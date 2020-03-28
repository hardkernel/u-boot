# meson-tools

meson-tools is a collection of tools for use with the Amlogic Meson family of ARM based SoCs.

Name-wise it was inspired by [sunxi-tools](https://github.com/linux-sunxi/sunxi-tools/).

## amlbootsig

Usage:
```
 amlbootsig boot_new.bin u-boot.img
```

This tool is supposed to provide equivalent output to:
```
 aml_encrypt_gxb --bootsig --input boot_new.bin --output u-boot.img
```
with the tool version distributed by Hardkernel for their Odroid-C2 board (S905 / Meson GXBaby).

### How to compare output

```
 hexdump -C a/u-boot.img > a/u-boot.img.hex
 hexdump -C b/u-boot.img > b/u-boot.img.hex
 diff -u a/u-boot.img.hex b/u-boot.img.hex | less
```

This should result in a diff with only the following differences:

* First 16 bytes will be random in original.
* The header for each FIP TOC entry will contain 4 bytes of random data.
* Due to FIP TOC entry headers differing, the SHA256 hash in the header will differ as well.

For testing identity of output files, modify the code to use the random bytes from the file you are testing against.

### Known limitations

* Correctness: Since amlbootsig was designed to binary-match previously created output files, it may still have some numbers hard-coded or may do calculations in a way that happened to match tested input/output but may break for other input files. Please report such cases as GitHub issues.
* Endianness: Only Little Endian byte order has been considered. Running it on Big Endian hosts may misinterpret file input and/or result in wrong output and/or other misbehavior. The solution would be byte swaps, but those depend on the field width, which is guessed only and thus may change as the format is being better understood.
* Security: The tool was not designed to defend against invalid or evil file input.

## unamlbootsig

Usage:
```
unamlbootsig u-boot.img boot_new.bin
```

This tool is supposed to do the reverse of `amlbootsig`, i.e. drop the boot signature.

The output may differ from the original `aml_encrypt_gxb --bootsig`/`amlbootsig` input from 0xb000 to 0xbfff as well as in FIP TOC entry size 16-byte alignment.

### Known limitations

See `amlbootsig`.

## amlinfo

Usage:
```
 amlinfo u-boot.img
```

This tool dumps info about an existing image file.

It supports the following inputs:
* `amlbootsig` output
* `aml_encrypt_gxb --bootsig` output, except when using `--amluserkey` or `--efuse`
* `dd if=u-boot.img bs=512 skip=96` output for either of them (FIP TOC with headered entries)
* `dd if=u-boot.img bs=1 skip=16` output, i.e. raw `@AML` header, of at least 64 bytes

### Known limitations

* Correctness: Since there seems to be no public documentation for the @AML headers, any field names printed are guesses and may need to be revised once their meaning becauses clearer.
* Endianness: Only Little Endian byte order has been considered, see above.
* Security: See above.
