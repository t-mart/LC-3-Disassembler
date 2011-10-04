;LC-3 LC-3 Disassembler
;by Tim Martin

;======DO NOT EDIT THIS SECTION=================================================
.orig x3000
  LD R6, POINTER
  BR DISASSEMBLE

POINTER .fill xFE00
;===============================================================================

DISASSEMBLE:
  
  ;Register conventions
  ;R0
  ;R1
  ;R2
  ;R3 - param code
  ;R4 - this opcode
  ;R5 - this instruction
  ;R6 - off limits
  ;R7 - off limits

  ;===============START DISASSEMBLY LOOP===============
  DISASSEMBLE_NEXT
  ;put next instruction into R5
  LDI R5, INSTRUCTION_PTR

  ;check for sentinel
  LD R0, SENTINEL
  NOT R0, R0
  ADD R0, R0, #1
  ADD R0, R0, R5
  BRZ STOP_DISASSEMBLY

  ;put opcode into R4
  LD R1, OPCODE_MASK
  AND R1, R5, R1
  LD R0, TWELVE
  JSR RSHIFT
  ADD R4, R0, #0

  LEA R3, PARAMS
  LD R0, NINE
  LD R1, REG1_MASK
  AND R1, R1, R5
  JSR RSHIFT
  STR R0, R3, #0

  LD R0, ELEVEN
  LD R1, BR_N_MASK
  AND R1, R1, R5
  JSR RSHIFT
  STR R0, R3, #1

  LD R0, TEN
  LD R1, BR_Z_MASK
  AND R1, R1, R5
  JSR RSHIFT
  STR R0, R3, #2

  LD R0, NINE
  LD R1, BR_P_MASK
  AND R1, R1, R5
  JSR RSHIFT
  STR R0, R3, #3

  LD R1, OFFSET11_MASK
  AND R1, R1, R5
  STR R1, R3, #4

  LD R0, SIX
  LD R1, REG2_MASK
  AND R1, R1, R5
  JSR RSHIFT
  STR R0, R3, #5

  LD R1, OFFSET9_MASK
  AND R1, R1, R5
  STR R1, R3, #6

  LD R1, OFFSET6_MASK
  AND R1, R1, R5
  STR R1, R3, #7

  LD R1, IMM5_MASK
  AND R1, R1, R5
  STR R1, R3, #8

  LD R1, REG3_MASK
  AND R1, R1, R5
  STR R1, R3, #9

  ;valid_instruction resolution
  ;if we're here and valid instruction is still 0, ERROR
  LD R0, VALID_INSTRUCTION
  BRP FINISH_DISASSEMBLE
  LEA R0, ERROR_STRING
  PUTS

  FINISH_DISASSEMBLE
  ;throw down a newline
  LEA R0, NEWLINE_STRING
  PUTS

  ;increment the instruction pointer
  LD R0, INSTRUCTION_PTR
  ADD R0, R0, #1
  ST R0, INSTRUCTION_PTR

  ;set valid_instruction to 0(used to print ERROR if its an off limits opcode
  LD R0, ZERO
  ST R0, VALID_INSTRUCTION

  BR DISASSEMBLE_NEXT



  STOP_DISASSEMBLY
  HALT

  ;==================================CONTSTANTS================================

  ;points to the instruction we're disassembling
  INSTRUCTION_PTR .FILL x5000

  ;we'll force the opcode code to turn this on
  ;if we get down to the bottom, and this hasn't been set, we've encountered
  ;one of the no-no opcodes for this homework, such as rti, (reserved
  ;opcode), or traps other than halt. in that case, write error
  VALID_INSTRUCTION .FILL x0

  ADD_AND_SR2_PARAMS .FILL x221
  ADD_AND_IMM5_PARAMS .FILL x121
  BR_PARAMS .FILL x1E
  JMP_JSRR_PARAMS .FILL x20
  JSR_PARAMS .FILL x10
  LD_LDI_LEA_ST_STI_PARAMS .FILL x41
  LDR_STR_PARAMS .FILL xA1
  NOT_PARAMS .FILL x21
  RET_HALT_NOP_PARAMS .FILL x0

  PARAMS .BLKW #10

  ;opcode mask
  OPCODE_MASK .FILL xF000

  ;destination/base and source register masks
  REG1_MASK .FILL xE00 ;the register found at bits 11 through 9
  REG2_MASK .FILL x1C0 ;the register found at bit 8 through 6
  REG3_MASK .FILL x7 ;the register found at bits 2 through 0

  ;condition code masks
  BR_CC_MASK .FILL xE00 ;the whole kitten kaboodle, >> 9
  BR_N_MASK .FILL x800 ; >> 11
  BR_Z_MASK .FILL x400 ; >> 10
  BR_P_MASK .FILL x200 ; >> 9

  ;imm5 vs source register flag mask
  ;if 0, using 2 registers. if 1, using a register and a imm5
  OPERAND2_FLAG_MASK .FILL x20 ; >> 5

  ;jsr vs jsrr flag mask
  ;if 0, jsrr. if 1, jsr
  JSR_FLAG_MASK .FILL x800 ; >> 7

  ;offset masks
  ;offset masks are always the least significant x bits
  OFFSET9_MASK .FILL x1FF
  OFFSET11_MASK .FILL x7FF
  OFFSET6_MASK .FILL x3F

  ;imm5 mask
  ;always lsb
  IMM5_MASK .FILL x1F

  ;trap vector mask
  ;always lsb
  TRAP_VECTOR_MASK .FILL xFF

  
  ;opcodes
  ADD_CODE .FILL x1
  AND_CODE .FILL x5
  BR_CODE .FILL x0
  JMP_CODE .FILL xC
  JSR_CODE .FILL x4
  LD_CODE .FILL x2
  LDI_CODE .FILL xA
  LDR_CODE .FILL x6
  LEA_CODE .FILL xE
  NOT_CODE .FILL x9
  RTI_CODE .FILL x8
  ST_CODE .FILL x3
  STI_CODE .FILL xB
  STR_CODE .FILL x7
  ;TRAP_CODE .FILL xF
  HALT_CODE .FILL xF025 ; we only have 1 trap (xf---), and thats halt

  ;sentinel value
  SENTINEL .FILL xFFFF

  ;constants
  ZERO .FILL x0
  ONE .FILL x1
  FIVE .FILL x5
  SIX .FILL x6
  NINE .FILL x9
  TEN .FILL xA
  ELEVEN .FILL xB
  TWELVE .FILL xC

  ;opcode strings
  ADD_STRING .STRINGZ "ADD "
  AND_STRING .STRINGZ "AND "
  BR_STRING .STRINGZ "BR" ;no space after this because the cc come immediately after
  JMP_STRING .STRINGZ "JMP "
  JSR_STRING .STRINGZ "JSR "
  JSRR_STRING .STRINGZ "JSRR "
  LD_STRING .STRINGZ "LD "
  LDI_STRING .STRINGZ "LDI "
  LDR_STRING .STRINGZ "LDR "
  LEA_STRING .STRINGZ "LEA "
  NOT_STRING .STRINGZ "NOT "
  NOP_STRING .STRINGZ "NOP "
  RET_STRING .STRINGZ "RET "
  RTI_STRING .STRINGZ "RTI "
  ST_STRING .STRINGZ "ST "
  STI_STRING .STRINGZ "STI "
  STR_STRING .STRINGZ "STR "
  TRAP_STRING .STRINGZ "TRAP "

  ;other strings
  N_STRING .STRINGZ "N"
  Z_STRING .STRINGZ "Z"
  P_STRING .STRINGZ "P"
  COMMA_STRING .STRINGZ ", "
  HALT_STRING .STRINGZ "HALT"
  R_STRING .STRINGZ "R" ;as in register, r1, r2, ...
  ERROR_STRING .STRINGZ "ERROR"
  NEWLINE_STRING .STRINGZ "\n"
  SPACE_STRING .STRINGZ " "
  X_STRING .STRINGZ "x"
  
  .END
;======do not edit this section=================================================

;; preconditions:
;;  r1 is between x0000 and xffff (x)
;;  r0 is between 1 and 15 (y)
;;
;; postconditions:
;;  r0 <- r1 >> r0 (x >> y)
;;
RSHIFT:
.FILL x1DBE
.FILL x7381
.FILL x7580
.FILL x54A0
.FILL x14AF
.FILL x14A1
.FILL x903F
.FILL x1021
.FILL x1080
.FILL x54A0
.FILL x1482
.FILL x5241
.FILL x0601
.FILL x14A1
.FILL x1241
.FILL x103F
.FILL x03F9
.FILL x10A0
.FILL x6381
.FILL x6580
.FILL x1DA2
.FILL x1020
.FILL xC1C0

;; preconditions:
;;  r0 contains the number you wish to print
;;
;; postconditions:
;;  r0 still contains the number you wish to print
;;  number printed to the console in hex.
PRINT_NUM:
.FILL x5000
.FILL x0A09
.FILL x1DBE
.FILL x7180
.FILL x7F81
.FILL x2019
.FILL xF021
.FILL x6180
.FILL x6F81
.FILL x1DA2
.FILL xC1C0
.FILL x1DBD
.FILL x7180
.FILL x7381
.FILL x7F82
.FILL x5000
.FILL x0409
.FILL x1220
.FILL x5020
.FILL x1024
.FILL x4FD5
.FILL x4FF5
.FILL x1060
.FILL x2208
.FILL x5040
.FILL x4807
.FILL x6180
.FILL x6381
.FILL x6F82
.FILL x1DA3
.FILL xC1C0
.FILL x0030
.FILL x000F
.FILL x1DBE
.FILL x7180
.FILL x7F81
.FILL x1036
.FILL x0606
.FILL x102F
.FILL x102F
.FILL x102F
.FILL x102D
.FILL xF021
.FILL x0E06
.FILL x102F
.FILL x102F
.FILL x102F
.FILL x102F
.FILL x1025
.FILL xF021
.FILL x6180
.FILL x6F81
.FILL x1DA2
.FILL xC1C0
.END
;===============================================================================

;instructions to disassemble.  put things here to test them.
.ORIG x5000
  .FILL x100F
  .FILL x102F
  .FILL x500F
  .FILL x502F
  .FILL x0E00
  .FILL x027C
  .FILL x0463
  .FILL x06E0
  .FILL x090D
  .FILL x0AAC
  .FILL x0CFD
  .FILL x0E64
  .FILL x00B2
  .FILL xC180
  .FILL xC1C0
  .FILL x49C0
  .FILL x41C0
  .FILL x284F
  .FILL xA84D
  .FILL x684D
  .FILL xEA0D
  .FILL x9A3F
  .FILL x8000
  .FILL x86AF
  .FILL x3A34
  .FILL xBA34
  .FILL x7A34
  .FILL xF025
  .FILL xF024
  .FILL xFFFF
.END

