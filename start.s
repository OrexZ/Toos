.section .startup
.code 32

.align 0

.global _start

.extern __vector_reset
.extern __vector_undefined
.extern __vector_swi
.extern __vector_prefetch_abort
.extern __vector_data_abort
.extern __vector_reserved
.extern __vector_irq
.extern __vector_fiq

_start:
    LDR pc, _vector_reset
    LDR pc, _vector_undefined
    LDR pc, _vector_swi
    LDR pc, _vector_prefetch_abort
    LDR pc, _vector_data_abort
    LDR pc, _vector_reserved
    LDR pc, _vector_irq
    LDR pc, _vector_fiq

@ align > 2 ** n
.align 2

_vector_reset:
    .word __vector_reset
_vector_undefined:
    .word __vector_undefined
_vector_swi:
    .word __vector_swi
_vector_prefetch_abort:
    .word __vector_prefetch_abort
_vector_data_abort:
    .word __vector_data_abort
_vector_reserved:
    .word __vector_reserved
_vector_irq:
    .word __vector_irq
_vector_fiq:
    .word __vector_fiq
