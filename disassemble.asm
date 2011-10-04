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
  ;R3
  ;R4 - this opcode
  ;R5 - this instruction
  ;R6 - off limits
  ;R7 - off limits


  DISASSEMBLE_NEXT
  LDI R5, INSTRUCTION_PTR
  ADD R0, R5, #1
  ST R0, INSTRUCTION_PTR

  SENTINEL_CHECK
  LD R0, SENTINEL
  NOT R0, R0
  ADD R0, R0, #1
  ADD R0, R0, R5

  BRZ STOP_DISASSEMBLY

    LD R1, OPCODE_MASK
    AND R1, R5, R1
    LD R0, TWELVE
    JSR RSHIFT
    ADD R4, R0, #0
    
    ;ADD
    ;example: ADD R0, R0, R5
    ;example: ADD R0, R3, ;17
    ADD_LOGIC
    LD R0, ADD_CODE
    NOT R0, R0
    ADD R0, R0, #1
    ADD R0, R0, R4
    BRNP AND_LOGIC
      LEA R0, ADD_STRING
      PUTS

      LEA R0, R_STRING
      PUTS
      LD R0, NINE
      LD R1, REG1_MASK
      AND R1, R5, R1
      JSR RSHIFT
      JSR PRINT_NUM
      LEA R0, COMMA_STRING
      PUTS

      LEA R0, R_STRING
      PUTS
      LD R0, SIX
      LD R1, REG2_MASK
      AND R1, R5, R1
      JSR RSHIFT
      JSR PRINT_NUM
      LEA R0, COMMA_STRING
      PUTS
      
      ;immediate more or source register 2 mode?
      LD R0, FIVE
      LD R1, OPERAND2_FLAG_MASK
      AND R1, R5, R1
      JSR RSHIFT
      ADD R0, R0, #0
      BRP ADD_IMM5
      ADD_SR2
        LEA R0, R_STRING
        PUTS
        LD R0, REG3_MASK
        AND R0, R0, R5
        JSR PRINT_NUM
        BR FINISH_ADD
      ADD_IMM5
        LD R0, IMM5_MASK
        AND R0, R0, R5
        JSR PRINT_NUM

      FINISH_ADD
      LD R0, ONE
      ST R0, VALID_INSTRUCTION
    
    ;AND
    ;example: AND R0, R0, R5
    ;example: AND R0, R3, ;17
    AND_LOGIC

  BR DISASSEMBLE_NEXT

  STOP_DISASSEMBLY

  HALT

  INSTRUCTION_PTR .FILL X5000

  ;we'll force the opcode code to turn this on
  ;if we get down to the bottom, and this hasn't been set, we've encountered
  ;one of the no-no opcodes for this homework, such as rti, (reserved
  ;opcode), or traps other than halt. in that case, write error
  VALID_INSTRUCTION .FILL X0

  ;we're going to be parsing 16-bit instructions. these masks will allow us to
  ;get meaningful data out of out of those 16 bits
  ;to use: (instruction & mask) >> x, where x is the index of the
  ;least-significant bit of of the mask
  ;e.g (0x00011011000001100 & opcode mask) >> 12 = 0001

  ;opcode mask
  OPCODE_MASK .FILL XF000

  ;destination/base and source register masks
  REG1_MASK .FILL XE00 ;the register found at bits 11 through 9
  REG2_MASK .FILL X1C0 ;the register found at bit 8 through 6
  REG3_MASK .FILL X7 ;the register found at bits 2 through 0

  ;condition code masks
  BR_CC_MASK .FILL XE00 ;the whole kitten kaboodle, >> 9
  BR_N_MASK .FILL x800 ; >> 11
  BR_Z_MASK .FILL X400 ; >> 10
  BR_P_MASK .FILL x200 ; >> 9

  ;imm5 vs source register flag mask
  ;if 0, using 2 registers. if 1, using a register and a imm5
  OPERAND2_FLAG_MASK .FILL x20 ; >> 5

  ;jsr vs jsrr flag mask
  ;if 0, jsrr. if 1, jsr
  JSR_FLAG_MASK .FILL x800 ; >> 7

  ;offset masks
  ;offset masks are always the least significant x bits
  OFFSET9_MASK .FILL X1FF
  OFFSET11_MASK .FILL X7FF
  OFFSET6_MASK .FILL X3F

  ;imm5 mask
  ;always lsb
  IMM5_MASK .FILL X1F

  ;trap vector mask
  ;always lsb
  TRAP_VECTOR_MASK .FILL XFF

  
  ;opcodes
  ADD_CODE .FILL X1
  AND_CODE .FILL X5
  BR_CODE .FILL X0
  JMP_CODE .FILL XC
  JSR_CODE .FILL X4
  LD_CODE .FILL X2
  LDI_CODE .FILL XA
  LDR_CODE .FILL X6
  LEA_CODE .FILL XE
  NOT_CODE .FILL X9
  RTI_CODE .FILL X8
  ST_CODE .FILL X3
  STI_CODE .FILL XB
  STR_CODE .FILL X7
  ;TRAP_CODE .FILL XF
  HALT_CODE .FILL XF025 ; we only have 1 trap (xf---), and thats halt

  ;sentinel value
  SENTINEL .FILL XFFFF

  ;constants
  ZERO .FILL X0
  ONE .FILL X1
  FIVE .FILL X5
  SIX .FILL X6
  NINE .FILL X9
  TEN .FILL XA
  ELEVEN .FILL XB
  TWELVE .FILL XC

  ;opcode strings
  ADD_STRING .STRINGZ "ADD "
  AND_STRING .STRINGZ "AND "
  BR_STRING .STRINGZ "BR "
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
.FILL X1DBE
.FILL X7381
.FILL X7580
.FILL X54A0
.FILL X14AF
.FILL X14A1
.FILL X903F
.FILL X1021
.FILL X1080
.FILL X54A0
.FILL X1482
.FILL X5241
.FILL X0601
.FILL X14A1
.FILL X1241
.FILL X103F
.FILL X03F9
.FILL X10A0
.FILL X6381
.FILL X6580
.FILL X1DA2
.FILL XC1C0

