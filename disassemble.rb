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
	reg3_mask = 0x7 #the reigster found at bits 2 through 0

	#condition code masks
	br_n_mask = 0x800
	br_z_mask = 0x400
	br_p_mask = 0x200

	#imm5 vs source register flag mask
	#if 0, using 2 registers. if 1, using a register and a imm5
	operand2_flag_mask = 0x20

	#offset masks
	#offset masks are always the least significant x bits
	offset_9_mask = 0x1FF
	offset_11_mask = 0x7FF
	offset_6_mask = 0x3f

	#imm5 mask
	imm5_mask = 0x1F

	#trap vector mask
	trap_vector_mask = 0xFF

	instruction_ptr = 0x0

	puts "addr\tinstruction"

	while instruction_ptr < memory.length #or 0xFFFF
		this_instruction = memory[instruction_ptr]
		
		opcode = (this_instruction & opcode_mask) >> 12

		puts "0x#{instruction_ptr.to_s(16).rjust(4,"0")}\t#{opcode}"

		instruction_ptr += 1
	end
end

test_memory = (0x0..0xF).collect { |i| i << 12 }

disassemble test_memory
