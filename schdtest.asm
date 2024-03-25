
_schdtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "\n");
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "\n>>>>> Test case 1: testing default scheduler (RR) ...\n");
  11:	68 74 0a 00 00       	push   $0xa74
  16:	6a 01                	push   $0x1
  18:	e8 83 06 00 00       	call   6a0 <printf>
    run_test(SCHEDULER_DEFAULT, 0);
  1d:	58                   	pop    %eax
  1e:	5a                   	pop    %edx
  1f:	6a 00                	push   $0x0
  21:	6a 00                	push   $0x0
  23:	e8 18 02 00 00       	call   240 <run_test>

    printf(1, "\n\n>>>>> Test case 2: testing MLFQ scheduler with default allotment ...\n");
  28:	59                   	pop    %ecx
  29:	58                   	pop    %eax
  2a:	68 ac 0a 00 00       	push   $0xaac
  2f:	6a 01                	push   $0x1
  31:	e8 6a 06 00 00       	call   6a0 <printf>
    run_test(SCHEDULER_MLFQ, 0);
  36:	58                   	pop    %eax
  37:	5a                   	pop    %edx
  38:	6a 00                	push   $0x0
  3a:	6a 01                	push   $0x1
  3c:	e8 ff 01 00 00       	call   240 <run_test>

    printf(1, "\n\n>>>>> Test case 3: testing default scheduler (RR) ..\n");
  41:	59                   	pop    %ecx
  42:	58                   	pop    %eax
  43:	68 f4 0a 00 00       	push   $0xaf4
  48:	6a 01                	push   $0x1
  4a:	e8 51 06 00 00       	call   6a0 <printf>
    run_test(SCHEDULER_DEFAULT, 0);
  4f:	58                   	pop    %eax
  50:	5a                   	pop    %edx
  51:	6a 00                	push   $0x0
  53:	6a 00                	push   $0x0
  55:	e8 e6 01 00 00       	call   240 <run_test>

    printf(1, "\n\n>>>>> Test case 4: testing MLFQ scheduler with runtime generated process ...\n");
  5a:	59                   	pop    %ecx
  5b:	58                   	pop    %eax
  5c:	68 2c 0b 00 00       	push   $0xb2c
  61:	6a 01                	push   $0x1
  63:	e8 38 06 00 00       	call   6a0 <printf>
    run_test(SCHEDULER_MLFQ, 1);
  68:	58                   	pop    %eax
  69:	5a                   	pop    %edx
  6a:	6a 01                	push   $0x1
  6c:	6a 01                	push   $0x1
  6e:	e8 cd 01 00 00       	call   240 <run_test>


    printf(1, "\n\n>>>>> Test case 5: testing MLFQ scheduler with new allotments ...\n");
  73:	59                   	pop    %ecx
  74:	58                   	pop    %eax
  75:	68 7c 0b 00 00       	push   $0xb7c
  7a:	6a 01                	push   $0x1
  7c:	e8 1f 06 00 00       	call   6a0 <printf>
    mlfq_set_allotment(3, 4);
  81:	58                   	pop    %eax
  82:	5a                   	pop    %edx
  83:	6a 04                	push   $0x4
  85:	6a 03                	push   $0x3
  87:	e8 5f 05 00 00       	call   5eb <mlfq_set_allotment>
    mlfq_set_allotment(2, 8);
  8c:	59                   	pop    %ecx
  8d:	58                   	pop    %eax
  8e:	6a 08                	push   $0x8
  90:	6a 02                	push   $0x2
  92:	e8 54 05 00 00       	call   5eb <mlfq_set_allotment>
    run_test(SCHEDULER_MLFQ, 0);
  97:	58                   	pop    %eax
  98:	5a                   	pop    %edx
  99:	6a 00                	push   $0x0
  9b:	6a 01                	push   $0x1
  9d:	e8 9e 01 00 00       	call   240 <run_test>
    // Change allotments back to default values
    mlfq_set_allotment(3, 2);
  a2:	59                   	pop    %ecx
  a3:	58                   	pop    %eax
  a4:	6a 02                	push   $0x2
  a6:	6a 03                	push   $0x3
  a8:	e8 3e 05 00 00       	call   5eb <mlfq_set_allotment>
    mlfq_set_allotment(2, 4);
  ad:	58                   	pop    %eax
  ae:	5a                   	pop    %edx
  af:	6a 04                	push   $0x4
  b1:	6a 02                	push   $0x2
  b3:	e8 33 05 00 00       	call   5eb <mlfq_set_allotment>
    
    exit();
  b8:	e8 66 04 00 00       	call   523 <exit>
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <usage>:
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "Usage: %s scheduler_type \n"
  c6:	ff 75 08             	push   0x8(%ebp)
  c9:	68 c8 09 00 00       	push   $0x9c8
  ce:	6a 01                	push   $0x1
  d0:	e8 cb 05 00 00       	call   6a0 <printf>
}
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	c9                   	leave
  d9:	c3                   	ret
  da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000e0 <computation>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
    while(n < loop)
  e3:	8b 55 0c             	mov    0xc(%ebp),%edx
{
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
    while(n < loop)
  e9:	39 d0                	cmp    %edx,%eax
    int tmp = 0;
  eb:	ba 00 00 00 00       	mov    $0x0,%edx
    while(n < loop)
  f0:	7d 12                	jge    104 <computation+0x24>
  f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
        tmp += n;
  fb:	01 c2                	add    %eax,%edx
        n++;
  fd:	83 c0 01             	add    $0x1,%eax
    while(n < loop)
 100:	39 c1                	cmp    %eax,%ecx
 102:	7f f4                	jg     f8 <computation+0x18>
}
 104:	89 d0                	mov    %edx,%eax
 106:	5d                   	pop    %ebp
 107:	c3                   	ret
 108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10f:	90                   	nop

