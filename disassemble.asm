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

  ;put every type of parameter into PARAMS[0-9]
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
  
  ;check if its add
  LD R0, ADD_CODE
  ADD R0, R0, R4
  BRNP CHECK_AND
  LEA R0, ADD_STRING
  PUTS
  BR DETERMINE_OPERAND2

  ;check if its and
  CHECK_AND
  LD R0, AND_CODE
  ADD R0, R0, R4
  BRNP CHECK_BR
  LEA R0, AND_STRING
  PUTS

  ;assign proper params code
  DETERMINE_OPERAND2
  LD R1, OPERAND2_FLAG_MASK
  LD R0, FIVE
  AND R1, R1, R5
  JSR RSHIFT
  ADD R0, R0, #0
  BRZ SR2
  LD R2, ADD_AND_IMM5_PARAMS
  JSR WRITE_PARAMS

  SR2
  LD R2, ADD_AND_SR2_PARAMS
  JSR WRITE_PARAMS

  ;check if its BR
  CHECK_BR
  LD R0, BR_CODE
  ADD R0, R0, R4
  BRNP CHECK_JMP
  LD R1, BR_CC_MASK
  AND R1, R1, R5
  LD R0, NINE
  JSR RSHIFT
  ADD R0, R0, #0
  BRZ P_NOP
  LEA R0, BR_STRING
  PUTS
  LD R2, BR_PARAMS
  JSR WRITE_PARAMS

  P_NOP
  LEA R0, NOP_STRING
  PUTS
  LD R2, RET_HALT_NOP_PARAMS
  JSR WRITE_PARAMS
 
 ;check if its jmp 
  CHECK_JMP
  LD R0, JMP_CODE
  ADD R0, R0, R4
  BRNP CHECK_JSR
  LD R1, REG2_MASK
  AND R1, R1, R5
  LD R0, SIX
  JSR RSHIFT
  ADD R0, R0, #-7
  BRZ P_RET
  LEA R0, JMP_STRING
  PUTS
  LD R2, JMP_JSRR_PARAMS
  JSR WRITE_PARAMS

  P_RET
  LEA R0, RET_STRING
  PUTS
  LD R2, RET_HALT_NOP_PARAMS
  JSR WRITE_PARAMS

 ;check if its jsr
  CHECK_JSR
  LD R0, JSR_CODE
  ADD R0, R0, R4
  BRNP CHECK_LD
  LD R1, JSR_FLAG_MASK
  AND R1, R1, R5
  LD R0, ELEVEN
  JSR RSHIFT
  ADD R0, R0, #0
  BRZ P_JSRR
  LEA R0, JSR_STRING
  PUTS
  LD R2, JSR_PARAMS
  JSR WRITE_PARAMS

  P_JSRR
  LEA R0, JSRR_STRING
  PUTS
  LD R2, JMP_JSRR_PARAMS
  JSR WRITE_PARAMS

  CHECK_LD
  LD R0, LD_CODE
  ADD R0, R0, R4
  BRNP CHECK_LDI
  LEA R0, LD_STRING
  PUTS
  LD R2, LD_LDI_LEA_ST_STI_PARAMS
  JSR WRITE_PARAMS

  CHECK_LDI
  LD R0, LDI_CODE
  ADD R0, R0, R4
  BRNP CHECK_LDR
  LEA R0, LDI_STRING
  PUTS
  LD R2, LD_LDI_LEA_ST_STI_PARAMS
  JSR WRITE_PARAMS
  
  CHECK_LDR
  LD R0, LDR_CODE
  ADD R0, R0, R4
  BRNP CHECK_LEA
  LEA R0, LDR_STRING
  PUTS
  LD R2, LDR_STR_PARAMS
  JSR WRITE_PARAMS

  CHECK_LEA
  LD R0, LEA_CODE
  ADD R0, R0, R4
  BRNP CHECK_NOT
  LEA R0, LEA_STRING
  PUTS
  LD R2, LD_LDI_LEA_ST_STI_PARAMS
  JSR WRITE_PARAMS

  CHECK_NOT
  LD R0, NOT_CODE
  ADD R0, R0, R4
  BRNP CHECK_ST
  LEA R0, NOT_STRING
  PUTS
  LD R2, NOT_PARAMS
  JSR WRITE_PARAMS

  CHECK_ST
  LD R0, ST_CODE
  ADD R0, R0, R4
  BRNP CHECK_STI
  LEA R0, ST_STRING
  PUTS
  LD R2, LD_LDI_LEA_ST_STI_PARAMS
  JSR WRITE_PARAMS


  CHECK_STI
  LD R0, STI_CODE
  ADD R0, R0, R4
  BRNP CHECK_STR
  LEA R0, STI_STRING
  PUTS
  LD R2, LD_LDI_LEA_ST_STI_PARAMS
  JSR WRITE_PARAMS

  CHECK_STR
  LD R0, STR_CODE
  ADD R0, R0, R4
  BRNP CHECK_HALT
  LEA R0, STR_STRING
  PUTS
  LD R2, LDR_STR_PARAMS
  JSR WRITE_PARAMS

  CHECK_HALT
  LD R0, HALT_CODE
  ADD R0, R0, R5 ;R5 here becase only TRAP HALT is good, no other trap
  BRNP INVALID_INSTRUCTION
  LEA R0, HALT_STRING
  PUTS
  LD R2, RET_HALT_NOP_PARAMS
  JSR WRITE_PARAMS

  ;valid_instruction resolution
  ;if we're here and valid instruction is still 0, ERROR
  INVALID_INSTRUCTION
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
  BR_PARAMS .FILL x4E
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
  JSR_FLAG_MASK .FILL x800 ; >> 11

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

  
  ;opcodes (NEGATED!)
  ADD_CODE .FILL xFFFF
  AND_CODE .FILL xFFFB
  BR_CODE .FILL x0
  JMP_CODE .FILL xFFF4
  JSR_CODE .FILL xFFFC
  LD_CODE .FILL xFFFE
  LDI_CODE .FILL xFFF6
  LDR_CODE .FILL xFFFA
  LEA_CODE .FILL xFFF2
  NOT_CODE .FILL xFFF7
  RTI_CODE .FILL xFFF8
  ST_CODE .FILL xFFFD
  STI_CODE .FILL xFFF5
  STR_CODE .FILL xFFF9
  ;TRAP_CODE .FILL xF
  HALT_CODE .FILL xFDB ; we only have 1 trap (xf---), and thats halt

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

  GET_BACK_FINISH_DISASSEMBLE .FILL x0

  .END

  WRITE_PARAMS
  LEA R0, FINISH_DISASSEMBLE
  ST R0, GET_BACK_FINISH_DISASSEMBLE
  LEA R3, PARAMS
  ;print reg1 
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_N
  LEA R0, R_STRING
  PUTS
  LDR R0, R3, #0
  JSR PRINT_NUM
  LEA R0, COMMA_STRING
  PUTS

  P_N
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print n
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_Z
  LDR R0, R3, #1
  BRZ P_Z
  LEA R0, N_STRING
  PUTS

  P_Z
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print z
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_P
  LDR R0, R3, #2
  BRZ P_P
  LEA R0, Z_STRING
  PUTS

  P_P
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print p
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_OFFSET11
  LDR R0, R3, #3
  BRZ P_OFFSET11
  LEA R0, P_STRING
  PUTS

  P_OFFSET11
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print offset11 (with a space before)
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_REG2
  LEA R0, SPACE_STRING
  PUTS
  LDR R0, R3, #4
  JSR PRINT_NUM

  P_REG2
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print reg2
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_OFFSET9
  LEA R0, R_STRING
  PUTS
  LDR R0, R3, #5
  JSR PRINT_NUM
  LEA R0, COMMA_STRING
  PUTS

  P_OFFSET9
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print offset9 (with a space before)
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_OFFSET6
  LEA R0, SPACE_STRING
  PUTS
  LDR R0, R3, #6
  JSR PRINT_NUM

  P_OFFSET6
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print offset6 (with a space before)
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_IMM5
  LEA R0, SPACE_STRING
  PUTS
  LDR R0, R3, #7
  JSR PRINT_NUM

  P_IMM5
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print imm5 (with a space before)
  LD R1, ONE
  AND R1, R1, R2
  BRZ P_REG3
  LDR R0, R3, #8
  JSR PRINT_NUM

  P_REG3
  ;shift param code
  ADD R1, R2, #0
  LD R0, ONE
  JSR RSHIFT
  ADD R2, R0, #0
  ;print reg3
  LD R1, ONE
  AND R1, R1, R2
  BRZ FINISH_WRITE_PARAMS
  LEA R0, R_STRING
  PUTS
  LDR R0, R3, #9
  JSR PRINT_NUM

  FINISH_WRITE_PARAMS

  LD R0, GET_BACK_FINISH_DISASSEMBLE
  JMP R0