;; preconditions:
;;  r0 contains the number you wish to print
;;
;; postconditions:
;;  r0 still contains the number you wish to print
;;  number printed to the console in hex.
PRINT_NUM:
.FILL X5000
.FILL X0A09
.FILL X1DBE
.FILL X7180
.FILL X7F81
.FILL X2019
.FILL XF021
.FILL X6180
.FILL X6F81
.FILL X1DA2
.FILL XC1C0
.FILL X1DBD
.FILL X7180
.FILL X7381
.FILL X7F82
.FILL X5000
.FILL X0409
.FILL X1220
.FILL X5020
.FILL X1024
.FILL X4FD5
.FILL X4FF5
.FILL X1060
.FILL X2208
.FILL X5040
.FILL X4807
.FILL X6180
.FILL X6381
.FILL X6F82
.FILL X1DA3
.FILL XC1C0
.FILL X0030
.FILL X000F
.FILL X1DBE
.FILL X7180
.FILL X7F81
.FILL X1036
.FILL X0606
.FILL X102F
.FILL X102F
.FILL X102F
.FILL X102D
.FILL XF021
.FILL X0E06
.FILL X102F
.FILL X102F
.FILL X102F
.FILL X102F
.FILL X1025
.FILL XF021
.FILL X6180
.FILL X6F81
.FILL X1DA2
.FILL XC1C0
.END
;===============================================================================

;instructions to disassemble.  put things here to test them.
.ORIG X5000
  .FILL X100F
  .FILL X102F
  .FILL X500F
  .FILL X502F
  .FILL X0E00
  .FILL X027C
  .FILL X0463
  .FILL X06E0
  .FILL X090D
  .FILL X0AAC
  .FILL X0CFD
  .FILL X0E64
  .FILL X00B2
  .FILL XC180
  .FILL XC1C0
  .FILL X49C0
  .FILL X41C0
  .FILL X284F
  .FILL XA84D
  .FILL X684D
  .FILL XEA0D
  .FILL X9A3F
  .FILL X8000
  .FILL X86AF
  .FILL X3A34
  .FILL XBA34
  .FILL X7A34
  .FILL XF025
  .FILL XF024
  .FILL XFFFF
.END

