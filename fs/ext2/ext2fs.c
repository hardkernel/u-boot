/*
 * (C) Copyright 2004
 *  esd gmbh <www.esd-electronics.com>
 *  Reinhard Arlt <reinhard.arlt@esd-electronics.com>
 *
 *  based on code from grub2 fs/ext2.c and fs/fshelp.c by
 *
 *  GRUB  --  GRand Unified Bootloader
 *  Copyright (C) 2003, 2004  Free Software Foundation, Inc.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <common.h>

#if defined(CONFIG_CMD_EXT2)
#include <ext2fs.h>
#include <malloc.h>
#include <asm/byteorder.h>
#include <part.h>

#if defined(CONFIG_S5P6450)
DECLARE_GLOBAL_DATA_PTR;
#endif

extern int ext2fs_devread (int sector, int byte_offset, int byte_len,
			   char *buf);

/* Magic value used to identify an ext2 filesystem.  */
#define	EXT2_MAGIC		0xEF53
/* Amount of indirect blocks in an inode.  */
#define INDIRECT_BLOCKS		12
/* Maximum lenght of a pathname.  */
#define EXT2_PATH_MAX		4096
/* Maximum nesting of symlinks, used to prevent a loop.  */
#define	EXT2_MAX_SYMLINKCNT	8

/* Filetype used in directory entry.  */
#define	FILETYPE_UNKNOWN	0
#define	FILETYPE_REG		1
#define	FILETYPE_DIRECTORY	2
#define	FILETYPE_SYMLINK	7

/* Filetype information as used in inodes.  */
#define FILETYPE_INO_MASK	0170000
#define FILETYPE_INO_REG	0100000
#define FILETYPE_INO_DIRECTORY	0040000
#define FILETYPE_INO_SYMLINK	0120000

/* Bits used as offset in sector */
#define DISK_SECTOR_BITS        9

/* Log2 size of ext2 block in 512 blocks.  */
#define LOG2_EXT2_BLOCK_SIZE(data) (__le32_to_cpu (data->sblock.log2_block_size) + 1)

/* Log2 size of ext2 block in bytes.  */
#define LOG2_BLOCK_SIZE(data)	   (__le32_to_cpu (data->sblock.log2_block_size) + 10)

/* The size of an ext2 block in bytes.  */
#define EXT2_BLOCK_SIZE(data)	   (1 << LOG2_BLOCK_SIZE(data))

/* The ext2 superblock.  */
struct ext2_sblock {
	uint32_t total_inodes;
	uint32_t total_blocks;
	uint32_t reserved_blocks;
	uint32_t free_blocks;
	uint32_t free_inodes;
	uint32_t first_data_block;
	uint32_t log2_block_size;
	uint32_t log2_fragment_size;
	uint32_t blocks_per_group;
	uint32_t fragments_per_group;
	uint32_t inodes_per_group;
	uint32_t mtime;
	uint32_t utime;
	uint16_t mnt_count;
	uint16_t max_mnt_count;
	uint16_t magic;
	uint16_t fs_state;
	uint16_t error_handling;
	uint16_t minor_revision_level;
	uint32_t lastcheck;
	uint32_t checkinterval;
	uint32_t creator_os;
	uint32_t revision_level;
	uint16_t uid_reserved;
	uint16_t gid_reserved;
	uint32_t first_inode;
	uint16_t inode_size;
	uint16_t block_group_number;
	uint32_t feature_compatibility;
	uint32_t feature_incompat;
	uint32_t feature_ro_compat;
	uint32_t unique_id[4];
	char volume_name[16];
	char last_mounted_on[64];
	uint32_t compression_info;
};

/* The ext2 blockgroup.  */
struct ext2_block_group {
	uint32_t block_id;
	uint32_t inode_id;
	uint32_t inode_table_id;
	uint16_t free_blocks;
	uint16_t free_inodes;
	uint16_t pad;
	uint32_t reserved[3];
};

/* The ext2 inode.  */
struct ext2_inode {
	uint16_t mode;
	uint16_t uid;
	uint32_t size;
	uint32_t atime;
	uint32_t ctime;
	uint32_t mtime;
	uint32_t dtime;
	uint16_t gid;
	uint16_t nlinks;
	uint32_t blockcnt;	/* Blocks of 512 bytes!! */
	uint32_t flags;
	uint32_t osd1;
	union {
		struct datablocks {
			uint32_t dir_blocks[INDIRECT_BLOCKS];
			uint32_t indir_block;
			uint32_t double_indir_block;
			uint32_t tripple_indir_block;
		} blocks;
		char symlink[60];
	} b;
	uint32_t version;
	uint32_t acl;
	uint32_t dir_acl;
	uint32_t fragment_addr;
	uint32_t osd2[3];
};

/* The header of an ext2 directory entry.  */
struct ext2_dirent {
	uint32_t inode;
	uint16_t direntlen;
	uint8_t namelen;
	uint8_t filetype;
};

struct ext2fs_node {
	struct ext2_data *data;
	struct ext2_inode inode;
	int ino;
	int inode_read;
};

/* Information about a "mounted" ext2 filesystem.  */
struct ext2_data {
	struct ext2_sblock sblock;
	struct ext2_inode *inode;
	struct ext2fs_node diropen;
};


typedef struct ext2fs_node *ext2fs_node_t;

struct ext2_data *ext2fs_root = NULL;
ext2fs_node_t ext2fs_file = NULL;
int symlinknest = 0;
uint32_t *indir1_block = NULL;
int indir1_size = 0;
int indir1_blkno = -1;
uint32_t *indir2_block = NULL;
int indir2_size = 0;
int indir2_blkno = -1;


static int ext2fs_blockgroup
	(struct ext2_data *data, int group, struct ext2_block_group *blkgrp) {
#ifdef DEBUG
	printf ("ext2fs read blockgroup\n");
#endif
	return (ext2fs_devread
		(((__le32_to_cpu (data->sblock.first_data_block) +
		   1) << LOG2_EXT2_BLOCK_SIZE (data)),
		 group * sizeof (struct ext2_block_group),
		 sizeof (struct ext2_block_group), (char *) blkgrp));
}


static int ext2fs_read_inode
	(struct ext2_data *data, int ino, struct ext2_inode *inode) {
	struct ext2_block_group blkgrp;
	struct ext2_sblock *sblock = &data->sblock;
	int inodes_per_block;
	int status;

	unsigned int blkno;
	unsigned int blkoff;

	/* It is easier to calculate if the first inode is 0.  */
	ino--;
#ifdef DEBUG
	printf ("ext2fs read inode %d\n", ino);
#endif
	status = ext2fs_blockgroup (data,
				    ino /
				    __le32_to_cpu (sblock->inodes_per_group),
				    &blkgrp);
	if (status == 0) {
		return (0);
	}
	inodes_per_block = EXT2_BLOCK_SIZE (data) / 128;
	blkno = (ino % __le32_to_cpu (sblock->inodes_per_group)) /
		inodes_per_block;
	blkoff = (ino % __le32_to_cpu (sblock->inodes_per_group)) %
		inodes_per_block;
#ifdef DEBUG
	printf ("ext2fs read inode blkno %d blkoff %d\n", blkno, blkoff);
#endif
	/* Read the inode.  */
	status = ext2fs_devread (((__le32_to_cpu (blkgrp.inode_table_id) +
				   blkno) << LOG2_EXT2_BLOCK_SIZE (data)),
				 sizeof (struct ext2_inode) * blkoff,
				 sizeof (struct ext2_inode), (char *) inode);
	if (status == 0) {
		return (0);
	}

	return (1);
}


void ext2fs_free_node (ext2fs_node_t node, ext2fs_node_t currroot) {
	if ((node != &ext2fs_root->diropen) && (node != currroot)) {
		free (node);
	}
}


