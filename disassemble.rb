def disassemble memory	
	#opcode mask
	opcode_mask = 0xF000

	#destination/base and source register masks
	11to9_mask = 0xE00
	8to6_mask = 0x1C0
	2to0_mask = 0x7

	#condition code masks
	br_n_mask = 0x800
	br_z_mask = 0x400
	br_p_mask = 0x200

	#imm5 vs source register flag mask
	#if 0, using 2 registers. if 1, using a register and a imm5
	operand2_flag_mask = 0x20

	#PC offset masks
	pc_offset_9_mask = 0x1FF
	pc_offset_11_mask = 0x7FF

	#imm5 mask
	imm5_mask = 0x1F

	#ldr/str offset mask
	offset6_mask = 0x3F

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
