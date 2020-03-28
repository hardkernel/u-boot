/*
 * Copyright (c) 2017 Andreas Färber
 *
 * SPDX-License-Identifier: GPL-2.0+
 */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "meson.h"

static void print_aml_header(const struct AmlogicHeader *hdr)
{
	printf("Size: 0x%" PRIx32 "\n", hdr->size);
	printf("Header size: 0x%" PRIx16 "\n", hdr->header_size);
	printf("Header version: %" PRIu16 "\n", hdr->header_version);
	printf("ID: 0x%" PRIx32 "\n", hdr->id);
	printf("Encrypted? %" PRIu32 "\n", hdr->encrypted);
	printf("Digest @ 0x%" PRIx32 ", len %" PRIu32 "\n", hdr->digest_offset, hdr->digest_size);
	printf("Data @ 0x%" PRIx32 ", len %" PRIu32 "\n", hdr->data_offset, hdr->data_size);
	printf("Padding @ 0x%" PRIx32 ", len %" PRIu32 "\n", hdr->padding_offset, hdr->padding_size);
	printf("_offset2: 0x%" PRIx32 "\n", hdr->_offset2);
	printf("pad2: 0x%" PRIx32 "\n", hdr->pad2);
	printf("Payload @ 0x%" PRIx32 ", len %" PRIu32 "\n", hdr->payload_offset, hdr->payload_size);
	printf("unknown: 0x%" PRIx32 "\n", hdr->unknown);
	printf("\n");
}

static int info(char *filename)
{
	uint8_t buf[16 + 64];
	struct AmlogicHeader *hdr;
	FILE *f;
	long pos;
	int len;

	f = fopen(filename, "rb");
	if (f == NULL)
		return 1;

	pos = 0;
	do {
		len = fread(buf, 1, 16 + 64, f);
		if (len >= 4 && strncmp((const char*)buf, AMLOGIC_SIGNATURE, 4) == 0) {
			hdr = (struct AmlogicHeader *)buf;
			pos += 0;
		} else if (len >= 16 + 4 && strncmp((const char*)buf + 16, AMLOGIC_SIGNATURE, 4) == 0) {
			hdr = (struct AmlogicHeader *)(buf + 16);
			pos += 16;
		} else if (len >= 4 && ((struct FipHeader *)buf)->name == FIP_SIGNATURE) {
			struct FipHeader *fip_hdr;
			long toc_pos = pos;
			int i = 0;

			fip_hdr = malloc(sizeof(struct FipHeader) + sizeof(struct FipEntry));
			if (fip_hdr == NULL)
				return 1;
			fseek(f, toc_pos, SEEK_SET);
			len = fread(fip_hdr, 1, sizeof(struct FipHeader) + sizeof(struct FipEntry), f);
			printf("FIP header @ 0x%" PRIx64 " (flags 0x%" PRIx64 ")\n", pos, fip_hdr->flags);
			printf("\n");
			while (fip_hdr->entries[0].size > 0) {
				printf("FIP TOC entry %u (flags 0x%" PRIx64 ")\n", i, fip_hdr->entries[0].flags);
				fseek(f, toc_pos + fip_hdr->entries[0].offset_address, SEEK_SET);
				len = fread(buf, 1, 64, f);
				if (len >= 4 && strncmp((const char*)buf, AMLOGIC_SIGNATURE, 4) == 0) {
					printf("@AML header @ 0x%" PRIx64 "\n", toc_pos + fip_hdr->entries[0].offset_address);
					print_aml_header((struct AmlogicHeader *)buf);
				} else {
					fprintf(stderr, "Unexpected FIP TOC entry contents\n");
				}

				i++;
				fseek(f, toc_pos + sizeof(struct FipHeader) + i * sizeof(struct FipEntry), SEEK_SET);
				fread((void*)fip_hdr + sizeof(struct FipHeader), 1, sizeof(struct FipEntry), f);
			}
			free(fip_hdr);
			break;
		} else {
			fclose(f);
			return 1;
		}

		printf("@AML header @ 0x%" PRIx64 "\n", pos);
		print_aml_header(hdr);

		fseek(f, pos + hdr->size, SEEK_SET);
	} while ((pos = ftell(f)) > 0);

	fclose(f);
	return 0;
}

int main(int argc, char **argv)
{
	if (argc < 2) {
		fprintf(stderr, "Usage: %s filename\n", argv[0]);
		return 1;
	}
	return info(argv[1]);
}
