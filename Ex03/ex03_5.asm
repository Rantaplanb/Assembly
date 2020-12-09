#i)
		.data		#HEXA	#BINARY
str_a: .asciz "a"	#61		#01100001
str_b: .asciz "b"	#62		#01100010
str_c: .asciz "c"	#63		#01100011
str_d: .asciz "d"	#64		#01100100
str_e: .asciz "e"	#...
str_f: .asciz "f"	#...
str_g: .asciz "g"	#Paratirw oti i ascii kwdikopoiisi twn xaraktirwn,
str_h: .asciz "h"	#antistoixei se auksitiki aparithmisi,
str_i: .asciz "i"	#me tin seira tou alfavitou, kai me tin seira twn psifiwn omoiws
str_j: .asciz "j"	#diladi: a...z -> 61...7a
str_k: .asciz "k"	# A...Z -> 41...5a
str_l: .asciz "l"	# 0...9 -> 30...39
str_m: .asciz "m"	#Episis, paratirw oti i kwdikopoiisi twn kefaiwn, proigitai twn pezwn.
str_n: .asciz "n"	#kai oti ta 4 least significant bits tis kwdikopoiisis
str_o: .asciz "o"	#twn arithmitikwn xaraktirwn, antistoixoun ston ekastote arithmo
str_p: .asciz "p"	#an ta metatrepsoume se decimal morfi!
str_q: .asciz "q"
str_r: .asciz "r"
str_s: .asciz "s"
str_t: .asciz "t"
str_u: .asciz "u"
str_v: .asciz "v"
str_w: .asciz "w"
str_x: .asciz "x"	#78		#01111000
str_y: .asciz "y"	#79		#01111001
str_z: .asciz "z"	#7a		#01111010

str_A: .asciz "A"	#41		#01000001
str_B: .asciz "B"	#42		#01000010
str_C: .asciz "C"	#43		#01000011
#...
str_Y: .asciz "Y"	#59		#01011001
str_Z: .asciz "Z"	#5a		#01011010

str_0: .asciz "0"	#30		#00110000
str_1: .asciz "1"	#31		#00110001
str_2: .asciz "2"	#32		#00110010		
str_3: .asciz "3"	#33		#00110011
str_4: .asciz "4"	#34		#00110100
str_5: .asciz "5"	#35		#00110101
str_6: .asciz "6"	#36		#00110110
str_7: .asciz "7"	#37		#00110111
str_8: .asciz "8"	#38		#00111000
str_9: .asciz "9"	#39		#00111001

#------------------------------------------#
#ii)
str_xyz: .asciz "xyz"
#	Little endian
#ASCII:			\0			z			y			x
#Binary: 	00000000    01111010   01111001    01111000
#HEXA:			00			7a			79			78
#DecimalSum: 8 + 7*16 + 9*16*16 + 7*16*16*16 + 10*16*16*16*16 + 7*16*16*16*16*16 = 8026488

#	Big endian
#ASCII: 		x 			y			z			\0
#Binary:	01111000	01111001	01111010	00000000
#HEXA 			78			79			7a			00
#DecimalSum: 10*16*16 + 7*16*16*16 + 9*16^4 + 7*16^5 + 8*16^6 + 7*16^7 = 2021227008

#----------------------------------------------------------------------------------#
#iii)
	.text
main:
	la x20, str_xyz #lead string address to x20 register
	lw x21, (x20) #load address contents to x21 register

	addi    x17, x0, 1      # environment call code for print_int
    add     x10, x21, x0    # copy x21 value to x10, to get it printed
    ecall 
	#Result -> little endian