static int ext2fs_read_block (ext2fs_node_t node, int fileblock) {
	struct ext2_data *data = node->data;
	struct ext2_inode *inode = &node->inode;
	int blknr;
	int blksz = EXT2_BLOCK_SIZE (data);
	int log2_blksz = LOG2_EXT2_BLOCK_SIZE (data);
	int status;

	/* Direct blocks.  */
	if (fileblock < INDIRECT_BLOCKS) {
		blknr = __le32_to_cpu (inode->b.blocks.dir_blocks[fileblock]);
	}
	/* Indirect.  */
	else if (fileblock < (INDIRECT_BLOCKS + (blksz / 4))) {
		if (indir1_block == NULL) {
			indir1_block = (uint32_t *) malloc (blksz);
			if (indir1_block == NULL) {
				printf ("** ext2fs read block (indir 1) malloc failed. **\n");
				return (-1);
			}
			indir1_size = blksz;
			indir1_blkno = -1;
		}
		if (blksz != indir1_size) {
			free (indir1_block);
			indir1_block = NULL;
			indir1_size = 0;
			indir1_blkno = -1;
			indir1_block = (uint32_t *) malloc (blksz);
			if (indir1_block == NULL) {
				printf ("** ext2fs read block (indir 1) malloc failed. **\n");
				return (-1);
			}
			indir1_size = blksz;
		}
		if ((__le32_to_cpu (inode->b.blocks.indir_block) <<
		     log2_blksz) != indir1_blkno) {
			status = ext2fs_devread (__le32_to_cpu(inode->b.blocks.indir_block) << log2_blksz,
						 0, blksz,
						 (char *) indir1_block);
			if (status == 0) {
				printf ("** ext2fs read block (indir 1) failed. **\n");
				return (0);
			}
			indir1_blkno =
				__le32_to_cpu (inode->b.blocks.
					       indir_block) << log2_blksz;
		}
		blknr = __le32_to_cpu (indir1_block
				       [fileblock - INDIRECT_BLOCKS]);
	}
	/* Double indirect.  */
	else if (fileblock <
		 (INDIRECT_BLOCKS + (blksz / 4 * (blksz / 4 + 1)))) {
		unsigned int perblock = blksz / 4;
		unsigned int rblock = fileblock - (INDIRECT_BLOCKS
						   + blksz / 4);

		if (indir1_block == NULL) {
			indir1_block = (uint32_t *) malloc (blksz);
			if (indir1_block == NULL) {
				printf ("** ext2fs read block (indir 2 1) malloc failed. **\n");
				return (-1);
			}
			indir1_size = blksz;
			indir1_blkno = -1;
		}
		if (blksz != indir1_size) {
			free (indir1_block);
			indir1_block = NULL;
			indir1_size = 0;
			indir1_blkno = -1;
			indir1_block = (uint32_t *) malloc (blksz);
			if (indir1_block == NULL) {
				printf ("** ext2fs read block (indir 2 1) malloc failed. **\n");
				return (-1);
			}
			indir1_size = blksz;
		}
		if ((__le32_to_cpu (inode->b.blocks.double_indir_block) <<
		     log2_blksz) != indir1_blkno) {
			status = ext2fs_devread (__le32_to_cpu(inode->b.blocks.double_indir_block) << log2_blksz,
						0, blksz,
						(char *) indir1_block);
			if (status == 0) {
				printf ("** ext2fs read block (indir 2 1) failed. **\n");
				return (-1);
			}
			indir1_blkno =
				__le32_to_cpu (inode->b.blocks.double_indir_block) << log2_blksz;
		}

		if (indir2_block == NULL) {
			indir2_block = (uint32_t *) malloc (blksz);
			if (indir2_block == NULL) {
				printf ("** ext2fs read block (indir 2 2) malloc failed. **\n");
				return (-1);
			}
			indir2_size = blksz;
			indir2_blkno = -1;
		}
		if (blksz != indir2_size) {
			free (indir2_block);
			indir2_block = NULL;
			indir2_size = 0;
			indir2_blkno = -1;
			indir2_block = (uint32_t *) malloc (blksz);
			if (indir2_block == NULL) {
				printf ("** ext2fs read block (indir 2 2) malloc failed. **\n");
				return (-1);
			}
			indir2_size = blksz;
		}
		if ((__le32_to_cpu (indir1_block[rblock / perblock]) <<
		     log2_blksz) != indir1_blkno) {
			status = ext2fs_devread (__le32_to_cpu(indir1_block[rblock / perblock]) << log2_blksz,
						 0, blksz,
						 (char *) indir2_block);
			if (status == 0) {
				printf ("** ext2fs read block (indir 2 2) failed. **\n");
				return (-1);
			}
			indir2_blkno =
				__le32_to_cpu (indir1_block[rblock / perblock]) << log2_blksz;
		}
		blknr = __le32_to_cpu (indir2_block[rblock % perblock]);
	}
	/* Tripple indirect.  */
	else {
		printf ("** ext2fs doesn't support tripple indirect blocks. **\n");
		return (-1);
	}
#ifdef DEBUG
	printf ("ext2fs_read_block %08x\n", blknr);
#endif
	return (blknr);
}


int ext2fs_read_file
	(ext2fs_node_t node, int pos, unsigned int len, char *buf) {
	int i;
	int blockcnt;
	int log2blocksize = LOG2_EXT2_BLOCK_SIZE (node->data);
	int blocksize = 1 << (log2blocksize + DISK_SECTOR_BITS);
	unsigned int filesize = __le32_to_cpu(node->inode.size);

	/* Adjust len so it we can't read past the end of the file.  */
	if (len > filesize) {
		len = filesize;
	}
	blockcnt = ((len + pos) + blocksize - 1) / blocksize;

	for (i = pos / blocksize; i < blockcnt; i++) {
		int blknr;
		int blockoff = pos % blocksize;
		int blockend = blocksize;

		int skipfirst = 0;

		blknr = ext2fs_read_block (node, i);
		if (blknr < 0) {
			return (-1);
		}
		blknr = blknr << log2blocksize;

		/* Last block.  */
		if (i == blockcnt - 1) {
			blockend = (len + pos) % blocksize;

			/* The last portion is exactly blocksize.  */
			if (!blockend) {
				blockend = blocksize;
			}
		}

		/* First block.  */
		if (i == pos / blocksize) {
			skipfirst = blockoff;
			blockend -= skipfirst;
		}

		/* If the block number is 0 this block is not stored on disk but
		   is zero filled instead.  */
		if (blknr) {
			int status;

			status = ext2fs_devread (blknr, skipfirst, blockend, buf);
			if (status == 0) {
				return (-1);
			}
		} else {
			memset (buf, 0, blocksize - skipfirst);
		}
		buf += blocksize - skipfirst;
	}
	return (len);
}


static int ext2fs_iterate_dir (ext2fs_node_t dir, char *name, ext2fs_node_t * fnode, int *ftype)
{
	unsigned int fpos = 0;
	int status;
	struct ext2fs_node *diro = (struct ext2fs_node *) dir;

#ifdef DEBUG
	if (name != NULL)
		printf ("Iterate dir %s\n", name);
#endif /* of DEBUG */
	if (!diro->inode_read) {
		status = ext2fs_read_inode (diro->data, diro->ino,
					    &diro->inode);
		if (status == 0) {
			return (0);
		}
	}
	/* Search the file.  */
	while (fpos < __le32_to_cpu (diro->inode.size)) {
		struct ext2_dirent dirent;

		status = ext2fs_read_file (diro, fpos,
					   sizeof (struct ext2_dirent),
					   (char *) &dirent);
		if (status < 1) {
			return (0);
		}
		if (dirent.namelen != 0) {
			char filename[dirent.namelen + 1];
			ext2fs_node_t fdiro;
			int type = FILETYPE_UNKNOWN;

			status = ext2fs_read_file (diro,
						   fpos + sizeof (struct ext2_dirent),
						   dirent.namelen, filename);
			if (status < 1) {
				return (0);
			}
			fdiro = malloc (sizeof (struct ext2fs_node));
			if (!fdiro) {
				return (0);
			}

			fdiro->data = diro->data;
			fdiro->ino = __le32_to_cpu (dirent.inode);

			filename[dirent.namelen] = '\0';

			if (dirent.filetype != FILETYPE_UNKNOWN) {
				fdiro->inode_read = 0;

				if (dirent.filetype == FILETYPE_DIRECTORY) {
					type = FILETYPE_DIRECTORY;
				} else if (dirent.filetype ==
					   FILETYPE_SYMLINK) {
					type = FILETYPE_SYMLINK;
				} else if (dirent.filetype == FILETYPE_REG) {
					type = FILETYPE_REG;
				}
			} else {
				/* The filetype can not be read from the dirent, get it from inode */

				status = ext2fs_read_inode (diro->data,
							    __le32_to_cpu(dirent.inode),
							    &fdiro->inode);
				if (status == 0) {
					free (fdiro);
					return (0);
				}
				fdiro->inode_read = 1;

				if ((__le16_to_cpu (fdiro->inode.mode) &
				     FILETYPE_INO_MASK) ==
				    FILETYPE_INO_DIRECTORY) {
					type = FILETYPE_DIRECTORY;
				} else if ((__le16_to_cpu (fdiro->inode.mode)
					    & FILETYPE_INO_MASK) ==
					   FILETYPE_INO_SYMLINK) {
					type = FILETYPE_SYMLINK;
				} else if ((__le16_to_cpu (fdiro->inode.mode)
					    & FILETYPE_INO_MASK) ==
					   FILETYPE_INO_REG) {
					type = FILETYPE_REG;
				}
			}
#ifdef DEBUG
			printf ("iterate >%s<\n", filename);
#endif /* of DEBUG */
			if ((name != NULL) && (fnode != NULL)
			    && (ftype != NULL)) {
				if (strcmp (filename, name) == 0) {
					*ftype = type;
					*fnode = fdiro;
					return (1);
				}
			} else {
				if (fdiro->inode_read == 0) {
					status = ext2fs_read_inode (diro->data,
							    __le32_to_cpu (dirent.inode),
							    &fdiro->inode);
					if (status == 0) {
						free (fdiro);
						return (0);
					}
					fdiro->inode_read = 1;
				}
				switch (type) {
				case FILETYPE_DIRECTORY:
					printf ("<DIR> ");
					break;
				case FILETYPE_SYMLINK:
					printf ("<SYM> ");
					break;
				case FILETYPE_REG:
					printf ("      ");
					break;
				default:
					printf ("< ? > ");
					break;
				}
				printf ("%10d %s\n",
					__le32_to_cpu (fdiro->inode.size),
					filename);
			}
			free (fdiro);
		}
		fpos += __le16_to_cpu (dirent.direntlen);
	}
	return (0);
}


