TITLE Project5     (Proj5_zamoraab.asm)

; Author: Abraham Zamora
; Last Modified: 3/4/2026
; OSU email address: zamoraab@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:                 Due Date: 3/5/2023
; Description: Program generates values into an array, then sorts the array,
;	provide the median, and counts the instances of each number in the array.

INCLUDE Irvine32.inc


; Program constants

	ARRAYSIZE = 200		; set ARRAYSIZE. Initially set to 200 but can be adjusted.
	LO = 15				; set LO for lowest value
	HI = 50				; Set HI for highest value


.data
	; string variables
	progName	BYTE	"Generating, Sorting, and Counting Random Integers! Programmed by Abraham Zamora",13,10,0
	progDesc	BYTE	"This program generates 200 random integers between 15 and 50, inclusive.",13,10,
						"It then displays the original list, sorts the list, displays the median value",13,10,
						"of the list, displays the list sorted in ascending order, and finally displays",13,10,
						"the number offset instances offset each generated value, starting with the",13,10,
						"lowest number.",0

	unsortNo	BYTE	"Your unsorted random numbers:",0
	median		BYTE	"The median value offset the array: ",0
	sortNum		BYTE	"Your sorted random numbers:",0
	instance	BYTE	"Your list offset instances of each generated number, starting with the smallest value:",0
	outro		BYTE	"Goodbye, and thanks for using my program!",0
	spacing		BYTE	"   ",0


	; dword variables
	randArray	DWORD	ARRAYSIZE DUP(?)	; array that will store randomnly generated values, with a size based on ARRAYSIZE
	counts		DWORD	HI-LO + 1 DUP(0)	; array that will store the count of each number
	array		DWORD	LENGTHOF randArray	; length of the randArray
	countsLen	DWORD	LENGTHOF counts		; length of the counts array
	


	

.code

main PROC

	; call Randomize to be able to generate random numbers
	call Randomize		

	; call introduction to the program
	PUSH OFFSET progName
	PUSH OFFSET	progDesc
	call introduction

	; call the fillArray procedure that will generate numbers and fill an array
	PUSH OFFSET	randArray
	call fillArray

	; call displayList to print the numbers in the array
	PUSH array
	PUSH OFFSET randArray
	PUSH OFFSET	spacing
	PUSH OFFSET unsortNo
	CALL displayList

	; call sortList and sort the array in ascending order 
	PUSH OFFSET randArray
	call sortList

	; call displayMedian to show the median number in the array
	PUSH OFFSET randArray
	PUSH OFFSET median
	call displayMedian

	; call sortList again in order to show the new sorted array
	PUSH array
	push OFFSET randArray
	push OFFSET spacing
	push OFFSET sortNum
	call displayList 

	;call countList to count the instance of each number
	PUSH OFFSET counts
	push OFFSET randArray
	call countList

	; call displayList one more time to show the instance of each number
	push countsLen
	push OFFSET counts
	push OFFSET spacing
	push OFFSET instance
	call displayList

	; call the outroMessage to show departing message and close program
	push OFFSET	outro
	CALL outroMessage

	Invoke ExitProcess,0	; exit to operating system

main ENDP

;-----------------------------------------------------
; Name: introduction
;
; Introduction procedures for program, with title, author, and
;	the description of what the program will do.
;
; Preconditions: None
;
; Postconditions: None
;
; Receives: progName and progDesc by reference
;
; Returns: Nothing
;
;-----------------------------------------------------
introduction PROC
	; push registers into stack
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	MOV		EDX, [EBP+12]


	; display progName and progDesc
	CALL	WriteString
	CALL	CrLF
	MOV		EDX, [EBP+8]
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

	; pop edx and ebp registers off the stack
	POP		EDX
	POP		EBP
	RET		8

introduction ENDP

;-----------------------------------------------
; Name: fillArray
;
; Random numbers are generated within HI and LO (inclusive)
;	and fill randArray with size ARRAYSIZE
;
; Preconditions: empty array with DWORD elements
;
; Postconditions: none
;
; Receives: randArray that is empty by reference
;
; Returns: filled randArray with generated values by reference
;
;------------------------------------------------

