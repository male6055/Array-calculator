.text
begin:
li $gp 0x10010000
li $s1 0
li $s0 0
li $s2 0
 li $v0 4
 la $a0 First			# Printing Integer or String array options
 syscall
 li $v0 5
 syscall
 beq $v0 1 integer		# If 1 is selected, integer array calculator will be executed
 b string			# Option other than 1 is printed, than String array will executed
 
 integer:
 	li $v0 4
	la $a0 Lenght		# Output Message for Lenght
	syscall
	li $v0 5		# Lenght Input
	syscall
 	move $s0 $v0		# moving value of Lenght to S0 which is not likely to be changed
	 # input array
 	addi $sp $sp -4		# Setting SP to first location
	sw $s0 0($sp)		# Saving location of s0 which has lenght
 	jal values		# calling values Function
 	lw $s0 0($sp)		# retrieving value of lenght for furhter us
 	
  	invalid:
  		li $v0 4
 		la $a0 options1			# Printing Integer or String array options
 		syscall
 		li $v0 5			# Options will be stored in V0
 		syscall
 	
 		beq $v0 1 printing		# Several Conditions
 		beq $v0 2 average
 		beq $v0 3 max
 		li $v0 4
 		la $a0 Invalid			# invalid statement will be printed
 		syscall
 	b invalid				# loop will continue till valid condition is acheived
 	printing:
 		li $gp 0x10010000
 		jal print			# calling print Procedure
 		lw $s0 0($sp)			# obtaing lenght again
  		addi $sp $sp 4		# reseting SP 
 	b exit
 	average:
 		li $v0 4		# message printing
 		la $a0 AVG
 		syscall
 		#Sum is obtained in Values Procedure, value is stored in S1	
		mtc1 $s1 $f1 		# moving s1 (sum) to $f1 Co processor
		cvt.s.w $f1, $f1	# Converting integer to decimal
		mtc1 $s0 $f3		# moving Lenght to f3
		cvt.s.w $f3, $f3	
		div.s $f12 $f1 $f3	# dividing CO processors f1 AND f2, ANSWER IN f12
 		li $v0 2		# SERVICE NO TO PRINT FLOAT
 		syscall
 	b exit				
 		max:				# IF USER ENTERED MAX
 			li $v0 4
 			la $a0 MAX		#  PRINTING MAX STATEMENT
 			syscall
  			li $v0 1		# SERVICE TO PRINT INTEGER (MAX)
 			add $a0 $0 $s2		# S2 CONTAINS MAX NO (OBTAINED IN VALUES PROCEDURE)
 			syscall
b exit

