.equ DISABLE_IRQ, 0b10000000
.equ DISABLE_FIQ, 0b01000000
.equ SYS_MOD,     0b00011111
.equ IRQ_MOD,     0b00010010
.equ FIQ_MOD,     0b00010001
.equ SVC_MOD,     0b00010011
.equ ABT_MOD,     0b00010111
.equ UND_MOD,     0b00011011
.equ MOD_MASK,    0b00011111

.macro TO_SVC_MOD
    msr cpsr_c, #(DISABLE_IRQ|DISABLE_FIQ|SVC_MOD)
.endm

.macro TO_IRQ_MOD
    msr cpsr_c, #(DISABLE_IRQ|DISABLE_FIQ|IRQ_MOD)
.endm


.global __vector_undefined
.global __vector_swi
.global __vector_prefetch_abort
.global __vector_data_abort
.global __vector_reserved
.global __vector_irq
.global __vector_fiq

.extern common_irq_handler

.text
.code 32

__vector_undefined:
    nop

__vector_swi:
    nop

__vector_prefetch_abort:
    nop

__vector_data_abort:
    nop

__vector_reserved:
    nop

/* __vector_irq: */
/*     sub r14,r14,#4 */
/*     stmfd r13!,{r14} */
/*     mrs r14,spsr */
/*     stmfd r13!,{r14} */
/*     TO_SVC_MOD */
/*     stmfd r13!,{r0-r3} */
/*     bl common_irq_handler */
/*     ldmfd r13!,{r0-r3} */
/*     TO_IRQ_MOD */
/*     ldmfd r13!,{r14} */
/*     msr spsr,r14 */
/*     ldmfd r13!,{pc}^ */

__vector_irq:
    sub r14, r14, #4
    str r14, [r13, #-0x4]
    mrs r14, spsr
    str r14, [r13, #-0x8]
    str r0,  [r13, #-0xc]
    mov r0, r13
    TO_SVC_MOD
    str r14, [r13, #-0x8]!
    ldr r14, [r0, #-0x4]
    str r14, [r13, #-0x4]
    ldr r14, [r0, #-0x8]
    ldr r0, [r0, #-0xc]
    stmdb r13!, {r0-r3, r14}
    bl common_irq_handler
    ldmia r13!, {r0-r3, r14}
    msr spsr, r14
    ldmfd r13!, {r14,pc}^


__vector_fiq:
    nop

