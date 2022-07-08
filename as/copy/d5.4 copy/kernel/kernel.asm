
kernel.out:     file format elf32-i386


Disassembly of section .text:

0000c400 <start>:

  


  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    c400:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    c402:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    c404:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    c406:	8e d0                	mov    %eax,%ss
  
  movb $0x13,%al  # ;vga 320x200x8 位,color mode 
    c408:	b0 13                	mov    $0x13,%al
  movb $0x00,%ah
    c40a:	b4 00                	mov    $0x0,%ah
  int $0x10
    c40c:	cd 10                	int    $0x10
  
#save color mode in ram 0x0ff0
 movb $8,(VMODE)
    c40e:	c6 06 f2             	movb   $0xf2,(%esi)
    c411:	0f 08                	invd   
 movw $320,(SCRNX)
    c413:	c7 06 f4 0f 40 01    	movl   $0x1400ff4,(%esi)
 movw $200,(SCRNY)
    c419:	c7 06 f6 0f c8 00    	movl   $0xc80ff6,(%esi)
 movl $0x000a0000,(VRAM)
    c41f:	66 c7 06 f8 0f       	movw   $0xff8,(%esi)
    c424:	00 00                	add    %al,(%eax)
    c426:	0a 00                	or     (%eax),%al

 #get keyboard led status
 movb	$0x02,%ah 
    c428:	b4 02                	mov    $0x2,%ah
 int     $0x16			#keyboard interrupts
    c42a:	cd 16                	int    $0x16
 movb   %al,(LEDS)
    c42c:	a2 f1 0f be 67       	mov    %al,0x67be0ff1
		
		
		
#diplay something
  movw $msg,%si
    c431:	c4                   	(bad)  
  call puts
    c432:	e8 5f 00 be 83       	call   83bec496 <__bss_start+0x83bdfa06>
  
  movw $try,%si
    c437:	c4                   	(bad)  
  call puts
    c438:	e8 59 00 fa fc       	call   fcfac496 <__bss_start+0xfcf9fa06>

0000c43d <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this. 
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    c43d:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    c43f:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    c441:	75 fa                	jne    c43d <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    c443:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    c445:	e6 64                	out    %al,$0x64

