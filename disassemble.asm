;======DO NOT EDIT THIS SECTION=================================================
.orig x3000
	LD R6, POINTER
	BR DISASSEMBLE

POINTER .fill xFE00
;===============================================================================

DISASSEMBLE:
	;Your assembly code goes here
	; Remember do not use R6 or R7 anywhere in your code!
	
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
	ADD R0, R0, R0
	BRNZP 0
	HALT
	.fill xD000
	.fill xFFFF
.end

