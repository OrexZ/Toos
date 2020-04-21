.equ DISABLE_IRQ, 0b10000000
.equ DISABLE_FIQ, 0b01000000
.equ SYS_MOD,     0b00011111
.equ IRQ_MOD,     0b00010010
.equ FIQ_MOD,     0b00010001
.equ SVC_MOD,     0b00010011
.equ ABT_MOD,     0b00010111
.equ UND_MOD,     0b00011011

// 8M memory
.equ MEM_SIZE, 0x00800000
// 0x3000000 is S3C2410 mach extend memory start-address
.equ TXT_BASE, 0x30000000

.equ _SVC_STACK, (TXT_BASE + MEM_SIZE - 4)
.equ _IRQ_STACK, (_SVC_STACK-0x400) // 0x400 = 1K
.equ _FIQ_STACK, (_IRQ_STACK-0x400)
.equ _ABT_STACK, (_FIQ_STACK-0x400)
.equ _UND_STACK, (_ABT_STACK-0x400)
.equ _SYS_STACK, (_UND_STACK-0x400) // at the end ? maybe extendable...

.text
.code 32
.global __vector_reset

.extern platform_bootup
.extern __bss_start__
.extern __bss_end__

__vector_reset:
    MSR cpsr_c, # (DISABLE_IRQ|DISABLE_FIQ|SVC_MOD)
    LDR sp, =_SVC_STACK

    MSR cpsr_c, # (DISABLE_IRQ|DISABLE_FIQ|IRQ_MOD)
    LDR sp, =_IRQ_STACK

    MSR cpsr_c, # (DISABLE_IRQ|DISABLE_FIQ|FIQ_MOD)
    LDR sp, =_FIQ_STACK

    MSR cpsr_c, # (DISABLE_IRQ|DISABLE_FIQ|ABT_MOD)
    LDR sp, =_ABT_STACK

    MSR cpsr_c, # (DISABLE_IRQ|DISABLE_FIQ|UND_MOD)
    LDR sp, =_UND_STACK

    MSR cpsr_c, # (DISABLE_IRQ|DISABLE_FIQ|SYS_MOD)
    LDR sp, =_SYS_STACK

_clear_bss:
    LDR r1, _bss_start_
    LDR r3, _bss_end_
    mov r2, #0x00
1:
    cmp r1, r3
    beq _main
    str r2, [r1], #0x04
    b 1b

_main:
    b platform_bootup

_bss_start_:
    .word __bss_start__

_bss_end_:
    .word __bss_end__

.end