fillArray PROC
	; push registers to stack
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	ECX
	PUSH	EDI
	MOV		ECX, ARRAYSIZE
	MOV		EDI, [EBP + 8]

; fill will subtract LO from HI, add 1, and then generate a random number
_fill:
	MOV		EAX, HI
	SUB		EAX, LO		; subtract LO from HI
	INC		EAX			; add 1
	CALL	RandomRange	; RandomRange will generate random numbers
	ADD		EAX, LO		; add LO to this random number to get a number between LO and HI
	MOV		[EDI], EAX
	ADD		EDI, 4
	loop	_fill

	; pop registers from stack and return
	POP		EDI
	POP		ECX
	POP		EAX
	POP		EBP
	RET		4

fillArray ENDP

;----------------------------------------------
; Name: sortList
;
; Sorts an array using bubble sort. Sorted in ascending order.
;	Returns a sorted array
;
; Preconditions: DWORD array
;
; Postconditions: None
;
; Receives: randArray (unsorted) by reference
;
; Returns: sorted randArray by reference
;
;----------------------------------------------

sortList PROC

	; push registers onto stack
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	ESI
	PUSH	ECX
	PUSH	EDX

_sort:
	mov		EDX,0				; if elements are swapped. intial set edx to zero
	MOV		ESI, [EBP + 8]
	mov		ECX, ARRAYSIZE
	DEC		ecx

; inner loop
_swap:
	MOV		EAX, [ESI]
	cmp		eax, [esi + 4]
	jle		_noSwap

	; push array to stack as reference parameters for exchangeElements
	PUSH	ESI
	CALL	exchangeElements	; call exchangeElements
	MOV		EDX, 1				; sets edx to 1 when exchange made

; if no exchange, decrease LOOP counter
_noSwap:
	add		ESI, 4
	LOOP	_swap

	; if there was a swap/exchange, return to start loop again
	cmp		edx, 1
	JE		_sort

	; pop registers from stack and return
	POP		EDX
	POP		ECX
	POP		esi
	pop		ebp
	ret		4

sortList ENDP

;-------------------------------------------
; Name: exchangeElements
;
; Swaps elements in the array.
;
; Preconditions: DWORD elements
;
; Postconditions: NONE
;
; Receives: randArray by reference
;
; Returns: randArray by reference, with values exchanged in two positions
;
;-------------------------------------------
exchangeElements PROC
	; push register to stack
	PUSH	EBP

	; swap elements at two positions
	MOV		ebp, esp
	mov		esi, [ebp+8]
	mov		eax, [esi]
	mov		ebx, [esi+4]
	mov		[esi+4], eax
	mov		[esi], ebx

	; pop register and return
	pop		ebp
	ret		4

exchangeElements ENDP

;--------------------------------------------
; Name: displayMedian
;
; Display median element of the array. As ARRAYSIZE can change,
;	if an ARRAYSIZE is odd, it will find the middle value. If
;	ARRAYSIZE is even, calculate the average and round up. Prints
;	median to terminal
;
; Preconditions: DWORD elements
;
; Postconditions: NONE
;
; Receives: randArray and median  by reference
;
; Returns: Nothing.
;
;--------------------------------------------

displayMedian PROC
	; push registers to stack
	push	ebp
	mov		ebp, esp
	push	esi
	push	eax
	push	ebx
	push	edx
	mov		esi, [ebp+12]

	; check ARRAYSIZE to see if it even or odd
	MOV		eax, ARRAYSIZE
	mov		ebx, 2
	cdq
	div		ebx
	cmp		edx, 0
	je		_even

	; if ARRAYSIZE is odd, then the middle element is the median
	mov		edx, [ebp+8]
	mov		eax, [esi + ((ARRAYSIZE + 1)/2)]
	jmp		_median

