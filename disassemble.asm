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


  ldi R5, instruction_ptr

  ld R0, sentinel
  not R0, R0
  add R0, R0, #1
  add R0, R0, R5

  brz STOP_DISASSEMBLY

  DISASSEMBLE_NEXT
    ld R1, opcode_mask
    and R1, R5, R1
    ld R0, twelve
    jsr RSHIFT
    add r4, r0, #0
    
    ;ADD
    ;example: ADD R0, R0, R5
    ;example: ADD R0, R3, ;17
    ADD_LOGIC
    ld R0, add_code
    not r0, r0
    add r0, r0, #1
    add r0, r0, r4
    brnp AND_LOGIC
      lea R0, add_string
      puts

      lea r0, r_string
      puts
      ld r0, nine
      ld r1, reg1_mask
      and r1, r5, r1
      jsr RSHIFT
      JSR PRINT_NUM
      lea r0, comma_string
      puts

      lea r0, r_string
      puts
      ld r0, six
      ld r1, reg2_mask
      and r1, r5, r1
      jsr RSHIFT
      JSR PRINT_NUM
      lea r0, comma_string
      puts
      
      ;immediate more or source register 2 mode?
      ld r0, five
      ld r1, operand2_flag_mask
      and r1, r5, r1
      JSR RSHIFT
      ADD R0, R0, #0
      BRP ADD_IMM5
        LEA r0, r_string
        puts
        ld r0, reg3_mask
        and r0, r0, r5
        JSR PRINT_NUM
        br FINISH_ADD
      ADD_IMM5
        ld r0, imm5_mask
        and r0, r0, r5
        JSR PRINT_NUM

      FINISH_ADD
      LD R0, one
      ST R0, valid_instruction
    
    ;AND
    ;example: AND R0, R0, R5
    ;example: AND R0, R3, ;17
    AND_LOGIC
    ;if this_opcode - and_code == 0
      ;print and_string
      ;print space_string
      
      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg2_mask) >> 6
      ;print reg
      ;print comma_string
      ;print space_string
      
      ;flag = (this_instruction & operand2_flag_mask) >> 5
      ;if flag == 0
        ;print r_string
        ;reg = (this_instruction & reg3_mask)
        ;print reg
      ;end
      ;if flag == 1
        ;imm5 = (this_instruction & imm5_mask)
        ;print hash_string
        ;print imm5
      ;end

      ;valid_instruction = 1
    ;end
  
    ;;BR and NOP
    ;;example: BR NZP ;4
    ;;example: NOP
    ;if this_opcode - br_code == 0
      ;cc = (this_instruction & br_cc_mask) >> 9
      ;if cc == 0
        ;print nop_string
      ;else
        ;print br_string
      
        ;;n set?
        ;n = (this_instruction & br_n_mask) >> 11
        ;if n > 0
          ;print n_string
        ;end
      
        ;;z set?
        ;z = (this_instruction & br_z_mask) >> 10
        ;if z > 0
          ;print z_string
        ;end
      
        ;;p set?
        ;p = (this_instruction & br_p_mask) >> 9
        ;if p > 0
          ;print p_string
        ;end
      
        ;print space_string
        ;offset = (this_instruction & offset9_mask)
        ;print hash_string
        ;print offset
      ;end

      ;valid_instruction = 1
    ;end

    ;;JMP and RET
    ;;example: JMP R5
    ;;example: RET
    ;if this_opcode - jmp_code == 0
      ;;ret and jmp share the same opcode
      ;reg = (this_instruction & reg2_mask) >> 6
      ;if reg - 7 == 0
        ;print ret_string
      ;else
        ;print jmp_string
        ;print space_string

        ;print r_string
        ;print reg
      ;end
      
      ;valid_instruction = 1
    ;end

    ;;JSR and JSRR
    ;;example: JSR ;123
    ;;example: JSRR R3
    ;if this_opcode - jsr_code == 0
      ;;jsr and jsrr share the same opcode
      ;jsr_flag = (this_instruction & jsr_flag_mask) >> 11
      ;if jsr_flag > 0
        ;offset = (this_instruction & offset11_mask)
        ;print jsr_string
        ;print space_string

        ;print hash_string
        ;print offset
      ;else
        ;print jsrr_string
        ;print space_string

        ;print r_string
        ;reg = (this_instruction & reg2_mask) >> 6
        ;print reg
      ;end

      ;valid_instruction = 1
    ;end

    ;;LD
    ;;example: LD R3, ;5
    ;if this_opcode - ld_code == 0
      ;print ld_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset9_mask)
      ;print hash_string
      ;print offset
      
      ;valid_instruction = 1
    ;end

    ;;LDI
    ;;example: LDI R2, ;22
    ;if this_opcode - ldi_code == 0
      ;print ldi_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset9_mask)
      ;print hash_string
      ;print offset
      
      ;valid_instruction = 1
    ;end

    ;;LDR
    ;;example: LDR R0, R4, ;5
    ;if this_opcode - ldr_code == 0
      ;print ldr_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg2_mask) >> 6
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset6_mask)
      ;print hash_string
      ;print offset
      
      ;valid_instruction = 1
    ;end

    ;;LEA
    ;;example: LEA R3, ;2
    ;if this_opcode - lea_code == 0
      ;print lea_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset9_mask)
      ;print hash_string
      ;print offset
      
      ;valid_instruction = 1
    ;end

    ;;NOT
    ;;example: NOT R0, R0
    ;if this_opcode - not_code == 0
      ;print not_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg2_mask) >> 6
      ;print reg
      
      ;valid_instruction = 1
    ;end

    ;;ST
    ;;example: ST R1, ;46
    ;if this_opcode - st_code == 0
      ;print st_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset9_mask)
      ;print hash_string
      ;print offset

      ;valid_instruction = 1
    ;end

    ;;STI
    ;;example: STI R0, ;128
    ;if this_opcode - sti_code == 0
      ;print sti_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset9_mask)
      ;print hash_string
      ;print offset

      ;valid_instruction = 1
    ;end

    ;;STR
    ;;example STR R0, R1, ;3
    ;if this_opcode - str_code == 0
      ;print str_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg1_mask) >> 9
      ;print reg
      ;print comma_string
      ;print space_string

      ;print r_string
      ;reg = (this_instruction & reg2_mask) >> 6
      ;print reg
      ;print comma_string
      ;print space_string

      ;offset = (this_instruction & offset6_mask)
      ;print hash_string
      ;print offset

      ;valid_instruction = 1

    ;end

    ;;HALT
    ;;example: HALT
    ;if this_instruction - halt_code == 0
      ;print halt_string

      ;valid_instruction = 1
    ;end

    ;;ERROR (for all not accepted instructions)
    ;;example: ERROR
    ;if valid_instruction == 0
      ;print error_string
    ;end

    ;print "\n"

    ;instruction_ptr += 1

  STOP_DISASSEMBLY

  HALT

  instruction_ptr .fill x5000

  ;we'll force the opcode code to turn this on
  ;if we get down to the bottom, and this hasn't been set, we've encountered
  ;one of the no-no opcodes for this homework, such as RTI, (reserved
  ;opcode), or traps other than HALT. in that case, write ERROR
  valid_instruction .fill x0

  ;we're going to be parsing 16-bit instructions. these masks will allow us to
  ;get meaningful data out of out of those 16 bits
  ;to use: (instruction & mask) >> x, where x is the index of the
  ;least-significant bit of of the mask
  ;e.g (0x00011011000001100 & opcode mask) >> 12 = 0001

  ;opcode mask
  opcode_mask .fill xF000

  ;destination/base and source register masks
  reg1_mask .fill xE00 ;the register found at bits 11 through 9
  reg2_mask .fill x1C0 ;the register found at bit 8 through 6
  reg3_mask .fill x7 ;the register found at bits 2 through 0

  ;condition code masks
  br_cc_mask .fill xE00 ;the whole kitten kaboodle, >> 9
  br_n_mask .fill x800 ; >> 11
  br_z_mask .fill x400 ; >> 10
  br_p_mask .fill x200 ; >> 9

  ;imm5 vs source register flag mask
  ;if 0, using 2 registers. if 1, using a register and a imm5
  operand2_flag_mask .fill x20 ; >> 5

  ;jsr vs jsrr flag mask
  ;if 0, jsrr. if 1, jsr
  jsr_flag_mask .fill x800 ; >> 7

  ;offset masks
  ;offset masks are always the least significant x bits
  offset9_mask .fill x1FF
  offset11_mask .fill x7FF
  offset6_mask .fill x3f

  ;imm5 mask
  ;always lsb
  imm5_mask .fill x1F

  ;trap vector mask
  ;always lsb
  trap_vector_mask .fill xFF

  
  ;opcodes
  add_code .fill x1
  and_code .fill x5
  br_code .fill x0
  jmp_code .fill xC
  jsr_code .fill x4
  ld_code .fill x2
  ldi_code .fill xA
  ldr_code .fill x6
  lea_code .fill xE
  not_code .fill x9
  rti_code .fill x8
  st_code .fill x3
  sti_code .fill xB
  str_code .fill x7
  ;trap_code .fill xF
  halt_code .fill xF025 ; we only have 1 trap (xF---), and thats halt

  ;sentinel value
  sentinel .fill xFFFF

  ;constants
  zero .fill x0
  one .fill x1
  five .fill x5
  six .fill x6
  nine .fill x9
  ten .fill xA
  eleven .fill xB
  twelve .fill xC

  ;opcode strings
  add_string .stringz "ADD "
  and_string .stringz "AND "
  br_string .stringz "BR "
  jmp_string .stringz "JMP "
  jsr_string .stringz "JSR "
  jsrr_string .stringz "JSRR "
  ld_string .stringz "LD "
  ldi_string .stringz "LDI "
  ldr_string .stringz "LDR "
  lea_string .stringz "LEA "
  not_string .stringz "NOT "
  nop_string .stringz "NOP "
  ret_string .stringz "RET "
  rti_string .stringz "RTI "
  st_string .stringz "ST "
  sti_string .stringz "STI "
  str_string .stringz "STR "
  trap_string .stringz "TRAP "

  ;other strings
  n_string .stringz "N"
  z_string .stringz "Z"
  p_string .stringz "P"
  comma_string .stringz ", "
  halt_string .stringz "HALT"
  r_string .stringz "R" ;as in register, R1, R2, ...
  error_string .stringz "ERROR"
  
  .end
