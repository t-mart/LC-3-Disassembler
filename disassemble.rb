#Ruby LC-3 Disassembler
#by Tim Martin
#
#everything is written in this method. because this code is serving simply as
#psuedo-code for the final version in assembly itself, IM GOING TO SPARE THE
#RUBYISMS AND CODE MORE LIKE ASM.
def disassemble memory  
  #we're going to be parsing 16-bit instructions. these masks will allow us to
  #get meaningful data out of out of those 16 bits
  #to use: (instruction & mask) >> x, where x is the index of the
  #least-significant bit of of the mask
  #e.g (0x00011011000001100 & opcode mask) >> 12 = 0001

  #opcode mask
  opcode_mask = 0xF000

  #destination/base and source register masks
  reg1_mask = 0xE00 #the register found at bits 11 through 9
  reg2_mask = 0x1C0 #the register found at bit 8 through 6
  reg3_mask = 0x7 #the register found at bits 2 through 0

  #condition code masks
  br_cc_mask = 0xE00 #the whole kitten kaboodle, >> 9
  br_n_mask = 0x800 # >> 11
  br_z_mask = 0x400 # >> 10
  br_p_mask = 0x200 # >> 9

  #imm5 vs source register flag mask
  #if 0, using 2 registers. if 1, using a register and a imm5
  operand2_flag_mask = 0x20 # >> 5

  #jsr vs jsrr flag mask
  #if 0, jsrr. if 1, jsr
  jsr_flag_mask = 0x800 # >> 7

  #offset masks
  #offset masks are always the least significant x bits
  offset9_mask = 0x1FF
  offset11_mask = 0x7FF
  offset6_mask = 0x3f

  #imm5 mask
  #always lsb
  imm5_mask = 0x1F

  #trap vector mask
  #always lsb
  trap_vector_mask = 0xFF

  
  #opcodes
  add_code = 0x1
  and_code = 0x5
  br_code = 0x0
  jmp_code = 0xC
  jsr_code = 0x4
  ld_code = 0x2
  ldi_code = 0xA
  ldr_code = 0x6
  lea_code = 0xE
  not_code = 0x9
  rti_code = 0x8
  st_code = 0x3
  sti_code = 0xB
  str_code = 0x7
  #trap_code = 0xF
  halt_code = 0xF025 # we only have 1 trap (0xF---), and thats halt


  #opcode strings
  add_string = "ADD"
  and_string = "AND"
  br_string = "BR"
  jmp_string = "JMP"
  jsr_string = "JSR"
  jsrr_string = "JSRR"
  ld_string = "LD"
  ldi_string = "LDI"
  ldr_string = "LDR"
  lea_string = "LEA"
  not_string = "NOT"
  nop_string = "NOP"
  ret_string = "RET"
  rti_string = "RTI"
  st_string = "ST"
  sti_string = "STI"
  str_string = "STR"
  trap_string = "TRAP"

  #other strings
  n_string = "N"
  z_string = "Z"
  p_string = "P"
  comma_string = ","
  halt_string = "HALT"
  space_string = " "
  r_string = "R" #as in register, R1, R2, ...
  error_string = "ERROR"
  hash_string = "#"
  
  #sign extension addends
  #we can encounter 2's complement numbers that are negative in x number of
  #bits, but not y number.
  #
  #for example: (binary) 0000 0101
  #in 3-bit 2's comp, this number is -3
  #in 8-bit 2's comp, this number is 5
  #
  #since ruby and lc3 have no (primitive) understanding of numbers with smaller 
  #bit lengths than the system default (32 and 16 respectively), we need to sign
  #extend these numbers so that the system also conveys bit these lengths.
  #
  #for negative 2's complement numbers, if we assume that the msb == the desired
  #bit length (ie, the number has been masked so that it contains no other data
  #beyond the desired bit length) then we can simply add an appropriate addend
  #constructed of all 1's in all places beyond the msb.
  #
  #extending our previous example: 
  #-3 = 1111 1101 = 1111 1000 + 0000 0101
  #
  #the following are these addends for various desired bit lengths
  #
  #NOTE: this is a system-dependent implementation. on this dev machine, the
  #integers we get by default are 32 bits. on lc3, its 16, and it could be
  #anything else for other machines. proceed with caution.