00000110 <create_child_processes>:
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	56                   	push   %esi
 114:	be 03 00 00 00       	mov    $0x3,%esi
 119:	53                   	push   %ebx
        pid = fork();
 11a:	e8 fc 03 00 00       	call   51b <fork>
 11f:	89 c3                	mov    %eax,%ebx
        if (pid < 0)
 121:	85 c0                	test   %eax,%eax
 123:	0f 88 9b 00 00 00    	js     1c4 <create_child_processes+0xb4>
        else if (pid == 0) // child
 129:	74 35                	je     160 <create_child_processes+0x50>
            printf(1, "Parent: child (pid=%d) created!\n", pid);
 12b:	83 ec 04             	sub    $0x4,%esp
 12e:	50                   	push   %eax
 12f:	68 50 0a 00 00       	push   $0xa50
 134:	6a 01                	push   $0x1
 136:	e8 65 05 00 00       	call   6a0 <printf>
    for (i = 0; i < CHILD_COUNT; i++)
 13b:	83 c4 10             	add    $0x10,%esp
 13e:	83 ee 01             	sub    $0x1,%esi
 141:	75 d7                	jne    11a <create_child_processes+0xa>
    printf(1, "\n");
 143:	83 ec 08             	sub    $0x8,%esp
 146:	68 cf 0b 00 00       	push   $0xbcf
 14b:	6a 01                	push   $0x1
 14d:	e8 4e 05 00 00       	call   6a0 <printf>
}
 152:	83 c4 10             	add    $0x10,%esp
 155:	8d 65 f8             	lea    -0x8(%ebp),%esp
 158:	5b                   	pop    %ebx
 159:	5e                   	pop    %esi
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n < loop)
 160:	31 c0                	xor    %eax,%eax
 162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        n++;
 168:	83 c0 01             	add    $0x1,%eax
    while(n < loop)
 16b:	3d 00 00 00 02       	cmp    $0x2000000,%eax
 170:	7c f6                	jl     168 <create_child_processes+0x58>
            if (with_rg_proc 
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	85 c0                	test   %eax,%eax
 177:	74 27                	je     1a0 <create_child_processes+0x90>
                && getpid() % CHILD_COUNT == 0)
 179:	e8 25 04 00 00       	call   5a3 <getpid>
 17e:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
 184:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
 189:	3d 54 55 55 55       	cmp    $0x55555554,%eax
 18e:	77 10                	ja     1a0 <create_child_processes+0x90>
                int r = fork();
 190:	e8 86 03 00 00       	call   51b <fork>
                if (r == 0)
 195:	85 c0                	test   %eax,%eax
 197:	74 3f                	je     1d8 <create_child_processes+0xc8>
                else if (r > 0)
 199:	7e 15                	jle    1b0 <create_child_processes+0xa0>
                    wait();
 19b:	e8 8b 03 00 00       	call   52b <wait>
        n++;
 1a0:	83 c3 01             	add    $0x1,%ebx
    while(n < loop)
 1a3:	81 fb 00 00 00 02    	cmp    $0x2000000,%ebx
 1a9:	7c f5                	jl     1a0 <create_child_processes+0x90>
                    exit();
 1ab:	e8 73 03 00 00       	call   523 <exit>
                    printf(1, "Generating RG process failed!\n");
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	68 30 0a 00 00       	push   $0xa30
 1b8:	6a 01                	push   $0x1
 1ba:	e8 e1 04 00 00       	call   6a0 <printf>
                    exit();
 1bf:	e8 5f 03 00 00       	call   523 <exit>
            printf(1, "fork() failed!\n");
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	68 c1 0b 00 00       	push   $0xbc1
 1cc:	6a 01                	push   $0x1
 1ce:	e8 cd 04 00 00       	call   6a0 <printf>
            exit();
 1d3:	e8 4b 03 00 00       	call   523 <exit>
    while(n < loop)
 1d8:	31 d2                	xor    %edx,%edx
 1da:	eb 03                	jmp    1df <create_child_processes+0xcf>
        n++;
 1dc:	83 c2 01             	add    $0x1,%edx
    while(n < loop)
 1df:	81 fa 00 00 00 02    	cmp    $0x2000000,%edx
 1e5:	7c f5                	jl     1dc <create_child_processes+0xcc>
 1e7:	eb 03                	jmp    1ec <create_child_processes+0xdc>
        n++;
 1e9:	83 c0 01             	add    $0x1,%eax
    while(n < loop)
 1ec:	3d 00 00 00 02       	cmp    $0x2000000,%eax
 1f1:	7c f6                	jl     1e9 <create_child_processes+0xd9>
 1f3:	eb b6                	jmp    1ab <create_child_processes+0x9b>
 1f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000200 <wait_child_processes>:
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
    for (i = 0; i < CHILD_COUNT; i++)
 204:	31 db                	xor    %ebx,%ebx
{
 206:	83 ec 04             	sub    $0x4,%esp
        if (wait() < 0)
 209:	e8 1d 03 00 00       	call   52b <wait>
 20e:	85 c0                	test   %eax,%eax
 210:	78 0e                	js     220 <wait_child_processes+0x20>
    for (i = 0; i < CHILD_COUNT; i++)
 212:	83 c3 01             	add    $0x1,%ebx
 215:	83 fb 03             	cmp    $0x3,%ebx
 218:	75 ef                	jne    209 <wait_child_processes+0x9>
}
 21a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 21d:	c9                   	leave
 21e:	c3                   	ret
 21f:	90                   	nop
            printf(1, "wait() on child-%d failed!\n", i);
 220:	83 ec 04             	sub    $0x4,%esp
 223:	53                   	push   %ebx
 224:	68 d1 0b 00 00       	push   $0xbd1
 229:	6a 01                	push   $0x1
 22b:	e8 70 04 00 00       	call   6a0 <printf>
 230:	83 c4 10             	add    $0x10,%esp
 233:	eb dd                	jmp    212 <wait_child_processes+0x12>
 235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <run_test>:
{    
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
 245:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 248:	8b 75 08             	mov    0x8(%ebp),%esi
    enable_sched_trace(1);
 24b:	83 ec 0c             	sub    $0xc,%esp
 24e:	6a 01                	push   $0x1
 250:	e8 76 03 00 00       	call   5cb <enable_sched_trace>
    set_sched(scheduler_type); 
 255:	89 34 24             	mov    %esi,(%esp)
 258:	e8 76 03 00 00       	call   5d3 <set_sched>
    pause_scheduling(1);
 25d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 264:	e8 7a 03 00 00       	call   5e3 <pause_scheduling>
    create_child_processes(with_rg_proc);
 269:	89 1c 24             	mov    %ebx,(%esp)
    for (i = 0; i < CHILD_COUNT; i++)
 26c:	31 db                	xor    %ebx,%ebx
    create_child_processes(with_rg_proc);
 26e:	e8 9d fe ff ff       	call   110 <create_child_processes>
    pause_scheduling(0);
 273:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 27a:	e8 64 03 00 00       	call   5e3 <pause_scheduling>
 27f:	83 c4 10             	add    $0x10,%esp
        if (wait() < 0)
 282:	e8 a4 02 00 00       	call   52b <wait>
 287:	85 c0                	test   %eax,%eax
 289:	78 35                	js     2c0 <run_test+0x80>
    for (i = 0; i < CHILD_COUNT; i++)
 28b:	83 c3 01             	add    $0x1,%ebx
 28e:	83 fb 03             	cmp    $0x3,%ebx
 291:	75 ef                	jne    282 <run_test+0x42>
    enable_sched_trace(0);
 293:	83 ec 0c             	sub    $0xc,%esp
 296:	6a 00                	push   $0x0
 298:	e8 2e 03 00 00       	call   5cb <enable_sched_trace>
    printf(1, "\n");
 29d:	c7 45 0c cf 0b 00 00 	movl   $0xbcf,0xc(%ebp)
 2a4:	83 c4 10             	add    $0x10,%esp
 2a7:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 2ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b1:	5b                   	pop    %ebx
 2b2:	5e                   	pop    %esi
 2b3:	5d                   	pop    %ebp
    printf(1, "\n");
 2b4:	e9 e7 03 00 00       	jmp    6a0 <printf>
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "wait() on child-%d failed!\n", i);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	53                   	push   %ebx
 2c4:	68 d1 0b 00 00       	push   $0xbd1
 2c9:	6a 01                	push   $0x1
 2cb:	e8 d0 03 00 00       	call   6a0 <printf>
 2d0:	83 c4 10             	add    $0x10,%esp
 2d3:	eb b6                	jmp    28b <run_test+0x4b>
 2d5:	66 90                	xchg   %ax,%ax
 2d7:	66 90                	xchg   %ax,%ax
 2d9:	66 90                	xchg   %ax,%ax
 2db:	66 90                	xchg   %ax,%ax
 2dd:	66 90                	xchg   %ax,%ax
 2df:	90                   	nop