string:		
	li $t0 0
	li $s5 0
				# WHEN USER ENTER 2, STRING OPERATIONS WILL BE EXECUTED
	notValid:			# THIS LABEL WILL FORCE TO USER TO MAKE APPROPIRATE CHOICE
  		li $v0 4
 		la $a0 options2		# Printing String array options
 		syscall
 		li $v0 5		# OPTION WILL BE SAVED IN $V0
 		syscall
 	
 		beq $v0 1 Pallendrome		# MULTIPLE CHOICES WITH LABEL JUMPS
 		beq $v0 2 Comparision
 		beq $v0 3 Spacing
 		li $v0 4			# OPTION OTHER THAN (1-3) WILL INVALID
 		la $a0 Invalid
 		syscall
 	b notValid				# JUMPS TO NOTINVALID TO GET CHOICES AGAIN
	Pallendrome:	# CHECK FOR A PALLENDROME
		li $t0 0
		li $v0 4
		la $a0 stringIN		# "ENTER A STRING WILL BE PRINTED
		syscall
		li $v0 8		# SERVICE FOR READING STRING
		la $a0 StringInput	# ADDRESS TO SAVE INPUT STRING
		li $a1 30		# ALLOTTED CHARACTER SPACE TO STRING
		syscall
		loop:
			addi $s1 $s1 1		# COUNTER TO CALCULATE LENGHT(HOW MANY TIMES COMPARING)
			lb $a0 StringInput($t1)	# LOADING BYTE FROM 0 LOCATION OF  (STRINGINPUT FIRST LOCATION)
			beq $a0 10 line		# 10 = = ENTER KEY(\n) IN ASCII "end string"
			li $v0 11	#sSERVICE FOR PRINTING CHARACTER
			addi $t1 $t1 1	# MOVING TO NEXT CHARACTER
			syscall
		b loop
		line:
			addi $t1 $t1 -1 # MOVING TO LAST CHARACTER ENTERED
			add $s5 $s5 $t1	# COPY OF ADDRESS OF LAST CHARACTER
			li $t1 0	# INITIALIZING T0 TO ZERO TO ACCESS FIRST CHARACTER
			div $s1 $s1 2	# COUNTER FOR INPUT STRING WILL BE DIVIDED BY 2
			mflo $s1	# LOOP / COMPARISION WILL BE DONE QUOTIENT TIMES
		start:
			beq $s1 $zero yes		# WHEN QUOTIENT BECOMES ZERO, GO TO YES
			lb $t3 StringInput($s5)		# LOADING LAST BYTE IN t1
			lb $t2 StringInput($t1)		# LOADING FIRST BYTE IN t2
			addi $s1 $s1 -1			# QUOTIENT WILL DECREASE BY 1
			beq $t3 $t2 start		# IF FIRST AND LAST BYTE ARE EQUAL, GO TO START
			li $v0 4			# IF 1st AND LAST BYTE ARE NOT EQUAL
			la $a0 nope			# MOVE TO NOPE
			syscall
		b exit
		yes:
			li $v0 4		# SERIVICE TO PRINT STRING
			la $a0 yo		# STATEMENT FOR YES WILL BE PRINTED
			syscall
b exit

	Comparision:				# COMPARING STRING
		li $v0 4
		la $a0 stringIN			# PRINTI: ENTER A STRING
		syscall
		li $v0 8			#SERVICE FOR INPUT STRING
		la $a0 str1			#LOADING ADDRESS OF STR1:.SPACE
		la $a1 30			# a1 HAS CHARACTER SPACES
		syscall
		li $v0 4			#SERVICE FOR PRINT A STRING
		la $a0 stringIN			
		syscall
		li $v0 8			#SERVICE FOR INPUT SECOND STRING
		la $a0 str2			#LOADING ADDRESS OF STR2: .SPACE
		la $a1 30			#a1 HAS 30 SPACES
		syscall
		for:
			lb $t6 str1($t0)	# LOADING FIRST CHAR OF STRING 1 IN T6
			lb $t7 str2($t0)	# LOADING FIRST CHAR OF STRING 2 IN T7
			bne $t6 $t7 NotEqual	# IF T6 AND T7 ARE NOT EQUAL MOVE TO NotEqual
			addi $t0 $t0 1		# T1 IS ADDRESS/COUNTER , INCREASING IT
			beq $t0 30 EQUAL	# GO TO EQUAL IF T1 BECOMES 30(which is char spaces)
		b for
	EQUAL:
		li $v0 4			# SERVICE FOR PRINTING EQUAL STRING
		la $a0 equal
		syscall
		b exit
	NotEqual:
		li $v0 4 			# SERVICE FOR PRINTING NOTEQUAL STRING
		la $a0 notequal
		syscall

