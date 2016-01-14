#include <lib.h>
#include <x86.h>
#include <pmm.h>
#include <int.h>
#include <thread.h>
#include <debug.h>

void
switchframe_switch(struct regs* regs) {
    assert(regs != NULL);

    // memory_barrier();
    asm volatile(
        "\tmovl     %0,%%esp\n"
        "\tpopl     %%ds\n"
        "\tpopl     %%es\n"
        "\tpopal\n"
        "\taddl     $0x8,%%esp\n"
        "\tiret\n"
        : : "g" (regs) : "memory"
    );

    panic("returned to switchframe_switch");
}

static void
switchframe_start(void) {
    // memory_barrier();
    asm volatile(
        "\tpushl    %%edx\n"
        "\tpushl    %%ecx\n"
        "\tpushl    %%eax\n"
        "\tcall     thread_start\n"
        : : : "memory"
    );

    panic("returned to switchframe_start");
}

void
switchframe_init(struct thread* thread,
                 int (*entrypoint)(void* data1, unsigned long data2),
                 void* data1, unsigned long data2) {
    uint32_t stacktop = (uint32_t) thread->stack + STACK_SIZE;

    thread->context = (struct regs*) stacktop - 1;
    memset(thread->context, 0, sizeof(struct regs));

    thread->context->cs = GD_KT;
    thread->context->ds = GD_KD;
    thread->context->es = GD_KD;
    thread->context->ss = GD_KD;
    // thread->context->eflags = FL_IF;

    thread->context->eax = (uint32_t) entrypoint;
    thread->context->ecx = (uint32_t) data1;
    thread->context->edx = (uint32_t) data2;
    thread->context->eip = (uint32_t) switchframe_start;

    thread->context->ebp = (uint32_t) thread->context;
    thread->context->esp = (uint32_t) thread->context;
}
