
obj/user/hello.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
    // jne args_exist

    // If not, push dummy argc/argv arguments.
    // This happens when we are loaded by the kernel,
    // because the kernel does not know about passing arguments.
    pushl $0
  800020:	6a 00                	push   $0x0
    pushl $0
  800022:	6a 00                	push   $0x0

00800024 <args_exist>:

args_exist:
    call usermain
  800024:	e8 0f 1b 00 00       	call   801b38 <usermain>
1:  jmp 1b
  800029:	eb fe                	jmp    800029 <args_exist+0x5>
  80002b:	90                   	nop

0080002c <main>:
#include <ulib.h>

int
main(int argc, char** argv) {
  80002c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  800030:	83 e4 f0             	and    $0xfffffff0,%esp
  800033:	ff 71 fc             	pushl  -0x4(%ecx)
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	51                   	push   %ecx
  80003a:	83 ec 10             	sub    $0x10,%esp
    (void) argc;
    (void) argv;

    print("Hello! You are in userspace.\n");
  80003d:	68 ec 1d 80 00       	push   $0x801dec
  800042:	e8 79 0e 00 00       	call   800ec0 <print>

    return 0;
  800047:	83 c4 10             	add    $0x10,%esp
}
  80004a:	31 c0                	xor    %eax,%eax
  80004c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80004f:	c9                   	leave  
  800050:	8d 61 fc             	lea    -0x4(%ecx),%esp
  800053:	c3                   	ret    

00800054 <printnum.constprop.2>:
/*
 * Print a number (base <= 16) in reverse order,
 * using specified putc function and associated pointer putdat.
 */
static void
printnum(void (*putc)(char),
  800054:	55                   	push   %ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 2c             	sub    $0x2c,%esp
  80005b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80005f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800063:	8b 5c 24 40          	mov    0x40(%esp),%ebx
  800067:	8b 74 24 44          	mov    0x44(%esp),%esi
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80006b:	89 cf                	mov    %ecx,%edi
  80006d:	31 ed                	xor    %ebp,%ebp
  80006f:	39 d5                	cmp    %edx,%ebp
  800071:	0f 83 9d 00 00 00    	jae    800114 <printnum.constprop.2+0xc0>
  800077:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  80007b:	55                   	push   %ebp
  80007c:	57                   	push   %edi
  80007d:	ff 74 24 14          	pushl  0x14(%esp)
  800081:	ff 74 24 14          	pushl  0x14(%esp)
  800085:	e8 fe 1a 00 00       	call   801b88 <__udivdi3>
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800091:	89 54 24 14          	mov    %edx,0x14(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800095:	39 d5                	cmp    %edx,%ebp
  800097:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  80009b:	0f 82 9f 00 00 00    	jb     800140 <printnum.constprop.2+0xec>
  8000a1:	77 08                	ja     8000ab <printnum.constprop.2+0x57>
  8000a3:	39 c1                	cmp    %eax,%ecx
  8000a5:	0f 86 95 00 00 00    	jbe    800140 <printnum.constprop.2+0xec>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8000ab:	83 eb 02             	sub    $0x2,%ebx
  8000ae:	85 db                	test   %ebx,%ebx
  8000b0:	7e 15                	jle    8000c7 <printnum.constprop.2+0x73>
  8000b2:	89 f0                	mov    %esi,%eax
  8000b4:	0f be f0             	movsbl %al,%esi
  8000b7:	90                   	nop
            putc(padc);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	56                   	push   %esi
  8000bc:	e8 93 1a 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	4b                   	dec    %ebx
  8000c5:	75 f1                	jne    8000b8 <printnum.constprop.2+0x64>
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  8000c7:	83 ec 10             	sub    $0x10,%esp
  8000ca:	55                   	push   %ebp
  8000cb:	57                   	push   %edi
  8000cc:	ff 74 24 2c          	pushl  0x2c(%esp)
  8000d0:	ff 74 24 2c          	pushl  0x2c(%esp)
  8000d4:	e8 bf 1b 00 00       	call   801c98 <__umoddi3>
  8000d9:	83 c4 14             	add    $0x14,%esp
  8000dc:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8000e3:	50                   	push   %eax
  8000e4:	e8 6b 1a 00 00       	call   801b54 <putc>
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	55                   	push   %ebp
  8000ed:	57                   	push   %edi
  8000ee:	ff 74 24 14          	pushl  0x14(%esp)
  8000f2:	ff 74 24 14          	pushl  0x14(%esp)
  8000f6:	e8 9d 1b 00 00       	call   801c98 <__umoddi3>
  8000fb:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800102:	89 44 24 50          	mov    %eax,0x50(%esp)
}
  800106:	83 c4 3c             	add    $0x3c,%esp
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  80010d:	e9 42 1a 00 00       	jmp    801b54 <putc>
  800112:	66 90                	xchg   %ax,%ax
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800114:	76 1e                	jbe    800134 <printnum.constprop.2+0xe0>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800116:	4b                   	dec    %ebx
  800117:	85 db                	test   %ebx,%ebx
  800119:	7e d1                	jle    8000ec <printnum.constprop.2+0x98>
  80011b:	89 f0                	mov    %esi,%eax
  80011d:	0f be f0             	movsbl %al,%esi
            putc(padc);
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	56                   	push   %esi
  800124:	e8 2b 1a 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	4b                   	dec    %ebx
  80012d:	75 f1                	jne    800120 <printnum.constprop.2+0xcc>
  80012f:	eb bb                	jmp    8000ec <printnum.constprop.2+0x98>
  800131:	8d 76 00             	lea    0x0(%esi),%esi
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800134:	39 c1                	cmp    %eax,%ecx
  800136:	0f 86 3b ff ff ff    	jbe    800077 <printnum.constprop.2+0x23>
  80013c:	eb d8                	jmp    800116 <printnum.constprop.2+0xc2>
  80013e:	66 90                	xchg   %ax,%ax
  800140:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  800144:	55                   	push   %ebp
  800145:	57                   	push   %edi
  800146:	ff 74 24 1c          	pushl  0x1c(%esp)
  80014a:	ff 74 24 1c          	pushl  0x1c(%esp)
  80014e:	e8 35 1a 00 00       	call   801b88 <__udivdi3>
  800153:	83 c4 08             	add    $0x8,%esp
  800156:	56                   	push   %esi
  800157:	83 eb 02             	sub    $0x2,%ebx
  80015a:	53                   	push   %ebx
  80015b:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  80015f:	e8 f0 fe ff ff       	call   800054 <printnum.constprop.2>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	e9 5b ff ff ff       	jmp    8000c7 <printnum.constprop.2+0x73>

0080016c <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putc function and associated pointer putdat.
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
  80016c:	55                   	push   %ebp
  80016d:	57                   	push   %edi
  80016e:	56                   	push   %esi
  80016f:	53                   	push   %ebx
  800170:	83 ec 2c             	sub    $0x2c,%esp
  800173:	89 c6                	mov    %eax,%esi
  800175:	89 d0                	mov    %edx,%eax
  800177:	89 ca                	mov    %ecx,%edx
  800179:	89 44 24 08          	mov    %eax,0x8(%esp)
  80017d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800181:	8b 7c 24 40          	mov    0x40(%esp),%edi
  800185:	8b 5c 24 44          	mov    0x44(%esp),%ebx
  800189:	8b 4c 24 48          	mov    0x48(%esp),%ecx
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80018d:	89 3c 24             	mov    %edi,(%esp)
  800190:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800197:	00 
  800198:	39 54 24 04          	cmp    %edx,0x4(%esp)
  80019c:	0f 83 a6 00 00 00    	jae    800248 <printnum+0xdc>
  8001a2:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  8001a6:	ff 74 24 04          	pushl  0x4(%esp)
  8001aa:	ff 74 24 04          	pushl  0x4(%esp)
  8001ae:	ff 74 24 14          	pushl  0x14(%esp)
  8001b2:	ff 74 24 14          	pushl  0x14(%esp)
  8001b6:	e8 cd 19 00 00       	call   801b88 <__udivdi3>
  8001bb:	83 c4 10             	add    $0x10,%esp
  8001be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c2:	89 54 24 14          	mov    %edx,0x14(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8001c6:	39 54 24 04          	cmp    %edx,0x4(%esp)
  8001ca:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  8001ce:	0f 82 9c 00 00 00    	jb     800270 <printnum+0x104>
  8001d4:	77 08                	ja     8001de <printnum+0x72>
  8001d6:	39 c7                	cmp    %eax,%edi
  8001d8:	0f 86 92 00 00 00    	jbe    800270 <printnum+0x104>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8001de:	83 eb 02             	sub    $0x2,%ebx
  8001e1:	85 db                	test   %ebx,%ebx
  8001e3:	7e 0f                	jle    8001f4 <printnum+0x88>
  8001e5:	0f be f9             	movsbl %cl,%edi
            putc(padc);
  8001e8:	83 ec 0c             	sub    $0xc,%esp
  8001eb:	57                   	push   %edi
  8001ec:	ff d6                	call   *%esi
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	4b                   	dec    %ebx
  8001f2:	75 f4                	jne    8001e8 <printnum+0x7c>
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  8001f4:	83 ec 10             	sub    $0x10,%esp
  8001f7:	ff 74 24 14          	pushl  0x14(%esp)
  8001fb:	ff 74 24 14          	pushl  0x14(%esp)
  8001ff:	ff 74 24 2c          	pushl  0x2c(%esp)
  800203:	ff 74 24 2c          	pushl  0x2c(%esp)
  800207:	e8 8c 1a 00 00       	call   801c98 <__umoddi3>
  80020c:	83 c4 14             	add    $0x14,%esp
  80020f:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800216:	50                   	push   %eax
  800217:	ff d6                	call   *%esi
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	ff 74 24 04          	pushl  0x4(%esp)
  800220:	ff 74 24 04          	pushl  0x4(%esp)
  800224:	ff 74 24 14          	pushl  0x14(%esp)
  800228:	ff 74 24 14          	pushl  0x14(%esp)
  80022c:	e8 67 1a 00 00       	call   801c98 <__umoddi3>
  800231:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800238:	89 44 24 50          	mov    %eax,0x50(%esp)
  80023c:	89 f0                	mov    %esi,%eax
}
  80023e:	83 c4 3c             	add    $0x3c,%esp
  800241:	5b                   	pop    %ebx
  800242:	5e                   	pop    %esi
  800243:	5f                   	pop    %edi
  800244:	5d                   	pop    %ebp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  800245:	ff e0                	jmp    *%eax
  800247:	90                   	nop
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800248:	76 1a                	jbe    800264 <printnum+0xf8>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80024a:	4b                   	dec    %ebx
  80024b:	85 db                	test   %ebx,%ebx
  80024d:	7e cd                	jle    80021c <printnum+0xb0>
  80024f:	0f be f9             	movsbl %cl,%edi
  800252:	66 90                	xchg   %ax,%ax
            putc(padc);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	57                   	push   %edi
  800258:	ff d6                	call   *%esi
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80025a:	83 c4 10             	add    $0x10,%esp
  80025d:	4b                   	dec    %ebx
  80025e:	75 f4                	jne    800254 <printnum+0xe8>
  800260:	eb ba                	jmp    80021c <printnum+0xb0>
  800262:	66 90                	xchg   %ax,%ax
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800264:	39 c7                	cmp    %eax,%edi
  800266:	0f 86 36 ff ff ff    	jbe    8001a2 <printnum+0x36>
  80026c:	eb dc                	jmp    80024a <printnum+0xde>
  80026e:	66 90                	xchg   %ax,%ax
  800270:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  800274:	ff 74 24 04          	pushl  0x4(%esp)
  800278:	ff 74 24 04          	pushl  0x4(%esp)
  80027c:	ff 74 24 1c          	pushl  0x1c(%esp)
  800280:	ff 74 24 1c          	pushl  0x1c(%esp)
  800284:	e8 ff 18 00 00       	call   801b88 <__udivdi3>
  800289:	83 c4 0c             	add    $0xc,%esp
  80028c:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  800290:	51                   	push   %ecx
  800291:	83 eb 02             	sub    $0x2,%ebx
  800294:	53                   	push   %ebx
  800295:	57                   	push   %edi
  800296:	89 d1                	mov    %edx,%ecx
  800298:	89 c2                	mov    %eax,%edx
  80029a:	89 f0                	mov    %esi,%eax
  80029c:	e8 cb fe ff ff       	call   80016c <printnum>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	e9 4b ff ff ff       	jmp    8001f4 <printnum+0x88>
  8002a9:	8d 76 00             	lea    0x0(%esi),%esi

008002ac <printfloat>:
    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
}

