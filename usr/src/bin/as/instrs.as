




PSEUDO("\0\0\0\0\2\0\05\0.byte",0, IBYTE),
PSEUDO("\0\0\0\0\2\0\05\0.word",0, IWORD),
PSEUDO("\0\0\0\0\2\0\04\0.int",0, IINT),
PSEUDO("\0\0\0\0\2\0\05\0.long",0, ILONG),
PSEUDO("\0\0\0\0\2\0\05\0.quad",0, IQUAD),
PSEUDO("\0\0\0\0\2\0\05\0.octa",0, IOCTA),
PSEUDO("\0\0\0\0\2\0\06\0.float",0, IFFLOAT),
PSEUDO("\0\0\0\0\2\0\07\0.double",0, IDFLOAT),
PSEUDO("\0\0\0\0\2\0\07\0.ffloat",0, IFFLOAT),
PSEUDO("\0\0\0\0\2\0\07\0.dfloat",0, IDFLOAT),
PSEUDO("\0\0\0\0\2\0\07\0.gfloat",0, IGFLOAT),
PSEUDO("\0\0\0\0\2\0\07\0.hfloat",0, IHFLOAT),
PSEUDO("\0\0\0\0\2\0\06\0.space",0, ISPACE),
PSEUDO("\0\0\0\0\2\0\05\0.fill",0, IFILL),
PSEUDO("\0\0\0\0\2\0\06\0.ascii",0, IASCII),
PSEUDO("\0\0\0\0\2\0\06\0.asciz",0, IASCIZ),

PSEUDO("\0\0\0\0\2\0\05\0.data",0, IDATA),
PSEUDO("\0\0\0\0\2\0\05\0.text",0, ITEXT),
PSEUDO("\0\0\0\0\2\0\06\0.align",0, IALIGN),

PSEUDO("\0\0\0\0\2\0\05\0.line",0, ILINENO),
PSEUDO("\0\0\0\0\2\0\05\0.file",0, IFILE),

PSEUDO("\0\0\0\0\2\0\06\0.globl",0, IGLOBAL),
PSEUDO("\0\0\0\0\2\0\05\0.comm",0, ICOMM),
PSEUDO("\0\0\0\0\2\0\06\0.lcomm",0, ILCOMM),
PSEUDO("\0\0\0\0\2\0\04\0.set",0, ISET),
PSEUDO("\0\0\0\0\2\0\05\0.lsym",0, ILSYM),
PSEUDO("\0\0\0\0\2\0\04\0.org",0, IORG),

PSEUDO("\0\0\0\0\2\0\05\0.stab",0, ISTAB),
PSEUDO("\0\0\0\0\2\0\06\0.stabd",0, ISTABDOT),
PSEUDO("\0\0\0\0\2\0\06\0.stabn",0, ISTABNONE),
PSEUDO("\0\0\0\0\2\0\06\0.stabs",0, ISTABSTR),

PSEUDO("\0\0\0\0\2\0\06\0.ABORT",0, IABORT),