static char *ext2fs_read_symlink (ext2fs_node_t node) {
	char *symlink;
	struct ext2fs_node *diro = node;
	int status;

	if (!diro->inode_read) {
		status = ext2fs_read_inode (diro->data, diro->ino,
					    &diro->inode);
		if (status == 0) {
			return (0);
		}
	}
	symlink = malloc (__le32_to_cpu (diro->inode.size) + 1);
	if (!symlink) {
		return (0);
	}
	/* If the filesize of the symlink is bigger than
	   60 the symlink is stored in a separate block,
	   otherwise it is stored in the inode.  */
	if (__le32_to_cpu (diro->inode.size) <= 60) {
		strncpy (symlink, diro->inode.b.symlink,
			 __le32_to_cpu (diro->inode.size));
	} else {
		status = ext2fs_read_file (diro, 0,
					   __le32_to_cpu (diro->inode.size),
					   symlink);
		if (status == 0) {
			free (symlink);
			return (0);
		}
	}
	symlink[__le32_to_cpu (diro->inode.size)] = '\0';
	return (symlink);
}


int ext2fs_find_file1
	(const char *currpath,
	 ext2fs_node_t currroot, ext2fs_node_t * currfound, int *foundtype) {
	char fpath[strlen (currpath) + 1];
	char *name = fpath;
	char *next;
	int status;
	int type = FILETYPE_DIRECTORY;
	ext2fs_node_t currnode = currroot;
	ext2fs_node_t oldnode = currroot;

	strncpy (fpath, currpath, strlen (currpath) + 1);

	/* Remove all leading slashes.  */
	while (*name == '/') {
		name++;
	}
	if (!*name) {
		*currfound = currnode;
		return (1);
	}

	for (;;) {
		int found;

		/* Extract the actual part from the pathname.  */
		next = strchr (name, '/');
		if (next) {
			/* Remove all leading slashes.  */
			while (*next == '/') {
				*(next++) = '\0';
			}
		}

		/* At this point it is expected that the current node is a directory, check if this is true.  */
		if (type != FILETYPE_DIRECTORY) {
			ext2fs_free_node (currnode, currroot);
			return (0);
		}

		oldnode = currnode;

		/* Iterate over the directory.  */
		found = ext2fs_iterate_dir (currnode, name, &currnode, &type);
		if (found == 0) {
			return (0);
		}
		if (found == -1) {
			break;
		}

		/* Read in the symlink and follow it.  */
		if (type == FILETYPE_SYMLINK) {
			char *symlink;

			/* Test if the symlink does not loop.  */
			if (++symlinknest == 8) {
				ext2fs_free_node (currnode, currroot);
				ext2fs_free_node (oldnode, currroot);
				return (0);
			}

			symlink = ext2fs_read_symlink (currnode);
			ext2fs_free_node (currnode, currroot);

			if (!symlink) {
				ext2fs_free_node (oldnode, currroot);
				return (0);
			}
#ifdef DEBUG
			printf ("Got symlink >%s<\n", symlink);
#endif /* of DEBUG */
			/* The symlink is an absolute path, go back to the root inode.  */
			if (symlink[0] == '/') {
				ext2fs_free_node (oldnode, currroot);
				oldnode = &ext2fs_root->diropen;
			}

			/* Lookup the node the symlink points to.  */
			status = ext2fs_find_file1 (symlink, oldnode,
						    &currnode, &type);

			free (symlink);

			if (status == 0) {
				ext2fs_free_node (oldnode, currroot);
				return (0);
			}
		}

		ext2fs_free_node (oldnode, currroot);

		/* Found the node!  */
		if (!next || *next == '\0') {
			*currfound = currnode;
			*foundtype = type;
			return (1);
		}
		name = next;
	}
	return (-1);
}


int ext2fs_find_file
	(const char *path,
	 ext2fs_node_t rootnode, ext2fs_node_t * foundnode, int expecttype) {
	int status;
	int foundtype = FILETYPE_DIRECTORY;


	symlinknest = 0;
	if (!path) {
		return (0);
	}

	status = ext2fs_find_file1 (path, rootnode, foundnode, &foundtype);
	if (status == 0) {
		return (0);
	}
	/* Check if the node that was found was of the expected type.  */
	if ((expecttype == FILETYPE_REG) && (foundtype != expecttype)) {
		return (0);
	} else if ((expecttype == FILETYPE_DIRECTORY)
		   && (foundtype != expecttype)) {
		return (0);
	}
	return (1);
}


int ext2fs_ls (char *dirname) {
	ext2fs_node_t dirnode;
	int status;

	if (ext2fs_root == NULL) {
		return (0);
	}

	status = ext2fs_find_file (dirname, &ext2fs_root->diropen, &dirnode,
				   FILETYPE_DIRECTORY);
	if (status != 1) {
		printf ("** Can not find directory. **\n");
		return (1);
	}
	ext2fs_iterate_dir (dirnode, NULL, NULL, NULL);
	ext2fs_free_node (dirnode, &ext2fs_root->diropen);
	return (0);
}


int ext2fs_open (char *filename) {
	ext2fs_node_t fdiro = NULL;
	int status;
	int len;

	if (ext2fs_root == NULL) {
		return (-1);
	}
	ext2fs_file = NULL;
	status = ext2fs_find_file (filename, &ext2fs_root->diropen, &fdiro,
				   FILETYPE_REG);
	if (status == 0) {
		goto fail;
	}
	if (!fdiro->inode_read) {
		status = ext2fs_read_inode (fdiro->data, fdiro->ino,
					    &fdiro->inode);
		if (status == 0) {
			goto fail;
		}
	}
	len = __le32_to_cpu (fdiro->inode.size);
	ext2fs_file = fdiro;
	return (len);

fail:
	ext2fs_free_node (fdiro, &ext2fs_root->diropen);
	return (-1);
}


int ext2fs_close (void
	) {
	if ((ext2fs_file != NULL) && (ext2fs_root != NULL)) {
		ext2fs_free_node (ext2fs_file, &ext2fs_root->diropen);
		ext2fs_file = NULL;
	}
	if (ext2fs_root != NULL) {
		free (ext2fs_root);
		ext2fs_root = NULL;
	}
	if (indir1_block != NULL) {
		free (indir1_block);
		indir1_block = NULL;
		indir1_size = 0;
		indir1_blkno = -1;
	}
	if (indir2_block != NULL) {
		free (indir2_block);
		indir2_block = NULL;
		indir2_size = 0;
		indir2_blkno = -1;
	}
	return (0);
}


int ext2fs_read (char *buf, unsigned len) {
	int status;

	if (ext2fs_root == NULL) {
		return (0);
	}

	if (ext2fs_file == NULL) {
		return (0);
	}

	status = ext2fs_read_file (ext2fs_file, 0, len, buf);
	return (status);
}


int ext2fs_mount (unsigned part_length) {
	struct ext2_data *data;
	int status;

	data = malloc (sizeof (struct ext2_data));
	if (!data) {
		return (0);
	}
	/* Read the superblock.  */
	status = ext2fs_devread (1 * 2, 0, sizeof (struct ext2_sblock),
				 (char *) &data->sblock);
	if (status == 0) {
		goto fail;
	}
	/* Make sure this is an ext2 filesystem.  */
	if (__le16_to_cpu (data->sblock.magic) != EXT2_MAGIC) {
		goto fail;
	}
	data->diropen.data = data;
	data->diropen.ino = 2;
	data->diropen.inode_read = 1;
	data->inode = &data->diropen.inode;

	status = ext2fs_read_inode (data, 2, data->inode);
	if (status == 0) {
		goto fail;
	}

	ext2fs_root = data;

	return (1);

fail:
	printf ("Failed to mount ext2 filesystem...\n");
	free (data);
	ext2fs_root = NULL;
	return (0);
}

/*
 * Format device by ext2.
 */