000002e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2e0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e1:	31 c0                	xor    %eax,%eax
{
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	53                   	push   %ebx
 2e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2f7:	83 c0 01             	add    $0x1,%eax
 2fa:	84 d2                	test   %dl,%dl
 2fc:	75 f2                	jne    2f0 <strcpy+0x10>
    ;
  return os;
}
 2fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 301:	89 c8                	mov    %ecx,%eax
 303:	c9                   	leave
 304:	c3                   	ret
 305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 55 08             	mov    0x8(%ebp),%edx
 317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 31a:	0f b6 02             	movzbl (%edx),%eax
 31d:	84 c0                	test   %al,%al
 31f:	75 17                	jne    338 <strcmp+0x28>
 321:	eb 3a                	jmp    35d <strcmp+0x4d>
 323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 327:	90                   	nop
 328:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 32c:	83 c2 01             	add    $0x1,%edx
 32f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 332:	84 c0                	test   %al,%al
 334:	74 1a                	je     350 <strcmp+0x40>
    p++, q++;
 336:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 338:	0f b6 19             	movzbl (%ecx),%ebx
 33b:	38 c3                	cmp    %al,%bl
 33d:	74 e9                	je     328 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 33f:	29 d8                	sub    %ebx,%eax
}
 341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 344:	c9                   	leave
 345:	c3                   	ret
 346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 350:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 354:	31 c0                	xor    %eax,%eax
 356:	29 d8                	sub    %ebx,%eax
}
 358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 35b:	c9                   	leave
 35c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 35d:	0f b6 19             	movzbl (%ecx),%ebx
 360:	31 c0                	xor    %eax,%eax
 362:	eb db                	jmp    33f <strcmp+0x2f>
 364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 36f:	90                   	nop

