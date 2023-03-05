TITLE Project 5 - Arrays, Addressing, and Stack-Passed Parameters     (Proj5_zamoraab.asm)

; Author: Abraham Zamora
; Last Modified: 3/4/2026
; OSU email address: zamoraab@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:                 Due Date: 3/5/2023
; Description:

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
	ARRAYSIZE = 200
	LO = 15
	HI = 50


.data
	progName	BYTE	"Generating, Sorting, and Counting Random Integers! Programmed by Abraham Zamora",13,10,0
	progDesc	BYTE	"This program generates 200 random integers between 15 and 50, inclusive.",13,10,
						"It then displays the original list, sorts the list, displays the median value",13,10,
						"of the list, displays the list sorted in ascending order, and finally displays",13,10,
						"the number offset instances offset each generated value, starting with the",13,10,
						"lowest number.",0

	unsortNo	BYTE	"Your unsorted random numbers:",0
	median		BYTE	"The median value offset the array: ",0
	sortNum		BYTE	"Your sorted random numbers:",0
	instance	BYTE	"Your list offset instances of each generated number, starting with the smalles value:",0
	outro		BYTE	"Goodbye, and thanks for using my program!",0

	randArray	DWORD	ARRAYSIZE DUP(?)
	counts		DWORD	HI-LO+1 DUP(0)
	array		DWORD	LENGTHOF randArray
	tabInd		BYTE	"   ",0


	

.code
main PROC

	call Randomize

	PUSH OFFSET progName
	PUSH OFFSET	progDesc
	call introduction

	PUSH OFFSET	randArray
	call fillArray


	PUSH array
	PUSH OFFSET randArray
	PUSH OFFSET	tabInd
	PUSH OFFSET unsortNo
	CALL displayList
	call CrLf

	
	;PUSH OFFSET randArray
	;call sortList

	;PUSH OFFSET randArray
	;PUSH OFFSET median
	;call displayMedian

	;call displayList 
	;call countList
	push OFFSET	outro
	CALL outroMessage

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)
introduction PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
	MOV		EDX, [EBP+12]
	CALL	WriteString
	CALL	CrLF
	MOV		EDX, [EBP+8]
	CALL	WriteString
	CALL	CrLf
	POP		EDX
	POP		EBP
	RET		8

introduction ENDP

fillArray PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	ECX
	PUSH	EDI
	MOV		ECX, ARRAYSIZE
	MOV		EDI, [EBP+8]
_fill:
	MOV		EAX, HI
	SUB		EAX, LO
	INC		EAX
	CALL	RandomRange
	ADD		EAX, LO
	MOV		[EDI], EAX
	ADD		EDI, 4
	loop	_fill

	POP		EDI
	POP		ECX
	POP		EAX
	POP		EBP
	RET		4

fillArray ENDP

sortList PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	ESI
	PUSH	ECX
	PUSH	EDX

_sort:
	mov		EDX,0
	MOV		ESI,[EBP+8]
	mov		ECX, ARRAYSIZE
	DEC		ecx
_swap:
	MOV		EAX, [ESI]
	cmp		eax, [esi+4]
	jle		_noSwap
	PUSH	ESI
	CALL	exchangeElements
	MOV		EDX, 1

_noSwap:
	add		ESI, 4
	LOOP	_swap

	cmp		edx, 1
	JE		_sort

	POP		EDX
	POP		ECX
	POP		esi
	pop		ebp
	ret		4

sortList ENDP

exchangeElements PROC

	PUSH	EBP
	MOV		ebp, esp
	mov		esi, [ebp+8]
	mov		eax, [esi]
	mov		ebx, [esi+4]
	mov		[esi+4], eax
	mov		[esi], ebx
	pop		ebp
	ret		4
exchangeElements ENDP

displayMedian PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	eax
	push	ebx
	push	edx
	mov		esi, [ebp+12]



displayMedian ENDP

displayList PROC
	PUSH	EBP
	MOV		EBP,ESP
	PUSH	EAX
	push	ebx
	push	ecx
	push	edx
	push	esi
	MOV		EBX, 0
	MOV		ESI, [EBP+16]
	MOV		EDX, [EBP+8]
	MOV		ecx, [ebp+20]
	CALL	WriteString
	CALL	CrLf
	mov		edx, [EBP+12]

_display:
	mov		eax,[esi]
	call	WriteDec
	CALL	WriteString
	ADD		ESI, 4
	INC		EBX
	cmp		EBX, 20
	JL		_continue
	CALL	crlf
	mov		EBX, 0
_continue:
	LOOP	_display

	pop		ESI
	pop		EDX
	pop		ecx
	pop		EBX
	pop		eax
	pop		ebp
	ret		16

displayList ENDP

countList PROC
countList ENDP

outroMessage PROC
	push	ebp
	mov		ebp, esp
	push	edx
	mov		edx, [ebp+8]
	call	WriteString
	pop		edx
	pop		ebp
	ret		4


outroMessage ENDP

END main