;======DO NOT EDIT THIS SECTION=================================================

;; Preconditions:
;;  R1 is between x0000 and xFFFF (x)
;;  R0 is between 1 and 15 (y)
;;
;; Postconditions:
;;  R0 <- R1 >> R0 (x >> y)
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
.fill x1DBD 
.fill x7180 
.fill x7381 
.fill x7F82 
.fill x5000 
.fill x040A 
.fill x1220 
.fill x5020
.fill x1024
.fill x4FE0 
.fill x4FF5 
.fill x1060 
.fill x220B 
.fill x5040 
.fill x480A 
.fill x0E02 
.fill x2006 
.fill xF021 
.fill x6180 
.fill x6381 
.fill x6F82 
.fill x1DA3 
.fill xC1C0 
.fill x0078 
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

.end
;===============================================================================

;Instructions to disassemble.  Put things here to test them.
.orig x5000
  .fill x100F
  .fill x102F
  .fill x500F
  .fill x502F
  .fill x0E00
  .fill x027C
  .fill x0463
  .fill x06E0
  .fill x090D
  .fill x0AAC
  .fill x0CFD
  .fill x0E64
  .fill x00B2
  .fill xC180
  .fill xC1C0
  .fill x49C0
  .fill x41C0
  .fill x284F
  .fill xA84D
  .fill x684D
  .fill xEA0D
  .fill x9A3F
  .fill x8000
  .fill x86AF
  .fill x3A34
  .fill xBA34
  .fill x7A34
  .fill xF025
  .fill xF024
  .fill xFFFF
.end