;======do not edit this section=================================================

;; preconditions:
;;  r1 is between x0000 and xffff (x)
;;  r0 is between 1 and 15 (y)
;;
;; postconditions:
;;  r0 <- r1 >> r0 (x >> y)
;;
RSHIFT:
.fill x1DBE
.fill x7381
.fill x7580
.fill x54A0
.fill x14AF
.fill x14A1
.fill x903F
.fill x1021
.fill x1080
.fill x54A0
.fill x1482
.fill x5241
.fill x0601
.fill x14A1
.fill x1241
.fill x103F
.fill x03F9
.fill x10A0
.fill x6381
.fill x6580
.fill x1DA2
.fill xC1C0

;; Preconditions:
;;  R0 contains the number you wish to print
;;
;; Postconditions:
;;  R0 still contains the number you wish to print
;;  Number printed to the console in HEX.

PRINT_NUM:
.fill x5000
.fill x0A09
.fill x1DBE
.fill x7180
.fill x7F81
.fill x2019
.fill xF021
.fill x6180
.fill x6F81
.fill x1DA2
.fill xC1C0
.fill x1DBD
.fill x7180
.fill x7381
.fill x7F82
.fill x5000
.fill x0409
.fill x1220
.fill x5020
.fill x1024
.fill x4FD5
.fill x4FF5
.fill x1060
.fill x2208
.fill x5040
.fill x4807
.fill x6180
.fill x6381
.fill x6F82
.fill x1DA3
.fill xC1C0
.fill x0030
.fill x000F
.fill x1DBE
.fill x7180
.fill x7F81
.fill x1036
.fill x0606
.fill x102F
.fill x102F
.fill x102F
.fill x102D
.fill xF021
.fill x0E06
.fill x102F
.fill x102F
.fill x102F
.fill x102F
.fill x1025
.fill xF021
.fill x6180
.fill x6F81
.fill x1DA2
.fill xC1C0
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