00000370 <strlen>:

uint
strlen(char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 376:	80 3a 00             	cmpb   $0x0,(%edx)
 379:	74 15                	je     390 <strlen+0x20>
 37b:	31 c0                	xor    %eax,%eax
 37d:	8d 76 00             	lea    0x0(%esi),%esi
 380:	83 c0 01             	add    $0x1,%eax
 383:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 387:	89 c1                	mov    %eax,%ecx
 389:	75 f5                	jne    380 <strlen+0x10>
    ;
  return n;
}
 38b:	89 c8                	mov    %ecx,%eax
 38d:	5d                   	pop    %ebp
 38e:	c3                   	ret
 38f:	90                   	nop
  for(n = 0; s[n]; n++)
 390:	31 c9                	xor    %ecx,%ecx
}
 392:	5d                   	pop    %ebp
 393:	89 c8                	mov    %ecx,%eax
 395:	c3                   	ret
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	89 d7                	mov    %edx,%edi
 3af:	fc                   	cld
 3b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3b5:	89 d0                	mov    %edx,%eax
 3b7:	c9                   	leave
 3b8:	c3                   	ret
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003c0 <strchr>:

char*
strchr(const char *s, char c)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3ca:	0f b6 10             	movzbl (%eax),%edx
 3cd:	84 d2                	test   %dl,%dl
 3cf:	75 12                	jne    3e3 <strchr+0x23>
 3d1:	eb 1d                	jmp    3f0 <strchr+0x30>
 3d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d7:	90                   	nop
 3d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3dc:	83 c0 01             	add    $0x1,%eax
 3df:	84 d2                	test   %dl,%dl
 3e1:	74 0d                	je     3f0 <strchr+0x30>
    if(*s == c)
 3e3:	38 d1                	cmp    %dl,%cl
 3e5:	75 f1                	jne    3d8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3f0:	31 c0                	xor    %eax,%eax
}
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret
 3f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <gets>:

