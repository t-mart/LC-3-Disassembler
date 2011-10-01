#Ruby LC-3 Disassembler
#by Tim Martin

#everything is written in this method. because this code is serving simply as psuedo-code for the final version in assembly itself, im going to spare the ruby-isms and code more like you would in asm.
def disassemble memory	
	#we're going to be parsing 16-bit instructions. these masks will allow us to get meaningful data out of out of those 16 bits
	#to use: (instruction & mask) >> x, where x is the index of the least-significant bit of of the mask
	#e.g (0x00011011000001100 & opcode mask) >> 12 = 0001

	#opcode mask
	opcode_mask = 0xF000

	#destination/base and source register masks
	reg1_mask = 0xE00 #the register found at bits 11 through 9
	reg2_mask = 0x1C0 #the register found at bit 8 through 6
	reg3_mask = 0x7 #the register found at bits 2 through 0

	#condition code masks
	br_n_mask = 0x800 # >> 7
	br_z_mask = 0x400 # >> 6
	br_p_mask = 0x200 # >> 5

	#imm5 vs source register flag mask
	#if 0, using 2 registers. if 1, using a register and a imm5
	operand2_flag_mask = 0x20 # >> 5

	#jsr vs jsrr flag mask
	#if 0, jsrr. if 1, jsr
	jsr_flag_mask = 0x800 # >> 7

	#offset masks
	#offset masks are always the least significant x bits
	offset_9_mask = 0x1FF
	offset_11_mask = 0x7FF
	offset_6_mask = 0x3f

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
	trap_code = 0xF


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
	left_bracket_string = "["
	right_bracket_string = "]"
	addition_sign_string = "+"
	not_sign_string = "~"
	equal_sign_string = "="
	greater_than_sign_string = ">"
	less_than_sign_string = "<"
	cc_string = "cc"
	comma_string = ","
	halt_string = "HALT"
	
	#a more asm way of saying index counter
	instruction_ptr = 0x0

	#give us some table headers
	puts "addr\tinstruction"

	while memory[instruction_ptr] - 0xFFFF != 0
		this_instruction = memory[instruction_ptr]
		
		opcode = (this_instruction & opcode_mask) >> 12

		puts "0x#{instruction_ptr.to_s(16).rjust(4,"0")}\t#{opcode}"

		instruction_ptr += 1
	end
end

test_memory = (0x0..0xF).collect { |i| i << 12 }

disassemble test_memory + [0xFFFF]
