	.data 		#initialize data memory with needed strings
strNewLine: .asciz "\n"
strMsg: .asciz "Enter a new key: "
strError: .asciz "You entered a negative key value! Exiting..."
strEnd: .asciz "All numbers, contained in list, bigger than key got printed!"

		.text	#executable code in program memory


main:								#FIRST PART OF MAIN FUNCTION
		jal ra, node_alloc			#allocate memory for dummy node
		sw x0, 0(a0)				#initialize dummy data = 0
		sw x0, 4(a0)				#initialize dummy next = NULL
		add s0, a0, x0				#s0:=memory address of dummy node (s0 == headPtr)
		add s1, a0, x0				#s1:=memory address of dummy node (s1 == ptrToLastNode)
loop1:								#integer_reading_loop
		jal ra, read_int			#call read_int to read a num
		add t1, a0, x0				#copy num to reg t1 otherwise we lose num because of node_alloc func call
		bge x0, t1, break			#if(t1<=0) <=> if(0>=t1)goto break
		jal ra, node_alloc			#allocate memory for a new node
		sw t1, 0(a0)				#newNode->data = num
		sw x0, 4(a0)				#newNode->next = NULL
		sw a0, 4(s1)				#prevNode->next = newNode
		add s1, a0, x0				#newNode is lastListNode -> s1(ptrToLastNode) now points to newNode
		j loop1						#repeat proccess of part 1
									#END OF FIRST PART OF MAIN
									
									#SECOND PART OF MAIN FUNCTION
break:
		addi    x17, x0, 4      	#ecall n4 for print string
        la      x10, strMsg  		#load string address to x10(ecall argument reg)
		ecall
		jal read_int				#call function to read the key value
		add s1, a0, x0				#save returned key value to s1 register
		bge s1, x0, skip			#if(key>=0)goto skip else exit
		addi    x17, x0, 4      	#environment call code for print_string
        la      x10, strError  		#pseudo-instruction: address of string
		ecall
		addi 	x17, x0, 10			#ecall n10 to Exit the program
		ecall
skip:
		add s2, s0, x0				#s2=s0 //now s2 is pointing to 1st node of the list
		lw t1, 4(s0)				#t1 = s0->next
		add s2, x0, t1 				#s2 = s0->next
loop2:								#link_traversal_loop
		lw a0, 0(s2)				#a0 = s2 (address of the next node each time)
		add a1, s1, x0				#a1 = key
		jal search_list				#call search_list fun with arguments: currentNodeAddress, key
compare_next:
		lw t2, 4(s2)				#t2 = currentNode->next (currentNodeAddress+4)
		add s2, x0, t2				#s2 now points to the next node (traversing the list)
							#using a saved register to not risk losing the currentNodeAddress of the list
		bne s2, x0, loop2			#if(s2!=NULL)goto loop2 // if(!endOfListReached)repeat for next node
									#else the end of the list was found!
		addi    x17, x0, 4      	#environment call code for print_string
        la      x10, strEnd  		#load string address
		ecall
		addi    x17, x0, 4      	#environment call code for print_string
        la      x10, strNewLine  	#load string address
		ecall
		j break						#repeat proccess of part 2
									#END OF SECOND PART OF MAIN

#|---------------------------|
#|#Additional functions used:|
#|---------------------------|
read_int:
		addi    x17, x0, 5     		#environment call code for read_int
        ecall                  		#read a line containing an integer
		add a0, x10, x0				#copy read int to return register
		jr ra, 0						#return
		
node_alloc:
		addi x17, x0, 9				#ecall n9 for set break (allocate memory block in heap)
		addi x10, x0, 8				#x12 contains ecall argument (allocate 8 bytes for a node)
		ecall						#push break 8 bytes
		jr ra, 0					#return
		
print_node:
		add t0, a0, x0				#t0 = currentNodeAddress
		bge a1, t0, compare_next	#if(key>=currentNodeAddress->data)goto compare_next //dont print
		add x10, x0, t0				#ecall argument = currentNodeAddress->data
		addi x17, x0, 1				#ecall n1 print integer
		ecall						
		addi    x17, x0, 4      	#environment call code for print_string
        la      x10, strNewLine  	#load string address to x10
		ecall
		jr ra, 0					#return
		
search_list:
		add t0, a0, x0				#t0 = currentNodeAddress
		addi sp, sp, -12			#increment stack by 12 bytes(4 for ra, 4 for node address, 4 for key)
		sw ra, 0(sp)				#store return address to the 1st 4 bytes(lowest mem addr): sp to sp+3
		sw a0, 4(sp)				#store currentNodeAddress to: sp+4 to sp+7 memory bytes
		sw a1, 8(sp)				#store keyValue to: sp+8 to sp+11 memory bytes
		jal print_node				#call func with same arguments:  currentNodeAddress, key
		lw ra, 0(sp)				#load stored(protected) return address to return register
		jr ra, 0					#return