char*
gets(char *buf, int max)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 405:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 408:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 409:	31 db                	xor    %ebx,%ebx
{
 40b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 40e:	eb 27                	jmp    437 <gets+0x37>
    cc = read(0, &c, 1);
 410:	83 ec 04             	sub    $0x4,%esp
 413:	6a 01                	push   $0x1
 415:	56                   	push   %esi
 416:	6a 00                	push   $0x0
 418:	e8 1e 01 00 00       	call   53b <read>
    if(cc < 1)
 41d:	83 c4 10             	add    $0x10,%esp
 420:	85 c0                	test   %eax,%eax
 422:	7e 1d                	jle    441 <gets+0x41>
      break;
    buf[i++] = c;
 424:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 428:	8b 55 08             	mov    0x8(%ebp),%edx
 42b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 42f:	3c 0a                	cmp    $0xa,%al
 431:	74 10                	je     443 <gets+0x43>
 433:	3c 0d                	cmp    $0xd,%al
 435:	74 0c                	je     443 <gets+0x43>
  for(i=0; i+1 < max; ){
 437:	89 df                	mov    %ebx,%edi
 439:	83 c3 01             	add    $0x1,%ebx
 43c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 43f:	7c cf                	jl     410 <gets+0x10>
 441:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 443:	8b 45 08             	mov    0x8(%ebp),%eax
 446:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 44a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44d:	5b                   	pop    %ebx
 44e:	5e                   	pop    %esi
 44f:	5f                   	pop    %edi
 450:	5d                   	pop    %ebp
 451:	c3                   	ret
 452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000460 <stat>:

int
stat(char *n, struct stat *st)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	56                   	push   %esi
 464:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 465:	83 ec 08             	sub    $0x8,%esp
 468:	6a 00                	push   $0x0
 46a:	ff 75 08             	push   0x8(%ebp)
 46d:	e8 f1 00 00 00       	call   563 <open>
  if(fd < 0)
 472:	83 c4 10             	add    $0x10,%esp
 475:	85 c0                	test   %eax,%eax
 477:	78 27                	js     4a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 479:	83 ec 08             	sub    $0x8,%esp
 47c:	ff 75 0c             	push   0xc(%ebp)
 47f:	89 c3                	mov    %eax,%ebx
 481:	50                   	push   %eax
 482:	e8 f4 00 00 00       	call   57b <fstat>
  close(fd);
 487:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 48a:	89 c6                	mov    %eax,%esi
  close(fd);
 48c:	e8 ba 00 00 00       	call   54b <close>
  return r;
 491:	83 c4 10             	add    $0x10,%esp
}
 494:	8d 65 f8             	lea    -0x8(%ebp),%esp
 497:	89 f0                	mov    %esi,%eax
 499:	5b                   	pop    %ebx
 49a:	5e                   	pop    %esi
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret
 49d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4a5:	eb ed                	jmp    494 <stat+0x34>
 4a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ae:	66 90                	xchg   %ax,%ax

000004b0 <atoi>:

int
atoi(const char *s)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	53                   	push   %ebx
 4b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b7:	0f be 02             	movsbl (%edx),%eax
 4ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4c5:	77 1e                	ja     4e5 <atoi+0x35>
 4c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4d0:	83 c2 01             	add    $0x1,%edx
 4d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4da:	0f be 02             	movsbl (%edx),%eax
 4dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4e0:	80 fb 09             	cmp    $0x9,%bl
 4e3:	76 eb                	jbe    4d0 <atoi+0x20>
  return n;
}
 4e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e8:	89 c8                	mov    %ecx,%eax
 4ea:	c9                   	leave
 4eb:	c3                   	ret
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	8b 45 10             	mov    0x10(%ebp),%eax
 4f8:	8b 55 08             	mov    0x8(%ebp),%edx
 4fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4fe:	85 c0                	test   %eax,%eax
 500:	7e 13                	jle    515 <memmove+0x25>
 502:	01 d0                	add    %edx,%eax
  dst = vdst;
 504:	89 d7                	mov    %edx,%edi
 506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 510:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 511:	39 f8                	cmp    %edi,%eax
 513:	75 fb                	jne    510 <memmove+0x20>
  return vdst;
}
 515:	5e                   	pop    %esi
 516:	89 d0                	mov    %edx,%eax
 518:	5f                   	pop    %edi
 519:	5d                   	pop    %ebp
 51a:	c3                   	ret

0000051b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 51b:	b8 01 00 00 00       	mov    $0x1,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <exit>:
SYSCALL(exit)
 523:	b8 02 00 00 00       	mov    $0x2,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <wait>:
SYSCALL(wait)
 52b:	b8 03 00 00 00       	mov    $0x3,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <pipe>:
SYSCALL(pipe)
 533:	b8 04 00 00 00       	mov    $0x4,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <read>:
SYSCALL(read)
 53b:	b8 05 00 00 00       	mov    $0x5,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <write>:
SYSCALL(write)
 543:	b8 10 00 00 00       	mov    $0x10,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <close>:
SYSCALL(close)
 54b:	b8 15 00 00 00       	mov    $0x15,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <kill>:
SYSCALL(kill)
 553:	b8 06 00 00 00       	mov    $0x6,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <exec>:
SYSCALL(exec)
 55b:	b8 07 00 00 00       	mov    $0x7,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <open>:
SYSCALL(open)
 563:	b8 0f 00 00 00       	mov    $0xf,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <mknod>:
SYSCALL(mknod)
 56b:	b8 11 00 00 00       	mov    $0x11,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <unlink>:
SYSCALL(unlink)
 573:	b8 12 00 00 00       	mov    $0x12,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <fstat>:
SYSCALL(fstat)
 57b:	b8 08 00 00 00       	mov    $0x8,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <link>:
SYSCALL(link)
 583:	b8 13 00 00 00       	mov    $0x13,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <mkdir>:
SYSCALL(mkdir)
 58b:	b8 14 00 00 00       	mov    $0x14,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <chdir>:
SYSCALL(chdir)
 593:	b8 09 00 00 00       	mov    $0x9,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <dup>:
SYSCALL(dup)
 59b:	b8 0a 00 00 00       	mov    $0xa,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <getpid>:
SYSCALL(getpid)
 5a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <sbrk>:
SYSCALL(sbrk)
 5ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <sleep>:
SYSCALL(sleep)
 5b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <uptime>:
SYSCALL(uptime)
 5bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <shutdown>:
SYSCALL(shutdown)
 5c3:	b8 16 00 00 00       	mov    $0x16,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <enable_sched_trace>:
SYSCALL(enable_sched_trace)
 5cb:	b8 17 00 00 00       	mov    $0x17,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <set_sched>:
SYSCALL(set_sched)
 5d3:	b8 18 00 00 00       	mov    $0x18,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret

000005db <fork_winner>:
SYSCALL(fork_winner)
 5db:	b8 19 00 00 00       	mov    $0x19,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <pause_scheduling>:
