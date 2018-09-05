
OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(acs_entry)

SECTIONS
{
    . = 0xFFFBF000;

    . : {
        __RO_START__ = .;
        *acs_entry.o(.text*)
        *(.text*)
        *(.data*)
    }

    ASSERT(. <= 0xFFFC0000, "timing image has exceeded its limit.")
}
