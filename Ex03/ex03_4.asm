		.data	#initialize data memory with needed strings:
str_inputMsg: .asciz "Enter 8 seperate integers: "
str_resultMsg: .asciz "\nResult: "
str_newLine: .asciz "\n"
a: .space 32	#32bytes/4bytes = 8*sizeof(int)


		.text	#executable code in program memory: 
main:
		la		x20, a		# x20 = address of a
		
		#print "Enter 8 seperate integers: "
		addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_inputMsg      # pseudo-instruction: address of string
		ecall
		
		addi x21, x0, 8			# initialize iterator i = 8
		
inputLoop:
        addi    x17, x0, 5      # environment call code for read_int
        ecall                   # read a line containing an integer
		sw		x10, (x20)		# store input int from x10 to the address contained in x20
		addi	x20, x20, 4		# next int will be stored in (previous address)+4
		addi 	x21, x21, -1	# i=i-1
		bne 	x21, x0, inputLoop	#iterate until i==0
		
		
		#print "\nResult: "
		addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_resultMsg      # pseudo-instruction: address of string
		ecall
		
		addi	x20, x20, -4	#address of LAST stored integer(compensate for addi x20,x20,4)
		addi 	x21, x0, 8		#reinitialize iterator i = 8
		
		
outputLoop:
		lw 		x18, (x20)		#x18 = a[i]
		add		x19, x18, x18 		#x19 = 2*a[i]
		add 	x18, x19, x18 		#x18 = 3*a[i]
		add 	x18, x18, x18		#x18 = 6*a[i]
		
		addi    x17, x0, 1      # environment call code for print_int
        add     x10, x18, x0    # copy x18 value to x10, to get it printed
        ecall   
		
		
		#print "\n"
		addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_newLine      # pseudo-instruction: address of string
		ecall
		
		addi 	x20, x20, -4	#address of next integer
		addi 	x21, x21, -1	# i = i-1
		bne 	x21, x0, outputLoop  #iterate until i == 0
		
		j		main 	#repeat the whole proccess
		

		