PSEUDO("\0\0\0\0\2\0\03\0jbc",0xe1, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jlbc",0xe9, IJXXX),
PSEUDO("\0\0\0\0\2\0\03\0jbs",0xe0, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jlbs",0xe8, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jbcc",0xe5, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jbsc",0xe4, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jbcs",0xe3, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jbss",0xe2, IJXXX),

PSEUDO("\0\0\0\0\2\0\03\0jbr",0x11, IJXXX),
PSEUDO("\0\0\0\0\2\0\03\0jcc",0x1e, IJXXX),
PSEUDO("\0\0\0\0\2\0\03\0jcs",0x1f, IJXXX),
PSEUDO("\0\0\0\0\2\0\03\0jvc",0x1c, IJXXX),
PSEUDO("\0\0\0\0\2\0\03\0jvs",0x1d, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jlss",0x19, IJXXX),
PSEUDO("\0\0\0\0\2\0\05\0jlssu",0x1f, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jleq",0x15, IJXXX),
PSEUDO("\0\0\0\0\2\0\05\0jlequ",0x1b, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jeql",0x13, IJXXX),
PSEUDO("\0\0\0\0\2\0\05\0jeqlu",0x13, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jneq",0x12, IJXXX),
PSEUDO("\0\0\0\0\2\0\05\0jnequ",0x12, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jgeq",0x18, IJXXX),
PSEUDO("\0\0\0\0\2\0\05\0jgequ",0x1e, IJXXX),
PSEUDO("\0\0\0\0\2\0\04\0jgtr",0x14, IJXXX),
PSEUDO("\0\0\0\0\2\0\05\0jgtru",0x1a, IJXXX),
PSEUDO("\0\0\0\0\2\0\02\0r0",0, REG),
PSEUDO("\0\0\0\0\2\0\02\0r1",1, REG),
PSEUDO("\0\0\0\0\2\0\02\0r2",2, REG),
PSEUDO("\0\0\0\0\2\0\02\0r3",3, REG),
PSEUDO("\0\0\0\0\2\0\02\0r4",4, REG),
PSEUDO("\0\0\0\0\2\0\02\0r5",5, REG),
PSEUDO("\0\0\0\0\2\0\02\0r6",6, REG),
PSEUDO("\0\0\0\0\2\0\02\0r7",7, REG),
PSEUDO("\0\0\0\0\2\0\02\0r8",8, REG),
PSEUDO("\0\0\0\0\2\0\02\0r9",9, REG),
PSEUDO("\0\0\0\0\2\0\03\0r10",10, REG),
PSEUDO("\0\0\0\0\2\0\03\0r11",11, REG),
PSEUDO("\0\0\0\0\2\0\03\0r12",12, REG),
PSEUDO("\0\0\0\0\2\0\03\0r13",13, REG),
PSEUDO("\0\0\0\0\2\0\03\0r14",14, REG),
PSEUDO("\0\0\0\0\2\0\03\0r15",15, REG),
PSEUDO("\0\0\0\0\2\0\02\0ap",12, REG),
PSEUDO("\0\0\0\0\2\0\02\0fp",13, REG),
PSEUDO("\0\0\0\0\2\0\02\0sp",14, REG),
PSEUDO("\0\0\0\0\2\0\02\0pc",15, REG),


OP("\0\0\0\0\2\0\04\0chmk", CORE, 0xbc, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0chme", CORE, 0xbd, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0chms", CORE, 0xbe, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0chmu", CORE, 0xbf, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0prober", CORE, 0x0c, 3, A_RB, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\06\0probew", CORE, 0x0d, 3, A_RB, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\03\0rei", CORE, 0x02, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0ldpctx", CORE, 0x06, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0svpctx", CORE, 0x07, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0mtpr", CORE, 0xda, 2, A_RL, A_RL,0,0,0,0),
OP("\0\0\0\0\2\0\04\0mfpr", CORE, 0xdb, 2, A_RL, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\03\0xfc", CORE, 0xfc, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0bpt", CORE, 0x03, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bugw", ESCF, 0xfe, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bugl", ESCF, 0xfd, 1, A_RL,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0halt", CORE, 0x00, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movb", CORE, 0x90, 2, A_RB, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movw", CORE, 0xb0, 2, A_RW, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movl", CORE, 0xd0, 2, A_RL, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movq", CORE, 0x7d, 2, A_RQ, A_WQ,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movo", ESCD, 0x7d, 2, A_RO, A_WO,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movf", CORE, 0x50, 2, A_RF, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movd", CORE, 0x70, 2, A_RD, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movg", ESCD, 0x50, 2, A_RG, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\04\0movh", ESCD, 0x70, 2, A_RH, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0pushl", CORE, 0xdd, 1, A_RL,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrb", CORE, 0x94, 1, A_WB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrw", CORE, 0xb4, 1, A_WW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrf", CORE, 0xd4, 1, A_WF,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrl", CORE, 0xd4, 1, A_WL,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrd", CORE, 0x7c, 1, A_WD,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrg", CORE, 0x7c, 1, A_WG,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrq", CORE, 0x7c, 1, A_WQ,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clrh", ESCD, 0x7c, 1, A_WH,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0clro", ESCD, 0x7c, 1, A_WO,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegb", CORE, 0x8e, 2, A_RB, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegw", CORE, 0xae, 2, A_RW, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegl", CORE, 0xce, 2, A_RL, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegf", CORE, 0x52, 2, A_RF, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegg", ESCD, 0x52, 2, A_RG, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegd", CORE, 0x72, 2, A_RD, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mnegh", ESCD, 0x72, 2, A_RH, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mcomb", CORE, 0x92, 2, A_RB, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mcomw", CORE, 0xb2, 2, A_RW, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mcoml", CORE, 0xd2, 2, A_RL, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtbw", CORE, 0x99, 2, A_RB, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtbl", CORE, 0x98, 2, A_RB, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtwb", CORE, 0x33, 2, A_RW, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtwl", CORE, 0x32, 2, A_RW, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtlb", CORE, 0xf6, 2, A_RL, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtlw", CORE, 0xf7, 2, A_RL, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtbf", CORE, 0x4c, 2, A_RB, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtbd", CORE, 0x6c, 2, A_RB, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtbg", ESCD, 0x4c, 2, A_RB, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtbh", ESCD, 0x6c, 2, A_RB, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtwf", CORE, 0x4d, 2, A_RW, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtwd", CORE, 0x6d, 2, A_RW, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtwg", ESCD, 0x4d, 2, A_RW, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtwh", ESCD, 0x6d, 2, A_RW, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtlf", CORE, 0x4e, 2, A_RL, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtld", CORE, 0x6e, 2, A_RL, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtlg", ESCD, 0x4e, 2, A_RL, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtlh", ESCD, 0x6e, 2, A_RL, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtfb", CORE, 0x48, 2, A_RF, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtdb", CORE, 0x68, 2, A_RD, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtgb", ESCD, 0x48, 2, A_RG, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvthb", ESCD, 0x68, 2, A_RH, A_WB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtfw", CORE, 0x49, 2, A_RF, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtdw", CORE, 0x69, 2, A_RD, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtgw", ESCD, 0x49, 2, A_RG, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvthw", ESCD, 0x69, 2, A_RH, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtfl", CORE, 0x4a, 2, A_RF, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0cvtrfl", CORE, 0x4b, 2, A_RF, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtdl", CORE, 0x6a, 2, A_RD, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0cvtrdl", CORE, 0x6b, 2, A_RD, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtgl", ESCD, 0x4a, 2, A_RG, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0cvtrgl", ESCD, 0x4b, 2, A_RG, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvthl", ESCD, 0x6a, 2, A_RH, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0cvtrhl", ESCD, 0x6b, 2, A_RH, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtfd", CORE, 0x56, 2, A_RF, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtfg", ESCD, 0x99, 2, A_RF, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtfh", ESCD, 0x98, 2, A_RF, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtdf", CORE, 0x76, 2, A_RD, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtdh", ESCD, 0x32, 2, A_RD, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtgf", ESCD, 0x33, 2, A_RG, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtgh", ESCD, 0x56, 2, A_RG, A_WH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvthf", ESCD, 0xf6, 2, A_RH, A_WF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvthd", ESCD, 0xf7, 2, A_RH, A_WD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0cvthg", ESCD, 0x76, 2, A_RH, A_WG,0,0,0,0),
OP("\0\0\0\0\2\0\06\0movzbw", CORE, 0x9b, 2, A_RB, A_WW,0,0,0,0),
OP("\0\0\0\0\2\0\06\0movzbl", CORE, 0x9a, 2, A_RB, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0movzwl", CORE, 0x3c, 2, A_RW, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmpb", CORE, 0x91, 2, A_RB, A_RB,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmpw", CORE, 0xb1, 2, A_RW, A_RW,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmpl", CORE, 0xd1, 2, A_RL, A_RL,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmpf", CORE, 0x51, 2, A_RF, A_RF,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmpd", CORE, 0x71, 2, A_RD, A_RD,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmpg", ESCD, 0x51, 2, A_RG, A_RG,0,0,0,0),
OP("\0\0\0\0\2\0\04\0cmph", ESCD, 0x71, 2, A_RH, A_RH,0,0,0,0),
OP("\0\0\0\0\2\0\04\0incb", CORE, 0x96, 1, A_MB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0incw", CORE, 0xb6, 1, A_MW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0incl", CORE, 0xd6, 1, A_ML,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tstb", CORE, 0x95, 1, A_RB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tstw", CORE, 0xb5, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tstl", CORE, 0xd5, 1, A_RL,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tstf", CORE, 0x53, 1, A_RF,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tstd", CORE, 0x73, 1, A_RD,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tstg", ESCD, 0x53, 1, A_RG,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0tsth", ESCD, 0x73, 1, A_RH,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addb2", CORE, 0x80, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addh2", ESCD, 0x60, 2, A_RH, A_MH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addb3", CORE, 0x81, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0addh3", ESCD, 0x61, 3, A_RH, A_RH, A_WH,0,0,0),
OP("\0\0\0\0\2\0\05\0addw2", CORE, 0xa0, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addw3", CORE, 0xa1, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0addl2", CORE, 0xc0, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addl3", CORE, 0xc1, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0addf2", CORE, 0x40, 2, A_RF, A_MF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addf3", CORE, 0x41, 3, A_RF, A_RF, A_WF,0,0,0),
OP("\0\0\0\0\2\0\05\0addd2", CORE, 0x60, 2, A_RD, A_MD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addd3", CORE, 0x61, 3, A_RD, A_RD, A_WD,0,0,0),
OP("\0\0\0\0\2\0\05\0addg2", ESCD, 0x40, 2, A_RG, A_MG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0addg3", ESCD, 0x41, 3, A_RG, A_RG, A_WG,0,0,0),
OP("\0\0\0\0\2\0\04\0adwc", CORE, 0xd8, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0adawi", CORE, 0x58, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subb2", CORE, 0x82, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subb3", CORE, 0x83, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0subw2", CORE, 0xa2, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subw3", CORE, 0xa3, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0subl2", CORE, 0xc2, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subl3", CORE, 0xc3, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0subf2", CORE, 0x42, 2, A_RF, A_MF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subf3", CORE, 0x43, 3, A_RF, A_RF, A_WF,0,0,0),
OP("\0\0\0\0\2\0\05\0subd2", CORE, 0x62, 2, A_RD, A_MD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subd3", CORE, 0x63, 3, A_RD, A_RD, A_WD,0,0,0),
OP("\0\0\0\0\2\0\05\0subg2", ESCD, 0x42, 2, A_RG, A_MG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subg3", ESCD, 0x43, 3, A_RG, A_RG, A_WG,0,0,0),
OP("\0\0\0\0\2\0\05\0subh2", ESCD, 0x62, 2, A_RH, A_MH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0subh3", ESCD, 0x63, 3, A_RH, A_RH, A_WH,0,0,0),
OP("\0\0\0\0\2\0\04\0decb", CORE, 0x97, 1, A_MB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0decw", CORE, 0xb7, 1, A_MW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0decl", CORE, 0xd7, 1, A_ML,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0sbwc", CORE, 0xd9, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mulb2", CORE, 0x84, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mulb3", CORE, 0x85, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0mulw2", CORE, 0xa4, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mulw3", CORE, 0xa5, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0mull2", CORE, 0xc4, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mull3", CORE, 0xc5, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0mulf2", CORE, 0x44, 2, A_RF, A_MF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mulf3", CORE, 0x45, 3, A_RF, A_RF, A_WF,0,0,0),
OP("\0\0\0\0\2\0\05\0muld2", CORE, 0x64, 2, A_RD, A_MD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0muld3", CORE, 0x65, 3, A_RD, A_RD, A_WD,0,0,0),
OP("\0\0\0\0\2\0\05\0mulg2", ESCD, 0x44, 2, A_RG, A_MG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mulg3", ESCD, 0x45, 3, A_RG, A_RG, A_WG,0,0,0),
OP("\0\0\0\0\2\0\05\0mulh2", ESCD, 0x64, 2, A_RH, A_MH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0mulh3", ESCD, 0x65, 3, A_RH, A_RH, A_WH,0,0,0),
OP("\0\0\0\0\2\0\05\0emodf", CORE, 0x54, 5, A_RF, A_RB, A_RF, A_WL, A_WF,0),
OP("\0\0\0\0\2\0\04\0emul", CORE, 0x7a, 4, A_RL, A_RL, A_RL, A_WQ,0,0),
OP("\0\0\0\0\2\0\05\0emodd", CORE, 0x74, 5, A_RD, A_RB, A_RD, A_WL, A_WD,0),
OP("\0\0\0\0\2\0\05\0emodg", ESCD, 0x54, 5, A_RG, A_RW, A_RG, A_WL, A_WG,0),
OP("\0\0\0\0\2\0\05\0emodh", ESCD, 0x74, 5, A_RH, A_RW, A_RH, A_WL, A_WH,0),
OP("\0\0\0\0\2\0\05\0divb2", CORE, 0x86, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divb3", CORE, 0x87, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0divw2", CORE, 0xa6, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divw3", CORE, 0xa7, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0divl2", CORE, 0xc6, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divl3", CORE, 0xc7, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0divf2", CORE, 0x46, 2, A_RF, A_MF,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divf3", CORE, 0x47, 3, A_RF, A_RF, A_WF,0,0,0),
OP("\0\0\0\0\2\0\05\0divd2", CORE, 0x66, 2, A_RD, A_MD,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divd3", CORE, 0x67, 3, A_RD, A_RD, A_RD,0,0,0),
OP("\0\0\0\0\2\0\05\0divg2", ESCD, 0x46, 2, A_RG, A_MG,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divg3", ESCD, 0x47, 3, A_RG, A_RG, A_WG,0,0,0),
OP("\0\0\0\0\2\0\05\0divh2", ESCD, 0x66, 2, A_RH, A_MH,0,0,0,0),
OP("\0\0\0\0\2\0\05\0divh3", ESCD, 0x67, 3, A_RH, A_RH, A_RH,0,0,0),
OP("\0\0\0\0\2\0\04\0ediv", CORE, 0x7b, 4, A_RL, A_RQ, A_WL, A_WL,0,0),
OP("\0\0\0\0\2\0\04\0bitb", CORE, 0x93, 2, A_RB, A_RB,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bitl", CORE, 0xd3, 2, A_RL, A_RL,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bitw", CORE, 0xb3, 2, A_RW, A_RW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bisb2", CORE, 0x88, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bisb3", CORE, 0x89, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0bisw2", CORE, 0xa8, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bisw3", CORE, 0xa9, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0bisl2", CORE, 0xc8, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bisl3", CORE, 0xc9, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0bicb2", CORE, 0x8a, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bicb3", CORE, 0x8b, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0bicw2", CORE, 0xaa, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bicw3", CORE, 0xab, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0bicl2", CORE, 0xca, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bicl3", CORE, 0xcb, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0xorb2", CORE, 0x8c, 2, A_RB, A_MB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0xorb3", CORE, 0x8d, 3, A_RB, A_RB, A_WB,0,0,0),
OP("\0\0\0\0\2\0\05\0xorw2", CORE, 0xac, 2, A_RW, A_MW,0,0,0,0),
OP("\0\0\0\0\2\0\05\0xorw3", CORE, 0xad, 3, A_RW, A_RW, A_WW,0,0,0),
OP("\0\0\0\0\2\0\05\0xorl2", CORE, 0xcc, 2, A_RL, A_ML,0,0,0,0),
OP("\0\0\0\0\2\0\05\0xorl3", CORE, 0xcd, 3, A_RL, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\04\0ashl", CORE, 0x78, 3, A_RB, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\04\0ashq", CORE, 0x79, 3, A_RB, A_RQ, A_WQ,0,0,0),
OP("\0\0\0\0\2\0\04\0rotl", CORE, 0x9c, 3, A_RB, A_RL, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0polyf", CORE, 0x55, 3, A_RF, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0polyd", CORE, 0x75, 3, A_RD, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0polyg", ESCD, 0x55, 3, A_RG, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0polyh", ESCD, 0x75, 3, A_RH, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0pushr", CORE, 0xbb, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0popr", CORE, 0xba, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0movpsl", CORE, 0xdc, 1, A_WL,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0bispsw", CORE, 0xb8, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0bicpsw", CORE, 0xb9, 1, A_RW,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movab", CORE, 0x9e, 2, A_AB, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushab", CORE, 0x9f, 1, A_AB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movaw", CORE, 0x3e, 2, A_AW, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushaw", CORE, 0x3f, 1, A_AW,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movaf", CORE, 0xde, 2, A_AF, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0moval", CORE, 0xde, 2, A_AL, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushaf", CORE, 0xdf, 1, A_AF,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushal", CORE, 0xdf, 1, A_AL,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushad", CORE, 0x7f, 1, A_AD,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushag", CORE, 0x7f, 1, A_AG,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushaq", CORE, 0x7f, 1, A_AQ,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushah", ESCD, 0x7f, 1, A_AH,0,0,0,0,0),
OP("\0\0\0\0\2\0\06\0pushao", ESCD, 0x7f, 1, A_AO,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movad", CORE, 0x7e, 2, A_AD, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movag", CORE, 0x7e, 2, A_AG, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movaq", CORE, 0x7e, 2, A_AQ, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movah", ESCD, 0x7e, 2, A_AH, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movao", ESCD, 0x7e, 2, A_AO, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\05\0index", CORE, 0x0a, 6, A_RL, A_RL, A_RL, A_RL, A_RL, A_WL),
OP("\0\0\0\0\2\0\06\0insque", CORE, 0x0e, 2, A_AB, A_AB,0,0,0,0),
OP("\0\0\0\0\2\0\06\0remque", CORE, 0x0f, 2, A_AB, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0insqhi", NEW, 0x5c, 2, A_AB, A_AQ,0,0,0,0),
OP("\0\0\0\0\2\0\06\0insqti", NEW, 0x5d, 2, A_AB, A_AQ,0,0,0,0),
OP("\0\0\0\0\2\0\06\0remqhi", NEW, 0x5e, 2, A_AQ, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\06\0remqti", NEW, 0x5f, 2, A_AQ, A_WL,0,0,0,0),
OP("\0\0\0\0\2\0\03\0ffc", CORE, 0xeb, 4, A_RL, A_RB, A_VB, A_WL,0,0),
OP("\0\0\0\0\2\0\03\0ffs", CORE, 0xea, 4, A_RL, A_RB, A_VB, A_WL,0,0),
OP("\0\0\0\0\2\0\04\0extv", CORE, 0xee, 4, A_RL, A_RB, A_VB, A_WL,0,0),
OP("\0\0\0\0\2\0\05\0extzv", CORE, 0xef, 4, A_RL, A_RB, A_VB, A_WL,0,0),
OP("\0\0\0\0\2\0\04\0cmpv", CORE, 0xec, 4, A_RL, A_RB, A_VB, A_RL,0,0),
OP("\0\0\0\0\2\0\05\0cmpzv", CORE, 0xed, 4, A_RL, A_RB, A_VB, A_RL,0,0),
OP("\0\0\0\0\2\0\04\0insv", CORE, 0xf0, 4, A_RL, A_RL, A_RB, A_VB,0,0),
OP("\0\0\0\0\2\0\04\0bneq", CORE, 0x12, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bnequ", CORE, 0x12, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0beql", CORE, 0x13, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0beqlu", CORE, 0x13, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bgtr", CORE, 0x14, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bleq", CORE, 0x15, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bgeq", CORE, 0x18, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0blss", CORE, 0x19, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bgtru", CORE, 0x1a, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0blequ", CORE, 0x1b, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0bvc", CORE, 0x1c, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0bvs", CORE, 0x1d, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0bgequ", CORE, 0x1e, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0bcc", CORE, 0x1e, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0blssu", CORE, 0x1f, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0bcs", CORE, 0x1f, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0brb", CORE, 0x11, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0brw", CORE, 0x31, 1, A_BW,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0jmp", CORE, 0x17, 1, A_AB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0bbs", CORE, 0xe0, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\03\0bbc", CORE, 0xe1, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\04\0bbss", CORE, 0xe2, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\04\0bbcs", CORE, 0xe3, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\04\0bbsc", CORE, 0xe4, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\04\0bbcc", CORE, 0xe5, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\05\0bbssi", CORE, 0xe6, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\05\0bbcci", CORE, 0xe7, 3, A_RL, A_VB, A_BB,0,0,0),
OP("\0\0\0\0\2\0\04\0blbs", CORE, 0xe8, 2, A_RL, A_BB,0,0,0,0),
OP("\0\0\0\0\2\0\04\0blbc", CORE, 0xe9, 2, A_RL, A_BB,0,0,0,0),
OP("\0\0\0\0\2\0\04\0acbb", CORE, 0x9d, 4, A_RB, A_RB, A_MB, A_BW,0,0),
OP("\0\0\0\0\2\0\04\0acbw", CORE, 0x3d, 4, A_RW, A_RW, A_MW, A_BW,0,0),
OP("\0\0\0\0\2\0\04\0acbl", CORE, 0xf1, 4, A_RL, A_RL, A_ML, A_BW,0,0),
OP("\0\0\0\0\2\0\04\0acbf", CORE, 0x4f, 4, A_RF, A_RF, A_MF, A_BW,0,0),
OP("\0\0\0\0\2\0\04\0acbd", CORE, 0x6f, 4, A_RD, A_RD, A_MD, A_BW,0,0),
OP("\0\0\0\0\2\0\04\0acbg", ESCD, 0x4f, 4, A_RG, A_RG, A_MG, A_BW,0,0),
OP("\0\0\0\0\2\0\04\0acbh", ESCD, 0x6f, 4, A_RH, A_RH, A_MH, A_BW,0,0),
OP("\0\0\0\0\2\0\06\0aoblss", CORE, 0xf2, 3, A_RL, A_ML, A_BB,0,0,0),
OP("\0\0\0\0\2\0\06\0aobleq", CORE, 0xf3, 3, A_RL, A_ML, A_BB,0,0,0),
OP("\0\0\0\0\2\0\06\0sobgeq", CORE, 0xf4, 2, A_ML, A_BB,0,0,0,0),
OP("\0\0\0\0\2\0\06\0sobgtr", CORE, 0xf5, 2, A_ML, A_BB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0caseb", CORE, 0x8f, 3, A_RB, A_RB, A_RB,0,0,0),
OP("\0\0\0\0\2\0\05\0casew", CORE, 0xaf, 3, A_RW, A_RW, A_RW,0,0,0),
OP("\0\0\0\0\2\0\05\0casel", CORE, 0xcf, 3, A_RL, A_RL, A_RL,0,0,0),
OP("\0\0\0\0\2\0\04\0bsbb", CORE, 0x10, 1, A_BB,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0bsbw", CORE, 0x30, 1, A_BW,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0jsb", CORE, 0x16, 1, A_AB,0,0,0,0,0),
OP("\0\0\0\0\2\0\03\0rsb", CORE, 0x05, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0callg", CORE, 0xfa, 2, A_AB, A_AB,0,0,0,0),
OP("\0\0\0\0\2\0\05\0calls", CORE, 0xfb, 2, A_RL, A_AB,0,0,0,0),
OP("\0\0\0\0\2\0\03\0ret", CORE, 0x04, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\05\0movc3", CORE, 0x28, 3, A_RW, A_AB, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0movc5", CORE, 0x2c, 5, A_RW, A_AB, A_RB, A_RW, A_AB,0),
OP("\0\0\0\0\2\0\05\0movtc", CORE, 0x2e, 6, A_RW, A_AB, A_RB, A_AB, A_RW, A_AB),
OP("\0\0\0\0\2\0\06\0movtuc", CORE, 0x2f, 6, A_RW, A_AB, A_RB, A_AB, A_RW, A_AB),
OP("\0\0\0\0\2\0\05\0cmpc3", CORE, 0x29, 3, A_RW, A_AB, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0cmpc5", CORE, 0x2d, 5, A_RW, A_AB, A_RB, A_RW, A_AB,0),
OP("\0\0\0\0\2\0\05\0scanc", CORE, 0x2a, 4, A_RW, A_AB, A_AB, A_RB,0,0),
OP("\0\0\0\0\2\0\05\0spanc", CORE, 0x2b, 4, A_RW, A_AB, A_AB, A_RB,0,0),
OP("\0\0\0\0\2\0\04\0locc", CORE, 0x3a, 3, A_RB, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\04\0skpc", CORE, 0x3b, 3, A_RB, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\06\0matchc", CORE, 0x39, 4, A_RW, A_AB, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\03\0crc", CORE, 0x0b, 4, A_AB, A_RL, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\04\0movp", CORE, 0x34, 3, A_RW, A_AB, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0cmpp3", CORE, 0x35, 3, A_RW, A_AB, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0cmpp4", CORE, 0x37, 4, A_RW, A_AB, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\05\0addp4", CORE, 0x20, 4, A_RW, A_AB, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\05\0addp6", CORE, 0x21, 6, A_RW, A_AB, A_RW, A_AB, A_RW, A_AB),
OP("\0\0\0\0\2\0\05\0subp4", CORE, 0x22, 4, A_RW, A_AB, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\05\0subp6", CORE, 0x23, 6, A_RW, A_AB, A_RW, A_AB, A_RW, A_AB),
OP("\0\0\0\0\2\0\04\0mulp", CORE, 0x25, 6, A_RW, A_AB, A_RW, A_AB, A_RW, A_AB),
OP("\0\0\0\0\2\0\04\0divp", CORE, 0x27, 6, A_RW, A_AB, A_RW, A_AB, A_RW, A_AB),
OP("\0\0\0\0\2\0\05\0cvtlp", CORE, 0xf9, 3, A_RL, A_RW, A_AB,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtpl", CORE, 0x36, 3, A_RW, A_AB, A_WL,0,0,0),
OP("\0\0\0\0\2\0\05\0cvtpt", CORE, 0x24, 5, A_RW, A_AB, A_AB, A_RW, A_AB,0),
OP("\0\0\0\0\2\0\05\0cvttp", CORE, 0x26, 5, A_RW, A_AB, A_AB, A_RW, A_AB,0),
OP("\0\0\0\0\2\0\05\0cvtps", CORE, 0x08, 4, A_RW, A_AB, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\05\0cvtsp", CORE, 0x09, 4, A_RW, A_AB, A_RW, A_AB,0,0),
OP("\0\0\0\0\2\0\04\0ashp", CORE, 0xf8, 6, A_RB, A_RW, A_AB, A_RB, A_RW, A_AB),
OP("\0\0\0\0\2\0\06\0editpc", CORE, 0x38, 4, A_RW, A_AB, A_AB, A_AB,0,0),
OP("\0\0\0\0\2\0\03\0nop", CORE, 0x01, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0escd", CORE, 0xfd, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0esce", CORE, 0xfe, 0,0,0,0,0,0,0),
OP("\0\0\0\0\2\0\04\0escf", CORE, 0xff, 0,0,0,0,0,0,0),
