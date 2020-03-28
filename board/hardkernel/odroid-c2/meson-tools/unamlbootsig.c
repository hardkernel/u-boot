/*
 * Copyright (c) 2017 Andreas Färber
 *
 * SPLX-License-Identifier: GPL-2.0+
 */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "meson.h"

static int extract(const char *input, const char *output)
{
	uint8_t buf[16 + sizeof(struct AmlogicHeader)];
	struct AmlogicHeader *hdr;
	FILE *fin, *fout;
	long pos;
	int len;

	fin = fopen(input, "rb");
	if (fin == NULL)
		return 1;

	fout = fopen(output, "wb");
	if (fout == NULL)
		return 1;

	pos = 0;
	do {
		len = fread(buf, 1, 16 + sizeof(struct AmlogicHeader), fin);
		if (len >= 4 && strncmp((const char*)buf, AMLOGIC_SIGNATURE, 4) == 0) {
			hdr = (struct AmlogicHeader *)buf;
		} else if (len >= 16 + 4 && strncmp((const char*)buf + 16, AMLOGIC_SIGNATURE, 4) == 0) {
			hdr = (struct AmlogicHeader *)(buf + 16);
			pos += 16;
		} else if (len >= 4 && ((struct FipHeader *)buf)->name == FIP_SIGNATURE) {
			struct FipHeader *fip_hdr;
			uint8_t *src_buf;
			long toc_pos = pos;
			int i, n;

			fip_hdr = malloc(sizeof(struct FipHeader) + sizeof(struct FipEntry));
			if (fip_hdr == NULL)
				return 1;
			fseek(fin, toc_pos, SEEK_SET);
			len = fread(fip_hdr, 1, sizeof(struct FipHeader) + sizeof(struct FipEntry), fin);
			printf("FIP header @ 0x%" PRIx64 " (flags 0x%" PRIx64 ")\n", pos, fip_hdr->flags);
			fwrite(fip_hdr, 1, sizeof(struct FipHeader), fout);
			n = 0;
			while (fip_hdr->entries[0].size > 0) {
				n++;
				fread((void*)fip_hdr + sizeof(struct FipHeader), 1, sizeof(struct FipEntry), fin);
			}
			fip_hdr = realloc(fip_hdr, sizeof(struct FipHeader) + (n + 1) * sizeof(struct FipEntry));
			if (fip_hdr == NULL)
				return 1;

			fseek(fin, toc_pos + sizeof(struct FipHeader), SEEK_SET);
			fread((void*)fip_hdr + sizeof(struct FipHeader), 1, (n + 1) * sizeof(struct FipEntry), fin);
			fwrite((void *)fip_hdr + sizeof(struct FipHeader), 1, (n + 1) * sizeof(struct FipEntry), fout);
			src_buf = malloc(0x4000);
			if (src_buf == NULL)
				return 1;

			for (i = 0; i < n; i++) {
				printf("FIP TOC entry %u (flags 0x%" PRIx64 ")\n", i, fip_hdr->entries[i].flags);

				fseek(fin, toc_pos + fip_hdr->entries[i].offset_address, SEEK_SET);
				len = fread(buf, 1, sizeof(struct AmlogicHeader), fin);
				if (len >= 4 && strncmp((const char*)buf, AMLOGIC_SIGNATURE, 4) == 0) {
					long remaining;

					printf("@AML header @ 0x%" PRIx64 "\n", toc_pos + fip_hdr->entries[i].offset_address);
					hdr = (struct AmlogicHeader *)buf;
					fip_hdr->entries[i].size -= hdr->header_size + hdr->digest_size;
					pos = ftell(fout);
					pos = ROUND_UP(pos, 0x4000);
					fseek(fout, pos, SEEK_SET);
					fseek(fin, toc_pos + fip_hdr->entries[i].offset_address + fip_hdr->entries[i].size, SEEK_SET);
					len = fread(src_buf, 1, hdr->header_size + hdr->digest_size, fin);
					fwrite(src_buf, 1, len, fout);

					fseek(fin, toc_pos + fip_hdr->entries[i].offset_address + hdr->header_size + hdr->digest_size, SEEK_SET);
					remaining = fip_hdr->entries[i].size - hdr->header_size - hdr->digest_size;
					while (remaining > 0) {
						len = fread(src_buf, 1, MIN(remaining, 0x4000), fin);
						remaining -= len;
						fwrite(src_buf, 1, len, fout);
					}
				} else {
					fprintf(stderr, "Unexpected FIP TOC entry contents\n");
				}
			}
			fseek(fout, 0xc000, SEEK_SET);
			fwrite(fip_hdr, 1, sizeof(struct FipHeader) + (n + 1) * sizeof(struct FipEntry), fout);
			fseek(fout, 0, SEEK_END);
			pos = ftell(fout);
			pos = ROUND_UP(pos, 0x4000);
			fseek(fout, pos - 1, SEEK_SET);
			buf[0] = 0;
			fwrite(buf, 1, 1, fout);
			free(fip_hdr);
			break;
		} else {
			fclose(fout);
			fclose(fin);
			return 1;
		}

		printf("@AML header @ 0x%" PRIx64 "\n", pos);

		fseek(fin, pos + hdr->payload_offset, SEEK_SET);
		uint8_t *src_buf = malloc(hdr->payload_size);
		if (src_buf == NULL) {
			fclose(fout);
			fclose(fin);
			return 1;
		}
		len = fread(src_buf, 1, hdr->payload_size, fin);
		fwrite(src_buf, 1, len, fout);
		free(src_buf);

		fseek(fin, pos + hdr->size, SEEK_SET);
		fseek(fout, 0xc000, SEEK_SET);
	} while ((pos = ftell(fin)) > 0);

	fclose(fout);
	fclose(fin);
	return 0;
}

int main(int argc, char **argv)
{
	if (argc < 3) {
		fprintf(stderr, "Usage: %s input output\n", argv[0]);
		return 1;
	}
	return extract(argv[1], argv[2]);
}