static void
printfloat(void (*putc)(char), long double real, int padc) {
  8002ac:	55                   	push   %ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 5c             	sub    $0x5c,%esp
  8002b3:	89 c3                	mov    %eax,%ebx
  8002b5:	db 6c 24 70          	fldt   0x70(%esp)
  8002b9:	89 d5                	mov    %edx,%ebp
    (void) padc;
    if (real < 0.0) {
  8002bb:	d9 ee                	fldz   
  8002bd:	dd e9                	fucomp %st(1)
  8002bf:	df e0                	fnstsw %ax
  8002c1:	f6 c4 45             	test   $0x45,%ah
  8002c4:	0f 84 ea 03 00 00    	je     8006b4 <printfloat+0x408>
        putc('-');
        real = -real;
    }
    unsigned long long integer = (unsigned long long) real;
  8002ca:	d9 05 d4 20 80 00    	flds   0x8020d4
  8002d0:	d9 c9                	fxch   %st(1)
  8002d2:	dd e1                	fucom  %st(1)
  8002d4:	df e0                	fnstsw %ax
  8002d6:	f6 c4 05             	test   $0x5,%ah
  8002d9:	0f 84 15 03 00 00    	je     8005f4 <printfloat+0x348>
  8002df:	dd d9                	fstp   %st(1)
  8002e1:	d9 7c 24 4e          	fnstcw 0x4e(%esp)
  8002e5:	66 8b 44 24 4e       	mov    0x4e(%esp),%ax
  8002ea:	b4 0c                	mov    $0xc,%ah
  8002ec:	66 89 44 24 4c       	mov    %ax,0x4c(%esp)
  8002f1:	d9 c0                	fld    %st(0)
  8002f3:	d9 6c 24 4c          	fldcw  0x4c(%esp)
  8002f7:	df 7c 24 40          	fistpll 0x40(%esp)
  8002fb:	d9 6c 24 4e          	fldcw  0x4e(%esp)
  8002ff:	8b 74 24 40          	mov    0x40(%esp),%esi
  800303:	8b 7c 24 44          	mov    0x44(%esp),%edi
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800307:	83 ff 00             	cmp    $0x0,%edi
  80030a:	0f 86 1d 03 00 00    	jbe    80062d <printfloat+0x381>
  800310:	db 7c 24 10          	fstpt  0x10(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  800314:	6a 00                	push   $0x0
  800316:	6a 0a                	push   $0xa
  800318:	57                   	push   %edi
  800319:	56                   	push   %esi
  80031a:	e8 69 18 00 00       	call   801b88 <__udivdi3>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	89 04 24             	mov    %eax,(%esp)
  800325:	89 54 24 04          	mov    %edx,0x4(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800329:	83 fa 00             	cmp    $0x0,%edx
  80032c:	db 6c 24 10          	fldt   0x10(%esp)
  800330:	0f 86 6e 03 00 00    	jbe    8006a4 <printfloat+0x3f8>
  800336:	db 7c 24 20          	fstpt  0x20(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  80033a:	6a 00                	push   $0x0
  80033c:	6a 64                	push   $0x64
  80033e:	57                   	push   %edi
  80033f:	56                   	push   %esi
  800340:	e8 43 18 00 00       	call   801b88 <__udivdi3>
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	89 44 24 10          	mov    %eax,0x10(%esp)
  80034c:	89 54 24 14          	mov    %edx,0x14(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800350:	83 fa 00             	cmp    $0x0,%edx
  800353:	db 6c 24 20          	fldt   0x20(%esp)
  800357:	0f 86 7f 03 00 00    	jbe    8006dc <printfloat+0x430>
  80035d:	db 7c 24 30          	fstpt  0x30(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  800361:	6a 00                	push   $0x0
  800363:	68 e8 03 00 00       	push   $0x3e8
  800368:	57                   	push   %edi
  800369:	56                   	push   %esi
  80036a:	e8 19 18 00 00       	call   801b88 <__udivdi3>
  80036f:	83 c4 10             	add    $0x10,%esp
  800372:	89 44 24 20          	mov    %eax,0x20(%esp)
  800376:	89 54 24 24          	mov    %edx,0x24(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80037a:	83 fa 00             	cmp    $0x0,%edx
  80037d:	db 6c 24 30          	fldt   0x30(%esp)
  800381:	0f 86 71 03 00 00    	jbe    8006f8 <printfloat+0x44c>
  800387:	db 7c 24 30          	fstpt  0x30(%esp)
        printnum(putc, num / base, base, width - 1, padc);
  80038b:	6a 00                	push   $0x0
  80038d:	68 10 27 00 00       	push   $0x2710
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	e8 ef 17 00 00       	call   801b88 <__udivdi3>
  800399:	83 c4 0c             	add    $0xc,%esp
  80039c:	55                   	push   %ebp
  80039d:	6a fc                	push   $0xfffffffc
  80039f:	6a 0a                	push   $0xa
  8003a1:	89 d1                	mov    %edx,%ecx
  8003a3:	89 c2                	mov    %eax,%edx
  8003a5:	89 d8                	mov    %ebx,%eax
  8003a7:	e8 c0 fd ff ff       	call   80016c <printnum>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	db 6c 24 30          	fldt   0x30(%esp)
  8003b3:	db 7c 24 30          	fstpt  0x30(%esp)
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  8003b7:	83 ec 10             	sub    $0x10,%esp
  8003ba:	6a 00                	push   $0x0
  8003bc:	6a 0a                	push   $0xa
  8003be:	ff 74 24 3c          	pushl  0x3c(%esp)
  8003c2:	ff 74 24 3c          	pushl  0x3c(%esp)
  8003c6:	e8 cd 18 00 00       	call   801c98 <__umoddi3>
  8003cb:	83 c4 14             	add    $0x14,%esp
  8003ce:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8003d5:	50                   	push   %eax
  8003d6:	ff d3                	call   *%ebx
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	db 6c 24 30          	fldt   0x30(%esp)
  8003df:	db 7c 24 20          	fstpt  0x20(%esp)
  8003e3:	83 ec 10             	sub    $0x10,%esp
  8003e6:	6a 00                	push   $0x0
  8003e8:	6a 0a                	push   $0xa
  8003ea:	ff 74 24 2c          	pushl  0x2c(%esp)
  8003ee:	ff 74 24 2c          	pushl  0x2c(%esp)
  8003f2:	e8 a1 18 00 00       	call   801c98 <__umoddi3>
  8003f7:	83 c4 14             	add    $0x14,%esp
  8003fa:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800401:	50                   	push   %eax
  800402:	ff d3                	call   *%ebx
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	db 6c 24 20          	fldt   0x20(%esp)
  80040b:	db 7c 24 10          	fstpt  0x10(%esp)
  80040f:	83 ec 10             	sub    $0x10,%esp
  800412:	6a 00                	push   $0x0
  800414:	6a 0a                	push   $0xa
  800416:	ff 74 24 1c          	pushl  0x1c(%esp)
  80041a:	ff 74 24 1c          	pushl  0x1c(%esp)
  80041e:	e8 75 18 00 00       	call   801c98 <__umoddi3>
  800423:	83 c4 14             	add    $0x14,%esp
  800426:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  80042d:	50                   	push   %eax
  80042e:	ff d3                	call   *%ebx
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	db 6c 24 10          	fldt   0x10(%esp)
  800437:	db 7c 24 10          	fstpt  0x10(%esp)
  80043b:	83 ec 10             	sub    $0x10,%esp
  80043e:	6a 00                	push   $0x0
  800440:	6a 0a                	push   $0xa
  800442:	57                   	push   %edi
  800443:	56                   	push   %esi
  800444:	e8 4f 18 00 00       	call   801c98 <__umoddi3>
  800449:	83 c4 14             	add    $0x14,%esp
  80044c:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800453:	50                   	push   %eax
  800454:	ff d3                	call   *%ebx
        putc('-');
        real = -real;
    }
    unsigned long long integer = (unsigned long long) real;
    printnum(putc, integer, 10, 0, padc);
    long double fraction = real - integer;
  800456:	89 74 24 10          	mov    %esi,0x10(%esp)
  80045a:	89 7c 24 14          	mov    %edi,0x14(%esp)
  80045e:	df 6c 24 10          	fildll 0x10(%esp)
  800462:	83 c4 10             	add    $0x10,%esp
  800465:	85 ff                	test   %edi,%edi
  800467:	db 6c 24 10          	fldt   0x10(%esp)
  80046b:	0f 88 13 02 00 00    	js     800684 <printfloat+0x3d8>
  800471:	de e1                	fsubp  %st,%st(1)
  800473:	db 3c 24             	fstpt  (%esp)
    putc('.');
  800476:	83 ec 0c             	sub    $0xc,%esp
  800479:	6a 2e                	push   $0x2e
  80047b:	ff d3                	call   *%ebx
    for (int i = 0; i < 8; ++i)
        fraction *= 10;
  80047d:	d9 05 dc 20 80 00    	flds   0x8020dc
  800483:	db 6c 24 10          	fldt   0x10(%esp)
  800487:	d8 c9                	fmul   %st(1),%st
  800489:	d8 c9                	fmul   %st(1),%st
  80048b:	d8 c9                	fmul   %st(1),%st
  80048d:	d8 c9                	fmul   %st(1),%st
  80048f:	d8 c9                	fmul   %st(1),%st
  800491:	d8 c9                	fmul   %st(1),%st
  800493:	d8 c9                	fmul   %st(1),%st
    integer = (unsigned long long) fraction;
  800495:	de c9                	fmulp  %st,%st(1)
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	d9 05 d4 20 80 00    	flds   0x8020d4
  8004a0:	d9 c9                	fxch   %st(1)
  8004a2:	dd e1                	fucom  %st(1)
  8004a4:	df e0                	fnstsw %ax
  8004a6:	f6 c4 05             	test   $0x5,%ah
  8004a9:	0f 84 8d 01 00 00    	je     80063c <printfloat+0x390>
  8004af:	dd d9                	fstp   %st(1)
  8004b1:	d9 7c 24 4e          	fnstcw 0x4e(%esp)
  8004b5:	66 8b 44 24 4e       	mov    0x4e(%esp),%ax
  8004ba:	b4 0c                	mov    $0xc,%ah
  8004bc:	66 89 44 24 4c       	mov    %ax,0x4c(%esp)
  8004c1:	d9 6c 24 4c          	fldcw  0x4c(%esp)
  8004c5:	df 7c 24 40          	fistpll 0x40(%esp)
  8004c9:	d9 6c 24 4e          	fldcw  0x4e(%esp)
  8004cd:	8b 74 24 40          	mov    0x40(%esp),%esi
  8004d1:	8b 7c 24 44          	mov    0x44(%esp),%edi
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8004d5:	83 ff 00             	cmp    $0x0,%edi
  8004d8:	0f 86 95 01 00 00    	jbe    800673 <printfloat+0x3c7>
        printnum(putc, num / base, base, width - 1, padc);
  8004de:	6a 00                	push   $0x0
  8004e0:	6a 0a                	push   $0xa
  8004e2:	57                   	push   %edi
  8004e3:	56                   	push   %esi
  8004e4:	e8 9f 16 00 00       	call   801b88 <__udivdi3>
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	89 04 24             	mov    %eax,(%esp)
  8004ef:	89 54 24 04          	mov    %edx,0x4(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8004f3:	83 fa 00             	cmp    $0x0,%edx
  8004f6:	0f 86 98 01 00 00    	jbe    800694 <printfloat+0x3e8>
        printnum(putc, num / base, base, width - 1, padc);
  8004fc:	6a 00                	push   $0x0
  8004fe:	6a 64                	push   $0x64
  800500:	57                   	push   %edi
  800501:	56                   	push   %esi
  800502:	e8 81 16 00 00       	call   801b88 <__udivdi3>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80050e:	89 54 24 14          	mov    %edx,0x14(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800512:	83 fa 00             	cmp    $0x0,%edx
  800515:	0f 86 b1 01 00 00    	jbe    8006cc <printfloat+0x420>
        printnum(putc, num / base, base, width - 1, padc);
  80051b:	6a 00                	push   $0x0
  80051d:	68 e8 03 00 00       	push   $0x3e8
  800522:	57                   	push   %edi
  800523:	56                   	push   %esi
  800524:	e8 5f 16 00 00       	call   801b88 <__udivdi3>
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	89 44 24 20          	mov    %eax,0x20(%esp)
  800530:	89 54 24 24          	mov    %edx,0x24(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800534:	83 fa 00             	cmp    $0x0,%edx
  800537:	0f 86 ad 01 00 00    	jbe    8006ea <printfloat+0x43e>
        printnum(putc, num / base, base, width - 1, padc);
  80053d:	6a 00                	push   $0x0
  80053f:	68 10 27 00 00       	push   $0x2710
  800544:	57                   	push   %edi
  800545:	56                   	push   %esi
  800546:	e8 3d 16 00 00       	call   801b88 <__udivdi3>
  80054b:	83 c4 0c             	add    $0xc,%esp
  80054e:	55                   	push   %ebp
  80054f:	6a fc                	push   $0xfffffffc
  800551:	6a 0a                	push   $0xa
  800553:	89 d1                	mov    %edx,%ecx
  800555:	89 c2                	mov    %eax,%edx
  800557:	89 d8                	mov    %ebx,%eax
  800559:	e8 0e fc ff ff       	call   80016c <printnum>
  80055e:	83 c4 10             	add    $0x10,%esp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  800561:	83 ec 10             	sub    $0x10,%esp
  800564:	6a 00                	push   $0x0
  800566:	6a 0a                	push   $0xa
  800568:	ff 74 24 3c          	pushl  0x3c(%esp)
  80056c:	ff 74 24 3c          	pushl  0x3c(%esp)
  800570:	e8 23 17 00 00       	call   801c98 <__umoddi3>
  800575:	83 c4 14             	add    $0x14,%esp
  800578:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  80057f:	50                   	push   %eax
  800580:	ff d3                	call   *%ebx
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	83 ec 10             	sub    $0x10,%esp
  800588:	6a 00                	push   $0x0
  80058a:	6a 0a                	push   $0xa
  80058c:	ff 74 24 2c          	pushl  0x2c(%esp)
  800590:	ff 74 24 2c          	pushl  0x2c(%esp)
  800594:	e8 ff 16 00 00       	call   801c98 <__umoddi3>
  800599:	83 c4 14             	add    $0x14,%esp
  80059c:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8005a3:	50                   	push   %eax
  8005a4:	ff d3                	call   *%ebx
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	83 ec 10             	sub    $0x10,%esp
  8005ac:	6a 00                	push   $0x0
  8005ae:	6a 0a                	push   $0xa
  8005b0:	ff 74 24 1c          	pushl  0x1c(%esp)
  8005b4:	ff 74 24 1c          	pushl  0x1c(%esp)
  8005b8:	e8 db 16 00 00       	call   801c98 <__umoddi3>
  8005bd:	83 c4 14             	add    $0x14,%esp
  8005c0:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8005c7:	50                   	push   %eax
  8005c8:	ff d3                	call   *%ebx
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	6a 00                	push   $0x0
  8005cf:	6a 0a                	push   $0xa
  8005d1:	57                   	push   %edi
  8005d2:	56                   	push   %esi
  8005d3:	e8 c0 16 00 00       	call   801c98 <__umoddi3>
  8005d8:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8005df:	89 84 24 80 00 00 00 	mov    %eax,0x80(%esp)
  8005e6:	89 d8                	mov    %ebx,%eax
    putc('.');
    for (int i = 0; i < 8; ++i)
        fraction *= 10;
    integer = (unsigned long long) fraction;
    printnum(putc, integer, 10, 0, padc);
}
  8005e8:	83 c4 6c             	add    $0x6c,%esp
  8005eb:	5b                   	pop    %ebx
  8005ec:	5e                   	pop    %esi
  8005ed:	5f                   	pop    %edi
  8005ee:	5d                   	pop    %ebp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  8005ef:	ff e0                	jmp    *%eax
  8005f1:	8d 76 00             	lea    0x0(%esi),%esi
    (void) padc;
    if (real < 0.0) {
        putc('-');
        real = -real;
    }
    unsigned long long integer = (unsigned long long) real;
  8005f4:	dc e1                	fsub   %st,%st(1)
  8005f6:	d9 c9                	fxch   %st(1)
  8005f8:	d9 7c 24 4e          	fnstcw 0x4e(%esp)
  8005fc:	66 8b 44 24 4e       	mov    0x4e(%esp),%ax
  800601:	b4 0c                	mov    $0xc,%ah
  800603:	66 89 44 24 4c       	mov    %ax,0x4c(%esp)
  800608:	d9 6c 24 4c          	fldcw  0x4c(%esp)
  80060c:	df 7c 24 40          	fistpll 0x40(%esp)
  800610:	d9 6c 24 4e          	fldcw  0x4e(%esp)
  800614:	8b 74 24 40          	mov    0x40(%esp),%esi
  800618:	8b 7c 24 44          	mov    0x44(%esp),%edi
  80061c:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
  800622:	89 c7                	mov    %eax,%edi
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800624:	83 ff 00             	cmp    $0x0,%edi
  800627:	0f 87 e3 fc ff ff    	ja     800310 <printfloat+0x64>
  80062d:	83 fe 09             	cmp    $0x9,%esi
  800630:	0f 86 01 fe ff ff    	jbe    800437 <printfloat+0x18b>
  800636:	e9 d5 fc ff ff       	jmp    800310 <printfloat+0x64>
  80063b:	90                   	nop
    printnum(putc, integer, 10, 0, padc);
    long double fraction = real - integer;
    putc('.');
    for (int i = 0; i < 8; ++i)
        fraction *= 10;
    integer = (unsigned long long) fraction;
  80063c:	de e1                	fsubp  %st,%st(1)
  80063e:	d9 7c 24 4e          	fnstcw 0x4e(%esp)
  800642:	66 8b 44 24 4e       	mov    0x4e(%esp),%ax
  800647:	b4 0c                	mov    $0xc,%ah
  800649:	66 89 44 24 4c       	mov    %ax,0x4c(%esp)
  80064e:	d9 6c 24 4c          	fldcw  0x4c(%esp)
  800652:	df 7c 24 40          	fistpll 0x40(%esp)
  800656:	d9 6c 24 4e          	fldcw  0x4e(%esp)
  80065a:	8b 74 24 40          	mov    0x40(%esp),%esi
  80065e:	8b 7c 24 44          	mov    0x44(%esp),%edi
  800662:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
  800668:	89 c7                	mov    %eax,%edi
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80066a:	83 ff 00             	cmp    $0x0,%edi
  80066d:	0f 87 6b fe ff ff    	ja     8004de <printfloat+0x232>
  800673:	83 fe 09             	cmp    $0x9,%esi
  800676:	0f 86 51 ff ff ff    	jbe    8005cd <printfloat+0x321>
  80067c:	e9 5d fe ff ff       	jmp    8004de <printfloat+0x232>
  800681:	8d 76 00             	lea    0x0(%esi),%esi
  800684:	d9 c9                	fxch   %st(1)
        putc('-');
        real = -real;
    }
    unsigned long long integer = (unsigned long long) real;
    printnum(putc, integer, 10, 0, padc);
    long double fraction = real - integer;
  800686:	d8 05 d8 20 80 00    	fadds  0x8020d8
  80068c:	d9 c9                	fxch   %st(1)
  80068e:	e9 de fd ff ff       	jmp    800471 <printfloat+0x1c5>
  800693:	90                   	nop
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800694:	83 f8 09             	cmp    $0x9,%eax
  800697:	0f 86 0c ff ff ff    	jbe    8005a9 <printfloat+0x2fd>
  80069d:	e9 5a fe ff ff       	jmp    8004fc <printfloat+0x250>
  8006a2:	66 90                	xchg   %ax,%ax
  8006a4:	83 f8 09             	cmp    $0x9,%eax
  8006a7:	0f 86 5e fd ff ff    	jbe    80040b <printfloat+0x15f>
  8006ad:	e9 84 fc ff ff       	jmp    800336 <printfloat+0x8a>
  8006b2:	66 90                	xchg   %ax,%ax
  8006b4:	db 3c 24             	fstpt  (%esp)

static void
printfloat(void (*putc)(char), long double real, int padc) {
    (void) padc;
    if (real < 0.0) {
        putc('-');
  8006b7:	83 ec 0c             	sub    $0xc,%esp
  8006ba:	6a 2d                	push   $0x2d
  8006bc:	ff d3                	call   *%ebx
        real = -real;
  8006be:	db 6c 24 10          	fldt   0x10(%esp)
  8006c2:	d9 e0                	fchs   
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	e9 fe fb ff ff       	jmp    8002ca <printfloat+0x1e>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8006cc:	83 f8 09             	cmp    $0x9,%eax
  8006cf:	0f 86 b0 fe ff ff    	jbe    800585 <printfloat+0x2d9>
  8006d5:	e9 41 fe ff ff       	jmp    80051b <printfloat+0x26f>
  8006da:	66 90                	xchg   %ax,%ax
  8006dc:	83 f8 09             	cmp    $0x9,%eax
  8006df:	0f 86 fa fc ff ff    	jbe    8003df <printfloat+0x133>
  8006e5:	e9 73 fc ff ff       	jmp    80035d <printfloat+0xb1>
  8006ea:	83 f8 09             	cmp    $0x9,%eax
  8006ed:	0f 86 6e fe ff ff    	jbe    800561 <printfloat+0x2b5>
  8006f3:	e9 45 fe ff ff       	jmp    80053d <printfloat+0x291>
  8006f8:	83 f8 09             	cmp    $0x9,%eax
  8006fb:	0f 86 b2 fc ff ff    	jbe    8003b3 <printfloat+0x107>
  800701:	e9 81 fc ff ff       	jmp    800387 <printfloat+0xdb>
  800706:	66 90                	xchg   %ax,%ax

00800708 <vprintfmt.constprop.1>:

// Main function to format and print a string.
void printfmt(void (*putc)(char), const char* fmt, ...);

void
vprintfmt(void (*putc)(char), const char* fmt, va_list ap) {
  800708:	55                   	push   %ebp
  800709:	57                   	push   %edi
  80070a:	56                   	push   %esi
  80070b:	53                   	push   %ebx
  80070c:	83 ec 3c             	sub    $0x3c,%esp
  80070f:	89 c5                	mov    %eax,%ebp
  800711:	89 54 24 04          	mov    %edx,0x4(%esp)
    long double real;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
  800715:	8d 5d 01             	lea    0x1(%ebp),%ebx
  800718:	0f be 45 00          	movsbl 0x0(%ebp),%eax
  80071c:	3c 25                	cmp    $0x25,%al
  80071e:	75 19                	jne    800739 <vprintfmt.constprop.1+0x31>
  800720:	eb 26                	jmp    800748 <vprintfmt.constprop.1+0x40>
  800722:	66 90                	xchg   %ax,%ax
            if (ch == '\0')
                return;
            putc(ch);
  800724:	83 ec 0c             	sub    $0xc,%esp
  800727:	50                   	push   %eax
  800728:	e8 27 14 00 00       	call   801b54 <putc>
    long double real;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
  80072d:	43                   	inc    %ebx
  80072e:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	3c 25                	cmp    $0x25,%al
  800737:	74 0f                	je     800748 <vprintfmt.constprop.1+0x40>
            if (ch == '\0')
  800739:	84 c0                	test   %al,%al
  80073b:	75 e7                	jne    800724 <vprintfmt.constprop.1+0x1c>
                for (fmt--; fmt[-1] != '%'; fmt--)
                    /* do nothing */;
                break;
        }
    }
}
  80073d:	83 c4 3c             	add    $0x3c,%esp
  800740:	5b                   	pop    %ebx
  800741:	5e                   	pop    %esi
  800742:	5f                   	pop    %edi
  800743:	5d                   	pop    %ebp
  800744:	c3                   	ret    
  800745:	8d 76 00             	lea    0x0(%esi),%esi
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
  800748:	c6 44 24 08 20       	movb   $0x20,0x8(%esp)
  80074d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800754:	00 
  800755:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  80075a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80075f:	31 c9                	xor    %ecx,%ecx
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800761:	8d 6b 01             	lea    0x1(%ebx),%ebp
  800764:	0f be 13             	movsbl (%ebx),%edx
  800767:	8d 42 dd             	lea    -0x23(%edx),%eax
  80076a:	3c 55                	cmp    $0x55,%al
  80076c:	0f 87 41 05 00 00    	ja     800cb3 <vprintfmt.constprop.1+0x5ab>
  800772:	0f b6 c0             	movzbl %al,%eax
  800775:	ff 24 85 24 1e 80 00 	jmp    *0x801e24(,%eax,4)
  80077c:	89 eb                	mov    %ebp,%ebx
                padc = '-';
                goto reswitch;

            // flag to pad with 0's instead of spaces
            case '0':
                padc = '0';
  80077e:	c6 44 24 08 30       	movb   $0x30,0x8(%esp)
  800783:	eb dc                	jmp    800761 <vprintfmt.constprop.1+0x59>
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
                    precision = precision * 10 + ch - '0';
  800785:	8d 7a d0             	lea    -0x30(%edx),%edi
                    ch = *fmt;
  800788:	0f be 43 01          	movsbl 0x1(%ebx),%eax
                    if (ch < '0' || ch > '9')
  80078c:	8d 50 d0             	lea    -0x30(%eax),%edx
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  80078f:	89 eb                	mov    %ebp,%ebx
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
                    precision = precision * 10 + ch - '0';
                    ch = *fmt;
                    if (ch < '0' || ch > '9')
  800791:	80 fa 09             	cmp    $0x9,%dl
  800794:	0f 87 b7 04 00 00    	ja     800c51 <vprintfmt.constprop.1+0x549>
  80079a:	66 90                	xchg   %ax,%ax
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
  80079c:	43                   	inc    %ebx
                    precision = precision * 10 + ch - '0';
  80079d:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  8007a0:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
                    ch = *fmt;
  8007a4:	0f be 03             	movsbl (%ebx),%eax
                    if (ch < '0' || ch > '9')
  8007a7:	8d 50 d0             	lea    -0x30(%eax),%edx
  8007aa:	80 fa 09             	cmp    $0x9,%dl
  8007ad:	76 ed                	jbe    80079c <vprintfmt.constprop.1+0x94>
  8007af:	e9 9d 04 00 00       	jmp    800c51 <vprintfmt.constprop.1+0x549>
                lflag++;
                goto reswitch;

            // character
            case 'c':
                putc(va_arg(ap, int));
  8007b4:	8b 44 24 04          	mov    0x4(%esp),%eax
  8007b8:	8d 58 04             	lea    0x4(%eax),%ebx
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	0f be 00             	movsbl (%eax),%eax
  8007c1:	50                   	push   %eax
  8007c2:	e8 8d 13 00 00       	call   801b54 <putc>
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007ce:	e9 42 ff ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
  8007d3:	49                   	dec    %ecx
        return va_arg(*ap, long long);
  8007d4:	8b 4c 24 04          	mov    0x4(%esp),%ecx

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
  8007d8:	0f 8e f4 05 00 00    	jle    800dd2 <vprintfmt.constprop.1+0x6ca>
        return va_arg(*ap, long long);
  8007de:	8b 51 04             	mov    0x4(%ecx),%edx
  8007e1:	8b 01                	mov    (%ecx),%eax
  8007e3:	83 c1 08             	add    $0x8,%ecx
  8007e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
                    putc(' ');
                break;

            // (signed) decimal
            case 'd':
                num = getint(&ap, lflag);
  8007ea:	89 44 24 18          	mov    %eax,0x18(%esp)
  8007ee:	89 54 24 1c          	mov    %edx,0x1c(%esp)
                if ((long long) num < 0) {
  8007f2:	85 d2                	test   %edx,%edx
  8007f4:	0f 88 13 06 00 00    	js     800e0d <vprintfmt.constprop.1+0x705>
  8007fa:	c7 44 24 10 0a 00 00 	movl   $0xa,0x10(%esp)
  800801:	00 
  800802:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800809:	00 
  80080a:	bf 0a 00 00 00       	mov    $0xa,%edi
            // (unsigned) hexadecimal
            case 'x':
                num = getuint(&ap, lflag);
                base = 16;
number:
                printnum(putc, num, base, width, padc);
  80080f:	0f be 5c 24 08       	movsbl 0x8(%esp),%ebx
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800814:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  800818:	39 ca                	cmp    %ecx,%edx
  80081a:	0f 86 ed 02 00 00    	jbe    800b0d <vprintfmt.constprop.1+0x405>
        printnum(putc, num / base, base, width - 1, padc);
  800820:	ff 74 24 14          	pushl  0x14(%esp)
  800824:	ff 74 24 14          	pushl  0x14(%esp)
  800828:	ff 74 24 24          	pushl  0x24(%esp)
  80082c:	ff 74 24 24          	pushl  0x24(%esp)
  800830:	e8 53 13 00 00       	call   801b88 <__udivdi3>
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800840:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  800844:	39 ca                	cmp    %ecx,%edx
  800846:	77 12                	ja     80085a <vprintfmt.constprop.1+0x152>
  800848:	0f 82 12 05 00 00    	jb     800d60 <vprintfmt.constprop.1+0x658>
  80084e:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  800852:	39 c8                	cmp    %ecx,%eax
  800854:	0f 82 06 05 00 00    	jb     800d60 <vprintfmt.constprop.1+0x658>
        printnum(putc, num / base, base, width - 1, padc);
  80085a:	ff 74 24 14          	pushl  0x14(%esp)
  80085e:	ff 74 24 14          	pushl  0x14(%esp)
  800862:	ff 74 24 14          	pushl  0x14(%esp)
  800866:	ff 74 24 14          	pushl  0x14(%esp)
  80086a:	e8 19 13 00 00       	call   801b88 <__udivdi3>
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	89 44 24 20          	mov    %eax,0x20(%esp)
  800876:	89 54 24 24          	mov    %edx,0x24(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80087a:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  80087e:	39 ca                	cmp    %ecx,%edx
  800880:	0f 86 a6 05 00 00    	jbe    800e2c <vprintfmt.constprop.1+0x724>
        printnum(putc, num / base, base, width - 1, padc);
  800886:	ff 74 24 14          	pushl  0x14(%esp)
  80088a:	ff 74 24 14          	pushl  0x14(%esp)
  80088e:	ff 74 24 2c          	pushl  0x2c(%esp)
  800892:	ff 74 24 2c          	pushl  0x2c(%esp)
  800896:	e8 ed 12 00 00       	call   801b88 <__udivdi3>
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	89 44 24 28          	mov    %eax,0x28(%esp)
  8008a2:	89 54 24 2c          	mov    %edx,0x2c(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8008a6:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  8008aa:	39 ca                	cmp    %ecx,%edx
  8008ac:	0f 86 cf 05 00 00    	jbe    800e81 <vprintfmt.constprop.1+0x779>
        printnum(putc, num / base, base, width - 1, padc);
  8008b2:	ff 74 24 14          	pushl  0x14(%esp)
  8008b6:	ff 74 24 14          	pushl  0x14(%esp)
  8008ba:	ff 74 24 34          	pushl  0x34(%esp)
  8008be:	ff 74 24 34          	pushl  0x34(%esp)
  8008c2:	e8 c1 12 00 00       	call   801b88 <__udivdi3>
  8008c7:	83 c4 08             	add    $0x8,%esp
  8008ca:	53                   	push   %ebx
  8008cb:	8d 4e fc             	lea    -0x4(%esi),%ecx
  8008ce:	51                   	push   %ecx
  8008cf:	89 f9                	mov    %edi,%ecx
  8008d1:	e8 7e f7 ff ff       	call   800054 <printnum.constprop.2>
  8008d6:	83 c4 10             	add    $0x10,%esp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  8008d9:	83 ec 10             	sub    $0x10,%esp
  8008dc:	ff 74 24 24          	pushl  0x24(%esp)
  8008e0:	ff 74 24 24          	pushl  0x24(%esp)
  8008e4:	ff 74 24 44          	pushl  0x44(%esp)
  8008e8:	ff 74 24 44          	pushl  0x44(%esp)
  8008ec:	e8 a7 13 00 00       	call   801c98 <__umoddi3>
  8008f1:	83 c4 14             	add    $0x14,%esp
  8008f4:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8008fb:	50                   	push   %eax
  8008fc:	e8 53 12 00 00       	call   801b54 <putc>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	83 ec 10             	sub    $0x10,%esp
  800907:	ff 74 24 24          	pushl  0x24(%esp)
  80090b:	ff 74 24 24          	pushl  0x24(%esp)
  80090f:	ff 74 24 3c          	pushl  0x3c(%esp)
  800913:	ff 74 24 3c          	pushl  0x3c(%esp)
  800917:	e8 7c 13 00 00       	call   801c98 <__umoddi3>
  80091c:	83 c4 14             	add    $0x14,%esp
  80091f:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800926:	50                   	push   %eax
  800927:	e8 28 12 00 00       	call   801b54 <putc>
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	83 ec 10             	sub    $0x10,%esp
  800932:	ff 74 24 24          	pushl  0x24(%esp)
  800936:	ff 74 24 24          	pushl  0x24(%esp)
  80093a:	ff 74 24 24          	pushl  0x24(%esp)
  80093e:	ff 74 24 24          	pushl  0x24(%esp)
  800942:	e8 51 13 00 00       	call   801c98 <__umoddi3>
  800947:	83 c4 14             	add    $0x14,%esp
  80094a:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800951:	50                   	push   %eax
  800952:	e8 fd 11 00 00       	call   801b54 <putc>
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	83 ec 10             	sub    $0x10,%esp
  80095d:	ff 74 24 24          	pushl  0x24(%esp)
  800961:	ff 74 24 24          	pushl  0x24(%esp)
  800965:	ff 74 24 34          	pushl  0x34(%esp)
  800969:	ff 74 24 34          	pushl  0x34(%esp)
  80096d:	e8 26 13 00 00       	call   801c98 <__umoddi3>
  800972:	83 c4 14             	add    $0x14,%esp
  800975:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  80097c:	50                   	push   %eax
  80097d:	e8 d2 11 00 00       	call   801b54 <putc>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	e9 8b fd ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>
}

static long double
getfloat(va_list* ap, int lflag) {
    if (lflag)
        return va_arg(*ap, long double);
  80098a:	8b 44 24 04          	mov    0x4(%esp),%eax
        return va_arg(*ap, int);
}

static long double
getfloat(va_list* ap, int lflag) {
    if (lflag)
  80098e:	85 c9                	test   %ecx,%ecx
  800990:	0f 84 a6 03 00 00    	je     800d3c <vprintfmt.constprop.1+0x634>
        return va_arg(*ap, long double);
  800996:	db 28                	fldt   (%eax)
  800998:	83 c0 0c             	add    $0xc,%eax
  80099b:	89 44 24 04          	mov    %eax,0x4(%esp)
                printnum(putc, num, base, width, padc);
                break;

            case 'f':
                real = getfloat(&ap, lflag);
                printfloat(putc, real, padc);
  80099f:	0f be 54 24 08       	movsbl 0x8(%esp),%edx
  8009a4:	83 ec 10             	sub    $0x10,%esp
  8009a7:	db 3c 24             	fstpt  (%esp)
  8009aa:	b8 54 1b 80 00       	mov    $0x801b54,%eax
  8009af:	e8 f8 f8 ff ff       	call   8002ac <printfloat>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	e9 59 fd ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
  8009bc:	49                   	dec    %ecx
  8009bd:	0f 8e f1 03 00 00    	jle    800db4 <vprintfmt.constprop.1+0x6ac>
        return va_arg(*ap, unsigned long long);
  8009c3:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  8009c7:	8b 51 04             	mov    0x4(%ecx),%edx
  8009ca:	8b 01                	mov    (%ecx),%eax
  8009cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009d0:	89 54 24 14          	mov    %edx,0x14(%esp)
  8009d4:	89 c8                	mov    %ecx,%eax
  8009d6:	83 c0 08             	add    $0x8,%eax
  8009d9:	89 44 24 04          	mov    %eax,0x4(%esp)

            // (unsigned) octal
            case 'o':
                num = getuint(&ap, lflag);
                base = 8;
                printnum(putc, num, base, width, padc);
  8009dd:	0f be 5c 24 08       	movsbl 0x8(%esp),%ebx
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8009e2:	8b 44 24 10          	mov    0x10(%esp),%eax
  8009e6:	8b 54 24 14          	mov    0x14(%esp),%edx
  8009ea:	83 fa 00             	cmp    $0x0,%edx
  8009ed:	0f 86 22 03 00 00    	jbe    800d15 <vprintfmt.constprop.1+0x60d>
        printnum(putc, num / base, base, width - 1, padc);
  8009f3:	0f ac d0 03          	shrd   $0x3,%edx,%eax
  8009f7:	c1 ea 03             	shr    $0x3,%edx
  8009fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800a02:	83 fa 00             	cmp    $0x0,%edx
  800a05:	77 09                	ja     800a10 <vprintfmt.constprop.1+0x308>
  800a07:	83 f8 07             	cmp    $0x7,%eax
  800a0a:	0f 86 d1 03 00 00    	jbe    800de1 <vprintfmt.constprop.1+0x6d9>
        printnum(putc, num / base, base, width - 1, padc);
  800a10:	8b 44 24 10          	mov    0x10(%esp),%eax
  800a14:	8b 54 24 14          	mov    0x14(%esp),%edx
  800a18:	0f ac d0 06          	shrd   $0x6,%edx,%eax
  800a1c:	c1 ea 06             	shr    $0x6,%edx
  800a1f:	89 44 24 18          	mov    %eax,0x18(%esp)
  800a23:	89 54 24 1c          	mov    %edx,0x1c(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800a27:	83 fa 00             	cmp    $0x0,%edx
  800a2a:	0f 86 29 04 00 00    	jbe    800e59 <vprintfmt.constprop.1+0x751>
        printnum(putc, num / base, base, width - 1, padc);
  800a30:	8b 44 24 10          	mov    0x10(%esp),%eax
  800a34:	8b 54 24 14          	mov    0x14(%esp),%edx
  800a38:	0f ac d0 09          	shrd   $0x9,%edx,%eax
  800a3c:	c1 ea 09             	shr    $0x9,%edx
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	53                   	push   %ebx
  800a43:	8d 4e fd             	lea    -0x3(%esi),%ecx
  800a46:	51                   	push   %ecx
  800a47:	b9 08 00 00 00       	mov    $0x8,%ecx
  800a4c:	e8 03 f6 ff ff       	call   800054 <printnum.constprop.2>
  800a51:	83 c4 10             	add    $0x10,%esp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  800a54:	83 ec 0c             	sub    $0xc,%esp
  800a57:	8b 74 24 24          	mov    0x24(%esp),%esi
  800a5b:	83 e6 07             	and    $0x7,%esi
  800a5e:	0f be 86 0a 1e 80 00 	movsbl 0x801e0a(%esi),%eax
  800a65:	50                   	push   %eax
  800a66:	e8 e9 10 00 00       	call   801b54 <putc>
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	83 ec 0c             	sub    $0xc,%esp
  800a71:	8b 44 24 14          	mov    0x14(%esp),%eax
  800a75:	83 e0 07             	and    $0x7,%eax
  800a78:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800a7f:	50                   	push   %eax
  800a80:	e8 cf 10 00 00       	call   801b54 <putc>
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	83 ec 0c             	sub    $0xc,%esp
  800a8b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  800a8f:	83 e0 07             	and    $0x7,%eax
  800a92:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  800a99:	50                   	push   %eax
  800a9a:	e8 b5 10 00 00       	call   801b54 <putc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	e9 6e fc ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>
                    width = precision, precision = -1;
                goto reswitch;

            // long flag (doubled for long long)
            case 'l':
                lflag++;
  800aa7:	41                   	inc    %ecx
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800aa8:	89 eb                	mov    %ebp,%ebx
  800aaa:	e9 b2 fc ff ff       	jmp    800761 <vprintfmt.constprop.1+0x59>
                printnum(putc, num, base, width, padc);
                break;

            // pointer
            case 'p':
                putc('0');
  800aaf:	83 ec 0c             	sub    $0xc,%esp
  800ab2:	6a 30                	push   $0x30
  800ab4:	e8 9b 10 00 00       	call   801b54 <putc>
                putc('x');
  800ab9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800ac0:	e8 8f 10 00 00       	call   801b54 <putc>
                num = (unsigned long long)
  800ac5:	8b 44 24 14          	mov    0x14(%esp),%eax
  800ac9:	8b 08                	mov    (%eax),%ecx
  800acb:	31 db                	xor    %ebx,%ebx
  800acd:	89 4c 24 28          	mov    %ecx,0x28(%esp)
  800ad1:	89 5c 24 2c          	mov    %ebx,0x2c(%esp)
  800ad5:	83 c4 10             	add    $0x10,%esp
                      (size_t) va_arg(ap, void*);
  800ad8:	83 c0 04             	add    $0x4,%eax
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
  800adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800adf:	c7 44 24 10 10 00 00 	movl   $0x10,0x10(%esp)
  800ae6:	00 
  800ae7:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800aee:	00 
  800aef:	bf 10 00 00 00       	mov    $0x10,%edi
  800af4:	8b 44 24 18          	mov    0x18(%esp),%eax
  800af8:	8b 54 24 1c          	mov    0x1c(%esp),%edx
            // (unsigned) hexadecimal
            case 'x':
                num = getuint(&ap, lflag);
                base = 16;
number:
                printnum(putc, num, base, width, padc);
  800afc:	0f be 5c 24 08       	movsbl 0x8(%esp),%ebx
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800b01:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  800b05:	39 ca                	cmp    %ecx,%edx
  800b07:	0f 87 13 fd ff ff    	ja     800820 <vprintfmt.constprop.1+0x118>
  800b0d:	72 0c                	jb     800b1b <vprintfmt.constprop.1+0x413>
  800b0f:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  800b13:	39 c8                	cmp    %ecx,%eax
  800b15:	0f 83 05 fd ff ff    	jae    800820 <vprintfmt.constprop.1+0x118>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800b1b:	4e                   	dec    %esi
  800b1c:	85 f6                	test   %esi,%esi
  800b1e:	0f 8e 36 fe ff ff    	jle    80095a <vprintfmt.constprop.1+0x252>
            putc(padc);
  800b24:	83 ec 0c             	sub    $0xc,%esp
  800b27:	53                   	push   %ebx
  800b28:	e8 27 10 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	4e                   	dec    %esi
  800b31:	75 f1                	jne    800b24 <vprintfmt.constprop.1+0x41c>
  800b33:	e9 22 fe ff ff       	jmp    80095a <vprintfmt.constprop.1+0x252>
                putc(va_arg(ap, int));
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
  800b38:	8b 44 24 04          	mov    0x4(%esp),%eax
  800b3c:	8d 48 04             	lea    0x4(%eax),%ecx
  800b3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	89 44 24 18          	mov    %eax,0x18(%esp)
  800b49:	85 c0                	test   %eax,%eax
  800b4b:	0f 84 af 02 00 00    	je     800e00 <vprintfmt.constprop.1+0x6f8>
                    p = "(null)";
                if (width > 0 && padc != '-')
  800b51:	85 f6                	test   %esi,%esi
  800b53:	7e 36                	jle    800b8b <vprintfmt.constprop.1+0x483>
  800b55:	8a 5c 24 08          	mov    0x8(%esp),%bl
  800b59:	80 fb 2d             	cmp    $0x2d,%bl
  800b5c:	0f 84 e8 01 00 00    	je     800d4a <vprintfmt.constprop.1+0x642>
                    for (width -= strlen(p); width > 0; width--)
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	ff 74 24 24          	pushl  0x24(%esp)
  800b69:	e8 62 0b 00 00       	call   8016d0 <strlen>
  800b6e:	29 c6                	sub    %eax,%esi
  800b70:	83 c4 10             	add    $0x10,%esp
  800b73:	85 f6                	test   %esi,%esi
  800b75:	7e 14                	jle    800b8b <vprintfmt.constprop.1+0x483>
  800b77:	0f be db             	movsbl %bl,%ebx
  800b7a:	66 90                	xchg   %ax,%ax
                        putc(padc);
  800b7c:	83 ec 0c             	sub    $0xc,%esp
  800b7f:	53                   	push   %ebx
  800b80:	e8 cf 0f 00 00       	call   801b54 <putc>
            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
  800b85:	83 c4 10             	add    $0x10,%esp
  800b88:	4e                   	dec    %esi
  800b89:	75 f1                	jne    800b7c <vprintfmt.constprop.1+0x474>
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8b:	8b 44 24 18          	mov    0x18(%esp),%eax
  800b8f:	8d 58 01             	lea    0x1(%eax),%ebx
  800b92:	0f be 00             	movsbl (%eax),%eax
  800b95:	84 c0                	test   %al,%al
  800b97:	0f 84 78 fb ff ff    	je     800715 <vprintfmt.constprop.1+0xd>
  800b9d:	8b 54 24 10          	mov    0x10(%esp),%edx
  800ba1:	85 d2                	test   %edx,%edx
  800ba3:	75 21                	jne    800bc6 <vprintfmt.constprop.1+0x4be>
  800ba5:	e9 2e 01 00 00       	jmp    800cd8 <vprintfmt.constprop.1+0x5d0>
  800baa:	66 90                	xchg   %ax,%ax
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
  800bac:	83 ec 0c             	sub    $0xc,%esp
  800baf:	50                   	push   %eax
  800bb0:	e8 9f 0f 00 00       	call   801b54 <putc>
  800bb5:	83 c4 10             	add    $0x10,%esp
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb8:	4e                   	dec    %esi
  800bb9:	43                   	inc    %ebx
  800bba:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  800bbe:	84 c0                	test   %al,%al
  800bc0:	0f 84 32 01 00 00    	je     800cf8 <vprintfmt.constprop.1+0x5f0>
  800bc6:	85 ff                	test   %edi,%edi
  800bc8:	78 0a                	js     800bd4 <vprintfmt.constprop.1+0x4cc>
  800bca:	4f                   	dec    %edi
  800bcb:	83 ff ff             	cmp    $0xffffffff,%edi
  800bce:	0f 84 24 01 00 00    	je     800cf8 <vprintfmt.constprop.1+0x5f0>
                    if (altflag && (ch < ' ' || ch > '~'))
  800bd4:	8d 50 e0             	lea    -0x20(%eax),%edx
  800bd7:	80 fa 5e             	cmp    $0x5e,%dl
  800bda:	76 d0                	jbe    800bac <vprintfmt.constprop.1+0x4a4>
                        putc('?');
  800bdc:	83 ec 0c             	sub    $0xc,%esp
  800bdf:	6a 3f                	push   $0x3f
  800be1:	e8 6e 0f 00 00       	call   801b54 <putc>
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	eb cd                	jmp    800bb8 <vprintfmt.constprop.1+0x4b0>

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
  800beb:	49                   	dec    %ecx
  800bec:	0f 8e a8 01 00 00    	jle    800d9a <vprintfmt.constprop.1+0x692>
        return va_arg(*ap, unsigned long long);
  800bf2:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  800bf6:	8b 51 04             	mov    0x4(%ecx),%edx
  800bf9:	8b 01                	mov    (%ecx),%eax
  800bfb:	89 44 24 18          	mov    %eax,0x18(%esp)
  800bff:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  800c03:	89 c8                	mov    %ecx,%eax
  800c05:	83 c0 08             	add    $0x8,%eax
  800c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c0c:	c7 44 24 10 0a 00 00 	movl   $0xa,0x10(%esp)
  800c13:	00 
  800c14:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800c1b:	00 
  800c1c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800c21:	8b 44 24 18          	mov    0x18(%esp),%eax
  800c25:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  800c29:	e9 e1 fb ff ff       	jmp    80080f <vprintfmt.constprop.1+0x107>
                printfloat(putc, real, padc);
                break;

            // escaped '%' character
            case '%':
                putc(ch);
  800c2e:	83 ec 0c             	sub    $0xc,%esp
  800c31:	0f be f2             	movsbl %dl,%esi
  800c34:	56                   	push   %esi
  800c35:	e8 1a 0f 00 00       	call   801b54 <putc>
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	e9 d3 fa ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>
                        break;
                }
                goto process_precision;

            case '*':
                precision = va_arg(ap, int);
  800c42:	8b 44 24 04          	mov    0x4(%esp),%eax
  800c46:	8b 38                	mov    (%eax),%edi
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800c4f:	89 eb                	mov    %ebp,%ebx
            case '#':
                altflag = 1;
                goto reswitch;

process_precision:
                if (width < 0)
  800c51:	85 f6                	test   %esi,%esi
  800c53:	0f 89 08 fb ff ff    	jns    800761 <vprintfmt.constprop.1+0x59>
                    width = precision, precision = -1;
  800c59:	89 fe                	mov    %edi,%esi
  800c5b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800c60:	e9 fc fa ff ff       	jmp    800761 <vprintfmt.constprop.1+0x59>

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
  800c65:	49                   	dec    %ecx
  800c66:	0f 8e 14 01 00 00    	jle    800d80 <vprintfmt.constprop.1+0x678>
        return va_arg(*ap, unsigned long long);
  800c6c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  800c70:	8b 51 04             	mov    0x4(%ecx),%edx
  800c73:	8b 01                	mov    (%ecx),%eax
  800c75:	89 44 24 18          	mov    %eax,0x18(%esp)
  800c79:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  800c7d:	89 c8                	mov    %ecx,%eax
  800c7f:	83 c0 08             	add    $0x8,%eax
  800c82:	e9 54 fe ff ff       	jmp    800adb <vprintfmt.constprop.1+0x3d3>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800c87:	89 eb                	mov    %ebp,%ebx
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
  800c89:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
  800c90:	00 
  800c91:	e9 cb fa ff ff       	jmp    800761 <vprintfmt.constprop.1+0x59>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800c96:	89 eb                	mov    %ebp,%ebx

            // flag to pad on the right
            case '-':
                padc = '-';
  800c98:	c6 44 24 08 2d       	movb   $0x2d,0x8(%esp)
  800c9d:	e9 bf fa ff ff       	jmp    800761 <vprintfmt.constprop.1+0x59>
  800ca2:	85 f6                	test   %esi,%esi
  800ca4:	0f 89 fe fd ff ff    	jns    800aa8 <vprintfmt.constprop.1+0x3a0>
  800caa:	31 f6                	xor    %esi,%esi
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800cac:	89 eb                	mov    %ebp,%ebx
  800cae:	e9 ae fa ff ff       	jmp    800761 <vprintfmt.constprop.1+0x59>
                putc(ch);
                break;

            // unrecognized escape sequence - just print it literally
            default:
                putc('%');
  800cb3:	83 ec 0c             	sub    $0xc,%esp
  800cb6:	6a 25                	push   $0x25
  800cb8:	e8 97 0e 00 00       	call   801b54 <putc>
                for (fmt--; fmt[-1] != '%'; fmt--)
  800cbd:	83 c4 10             	add    $0x10,%esp
  800cc0:	89 dd                	mov    %ebx,%ebp
  800cc2:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800cc6:	0f 84 49 fa ff ff    	je     800715 <vprintfmt.constprop.1+0xd>
  800ccc:	4d                   	dec    %ebp
  800ccd:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
  800cd1:	75 f9                	jne    800ccc <vprintfmt.constprop.1+0x5c4>
  800cd3:	e9 3d fa ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd8:	85 ff                	test   %edi,%edi
  800cda:	78 06                	js     800ce2 <vprintfmt.constprop.1+0x5da>
  800cdc:	4f                   	dec    %edi
  800cdd:	83 ff ff             	cmp    $0xffffffff,%edi
  800ce0:	74 16                	je     800cf8 <vprintfmt.constprop.1+0x5f0>
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
  800ce2:	83 ec 0c             	sub    $0xc,%esp
  800ce5:	50                   	push   %eax
  800ce6:	e8 69 0e 00 00       	call   801b54 <putc>
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ceb:	4e                   	dec    %esi
  800cec:	43                   	inc    %ebx
  800ced:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  800cf1:	83 c4 10             	add    $0x10,%esp
  800cf4:	84 c0                	test   %al,%al
  800cf6:	75 e0                	jne    800cd8 <vprintfmt.constprop.1+0x5d0>
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
  800cf8:	85 f6                	test   %esi,%esi
  800cfa:	0f 8e 15 fa ff ff    	jle    800715 <vprintfmt.constprop.1+0xd>
                    putc(' ');
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	6a 20                	push   $0x20
  800d05:	e8 4a 0e 00 00       	call   801b54 <putc>
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
  800d0a:	83 c4 10             	add    $0x10,%esp
  800d0d:	4e                   	dec    %esi
  800d0e:	75 f0                	jne    800d00 <vprintfmt.constprop.1+0x5f8>
  800d10:	e9 00 fa ff ff       	jmp    800715 <vprintfmt.constprop.1+0xd>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800d15:	83 f8 07             	cmp    $0x7,%eax
  800d18:	0f 87 d5 fc ff ff    	ja     8009f3 <vprintfmt.constprop.1+0x2eb>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800d1e:	4e                   	dec    %esi
  800d1f:	85 f6                	test   %esi,%esi
  800d21:	0f 8e 61 fd ff ff    	jle    800a88 <vprintfmt.constprop.1+0x380>
  800d27:	90                   	nop
            putc(padc);
  800d28:	83 ec 0c             	sub    $0xc,%esp
  800d2b:	53                   	push   %ebx
  800d2c:	e8 23 0e 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	4e                   	dec    %esi
  800d35:	75 f1                	jne    800d28 <vprintfmt.constprop.1+0x620>
  800d37:	e9 4c fd ff ff       	jmp    800a88 <vprintfmt.constprop.1+0x380>
static long double
getfloat(va_list* ap, int lflag) {
    if (lflag)
        return va_arg(*ap, long double);
    else
        return va_arg(*ap, double);
  800d3c:	dd 00                	fldl   (%eax)
  800d3e:	83 c0 08             	add    $0x8,%eax
  800d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d45:	e9 55 fc ff ff       	jmp    80099f <vprintfmt.constprop.1+0x297>
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d4a:	8b 44 24 18          	mov    0x18(%esp),%eax
  800d4e:	8d 58 01             	lea    0x1(%eax),%ebx
  800d51:	0f be 00             	movsbl (%eax),%eax
  800d54:	84 c0                	test   %al,%al
  800d56:	0f 85 41 fe ff ff    	jne    800b9d <vprintfmt.constprop.1+0x495>
  800d5c:	eb a2                	jmp    800d00 <vprintfmt.constprop.1+0x5f8>
  800d5e:	66 90                	xchg   %ax,%ax
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800d60:	83 ee 02             	sub    $0x2,%esi
  800d63:	85 f6                	test   %esi,%esi
  800d65:	0f 8e c4 fb ff ff    	jle    80092f <vprintfmt.constprop.1+0x227>
  800d6b:	90                   	nop
            putc(padc);
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	53                   	push   %ebx
  800d70:	e8 df 0d 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800d75:	83 c4 10             	add    $0x10,%esp
  800d78:	4e                   	dec    %esi
  800d79:	75 f1                	jne    800d6c <vprintfmt.constprop.1+0x664>
  800d7b:	e9 af fb ff ff       	jmp    80092f <vprintfmt.constprop.1+0x227>
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
    else if (lflag)
        return va_arg(*ap, unsigned long);
  800d80:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  800d84:	8b 01                	mov    (%ecx),%eax
  800d86:	31 d2                	xor    %edx,%edx
  800d88:	89 44 24 18          	mov    %eax,0x18(%esp)
  800d8c:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  800d90:	89 c8                	mov    %ecx,%eax
  800d92:	83 c0 04             	add    $0x4,%eax
  800d95:	e9 41 fd ff ff       	jmp    800adb <vprintfmt.constprop.1+0x3d3>
  800d9a:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  800d9e:	8b 01                	mov    (%ecx),%eax
  800da0:	31 d2                	xor    %edx,%edx
  800da2:	89 44 24 18          	mov    %eax,0x18(%esp)
  800da6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  800daa:	89 c8                	mov    %ecx,%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	e9 54 fe ff ff       	jmp    800c08 <vprintfmt.constprop.1+0x500>
  800db4:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  800db8:	8b 01                	mov    (%ecx),%eax
  800dba:	31 d2                	xor    %edx,%edx
  800dbc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc0:	89 54 24 14          	mov    %edx,0x14(%esp)
  800dc4:	89 c8                	mov    %ecx,%eax
  800dc6:	83 c0 04             	add    $0x4,%eax
  800dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dcd:	e9 0b fc ff ff       	jmp    8009dd <vprintfmt.constprop.1+0x2d5>
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, long long);
    else if (lflag)
        return va_arg(*ap, long);
  800dd2:	8b 01                	mov    (%ecx),%eax
    else
        return va_arg(*ap, int);
  800dd4:	99                   	cltd   
  800dd5:	83 c1 04             	add    $0x4,%ecx
  800dd8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ddc:	e9 09 fa ff ff       	jmp    8007ea <vprintfmt.constprop.1+0xe2>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800de1:	83 ee 02             	sub    $0x2,%esi
  800de4:	85 f6                	test   %esi,%esi
  800de6:	0f 8e 82 fc ff ff    	jle    800a6e <vprintfmt.constprop.1+0x366>
            putc(padc);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	53                   	push   %ebx
  800df0:	e8 5f 0d 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	4e                   	dec    %esi
  800df9:	75 f1                	jne    800dec <vprintfmt.constprop.1+0x6e4>
  800dfb:	e9 6e fc ff ff       	jmp    800a6e <vprintfmt.constprop.1+0x366>
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
  800e00:	c7 44 24 18 1b 1e 80 	movl   $0x801e1b,0x18(%esp)
  800e07:	00 
  800e08:	e9 44 fd ff ff       	jmp    800b51 <vprintfmt.constprop.1+0x449>

            // (signed) decimal
            case 'd':
                num = getint(&ap, lflag);
                if ((long long) num < 0) {
                    putc('-');
  800e0d:	83 ec 0c             	sub    $0xc,%esp
  800e10:	6a 2d                	push   $0x2d
  800e12:	e8 3d 0d 00 00       	call   801b54 <putc>
                    num = -(long long) num;
  800e17:	f7 5c 24 28          	negl   0x28(%esp)
  800e1b:	83 54 24 2c 00       	adcl   $0x0,0x2c(%esp)
  800e20:	f7 5c 24 2c          	negl   0x2c(%esp)
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	e9 e0 fd ff ff       	jmp    800c0c <vprintfmt.constprop.1+0x504>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800e2c:	72 0c                	jb     800e3a <vprintfmt.constprop.1+0x732>
  800e2e:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  800e32:	39 c8                	cmp    %ecx,%eax
  800e34:	0f 83 4c fa ff ff    	jae    800886 <vprintfmt.constprop.1+0x17e>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800e3a:	83 ee 03             	sub    $0x3,%esi
  800e3d:	85 f6                	test   %esi,%esi
  800e3f:	0f 8e bf fa ff ff    	jle    800904 <vprintfmt.constprop.1+0x1fc>
            putc(padc);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	53                   	push   %ebx
  800e49:	e8 06 0d 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	4e                   	dec    %esi
  800e52:	75 f1                	jne    800e45 <vprintfmt.constprop.1+0x73d>
  800e54:	e9 ab fa ff ff       	jmp    800904 <vprintfmt.constprop.1+0x1fc>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800e59:	83 f8 07             	cmp    $0x7,%eax
  800e5c:	0f 87 ce fb ff ff    	ja     800a30 <vprintfmt.constprop.1+0x328>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800e62:	83 ee 03             	sub    $0x3,%esi
  800e65:	85 f6                	test   %esi,%esi
  800e67:	0f 8e e7 fb ff ff    	jle    800a54 <vprintfmt.constprop.1+0x34c>
            putc(padc);
  800e6d:	83 ec 0c             	sub    $0xc,%esp
  800e70:	53                   	push   %ebx
  800e71:	e8 de 0c 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800e76:	83 c4 10             	add    $0x10,%esp
  800e79:	4e                   	dec    %esi
  800e7a:	75 f1                	jne    800e6d <vprintfmt.constprop.1+0x765>
  800e7c:	e9 d3 fb ff ff       	jmp    800a54 <vprintfmt.constprop.1+0x34c>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800e81:	72 0c                	jb     800e8f <vprintfmt.constprop.1+0x787>
  800e83:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  800e87:	39 c8                	cmp    %ecx,%eax
  800e89:	0f 83 23 fa ff ff    	jae    8008b2 <vprintfmt.constprop.1+0x1aa>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800e8f:	83 ee 04             	sub    $0x4,%esi
  800e92:	85 f6                	test   %esi,%esi
  800e94:	0f 8e 3f fa ff ff    	jle    8008d9 <vprintfmt.constprop.1+0x1d1>
            putc(padc);
  800e9a:	83 ec 0c             	sub    $0xc,%esp
  800e9d:	53                   	push   %ebx
  800e9e:	e8 b1 0c 00 00       	call   801b54 <putc>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  800ea3:	83 c4 10             	add    $0x10,%esp
  800ea6:	4e                   	dec    %esi
  800ea7:	75 f1                	jne    800e9a <vprintfmt.constprop.1+0x792>
  800ea9:	e9 2b fa ff ff       	jmp    8008d9 <vprintfmt.constprop.1+0x1d1>
  800eae:	66 90                	xchg   %ax,%ax

00800eb0 <vcprintf>:
void printfmt(void (*putc)(char), const char* fmt, ...);
void vprintfmt(void (*putc)(char), const char* fmt, va_list);

void
vcprintf(const char* fmt, va_list ap) {
    vprintfmt((void (*)(char)) putc, fmt, ap);
  800eb0:	8b 54 24 08          	mov    0x8(%esp),%edx
  800eb4:	8b 44 24 04          	mov    0x4(%esp),%eax
  800eb8:	e9 4b f8 ff ff       	jmp    800708 <vprintfmt.constprop.1>
  800ebd:	8d 76 00             	lea    0x0(%esi),%esi

00800ec0 <print>:
}

void
print(const char* fmt, ...) {
  800ec0:	83 ec 0c             	sub    $0xc,%esp
void printfmt(void (*putc)(char), const char* fmt, ...);
void vprintfmt(void (*putc)(char), const char* fmt, va_list);

void
vcprintf(const char* fmt, va_list ap) {
    vprintfmt((void (*)(char)) putc, fmt, ap);
  800ec3:	8d 54 24 14          	lea    0x14(%esp),%edx
  800ec7:	8b 44 24 10          	mov    0x10(%esp),%eax
  800ecb:	e8 38 f8 ff ff       	call   800708 <vprintfmt.constprop.1>
    va_list ap;

    va_start(ap, fmt);
    vcprintf(fmt, ap);
    va_end(ap);
}
  800ed0:	83 c4 0c             	add    $0xc,%esp
  800ed3:	c3                   	ret    

00800ed4 <vprintfmt>:

// Main function to format and print a string.
void printfmt(void (*putc)(char), const char* fmt, ...);

void
vprintfmt(void (*putc)(char), const char* fmt, va_list ap) {
  800ed4:	55                   	push   %ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 3c             	sub    $0x3c,%esp
  800edb:	8b 6c 24 50          	mov    0x50(%esp),%ebp
  800edf:	8b 44 24 54          	mov    0x54(%esp),%eax
    long double real;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
  800ee3:	8d 58 01             	lea    0x1(%eax),%ebx
  800ee6:	0f be 00             	movsbl (%eax),%eax
  800ee9:	3c 25                	cmp    $0x25,%al
  800eeb:	75 15                	jne    800f02 <vprintfmt+0x2e>
  800eed:	eb 21                	jmp    800f10 <vprintfmt+0x3c>
  800eef:	90                   	nop
            if (ch == '\0')
                return;
            putc(ch);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	50                   	push   %eax
  800ef4:	ff d5                	call   *%ebp
    long double real;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char*) fmt++) != '%') {
  800ef6:	43                   	inc    %ebx
  800ef7:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  800efb:	83 c4 10             	add    $0x10,%esp
  800efe:	3c 25                	cmp    $0x25,%al
  800f00:	74 0e                	je     800f10 <vprintfmt+0x3c>
            if (ch == '\0')
  800f02:	84 c0                	test   %al,%al
  800f04:	75 ea                	jne    800ef0 <vprintfmt+0x1c>
                for (fmt--; fmt[-1] != '%'; fmt--)
                    /* do nothing */;
                break;
        }
    }
}
  800f06:	83 c4 3c             	add    $0x3c,%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
  800f0e:	66 90                	xchg   %ax,%ax
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
  800f10:	c6 44 24 08 20       	movb   $0x20,0x8(%esp)
  800f15:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  800f1c:	00 
  800f1d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  800f22:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800f27:	31 c9                	xor    %ecx,%ecx
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800f29:	8d 43 01             	lea    0x1(%ebx),%eax
  800f2c:	89 44 24 54          	mov    %eax,0x54(%esp)
  800f30:	0f be 13             	movsbl (%ebx),%edx
  800f33:	8d 42 dd             	lea    -0x23(%edx),%eax
  800f36:	3c 55                	cmp    $0x55,%al
  800f38:	0f 87 45 05 00 00    	ja     801483 <vprintfmt+0x5af>
  800f3e:	0f b6 c0             	movzbl %al,%eax
  800f41:	ff 24 85 7c 1f 80 00 	jmp    *0x801f7c(,%eax,4)
  800f48:	8b 5c 24 54          	mov    0x54(%esp),%ebx
                padc = '-';
                goto reswitch;

            // flag to pad with 0's instead of spaces
            case '0':
                padc = '0';
  800f4c:	c6 44 24 08 30       	movb   $0x30,0x8(%esp)
  800f51:	eb d6                	jmp    800f29 <vprintfmt+0x55>
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
                    precision = precision * 10 + ch - '0';
  800f53:	8d 7a d0             	lea    -0x30(%edx),%edi
                    ch = *fmt;
  800f56:	0f be 43 01          	movsbl 0x1(%ebx),%eax
                    if (ch < '0' || ch > '9')
  800f5a:	8d 50 d0             	lea    -0x30(%eax),%edx
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  800f5d:	8b 5c 24 54          	mov    0x54(%esp),%ebx
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
                    precision = precision * 10 + ch - '0';
                    ch = *fmt;
                    if (ch < '0' || ch > '9')
  800f61:	80 fa 09             	cmp    $0x9,%dl
  800f64:	0f 87 b3 04 00 00    	ja     80141d <vprintfmt+0x549>
  800f6a:	66 90                	xchg   %ax,%ax
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                for (precision = 0; ; ++fmt) {
  800f6c:	43                   	inc    %ebx
                    precision = precision * 10 + ch - '0';
  800f6d:	8d 14 bf             	lea    (%edi,%edi,4),%edx
  800f70:	8d 7c 50 d0          	lea    -0x30(%eax,%edx,2),%edi
                    ch = *fmt;
  800f74:	0f be 03             	movsbl (%ebx),%eax
                    if (ch < '0' || ch > '9')
  800f77:	8d 50 d0             	lea    -0x30(%eax),%edx
  800f7a:	80 fa 09             	cmp    $0x9,%dl
  800f7d:	76 ed                	jbe    800f6c <vprintfmt+0x98>
  800f7f:	e9 99 04 00 00       	jmp    80141d <vprintfmt+0x549>
                lflag++;
                goto reswitch;

            // character
            case 'c':
                putc(va_arg(ap, int));
  800f84:	8b 44 24 58          	mov    0x58(%esp),%eax
  800f88:	8d 58 04             	lea    0x4(%eax),%ebx
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	8b 44 24 64          	mov    0x64(%esp),%eax
  800f92:	0f be 00             	movsbl (%eax),%eax
  800f95:	50                   	push   %eax
  800f96:	ff d5                	call   *%ebp
                break;
  800f98:	83 c4 10             	add    $0x10,%esp
                lflag++;
                goto reswitch;

            // character
            case 'c':
                putc(va_arg(ap, int));
  800f9b:	89 5c 24 58          	mov    %ebx,0x58(%esp)
  800f9f:	8b 44 24 54          	mov    0x54(%esp),%eax
                break;
  800fa3:	e9 3b ff ff ff       	jmp    800ee3 <vprintfmt+0xf>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, long long);
  800fa8:	8b 44 24 58          	mov    0x58(%esp),%eax

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
  800fac:	49                   	dec    %ecx
  800fad:	0f 8e 30 06 00 00    	jle    8015e3 <vprintfmt+0x70f>
        return va_arg(*ap, long long);
  800fb3:	8b 50 04             	mov    0x4(%eax),%edx
  800fb6:	8b 00                	mov    (%eax),%eax
  800fb8:	8b 4c 24 58          	mov    0x58(%esp),%ecx
  800fbc:	83 c1 08             	add    $0x8,%ecx
  800fbf:	89 4c 24 58          	mov    %ecx,0x58(%esp)
                    putc(' ');
                break;

            // (signed) decimal
            case 'd':
                num = getint(&ap, lflag);
  800fc3:	89 44 24 18          	mov    %eax,0x18(%esp)
  800fc7:	89 54 24 1c          	mov    %edx,0x1c(%esp)
                if ((long long) num < 0) {
  800fcb:	85 d2                	test   %edx,%edx
  800fcd:	0f 88 4c 06 00 00    	js     80161f <vprintfmt+0x74b>
  800fd3:	c7 44 24 10 0a 00 00 	movl   $0xa,0x10(%esp)
  800fda:	00 
  800fdb:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  800fe2:	00 
  800fe3:	bf 0a 00 00 00       	mov    $0xa,%edi
            // (unsigned) hexadecimal
            case 'x':
                num = getuint(&ap, lflag);
                base = 16;
number:
                printnum(putc, num, base, width, padc);
  800fe8:	0f be 5c 24 08       	movsbl 0x8(%esp),%ebx
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  800fed:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  800ff1:	39 ca                	cmp    %ecx,%edx
  800ff3:	0f 86 e6 02 00 00    	jbe    8012df <vprintfmt+0x40b>
        printnum(putc, num / base, base, width - 1, padc);
  800ff9:	ff 74 24 14          	pushl  0x14(%esp)
  800ffd:	ff 74 24 14          	pushl  0x14(%esp)
  801001:	ff 74 24 24          	pushl  0x24(%esp)
  801005:	ff 74 24 24          	pushl  0x24(%esp)
  801009:	e8 7a 0b 00 00       	call   801b88 <__udivdi3>
  80100e:	83 c4 10             	add    $0x10,%esp
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  801011:	89 44 24 08          	mov    %eax,0x8(%esp)
  801015:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801019:	89 d1                	mov    %edx,%ecx
  80101b:	8b 44 24 10          	mov    0x10(%esp),%eax
  80101f:	8b 54 24 14          	mov    0x14(%esp),%edx
  801023:	39 ca                	cmp    %ecx,%edx
  801025:	72 12                	jb     801039 <vprintfmt+0x165>
  801027:	0f 87 0b 05 00 00    	ja     801538 <vprintfmt+0x664>
  80102d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801031:	39 c8                	cmp    %ecx,%eax
  801033:	0f 87 ff 04 00 00    	ja     801538 <vprintfmt+0x664>
        printnum(putc, num / base, base, width - 1, padc);
  801039:	ff 74 24 14          	pushl  0x14(%esp)
  80103d:	ff 74 24 14          	pushl  0x14(%esp)
  801041:	ff 74 24 14          	pushl  0x14(%esp)
  801045:	ff 74 24 14          	pushl  0x14(%esp)
  801049:	e8 3a 0b 00 00       	call   801b88 <__udivdi3>
  80104e:	83 c4 10             	add    $0x10,%esp
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  801051:	89 44 24 20          	mov    %eax,0x20(%esp)
  801055:	89 54 24 24          	mov    %edx,0x24(%esp)
  801059:	89 d1                	mov    %edx,%ecx
  80105b:	8b 44 24 10          	mov    0x10(%esp),%eax
  80105f:	8b 54 24 14          	mov    0x14(%esp),%edx
  801063:	39 ca                	cmp    %ecx,%edx
  801065:	0f 83 d0 05 00 00    	jae    80163b <vprintfmt+0x767>
        printnum(putc, num / base, base, width - 1, padc);
  80106b:	ff 74 24 14          	pushl  0x14(%esp)
  80106f:	ff 74 24 14          	pushl  0x14(%esp)
  801073:	ff 74 24 2c          	pushl  0x2c(%esp)
  801077:	ff 74 24 2c          	pushl  0x2c(%esp)
  80107b:	e8 08 0b 00 00       	call   801b88 <__udivdi3>
  801080:	83 c4 10             	add    $0x10,%esp
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  801083:	89 44 24 28          	mov    %eax,0x28(%esp)
  801087:	89 54 24 2c          	mov    %edx,0x2c(%esp)
  80108b:	89 d1                	mov    %edx,%ecx
  80108d:	8b 44 24 10          	mov    0x10(%esp),%eax
  801091:	8b 54 24 14          	mov    0x14(%esp),%edx
  801095:	39 ca                	cmp    %ecx,%edx
  801097:	0f 83 ed 05 00 00    	jae    80168a <vprintfmt+0x7b6>
        printnum(putc, num / base, base, width - 1, padc);
  80109d:	ff 74 24 14          	pushl  0x14(%esp)
  8010a1:	ff 74 24 14          	pushl  0x14(%esp)
  8010a5:	ff 74 24 34          	pushl  0x34(%esp)
  8010a9:	ff 74 24 34          	pushl  0x34(%esp)
  8010ad:	e8 d6 0a 00 00       	call   801b88 <__udivdi3>
  8010b2:	83 c4 0c             	add    $0xc,%esp
  8010b5:	53                   	push   %ebx
  8010b6:	83 ee 04             	sub    $0x4,%esi
  8010b9:	56                   	push   %esi
  8010ba:	57                   	push   %edi
  8010bb:	89 d1                	mov    %edx,%ecx
  8010bd:	89 c2                	mov    %eax,%edx
  8010bf:	89 e8                	mov    %ebp,%eax
  8010c1:	e8 a6 f0 ff ff       	call   80016c <printnum>
  8010c6:	83 c4 10             	add    $0x10,%esp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  8010c9:	83 ec 10             	sub    $0x10,%esp
  8010cc:	ff 74 24 24          	pushl  0x24(%esp)
  8010d0:	ff 74 24 24          	pushl  0x24(%esp)
  8010d4:	ff 74 24 44          	pushl  0x44(%esp)
  8010d8:	ff 74 24 44          	pushl  0x44(%esp)
  8010dc:	e8 b7 0b 00 00       	call   801c98 <__umoddi3>
  8010e1:	83 c4 14             	add    $0x14,%esp
  8010e4:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  8010eb:	50                   	push   %eax
  8010ec:	ff d5                	call   *%ebp
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	83 ec 10             	sub    $0x10,%esp
  8010f4:	ff 74 24 24          	pushl  0x24(%esp)
  8010f8:	ff 74 24 24          	pushl  0x24(%esp)
  8010fc:	ff 74 24 3c          	pushl  0x3c(%esp)
  801100:	ff 74 24 3c          	pushl  0x3c(%esp)
  801104:	e8 8f 0b 00 00       	call   801c98 <__umoddi3>
  801109:	83 c4 14             	add    $0x14,%esp
  80110c:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  801113:	50                   	push   %eax
  801114:	ff d5                	call   *%ebp
  801116:	83 c4 10             	add    $0x10,%esp
  801119:	83 ec 10             	sub    $0x10,%esp
  80111c:	ff 74 24 24          	pushl  0x24(%esp)
  801120:	ff 74 24 24          	pushl  0x24(%esp)
  801124:	ff 74 24 24          	pushl  0x24(%esp)
  801128:	ff 74 24 24          	pushl  0x24(%esp)
  80112c:	e8 67 0b 00 00       	call   801c98 <__umoddi3>
  801131:	83 c4 14             	add    $0x14,%esp
  801134:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  80113b:	50                   	push   %eax
  80113c:	ff d5                	call   *%ebp
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	83 ec 10             	sub    $0x10,%esp
  801144:	ff 74 24 24          	pushl  0x24(%esp)
  801148:	ff 74 24 24          	pushl  0x24(%esp)
  80114c:	ff 74 24 34          	pushl  0x34(%esp)
  801150:	ff 74 24 34          	pushl  0x34(%esp)
  801154:	e8 3f 0b 00 00       	call   801c98 <__umoddi3>
  801159:	83 c4 14             	add    $0x14,%esp
  80115c:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  801163:	50                   	push   %eax
  801164:	ff d5                	call   *%ebp
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	8b 44 24 54          	mov    0x54(%esp),%eax
  80116d:	e9 71 fd ff ff       	jmp    800ee3 <vprintfmt+0xf>
}

static long double
getfloat(va_list* ap, int lflag) {
    if (lflag)
        return va_arg(*ap, long double);
  801172:	8b 44 24 58          	mov    0x58(%esp),%eax
        return va_arg(*ap, int);
}

static long double
getfloat(va_list* ap, int lflag) {
    if (lflag)
  801176:	85 c9                	test   %ecx,%ecx
  801178:	0f 84 97 03 00 00    	je     801515 <vprintfmt+0x641>
        return va_arg(*ap, long double);
  80117e:	db 28                	fldt   (%eax)
  801180:	83 c0 0c             	add    $0xc,%eax
  801183:	89 44 24 58          	mov    %eax,0x58(%esp)
                printnum(putc, num, base, width, padc);
                break;

            case 'f':
                real = getfloat(&ap, lflag);
                printfloat(putc, real, padc);
  801187:	0f be 54 24 08       	movsbl 0x8(%esp),%edx
  80118c:	83 ec 10             	sub    $0x10,%esp
  80118f:	db 3c 24             	fstpt  (%esp)
  801192:	89 e8                	mov    %ebp,%eax
  801194:	e8 13 f1 ff ff       	call   8002ac <printfloat>
                break;
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	8b 44 24 54          	mov    0x54(%esp),%eax
  8011a0:	e9 3e fd ff ff       	jmp    800ee3 <vprintfmt+0xf>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
  8011a5:	8b 44 24 58          	mov    0x58(%esp),%eax

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
  8011a9:	49                   	dec    %ecx
  8011aa:	0f 8e 17 04 00 00    	jle    8015c7 <vprintfmt+0x6f3>
        return va_arg(*ap, unsigned long long);
  8011b0:	8b 50 04             	mov    0x4(%eax),%edx
  8011b3:	8b 00                	mov    (%eax),%eax
  8011b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b9:	89 54 24 14          	mov    %edx,0x14(%esp)
  8011bd:	8b 44 24 58          	mov    0x58(%esp),%eax
  8011c1:	83 c0 08             	add    $0x8,%eax
  8011c4:	89 44 24 58          	mov    %eax,0x58(%esp)

            // (unsigned) octal
            case 'o':
                num = getuint(&ap, lflag);
                base = 8;
                printnum(putc, num, base, width, padc);
  8011c8:	0f be 5c 24 08       	movsbl 0x8(%esp),%ebx
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8011cd:	8b 44 24 10          	mov    0x10(%esp),%eax
  8011d1:	8b 54 24 14          	mov    0x14(%esp),%edx
  8011d5:	83 fa 00             	cmp    $0x0,%edx
  8011d8:	0f 86 14 03 00 00    	jbe    8014f2 <vprintfmt+0x61e>
        printnum(putc, num / base, base, width - 1, padc);
  8011de:	0f ac d0 03          	shrd   $0x3,%edx,%eax
  8011e2:	c1 ea 03             	shr    $0x3,%edx
  8011e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011e9:	89 54 24 0c          	mov    %edx,0xc(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8011ed:	83 fa 00             	cmp    $0x0,%edx
  8011f0:	77 09                	ja     8011fb <vprintfmt+0x327>
  8011f2:	83 f8 07             	cmp    $0x7,%eax
  8011f5:	0f 86 fb 03 00 00    	jbe    8015f6 <vprintfmt+0x722>
        printnum(putc, num / base, base, width - 1, padc);
  8011fb:	8b 44 24 10          	mov    0x10(%esp),%eax
  8011ff:	8b 54 24 14          	mov    0x14(%esp),%edx
  801203:	0f ac d0 06          	shrd   $0x6,%edx,%eax
  801207:	c1 ea 06             	shr    $0x6,%edx
  80120a:	89 44 24 18          	mov    %eax,0x18(%esp)
  80120e:	89 54 24 1c          	mov    %edx,0x1c(%esp)
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  801212:	83 fa 00             	cmp    $0x0,%edx
  801215:	0f 86 4a 04 00 00    	jbe    801665 <vprintfmt+0x791>
        printnum(putc, num / base, base, width - 1, padc);
  80121b:	8b 54 24 10          	mov    0x10(%esp),%edx
  80121f:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  801223:	0f ac ca 09          	shrd   $0x9,%ecx,%edx
  801227:	c1 e9 09             	shr    $0x9,%ecx
  80122a:	50                   	push   %eax
  80122b:	53                   	push   %ebx
  80122c:	83 ee 03             	sub    $0x3,%esi
  80122f:	56                   	push   %esi
  801230:	6a 08                	push   $0x8
  801232:	89 e8                	mov    %ebp,%eax
  801234:	e8 33 ef ff ff       	call   80016c <printnum>
  801239:	83 c4 10             	add    $0x10,%esp
    else
        while (--width > 0)
            putc(padc);

    // then print this (the least significant) digit
    putc("0123456789abcdef"[num % base]);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	8b 44 24 24          	mov    0x24(%esp),%eax
  801243:	83 e0 07             	and    $0x7,%eax
  801246:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  80124d:	50                   	push   %eax
  80124e:	ff d5                	call   *%ebp
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	8b 44 24 14          	mov    0x14(%esp),%eax
  80125a:	83 e0 07             	and    $0x7,%eax
  80125d:	0f be 80 0a 1e 80 00 	movsbl 0x801e0a(%eax),%eax
  801264:	50                   	push   %eax
  801265:	ff d5                	call   *%ebp
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	83 ec 0c             	sub    $0xc,%esp
  80126d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  801271:	83 e0 07             	and    $0x7,%eax
  801274:	e9 e3 fe ff ff       	jmp    80115c <vprintfmt+0x288>
                    width = precision, precision = -1;
                goto reswitch;

            // long flag (doubled for long long)
            case 'l':
                lflag++;
  801279:	41                   	inc    %ecx
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  80127a:	8b 5c 24 54          	mov    0x54(%esp),%ebx
                goto reswitch;

            // long flag (doubled for long long)
            case 'l':
                lflag++;
                goto reswitch;
  80127e:	e9 a6 fc ff ff       	jmp    800f29 <vprintfmt+0x55>
                printnum(putc, num, base, width, padc);
                break;

            // pointer
            case 'p':
                putc('0');
  801283:	83 ec 0c             	sub    $0xc,%esp
  801286:	6a 30                	push   $0x30
  801288:	ff d5                	call   *%ebp
                putc('x');
  80128a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801291:	ff d5                	call   *%ebp
                num = (unsigned long long)
  801293:	8b 44 24 68          	mov    0x68(%esp),%eax
  801297:	8b 00                	mov    (%eax),%eax
  801299:	31 d2                	xor    %edx,%edx
  80129b:	89 44 24 28          	mov    %eax,0x28(%esp)
  80129f:	89 54 24 2c          	mov    %edx,0x2c(%esp)
                      (size_t) va_arg(ap, void*);
                base = 16;
                goto number;
  8012a3:	83 c4 10             	add    $0x10,%esp
            // pointer
            case 'p':
                putc('0');
                putc('x');
                num = (unsigned long long)
                      (size_t) va_arg(ap, void*);
  8012a6:	8b 44 24 58          	mov    0x58(%esp),%eax
  8012aa:	83 c0 04             	add    $0x4,%eax
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
  8012ad:	89 44 24 58          	mov    %eax,0x58(%esp)
  8012b1:	c7 44 24 10 10 00 00 	movl   $0x10,0x10(%esp)
  8012b8:	00 
  8012b9:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8012c0:	00 
  8012c1:	bf 10 00 00 00       	mov    $0x10,%edi
  8012c6:	8b 44 24 18          	mov    0x18(%esp),%eax
  8012ca:	8b 54 24 1c          	mov    0x1c(%esp),%edx
            // (unsigned) hexadecimal
            case 'x':
                num = getuint(&ap, lflag);
                base = 16;
number:
                printnum(putc, num, base, width, padc);
  8012ce:	0f be 5c 24 08       	movsbl 0x8(%esp),%ebx
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8012d3:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  8012d7:	39 ca                	cmp    %ecx,%edx
  8012d9:	0f 87 1a fd ff ff    	ja     800ff9 <vprintfmt+0x125>
  8012df:	72 0c                	jb     8012ed <vprintfmt+0x419>
  8012e1:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  8012e5:	39 c8                	cmp    %ecx,%eax
  8012e7:	0f 83 0c fd ff ff    	jae    800ff9 <vprintfmt+0x125>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8012ed:	4e                   	dec    %esi
  8012ee:	85 f6                	test   %esi,%esi
  8012f0:	0f 8e 4b fe ff ff    	jle    801141 <vprintfmt+0x26d>
  8012f6:	66 90                	xchg   %ax,%ax
            putc(padc);
  8012f8:	83 ec 0c             	sub    $0xc,%esp
  8012fb:	53                   	push   %ebx
  8012fc:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	4e                   	dec    %esi
  801302:	75 f4                	jne    8012f8 <vprintfmt+0x424>
  801304:	e9 38 fe ff ff       	jmp    801141 <vprintfmt+0x26d>
                putc(va_arg(ap, int));
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
  801309:	8b 44 24 58          	mov    0x58(%esp),%eax
  80130d:	83 c0 04             	add    $0x4,%eax
  801310:	89 44 24 18          	mov    %eax,0x18(%esp)
  801314:	8b 44 24 58          	mov    0x58(%esp),%eax
  801318:	8b 00                	mov    (%eax),%eax
  80131a:	89 44 24 20          	mov    %eax,0x20(%esp)
  80131e:	85 c0                	test   %eax,%eax
  801320:	0f 84 ec 02 00 00    	je     801612 <vprintfmt+0x73e>
                    p = "(null)";
                if (width > 0 && padc != '-')
  801326:	85 f6                	test   %esi,%esi
  801328:	7e 32                	jle    80135c <vprintfmt+0x488>
  80132a:	8a 5c 24 08          	mov    0x8(%esp),%bl
  80132e:	80 fb 2d             	cmp    $0x2d,%bl
  801331:	0f 84 ec 01 00 00    	je     801523 <vprintfmt+0x64f>
                    for (width -= strlen(p); width > 0; width--)
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	ff 74 24 2c          	pushl  0x2c(%esp)
  80133e:	e8 8d 03 00 00       	call   8016d0 <strlen>
  801343:	29 c6                	sub    %eax,%esi
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 f6                	test   %esi,%esi
  80134a:	7e 10                	jle    80135c <vprintfmt+0x488>
  80134c:	0f be db             	movsbl %bl,%ebx
  80134f:	90                   	nop
                        putc(padc);
  801350:	83 ec 0c             	sub    $0xc,%esp
  801353:	53                   	push   %ebx
  801354:	ff d5                	call   *%ebp
            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	4e                   	dec    %esi
  80135a:	75 f4                	jne    801350 <vprintfmt+0x47c>
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80135c:	8b 44 24 20          	mov    0x20(%esp),%eax
  801360:	8d 58 01             	lea    0x1(%eax),%ebx
  801363:	0f be 00             	movsbl (%eax),%eax
  801366:	84 c0                	test   %al,%al
  801368:	0f 84 73 01 00 00    	je     8014e1 <vprintfmt+0x60d>
  80136e:	8b 54 24 10          	mov    0x10(%esp),%edx
  801372:	85 d2                	test   %edx,%edx
  801374:	75 1d                	jne    801393 <vprintfmt+0x4bf>
  801376:	e9 35 01 00 00       	jmp    8014b0 <vprintfmt+0x5dc>
  80137b:	90                   	nop
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	50                   	push   %eax
  801380:	ff d5                	call   *%ebp
  801382:	83 c4 10             	add    $0x10,%esp
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801385:	4e                   	dec    %esi
  801386:	43                   	inc    %ebx
  801387:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  80138b:	84 c0                	test   %al,%al
  80138d:	0f 84 3a 01 00 00    	je     8014cd <vprintfmt+0x5f9>
  801393:	85 ff                	test   %edi,%edi
  801395:	78 0a                	js     8013a1 <vprintfmt+0x4cd>
  801397:	4f                   	dec    %edi
  801398:	83 ff ff             	cmp    $0xffffffff,%edi
  80139b:	0f 84 2c 01 00 00    	je     8014cd <vprintfmt+0x5f9>
                    if (altflag && (ch < ' ' || ch > '~'))
  8013a1:	8d 50 e0             	lea    -0x20(%eax),%edx
  8013a4:	80 fa 5e             	cmp    $0x5e,%dl
  8013a7:	76 d3                	jbe    80137c <vprintfmt+0x4a8>
                        putc('?');
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	6a 3f                	push   $0x3f
  8013ae:	ff d5                	call   *%ebp
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	eb d0                	jmp    801385 <vprintfmt+0x4b1>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
  8013b5:	8b 44 24 58          	mov    0x58(%esp),%eax

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
  8013b9:	49                   	dec    %ecx
  8013ba:	0f 8e ce 01 00 00    	jle    80158e <vprintfmt+0x6ba>
        return va_arg(*ap, unsigned long long);
  8013c0:	8b 50 04             	mov    0x4(%eax),%edx
  8013c3:	8b 00                	mov    (%eax),%eax
  8013c5:	89 44 24 18          	mov    %eax,0x18(%esp)
  8013c9:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  8013cd:	8b 44 24 58          	mov    0x58(%esp),%eax
  8013d1:	83 c0 08             	add    $0x8,%eax
  8013d4:	89 44 24 58          	mov    %eax,0x58(%esp)
  8013d8:	c7 44 24 10 0a 00 00 	movl   $0xa,0x10(%esp)
  8013df:	00 
  8013e0:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8013e7:	00 
  8013e8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013ed:	8b 44 24 18          	mov    0x18(%esp),%eax
  8013f1:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  8013f5:	e9 ee fb ff ff       	jmp    800fe8 <vprintfmt+0x114>
                printfloat(putc, real, padc);
                break;

            // escaped '%' character
            case '%':
                putc(ch);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	52                   	push   %edx
  8013fe:	ff d5                	call   *%ebp
                break;
  801400:	83 c4 10             	add    $0x10,%esp
  801403:	8b 44 24 54          	mov    0x54(%esp),%eax
  801407:	e9 d7 fa ff ff       	jmp    800ee3 <vprintfmt+0xf>
                        break;
                }
                goto process_precision;

            case '*':
                precision = va_arg(ap, int);
  80140c:	8b 44 24 58          	mov    0x58(%esp),%eax
  801410:	8b 38                	mov    (%eax),%edi
  801412:	83 c0 04             	add    $0x4,%eax
  801415:	89 44 24 58          	mov    %eax,0x58(%esp)
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  801419:	8b 5c 24 54          	mov    0x54(%esp),%ebx
            case '#':
                altflag = 1;
                goto reswitch;

process_precision:
                if (width < 0)
  80141d:	85 f6                	test   %esi,%esi
  80141f:	0f 89 04 fb ff ff    	jns    800f29 <vprintfmt+0x55>
                    width = precision, precision = -1;
  801425:	89 fe                	mov    %edi,%esi
  801427:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  80142c:	e9 f8 fa ff ff       	jmp    800f29 <vprintfmt+0x55>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
  801431:	8b 44 24 58          	mov    0x58(%esp),%eax

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
  801435:	49                   	dec    %ecx
  801436:	0f 8e 19 01 00 00    	jle    801555 <vprintfmt+0x681>
        return va_arg(*ap, unsigned long long);
  80143c:	8b 50 04             	mov    0x4(%eax),%edx
  80143f:	8b 00                	mov    (%eax),%eax
  801441:	89 44 24 18          	mov    %eax,0x18(%esp)
  801445:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  801449:	8b 44 24 58          	mov    0x58(%esp),%eax
  80144d:	83 c0 08             	add    $0x8,%eax
  801450:	e9 58 fe ff ff       	jmp    8012ad <vprintfmt+0x3d9>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  801455:	8b 5c 24 54          	mov    0x54(%esp),%ebx
                if (width < 0)
                    width = 0;
                goto reswitch;

            case '#':
                altflag = 1;
  801459:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
  801460:	00 
                goto reswitch;
  801461:	e9 c3 fa ff ff       	jmp    800f29 <vprintfmt+0x55>
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
reswitch:
        switch (ch = *(unsigned char*) fmt++) {
  801466:	8b 5c 24 54          	mov    0x54(%esp),%ebx

            // flag to pad on the right
            case '-':
                padc = '-';
  80146a:	c6 44 24 08 2d       	movb   $0x2d,0x8(%esp)
  80146f:	e9 b5 fa ff ff       	jmp    800f29 <vprintfmt+0x55>
  801474:	85 f6                	test   %esi,%esi
  801476:	0f 89 fe fd ff ff    	jns    80127a <vprintfmt+0x3a6>
  80147c:	31 f6                	xor    %esi,%esi
  80147e:	e9 f7 fd ff ff       	jmp    80127a <vprintfmt+0x3a6>
                putc(ch);
                break;

            // unrecognized escape sequence - just print it literally
            default:
                putc('%');
  801483:	83 ec 0c             	sub    $0xc,%esp
  801486:	6a 25                	push   $0x25
  801488:	ff d5                	call   *%ebp
                for (fmt--; fmt[-1] != '%'; fmt--)
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801491:	89 5c 24 54          	mov    %ebx,0x54(%esp)
  801495:	89 d8                	mov    %ebx,%eax
  801497:	0f 84 46 fa ff ff    	je     800ee3 <vprintfmt+0xf>
  80149d:	8d 76 00             	lea    0x0(%esi),%esi
  8014a0:	48                   	dec    %eax
  8014a1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8014a5:	75 f9                	jne    8014a0 <vprintfmt+0x5cc>
  8014a7:	89 44 24 54          	mov    %eax,0x54(%esp)
  8014ab:	e9 33 fa ff ff       	jmp    800ee3 <vprintfmt+0xf>
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014b0:	85 ff                	test   %edi,%edi
  8014b2:	78 06                	js     8014ba <vprintfmt+0x5e6>
  8014b4:	4f                   	dec    %edi
  8014b5:	83 ff ff             	cmp    $0xffffffff,%edi
  8014b8:	74 13                	je     8014cd <vprintfmt+0x5f9>
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	50                   	push   %eax
  8014be:	ff d5                	call   *%ebp
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014c0:	4e                   	dec    %esi
  8014c1:	43                   	inc    %ebx
  8014c2:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	84 c0                	test   %al,%al
  8014cb:	75 e3                	jne    8014b0 <vprintfmt+0x5dc>
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
  8014cd:	85 f6                	test   %esi,%esi
  8014cf:	7e 10                	jle    8014e1 <vprintfmt+0x60d>
  8014d1:	8d 76 00             	lea    0x0(%esi),%esi
                    putc(' ');
  8014d4:	83 ec 0c             	sub    $0xc,%esp
  8014d7:	6a 20                	push   $0x20
  8014d9:	ff d5                	call   *%ebp
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
                    if (altflag && (ch < ' ' || ch > '~'))
                        putc('?');
                    else
                        putc(ch);
                for (; width > 0; width--)
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	4e                   	dec    %esi
  8014df:	75 f3                	jne    8014d4 <vprintfmt+0x600>
                putc(va_arg(ap, int));
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
  8014e1:	8b 44 24 18          	mov    0x18(%esp),%eax
  8014e5:	89 44 24 58          	mov    %eax,0x58(%esp)
  8014e9:	8b 44 24 54          	mov    0x54(%esp),%eax
  8014ed:	e9 f1 f9 ff ff       	jmp    800ee3 <vprintfmt+0xf>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  8014f2:	83 f8 07             	cmp    $0x7,%eax
  8014f5:	0f 87 e3 fc ff ff    	ja     8011de <vprintfmt+0x30a>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8014fb:	4e                   	dec    %esi
  8014fc:	85 f6                	test   %esi,%esi
  8014fe:	0f 8e 66 fd ff ff    	jle    80126a <vprintfmt+0x396>
            putc(padc);
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	53                   	push   %ebx
  801508:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	4e                   	dec    %esi
  80150e:	75 f4                	jne    801504 <vprintfmt+0x630>
  801510:	e9 55 fd ff ff       	jmp    80126a <vprintfmt+0x396>
static long double
getfloat(va_list* ap, int lflag) {
    if (lflag)
        return va_arg(*ap, long double);
    else
        return va_arg(*ap, double);
  801515:	dd 00                	fldl   (%eax)
  801517:	83 c0 08             	add    $0x8,%eax
  80151a:	89 44 24 58          	mov    %eax,0x58(%esp)
  80151e:	e9 64 fc ff ff       	jmp    801187 <vprintfmt+0x2b3>
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
                if (width > 0 && padc != '-')
                    for (width -= strlen(p); width > 0; width--)
                        putc(padc);
                for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801523:	8b 44 24 20          	mov    0x20(%esp),%eax
  801527:	8d 58 01             	lea    0x1(%eax),%ebx
  80152a:	0f be 00             	movsbl (%eax),%eax
  80152d:	84 c0                	test   %al,%al
  80152f:	0f 85 39 fe ff ff    	jne    80136e <vprintfmt+0x49a>
  801535:	eb 9d                	jmp    8014d4 <vprintfmt+0x600>
  801537:	90                   	nop
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  801538:	83 ee 02             	sub    $0x2,%esi
  80153b:	85 f6                	test   %esi,%esi
  80153d:	0f 8e d6 fb ff ff    	jle    801119 <vprintfmt+0x245>
  801543:	90                   	nop
            putc(padc);
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	53                   	push   %ebx
  801548:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	4e                   	dec    %esi
  80154e:	75 f4                	jne    801544 <vprintfmt+0x670>
  801550:	e9 c4 fb ff ff       	jmp    801119 <vprintfmt+0x245>
static unsigned long long
getuint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, unsigned long long);
    else if (lflag)
        return va_arg(*ap, unsigned long);
  801555:	8b 00                	mov    (%eax),%eax
  801557:	31 d2                	xor    %edx,%edx
  801559:	89 44 24 18          	mov    %eax,0x18(%esp)
  80155d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  801561:	8b 44 24 58          	mov    0x58(%esp),%eax
  801565:	83 c0 04             	add    $0x4,%eax
  801568:	89 44 24 58          	mov    %eax,0x58(%esp)
  80156c:	c7 44 24 10 10 00 00 	movl   $0x10,0x10(%esp)
  801573:	00 
  801574:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  80157b:	00 
  80157c:	bf 10 00 00 00       	mov    $0x10,%edi
  801581:	8b 44 24 18          	mov    0x18(%esp),%eax
  801585:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  801589:	e9 5a fa ff ff       	jmp    800fe8 <vprintfmt+0x114>
  80158e:	8b 00                	mov    (%eax),%eax
  801590:	31 d2                	xor    %edx,%edx
  801592:	89 44 24 18          	mov    %eax,0x18(%esp)
  801596:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  80159a:	8b 44 24 58          	mov    0x58(%esp),%eax
  80159e:	83 c0 04             	add    $0x4,%eax
  8015a1:	89 44 24 58          	mov    %eax,0x58(%esp)
  8015a5:	c7 44 24 10 0a 00 00 	movl   $0xa,0x10(%esp)
  8015ac:	00 
  8015ad:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  8015b4:	00 
  8015b5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8015ba:	8b 44 24 18          	mov    0x18(%esp),%eax
  8015be:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  8015c2:	e9 21 fa ff ff       	jmp    800fe8 <vprintfmt+0x114>
  8015c7:	8b 00                	mov    (%eax),%eax
  8015c9:	31 d2                	xor    %edx,%edx
  8015cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015cf:	89 54 24 14          	mov    %edx,0x14(%esp)
  8015d3:	8b 44 24 58          	mov    0x58(%esp),%eax
  8015d7:	83 c0 04             	add    $0x4,%eax
  8015da:	89 44 24 58          	mov    %eax,0x58(%esp)
  8015de:	e9 e5 fb ff ff       	jmp    8011c8 <vprintfmt+0x2f4>
static long long
getint(va_list* ap, int lflag) {
    if (lflag >= 2)
        return va_arg(*ap, long long);
    else if (lflag)
        return va_arg(*ap, long);
  8015e3:	8b 00                	mov    (%eax),%eax
  8015e5:	99                   	cltd   
  8015e6:	8b 4c 24 58          	mov    0x58(%esp),%ecx
  8015ea:	83 c1 04             	add    $0x4,%ecx
  8015ed:	89 4c 24 58          	mov    %ecx,0x58(%esp)
  8015f1:	e9 cd f9 ff ff       	jmp    800fc3 <vprintfmt+0xef>
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8015f6:	83 ee 02             	sub    $0x2,%esi
  8015f9:	85 f6                	test   %esi,%esi
  8015fb:	0f 8e 52 fc ff ff    	jle    801253 <vprintfmt+0x37f>
            putc(padc);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	53                   	push   %ebx
  801605:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	4e                   	dec    %esi
  80160b:	75 f4                	jne    801601 <vprintfmt+0x72d>
  80160d:	e9 41 fc ff ff       	jmp    801253 <vprintfmt+0x37f>
                break;

            // string
            case 's':
                if ((p = va_arg(ap, char*)) == NULL)
                    p = "(null)";
  801612:	c7 44 24 20 1b 1e 80 	movl   $0x801e1b,0x20(%esp)
  801619:	00 
  80161a:	e9 07 fd ff ff       	jmp    801326 <vprintfmt+0x452>

            // (signed) decimal
            case 'd':
                num = getint(&ap, lflag);
                if ((long long) num < 0) {
                    putc('-');
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	6a 2d                	push   $0x2d
  801624:	ff d5                	call   *%ebp
                    num = -(long long) num;
  801626:	f7 5c 24 28          	negl   0x28(%esp)
  80162a:	83 54 24 2c 00       	adcl   $0x0,0x2c(%esp)
  80162f:	f7 5c 24 2c          	negl   0x2c(%esp)
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	e9 9d fd ff ff       	jmp    8013d8 <vprintfmt+0x504>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80163b:	77 0c                	ja     801649 <vprintfmt+0x775>
  80163d:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  801641:	39 c8                	cmp    %ecx,%eax
  801643:	0f 86 22 fa ff ff    	jbe    80106b <vprintfmt+0x197>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  801649:	83 ee 03             	sub    $0x3,%esi
  80164c:	85 f6                	test   %esi,%esi
  80164e:	0f 8e 9d fa ff ff    	jle    8010f1 <vprintfmt+0x21d>
            putc(padc);
  801654:	83 ec 0c             	sub    $0xc,%esp
  801657:	53                   	push   %ebx
  801658:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	4e                   	dec    %esi
  80165e:	75 f4                	jne    801654 <vprintfmt+0x780>
  801660:	e9 8c fa ff ff       	jmp    8010f1 <vprintfmt+0x21d>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  801665:	83 f8 07             	cmp    $0x7,%eax
  801668:	0f 87 ad fb ff ff    	ja     80121b <vprintfmt+0x347>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80166e:	83 ee 03             	sub    $0x3,%esi
  801671:	85 f6                	test   %esi,%esi
  801673:	0f 8e c3 fb ff ff    	jle    80123c <vprintfmt+0x368>
            putc(padc);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	53                   	push   %ebx
  80167d:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	4e                   	dec    %esi
  801683:	75 f4                	jne    801679 <vprintfmt+0x7a5>
  801685:	e9 b2 fb ff ff       	jmp    80123c <vprintfmt+0x368>
 */
static void
printnum(void (*putc)(char),
         unsigned long long num, unsigned base, int width, int padc) {
    // first recursively print all preceding (more significant) digits
    if (num >= base)
  80168a:	77 0c                	ja     801698 <vprintfmt+0x7c4>
  80168c:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  801690:	39 c8                	cmp    %ecx,%eax
  801692:	0f 86 05 fa ff ff    	jbe    80109d <vprintfmt+0x1c9>
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  801698:	83 ee 04             	sub    $0x4,%esi
  80169b:	85 f6                	test   %esi,%esi
  80169d:	0f 8e 26 fa ff ff    	jle    8010c9 <vprintfmt+0x1f5>
            putc(padc);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	53                   	push   %ebx
  8016a7:	ff d5                	call   *%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base)
        printnum(putc, num / base, base, width - 1, padc);
    // print any needed pad characters before first digit
    else
        while (--width > 0)
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	4e                   	dec    %esi
  8016ad:	75 f4                	jne    8016a3 <vprintfmt+0x7cf>
  8016af:	e9 15 fa ff ff       	jmp    8010c9 <vprintfmt+0x1f5>

008016b4 <printfmt>:
        }
    }
}

void
printfmt(void (*putc)(char), const char* fmt, ...) {
  8016b4:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;

    va_start(ap, fmt);
  8016b7:	8d 44 24 18          	lea    0x18(%esp),%eax
    vprintfmt(putc, fmt, ap);
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	ff 74 24 1c          	pushl  0x1c(%esp)
  8016c1:	ff 74 24 1c          	pushl  0x1c(%esp)
  8016c5:	e8 0a f8 ff ff       	call   800ed4 <vprintfmt>
    va_end(ap);
}
  8016ca:	83 c4 1c             	add    $0x1c,%esp
  8016cd:	c3                   	ret    
  8016ce:	66 90                	xchg   %ax,%ax

008016d0 <strlen>:
// but it makes an even bigger difference on bochs.
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char* s) {
  8016d0:	8b 54 24 04          	mov    0x4(%esp),%edx
    int n;

    for (n = 0; *s != '\0'; s++)
  8016d4:	31 c0                	xor    %eax,%eax
  8016d6:	80 3a 00             	cmpb   $0x0,(%edx)
  8016d9:	74 09                	je     8016e4 <strlen+0x14>
  8016db:	90                   	nop
        n++;
  8016dc:	40                   	inc    %eax

int
strlen(const char* s) {
    int n;

    for (n = 0; *s != '\0'; s++)
  8016dd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016e1:	75 f9                	jne    8016dc <strlen+0xc>
  8016e3:	c3                   	ret    
        n++;
    return n;
}
  8016e4:	c3                   	ret    
  8016e5:	8d 76 00             	lea    0x0(%esi),%esi

008016e8 <strnlen>:

int
strnlen(const char* s, size_t size) {
  8016e8:	53                   	push   %ebx
  8016e9:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  8016ed:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016f1:	85 c9                	test   %ecx,%ecx
  8016f3:	74 1f                	je     801714 <strnlen+0x2c>
  8016f5:	80 3b 00             	cmpb   $0x0,(%ebx)
  8016f8:	74 1a                	je     801714 <strnlen+0x2c>
  8016fa:	ba 01 00 00 00       	mov    $0x1,%edx
  8016ff:	eb 0b                	jmp    80170c <strnlen+0x24>
  801701:	8d 76 00             	lea    0x0(%esi),%esi
  801704:	42                   	inc    %edx
  801705:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  80170a:	74 06                	je     801712 <strnlen+0x2a>
        n++;
  80170c:	89 d0                	mov    %edx,%eax

int
strnlen(const char* s, size_t size) {
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80170e:	39 ca                	cmp    %ecx,%edx
  801710:	75 f2                	jne    801704 <strnlen+0x1c>
        n++;
    return n;
}
  801712:	5b                   	pop    %ebx
  801713:	c3                   	ret    

int
strnlen(const char* s, size_t size) {
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801714:	31 c0                	xor    %eax,%eax
        n++;
    return n;
}
  801716:	5b                   	pop    %ebx
  801717:	c3                   	ret    

00801718 <strcpy>:

char*
strcpy(char* dst, const char* src) {
  801718:	53                   	push   %ebx
  801719:	8b 44 24 08          	mov    0x8(%esp),%eax
  80171d:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    char* ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
  801721:	89 c2                	mov    %eax,%edx
  801723:	90                   	nop
  801724:	42                   	inc    %edx
  801725:	41                   	inc    %ecx
  801726:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801729:	88 5a ff             	mov    %bl,-0x1(%edx)
  80172c:	84 db                	test   %bl,%bl
  80172e:	75 f4                	jne    801724 <strcpy+0xc>
        /* do nothing */;
    return ret;
}
  801730:	5b                   	pop    %ebx
  801731:	c3                   	ret    
  801732:	66 90                	xchg   %ax,%ax

00801734 <strcat>:

char*
strcat(char* dst, const char* src) {
  801734:	53                   	push   %ebx
  801735:	8b 44 24 08          	mov    0x8(%esp),%eax
  801739:	8b 5c 24 0c          	mov    0xc(%esp),%ebx

int
strlen(const char* s) {
    int n;

    for (n = 0; *s != '\0'; s++)
  80173d:	80 38 00             	cmpb   $0x0,(%eax)
  801740:	74 1c                	je     80175e <strcat+0x2a>
  801742:	31 c9                	xor    %ecx,%ecx
        n++;
  801744:	41                   	inc    %ecx
  801745:	89 ca                	mov    %ecx,%edx

int
strlen(const char* s) {
    int n;

    for (n = 0; *s != '\0'; s++)
  801747:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  80174b:	75 f7                	jne    801744 <strcat+0x10>
}

char*
strcat(char* dst, const char* src) {
    int len = strlen(dst);
    strcpy(dst + len, src);
  80174d:	01 c2                	add    %eax,%edx
  80174f:	90                   	nop
char*
strcpy(char* dst, const char* src) {
    char* ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
  801750:	42                   	inc    %edx
  801751:	43                   	inc    %ebx
  801752:	8a 4b ff             	mov    -0x1(%ebx),%cl
  801755:	88 4a ff             	mov    %cl,-0x1(%edx)
  801758:	84 c9                	test   %cl,%cl
  80175a:	75 f4                	jne    801750 <strcat+0x1c>
char*
strcat(char* dst, const char* src) {
    int len = strlen(dst);
    strcpy(dst + len, src);
    return dst;
}
  80175c:	5b                   	pop    %ebx
  80175d:	c3                   	ret    

int
strlen(const char* s) {
    int n;

    for (n = 0; *s != '\0'; s++)
  80175e:	31 d2                	xor    %edx,%edx
  801760:	eb eb                	jmp    80174d <strcat+0x19>
  801762:	66 90                	xchg   %ax,%ax

00801764 <strncpy>:
    strcpy(dst + len, src);
    return dst;
}

char*
strncpy(char* dst, const char* src, size_t size) {
  801764:	56                   	push   %esi
  801765:	53                   	push   %ebx
  801766:	8b 44 24 0c          	mov    0xc(%esp),%eax
  80176a:	8b 54 24 10          	mov    0x10(%esp),%edx
  80176e:	8b 74 24 14          	mov    0x14(%esp),%esi
    size_t i;
    char* ret;

    ret = dst;
    for (i = 0; i < size; i++) {
  801772:	85 f6                	test   %esi,%esi
  801774:	74 1a                	je     801790 <strncpy+0x2c>
  801776:	01 c6                	add    %eax,%esi
  801778:	89 c1                	mov    %eax,%ecx
  80177a:	66 90                	xchg   %ax,%ax
        *dst++ = *src;
  80177c:	41                   	inc    %ecx
  80177d:	8a 1a                	mov    (%edx),%bl
  80177f:	88 59 ff             	mov    %bl,-0x1(%ecx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
  801782:	8d 5a 01             	lea    0x1(%edx),%ebx
  801785:	80 3a 00             	cmpb   $0x0,(%edx)
  801788:	74 02                	je     80178c <strncpy+0x28>
  80178a:	89 da                	mov    %ebx,%edx
strncpy(char* dst, const char* src, size_t size) {
    size_t i;
    char* ret;

    ret = dst;
    for (i = 0; i < size; i++) {
  80178c:	39 f1                	cmp    %esi,%ecx
  80178e:	75 ec                	jne    80177c <strncpy+0x18>
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
    }
    return ret;
}
  801790:	5b                   	pop    %ebx
  801791:	5e                   	pop    %esi
  801792:	c3                   	ret    
  801793:	90                   	nop

00801794 <strlcpy>:

size_t
strlcpy(char* dst, const char* src, size_t size) {
  801794:	53                   	push   %ebx
  801795:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801799:	8b 44 24 10          	mov    0x10(%esp),%eax
    char* dst_in;

    dst_in = dst;
    if (size > 0) {
  80179d:	85 c0                	test   %eax,%eax
  80179f:	74 33                	je     8017d4 <strlcpy+0x40>
        while (--size > 0 && *src != '\0')
  8017a1:	48                   	dec    %eax
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	74 32                	je     8017d8 <strlcpy+0x44>
  8017a6:	8a 0a                	mov    (%edx),%cl
  8017a8:	84 c9                	test   %cl,%cl
  8017aa:	74 2c                	je     8017d8 <strlcpy+0x44>
  8017ac:	8d 42 01             	lea    0x1(%edx),%eax
  8017af:	01 d3                	add    %edx,%ebx
  8017b1:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017b5:	eb 09                	jmp    8017c0 <strlcpy+0x2c>
  8017b7:	90                   	nop
  8017b8:	40                   	inc    %eax
  8017b9:	8a 48 ff             	mov    -0x1(%eax),%cl
  8017bc:	84 c9                	test   %cl,%cl
  8017be:	74 08                	je     8017c8 <strlcpy+0x34>
            *dst++ = *src++;
  8017c0:	42                   	inc    %edx
  8017c1:	88 4a ff             	mov    %cl,-0x1(%edx)
strlcpy(char* dst, const char* src, size_t size) {
    char* dst_in;

    dst_in = dst;
    if (size > 0) {
        while (--size > 0 && *src != '\0')
  8017c4:	39 d8                	cmp    %ebx,%eax
  8017c6:	75 f0                	jne    8017b8 <strlcpy+0x24>
  8017c8:	89 d0                	mov    %edx,%eax
  8017ca:	2b 44 24 08          	sub    0x8(%esp),%eax
            *dst++ = *src++;
        *dst = '\0';
  8017ce:	c6 02 00             	movb   $0x0,(%edx)
    }
    return dst - dst_in;
}
  8017d1:	5b                   	pop    %ebx
  8017d2:	c3                   	ret    
  8017d3:	90                   	nop
  8017d4:	31 c0                	xor    %eax,%eax
  8017d6:	5b                   	pop    %ebx
  8017d7:	c3                   	ret    
strlcpy(char* dst, const char* src, size_t size) {
    char* dst_in;

    dst_in = dst;
    if (size > 0) {
        while (--size > 0 && *src != '\0')
  8017d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8017dc:	31 c0                	xor    %eax,%eax
  8017de:	eb ee                	jmp    8017ce <strlcpy+0x3a>

008017e0 <strcmp>:
    }
    return dst - dst_in;
}

int
strcmp(const char* p, const char* q) {
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8017e6:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    while (*p && *p == *q)
  8017ea:	0f b6 02             	movzbl (%edx),%eax
  8017ed:	0f b6 0b             	movzbl (%ebx),%ecx
  8017f0:	84 c0                	test   %al,%al
  8017f2:	75 15                	jne    801809 <strcmp+0x29>
  8017f4:	eb 1e                	jmp    801814 <strcmp+0x34>
  8017f6:	66 90                	xchg   %ax,%ax
        p++, q++;
  8017f8:	42                   	inc    %edx
  8017f9:	8d 73 01             	lea    0x1(%ebx),%esi
    return dst - dst_in;
}

int
strcmp(const char* p, const char* q) {
    while (*p && *p == *q)
  8017fc:	0f b6 02             	movzbl (%edx),%eax
  8017ff:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  801803:	84 c0                	test   %al,%al
  801805:	74 0d                	je     801814 <strcmp+0x34>
  801807:	89 f3                	mov    %esi,%ebx
  801809:	38 c8                	cmp    %cl,%al
  80180b:	74 eb                	je     8017f8 <strcmp+0x18>
        p++, q++;
    return (int) ((unsigned char) * p - (unsigned char) * q);
  80180d:	29 c8                	sub    %ecx,%eax
}
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	c3                   	ret    
  801812:	66 90                	xchg   %ax,%ax
    return dst - dst_in;
}

int
strcmp(const char* p, const char* q) {
    while (*p && *p == *q)
  801814:	31 c0                	xor    %eax,%eax
        p++, q++;
    return (int) ((unsigned char) * p - (unsigned char) * q);
  801816:	29 c8                	sub    %ecx,%eax
}
  801818:	5b                   	pop    %ebx
  801819:	5e                   	pop    %esi
  80181a:	c3                   	ret    
  80181b:	90                   	nop

0080181c <strncmp>:

int
strncmp(const char* p, const char* q, size_t n) {
  80181c:	57                   	push   %edi
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
  80181f:	8b 7c 24 10          	mov    0x10(%esp),%edi
  801823:	8b 74 24 14          	mov    0x14(%esp),%esi
  801827:	8b 5c 24 18          	mov    0x18(%esp),%ebx
    while (n > 0 && *p && *p == *q)
  80182b:	85 db                	test   %ebx,%ebx
  80182d:	74 2c                	je     80185b <strncmp+0x3f>
  80182f:	8a 17                	mov    (%edi),%dl
  801831:	0f b6 0e             	movzbl (%esi),%ecx
  801834:	84 d2                	test   %dl,%dl
  801836:	74 39                	je     801871 <strncmp+0x55>
  801838:	38 d1                	cmp    %dl,%cl
  80183a:	75 2c                	jne    801868 <strncmp+0x4c>
  80183c:	8d 47 01             	lea    0x1(%edi),%eax
  80183f:	01 df                	add    %ebx,%edi
  801841:	eb 11                	jmp    801854 <strncmp+0x38>
  801843:	90                   	nop
  801844:	8a 10                	mov    (%eax),%dl
  801846:	84 d2                	test   %dl,%dl
  801848:	74 1a                	je     801864 <strncmp+0x48>
  80184a:	0f b6 0b             	movzbl (%ebx),%ecx
  80184d:	40                   	inc    %eax
  80184e:	89 de                	mov    %ebx,%esi
  801850:	38 ca                	cmp    %cl,%dl
  801852:	75 14                	jne    801868 <strncmp+0x4c>
        n--, p++, q++;
  801854:	8d 5e 01             	lea    0x1(%esi),%ebx
    return (int) ((unsigned char) * p - (unsigned char) * q);
}

int
strncmp(const char* p, const char* q, size_t n) {
    while (n > 0 && *p && *p == *q)
  801857:	39 f8                	cmp    %edi,%eax
  801859:	75 e9                	jne    801844 <strncmp+0x28>
        n--, p++, q++;
    if (n == 0)
        return 0;
  80185b:	31 c0                	xor    %eax,%eax
    else
        return (int) ((unsigned char) * p - (unsigned char) * q);
}
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5f                   	pop    %edi
  801860:	c3                   	ret    
  801861:	8d 76 00             	lea    0x0(%esi),%esi
  801864:	0f b6 4e 01          	movzbl 0x1(%esi),%ecx
    while (n > 0 && *p && *p == *q)
        n--, p++, q++;
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) * p - (unsigned char) * q);
  801868:	0f b6 c2             	movzbl %dl,%eax
  80186b:	29 c8                	sub    %ecx,%eax
}
  80186d:	5b                   	pop    %ebx
  80186e:	5e                   	pop    %esi
  80186f:	5f                   	pop    %edi
  801870:	c3                   	ret    
    return (int) ((unsigned char) * p - (unsigned char) * q);
}

int
strncmp(const char* p, const char* q, size_t n) {
    while (n > 0 && *p && *p == *q)
  801871:	31 d2                	xor    %edx,%edx
  801873:	eb f3                	jmp    801868 <strncmp+0x4c>
  801875:	8d 76 00             	lea    0x0(%esi),%esi

00801878 <strchr>:
}

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char*
strchr(const char* s, char c) {
  801878:	53                   	push   %ebx
  801879:	8b 44 24 08          	mov    0x8(%esp),%eax
  80187d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
    for (; *s; s++)
  801881:	8a 10                	mov    (%eax),%dl
  801883:	84 d2                	test   %dl,%dl
  801885:	74 14                	je     80189b <strchr+0x23>
  801887:	88 d9                	mov    %bl,%cl
        if (*s == c)
  801889:	38 d3                	cmp    %dl,%bl
  80188b:	75 07                	jne    801894 <strchr+0x1c>
  80188d:	eb 0e                	jmp    80189d <strchr+0x25>
  80188f:	90                   	nop
  801890:	38 ca                	cmp    %cl,%dl
  801892:	74 09                	je     80189d <strchr+0x25>

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char*
strchr(const char* s, char c) {
    for (; *s; s++)
  801894:	40                   	inc    %eax
  801895:	8a 10                	mov    (%eax),%dl
  801897:	84 d2                	test   %dl,%dl
  801899:	75 f5                	jne    801890 <strchr+0x18>
        if (*s == c)
            return (char*) s;
    return 0;
  80189b:	31 c0                	xor    %eax,%eax
}
  80189d:	5b                   	pop    %ebx
  80189e:	c3                   	ret    
  80189f:	90                   	nop

008018a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char*
strfind(const char* s, char c) {
  8018a0:	53                   	push   %ebx
  8018a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018a5:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
    for (; *s; s++)
  8018a9:	8a 10                	mov    (%eax),%dl
  8018ab:	84 d2                	test   %dl,%dl
  8018ad:	74 14                	je     8018c3 <strfind+0x23>
  8018af:	88 d9                	mov    %bl,%cl
        if (*s == c)
  8018b1:	38 d3                	cmp    %dl,%bl
  8018b3:	75 07                	jne    8018bc <strfind+0x1c>
  8018b5:	eb 0c                	jmp    8018c3 <strfind+0x23>
  8018b7:	90                   	nop
  8018b8:	38 ca                	cmp    %cl,%dl
  8018ba:	74 07                	je     8018c3 <strfind+0x23>

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char*
strfind(const char* s, char c) {
    for (; *s; s++)
  8018bc:	40                   	inc    %eax
  8018bd:	8a 10                	mov    (%eax),%dl
  8018bf:	84 d2                	test   %dl,%dl
  8018c1:	75 f5                	jne    8018b8 <strfind+0x18>
        if (*s == c)
            break;
    return (char*) s;
}
  8018c3:	5b                   	pop    %ebx
  8018c4:	c3                   	ret    
  8018c5:	8d 76 00             	lea    0x0(%esi),%esi

008018c8 <memset>:

#if ASM
void*
memset(void* v, int c, size_t n) {
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8018cf:	8b 4c 24 18          	mov    0x18(%esp),%ecx
    if (n == 0)
  8018d3:	85 c9                	test   %ecx,%ecx
  8018d5:	74 14                	je     8018eb <memset+0x23>
        return v;
    if ((int)v % 4 == 0 && n % 4 == 0) {
  8018d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8018dd:	75 05                	jne    8018e4 <memset+0x1c>
  8018df:	f6 c1 03             	test   $0x3,%cl
  8018e2:	74 10                	je     8018f4 <memset+0x2c>
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile("cld; rep stosl\n"
                     :: "D" (v), "a" (c), "c" (n/4)
                     : "cc", "memory");
    } else
        asm volatile("cld; rep stosb\n"
  8018e4:	8b 44 24 14          	mov    0x14(%esp),%eax
  8018e8:	fc                   	cld    
  8018e9:	f3 aa                	rep stos %al,%es:(%edi)
                     :: "D" (v), "a" (c), "c" (n)
                     : "cc", "memory");
    return v;
}
  8018eb:	89 f8                	mov    %edi,%eax
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	c3                   	ret    
  8018f1:	8d 76 00             	lea    0x0(%esi),%esi
void*
memset(void* v, int c, size_t n) {
    if (n == 0)
        return v;
    if ((int)v % 4 == 0 && n % 4 == 0) {
        c &= 0xFF;
  8018f4:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
  8018f9:	89 d6                	mov    %edx,%esi
  8018fb:	c1 e6 08             	shl    $0x8,%esi
  8018fe:	89 d0                	mov    %edx,%eax
  801900:	c1 e0 18             	shl    $0x18,%eax
  801903:	89 d3                	mov    %edx,%ebx
  801905:	c1 e3 10             	shl    $0x10,%ebx
  801908:	09 d8                	or     %ebx,%eax
  80190a:	09 c2                	or     %eax,%edx
        asm volatile("cld; rep stosl\n"
  80190c:	89 f0                	mov    %esi,%eax
  80190e:	09 d0                	or     %edx,%eax
  801910:	c1 e9 02             	shr    $0x2,%ecx
  801913:	fc                   	cld    
  801914:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile("cld; rep stosb\n"
                     :: "D" (v), "a" (c), "c" (n)
                     : "cc", "memory");
    return v;
}
  801916:	89 f8                	mov    %edi,%eax
  801918:	5b                   	pop    %ebx
  801919:	5e                   	pop    %esi
  80191a:	5f                   	pop    %edi
  80191b:	c3                   	ret    

0080191c <memmove>:

void*
memmove(void* dst, const void* src, size_t n) {
  80191c:	57                   	push   %edi
  80191d:	56                   	push   %esi
  80191e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  801922:	8b 74 24 10          	mov    0x10(%esp),%esi
  801926:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char* s;
    char* d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  80192a:	39 c6                	cmp    %eax,%esi
  80192c:	73 1e                	jae    80194c <memmove+0x30>
  80192e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801931:	39 d0                	cmp    %edx,%eax
  801933:	73 17                	jae    80194c <memmove+0x30>
        s += n;
        d += n;
  801935:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int)s % 4 == 0 && (int)d % 4 == 0 && n % 4 == 0)
  801938:	89 d6                	mov    %edx,%esi
  80193a:	09 fe                	or     %edi,%esi
  80193c:	83 e6 03             	and    $0x3,%esi
  80193f:	74 2b                	je     80196c <memmove+0x50>
            asm volatile("std; rep movsl\n"
                         :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
        else
            asm volatile("std; rep movsb\n"
  801941:	4f                   	dec    %edi
  801942:	8d 72 ff             	lea    -0x1(%edx),%esi
  801945:	fd                   	std    
  801946:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                         :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
  801948:	fc                   	cld    
        else
            asm volatile("cld; rep movsb\n"
                         :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
    }
    return dst;
}
  801949:	5e                   	pop    %esi
  80194a:	5f                   	pop    %edi
  80194b:	c3                   	ret    
            asm volatile("std; rep movsb\n"
                         :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
    } else {
        if ((int)s % 4 == 0 && (int)d % 4 == 0 && n % 4 == 0)
  80194c:	89 f2                	mov    %esi,%edx
  80194e:	09 c2                	or     %eax,%edx
  801950:	83 e2 03             	and    $0x3,%edx
  801953:	75 0f                	jne    801964 <memmove+0x48>
  801955:	f6 c1 03             	test   $0x3,%cl
  801958:	75 0a                	jne    801964 <memmove+0x48>
            asm volatile("cld; rep movsl\n"
  80195a:	c1 e9 02             	shr    $0x2,%ecx
  80195d:	89 c7                	mov    %eax,%edi
  80195f:	fc                   	cld    
  801960:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801962:	eb 05                	jmp    801969 <memmove+0x4d>
                         :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
        else
            asm volatile("cld; rep movsb\n"
  801964:	89 c7                	mov    %eax,%edi
  801966:	fc                   	cld    
  801967:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                         :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
    }
    return dst;
}
  801969:	5e                   	pop    %esi
  80196a:	5f                   	pop    %edi
  80196b:	c3                   	ret    
    s = src;
    d = dst;
    if (s < d && s + n > d) {
        s += n;
        d += n;
        if ((int)s % 4 == 0 && (int)d % 4 == 0 && n % 4 == 0)
  80196c:	f6 c1 03             	test   $0x3,%cl
  80196f:	75 d0                	jne    801941 <memmove+0x25>
            asm volatile("std; rep movsl\n"
  801971:	83 ef 04             	sub    $0x4,%edi
  801974:	8d 72 fc             	lea    -0x4(%edx),%esi
  801977:	c1 e9 02             	shr    $0x2,%ecx
  80197a:	fd                   	std    
  80197b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80197d:	eb c9                	jmp    801948 <memmove+0x2c>
  80197f:	90                   	nop

00801980 <memcpy>:
    return dst;
}
#endif

void*
memcpy(void* dst, const void* src, size_t n) {
  801980:	57                   	push   %edi
  801981:	56                   	push   %esi
  801982:	8b 44 24 0c          	mov    0xc(%esp),%eax
  801986:	8b 74 24 10          	mov    0x10(%esp),%esi
  80198a:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char* s;
    char* d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  80198e:	39 f0                	cmp    %esi,%eax
  801990:	76 1e                	jbe    8019b0 <memcpy+0x30>
  801992:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801995:	39 d0                	cmp    %edx,%eax
  801997:	73 17                	jae    8019b0 <memcpy+0x30>
        s += n;
        d += n;
  801999:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int)s % 4 == 0 && (int)d % 4 == 0 && n % 4 == 0)
  80199c:	89 d6                	mov    %edx,%esi
  80199e:	09 fe                	or     %edi,%esi
  8019a0:	83 e6 03             	and    $0x3,%esi
  8019a3:	74 2b                	je     8019d0 <memcpy+0x50>
            asm volatile("std; rep movsl\n"
                         :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
        else
            asm volatile("std; rep movsb\n"
  8019a5:	4f                   	dec    %edi
  8019a6:	8d 72 ff             	lea    -0x1(%edx),%esi
  8019a9:	fd                   	std    
  8019aa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                         :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
  8019ac:	fc                   	cld    
#endif

void*
memcpy(void* dst, const void* src, size_t n) {
    return memmove(dst, src, n);
}
  8019ad:	5e                   	pop    %esi
  8019ae:	5f                   	pop    %edi
  8019af:	c3                   	ret    
            asm volatile("std; rep movsb\n"
                         :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
    } else {
        if ((int)s % 4 == 0 && (int)d % 4 == 0 && n % 4 == 0)
  8019b0:	89 f2                	mov    %esi,%edx
  8019b2:	09 c2                	or     %eax,%edx
  8019b4:	83 e2 03             	and    $0x3,%edx
  8019b7:	75 0f                	jne    8019c8 <memcpy+0x48>
  8019b9:	f6 c1 03             	test   $0x3,%cl
  8019bc:	75 0a                	jne    8019c8 <memcpy+0x48>
            asm volatile("cld; rep movsl\n"
  8019be:	c1 e9 02             	shr    $0x2,%ecx
  8019c1:	89 c7                	mov    %eax,%edi
  8019c3:	fc                   	cld    
  8019c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019c6:	eb 05                	jmp    8019cd <memcpy+0x4d>
                         :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
        else
            asm volatile("cld; rep movsb\n"
  8019c8:	89 c7                	mov    %eax,%edi
  8019ca:	fc                   	cld    
  8019cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
#endif

void*
memcpy(void* dst, const void* src, size_t n) {
    return memmove(dst, src, n);
}
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	c3                   	ret    
    s = src;
    d = dst;
    if (s < d && s + n > d) {
        s += n;
        d += n;
        if ((int)s % 4 == 0 && (int)d % 4 == 0 && n % 4 == 0)
  8019d0:	f6 c1 03             	test   $0x3,%cl
  8019d3:	75 d0                	jne    8019a5 <memcpy+0x25>
            asm volatile("std; rep movsl\n"
  8019d5:	83 ef 04             	sub    $0x4,%edi
  8019d8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019db:	c1 e9 02             	shr    $0x2,%ecx
  8019de:	fd                   	std    
  8019df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019e1:	eb c9                	jmp    8019ac <memcpy+0x2c>
  8019e3:	90                   	nop

008019e4 <memcmp>:
memcpy(void* dst, const void* src, size_t n) {
    return memmove(dst, src, n);
}

int
memcmp(const void* v1, const void* v2, size_t n) {
  8019e4:	57                   	push   %edi
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  8019eb:	8b 74 24 14          	mov    0x14(%esp),%esi
  8019ef:	8b 44 24 18          	mov    0x18(%esp),%eax
    const uint8_t* s1 = (const uint8_t*) v1;
    const uint8_t* s2 = (const uint8_t*) v2;

    while (n-- > 0) {
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	74 22                	je     801a19 <memcmp+0x35>
        if (*s1 != *s2)
  8019f7:	8a 13                	mov    (%ebx),%dl
  8019f9:	0f b6 0e             	movzbl (%esi),%ecx
  8019fc:	38 d1                	cmp    %dl,%cl
  8019fe:	75 20                	jne    801a20 <memcmp+0x3c>
  801a00:	8d 78 ff             	lea    -0x1(%eax),%edi
  801a03:	31 c0                	xor    %eax,%eax
  801a05:	eb 0e                	jmp    801a15 <memcmp+0x31>
  801a07:	90                   	nop
  801a08:	8a 54 03 01          	mov    0x1(%ebx,%eax,1),%dl
  801a0c:	40                   	inc    %eax
  801a0d:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  801a11:	38 ca                	cmp    %cl,%dl
  801a13:	75 0b                	jne    801a20 <memcmp+0x3c>
int
memcmp(const void* v1, const void* v2, size_t n) {
    const uint8_t* s1 = (const uint8_t*) v1;
    const uint8_t* s2 = (const uint8_t*) v2;

    while (n-- > 0) {
  801a15:	39 f8                	cmp    %edi,%eax
  801a17:	75 ef                	jne    801a08 <memcmp+0x24>
        if (*s1 != *s2)
            return (int) * s1 - (int) * s2;
        s1++, s2++;
    }

    return 0;
  801a19:	31 c0                	xor    %eax,%eax
}
  801a1b:	5b                   	pop    %ebx
  801a1c:	5e                   	pop    %esi
  801a1d:	5f                   	pop    %edi
  801a1e:	c3                   	ret    
  801a1f:	90                   	nop
    const uint8_t* s1 = (const uint8_t*) v1;
    const uint8_t* s2 = (const uint8_t*) v2;

    while (n-- > 0) {
        if (*s1 != *s2)
            return (int) * s1 - (int) * s2;
  801a20:	0f b6 c2             	movzbl %dl,%eax
  801a23:	29 c8                	sub    %ecx,%eax
        s1++, s2++;
    }

    return 0;
}
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5f                   	pop    %edi
  801a28:	c3                   	ret    
  801a29:	8d 76 00             	lea    0x0(%esi),%esi

00801a2c <memfind>:

void*
memfind(const void* s, int c, size_t n) {
  801a2c:	53                   	push   %ebx
  801a2d:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a31:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    const void* ends = (const char*) s + n;
  801a35:	8b 44 24 10          	mov    0x10(%esp),%eax
  801a39:	01 d0                	add    %edx,%eax
    for (; s < ends; s++)
  801a3b:	39 c2                	cmp    %eax,%edx
  801a3d:	73 19                	jae    801a58 <memfind+0x2c>
        if (*(const unsigned char*) s == (unsigned char) c)
  801a3f:	0f b6 d9             	movzbl %cl,%ebx
  801a42:	38 0a                	cmp    %cl,(%edx)
  801a44:	75 09                	jne    801a4f <memfind+0x23>
  801a46:	eb 10                	jmp    801a58 <memfind+0x2c>
  801a48:	0f b6 0a             	movzbl (%edx),%ecx
  801a4b:	39 d9                	cmp    %ebx,%ecx
  801a4d:	74 09                	je     801a58 <memfind+0x2c>
}

void*
memfind(const void* s, int c, size_t n) {
    const void* ends = (const char*) s + n;
    for (; s < ends; s++)
  801a4f:	42                   	inc    %edx
  801a50:	39 d0                	cmp    %edx,%eax
  801a52:	75 f4                	jne    801a48 <memfind+0x1c>
        if (*(const unsigned char*) s == (unsigned char) c)
            break;
    return (void*) s;
}
  801a54:	5b                   	pop    %ebx
  801a55:	c3                   	ret    
  801a56:	66 90                	xchg   %ax,%ax
}

void*
memfind(const void* s, int c, size_t n) {
    const void* ends = (const char*) s + n;
    for (; s < ends; s++)
  801a58:	89 d0                	mov    %edx,%eax
        if (*(const unsigned char*) s == (unsigned char) c)
            break;
    return (void*) s;
}
  801a5a:	5b                   	pop    %ebx
  801a5b:	c3                   	ret    

00801a5c <strtol>:

long
strtol(const char* s, char** endptr, int base) {
  801a5c:	55                   	push   %ebp
  801a5d:	57                   	push   %edi
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  801a64:	8b 74 24 18          	mov    0x18(%esp),%esi
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
  801a68:	8a 01                	mov    (%ecx),%al
  801a6a:	3c 20                	cmp    $0x20,%al
  801a6c:	74 04                	je     801a72 <strtol+0x16>
  801a6e:	3c 09                	cmp    $0x9,%al
  801a70:	75 06                	jne    801a78 <strtol+0x1c>
        s++;
  801a72:	41                   	inc    %ecx
  801a73:	eb f3                	jmp    801a68 <strtol+0xc>
  801a75:	8d 76 00             	lea    0x0(%esi),%esi

    // plus/minus sign
    if (*s == '+')
  801a78:	3c 2b                	cmp    $0x2b,%al
  801a7a:	74 78                	je     801af4 <strtol+0x98>
        s++;
    else if (*s == '-')
  801a7c:	3c 2d                	cmp    $0x2d,%al
  801a7e:	74 7c                	je     801afc <strtol+0xa0>
    return (void*) s;
}

long
strtol(const char* s, char** endptr, int base) {
    int neg = 0;
  801a80:	31 ff                	xor    %edi,%edi
        s++;
    else if (*s == '-')
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a82:	f7 44 24 1c ef ff ff 	testl  $0xffffffef,0x1c(%esp)
  801a89:	ff 
  801a8a:	75 14                	jne    801aa0 <strtol+0x44>
  801a8c:	3c 30                	cmp    $0x30,%al
  801a8e:	74 7a                	je     801b0a <strtol+0xae>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
  801a90:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  801a94:	85 d2                	test   %edx,%edx
  801a96:	75 08                	jne    801aa0 <strtol+0x44>
        s++, base = 8;
    else if (base == 0)
        base = 10;
  801a98:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
  801a9f:	00 
  801aa0:	31 c0                	xor    %eax,%eax
  801aa2:	eb 11                	jmp    801ab5 <strtol+0x59>
    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
  801aa4:	83 ea 30             	sub    $0x30,%edx
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
  801aa7:	3b 54 24 1c          	cmp    0x1c(%esp),%edx
  801aab:	7d 26                	jge    801ad3 <strtol+0x77>
            break;
        s++, val = (val * base) + dig;
  801aad:	41                   	inc    %ecx
  801aae:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
  801ab3:	01 d0                	add    %edx,%eax

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
  801ab5:	0f be 11             	movsbl (%ecx),%edx
  801ab8:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801abb:	80 fb 09             	cmp    $0x9,%bl
  801abe:	76 e4                	jbe    801aa4 <strtol+0x48>
            dig = *s - '0';
        else if (*s >= 'a' && *s <= 'z')
  801ac0:	8d 6a 9f             	lea    -0x61(%edx),%ebp
  801ac3:	89 eb                	mov    %ebp,%ebx
  801ac5:	80 fb 19             	cmp    $0x19,%bl
  801ac8:	77 1a                	ja     801ae4 <strtol+0x88>
            dig = *s - 'a' + 10;
  801aca:	83 ea 57             	sub    $0x57,%edx
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
  801acd:	3b 54 24 1c          	cmp    0x1c(%esp),%edx
  801ad1:	7c da                	jl     801aad <strtol+0x51>
            break;
        s++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr)
  801ad3:	85 f6                	test   %esi,%esi
  801ad5:	74 02                	je     801ad9 <strtol+0x7d>
        *endptr = (char*) s;
  801ad7:	89 0e                	mov    %ecx,(%esi)
    return (neg ? -val : val);
  801ad9:	85 ff                	test   %edi,%edi
  801adb:	74 02                	je     801adf <strtol+0x83>
  801add:	f7 d8                	neg    %eax
}
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
        else if (*s >= 'a' && *s <= 'z')
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
  801ae4:	8d 6a bf             	lea    -0x41(%edx),%ebp
  801ae7:	89 eb                	mov    %ebp,%ebx
  801ae9:	80 fb 19             	cmp    $0x19,%bl
  801aec:	77 e5                	ja     801ad3 <strtol+0x77>
            dig = *s - 'A' + 10;
  801aee:	83 ea 37             	sub    $0x37,%edx
  801af1:	eb b4                	jmp    801aa7 <strtol+0x4b>
  801af3:	90                   	nop
  801af4:	8a 41 01             	mov    0x1(%ecx),%al
    while (*s == ' ' || *s == '\t')
        s++;

    // plus/minus sign
    if (*s == '+')
        s++;
  801af7:	41                   	inc    %ecx
    return (void*) s;
}

long
strtol(const char* s, char** endptr, int base) {
    int neg = 0;
  801af8:	31 ff                	xor    %edi,%edi
  801afa:	eb 86                	jmp    801a82 <strtol+0x26>
  801afc:	8a 41 01             	mov    0x1(%ecx),%al

    // plus/minus sign
    if (*s == '+')
        s++;
    else if (*s == '-')
        s++, neg = 1;
  801aff:	41                   	inc    %ecx
  801b00:	bf 01 00 00 00       	mov    $0x1,%edi
  801b05:	e9 78 ff ff ff       	jmp    801a82 <strtol+0x26>

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801b0a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801b0e:	74 16                	je     801b26 <strtol+0xca>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
  801b10:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  801b14:	85 c0                	test   %eax,%eax
  801b16:	75 88                	jne    801aa0 <strtol+0x44>
        s++, base = 8;
  801b18:	41                   	inc    %ecx
  801b19:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
  801b20:	00 
  801b21:	e9 7a ff ff ff       	jmp    801aa0 <strtol+0x44>
    else if (*s == '-')
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
        s += 2, base = 16;
  801b26:	83 c1 02             	add    $0x2,%ecx
  801b29:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  801b30:	00 
  801b31:	e9 6a ff ff ff       	jmp    801aa0 <strtol+0x44>
  801b36:	66 90                	xchg   %ax,%ax

00801b38 <usermain>:

const volatile struct proc* thisproc;
const char* binaryname = "<unknown>";

void
usermain(int argc, char** argv) {
  801b38:	83 ec 14             	sub    $0x14,%esp
    //     binaryname = argv[0];

    // print("here!\n");

    // call user main routine
    int ret = main(argc, argv);
  801b3b:	ff 74 24 1c          	pushl  0x1c(%esp)
  801b3f:	ff 74 24 1c          	pushl  0x1c(%esp)
  801b43:	e8 e4 e4 ff ff       	call   80002c <main>

    // exit gracefully
    exit(ret);
  801b48:	89 44 24 20          	mov    %eax,0x20(%esp)
}
  801b4c:	83 c4 1c             	add    $0x1c,%esp

    // call user main routine
    int ret = main(argc, argv);

    // exit gracefully
    exit(ret);
  801b4f:	e9 18 00 00 00       	jmp    801b6c <exit>

00801b54 <putc>:

    return ret;
}

void
putc(char c) {
  801b54:	57                   	push   %edi
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
    //
    // The last clause tells the assembler that this can
    // potentially change the condition codes and arbitrary
    // memory locations.

    asm volatile("int %1\n"
  801b57:	31 c0                	xor    %eax,%eax
  801b59:	0f be 54 24 10       	movsbl 0x10(%esp),%edx
  801b5e:	89 c1                	mov    %eax,%ecx
  801b60:	89 c3                	mov    %eax,%ebx
  801b62:	89 c7                	mov    %eax,%edi
  801b64:	89 c6                	mov    %eax,%esi
  801b66:	cd 30                	int    $0x30
}

void
putc(char c) {
    syscall(syscall_putc, 0, (uint32_t) c, 0, 0, 0, 0);
}
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5f                   	pop    %edi
  801b6b:	c3                   	ret    

00801b6c <exit>:

void
exit(int code) {
  801b6c:	57                   	push   %edi
  801b6d:	56                   	push   %esi
  801b6e:	53                   	push   %ebx
    //
    // The last clause tells the assembler that this can
    // potentially change the condition codes and arbitrary
    // memory locations.

    asm volatile("int %1\n"
  801b6f:	31 c9                	xor    %ecx,%ecx
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	8b 54 24 10          	mov    0x10(%esp),%edx
  801b7a:	89 cb                	mov    %ecx,%ebx
  801b7c:	89 cf                	mov    %ecx,%edi
  801b7e:	89 ce                	mov    %ecx,%esi
  801b80:	cd 30                	int    $0x30
}

void
exit(int code) {
    syscall(syscall_exit, 0, (uint32_t) code, 0, 0, 0, 0);
}
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5f                   	pop    %edi
  801b85:	c3                   	ret    
  801b86:	66 90                	xchg   %ax,%ax

00801b88 <__udivdi3>:
  801b88:	55                   	push   %ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 1c             	sub    $0x1c,%esp
  801b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9f:	89 ca                	mov    %ecx,%edx
  801ba1:	89 f8                	mov    %edi,%eax
  801ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ba7:	85 f6                	test   %esi,%esi
  801ba9:	75 2d                	jne    801bd8 <__udivdi3+0x50>
  801bab:	39 cf                	cmp    %ecx,%edi
  801bad:	77 65                	ja     801c14 <__udivdi3+0x8c>
  801baf:	89 fd                	mov    %edi,%ebp
  801bb1:	85 ff                	test   %edi,%edi
  801bb3:	75 0b                	jne    801bc0 <__udivdi3+0x38>
  801bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bba:	31 d2                	xor    %edx,%edx
  801bbc:	f7 f7                	div    %edi
  801bbe:	89 c5                	mov    %eax,%ebp
  801bc0:	31 d2                	xor    %edx,%edx
  801bc2:	89 c8                	mov    %ecx,%eax
  801bc4:	f7 f5                	div    %ebp
  801bc6:	89 c1                	mov    %eax,%ecx
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	f7 f5                	div    %ebp
  801bcc:	89 cf                	mov    %ecx,%edi
  801bce:	89 fa                	mov    %edi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	39 ce                	cmp    %ecx,%esi
  801bda:	77 28                	ja     801c04 <__udivdi3+0x7c>
  801bdc:	0f bd fe             	bsr    %esi,%edi
  801bdf:	83 f7 1f             	xor    $0x1f,%edi
  801be2:	75 40                	jne    801c24 <__udivdi3+0x9c>
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	72 0a                	jb     801bf2 <__udivdi3+0x6a>
  801be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bec:	0f 87 9e 00 00 00    	ja     801c90 <__udivdi3+0x108>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	89 fa                	mov    %edi,%edx
  801bf9:	83 c4 1c             	add    $0x1c,%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5f                   	pop    %edi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    
  801c01:	8d 76 00             	lea    0x0(%esi),%esi
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	31 c0                	xor    %eax,%eax
  801c08:	89 fa                	mov    %edi,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	f7 f7                	div    %edi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	89 fa                	mov    %edi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c29:	89 eb                	mov    %ebp,%ebx
  801c2b:	29 fb                	sub    %edi,%ebx
  801c2d:	89 f9                	mov    %edi,%ecx
  801c2f:	d3 e6                	shl    %cl,%esi
  801c31:	89 c5                	mov    %eax,%ebp
  801c33:	88 d9                	mov    %bl,%cl
  801c35:	d3 ed                	shr    %cl,%ebp
  801c37:	89 e9                	mov    %ebp,%ecx
  801c39:	09 f1                	or     %esi,%ecx
  801c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c3f:	89 f9                	mov    %edi,%ecx
  801c41:	d3 e0                	shl    %cl,%eax
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	88 d9                	mov    %bl,%cl
  801c49:	d3 ee                	shr    %cl,%esi
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e2                	shl    %cl,%edx
  801c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	09 c2                	or     %eax,%edx
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	f7 74 24 0c          	divl   0xc(%esp)
  801c61:	89 d6                	mov    %edx,%esi
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	f7 e5                	mul    %ebp
  801c67:	39 d6                	cmp    %edx,%esi
  801c69:	72 19                	jb     801c84 <__udivdi3+0xfc>
  801c6b:	74 0b                	je     801c78 <__udivdi3+0xf0>
  801c6d:	89 d8                	mov    %ebx,%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 58 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c7c:	89 f9                	mov    %edi,%ecx
  801c7e:	d3 e2                	shl    %cl,%edx
  801c80:	39 c2                	cmp    %eax,%edx
  801c82:	73 e9                	jae    801c6d <__udivdi3+0xe5>
  801c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c87:	31 ff                	xor    %edi,%edi
  801c89:	e9 40 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	31 c0                	xor    %eax,%eax
  801c92:	e9 37 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c97:	90                   	nop

00801c98 <__umoddi3>:
  801c98:	55                   	push   %ebp
  801c99:	57                   	push   %edi
  801c9a:	56                   	push   %esi
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 1c             	sub    $0x1c,%esp
  801c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb7:	89 f3                	mov    %esi,%ebx
  801cb9:	89 fa                	mov    %edi,%edx
  801cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbf:	89 34 24             	mov    %esi,(%esp)
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	75 1a                	jne    801ce0 <__umoddi3+0x48>
  801cc6:	39 f7                	cmp    %esi,%edi
  801cc8:	0f 86 a2 00 00 00    	jbe    801d70 <__umoddi3+0xd8>
  801cce:	89 c8                	mov    %ecx,%eax
  801cd0:	89 f2                	mov    %esi,%edx
  801cd2:	f7 f7                	div    %edi
  801cd4:	89 d0                	mov    %edx,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	83 c4 1c             	add    $0x1c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    
  801ce0:	39 f0                	cmp    %esi,%eax
  801ce2:	0f 87 ac 00 00 00    	ja     801d94 <__umoddi3+0xfc>
  801ce8:	0f bd e8             	bsr    %eax,%ebp
  801ceb:	83 f5 1f             	xor    $0x1f,%ebp
  801cee:	0f 84 ac 00 00 00    	je     801da0 <__umoddi3+0x108>
  801cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf9:	29 ef                	sub    %ebp,%edi
  801cfb:	89 fe                	mov    %edi,%esi
  801cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d01:	89 e9                	mov    %ebp,%ecx
  801d03:	d3 e0                	shl    %cl,%eax
  801d05:	89 d7                	mov    %edx,%edi
  801d07:	89 f1                	mov    %esi,%ecx
  801d09:	d3 ef                	shr    %cl,%edi
  801d0b:	09 c7                	or     %eax,%edi
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e2                	shl    %cl,%edx
  801d11:	89 14 24             	mov    %edx,(%esp)
  801d14:	89 d8                	mov    %ebx,%eax
  801d16:	d3 e0                	shl    %cl,%eax
  801d18:	89 c2                	mov    %eax,%edx
  801d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1e:	d3 e0                	shl    %cl,%eax
  801d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d28:	89 f1                	mov    %esi,%ecx
  801d2a:	d3 e8                	shr    %cl,%eax
  801d2c:	09 d0                	or     %edx,%eax
  801d2e:	d3 eb                	shr    %cl,%ebx
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	f7 f7                	div    %edi
  801d34:	89 d3                	mov    %edx,%ebx
  801d36:	f7 24 24             	mull   (%esp)
  801d39:	89 c6                	mov    %eax,%esi
  801d3b:	89 d1                	mov    %edx,%ecx
  801d3d:	39 d3                	cmp    %edx,%ebx
  801d3f:	0f 82 87 00 00 00    	jb     801dcc <__umoddi3+0x134>
  801d45:	0f 84 91 00 00 00    	je     801ddc <__umoddi3+0x144>
  801d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d4f:	29 f2                	sub    %esi,%edx
  801d51:	19 cb                	sbb    %ecx,%ebx
  801d53:	89 d8                	mov    %ebx,%eax
  801d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d59:	d3 e0                	shl    %cl,%eax
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	d3 ea                	shr    %cl,%edx
  801d5f:	09 d0                	or     %edx,%eax
  801d61:	89 e9                	mov    %ebp,%ecx
  801d63:	d3 eb                	shr    %cl,%ebx
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	83 c4 1c             	add    $0x1c,%esp
  801d6a:	5b                   	pop    %ebx
  801d6b:	5e                   	pop    %esi
  801d6c:	5f                   	pop    %edi
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    
  801d6f:	90                   	nop
  801d70:	89 fd                	mov    %edi,%ebp
  801d72:	85 ff                	test   %edi,%edi
  801d74:	75 0b                	jne    801d81 <__umoddi3+0xe9>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f7                	div    %edi
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 f0                	mov    %esi,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f5                	div    %ebp
  801d87:	89 c8                	mov    %ecx,%eax
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	e9 44 ff ff ff       	jmp    801cd6 <__umoddi3+0x3e>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	89 c8                	mov    %ecx,%eax
  801d96:	89 f2                	mov    %esi,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	3b 04 24             	cmp    (%esp),%eax
  801da3:	72 06                	jb     801dab <__umoddi3+0x113>
  801da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da9:	77 0f                	ja     801dba <__umoddi3+0x122>
  801dab:	89 f2                	mov    %esi,%edx
  801dad:	29 f9                	sub    %edi,%ecx
  801daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801db3:	89 14 24             	mov    %edx,(%esp)
  801db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dbe:	8b 14 24             	mov    (%esp),%edx
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
  801dc9:	8d 76 00             	lea    0x0(%esi),%esi
  801dcc:	2b 04 24             	sub    (%esp),%eax
  801dcf:	19 fa                	sbb    %edi,%edx
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	89 c6                	mov    %eax,%esi
  801dd5:	e9 71 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de0:	72 ea                	jb     801dcc <__umoddi3+0x134>
  801de2:	89 d9                	mov    %ebx,%ecx
  801de4:	e9 62 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
