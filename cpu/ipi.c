#include <lib.h>
#include <ipi.h>
#include <cpu.h>
#include <x86.h>

#define TLBSHOOTDOWN_ALL  (-1)
#define TLBSHOOTDOWN_MAX 16

struct tlbshootdown {
    /*
     * Change this to what you need for your VM design.
     */
    int ts_placeholder;
};

void
ipi_send(struct cpu* target, int code) {
    assert(code >= 0 && code < 32);

    spinlock_acquire(&target->ipi_lock);
    target->ipi_pending |= (uint32_t)1 << code;
    // mainbus_send_ipi(target);
    spinlock_release(&target->ipi_lock);
}

void
ipi_broadcast(int code) {
    for (size_t i = 0; i < ncpu; i++)
        if (cpus[i] != thiscpu->self)
            ipi_send(cpus[i], code);
}

// void
// ipi_tlbshootdown(struct cpu *target, const struct tlbshootdown *mapping)
// {
//     int n;

//     spinlock_acquire(&target->ipi_lock);

//     n = target->numshootdown;
//     if (n == TLBSHOOTDOWN_MAX) {
//         target->numshootdown = TLBSHOOTDOWN_ALL;
//     }
//     else {
//         target->shootdown[n] = *mapping;
//         target->numshootdown = n+1;
//     }

//     target->ipi_pending |= (uint32_t)1 << IPI_TLBSHOOTDOWN;
//     mainbus_send_ipi(target);

//     spinlock_release(&target->ipi_lock);
// }

void
interprocessor_interrupt(void) {
    spinlock_acquire(&thiscpu->ipi_lock);
    uint32_t bits = thiscpu->ipi_pending;

    if (bits & BIT(IPI_PANIC)) {
        /* panic on another cpu - just stop dead */
        spinlock_release(&thiscpu->ipi_lock);
        // cpu_halt();
    }
    if (bits & BIT(IPI_OFFLINE)) {
        /* offline request */
        spinlock_release(&thiscpu->ipi_lock);
        spinlock_acquire(&thiscpu->active_threads_lock);
        if (thiscpu->status != CPU_IDLE)
            print("cpu%d: offline: warning: not idle\n", thiscpu->apicid);
        spinlock_release(&thiscpu->active_threads_lock);
        print("cpu%d: offline.\n", thiscpu->apicid);
        // cpu_halt();
    }
    if (bits & BIT(IPI_UNIDLE)) {
        /*
         * The cpu has already unidled itself to take the
         * interrupt; don't need to do anything else.
         */
    }
    if (bits & BIT(IPI_TLBSHOOTDOWN))
        tlbflush();

    thiscpu->ipi_pending = 0;
    spinlock_release(&thiscpu->ipi_lock);
}