SYSCALL(pause_scheduling)
 5e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <mlfq_set_allotment>:
 5eb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret
 5f3:	66 90                	xchg   %ax,%ax
 5f5:	66 90                	xchg   %ax,%ax
 5f7:	66 90                	xchg   %ax,%ax
 5f9:	66 90                	xchg   %ax,%ax
 5fb:	66 90                	xchg   %ax,%ax
 5fd:	66 90                	xchg   %ax,%ax
 5ff:	90                   	nop

00000600 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 608:	89 d1                	mov    %edx,%ecx
{
 60a:	83 ec 3c             	sub    $0x3c,%esp
 60d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 610:	85 d2                	test   %edx,%edx
 612:	0f 89 80 00 00 00    	jns    698 <printint+0x98>
 618:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 61c:	74 7a                	je     698 <printint+0x98>
    x = -xx;
 61e:	f7 d9                	neg    %ecx
    neg = 1;
 620:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 625:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 628:	31 f6                	xor    %esi,%esi
 62a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 630:	89 c8                	mov    %ecx,%eax
 632:	31 d2                	xor    %edx,%edx
 634:	89 f7                	mov    %esi,%edi
 636:	f7 f3                	div    %ebx
 638:	8d 76 01             	lea    0x1(%esi),%esi
 63b:	0f b6 92 4c 0c 00 00 	movzbl 0xc4c(%edx),%edx
 642:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 646:	89 ca                	mov    %ecx,%edx
 648:	89 c1                	mov    %eax,%ecx
 64a:	39 da                	cmp    %ebx,%edx
 64c:	73 e2                	jae    630 <printint+0x30>
  if(neg)
 64e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 651:	85 c0                	test   %eax,%eax
 653:	74 07                	je     65c <printint+0x5c>
    buf[i++] = '-';
 655:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 65a:	89 f7                	mov    %esi,%edi
 65c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 65f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 662:	01 df                	add    %ebx,%edi
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 668:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 66b:	83 ec 04             	sub    $0x4,%esp
 66e:	88 45 d7             	mov    %al,-0x29(%ebp)
 671:	8d 45 d7             	lea    -0x29(%ebp),%eax
 674:	6a 01                	push   $0x1
 676:	50                   	push   %eax
 677:	56                   	push   %esi
 678:	e8 c6 fe ff ff       	call   543 <write>
  while(--i >= 0)
 67d:	89 f8                	mov    %edi,%eax
 67f:	83 c4 10             	add    $0x10,%esp
 682:	83 ef 01             	sub    $0x1,%edi
 685:	39 d8                	cmp    %ebx,%eax
 687:	75 df                	jne    668 <printint+0x68>
}
 689:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68c:	5b                   	pop    %ebx
 68d:	5e                   	pop    %esi
 68e:	5f                   	pop    %edi
 68f:	5d                   	pop    %ebp
 690:	c3                   	ret
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 698:	31 c0                	xor    %eax,%eax
 69a:	eb 89                	jmp    625 <printint+0x25>
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 6ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 6af:	0f b6 1e             	movzbl (%esi),%ebx
 6b2:	83 c6 01             	add    $0x1,%esi
 6b5:	84 db                	test   %bl,%bl
 6b7:	74 67                	je     720 <printf+0x80>
 6b9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 6bc:	31 d2                	xor    %edx,%edx
 6be:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 6c1:	eb 34                	jmp    6f7 <printf+0x57>
 6c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c7:	90                   	nop
 6c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6cb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6d0:	83 f8 25             	cmp    $0x25,%eax
 6d3:	74 18                	je     6ed <printf+0x4d>
  write(fd, &c, 1);
 6d5:	83 ec 04             	sub    $0x4,%esp
 6d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6db:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6de:	6a 01                	push   $0x1
 6e0:	50                   	push   %eax
 6e1:	57                   	push   %edi
 6e2:	e8 5c fe ff ff       	call   543 <write>
 6e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6ea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6ed:	0f b6 1e             	movzbl (%esi),%ebx
 6f0:	83 c6 01             	add    $0x1,%esi
 6f3:	84 db                	test   %bl,%bl
 6f5:	74 29                	je     720 <printf+0x80>
    c = fmt[i] & 0xff;
 6f7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6fa:	85 d2                	test   %edx,%edx
 6fc:	74 ca                	je     6c8 <printf+0x28>
      }
    } else if(state == '%'){
 6fe:	83 fa 25             	cmp    $0x25,%edx
 701:	75 ea                	jne    6ed <printf+0x4d>
      if(c == 'd'){
 703:	83 f8 25             	cmp    $0x25,%eax
 706:	0f 84 24 01 00 00    	je     830 <printf+0x190>
 70c:	83 e8 63             	sub    $0x63,%eax
 70f:	83 f8 15             	cmp    $0x15,%eax
 712:	77 1c                	ja     730 <printf+0x90>
 714:	ff 24 85 f4 0b 00 00 	jmp    *0xbf4(,%eax,4)
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 720:	8d 65 f4             	lea    -0xc(%ebp),%esp
 723:	5b                   	pop    %ebx
 724:	5e                   	pop    %esi
 725:	5f                   	pop    %edi
 726:	5d                   	pop    %ebp
 727:	c3                   	ret
 728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
 733:	8d 55 e7             	lea    -0x19(%ebp),%edx
 736:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 73a:	6a 01                	push   $0x1
 73c:	52                   	push   %edx
 73d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 740:	57                   	push   %edi
 741:	e8 fd fd ff ff       	call   543 <write>
 746:	83 c4 0c             	add    $0xc,%esp
 749:	88 5d e7             	mov    %bl,-0x19(%ebp)
 74c:	6a 01                	push   $0x1
 74e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 751:	52                   	push   %edx
 752:	57                   	push   %edi
 753:	e8 eb fd ff ff       	call   543 <write>
        putc(fd, c);
 758:	83 c4 10             	add    $0x10,%esp
      state = 0;
 75b:	31 d2                	xor    %edx,%edx
 75d:	eb 8e                	jmp    6ed <printf+0x4d>
 75f:	90                   	nop
        printint(fd, *ap, 16, 0);
 760:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 763:	83 ec 0c             	sub    $0xc,%esp
 766:	b9 10 00 00 00       	mov    $0x10,%ecx
 76b:	8b 13                	mov    (%ebx),%edx
 76d:	6a 00                	push   $0x0
 76f:	89 f8                	mov    %edi,%eax
        ap++;
 771:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 774:	e8 87 fe ff ff       	call   600 <printint>
        ap++;
 779:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 77c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 67 ff ff ff       	jmp    6ed <printf+0x4d>
 786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 790:	8b 45 d0             	mov    -0x30(%ebp),%eax
 793:	8b 18                	mov    (%eax),%ebx
        ap++;
 795:	83 c0 04             	add    $0x4,%eax
 798:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 79b:	85 db                	test   %ebx,%ebx
 79d:	0f 84 9d 00 00 00    	je     840 <printf+0x1a0>
        while(*s != 0){
 7a3:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7a6:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7a8:	84 c0                	test   %al,%al
 7aa:	0f 84 3d ff ff ff    	je     6ed <printf+0x4d>
 7b0:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7b3:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7b6:	89 de                	mov    %ebx,%esi
 7b8:	89 d3                	mov    %edx,%ebx
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 7c6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 7c9:	6a 01                	push   $0x1
 7cb:	53                   	push   %ebx
 7cc:	57                   	push   %edi
 7cd:	e8 71 fd ff ff       	call   543 <write>
        while(*s != 0){
 7d2:	0f b6 06             	movzbl (%esi),%eax
 7d5:	83 c4 10             	add    $0x10,%esp
 7d8:	84 c0                	test   %al,%al
 7da:	75 e4                	jne    7c0 <printf+0x120>
      state = 0;
 7dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 7df:	31 d2                	xor    %edx,%edx
 7e1:	e9 07 ff ff ff       	jmp    6ed <printf+0x4d>
 7e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 7f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7fb:	8b 13                	mov    (%ebx),%edx
 7fd:	6a 01                	push   $0x1
 7ff:	e9 6b ff ff ff       	jmp    76f <printf+0xcf>
 804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 808:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 80b:	83 ec 04             	sub    $0x4,%esp
 80e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 811:	8b 03                	mov    (%ebx),%eax
        ap++;
 813:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 816:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 819:	6a 01                	push   $0x1
 81b:	52                   	push   %edx
 81c:	57                   	push   %edi
 81d:	e8 21 fd ff ff       	call   543 <write>
        ap++;
 822:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 825:	83 c4 10             	add    $0x10,%esp
      state = 0;
 828:	31 d2                	xor    %edx,%edx
 82a:	e9 be fe ff ff       	jmp    6ed <printf+0x4d>
 82f:	90                   	nop
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
 833:	88 5d e7             	mov    %bl,-0x19(%ebp)
 836:	8d 55 e7             	lea    -0x19(%ebp),%edx
 839:	6a 01                	push   $0x1
 83b:	e9 11 ff ff ff       	jmp    751 <printf+0xb1>
 840:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 845:	bb ed 0b 00 00       	mov    $0xbed,%ebx
 84a:	e9 61 ff ff ff       	jmp    7b0 <printf+0x110>
 84f:	90                   	nop

00000850 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 850:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 851:	a1 a8 0f 00 00       	mov    0xfa8,%eax
{
 856:	89 e5                	mov    %esp,%ebp
 858:	57                   	push   %edi
 859:	56                   	push   %esi
 85a:	53                   	push   %ebx
 85b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 85e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 868:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	39 ca                	cmp    %ecx,%edx
 86e:	73 30                	jae    8a0 <free+0x50>
 870:	39 c1                	cmp    %eax,%ecx
 872:	72 04                	jb     878 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 874:	39 c2                	cmp    %eax,%edx
 876:	72 f0                	jb     868 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 878:	8b 73 fc             	mov    -0x4(%ebx),%esi
 87b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 87e:	39 f8                	cmp    %edi,%eax
 880:	74 2e                	je     8b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 885:	8b 42 04             	mov    0x4(%edx),%eax
 888:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 88b:	39 f1                	cmp    %esi,%ecx
 88d:	74 38                	je     8c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 88f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 891:	5b                   	pop    %ebx
  freep = p;
 892:	89 15 a8 0f 00 00    	mov    %edx,0xfa8
}
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	39 c1                	cmp    %eax,%ecx
 8a2:	72 d0                	jb     874 <free+0x24>
 8a4:	eb c2                	jmp    868 <free+0x18>
 8a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ad:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 8b0:	03 70 04             	add    0x4(%eax),%esi
 8b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	8b 02                	mov    (%edx),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 8bd:	8b 42 04             	mov    0x4(%edx),%eax
 8c0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8c3:	39 f1                	cmp    %esi,%ecx
 8c5:	75 c8                	jne    88f <free+0x3f>
    p->s.size += bp->s.size;
 8c7:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 8ca:	89 15 a8 0f 00 00    	mov    %edx,0xfa8
    p->s.size += bp->s.size;
 8d0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 8d3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 8d6:	89 0a                	mov    %ecx,(%edx)
}
 8d8:	5b                   	pop    %ebx
 8d9:	5e                   	pop    %esi
 8da:	5f                   	pop    %edi
 8db:	5d                   	pop    %ebp
 8dc:	c3                   	ret
 8dd:	8d 76 00             	lea    0x0(%esi),%esi

000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	57                   	push   %edi
 8e4:	56                   	push   %esi
 8e5:	53                   	push   %ebx
 8e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ec:	8b 15 a8 0f 00 00    	mov    0xfa8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f2:	8d 78 07             	lea    0x7(%eax),%edi
 8f5:	c1 ef 03             	shr    $0x3,%edi
 8f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8fb:	85 d2                	test   %edx,%edx
 8fd:	0f 84 8d 00 00 00    	je     990 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 903:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 905:	8b 48 04             	mov    0x4(%eax),%ecx
 908:	39 f9                	cmp    %edi,%ecx
 90a:	73 64                	jae    970 <malloc+0x90>
  if(nu < 4096)
 90c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 911:	39 df                	cmp    %ebx,%edi
 913:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 916:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 91d:	eb 0a                	jmp    929 <malloc+0x49>
 91f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 922:	8b 48 04             	mov    0x4(%eax),%ecx
 925:	39 f9                	cmp    %edi,%ecx
 927:	73 47                	jae    970 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 929:	89 c2                	mov    %eax,%edx
 92b:	39 05 a8 0f 00 00    	cmp    %eax,0xfa8
 931:	75 ed                	jne    920 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 933:	83 ec 0c             	sub    $0xc,%esp
 936:	56                   	push   %esi
 937:	e8 6f fc ff ff       	call   5ab <sbrk>
  if(p == (char*)-1)
 93c:	83 c4 10             	add    $0x10,%esp
 93f:	83 f8 ff             	cmp    $0xffffffff,%eax
 942:	74 1c                	je     960 <malloc+0x80>
  hp->s.size = nu;
 944:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 947:	83 ec 0c             	sub    $0xc,%esp
 94a:	83 c0 08             	add    $0x8,%eax
 94d:	50                   	push   %eax
 94e:	e8 fd fe ff ff       	call   850 <free>
  return freep;
 953:	8b 15 a8 0f 00 00    	mov    0xfa8,%edx
      if((p = morecore(nunits)) == 0)
 959:	83 c4 10             	add    $0x10,%esp
 95c:	85 d2                	test   %edx,%edx
 95e:	75 c0                	jne    920 <malloc+0x40>
        return 0;
  }
}
 960:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 963:	31 c0                	xor    %eax,%eax
}
 965:	5b                   	pop    %ebx
 966:	5e                   	pop    %esi
 967:	5f                   	pop    %edi
 968:	5d                   	pop    %ebp
 969:	c3                   	ret
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 970:	39 cf                	cmp    %ecx,%edi
 972:	74 4c                	je     9c0 <malloc+0xe0>
        p->s.size -= nunits;
 974:	29 f9                	sub    %edi,%ecx
 976:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 979:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 97c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 97f:	89 15 a8 0f 00 00    	mov    %edx,0xfa8
}
 985:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 988:	83 c0 08             	add    $0x8,%eax
}
 98b:	5b                   	pop    %ebx
 98c:	5e                   	pop    %esi
 98d:	5f                   	pop    %edi
 98e:	5d                   	pop    %ebp
 98f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 990:	c7 05 a8 0f 00 00 ac 	movl   $0xfac,0xfa8
 997:	0f 00 00 
    base.s.size = 0;
 99a:	b8 ac 0f 00 00       	mov    $0xfac,%eax
    base.s.ptr = freep = prevp = &base;
 99f:	c7 05 ac 0f 00 00 ac 	movl   $0xfac,0xfac
 9a6:	0f 00 00 
    base.s.size = 0;
 9a9:	c7 05 b0 0f 00 00 00 	movl   $0x0,0xfb0
 9b0:	00 00 00 
    if(p->s.size >= nunits){
 9b3:	e9 54 ff ff ff       	jmp    90c <malloc+0x2c>
 9b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9bf:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 9c0:	8b 08                	mov    (%eax),%ecx
 9c2:	89 0a                	mov    %ecx,(%edx)
 9c4:	eb b9                	jmp    97f <malloc+0x9f>