b exit
	Spacing:
		li $v0 4
		la $a0 stringIN
		syscall
		li $v0 8			# INPUT STRING FOR SPACING
		la $a0 StringInput		# LOADING ADDRESS OF STRINGINPUT
		li $a1 30			# SPACE OF 30 CHARACTER
		syscall
		li $v0 4			# SERVICE FOR PRINTING STRING
		la $a0 newline 			# NEW LINE
		syscall
		jump:
			beq $a1 $zero exit	# a1 = character space, when runs out, jump to exit
			li $v0 11		# SERVICE FOR CHARACTER PRINTING
			lb $a0 StringInput($t0)# a0 HAS FIRST CHARACTER OF INPUT STRING
			beq $a0 32 inline	#{ "SPACE" = 32 BITS }, WHEN APPEARS, PRINT LINE
			syscall
			cont:
			addi $t0 $t0 1 		# MOVING TO NEXT CHARACTER
			addi $a1 $a1 -1		# CHARACTER SPACE WILL DECREASE BY 1 (COUNTER)
		b jump
	inline:			# CHANGING LINE
		li $v0 4	# SERVICE FOR PRINTING STRING
		la $a0 newline
		syscall
	b cont
b exit

			
# PROCEDURES		
values:					# procedure to input values
	li $v0 4		# SERVICE FOR PRINTING STRING
	la $a0 Values
	syscall
	li $v0 5		# SERVICE FOR INPUT INTEGER (INPUT IN V0)
	syscall
	sw $v0 0($gp)		# storing VALUES OF v0 to respective places of GP
	# TRICK TO OBTAIN MAX NO FROM ARRAY
	bgt $s2 $v0 great 	# IF S2, WHICH IS ZERO INITIALLY, IS GREATER THAN V0, MOVE TO GREAT
	add $s2 $zero $v0	# IF NOT GREATER, UPDATE s2 TO THE VALUE OF v0
	great:
	# TRICK TO OBTAIN SUM OF ARRAY
	add $s1 $s1 $v0		# s1 will be used for total sum
	addi $s0 $s0 -1		# S0 IS LENGHT OF ARRAY, DECREASED BY 1 TO END LOOP AT LAST
	add  $gp $gp 4		# UPDATING GP TO NEXT WORD
  	bne $s0 $zero values	# IF S0 IS ZERO, RETURN BACK
  	jr $ra
#Print array
  print:	# PRINT PROCEDURE
  	lw $a0 0($gp)		# storing VALUE OF a0 to respective places of GP
	li $v0,1		# SERVICE FOR PRINTING INTEGER
	syscall
	
	li $v0 4		# SERVICE FOR PRINTING STRING
	la $a0 newline		# adding New Line
	syscall
	addi $s0 $s0 -1		# S0 IS LENGHT, USED AS LOOP COUNTER
	addi $gp $gp 4		# MOVING TO NEXT WORD
  	bne $s0 0 print		# IF LENGHT IS NOT ZERO, GO TO PRINT 
  	jr $ra

exit:
li $v0 4
la $a0 choice
syscall
li $v0 5
syscall
beq $v0 1 begin
exe:
li $v0 4
la $a0 end
syscall
 li $v0, 10			# TERMINATING STATEMENT
    syscall
	
  
.data
checker: .asciiz "Your program is at String"
First: .asciiz "\n1. Integer array Calculation\n2. String Array calculation\n Your Option="
Lenght: .asciiz "\nEnter Length of Array="
Values: .asciiz "\tEnter values of Array="
newline: .asciiz "\n"
Invalid: .asciiz "\n Ivalid Input Choose Options Again\n"
options1 : .asciiz "1)Print Array\n2)Calculate Average\n3)Calculate Maximum Value\nSelect What task You want to perform :"
AVG: .asciiz "avg="
MAX:.asciiz "max="
options2: .asciiz "1) Check A Pallendrome\n2) Compare 2 Strings\n3) Sentence Spacing\n\nYour Option:"
yo : .asciiz " is Pallendrome"
StringInput:.space 30
nope:.asciiz " is not a pallendrome"
stringIN: .asciiz "\nEnter a String:"
str1:.space 30
str2:.space 30
equal:.asciiz "Strings are Equal"
notequal :.asciiz "Strings are NOT Equal"
choice:.asciiz"\n\n1)Start again\n2)End\n your choice:"
end:.asciiz "\n\t Thanks for using my program :)"
