#include <lib.h>
#include <int.h>
#include <x86.h>
#include <console.h>

#define SERIAL_IO       0x3F8

#define COM_RX          0x00    // In:  Receive buffer (DLAB=0)
#define COM_TX          0x00    // Out: Transmit buffer (DLAB=0)
#define COM_DLL         0x00    // Out: Divisor Latch Low (DLAB=1)
#define COM_DLM         0x01    // Out: Divisor Latch High (DLAB=1)
#define COM_IER         0x01    // Out: Interrupt Enable Register
#define COM_IER_RDI     0x01    //      Enable receiver data interrupt
#define COM_IIR         0x02    // In:  Interrupt ID Register
#define COM_FCR         0x02    // Out: FIFO Control Register
#define COM_LCR         0x03    // Out: Line Control Register
#define COM_LCR_DLAB    0x80    //      Divisor latch access bit
#define COM_LCR_WLEN8   0x03    //      Wordlength: 8 bits
#define COM_MCR         0x04    // Out: Modem Control Register
// #define COM_MCR_RTS     0x02    // RTS  complement
// #define COM_MCR_DTR     0x01    // DTR  complement
// #define COM_MCR_OUT2    0x08    // Out2 complement
#define COM_LSR         0x05    // In:  Line Status Register
#define COM_LSR_DATA    0x01    //      Data available
#define COM_LSR_TXRDY   0x20    //      Transmit buffer avail
// #define COM_LSR_TSRE    0x40    //      Transmitter off

static bool serial;

static void
delay(void) {
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}

void
irq_handler_serial(struct regs* r) {
    (void) r;

    if (serial) {
        if (!(inb(SERIAL_IO + COM_LSR) & COM_LSR_DATA))
            return;

        char c = (char) inb(SERIAL_IO + COM_RX);

        extern struct console console;
        console.buf[console.wpos++] = c;
        if (console.wpos == CONSBUFSIZE)
            console.wpos = 0;
    }
}

void
putc_serial(int c) {
    if (serial) {
        for (int i = 0; i < 12800; ++i) {
            if (inb(SERIAL_IO + COM_LSR) & COM_LSR_TXRDY)
                break;
            delay();
        }
        outb(SERIAL_IO + COM_TX, c);
    }
}

// void
// putc_lpt(int c) {
//     int i;

//     for (i = 0; !(inb(0x378 + 1) & 0x80) && i < 12800; i++)
//         delay();
//     outb(0x378 + 0, c);
//     outb(0x378 + 2, 0x08 | 0x04 | 0x01);
//     outb(0x378 + 2, 0x08);
// }

void
init_serial(void) {
    // Turn off the FIFO
    outb(SERIAL_IO + COM_FCR, 0);

    // Set speed; requires DLAB latch
    outb(SERIAL_IO + COM_LCR, COM_LCR_DLAB);
    outb(SERIAL_IO + COM_DLL, (uint8_t) (115200 / 9600));
    outb(SERIAL_IO + COM_DLM, 0);

    // 8 data bits, 1 stop bit, parity off; turn off DLAB latch
    outb(SERIAL_IO + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);

    // No modem controls
    outb(SERIAL_IO + COM_MCR, 0);
    // Enable rcv interrupts
    outb(SERIAL_IO + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial = (inb(SERIAL_IO + COM_LSR) != 0xFF);
    (void) inb(SERIAL_IO + COM_IIR);
    (void) inb(SERIAL_IO + COM_RX);

    irq_install_handler(IRQ_SER1, irq_handler_serial);
}

