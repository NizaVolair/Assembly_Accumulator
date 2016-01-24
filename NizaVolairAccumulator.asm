TITLE Accumulator      (NizaVolairAccumulator.asm)

; Name: Niza Volair
; Email: nizavolair@gmail.com 
; Date: 11 - 01 - 2015
; Description: Program to add a series of numbesr and display sum and average

INCLUDE Irvine32.inc

; upper and lower limit for input constant
upperLimit = -1
lowerLimit = -100

.data

; variables for user name
buffer	BYTE	25 DUP(0)
user	DWORD ?

; variables for counter to display line numbers, keep track of amount of numbers input, and sum of numbers
line	DWORD	0
count 	DWORD	0
sum		DWORD	0
average DWORD	0

; introduction, greeting by name, instructions for input, result information, and outro for goodbye
Intro	BYTE	"Welcome to the Integer Accumulator Programmed by Niza Volair", 0dh, 0ah
		BYTE	"What is your name? ", 0

Greet	BYTE	"Hello, ", 0

Period	BYTE	".", 0

Inst1	BYTE	"Please enter numbers in[-100, -1].", 0dh, 0ah
		BYTE	"Enter a non-negative number when you are finished to see results.", 0
Inst2	BYTE	" Enter number: ", 0

Result1	BYTE	"Number of valid number you entered: ", 0
Result2 BYTE	"The sum of your valid numbers is: ", 0
Result3	BYTE	"The rounded average is: ", 0

LowErr	BYTE	"Lower Limit Error: number must be greater than -100.", 0
Special BYTE	"Special Message: No negative numbers were entered.", 0
Outro	BYTE	"Thank you for playing Integer Accumulator!", 0dh, 0ah
BYTE	"It's been a pleasure to meet you, ", 0
.code
main PROC

; Display the program title and programmer’s name.
mov		edx, OFFSET		Intro
call	WriteString

; Get the user’s name, and greet the user.
mov		edx, OFFSET		user
mov		ecx, SIZEOF		buffer
call	ReadString
call	Crlf

mov		edx, OFFSET		Greet
call	WriteString
mov		edx, OFFSET		user
call	WriteString
mov		edx, OFFSET		Period
call	WriteString
call	Crlf
call	Crlf


; Display instructions for the user.
mov		edx, OFFSET		Inst1
call	WriteString

; Repeatedly prompt the user to enter a number.Validate the user input to be in[-100, -1](inclusive).
; Count and accumulate the valid user numbers until a non - negative number is entered. (The nonnegative number is discarded.)
mov		line, 1							; initialize line and count
mov		count, 0
call	Crlf

jmp		NumberCount						; jump to skip too lower limit error message

LowerLimitError:						; error message for when numbers are too low
call	Crlf
mov		edx, OFFSET		lowErr
call	WriteString
call	Crlf

NumberCount :							; loop for entering numbers	

mov	eax, line							; prompt for integer
call	WriteDec
mov		edx, OFFSET		Inst2		
call	WriteString

call	ReadInt							; compare integer to upper and lower limits
cmp		eax, upperLimit					; if greater than upper limit jump to calculations
jg		CalculateAndDisplay
cmp		eax, lowerLimit					; if lower than lower limit go to error message and reprompt
jl		LowerLimitError
						
inc		line							; if in range, increase line and count trackers, add to sum, and loop to get another integer
inc		count
add		sum, eax
jmp		NumberCount

; Calculate the(rounded integer) average of the negative numbers is done in Display 

; Display: 

CalculateAndDisplay:

cmp		count, 0						; if no negative numbers were entered, display a special message and skip to iv.
je		SpecialMessage

call	Crlf
call	Crlf
mov		edx, OFFSET		Result1			; the number of negative numbers entered
call	WriteString
mov		eax, count
call	WriteDec
call	Crlf


mov		edx, OFFSET		Result2			; the sum of negative numbers entered
call	WriteString
mov		eax, sum
call	WriteInt
call	Crlf

; Calculate the(rounded integer) average of the negative numbers is done here
mov		edx, OFFSET		Result3			; the average, rounded to the nearest integer(e.g. - 20.5 rounds to - 20)
call	WriteString
mov		eax, sum
cdq
mov		ebx, count
idiv	ebx
mov		average, eax
call	WriteInt
call	Crlf

jmp		Farewell							; Jump to avoid Special Message if not needed

SpecialMessage:								; Special Message to tell user no negative numbers were entered

call Crlf
mov		edx, OFFSET		Special		
call	WriteString
call	Crlf

Farewell:								; Parting message(with the user’s name)

call	Crlf
call	Crlf
mov		edx, OFFSET		Outro
call	WriteString
mov		edx, OFFSET		user
call	WriteString
mov		edx, OFFSET		Period
call	WriteString
call	Crlf
call	Crlf

	exit	; exit to operating system
main ENDP


END main