struct super_block {
	__u8 total_inodes[4];
	__u8 total_blocks[4];
	__u8 reserved_blocks[4];
	__u8 free_blocks[4];
	__u8 free_inodes[4];
	__u8 first_data_block[4];
	__u8 log2_block_size[4];
	__u8 log2_fragment_size[4];
	__u8 blocks_per_group[4];
	__u8 fragments_per_group[4];
	__u8 inodes_per_group[4];
	__u8 mtime[4];
	__u8 wtime[4];
	__u8 mnt_count[2];
	__u8 max_mnt_count[2];
	__u8 magic[2];
	__u8 fs_state[2];
	__u8 error_handling[2];
	__u8 minor_revision_level[2];
	__u8 lastcheck[4];
	__u8 checkinterval[4];
	__u8 creator_os[4];
	__u8 revision_level[4];
	__u8 uid_reserved[2];
	__u8 gid_reserved[2];
	__u8 first_inode[4];
	__u8 inode_size[2];
	__u8 block_group_number[2];
	__u8 feature_compatibility[4];
	__u8 feature_incompat[4];
	__u8 feature_ro_compat[4];
	__u8 unique_id[16];
	__u8 volume_name[16];
	__u8 last_mounted_on[64];
	__u8 compression_info[4];
	__u8 prealloc_blk_cnt;
	__u8 prealloc_dir_cnt;
	__u8 reserved_gtd_blk[2];
	__u8 journal_uuid[16];
	__u8 journal_inode_num[4];
	__u8 journal_device[4];
	__u8 orphan_inode_list[4];
	__u8 hash_seed[16];
	__u8 hash_version;
	__u8 journal_backup_type;
	__u8 gtd_size[2];
	__u8 mount_option[4];
	__u8 first_meta_blk[4];
	__u8 mkfs_time[4];
	__u8 journal_blocks[68];
	__u8 blocks_cnt_hi[4];
	__u8 reserved_blk_cnt_hi[4];
	__u8 free_blocks_hi[4];
	__u8 min_extra_isize[2];
	__u8 want_extra_isize[2];
	__u8 flags[4];
	__u8 raid_stride[2];
	__u8 mmp_interval[2];
	__u8 mmp_block[8];
	__u8 raid_stripe_width[4];
};

struct group_desc_table {
	__u8 start_blkbit_addr[4];
	__u8 start_indbit_addr[4];
	__u8 start_inode_table[4];
	__u8 free_blk_cnt[2];
	__u8 free_inode_cnt[2];
	__u8 directories_cnt[2];
	__u8 padding[2];
	__u8 reserved[12];
};

struct inode_desc {
	__u8 file_mode[2];
	__u8 uid[2];
	__u8 size_byte[4];
	__u8 access_time[4];
	__u8 change_time[4];
	__u8 modify_time[4];
	__u8 deletion_time[4];
	__u8 group_id[2];
	__u8 link_count[2];
	__u8 block_count[4];
	__u8 flags[4];
	__u8 os_description1[4];
	__u8 block_pointers[60];
	__u8 generation_num[4];
	__u8 file_acl[4];
	__u8 directory_acl[4];
	__u8 address_fragmentation[4];
	__u8 os_description2[12];
};

#define mk1(p, x)	\
 	(p) = (__u8)(x)

#define mk2(p, x)		\
	(p)[0] = (__u8)(x),	\
	(p)[1] = (__u8)((x) >> 010)

#define mk4(p, x)			\
	(p)[0] = (__u8)(x),		\
	(p)[1] = (__u8)((x) >> 010),	\
	(p)[2] = (__u8)((x) >> 020),	\
	(p)[3] = (__u8)((x) >> 030)

#define SEC_PER_BLOCK	8

unsigned int get_random_val(unsigned int next)
{
	next = next * 1103515245 + 12345;
	return((unsigned)(next/65536) % 65536);
}

unsigned int default_journal_size(uint32_t block_cnt)
{
	if (block_cnt < 2048)
		return -1;
	if (block_cnt < 32768)
		return (1024);
	if (block_cnt < 256 * 1024)
		return (4096);
	if (block_cnt < 512 * 1024)
		return (8192);
	if (block_cnt < 1024 * 1024)
		return (16384);
	return (32768);
}


int ext2fs_format(block_dev_desc_t *dev_desc, int part_no, char set_journaling)
{
	
	unsigned char buffer[SECTOR_SIZE];
	disk_partition_t info;

	if (!dev_desc->block_read)
		return -1;

	/* check if we have a MBR (on floppies we have only a PBR) */
	if (dev_desc->block_read (dev_desc->dev, 0, 1, (ulong *) buffer) != 1) {
		printf ("** Can't read from device %d **\n", dev_desc->dev);
		return -1;
	}
	if (buffer[0x1fe] != 0x55 ||
		buffer[0x1fe + 1] != 0xaa) {
		printf("** MBR is broken **\n");
		/* no signature found */
		return -1;
	}
#if (defined(CONFIG_CMD_IDE) || \
     defined(CONFIG_CMD_SCSI) || \
     defined(CONFIG_CMD_USB) || \
     defined(CONFIG_MMC) || \
     defined(CONFIG_SYSTEMACE) )
	/* First we assume, there is a MBR */
	if (!get_partition_info (dev_desc, part_no, &info)) {
		printf ("** Partition%d is not ext2 file-system %d **\n",
				part_no, dev_desc->dev);
	}