0000c447 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    c447:	e4 64                	in     $0x64,%al
  testb   $02,%al
    c449:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    c44b:	75 fa                	jne    c447 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    c44d:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    c44f:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode, using a bootstrap GDT       this is vip ,but i don`t know it clearly now
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    c451:	0f 01 16             	lgdtl  (%esi)
    c454:	dc c4                	fadd   %st,%st(4)
  movl    %cr0, %eax
    c456:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE_ON, %eax
    c459:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    c45d:	0f 22 c0             	mov    %eax,%cr0

0000c460 <f1>:
  
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
f1:
  jmp f1
    c460:	eb fe                	jmp    c460 <f1>
  ljmp    $PROT_MODE_CSEG, $protcseg
    c462:	ea                   	.byte 0xea
    c463:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    c464:	c4 08                	les    (%eax),%ecx
	...

0000c467 <msg>:
    c467:	0d 0a 0a 0d 6d       	or     $0x6d0d0a0a,%eax
    c46c:	79 20                	jns    c48e <try+0xb>
    c46e:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
    c472:	65 6c                	gs insb (%dx),%es:(%edi)
    c474:	20 69 73             	and    %ch,0x73(%ecx)
    c477:	20 72 75             	and    %dh,0x75(%edx)
    c47a:	6e                   	outsb  %ds:(%esi),(%dx)
    c47b:	69 6e 67 20 6a 6f 73 	imul   $0x736f6a20,0x67(%esi),%ebp
	...

0000c483 <try>:
    c483:	0d 0a 0a 0d 74       	or     $0x740d0a0a,%eax
    c488:	72 79                	jb     c503 <bootmain+0x21>
    c48a:	20 69 74             	and    %ch,0x74(%ecx)
    c48d:	20 61 67             	and    %ah,0x67(%ecx)
    c490:	61                   	popa   
    c491:	69                   	.byte 0x69
    c492:	6e                   	outsb  %ds:(%esi),(%dx)
	...

0000c494 <puts>:
 try:
  .asciz "\r\n\n\rtry it again"

puts:

	movb (%si),%al
    c494:	8a 04 83             	mov    (%ebx,%eax,4),%al
	add $1,%si
    c497:	c6 01 3c             	movb   $0x3c,(%ecx)
	cmp $0,%al
    c49a:	00 74 09 b4          	add    %dh,-0x4c(%ecx,%ecx,1)
	je over
	movb $0x0e,%ah
    c49e:	0e                   	push   %cs
	movw $15,%bx
    c49f:	bb 0f 00 cd 10       	mov    $0x10cd000f,%ebx
	int $0x10
	jmp puts
    c4a4:	eb ee                	jmp    c494 <puts>

0000c4a6 <over>:
over:
	ret	
    c4a6:	c3                   	ret    

0000c4a7 <protcseg>:
	
	
  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    c4a7:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    c4ab:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    c4ad:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    c4af:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    c4b1:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    c4b3:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    c4b5:	bc 00 c4 00 00       	mov    $0xc400,%esp
  call bootmain
    c4ba:	e8 23 00 00 00       	call   c4e2 <bootmain>

0000c4bf <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    c4bf:	eb fe                	jmp    c4bf <spin>
    c4c1:	8d 76 00             	lea    0x0(%esi),%esi

0000c4c4 <gdt>:
	...
    c4cc:	ff                   	(bad)  
    c4cd:	ff 00                	incl   (%eax)
    c4cf:	00 00                	add    %al,(%eax)
    c4d1:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    c4d8:	00                   	.byte 0x0
    c4d9:	92                   	xchg   %eax,%edx
    c4da:	cf                   	iret   
	...

0000c4dc <gdtdesc>:
    c4dc:	17                   	pop    %ss
    c4dd:	00 c4                	add    %al,%ah
    c4df:	c4 00                	les    (%eax),%eax
	...

0000c4e2 <bootmain>:

	//putfont8(vram, 20, 50, 50, 'd', font_A);
	putfont8(binfo->vram binfo->xsize, 8, 8, COL8_FFFFFF, font_A);
}
*/
void bootmain(void){
    c4e2:	f3 0f 1e fb          	endbr32 
    c4e6:	55                   	push   %ebp
    c4e7:	89 e5                	mov    %esp,%ebp
    c4e9:	53                   	push   %ebx
    c4ea:	e8 4f 00 00 00       	call   c53e <__x86.get_pc_thunk.bx>
    c4ef:	81 c3 45 05 00 00    	add    $0x545,%ebx
    c4f5:	50                   	push   %eax
	static char font_A[16]={
		0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24,
		0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00
	};
	
	init_palette();
    c4f6:	e8 d2 00 00 00       	call   c5cd <init_palette>
	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
    c4fb:	52                   	push   %edx
    c4fc:	0f bf 05 f6 0f 00 00 	movswl 0xff6,%eax
    c503:	50                   	push   %eax
    c504:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
    c50b:	50                   	push   %eax
    c50c:	ff 35 f8 0f 00 00    	pushl  0xff8
    c512:	e8 51 01 00 00       	call   c668 <init_screen>
	putfont8(binfo->vram, binfo->scrnx, 10, 10, COL8_FFFFFF, font_A);
    c517:	59                   	pop    %ecx
    c518:	58                   	pop    %eax
    c519:	8d 83 0c 00 00 00    	lea    0xc(%ebx),%eax
    c51f:	50                   	push   %eax
    c520:	0f bf 05 f4 0f 00 00 	movswl 0xff4,%eax
    c527:	6a 07                	push   $0x7
    c529:	6a 0a                	push   $0xa
    c52b:	6a 0a                	push   $0xa
    c52d:	50                   	push   %eax
    c52e:	ff 35 f8 0f 00 00    	pushl  0xff8
    c534:	e8 f7 02 00 00       	call   c830 <putfont8>
    c539:	83 c4 20             	add    $0x20,%esp
    c53c:	eb fe                	jmp    c53c <bootmain+0x5a>

0000c53e <__x86.get_pc_thunk.bx>:
    c53e:	8b 1c 24             	mov    (%esp),%ebx
    c541:	c3                   	ret    

0000c542 <clear_screen>:
#include<header.h>


void clear_screen(char color) //15:pure white
{
    c542:	f3 0f 1e fb          	endbr32 
    c546:	55                   	push   %ebp
    c547:	89 e5                	mov    %esp,%ebp
    c549:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
	int i;
	for(i=0xa0000;i<0xaffff;i++)
    c54d:	b8 00 00 0a 00       	mov    $0xa0000,%eax
	{
		write_mem8(i,color);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
    c552:	88 10                	mov    %dl,(%eax)
	for(i=0xa0000;i<0xaffff;i++)
    c554:	83 c0 01             	add    $0x1,%eax
    c557:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
    c55c:	75 f4                	jne    c552 <clear_screen+0x10>

	}
}
    c55e:	5d                   	pop    %ebp
    c55f:	c3                   	ret    

0000c560 <color_screen>:

void color_screen(char color) //15:pure white
{
    c560:	f3 0f 1e fb          	endbr32 
	int i;
	color=color;
	for(i=0xa0000;i<0xaffff;i++)
    c564:	b8 00 00 0a 00       	mov    $0xa0000,%eax
	{
		write_mem8(i,i&0x0f);  //if we write 15 ,all pixels color will be white,15 mens pure white ,so the screen changes into white
    c569:	89 c2                	mov    %eax,%edx
    c56b:	83 e2 0f             	and    $0xf,%edx
    c56e:	88 10                	mov    %dl,(%eax)
	for(i=0xa0000;i<0xaffff;i++)
    c570:	83 c0 01             	add    $0x1,%eax
    c573:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
    c578:	75 ef                	jne    c569 <color_screen+0x9>

	}
}
    c57a:	c3                   	ret    

0000c57b <set_palette>:

void set_palette(int start, int end, unsigned char* rgb){
    c57b:	f3 0f 1e fb          	endbr32 
    c57f:	55                   	push   %ebp
    c580:	89 e5                	mov    %esp,%ebp
    c582:	56                   	push   %esi
    c583:	53                   	push   %ebx
    c584:	8b 45 08             	mov    0x8(%ebp),%eax
    c587:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    c58a:	8b 4d 10             	mov    0x10(%ebp),%ecx
//read eflags and write_eflags
static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
    c58d:	9c                   	pushf  
    c58e:	5e                   	pop    %esi
	int i, eflags;
	eflags = read_eflags();	//替代作者的io_load_eflags()
	io_cli();
    c58f:	fa                   	cli    
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    c590:	ba c8 03 00 00       	mov    $0x3c8,%edx
    c595:	ee                   	out    %al,(%dx)
	outb(0x03c8, start);	//替代作者的io_out8()
	for(i=start; i<=end; i++){
    c596:	39 d8                	cmp    %ebx,%eax
    c598:	7f 2d                	jg     c5c7 <set_palette+0x4c>
    c59a:	83 c3 01             	add    $0x1,%ebx
    c59d:	29 c3                	sub    %eax,%ebx
    c59f:	8d 1c 5b             	lea    (%ebx,%ebx,2),%ebx
    c5a2:	01 cb                	add    %ecx,%ebx
    c5a4:	ba c9 03 00 00       	mov    $0x3c9,%edx
		outb(0x03c9,rgb[0]/4);
    c5a9:	0f b6 01             	movzbl (%ecx),%eax
    c5ac:	c0 e8 02             	shr    $0x2,%al
    c5af:	ee                   	out    %al,(%dx)
		outb(0x03c9,rgb[1]/4);
    c5b0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    c5b4:	c0 e8 02             	shr    $0x2,%al
    c5b7:	ee                   	out    %al,(%dx)
		outb(0x03c9,rgb[2]/4);
    c5b8:	0f b6 41 02          	movzbl 0x2(%ecx),%eax
    c5bc:	c0 e8 02             	shr    $0x2,%al
    c5bf:	ee                   	out    %al,(%dx)
		rgb+=3;
    c5c0:	83 c1 03             	add    $0x3,%ecx
	for(i=start; i<=end; i++){
    c5c3:	39 d9                	cmp    %ebx,%ecx
    c5c5:	75 e2                	jne    c5a9 <set_palette+0x2e>
}

static __inline void
write_eflags(uint32_t eflags)
{
        __asm __volatile("pushl %0; popfl" : : "r" (eflags));
    c5c7:	56                   	push   %esi
    c5c8:	9d                   	popf   
	}
	write_eflags(eflags);	//替代作者的io_store_eflags(eflags)
	return;
}
    c5c9:	5b                   	pop    %ebx
    c5ca:	5e                   	pop    %esi
    c5cb:	5d                   	pop    %ebp
    c5cc:	c3                   	ret    

0000c5cd <init_palette>:


void init_palette(void){
    c5cd:	f3 0f 1e fb          	endbr32 
    c5d1:	55                   	push   %ebp
    c5d2:	89 e5                	mov    %esp,%ebp
    c5d4:	83 ec 0c             	sub    $0xc,%esp
    c5d7:	e8 c7 02 00 00       	call   c8a3 <__x86.get_pc_thunk.ax>
    c5dc:	05 58 04 00 00       	add    $0x458,%eax
		0x00,0x00,0x84,   /*12:dark 青*/
		0x84,0x00,0x84,   /*13:dark purper*/
		0x00,0x84,0x84,   /*14:light blue*/
		0x84,0x84,0x84,   /*15:dark gray*/
	};  
	set_palette(0,15,table_rgb);
    c5e1:	8d 80 2c 00 00 00    	lea    0x2c(%eax),%eax
    c5e7:	50                   	push   %eax
    c5e8:	6a 0f                	push   $0xf
    c5ea:	6a 00                	push   $0x0
    c5ec:	e8 8a ff ff ff       	call   c57b <set_palette>
	return;
    c5f1:	83 c4 10             	add    $0x10,%esp
}
    c5f4:	c9                   	leave  
    c5f5:	c3                   	ret    

0000c5f6 <boxfill8>:

void boxfill8(char* vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1){
    c5f6:	f3 0f 1e fb          	endbr32 
    c5fa:	55                   	push   %ebp
    c5fb:	89 e5                	mov    %esp,%ebp
    c5fd:	57                   	push   %edi
    c5fe:	56                   	push   %esi
    c5ff:	53                   	push   %ebx
    c600:	83 ec 08             	sub    $0x8,%esp
    c603:	8b 75 0c             	mov    0xc(%ebp),%esi
    c606:	8b 5d 18             	mov    0x18(%ebp),%ebx
    c609:	8b 7d 20             	mov    0x20(%ebp),%edi
    c60c:	0f b6 4d 10          	movzbl 0x10(%ebp),%ecx
	int x, y;
	for(y=y0; y<=y1; y++){
    c610:	39 fb                	cmp    %edi,%ebx
    c612:	7f 4c                	jg     c660 <boxfill8+0x6a>
    c614:	89 75 ec             	mov    %esi,-0x14(%ebp)
    c617:	8b 45 08             	mov    0x8(%ebp),%eax
    c61a:	8b 55 1c             	mov    0x1c(%ebp),%edx
    c61d:	8d 54 10 01          	lea    0x1(%eax,%edx,1),%edx
    c621:	89 f0                	mov    %esi,%eax
    c623:	0f af c3             	imul   %ebx,%eax
    c626:	01 c2                	add    %eax,%edx
    c628:	8d 77 01             	lea    0x1(%edi),%esi
    c62b:	8b 7d 14             	mov    0x14(%ebp),%edi
    c62e:	2b 7d 1c             	sub    0x1c(%ebp),%edi
    c631:	83 ef 01             	sub    $0x1,%edi
    c634:	88 4d f3             	mov    %cl,-0xd(%ebp)
    c637:	eb 1a                	jmp    c653 <boxfill8+0x5d>
    c639:	0f b6 4d f3          	movzbl -0xd(%ebp),%ecx
		for(x=x0; x<=x1; x++){
			vram[y*xsize+x]=c;
    c63d:	88 08                	mov    %cl,(%eax)
    c63f:	83 c0 01             	add    $0x1,%eax
		for(x=x0; x<=x1; x++){
    c642:	39 d0                	cmp    %edx,%eax
    c644:	75 f7                	jne    c63d <boxfill8+0x47>
    c646:	88 4d f3             	mov    %cl,-0xd(%ebp)
	for(y=y0; y<=y1; y++){
    c649:	83 c3 01             	add    $0x1,%ebx
    c64c:	03 55 ec             	add    -0x14(%ebp),%edx
    c64f:	39 f3                	cmp    %esi,%ebx
    c651:	74 0d                	je     c660 <boxfill8+0x6a>
    c653:	8d 04 17             	lea    (%edi,%edx,1),%eax
		for(x=x0; x<=x1; x++){
    c656:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
    c659:	39 4d 14             	cmp    %ecx,0x14(%ebp)
    c65c:	7e db                	jle    c639 <boxfill8+0x43>
    c65e:	eb e9                	jmp    c649 <boxfill8+0x53>
		}
	}
	return;
}
    c660:	83 c4 08             	add    $0x8,%esp
    c663:	5b                   	pop    %ebx
    c664:	5e                   	pop    %esi
    c665:	5f                   	pop    %edi
    c666:	5d                   	pop    %ebp
    c667:	c3                   	ret    

0000c668 <init_screen>:
   binfo->color_mode = 8;
   binfo->xsize = 320;
   binfo->ysize = 200;
   }
   */
void init_screen(char *vram, int x, int y){
    c668:	f3 0f 1e fb          	endbr32 
    c66c:	55                   	push   %ebp
    c66d:	89 e5                	mov    %esp,%ebp
    c66f:	57                   	push   %edi
    c670:	56                   	push   %esi
    c671:	53                   	push   %ebx
    c672:	83 ec 14             	sub    $0x14,%esp
    c675:	8b 7d 08             	mov    0x8(%ebp),%edi
    c678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    c67b:	8b 75 10             	mov    0x10(%ebp),%esi
	boxfill8(vram, x, COL8_008484,  0,     0,      x -  1, y - 29);
    c67e:	8d 43 ff             	lea    -0x1(%ebx),%eax
    c681:	89 c2                	mov    %eax,%edx
    c683:	8d 46 e3             	lea    -0x1d(%esi),%eax
    c686:	50                   	push   %eax
    c687:	89 55 f0             	mov    %edx,-0x10(%ebp)
    c68a:	52                   	push   %edx
    c68b:	6a 00                	push   $0x0
    c68d:	6a 00                	push   $0x0
    c68f:	6a 0e                	push   $0xe
    c691:	53                   	push   %ebx
    c692:	57                   	push   %edi
    c693:	e8 5e ff ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_C6C6C6,  0,     y - 28, x -  1, y - 28);
    c698:	8d 46 e4             	lea    -0x1c(%esi),%eax
    c69b:	50                   	push   %eax
    c69c:	ff 75 f0             	pushl  -0x10(%ebp)
    c69f:	50                   	push   %eax
    c6a0:	6a 00                	push   $0x0
    c6a2:	6a 08                	push   $0x8
    c6a4:	53                   	push   %ebx
    c6a5:	57                   	push   %edi
    c6a6:	e8 4b ff ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_FFFFFF,  0,     y - 27, x -  1, y - 27);
    c6ab:	8d 46 e5             	lea    -0x1b(%esi),%eax
    c6ae:	83 c4 38             	add    $0x38,%esp
    c6b1:	50                   	push   %eax
    c6b2:	ff 75 f0             	pushl  -0x10(%ebp)
    c6b5:	50                   	push   %eax
    c6b6:	6a 00                	push   $0x0
    c6b8:	6a 07                	push   $0x7
    c6ba:	53                   	push   %ebx
    c6bb:	57                   	push   %edi
    c6bc:	e8 35 ff ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_C6C6C6,  0,     y - 26, x -  1, y -  1);
    c6c1:	8d 46 ff             	lea    -0x1(%esi),%eax
    c6c4:	50                   	push   %eax
    c6c5:	ff 75 f0             	pushl  -0x10(%ebp)
    c6c8:	8d 46 e6             	lea    -0x1a(%esi),%eax
    c6cb:	50                   	push   %eax
    c6cc:	6a 00                	push   $0x0
    c6ce:	6a 08                	push   $0x8
    c6d0:	53                   	push   %ebx
    c6d1:	57                   	push   %edi
    c6d2:	e8 1f ff ff ff       	call   c5f6 <boxfill8>

	boxfill8(vram, x, COL8_FFFFFF,  3,     y - 24, 59,     y - 24);
    c6d7:	8d 46 e8             	lea    -0x18(%esi),%eax
    c6da:	83 c4 38             	add    $0x38,%esp
    c6dd:	50                   	push   %eax
    c6de:	6a 3b                	push   $0x3b
    c6e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    c6e3:	50                   	push   %eax
    c6e4:	6a 03                	push   $0x3
    c6e6:	6a 07                	push   $0x7
    c6e8:	53                   	push   %ebx
    c6e9:	57                   	push   %edi
    c6ea:	e8 07 ff ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_FFFFFF,  2,     y - 24,  2,     y -  4);
    c6ef:	8d 4e fc             	lea    -0x4(%esi),%ecx
    c6f2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
    c6f5:	51                   	push   %ecx
    c6f6:	6a 02                	push   $0x2
    c6f8:	ff 75 f0             	pushl  -0x10(%ebp)
    c6fb:	6a 02                	push   $0x2
    c6fd:	6a 07                	push   $0x7
    c6ff:	53                   	push   %ebx
    c700:	57                   	push   %edi
    c701:	e8 f0 fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_848484,  3,     y -  4, 59,     y -  4);
    c706:	83 c4 38             	add    $0x38,%esp
    c709:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    c70c:	51                   	push   %ecx
    c70d:	6a 3b                	push   $0x3b
    c70f:	51                   	push   %ecx
    c710:	6a 03                	push   $0x3
    c712:	6a 0f                	push   $0xf
    c714:	53                   	push   %ebx
    c715:	57                   	push   %edi
    c716:	e8 db fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_848484, 59,     y - 23, 59,     y -  5);
    c71b:	8d 56 e9             	lea    -0x17(%esi),%edx
    c71e:	8d 46 fb             	lea    -0x5(%esi),%eax
    c721:	50                   	push   %eax
    c722:	6a 3b                	push   $0x3b
    c724:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    c727:	52                   	push   %edx
    c728:	6a 3b                	push   $0x3b
    c72a:	6a 0f                	push   $0xf
    c72c:	53                   	push   %ebx
    c72d:	57                   	push   %edi
    c72e:	e8 c3 fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_000000,  2,     y -  3, 59,     y -  3);
    c733:	83 ee 03             	sub    $0x3,%esi
    c736:	83 c4 38             	add    $0x38,%esp
    c739:	56                   	push   %esi
    c73a:	6a 3b                	push   $0x3b
    c73c:	56                   	push   %esi
    c73d:	6a 02                	push   $0x2
    c73f:	6a 00                	push   $0x0
    c741:	53                   	push   %ebx
    c742:	57                   	push   %edi
    c743:	e8 ae fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_000000, 60,     y - 24, 60,     y -  3);
    c748:	56                   	push   %esi
    c749:	6a 3c                	push   $0x3c
    c74b:	ff 75 f0             	pushl  -0x10(%ebp)
    c74e:	6a 3c                	push   $0x3c
    c750:	6a 00                	push   $0x0
    c752:	53                   	push   %ebx
    c753:	57                   	push   %edi
    c754:	e8 9d fe ff ff       	call   c5f6 <boxfill8>

	boxfill8(vram, x, COL8_848484, x - 47, y - 24, x -  4, y - 24);
    c759:	8d 4b fc             	lea    -0x4(%ebx),%ecx
    c75c:	8d 53 d1             	lea    -0x2f(%ebx),%edx
    c75f:	83 c4 38             	add    $0x38,%esp
    c762:	8b 45 f0             	mov    -0x10(%ebp),%eax
    c765:	50                   	push   %eax
    c766:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    c769:	51                   	push   %ecx
    c76a:	50                   	push   %eax
    c76b:	89 55 e8             	mov    %edx,-0x18(%ebp)
    c76e:	52                   	push   %edx
    c76f:	6a 0f                	push   $0xf
    c771:	53                   	push   %ebx
    c772:	57                   	push   %edi
    c773:	e8 7e fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_848484, x - 47, y - 23, x - 47, y -  4);
    c778:	ff 75 ec             	pushl  -0x14(%ebp)
    c77b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    c77e:	52                   	push   %edx
    c77f:	ff 75 e4             	pushl  -0x1c(%ebp)
    c782:	52                   	push   %edx
    c783:	6a 0f                	push   $0xf
    c785:	53                   	push   %ebx
    c786:	57                   	push   %edi
    c787:	e8 6a fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_FFFFFF, x - 47, y -  3, x -  4, y -  3);
    c78c:	83 c4 38             	add    $0x38,%esp
    c78f:	56                   	push   %esi
    c790:	ff 75 e0             	pushl  -0x20(%ebp)
    c793:	56                   	push   %esi
    c794:	ff 75 e8             	pushl  -0x18(%ebp)
    c797:	6a 07                	push   $0x7
    c799:	53                   	push   %ebx
    c79a:	57                   	push   %edi
    c79b:	e8 56 fe ff ff       	call   c5f6 <boxfill8>
	boxfill8(vram, x, COL8_FFFFFF, x -  3, y - 24, x -  3, y -  3);
    c7a0:	8d 43 fd             	lea    -0x3(%ebx),%eax
    c7a3:	56                   	push   %esi
    c7a4:	50                   	push   %eax
    c7a5:	ff 75 f0             	pushl  -0x10(%ebp)
    c7a8:	50                   	push   %eax
    c7a9:	6a 07                	push   $0x7
    c7ab:	53                   	push   %ebx
    c7ac:	57                   	push   %edi
    c7ad:	e8 44 fe ff ff       	call   c5f6 <boxfill8>
	return;
    c7b2:	83 c4 38             	add    $0x38,%esp
}
    c7b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    c7b8:	5b                   	pop    %ebx
    c7b9:	5e                   	pop    %esi
    c7ba:	5f                   	pop    %edi
    c7bb:	5d                   	pop    %ebp
    c7bc:	c3                   	ret    

0000c7bd <putfont>:

void putfont(char* vram, int xsize, int x, int y, char c, char *font){
    c7bd:	f3 0f 1e fb          	endbr32 
    c7c1:	55                   	push   %ebp
    c7c2:	89 e5                	mov    %esp,%ebp
    c7c4:	57                   	push   %edi
    c7c5:	56                   	push   %esi
    c7c6:	53                   	push   %ebx
    c7c7:	8b 55 0c             	mov    0xc(%ebp),%edx
    c7ca:	8b 75 1c             	mov    0x1c(%ebp),%esi
    c7cd:	0f b6 5d 18          	movzbl 0x18(%ebp),%ebx
    c7d1:	89 f1                	mov    %esi,%ecx
    c7d3:	89 d7                	mov    %edx,%edi
    c7d5:	0f af 55 14          	imul   0x14(%ebp),%edx
    c7d9:	03 55 10             	add    0x10(%ebp),%edx
    c7dc:	03 55 08             	add    0x8(%ebp),%edx
    c7df:	83 c6 10             	add    $0x10,%esi
    c7e2:	eb 0d                	jmp    c7f1 <putfont+0x34>
	int i;
	char d, *p;
	for(i=0; i<16; i++){
		d=font[i];
		p=vram+(y+i)*xsize+x;
		if((d&0x80)!=0) p[0]=c;
    c7e4:	88 1a                	mov    %bl,(%edx)
    c7e6:	eb 10                	jmp    c7f8 <putfont+0x3b>
    c7e8:	83 c1 01             	add    $0x1,%ecx
    c7eb:	01 fa                	add    %edi,%edx
	for(i=0; i<16; i++){
    c7ed:	39 f1                	cmp    %esi,%ecx
    c7ef:	74 3a                	je     c82b <putfont+0x6e>
		d=font[i];
    c7f1:	0f b6 01             	movzbl (%ecx),%eax
		if((d&0x80)!=0) p[0]=c;
    c7f4:	84 c0                	test   %al,%al
    c7f6:	78 ec                	js     c7e4 <putfont+0x27>
		if((d&0x40)!=0) p[1]=c;
    c7f8:	a8 40                	test   $0x40,%al
    c7fa:	74 03                	je     c7ff <putfont+0x42>
    c7fc:	88 5a 01             	mov    %bl,0x1(%edx)
		if((d&0x20)!=0) p[2]=c;
    c7ff:	a8 20                	test   $0x20,%al
    c801:	74 03                	je     c806 <putfont+0x49>
    c803:	88 5a 02             	mov    %bl,0x2(%edx)
		if((d&0x10)!=0) p[3]=c;
    c806:	a8 10                	test   $0x10,%al
    c808:	74 03                	je     c80d <putfont+0x50>
    c80a:	88 5a 03             	mov    %bl,0x3(%edx)
		if((d&0x08)!=0) p[4]=c;
    c80d:	a8 08                	test   $0x8,%al
    c80f:	74 03                	je     c814 <putfont+0x57>
    c811:	88 5a 04             	mov    %bl,0x4(%edx)
		if((d&0x04)!=0) p[5]=c;
    c814:	a8 04                	test   $0x4,%al
    c816:	74 03                	je     c81b <putfont+0x5e>
    c818:	88 5a 05             	mov    %bl,0x5(%edx)
		if((d&0x02)!=0) p[6]=c;
    c81b:	a8 02                	test   $0x2,%al
    c81d:	74 03                	je     c822 <putfont+0x65>
    c81f:	88 5a 06             	mov    %bl,0x6(%edx)
		if((d&0x01)!=0) p[7]=c;
    c822:	a8 01                	test   $0x1,%al
    c824:	74 c2                	je     c7e8 <putfont+0x2b>
    c826:	88 5a 07             	mov    %bl,0x7(%edx)
    c829:	eb bd                	jmp    c7e8 <putfont+0x2b>
	}
	return;
}
    c82b:	5b                   	pop    %ebx
    c82c:	5e                   	pop    %esi
    c82d:	5f                   	pop    %edi
    c82e:	5d                   	pop    %ebp
    c82f:	c3                   	ret    

0000c830 <putfont8>:

void putfont8(char *vram, int xsize, int x, int y, char c, char *font){
    c830:	f3 0f 1e fb          	endbr32 
    c834:	55                   	push   %ebp
    c835:	89 e5                	mov    %esp,%ebp
    c837:	57                   	push   %edi
    c838:	56                   	push   %esi
    c839:	53                   	push   %ebx
    c83a:	8b 55 0c             	mov    0xc(%ebp),%edx
    c83d:	8b 75 1c             	mov    0x1c(%ebp),%esi
    c840:	0f b6 5d 18          	movzbl 0x18(%ebp),%ebx
    c844:	89 f1                	mov    %esi,%ecx
    c846:	89 d7                	mov    %edx,%edi
    c848:	0f af 55 14          	imul   0x14(%ebp),%edx
    c84c:	03 55 10             	add    0x10(%ebp),%edx
    c84f:	03 55 08             	add    0x8(%ebp),%edx
    c852:	83 c6 10             	add    $0x10,%esi
    c855:	eb 0d                	jmp    c864 <putfont8+0x34>
	int i;
	char *p, d /* data */;
	for (i = 0; i < 16; i++) {
		p = vram + (y + i) * xsize + x;
		d = font[i];
		if ((d & 0x80) != 0) { p[0] = c; }
    c857:	88 1a                	mov    %bl,(%edx)
    c859:	eb 10                	jmp    c86b <putfont8+0x3b>
    c85b:	83 c1 01             	add    $0x1,%ecx
    c85e:	01 fa                	add    %edi,%edx
	for (i = 0; i < 16; i++) {
    c860:	39 f1                	cmp    %esi,%ecx
    c862:	74 3a                	je     c89e <putfont8+0x6e>
		d = font[i];
    c864:	0f b6 01             	movzbl (%ecx),%eax
		if ((d & 0x80) != 0) { p[0] = c; }
    c867:	84 c0                	test   %al,%al
    c869:	78 ec                	js     c857 <putfont8+0x27>
		if ((d & 0x40) != 0) { p[1] = c; }
    c86b:	a8 40                	test   $0x40,%al
    c86d:	74 03                	je     c872 <putfont8+0x42>
    c86f:	88 5a 01             	mov    %bl,0x1(%edx)
		if ((d & 0x20) != 0) { p[2] = c; }
    c872:	a8 20                	test   $0x20,%al
    c874:	74 03                	je     c879 <putfont8+0x49>
    c876:	88 5a 02             	mov    %bl,0x2(%edx)
		if ((d & 0x10) != 0) { p[3] = c; }
    c879:	a8 10                	test   $0x10,%al
    c87b:	74 03                	je     c880 <putfont8+0x50>
    c87d:	88 5a 03             	mov    %bl,0x3(%edx)
		if ((d & 0x08) != 0) { p[4] = c; }
    c880:	a8 08                	test   $0x8,%al
    c882:	74 03                	je     c887 <putfont8+0x57>
    c884:	88 5a 04             	mov    %bl,0x4(%edx)
		if ((d & 0x04) != 0) { p[5] = c; }
    c887:	a8 04                	test   $0x4,%al
    c889:	74 03                	je     c88e <putfont8+0x5e>
    c88b:	88 5a 05             	mov    %bl,0x5(%edx)
		if ((d & 0x02) != 0) { p[6] = c; }
    c88e:	a8 02                	test   $0x2,%al
    c890:	74 03                	je     c895 <putfont8+0x65>
    c892:	88 5a 06             	mov    %bl,0x6(%edx)
		if ((d & 0x01) != 0) { p[7] = c; }
    c895:	a8 01                	test   $0x1,%al
    c897:	74 c2                	je     c85b <putfont8+0x2b>
    c899:	88 5a 07             	mov    %bl,0x7(%edx)
    c89c:	eb bd                	jmp    c85b <putfont8+0x2b>
	}
	return;
}
    c89e:	5b                   	pop    %ebx
    c89f:	5e                   	pop    %esi
    c8a0:	5f                   	pop    %edi
    c8a1:	5d                   	pop    %ebp
    c8a2:	c3                   	ret    

0000c8a3 <__x86.get_pc_thunk.ax>:
    c8a3:	8b 04 24             	mov    (%esp),%eax
    c8a6:	c3                   	ret    
