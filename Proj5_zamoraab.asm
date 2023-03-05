TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
	ARRAYSIZE = 200
	LO = 20
	HI = 30


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
	PUSH OFFSET unsortNo
	CALL displayList

	call sortList
	;call exchangeElements
	;call displayMedian
	;call displayList 
	;call countList

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

sortList ENDP

exchangeElements PROC
exchangeElements ENDP

displayMedian PROC
displayMedian ENDP

displayList PROC
	PUSH	EBP
	MOV		EBP,ESP
	PUSH	EAX
	push	ecx
	push	edx
	push	esi
	MOV		EBX, 0
	MOV		ESI, [EBP+16]

displayList ENDP

countList PROC
countList ENDP


END main