;if ARRAYSIZE is even, then two middle elements are added, divided by two, and rounded up if necessary	
_even:
	mov		eax, [esi + 4 * ARRAYSIZE / 2]			; stores middle element
	mov		ebx, [esi + (4 * ARRAYSIZE / 2) + 4]	; stores middle element + 1
	add		eax, ebx
	mov		ebx, 2
	cdq
	div		ebx
	cmp		edx, 1
	jne		_noRounding
	inc		eax

; if result of division is a remainder of 1 in EDX, then round up for median
_noRounding:
	mov		edx, [ebp + 8]

; once median is found, print to terminal
_median:
	call	WriteString
	call	WriteDec
	CALL	CrLf
	call	CrLf
	
	; pop registers from stack and return
	POP		edx
	pop		ebx
	pop		eax
	pop		esi
	pop		ebp
	ret		8
	
	



displayMedian ENDP

;---------------------------------------------
; Name: displayList
;
; Display array with 20 elements per line to terminal
;
; Preconditions: DWORD elements
;
; Postconditions: NONE
;
; Receives: two strings by reference, an array by reference and size
;	of the array by value
;
; Returns: Nothing
;
;---------------------------------------------

displayList PROC
	; push registers onto stack
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	push	ebx
	push	ecx
	push	edx
	push	esi

	MOV		EBX, 0
	MOV		ESI, [EBP + 16]
	MOV		EDX, [EBP + 8]
	MOV		ecx, [ebp + 20]

	CALL	WriteString
	CALL	CrLf
	call	CrLf
	mov		edx, [EBP + 12]

; loop through array and display each element
_display:
	mov		eax, [esi]
	call	WriteDec
	CALL	WriteString
	ADD		ESI, 4
	INC		EBX
	cmp		EBX, 20			; check to see if there are 20 numbers in row
	JL		_continue
	CALL	crlf
	mov		EBX, 0

; no new line, so it will continue to print out elements of array
_continue:
	LOOP	_display

	call	CrLf

	; pop registers off stack
	pop		ESI
	pop		EDX
	pop		ecx
	pop		EBX
	pop		eax
	pop		ebp
	ret		16

displayList ENDP

;-------------------------------------------
; Name: countList
;
; Counts the instance of each number in array, and the counts are placed in a
;	new array
;
; Preconditions: DWORD elements
;
; Postconditions: None
;
; Receives: randArray 
;
; Returns: counts array
;
;-------------------------------------------
countList PROC

	; push registers onto stack
	push	ebp
	mov		ebp, esp
	push	esi
	push	edi
	push	eax
	push	ebx
	push	ecx

	mov		esi, [ebp + 8]		; randArray	
	mov		edi, [ebp + 12]		; counts array
	mov		ebx, LO
	mov		ECX, ARRAYSIZE

; loop through randArray and count each element, increment for each instance found
_countInstance:
	mov		eax, [esi]
	add		esi, 4
	cmp		eax, ebx
	JNE		_noMatching
	inc		DWORD PTR [EDI]
	MOV		edx, [edi]
	jmp		_match

; if there is no match, move to next number, then go to _match to loop countInstance
_noMatching:
	add		edi, 4
	inc		DWORD PTR [EDI]
	inc		EBX

; if a match is found, loop countInstance
_match:
	LOOP	_countInstance

	; pop registers off stack and return
	pop		ecx
	pop		ebx
	pop		eax
	pop		edi
	pop		esi
	pop		ebp
	ret		8

countList ENDP

;-------------------------------------------
; Name: outroMessage
;
; Program outro written to terminal
;
; Preconditions: None	
;
; Postconditions None
;
; Receives: outro string variable
;
; Returns: nothing
;
;-------------------------------------------

outroMessage PROC
	; push registers to stack
	push	ebp
	mov		ebp, esp
	push	edx
	mov		edx, [ebp + 8]

	; print outro message to screen
	call	CrLf
	call	WriteString
	call	CrLf

	; pop registers and return
	pop		edx
	pop		ebp
	ret		4


outroMessage ENDP

END main
