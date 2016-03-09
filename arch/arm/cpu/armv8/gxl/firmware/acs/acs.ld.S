
OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(acs_entry)

SECTIONS
{
    . = 0x0;

    ro . : {
        __RO_START__ = .;
        *acs_entry.o(.text*)
        *(.text*)
        *(.rodata*)
        *(.vectors)
        __RO_END_UNALIGNED__ = .;
        /*
         * Memory page(s) mapped to this section will be marked as
         * read-only, executable.  No RW data from the next section must
         * creep in.  Ensure the rest of the current memory page is unused.
         */
        __RO_END__ = .;
    }

    .data . : {
        __DATA_START__ = .;
        *(.data*)
        __DATA_END__ = .;
    }

    /*
     * The .bss section gets initialised to 0 at runtime.
     * Its base address must be 16-byte aligned.
     */
    .bss : ALIGN(16) {
        __BSS_START__ = .;
        *(.bss*)
        __BSS_END__ = .;
    }

    ASSERT(. <= 0x1000, "timing image has exceeded its limit.")
}