#  bit5_extender = 0xFFFFFFE0
#  bit6_extender = 0xFFFFFFC0
#  bit9_extender = 0xFFFFFE00
#  bit11_extender = 0xFFFFF800

  
  #a more asm way of saying index counter
  instruction_ptr = 0x0

  while memory[instruction_ptr] - 0xFFFF != 0
    this_instruction = memory[instruction_ptr]
    
    this_opcode = (this_instruction & opcode_mask) >> 12

    #we'll force the opcode code to turn this on
    #if we get down to the bottom, and this hasn't been set, we've encountered one of the
    #no-no opcodes for this homework, such as RTI, (reserved opcode), or traps other than
    #HALT. in that case, write ERROR
    valid_instruction = 0
    
    #ADD
    #example: ADD R0, R0, R5
    #example: ADD R0, R3, #17
    if this_opcode - add_code == 0
      print add_string
      print colon_string
      print space_string

      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print r_string
      reg = (this_instruction & reg2_mask) >> 6
      print reg
      print space_string
      print addition_sign_string
      print space_string
      
      #immediate more or source register 2 mode?
      flag = (this_instruction & operand2_flag_mask) >> 5
      if flag == 0
        print r_string
        reg = (this_instruction & reg3_mask)
        print reg
      end
      if flag == 1
        imm5 = (this_instruction & imm5_mask)
        print imm5
      end

      valid_instruction = 1
    end
    
    #AND
    #example: AND R0, R0, R5
    #example: AND R0, R3, #17
    if this_opcode - and_code == 0
      print and_string
      print colon_string
      print space_string
      
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print r_string
      reg = (this_instruction & reg2_mask) >> 6
      print reg
      print space_string
      print and_sign_string
      print space_string
      
      flag = (this_instruction & operand2_flag_mask) >> 5
      if flag == 0
        print r_string
        reg = (this_instruction & reg3_mask)
        print reg
      end
      if flag == 1
        imm5 = (this_instruction & imm5_mask)
        print imm5
      end

      valid_instruction = 1
    end
  
    #BR and NOP
    #example: BR NZP #4
    #example: NOP
    if this_opcode - br_code == 0
      cc = (this_instruction & br_cc_mask) >> 9
      if cc == 0
        print nop_string
      else
        print br_string
        print colon_string
        print space_string
        print cc_string
        print space_string
      
        #n set?
        n = (this_instruction & br_n_mask) >> 11
        if n > 0
          print n_string
        end
      
        #z set?
        z = (this_instruction & br_z_mask) >> 10
        if z > 0
          print z_string
        end
      
        #p set?
        p = (this_instruction & br_p_mask) >> 9
        if p > 0
          print p_string
        end
      
        print comma_string
        print space_string
        print pc_string
        print space_string
        print set_to_string
        print space_string
        print pc_string
        print space_string
        print addition_sign_string
        print space_string
        offset = (this_instruction & offset9_mask)
        print offset
      end

      valid_instruction = 1
    end

    #JMP and RET
    #example: JMP R5
    #example: RET
    if this_opcode - jmp_code == 0
      #ret and jmp share the same opcode
      reg = (this_instruction & reg2_mask) >> 6
      if reg - 7 == 0
        print ret_string
      else
        print jmp_string
      end
      print colon_string
      
      print space_string
      print pc_string
      print space_string
      print set_to_string
      print space_string
      print r_string
      print reg
      
      valid_instruction = 1
    end

    #JSR and JSRR
    #example: JSR #123
    #example: JSRR R3
    if this_opcode - jsr_code == 0
      #jsr and jsrr share the same opcode
      jsr_flag = (this_instruction & jsr_flag_mask) >> 11
      if jsr_flag > 0
        offset = (this_instruction & offset11_mask)
        print jsr_string
        print colon_string
      
        print space_string
        print pc_string
        print space_string
        print set_to_string
        print space_string
        print pc_string
        print space_string
        print addition_sign_string
        print space_string
        print offset
      else
        print jsrr_string
        print colon_string
      
        print space_string
        print pc_string
        print space_string
        print set_to_string
        print space_string
        print r_string
        reg = (this_instruction & reg2_mask) >> 6
        print reg
      end

      valid_instruction = 1
    end

    #LD
    #example: LD R3, #5
    if this_opcode - ld_code == 0
      print ld_string
      print colon_string
      
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print mem_string
      print left_bracket_string
      print pc_string
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset9_mask)
      print offset
      print right_bracket_string
      
      valid_instruction = 1
    end

    #LDI
    #example: LDI R2, #22
    if this_opcode - ldi_code == 0
      print ldi_string
      print colon_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print mem_string
      print left_bracket_string
      print mem_string
      print left_bracket_string
      print pc_string
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset9_mask)
      print offset
      print right_bracket_string
      print right_bracket_string
      
      valid_instruction = 1
    end

    #LDR
    #example: LDR R0, R4, #5
    if this_opcode - ldr_code == 0
      print ldr_string
      print colon_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print mem_string
      print left_bracket_string
      print r_string
      reg = (this_instruction & reg2_mask) >> 6
      print reg
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset6_mask)
      print offset
      print right_bracket_string
      
      valid_instruction = 1
    end

    #LEA
    #example: LEA R3, #2
    if this_opcode - lea_code == 0
      print lea_string
      print colon_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print pc_string
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset9_mask)
      print offset
      
      valid_instruction = 1
    end

    #NOT
    #example: NOT R0, R0
    if this_opcode - not_code == 0
      print not_string
      print colon_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg
      print space_string
      print set_to_string
      print space_string
      print not_sign_string
      print r_string
      reg = (this_instruction & reg2_mask) >> 6
      print reg
      
      valid_instruction = 1
    end

    #ST
    #example: ST R1, #46
    if this_opcode - st_code == 0
      print st_string
      print colon_string
      print space_string
      print mem_string
      print left_bracket_string
      print pc_string
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset9_mask)
      print offset
      print right_bracket_string
      print space_string
      print set_to_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg

      valid_instruction = 1
    end

    #STI
    #example: STI R0, #128
    if this_opcode - sti_code == 0
      print sti_string
      print colon_string
      print space_string
      print mem_string
      print left_bracket_string
      print mem_string
      print left_bracket_string
      print pc_string
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset9_mask)
      print offset
      print right_bracket_string
      print right_bracket_string
      print space_string
      print set_to_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg

      valid_instruction = 1
    end

    #STR
    #example STR R0, R1, #3
    if this_opcode - str_code == 0
      print str_string
      print colon_string
      print space_string
      print mem_string
      print left_bracket_string
      print r_string
      reg = (this_instruction & reg2_mask) >> 6
      print reg
      print space_string
      print addition_sign_string
      print space_string
      offset = (this_instruction & offset6_mask)
      print offset
      print right_bracket_string
      print space_string
      print set_to_string
      print space_string
      print r_string
      reg = (this_instruction & reg1_mask) >> 9
      print reg

      valid_instruction = 1

    end

    #HALT
    #example HALT
    if this_instruction - halt_code == 0
      print halt_string

      valid_instruction = 1
    end

    #ERROR (for all not accepted instructions)
    #example ERROR
    if valid_instruction == 0
      print error_string
    end

    print "\n"

    instruction_ptr += 1
  end
end

test_memory = [
  0x100F,
  0x102F,
  0x500F,
  0x502F,
  0x027C,
  0x0463,
  0x06E0,
  0x090D,
  0x0AAC,
  0x0CFD,
  0x0E64,
  0x00B2,
  0xC180,
  0xC1C0,
  0x49C0,
  0x41C0,
  0x284F,
  0xA84D,
  0x684D,
  0xEA0D,
  0x9A3F,
  0x8000,
  0x86AF,
  0x3A34,
  0xBA34,
  0x7A34,
  0xF025,
  0xF024
]
#test_memory = (0x0..0xF).collect { |i| i << 12 }

disassemble test_memory + [0xFFFF]
