
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 68 11 80       	mov    $0x801168f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 30 10 80       	mov    $0x801030e0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 78 10 80       	push   $0x80107860
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 f5 48 00 00       	call   80104950 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 78 10 80       	push   $0x80107867
80100097:	50                   	push   %eax
80100098:	e8 a3 47 00 00       	call   80104840 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 87 49 00 00       	call   80104a70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 49 4a 00 00       	call   80104bb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 47 00 00       	call   80104880 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 df 21 00 00       	call   80102370 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 78 10 80       	push   $0x8010786e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 5d 47 00 00       	call   80104920 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 97 21 00 00       	jmp    80102370 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 78 10 80       	push   $0x8010787f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 47 00 00       	call   80104920 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 46 00 00       	call   801048e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 48 00 00       	call   80104a70 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 42 49 00 00       	jmp    80104bb0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 78 10 80       	push   $0x80107886
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 cb 47 00 00       	call   80104a70 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 0e 43 00 00       	call   801045e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 37 00 00       	call   80103a90 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 b5 48 00 00       	call   80104bb0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ec 14 00 00       	call   801017f0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 5f 48 00 00       	call   80104bb0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 96 14 00 00       	call   801017f0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 e2 25 00 00       	call   80102980 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 78 10 80       	push   $0x8010788d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 bf 7d 10 80 	movl   $0x80107dbf,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 a3 45 00 00       	call   80104970 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 78 10 80       	push   $0x801078a1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 7c 5f 00 00       	call   801063a0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 b1 5e 00 00       	call   801063a0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 a5 5e 00 00       	call   801063a0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 99 5e 00 00       	call   801063a0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 47 00 00       	call   80104c90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 46 00 00       	call   80104c00 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 a5 78 10 80       	push   $0x801078a5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 0c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 a0 44 00 00       	call   80104a70 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 df                	cmp    %ebx,%edi
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 a7 45 00 00       	call   80104bb0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 de 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	89 c6                	mov    %eax,%esi
80100627:	53                   	push   %ebx
80100628:	89 d3                	mov    %edx,%ebx
8010062a:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062d:	85 c9                	test   %ecx,%ecx
8010062f:	74 04                	je     80100635 <printint+0x15>
80100631:	85 c0                	test   %eax,%eax
80100633:	78 63                	js     80100698 <printint+0x78>
    x = xx;
80100635:	89 f1                	mov    %esi,%ecx
80100637:	31 c0                	xor    %eax,%eax
  i = 0;
80100639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010063c:	31 f6                	xor    %esi,%esi
8010063e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 d0 78 10 80 	movzbl -0x7fef8730(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100661:	85 c0                	test   %eax,%eax
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 0c                	je     801006a0 <printint+0x80>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
80100698:	89 c8                	mov    %ecx,%eax
    x = -xx;
8010069a:	89 f1                	mov    %esi,%ecx
8010069c:	f7 d9                	neg    %ecx
8010069e:	eb 99                	jmp    80100639 <printint+0x19>
}
801006a0:	83 c4 2c             	add    $0x2c,%esp
801006a3:	5b                   	pop    %ebx
801006a4:	5e                   	pop    %esi
801006a5:	5f                   	pop    %edi
801006a6:	5d                   	pop    %ebp
801006a7:	c3                   	ret
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 36 01 00 00    	jne    80100800 <cprintf+0x150>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 e0 01 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 6b                	je     80100744 <cprintf+0x94>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	0f 85 dc 00 00 00    	jne    801007c8 <cprintf+0x118>
    c = fmt[++i] & 0xff;
801006ec:	83 c3 01             	add    $0x1,%ebx
801006ef:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006f3:	85 c9                	test   %ecx,%ecx
801006f5:	74 42                	je     80100739 <cprintf+0x89>
    switch(c){
801006f7:	83 f9 70             	cmp    $0x70,%ecx
801006fa:	0f 84 99 00 00 00    	je     80100799 <cprintf+0xe9>
80100700:	7f 4e                	jg     80100750 <cprintf+0xa0>
80100702:	83 f9 25             	cmp    $0x25,%ecx
80100705:	0f 84 cd 00 00 00    	je     801007d8 <cprintf+0x128>
8010070b:	83 f9 64             	cmp    $0x64,%ecx
8010070e:	0f 85 24 01 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 10, 1);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	b9 01 00 00 00       	mov    $0x1,%ecx
8010071c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100724:	8b 07                	mov    (%edi),%eax
80100726:	e8 f5 fe ff ff       	call   80100620 <printint>
8010072b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072e:	83 c3 01             	add    $0x1,%ebx
80100731:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100735:	85 c0                	test   %eax,%eax
80100737:	75 aa                	jne    801006e3 <cprintf+0x33>
80100739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010073c:	85 ff                	test   %edi,%edi
8010073e:	0f 85 df 00 00 00    	jne    80100823 <cprintf+0x173>
}
80100744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100750:	83 f9 73             	cmp    $0x73,%ecx
80100753:	75 3b                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
80100755:	8b 17                	mov    (%edi),%edx
80100757:	8d 47 04             	lea    0x4(%edi),%eax
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 85 0e 01 00 00    	jne    80100870 <cprintf+0x1c0>
80100762:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100767:	bf b8 78 10 80       	mov    $0x801078b8,%edi
8010076c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010076f:	89 fb                	mov    %edi,%ebx
80100771:	89 f7                	mov    %esi,%edi
80100773:	89 c6                	mov    %eax,%esi
80100775:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100778:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	0f 84 fe 00 00 00    	je     80100884 <cprintf+0x1d4>
80100786:	fa                   	cli
    for(;;)
80100787:	eb fe                	jmp    80100787 <cprintf+0xd7>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 f9 78             	cmp    $0x78,%ecx
80100793:	0f 85 9f 00 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 16, 0);
80100799:	8d 47 04             	lea    0x4(%edi),%eax
8010079c:	31 c9                	xor    %ecx,%ecx
8010079e:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a3:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a9:	8b 07                	mov    (%edi),%eax
801007ab:	e8 70 fe ff ff       	call   80100620 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	85 c0                	test   %eax,%eax
801007b9:	0f 85 24 ff ff ff    	jne    801006e3 <cprintf+0x33>
801007bf:	e9 75 ff ff ff       	jmp    80100739 <cprintf+0x89>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007c8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ce:	85 c9                	test   %ecx,%ecx
801007d0:	74 15                	je     801007e7 <cprintf+0x137>
801007d2:	fa                   	cli
    for(;;)
801007d3:	eb fe                	jmp    801007d3 <cprintf+0x123>
801007d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007d8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	75 7e                	jne    80100860 <cprintf+0x1b0>
801007e2:	b8 25 00 00 00       	mov    $0x25,%eax
801007e7:	e8 14 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ec:	83 c3 01             	add    $0x1,%ebx
801007ef:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007f3:	85 c0                	test   %eax,%eax
801007f5:	0f 85 e8 fe ff ff    	jne    801006e3 <cprintf+0x33>
801007fb:	e9 39 ff ff ff       	jmp    80100739 <cprintf+0x89>
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ff 10 80       	push   $0x8010ff20
80100808:	e8 63 42 00 00       	call   80104a70 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 9a 00 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 b6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ff 10 80       	push   $0x8010ff20
8010082b:	e8 80 43 00 00       	call   80104bb0 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 0c ff ff ff       	jmp    80100744 <cprintf+0x94>
  if(panicked){
80100838:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010083e:	85 d2                	test   %edx,%edx
80100840:	75 26                	jne    80100868 <cprintf+0x1b8>
80100842:	b8 25 00 00 00       	mov    $0x25,%eax
80100847:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010084a:	e8 b1 fb ff ff       	call   80100400 <consputc.part.0>
8010084f:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100854:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100857:	85 c0                	test   %eax,%eax
80100859:	74 4b                	je     801008a6 <cprintf+0x1f6>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0x1ac>
8010085e:	66 90                	xchg   %ax,%ax
80100860:	fa                   	cli
80100861:	eb fe                	jmp    80100861 <cprintf+0x1b1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
80100868:	fa                   	cli
80100869:	eb fe                	jmp    80100869 <cprintf+0x1b9>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
      for(; *s; s++)
80100870:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100873:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100875:	84 c9                	test   %cl,%cl
80100877:	0f 85 ef fe ff ff    	jne    8010076c <cprintf+0xbc>
      if((s = (char*)*argp++) == 0)
8010087d:	89 c7                	mov    %eax,%edi
8010087f:	e9 aa fe ff ff       	jmp    8010072e <cprintf+0x7e>
80100884:	e8 77 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100889:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010088d:	83 c3 01             	add    $0x1,%ebx
80100890:	84 c0                	test   %al,%al
80100892:	0f 85 e0 fe ff ff    	jne    80100778 <cprintf+0xc8>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 88 fe ff ff       	jmp    8010072e <cprintf+0x7e>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
801008ad:	e9 7c fe ff ff       	jmp    8010072e <cprintf+0x7e>
    panic("null fmt");
801008b2:	83 ec 0c             	sub    $0xc,%esp
801008b5:	68 bf 78 10 80       	push   $0x801078bf
801008ba:	e8 c1 fa ff ff       	call   80100380 <panic>
801008bf:	90                   	nop

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
  int c, doprocdump = 0;
801008c5:	31 f6                	xor    %esi,%esi
{
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008ce:	68 20 ff 10 80       	push   $0x8010ff20
801008d3:	e8 98 41 00 00       	call   80104a70 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	eb 1a                	jmp    801008f7 <consoleintr+0x37>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e0:	83 fb 08             	cmp    $0x8,%ebx
801008e3:	0f 84 d7 00 00 00    	je     801009c0 <consoleintr+0x100>
801008e9:	83 fb 10             	cmp    $0x10,%ebx
801008ec:	0f 85 2d 01 00 00    	jne    80100a1f <consoleintr+0x15f>
801008f2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008f7:	ff d7                	call   *%edi
801008f9:	89 c3                	mov    %eax,%ebx
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 88 e5 00 00 00    	js     801009e8 <consoleintr+0x128>
    switch(c){
80100903:	83 fb 15             	cmp    $0x15,%ebx
80100906:	74 7a                	je     80100982 <consoleintr+0xc2>
80100908:	7e d6                	jle    801008e0 <consoleintr+0x20>
8010090a:	83 fb 7f             	cmp    $0x7f,%ebx
8010090d:	0f 84 ad 00 00 00    	je     801009c0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100913:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100918:	89 c2                	mov    %eax,%edx
8010091a:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100920:	83 fa 7f             	cmp    $0x7f,%edx
80100923:	77 d2                	ja     801008f7 <consoleintr+0x37>
  if(panicked){
80100925:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010092b:	8d 48 01             	lea    0x1(%eax),%ecx
8010092e:	83 e0 7f             	and    $0x7f,%eax
80100931:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100937:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010093d:	85 d2                	test   %edx,%edx
8010093f:	0f 85 47 01 00 00    	jne    80100a8c <consoleintr+0x1cc>
80100945:	89 d8                	mov    %ebx,%eax
80100947:	e8 b4 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010094c:	83 fb 0a             	cmp    $0xa,%ebx
8010094f:	0f 84 18 01 00 00    	je     80100a6d <consoleintr+0x1ad>
80100955:	83 fb 04             	cmp    $0x4,%ebx
80100958:	0f 84 0f 01 00 00    	je     80100a6d <consoleintr+0x1ad>
8010095e:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100963:	83 e8 80             	sub    $0xffffff80,%eax
80100966:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
8010096c:	75 89                	jne    801008f7 <consoleintr+0x37>
8010096e:	e9 ff 00 00 00       	jmp    80100a72 <consoleintr+0x1b2>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100987:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098d:	0f 84 64 ff ff ff    	je     801008f7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100993:	83 e8 01             	sub    $0x1,%eax
80100996:	89 c2                	mov    %eax,%edx
80100998:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010099b:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
801009a2:	0f 84 4f ff ff ff    	je     801008f7 <consoleintr+0x37>
  if(panicked){
801009a8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
801009ae:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
801009b3:	85 d2                	test   %edx,%edx
801009b5:	74 c1                	je     80100978 <consoleintr+0xb8>
801009b7:	fa                   	cli
    for(;;)
801009b8:	eb fe                	jmp    801009b8 <consoleintr+0xf8>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009c0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009c5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009cb:	0f 84 26 ff ff ff    	je     801008f7 <consoleintr+0x37>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
801009d9:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	74 22                	je     80100a04 <consoleintr+0x144>
801009e2:	fa                   	cli
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <consoleintr+0x123>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 ff 10 80       	push   $0x8010ff20
801009f0:	e8 bb 41 00 00       	call   80104bb0 <release>
  if(doprocdump) {
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	85 f6                	test   %esi,%esi
801009fa:	75 17                	jne    80100a13 <consoleintr+0x153>
}
801009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ff:	5b                   	pop    %ebx
80100a00:	5e                   	pop    %esi
80100a01:	5f                   	pop    %edi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret
80100a04:	b8 00 01 00 00       	mov    $0x100,%eax
80100a09:	e8 f2 f9 ff ff       	call   80100400 <consputc.part.0>
80100a0e:	e9 e4 fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a16:	5b                   	pop    %ebx
80100a17:	5e                   	pop    %esi
80100a18:	5f                   	pop    %edi
80100a19:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a1a:	e9 61 3d 00 00       	jmp    80104780 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1f:	85 db                	test   %ebx,%ebx
80100a21:	0f 84 d0 fe ff ff    	je     801008f7 <consoleintr+0x37>
80100a27:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a2c:	89 c2                	mov    %eax,%edx
80100a2e:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100a34:	83 fa 7f             	cmp    $0x7f,%edx
80100a37:	0f 87 ba fe ff ff    	ja     801008f7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100a40:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a49:	83 fb 0d             	cmp    $0xd,%ebx
80100a4c:	0f 85 df fe ff ff    	jne    80100931 <consoleintr+0x71>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100a58:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a5f:	85 d2                	test   %edx,%edx
80100a61:	75 29                	jne    80100a8c <consoleintr+0x1cc>
80100a63:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a68:	e8 93 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6d:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a72:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a75:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a7a:	68 00 ff 10 80       	push   $0x8010ff00
80100a7f:	e8 1c 3c 00 00       	call   801046a0 <wakeup>
80100a84:	83 c4 10             	add    $0x10,%esp
80100a87:	e9 6b fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a8c:	fa                   	cli
    for(;;)
80100a8d:	eb fe                	jmp    80100a8d <consoleintr+0x1cd>
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 c8 78 10 80       	push   $0x801078c8
80100a9b:	68 20 ff 10 80       	push   $0x8010ff20
80100aa0:	e8 ab 3e 00 00       	call   80104950 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aa5:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100aac:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100aaf:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100ab6:	02 10 80 
  cons.locking = 1;
80100ab9:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100ac0:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100ac3:	58                   	pop    %eax
80100ac4:	5a                   	pop    %edx
80100ac5:	6a 00                	push   $0x0
80100ac7:	6a 01                	push   $0x1
80100ac9:	e8 32 1a 00 00       	call   80102500 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 9f 2f 00 00       	call   80103a90 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 f4 22 00 00       	call   80102df0 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 19 16 00 00       	call   80102120 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 d3 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 d2 0f 00 00       	call   80101b00 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 c1 69 00 00       	call   80107510 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 80 67 00 00       	call   80107340 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 7a 66 00 00       	call   80107270 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 e2 0e 00 00       	call   80101b00 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 58 68 00 00       	call   80107490 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 3c 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c44:	e8 17 22 00 00       	call   80102e60 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 ff 0d 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c81:	e8 da 21 00 00       	call   80102e60 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 a9 66 00 00       	call   80107340 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 f8 68 00 00       	call   801075b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
  for(argc = 0; argv[argc]; argc++) {
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 f1 40 00 00       	call   80104df0 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 e0 40 00 00       	call   80104df0 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 4d 6a 00 00       	call   80107770 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 58 67 00 00       	call   80107490 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 dc 69 00 00       	call   80107770 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 dc 3f 00 00       	call   80104db0 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 e0 62 00 00       	call   801070e0 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 88 66 00 00       	call   80107490 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 19 20 00 00       	call   80102e60 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 e1 78 10 80       	push   $0x801078e1
80100e4f:	e8 5c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 ed 78 10 80       	push   $0x801078ed
80100e6b:	68 60 ff 10 80       	push   $0x8010ff60
80100e70:	e8 db 3a 00 00       	call   80104950 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 da 3b 00 00       	call   80104a70 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ff 10 80       	push   $0x8010ff60
80100ec1:	e8 ea 3c 00 00       	call   80104bb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ff 10 80       	push   $0x8010ff60
80100eda:	e8 d1 3c 00 00       	call   80104bb0 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ff 10 80       	push   $0x8010ff60
80100eff:	e8 6c 3b 00 00       	call   80104a70 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ff 10 80       	push   $0x8010ff60
80100f1c:	e8 8f 3c 00 00       	call   80104bb0 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 f4 78 10 80       	push   $0x801078f4
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ff 10 80       	push   $0x8010ff60
80100f51:	e8 1a 3b 00 00       	call   80104a70 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ff 10 80       	push   $0x8010ff60
80100f8c:	e8 1f 3c 00 00       	call   80104bb0 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 ed 3b 00 00       	jmp    80104bb0 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 23 1e 00 00       	call   80102df0 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 48 09 00 00       	call   80101920 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 79 1e 00 00       	jmp    80102e60 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 b2 25 00 00       	call   801035b0 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 fc 78 10 80       	push   $0x801078fc
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 b6 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 89 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 80 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 51 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 54 0a 00 00       	call   80101b00 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 0d 08 00 00       	call   801018d0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 8e 26 00 00       	jmp    80103770 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 06 79 10 80       	push   $0x80107906
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 77 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101159:	e8 02 1d 00 00       	call   80102e60 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 6d 1c 00 00       	call   80102df0 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 62 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 60 0a 00 00       	call   80101c00 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 1b 07 00 00       	call   801018d0 <iunlock>
      end_op();
801011b5:	e8 a6 1c 00 00       	call   80102e60 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 0f 79 10 80       	push   $0x8010790f
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
    return -1;
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 52 24 00 00       	jmp    80103650 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 15 79 10 80       	push   $0x80107915
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 1f 79 10 80       	push   $0x8010791f
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 f6 1c 00 00       	call   80102fd0 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 fe 38 00 00       	call   80104c00 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 c6 1c 00 00       	call   80102fd0 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 09 11 80       	push   $0x80110960
8010133a:	e8 31 37 00 00       	call   80104a70 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 09 11 80       	push   $0x80110960
801013a7:	e8 04 38 00 00       	call   80104bb0 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 09 11 80       	push   $0x80110960
801013d5:	e8 d6 37 00 00       	call   80104bb0 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 35 79 10 80       	push   $0x80107935
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	89 c6                	mov    %eax,%esi
80101427:	53                   	push   %ebx
80101428:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010142b:	83 fa 0b             	cmp    $0xb,%edx
8010142e:	0f 86 8c 00 00 00    	jbe    801014c0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101434:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101437:	83 fb 7f             	cmp    $0x7f,%ebx
8010143a:	0f 87 a2 00 00 00    	ja     801014e2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101440:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101446:	85 c0                	test   %eax,%eax
80101448:	74 5e                	je     801014a8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010144a:	83 ec 08             	sub    $0x8,%esp
8010144d:	50                   	push   %eax
8010144e:	ff 36                	push   (%esi)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010145c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010145e:	8b 3b                	mov    (%ebx),%edi
80101460:	85 ff                	test   %edi,%edi
80101462:	74 1c                	je     80101480 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	52                   	push   %edx
80101468:	e8 83 ed ff ff       	call   801001f0 <brelse>
8010146d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101473:	89 f8                	mov    %edi,%eax
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5f                   	pop    %edi
80101478:	5d                   	pop    %ebp
80101479:	c3                   	ret
8010147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101483:	8b 06                	mov    (%esi),%eax
80101485:	e8 86 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010148d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101490:	89 03                	mov    %eax,(%ebx)
80101492:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101494:	52                   	push   %edx
80101495:	e8 36 1b 00 00       	call   80102fd0 <log_write>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010149d:	83 c4 10             	add    $0x10,%esp
801014a0:	eb c2                	jmp    80101464 <bmap+0x44>
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 61 fd ff ff       	call   80101210 <balloc>
801014af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014b5:	eb 93                	jmp    8010144a <bmap+0x2a>
801014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014be:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014c0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014c3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014c7:	85 ff                	test   %edi,%edi
801014c9:	75 a5                	jne    80101470 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014cb:	8b 00                	mov    (%eax),%eax
801014cd:	e8 3e fd ff ff       	call   80101210 <balloc>
801014d2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801014d6:	89 c7                	mov    %eax,%edi
}
801014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014db:	5b                   	pop    %ebx
801014dc:	89 f8                	mov    %edi,%eax
801014de:	5e                   	pop    %esi
801014df:	5f                   	pop    %edi
801014e0:	5d                   	pop    %ebp
801014e1:	c3                   	ret
  panic("bmap: out of range");
801014e2:	83 ec 0c             	sub    $0xc,%esp
801014e5:	68 45 79 10 80       	push   $0x80107945
801014ea:	e8 91 ee ff ff       	call   80100380 <panic>
801014ef:	90                   	nop

801014f0 <bfree>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	89 c6                	mov    %eax,%esi
801014f7:	53                   	push   %ebx
801014f8:	89 d3                	mov    %edx,%ebx
801014fa:	83 ec 14             	sub    $0x14,%esp
  bp = bread(dev, 1);
801014fd:	6a 01                	push   $0x1
801014ff:	50                   	push   %eax
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101505:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101508:	89 c7                	mov    %eax,%edi
  memmove(sb, bp->data, sizeof(*sb));
8010150a:	83 c0 5c             	add    $0x5c,%eax
8010150d:	6a 1c                	push   $0x1c
8010150f:	50                   	push   %eax
80101510:	68 b4 25 11 80       	push   $0x801125b4
80101515:	e8 76 37 00 00       	call   80104c90 <memmove>
  brelse(bp);
8010151a:	89 3c 24             	mov    %edi,(%esp)
8010151d:	e8 ce ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, BBLOCK(b, sb));
80101522:	58                   	pop    %eax
80101523:	89 d8                	mov    %ebx,%eax
80101525:	5a                   	pop    %edx
80101526:	c1 e8 0c             	shr    $0xc,%eax
80101529:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010152f:	50                   	push   %eax
80101530:	56                   	push   %esi
80101531:	e8 9a eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101536:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101538:	c1 fb 03             	sar    $0x3,%ebx
8010153b:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010153e:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101540:	83 e1 07             	and    $0x7,%ecx
80101543:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101548:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
8010154e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101550:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101555:	85 c1                	test   %eax,%ecx
80101557:	74 24                	je     8010157d <bfree+0x8d>
  bp->data[bi/8] &= ~m;
80101559:	f7 d0                	not    %eax
  log_write(bp);
8010155b:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
8010155e:	21 c8                	and    %ecx,%eax
80101560:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101564:	56                   	push   %esi
80101565:	e8 66 1a 00 00       	call   80102fd0 <log_write>
  brelse(bp);
8010156a:	89 34 24             	mov    %esi,(%esp)
8010156d:	e8 7e ec ff ff       	call   801001f0 <brelse>
}
80101572:	83 c4 10             	add    $0x10,%esp
80101575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101578:	5b                   	pop    %ebx
80101579:	5e                   	pop    %esi
8010157a:	5f                   	pop    %edi
8010157b:	5d                   	pop    %ebp
8010157c:	c3                   	ret
    panic("freeing free block");
8010157d:	83 ec 0c             	sub    $0xc,%esp
80101580:	68 58 79 10 80       	push   $0x80107958
80101585:	e8 f6 ed ff ff       	call   80100380 <panic>
8010158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 da 36 00 00       	call   80104c90 <memmove>
  brelse(bp);
801015b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015b9:	83 c4 10             	add    $0x10,%esp
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 29 ec ff ff       	jmp    801001f0 <brelse>
801015c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ce:	66 90                	xchg   %ax,%ax

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 6b 79 10 80       	push   $0x8010796b
801015e1:	68 60 09 11 80       	push   $0x80110960
801015e6:	e8 65 33 00 00       	call   80104950 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 72 79 10 80       	push   $0x80107972
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 3c 32 00 00       	call   80104840 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 25 11 80       	push   $0x801125b4
8010162c:	e8 5f 36 00 00       	call   80104c90 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 b7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 25 11 80    	push   0x801125cc
8010163f:	ff 35 c8 25 11 80    	push   0x801125c8
80101645:	ff 35 c4 25 11 80    	push   0x801125c4
8010164b:	ff 35 c0 25 11 80    	push   0x801125c0
80101651:	ff 35 bc 25 11 80    	push   0x801125bc
80101657:	ff 35 b8 25 11 80    	push   0x801125b8
8010165d:	ff 35 b4 25 11 80    	push   0x801125b4
80101663:	68 d8 79 10 80       	push   $0x801079d8
80101668:	e8 43 f0 ff ff       	call   801006b0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave
80101674:	c3                   	ret
80101675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ad:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 34 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	6a 40                	push   $0x40
801016f8:	6a 00                	push   $0x0
801016fa:	51                   	push   %ecx
801016fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016fe:	e8 fd 34 00 00       	call   80104c00 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 bb 18 00 00       	call   80102fd0 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 f0 fb ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 78 79 10 80       	push   $0x80107978
80101738:	e8 43 ec ff ff       	call   80100380 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 ea 34 00 00       	call   80104c90 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 22 18 00 00       	call   80102fd0 <log_write>
  brelse(bp);
801017ae:	89 75 08             	mov    %esi,0x8(%ebp)
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 31 ea ff ff       	jmp    801001f0 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 09 11 80       	push   $0x80110960
801017cf:	e8 9c 32 00 00       	call   80104a70 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017df:	e8 cc 33 00 00       	call   80104bb0 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 69 30 00 00       	call   80104880 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 03 34 00 00       	call   80104c90 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 90 79 10 80       	push   $0x80107990
801018b2:	e8 c9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 8a 79 10 80       	push   $0x8010798a
801018bf:	e8 bc ea ff ff       	call   80100380 <panic>
801018c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 38 30 00 00       	call   80104920 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 dc 2f 00 00       	jmp    801048e0 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 9f 79 10 80       	push   $0x8010799f
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191f:	90                   	nop

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 4b 2f 00 00       	call   80104880 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 91 2f 00 00       	call   801048e0 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101956:	e8 15 31 00 00       	call   80104a70 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 3b 32 00 00       	jmp    80104bb0 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 09 11 80       	push   $0x80110960
80101980:	e8 eb 30 00 00       	call   80104a70 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010198f:	e8 1c 32 00 00       	call   80104bb0 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 2c fb ff ff       	call   801014f0 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 51 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 43 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 ac fa ff ff       	call   801014f0 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 8e fa ff ff       	call   801014f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 88 2e 00 00       	call   80104920 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 31 2e 00 00       	call   801048e0 <releasesleep>
  iput(ip);
80101aaf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab2:	83 c4 10             	add    $0x10,%esp
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 9f 79 10 80       	push   $0x8010799f
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 75 08             	mov    0x8(%ebp),%esi
80101b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b1a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b20:	0f 84 aa 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b26:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b29:	8b 56 58             	mov    0x58(%esi),%edx
80101b2c:	39 fa                	cmp    %edi,%edx
80101b2e:	0f 82 bd 00 00 00    	jb     80101bf1 <readi+0xf1>
80101b34:	89 f9                	mov    %edi,%ecx
80101b36:	31 db                	xor    %ebx,%ebx
80101b38:	01 c1                	add    %eax,%ecx
80101b3a:	0f 92 c3             	setb   %bl
80101b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b40:	0f 82 ab 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b46:	89 d3                	mov    %edx,%ebx
80101b48:	29 fb                	sub    %edi,%ebx
80101b4a:	39 ca                	cmp    %ecx,%edx
80101b4c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	74 73                	je     80101bc6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 fa                	mov    %edi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 b1 f8 ff ff       	call   80101420 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f8                	mov    %edi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 f3                	sub    %esi,%ebx
80101b8d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b93:	39 d9                	cmp    %ebx,%ecx
80101b95:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b98:	83 c4 0c             	add    $0xc,%esp
80101b9b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
80101b9e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 e4 30 00 00       	call   80104c90 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 39 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	39 de                	cmp    %ebx,%esi
80101bc2:	72 9c                	jb     80101b60 <readi+0x60>
80101bc4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc9:	5b                   	pop    %ebx
80101bca:	5e                   	pop    %esi
80101bcb:	5f                   	pop    %edi
80101bcc:	5d                   	pop    %ebp
80101bcd:	c3                   	ret
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bd4:	66 83 fa 09          	cmp    $0x9,%dx
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e2                	jmp    *%edx
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb ce                	jmp    80101bc6 <readi+0xc6>
80101bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c0f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c20:	0f 84 ca 00 00 00    	je     80101cf0 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c26:	39 78 58             	cmp    %edi,0x58(%eax)
80101c29:	0f 82 fa 00 00 00    	jb     80101d29 <writei+0x129>
80101c2f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c32:	31 c9                	xor    %ecx,%ecx
80101c34:	89 f2                	mov    %esi,%edx
80101c36:	01 fa                	add    %edi,%edx
80101c38:	0f 92 c1             	setb   %cl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c3b:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c41:	0f 87 e2 00 00 00    	ja     80101d29 <writei+0x129>
80101c47:	85 c9                	test   %ecx,%ecx
80101c49:	0f 85 da 00 00 00    	jne    80101d29 <writei+0x129>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	85 f6                	test   %esi,%esi
80101c51:	0f 84 86 00 00 00    	je     80101cdd <writei+0xdd>
80101c57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c68:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c6b:	89 fa                	mov    %edi,%edx
80101c6d:	c1 ea 09             	shr    $0x9,%edx
80101c70:	89 f0                	mov    %esi,%eax
80101c72:	e8 a9 f7 ff ff       	call   80101420 <bmap>
80101c77:	83 ec 08             	sub    $0x8,%esp
80101c7a:	50                   	push   %eax
80101c7b:	ff 36                	push   (%esi)
80101c7d:	e8 4e e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c85:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c88:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c8d:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8f:	89 f8                	mov    %edi,%eax
80101c91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c96:	29 d3                	sub    %edx,%ebx
80101c98:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c9a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9e:	39 d9                	cmp    %ebx,%ecx
80101ca0:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	83 c4 0c             	add    $0xc,%esp
80101ca6:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca7:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101ca9:	ff 75 dc             	push   -0x24(%ebp)
80101cac:	50                   	push   %eax
80101cad:	e8 de 2f 00 00       	call   80104c90 <memmove>
    log_write(bp);
80101cb2:	89 34 24             	mov    %esi,(%esp)
80101cb5:	e8 16 13 00 00       	call   80102fd0 <log_write>
    brelse(bp);
80101cba:	89 34 24             	mov    %esi,(%esp)
80101cbd:	e8 2e e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc2:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc8:	83 c4 10             	add    $0x10,%esp
80101ccb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cd1:	39 d8                	cmp    %ebx,%eax
80101cd3:	72 93                	jb     80101c68 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101cd5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cd8:	39 78 58             	cmp    %edi,0x58(%eax)
80101cdb:	72 3b                	jb     80101d18 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce3:	5b                   	pop    %ebx
80101ce4:	5e                   	pop    %esi
80101ce5:	5f                   	pop    %edi
80101ce6:	5d                   	pop    %ebp
80101ce7:	c3                   	ret
80101ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cef:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 2f                	ja     80101d29 <writei+0x129>
80101cfa:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 24                	je     80101d29 <writei+0x129>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d1e:	50                   	push   %eax
80101d1f:	e8 1c fa ff ff       	call   80101740 <iupdate>
80101d24:	83 c4 10             	add    $0x10,%esp
80101d27:	eb b4                	jmp    80101cdd <writei+0xdd>
      return -1;
80101d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d2e:	eb b0                	jmp    80101ce0 <writei+0xe0>

80101d30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d36:	6a 0e                	push   $0xe
80101d38:	ff 75 0c             	push   0xc(%ebp)
80101d3b:	ff 75 08             	push   0x8(%ebp)
80101d3e:	e8 bd 2f 00 00       	call   80104d00 <strncmp>
}
80101d43:	c9                   	leave
80101d44:	c3                   	ret
80101d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d61:	0f 85 85 00 00 00    	jne    80101dec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d67:	8b 53 58             	mov    0x58(%ebx),%edx
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d6f:	85 d2                	test   %edx,%edx
80101d71:	74 3e                	je     80101db1 <dirlookup+0x61>
80101d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d78:	6a 10                	push   $0x10
80101d7a:	57                   	push   %edi
80101d7b:	56                   	push   %esi
80101d7c:	53                   	push   %ebx
80101d7d:	e8 7e fd ff ff       	call   80101b00 <readi>
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	83 f8 10             	cmp    $0x10,%eax
80101d88:	75 55                	jne    80101ddf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d8f:	74 18                	je     80101da9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d91:	83 ec 04             	sub    $0x4,%esp
80101d94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d97:	6a 0e                	push   $0xe
80101d99:	50                   	push   %eax
80101d9a:	ff 75 0c             	push   0xc(%ebp)
80101d9d:	e8 5e 2f 00 00       	call   80104d00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 17                	je     80101dc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da9:	83 c7 10             	add    $0x10,%edi
80101dac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101daf:	72 c7                	jb     80101d78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101db4:	31 c0                	xor    %eax,%eax
}
80101db6:	5b                   	pop    %ebx
80101db7:	5e                   	pop    %esi
80101db8:	5f                   	pop    %edi
80101db9:	5d                   	pop    %ebp
80101dba:	c3                   	ret
80101dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop
      if(poff)
80101dc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	74 05                	je     80101dcc <dirlookup+0x7c>
        *poff = off;
80101dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dd0:	8b 03                	mov    (%ebx),%eax
80101dd2:	e8 49 f5 ff ff       	call   80101320 <iget>
}
80101dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dda:	5b                   	pop    %ebx
80101ddb:	5e                   	pop    %esi
80101ddc:	5f                   	pop    %edi
80101ddd:	5d                   	pop    %ebp
80101dde:	c3                   	ret
      panic("dirlookup read");
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	68 b9 79 10 80       	push   $0x801079b9
80101de7:	e8 94 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 a7 79 10 80       	push   $0x801079a7
80101df4:	e8 87 e5 ff ff       	call   80100380 <panic>
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 64 01 00 00    	je     80101f7e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 71 1c 00 00       	call   80103a90 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e22:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e25:	68 60 09 11 80       	push   $0x80110960
80101e2a:	e8 41 2c 00 00       	call   80104a70 <acquire>
  ip->ref++;
80101e2f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e33:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e3a:	e8 71 2d 00 00       	call   80104bb0 <release>
80101e3f:	83 c4 10             	add    $0x10,%esp
80101e42:	eb 07                	jmp    80101e4b <namex+0x4b>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	0f b6 03             	movzbl (%ebx),%eax
80101e4e:	3c 2f                	cmp    $0x2f,%al
80101e50:	74 f6                	je     80101e48 <namex+0x48>
  if(*path == 0)
80101e52:	84 c0                	test   %al,%al
80101e54:	0f 84 06 01 00 00    	je     80101f60 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e5a:	0f b6 03             	movzbl (%ebx),%eax
80101e5d:	84 c0                	test   %al,%al
80101e5f:	0f 84 10 01 00 00    	je     80101f75 <namex+0x175>
80101e65:	89 df                	mov    %ebx,%edi
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	0f 84 06 01 00 00    	je     80101f75 <namex+0x175>
80101e6f:	90                   	nop
80101e70:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e74:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	74 04                	je     80101e7f <namex+0x7f>
80101e7b:	84 c0                	test   %al,%al
80101e7d:	75 f1                	jne    80101e70 <namex+0x70>
  len = path - s;
80101e7f:	89 f8                	mov    %edi,%eax
80101e81:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e83:	83 f8 0d             	cmp    $0xd,%eax
80101e86:	0f 8e ac 00 00 00    	jle    80101f38 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e8c:	83 ec 04             	sub    $0x4,%esp
80101e8f:	6a 0e                	push   $0xe
80101e91:	53                   	push   %ebx
    path++;
80101e92:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e94:	ff 75 e4             	push   -0x1c(%ebp)
80101e97:	e8 f4 2d 00 00       	call   80104c90 <memmove>
80101e9c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e9f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ea2:	75 0c                	jne    80101eb0 <namex+0xb0>
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ea8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eab:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eae:	74 f8                	je     80101ea8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101eb9:	83 c4 10             	add    $0x10,%esp
80101ebc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ec1:	0f 85 cd 00 00 00    	jne    80101f94 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	74 09                	je     80101ed7 <namex+0xd7>
80101ece:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ed1:	0f 84 34 01 00 00    	je     8010200b <namex+0x20b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ed7:	83 ec 04             	sub    $0x4,%esp
80101eda:	6a 00                	push   $0x0
80101edc:	ff 75 e4             	push   -0x1c(%ebp)
80101edf:	56                   	push   %esi
80101ee0:	e8 6b fe ff ff       	call   80101d50 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	89 c7                	mov    %eax,%edi
80101eed:	85 c0                	test   %eax,%eax
80101eef:	0f 84 e1 00 00 00    	je     80101fd6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	52                   	push   %edx
80101ef9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101efc:	e8 1f 2a 00 00       	call   80104920 <holdingsleep>
80101f01:	83 c4 10             	add    $0x10,%esp
80101f04:	85 c0                	test   %eax,%eax
80101f06:	0f 84 3f 01 00 00    	je     8010204b <namex+0x24b>
80101f0c:	8b 56 08             	mov    0x8(%esi),%edx
80101f0f:	85 d2                	test   %edx,%edx
80101f11:	0f 8e 34 01 00 00    	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101f17:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	52                   	push   %edx
80101f1e:	e8 bd 29 00 00       	call   801048e0 <releasesleep>
  iput(ip);
80101f23:	89 34 24             	mov    %esi,(%esp)
80101f26:	89 fe                	mov    %edi,%esi
80101f28:	e8 f3 f9 ff ff       	call   80101920 <iput>
80101f2d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f30:	e9 16 ff ff ff       	jmp    80101e4b <namex+0x4b>
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f3b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f3e:	83 ec 04             	sub    $0x4,%esp
80101f41:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f44:	50                   	push   %eax
80101f45:	53                   	push   %ebx
    name[len] = 0;
80101f46:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f48:	ff 75 e4             	push   -0x1c(%ebp)
80101f4b:	e8 40 2d 00 00       	call   80104c90 <memmove>
    name[len] = 0;
80101f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	c6 02 00             	movb   $0x0,(%edx)
80101f59:	e9 41 ff ff ff       	jmp    80101e9f <namex+0x9f>
80101f5e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f63:	85 c0                	test   %eax,%eax
80101f65:	0f 85 d0 00 00 00    	jne    8010203b <namex+0x23b>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6e:	89 f0                	mov    %esi,%eax
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f78:	89 df                	mov    %ebx,%edi
80101f7a:	31 c0                	xor    %eax,%eax
80101f7c:	eb c0                	jmp    80101f3e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f7e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f83:	b8 01 00 00 00       	mov    $0x1,%eax
80101f88:	e8 93 f3 ff ff       	call   80101320 <iget>
80101f8d:	89 c6                	mov    %eax,%esi
80101f8f:	e9 b7 fe ff ff       	jmp    80101e4b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f94:	83 ec 0c             	sub    $0xc,%esp
80101f97:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9a:	53                   	push   %ebx
80101f9b:	e8 80 29 00 00       	call   80104920 <holdingsleep>
80101fa0:	83 c4 10             	add    $0x10,%esp
80101fa3:	85 c0                	test   %eax,%eax
80101fa5:	0f 84 a0 00 00 00    	je     8010204b <namex+0x24b>
80101fab:	8b 46 08             	mov    0x8(%esi),%eax
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	0f 8e 95 00 00 00    	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	53                   	push   %ebx
80101fba:	e8 21 29 00 00       	call   801048e0 <releasesleep>
  iput(ip);
80101fbf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fc2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fc4:	e8 57 f9 ff ff       	call   80101920 <iput>
      return 0;
80101fc9:	83 c4 10             	add    $0x10,%esp
}
80101fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcf:	89 f0                	mov    %esi,%eax
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd6:	83 ec 0c             	sub    $0xc,%esp
80101fd9:	52                   	push   %edx
80101fda:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fdd:	e8 3e 29 00 00       	call   80104920 <holdingsleep>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	85 c0                	test   %eax,%eax
80101fe7:	74 62                	je     8010204b <namex+0x24b>
80101fe9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fec:	85 c9                	test   %ecx,%ecx
80101fee:	7e 5b                	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ff3:	83 ec 0c             	sub    $0xc,%esp
80101ff6:	52                   	push   %edx
80101ff7:	e8 e4 28 00 00       	call   801048e0 <releasesleep>
  iput(ip);
80101ffc:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fff:	31 f6                	xor    %esi,%esi
  iput(ip);
80102001:	e8 1a f9 ff ff       	call   80101920 <iput>
      return 0;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	eb c1                	jmp    80101fcc <namex+0x1cc>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010200b:	83 ec 0c             	sub    $0xc,%esp
8010200e:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102011:	53                   	push   %ebx
80102012:	e8 09 29 00 00       	call   80104920 <holdingsleep>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	74 2d                	je     8010204b <namex+0x24b>
8010201e:	8b 7e 08             	mov    0x8(%esi),%edi
80102021:	85 ff                	test   %edi,%edi
80102023:	7e 26                	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	53                   	push   %ebx
80102029:	e8 b2 28 00 00       	call   801048e0 <releasesleep>
}
8010202e:	83 c4 10             	add    $0x10,%esp
}
80102031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102034:	89 f0                	mov    %esi,%eax
80102036:	5b                   	pop    %ebx
80102037:	5e                   	pop    %esi
80102038:	5f                   	pop    %edi
80102039:	5d                   	pop    %ebp
8010203a:	c3                   	ret
    iput(ip);
8010203b:	83 ec 0c             	sub    $0xc,%esp
8010203e:	56                   	push   %esi
      return 0;
8010203f:	31 f6                	xor    %esi,%esi
    iput(ip);
80102041:	e8 da f8 ff ff       	call   80101920 <iput>
    return 0;
80102046:	83 c4 10             	add    $0x10,%esp
80102049:	eb 81                	jmp    80101fcc <namex+0x1cc>
    panic("iunlock");
8010204b:	83 ec 0c             	sub    $0xc,%esp
8010204e:	68 9f 79 10 80       	push   $0x8010799f
80102053:	e8 28 e3 ff ff       	call   80100380 <panic>
80102058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205f:	90                   	nop

80102060 <dirlink>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 20             	sub    $0x20,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010206c:	6a 00                	push   $0x0
8010206e:	ff 75 0c             	push   0xc(%ebp)
80102071:	53                   	push   %ebx
80102072:	e8 d9 fc ff ff       	call   80101d50 <dirlookup>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	75 67                	jne    801020e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010207e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102081:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102084:	85 ff                	test   %edi,%edi
80102086:	74 29                	je     801020b1 <dirlink+0x51>
80102088:	31 ff                	xor    %edi,%edi
8010208a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010208d:	eb 09                	jmp    80102098 <dirlink+0x38>
8010208f:	90                   	nop
80102090:	83 c7 10             	add    $0x10,%edi
80102093:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102096:	73 19                	jae    801020b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102098:	6a 10                	push   $0x10
8010209a:	57                   	push   %edi
8010209b:	56                   	push   %esi
8010209c:	53                   	push   %ebx
8010209d:	e8 5e fa ff ff       	call   80101b00 <readi>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	83 f8 10             	cmp    $0x10,%eax
801020a8:	75 4e                	jne    801020f8 <dirlink+0x98>
    if(de.inum == 0)
801020aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020af:	75 df                	jne    80102090 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020b1:	83 ec 04             	sub    $0x4,%esp
801020b4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020b7:	6a 0e                	push   $0xe
801020b9:	ff 75 0c             	push   0xc(%ebp)
801020bc:	50                   	push   %eax
801020bd:	e8 8e 2c 00 00       	call   80104d50 <strncpy>
  de.inum = inum;
801020c2:	8b 45 10             	mov    0x10(%ebp),%eax
801020c5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c9:	6a 10                	push   $0x10
801020cb:	57                   	push   %edi
801020cc:	56                   	push   %esi
801020cd:	53                   	push   %ebx
801020ce:	e8 2d fb ff ff       	call   80101c00 <writei>
801020d3:	83 c4 20             	add    $0x20,%esp
801020d6:	83 f8 10             	cmp    $0x10,%eax
801020d9:	75 2a                	jne    80102105 <dirlink+0xa5>
  return 0;
801020db:	31 c0                	xor    %eax,%eax
}
801020dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret
    iput(ip);
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	50                   	push   %eax
801020e9:	e8 32 f8 ff ff       	call   80101920 <iput>
    return -1;
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f6:	eb e5                	jmp    801020dd <dirlink+0x7d>
      panic("dirlink read");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 c8 79 10 80       	push   $0x801079c8
80102100:	e8 7b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 d6 7f 10 80       	push   $0x80107fd6
8010210d:	e8 6e e2 ff ff       	call   80100380 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102120 <namei>:

struct inode*
namei(char *path)
{
80102120:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102121:	31 d2                	xor    %edx,%edx
{
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010212e:	e8 cd fc ff ff       	call   80101e00 <namex>
}
80102133:	c9                   	leave
80102134:	c3                   	ret
80102135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102140:	55                   	push   %ebp
  return namex(path, 1, name);
80102141:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102146:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010214e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010214f:	e9 ac fc ff ff       	jmp    80101e00 <namex>
80102154:	66 90                	xchg   %ax,%ax
80102156:	66 90                	xchg   %ax,%ax
80102158:	66 90                	xchg   %ax,%ax
8010215a:	66 90                	xchg   %ax,%ax
8010215c:	66 90                	xchg   %ax,%ax
8010215e:	66 90                	xchg   %ax,%ax

80102160 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102169:	85 c0                	test   %eax,%eax
8010216b:	0f 84 b4 00 00 00    	je     80102225 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102171:	8b 70 08             	mov    0x8(%eax),%esi
80102174:	89 c3                	mov    %eax,%ebx
80102176:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010217c:	0f 87 96 00 00 00    	ja     80102218 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	89 ca                	mov    %ecx,%edx
80102192:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102193:	83 e0 c0             	and    $0xffffffc0,%eax
80102196:	3c 40                	cmp    $0x40,%al
80102198:	75 f6                	jne    80102190 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	ee                   	out    %al,(%dx)
801021a4:	b8 01 00 00 00       	mov    $0x1,%eax
801021a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ae:	ee                   	out    %al,(%dx)
801021af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b4:	89 f0                	mov    %esi,%eax
801021b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021b7:	89 f0                	mov    %esi,%eax
801021b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021be:	c1 f8 08             	sar    $0x8,%eax
801021c1:	ee                   	out    %al,(%dx)
801021c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d3:	c1 e0 04             	shl    $0x4,%eax
801021d6:	83 e0 10             	and    $0x10,%eax
801021d9:	83 c8 e0             	or     $0xffffffe0,%eax
801021dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021dd:	f6 03 04             	testb  $0x4,(%ebx)
801021e0:	75 16                	jne    801021f8 <idestart+0x98>
801021e2:	b8 20 00 00 00       	mov    $0x20,%eax
801021e7:	89 ca                	mov    %ecx,%edx
801021e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ed:	5b                   	pop    %ebx
801021ee:	5e                   	pop    %esi
801021ef:	5f                   	pop    %edi
801021f0:	5d                   	pop    %ebp
801021f1:	c3                   	ret
801021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f8:	b8 30 00 00 00       	mov    $0x30,%eax
801021fd:	89 ca                	mov    %ecx,%edx
801021ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102200:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102205:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102208:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010220d:	fc                   	cld
8010220e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102213:	5b                   	pop    %ebx
80102214:	5e                   	pop    %esi
80102215:	5f                   	pop    %edi
80102216:	5d                   	pop    %ebp
80102217:	c3                   	ret
    panic("incorrect blockno");
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	68 34 7a 10 80       	push   $0x80107a34
80102220:	e8 5b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	68 2b 7a 10 80       	push   $0x80107a2b
8010222d:	e8 4e e1 ff ff       	call   80100380 <panic>
80102232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102240 <ideinit>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102246:	68 46 7a 10 80       	push   $0x80107a46
8010224b:	68 00 26 11 80       	push   $0x80112600
80102250:	e8 fb 26 00 00       	call   80104950 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 84 27 11 80       	mov    0x80112784,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 99 02 00 00       	call   80102500 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102267:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010226f:	90                   	nop
80102270:	89 ca                	mov    %ecx,%edx
80102272:	ec                   	in     (%dx),%al
80102273:	83 e0 c0             	and    $0xffffffc0,%eax
80102276:	3c 40                	cmp    $0x40,%al
80102278:	75 f6                	jne    80102270 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010227a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010227f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102284:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102285:	89 ca                	mov    %ecx,%edx
80102287:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102288:	84 c0                	test   %al,%al
8010228a:	75 1e                	jne    801022aa <ideinit+0x6a>
8010228c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102291:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
801022a0:	83 e9 01             	sub    $0x1,%ecx
801022a3:	74 0f                	je     801022b4 <ideinit+0x74>
801022a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022a6:	84 c0                	test   %al,%al
801022a8:	74 f6                	je     801022a0 <ideinit+0x60>
      havedisk1 = 1;
801022aa:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801022b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022be:	ee                   	out    %al,(%dx)
}
801022bf:	c9                   	leave
801022c0:	c3                   	ret
801022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop

801022d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	57                   	push   %edi
801022d4:	56                   	push   %esi
801022d5:	53                   	push   %ebx
801022d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022d9:	68 00 26 11 80       	push   $0x80112600
801022de:	e8 8d 27 00 00       	call   80104a70 <acquire>

  if((b = idequeue) == 0){
801022e3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022e9:	83 c4 10             	add    $0x10,%esp
801022ec:	85 db                	test   %ebx,%ebx
801022ee:	74 63                	je     80102353 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022f0:	8b 43 58             	mov    0x58(%ebx),%eax
801022f3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022f8:	8b 33                	mov    (%ebx),%esi
801022fa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102300:	75 2f                	jne    80102331 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102302:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230e:	66 90                	xchg   %ax,%ax
80102310:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102311:	89 c1                	mov    %eax,%ecx
80102313:	83 e1 c0             	and    $0xffffffc0,%ecx
80102316:	80 f9 40             	cmp    $0x40,%cl
80102319:	75 f5                	jne    80102310 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010231b:	a8 21                	test   $0x21,%al
8010231d:	75 12                	jne    80102331 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010231f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102322:	b9 80 00 00 00       	mov    $0x80,%ecx
80102327:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010232c:	fc                   	cld
8010232d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010232f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102331:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102334:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102337:	83 ce 02             	or     $0x2,%esi
8010233a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010233c:	53                   	push   %ebx
8010233d:	e8 5e 23 00 00       	call   801046a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102342:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102347:	83 c4 10             	add    $0x10,%esp
8010234a:	85 c0                	test   %eax,%eax
8010234c:	74 05                	je     80102353 <ideintr+0x83>
    idestart(idequeue);
8010234e:	e8 0d fe ff ff       	call   80102160 <idestart>
    release(&idelock);
80102353:	83 ec 0c             	sub    $0xc,%esp
80102356:	68 00 26 11 80       	push   $0x80112600
8010235b:	e8 50 28 00 00       	call   80104bb0 <release>

  release(&idelock);
}
80102360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102363:	5b                   	pop    %ebx
80102364:	5e                   	pop    %esi
80102365:	5f                   	pop    %edi
80102366:	5d                   	pop    %ebp
80102367:	c3                   	ret
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	53                   	push   %ebx
80102374:	83 ec 10             	sub    $0x10,%esp
80102377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010237a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010237d:	50                   	push   %eax
8010237e:	e8 9d 25 00 00       	call   80104920 <holdingsleep>
80102383:	83 c4 10             	add    $0x10,%esp
80102386:	85 c0                	test   %eax,%eax
80102388:	0f 84 c3 00 00 00    	je     80102451 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 e0 06             	and    $0x6,%eax
80102393:	83 f8 02             	cmp    $0x2,%eax
80102396:	0f 84 a8 00 00 00    	je     80102444 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010239c:	8b 53 04             	mov    0x4(%ebx),%edx
8010239f:	85 d2                	test   %edx,%edx
801023a1:	74 0d                	je     801023b0 <iderw+0x40>
801023a3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801023a8:	85 c0                	test   %eax,%eax
801023aa:	0f 84 87 00 00 00    	je     80102437 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 00 26 11 80       	push   $0x80112600
801023b8:	e8 b3 26 00 00       	call   80104a70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023bd:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801023c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c9:	83 c4 10             	add    $0x10,%esp
801023cc:	85 c0                	test   %eax,%eax
801023ce:	74 60                	je     80102430 <iderw+0xc0>
801023d0:	89 c2                	mov    %eax,%edx
801023d2:	8b 40 58             	mov    0x58(%eax),%eax
801023d5:	85 c0                	test   %eax,%eax
801023d7:	75 f7                	jne    801023d0 <iderw+0x60>
801023d9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023dc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023de:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023e4:	74 3a                	je     80102420 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023e6:	8b 03                	mov    (%ebx),%eax
801023e8:	83 e0 06             	and    $0x6,%eax
801023eb:	83 f8 02             	cmp    $0x2,%eax
801023ee:	74 1b                	je     8010240b <iderw+0x9b>
    sleep(b, &idelock);
801023f0:	83 ec 08             	sub    $0x8,%esp
801023f3:	68 00 26 11 80       	push   $0x80112600
801023f8:	53                   	push   %ebx
801023f9:	e8 e2 21 00 00       	call   801045e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 c4 10             	add    $0x10,%esp
80102403:	83 e0 06             	and    $0x6,%eax
80102406:	83 f8 02             	cmp    $0x2,%eax
80102409:	75 e5                	jne    801023f0 <iderw+0x80>
  }


  release(&idelock);
8010240b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102415:	c9                   	leave
  release(&idelock);
80102416:	e9 95 27 00 00       	jmp    80104bb0 <release>
8010241b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    idestart(b);
80102420:	89 d8                	mov    %ebx,%eax
80102422:	e8 39 fd ff ff       	call   80102160 <idestart>
80102427:	eb bd                	jmp    801023e6 <iderw+0x76>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102430:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102435:	eb a5                	jmp    801023dc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 75 7a 10 80       	push   $0x80107a75
8010243f:	e8 3c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	68 60 7a 10 80       	push   $0x80107a60
8010244c:	e8 2f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102451:	83 ec 0c             	sub    $0xc,%esp
80102454:	68 4a 7a 10 80       	push   $0x80107a4a
80102459:	e8 22 df ff ff       	call   80100380 <panic>
8010245e:	66 90                	xchg   %ax,%ax

80102460 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102465:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010246c:	00 c0 fe 
  ioapic->reg = reg;
8010246f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102476:	00 00 00 
  return ioapic->data;
80102479:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010247f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102482:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102488:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010248e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102495:	c1 ee 10             	shr    $0x10,%esi
80102498:	89 f0                	mov    %esi,%eax
8010249a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010249d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801024a0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024a3:	39 c2                	cmp    %eax,%edx
801024a5:	74 16                	je     801024bd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 94 7a 10 80       	push   $0x80107a94
801024af:	e8 fc e1 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
801024b4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801024ba:	83 c4 10             	add    $0x10,%esp
{
801024bd:	ba 10 00 00 00       	mov    $0x10,%edx
801024c2:	31 c0                	xor    %eax,%eax
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024c8:	89 13                	mov    %edx,(%ebx)
801024ca:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024cd:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024d3:	83 c0 01             	add    $0x1,%eax
801024d6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024dc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024df:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024e2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024e5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024e7:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801024ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024f4:	39 c6                	cmp    %eax,%esi
801024f6:	7d d0                	jge    801024c8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024fb:	5b                   	pop    %ebx
801024fc:	5e                   	pop    %esi
801024fd:	5d                   	pop    %ebp
801024fe:	c3                   	ret
801024ff:	90                   	nop

80102500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102500:	55                   	push   %ebp
  ioapic->reg = reg;
80102501:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102507:	89 e5                	mov    %esp,%ebp
80102509:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010250c:	8d 50 20             	lea    0x20(%eax),%edx
8010250f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102513:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102515:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010251e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102521:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102524:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102526:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010252b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010252e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	83 ec 04             	sub    $0x4,%esp
80102547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010254a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102550:	75 76                	jne    801025c8 <kfree+0x88>
80102552:	81 fb f0 68 11 80    	cmp    $0x801168f0,%ebx
80102558:	72 6e                	jb     801025c8 <kfree+0x88>
8010255a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102560:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102565:	77 61                	ja     801025c8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102567:	83 ec 04             	sub    $0x4,%esp
8010256a:	68 00 10 00 00       	push   $0x1000
8010256f:	6a 01                	push   $0x1
80102571:	53                   	push   %ebx
80102572:	e8 89 26 00 00       	call   80104c00 <memset>

  if(kmem.use_lock)
80102577:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 d2                	test   %edx,%edx
80102582:	75 1c                	jne    801025a0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102584:	a1 78 26 11 80       	mov    0x80112678,%eax
80102589:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010258b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102590:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102596:	85 c0                	test   %eax,%eax
80102598:	75 1e                	jne    801025b8 <kfree+0x78>
    release(&kmem.lock);
}
8010259a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259d:	c9                   	leave
8010259e:	c3                   	ret
8010259f:	90                   	nop
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 40 26 11 80       	push   $0x80112640
801025a8:	e8 c3 24 00 00       	call   80104a70 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb d2                	jmp    80102584 <kfree+0x44>
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025b8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801025bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c2:	c9                   	leave
    release(&kmem.lock);
801025c3:	e9 e8 25 00 00       	jmp    80104bb0 <release>
    panic("kfree");
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	68 c6 7a 10 80       	push   $0x80107ac6
801025d0:	e8 ab dd ff ff       	call   80100380 <panic>
801025d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 23 ff ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <freerange+0x28>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret
8010262b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <kinit2>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102638:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <kinit2+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 d3 fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret
80102685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 cc 7a 10 80       	push   $0x80107acc
801026a0:	68 40 26 11 80       	push   $0x80112640
801026a5:	e8 a6 22 00 00       	call   80104950 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cc:	39 de                	cmp    %ebx,%esi
801026ce:	72 1c                	jb     801026ec <kinit1+0x5c>
    kfree(p);
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026df:	50                   	push   %eax
801026e0:	e8 5b fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	39 de                	cmp    %ebx,%esi
801026ea:	73 e4                	jae    801026d0 <kinit1+0x40>
}
801026ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ef:	5b                   	pop    %ebx
801026f0:	5e                   	pop    %esi
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret
801026f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102700 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102707:	a1 74 26 11 80       	mov    0x80112674,%eax
8010270c:	85 c0                	test   %eax,%eax
8010270e:	75 20                	jne    80102730 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102710:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102716:	85 db                	test   %ebx,%ebx
80102718:	74 07                	je     80102721 <kalloc+0x21>
    kmem.freelist = r->next;
8010271a:	8b 03                	mov    (%ebx),%eax
8010271c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102721:	89 d8                	mov    %ebx,%eax
80102723:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102726:	c9                   	leave
80102727:	c3                   	ret
80102728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272f:	90                   	nop
    acquire(&kmem.lock);
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 40 26 11 80       	push   $0x80112640
80102738:	e8 33 23 00 00       	call   80104a70 <acquire>
  r = kmem.freelist;
8010273d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102743:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
80102748:	83 c4 10             	add    $0x10,%esp
8010274b:	85 db                	test   %ebx,%ebx
8010274d:	74 08                	je     80102757 <kalloc+0x57>
    kmem.freelist = r->next;
8010274f:	8b 13                	mov    (%ebx),%edx
80102751:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102757:	85 c0                	test   %eax,%eax
80102759:	74 c6                	je     80102721 <kalloc+0x21>
    release(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 40 26 11 80       	push   $0x80112640
80102763:	e8 48 24 00 00       	call   80104bb0 <release>
}
80102768:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010276a:	83 c4 10             	add    $0x10,%esp
}
8010276d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102770:	c9                   	leave
80102771:	c3                   	ret
80102772:	66 90                	xchg   %ax,%ax
80102774:	66 90                	xchg   %ax,%ax
80102776:	66 90                	xchg   %ax,%ax
80102778:	66 90                	xchg   %ax,%ax
8010277a:	66 90                	xchg   %ax,%ax
8010277c:	66 90                	xchg   %ax,%ax
8010277e:	66 90                	xchg   %ax,%ax

80102780 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102780:	ba 64 00 00 00       	mov    $0x64,%edx
80102785:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102786:	a8 01                	test   $0x1,%al
80102788:	0f 84 c2 00 00 00    	je     80102850 <kbdgetc+0xd0>
{
8010278e:	55                   	push   %ebp
8010278f:	ba 60 00 00 00       	mov    $0x60,%edx
80102794:	89 e5                	mov    %esp,%ebp
80102796:	53                   	push   %ebx
80102797:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102798:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010279e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027a1:	3c e0                	cmp    $0xe0,%al
801027a3:	74 5b                	je     80102800 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027a5:	89 da                	mov    %ebx,%edx
801027a7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027aa:	84 c0                	test   %al,%al
801027ac:	78 6a                	js     80102818 <kbdgetc+0x98>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027ae:	85 d2                	test   %edx,%edx
801027b0:	74 09                	je     801027bb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027b2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027b5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027b8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027bb:	0f b6 91 00 7c 10 80 	movzbl -0x7fef8400(%ecx),%edx
  shift ^= togglecode[data];
801027c2:	0f b6 81 00 7b 10 80 	movzbl -0x7fef8500(%ecx),%eax
  shift |= shiftcode[data];
801027c9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027cb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027cd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027cf:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801027d5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027d8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027db:	8b 04 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%eax
801027e2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027e6:	74 0b                	je     801027f3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027e8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027eb:	83 fa 19             	cmp    $0x19,%edx
801027ee:	77 48                	ja     80102838 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027f0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027f6:	c9                   	leave
801027f7:	c3                   	ret
801027f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ff:	90                   	nop
    shift |= E0ESC;
80102800:	89 d8                	mov    %ebx,%eax
80102802:	83 c8 40             	or     $0x40,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102805:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
8010280a:	31 c0                	xor    %eax,%eax
}
8010280c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010280f:	c9                   	leave
80102810:	c3                   	ret
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
80102818:	83 e0 7f             	and    $0x7f,%eax
8010281b:	85 d2                	test   %edx,%edx
8010281d:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102820:	0f b6 81 00 7c 10 80 	movzbl -0x7fef8400(%ecx),%eax
80102827:	83 c8 40             	or     $0x40,%eax
8010282a:	0f b6 c0             	movzbl %al,%eax
8010282d:	f7 d0                	not    %eax
8010282f:	21 d8                	and    %ebx,%eax
    return 0;
80102831:	eb d2                	jmp    80102805 <kbdgetc+0x85>
80102833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102837:	90                   	nop
    else if('A' <= c && c <= 'Z')
80102838:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010283b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010283e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102841:	c9                   	leave
      c += 'a' - 'A';
80102842:	83 f9 1a             	cmp    $0x1a,%ecx
80102845:	0f 42 c2             	cmovb  %edx,%eax
}
80102848:	c3                   	ret
80102849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102855:	c3                   	ret
80102856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285d:	8d 76 00             	lea    0x0(%esi),%esi

80102860 <kbdintr>:

void
kbdintr(void)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102866:	68 80 27 10 80       	push   $0x80102780
8010286b:	e8 50 e0 ff ff       	call   801008c0 <consoleintr>
}
80102870:	83 c4 10             	add    $0x10,%esp
80102873:	c9                   	leave
80102874:	c3                   	ret
80102875:	66 90                	xchg   %ax,%ax
80102877:	66 90                	xchg   %ax,%ax
80102879:	66 90                	xchg   %ax,%ax
8010287b:	66 90                	xchg   %ax,%ax
8010287d:	66 90                	xchg   %ax,%ax
8010287f:	90                   	nop

80102880 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102880:	a1 80 26 11 80       	mov    0x80112680,%eax
80102885:	85 c0                	test   %eax,%eax
80102887:	0f 84 cb 00 00 00    	je     80102958 <lapicinit+0xd8>
  lapic[index] = value;
8010288d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102894:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028ae:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028bb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ce:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028d5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028db:	8b 50 30             	mov    0x30(%eax),%edx
801028de:	c1 ea 10             	shr    $0x10,%edx
801028e1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028e7:	75 77                	jne    80102960 <lapicinit+0xe0>
  lapic[index] = value;
801028e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102900:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102903:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010290a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010290d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102910:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102917:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102924:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102931:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102934:	8b 50 20             	mov    0x20(%eax),%edx
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102940:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102946:	80 e6 10             	and    $0x10,%dh
80102949:	75 f5                	jne    80102940 <lapicinit+0xc0>
  lapic[index] = value;
8010294b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102952:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102955:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102958:	c3                   	ret
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102960:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102967:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010296a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010296d:	e9 77 ff ff ff       	jmp    801028e9 <lapicinit+0x69>
80102972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102980 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102980:	a1 80 26 11 80       	mov    0x80112680,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 07                	je     80102990 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102989:	8b 40 20             	mov    0x20(%eax),%eax
8010298c:	c1 e8 18             	shr    $0x18,%eax
8010298f:	c3                   	ret
    return 0;
80102990:	31 c0                	xor    %eax,%eax
}
80102992:	c3                   	ret
80102993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029a0:	a1 80 26 11 80       	mov    0x80112680,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	74 0d                	je     801029b6 <lapiceoi+0x16>
  lapic[index] = value;
801029a9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029b6:	c3                   	ret
801029b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029be:	66 90                	xchg   %ax,%ax

801029c0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029c0:	c3                   	ret
801029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop

801029d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	53                   	push   %ebx
801029de:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029e4:	ee                   	out    %al,(%dx)
801029e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ea:	ba 71 00 00 00       	mov    $0x71,%edx
801029ef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029f0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029f2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029fb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029fd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a00:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a02:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a0e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a5d:	c9                   	leave
80102a5e:	c3                   	ret
80102a5f:	90                   	nop

80102a60 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a60:	55                   	push   %ebp
80102a61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a66:	ba 70 00 00 00       	mov    $0x70,%edx
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	57                   	push   %edi
80102a6e:	56                   	push   %esi
80102a6f:	53                   	push   %ebx
80102a70:	83 ec 4c             	sub    $0x4c,%esp
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	ba 71 00 00 00       	mov    $0x71,%edx
80102a79:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a85:	8d 76 00             	lea    0x0(%esi),%esi
80102a88:	31 c0                	xor    %eax,%eax
80102a8a:	89 fa                	mov    %edi,%edx
80102a8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a92:	89 ca                	mov    %ecx,%edx
80102a94:	ec                   	in     (%dx),%al
80102a95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 fa                	mov    %edi,%edx
80102a9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa0:	89 ca                	mov    %ecx,%edx
80102aa2:	ec                   	in     (%dx),%al
80102aa3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa6:	89 fa                	mov    %edi,%edx
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 fa                	mov    %edi,%edx
80102ab6:	b8 07 00 00 00       	mov    $0x7,%eax
80102abb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abc:	89 ca                	mov    %ecx,%edx
80102abe:	ec                   	in     (%dx),%al
80102abf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac2:	89 fa                	mov    %edi,%edx
80102ac4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ac9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aca:	89 ca                	mov    %ecx,%edx
80102acc:	ec                   	in     (%dx),%al
80102acd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ad6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad7:	89 ca                	mov    %ecx,%edx
80102ad9:	ec                   	in     (%dx),%al
80102ada:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	89 fa                	mov    %edi,%edx
80102adf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 ca                	mov    %ecx,%edx
80102ae7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ae8:	84 c0                	test   %al,%al
80102aea:	78 9c                	js     80102a88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aec:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102af0:	89 f2                	mov    %esi,%edx
80102af2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102af5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af8:	89 fa                	mov    %edi,%edx
80102afa:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102afd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b01:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b04:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b07:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b0b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b0e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b12:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b15:	31 c0                	xor    %eax,%eax
80102b17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b18:	89 ca                	mov    %ecx,%edx
80102b1a:	ec                   	in     (%dx),%al
80102b1b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1e:	89 fa                	mov    %edi,%edx
80102b20:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b23:	b8 02 00 00 00       	mov    $0x2,%eax
80102b28:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b29:	89 ca                	mov    %ecx,%edx
80102b2b:	ec                   	in     (%dx),%al
80102b2c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2f:	89 fa                	mov    %edi,%edx
80102b31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b34:	b8 04 00 00 00       	mov    $0x4,%eax
80102b39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3a:	89 ca                	mov    %ecx,%edx
80102b3c:	ec                   	in     (%dx),%al
80102b3d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b40:	89 fa                	mov    %edi,%edx
80102b42:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b45:	b8 07 00 00 00       	mov    $0x7,%eax
80102b4a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4b:	89 ca                	mov    %ecx,%edx
80102b4d:	ec                   	in     (%dx),%al
80102b4e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	89 fa                	mov    %edi,%edx
80102b53:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b56:	b8 08 00 00 00       	mov    $0x8,%eax
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 ca                	mov    %ecx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 fa                	mov    %edi,%edx
80102b64:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b67:	b8 09 00 00 00       	mov    $0x9,%eax
80102b6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6d:	89 ca                	mov    %ecx,%edx
80102b6f:	ec                   	in     (%dx),%al
80102b70:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b73:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b79:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b7c:	6a 18                	push   $0x18
80102b7e:	50                   	push   %eax
80102b7f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b82:	50                   	push   %eax
80102b83:	e8 b8 20 00 00       	call   80104c40 <memcmp>
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	0f 85 f5 fe ff ff    	jne    80102a88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b93:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b9a:	89 f0                	mov    %esi,%eax
80102b9c:	84 c0                	test   %al,%al
80102b9e:	75 78                	jne    80102c18 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ba0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ba3:	89 c2                	mov    %eax,%edx
80102ba5:	83 e0 0f             	and    $0xf,%eax
80102ba8:	c1 ea 04             	shr    $0x4,%edx
80102bab:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bae:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bb4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb7:	89 c2                	mov    %eax,%edx
80102bb9:	83 e0 0f             	and    $0xf,%eax
80102bbc:	c1 ea 04             	shr    $0x4,%edx
80102bbf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bc8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bcb:	89 c2                	mov    %eax,%edx
80102bcd:	83 e0 0f             	and    $0xf,%eax
80102bd0:	c1 ea 04             	shr    $0x4,%edx
80102bd3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bdc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bdf:	89 c2                	mov    %eax,%edx
80102be1:	83 e0 0f             	and    $0xf,%eax
80102be4:	c1 ea 04             	shr    $0x4,%edx
80102be7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bea:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf3:	89 c2                	mov    %eax,%edx
80102bf5:	83 e0 0f             	and    $0xf,%eax
80102bf8:	c1 ea 04             	shr    $0x4,%edx
80102bfb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bfe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c01:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c04:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c07:	89 c2                	mov    %eax,%edx
80102c09:	83 e0 0f             	and    $0xf,%eax
80102c0c:	c1 ea 04             	shr    $0x4,%edx
80102c0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c15:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c1b:	89 03                	mov    %eax,(%ebx)
80102c1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c20:	89 43 04             	mov    %eax,0x4(%ebx)
80102c23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c26:	89 43 08             	mov    %eax,0x8(%ebx)
80102c29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c2c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c32:	89 43 10             	mov    %eax,0x10(%ebx)
80102c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c38:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c3b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c45:	5b                   	pop    %ebx
80102c46:	5e                   	pop    %esi
80102c47:	5f                   	pop    %edi
80102c48:	5d                   	pop    %ebp
80102c49:	c3                   	ret
80102c4a:	66 90                	xchg   %ax,%ax
80102c4c:	66 90                	xchg   %ax,%ax
80102c4e:	66 90                	xchg   %ax,%ax

80102c50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c50:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c56:	85 c9                	test   %ecx,%ecx
80102c58:	0f 8e 8a 00 00 00    	jle    80102ce8 <install_trans+0x98>
{
80102c5e:	55                   	push   %ebp
80102c5f:	89 e5                	mov    %esp,%ebp
80102c61:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c62:	31 ff                	xor    %edi,%edi
{
80102c64:	56                   	push   %esi
80102c65:	53                   	push   %ebx
80102c66:	83 ec 0c             	sub    $0xc,%esp
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c75:	83 ec 08             	sub    $0x8,%esp
80102c78:	01 f8                	add    %edi,%eax
80102c7a:	83 c0 01             	add    $0x1,%eax
80102c7d:	50                   	push   %eax
80102c7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c84:	e8 47 d4 ff ff       	call   801000d0 <bread>
80102c89:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c8b:	58                   	pop    %eax
80102c8c:	5a                   	pop    %edx
80102c8d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c9d:	e8 2e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ca2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ca5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ca7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102caa:	68 00 02 00 00       	push   $0x200
80102caf:	50                   	push   %eax
80102cb0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cb3:	50                   	push   %eax
80102cb4:	e8 d7 1f 00 00       	call   80104c90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cb9:	89 1c 24             	mov    %ebx,(%esp)
80102cbc:	e8 ef d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102cc1:	89 34 24             	mov    %esi,(%esp)
80102cc4:	e8 27 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cc9:	89 1c 24             	mov    %ebx,(%esp)
80102ccc:	e8 1f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd1:	83 c4 10             	add    $0x10,%esp
80102cd4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102cda:	7f 94                	jg     80102c70 <install_trans+0x20>
  }
}
80102cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cdf:	5b                   	pop    %ebx
80102ce0:	5e                   	pop    %esi
80102ce1:	5f                   	pop    %edi
80102ce2:	5d                   	pop    %ebp
80102ce3:	c3                   	ret
80102ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ce8:	c3                   	ret
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cf7:	ff 35 d4 26 11 80    	push   0x801126d4
80102cfd:	ff 35 e4 26 11 80    	push   0x801126e4
80102d03:	e8 c8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d08:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d0b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d0d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102d12:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d15:	85 c0                	test   %eax,%eax
80102d17:	7e 19                	jle    80102d32 <write_head+0x42>
80102d19:	31 d2                	xor    %edx,%edx
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d20:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102d27:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d0                	cmp    %edx,%eax
80102d30:	75 ee                	jne    80102d20 <write_head+0x30>
  }
  bwrite(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	53                   	push   %ebx
80102d36:	e8 75 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d3b:	89 1c 24             	mov    %ebx,(%esp)
80102d3e:	e8 ad d4 ff ff       	call   801001f0 <brelse>
}
80102d43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d46:	83 c4 10             	add    $0x10,%esp
80102d49:	c9                   	leave
80102d4a:	c3                   	ret
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop

80102d50 <initlog>:
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 2c             	sub    $0x2c,%esp
80102d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d5a:	68 00 7d 10 80       	push   $0x80107d00
80102d5f:	68 a0 26 11 80       	push   $0x801126a0
80102d64:	e8 e7 1b 00 00       	call   80104950 <initlock>
  readsb(dev, &sb);
80102d69:	58                   	pop    %eax
80102d6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 1b e8 ff ff       	call   80101590 <readsb>
  log.size = sb.nlog;
80102d75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.dev = dev;
80102d7b:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.start = sb.logstart;
80102d81:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d86:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d8c:	59                   	pop    %ecx
80102d8d:	5a                   	pop    %edx
80102d8e:	50                   	push   %eax
80102d8f:	53                   	push   %ebx
80102d90:	e8 3b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d95:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d98:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d9b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102da1:	85 db                	test   %ebx,%ebx
80102da3:	7e 1d                	jle    80102dc2 <initlog+0x72>
80102da5:	31 d2                	xor    %edx,%edx
80102da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dae:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102db0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102db4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dbb:	83 c2 01             	add    $0x1,%edx
80102dbe:	39 d3                	cmp    %edx,%ebx
80102dc0:	75 ee                	jne    80102db0 <initlog+0x60>
  brelse(buf);
80102dc2:	83 ec 0c             	sub    $0xc,%esp
80102dc5:	50                   	push   %eax
80102dc6:	e8 25 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dcb:	e8 80 fe ff ff       	call   80102c50 <install_trans>
  log.lh.n = 0;
80102dd0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102dd7:	00 00 00 
  write_head(); // clear the log
80102dda:	e8 11 ff ff ff       	call   80102cf0 <write_head>
}
80102ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102de2:	83 c4 10             	add    $0x10,%esp
80102de5:	c9                   	leave
80102de6:	c3                   	ret
80102de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102df6:	68 a0 26 11 80       	push   $0x801126a0
80102dfb:	e8 70 1c 00 00       	call   80104a70 <acquire>
80102e00:	83 c4 10             	add    $0x10,%esp
80102e03:	eb 18                	jmp    80102e1d <begin_op+0x2d>
80102e05:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e08:	83 ec 08             	sub    $0x8,%esp
80102e0b:	68 a0 26 11 80       	push   $0x801126a0
80102e10:	68 a0 26 11 80       	push   $0x801126a0
80102e15:	e8 c6 17 00 00       	call   801045e0 <sleep>
80102e1a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e1d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102e22:	85 c0                	test   %eax,%eax
80102e24:	75 e2                	jne    80102e08 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e26:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e2b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e31:	83 c0 01             	add    $0x1,%eax
80102e34:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e37:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e3a:	83 fa 1e             	cmp    $0x1e,%edx
80102e3d:	7f c9                	jg     80102e08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e3f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e42:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e47:	68 a0 26 11 80       	push   $0x801126a0
80102e4c:	e8 5f 1d 00 00       	call   80104bb0 <release>
      break;
    }
  }
}
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	c9                   	leave
80102e55:	c3                   	ret
80102e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi

80102e60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	57                   	push   %edi
80102e64:	56                   	push   %esi
80102e65:	53                   	push   %ebx
80102e66:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e69:	68 a0 26 11 80       	push   $0x801126a0
80102e6e:	e8 fd 1b 00 00       	call   80104a70 <acquire>
  log.outstanding -= 1;
80102e73:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e78:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e7e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e81:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e84:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e8a:	85 f6                	test   %esi,%esi
80102e8c:	0f 85 22 01 00 00    	jne    80102fb4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e92:	85 db                	test   %ebx,%ebx
80102e94:	0f 85 f6 00 00 00    	jne    80102f90 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e9a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102ea1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ea4:	83 ec 0c             	sub    $0xc,%esp
80102ea7:	68 a0 26 11 80       	push   $0x801126a0
80102eac:	e8 ff 1c 00 00       	call   80104bb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102eb1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102eb7:	83 c4 10             	add    $0x10,%esp
80102eba:	85 c9                	test   %ecx,%ecx
80102ebc:	7f 42                	jg     80102f00 <end_op+0xa0>
    acquire(&log.lock);
80102ebe:	83 ec 0c             	sub    $0xc,%esp
80102ec1:	68 a0 26 11 80       	push   $0x801126a0
80102ec6:	e8 a5 1b 00 00       	call   80104a70 <acquire>
    log.committing = 0;
80102ecb:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102ed2:	00 00 00 
    wakeup(&log);
80102ed5:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102edc:	e8 bf 17 00 00       	call   801046a0 <wakeup>
    release(&log.lock);
80102ee1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ee8:	e8 c3 1c 00 00       	call   80104bb0 <release>
80102eed:	83 c4 10             	add    $0x10,%esp
}
80102ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef3:	5b                   	pop    %ebx
80102ef4:	5e                   	pop    %esi
80102ef5:	5f                   	pop    %edi
80102ef6:	5d                   	pop    %ebp
80102ef7:	c3                   	ret
80102ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f00:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	01 d8                	add    %ebx,%eax
80102f0a:	83 c0 01             	add    $0x1,%eax
80102f0d:	50                   	push   %eax
80102f0e:	ff 35 e4 26 11 80    	push   0x801126e4
80102f14:	e8 b7 d1 ff ff       	call   801000d0 <bread>
80102f19:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f1b:	58                   	pop    %eax
80102f1c:	5a                   	pop    %edx
80102f1d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102f24:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f2d:	e8 9e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f32:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f35:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f37:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f3a:	68 00 02 00 00       	push   $0x200
80102f3f:	50                   	push   %eax
80102f40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f43:	50                   	push   %eax
80102f44:	e8 47 1d 00 00       	call   80104c90 <memmove>
    bwrite(to);  // write the log
80102f49:	89 34 24             	mov    %esi,(%esp)
80102f4c:	e8 5f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f51:	89 3c 24             	mov    %edi,(%esp)
80102f54:	e8 97 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f59:	89 34 24             	mov    %esi,(%esp)
80102f5c:	e8 8f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f6a:	7c 94                	jl     80102f00 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f6c:	e8 7f fd ff ff       	call   80102cf0 <write_head>
    install_trans(); // Now install writes to home locations
80102f71:	e8 da fc ff ff       	call   80102c50 <install_trans>
    log.lh.n = 0;
80102f76:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f7d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f80:	e8 6b fd ff ff       	call   80102cf0 <write_head>
80102f85:	e9 34 ff ff ff       	jmp    80102ebe <end_op+0x5e>
80102f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f90:	83 ec 0c             	sub    $0xc,%esp
80102f93:	68 a0 26 11 80       	push   $0x801126a0
80102f98:	e8 03 17 00 00       	call   801046a0 <wakeup>
  release(&log.lock);
80102f9d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102fa4:	e8 07 1c 00 00       	call   80104bb0 <release>
80102fa9:	83 c4 10             	add    $0x10,%esp
}
80102fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102faf:	5b                   	pop    %ebx
80102fb0:	5e                   	pop    %esi
80102fb1:	5f                   	pop    %edi
80102fb2:	5d                   	pop    %ebp
80102fb3:	c3                   	ret
    panic("log.committing");
80102fb4:	83 ec 0c             	sub    $0xc,%esp
80102fb7:	68 04 7d 10 80       	push   $0x80107d04
80102fbc:	e8 bf d3 ff ff       	call   80100380 <panic>
80102fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop

80102fd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fd7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fe0:	83 fa 1d             	cmp    $0x1d,%edx
80102fe3:	7f 7d                	jg     80103062 <log_write+0x92>
80102fe5:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102fea:	83 e8 01             	sub    $0x1,%eax
80102fed:	39 c2                	cmp    %eax,%edx
80102fef:	7d 71                	jge    80103062 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ff1:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102ff6:	85 c0                	test   %eax,%eax
80102ff8:	7e 75                	jle    8010306f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ffa:	83 ec 0c             	sub    $0xc,%esp
80102ffd:	68 a0 26 11 80       	push   $0x801126a0
80103002:	e8 69 1a 00 00       	call   80104a70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	31 c0                	xor    %eax,%eax
8010300f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103015:	85 d2                	test   %edx,%edx
80103017:	7f 0e                	jg     80103027 <log_write+0x57>
80103019:	eb 15                	jmp    80103030 <log_write+0x60>
8010301b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop
80103020:	83 c0 01             	add    $0x1,%eax
80103023:	39 c2                	cmp    %eax,%edx
80103025:	74 29                	je     80103050 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103027:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010302e:	75 f0                	jne    80103020 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103030:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80103037:	39 c2                	cmp    %eax,%edx
80103039:	74 1c                	je     80103057 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010303b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010303e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103041:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103048:	c9                   	leave
  release(&log.lock);
80103049:	e9 62 1b 00 00       	jmp    80104bb0 <release>
8010304e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103050:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103057:	83 c2 01             	add    $0x1,%edx
8010305a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103060:	eb d9                	jmp    8010303b <log_write+0x6b>
    panic("too big a transaction");
80103062:	83 ec 0c             	sub    $0xc,%esp
80103065:	68 13 7d 10 80       	push   $0x80107d13
8010306a:	e8 11 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010306f:	83 ec 0c             	sub    $0xc,%esp
80103072:	68 29 7d 10 80       	push   $0x80107d29
80103077:	e8 04 d3 ff ff       	call   80100380 <panic>
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103087:	e8 e4 09 00 00       	call   80103a70 <cpuid>
8010308c:	89 c3                	mov    %eax,%ebx
8010308e:	e8 dd 09 00 00       	call   80103a70 <cpuid>
80103093:	83 ec 04             	sub    $0x4,%esp
80103096:	53                   	push   %ebx
80103097:	50                   	push   %eax
80103098:	68 44 7d 10 80       	push   $0x80107d44
8010309d:	e8 0e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801030a2:	e8 19 2f 00 00       	call   80105fc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030a7:	e8 64 09 00 00       	call   80103a10 <mycpu>
801030ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ae:	b8 01 00 00 00       	mov    $0x1,%eax
801030b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030ba:	e8 91 0e 00 00       	call   80103f50 <scheduler>
801030bf:	90                   	nop

801030c0 <mpenter>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030c6:	e8 05 40 00 00       	call   801070d0 <switchkvm>
  seginit();
801030cb:	e8 70 3f 00 00       	call   80107040 <seginit>
  lapicinit();
801030d0:	e8 ab f7 ff ff       	call   80102880 <lapicinit>
  mpmain();
801030d5:	e8 a6 ff ff ff       	call   80103080 <mpmain>
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <main>:
{
801030e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030e4:	83 e4 f0             	and    $0xfffffff0,%esp
801030e7:	ff 71 fc             	push   -0x4(%ecx)
801030ea:	55                   	push   %ebp
801030eb:	89 e5                	mov    %esp,%ebp
801030ed:	53                   	push   %ebx
801030ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030ef:	83 ec 08             	sub    $0x8,%esp
801030f2:	68 00 00 40 80       	push   $0x80400000
801030f7:	68 f0 68 11 80       	push   $0x801168f0
801030fc:	e8 8f f5 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103101:	e8 8a 44 00 00       	call   80107590 <kvmalloc>
  mpinit();        // detect other processors
80103106:	e8 85 01 00 00       	call   80103290 <mpinit>
  lapicinit();     // interrupt controller
8010310b:	e8 70 f7 ff ff       	call   80102880 <lapicinit>
  seginit();       // segment descriptors
80103110:	e8 2b 3f 00 00       	call   80107040 <seginit>
  picinit();       // disable pic
80103115:	e8 86 03 00 00       	call   801034a0 <picinit>
  ioapicinit();    // another interrupt controller
8010311a:	e8 41 f3 ff ff       	call   80102460 <ioapicinit>
  consoleinit();   // console hardware
8010311f:	e8 6c d9 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
80103124:	e8 87 31 00 00       	call   801062b0 <uartinit>
  pinit();         // process table
80103129:	e8 c2 08 00 00       	call   801039f0 <pinit>
  tvinit();        // trap vectors
8010312e:	e8 0d 2e 00 00       	call   80105f40 <tvinit>
  binit();         // buffer cache
80103133:	e8 08 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103138:	e8 23 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
8010313d:	e8 fe f0 ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103142:	83 c4 0c             	add    $0xc,%esp
80103145:	68 8a 00 00 00       	push   $0x8a
8010314a:	68 8c b4 10 80       	push   $0x8010b48c
8010314f:	68 00 70 00 80       	push   $0x80007000
80103154:	e8 37 1b 00 00       	call   80104c90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103163:	00 00 00 
80103166:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010316b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103170:	76 7e                	jbe    801031f0 <main+0x110>
80103172:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103177:	eb 20                	jmp    80103199 <main+0xb9>
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103187:	00 00 00 
8010318a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103190:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103195:	39 c3                	cmp    %eax,%ebx
80103197:	73 57                	jae    801031f0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103199:	e8 72 08 00 00       	call   80103a10 <mycpu>
8010319e:	39 c3                	cmp    %eax,%ebx
801031a0:	74 de                	je     80103180 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031a2:	e8 59 f5 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031a7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801031aa:	c7 05 f8 6f 00 80 c0 	movl   $0x801030c0,0x80006ff8
801031b1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031b4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031bb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031be:	05 00 10 00 00       	add    $0x1000,%eax
801031c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031c8:	0f b6 03             	movzbl (%ebx),%eax
801031cb:	68 00 70 00 00       	push   $0x7000
801031d0:	50                   	push   %eax
801031d1:	e8 fa f7 ff ff       	call   801029d0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031d6:	83 c4 10             	add    $0x10,%esp
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031e6:	85 c0                	test   %eax,%eax
801031e8:	74 f6                	je     801031e0 <main+0x100>
801031ea:	eb 94                	jmp    80103180 <main+0xa0>
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031f0:	83 ec 08             	sub    $0x8,%esp
801031f3:	68 00 00 00 8e       	push   $0x8e000000
801031f8:	68 00 00 40 80       	push   $0x80400000
801031fd:	e8 2e f4 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
80103202:	e8 b9 08 00 00       	call   80103ac0 <userinit>
  mpmain();        // finish this processor's setup
80103207:	e8 74 fe ff ff       	call   80103080 <mpmain>
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103215:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010321b:	53                   	push   %ebx
  e = addr+len;
8010321c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010321f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103222:	39 de                	cmp    %ebx,%esi
80103224:	72 10                	jb     80103236 <mpsearch1+0x26>
80103226:	eb 50                	jmp    80103278 <mpsearch1+0x68>
80103228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop
80103230:	89 fe                	mov    %edi,%esi
80103232:	39 df                	cmp    %ebx,%edi
80103234:	73 42                	jae    80103278 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103236:	83 ec 04             	sub    $0x4,%esp
80103239:	8d 7e 10             	lea    0x10(%esi),%edi
8010323c:	6a 04                	push   $0x4
8010323e:	68 58 7d 10 80       	push   $0x80107d58
80103243:	56                   	push   %esi
80103244:	e8 f7 19 00 00       	call   80104c40 <memcmp>
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	85 c0                	test   %eax,%eax
8010324e:	75 e0                	jne    80103230 <mpsearch1+0x20>
80103250:	89 f2                	mov    %esi,%edx
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103258:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010325b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010325e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103260:	39 fa                	cmp    %edi,%edx
80103262:	75 f4                	jne    80103258 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103264:	84 c0                	test   %al,%al
80103266:	75 c8                	jne    80103230 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326b:	89 f0                	mov    %esi,%eax
8010326d:	5b                   	pop    %ebx
8010326e:	5e                   	pop    %esi
8010326f:	5f                   	pop    %edi
80103270:	5d                   	pop    %ebp
80103271:	c3                   	ret
80103272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010327b:	31 f6                	xor    %esi,%esi
}
8010327d:	5b                   	pop    %ebx
8010327e:	89 f0                	mov    %esi,%eax
80103280:	5e                   	pop    %esi
80103281:	5f                   	pop    %edi
80103282:	5d                   	pop    %ebp
80103283:	c3                   	ret
80103284:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop

80103290 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103299:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032a7:	c1 e0 08             	shl    $0x8,%eax
801032aa:	09 d0                	or     %edx,%eax
801032ac:	c1 e0 04             	shl    $0x4,%eax
801032af:	75 1b                	jne    801032cc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032b1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032b8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032bf:	c1 e0 08             	shl    $0x8,%eax
801032c2:	09 d0                	or     %edx,%eax
801032c4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032c7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032cc:	ba 00 04 00 00       	mov    $0x400,%edx
801032d1:	e8 3a ff ff ff       	call   80103210 <mpsearch1>
801032d6:	89 c3                	mov    %eax,%ebx
801032d8:	85 c0                	test   %eax,%eax
801032da:	0f 84 50 01 00 00    	je     80103430 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032e0:	8b 73 04             	mov    0x4(%ebx),%esi
801032e3:	85 f6                	test   %esi,%esi
801032e5:	0f 84 35 01 00 00    	je     80103420 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
801032eb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ee:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032f7:	6a 04                	push   $0x4
801032f9:	68 5d 7d 10 80       	push   $0x80107d5d
801032fe:	50                   	push   %eax
801032ff:	e8 3c 19 00 00       	call   80104c40 <memcmp>
80103304:	83 c4 10             	add    $0x10,%esp
80103307:	85 c0                	test   %eax,%eax
80103309:	0f 85 11 01 00 00    	jne    80103420 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
8010330f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103316:	3c 01                	cmp    $0x1,%al
80103318:	74 08                	je     80103322 <mpinit+0x92>
8010331a:	3c 04                	cmp    $0x4,%al
8010331c:	0f 85 fe 00 00 00    	jne    80103420 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80103322:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103329:	66 85 d2             	test   %dx,%dx
8010332c:	74 22                	je     80103350 <mpinit+0xc0>
8010332e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103331:	89 f0                	mov    %esi,%eax
  sum = 0;
80103333:	31 d2                	xor    %edx,%edx
80103335:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103338:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010333f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103342:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103344:	39 c7                	cmp    %eax,%edi
80103346:	75 f0                	jne    80103338 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103348:	84 d2                	test   %dl,%dl
8010334a:	0f 85 d0 00 00 00    	jne    80103420 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103350:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103359:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010335c:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103361:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103368:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
8010336e:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103373:	01 d7                	add    %edx,%edi
80103375:	89 fa                	mov    %edi,%edx
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
80103380:	39 d0                	cmp    %edx,%eax
80103382:	73 15                	jae    80103399 <mpinit+0x109>
    switch(*p){
80103384:	0f b6 08             	movzbl (%eax),%ecx
80103387:	80 f9 02             	cmp    $0x2,%cl
8010338a:	74 54                	je     801033e0 <mpinit+0x150>
8010338c:	77 42                	ja     801033d0 <mpinit+0x140>
8010338e:	84 c9                	test   %cl,%cl
80103390:	74 5e                	je     801033f0 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103392:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103395:	39 d0                	cmp    %edx,%eax
80103397:	72 eb                	jb     80103384 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103399:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010339c:	85 f6                	test   %esi,%esi
8010339e:	0f 84 e1 00 00 00    	je     80103485 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033a4:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033a8:	74 15                	je     801033bf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033aa:	b8 70 00 00 00       	mov    $0x70,%eax
801033af:	ba 22 00 00 00       	mov    $0x22,%edx
801033b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b5:	ba 23 00 00 00       	mov    $0x23,%edx
801033ba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033bb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033be:	ee                   	out    %al,(%dx)
  }
}
801033bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033c2:	5b                   	pop    %ebx
801033c3:	5e                   	pop    %esi
801033c4:	5f                   	pop    %edi
801033c5:	5d                   	pop    %ebp
801033c6:	c3                   	ret
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax
    switch(*p){
801033d0:	83 e9 03             	sub    $0x3,%ecx
801033d3:	80 f9 01             	cmp    $0x1,%cl
801033d6:	76 ba                	jbe    80103392 <mpinit+0x102>
801033d8:	31 f6                	xor    %esi,%esi
801033da:	eb a4                	jmp    80103380 <mpinit+0xf0>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033e0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033e4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033e7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801033ed:	eb 91                	jmp    80103380 <mpinit+0xf0>
801033ef:	90                   	nop
      if(ncpu < NCPU) {
801033f0:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801033f6:	83 f9 07             	cmp    $0x7,%ecx
801033f9:	7f 19                	jg     80103414 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033fb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103401:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103405:	83 c1 01             	add    $0x1,%ecx
80103408:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010340e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103414:	83 c0 14             	add    $0x14,%eax
      continue;
80103417:	e9 64 ff ff ff       	jmp    80103380 <mpinit+0xf0>
8010341c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103420:	83 ec 0c             	sub    $0xc,%esp
80103423:	68 62 7d 10 80       	push   $0x80107d62
80103428:	e8 53 cf ff ff       	call   80100380 <panic>
8010342d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103430:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103435:	eb 13                	jmp    8010344a <mpinit+0x1ba>
80103437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103440:	89 f3                	mov    %esi,%ebx
80103442:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103448:	74 d6                	je     80103420 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010344a:	83 ec 04             	sub    $0x4,%esp
8010344d:	8d 73 10             	lea    0x10(%ebx),%esi
80103450:	6a 04                	push   $0x4
80103452:	68 58 7d 10 80       	push   $0x80107d58
80103457:	53                   	push   %ebx
80103458:	e8 e3 17 00 00       	call   80104c40 <memcmp>
8010345d:	83 c4 10             	add    $0x10,%esp
80103460:	85 c0                	test   %eax,%eax
80103462:	75 dc                	jne    80103440 <mpinit+0x1b0>
80103464:	89 da                	mov    %ebx,%edx
80103466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103470:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103473:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103476:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103478:	39 f2                	cmp    %esi,%edx
8010347a:	75 f4                	jne    80103470 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010347c:	84 c0                	test   %al,%al
8010347e:	75 c0                	jne    80103440 <mpinit+0x1b0>
80103480:	e9 5b fe ff ff       	jmp    801032e0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103485:	83 ec 0c             	sub    $0xc,%esp
80103488:	68 7c 7d 10 80       	push   $0x80107d7c
8010348d:	e8 ee ce ff ff       	call   80100380 <panic>
80103492:	66 90                	xchg   %ax,%ax
80103494:	66 90                	xchg   %ax,%ax
80103496:	66 90                	xchg   %ax,%ax
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <picinit>:
801034a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034a5:	ba 21 00 00 00       	mov    $0x21,%edx
801034aa:	ee                   	out    %al,(%dx)
801034ab:	ba a1 00 00 00       	mov    $0xa1,%edx
801034b0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034b1:	c3                   	ret
801034b2:	66 90                	xchg   %ax,%ax
801034b4:	66 90                	xchg   %ax,%ax
801034b6:	66 90                	xchg   %ax,%ax
801034b8:	66 90                	xchg   %ax,%ax
801034ba:	66 90                	xchg   %ax,%ax
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	57                   	push   %edi
801034c4:	56                   	push   %esi
801034c5:	53                   	push   %ebx
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	8b 75 08             	mov    0x8(%ebp),%esi
801034cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034cf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801034d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034db:	e8 a0 d9 ff ff       	call   80100e80 <filealloc>
801034e0:	89 06                	mov    %eax,(%esi)
801034e2:	85 c0                	test   %eax,%eax
801034e4:	0f 84 a5 00 00 00    	je     8010358f <pipealloc+0xcf>
801034ea:	e8 91 d9 ff ff       	call   80100e80 <filealloc>
801034ef:	89 07                	mov    %eax,(%edi)
801034f1:	85 c0                	test   %eax,%eax
801034f3:	0f 84 84 00 00 00    	je     8010357d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034f9:	e8 02 f2 ff ff       	call   80102700 <kalloc>
801034fe:	89 c3                	mov    %eax,%ebx
80103500:	85 c0                	test   %eax,%eax
80103502:	0f 84 a0 00 00 00    	je     801035a8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103508:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010350f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103512:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103515:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010351c:	00 00 00 
  p->nwrite = 0;
8010351f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103526:	00 00 00 
  p->nread = 0;
80103529:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103530:	00 00 00 
  initlock(&p->lock, "pipe");
80103533:	68 9b 7d 10 80       	push   $0x80107d9b
80103538:	50                   	push   %eax
80103539:	e8 12 14 00 00       	call   80104950 <initlock>
  (*f0)->type = FD_PIPE;
8010353e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103540:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103543:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103549:	8b 06                	mov    (%esi),%eax
8010354b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010354f:	8b 06                	mov    (%esi),%eax
80103551:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103555:	8b 06                	mov    (%esi),%eax
80103557:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010355a:	8b 07                	mov    (%edi),%eax
8010355c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103562:	8b 07                	mov    (%edi),%eax
80103564:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103568:	8b 07                	mov    (%edi),%eax
8010356a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010356e:	8b 07                	mov    (%edi),%eax
80103570:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103573:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103578:	5b                   	pop    %ebx
80103579:	5e                   	pop    %esi
8010357a:	5f                   	pop    %edi
8010357b:	5d                   	pop    %ebp
8010357c:	c3                   	ret
  if(*f0)
8010357d:	8b 06                	mov    (%esi),%eax
8010357f:	85 c0                	test   %eax,%eax
80103581:	74 1e                	je     801035a1 <pipealloc+0xe1>
    fileclose(*f0);
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	50                   	push   %eax
80103587:	e8 b4 d9 ff ff       	call   80100f40 <fileclose>
8010358c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010358f:	8b 07                	mov    (%edi),%eax
80103591:	85 c0                	test   %eax,%eax
80103593:	74 0c                	je     801035a1 <pipealloc+0xe1>
    fileclose(*f1);
80103595:	83 ec 0c             	sub    $0xc,%esp
80103598:	50                   	push   %eax
80103599:	e8 a2 d9 ff ff       	call   80100f40 <fileclose>
8010359e:	83 c4 10             	add    $0x10,%esp
  return -1;
801035a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035a6:	eb cd                	jmp    80103575 <pipealloc+0xb5>
  if(*f0)
801035a8:	8b 06                	mov    (%esi),%eax
801035aa:	85 c0                	test   %eax,%eax
801035ac:	75 d5                	jne    80103583 <pipealloc+0xc3>
801035ae:	eb df                	jmp    8010358f <pipealloc+0xcf>

801035b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	56                   	push   %esi
801035b4:	53                   	push   %ebx
801035b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035bb:	83 ec 0c             	sub    $0xc,%esp
801035be:	53                   	push   %ebx
801035bf:	e8 ac 14 00 00       	call   80104a70 <acquire>
  if(writable){
801035c4:	83 c4 10             	add    $0x10,%esp
801035c7:	85 f6                	test   %esi,%esi
801035c9:	74 65                	je     80103630 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035db:	00 00 00 
    wakeup(&p->nread);
801035de:	50                   	push   %eax
801035df:	e8 bc 10 00 00       	call   801046a0 <wakeup>
801035e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ed:	85 d2                	test   %edx,%edx
801035ef:	75 0a                	jne    801035fb <pipeclose+0x4b>
801035f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	74 15                	je     80103610 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103601:	5b                   	pop    %ebx
80103602:	5e                   	pop    %esi
80103603:	5d                   	pop    %ebp
    release(&p->lock);
80103604:	e9 a7 15 00 00       	jmp    80104bb0 <release>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 97 15 00 00       	call   80104bb0 <release>
    kfree((char*)p);
80103619:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010361c:	83 c4 10             	add    $0x10,%esp
}
8010361f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103622:	5b                   	pop    %ebx
80103623:	5e                   	pop    %esi
80103624:	5d                   	pop    %ebp
    kfree((char*)p);
80103625:	e9 16 ef ff ff       	jmp    80102540 <kfree>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103639:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103640:	00 00 00 
    wakeup(&p->nwrite);
80103643:	50                   	push   %eax
80103644:	e8 57 10 00 00       	call   801046a0 <wakeup>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	eb 99                	jmp    801035e7 <pipeclose+0x37>
8010364e:	66 90                	xchg   %ax,%ax

80103650 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 28             	sub    $0x28,%esp
80103659:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010365c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010365f:	53                   	push   %ebx
80103660:	e8 0b 14 00 00       	call   80104a70 <acquire>
  for(i = 0; i < n; i++){
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	85 ff                	test   %edi,%edi
8010366a:	0f 8e ce 00 00 00    	jle    8010373e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103670:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103676:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103679:	89 7d 10             	mov    %edi,0x10(%ebp)
8010367c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010367f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103682:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103685:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010368b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103691:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103697:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010369d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801036a0:	0f 85 b6 00 00 00    	jne    8010375c <pipewrite+0x10c>
801036a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036a9:	eb 3b                	jmp    801036e6 <pipewrite+0x96>
801036ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036af:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801036b0:	e8 db 03 00 00       	call   80103a90 <myproc>
801036b5:	8b 48 24             	mov    0x24(%eax),%ecx
801036b8:	85 c9                	test   %ecx,%ecx
801036ba:	75 34                	jne    801036f0 <pipewrite+0xa0>
      wakeup(&p->nread);
801036bc:	83 ec 0c             	sub    $0xc,%esp
801036bf:	56                   	push   %esi
801036c0:	e8 db 0f 00 00       	call   801046a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036c5:	58                   	pop    %eax
801036c6:	5a                   	pop    %edx
801036c7:	53                   	push   %ebx
801036c8:	57                   	push   %edi
801036c9:	e8 12 0f 00 00       	call   801045e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ce:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036d4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	05 00 02 00 00       	add    $0x200,%eax
801036e2:	39 c2                	cmp    %eax,%edx
801036e4:	75 2a                	jne    80103710 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ec:	85 c0                	test   %eax,%eax
801036ee:	75 c0                	jne    801036b0 <pipewrite+0x60>
        release(&p->lock);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	53                   	push   %ebx
801036f4:	e8 b7 14 00 00       	call   80104bb0 <release>
        return -1;
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103701:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103704:	5b                   	pop    %ebx
80103705:	5e                   	pop    %esi
80103706:	5f                   	pop    %edi
80103707:	5d                   	pop    %ebp
80103708:	c3                   	ret
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103710:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103713:	8d 42 01             	lea    0x1(%edx),%eax
80103716:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010371c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010371f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103728:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010372c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103730:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103733:	39 c1                	cmp    %eax,%ecx
80103735:	0f 85 50 ff ff ff    	jne    8010368b <pipewrite+0x3b>
8010373b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103747:	50                   	push   %eax
80103748:	e8 53 0f 00 00       	call   801046a0 <wakeup>
  release(&p->lock);
8010374d:	89 1c 24             	mov    %ebx,(%esp)
80103750:	e8 5b 14 00 00       	call   80104bb0 <release>
  return n;
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	89 f8                	mov    %edi,%eax
8010375a:	eb a5                	jmp    80103701 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010375c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010375f:	eb b2                	jmp    80103713 <pipewrite+0xc3>
80103761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop

80103770 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	53                   	push   %ebx
80103776:	83 ec 18             	sub    $0x18,%esp
80103779:	8b 75 08             	mov    0x8(%ebp),%esi
8010377c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010377f:	56                   	push   %esi
80103780:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103786:	e8 e5 12 00 00       	call   80104a70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010378b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103791:	83 c4 10             	add    $0x10,%esp
80103794:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010379a:	74 2f                	je     801037cb <piperead+0x5b>
8010379c:	eb 37                	jmp    801037d5 <piperead+0x65>
8010379e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037a0:	e8 eb 02 00 00       	call   80103a90 <myproc>
801037a5:	8b 48 24             	mov    0x24(%eax),%ecx
801037a8:	85 c9                	test   %ecx,%ecx
801037aa:	0f 85 80 00 00 00    	jne    80103830 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037b0:	83 ec 08             	sub    $0x8,%esp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
801037b5:	e8 26 0e 00 00       	call   801045e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ba:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037c0:	83 c4 10             	add    $0x10,%esp
801037c3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037c9:	75 0a                	jne    801037d5 <piperead+0x65>
801037cb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037d1:	85 c0                	test   %eax,%eax
801037d3:	75 cb                	jne    801037a0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037d5:	8b 55 10             	mov    0x10(%ebp),%edx
801037d8:	31 db                	xor    %ebx,%ebx
801037da:	85 d2                	test   %edx,%edx
801037dc:	7f 20                	jg     801037fe <piperead+0x8e>
801037de:	eb 2c                	jmp    8010380c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037e0:	8d 48 01             	lea    0x1(%eax),%ecx
801037e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037f6:	83 c3 01             	add    $0x1,%ebx
801037f9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037fc:	74 0e                	je     8010380c <piperead+0x9c>
    if(p->nread == p->nwrite)
801037fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103804:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010380a:	75 d4                	jne    801037e0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010380c:	83 ec 0c             	sub    $0xc,%esp
8010380f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103815:	50                   	push   %eax
80103816:	e8 85 0e 00 00       	call   801046a0 <wakeup>
  release(&p->lock);
8010381b:	89 34 24             	mov    %esi,(%esp)
8010381e:	e8 8d 13 00 00       	call   80104bb0 <release>
  return i;
80103823:	83 c4 10             	add    $0x10,%esp
}
80103826:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103829:	89 d8                	mov    %ebx,%eax
8010382b:	5b                   	pop    %ebx
8010382c:	5e                   	pop    %esi
8010382d:	5f                   	pop    %edi
8010382e:	5d                   	pop    %ebp
8010382f:	c3                   	ret
      release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103833:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103838:	56                   	push   %esi
80103839:	e8 72 13 00 00       	call   80104bb0 <release>
      return -1;
8010383e:	83 c4 10             	add    $0x10,%esp
}
80103841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103844:	89 d8                	mov    %ebx,%eax
80103846:	5b                   	pop    %ebx
80103847:	5e                   	pop    %esi
80103848:	5f                   	pop    %edi
80103849:	5d                   	pop    %ebp
8010384a:	c3                   	ret
8010384b:	66 90                	xchg   %ax,%ax
8010384d:	66 90                	xchg   %ax,%ax
8010384f:	90                   	nop

80103850 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103854:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103859:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010385c:	68 40 2d 11 80       	push   $0x80112d40
80103861:	e8 0a 12 00 00       	call   80104a70 <acquire>
80103866:	83 c4 10             	add    $0x10,%esp
80103869:	eb 17                	jmp    80103882 <allocproc+0x32>
8010386b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010386f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103870:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103876:	81 fb 74 50 11 80    	cmp    $0x80115074,%ebx
8010387c:	0f 84 7e 00 00 00    	je     80103900 <allocproc+0xb0>
    if(p->state == UNUSED)
80103882:	8b 43 0c             	mov    0xc(%ebx),%eax
80103885:	85 c0                	test   %eax,%eax
80103887:	75 e7                	jne    80103870 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103889:	a1 14 b0 10 80       	mov    0x8010b014,%eax
  p->paused = 0; 

  release(&ptable.lock);
8010388e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103891:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->paused = 0; 
80103898:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010389f:	00 00 00 
  p->pid = nextpid++;
801038a2:	8d 50 01             	lea    0x1(%eax),%edx
801038a5:	89 43 10             	mov    %eax,0x10(%ebx)
801038a8:	89 15 14 b0 10 80    	mov    %edx,0x8010b014
  release(&ptable.lock);
801038ae:	68 40 2d 11 80       	push   $0x80112d40
801038b3:	e8 f8 12 00 00       	call   80104bb0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038b8:	e8 43 ee ff ff       	call   80102700 <kalloc>
801038bd:	83 c4 10             	add    $0x10,%esp
801038c0:	89 43 08             	mov    %eax,0x8(%ebx)
801038c3:	85 c0                	test   %eax,%eax
801038c5:	74 52                	je     80103919 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038c7:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038cd:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038d0:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038d5:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038d8:	c7 40 14 2f 5f 10 80 	movl   $0x80105f2f,0x14(%eax)
  p->context = (struct context*)sp;
801038df:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038e2:	6a 14                	push   $0x14
801038e4:	6a 00                	push   $0x0
801038e6:	50                   	push   %eax
801038e7:	e8 14 13 00 00       	call   80104c00 <memset>
  p->context->eip = (uint)forkret;
801038ec:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038ef:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038f2:	c7 40 10 30 39 10 80 	movl   $0x80103930,0x10(%eax)
}
801038f9:	89 d8                	mov    %ebx,%eax
801038fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038fe:	c9                   	leave
801038ff:	c3                   	ret
  release(&ptable.lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103903:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103905:	68 40 2d 11 80       	push   $0x80112d40
8010390a:	e8 a1 12 00 00       	call   80104bb0 <release>
  return 0;
8010390f:	83 c4 10             	add    $0x10,%esp
}
80103912:	89 d8                	mov    %ebx,%eax
80103914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103917:	c9                   	leave
80103918:	c3                   	ret
    p->state = UNUSED;
80103919:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103920:	31 db                	xor    %ebx,%ebx
80103922:	eb ee                	jmp    80103912 <allocproc+0xc2>
80103924:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop

80103930 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103936:	68 40 2d 11 80       	push   $0x80112d40
8010393b:	e8 70 12 00 00       	call   80104bb0 <release>

  if (first) {
80103940:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	85 c0                	test   %eax,%eax
8010394a:	75 04                	jne    80103950 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010394c:	c9                   	leave
8010394d:	c3                   	ret
8010394e:	66 90                	xchg   %ax,%ax
    first = 0;
80103950:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103957:	00 00 00 
    iinit(ROOTDEV);
8010395a:	83 ec 0c             	sub    $0xc,%esp
8010395d:	6a 01                	push   $0x1
8010395f:	e8 6c dc ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
80103964:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010396b:	e8 e0 f3 ff ff       	call   80102d50 <initlog>
}
80103970:	83 c4 10             	add    $0x10,%esp
80103973:	c9                   	leave
80103974:	c3                   	ret
80103975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103980 <print_sched_trace>:
{
80103980:	55                   	push   %ebp
  cprintf("[%s] PID:%d|PRT:%d", st ? "MLFQ" : "RR", p->pid, p->priority);
80103981:	b9 a0 7d 10 80       	mov    $0x80107da0,%ecx
{
80103986:	89 e5                	mov    %esp,%ebp
80103988:	83 ec 08             	sub    $0x8,%esp
  cprintf("[%s] PID:%d|PRT:%d", st ? "MLFQ" : "RR", p->pid, p->priority);
8010398b:	8b 45 0c             	mov    0xc(%ebp),%eax
{
8010398e:	8b 55 08             	mov    0x8(%ebp),%edx
  cprintf("[%s] PID:%d|PRT:%d", st ? "MLFQ" : "RR", p->pid, p->priority);
80103991:	85 c0                	test   %eax,%eax
80103993:	b8 a5 7d 10 80       	mov    $0x80107da5,%eax
80103998:	ff 72 7c             	push   0x7c(%edx)
8010399b:	0f 45 c1             	cmovne %ecx,%eax
8010399e:	ff 72 10             	push   0x10(%edx)
801039a1:	50                   	push   %eax
801039a2:	68 a8 7d 10 80       	push   $0x80107da8
801039a7:	e8 04 cd ff ff       	call   801006b0 <cprintf>
  sched_trace_counter++;
801039ac:	a1 2c 2d 11 80       	mov    0x80112d2c,%eax
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	83 c0 01             	add    $0x1,%eax
801039b7:	a3 2c 2d 11 80       	mov    %eax,0x80112d2c
801039bc:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
801039c2:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
  if (sched_trace_counter % 3 == 0)
801039c7:	3d 54 55 55 55       	cmp    $0x55555554,%eax
801039cc:	77 12                	ja     801039e0 <print_sched_trace+0x60>
    cprintf(" -> \n");
801039ce:	c7 45 08 bb 7d 10 80 	movl   $0x80107dbb,0x8(%ebp)
}
801039d5:	c9                   	leave
    cprintf(" -> \n");
801039d6:	e9 d5 cc ff ff       	jmp    801006b0 <cprintf>
801039db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop
    cprintf(" -> ");
801039e0:	c7 45 08 c1 7d 10 80 	movl   $0x80107dc1,0x8(%ebp)
}
801039e7:	c9                   	leave
    cprintf(" -> ");
801039e8:	e9 c3 cc ff ff       	jmp    801006b0 <cprintf>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi

801039f0 <pinit>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039f6:	68 c6 7d 10 80       	push   $0x80107dc6
801039fb:	68 40 2d 11 80       	push   $0x80112d40
80103a00:	e8 4b 0f 00 00       	call   80104950 <initlock>
}
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	c9                   	leave
80103a09:	c3                   	ret
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a10 <mycpu>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a15:	9c                   	pushf
80103a16:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a17:	f6 c4 02             	test   $0x2,%ah
80103a1a:	75 46                	jne    80103a62 <mycpu+0x52>
  apicid = lapicid();
80103a1c:	e8 5f ef ff ff       	call   80102980 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a21:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103a27:	85 f6                	test   %esi,%esi
80103a29:	7e 2a                	jle    80103a55 <mycpu+0x45>
80103a2b:	31 d2                	xor    %edx,%edx
80103a2d:	eb 08                	jmp    80103a37 <mycpu+0x27>
80103a2f:	90                   	nop
80103a30:	83 c2 01             	add    $0x1,%edx
80103a33:	39 f2                	cmp    %esi,%edx
80103a35:	74 1e                	je     80103a55 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a37:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a3d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103a44:	39 c3                	cmp    %eax,%ebx
80103a46:	75 e8                	jne    80103a30 <mycpu+0x20>
}
80103a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a4b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103a51:	5b                   	pop    %ebx
80103a52:	5e                   	pop    %esi
80103a53:	5d                   	pop    %ebp
80103a54:	c3                   	ret
  panic("unknown apicid\n");
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	68 cd 7d 10 80       	push   $0x80107dcd
80103a5d:	e8 1e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a62:	83 ec 0c             	sub    $0xc,%esp
80103a65:	68 a8 7e 10 80       	push   $0x80107ea8
80103a6a:	e8 11 c9 ff ff       	call   80100380 <panic>
80103a6f:	90                   	nop

80103a70 <cpuid>:
cpuid() {
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a76:	e8 95 ff ff ff       	call   80103a10 <mycpu>
}
80103a7b:	c9                   	leave
  return mycpu()-cpus;
80103a7c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a81:	c1 f8 04             	sar    $0x4,%eax
80103a84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a8a:	c3                   	ret
80103a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop

80103a90 <myproc>:
myproc(void) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a97:	e8 84 0f 00 00       	call   80104a20 <pushcli>
  c = mycpu();
80103a9c:	e8 6f ff ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103aa1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa7:	e8 a4 10 00 00       	call   80104b50 <popcli>
}
80103aac:	89 d8                	mov    %ebx,%eax
80103aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab1:	c9                   	leave
80103ab2:	c3                   	ret
80103ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ac0 <userinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ac7:	e8 84 fd ff ff       	call   80103850 <allocproc>
80103acc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ace:	a3 74 50 11 80       	mov    %eax,0x80115074
  if((p->pgdir = setupkvm()) == 0)
80103ad3:	e8 38 3a 00 00       	call   80107510 <setupkvm>
80103ad8:	89 43 04             	mov    %eax,0x4(%ebx)
80103adb:	85 c0                	test   %eax,%eax
80103add:	0f 84 bd 00 00 00    	je     80103ba0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ae3:	83 ec 04             	sub    $0x4,%esp
80103ae6:	68 2c 00 00 00       	push   $0x2c
80103aeb:	68 60 b4 10 80       	push   $0x8010b460
80103af0:	50                   	push   %eax
80103af1:	e8 fa 36 00 00       	call   801071f0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103af6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103af9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aff:	6a 4c                	push   $0x4c
80103b01:	6a 00                	push   $0x0
80103b03:	ff 73 18             	push   0x18(%ebx)
80103b06:	e8 f5 10 00 00       	call   80104c00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b26:	8b 43 18             	mov    0x18(%ebx),%eax
80103b29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b31:	8b 43 18             	mov    0x18(%ebx),%eax
80103b34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b50:	8b 43 18             	mov    0x18(%ebx),%eax
80103b53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b5d:	6a 10                	push   $0x10
80103b5f:	68 f6 7d 10 80       	push   $0x80107df6
80103b64:	50                   	push   %eax
80103b65:	e8 46 12 00 00       	call   80104db0 <safestrcpy>
  p->cwd = namei("/");
80103b6a:	c7 04 24 ff 7d 10 80 	movl   $0x80107dff,(%esp)
80103b71:	e8 aa e5 ff ff       	call   80102120 <namei>
80103b76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b79:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b80:	e8 eb 0e 00 00       	call   80104a70 <acquire>
  p->state = RUNNABLE;
80103b85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b8c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b93:	e8 18 10 00 00       	call   80104bb0 <release>
}
80103b98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b9b:	83 c4 10             	add    $0x10,%esp
80103b9e:	c9                   	leave
80103b9f:	c3                   	ret
    panic("userinit: out of memory?");
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 dd 7d 10 80       	push   $0x80107ddd
80103ba8:	e8 d3 c7 ff ff       	call   80100380 <panic>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi

80103bb0 <growproc>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bb8:	e8 63 0e 00 00       	call   80104a20 <pushcli>
  c = mycpu();
80103bbd:	e8 4e fe ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103bc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bc8:	e8 83 0f 00 00       	call   80104b50 <popcli>
  sz = curproc->sz;
80103bcd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bcf:	85 f6                	test   %esi,%esi
80103bd1:	7f 1d                	jg     80103bf0 <growproc+0x40>
  } else if(n < 0){
80103bd3:	75 3b                	jne    80103c10 <growproc+0x60>
  switchuvm(curproc);
80103bd5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bd8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bda:	53                   	push   %ebx
80103bdb:	e8 00 35 00 00       	call   801070e0 <switchuvm>
  return 0;
80103be0:	83 c4 10             	add    $0x10,%esp
80103be3:	31 c0                	xor    %eax,%eax
}
80103be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be8:	5b                   	pop    %ebx
80103be9:	5e                   	pop    %esi
80103bea:	5d                   	pop    %ebp
80103beb:	c3                   	ret
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bf0:	83 ec 04             	sub    $0x4,%esp
80103bf3:	01 c6                	add    %eax,%esi
80103bf5:	56                   	push   %esi
80103bf6:	50                   	push   %eax
80103bf7:	ff 73 04             	push   0x4(%ebx)
80103bfa:	e8 41 37 00 00       	call   80107340 <allocuvm>
80103bff:	83 c4 10             	add    $0x10,%esp
80103c02:	85 c0                	test   %eax,%eax
80103c04:	75 cf                	jne    80103bd5 <growproc+0x25>
      return -1;
80103c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c0b:	eb d8                	jmp    80103be5 <growproc+0x35>
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	push   0x4(%ebx)
80103c1a:	e8 41 38 00 00       	call   80107460 <deallocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 af                	jne    80103bd5 <growproc+0x25>
80103c26:	eb de                	jmp    80103c06 <growproc+0x56>
80103c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop

80103c30 <scheduling_logic_rr>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c36:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103c3b:	83 ec 28             	sub    $0x28,%esp
80103c3e:	8b 75 08             	mov    0x8(%ebp),%esi
  c->proc = 0;
80103c41:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c48:	00 00 00 
    swtch(&(c->scheduler), p->context);
80103c4b:	8d 7e 04             	lea    0x4(%esi),%edi
  acquire(&ptable.lock);
80103c4e:	68 40 2d 11 80       	push   $0x80112d40
80103c53:	e8 18 0e 00 00       	call   80104a70 <acquire>
80103c58:	83 c4 10             	add    $0x10,%esp
  ran = 0;
80103c5b:	31 c0                	xor    %eax,%eax
80103c5d:	eb 47                	jmp    80103ca6 <scheduling_logic_rr+0x76>
80103c5f:	90                   	nop
    switchuvm(p);
80103c60:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80103c63:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
    switchuvm(p);
80103c69:	53                   	push   %ebx
80103c6a:	e8 71 34 00 00       	call   801070e0 <switchuvm>
    p->state = RUNNING;
80103c6f:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    swtch(&(c->scheduler), p->context);
80103c76:	58                   	pop    %eax
80103c77:	5a                   	pop    %edx
80103c78:	ff 73 1c             	push   0x1c(%ebx)
80103c7b:	57                   	push   %edi
80103c7c:	e8 8a 11 00 00       	call   80104e0b <swtch>
    switchkvm();
80103c81:	e8 4a 34 00 00       	call   801070d0 <switchkvm>
    c->proc = 0;
80103c86:	83 c4 10             	add    $0x10,%esp
    ran = 1;
80103c89:	b8 01 00 00 00       	mov    $0x1,%eax
    c->proc = 0;
80103c8e:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c95:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c98:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103c9e:	81 fb 74 50 11 80    	cmp    $0x80115074,%ebx
80103ca4:	74 7a                	je     80103d20 <scheduling_logic_rr+0xf0>
    if(p->state != RUNNABLE)
80103ca6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103caa:	75 ec                	jne    80103c98 <scheduling_logic_rr+0x68>
    if (sched_trace_enabled)
80103cac:	8b 0d 30 2d 11 80    	mov    0x80112d30,%ecx
80103cb2:	85 c9                	test   %ecx,%ecx
80103cb4:	74 aa                	je     80103c60 <scheduling_logic_rr+0x30>
  cprintf("[%s] PID:%d|PRT:%d", st ? "MLFQ" : "RR", p->pid, p->priority);
80103cb6:	ff 73 7c             	push   0x7c(%ebx)
80103cb9:	ff 73 10             	push   0x10(%ebx)
80103cbc:	68 a5 7d 10 80       	push   $0x80107da5
80103cc1:	68 a8 7d 10 80       	push   $0x80107da8
80103cc6:	e8 e5 c9 ff ff       	call   801006b0 <cprintf>
  sched_trace_counter++;
80103ccb:	a1 2c 2d 11 80       	mov    0x80112d2c,%eax
80103cd0:	83 c4 10             	add    $0x10,%esp
80103cd3:	83 c0 01             	add    $0x1,%eax
80103cd6:	a3 2c 2d 11 80       	mov    %eax,0x80112d2c
80103cdb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
80103ce1:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
  if (sched_trace_counter % 3 == 0)
80103ce6:	3d 54 55 55 55       	cmp    $0x55555554,%eax
80103ceb:	77 1b                	ja     80103d08 <scheduling_logic_rr+0xd8>
    cprintf(" -> \n");
80103ced:	83 ec 0c             	sub    $0xc,%esp
80103cf0:	68 bb 7d 10 80       	push   $0x80107dbb
80103cf5:	e8 b6 c9 ff ff       	call   801006b0 <cprintf>
}
80103cfa:	83 c4 10             	add    $0x10,%esp
80103cfd:	e9 5e ff ff ff       	jmp    80103c60 <scheduling_logic_rr+0x30>
80103d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" -> ");
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	68 c1 7d 10 80       	push   $0x80107dc1
80103d10:	e8 9b c9 ff ff       	call   801006b0 <cprintf>
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	e9 43 ff ff ff       	jmp    80103c60 <scheduling_logic_rr+0x30>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103d20:	83 ec 0c             	sub    $0xc,%esp
80103d23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d26:	68 40 2d 11 80       	push   $0x80112d40
80103d2b:	e8 80 0e 00 00       	call   80104bb0 <release>
  if (ran == 0){
80103d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	85 c0                	test   %eax,%eax
80103d38:	75 01                	jne    80103d3b <scheduling_logic_rr+0x10b>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103d3a:	f4                   	hlt
}
80103d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3e:	5b                   	pop    %ebx
80103d3f:	5e                   	pop    %esi
80103d40:	5f                   	pop    %edi
80103d41:	5d                   	pop    %ebp
80103d42:	c3                   	ret
80103d43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d50 <scheduling_logic_mlfq>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
  acquire(&ptable.lock);
80103d55:	be 03 00 00 00       	mov    $0x3,%esi
{
80103d5a:	53                   	push   %ebx
80103d5b:	83 ec 28             	sub    $0x28,%esp
80103d5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  c->proc = 0;
80103d61:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d68:	00 00 00 
  acquire(&ptable.lock);
80103d6b:	68 40 2d 11 80       	push   $0x80112d40
80103d70:	e8 fb 0c 00 00       	call   80104a70 <acquire>
80103d75:	83 c4 10             	add    $0x10,%esp
      swtch(&(c->scheduler), p->context);
80103d78:	8d 53 04             	lea    0x4(%ebx),%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d7b:	31 c0                	xor    %eax,%eax
80103d7d:	bf 74 2d 11 80       	mov    $0x80112d74,%edi
      swtch(&(c->scheduler), p->context);
80103d82:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103d85:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE || p->priority != priority)
80103d88:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103d8c:	0f 85 9e 00 00 00    	jne    80103e30 <scheduling_logic_mlfq+0xe0>
80103d92:	39 77 7c             	cmp    %esi,0x7c(%edi)
80103d95:	0f 85 95 00 00 00    	jne    80103e30 <scheduling_logic_mlfq+0xe0>
      if (sched_trace_enabled)
80103d9b:	8b 0d 30 2d 11 80    	mov    0x80112d30,%ecx
80103da1:	85 c9                	test   %ecx,%ecx
80103da3:	0f 85 0f 01 00 00    	jne    80103eb8 <scheduling_logic_mlfq+0x168>
      switchuvm(p);
80103da9:	83 ec 0c             	sub    $0xc,%esp
      p->sched_count++; 
80103dac:	83 87 80 00 00 00 01 	addl   $0x1,0x80(%edi)
      c->proc = p;
80103db3:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103db9:	57                   	push   %edi
80103dba:	e8 21 33 00 00       	call   801070e0 <switchuvm>
      p->state = RUNNING;
80103dbf:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103dc6:	58                   	pop    %eax
80103dc7:	5a                   	pop    %edx
80103dc8:	ff 77 1c             	push   0x1c(%edi)
80103dcb:	ff 75 e4             	push   -0x1c(%ebp)
80103dce:	e8 38 10 00 00       	call   80104e0b <swtch>
      switchkvm();
80103dd3:	e8 f8 32 00 00       	call   801070d0 <switchkvm>
      if((priority == 3 && p->sched_count >= thirdPriorityAllotment) || (priority == 2 && p->sched_count >= secondPriorityAllotment)) {
80103dd8:	83 c4 10             	add    $0x10,%esp
80103ddb:	83 fe 03             	cmp    $0x3,%esi
80103dde:	0f 84 8c 00 00 00    	je     80103e70 <scheduling_logic_mlfq+0x120>
80103de4:	83 fe 02             	cmp    $0x2,%esi
80103de7:	0f 84 1b 01 00 00    	je     80103f08 <scheduling_logic_mlfq+0x1b8>
      c->proc = 0;
80103ded:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103df4:	00 00 00 
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103df7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103dfc:	eb 12                	jmp    80103e10 <scheduling_logic_mlfq+0xc0>
80103dfe:	66 90                	xchg   %ax,%ax
80103e00:	05 8c 00 00 00       	add    $0x8c,%eax
80103e05:	3d 74 50 11 80       	cmp    $0x80115074,%eax
80103e0a:	0f 84 85 00 00 00    	je     80103e95 <scheduling_logic_mlfq+0x145>
            if(p->state == RUNNABLE && p->priority == 3) {
80103e10:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e14:	75 ea                	jne    80103e00 <scheduling_logic_mlfq+0xb0>
80103e16:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
80103e1a:	75 e4                	jne    80103e00 <scheduling_logic_mlfq+0xb0>
  release(&ptable.lock);
80103e1c:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80103e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e26:	5b                   	pop    %ebx
80103e27:	5e                   	pop    %esi
80103e28:	5f                   	pop    %edi
80103e29:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e2a:	e9 81 0d 00 00       	jmp    80104bb0 <release>
80103e2f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e30:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80103e36:	81 ff 74 50 11 80    	cmp    $0x80115074,%edi
80103e3c:	0f 85 46 ff ff ff    	jne    80103d88 <scheduling_logic_mlfq+0x38>
    if(ran) break;
80103e42:	85 c0                	test   %eax,%eax
80103e44:	75 d6                	jne    80103e1c <scheduling_logic_mlfq+0xcc>
  for(int priority = max_priority; priority >= 1; priority--)
80103e46:	83 ee 01             	sub    $0x1,%esi
80103e49:	0f 85 29 ff ff ff    	jne    80103d78 <scheduling_logic_mlfq+0x28>
  release(&ptable.lock);
80103e4f:	83 ec 0c             	sub    $0xc,%esp
80103e52:	68 40 2d 11 80       	push   $0x80112d40
80103e57:	e8 54 0d 00 00       	call   80104bb0 <release>
80103e5c:	f4                   	hlt
}
80103e5d:	83 c4 10             	add    $0x10,%esp
}
80103e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e63:	5b                   	pop    %ebx
80103e64:	5e                   	pop    %esi
80103e65:	5f                   	pop    %edi
80103e66:	5d                   	pop    %ebp
80103e67:	c3                   	ret
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop
      if((priority == 3 && p->sched_count >= thirdPriorityAllotment) || (priority == 2 && p->sched_count >= secondPriorityAllotment)) {
80103e70:	a1 1c b0 10 80       	mov    0x8010b01c,%eax
80103e75:	39 87 80 00 00 00    	cmp    %eax,0x80(%edi)
80103e7b:	7c 0e                	jl     80103e8b <scheduling_logic_mlfq+0x13b>
        p->priority--; 
80103e7d:	83 6f 7c 01          	subl   $0x1,0x7c(%edi)
        p->sched_count = 0; 
80103e81:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
80103e88:	00 00 00 
      c->proc = 0;
80103e8b:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103e92:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e95:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80103e9b:	81 ff 74 50 11 80    	cmp    $0x80115074,%edi
80103ea1:	0f 84 75 ff ff ff    	je     80103e1c <scheduling_logic_mlfq+0xcc>
80103ea7:	b8 01 00 00 00       	mov    $0x1,%eax
80103eac:	e9 d7 fe ff ff       	jmp    80103d88 <scheduling_logic_mlfq+0x38>
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cprintf("[%s] PID:%d|PRT:%d", st ? "MLFQ" : "RR", p->pid, p->priority);
80103eb8:	56                   	push   %esi
80103eb9:	ff 77 10             	push   0x10(%edi)
80103ebc:	68 a0 7d 10 80       	push   $0x80107da0
80103ec1:	68 a8 7d 10 80       	push   $0x80107da8
80103ec6:	e8 e5 c7 ff ff       	call   801006b0 <cprintf>
  sched_trace_counter++;
80103ecb:	a1 2c 2d 11 80       	mov    0x80112d2c,%eax
80103ed0:	83 c4 10             	add    $0x10,%esp
80103ed3:	83 c0 01             	add    $0x1,%eax
80103ed6:	a3 2c 2d 11 80       	mov    %eax,0x80112d2c
80103edb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
80103ee1:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
  if (sched_trace_counter % 3 == 0)
80103ee6:	3d 54 55 55 55       	cmp    $0x55555554,%eax
80103eeb:	77 3f                	ja     80103f2c <scheduling_logic_mlfq+0x1dc>
    cprintf(" -> \n");
80103eed:	83 ec 0c             	sub    $0xc,%esp
80103ef0:	68 bb 7d 10 80       	push   $0x80107dbb
80103ef5:	e8 b6 c7 ff ff       	call   801006b0 <cprintf>
}
80103efa:	83 c4 10             	add    $0x10,%esp
80103efd:	e9 a7 fe ff ff       	jmp    80103da9 <scheduling_logic_mlfq+0x59>
80103f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if((priority == 3 && p->sched_count >= thirdPriorityAllotment) || (priority == 2 && p->sched_count >= secondPriorityAllotment)) {
80103f08:	a1 18 b0 10 80       	mov    0x8010b018,%eax
80103f0d:	39 87 80 00 00 00    	cmp    %eax,0x80(%edi)
80103f13:	0f 8c d4 fe ff ff    	jl     80103ded <scheduling_logic_mlfq+0x9d>
        p->priority--; 
80103f19:	83 6f 7c 01          	subl   $0x1,0x7c(%edi)
        p->sched_count = 0; 
80103f1d:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
80103f24:	00 00 00 
      if(priority!=3) {
80103f27:	e9 c1 fe ff ff       	jmp    80103ded <scheduling_logic_mlfq+0x9d>
    cprintf(" -> ");
80103f2c:	83 ec 0c             	sub    $0xc,%esp
80103f2f:	68 c1 7d 10 80       	push   $0x80107dc1
80103f34:	e8 77 c7 ff ff       	call   801006b0 <cprintf>
80103f39:	83 c4 10             	add    $0x10,%esp
80103f3c:	e9 68 fe ff ff       	jmp    80103da9 <scheduling_logic_mlfq+0x59>
80103f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4f:	90                   	nop

80103f50 <scheduler>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c = mycpu();
80103f57:	e8 b4 fa ff ff       	call   80103a10 <mycpu>
80103f5c:	89 c3                	mov    %eax,%ebx
80103f5e:	66 90                	xchg   %ax,%ax
  asm volatile("sti");
80103f60:	fb                   	sti
    if (SCHEDULER_DEFAULT == scheduler_type)
80103f61:	a1 28 2d 11 80       	mov    0x80112d28,%eax
80103f66:	85 c0                	test   %eax,%eax
80103f68:	75 16                	jne    80103f80 <scheduler+0x30>
      scheduling_logic_rr(c);
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	53                   	push   %ebx
80103f6e:	e8 bd fc ff ff       	call   80103c30 <scheduling_logic_rr>
80103f73:	83 c4 10             	add    $0x10,%esp
80103f76:	eb e8                	jmp    80103f60 <scheduler+0x10>
80103f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7f:	90                   	nop
      scheduling_logic_mlfq(c);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	53                   	push   %ebx
80103f84:	e8 c7 fd ff ff       	call   80103d50 <scheduling_logic_mlfq>
80103f89:	83 c4 10             	add    $0x10,%esp
80103f8c:	eb d2                	jmp    80103f60 <scheduler+0x10>
80103f8e:	66 90                	xchg   %ax,%ax

80103f90 <sched>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  pushcli();
80103f95:	e8 86 0a 00 00       	call   80104a20 <pushcli>
  c = mycpu();
80103f9a:	e8 71 fa ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80103f9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fa5:	e8 a6 0b 00 00       	call   80104b50 <popcli>
  if(!holding(&ptable.lock))
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 40 2d 11 80       	push   $0x80112d40
80103fb2:	e8 29 0a 00 00       	call   801049e0 <holding>
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	85 c0                	test   %eax,%eax
80103fbc:	74 7f                	je     8010403d <sched+0xad>
  if(mycpu()->ncli != 1)
80103fbe:	e8 4d fa ff ff       	call   80103a10 <mycpu>
80103fc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fca:	75 64                	jne    80104030 <sched+0xa0>
  if(p->state == RUNNING)
80103fcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fd0:	74 51                	je     80104023 <sched+0x93>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fd2:	9c                   	pushf
80103fd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fd4:	f6 c4 02             	test   $0x2,%ah
80103fd7:	75 3d                	jne    80104016 <sched+0x86>
  if (pause_sched) {
80103fd9:	a1 20 2d 11 80       	mov    0x80112d20,%eax
80103fde:	85 c0                	test   %eax,%eax
80103fe0:	75 2d                	jne    8010400f <sched+0x7f>
  intena = mycpu()->intena;
80103fe2:	e8 29 fa ff ff       	call   80103a10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fe7:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fea:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ff0:	e8 1b fa ff ff       	call   80103a10 <mycpu>
80103ff5:	83 ec 08             	sub    $0x8,%esp
80103ff8:	ff 70 04             	push   0x4(%eax)
80103ffb:	53                   	push   %ebx
80103ffc:	e8 0a 0e 00 00       	call   80104e0b <swtch>
  mycpu()->intena = intena;
80104001:	e8 0a fa ff ff       	call   80103a10 <mycpu>
80104006:	83 c4 10             	add    $0x10,%esp
80104009:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010400f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104012:	5b                   	pop    %ebx
80104013:	5e                   	pop    %esi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret
    panic("sched interruptible");
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	68 2d 7e 10 80       	push   $0x80107e2d
8010401e:	e8 5d c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	68 1f 7e 10 80       	push   $0x80107e1f
8010402b:	e8 50 c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	68 13 7e 10 80       	push   $0x80107e13
80104038:	e8 43 c3 ff ff       	call   80100380 <panic>
    panic("sched ptable.lock");
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	68 01 7e 10 80       	push   $0x80107e01
80104045:	e8 36 c3 ff ff       	call   80100380 <panic>
8010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104050 <exit>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104059:	e8 32 fa ff ff       	call   80103a90 <myproc>
  if(curproc == initproc)
8010405e:	39 05 74 50 11 80    	cmp    %eax,0x80115074
80104064:	0f 84 07 01 00 00    	je     80104171 <exit+0x121>
8010406a:	89 c3                	mov    %eax,%ebx
8010406c:	8d 70 28             	lea    0x28(%eax),%esi
8010406f:	8d 78 68             	lea    0x68(%eax),%edi
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104078:	8b 06                	mov    (%esi),%eax
8010407a:	85 c0                	test   %eax,%eax
8010407c:	74 12                	je     80104090 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	50                   	push   %eax
80104082:	e8 b9 ce ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80104087:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010408d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104090:	83 c6 04             	add    $0x4,%esi
80104093:	39 f7                	cmp    %esi,%edi
80104095:	75 e1                	jne    80104078 <exit+0x28>
  begin_op();
80104097:	e8 54 ed ff ff       	call   80102df0 <begin_op>
  iput(curproc->cwd);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 73 68             	push   0x68(%ebx)
801040a2:	e8 79 d8 ff ff       	call   80101920 <iput>
  end_op();
801040a7:	e8 b4 ed ff ff       	call   80102e60 <end_op>
  curproc->cwd = 0;
801040ac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040b3:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801040ba:	e8 b1 09 00 00       	call   80104a70 <acquire>
  wakeup1(curproc->parent);
801040bf:	8b 53 14             	mov    0x14(%ebx),%edx
801040c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c5:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040ca:	eb 10                	jmp    801040dc <exit+0x8c>
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d0:	05 8c 00 00 00       	add    $0x8c,%eax
801040d5:	3d 74 50 11 80       	cmp    $0x80115074,%eax
801040da:	74 1e                	je     801040fa <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
801040dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040e0:	75 ee                	jne    801040d0 <exit+0x80>
801040e2:	3b 50 20             	cmp    0x20(%eax),%edx
801040e5:	75 e9                	jne    801040d0 <exit+0x80>
      p->state = RUNNABLE;
801040e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ee:	05 8c 00 00 00       	add    $0x8c,%eax
801040f3:	3d 74 50 11 80       	cmp    $0x80115074,%eax
801040f8:	75 e2                	jne    801040dc <exit+0x8c>
      p->parent = initproc;
801040fa:	8b 0d 74 50 11 80    	mov    0x80115074,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104100:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80104105:	eb 17                	jmp    8010411e <exit+0xce>
80104107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410e:	66 90                	xchg   %ax,%ax
80104110:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80104116:	81 fa 74 50 11 80    	cmp    $0x80115074,%edx
8010411c:	74 3a                	je     80104158 <exit+0x108>
    if(p->parent == curproc){
8010411e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104121:	75 ed                	jne    80104110 <exit+0xc0>
      if(p->state == ZOMBIE)
80104123:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104127:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010412a:	75 e4                	jne    80104110 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412c:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104131:	eb 11                	jmp    80104144 <exit+0xf4>
80104133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104137:	90                   	nop
80104138:	05 8c 00 00 00       	add    $0x8c,%eax
8010413d:	3d 74 50 11 80       	cmp    $0x80115074,%eax
80104142:	74 cc                	je     80104110 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104144:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104148:	75 ee                	jne    80104138 <exit+0xe8>
8010414a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010414d:	75 e9                	jne    80104138 <exit+0xe8>
      p->state = RUNNABLE;
8010414f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104156:	eb e0                	jmp    80104138 <exit+0xe8>
  curproc->state = ZOMBIE;
80104158:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010415f:	e8 2c fe ff ff       	call   80103f90 <sched>
  panic("zombie exit");
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 4e 7e 10 80       	push   $0x80107e4e
8010416c:	e8 0f c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	68 41 7e 10 80       	push   $0x80107e41
80104179:	e8 02 c2 ff ff       	call   80100380 <panic>
8010417e:	66 90                	xchg   %ax,%ax

80104180 <wait>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
  pushcli();
80104185:	e8 96 08 00 00       	call   80104a20 <pushcli>
  c = mycpu();
8010418a:	e8 81 f8 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
8010418f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104195:	e8 b6 09 00 00       	call   80104b50 <popcli>
  acquire(&ptable.lock);
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 40 2d 11 80       	push   $0x80112d40
801041a2:	e8 c9 08 00 00       	call   80104a70 <acquire>
801041a7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041aa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ac:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
801041b1:	eb 13                	jmp    801041c6 <wait+0x46>
801041b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b7:	90                   	nop
801041b8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801041be:	81 fb 74 50 11 80    	cmp    $0x80115074,%ebx
801041c4:	74 1e                	je     801041e4 <wait+0x64>
      if(p->parent != curproc)
801041c6:	39 73 14             	cmp    %esi,0x14(%ebx)
801041c9:	75 ed                	jne    801041b8 <wait+0x38>
      if(p->state == ZOMBIE){
801041cb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041cf:	74 5f                	je     80104230 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
801041d7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	81 fb 74 50 11 80    	cmp    $0x80115074,%ebx
801041e2:	75 e2                	jne    801041c6 <wait+0x46>
    if(!havekids || curproc->killed){
801041e4:	85 c0                	test   %eax,%eax
801041e6:	0f 84 9a 00 00 00    	je     80104286 <wait+0x106>
801041ec:	8b 46 24             	mov    0x24(%esi),%eax
801041ef:	85 c0                	test   %eax,%eax
801041f1:	0f 85 8f 00 00 00    	jne    80104286 <wait+0x106>
  pushcli();
801041f7:	e8 24 08 00 00       	call   80104a20 <pushcli>
  c = mycpu();
801041fc:	e8 0f f8 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
80104201:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104207:	e8 44 09 00 00       	call   80104b50 <popcli>
  if(p == 0)
8010420c:	85 db                	test   %ebx,%ebx
8010420e:	0f 84 89 00 00 00    	je     8010429d <wait+0x11d>
  p->chan = chan;
80104214:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104217:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010421e:	e8 6d fd ff ff       	call   80103f90 <sched>
  p->chan = 0;
80104223:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010422a:	e9 7b ff ff ff       	jmp    801041aa <wait+0x2a>
8010422f:	90                   	nop
        kfree(p->kstack);
80104230:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104233:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104236:	ff 73 08             	push   0x8(%ebx)
80104239:	e8 02 e3 ff ff       	call   80102540 <kfree>
        p->kstack = 0;
8010423e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104245:	5a                   	pop    %edx
80104246:	ff 73 04             	push   0x4(%ebx)
80104249:	e8 42 32 00 00       	call   80107490 <freevm>
        p->pid = 0;
8010424e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104255:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010425c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104260:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104267:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010426e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104275:	e8 36 09 00 00       	call   80104bb0 <release>
        return pid;
8010427a:	83 c4 10             	add    $0x10,%esp
}
8010427d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104280:	89 f0                	mov    %esi,%eax
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret
      release(&ptable.lock);
80104286:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104289:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010428e:	68 40 2d 11 80       	push   $0x80112d40
80104293:	e8 18 09 00 00       	call   80104bb0 <release>
      return -1;
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	eb e0                	jmp    8010427d <wait+0xfd>
    panic("sleep");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 5a 7e 10 80       	push   $0x80107e5a
801042a5:	e8 d6 c0 ff ff       	call   80100380 <panic>
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042b0 <fork>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	57                   	push   %edi
801042b4:	56                   	push   %esi
801042b5:	53                   	push   %ebx
801042b6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042b9:	e8 62 07 00 00       	call   80104a20 <pushcli>
  c = mycpu();
801042be:	e8 4d f7 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
801042c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c9:	e8 82 08 00 00       	call   80104b50 <popcli>
  if((np = allocproc()) == 0){
801042ce:	e8 7d f5 ff ff       	call   80103850 <allocproc>
801042d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042d6:	85 c0                	test   %eax,%eax
801042d8:	0f 84 28 01 00 00    	je     80104406 <fork+0x156>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801042de:	83 ec 08             	sub    $0x8,%esp
801042e1:	ff 33                	push   (%ebx)
801042e3:	89 c7                	mov    %eax,%edi
801042e5:	ff 73 04             	push   0x4(%ebx)
801042e8:	e8 13 33 00 00       	call   80107600 <copyuvm>
801042ed:	83 c4 10             	add    $0x10,%esp
801042f0:	89 47 04             	mov    %eax,0x4(%edi)
801042f3:	85 c0                	test   %eax,%eax
801042f5:	0f 84 ec 00 00 00    	je     801043e7 <fork+0x137>
  np->sz = curproc->sz;
801042fb:	8b 03                	mov    (%ebx),%eax
801042fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104300:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104302:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104305:	89 c8                	mov    %ecx,%eax
80104307:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010430a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010430f:	8b 73 18             	mov    0x18(%ebx),%esi
80104312:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104314:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104316:	8b 40 18             	mov    0x18(%eax),%eax
80104319:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104320:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104324:	85 c0                	test   %eax,%eax
80104326:	74 13                	je     8010433b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	50                   	push   %eax
8010432c:	e8 bf cb ff ff       	call   80100ef0 <filedup>
80104331:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104334:	83 c4 10             	add    $0x10,%esp
80104337:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010433b:	83 c6 01             	add    $0x1,%esi
8010433e:	83 fe 10             	cmp    $0x10,%esi
80104341:	75 dd                	jne    80104320 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104349:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010434c:	e8 6f d4 ff ff       	call   801017c0 <idup>
80104351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104354:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104357:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010435a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010435d:	6a 10                	push   $0x10
8010435f:	53                   	push   %ebx
80104360:	50                   	push   %eax
80104361:	e8 4a 0a 00 00       	call   80104db0 <safestrcpy>
  pid = np->pid;
80104366:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104369:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104370:	e8 fb 06 00 00       	call   80104a70 <acquire>
  np->state = RUNNABLE;
80104375:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010437c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104383:	e8 28 08 00 00       	call   80104bb0 <release>
  if(child_first==1){
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	83 3d 24 2d 11 80 01 	cmpl   $0x1,0x80112d24
80104392:	74 0c                	je     801043a0 <fork+0xf0>
}
80104394:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104397:	89 d8                	mov    %ebx,%eax
80104399:	5b                   	pop    %ebx
8010439a:	5e                   	pop    %esi
8010439b:	5f                   	pop    %edi
8010439c:	5d                   	pop    %ebp
8010439d:	c3                   	ret
8010439e:	66 90                	xchg   %ax,%ax
  acquire(&ptable.lock);  //DOC: yieldlock
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 40 2d 11 80       	push   $0x80112d40
801043a8:	e8 c3 06 00 00       	call   80104a70 <acquire>
  pushcli();
801043ad:	e8 6e 06 00 00       	call   80104a20 <pushcli>
  c = mycpu();
801043b2:	e8 59 f6 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
801043b7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043bd:	e8 8e 07 00 00       	call   80104b50 <popcli>
  myproc()->state = RUNNABLE;
801043c2:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  sched();
801043c9:	e8 c2 fb ff ff       	call   80103f90 <sched>
  release(&ptable.lock);
801043ce:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801043d5:	e8 d6 07 00 00       	call   80104bb0 <release>
}
801043da:	83 c4 10             	add    $0x10,%esp
}
801043dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e0:	89 d8                	mov    %ebx,%eax
801043e2:	5b                   	pop    %ebx
801043e3:	5e                   	pop    %esi
801043e4:	5f                   	pop    %edi
801043e5:	5d                   	pop    %ebp
801043e6:	c3                   	ret
    kfree(np->kstack);
801043e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801043ea:	83 ec 0c             	sub    $0xc,%esp
801043ed:	ff 73 08             	push   0x8(%ebx)
801043f0:	e8 4b e1 ff ff       	call   80102540 <kfree>
    np->kstack = 0;
801043f5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801043fc:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801043ff:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104406:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010440b:	eb 87                	jmp    80104394 <fork+0xe4>
8010440d:	8d 76 00             	lea    0x0(%esi),%esi

80104410 <schedSet>:
void schedSet(void){
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80104416:	68 40 2d 11 80       	push   $0x80112d40
8010441b:	e8 50 06 00 00       	call   80104a70 <acquire>
        p->allotted_ticks = allotments[MLFQ_PRIORITY_MAX];
80104420:	8b 15 10 b0 10 80    	mov    0x8010b010,%edx
80104426:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104429:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010442e:	66 90                	xchg   %ax,%ax
      if(p->state != UNUSED) {
80104430:	8b 48 0c             	mov    0xc(%eax),%ecx
80104433:	85 c9                	test   %ecx,%ecx
80104435:	74 0d                	je     80104444 <schedSet+0x34>
        p->priority = MLFQ_PRIORITY_MAX;
80104437:	c7 40 7c 03 00 00 00 	movl   $0x3,0x7c(%eax)
        p->allotted_ticks = allotments[MLFQ_PRIORITY_MAX];
8010443e:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104444:	05 8c 00 00 00       	add    $0x8c,%eax
80104449:	3d 74 50 11 80       	cmp    $0x80115074,%eax
8010444e:	75 e0                	jne    80104430 <schedSet+0x20>
    release(&ptable.lock);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	68 40 2d 11 80       	push   $0x80112d40
80104458:	e8 53 07 00 00       	call   80104bb0 <release>
}
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	c9                   	leave
80104461:	c3                   	ret
80104462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <set_all_processes_to_highest_priority>:
void set_all_processes_to_highest_priority() {
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);
80104476:	68 40 2d 11 80       	push   $0x80112d40
8010447b:	e8 f0 05 00 00       	call   80104a70 <acquire>
            p->allotted_ticks = allotments[MLFQ_PRIORITY_MAX];
80104480:	8b 0d 10 b0 10 80    	mov    0x8010b010,%ecx
80104486:	83 c4 10             	add    $0x10,%esp
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104489:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010448e:	66 90                	xchg   %ax,%ax
        if(p->state == RUNNABLE || p->state == RUNNING) {
80104490:	8b 50 0c             	mov    0xc(%eax),%edx
80104493:	83 ea 03             	sub    $0x3,%edx
80104496:	83 fa 01             	cmp    $0x1,%edx
80104499:	77 0d                	ja     801044a8 <set_all_processes_to_highest_priority+0x38>
            p->priority = MLFQ_PRIORITY_MAX;
8010449b:	c7 40 7c 03 00 00 00 	movl   $0x3,0x7c(%eax)
            p->allotted_ticks = allotments[MLFQ_PRIORITY_MAX];
801044a2:	89 88 88 00 00 00    	mov    %ecx,0x88(%eax)
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044a8:	05 8c 00 00 00       	add    $0x8c,%eax
801044ad:	3d 74 50 11 80       	cmp    $0x80115074,%eax
801044b2:	75 dc                	jne    80104490 <set_all_processes_to_highest_priority+0x20>
    release(&ptable.lock);
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	68 40 2d 11 80       	push   $0x80112d40
801044bc:	e8 ef 06 00 00       	call   80104bb0 <release>
}
801044c1:	83 c4 10             	add    $0x10,%esp
801044c4:	c9                   	leave
801044c5:	c3                   	ret
801044c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cd:	8d 76 00             	lea    0x0(%esi),%esi

801044d0 <reset_all_priorities>:
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 10             	sub    $0x10,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044da:	68 40 2d 11 80       	push   $0x80112d40
801044df:	e8 8c 05 00 00       	call   80104a70 <acquire>
  scheduler_type = new_scheduler_type;
801044e4:	31 c0                	xor    %eax,%eax
801044e6:	83 c4 10             	add    $0x10,%esp
801044e9:	83 fb 01             	cmp    $0x1,%ebx
801044ec:	89 1d 28 2d 11 80    	mov    %ebx,0x80112d28
  for (struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f2:	0f 94 c0             	sete   %al
801044f5:	ba 00 00 00 00       	mov    $0x0,%edx
801044fa:	0f 44 15 10 b0 10 80 	cmove  0x8010b010,%edx
80104501:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
80104504:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (new_scheduler_type == SCHEDULER_MLFQ)
80104510:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  for (struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104516:	05 8c 00 00 00       	add    $0x8c,%eax
8010451b:	89 48 f0             	mov    %ecx,-0x10(%eax)
8010451e:	3d 74 50 11 80       	cmp    $0x80115074,%eax
80104523:	75 eb                	jne    80104510 <reset_all_priorities+0x40>
  release(&ptable.lock);
80104525:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
8010452c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010452f:	c9                   	leave
  release(&ptable.lock);
80104530:	e9 7b 06 00 00       	jmp    80104bb0 <release>
80104535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <set_rr_scheduler_defaults>:
void set_rr_scheduler_defaults() {
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);
80104546:	68 40 2d 11 80       	push   $0x80112d40
8010454b:	e8 20 05 00 00       	call   80104a70 <acquire>
80104550:	83 c4 10             	add    $0x10,%esp
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104553:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop
        if(p->state == RUNNABLE || p->state == RUNNING) {
80104560:	8b 48 0c             	mov    0xc(%eax),%ecx
80104563:	8d 51 fd             	lea    -0x3(%ecx),%edx
80104566:	83 fa 01             	cmp    $0x1,%edx
80104569:	77 07                	ja     80104572 <set_rr_scheduler_defaults+0x32>
            p->priority = 0; 
8010456b:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
    for(struct proc *p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104572:	05 8c 00 00 00       	add    $0x8c,%eax
80104577:	3d 74 50 11 80       	cmp    $0x80115074,%eax
8010457c:	75 e2                	jne    80104560 <set_rr_scheduler_defaults+0x20>
    release(&ptable.lock);
8010457e:	83 ec 0c             	sub    $0xc,%esp
80104581:	68 40 2d 11 80       	push   $0x80112d40
80104586:	e8 25 06 00 00       	call   80104bb0 <release>
}
8010458b:	83 c4 10             	add    $0x10,%esp
8010458e:	c9                   	leave
8010458f:	c3                   	ret

80104590 <yield>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104597:	68 40 2d 11 80       	push   $0x80112d40
8010459c:	e8 cf 04 00 00       	call   80104a70 <acquire>
  pushcli();
801045a1:	e8 7a 04 00 00       	call   80104a20 <pushcli>
  c = mycpu();
801045a6:	e8 65 f4 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
801045ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045b1:	e8 9a 05 00 00       	call   80104b50 <popcli>
  myproc()->state = RUNNABLE;
801045b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045bd:	e8 ce f9 ff ff       	call   80103f90 <sched>
  release(&ptable.lock);
801045c2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801045c9:	e8 e2 05 00 00       	call   80104bb0 <release>
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	83 c4 10             	add    $0x10,%esp
801045d4:	c9                   	leave
801045d5:	c3                   	ret
801045d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045dd:	8d 76 00             	lea    0x0(%esi),%esi

801045e0 <sleep>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	83 ec 0c             	sub    $0xc,%esp
801045e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801045ef:	e8 2c 04 00 00       	call   80104a20 <pushcli>
  c = mycpu();
801045f4:	e8 17 f4 ff ff       	call   80103a10 <mycpu>
  p = c->proc;
801045f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045ff:	e8 4c 05 00 00       	call   80104b50 <popcli>
  if(p == 0)
80104604:	85 db                	test   %ebx,%ebx
80104606:	0f 84 87 00 00 00    	je     80104693 <sleep+0xb3>
  if(lk == 0)
8010460c:	85 f6                	test   %esi,%esi
8010460e:	74 76                	je     80104686 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104610:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80104616:	74 50                	je     80104668 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	68 40 2d 11 80       	push   $0x80112d40
80104620:	e8 4b 04 00 00       	call   80104a70 <acquire>
    release(lk);
80104625:	89 34 24             	mov    %esi,(%esp)
80104628:	e8 83 05 00 00       	call   80104bb0 <release>
  p->chan = chan;
8010462d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104630:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104637:	e8 54 f9 ff ff       	call   80103f90 <sched>
  p->chan = 0;
8010463c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104643:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010464a:	e8 61 05 00 00       	call   80104bb0 <release>
    acquire(lk);
8010464f:	89 75 08             	mov    %esi,0x8(%ebp)
80104652:	83 c4 10             	add    $0x10,%esp
}
80104655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104658:	5b                   	pop    %ebx
80104659:	5e                   	pop    %esi
8010465a:	5f                   	pop    %edi
8010465b:	5d                   	pop    %ebp
    acquire(lk);
8010465c:	e9 0f 04 00 00       	jmp    80104a70 <acquire>
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104668:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010466b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104672:	e8 19 f9 ff ff       	call   80103f90 <sched>
  p->chan = 0;
80104677:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010467e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104681:	5b                   	pop    %ebx
80104682:	5e                   	pop    %esi
80104683:	5f                   	pop    %edi
80104684:	5d                   	pop    %ebp
80104685:	c3                   	ret
    panic("sleep without lk");
80104686:	83 ec 0c             	sub    $0xc,%esp
80104689:	68 60 7e 10 80       	push   $0x80107e60
8010468e:	e8 ed bc ff ff       	call   80100380 <panic>
    panic("sleep");
80104693:	83 ec 0c             	sub    $0xc,%esp
80104696:	68 5a 7e 10 80       	push   $0x80107e5a
8010469b:	e8 e0 bc ff ff       	call   80100380 <panic>

801046a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 10             	sub    $0x10,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046aa:	68 40 2d 11 80       	push   $0x80112d40
801046af:	e8 bc 03 00 00       	call   80104a70 <acquire>
801046b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046b7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801046bc:	eb 0e                	jmp    801046cc <wakeup+0x2c>
801046be:	66 90                	xchg   %ax,%ax
801046c0:	05 8c 00 00 00       	add    $0x8c,%eax
801046c5:	3d 74 50 11 80       	cmp    $0x80115074,%eax
801046ca:	74 1e                	je     801046ea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801046cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046d0:	75 ee                	jne    801046c0 <wakeup+0x20>
801046d2:	3b 58 20             	cmp    0x20(%eax),%ebx
801046d5:	75 e9                	jne    801046c0 <wakeup+0x20>
      p->state = RUNNABLE;
801046d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046de:	05 8c 00 00 00       	add    $0x8c,%eax
801046e3:	3d 74 50 11 80       	cmp    $0x80115074,%eax
801046e8:	75 e2                	jne    801046cc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801046ea:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
801046f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f4:	c9                   	leave
  release(&ptable.lock);
801046f5:	e9 b6 04 00 00       	jmp    80104bb0 <release>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104700 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 10             	sub    $0x10,%esp
80104707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010470a:	68 40 2d 11 80       	push   $0x80112d40
8010470f:	e8 5c 03 00 00       	call   80104a70 <acquire>
80104714:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104717:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010471c:	eb 0e                	jmp    8010472c <kill+0x2c>
8010471e:	66 90                	xchg   %ax,%ax
80104720:	05 8c 00 00 00       	add    $0x8c,%eax
80104725:	3d 74 50 11 80       	cmp    $0x80115074,%eax
8010472a:	74 34                	je     80104760 <kill+0x60>
    if(p->pid == pid){
8010472c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010472f:	75 ef                	jne    80104720 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104731:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104735:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010473c:	75 07                	jne    80104745 <kill+0x45>
        p->state = RUNNABLE;
8010473e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104745:	83 ec 0c             	sub    $0xc,%esp
80104748:	68 40 2d 11 80       	push   $0x80112d40
8010474d:	e8 5e 04 00 00       	call   80104bb0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104755:	83 c4 10             	add    $0x10,%esp
80104758:	31 c0                	xor    %eax,%eax
}
8010475a:	c9                   	leave
8010475b:	c3                   	ret
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104760:	83 ec 0c             	sub    $0xc,%esp
80104763:	68 40 2d 11 80       	push   $0x80112d40
80104768:	e8 43 04 00 00       	call   80104bb0 <release>
}
8010476d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104770:	83 c4 10             	add    $0x10,%esp
80104773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104778:	c9                   	leave
80104779:	c3                   	ret
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104788:	53                   	push   %ebx
80104789:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
8010478e:	83 ec 3c             	sub    $0x3c,%esp
80104791:	eb 27                	jmp    801047ba <procdump+0x3a>
80104793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104797:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 bf 7d 10 80       	push   $0x80107dbf
801047a0:	e8 0b bf ff ff       	call   801006b0 <cprintf>
801047a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801047ae:	81 fb e0 50 11 80    	cmp    $0x801150e0,%ebx
801047b4:	0f 84 7e 00 00 00    	je     80104838 <procdump+0xb8>
    if(p->state == UNUSED)
801047ba:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047bd:	85 c0                	test   %eax,%eax
801047bf:	74 e7                	je     801047a8 <procdump+0x28>
      state = "???";
801047c1:	ba 71 7e 10 80       	mov    $0x80107e71,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047c6:	83 f8 05             	cmp    $0x5,%eax
801047c9:	77 11                	ja     801047dc <procdump+0x5c>
801047cb:	8b 14 85 d0 7e 10 80 	mov    -0x7fef8130(,%eax,4),%edx
      state = "???";
801047d2:	b8 71 7e 10 80       	mov    $0x80107e71,%eax
801047d7:	85 d2                	test   %edx,%edx
801047d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047dc:	53                   	push   %ebx
801047dd:	52                   	push   %edx
801047de:	ff 73 a4             	push   -0x5c(%ebx)
801047e1:	68 75 7e 10 80       	push   $0x80107e75
801047e6:	e8 c5 be ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801047eb:	83 c4 10             	add    $0x10,%esp
801047ee:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801047f2:	75 a4                	jne    80104798 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047f4:	83 ec 08             	sub    $0x8,%esp
801047f7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047fa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047fd:	50                   	push   %eax
801047fe:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104801:	8b 40 0c             	mov    0xc(%eax),%eax
80104804:	83 c0 08             	add    $0x8,%eax
80104807:	50                   	push   %eax
80104808:	e8 63 01 00 00       	call   80104970 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010480d:	83 c4 10             	add    $0x10,%esp
80104810:	8b 17                	mov    (%edi),%edx
80104812:	85 d2                	test   %edx,%edx
80104814:	74 82                	je     80104798 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104816:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104819:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010481c:	52                   	push   %edx
8010481d:	68 a1 78 10 80       	push   $0x801078a1
80104822:	e8 89 be ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104827:	83 c4 10             	add    $0x10,%esp
8010482a:	39 f7                	cmp    %esi,%edi
8010482c:	75 e2                	jne    80104810 <procdump+0x90>
8010482e:	e9 65 ff ff ff       	jmp    80104798 <procdump+0x18>
80104833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104837:	90                   	nop
  }
}
80104838:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010483b:	5b                   	pop    %ebx
8010483c:	5e                   	pop    %esi
8010483d:	5f                   	pop    %edi
8010483e:	5d                   	pop    %ebp
8010483f:	c3                   	ret

80104840 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010484a:	68 e8 7e 10 80       	push   $0x80107ee8
8010484f:	8d 43 04             	lea    0x4(%ebx),%eax
80104852:	50                   	push   %eax
80104853:	e8 f8 00 00 00       	call   80104950 <initlock>
  lk->name = name;
80104858:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010485b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104861:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104864:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010486b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010486e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104871:	c9                   	leave
80104872:	c3                   	ret
80104873:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104880 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104888:	8d 73 04             	lea    0x4(%ebx),%esi
8010488b:	83 ec 0c             	sub    $0xc,%esp
8010488e:	56                   	push   %esi
8010488f:	e8 dc 01 00 00       	call   80104a70 <acquire>
  while (lk->locked) {
80104894:	8b 13                	mov    (%ebx),%edx
80104896:	83 c4 10             	add    $0x10,%esp
80104899:	85 d2                	test   %edx,%edx
8010489b:	74 16                	je     801048b3 <acquiresleep+0x33>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801048a0:	83 ec 08             	sub    $0x8,%esp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	e8 36 fd ff ff       	call   801045e0 <sleep>
  while (lk->locked) {
801048aa:	8b 03                	mov    (%ebx),%eax
801048ac:	83 c4 10             	add    $0x10,%esp
801048af:	85 c0                	test   %eax,%eax
801048b1:	75 ed                	jne    801048a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801048b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801048b9:	e8 d2 f1 ff ff       	call   80103a90 <myproc>
801048be:	8b 40 10             	mov    0x10(%eax),%eax
801048c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801048c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ca:	5b                   	pop    %ebx
801048cb:	5e                   	pop    %esi
801048cc:	5d                   	pop    %ebp
  release(&lk->lk);
801048cd:	e9 de 02 00 00       	jmp    80104bb0 <release>
801048d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048e8:	8d 73 04             	lea    0x4(%ebx),%esi
801048eb:	83 ec 0c             	sub    $0xc,%esp
801048ee:	56                   	push   %esi
801048ef:	e8 7c 01 00 00       	call   80104a70 <acquire>
  lk->locked = 0;
801048f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104901:	89 1c 24             	mov    %ebx,(%esp)
80104904:	e8 97 fd ff ff       	call   801046a0 <wakeup>
  release(&lk->lk);
80104909:	89 75 08             	mov    %esi,0x8(%ebp)
8010490c:	83 c4 10             	add    $0x10,%esp
}
8010490f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104912:	5b                   	pop    %ebx
80104913:	5e                   	pop    %esi
80104914:	5d                   	pop    %ebp
  release(&lk->lk);
80104915:	e9 96 02 00 00       	jmp    80104bb0 <release>
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104928:	8d 5e 04             	lea    0x4(%esi),%ebx
8010492b:	83 ec 0c             	sub    $0xc,%esp
8010492e:	53                   	push   %ebx
8010492f:	e8 3c 01 00 00       	call   80104a70 <acquire>
  r = lk->locked;
80104934:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104936:	89 1c 24             	mov    %ebx,(%esp)
80104939:	e8 72 02 00 00       	call   80104bb0 <release>
  return r;
}
8010493e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104941:	89 f0                	mov    %esi,%eax
80104943:	5b                   	pop    %ebx
80104944:	5e                   	pop    %esi
80104945:	5d                   	pop    %ebp
80104946:	c3                   	ret
80104947:	66 90                	xchg   %ax,%ax
80104949:	66 90                	xchg   %ax,%ax
8010494b:	66 90                	xchg   %ax,%ax
8010494d:	66 90                	xchg   %ax,%ax
8010494f:	90                   	nop

80104950 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104956:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010495f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104962:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret
8010496b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop

80104970 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	8b 45 08             	mov    0x8(%ebp),%eax
80104977:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010497a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010497d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104982:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104987:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010498c:	76 10                	jbe    8010499e <getcallerpcs+0x2e>
8010498e:	eb 28                	jmp    801049b8 <getcallerpcs+0x48>
80104990:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104996:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010499c:	77 1a                	ja     801049b8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010499e:	8b 5a 04             	mov    0x4(%edx),%ebx
801049a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801049a4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801049a7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801049a9:	83 f8 0a             	cmp    $0xa,%eax
801049ac:	75 e2                	jne    80104990 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801049ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b1:	c9                   	leave
801049b2:	c3                   	ret
801049b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b7:	90                   	nop
801049b8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801049bb:	8d 51 28             	lea    0x28(%ecx),%edx
801049be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801049c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049c6:	83 c0 04             	add    $0x4,%eax
801049c9:	39 d0                	cmp    %edx,%eax
801049cb:	75 f3                	jne    801049c0 <getcallerpcs+0x50>
}
801049cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d0:	c9                   	leave
801049d1:	c3                   	ret
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049e0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801049ea:	8b 02                	mov    (%edx),%eax
801049ec:	85 c0                	test   %eax,%eax
801049ee:	75 10                	jne    80104a00 <holding+0x20>
}
801049f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f3:	31 c0                	xor    %eax,%eax
801049f5:	c9                   	leave
801049f6:	c3                   	ret
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax
  return lock->locked && lock->cpu == mycpu();
80104a00:	8b 5a 08             	mov    0x8(%edx),%ebx
80104a03:	e8 08 f0 ff ff       	call   80103a10 <mycpu>
80104a08:	39 c3                	cmp    %eax,%ebx
}
80104a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a0d:	c9                   	leave
  return lock->locked && lock->cpu == mycpu();
80104a0e:	0f 94 c0             	sete   %al
80104a11:	0f b6 c0             	movzbl %al,%eax
}
80104a14:	c3                   	ret
80104a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	9c                   	pushf
80104a28:	5b                   	pop    %ebx
  asm volatile("cli");
80104a29:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a2a:	e8 e1 ef ff ff       	call   80103a10 <mycpu>
80104a2f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a35:	85 c0                	test   %eax,%eax
80104a37:	74 17                	je     80104a50 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104a39:	e8 d2 ef ff ff       	call   80103a10 <mycpu>
80104a3e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a48:	c9                   	leave
80104a49:	c3                   	ret
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104a50:	e8 bb ef ff ff       	call   80103a10 <mycpu>
80104a55:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a5b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a61:	eb d6                	jmp    80104a39 <pushcli+0x19>
80104a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <acquire>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a77:	e8 a4 ff ff ff       	call   80104a20 <pushcli>
  if(holding(lk))
80104a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104a7f:	8b 02                	mov    (%edx),%eax
80104a81:	85 c0                	test   %eax,%eax
80104a83:	0f 85 9f 00 00 00    	jne    80104b28 <acquire+0xb8>
  asm volatile("lock; xchgl %0, %1" :
80104a89:	b8 01 00 00 00       	mov    $0x1,%eax
80104a8e:	f0 87 02             	lock xchg %eax,(%edx)
80104a91:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104a96:	85 c0                	test   %eax,%eax
80104a98:	74 12                	je     80104aac <acquire+0x3c>
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa0:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa3:	89 c8                	mov    %ecx,%eax
80104aa5:	f0 87 02             	lock xchg %eax,(%edx)
80104aa8:	85 c0                	test   %eax,%eax
80104aaa:	75 f4                	jne    80104aa0 <acquire+0x30>
  __sync_synchronize();
80104aac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ab4:	e8 57 ef ff ff       	call   80103a10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104abc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104abe:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ac1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104ac7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104acc:	77 32                	ja     80104b00 <acquire+0x90>
  ebp = (uint*)v - 2;
80104ace:	89 e8                	mov    %ebp,%eax
80104ad0:	eb 14                	jmp    80104ae6 <acquire+0x76>
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ad8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ade:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ae4:	77 1a                	ja     80104b00 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104ae6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ae9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104aed:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104af0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104af2:	83 fa 0a             	cmp    $0xa,%edx
80104af5:	75 e1                	jne    80104ad8 <acquire+0x68>
}
80104af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104afa:	c9                   	leave
80104afb:	c3                   	ret
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b00:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104b04:	8d 51 34             	lea    0x34(%ecx),%edx
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b16:	83 c0 04             	add    $0x4,%eax
80104b19:	39 d0                	cmp    %edx,%eax
80104b1b:	75 f3                	jne    80104b10 <acquire+0xa0>
}
80104b1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b20:	c9                   	leave
80104b21:	c3                   	ret
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104b28:	8b 5a 08             	mov    0x8(%edx),%ebx
80104b2b:	e8 e0 ee ff ff       	call   80103a10 <mycpu>
80104b30:	39 c3                	cmp    %eax,%ebx
80104b32:	74 0c                	je     80104b40 <acquire+0xd0>
  while(xchg(&lk->locked, 1) != 0)
80104b34:	8b 55 08             	mov    0x8(%ebp),%edx
80104b37:	e9 4d ff ff ff       	jmp    80104a89 <acquire+0x19>
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("acquire");
80104b40:	83 ec 0c             	sub    $0xc,%esp
80104b43:	68 f3 7e 10 80       	push   $0x80107ef3
80104b48:	e8 33 b8 ff ff       	call   80100380 <panic>
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi

80104b50 <popcli>:

void
popcli(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b56:	9c                   	pushf
80104b57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b58:	f6 c4 02             	test   $0x2,%ah
80104b5b:	75 35                	jne    80104b92 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b5d:	e8 ae ee ff ff       	call   80103a10 <mycpu>
80104b62:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b69:	78 34                	js     80104b9f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b6b:	e8 a0 ee ff ff       	call   80103a10 <mycpu>
80104b70:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b76:	85 d2                	test   %edx,%edx
80104b78:	74 06                	je     80104b80 <popcli+0x30>
    sti();
}
80104b7a:	c9                   	leave
80104b7b:	c3                   	ret
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b80:	e8 8b ee ff ff       	call   80103a10 <mycpu>
80104b85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	74 eb                	je     80104b7a <popcli+0x2a>
  asm volatile("sti");
80104b8f:	fb                   	sti
}
80104b90:	c9                   	leave
80104b91:	c3                   	ret
    panic("popcli - interruptible");
80104b92:	83 ec 0c             	sub    $0xc,%esp
80104b95:	68 fb 7e 10 80       	push   $0x80107efb
80104b9a:	e8 e1 b7 ff ff       	call   80100380 <panic>
    panic("popcli");
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 12 7f 10 80       	push   $0x80107f12
80104ba7:	e8 d4 b7 ff ff       	call   80100380 <panic>
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <release>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104bb8:	8b 03                	mov    (%ebx),%eax
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	75 12                	jne    80104bd0 <release+0x20>
    panic("release");
80104bbe:	83 ec 0c             	sub    $0xc,%esp
80104bc1:	68 19 7f 10 80       	push   $0x80107f19
80104bc6:	e8 b5 b7 ff ff       	call   80100380 <panic>
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104bd0:	8b 73 08             	mov    0x8(%ebx),%esi
80104bd3:	e8 38 ee ff ff       	call   80103a10 <mycpu>
80104bd8:	39 c6                	cmp    %eax,%esi
80104bda:	75 e2                	jne    80104bbe <release+0xe>
  lk->pcs[0] = 0;
80104bdc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104be3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bea:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104bf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf8:	5b                   	pop    %ebx
80104bf9:	5e                   	pop    %esi
80104bfa:	5d                   	pop    %ebp
  popcli();
80104bfb:	e9 50 ff ff ff       	jmp    80104b50 <popcli>

80104c00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	57                   	push   %edi
80104c04:	8b 55 08             	mov    0x8(%ebp),%edx
80104c07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c0a:	89 d0                	mov    %edx,%eax
80104c0c:	09 c8                	or     %ecx,%eax
80104c0e:	a8 03                	test   $0x3,%al
80104c10:	75 1e                	jne    80104c30 <memset+0x30>
    c &= 0xFF;
80104c12:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c16:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104c19:	89 d7                	mov    %edx,%edi
80104c1b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104c21:	fc                   	cld
80104c22:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104c24:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c27:	89 d0                	mov    %edx,%eax
80104c29:	c9                   	leave
80104c2a:	c3                   	ret
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104c30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c33:	89 d7                	mov    %edx,%edi
80104c35:	fc                   	cld
80104c36:	f3 aa                	rep stos %al,%es:(%edi)
80104c38:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c3b:	89 d0                	mov    %edx,%eax
80104c3d:	c9                   	leave
80104c3e:	c3                   	ret
80104c3f:	90                   	nop

80104c40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	8b 75 10             	mov    0x10(%ebp),%esi
80104c48:	8b 55 08             	mov    0x8(%ebp),%edx
80104c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c4e:	85 f6                	test   %esi,%esi
80104c50:	74 2e                	je     80104c80 <memcmp+0x40>
80104c52:	01 c6                	add    %eax,%esi
80104c54:	eb 14                	jmp    80104c6a <memcmp+0x2a>
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104c66:	39 f0                	cmp    %esi,%eax
80104c68:	74 16                	je     80104c80 <memcmp+0x40>
    if(*s1 != *s2)
80104c6a:	0f b6 0a             	movzbl (%edx),%ecx
80104c6d:	0f b6 18             	movzbl (%eax),%ebx
80104c70:	38 d9                	cmp    %bl,%cl
80104c72:	74 ec                	je     80104c60 <memcmp+0x20>
      return *s1 - *s2;
80104c74:	0f b6 c1             	movzbl %cl,%eax
80104c77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5d                   	pop    %ebp
80104c7c:	c3                   	ret
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	5b                   	pop    %ebx
  return 0;
80104c81:	31 c0                	xor    %eax,%eax
}
80104c83:	5e                   	pop    %esi
80104c84:	5d                   	pop    %ebp
80104c85:	c3                   	ret
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi

80104c90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	8b 55 08             	mov    0x8(%ebp),%edx
80104c98:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c9e:	39 d6                	cmp    %edx,%esi
80104ca0:	73 26                	jae    80104cc8 <memmove+0x38>
80104ca2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104ca5:	39 ca                	cmp    %ecx,%edx
80104ca7:	73 1f                	jae    80104cc8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ca9:	85 c0                	test   %eax,%eax
80104cab:	74 0f                	je     80104cbc <memmove+0x2c>
80104cad:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104cb0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104cb4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104cb7:	83 e8 01             	sub    $0x1,%eax
80104cba:	73 f4                	jae    80104cb0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cbc:	5e                   	pop    %esi
80104cbd:	89 d0                	mov    %edx,%eax
80104cbf:	5f                   	pop    %edi
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104cc8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104ccb:	89 d7                	mov    %edx,%edi
80104ccd:	85 c0                	test   %eax,%eax
80104ccf:	74 eb                	je     80104cbc <memmove+0x2c>
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104cd8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104cd9:	39 ce                	cmp    %ecx,%esi
80104cdb:	75 fb                	jne    80104cd8 <memmove+0x48>
}
80104cdd:	5e                   	pop    %esi
80104cde:	89 d0                	mov    %edx,%eax
80104ce0:	5f                   	pop    %edi
80104ce1:	5d                   	pop    %ebp
80104ce2:	c3                   	ret
80104ce3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cf0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104cf0:	eb 9e                	jmp    80104c90 <memmove>
80104cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	8b 55 10             	mov    0x10(%ebp),%edx
80104d07:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104d0d:	85 d2                	test   %edx,%edx
80104d0f:	75 16                	jne    80104d27 <strncmp+0x27>
80104d11:	eb 2d                	jmp    80104d40 <strncmp+0x40>
80104d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d17:	90                   	nop
80104d18:	3a 19                	cmp    (%ecx),%bl
80104d1a:	75 12                	jne    80104d2e <strncmp+0x2e>
    n--, p++, q++;
80104d1c:	83 c0 01             	add    $0x1,%eax
80104d1f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d22:	83 ea 01             	sub    $0x1,%edx
80104d25:	74 19                	je     80104d40 <strncmp+0x40>
80104d27:	0f b6 18             	movzbl (%eax),%ebx
80104d2a:	84 db                	test   %bl,%bl
80104d2c:	75 ea                	jne    80104d18 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d2e:	0f b6 00             	movzbl (%eax),%eax
80104d31:	0f b6 11             	movzbl (%ecx),%edx
}
80104d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d37:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104d38:	29 d0                	sub    %edx,%eax
}
80104d3a:	c3                   	ret
80104d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop
80104d40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104d43:	31 c0                	xor    %eax,%eax
}
80104d45:	c9                   	leave
80104d46:	c3                   	ret
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	8b 75 08             	mov    0x8(%ebp),%esi
80104d59:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d5c:	89 f0                	mov    %esi,%eax
80104d5e:	eb 15                	jmp    80104d75 <strncpy+0x25>
80104d60:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d64:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d67:	83 c0 01             	add    $0x1,%eax
80104d6a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104d6e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104d71:	84 c9                	test   %cl,%cl
80104d73:	74 13                	je     80104d88 <strncpy+0x38>
80104d75:	89 d3                	mov    %edx,%ebx
80104d77:	83 ea 01             	sub    $0x1,%edx
80104d7a:	85 db                	test   %ebx,%ebx
80104d7c:	7f e2                	jg     80104d60 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104d7e:	5b                   	pop    %ebx
80104d7f:	89 f0                	mov    %esi,%eax
80104d81:	5e                   	pop    %esi
80104d82:	5f                   	pop    %edi
80104d83:	5d                   	pop    %ebp
80104d84:	c3                   	ret
80104d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104d88:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104d8b:	83 e9 01             	sub    $0x1,%ecx
80104d8e:	85 d2                	test   %edx,%edx
80104d90:	74 ec                	je     80104d7e <strncpy+0x2e>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104d98:	83 c0 01             	add    $0x1,%eax
80104d9b:	89 ca                	mov    %ecx,%edx
80104d9d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104da1:	29 c2                	sub    %eax,%edx
80104da3:	85 d2                	test   %edx,%edx
80104da5:	7f f1                	jg     80104d98 <strncpy+0x48>
}
80104da7:	5b                   	pop    %ebx
80104da8:	89 f0                	mov    %esi,%eax
80104daa:	5e                   	pop    %esi
80104dab:	5f                   	pop    %edi
80104dac:	5d                   	pop    %ebp
80104dad:	c3                   	ret
80104dae:	66 90                	xchg   %ax,%ax

80104db0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	8b 55 10             	mov    0x10(%ebp),%edx
80104db8:	8b 75 08             	mov    0x8(%ebp),%esi
80104dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104dbe:	85 d2                	test   %edx,%edx
80104dc0:	7e 25                	jle    80104de7 <safestrcpy+0x37>
80104dc2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104dc6:	89 f2                	mov    %esi,%edx
80104dc8:	eb 16                	jmp    80104de0 <safestrcpy+0x30>
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104dd0:	0f b6 08             	movzbl (%eax),%ecx
80104dd3:	83 c0 01             	add    $0x1,%eax
80104dd6:	83 c2 01             	add    $0x1,%edx
80104dd9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ddc:	84 c9                	test   %cl,%cl
80104dde:	74 04                	je     80104de4 <safestrcpy+0x34>
80104de0:	39 d8                	cmp    %ebx,%eax
80104de2:	75 ec                	jne    80104dd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104de4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104de7:	89 f0                	mov    %esi,%eax
80104de9:	5b                   	pop    %ebx
80104dea:	5e                   	pop    %esi
80104deb:	5d                   	pop    %ebp
80104dec:	c3                   	ret
80104ded:	8d 76 00             	lea    0x0(%esi),%esi

80104df0 <strlen>:

int
strlen(const char *s)
{
80104df0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104df1:	31 c0                	xor    %eax,%eax
{
80104df3:	89 e5                	mov    %esp,%ebp
80104df5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104df8:	80 3a 00             	cmpb   $0x0,(%edx)
80104dfb:	74 0c                	je     80104e09 <strlen+0x19>
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
80104e00:	83 c0 01             	add    $0x1,%eax
80104e03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e07:	75 f7                	jne    80104e00 <strlen+0x10>
    ;
  return n;
}
80104e09:	5d                   	pop    %ebp
80104e0a:	c3                   	ret

80104e0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104e13:	55                   	push   %ebp
  pushl %ebx
80104e14:	53                   	push   %ebx
  pushl %esi
80104e15:	56                   	push   %esi
  pushl %edi
80104e16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e19:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104e1b:	5f                   	pop    %edi
  popl %esi
80104e1c:	5e                   	pop    %esi
  popl %ebx
80104e1d:	5b                   	pop    %ebx
  popl %ebp
80104e1e:	5d                   	pop    %ebp
  ret
80104e1f:	c3                   	ret

80104e20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
80104e24:	83 ec 04             	sub    $0x4,%esp
80104e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e2a:	e8 61 ec ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e2f:	8b 00                	mov    (%eax),%eax
80104e31:	39 c3                	cmp    %eax,%ebx
80104e33:	73 1b                	jae    80104e50 <fetchint+0x30>
80104e35:	8d 53 04             	lea    0x4(%ebx),%edx
80104e38:	39 d0                	cmp    %edx,%eax
80104e3a:	72 14                	jb     80104e50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e3f:	8b 13                	mov    (%ebx),%edx
80104e41:	89 10                	mov    %edx,(%eax)
  return 0;
80104e43:	31 c0                	xor    %eax,%eax
}
80104e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e48:	c9                   	leave
80104e49:	c3                   	ret
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e55:	eb ee                	jmp    80104e45 <fetchint+0x25>
80104e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 04             	sub    $0x4,%esp
80104e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e6a:	e8 21 ec ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz)
80104e6f:	3b 18                	cmp    (%eax),%ebx
80104e71:	73 2d                	jae    80104ea0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e76:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e78:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e7a:	39 d3                	cmp    %edx,%ebx
80104e7c:	73 22                	jae    80104ea0 <fetchstr+0x40>
80104e7e:	89 d8                	mov    %ebx,%eax
80104e80:	eb 0d                	jmp    80104e8f <fetchstr+0x2f>
80104e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e88:	83 c0 01             	add    $0x1,%eax
80104e8b:	39 d0                	cmp    %edx,%eax
80104e8d:	73 11                	jae    80104ea0 <fetchstr+0x40>
    if(*s == 0)
80104e8f:	80 38 00             	cmpb   $0x0,(%eax)
80104e92:	75 f4                	jne    80104e88 <fetchstr+0x28>
      return s - *pp;
80104e94:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e99:	c9                   	leave
80104e9a:	c3                   	ret
80104e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop
80104ea0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ea3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea8:	c9                   	leave
80104ea9:	c3                   	ret
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104eb0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eb5:	e8 d6 eb ff ff       	call   80103a90 <myproc>
80104eba:	8b 55 08             	mov    0x8(%ebp),%edx
80104ebd:	8b 40 18             	mov    0x18(%eax),%eax
80104ec0:	8b 40 44             	mov    0x44(%eax),%eax
80104ec3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ec6:	e8 c5 eb ff ff       	call   80103a90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ecb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ece:	8b 00                	mov    (%eax),%eax
80104ed0:	39 c6                	cmp    %eax,%esi
80104ed2:	73 1c                	jae    80104ef0 <argint+0x40>
80104ed4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ed7:	39 d0                	cmp    %edx,%eax
80104ed9:	72 15                	jb     80104ef0 <argint+0x40>
  *ip = *(int*)(addr);
80104edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ede:	8b 53 04             	mov    0x4(%ebx),%edx
80104ee1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ee3:	31 c0                	xor    %eax,%eax
}
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5d                   	pop    %ebp
80104ee8:	c3                   	ret
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ef5:	eb ee                	jmp    80104ee5 <argint+0x35>
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
80104f05:	53                   	push   %ebx
80104f06:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104f09:	e8 82 eb ff ff       	call   80103a90 <myproc>
80104f0e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f10:	e8 7b eb ff ff       	call   80103a90 <myproc>
80104f15:	8b 55 08             	mov    0x8(%ebp),%edx
80104f18:	8b 40 18             	mov    0x18(%eax),%eax
80104f1b:	8b 40 44             	mov    0x44(%eax),%eax
80104f1e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f21:	e8 6a eb ff ff       	call   80103a90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f26:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f29:	8b 00                	mov    (%eax),%eax
80104f2b:	39 c7                	cmp    %eax,%edi
80104f2d:	73 31                	jae    80104f60 <argptr+0x60>
80104f2f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104f32:	39 c8                	cmp    %ecx,%eax
80104f34:	72 2a                	jb     80104f60 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f36:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104f39:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f3c:	85 d2                	test   %edx,%edx
80104f3e:	78 20                	js     80104f60 <argptr+0x60>
80104f40:	8b 16                	mov    (%esi),%edx
80104f42:	39 d0                	cmp    %edx,%eax
80104f44:	73 1a                	jae    80104f60 <argptr+0x60>
80104f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f49:	01 c3                	add    %eax,%ebx
80104f4b:	39 da                	cmp    %ebx,%edx
80104f4d:	72 11                	jb     80104f60 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f52:	89 02                	mov    %eax,(%edx)
  return 0;
80104f54:	31 c0                	xor    %eax,%eax
}
80104f56:	83 c4 0c             	add    $0xc,%esp
80104f59:	5b                   	pop    %ebx
80104f5a:	5e                   	pop    %esi
80104f5b:	5f                   	pop    %edi
80104f5c:	5d                   	pop    %ebp
80104f5d:	c3                   	ret
80104f5e:	66 90                	xchg   %ax,%ax
    return -1;
80104f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f65:	eb ef                	jmp    80104f56 <argptr+0x56>
80104f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6e:	66 90                	xchg   %ax,%ax

80104f70 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f75:	e8 16 eb ff ff       	call   80103a90 <myproc>
80104f7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f7d:	8b 40 18             	mov    0x18(%eax),%eax
80104f80:	8b 40 44             	mov    0x44(%eax),%eax
80104f83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f86:	e8 05 eb ff ff       	call   80103a90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f8e:	8b 00                	mov    (%eax),%eax
80104f90:	39 c6                	cmp    %eax,%esi
80104f92:	73 44                	jae    80104fd8 <argstr+0x68>
80104f94:	8d 53 08             	lea    0x8(%ebx),%edx
80104f97:	39 d0                	cmp    %edx,%eax
80104f99:	72 3d                	jb     80104fd8 <argstr+0x68>
  *ip = *(int*)(addr);
80104f9b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104f9e:	e8 ed ea ff ff       	call   80103a90 <myproc>
  if(addr >= curproc->sz)
80104fa3:	3b 18                	cmp    (%eax),%ebx
80104fa5:	73 31                	jae    80104fd8 <argstr+0x68>
  *pp = (char*)addr;
80104fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104faa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104fac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104fae:	39 d3                	cmp    %edx,%ebx
80104fb0:	73 26                	jae    80104fd8 <argstr+0x68>
80104fb2:	89 d8                	mov    %ebx,%eax
80104fb4:	eb 11                	jmp    80104fc7 <argstr+0x57>
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
80104fc0:	83 c0 01             	add    $0x1,%eax
80104fc3:	39 d0                	cmp    %edx,%eax
80104fc5:	73 11                	jae    80104fd8 <argstr+0x68>
    if(*s == 0)
80104fc7:	80 38 00             	cmpb   $0x0,(%eax)
80104fca:	75 f4                	jne    80104fc0 <argstr+0x50>
      return s - *pp;
80104fcc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104fce:	5b                   	pop    %ebx
80104fcf:	5e                   	pop    %esi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fd8:	5b                   	pop    %ebx
    return -1;
80104fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fde:	5e                   	pop    %esi
80104fdf:	5d                   	pop    %ebp
80104fe0:	c3                   	ret
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop

80104ff0 <syscall>:
[SYS_mlfq_set_allotment]  sys_mlfq_set_allotment,
};

void
syscall(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	53                   	push   %ebx
80104ff4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ff7:	e8 94 ea ff ff       	call   80103a90 <myproc>
80104ffc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ffe:	8b 40 18             	mov    0x18(%eax),%eax
80105001:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105004:	8d 50 ff             	lea    -0x1(%eax),%edx
80105007:	83 fa 1a             	cmp    $0x1a,%edx
8010500a:	77 24                	ja     80105030 <syscall+0x40>
8010500c:	8b 14 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%edx
80105013:	85 d2                	test   %edx,%edx
80105015:	74 19                	je     80105030 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105017:	ff d2                	call   *%edx
80105019:	89 c2                	mov    %eax,%edx
8010501b:	8b 43 18             	mov    0x18(%ebx),%eax
8010501e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105021:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105024:	c9                   	leave
80105025:	c3                   	ret
80105026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105030:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105031:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105034:	50                   	push   %eax
80105035:	ff 73 10             	push   0x10(%ebx)
80105038:	68 21 7f 10 80       	push   $0x80107f21
8010503d:	e8 6e b6 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105042:	8b 43 18             	mov    0x18(%ebx),%eax
80105045:	83 c4 10             	add    $0x10,%esp
80105048:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010504f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105052:	c9                   	leave
80105053:	c3                   	ret
80105054:	66 90                	xchg   %ax,%ax
80105056:	66 90                	xchg   %ax,%ax
80105058:	66 90                	xchg   %ax,%ax
8010505a:	66 90                	xchg   %ax,%ax
8010505c:	66 90                	xchg   %ax,%ax
8010505e:	66 90                	xchg   %ax,%ax

80105060 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105065:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105068:	53                   	push   %ebx
80105069:	83 ec 44             	sub    $0x44,%esp
8010506c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010506f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105072:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105075:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105078:	57                   	push   %edi
80105079:	50                   	push   %eax
8010507a:	e8 c1 d0 ff ff       	call   80102140 <nameiparent>
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	85 c0                	test   %eax,%eax
80105084:	74 5e                	je     801050e4 <create+0x84>
    return 0;
  ilock(dp);
80105086:	83 ec 0c             	sub    $0xc,%esp
80105089:	89 c3                	mov    %eax,%ebx
8010508b:	50                   	push   %eax
8010508c:	e8 5f c7 ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105091:	83 c4 0c             	add    $0xc,%esp
80105094:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105097:	50                   	push   %eax
80105098:	57                   	push   %edi
80105099:	53                   	push   %ebx
8010509a:	e8 b1 cc ff ff       	call   80101d50 <dirlookup>
8010509f:	83 c4 10             	add    $0x10,%esp
801050a2:	89 c6                	mov    %eax,%esi
801050a4:	85 c0                	test   %eax,%eax
801050a6:	74 48                	je     801050f0 <create+0x90>
    iunlockput(dp);
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	53                   	push   %ebx
801050ac:	e8 cf c9 ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
801050b1:	89 34 24             	mov    %esi,(%esp)
801050b4:	e8 37 c7 ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801050c1:	75 15                	jne    801050d8 <create+0x78>
801050c3:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801050c8:	75 0e                	jne    801050d8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cd:	89 f0                	mov    %esi,%eax
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5f                   	pop    %edi
801050d2:	5d                   	pop    %ebp
801050d3:	c3                   	ret
801050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	56                   	push   %esi
801050dc:	e8 9f c9 ff ff       	call   80101a80 <iunlockput>
    return 0;
801050e1:	83 c4 10             	add    $0x10,%esp
}
801050e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801050e7:	31 f6                	xor    %esi,%esi
}
801050e9:	5b                   	pop    %ebx
801050ea:	89 f0                	mov    %esi,%eax
801050ec:	5e                   	pop    %esi
801050ed:	5f                   	pop    %edi
801050ee:	5d                   	pop    %ebp
801050ef:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
801050f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	50                   	push   %eax
801050f8:	ff 33                	push   (%ebx)
801050fa:	e8 81 c5 ff ff       	call   80101680 <ialloc>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	89 c6                	mov    %eax,%esi
80105104:	85 c0                	test   %eax,%eax
80105106:	0f 84 bc 00 00 00    	je     801051c8 <create+0x168>
  ilock(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	50                   	push   %eax
80105110:	e8 db c6 ff ff       	call   801017f0 <ilock>
  ip->major = major;
80105115:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105119:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010511d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105121:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105125:	b8 01 00 00 00       	mov    $0x1,%eax
8010512a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010512e:	89 34 24             	mov    %esi,(%esp)
80105131:	e8 0a c6 ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010513e:	74 30                	je     80105170 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	ff 76 04             	push   0x4(%esi)
80105146:	57                   	push   %edi
80105147:	53                   	push   %ebx
80105148:	e8 13 cf ff ff       	call   80102060 <dirlink>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	78 67                	js     801051bb <create+0x15b>
  iunlockput(dp);
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	53                   	push   %ebx
80105158:	e8 23 c9 ff ff       	call   80101a80 <iunlockput>
  return ip;
8010515d:	83 c4 10             	add    $0x10,%esp
}
80105160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105163:	89 f0                	mov    %esi,%eax
80105165:	5b                   	pop    %ebx
80105166:	5e                   	pop    %esi
80105167:	5f                   	pop    %edi
80105168:	5d                   	pop    %ebp
80105169:	c3                   	ret
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105170:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105173:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105178:	53                   	push   %ebx
80105179:	e8 c2 c5 ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010517e:	83 c4 0c             	add    $0xc,%esp
80105181:	ff 76 04             	push   0x4(%esi)
80105184:	68 cc 7f 10 80       	push   $0x80107fcc
80105189:	56                   	push   %esi
8010518a:	e8 d1 ce ff ff       	call   80102060 <dirlink>
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	85 c0                	test   %eax,%eax
80105194:	78 18                	js     801051ae <create+0x14e>
80105196:	83 ec 04             	sub    $0x4,%esp
80105199:	ff 73 04             	push   0x4(%ebx)
8010519c:	68 cb 7f 10 80       	push   $0x80107fcb
801051a1:	56                   	push   %esi
801051a2:	e8 b9 ce ff ff       	call   80102060 <dirlink>
801051a7:	83 c4 10             	add    $0x10,%esp
801051aa:	85 c0                	test   %eax,%eax
801051ac:	79 92                	jns    80105140 <create+0xe0>
      panic("create dots");
801051ae:	83 ec 0c             	sub    $0xc,%esp
801051b1:	68 bf 7f 10 80       	push   $0x80107fbf
801051b6:	e8 c5 b1 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
801051bb:	83 ec 0c             	sub    $0xc,%esp
801051be:	68 ce 7f 10 80       	push   $0x80107fce
801051c3:	e8 b8 b1 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801051c8:	83 ec 0c             	sub    $0xc,%esp
801051cb:	68 b0 7f 10 80       	push   $0x80107fb0
801051d0:	e8 ab b1 ff ff       	call   80100380 <panic>
801051d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_dup>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051eb:	50                   	push   %eax
801051ec:	6a 00                	push   $0x0
801051ee:	e8 bd fc ff ff       	call   80104eb0 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 36                	js     80105230 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051fe:	77 30                	ja     80105230 <sys_dup+0x50>
80105200:	e8 8b e8 ff ff       	call   80103a90 <myproc>
80105205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105208:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010520c:	85 f6                	test   %esi,%esi
8010520e:	74 20                	je     80105230 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105210:	e8 7b e8 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105215:	31 db                	xor    %ebx,%ebx
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105220:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105224:	85 d2                	test   %edx,%edx
80105226:	74 18                	je     80105240 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105228:	83 c3 01             	add    $0x1,%ebx
8010522b:	83 fb 10             	cmp    $0x10,%ebx
8010522e:	75 f0                	jne    80105220 <sys_dup+0x40>
}
80105230:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105233:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105238:	89 d8                	mov    %ebx,%eax
8010523a:	5b                   	pop    %ebx
8010523b:	5e                   	pop    %esi
8010523c:	5d                   	pop    %ebp
8010523d:	c3                   	ret
8010523e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105240:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105243:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105247:	56                   	push   %esi
80105248:	e8 a3 bc ff ff       	call   80100ef0 <filedup>
  return fd;
8010524d:	83 c4 10             	add    $0x10,%esp
}
80105250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105253:	89 d8                	mov    %ebx,%eax
80105255:	5b                   	pop    %ebx
80105256:	5e                   	pop    %esi
80105257:	5d                   	pop    %ebp
80105258:	c3                   	ret
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_read>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105265:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105268:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010526b:	53                   	push   %ebx
8010526c:	6a 00                	push   $0x0
8010526e:	e8 3d fc ff ff       	call   80104eb0 <argint>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 5e                	js     801052d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010527a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010527e:	77 58                	ja     801052d8 <sys_read+0x78>
80105280:	e8 0b e8 ff ff       	call   80103a90 <myproc>
80105285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105288:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010528c:	85 f6                	test   %esi,%esi
8010528e:	74 48                	je     801052d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105290:	83 ec 08             	sub    $0x8,%esp
80105293:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105296:	50                   	push   %eax
80105297:	6a 02                	push   $0x2
80105299:	e8 12 fc ff ff       	call   80104eb0 <argint>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 33                	js     801052d8 <sys_read+0x78>
801052a5:	83 ec 04             	sub    $0x4,%esp
801052a8:	ff 75 f0             	push   -0x10(%ebp)
801052ab:	53                   	push   %ebx
801052ac:	6a 01                	push   $0x1
801052ae:	e8 4d fc ff ff       	call   80104f00 <argptr>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	78 1e                	js     801052d8 <sys_read+0x78>
  return fileread(f, p, n);
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	ff 75 f0             	push   -0x10(%ebp)
801052c0:	ff 75 f4             	push   -0xc(%ebp)
801052c3:	56                   	push   %esi
801052c4:	e8 a7 bd ff ff       	call   80101070 <fileread>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052cf:	5b                   	pop    %ebx
801052d0:	5e                   	pop    %esi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret
801052d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d7:	90                   	nop
    return -1;
801052d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052dd:	eb ed                	jmp    801052cc <sys_read+0x6c>
801052df:	90                   	nop

801052e0 <sys_write>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052eb:	53                   	push   %ebx
801052ec:	6a 00                	push   $0x0
801052ee:	e8 bd fb ff ff       	call   80104eb0 <argint>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 5e                	js     80105358 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052fe:	77 58                	ja     80105358 <sys_write+0x78>
80105300:	e8 8b e7 ff ff       	call   80103a90 <myproc>
80105305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105308:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010530c:	85 f6                	test   %esi,%esi
8010530e:	74 48                	je     80105358 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105310:	83 ec 08             	sub    $0x8,%esp
80105313:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105316:	50                   	push   %eax
80105317:	6a 02                	push   $0x2
80105319:	e8 92 fb ff ff       	call   80104eb0 <argint>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	78 33                	js     80105358 <sys_write+0x78>
80105325:	83 ec 04             	sub    $0x4,%esp
80105328:	ff 75 f0             	push   -0x10(%ebp)
8010532b:	53                   	push   %ebx
8010532c:	6a 01                	push   $0x1
8010532e:	e8 cd fb ff ff       	call   80104f00 <argptr>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 1e                	js     80105358 <sys_write+0x78>
  return filewrite(f, p, n);
8010533a:	83 ec 04             	sub    $0x4,%esp
8010533d:	ff 75 f0             	push   -0x10(%ebp)
80105340:	ff 75 f4             	push   -0xc(%ebp)
80105343:	56                   	push   %esi
80105344:	e8 b7 bd ff ff       	call   80101100 <filewrite>
80105349:	83 c4 10             	add    $0x10,%esp
}
8010534c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010534f:	5b                   	pop    %ebx
80105350:	5e                   	pop    %esi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret
80105353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105357:	90                   	nop
    return -1;
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	eb ed                	jmp    8010534c <sys_write+0x6c>
8010535f:	90                   	nop

80105360 <sys_close>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	56                   	push   %esi
80105364:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105365:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105368:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010536b:	50                   	push   %eax
8010536c:	6a 00                	push   $0x0
8010536e:	e8 3d fb ff ff       	call   80104eb0 <argint>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	78 3e                	js     801053b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010537a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010537e:	77 38                	ja     801053b8 <sys_close+0x58>
80105380:	e8 0b e7 ff ff       	call   80103a90 <myproc>
80105385:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105388:	8d 5a 08             	lea    0x8(%edx),%ebx
8010538b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010538f:	85 f6                	test   %esi,%esi
80105391:	74 25                	je     801053b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105393:	e8 f8 e6 ff ff       	call   80103a90 <myproc>
  fileclose(f);
80105398:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010539b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801053a2:	00 
  fileclose(f);
801053a3:	56                   	push   %esi
801053a4:	e8 97 bb ff ff       	call   80100f40 <fileclose>
  return 0;
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5d                   	pop    %ebp
801053b4:	c3                   	ret
801053b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bd:	eb ef                	jmp    801053ae <sys_close+0x4e>
801053bf:	90                   	nop

801053c0 <sys_fstat>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053cb:	53                   	push   %ebx
801053cc:	6a 00                	push   $0x0
801053ce:	e8 dd fa ff ff       	call   80104eb0 <argint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 46                	js     80105420 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053de:	77 40                	ja     80105420 <sys_fstat+0x60>
801053e0:	e8 ab e6 ff ff       	call   80103a90 <myproc>
801053e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053ec:	85 f6                	test   %esi,%esi
801053ee:	74 30                	je     80105420 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053f0:	83 ec 04             	sub    $0x4,%esp
801053f3:	6a 14                	push   $0x14
801053f5:	53                   	push   %ebx
801053f6:	6a 01                	push   $0x1
801053f8:	e8 03 fb ff ff       	call   80104f00 <argptr>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	78 1c                	js     80105420 <sys_fstat+0x60>
  return filestat(f, st);
80105404:	83 ec 08             	sub    $0x8,%esp
80105407:	ff 75 f4             	push   -0xc(%ebp)
8010540a:	56                   	push   %esi
8010540b:	e8 10 bc ff ff       	call   80101020 <filestat>
80105410:	83 c4 10             	add    $0x10,%esp
}
80105413:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105416:	5b                   	pop    %ebx
80105417:	5e                   	pop    %esi
80105418:	5d                   	pop    %ebp
80105419:	c3                   	ret
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105425:	eb ec                	jmp    80105413 <sys_fstat+0x53>
80105427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542e:	66 90                	xchg   %ax,%ax

80105430 <sys_link>:
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105435:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105438:	53                   	push   %ebx
80105439:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 2c fb ff ff       	call   80104f70 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 fb 00 00 00    	js     8010554a <sys_link+0x11a>
8010544f:	83 ec 08             	sub    $0x8,%esp
80105452:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105455:	50                   	push   %eax
80105456:	6a 01                	push   $0x1
80105458:	e8 13 fb ff ff       	call   80104f70 <argstr>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	0f 88 e2 00 00 00    	js     8010554a <sys_link+0x11a>
  begin_op();
80105468:	e8 83 d9 ff ff       	call   80102df0 <begin_op>
  if((ip = namei(old)) == 0){
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	ff 75 d4             	push   -0x2c(%ebp)
80105473:	e8 a8 cc ff ff       	call   80102120 <namei>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	89 c3                	mov    %eax,%ebx
8010547d:	85 c0                	test   %eax,%eax
8010547f:	0f 84 df 00 00 00    	je     80105564 <sys_link+0x134>
  ilock(ip);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	50                   	push   %eax
80105489:	e8 62 c3 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105496:	0f 84 b5 00 00 00    	je     80105551 <sys_link+0x121>
  iupdate(ip);
8010549c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010549f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801054a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054a7:	53                   	push   %ebx
801054a8:	e8 93 c2 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
801054ad:	89 1c 24             	mov    %ebx,(%esp)
801054b0:	e8 1b c4 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054b5:	58                   	pop    %eax
801054b6:	5a                   	pop    %edx
801054b7:	57                   	push   %edi
801054b8:	ff 75 d0             	push   -0x30(%ebp)
801054bb:	e8 80 cc ff ff       	call   80102140 <nameiparent>
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	89 c6                	mov    %eax,%esi
801054c5:	85 c0                	test   %eax,%eax
801054c7:	74 5b                	je     80105524 <sys_link+0xf4>
  ilock(dp);
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	50                   	push   %eax
801054cd:	e8 1e c3 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054d2:	8b 03                	mov    (%ebx),%eax
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	39 06                	cmp    %eax,(%esi)
801054d9:	75 3d                	jne    80105518 <sys_link+0xe8>
801054db:	83 ec 04             	sub    $0x4,%esp
801054de:	ff 73 04             	push   0x4(%ebx)
801054e1:	57                   	push   %edi
801054e2:	56                   	push   %esi
801054e3:	e8 78 cb ff ff       	call   80102060 <dirlink>
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	85 c0                	test   %eax,%eax
801054ed:	78 29                	js     80105518 <sys_link+0xe8>
  iunlockput(dp);
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	56                   	push   %esi
801054f3:	e8 88 c5 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
801054f8:	89 1c 24             	mov    %ebx,(%esp)
801054fb:	e8 20 c4 ff ff       	call   80101920 <iput>
  end_op();
80105500:	e8 5b d9 ff ff       	call   80102e60 <end_op>
  return 0;
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	31 c0                	xor    %eax,%eax
}
8010550a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010550d:	5b                   	pop    %ebx
8010550e:	5e                   	pop    %esi
8010550f:	5f                   	pop    %edi
80105510:	5d                   	pop    %ebp
80105511:	c3                   	ret
80105512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105518:	83 ec 0c             	sub    $0xc,%esp
8010551b:	56                   	push   %esi
8010551c:	e8 5f c5 ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105521:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105524:	83 ec 0c             	sub    $0xc,%esp
80105527:	53                   	push   %ebx
80105528:	e8 c3 c2 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
8010552d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105532:	89 1c 24             	mov    %ebx,(%esp)
80105535:	e8 06 c2 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
8010553a:	89 1c 24             	mov    %ebx,(%esp)
8010553d:	e8 3e c5 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105542:	e8 19 d9 ff ff       	call   80102e60 <end_op>
  return -1;
80105547:	83 c4 10             	add    $0x10,%esp
    return -1;
8010554a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554f:	eb b9                	jmp    8010550a <sys_link+0xda>
    iunlockput(ip);
80105551:	83 ec 0c             	sub    $0xc,%esp
80105554:	53                   	push   %ebx
80105555:	e8 26 c5 ff ff       	call   80101a80 <iunlockput>
    end_op();
8010555a:	e8 01 d9 ff ff       	call   80102e60 <end_op>
    return -1;
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	eb e6                	jmp    8010554a <sys_link+0x11a>
    end_op();
80105564:	e8 f7 d8 ff ff       	call   80102e60 <end_op>
    return -1;
80105569:	eb df                	jmp    8010554a <sys_link+0x11a>
8010556b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop

80105570 <sys_unlink>:
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105575:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105578:	53                   	push   %ebx
80105579:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010557c:	50                   	push   %eax
8010557d:	6a 00                	push   $0x0
8010557f:	e8 ec f9 ff ff       	call   80104f70 <argstr>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	85 c0                	test   %eax,%eax
80105589:	0f 88 54 01 00 00    	js     801056e3 <sys_unlink+0x173>
  begin_op();
8010558f:	e8 5c d8 ff ff       	call   80102df0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105594:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105597:	83 ec 08             	sub    $0x8,%esp
8010559a:	53                   	push   %ebx
8010559b:	ff 75 c0             	push   -0x40(%ebp)
8010559e:	e8 9d cb ff ff       	call   80102140 <nameiparent>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801055a9:	85 c0                	test   %eax,%eax
801055ab:	0f 84 58 01 00 00    	je     80105709 <sys_unlink+0x199>
  ilock(dp);
801055b1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	57                   	push   %edi
801055b8:	e8 33 c2 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055bd:	58                   	pop    %eax
801055be:	5a                   	pop    %edx
801055bf:	68 cc 7f 10 80       	push   $0x80107fcc
801055c4:	53                   	push   %ebx
801055c5:	e8 66 c7 ff ff       	call   80101d30 <namecmp>
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	85 c0                	test   %eax,%eax
801055cf:	0f 84 fb 00 00 00    	je     801056d0 <sys_unlink+0x160>
801055d5:	83 ec 08             	sub    $0x8,%esp
801055d8:	68 cb 7f 10 80       	push   $0x80107fcb
801055dd:	53                   	push   %ebx
801055de:	e8 4d c7 ff ff       	call   80101d30 <namecmp>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	0f 84 e2 00 00 00    	je     801056d0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801055ee:	83 ec 04             	sub    $0x4,%esp
801055f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801055f4:	50                   	push   %eax
801055f5:	53                   	push   %ebx
801055f6:	57                   	push   %edi
801055f7:	e8 54 c7 ff ff       	call   80101d50 <dirlookup>
801055fc:	83 c4 10             	add    $0x10,%esp
801055ff:	89 c3                	mov    %eax,%ebx
80105601:	85 c0                	test   %eax,%eax
80105603:	0f 84 c7 00 00 00    	je     801056d0 <sys_unlink+0x160>
  ilock(ip);
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	50                   	push   %eax
8010560d:	e8 de c1 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010561a:	0f 8e 0a 01 00 00    	jle    8010572a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105620:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105625:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105628:	74 66                	je     80105690 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010562a:	83 ec 04             	sub    $0x4,%esp
8010562d:	6a 10                	push   $0x10
8010562f:	6a 00                	push   $0x0
80105631:	57                   	push   %edi
80105632:	e8 c9 f5 ff ff       	call   80104c00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105637:	6a 10                	push   $0x10
80105639:	ff 75 c4             	push   -0x3c(%ebp)
8010563c:	57                   	push   %edi
8010563d:	ff 75 b4             	push   -0x4c(%ebp)
80105640:	e8 bb c5 ff ff       	call   80101c00 <writei>
80105645:	83 c4 20             	add    $0x20,%esp
80105648:	83 f8 10             	cmp    $0x10,%eax
8010564b:	0f 85 cc 00 00 00    	jne    8010571d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105651:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105656:	0f 84 94 00 00 00    	je     801056f0 <sys_unlink+0x180>
  iunlockput(dp);
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	ff 75 b4             	push   -0x4c(%ebp)
80105662:	e8 19 c4 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105667:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010566c:	89 1c 24             	mov    %ebx,(%esp)
8010566f:	e8 cc c0 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105674:	89 1c 24             	mov    %ebx,(%esp)
80105677:	e8 04 c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010567c:	e8 df d7 ff ff       	call   80102e60 <end_op>
  return 0;
80105681:	83 c4 10             	add    $0x10,%esp
80105684:	31 c0                	xor    %eax,%eax
}
80105686:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105689:	5b                   	pop    %ebx
8010568a:	5e                   	pop    %esi
8010568b:	5f                   	pop    %edi
8010568c:	5d                   	pop    %ebp
8010568d:	c3                   	ret
8010568e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105690:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105694:	76 94                	jbe    8010562a <sys_unlink+0xba>
80105696:	be 20 00 00 00       	mov    $0x20,%esi
8010569b:	eb 0b                	jmp    801056a8 <sys_unlink+0x138>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
801056a0:	83 c6 10             	add    $0x10,%esi
801056a3:	3b 73 58             	cmp    0x58(%ebx),%esi
801056a6:	73 82                	jae    8010562a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056a8:	6a 10                	push   $0x10
801056aa:	56                   	push   %esi
801056ab:	57                   	push   %edi
801056ac:	53                   	push   %ebx
801056ad:	e8 4e c4 ff ff       	call   80101b00 <readi>
801056b2:	83 c4 10             	add    $0x10,%esp
801056b5:	83 f8 10             	cmp    $0x10,%eax
801056b8:	75 56                	jne    80105710 <sys_unlink+0x1a0>
    if(de.inum != 0)
801056ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056bf:	74 df                	je     801056a0 <sys_unlink+0x130>
    iunlockput(ip);
801056c1:	83 ec 0c             	sub    $0xc,%esp
801056c4:	53                   	push   %ebx
801056c5:	e8 b6 c3 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	ff 75 b4             	push   -0x4c(%ebp)
801056d6:	e8 a5 c3 ff ff       	call   80101a80 <iunlockput>
  end_op();
801056db:	e8 80 d7 ff ff       	call   80102e60 <end_op>
  return -1;
801056e0:	83 c4 10             	add    $0x10,%esp
    return -1;
801056e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e8:	eb 9c                	jmp    80105686 <sys_unlink+0x116>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801056f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801056f3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801056f6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801056fb:	50                   	push   %eax
801056fc:	e8 3f c0 ff ff       	call   80101740 <iupdate>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	e9 53 ff ff ff       	jmp    8010565c <sys_unlink+0xec>
    end_op();
80105709:	e8 52 d7 ff ff       	call   80102e60 <end_op>
    return -1;
8010570e:	eb d3                	jmp    801056e3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	68 f0 7f 10 80       	push   $0x80107ff0
80105718:	e8 63 ac ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	68 02 80 10 80       	push   $0x80108002
80105725:	e8 56 ac ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010572a:	83 ec 0c             	sub    $0xc,%esp
8010572d:	68 de 7f 10 80       	push   $0x80107fde
80105732:	e8 49 ac ff ff       	call   80100380 <panic>
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax

80105740 <sys_open>:

int
sys_open(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105745:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105748:	53                   	push   %ebx
80105749:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010574c:	50                   	push   %eax
8010574d:	6a 00                	push   $0x0
8010574f:	e8 1c f8 ff ff       	call   80104f70 <argstr>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	0f 88 8e 00 00 00    	js     801057ed <sys_open+0xad>
8010575f:	83 ec 08             	sub    $0x8,%esp
80105762:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105765:	50                   	push   %eax
80105766:	6a 01                	push   $0x1
80105768:	e8 43 f7 ff ff       	call   80104eb0 <argint>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	85 c0                	test   %eax,%eax
80105772:	78 79                	js     801057ed <sys_open+0xad>
    return -1;

  begin_op();
80105774:	e8 77 d6 ff ff       	call   80102df0 <begin_op>

  if(omode & O_CREATE){
80105779:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010577d:	75 79                	jne    801057f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010577f:	83 ec 0c             	sub    $0xc,%esp
80105782:	ff 75 e0             	push   -0x20(%ebp)
80105785:	e8 96 c9 ff ff       	call   80102120 <namei>
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	89 c6                	mov    %eax,%esi
8010578f:	85 c0                	test   %eax,%eax
80105791:	0f 84 7e 00 00 00    	je     80105815 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105797:	83 ec 0c             	sub    $0xc,%esp
8010579a:	50                   	push   %eax
8010579b:	e8 50 c0 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057a0:	83 c4 10             	add    $0x10,%esp
801057a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057a8:	0f 84 ba 00 00 00    	je     80105868 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ae:	e8 cd b6 ff ff       	call   80100e80 <filealloc>
801057b3:	89 c7                	mov    %eax,%edi
801057b5:	85 c0                	test   %eax,%eax
801057b7:	74 23                	je     801057dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801057b9:	e8 d2 e2 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057c4:	85 d2                	test   %edx,%edx
801057c6:	74 58                	je     80105820 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801057c8:	83 c3 01             	add    $0x1,%ebx
801057cb:	83 fb 10             	cmp    $0x10,%ebx
801057ce:	75 f0                	jne    801057c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	57                   	push   %edi
801057d4:	e8 67 b7 ff ff       	call   80100f40 <fileclose>
801057d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057dc:	83 ec 0c             	sub    $0xc,%esp
801057df:	56                   	push   %esi
801057e0:	e8 9b c2 ff ff       	call   80101a80 <iunlockput>
    end_op();
801057e5:	e8 76 d6 ff ff       	call   80102e60 <end_op>
    return -1;
801057ea:	83 c4 10             	add    $0x10,%esp
    return -1;
801057ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057f2:	eb 65                	jmp    80105859 <sys_open+0x119>
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	31 c9                	xor    %ecx,%ecx
801057fd:	ba 02 00 00 00       	mov    $0x2,%edx
80105802:	6a 00                	push   $0x0
80105804:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105807:	e8 54 f8 ff ff       	call   80105060 <create>
    if(ip == 0){
8010580c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010580f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105811:	85 c0                	test   %eax,%eax
80105813:	75 99                	jne    801057ae <sys_open+0x6e>
      end_op();
80105815:	e8 46 d6 ff ff       	call   80102e60 <end_op>
      return -1;
8010581a:	eb d1                	jmp    801057ed <sys_open+0xad>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105823:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105827:	56                   	push   %esi
80105828:	e8 a3 c0 ff ff       	call   801018d0 <iunlock>
  end_op();
8010582d:	e8 2e d6 ff ff       	call   80102e60 <end_op>

  f->type = FD_INODE;
80105832:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105838:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010583b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010583e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105841:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105843:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010584a:	f7 d0                	not    %eax
8010584c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010584f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105852:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105855:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010585c:	89 d8                	mov    %ebx,%eax
8010585e:	5b                   	pop    %ebx
8010585f:	5e                   	pop    %esi
80105860:	5f                   	pop    %edi
80105861:	5d                   	pop    %ebp
80105862:	c3                   	ret
80105863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105867:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105868:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010586b:	85 c9                	test   %ecx,%ecx
8010586d:	0f 84 3b ff ff ff    	je     801057ae <sys_open+0x6e>
80105873:	e9 64 ff ff ff       	jmp    801057dc <sys_open+0x9c>
80105878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop

80105880 <sys_mkdir>:

int
sys_mkdir(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105886:	e8 65 d5 ff ff       	call   80102df0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105891:	50                   	push   %eax
80105892:	6a 00                	push   $0x0
80105894:	e8 d7 f6 ff ff       	call   80104f70 <argstr>
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	85 c0                	test   %eax,%eax
8010589e:	78 30                	js     801058d0 <sys_mkdir+0x50>
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	31 c9                	xor    %ecx,%ecx
801058a5:	ba 01 00 00 00       	mov    $0x1,%edx
801058aa:	6a 00                	push   $0x0
801058ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058af:	e8 ac f7 ff ff       	call   80105060 <create>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	74 15                	je     801058d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058bb:	83 ec 0c             	sub    $0xc,%esp
801058be:	50                   	push   %eax
801058bf:	e8 bc c1 ff ff       	call   80101a80 <iunlockput>
  end_op();
801058c4:	e8 97 d5 ff ff       	call   80102e60 <end_op>
  return 0;
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	31 c0                	xor    %eax,%eax
}
801058ce:	c9                   	leave
801058cf:	c3                   	ret
    end_op();
801058d0:	e8 8b d5 ff ff       	call   80102e60 <end_op>
    return -1;
801058d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058da:	c9                   	leave
801058db:	c3                   	ret
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_mknod>:

int
sys_mknod(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058e6:	e8 05 d5 ff ff       	call   80102df0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058f1:	50                   	push   %eax
801058f2:	6a 00                	push   $0x0
801058f4:	e8 77 f6 ff ff       	call   80104f70 <argstr>
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	85 c0                	test   %eax,%eax
801058fe:	78 60                	js     80105960 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105906:	50                   	push   %eax
80105907:	6a 01                	push   $0x1
80105909:	e8 a2 f5 ff ff       	call   80104eb0 <argint>
  if((argstr(0, &path)) < 0 ||
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	85 c0                	test   %eax,%eax
80105913:	78 4b                	js     80105960 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105915:	83 ec 08             	sub    $0x8,%esp
80105918:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591b:	50                   	push   %eax
8010591c:	6a 02                	push   $0x2
8010591e:	e8 8d f5 ff ff       	call   80104eb0 <argint>
     argint(1, &major) < 0 ||
80105923:	83 c4 10             	add    $0x10,%esp
80105926:	85 c0                	test   %eax,%eax
80105928:	78 36                	js     80105960 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010592a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010592e:	83 ec 0c             	sub    $0xc,%esp
80105931:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105935:	ba 03 00 00 00       	mov    $0x3,%edx
8010593a:	50                   	push   %eax
8010593b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010593e:	e8 1d f7 ff ff       	call   80105060 <create>
     argint(2, &minor) < 0 ||
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	74 16                	je     80105960 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010594a:	83 ec 0c             	sub    $0xc,%esp
8010594d:	50                   	push   %eax
8010594e:	e8 2d c1 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105953:	e8 08 d5 ff ff       	call   80102e60 <end_op>
  return 0;
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	31 c0                	xor    %eax,%eax
}
8010595d:	c9                   	leave
8010595e:	c3                   	ret
8010595f:	90                   	nop
    end_op();
80105960:	e8 fb d4 ff ff       	call   80102e60 <end_op>
    return -1;
80105965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010596a:	c9                   	leave
8010596b:	c3                   	ret
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_chdir>:

int
sys_chdir(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	56                   	push   %esi
80105974:	53                   	push   %ebx
80105975:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105978:	e8 13 e1 ff ff       	call   80103a90 <myproc>
8010597d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010597f:	e8 6c d4 ff ff       	call   80102df0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105984:	83 ec 08             	sub    $0x8,%esp
80105987:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010598a:	50                   	push   %eax
8010598b:	6a 00                	push   $0x0
8010598d:	e8 de f5 ff ff       	call   80104f70 <argstr>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	78 77                	js     80105a10 <sys_chdir+0xa0>
80105999:	83 ec 0c             	sub    $0xc,%esp
8010599c:	ff 75 f4             	push   -0xc(%ebp)
8010599f:	e8 7c c7 ff ff       	call   80102120 <namei>
801059a4:	83 c4 10             	add    $0x10,%esp
801059a7:	89 c3                	mov    %eax,%ebx
801059a9:	85 c0                	test   %eax,%eax
801059ab:	74 63                	je     80105a10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	50                   	push   %eax
801059b1:	e8 3a be ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059be:	75 30                	jne    801059f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	53                   	push   %ebx
801059c4:	e8 07 bf ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
801059c9:	58                   	pop    %eax
801059ca:	ff 76 68             	push   0x68(%esi)
801059cd:	e8 4e bf ff ff       	call   80101920 <iput>
  end_op();
801059d2:	e8 89 d4 ff ff       	call   80102e60 <end_op>
  curproc->cwd = ip;
801059d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	31 c0                	xor    %eax,%eax
}
801059df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059e2:	5b                   	pop    %ebx
801059e3:	5e                   	pop    %esi
801059e4:	5d                   	pop    %ebp
801059e5:	c3                   	ret
801059e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	53                   	push   %ebx
801059f4:	e8 87 c0 ff ff       	call   80101a80 <iunlockput>
    end_op();
801059f9:	e8 62 d4 ff ff       	call   80102e60 <end_op>
    return -1;
801059fe:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a06:	eb d7                	jmp    801059df <sys_chdir+0x6f>
80105a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
    end_op();
80105a10:	e8 4b d4 ff ff       	call   80102e60 <end_op>
    return -1;
80105a15:	eb ea                	jmp    80105a01 <sys_chdir+0x91>
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_exec>:

int
sys_exec(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a25:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a2b:	53                   	push   %ebx
80105a2c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a32:	50                   	push   %eax
80105a33:	6a 00                	push   $0x0
80105a35:	e8 36 f5 ff ff       	call   80104f70 <argstr>
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	0f 88 87 00 00 00    	js     80105acc <sys_exec+0xac>
80105a45:	83 ec 08             	sub    $0x8,%esp
80105a48:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a4e:	50                   	push   %eax
80105a4f:	6a 01                	push   $0x1
80105a51:	e8 5a f4 ff ff       	call   80104eb0 <argint>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	78 6f                	js     80105acc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a5d:	83 ec 04             	sub    $0x4,%esp
80105a60:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105a66:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a68:	68 80 00 00 00       	push   $0x80
80105a6d:	6a 00                	push   $0x0
80105a6f:	56                   	push   %esi
80105a70:	e8 8b f1 ff ff       	call   80104c00 <memset>
80105a75:	83 c4 10             	add    $0x10,%esp
80105a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a80:	83 ec 08             	sub    $0x8,%esp
80105a83:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105a89:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105a90:	50                   	push   %eax
80105a91:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a97:	01 f8                	add    %edi,%eax
80105a99:	50                   	push   %eax
80105a9a:	e8 81 f3 ff ff       	call   80104e20 <fetchint>
80105a9f:	83 c4 10             	add    $0x10,%esp
80105aa2:	85 c0                	test   %eax,%eax
80105aa4:	78 26                	js     80105acc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105aa6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105aac:	85 c0                	test   %eax,%eax
80105aae:	74 30                	je     80105ae0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105ab6:	52                   	push   %edx
80105ab7:	50                   	push   %eax
80105ab8:	e8 a3 f3 ff ff       	call   80104e60 <fetchstr>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	78 08                	js     80105acc <sys_exec+0xac>
  for(i=0;; i++){
80105ac4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ac7:	83 fb 20             	cmp    $0x20,%ebx
80105aca:	75 b4                	jne    80105a80 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad4:	5b                   	pop    %ebx
80105ad5:	5e                   	pop    %esi
80105ad6:	5f                   	pop    %edi
80105ad7:	5d                   	pop    %ebp
80105ad8:	c3                   	ret
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105ae0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ae7:	00 00 00 00 
  return exec(path, argv);
80105aeb:	83 ec 08             	sub    $0x8,%esp
80105aee:	56                   	push   %esi
80105aef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105af5:	e8 e6 af ff ff       	call   80100ae0 <exec>
80105afa:	83 c4 10             	add    $0x10,%esp
}
80105afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b00:	5b                   	pop    %ebx
80105b01:	5e                   	pop    %esi
80105b02:	5f                   	pop    %edi
80105b03:	5d                   	pop    %ebp
80105b04:	c3                   	ret
80105b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_pipe>:

int
sys_pipe(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b15:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b18:	53                   	push   %ebx
80105b19:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b1c:	6a 08                	push   $0x8
80105b1e:	50                   	push   %eax
80105b1f:	6a 00                	push   $0x0
80105b21:	e8 da f3 ff ff       	call   80104f00 <argptr>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	0f 88 8b 00 00 00    	js     80105bbc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b31:	83 ec 08             	sub    $0x8,%esp
80105b34:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b37:	50                   	push   %eax
80105b38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b3b:	50                   	push   %eax
80105b3c:	e8 7f d9 ff ff       	call   801034c0 <pipealloc>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	78 74                	js     80105bbc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b48:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b4b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b4d:	e8 3e df ff ff       	call   80103a90 <myproc>
    if(curproc->ofile[fd] == 0){
80105b52:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b56:	85 f6                	test   %esi,%esi
80105b58:	74 16                	je     80105b70 <sys_pipe+0x60>
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b60:	83 c3 01             	add    $0x1,%ebx
80105b63:	83 fb 10             	cmp    $0x10,%ebx
80105b66:	74 3d                	je     80105ba5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105b68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b6c:	85 f6                	test   %esi,%esi
80105b6e:	75 f0                	jne    80105b60 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b70:	8d 73 08             	lea    0x8(%ebx),%esi
80105b73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b7a:	e8 11 df ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b7f:	31 d2                	xor    %edx,%edx
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b8c:	85 c9                	test   %ecx,%ecx
80105b8e:	74 38                	je     80105bc8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105b90:	83 c2 01             	add    $0x1,%edx
80105b93:	83 fa 10             	cmp    $0x10,%edx
80105b96:	75 f0                	jne    80105b88 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b98:	e8 f3 de ff ff       	call   80103a90 <myproc>
80105b9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ba4:	00 
    fileclose(rf);
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	ff 75 e0             	push   -0x20(%ebp)
80105bab:	e8 90 b3 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105bb0:	58                   	pop    %eax
80105bb1:	ff 75 e4             	push   -0x1c(%ebp)
80105bb4:	e8 87 b3 ff ff       	call   80100f40 <fileclose>
    return -1;
80105bb9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc1:	eb 16                	jmp    80105bd9 <sys_pipe+0xc9>
80105bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc7:	90                   	nop
      curproc->ofile[fd] = f;
80105bc8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105bcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bcf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105bd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bd4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105bd7:	31 c0                	xor    %eax,%eax
}
80105bd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bdc:	5b                   	pop    %ebx
80105bdd:	5e                   	pop    %esi
80105bde:	5f                   	pop    %edi
80105bdf:	5d                   	pop    %ebp
80105be0:	c3                   	ret
80105be1:	66 90                	xchg   %ax,%ax
80105be3:	66 90                	xchg   %ax,%ax
80105be5:	66 90                	xchg   %ax,%ax
80105be7:	66 90                	xchg   %ax,%ax
80105be9:	66 90                	xchg   %ax,%ax
80105beb:	66 90                	xchg   %ax,%ax
80105bed:	66 90                	xchg   %ax,%ax
80105bef:	90                   	nop

80105bf0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105bf0:	e9 bb e6 ff ff       	jmp    801042b0 <fork>
80105bf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_exit>:
}

int
sys_exit(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c06:	e8 45 e4 ff ff       	call   80104050 <exit>
  return 0;  // not reached
}
80105c0b:	31 c0                	xor    %eax,%eax
80105c0d:	c9                   	leave
80105c0e:	c3                   	ret
80105c0f:	90                   	nop

80105c10 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105c10:	e9 6b e5 ff ff       	jmp    80104180 <wait>
80105c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c20 <sys_kill>:
}

int
sys_kill(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c29:	50                   	push   %eax
80105c2a:	6a 00                	push   $0x0
80105c2c:	e8 7f f2 ff ff       	call   80104eb0 <argint>
80105c31:	83 c4 10             	add    $0x10,%esp
80105c34:	85 c0                	test   %eax,%eax
80105c36:	78 18                	js     80105c50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c38:	83 ec 0c             	sub    $0xc,%esp
80105c3b:	ff 75 f4             	push   -0xc(%ebp)
80105c3e:	e8 bd ea ff ff       	call   80104700 <kill>
80105c43:	83 c4 10             	add    $0x10,%esp
}
80105c46:	c9                   	leave
80105c47:	c3                   	ret
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
80105c50:	c9                   	leave
    return -1;
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c56:	c3                   	ret
80105c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <sys_getpid>:

int
sys_getpid(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c66:	e8 25 de ff ff       	call   80103a90 <myproc>
80105c6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c6e:	c9                   	leave
80105c6f:	c3                   	ret

80105c70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 2e f2 ff ff       	call   80104eb0 <argint>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 27                	js     80105cb0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c89:	e8 02 de ff ff       	call   80103a90 <myproc>
  if(growproc(n) < 0)
80105c8e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c91:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c93:	ff 75 f4             	push   -0xc(%ebp)
80105c96:	e8 15 df ff ff       	call   80103bb0 <growproc>
80105c9b:	83 c4 10             	add    $0x10,%esp
80105c9e:	85 c0                	test   %eax,%eax
80105ca0:	78 0e                	js     80105cb0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ca2:	89 d8                	mov    %ebx,%eax
80105ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca7:	c9                   	leave
80105ca8:	c3                   	ret
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cb5:	eb eb                	jmp    80105ca2 <sys_sbrk+0x32>
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_sleep>:

int
sys_sleep(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cca:	50                   	push   %eax
80105ccb:	6a 00                	push   $0x0
80105ccd:	e8 de f1 ff ff       	call   80104eb0 <argint>
80105cd2:	83 c4 10             	add    $0x10,%esp
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	78 64                	js     80105d3d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105cd9:	83 ec 0c             	sub    $0xc,%esp
80105cdc:	68 a0 50 11 80       	push   $0x801150a0
80105ce1:	e8 8a ed ff ff       	call   80104a70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ce9:	8b 1d 80 50 11 80    	mov    0x80115080,%ebx
  while(ticks - ticks0 < n){
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	85 d2                	test   %edx,%edx
80105cf4:	75 2b                	jne    80105d21 <sys_sleep+0x61>
80105cf6:	eb 58                	jmp    80105d50 <sys_sleep+0x90>
80105cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d00:	83 ec 08             	sub    $0x8,%esp
80105d03:	68 a0 50 11 80       	push   $0x801150a0
80105d08:	68 80 50 11 80       	push   $0x80115080
80105d0d:	e8 ce e8 ff ff       	call   801045e0 <sleep>
  while(ticks - ticks0 < n){
80105d12:	a1 80 50 11 80       	mov    0x80115080,%eax
80105d17:	83 c4 10             	add    $0x10,%esp
80105d1a:	29 d8                	sub    %ebx,%eax
80105d1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d1f:	73 2f                	jae    80105d50 <sys_sleep+0x90>
    if(myproc()->killed){
80105d21:	e8 6a dd ff ff       	call   80103a90 <myproc>
80105d26:	8b 40 24             	mov    0x24(%eax),%eax
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 d3                	je     80105d00 <sys_sleep+0x40>
      release(&tickslock);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	68 a0 50 11 80       	push   $0x801150a0
80105d35:	e8 76 ee ff ff       	call   80104bb0 <release>
      return -1;
80105d3a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105d3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d45:	c9                   	leave
80105d46:	c3                   	ret
80105d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	68 a0 50 11 80       	push   $0x801150a0
80105d58:	e8 53 ee ff ff       	call   80104bb0 <release>
}
80105d5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105d60:	83 c4 10             	add    $0x10,%esp
80105d63:	31 c0                	xor    %eax,%eax
}
80105d65:	c9                   	leave
80105d66:	c3                   	ret
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
80105d74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d77:	68 a0 50 11 80       	push   $0x801150a0
80105d7c:	e8 ef ec ff ff       	call   80104a70 <acquire>
  xticks = ticks;
80105d81:	8b 1d 80 50 11 80    	mov    0x80115080,%ebx
  release(&tickslock);
80105d87:	c7 04 24 a0 50 11 80 	movl   $0x801150a0,(%esp)
80105d8e:	e8 1d ee ff ff       	call   80104bb0 <release>
  return xticks;
}
80105d93:	89 d8                	mov    %ebx,%eax
80105d95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d98:	c9                   	leave
80105d99:	c3                   	ret
80105d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105da0 <sys_shutdown>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105da0:	b8 00 20 00 00       	mov    $0x2000,%eax
80105da5:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105daa:	66 ef                	out    %ax,(%dx)
80105dac:	ba 04 06 00 00       	mov    $0x604,%edx
80105db1:	66 ef                	out    %ax,(%dx)
  /* Either of the following will work. Does not harm to put them together. */
  outw(0xB004, 0x0|0x2000); // working for old qemu
  outw(0x604, 0x0|0x2000); // working for newer qemu
  
  return 0;
}
80105db3:	31 c0                	xor    %eax,%eax
80105db5:	c3                   	ret
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi

80105dc0 <sys_enable_sched_trace>:

extern int sched_trace_enabled;
extern int sched_trace_counter;
int sys_enable_sched_trace(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 10             	sub    $0x10,%esp
  if (argint(0, &sched_trace_enabled) < 0)
80105dc6:	68 30 2d 11 80       	push   $0x80112d30
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 de f0 ff ff       	call   80104eb0 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	78 17                	js     80105df0 <sys_enable_sched_trace+0x30>
  {
    cprintf("enable_sched_trace() failed!\n");
  }

  sched_trace_counter = 0;
80105dd9:	c7 05 2c 2d 11 80 00 	movl   $0x0,0x80112d2c
80105de0:	00 00 00 

  return 0;
}
80105de3:	31 c0                	xor    %eax,%eax
80105de5:	c9                   	leave
80105de6:	c3                   	ret
80105de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dee:	66 90                	xchg   %ax,%ax
    cprintf("enable_sched_trace() failed!\n");
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	68 11 80 10 80       	push   $0x80108011
80105df8:	e8 b3 a8 ff ff       	call   801006b0 <cprintf>
80105dfd:	83 c4 10             	add    $0x10,%esp
}
80105e00:	31 c0                	xor    %eax,%eax
  sched_trace_counter = 0;
80105e02:	c7 05 2c 2d 11 80 00 	movl   $0x0,0x80112d2c
80105e09:	00 00 00 
}
80105e0c:	c9                   	leave
80105e0d:	c3                   	ret
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <sys_fork_winner>:
extern int child_first;
extern int pause_sched;

int 
sys_fork_winner(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	83 ec 10             	sub    $0x10,%esp
  argint(0, &child_first);
80105e16:	68 24 2d 11 80       	push   $0x80112d24
80105e1b:	6a 00                	push   $0x0
80105e1d:	e8 8e f0 ff ff       	call   80104eb0 <argint>
  return 0;
}
80105e22:	31 c0                	xor    %eax,%eax
80105e24:	c9                   	leave
80105e25:	c3                   	ret
80105e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi

80105e30 <sys_pause_scheduling>:

int sys_pause_scheduling(void) {
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 20             	sub    $0x20,%esp
  int pause;
  if(argint(0, &pause) < 0)
80105e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e39:	50                   	push   %eax
80105e3a:	6a 00                	push   $0x0
80105e3c:	e8 6f f0 ff ff       	call   80104eb0 <argint>
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	85 c0                	test   %eax,%eax
80105e46:	78 13                	js     80105e5b <sys_pause_scheduling+0x2b>
    return -1;

  if(pause)
80105e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e4b:	31 c0                	xor    %eax,%eax
80105e4d:	85 d2                	test   %edx,%edx
80105e4f:	0f 95 c0             	setne  %al
    pause_sched = 1;
80105e52:	a3 20 2d 11 80       	mov    %eax,0x80112d20
  else
    pause_sched = 0;
  return 0;
80105e57:	31 c0                	xor    %eax,%eax
}
80105e59:	c9                   	leave
80105e5a:	c3                   	ret
80105e5b:	c9                   	leave
    return -1;
80105e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e61:	c3                   	ret
80105e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e70 <sys_set_sched>:

int
sys_set_sched(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 20             	sub    $0x20,%esp
  int sched;
  if(argint(0, &sched) < 0)
80105e76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e79:	50                   	push   %eax
80105e7a:	6a 00                	push   $0x0
80105e7c:	e8 2f f0 ff ff       	call   80104eb0 <argint>
80105e81:	83 c4 10             	add    $0x10,%esp
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 2a                	js     80105eb2 <sys_set_sched+0x42>
    return -1;

  if(sched == SCHEDULER_MLFQ) {
80105e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8b:	83 f8 01             	cmp    $0x1,%eax
80105e8e:	74 10                	je     80105ea0 <sys_set_sched+0x30>
    reset_all_priorities(SCHEDULER_MLFQ);
  }

  scheduler_type = sched;
80105e90:	a3 28 2d 11 80       	mov    %eax,0x80112d28
  return 0;
80105e95:	31 c0                	xor    %eax,%eax
}
80105e97:	c9                   	leave
80105e98:	c3                   	ret
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    reset_all_priorities(SCHEDULER_MLFQ);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	6a 01                	push   $0x1
80105ea5:	e8 26 e6 ff ff       	call   801044d0 <reset_all_priorities>
  scheduler_type = sched;
80105eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	eb de                	jmp    80105e90 <sys_set_sched+0x20>
}
80105eb2:	c9                   	leave
    return -1;
80105eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eb8:	c3                   	ret
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_mlfq_set_allotment>:

extern int allotments[];
int
sys_mlfq_set_allotment(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	83 ec 20             	sub    $0x20,%esp
  int priority, allotment;
  if(argint(0, &priority) < 0 || argint(1, &allotment) < 0)
80105ec6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ec9:	50                   	push   %eax
80105eca:	6a 00                	push   $0x0
80105ecc:	e8 df ef ff ff       	call   80104eb0 <argint>
80105ed1:	83 c4 10             	add    $0x10,%esp
80105ed4:	85 c0                	test   %eax,%eax
80105ed6:	78 38                	js     80105f10 <sys_mlfq_set_allotment+0x50>
80105ed8:	83 ec 08             	sub    $0x8,%esp
80105edb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ede:	50                   	push   %eax
80105edf:	6a 01                	push   $0x1
80105ee1:	e8 ca ef ff ff       	call   80104eb0 <argint>
80105ee6:	83 c4 10             	add    $0x10,%esp
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	78 23                	js     80105f10 <sys_mlfq_set_allotment+0x50>
    return -1;

  if(priority < MLFQ_PRIORITY_MIN || priority > MLFQ_PRIORITY_MAX)
80105eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ef3:	83 fa 02             	cmp    $0x2,%edx
80105ef6:	77 18                	ja     80105f10 <sys_mlfq_set_allotment+0x50>
    return -1;

  allotments[priority] = allotment;
80105ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105efb:	89 14 85 04 b0 10 80 	mov    %edx,-0x7fef4ffc(,%eax,4)
  return 0;
80105f02:	31 c0                	xor    %eax,%eax
80105f04:	c9                   	leave
80105f05:	c3                   	ret
80105f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi
80105f10:	c9                   	leave
    return -1;
80105f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f16:	c3                   	ret

80105f17 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f17:	1e                   	push   %ds
  pushl %es
80105f18:	06                   	push   %es
  pushl %fs
80105f19:	0f a0                	push   %fs
  pushl %gs
80105f1b:	0f a8                	push   %gs
  pushal
80105f1d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f1e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f22:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f24:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f26:	54                   	push   %esp
  call trap
80105f27:	e8 c4 00 00 00       	call   80105ff0 <trap>
  addl $4, %esp
80105f2c:	83 c4 04             	add    $0x4,%esp

80105f2f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f2f:	61                   	popa
  popl %gs
80105f30:	0f a9                	pop    %gs
  popl %fs
80105f32:	0f a1                	pop    %fs
  popl %es
80105f34:	07                   	pop    %es
  popl %ds
80105f35:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f36:	83 c4 08             	add    $0x8,%esp
  iret
80105f39:	cf                   	iret
80105f3a:	66 90                	xchg   %ax,%ax
80105f3c:	66 90                	xchg   %ax,%ax
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f41:	31 c0                	xor    %eax,%eax
{
80105f43:	89 e5                	mov    %esp,%ebp
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f50:	8b 14 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%edx
80105f57:	c7 04 c5 e2 50 11 80 	movl   $0x8e000008,-0x7feeaf1e(,%eax,8)
80105f5e:	08 00 00 8e 
80105f62:	66 89 14 c5 e0 50 11 	mov    %dx,-0x7feeaf20(,%eax,8)
80105f69:	80 
80105f6a:	c1 ea 10             	shr    $0x10,%edx
80105f6d:	66 89 14 c5 e6 50 11 	mov    %dx,-0x7feeaf1a(,%eax,8)
80105f74:	80 
  for(i = 0; i < 256; i++)
80105f75:	83 c0 01             	add    $0x1,%eax
80105f78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f7d:	75 d1                	jne    80105f50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f7f:	a1 20 b1 10 80       	mov    0x8010b120,%eax

  initlock(&tickslock, "time");
80105f84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f87:	c7 05 e2 52 11 80 08 	movl   $0xef000008,0x801152e2
80105f8e:	00 00 ef 
80105f91:	66 a3 e0 52 11 80    	mov    %ax,0x801152e0
80105f97:	c1 e8 10             	shr    $0x10,%eax
80105f9a:	66 a3 e6 52 11 80    	mov    %ax,0x801152e6
  initlock(&tickslock, "time");
80105fa0:	68 2f 80 10 80       	push   $0x8010802f
80105fa5:	68 a0 50 11 80       	push   $0x801150a0
80105faa:	e8 a1 e9 ff ff       	call   80104950 <initlock>
}
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	c9                   	leave
80105fb3:	c3                   	ret
80105fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop

80105fc0 <idtinit>:

void
idtinit(void)
{
80105fc0:	55                   	push   %ebp
  pd[0] = size-1;
80105fc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fc6:	89 e5                	mov    %esp,%ebp
80105fc8:	83 ec 10             	sub    $0x10,%esp
80105fcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fcf:	b8 e0 50 11 80       	mov    $0x801150e0,%eax
80105fd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fd8:	c1 e8 10             	shr    $0x10,%eax
80105fdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fe2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fe5:	c9                   	leave
80105fe6:	c3                   	ret
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	53                   	push   %ebx
80105ff6:	83 ec 1c             	sub    $0x1c,%esp
80105ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ffc:	8b 43 30             	mov    0x30(%ebx),%eax
80105fff:	83 f8 40             	cmp    $0x40,%eax
80106002:	0f 84 68 01 00 00    	je     80106170 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106008:	83 e8 20             	sub    $0x20,%eax
8010600b:	83 f8 1f             	cmp    $0x1f,%eax
8010600e:	0f 87 8c 00 00 00    	ja     801060a0 <trap+0xb0>
80106014:	ff 24 85 d8 80 10 80 	jmp    *-0x7fef7f28(,%eax,4)
8010601b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010601f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106020:	e8 ab c2 ff ff       	call   801022d0 <ideintr>
    lapiceoi();
80106025:	e8 76 c9 ff ff       	call   801029a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010602a:	e8 61 da ff ff       	call   80103a90 <myproc>
8010602f:	85 c0                	test   %eax,%eax
80106031:	74 1d                	je     80106050 <trap+0x60>
80106033:	e8 58 da ff ff       	call   80103a90 <myproc>
80106038:	8b 50 24             	mov    0x24(%eax),%edx
8010603b:	85 d2                	test   %edx,%edx
8010603d:	74 11                	je     80106050 <trap+0x60>
8010603f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106043:	83 e0 03             	and    $0x3,%eax
80106046:	66 83 f8 03          	cmp    $0x3,%ax
8010604a:	0f 84 e8 01 00 00    	je     80106238 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106050:	e8 3b da ff ff       	call   80103a90 <myproc>
80106055:	85 c0                	test   %eax,%eax
80106057:	74 0f                	je     80106068 <trap+0x78>
80106059:	e8 32 da ff ff       	call   80103a90 <myproc>
8010605e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106062:	0f 84 b8 00 00 00    	je     80106120 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106068:	e8 23 da ff ff       	call   80103a90 <myproc>
8010606d:	85 c0                	test   %eax,%eax
8010606f:	74 1d                	je     8010608e <trap+0x9e>
80106071:	e8 1a da ff ff       	call   80103a90 <myproc>
80106076:	8b 40 24             	mov    0x24(%eax),%eax
80106079:	85 c0                	test   %eax,%eax
8010607b:	74 11                	je     8010608e <trap+0x9e>
8010607d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106081:	83 e0 03             	and    $0x3,%eax
80106084:	66 83 f8 03          	cmp    $0x3,%ax
80106088:	0f 84 0f 01 00 00    	je     8010619d <trap+0x1ad>
    exit();
}
8010608e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106091:	5b                   	pop    %ebx
80106092:	5e                   	pop    %esi
80106093:	5f                   	pop    %edi
80106094:	5d                   	pop    %ebp
80106095:	c3                   	ret
80106096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801060a0:	e8 eb d9 ff ff       	call   80103a90 <myproc>
801060a5:	8b 7b 38             	mov    0x38(%ebx),%edi
801060a8:	85 c0                	test   %eax,%eax
801060aa:	0f 84 a2 01 00 00    	je     80106252 <trap+0x262>
801060b0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060b4:	0f 84 98 01 00 00    	je     80106252 <trap+0x262>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060ba:	0f 20 d1             	mov    %cr2,%ecx
801060bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060c0:	e8 ab d9 ff ff       	call   80103a70 <cpuid>
801060c5:	8b 73 30             	mov    0x30(%ebx),%esi
801060c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060cb:	8b 43 34             	mov    0x34(%ebx),%eax
801060ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801060d1:	e8 ba d9 ff ff       	call   80103a90 <myproc>
801060d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060d9:	e8 b2 d9 ff ff       	call   80103a90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060e1:	51                   	push   %ecx
801060e2:	57                   	push   %edi
801060e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060e6:	52                   	push   %edx
801060e7:	ff 75 e4             	push   -0x1c(%ebp)
801060ea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060eb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060ee:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060f1:	56                   	push   %esi
801060f2:	ff 70 10             	push   0x10(%eax)
801060f5:	68 94 80 10 80       	push   $0x80108094
801060fa:	e8 b1 a5 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
801060ff:	83 c4 20             	add    $0x20,%esp
80106102:	e8 89 d9 ff ff       	call   80103a90 <myproc>
80106107:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010610e:	e8 7d d9 ff ff       	call   80103a90 <myproc>
80106113:	85 c0                	test   %eax,%eax
80106115:	0f 85 18 ff ff ff    	jne    80106033 <trap+0x43>
8010611b:	e9 30 ff ff ff       	jmp    80106050 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106120:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106124:	0f 85 3e ff ff ff    	jne    80106068 <trap+0x78>
    yield();
8010612a:	e8 61 e4 ff ff       	call   80104590 <yield>
8010612f:	e9 34 ff ff ff       	jmp    80106068 <trap+0x78>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106138:	8b 7b 38             	mov    0x38(%ebx),%edi
8010613b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010613f:	e8 2c d9 ff ff       	call   80103a70 <cpuid>
80106144:	57                   	push   %edi
80106145:	56                   	push   %esi
80106146:	50                   	push   %eax
80106147:	68 3c 80 10 80       	push   $0x8010803c
8010614c:	e8 5f a5 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106151:	e8 4a c8 ff ff       	call   801029a0 <lapiceoi>
    break;
80106156:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106159:	e8 32 d9 ff ff       	call   80103a90 <myproc>
8010615e:	85 c0                	test   %eax,%eax
80106160:	0f 85 cd fe ff ff    	jne    80106033 <trap+0x43>
80106166:	e9 e5 fe ff ff       	jmp    80106050 <trap+0x60>
8010616b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop
    if(myproc()->killed)
80106170:	e8 1b d9 ff ff       	call   80103a90 <myproc>
80106175:	8b 70 24             	mov    0x24(%eax),%esi
80106178:	85 f6                	test   %esi,%esi
8010617a:	0f 85 c8 00 00 00    	jne    80106248 <trap+0x258>
    myproc()->tf = tf;
80106180:	e8 0b d9 ff ff       	call   80103a90 <myproc>
80106185:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106188:	e8 63 ee ff ff       	call   80104ff0 <syscall>
    if(myproc()->killed)
8010618d:	e8 fe d8 ff ff       	call   80103a90 <myproc>
80106192:	8b 48 24             	mov    0x24(%eax),%ecx
80106195:	85 c9                	test   %ecx,%ecx
80106197:	0f 84 f1 fe ff ff    	je     8010608e <trap+0x9e>
}
8010619d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061a0:	5b                   	pop    %ebx
801061a1:	5e                   	pop    %esi
801061a2:	5f                   	pop    %edi
801061a3:	5d                   	pop    %ebp
      exit();
801061a4:	e9 a7 de ff ff       	jmp    80104050 <exit>
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801061b0:	e8 4b 02 00 00       	call   80106400 <uartintr>
    lapiceoi();
801061b5:	e8 e6 c7 ff ff       	call   801029a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ba:	e8 d1 d8 ff ff       	call   80103a90 <myproc>
801061bf:	85 c0                	test   %eax,%eax
801061c1:	0f 85 6c fe ff ff    	jne    80106033 <trap+0x43>
801061c7:	e9 84 fe ff ff       	jmp    80106050 <trap+0x60>
801061cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801061d0:	e8 8b c6 ff ff       	call   80102860 <kbdintr>
    lapiceoi();
801061d5:	e8 c6 c7 ff ff       	call   801029a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061da:	e8 b1 d8 ff ff       	call   80103a90 <myproc>
801061df:	85 c0                	test   %eax,%eax
801061e1:	0f 85 4c fe ff ff    	jne    80106033 <trap+0x43>
801061e7:	e9 64 fe ff ff       	jmp    80106050 <trap+0x60>
801061ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801061f0:	e8 7b d8 ff ff       	call   80103a70 <cpuid>
801061f5:	85 c0                	test   %eax,%eax
801061f7:	0f 85 28 fe ff ff    	jne    80106025 <trap+0x35>
      acquire(&tickslock);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 a0 50 11 80       	push   $0x801150a0
80106205:	e8 66 e8 ff ff       	call   80104a70 <acquire>
      ticks++;
8010620a:	83 05 80 50 11 80 01 	addl   $0x1,0x80115080
      wakeup(&ticks);
80106211:	c7 04 24 80 50 11 80 	movl   $0x80115080,(%esp)
80106218:	e8 83 e4 ff ff       	call   801046a0 <wakeup>
      release(&tickslock);
8010621d:	c7 04 24 a0 50 11 80 	movl   $0x801150a0,(%esp)
80106224:	e8 87 e9 ff ff       	call   80104bb0 <release>
80106229:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010622c:	e9 f4 fd ff ff       	jmp    80106025 <trap+0x35>
80106231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106238:	e8 13 de ff ff       	call   80104050 <exit>
8010623d:	e9 0e fe ff ff       	jmp    80106050 <trap+0x60>
80106242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106248:	e8 03 de ff ff       	call   80104050 <exit>
8010624d:	e9 2e ff ff ff       	jmp    80106180 <trap+0x190>
80106252:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106255:	e8 16 d8 ff ff       	call   80103a70 <cpuid>
8010625a:	83 ec 0c             	sub    $0xc,%esp
8010625d:	56                   	push   %esi
8010625e:	57                   	push   %edi
8010625f:	50                   	push   %eax
80106260:	ff 73 30             	push   0x30(%ebx)
80106263:	68 60 80 10 80       	push   $0x80108060
80106268:	e8 43 a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010626d:	83 c4 14             	add    $0x14,%esp
80106270:	68 34 80 10 80       	push   $0x80108034
80106275:	e8 06 a1 ff ff       	call   80100380 <panic>
8010627a:	66 90                	xchg   %ax,%ax
8010627c:	66 90                	xchg   %ax,%ax
8010627e:	66 90                	xchg   %ax,%ax

80106280 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106280:	a1 e0 58 11 80       	mov    0x801158e0,%eax
80106285:	85 c0                	test   %eax,%eax
80106287:	74 17                	je     801062a0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106289:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010628e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010628f:	a8 01                	test   $0x1,%al
80106291:	74 0d                	je     801062a0 <uartgetc+0x20>
80106293:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106298:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106299:	0f b6 c0             	movzbl %al,%eax
8010629c:	c3                   	ret
8010629d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801062a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062a5:	c3                   	ret
801062a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ad:	8d 76 00             	lea    0x0(%esi),%esi

801062b0 <uartinit>:
{
801062b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b1:	31 c9                	xor    %ecx,%ecx
801062b3:	89 c8                	mov    %ecx,%eax
801062b5:	89 e5                	mov    %esp,%ebp
801062b7:	57                   	push   %edi
801062b8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801062bd:	56                   	push   %esi
801062be:	89 fa                	mov    %edi,%edx
801062c0:	53                   	push   %ebx
801062c1:	83 ec 1c             	sub    $0x1c,%esp
801062c4:	ee                   	out    %al,(%dx)
801062c5:	be fb 03 00 00       	mov    $0x3fb,%esi
801062ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062cf:	89 f2                	mov    %esi,%edx
801062d1:	ee                   	out    %al,(%dx)
801062d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062dc:	ee                   	out    %al,(%dx)
801062dd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801062e2:	89 c8                	mov    %ecx,%eax
801062e4:	89 da                	mov    %ebx,%edx
801062e6:	ee                   	out    %al,(%dx)
801062e7:	b8 03 00 00 00       	mov    $0x3,%eax
801062ec:	89 f2                	mov    %esi,%edx
801062ee:	ee                   	out    %al,(%dx)
801062ef:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062f4:	89 c8                	mov    %ecx,%eax
801062f6:	ee                   	out    %al,(%dx)
801062f7:	b8 01 00 00 00       	mov    $0x1,%eax
801062fc:	89 da                	mov    %ebx,%edx
801062fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106304:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106305:	3c ff                	cmp    $0xff,%al
80106307:	0f 84 7c 00 00 00    	je     80106389 <uartinit+0xd9>
  uart = 1;
8010630d:	c7 05 e0 58 11 80 01 	movl   $0x1,0x801158e0
80106314:	00 00 00 
80106317:	89 fa                	mov    %edi,%edx
80106319:	ec                   	in     (%dx),%al
8010631a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010631f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106320:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106323:	bf 58 81 10 80       	mov    $0x80108158,%edi
80106328:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010632d:	6a 00                	push   $0x0
8010632f:	6a 04                	push   $0x4
80106331:	e8 ca c1 ff ff       	call   80102500 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106336:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106340:	a1 e0 58 11 80       	mov    0x801158e0,%eax
80106345:	85 c0                	test   %eax,%eax
80106347:	74 32                	je     8010637b <uartinit+0xcb>
80106349:	89 f2                	mov    %esi,%edx
8010634b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010634c:	a8 20                	test   $0x20,%al
8010634e:	75 21                	jne    80106371 <uartinit+0xc1>
80106350:	bb 80 00 00 00       	mov    $0x80,%ebx
80106355:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106358:	83 ec 0c             	sub    $0xc,%esp
8010635b:	6a 0a                	push   $0xa
8010635d:	e8 5e c6 ff ff       	call   801029c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	83 eb 01             	sub    $0x1,%ebx
80106368:	74 07                	je     80106371 <uartinit+0xc1>
8010636a:	89 f2                	mov    %esi,%edx
8010636c:	ec                   	in     (%dx),%al
8010636d:	a8 20                	test   $0x20,%al
8010636f:	74 e7                	je     80106358 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106371:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106376:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010637a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010637b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010637f:	83 c7 01             	add    $0x1,%edi
80106382:	88 45 e7             	mov    %al,-0x19(%ebp)
80106385:	84 c0                	test   %al,%al
80106387:	75 b7                	jne    80106340 <uartinit+0x90>
}
80106389:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010638c:	5b                   	pop    %ebx
8010638d:	5e                   	pop    %esi
8010638e:	5f                   	pop    %edi
8010638f:	5d                   	pop    %ebp
80106390:	c3                   	ret
80106391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639f:	90                   	nop

801063a0 <uartputc>:
  if(!uart)
801063a0:	a1 e0 58 11 80       	mov    0x801158e0,%eax
801063a5:	85 c0                	test   %eax,%eax
801063a7:	74 4f                	je     801063f8 <uartputc+0x58>
{
801063a9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063aa:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063af:	89 e5                	mov    %esp,%ebp
801063b1:	56                   	push   %esi
801063b2:	53                   	push   %ebx
801063b3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063b4:	a8 20                	test   $0x20,%al
801063b6:	75 29                	jne    801063e1 <uartputc+0x41>
801063b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801063bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	6a 0a                	push   $0xa
801063cd:	e8 ee c5 ff ff       	call   801029c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063d2:	83 c4 10             	add    $0x10,%esp
801063d5:	83 eb 01             	sub    $0x1,%ebx
801063d8:	74 07                	je     801063e1 <uartputc+0x41>
801063da:	89 f2                	mov    %esi,%edx
801063dc:	ec                   	in     (%dx),%al
801063dd:	a8 20                	test   $0x20,%al
801063df:	74 e7                	je     801063c8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063e1:	8b 45 08             	mov    0x8(%ebp),%eax
801063e4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063e9:	ee                   	out    %al,(%dx)
}
801063ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063ed:	5b                   	pop    %ebx
801063ee:	5e                   	pop    %esi
801063ef:	5d                   	pop    %ebp
801063f0:	c3                   	ret
801063f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063f8:	c3                   	ret
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106400 <uartintr>:

void
uartintr(void)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106406:	68 80 62 10 80       	push   $0x80106280
8010640b:	e8 b0 a4 ff ff       	call   801008c0 <consoleintr>
}
80106410:	83 c4 10             	add    $0x10,%esp
80106413:	c9                   	leave
80106414:	c3                   	ret

80106415 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $0
80106417:	6a 00                	push   $0x0
  jmp alltraps
80106419:	e9 f9 fa ff ff       	jmp    80105f17 <alltraps>

8010641e <vector1>:
.globl vector1
vector1:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $1
80106420:	6a 01                	push   $0x1
  jmp alltraps
80106422:	e9 f0 fa ff ff       	jmp    80105f17 <alltraps>

80106427 <vector2>:
.globl vector2
vector2:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $2
80106429:	6a 02                	push   $0x2
  jmp alltraps
8010642b:	e9 e7 fa ff ff       	jmp    80105f17 <alltraps>

80106430 <vector3>:
.globl vector3
vector3:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $3
80106432:	6a 03                	push   $0x3
  jmp alltraps
80106434:	e9 de fa ff ff       	jmp    80105f17 <alltraps>

80106439 <vector4>:
.globl vector4
vector4:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $4
8010643b:	6a 04                	push   $0x4
  jmp alltraps
8010643d:	e9 d5 fa ff ff       	jmp    80105f17 <alltraps>

80106442 <vector5>:
.globl vector5
vector5:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $5
80106444:	6a 05                	push   $0x5
  jmp alltraps
80106446:	e9 cc fa ff ff       	jmp    80105f17 <alltraps>

8010644b <vector6>:
.globl vector6
vector6:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $6
8010644d:	6a 06                	push   $0x6
  jmp alltraps
8010644f:	e9 c3 fa ff ff       	jmp    80105f17 <alltraps>

80106454 <vector7>:
.globl vector7
vector7:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $7
80106456:	6a 07                	push   $0x7
  jmp alltraps
80106458:	e9 ba fa ff ff       	jmp    80105f17 <alltraps>

8010645d <vector8>:
.globl vector8
vector8:
  pushl $8
8010645d:	6a 08                	push   $0x8
  jmp alltraps
8010645f:	e9 b3 fa ff ff       	jmp    80105f17 <alltraps>

80106464 <vector9>:
.globl vector9
vector9:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $9
80106466:	6a 09                	push   $0x9
  jmp alltraps
80106468:	e9 aa fa ff ff       	jmp    80105f17 <alltraps>

8010646d <vector10>:
.globl vector10
vector10:
  pushl $10
8010646d:	6a 0a                	push   $0xa
  jmp alltraps
8010646f:	e9 a3 fa ff ff       	jmp    80105f17 <alltraps>

80106474 <vector11>:
.globl vector11
vector11:
  pushl $11
80106474:	6a 0b                	push   $0xb
  jmp alltraps
80106476:	e9 9c fa ff ff       	jmp    80105f17 <alltraps>

8010647b <vector12>:
.globl vector12
vector12:
  pushl $12
8010647b:	6a 0c                	push   $0xc
  jmp alltraps
8010647d:	e9 95 fa ff ff       	jmp    80105f17 <alltraps>

80106482 <vector13>:
.globl vector13
vector13:
  pushl $13
80106482:	6a 0d                	push   $0xd
  jmp alltraps
80106484:	e9 8e fa ff ff       	jmp    80105f17 <alltraps>

80106489 <vector14>:
.globl vector14
vector14:
  pushl $14
80106489:	6a 0e                	push   $0xe
  jmp alltraps
8010648b:	e9 87 fa ff ff       	jmp    80105f17 <alltraps>

80106490 <vector15>:
.globl vector15
vector15:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $15
80106492:	6a 0f                	push   $0xf
  jmp alltraps
80106494:	e9 7e fa ff ff       	jmp    80105f17 <alltraps>

80106499 <vector16>:
.globl vector16
vector16:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $16
8010649b:	6a 10                	push   $0x10
  jmp alltraps
8010649d:	e9 75 fa ff ff       	jmp    80105f17 <alltraps>

801064a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064a2:	6a 11                	push   $0x11
  jmp alltraps
801064a4:	e9 6e fa ff ff       	jmp    80105f17 <alltraps>

801064a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $18
801064ab:	6a 12                	push   $0x12
  jmp alltraps
801064ad:	e9 65 fa ff ff       	jmp    80105f17 <alltraps>

801064b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $19
801064b4:	6a 13                	push   $0x13
  jmp alltraps
801064b6:	e9 5c fa ff ff       	jmp    80105f17 <alltraps>

801064bb <vector20>:
.globl vector20
vector20:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $20
801064bd:	6a 14                	push   $0x14
  jmp alltraps
801064bf:	e9 53 fa ff ff       	jmp    80105f17 <alltraps>

801064c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $21
801064c6:	6a 15                	push   $0x15
  jmp alltraps
801064c8:	e9 4a fa ff ff       	jmp    80105f17 <alltraps>

801064cd <vector22>:
.globl vector22
vector22:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $22
801064cf:	6a 16                	push   $0x16
  jmp alltraps
801064d1:	e9 41 fa ff ff       	jmp    80105f17 <alltraps>

801064d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $23
801064d8:	6a 17                	push   $0x17
  jmp alltraps
801064da:	e9 38 fa ff ff       	jmp    80105f17 <alltraps>

801064df <vector24>:
.globl vector24
vector24:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $24
801064e1:	6a 18                	push   $0x18
  jmp alltraps
801064e3:	e9 2f fa ff ff       	jmp    80105f17 <alltraps>

801064e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $25
801064ea:	6a 19                	push   $0x19
  jmp alltraps
801064ec:	e9 26 fa ff ff       	jmp    80105f17 <alltraps>

801064f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $26
801064f3:	6a 1a                	push   $0x1a
  jmp alltraps
801064f5:	e9 1d fa ff ff       	jmp    80105f17 <alltraps>

801064fa <vector27>:
.globl vector27
vector27:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $27
801064fc:	6a 1b                	push   $0x1b
  jmp alltraps
801064fe:	e9 14 fa ff ff       	jmp    80105f17 <alltraps>

80106503 <vector28>:
.globl vector28
vector28:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $28
80106505:	6a 1c                	push   $0x1c
  jmp alltraps
80106507:	e9 0b fa ff ff       	jmp    80105f17 <alltraps>

8010650c <vector29>:
.globl vector29
vector29:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $29
8010650e:	6a 1d                	push   $0x1d
  jmp alltraps
80106510:	e9 02 fa ff ff       	jmp    80105f17 <alltraps>

80106515 <vector30>:
.globl vector30
vector30:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $30
80106517:	6a 1e                	push   $0x1e
  jmp alltraps
80106519:	e9 f9 f9 ff ff       	jmp    80105f17 <alltraps>

8010651e <vector31>:
.globl vector31
vector31:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $31
80106520:	6a 1f                	push   $0x1f
  jmp alltraps
80106522:	e9 f0 f9 ff ff       	jmp    80105f17 <alltraps>

80106527 <vector32>:
.globl vector32
vector32:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $32
80106529:	6a 20                	push   $0x20
  jmp alltraps
8010652b:	e9 e7 f9 ff ff       	jmp    80105f17 <alltraps>

80106530 <vector33>:
.globl vector33
vector33:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $33
80106532:	6a 21                	push   $0x21
  jmp alltraps
80106534:	e9 de f9 ff ff       	jmp    80105f17 <alltraps>

80106539 <vector34>:
.globl vector34
vector34:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $34
8010653b:	6a 22                	push   $0x22
  jmp alltraps
8010653d:	e9 d5 f9 ff ff       	jmp    80105f17 <alltraps>

80106542 <vector35>:
.globl vector35
vector35:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $35
80106544:	6a 23                	push   $0x23
  jmp alltraps
80106546:	e9 cc f9 ff ff       	jmp    80105f17 <alltraps>

8010654b <vector36>:
.globl vector36
vector36:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $36
8010654d:	6a 24                	push   $0x24
  jmp alltraps
8010654f:	e9 c3 f9 ff ff       	jmp    80105f17 <alltraps>

80106554 <vector37>:
.globl vector37
vector37:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $37
80106556:	6a 25                	push   $0x25
  jmp alltraps
80106558:	e9 ba f9 ff ff       	jmp    80105f17 <alltraps>

8010655d <vector38>:
.globl vector38
vector38:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $38
8010655f:	6a 26                	push   $0x26
  jmp alltraps
80106561:	e9 b1 f9 ff ff       	jmp    80105f17 <alltraps>

80106566 <vector39>:
.globl vector39
vector39:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $39
80106568:	6a 27                	push   $0x27
  jmp alltraps
8010656a:	e9 a8 f9 ff ff       	jmp    80105f17 <alltraps>

8010656f <vector40>:
.globl vector40
vector40:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $40
80106571:	6a 28                	push   $0x28
  jmp alltraps
80106573:	e9 9f f9 ff ff       	jmp    80105f17 <alltraps>

80106578 <vector41>:
.globl vector41
vector41:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $41
8010657a:	6a 29                	push   $0x29
  jmp alltraps
8010657c:	e9 96 f9 ff ff       	jmp    80105f17 <alltraps>

80106581 <vector42>:
.globl vector42
vector42:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $42
80106583:	6a 2a                	push   $0x2a
  jmp alltraps
80106585:	e9 8d f9 ff ff       	jmp    80105f17 <alltraps>

8010658a <vector43>:
.globl vector43
vector43:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $43
8010658c:	6a 2b                	push   $0x2b
  jmp alltraps
8010658e:	e9 84 f9 ff ff       	jmp    80105f17 <alltraps>

80106593 <vector44>:
.globl vector44
vector44:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $44
80106595:	6a 2c                	push   $0x2c
  jmp alltraps
80106597:	e9 7b f9 ff ff       	jmp    80105f17 <alltraps>

8010659c <vector45>:
.globl vector45
vector45:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $45
8010659e:	6a 2d                	push   $0x2d
  jmp alltraps
801065a0:	e9 72 f9 ff ff       	jmp    80105f17 <alltraps>

801065a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $46
801065a7:	6a 2e                	push   $0x2e
  jmp alltraps
801065a9:	e9 69 f9 ff ff       	jmp    80105f17 <alltraps>

801065ae <vector47>:
.globl vector47
vector47:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $47
801065b0:	6a 2f                	push   $0x2f
  jmp alltraps
801065b2:	e9 60 f9 ff ff       	jmp    80105f17 <alltraps>

801065b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $48
801065b9:	6a 30                	push   $0x30
  jmp alltraps
801065bb:	e9 57 f9 ff ff       	jmp    80105f17 <alltraps>

801065c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $49
801065c2:	6a 31                	push   $0x31
  jmp alltraps
801065c4:	e9 4e f9 ff ff       	jmp    80105f17 <alltraps>

801065c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $50
801065cb:	6a 32                	push   $0x32
  jmp alltraps
801065cd:	e9 45 f9 ff ff       	jmp    80105f17 <alltraps>

801065d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $51
801065d4:	6a 33                	push   $0x33
  jmp alltraps
801065d6:	e9 3c f9 ff ff       	jmp    80105f17 <alltraps>

801065db <vector52>:
.globl vector52
vector52:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $52
801065dd:	6a 34                	push   $0x34
  jmp alltraps
801065df:	e9 33 f9 ff ff       	jmp    80105f17 <alltraps>

801065e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $53
801065e6:	6a 35                	push   $0x35
  jmp alltraps
801065e8:	e9 2a f9 ff ff       	jmp    80105f17 <alltraps>

801065ed <vector54>:
.globl vector54
vector54:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $54
801065ef:	6a 36                	push   $0x36
  jmp alltraps
801065f1:	e9 21 f9 ff ff       	jmp    80105f17 <alltraps>

801065f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $55
801065f8:	6a 37                	push   $0x37
  jmp alltraps
801065fa:	e9 18 f9 ff ff       	jmp    80105f17 <alltraps>

801065ff <vector56>:
.globl vector56
vector56:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $56
80106601:	6a 38                	push   $0x38
  jmp alltraps
80106603:	e9 0f f9 ff ff       	jmp    80105f17 <alltraps>

80106608 <vector57>:
.globl vector57
vector57:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $57
8010660a:	6a 39                	push   $0x39
  jmp alltraps
8010660c:	e9 06 f9 ff ff       	jmp    80105f17 <alltraps>

80106611 <vector58>:
.globl vector58
vector58:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $58
80106613:	6a 3a                	push   $0x3a
  jmp alltraps
80106615:	e9 fd f8 ff ff       	jmp    80105f17 <alltraps>

8010661a <vector59>:
.globl vector59
vector59:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $59
8010661c:	6a 3b                	push   $0x3b
  jmp alltraps
8010661e:	e9 f4 f8 ff ff       	jmp    80105f17 <alltraps>

80106623 <vector60>:
.globl vector60
vector60:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $60
80106625:	6a 3c                	push   $0x3c
  jmp alltraps
80106627:	e9 eb f8 ff ff       	jmp    80105f17 <alltraps>

8010662c <vector61>:
.globl vector61
vector61:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $61
8010662e:	6a 3d                	push   $0x3d
  jmp alltraps
80106630:	e9 e2 f8 ff ff       	jmp    80105f17 <alltraps>

80106635 <vector62>:
.globl vector62
vector62:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $62
80106637:	6a 3e                	push   $0x3e
  jmp alltraps
80106639:	e9 d9 f8 ff ff       	jmp    80105f17 <alltraps>

8010663e <vector63>:
.globl vector63
vector63:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $63
80106640:	6a 3f                	push   $0x3f
  jmp alltraps
80106642:	e9 d0 f8 ff ff       	jmp    80105f17 <alltraps>

80106647 <vector64>:
.globl vector64
vector64:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $64
80106649:	6a 40                	push   $0x40
  jmp alltraps
8010664b:	e9 c7 f8 ff ff       	jmp    80105f17 <alltraps>

80106650 <vector65>:
.globl vector65
vector65:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $65
80106652:	6a 41                	push   $0x41
  jmp alltraps
80106654:	e9 be f8 ff ff       	jmp    80105f17 <alltraps>

80106659 <vector66>:
.globl vector66
vector66:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $66
8010665b:	6a 42                	push   $0x42
  jmp alltraps
8010665d:	e9 b5 f8 ff ff       	jmp    80105f17 <alltraps>

80106662 <vector67>:
.globl vector67
vector67:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $67
80106664:	6a 43                	push   $0x43
  jmp alltraps
80106666:	e9 ac f8 ff ff       	jmp    80105f17 <alltraps>

8010666b <vector68>:
.globl vector68
vector68:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $68
8010666d:	6a 44                	push   $0x44
  jmp alltraps
8010666f:	e9 a3 f8 ff ff       	jmp    80105f17 <alltraps>

80106674 <vector69>:
.globl vector69
vector69:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $69
80106676:	6a 45                	push   $0x45
  jmp alltraps
80106678:	e9 9a f8 ff ff       	jmp    80105f17 <alltraps>

8010667d <vector70>:
.globl vector70
vector70:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $70
8010667f:	6a 46                	push   $0x46
  jmp alltraps
80106681:	e9 91 f8 ff ff       	jmp    80105f17 <alltraps>

80106686 <vector71>:
.globl vector71
vector71:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $71
80106688:	6a 47                	push   $0x47
  jmp alltraps
8010668a:	e9 88 f8 ff ff       	jmp    80105f17 <alltraps>

8010668f <vector72>:
.globl vector72
vector72:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $72
80106691:	6a 48                	push   $0x48
  jmp alltraps
80106693:	e9 7f f8 ff ff       	jmp    80105f17 <alltraps>

80106698 <vector73>:
.globl vector73
vector73:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $73
8010669a:	6a 49                	push   $0x49
  jmp alltraps
8010669c:	e9 76 f8 ff ff       	jmp    80105f17 <alltraps>

801066a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $74
801066a3:	6a 4a                	push   $0x4a
  jmp alltraps
801066a5:	e9 6d f8 ff ff       	jmp    80105f17 <alltraps>

801066aa <vector75>:
.globl vector75
vector75:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $75
801066ac:	6a 4b                	push   $0x4b
  jmp alltraps
801066ae:	e9 64 f8 ff ff       	jmp    80105f17 <alltraps>

801066b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $76
801066b5:	6a 4c                	push   $0x4c
  jmp alltraps
801066b7:	e9 5b f8 ff ff       	jmp    80105f17 <alltraps>

801066bc <vector77>:
.globl vector77
vector77:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $77
801066be:	6a 4d                	push   $0x4d
  jmp alltraps
801066c0:	e9 52 f8 ff ff       	jmp    80105f17 <alltraps>

801066c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $78
801066c7:	6a 4e                	push   $0x4e
  jmp alltraps
801066c9:	e9 49 f8 ff ff       	jmp    80105f17 <alltraps>

801066ce <vector79>:
.globl vector79
vector79:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $79
801066d0:	6a 4f                	push   $0x4f
  jmp alltraps
801066d2:	e9 40 f8 ff ff       	jmp    80105f17 <alltraps>

801066d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $80
801066d9:	6a 50                	push   $0x50
  jmp alltraps
801066db:	e9 37 f8 ff ff       	jmp    80105f17 <alltraps>

801066e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $81
801066e2:	6a 51                	push   $0x51
  jmp alltraps
801066e4:	e9 2e f8 ff ff       	jmp    80105f17 <alltraps>

801066e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $82
801066eb:	6a 52                	push   $0x52
  jmp alltraps
801066ed:	e9 25 f8 ff ff       	jmp    80105f17 <alltraps>

801066f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $83
801066f4:	6a 53                	push   $0x53
  jmp alltraps
801066f6:	e9 1c f8 ff ff       	jmp    80105f17 <alltraps>

801066fb <vector84>:
.globl vector84
vector84:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $84
801066fd:	6a 54                	push   $0x54
  jmp alltraps
801066ff:	e9 13 f8 ff ff       	jmp    80105f17 <alltraps>

80106704 <vector85>:
.globl vector85
vector85:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $85
80106706:	6a 55                	push   $0x55
  jmp alltraps
80106708:	e9 0a f8 ff ff       	jmp    80105f17 <alltraps>

8010670d <vector86>:
.globl vector86
vector86:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $86
8010670f:	6a 56                	push   $0x56
  jmp alltraps
80106711:	e9 01 f8 ff ff       	jmp    80105f17 <alltraps>

80106716 <vector87>:
.globl vector87
vector87:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $87
80106718:	6a 57                	push   $0x57
  jmp alltraps
8010671a:	e9 f8 f7 ff ff       	jmp    80105f17 <alltraps>

8010671f <vector88>:
.globl vector88
vector88:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $88
80106721:	6a 58                	push   $0x58
  jmp alltraps
80106723:	e9 ef f7 ff ff       	jmp    80105f17 <alltraps>

80106728 <vector89>:
.globl vector89
vector89:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $89
8010672a:	6a 59                	push   $0x59
  jmp alltraps
8010672c:	e9 e6 f7 ff ff       	jmp    80105f17 <alltraps>

80106731 <vector90>:
.globl vector90
vector90:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $90
80106733:	6a 5a                	push   $0x5a
  jmp alltraps
80106735:	e9 dd f7 ff ff       	jmp    80105f17 <alltraps>

8010673a <vector91>:
.globl vector91
vector91:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $91
8010673c:	6a 5b                	push   $0x5b
  jmp alltraps
8010673e:	e9 d4 f7 ff ff       	jmp    80105f17 <alltraps>

80106743 <vector92>:
.globl vector92
vector92:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $92
80106745:	6a 5c                	push   $0x5c
  jmp alltraps
80106747:	e9 cb f7 ff ff       	jmp    80105f17 <alltraps>

8010674c <vector93>:
.globl vector93
vector93:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $93
8010674e:	6a 5d                	push   $0x5d
  jmp alltraps
80106750:	e9 c2 f7 ff ff       	jmp    80105f17 <alltraps>

80106755 <vector94>:
.globl vector94
vector94:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $94
80106757:	6a 5e                	push   $0x5e
  jmp alltraps
80106759:	e9 b9 f7 ff ff       	jmp    80105f17 <alltraps>

8010675e <vector95>:
.globl vector95
vector95:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $95
80106760:	6a 5f                	push   $0x5f
  jmp alltraps
80106762:	e9 b0 f7 ff ff       	jmp    80105f17 <alltraps>

80106767 <vector96>:
.globl vector96
vector96:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $96
80106769:	6a 60                	push   $0x60
  jmp alltraps
8010676b:	e9 a7 f7 ff ff       	jmp    80105f17 <alltraps>

80106770 <vector97>:
.globl vector97
vector97:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $97
80106772:	6a 61                	push   $0x61
  jmp alltraps
80106774:	e9 9e f7 ff ff       	jmp    80105f17 <alltraps>

80106779 <vector98>:
.globl vector98
vector98:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $98
8010677b:	6a 62                	push   $0x62
  jmp alltraps
8010677d:	e9 95 f7 ff ff       	jmp    80105f17 <alltraps>

80106782 <vector99>:
.globl vector99
vector99:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $99
80106784:	6a 63                	push   $0x63
  jmp alltraps
80106786:	e9 8c f7 ff ff       	jmp    80105f17 <alltraps>

8010678b <vector100>:
.globl vector100
vector100:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $100
8010678d:	6a 64                	push   $0x64
  jmp alltraps
8010678f:	e9 83 f7 ff ff       	jmp    80105f17 <alltraps>

80106794 <vector101>:
.globl vector101
vector101:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $101
80106796:	6a 65                	push   $0x65
  jmp alltraps
80106798:	e9 7a f7 ff ff       	jmp    80105f17 <alltraps>

8010679d <vector102>:
.globl vector102
vector102:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $102
8010679f:	6a 66                	push   $0x66
  jmp alltraps
801067a1:	e9 71 f7 ff ff       	jmp    80105f17 <alltraps>

801067a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $103
801067a8:	6a 67                	push   $0x67
  jmp alltraps
801067aa:	e9 68 f7 ff ff       	jmp    80105f17 <alltraps>

801067af <vector104>:
.globl vector104
vector104:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $104
801067b1:	6a 68                	push   $0x68
  jmp alltraps
801067b3:	e9 5f f7 ff ff       	jmp    80105f17 <alltraps>

801067b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $105
801067ba:	6a 69                	push   $0x69
  jmp alltraps
801067bc:	e9 56 f7 ff ff       	jmp    80105f17 <alltraps>

801067c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $106
801067c3:	6a 6a                	push   $0x6a
  jmp alltraps
801067c5:	e9 4d f7 ff ff       	jmp    80105f17 <alltraps>

801067ca <vector107>:
.globl vector107
vector107:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $107
801067cc:	6a 6b                	push   $0x6b
  jmp alltraps
801067ce:	e9 44 f7 ff ff       	jmp    80105f17 <alltraps>

801067d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $108
801067d5:	6a 6c                	push   $0x6c
  jmp alltraps
801067d7:	e9 3b f7 ff ff       	jmp    80105f17 <alltraps>

801067dc <vector109>:
.globl vector109
vector109:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $109
801067de:	6a 6d                	push   $0x6d
  jmp alltraps
801067e0:	e9 32 f7 ff ff       	jmp    80105f17 <alltraps>

801067e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $110
801067e7:	6a 6e                	push   $0x6e
  jmp alltraps
801067e9:	e9 29 f7 ff ff       	jmp    80105f17 <alltraps>

801067ee <vector111>:
.globl vector111
vector111:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $111
801067f0:	6a 6f                	push   $0x6f
  jmp alltraps
801067f2:	e9 20 f7 ff ff       	jmp    80105f17 <alltraps>

801067f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $112
801067f9:	6a 70                	push   $0x70
  jmp alltraps
801067fb:	e9 17 f7 ff ff       	jmp    80105f17 <alltraps>

80106800 <vector113>:
.globl vector113
vector113:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $113
80106802:	6a 71                	push   $0x71
  jmp alltraps
80106804:	e9 0e f7 ff ff       	jmp    80105f17 <alltraps>

80106809 <vector114>:
.globl vector114
vector114:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $114
8010680b:	6a 72                	push   $0x72
  jmp alltraps
8010680d:	e9 05 f7 ff ff       	jmp    80105f17 <alltraps>

80106812 <vector115>:
.globl vector115
vector115:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $115
80106814:	6a 73                	push   $0x73
  jmp alltraps
80106816:	e9 fc f6 ff ff       	jmp    80105f17 <alltraps>

8010681b <vector116>:
.globl vector116
vector116:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $116
8010681d:	6a 74                	push   $0x74
  jmp alltraps
8010681f:	e9 f3 f6 ff ff       	jmp    80105f17 <alltraps>

80106824 <vector117>:
.globl vector117
vector117:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $117
80106826:	6a 75                	push   $0x75
  jmp alltraps
80106828:	e9 ea f6 ff ff       	jmp    80105f17 <alltraps>

8010682d <vector118>:
.globl vector118
vector118:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $118
8010682f:	6a 76                	push   $0x76
  jmp alltraps
80106831:	e9 e1 f6 ff ff       	jmp    80105f17 <alltraps>

80106836 <vector119>:
.globl vector119
vector119:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $119
80106838:	6a 77                	push   $0x77
  jmp alltraps
8010683a:	e9 d8 f6 ff ff       	jmp    80105f17 <alltraps>

8010683f <vector120>:
.globl vector120
vector120:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $120
80106841:	6a 78                	push   $0x78
  jmp alltraps
80106843:	e9 cf f6 ff ff       	jmp    80105f17 <alltraps>

80106848 <vector121>:
.globl vector121
vector121:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $121
8010684a:	6a 79                	push   $0x79
  jmp alltraps
8010684c:	e9 c6 f6 ff ff       	jmp    80105f17 <alltraps>

80106851 <vector122>:
.globl vector122
vector122:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $122
80106853:	6a 7a                	push   $0x7a
  jmp alltraps
80106855:	e9 bd f6 ff ff       	jmp    80105f17 <alltraps>

8010685a <vector123>:
.globl vector123
vector123:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $123
8010685c:	6a 7b                	push   $0x7b
  jmp alltraps
8010685e:	e9 b4 f6 ff ff       	jmp    80105f17 <alltraps>

80106863 <vector124>:
.globl vector124
vector124:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $124
80106865:	6a 7c                	push   $0x7c
  jmp alltraps
80106867:	e9 ab f6 ff ff       	jmp    80105f17 <alltraps>

8010686c <vector125>:
.globl vector125
vector125:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $125
8010686e:	6a 7d                	push   $0x7d
  jmp alltraps
80106870:	e9 a2 f6 ff ff       	jmp    80105f17 <alltraps>

80106875 <vector126>:
.globl vector126
vector126:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $126
80106877:	6a 7e                	push   $0x7e
  jmp alltraps
80106879:	e9 99 f6 ff ff       	jmp    80105f17 <alltraps>

8010687e <vector127>:
.globl vector127
vector127:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $127
80106880:	6a 7f                	push   $0x7f
  jmp alltraps
80106882:	e9 90 f6 ff ff       	jmp    80105f17 <alltraps>

80106887 <vector128>:
.globl vector128
vector128:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $128
80106889:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010688e:	e9 84 f6 ff ff       	jmp    80105f17 <alltraps>

80106893 <vector129>:
.globl vector129
vector129:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $129
80106895:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010689a:	e9 78 f6 ff ff       	jmp    80105f17 <alltraps>

8010689f <vector130>:
.globl vector130
vector130:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $130
801068a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068a6:	e9 6c f6 ff ff       	jmp    80105f17 <alltraps>

801068ab <vector131>:
.globl vector131
vector131:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $131
801068ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068b2:	e9 60 f6 ff ff       	jmp    80105f17 <alltraps>

801068b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $132
801068b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068be:	e9 54 f6 ff ff       	jmp    80105f17 <alltraps>

801068c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $133
801068c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068ca:	e9 48 f6 ff ff       	jmp    80105f17 <alltraps>

801068cf <vector134>:
.globl vector134
vector134:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $134
801068d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068d6:	e9 3c f6 ff ff       	jmp    80105f17 <alltraps>

801068db <vector135>:
.globl vector135
vector135:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $135
801068dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068e2:	e9 30 f6 ff ff       	jmp    80105f17 <alltraps>

801068e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $136
801068e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068ee:	e9 24 f6 ff ff       	jmp    80105f17 <alltraps>

801068f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $137
801068f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068fa:	e9 18 f6 ff ff       	jmp    80105f17 <alltraps>

801068ff <vector138>:
.globl vector138
vector138:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $138
80106901:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106906:	e9 0c f6 ff ff       	jmp    80105f17 <alltraps>

8010690b <vector139>:
.globl vector139
vector139:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $139
8010690d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106912:	e9 00 f6 ff ff       	jmp    80105f17 <alltraps>

80106917 <vector140>:
.globl vector140
vector140:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $140
80106919:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010691e:	e9 f4 f5 ff ff       	jmp    80105f17 <alltraps>

80106923 <vector141>:
.globl vector141
vector141:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $141
80106925:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010692a:	e9 e8 f5 ff ff       	jmp    80105f17 <alltraps>

8010692f <vector142>:
.globl vector142
vector142:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $142
80106931:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106936:	e9 dc f5 ff ff       	jmp    80105f17 <alltraps>

8010693b <vector143>:
.globl vector143
vector143:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $143
8010693d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106942:	e9 d0 f5 ff ff       	jmp    80105f17 <alltraps>

80106947 <vector144>:
.globl vector144
vector144:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $144
80106949:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010694e:	e9 c4 f5 ff ff       	jmp    80105f17 <alltraps>

80106953 <vector145>:
.globl vector145
vector145:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $145
80106955:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010695a:	e9 b8 f5 ff ff       	jmp    80105f17 <alltraps>

8010695f <vector146>:
.globl vector146
vector146:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $146
80106961:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106966:	e9 ac f5 ff ff       	jmp    80105f17 <alltraps>

8010696b <vector147>:
.globl vector147
vector147:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $147
8010696d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106972:	e9 a0 f5 ff ff       	jmp    80105f17 <alltraps>

80106977 <vector148>:
.globl vector148
vector148:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $148
80106979:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010697e:	e9 94 f5 ff ff       	jmp    80105f17 <alltraps>

80106983 <vector149>:
.globl vector149
vector149:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $149
80106985:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010698a:	e9 88 f5 ff ff       	jmp    80105f17 <alltraps>

8010698f <vector150>:
.globl vector150
vector150:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $150
80106991:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106996:	e9 7c f5 ff ff       	jmp    80105f17 <alltraps>

8010699b <vector151>:
.globl vector151
vector151:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $151
8010699d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069a2:	e9 70 f5 ff ff       	jmp    80105f17 <alltraps>

801069a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $152
801069a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069ae:	e9 64 f5 ff ff       	jmp    80105f17 <alltraps>

801069b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $153
801069b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ba:	e9 58 f5 ff ff       	jmp    80105f17 <alltraps>

801069bf <vector154>:
.globl vector154
vector154:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $154
801069c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069c6:	e9 4c f5 ff ff       	jmp    80105f17 <alltraps>

801069cb <vector155>:
.globl vector155
vector155:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $155
801069cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069d2:	e9 40 f5 ff ff       	jmp    80105f17 <alltraps>

801069d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $156
801069d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069de:	e9 34 f5 ff ff       	jmp    80105f17 <alltraps>

801069e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $157
801069e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069ea:	e9 28 f5 ff ff       	jmp    80105f17 <alltraps>

801069ef <vector158>:
.globl vector158
vector158:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $158
801069f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069f6:	e9 1c f5 ff ff       	jmp    80105f17 <alltraps>

801069fb <vector159>:
.globl vector159
vector159:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $159
801069fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a02:	e9 10 f5 ff ff       	jmp    80105f17 <alltraps>

80106a07 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $160
80106a09:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a0e:	e9 04 f5 ff ff       	jmp    80105f17 <alltraps>

80106a13 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $161
80106a15:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a1a:	e9 f8 f4 ff ff       	jmp    80105f17 <alltraps>

80106a1f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $162
80106a21:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a26:	e9 ec f4 ff ff       	jmp    80105f17 <alltraps>

80106a2b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $163
80106a2d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a32:	e9 e0 f4 ff ff       	jmp    80105f17 <alltraps>

80106a37 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $164
80106a39:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a3e:	e9 d4 f4 ff ff       	jmp    80105f17 <alltraps>

80106a43 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $165
80106a45:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a4a:	e9 c8 f4 ff ff       	jmp    80105f17 <alltraps>

80106a4f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $166
80106a51:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a56:	e9 bc f4 ff ff       	jmp    80105f17 <alltraps>

80106a5b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $167
80106a5d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a62:	e9 b0 f4 ff ff       	jmp    80105f17 <alltraps>

80106a67 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $168
80106a69:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a6e:	e9 a4 f4 ff ff       	jmp    80105f17 <alltraps>

80106a73 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $169
80106a75:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a7a:	e9 98 f4 ff ff       	jmp    80105f17 <alltraps>

80106a7f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $170
80106a81:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a86:	e9 8c f4 ff ff       	jmp    80105f17 <alltraps>

80106a8b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $171
80106a8d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a92:	e9 80 f4 ff ff       	jmp    80105f17 <alltraps>

80106a97 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $172
80106a99:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a9e:	e9 74 f4 ff ff       	jmp    80105f17 <alltraps>

80106aa3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $173
80106aa5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aaa:	e9 68 f4 ff ff       	jmp    80105f17 <alltraps>

80106aaf <vector174>:
.globl vector174
vector174:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $174
80106ab1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ab6:	e9 5c f4 ff ff       	jmp    80105f17 <alltraps>

80106abb <vector175>:
.globl vector175
vector175:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $175
80106abd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ac2:	e9 50 f4 ff ff       	jmp    80105f17 <alltraps>

80106ac7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $176
80106ac9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ace:	e9 44 f4 ff ff       	jmp    80105f17 <alltraps>

80106ad3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $177
80106ad5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106ada:	e9 38 f4 ff ff       	jmp    80105f17 <alltraps>

80106adf <vector178>:
.globl vector178
vector178:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $178
80106ae1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ae6:	e9 2c f4 ff ff       	jmp    80105f17 <alltraps>

80106aeb <vector179>:
.globl vector179
vector179:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $179
80106aed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106af2:	e9 20 f4 ff ff       	jmp    80105f17 <alltraps>

80106af7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $180
80106af9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106afe:	e9 14 f4 ff ff       	jmp    80105f17 <alltraps>

80106b03 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $181
80106b05:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b0a:	e9 08 f4 ff ff       	jmp    80105f17 <alltraps>

80106b0f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $182
80106b11:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b16:	e9 fc f3 ff ff       	jmp    80105f17 <alltraps>

80106b1b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $183
80106b1d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b22:	e9 f0 f3 ff ff       	jmp    80105f17 <alltraps>

80106b27 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $184
80106b29:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b2e:	e9 e4 f3 ff ff       	jmp    80105f17 <alltraps>

80106b33 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $185
80106b35:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b3a:	e9 d8 f3 ff ff       	jmp    80105f17 <alltraps>

80106b3f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $186
80106b41:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b46:	e9 cc f3 ff ff       	jmp    80105f17 <alltraps>

80106b4b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $187
80106b4d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b52:	e9 c0 f3 ff ff       	jmp    80105f17 <alltraps>

80106b57 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $188
80106b59:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b5e:	e9 b4 f3 ff ff       	jmp    80105f17 <alltraps>

80106b63 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $189
80106b65:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b6a:	e9 a8 f3 ff ff       	jmp    80105f17 <alltraps>

80106b6f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $190
80106b71:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b76:	e9 9c f3 ff ff       	jmp    80105f17 <alltraps>

80106b7b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $191
80106b7d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b82:	e9 90 f3 ff ff       	jmp    80105f17 <alltraps>

80106b87 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $192
80106b89:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b8e:	e9 84 f3 ff ff       	jmp    80105f17 <alltraps>

80106b93 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $193
80106b95:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b9a:	e9 78 f3 ff ff       	jmp    80105f17 <alltraps>

80106b9f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $194
80106ba1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ba6:	e9 6c f3 ff ff       	jmp    80105f17 <alltraps>

80106bab <vector195>:
.globl vector195
vector195:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $195
80106bad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bb2:	e9 60 f3 ff ff       	jmp    80105f17 <alltraps>

80106bb7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $196
80106bb9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bbe:	e9 54 f3 ff ff       	jmp    80105f17 <alltraps>

80106bc3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $197
80106bc5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bca:	e9 48 f3 ff ff       	jmp    80105f17 <alltraps>

80106bcf <vector198>:
.globl vector198
vector198:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $198
80106bd1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bd6:	e9 3c f3 ff ff       	jmp    80105f17 <alltraps>

80106bdb <vector199>:
.globl vector199
vector199:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $199
80106bdd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106be2:	e9 30 f3 ff ff       	jmp    80105f17 <alltraps>

80106be7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $200
80106be9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bee:	e9 24 f3 ff ff       	jmp    80105f17 <alltraps>

80106bf3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $201
80106bf5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bfa:	e9 18 f3 ff ff       	jmp    80105f17 <alltraps>

80106bff <vector202>:
.globl vector202
vector202:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $202
80106c01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c06:	e9 0c f3 ff ff       	jmp    80105f17 <alltraps>

80106c0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $203
80106c0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c12:	e9 00 f3 ff ff       	jmp    80105f17 <alltraps>

80106c17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $204
80106c19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c1e:	e9 f4 f2 ff ff       	jmp    80105f17 <alltraps>

80106c23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $205
80106c25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c2a:	e9 e8 f2 ff ff       	jmp    80105f17 <alltraps>

80106c2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $206
80106c31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c36:	e9 dc f2 ff ff       	jmp    80105f17 <alltraps>

80106c3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $207
80106c3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c42:	e9 d0 f2 ff ff       	jmp    80105f17 <alltraps>

80106c47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $208
80106c49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c4e:	e9 c4 f2 ff ff       	jmp    80105f17 <alltraps>

80106c53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $209
80106c55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c5a:	e9 b8 f2 ff ff       	jmp    80105f17 <alltraps>

80106c5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $210
80106c61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c66:	e9 ac f2 ff ff       	jmp    80105f17 <alltraps>

80106c6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $211
80106c6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c72:	e9 a0 f2 ff ff       	jmp    80105f17 <alltraps>

80106c77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $212
80106c79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c7e:	e9 94 f2 ff ff       	jmp    80105f17 <alltraps>

80106c83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $213
80106c85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c8a:	e9 88 f2 ff ff       	jmp    80105f17 <alltraps>

80106c8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $214
80106c91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c96:	e9 7c f2 ff ff       	jmp    80105f17 <alltraps>

80106c9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $215
80106c9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ca2:	e9 70 f2 ff ff       	jmp    80105f17 <alltraps>

80106ca7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $216
80106ca9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cae:	e9 64 f2 ff ff       	jmp    80105f17 <alltraps>

80106cb3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $217
80106cb5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cba:	e9 58 f2 ff ff       	jmp    80105f17 <alltraps>

80106cbf <vector218>:
.globl vector218
vector218:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $218
80106cc1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cc6:	e9 4c f2 ff ff       	jmp    80105f17 <alltraps>

80106ccb <vector219>:
.globl vector219
vector219:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $219
80106ccd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106cd2:	e9 40 f2 ff ff       	jmp    80105f17 <alltraps>

80106cd7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $220
80106cd9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cde:	e9 34 f2 ff ff       	jmp    80105f17 <alltraps>

80106ce3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $221
80106ce5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cea:	e9 28 f2 ff ff       	jmp    80105f17 <alltraps>

80106cef <vector222>:
.globl vector222
vector222:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $222
80106cf1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cf6:	e9 1c f2 ff ff       	jmp    80105f17 <alltraps>

80106cfb <vector223>:
.globl vector223
vector223:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $223
80106cfd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d02:	e9 10 f2 ff ff       	jmp    80105f17 <alltraps>

80106d07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $224
80106d09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d0e:	e9 04 f2 ff ff       	jmp    80105f17 <alltraps>

80106d13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $225
80106d15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d1a:	e9 f8 f1 ff ff       	jmp    80105f17 <alltraps>

80106d1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $226
80106d21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d26:	e9 ec f1 ff ff       	jmp    80105f17 <alltraps>

80106d2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $227
80106d2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d32:	e9 e0 f1 ff ff       	jmp    80105f17 <alltraps>

80106d37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $228
80106d39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d3e:	e9 d4 f1 ff ff       	jmp    80105f17 <alltraps>

80106d43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $229
80106d45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d4a:	e9 c8 f1 ff ff       	jmp    80105f17 <alltraps>

80106d4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $230
80106d51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d56:	e9 bc f1 ff ff       	jmp    80105f17 <alltraps>

80106d5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $231
80106d5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d62:	e9 b0 f1 ff ff       	jmp    80105f17 <alltraps>

80106d67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $232
80106d69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d6e:	e9 a4 f1 ff ff       	jmp    80105f17 <alltraps>

80106d73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $233
80106d75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d7a:	e9 98 f1 ff ff       	jmp    80105f17 <alltraps>

80106d7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $234
80106d81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d86:	e9 8c f1 ff ff       	jmp    80105f17 <alltraps>

80106d8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $235
80106d8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d92:	e9 80 f1 ff ff       	jmp    80105f17 <alltraps>

80106d97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $236
80106d99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d9e:	e9 74 f1 ff ff       	jmp    80105f17 <alltraps>

80106da3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $237
80106da5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106daa:	e9 68 f1 ff ff       	jmp    80105f17 <alltraps>

80106daf <vector238>:
.globl vector238
vector238:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $238
80106db1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106db6:	e9 5c f1 ff ff       	jmp    80105f17 <alltraps>

80106dbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $239
80106dbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dc2:	e9 50 f1 ff ff       	jmp    80105f17 <alltraps>

80106dc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $240
80106dc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dce:	e9 44 f1 ff ff       	jmp    80105f17 <alltraps>

80106dd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $241
80106dd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dda:	e9 38 f1 ff ff       	jmp    80105f17 <alltraps>

80106ddf <vector242>:
.globl vector242
vector242:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $242
80106de1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106de6:	e9 2c f1 ff ff       	jmp    80105f17 <alltraps>

80106deb <vector243>:
.globl vector243
vector243:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $243
80106ded:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106df2:	e9 20 f1 ff ff       	jmp    80105f17 <alltraps>

80106df7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $244
80106df9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dfe:	e9 14 f1 ff ff       	jmp    80105f17 <alltraps>

80106e03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $245
80106e05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e0a:	e9 08 f1 ff ff       	jmp    80105f17 <alltraps>

80106e0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $246
80106e11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e16:	e9 fc f0 ff ff       	jmp    80105f17 <alltraps>

80106e1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $247
80106e1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e22:	e9 f0 f0 ff ff       	jmp    80105f17 <alltraps>

80106e27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $248
80106e29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e2e:	e9 e4 f0 ff ff       	jmp    80105f17 <alltraps>

80106e33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $249
80106e35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e3a:	e9 d8 f0 ff ff       	jmp    80105f17 <alltraps>

80106e3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $250
80106e41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e46:	e9 cc f0 ff ff       	jmp    80105f17 <alltraps>

80106e4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $251
80106e4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e52:	e9 c0 f0 ff ff       	jmp    80105f17 <alltraps>

80106e57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $252
80106e59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e5e:	e9 b4 f0 ff ff       	jmp    80105f17 <alltraps>

80106e63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $253
80106e65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e6a:	e9 a8 f0 ff ff       	jmp    80105f17 <alltraps>

80106e6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $254
80106e71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e76:	e9 9c f0 ff ff       	jmp    80105f17 <alltraps>

80106e7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $255
80106e7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e82:	e9 90 f0 ff ff       	jmp    80105f17 <alltraps>
80106e87:	66 90                	xchg   %ax,%ax
80106e89:	66 90                	xchg   %ax,%ax
80106e8b:	66 90                	xchg   %ax,%ax
80106e8d:	66 90                	xchg   %ax,%ax
80106e8f:	90                   	nop

80106e90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106e9c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ea2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106ea5:	39 d3                	cmp    %edx,%ebx
80106ea7:	73 56                	jae    80106eff <deallocuvm.part.0+0x6f>
80106ea9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106eac:	89 c6                	mov    %eax,%esi
80106eae:	89 d7                	mov    %edx,%edi
80106eb0:	eb 12                	jmp    80106ec4 <deallocuvm.part.0+0x34>
80106eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106eb8:	83 c2 01             	add    $0x1,%edx
80106ebb:	89 d3                	mov    %edx,%ebx
80106ebd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ec0:	39 fb                	cmp    %edi,%ebx
80106ec2:	73 38                	jae    80106efc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106ec4:	89 da                	mov    %ebx,%edx
80106ec6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ec9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106ecc:	a8 01                	test   $0x1,%al
80106ece:	74 e8                	je     80106eb8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106ed0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ed7:	c1 e9 0a             	shr    $0xa,%ecx
80106eda:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106ee0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	74 cd                	je     80106eb8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106eeb:	8b 10                	mov    (%eax),%edx
80106eed:	f6 c2 01             	test   $0x1,%dl
80106ef0:	75 1e                	jne    80106f10 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106ef2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ef8:	39 fb                	cmp    %edi,%ebx
80106efa:	72 c8                	jb     80106ec4 <deallocuvm.part.0+0x34>
80106efc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f02:	89 c8                	mov    %ecx,%eax
80106f04:	5b                   	pop    %ebx
80106f05:	5e                   	pop    %esi
80106f06:	5f                   	pop    %edi
80106f07:	5d                   	pop    %ebp
80106f08:	c3                   	ret
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106f10:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106f16:	74 26                	je     80106f3e <deallocuvm.part.0+0xae>
      kfree(v);
80106f18:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f1b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f24:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106f2a:	52                   	push   %edx
80106f2b:	e8 10 b6 ff ff       	call   80102540 <kfree>
      *pte = 0;
80106f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106f33:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106f36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106f3c:	eb 82                	jmp    80106ec0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106f3e:	83 ec 0c             	sub    $0xc,%esp
80106f41:	68 c6 7a 10 80       	push   $0x80107ac6
80106f46:	e8 35 94 ff ff       	call   80100380 <panic>
80106f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f4f:	90                   	nop

80106f50 <mappages>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f56:	89 d3                	mov    %edx,%ebx
80106f58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f5e:	83 ec 1c             	sub    $0x1c,%esp
80106f61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f70:	8b 45 08             	mov    0x8(%ebp),%eax
80106f73:	29 d8                	sub    %ebx,%eax
80106f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f78:	eb 3f                	jmp    80106fb9 <mappages+0x69>
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106f87:	c1 ea 0a             	shr    $0xa,%edx
80106f8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f97:	85 c0                	test   %eax,%eax
80106f99:	74 75                	je     80107010 <mappages+0xc0>
    if(*pte & PTE_P)
80106f9b:	f6 00 01             	testb  $0x1,(%eax)
80106f9e:	0f 85 86 00 00 00    	jne    8010702a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106fa4:	0b 75 0c             	or     0xc(%ebp),%esi
80106fa7:	83 ce 01             	or     $0x1,%esi
80106faa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fac:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106faf:	39 c3                	cmp    %eax,%ebx
80106fb1:	74 6d                	je     80107020 <mappages+0xd0>
    a += PGSIZE;
80106fb3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106fbc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106fbf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106fc2:	89 d8                	mov    %ebx,%eax
80106fc4:	c1 e8 16             	shr    $0x16,%eax
80106fc7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106fca:	8b 07                	mov    (%edi),%eax
80106fcc:	a8 01                	test   $0x1,%al
80106fce:	75 b0                	jne    80106f80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fd0:	e8 2b b7 ff ff       	call   80102700 <kalloc>
80106fd5:	85 c0                	test   %eax,%eax
80106fd7:	74 37                	je     80107010 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106fd9:	83 ec 04             	sub    $0x4,%esp
80106fdc:	68 00 10 00 00       	push   $0x1000
80106fe1:	6a 00                	push   $0x0
80106fe3:	50                   	push   %eax
80106fe4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106fe7:	e8 14 dc ff ff       	call   80104c00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106fef:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ff2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ff8:	83 c8 07             	or     $0x7,%eax
80106ffb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106ffd:	89 d8                	mov    %ebx,%eax
80106fff:	c1 e8 0a             	shr    $0xa,%eax
80107002:	25 fc 0f 00 00       	and    $0xffc,%eax
80107007:	01 d0                	add    %edx,%eax
80107009:	eb 90                	jmp    80106f9b <mappages+0x4b>
8010700b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010700f:	90                   	nop
}
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107018:	5b                   	pop    %ebx
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107023:	31 c0                	xor    %eax,%eax
}
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret
      panic("remap");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 60 81 10 80       	push   $0x80108160
80107032:	e8 49 93 ff ff       	call   80100380 <panic>
80107037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703e:	66 90                	xchg   %ax,%ax

80107040 <seginit>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107046:	e8 25 ca ff ff       	call   80103a70 <cpuid>
  pd[0] = size-1;
8010704b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107050:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107056:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
8010705d:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107060:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107067:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010706a:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107071:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107074:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010707b:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010707e:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80107085:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107088:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010708f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107092:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107099:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010709c:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801070a3:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070a6:	05 10 28 11 80       	add    $0x80112810,%eax
801070ab:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801070af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070b3:	c1 e8 10             	shr    $0x10,%eax
801070b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070bd:	0f 01 10             	lgdtl  (%eax)
}
801070c0:	c9                   	leave
801070c1:	c3                   	ret
801070c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070d0:	a1 e4 58 11 80       	mov    0x801158e4,%eax
801070d5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070da:	0f 22 d8             	mov    %eax,%cr3
}
801070dd:	c3                   	ret
801070de:	66 90                	xchg   %ax,%ax

801070e0 <switchuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801070ec:	85 f6                	test   %esi,%esi
801070ee:	0f 84 cb 00 00 00    	je     801071bf <switchuvm+0xdf>
  if(p->kstack == 0)
801070f4:	8b 46 08             	mov    0x8(%esi),%eax
801070f7:	85 c0                	test   %eax,%eax
801070f9:	0f 84 da 00 00 00    	je     801071d9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801070ff:	8b 46 04             	mov    0x4(%esi),%eax
80107102:	85 c0                	test   %eax,%eax
80107104:	0f 84 c2 00 00 00    	je     801071cc <switchuvm+0xec>
  pushcli();
8010710a:	e8 11 d9 ff ff       	call   80104a20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010710f:	e8 fc c8 ff ff       	call   80103a10 <mycpu>
80107114:	89 c3                	mov    %eax,%ebx
80107116:	e8 f5 c8 ff ff       	call   80103a10 <mycpu>
8010711b:	89 c7                	mov    %eax,%edi
8010711d:	e8 ee c8 ff ff       	call   80103a10 <mycpu>
80107122:	83 c7 08             	add    $0x8,%edi
80107125:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107128:	e8 e3 c8 ff ff       	call   80103a10 <mycpu>
8010712d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107130:	ba 67 00 00 00       	mov    $0x67,%edx
80107135:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010713c:	83 c0 08             	add    $0x8,%eax
8010713f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107146:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010714b:	83 c1 08             	add    $0x8,%ecx
8010714e:	c1 e8 18             	shr    $0x18,%eax
80107151:	c1 e9 10             	shr    $0x10,%ecx
80107154:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010715a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107160:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107165:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010716c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107171:	e8 9a c8 ff ff       	call   80103a10 <mycpu>
80107176:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010717d:	e8 8e c8 ff ff       	call   80103a10 <mycpu>
80107182:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107186:	8b 5e 08             	mov    0x8(%esi),%ebx
80107189:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010718f:	e8 7c c8 ff ff       	call   80103a10 <mycpu>
80107194:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107197:	e8 74 c8 ff ff       	call   80103a10 <mycpu>
8010719c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071a0:	b8 28 00 00 00       	mov    $0x28,%eax
801071a5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071a8:	8b 46 04             	mov    0x4(%esi),%eax
801071ab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071b0:	0f 22 d8             	mov    %eax,%cr3
}
801071b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b6:	5b                   	pop    %ebx
801071b7:	5e                   	pop    %esi
801071b8:	5f                   	pop    %edi
801071b9:	5d                   	pop    %ebp
  popcli();
801071ba:	e9 91 d9 ff ff       	jmp    80104b50 <popcli>
    panic("switchuvm: no process");
801071bf:	83 ec 0c             	sub    $0xc,%esp
801071c2:	68 66 81 10 80       	push   $0x80108166
801071c7:	e8 b4 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801071cc:	83 ec 0c             	sub    $0xc,%esp
801071cf:	68 91 81 10 80       	push   $0x80108191
801071d4:	e8 a7 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 7c 81 10 80       	push   $0x8010817c
801071e1:	e8 9a 91 ff ff       	call   80100380 <panic>
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <inituvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 45 08             	mov    0x8(%ebp),%eax
801071fc:	8b 75 10             	mov    0x10(%ebp),%esi
801071ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107202:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107205:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010720b:	77 49                	ja     80107256 <inituvm+0x66>
  mem = kalloc();
8010720d:	e8 ee b4 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80107212:	83 ec 04             	sub    $0x4,%esp
80107215:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010721a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010721c:	6a 00                	push   $0x0
8010721e:	50                   	push   %eax
8010721f:	e8 dc d9 ff ff       	call   80104c00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107224:	58                   	pop    %eax
80107225:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010722b:	5a                   	pop    %edx
8010722c:	6a 06                	push   $0x6
8010722e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107233:	31 d2                	xor    %edx,%edx
80107235:	50                   	push   %eax
80107236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107239:	e8 12 fd ff ff       	call   80106f50 <mappages>
  memmove(mem, init, sz);
8010723e:	89 75 10             	mov    %esi,0x10(%ebp)
80107241:	83 c4 10             	add    $0x10,%esp
80107244:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107247:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010724a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724d:	5b                   	pop    %ebx
8010724e:	5e                   	pop    %esi
8010724f:	5f                   	pop    %edi
80107250:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107251:	e9 3a da ff ff       	jmp    80104c90 <memmove>
    panic("inituvm: more than a page");
80107256:	83 ec 0c             	sub    $0xc,%esp
80107259:	68 a5 81 10 80       	push   $0x801081a5
8010725e:	e8 1d 91 ff ff       	call   80100380 <panic>
80107263:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107270 <loaduvm>:
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107279:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010727c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010727f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107285:	0f 85 a2 00 00 00    	jne    8010732d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010728b:	85 ff                	test   %edi,%edi
8010728d:	74 7d                	je     8010730c <loaduvm+0x9c>
8010728f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107290:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107293:	8b 55 08             	mov    0x8(%ebp),%edx
80107296:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107298:	89 c1                	mov    %eax,%ecx
8010729a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010729d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801072a0:	f6 c1 01             	test   $0x1,%cl
801072a3:	75 13                	jne    801072b8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801072a5:	83 ec 0c             	sub    $0xc,%esp
801072a8:	68 bf 81 10 80       	push   $0x801081bf
801072ad:	e8 ce 90 ff ff       	call   80100380 <panic>
801072b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072b8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072bb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801072c1:	25 fc 0f 00 00       	and    $0xffc,%eax
801072c6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072cd:	85 c9                	test   %ecx,%ecx
801072cf:	74 d4                	je     801072a5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801072d1:	89 fb                	mov    %edi,%ebx
801072d3:	b8 00 10 00 00       	mov    $0x1000,%eax
801072d8:	29 f3                	sub    %esi,%ebx
801072da:	39 c3                	cmp    %eax,%ebx
801072dc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072df:	53                   	push   %ebx
801072e0:	8b 45 14             	mov    0x14(%ebp),%eax
801072e3:	01 f0                	add    %esi,%eax
801072e5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801072e6:	8b 01                	mov    (%ecx),%eax
801072e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072ed:	05 00 00 00 80       	add    $0x80000000,%eax
801072f2:	50                   	push   %eax
801072f3:	ff 75 10             	push   0x10(%ebp)
801072f6:	e8 05 a8 ff ff       	call   80101b00 <readi>
801072fb:	83 c4 10             	add    $0x10,%esp
801072fe:	39 d8                	cmp    %ebx,%eax
80107300:	75 1e                	jne    80107320 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107302:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107308:	39 fe                	cmp    %edi,%esi
8010730a:	72 84                	jb     80107290 <loaduvm+0x20>
}
8010730c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010730f:	31 c0                	xor    %eax,%eax
}
80107311:	5b                   	pop    %ebx
80107312:	5e                   	pop    %esi
80107313:	5f                   	pop    %edi
80107314:	5d                   	pop    %ebp
80107315:	c3                   	ret
80107316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010732d:	83 ec 0c             	sub    $0xc,%esp
80107330:	68 60 82 10 80       	push   $0x80108260
80107335:	e8 46 90 ff ff       	call   80100380 <panic>
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <allocuvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 1c             	sub    $0x1c,%esp
80107349:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010734c:	85 f6                	test   %esi,%esi
8010734e:	0f 88 98 00 00 00    	js     801073ec <allocuvm+0xac>
80107354:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107356:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107359:	0f 82 a1 00 00 00    	jb     80107400 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010735f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107362:	05 ff 0f 00 00       	add    $0xfff,%eax
80107367:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010736c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010736e:	39 f0                	cmp    %esi,%eax
80107370:	0f 83 8d 00 00 00    	jae    80107403 <allocuvm+0xc3>
80107376:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107379:	eb 44                	jmp    801073bf <allocuvm+0x7f>
8010737b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010737f:	90                   	nop
    memset(mem, 0, PGSIZE);
80107380:	83 ec 04             	sub    $0x4,%esp
80107383:	68 00 10 00 00       	push   $0x1000
80107388:	6a 00                	push   $0x0
8010738a:	50                   	push   %eax
8010738b:	e8 70 d8 ff ff       	call   80104c00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107390:	58                   	pop    %eax
80107391:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107397:	5a                   	pop    %edx
80107398:	6a 06                	push   $0x6
8010739a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010739f:	89 fa                	mov    %edi,%edx
801073a1:	50                   	push   %eax
801073a2:	8b 45 08             	mov    0x8(%ebp),%eax
801073a5:	e8 a6 fb ff ff       	call   80106f50 <mappages>
801073aa:	83 c4 10             	add    $0x10,%esp
801073ad:	85 c0                	test   %eax,%eax
801073af:	78 5f                	js     80107410 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801073b1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073b7:	39 f7                	cmp    %esi,%edi
801073b9:	0f 83 89 00 00 00    	jae    80107448 <allocuvm+0x108>
    mem = kalloc();
801073bf:	e8 3c b3 ff ff       	call   80102700 <kalloc>
801073c4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073c6:	85 c0                	test   %eax,%eax
801073c8:	75 b6                	jne    80107380 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073ca:	83 ec 0c             	sub    $0xc,%esp
801073cd:	68 dd 81 10 80       	push   $0x801081dd
801073d2:	e8 d9 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801073d7:	83 c4 10             	add    $0x10,%esp
801073da:	3b 75 0c             	cmp    0xc(%ebp),%esi
801073dd:	74 0d                	je     801073ec <allocuvm+0xac>
801073df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073e2:	8b 45 08             	mov    0x8(%ebp),%eax
801073e5:	89 f2                	mov    %esi,%edx
801073e7:	e8 a4 fa ff ff       	call   80106e90 <deallocuvm.part.0>
    return 0;
801073ec:	31 d2                	xor    %edx,%edx
}
801073ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f1:	89 d0                	mov    %edx,%eax
801073f3:	5b                   	pop    %ebx
801073f4:	5e                   	pop    %esi
801073f5:	5f                   	pop    %edi
801073f6:	5d                   	pop    %ebp
801073f7:	c3                   	ret
801073f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ff:	90                   	nop
    return oldsz;
80107400:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107406:	89 d0                	mov    %edx,%eax
80107408:	5b                   	pop    %ebx
80107409:	5e                   	pop    %esi
8010740a:	5f                   	pop    %edi
8010740b:	5d                   	pop    %ebp
8010740c:	c3                   	ret
8010740d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107410:	83 ec 0c             	sub    $0xc,%esp
80107413:	68 f5 81 10 80       	push   $0x801081f5
80107418:	e8 93 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
8010741d:	83 c4 10             	add    $0x10,%esp
80107420:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107423:	74 0d                	je     80107432 <allocuvm+0xf2>
80107425:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107428:	8b 45 08             	mov    0x8(%ebp),%eax
8010742b:	89 f2                	mov    %esi,%edx
8010742d:	e8 5e fa ff ff       	call   80106e90 <deallocuvm.part.0>
      kfree(mem);
80107432:	83 ec 0c             	sub    $0xc,%esp
80107435:	53                   	push   %ebx
80107436:	e8 05 b1 ff ff       	call   80102540 <kfree>
      return 0;
8010743b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010743e:	31 d2                	xor    %edx,%edx
80107440:	eb ac                	jmp    801073ee <allocuvm+0xae>
80107442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107448:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010744b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010744e:	5b                   	pop    %ebx
8010744f:	5e                   	pop    %esi
80107450:	89 d0                	mov    %edx,%eax
80107452:	5f                   	pop    %edi
80107453:	5d                   	pop    %ebp
80107454:	c3                   	ret
80107455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107460 <deallocuvm>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	8b 55 0c             	mov    0xc(%ebp),%edx
80107466:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107469:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010746c:	39 d1                	cmp    %edx,%ecx
8010746e:	73 10                	jae    80107480 <deallocuvm+0x20>
}
80107470:	5d                   	pop    %ebp
80107471:	e9 1a fa ff ff       	jmp    80106e90 <deallocuvm.part.0>
80107476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747d:	8d 76 00             	lea    0x0(%esi),%esi
80107480:	89 d0                	mov    %edx,%eax
80107482:	5d                   	pop    %ebp
80107483:	c3                   	ret
80107484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010748f:	90                   	nop

80107490 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 0c             	sub    $0xc,%esp
80107499:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010749c:	85 f6                	test   %esi,%esi
8010749e:	74 59                	je     801074f9 <freevm+0x69>
  if(newsz >= oldsz)
801074a0:	31 c9                	xor    %ecx,%ecx
801074a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074a7:	89 f0                	mov    %esi,%eax
801074a9:	89 f3                	mov    %esi,%ebx
801074ab:	e8 e0 f9 ff ff       	call   80106e90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074b6:	eb 0f                	jmp    801074c7 <freevm+0x37>
801074b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop
801074c0:	83 c3 04             	add    $0x4,%ebx
801074c3:	39 fb                	cmp    %edi,%ebx
801074c5:	74 23                	je     801074ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074c7:	8b 03                	mov    (%ebx),%eax
801074c9:	a8 01                	test   $0x1,%al
801074cb:	74 f3                	je     801074c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074dd:	50                   	push   %eax
801074de:	e8 5d b0 ff ff       	call   80102540 <kfree>
801074e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074e6:	39 fb                	cmp    %edi,%ebx
801074e8:	75 dd                	jne    801074c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801074ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f0:	5b                   	pop    %ebx
801074f1:	5e                   	pop    %esi
801074f2:	5f                   	pop    %edi
801074f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074f4:	e9 47 b0 ff ff       	jmp    80102540 <kfree>
    panic("freevm: no pgdir");
801074f9:	83 ec 0c             	sub    $0xc,%esp
801074fc:	68 11 82 10 80       	push   $0x80108211
80107501:	e8 7a 8e ff ff       	call   80100380 <panic>
80107506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750d:	8d 76 00             	lea    0x0(%esi),%esi

80107510 <setupkvm>:
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	56                   	push   %esi
80107514:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107515:	e8 e6 b1 ff ff       	call   80102700 <kalloc>
8010751a:	85 c0                	test   %eax,%eax
8010751c:	74 5e                	je     8010757c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010751e:	83 ec 04             	sub    $0x4,%esp
80107521:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107523:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107528:	68 00 10 00 00       	push   $0x1000
8010752d:	6a 00                	push   $0x0
8010752f:	50                   	push   %eax
80107530:	e8 cb d6 ff ff       	call   80104c00 <memset>
80107535:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107538:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010753b:	83 ec 08             	sub    $0x8,%esp
8010753e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107541:	8b 13                	mov    (%ebx),%edx
80107543:	ff 73 0c             	push   0xc(%ebx)
80107546:	50                   	push   %eax
80107547:	29 c1                	sub    %eax,%ecx
80107549:	89 f0                	mov    %esi,%eax
8010754b:	e8 00 fa ff ff       	call   80106f50 <mappages>
80107550:	83 c4 10             	add    $0x10,%esp
80107553:	85 c0                	test   %eax,%eax
80107555:	78 19                	js     80107570 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107557:	83 c3 10             	add    $0x10,%ebx
8010755a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107560:	75 d6                	jne    80107538 <setupkvm+0x28>
}
80107562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107565:	89 f0                	mov    %esi,%eax
80107567:	5b                   	pop    %ebx
80107568:	5e                   	pop    %esi
80107569:	5d                   	pop    %ebp
8010756a:	c3                   	ret
8010756b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010756f:	90                   	nop
      freevm(pgdir);
80107570:	83 ec 0c             	sub    $0xc,%esp
80107573:	56                   	push   %esi
80107574:	e8 17 ff ff ff       	call   80107490 <freevm>
      return 0;
80107579:	83 c4 10             	add    $0x10,%esp
}
8010757c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010757f:	31 f6                	xor    %esi,%esi
}
80107581:	89 f0                	mov    %esi,%eax
80107583:	5b                   	pop    %ebx
80107584:	5e                   	pop    %esi
80107585:	5d                   	pop    %ebp
80107586:	c3                   	ret
80107587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758e:	66 90                	xchg   %ax,%ax

80107590 <kvmalloc>:
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107596:	e8 75 ff ff ff       	call   80107510 <setupkvm>
8010759b:	a3 e4 58 11 80       	mov    %eax,0x801158e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075a0:	05 00 00 00 80       	add    $0x80000000,%eax
801075a5:	0f 22 d8             	mov    %eax,%cr3
}
801075a8:	c9                   	leave
801075a9:	c3                   	ret
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	83 ec 08             	sub    $0x8,%esp
801075b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075bc:	89 c1                	mov    %eax,%ecx
801075be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075c4:	f6 c2 01             	test   $0x1,%dl
801075c7:	75 17                	jne    801075e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	68 22 82 10 80       	push   $0x80108222
801075d1:	e8 aa 8d ff ff       	call   80100380 <panic>
801075d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075dd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801075e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801075e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801075ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801075f5:	85 c0                	test   %eax,%eax
801075f7:	74 d0                	je     801075c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801075f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075fc:	c9                   	leave
801075fd:	c3                   	ret
801075fe:	66 90                	xchg   %ax,%ax

80107600 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107609:	e8 02 ff ff ff       	call   80107510 <setupkvm>
8010760e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107611:	85 c0                	test   %eax,%eax
80107613:	0f 84 dd 00 00 00    	je     801076f6 <copyuvm+0xf6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107619:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010761c:	85 c9                	test   %ecx,%ecx
8010761e:	0f 84 b3 00 00 00    	je     801076d7 <copyuvm+0xd7>
80107624:	31 f6                	xor    %esi,%esi
80107626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107630:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107633:	89 f0                	mov    %esi,%eax
80107635:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107638:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010763b:	a8 01                	test   $0x1,%al
8010763d:	75 11                	jne    80107650 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010763f:	83 ec 0c             	sub    $0xc,%esp
80107642:	68 2c 82 10 80       	push   $0x8010822c
80107647:	e8 34 8d ff ff       	call   80100380 <panic>
8010764c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107650:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107652:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107657:	c1 ea 0a             	shr    $0xa,%edx
8010765a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107660:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107667:	85 c0                	test   %eax,%eax
80107669:	74 d4                	je     8010763f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010766b:	8b 18                	mov    (%eax),%ebx
8010766d:	f6 c3 01             	test   $0x1,%bl
80107670:	0f 84 92 00 00 00    	je     80107708 <copyuvm+0x108>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107676:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107678:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
8010767e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107684:	e8 77 b0 ff ff       	call   80102700 <kalloc>
80107689:	85 c0                	test   %eax,%eax
8010768b:	74 5b                	je     801076e8 <copyuvm+0xe8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010768d:	83 ec 04             	sub    $0x4,%esp
80107690:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107696:	68 00 10 00 00       	push   $0x1000
8010769b:	57                   	push   %edi
8010769c:	50                   	push   %eax
8010769d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076a0:	e8 eb d5 ff ff       	call   80104c90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801076a5:	58                   	pop    %eax
801076a6:	5a                   	pop    %edx
801076a7:	53                   	push   %ebx
801076a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076ab:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076b0:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801076b6:	52                   	push   %edx
801076b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076ba:	89 f2                	mov    %esi,%edx
801076bc:	e8 8f f8 ff ff       	call   80106f50 <mappages>
801076c1:	83 c4 10             	add    $0x10,%esp
801076c4:	85 c0                	test   %eax,%eax
801076c6:	78 20                	js     801076e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801076c8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076ce:	3b 75 0c             	cmp    0xc(%ebp),%esi
801076d1:	0f 82 59 ff ff ff    	jb     80107630 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801076d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076dd:	5b                   	pop    %ebx
801076de:	5e                   	pop    %esi
801076df:	5f                   	pop    %edi
801076e0:	5d                   	pop    %ebp
801076e1:	c3                   	ret
801076e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(d);
801076e8:	83 ec 0c             	sub    $0xc,%esp
801076eb:	ff 75 e0             	push   -0x20(%ebp)
801076ee:	e8 9d fd ff ff       	call   80107490 <freevm>
  return 0;
801076f3:	83 c4 10             	add    $0x10,%esp
    return 0;
801076f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801076fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107703:	5b                   	pop    %ebx
80107704:	5e                   	pop    %esi
80107705:	5f                   	pop    %edi
80107706:	5d                   	pop    %ebp
80107707:	c3                   	ret
      panic("copyuvm: page not present");
80107708:	83 ec 0c             	sub    $0xc,%esp
8010770b:	68 46 82 10 80       	push   $0x80108246
80107710:	e8 6b 8c ff ff       	call   80100380 <panic>
80107715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010771c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107720 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107726:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107729:	89 c1                	mov    %eax,%ecx
8010772b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010772e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107731:	f6 c2 01             	test   $0x1,%dl
80107734:	0f 84 00 01 00 00    	je     8010783a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010773a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010773d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107743:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107744:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107749:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107750:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107752:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107757:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010775a:	05 00 00 00 80       	add    $0x80000000,%eax
8010775f:	83 fa 05             	cmp    $0x5,%edx
80107762:	ba 00 00 00 00       	mov    $0x0,%edx
80107767:	0f 45 c2             	cmovne %edx,%eax
}
8010776a:	c3                   	ret
8010776b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010776f:	90                   	nop

80107770 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	57                   	push   %edi
80107774:	56                   	push   %esi
80107775:	53                   	push   %ebx
80107776:	83 ec 0c             	sub    $0xc,%esp
80107779:	8b 75 14             	mov    0x14(%ebp),%esi
8010777c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010777f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107782:	85 f6                	test   %esi,%esi
80107784:	75 51                	jne    801077d7 <copyout+0x67>
80107786:	e9 a5 00 00 00       	jmp    80107830 <copyout+0xc0>
8010778b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010778f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107790:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107796:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010779c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801077a2:	74 75                	je     80107819 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801077a4:	89 fb                	mov    %edi,%ebx
801077a6:	29 c3                	sub    %eax,%ebx
801077a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077ae:	39 f3                	cmp    %esi,%ebx
801077b0:	0f 47 de             	cmova  %esi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077b3:	29 f8                	sub    %edi,%eax
801077b5:	83 ec 04             	sub    $0x4,%esp
801077b8:	01 c1                	add    %eax,%ecx
801077ba:	53                   	push   %ebx
801077bb:	52                   	push   %edx
801077bc:	89 55 10             	mov    %edx,0x10(%ebp)
801077bf:	51                   	push   %ecx
801077c0:	e8 cb d4 ff ff       	call   80104c90 <memmove>
    len -= n;
    buf += n;
801077c5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801077c8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801077ce:	83 c4 10             	add    $0x10,%esp
    buf += n;
801077d1:	01 da                	add    %ebx,%edx
  while(len > 0){
801077d3:	29 de                	sub    %ebx,%esi
801077d5:	74 59                	je     80107830 <copyout+0xc0>
  if(*pde & PTE_P){
801077d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801077da:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077dc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801077de:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077e1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801077e7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801077ea:	f6 c1 01             	test   $0x1,%cl
801077ed:	0f 84 4e 00 00 00    	je     80107841 <copyout.cold>
  return &pgtab[PTX(va)];
801077f3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801077fb:	c1 eb 0c             	shr    $0xc,%ebx
801077fe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107804:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010780b:	89 d9                	mov    %ebx,%ecx
8010780d:	83 e1 05             	and    $0x5,%ecx
80107810:	83 f9 05             	cmp    $0x5,%ecx
80107813:	0f 84 77 ff ff ff    	je     80107790 <copyout+0x20>
  }
  return 0;
}
80107819:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010781c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107821:	5b                   	pop    %ebx
80107822:	5e                   	pop    %esi
80107823:	5f                   	pop    %edi
80107824:	5d                   	pop    %ebp
80107825:	c3                   	ret
80107826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782d:	8d 76 00             	lea    0x0(%esi),%esi
80107830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107833:	31 c0                	xor    %eax,%eax
}
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret

8010783a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010783a:	a1 00 00 00 00       	mov    0x0,%eax
8010783f:	0f 0b                	ud2

80107841 <copyout.cold>:
80107841:	a1 00 00 00 00       	mov    0x0,%eax
80107846:	0f 0b                	ud2