#endif
	printf("Partition%d: Start Address(0x%x), Size(0x%x)\n", part_no, info.start, info.size);
	/* Write Super Block */
	int blk_group_num = info.size / 0x40000;
	if (info.size % 0x40000)
		blk_group_num += 1;
	
	int bgcnt;
	uint32_t start_block = 0;
	uint8_t *img; /* Super Block Image */
	uint32_t uuid[4];
	img = malloc(sizeof(__u8) * 4096);
	if (img == NULL) {
		printf("Can't make img buffer~~!!\n");
		return -1;
	}
	uint8_t *img2; /* Group Descriptor Table */
	img2 = malloc(sizeof(__u8) * 4096);
	if (img2 == NULL) {
		printf("Can't make img2 buffer~~!!\n");
		return -1;
	}
	uint8_t *reserve_img;
	reserve_img = malloc(sizeof(__u8) * 4096);
	if (reserve_img == NULL) {
		printf("Can't make reserve_img buffer~~!!\n");
		return -1;
	}

	uint8_t *img3; /* Block Bitmap */
	img3 = malloc(sizeof(__u8) * 4096);
	if (img3 == NULL) {
		printf("Can't make img3 buffer~~!!\n");
		return -1;
	}
	uint8_t *img4;
	img4 = malloc(sizeof(__u8) * 4096);
	if (img4 == NULL) {
		printf("Can't make img4 buffer~~!!\n");
		return -1;
	}
	uint8_t *zerobuf = malloc(sizeof(__u8) * 4096 * 80);
	if (zerobuf == NULL) {
		printf("Can't make zero buffer~~!!\n");
		return -1;
	}

	uint8_t *img5;
	img5 = malloc(sizeof(__u8) * 2048);
	if (img5 == NULL) {
		printf("Can't make img5 buffer~~!!\n");
		return -1;
	}
	uint8_t *rootdata = malloc(sizeof(__u8) * 4096);
	if (rootdata == NULL) {
		printf("Can't make rootdata buffer~~!!\n");
		return -1;
	}
	uint8_t *inode_data = malloc(sizeof(__u8) * 4096);
	if (inode_data == NULL) {
		printf("Can't make inodedata buffer~~!!\n");
		return -1;
	}

	uint8_t *inode_data2 = malloc(sizeof(__u8) * 4096);
	if (inode_data2 == NULL) {
		printf("Can't make inodedata2 buffer~~!!\n");
		return -1;
	}

	printf("Start ext2format...\n");
	for (bgcnt = 0; bgcnt < blk_group_num; bgcnt++) {
		printf("Wirte %d/%dblock-group\n",bgcnt,  blk_group_num);
		int i = 0;
		int rsv_blk_cnt = 0;
		struct super_block *sblock;
		memset(img, 0x0, sizeof(__u8) * 4096);
		if (bgcnt == 0)
			sblock = (struct super_block *)(img + 1024);
		else
			sblock = (struct super_block *)img;

		uint32_t total_blocks = info.size / SEC_PER_BLOCK; /* 4KB block */
		mk4(sblock->total_blocks, total_blocks); /* block count */
		uint32_t total_inodes = (total_blocks / 0x20);
		if (total_blocks % 0x20) {
			total_inodes += 1;
			/* Fix Me... it's just temp code */
			/* Check... 'total_blocks % 0x20'*/
			if (total_blocks > 0x8000 && total_blocks < 0x10000) {
				total_inodes += 1;
			}
		}
		total_inodes *= 0x20;
			
		if (total_blocks > 0x3E800) /* if size > 1GB */
			total_inodes /= 2;
		
		uint32_t inodes_per_group = ((total_inodes -1) / blk_group_num) + 1;
		inodes_per_group = (inodes_per_group / 0x20) + 1;
		inodes_per_group *= 0x20;

		if (total_blocks > 0x8000)
			mk4(sblock->inodes_per_group, inodes_per_group); /* inode for group */
		else
			mk4(sblock->inodes_per_group, total_inodes); /* inode for group */
			
		uint32_t reserved_blocks = total_blocks * 5 / 100;
		mk4(sblock->reserved_blocks, reserved_blocks); /* reserved block count */
		mk4(sblock->first_data_block, 0); /* frist data block */
		mk4(sblock->log2_block_size, 2); /* log block size */
		mk4(sblock->log2_fragment_size, 2); /* log fragmentation size */
		/* 8(1bit) * 4096(1block:4K) */
		mk4(sblock->blocks_per_group, 0x8000); /* block per group */
		uint32_t blocks_per_group = 0x8000;
		mk4(sblock->fragments_per_group, 0x8000); /* fragmentation per group */
		mk4(sblock->mtime, 0); /* mtime */
		mk4(sblock->wtime, 0x33); /* wtime : 0x33 means nothing*/
		mk2(sblock->mnt_count, 0); /* mount count*/
		mk2(sblock->max_mnt_count, 0x20); /* max mount count */
		mk2(sblock->magic, EXT2_MAGIC); /* magic signature */
		mk2(sblock->fs_state, 1); /* state (1:valid, 2:error) */
		mk2(sblock->error_handling, 1); /* errors */
		mk2(sblock->minor_revision_level, 0); /* minor version */
		mk4(sblock->lastcheck, 0); /* last check time */
		mk4(sblock->checkinterval, 0xed4e00); /* check interval */
		mk4(sblock->creator_os, 0); /* creator os */
		mk4(sblock->revision_level, 1); /* major version */
		mk2(sblock->uid_reserved, 0); /* UID that can use reserved blocks */
		mk2(sblock->gid_reserved, 0); /* GID that can use reserved blocks */
		mk4(sblock->first_inode, 0xb); /* first non-reserved inode */
		mk2(sblock->inode_size, 0x80); /* inode structure size */
		mk2(sblock->block_group_number, 0); /* block group num */
		uint32_t feature_compatibility = 0x30; /* default */
		if (set_journaling) {
			feature_compatibility += 0x4; /* 0x4 means HAS_JOURNAL */
		}
		mk4(sblock->feature_compatibility, feature_compatibility); /* compatible feature */
		mk4(sblock->feature_incompat, 0x2); /* incompatible feature */
		mk4(sblock->feature_ro_compat, 0x3); /* read-only feature */
		if (bgcnt == 0) {
			/* Set Unique ID */
			uuid[0] = get_random_val(get_timer(0));
			uuid[0] |= (get_random_val(get_timer(0)) << 16);
			uuid[1] = get_random_val(get_timer(0));
			uuid[1] |= (get_random_val(get_timer(0)) << 16);
			uuid[2] = get_random_val(get_timer(0));
			uuid[2] |= (get_random_val(get_timer(0)) << 16);
			uuid[3] = get_random_val(get_timer(0));
			uuid[3] |= (get_random_val(get_timer(0)) << 16);
		}
		mk4(sblock->unique_id, uuid[0]); /* UUID filesystem ID */
		mk4(sblock->unique_id + 4, uuid[1]); /* UUID filesystem ID */
		mk4(sblock->unique_id + 8, uuid[2]); /* UUID filesystem ID */
		mk4(sblock->unique_id + 12, uuid[3]); /* UUID filesystem ID */
		mk4(sblock->compression_info, 0); /* algorithm usage bitmap */
	
		uint32_t reserved_gdt_blk = total_blocks >> 12;
		mk2(sblock->reserved_gtd_blk, reserved_gdt_blk); /* reserved gtd blocks */
		if (set_journaling) {
			/* 8th inode is reserved for journaling */
			mk4(sblock->journal_inode_num, 8);
			sblock->journal_backup_type = 1;
		}
		mk2(sblock->hash_seed, get_random_val(get_timer(0))); /* Hash Seed */
		mk2(sblock->hash_seed + 2, get_random_val(get_timer(0)));
		mk2(sblock->hash_seed + 4, get_random_val(get_timer(0)));
		mk2(sblock->hash_seed + 6, get_random_val(get_timer(0)));
		mk2(sblock->hash_seed + 8, get_random_val(get_timer(0)));
		mk2(sblock->hash_seed + 10, get_random_val(get_timer(0)));
		mk2(sblock->hash_seed + 12, get_random_val(get_timer(0)));
		mk2(sblock->hash_seed + 14, get_random_val(get_timer(0)));
		sblock->hash_version = 0x2;
		mk4(sblock->mkfs_time, 0x33); /* 0x33 means nothing */

		/* Write Group Descriptor Table */
		struct group_desc_table *desc_table;
		memset(img2, 0x0, sizeof(__u8) * 4096);
	
		int offset = 0;
		uint32_t free_blk_cnt = 0;
		uint32_t free_inode_cnt = 0;
		uint32_t free_blocks = 0;
		uint32_t free_inodes = 0;
		uint32_t start_blkbit_addr = 0;
		uint32_t start_indbit_addr = 0;
		uint32_t start_indtable_addr = 0;
	
		uint32_t current_free_blk = 0;
		uint32_t reserved_blk_cnt = 0;
		uint32_t normal_used_blk = 0;
		uint32_t default_used_blk = 0;
		uint32_t first_inode_table_addr = 0;
		uint32_t current_blkbit_addr = 0;
		uint32_t current_indbit_addr = 0;
		uint32_t current_indtable_addr= 0;

		char have_rev_gdt = 0;
		int remain_blocks = 0;
		int jnl_blocks = 0;
		int32_t jnldata_start_addr = 0;
		/* second group inode table offset */
		int32_t seblk_offset = 0;
		/* Starting block address of block bitmap */
		for (i = 0; i < blk_group_num; i++) {
			char is_revgdt = 0;
			/* 0 group description table need to change for default
			 * directory.
			 */
			start_blkbit_addr = i * blocks_per_group;
			start_indbit_addr = 1 + i * blocks_per_group;
			start_indtable_addr = 2 + i * blocks_per_group;
			desc_table = (struct group_desc_table *)(img2 + offset);	
			
			/* last block is not full size */
			if (i == blk_group_num - 1) {
				//uint32_t remain_blocks = total_blocks -
				//			(blocks_per_group * i);
				uint32_t remain_blocks = total_blocks % 0x8000;
				free_blk_cnt = remain_blocks - 4 -
					(inodes_per_group * 128 / 4096) + 2;
				free_inode_cnt = inodes_per_group;
			} else {
				/* 
				 * 0x8000 : total blocks per group
				 * 4 : super block(1), group descriptor table(1),
				 *     block bitmap(1), inode bitmap(1)
				 * (inodes_per_group * 128 / 4096) : inode table
				 * 2 : ?? (block start from 0??)
				 *     reserved block include superblock&gdt
				 */
				free_blk_cnt = 0x8000 - 4 - (inodes_per_group * 128 / 4096) + 2;
				free_inode_cnt = inodes_per_group;
			}
	
			if (i == 0) {
				is_revgdt = 1;
				reserved_blk_cnt++;
				/* For default creation */
				free_blk_cnt -= 6;
				if (total_blocks > 0x8000) /* if size > 128MB */
					free_inode_cnt -= 0xb;
				else
					free_inode_cnt -= 0x2b;
				
				start_blkbit_addr += reserved_gdt_blk + 2;
				start_indbit_addr += reserved_gdt_blk + 2;
				start_indtable_addr += reserved_gdt_blk + 2;
				free_blk_cnt -= (reserved_gdt_blk + 2);

				first_inode_table_addr = start_indtable_addr;
			}

			/* delete journaling block from free blocks */
			if (set_journaling) {
				if (i == 0) {
					jnl_blocks = default_journal_size(total_blocks);
					/* 1024 means number of pointing by 1blcok (4096/4) */
					jnl_blocks += (jnl_blocks / 1024);
					if (jnl_blocks >= 4096) {
						/* 
						 * 2 blocks are needed to use double
						 * indirect pointer
						 */
						jnl_blocks += 2;
					}
					printf("Reserved blocks for jounaling : %d\n", jnl_blocks);
					if (free_blk_cnt >= jnl_blocks) {
						free_blk_cnt -= jnl_blocks;
					}
					else {
						remain_blocks = jnl_blocks -
							free_blk_cnt;
						free_blk_cnt = 0;
					}
				} else {
					
					if (remain_blocks > 0) {
						free_blk_cnt -= remain_blocks;
						remain_blocks = 0;
					}
				}
			}
	
			/* 
			 * Keep reserved region.???
			 * If card is higher than 16GB, below codes must be fixed. 
			 * Please excute mke2fs on linux and check messages 
			 * 'superblock backups stored on blocks:'. 
			 */
			if (i < 10) {
				if (i % 2) {
					is_revgdt  = 1;
					reserved_blk_cnt++;
					start_blkbit_addr += reserved_gdt_blk + 2;
					start_indbit_addr += reserved_gdt_blk + 2;
					start_indtable_addr += reserved_gdt_blk + 2;
					free_blk_cnt -= (reserved_gdt_blk + 2);
					rsv_blk_cnt++;
				}
			} else if (i > 20 && i < 30) {
				if (i == 25 || i == 27) {
					is_revgdt = 1;
					reserved_blk_cnt++;
					start_blkbit_addr += reserved_gdt_blk + 2;
					start_indbit_addr += reserved_gdt_blk + 2;
					start_indtable_addr += reserved_gdt_blk + 2;
					free_blk_cnt -= (reserved_gdt_blk + 2);
					rsv_blk_cnt++;
				}
			} else if (i > 40 && i < 50) {
				if (i == 49) {
					is_revgdt = 1;
					reserved_blk_cnt++;
					start_blkbit_addr += reserved_gdt_blk + 2;
					start_indbit_addr += reserved_gdt_blk + 2;
					start_indtable_addr += reserved_gdt_blk + 2;
					free_blk_cnt -= (reserved_gdt_blk + 2);
					rsv_blk_cnt++;
				}
			}
	
			free_blocks += free_blk_cnt;
			free_inodes += free_inode_cnt;
	
			mk4(desc_table->start_blkbit_addr, start_blkbit_addr);
			mk4(desc_table->start_indbit_addr, start_indbit_addr);
			mk4(desc_table->start_inode_table, start_indtable_addr);
			mk2(desc_table->free_blk_cnt, free_blk_cnt);
			
			if (i == 1) {
				seblk_offset = start_indtable_addr - 0x8000;
			}
			if (i == bgcnt) { //original code
			//if (i == 0) { //first block 
			//if (i == blk_group_num -1) { // last block
				current_free_blk = free_blk_cnt;
				current_blkbit_addr = start_blkbit_addr;
				current_indbit_addr = start_indbit_addr;
				current_indtable_addr = start_indtable_addr;
				if (is_revgdt)
					have_rev_gdt = 1;
				
			}
			mk2(desc_table->free_inode_cnt, free_inode_cnt);
			if (i == 0)
				mk2(desc_table->directories_cnt, 2);
			else
				mk2(desc_table->directories_cnt, 0);
			offset += sizeof(struct group_desc_table);
		}	

		if (set_journaling) {

			/* set journal blocks 
			 * journal data start address =
			 * next of first inode_table block
			 * + (size of inode table)
			 * + 6 (size of root & reserved data region)
			 */
			if (total_blocks > 0x8000) { /* if size > 128MB */
				jnldata_start_addr = first_inode_table_addr
						+ (inodes_per_group * 128 / 4096) + 6;
			}
			else {
				jnldata_start_addr = first_inode_table_addr
						+ (inodes_per_group * 128 / 4096) + 5;
			}

			mk4(sblock->journal_blocks, jnldata_start_addr);
			mk4(sblock->journal_blocks + 4, jnldata_start_addr + 1);
			mk4(sblock->journal_blocks + 8, jnldata_start_addr + 2);
			mk4(sblock->journal_blocks + 12, jnldata_start_addr + 3);
			mk4(sblock->journal_blocks + 16, jnldata_start_addr + 4);
			mk4(sblock->journal_blocks + 20, jnldata_start_addr + 5);
			mk4(sblock->journal_blocks + 24, jnldata_start_addr + 6);
			mk4(sblock->journal_blocks + 28, jnldata_start_addr + 7);
			mk4(sblock->journal_blocks + 32, jnldata_start_addr + 8);
			mk4(sblock->journal_blocks + 36, jnldata_start_addr + 9);
			mk4(sblock->journal_blocks + 40, jnldata_start_addr + 10);
			mk4(sblock->journal_blocks + 44, jnldata_start_addr + 11);
			mk4(sblock->journal_blocks + 48, jnldata_start_addr + 12);
			
			int default_jnl_blocks = default_journal_size(total_blocks);
			uint32_t temp_val;
			if (default_jnl_blocks == 1024)
				temp_val = 0x400000;
			else if (default_jnl_blocks == 4096)
				temp_val = 0x1000000;
			else if (default_jnl_blocks == 8192)
				temp_val = 0x2000000;
			else if (default_jnl_blocks == 16384)
				temp_val = 0x4000000;
			else if (default_jnl_blocks == 32768)
				temp_val = 0x8000000;
			mk4(sblock->journal_blocks + 64, temp_val);

			/* 400 : 0x400(1024) means amount of pointing by 1block
			 *       4096(1block) / 4 = 1024
			 */
			if (default_jnl_blocks != 1024)
				mk4(sblock->journal_blocks + 52, jnldata_start_addr + 0x400 + 13);
		}
		mk4(sblock->free_blocks, free_blocks); /* free block count */
		mk4(sblock->free_inodes, free_inodes); /* free inode count */
		free_inodes += 0x10;
		free_inodes &= 0xfffffff0;
		mk4(sblock->total_inodes, free_inodes); /* inode count */

		/* print value */
		/*
		printf("Print Super Blocks\n");
		for(i = 0;i < 4096; i++) {
			if(img[i] == 0)
				printf("00 ");
			else
				printf("%02x ", img[i]);
	
			if (!((i+1) % 4))
				printf("| ");
			if (!((i+1) % 16))
				printf("\n");
			if (!((i+1) % 512))
				printf("---------------------------------------------------%d\n", i+1);
		}
		*/

		/* Write super-block to mmc */
		start_block = info.start + (bgcnt * 0x8000 * 4096 / 512);
		printf("Start write addr : 0x%x\n",start_block);
		if (have_rev_gdt) {
			if (dev_desc->block_write(dev_desc->dev, start_block, 8, (ulong *)img) != 8) {
				printf("Can't write Superblock(%d)~~~!!!\n", bgcnt);
			}
		}

		/*	
		printf("\n\nPrint Group Descriptor Table\n");
		for(i = 0;i < 4096; i++) {
			if(img2[i] == 0)
				printf("00 ");
			else
				printf("%02x ", img2[i]);
			if (!((i+1) % 4))
				printf("| ");
			if (!((i+1) % 16))
				printf("\n");
			if (!((i+1) % 512))
				printf("---------------------------------------------------%d\n", i+1);
		}
		*/

		/* Write Group Descriptor Table */
		if (have_rev_gdt) {
			start_block += 8;
			if (dev_desc->block_write(dev_desc->dev, start_block, 8,
				(ulong *)img2) != 8) {
				printf("Can't write Descriptor Table(%d)~~~!!!\n", bgcnt);
			}
		}

		/* Write reserved region */
		if (bgcnt == 0) {
			memset(reserve_img, 0x0, sizeof(__u8) * 4096);

			int rev_cnt;
			for (rev_cnt = 2; rev_cnt <= reserved_gdt_blk +
				1; rev_cnt++) {
				start_block += 8;
				if (rsv_blk_cnt >= 1)
					mk4(reserve_img, 0x8000 + rev_cnt);
				if (rsv_blk_cnt >= 2)
					mk4(reserve_img + 4, 0x18000 + rev_cnt);
				if (rsv_blk_cnt >= 3)
					mk4(reserve_img + 8, 0x28000 + rev_cnt);
				if (rsv_blk_cnt >= 4)
					mk4(reserve_img + 12, 0x38000 + rev_cnt);
				if (rsv_blk_cnt >= 5)
					mk4(reserve_img + 16, 0x48000 + rev_cnt);
				if (rsv_blk_cnt >= 6)
					mk4(reserve_img + 20, 0xc8000 + rev_cnt);
				if (rsv_blk_cnt >= 7)
					mk4(reserve_img + 24, 0xd8000 + rev_cnt);
				if (rsv_blk_cnt >= 8)
					mk4(reserve_img + 28, 0x188000 + rev_cnt);
				if (dev_desc->block_write(dev_desc->dev, start_block, 8,
					(ulong *)reserve_img) != 8) {
					printf("Can't write reserve(%d)~~~!!!\n", bgcnt);
				}
			}
		}

		/* Write Block Bitmap */
		uint8_t *blk_bitmap;
		int used_blocks;
		int set_full;
		int j;
		int set_val;
		uint32_t bitmap_val;
		int empty_blocks;
	
		
		if (bgcnt != blk_group_num - 1) {
			memset(img3, 0x00, sizeof(__u8) * 4096);

			used_blocks = 0x8000 - current_free_blk;
			set_full = used_blocks / 0x20;
			set_val = used_blocks % 0x20;
			bitmap_val = 0;
	
			for (i = 0;i <= set_full;i++) {
				blk_bitmap = (uint32_t *)(img3 + (4 * i));
				if(i == set_full) {
					for (j = 0;j <= set_val - 1;j++) {
						bitmap_val |= 1 << j;
					}
					mk4(blk_bitmap, bitmap_val);
				} else {
					mk4(blk_bitmap, 0xffffffff);
				}
			}
		} else {
			memset(img3, 0xff, sizeof(__u8) * 4096);

			used_blocks = 0x8000 - (current_free_blk + (0x8000 -
					(total_blocks % 0x8000)));

			set_full = used_blocks / 0x20;
			set_val = used_blocks % 0x20;

			bitmap_val = 0x0;
			//==> write empty blocks
			empty_blocks = (current_free_blk + used_blocks) / 32;
			int temp = (current_free_blk + used_blocks) % 32;
			for (i = 0; i <= empty_blocks; i++) {
				blk_bitmap = (uint32_t *)(img3 + (4 * i));
				if (i == empty_blocks ) {
					for (j = temp;j < 32; j++) {
						bitmap_val |= 1 << j;
					}
					mk4(blk_bitmap, bitmap_val);
				} else {
					mk4(blk_bitmap, 0x00);
				}
			}

			bitmap_val = 0;
			for (i = 0;i <= set_full;i++) {
				blk_bitmap = (uint32_t *)(img3 + (4 * i));
				if(i == set_full) {
					for (j = 0;j <= set_val - 1;j++) {
						bitmap_val |= 1 << j;
					}
					mk4(blk_bitmap, bitmap_val);
				} else {
					mk4(blk_bitmap, 0xffffffff);
				}
			}
		}

		/*
		printf("\n\nPrint Block Bitmap(0x%x)\n",current_free_blk);
		for(i = 0;i < 4096; i++) {
			if(img3[i] == 0)
				printf("00 ");
			else
				printf("%02x ", img3[i]);
			if (!((i+1) % 4))
				printf("| ");
			if (!((i+1) % 16))
				printf("\n");
			if (!((i+1) % 512))
				printf("---------------------------------------------------%d\n", i+1);
		}
		*/

		/* Write block bitmap */
		start_block = (current_blkbit_addr * 8) + info.start;

		if (dev_desc->block_write(dev_desc->dev, start_block, 8,
			(ulong *)img3) != 8) {
			printf("Can't write Descriptor Table(%d)~~~!!!\n", bgcnt);
		}

		/* Write inode bitmap */
		uint8_t *inode_bitmap;
	
		memset(img4, 0xff, sizeof(__u8) * 4096);
	
		int empty_inode = inodes_per_group;
		int set_empty = empty_inode / 0x20;
		
		// Fix me~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if (total_blocks < 0x8000) /* if size < 128MB */
			set_empty -= 1;
		
		for (i = 0;i < set_empty;i++) {
			inode_bitmap = (uint32_t *)(img4 + (4 * i));
			mk4(inode_bitmap, 0);
		}

		if (bgcnt == 0) {
			inode_bitmap = (uint32_t *)img4;
			mk4(inode_bitmap, 0x7ff);
		}

		/*
		printf("\n\nPrint Inode Bitmap0\n");
		for(i = 0;i < 4096; i++) {
			if(img4[i] == 0)
				printf("00 ");
			else
				printf("%02x ", img4[i]);
			if (!((i+1) % 4))
				printf("| ");
			if (!((i+1) % 16))
				printf("\n");
			if (!((i+1) % 512))
				printf("---------------------------------------------------%d\n", i+1);
		}
		*/

		/* Write inode bitmap */
		start_block = (current_indbit_addr * 8) + info.start;
		if (dev_desc->block_write(dev_desc->dev, start_block, 8,
			(ulong *)img4) != 8) {
			printf("Can't write inode bitmap(%d)~~~!!!\n", bgcnt);
		}
		
		/* Write Inode Table & data */
		start_block = (current_indtable_addr * 8) + info.start;
		//Erase to 0x00 to initialize inode table.....
		memset(zerobuf, 0x00, sizeof(__u8) * 4096 * 80);
		int indt_blknum = (inodes_per_group * 128 / 4096) + 1;
		printf("Erase inode table(%d) - 0x%x", bgcnt, start_block);
		for (j = 0; j < (indt_blknum /80) + 4; j++) { // 2 means root + a 
			start_block += j * 8;
			if (dev_desc->block_write(dev_desc->dev,
				start_block, 640, (ulong *)zerobuf) != 640) {
				printf("Can't erase inode table(%d)~~~!!!\n", bgcnt);
			}
			printf(".");
		}
		printf("\n");

		struct inode_desc *inode;
	
		memset(img5, 0x00, sizeof(__u8) * 2048);
	
		// 1st inode : bad inode
		inode = (struct inode *)img5;
		mk4(inode->access_time, 0x33); /* 0x33 means nothing */
		mk4(inode->change_time, 0x33); /* 0x33 means nothing */
		mk4(inode->modify_time, 0x33); /* 0x33 means nothing */
	
		// 2nd inode : Root inode
		inode = (struct inode *)(img5 + sizeof(struct inode_desc));
		mk2(inode->file_mode, 0x41ed);
		mk4(inode->size_byte, 0x1000);
		mk4(inode->access_time, 0x33); /* 0x33 means nothing */
		mk4(inode->change_time, 0x33); /* 0x33 means nothing */
		mk4(inode->modify_time, 0x33); /* 0x33 means nothing */
		mk2(inode->link_count, 0x3);
		mk2(inode->block_count, 0x8);
		/* root data block addr = 
		 * inode_table_addr + inode table size
		 */
		uint32_t root_data_blk = (inodes_per_group * 128) / 4096;
		if (total_blocks > 0x8000) /* if size > 128MB */
			root_data_blk += first_inode_table_addr; 
		else
			root_data_blk += first_inode_table_addr - 1; 

		mk4(inode->block_pointers, root_data_blk);
		// Write root directory in data region.
		if (bgcnt == 0) {
			/* root data */
			memset(rootdata, 0x00, sizeof(__u8) * 4096);
			mk4(rootdata, 0x2);
			mk4(rootdata + 4, 0x201000c);
			mk4(rootdata + 8, 0x2e);
			mk4(rootdata + 12, 0x2);
			mk4(rootdata + 16, 0x202000c);
			mk4(rootdata + 20, 0x2e2e);
			mk4(rootdata + 24, 0xb);
			mk4(rootdata + 28, 0x20a0fe8);
			mk4(rootdata + 32, 0x74736f6c);
			mk4(rootdata + 36, 0x756f662b);
			mk4(rootdata + 40, 0x646e);
			if (dev_desc->block_write(dev_desc->dev,
				(root_data_blk * 8) + info.start, 8,
				(ulong *)rootdata) != 8) {
				printf("Can't write rootdata~~~!!!\n");
			}

			/* root + 1 data */
			root_data_blk++;
			memset(inode_data, 0x00, sizeof(__u8) * 4096);
			mk4(inode_data, 0xb);
			mk4(inode_data + 4, 0x201000c);
			mk4(inode_data + 8, 0x2e);
			mk4(inode_data + 12, 0x2);
			mk4(inode_data + 16, 0x2020ff4);
			mk4(inode_data + 20, 0x2e2e);
			if (dev_desc->block_write(dev_desc->dev,
				(root_data_blk * 8) + info.start, 8,
				(ulong*)inode_data) != 8) {
				printf("Can't write root+1~~~!!!\n");
			}
			/* root + 2 data */
			root_data_blk++;
			memset(inode_data, 0x00, sizeof(__u8) * 4096);
			mk4(inode_data + 4, 0x1000);
			if (dev_desc->block_write(dev_desc->dev,
				(root_data_blk * 8) + info.start, 8,
				(ulong*)inode_data) != 8) {
				printf("Can't write root+1~~~!!!\n");
			}

			/* root + 3 data */
			root_data_blk++;
			memset(inode_data, 0x00, sizeof(__u8) * 4096);
			mk4(inode_data + 4, 0x1000);
			if (dev_desc->block_write(dev_desc->dev,
				(root_data_blk * 8) + info.start, 8,
				(ulong*)inode_data) != 8) {
				printf("Can't write root+1~~~!!!\n");
			}

			/* root + 4 data */
			root_data_blk++;
			memset(inode_data, 0x00, sizeof(__u8) * 4096);
			mk4(inode_data + 4, 0x1000);
			if (dev_desc->block_write(dev_desc->dev,
				(root_data_blk * 8) + info.start, 8,
				(ulong*)inode_data) != 8) {
				printf("Can't write root+1~~~!!!\n");
			}
		}

		// 3 ~ 6th inode : empty
		// 7th inode : reserved_gdt_blocks
		inode = (struct inode *)(img5 + sizeof(struct inode_desc) * 6);
		mk2(inode->file_mode, 0x8180);
		mk4(inode->size_byte, 0x40c000);
		mk4(inode->access_time, 0x33); /* 0x33 means nothing */
		mk4(inode->change_time, 0x33); /* 0x33 means nothing */
		mk4(inode->modify_time, 0x33); /* 0x33 means nothing */
		mk2(inode->link_count, 0x1);
		uint32_t inode7_cnt;
		// 4096 * 512 ==> changing from ext2block to mmc block....
		inode7_cnt = ((reserved_gdt_blk * reserved_blk_cnt) + 1) * 4096 / 512;
		mk2(inode->block_count, inode7_cnt);
		root_data_blk ++; 
		mk4(inode->block_pointers + 52, root_data_blk);
		mk4(inode->directory_acl, 1);

		// Write 7th inode data
		if (bgcnt == 0) {
			memset(inode_data, 0x00, sizeof(__u8) * 4096);
			/* original code
			uint32_t temp;	
			if (reserved_gdt_blk % 2) {
				temp = reserved_gdt_blk /= 2;
				temp++;
				temp *= 2;
			}
			for(j=0; j< temp; j++) {
				if ( j != 0)
					mk4(inode_data + (j * 4), j + 1);
			}
			*/
			for(j=0; j< current_blkbit_addr - 1; j++) {
				if ( j != 0)
					mk4(inode_data + (j * 4), j + 1);
			}
			if (dev_desc->block_write(dev_desc->dev, 
				(root_data_blk * 8) + info.start, 8,
				(ulong*)inode_data) != 8) {
				printf("Can't write 7th inode~~~!!!\n");
			}
		}
		
		if (set_journaling) {
			// 8th inode : reserved for journaling
			inode = (struct inode *)(img5 + sizeof(struct
					inode_desc) * 7);
			mk2(inode->file_mode, 0x8180);
			uint32_t indirect_pointer_addr = 0;
			uint32_t d_indirect_pointer_addr = 0;
			int default_jnl_blocks = default_journal_size(total_blocks);
			uint32_t temp_val;
			if (default_jnl_blocks == 1024)
				temp_val = 0x400000;
			else if (default_jnl_blocks == 4096)
				temp_val = 0x1000000;
			else if (default_jnl_blocks == 8192)
				temp_val = 0x2000000;
			else if (default_jnl_blocks == 16384)
				temp_val = 0x4000000;
			else if (default_jnl_blocks == 32768)
				temp_val = 0x8000000;
			mk4(inode->size_byte, temp_val);
			mk4(inode->change_time, 0x33);
			mk4(inode->modify_time, 0x33);
			mk2(inode->link_count, 0x1);
			// set journaling blocks by 512 per 1block.
			int inode_jnl_blocks = jnl_blocks * 4096 / 512;
			if (total_blocks > 0x8000) /* if size > 128MB */
				mk4(inode->block_count, inode_jnl_blocks);
			else
				mk4(inode->block_count, inode_jnl_blocks + 8);

			// set journaling block address
			mk4(inode->block_pointers, jnldata_start_addr);
			mk4(inode->block_pointers + 4, jnldata_start_addr + 1);
			mk4(inode->block_pointers + 8, jnldata_start_addr + 2);
			mk4(inode->block_pointers + 12, jnldata_start_addr + 3);
			mk4(inode->block_pointers + 16, jnldata_start_addr + 4);
			mk4(inode->block_pointers + 20, jnldata_start_addr + 5);
			mk4(inode->block_pointers + 24, jnldata_start_addr + 6);
			mk4(inode->block_pointers + 28, jnldata_start_addr + 7);
			mk4(inode->block_pointers + 32, jnldata_start_addr + 8);
			mk4(inode->block_pointers + 36, jnldata_start_addr + 9);
			mk4(inode->block_pointers + 40, jnldata_start_addr + 10);
			mk4(inode->block_pointers + 44, jnldata_start_addr + 11);
			indirect_pointer_addr = jnldata_start_addr + 12;
			mk4(inode->block_pointers + 48, indirect_pointer_addr);

			/* If journaling data blocks are bigger than 4096, it
			 * use double indirect pointer (block13)
			 */
			if (default_jnl_blocks >= 4096) {
				/* 400 : 0x400(1024) means amount of pointing by 1block
				 *       4096(1block) / 4 = 1024
				 */
				d_indirect_pointer_addr = jnldata_start_addr
							+ 0x400 + 13;
				mk4(inode->block_pointers + 52,
					d_indirect_pointer_addr);
			}
			// Write 8th inode data
			if (bgcnt == 0) {
				memset(inode_data, 0x00, sizeof(__u8) * 4096);
				mk4(inode_data, 0x98393bc0);
				mk4(inode_data + 4, 0x4000000);
				mk4(inode_data + 12, 0x100000);
				temp_val >>= 4;
				mk4(inode_data + 16, temp_val);
				mk4(inode_data + 20, 0x1000000);
				mk4(inode_data + 24, 0x1000000);
				// set UUID
				mk4(inode_data + 48, uuid[0]);
				mk4(inode_data + 52, uuid[1]);
				mk4(inode_data + 56, uuid[2]);
				mk4(inode_data + 60, uuid[3]);
				mk4(inode_data + 64, 0x1000000);

				//write data to sd/mmc
				if (dev_desc->block_write(dev_desc->dev, 
					(jnldata_start_addr * 8) + info.start, 8,
					(ulong*)inode_data) != 8) {
					printf("Can't write 8th inode~~~!!!\n");
				}

				// Write indirect pointer value
				// 12 means num of default direct pointer
				uint32_t remain_blocks = jnl_blocks - 12;
				memset(inode_data, 0x00, sizeof(__u8) * 4096);
				for (j = 0; j < 1024; j++) {
					mk4(inode_data + (j * 4),
						indirect_pointer_addr + 1 + j);
					remain_blocks--;
					if (remain_blocks == 0)
						break;
				}
				//write data to sd/mmc
				if (dev_desc->block_write(dev_desc->dev, 
					(indirect_pointer_addr * 8) + info.start, 8,
					(ulong*)inode_data) != 8) {
					printf("Can't write 8th inode~~~!!!\n");
				}

				//Write double indirect pointer
				if (remain_blocks != 0) {
					memset(inode_data, 0x00, sizeof(__u8) * 4096);
					int k;
					int needed_blocks = remain_blocks / 1024;
					// Check me==================>
					if (total_blocks > 0x8000) /* if size > 128MB */
						if (remain_blocks % 1024)
							needed_blocks += 1;
					//<==========================
					remain_blocks -= (needed_blocks + 2);

					for (j=0;j < needed_blocks; j++) {
						int now_val =
						d_indirect_pointer_addr + 1 + (j * 0x400) + j;
						mk4(inode_data + (j * 4), now_val);
						
						memset(inode_data2, 0x00, sizeof(__u8) * 4096);
						for (k = 0; k < 1024; k++) {
							uint32_t tmp_val = now_val + 1 + k;
							if (tmp_val >= 0x8000) {
								tmp_val += 
								seblk_offset + (inodes_per_group * 128 / 4096);
							}
							mk4(inode_data2 + (k * 4), tmp_val);
							remain_blocks--;
							if(remain_blocks == 0)
								break;
						}
						//write data to sd/mmc
						if (dev_desc->block_write(dev_desc->dev, 
							(now_val * 8) + info.start, 8,
							(ulong*)inode_data2) != 8) {
							printf("Can't  inodeval~~~!!!\n");
						}
					}
					//write data to sd/mmc
					printf("d_indirect_point:0x%x\n",
						(d_indirect_pointer_addr * 8) + info.start);
					if (dev_desc->block_write(dev_desc->dev, 
						(d_indirect_pointer_addr * 8) + info.start, 8,
						(ulong*)inode_data) != 8) {
						printf("Can't write 8th inode~~~!!!\n");
					}
				}
			}
		}

		// 9  ~ 10th inode : empty
		// 11th inode : first inode without reserved
		//              It point next of root(lost+found)
		inode = (struct inode *)(img5 + sizeof(struct inode_desc) * 10);
		mk2(inode->file_mode, 0x41c0);
		mk4(inode->size_byte, 0x4000);
		mk4(inode->access_time, 0x33); /* 0x33 means nothing */
		mk4(inode->change_time, 0x33); /* 0x33 means nothing */
		mk4(inode->modify_time, 0x33); /* 0x33 means nothing */
		mk2(inode->link_count, 0x2);
		mk2(inode->block_count, 0x20);
		root_data_blk -= 4; 
		mk4(inode->block_pointers, root_data_blk);
		mk4(inode->block_pointers + 4, root_data_blk + 1);
		mk4(inode->block_pointers + 8, root_data_blk + 2);
		mk4(inode->block_pointers + 12, root_data_blk + 3);


		/*
		printf("\n\nPrint inode table0\n");
		for(i = 0;i < 2048; i++) {
			if(img5[i] == 0)
				printf("00 ");
			else
				printf("%02x ", img5[i]);
			if (!((i+1) % 4))
				printf("| ");
			if (!((i+1) % 16))
				printf("\n");
			if (!((i+1) % 512))
				printf("---------------------------------------------------%d\n", i+1);
		}
		*/

		if (bgcnt == 0) {
			/* Write inode table */
			start_block = (current_indtable_addr * 8) + info.start;
			if (dev_desc->block_write(dev_desc->dev, start_block, 4,
				(ulong *)img5) != 4) {
				printf("Can't write inode table(%d)~~~!!!\n", bgcnt);
			}
		}
	}
	free(img);
	free(img2);
	free(reserve_img);
	free(img3);
	free(img4);
	free(zerobuf);
	free(img5);
	free(rootdata);
	free(inode_data);

	return 0;
}

#endif
