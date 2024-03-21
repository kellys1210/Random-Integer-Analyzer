TITLE Project 5     (Proj5_shielkel.asm)

; Author: Kelly Shields
; Last Modified: 2/22/2024
; OSU email address:shielkel@oregonstate.edu
; Course number/section:   CS271 Section 402
; Project Number:  5    Due Date: 3/3/2024
; Description: Program which uses Randomize from Irvine Procedures to generate 200 random integers between 15 and 50, inclusive, and adds these numbers to an 
; array. The original array of random integers is displayed, then sorted into ascending order. Next, the median of the sorted list is calculated and displayed.
; The it will display the sorted list, and finally it will calculate how many appearances each number in the range makes in the sorted array, and adds these
; numbers to another array. Even if a number doesn't appear, it will be listed in the array as 0. Lastly, this array with the counted values will be 
; displayed.
;


INCLUDE Irvine32.inc

	ARRAYSIZE   =  200
	LO          =  15
	HI          =  50
	COUNTLENGTH =  (HI - LO + 1)   ; Loop counter for count display

.data

	; Program intro/exit:
	programName       BYTE   "       The Marauder's Map of Magical Integers", 0
	programAuthor     BYTE   " ::::: By Kelly Shields", 13, 10, 13, 10, 0
	programIntro	  BYTE   "This program will magically generate 200 integers between 15 and 50, inclusive. Next, it will display "
					  BYTE   "the original list, sort that list (in ascending order, not house), and displays the median value.", 13, 10, 0
	programIntro2	  BYTE	 13, 10, "Then it'll display the sorted list, and finally displays the number "
					  BYTE   "of instances of each generated value, starting with the smallest number in the list.", 13, 10, 13, 10, 0
	programOutro      BYTE   13, 10, "Mischief managed!", 13, 10, 0

	; Arrays: 
	randArray		  DWORD   ARRAYSIZE  DUP(?)
	counts            DWORD   ARRAYSIZE  DUP(?)
	randLength        DWORD   LENGTHOF   randArray
    typerandArray     DWORD   TYPE       randArray 

	; Display:
	unsortedDisplay   BYTE   "Your unsorted random numbers: ", 13, 10, 0
	medianDisplay     BYTE   "The median value of the array: ", 0
	sortedDisplay     BYTE   "Your sorted random numbers :", 13, 10, 0
	countDisplay      BYTE   "Your list of instances of each generated number, starting with the smallest value:", 13, 10, 0


	; Formatting:
	spacer            BYTE   " ", 0    ; Adds a space between each value in array

.code
main PROC

	;intro
	push  offset  programName
	push  offset  programAuthor
	push  offset  programIntro
	push  offset  programIntro2
	call  introduction
	
	;randomize
	call  randomize                     ; Initializes random starting seed value

	; fillArray
	push  offset randArray
	call  fillArray

	; displayList for UNSORTED array
	push  offset  randArray
	push  offset  unsortedDisplay
	mov   ecx, offset randLength
	mov   ecx, [ecx]
	push  ecx
	push  offset  spacer
	call  displayList

	;sortList
	push  offset  randArray
	call  sortList

	; displayList for SORTED array
	push  offset  randArray
	push  offset  sortedDisplay
	mov   ecx, offset randLength
	mov   ecx, [ecx]
	push  ecx
	push  offset  spacer
	call  displayList
 
	;displayMedian
	push  offset  randArray
	push  offset  medianDisplay
	mov   ecx, offset typerandArray
	mov   ecx, [ecx]
	push  ecx
	call  displayMedian
	
	;countList
	push  offset  randArray
	push  offset  counts
	push  offset  COUNTLENGTH
	call  countList
	
	;displayList for COUNTS array
	push  offset  counts
	push  offset  countDisplay
	mov   ecx, offset  COUNTLENGTH
	push  ecx
	push  offset  spacer	
	call  displayList

	; goodbye
	push  offset programOutro
	call  goodBye

	Invoke ExitProcess,0	       ; exit to operating system
main ENDP

; -- introduction --
; Procedure to introduce user to program; displays program name and author, and provides description of program functionality
; preconditions: Strings created for programName, programAuthor, programIntro, programIntro2
; postconditions: EDX changed
; receives: Memory offset of programName, programAuthor, programIntro, programIntro2
; returns: none

introduction PROC
push  ebp
mov   ebp, esp
mov   edx, [ebp + 20]			; programName
call  writestring				
mov   edx, [ebp + 16]			; programAuthor
call  writestring				
mov   edx, [ebp + 12]			; intro
call  writestring
mov   edx, [ebp +8]				; intro2
call  writestring
pop   ebp
ret   16

introduction ENDP

; -- fillArray --
; Procedure to fill initial array with random numbers, uses RandomRange from Irvine procedures to generate random integers between 15-50 inclusive; validates
; to ensure number generated fits in range, if so, adds to array and repeats until array size is met using a loop. Range limits and array size set as constants
; preconditions: Global constants set: HI and LO for range, and ARRAYSIZE for loop counter. RandVal initialzed to hold random numbers generated for 
; validation purposes.
; postconditions: randArray will hold all random values, EAX/EBX/ECX/EDI changed
; receives: HI, LO, ARRAYSIZE global constants, randVal memory offset
; returns: randArry with random integers added, randVal with randomly generated value

fillArray PROC

	push ebp
	mov  ebp, esp
	mov  edi, [ebp + 8]       ; Address of randArray
	mov  ecx, ARRAYSIZE		  ; Constant: 200, allows loop to run that many times to fill array

_randomLoop:
	mov   eax, HI             ; Constant: 50, set as upper limit for RandomRange proc , reset to EAX for each loop
	inc   eax                 ; Adjusts range to make inclusive
	call  RandomRange
	mov   ebx, eax
	cmp   ebx, HI             ; Begins validation to ensure generated integers are in range
	jg    _outofRange
	cmp   ebx, LO
	jl    _outofRange
	mov   [edi], ebx
	add   edi, 4              ; Increments edi address for next element to be filled
	loop  _randomLoop

	pop   ebp
	ret   4
	
_outofRange:				  
	jmp   _randomLoop

fillArray ENDP

; -- sortList --
; Procedure to sort elements of array in ascending order, uses gnome sort algorithm (IFGYG)
; preconditions: ARRAYSIZE constant matches size of input array in order to use that value to know when end of array is reached, randArray
; offset pushed before call
; postconditions: randArray sorted list as output, EAX/EBX/EDX/ESI changed
; receives: randArray offset, ARRAYSIZE constant
; returns: randArray sorted list

sortList PROC

	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 8]	    ; array
	mov  ebx, 0             ; pointer

_sortLoop:
	cmp  ebx, ARRAYSIZE
	je   _doneSort			; when pointer at end of array, list is sorted
	cmp  ebx, 0
	je   _incrementPointer  ; if pointer at start of array, moves forward to next element
	mov  eax, [esi]
	mov  edx, [esi -4]
	cmp  eax, edx			; compares current element to previous element
	jl   _swap
	jmp  _incrementPointer

_swap:
	push eax				; pushes randArray[current] onto stack
	push edx				; pushes randArray[previous] onto stack
	call exchangeElements
	jmp  _sortLoop

	; moves pointer and array offset to next element
_incrementPointer:
	inc  ebx
	add  esi, 4
	jmp  _sortLoop

_doneSort:
	pop  ebp
	ret  4
	
sortList ENDP

; -- exchangeElements --
; Procedure to swap elements which require sorting in randArray so that all numbers will eventually be in ascending order
; preconditions: "current" element at esi moved to eax, "previous" element at esi-4 loaded into edx
; postconditions: "current" and "previous" elements exchanged in randArray, esi decremented 4 to set "current" back in array
; to continue comparing, ebx decremented to match "current" element's position'
; receives: randArray[current] and randArray[previous], ebx from sortList 
; returns: index i/j values swapped and sent back to sortList for continued sorting
exchangeElements PROC
	push ebp
	mov  ebp, esp
	mov  eax, [ebp + 12]    ; randArray[current]
	mov  edx, [ebp + 8]     ; randArray[previous]

	; p
	mov [esi], edx
	mov [esi-4], eax
	
	; moves pointer and array memory to previous element (one just swapped), back to loop see if it needs swapped further
	sub   esi, 4
	dec   ebx
	pop   ebp
	ret   8

exchangeElements ENDP


; -- displayMedian --
; Procedure to calculate and display median value of randArray; checks if array is even or odd to determine how median is calculated - 
; if odd, middle number of array is median, if even, median is calculated as the average of the two middle numbers, this number is
; then rounded using round half up method
; preconditions: randArray and medianDisplay offsets pushed before procedure call, ARRAYSIZE constant set and matches size of randArray,
; array type variable created and offset moved to ecx prior to procedure, ARRAYSIZE moved to EAX for IDIV and sign extended, divisor moved
; to EBX, multiplier moved to EBX
; postconditions: EAX, EBX, ESI changed
; receives: randARRAY, typerandArray and medianDisplay offsets, ARRAYSIZE constant
; returns: none

displayMedian PROC
	call crlf
	push ebp
	mov  ebp, esp
	mov  edx, [ebp + 12]	; display string
	call writestring
	mov  esi, [ebp + 16]	; randArray sorted
	mov  eax, ARRAYSIZE
	cdq
	mov  ebx, 2
	idiv ebx
	cmp  edx, 0
	jz   _evenArray
	
	; for odd array: Divides array size by 2, quotient will point to middle element of array, to be used as index
	mov  eax, ARRAYSIZE
	cdq	
	mov  ebx, 2
	idiv ebx
	mul  ecx			  ; index * type to obtain address of middle index
	add  esi, eax
	mov  eax, [ESI]
	call writedec
	jmp  _medianComplete
	
	; For even array: Divides array size by 2, multiplies quotient by array type to find memory address of first middle
	; element, adds array type to make ebx next middle element; adds both, divides, and uses remainder to determine if rounding
	; needed
_evenArray:
	mov  eax, ARRAYSIZE
	cdq	
	mov  ebx, 2
	idiv ebx 
	mul  ecx      
	add  esi, eax
	mov  eax, [esi]
	mov  ebx, [esi + ecx]
	add  eax, ebx        ; adds 2 middle elements together
	mov  ebx, 2
	cdq
	idiv ebx
	cmp  edx, 0  
	jnz  _needsRounding  ; if remainder is 0, no rounding required
	call writedec  
	jmp  _medianComplete

	; Multiplies remainder by 10, then compares that to 50 to determine if integer needs to be rounded up or down
_needsRounding:
	push eax
	mov  eax, edx
	mov  ebx, 10
	imul ebx
	cmp  eax, 50
	jge  _roundUp
	pop  eax
	call writedec
	jmp _medianComplete
	
_roundUp:
	pop  eax
	inc  eax
	call writedec
	
_medianComplete:
	call crlf
	pop  ebp
	ret  12


displayMedian ENDP

; -- displayList --
; Procedure to display several versions of list: unsorted, sorted, and count version; will be called 3 separate times for each version. Displays each list
; 20 elements per row with one space between each element.
; preconditions: String created for display titles, separate string pushed before each call for each sort method, lengthof variables created for each array
; to be used as counters and passed by value
; postconditions: EAX/ECX/EDX/ESI/EDI changed
; receives: Offsets for randArray, sortedArray, counts, unsortedDisplay, sortedDisplay, countDisplay, randLength, sortedLength, countLength and 
; spacer
; returns: none

displayList PROC
	call crlf
	push ebp
	mov  ebp, esp
	mov  edx, [ebp + 16]   ; address for sort title, prints title
	call writestring
	mov  esi, [ebp + 20]   ; array
	mov  ebx, [ebp + 8]	   ; spacer
	mov  ecx, [ebp + 12]   ; counter
	mov  edi, 20           ; line counter

_displayLoop:
	cmp  edi, 0				
	je   _newLine
	mov  eax, [ESI]        ; moves element of array into eax
	call writedec
	mov  edx, ebx
	call writestring       ; prints spacer
	add  esi, 4            ; increments array memory by 4 to print next element
	dec  edi
	loop _displayLoop

	call crlf
	pop  ebp
	ret  16

_newLine:
	call crlf
	mov  edi,  20			; resets count back to 20
	jmp  _displayLoop
	

displayList ENDP

; -- countList --
; Procedure to calculate number of times each value in range from LO to HI appears in array; if number in range is not in array, it will be listed as 0
; preconditions: offsets pushed for randArray, counts, COUNTLENGTH; will use LO, HI constants
; postconditions: counts array filled with occurrences, ESI/EDI/EDX/EBX/ECX changed
; receives: offsets of randArray, counts; constants: LO, HI, COUNTLENGTH 
; returns: counts array filled with number of occurrences of each value in range

countList PROC
	push ebp
	mov  ebp, esp
	mov  esi, [ebp + 16]    ; randArray
	mov  edi, [ebp + 12]    ; counts
	mov  ecx, [ebp + 8]     ; countLength
	mov  edx, 0
	mov  ebx, LO


_countLoop:
	cmp  ebx, ecx
	
	cmp  [esi], ebx		  ; compares LO to value in array, if equal, counter and memory slot incremented
	je   _increaseCount

	; if not equal, current counter value moved to counts array and counts array imcremented to next memory
	; slot, counter reset, ebx incremented to begin comparing range to current value in memory
	mov  [edi], edx		  
	add  edi,   4
	mov  edx,   0
	inc  ebx
	loop _countLoop

	pop ebp
	ret 12

_increaseCount:
	inc edx	
	add esi, 4		; counter increased, moves to next memory slot in randArray
	jmp _countLoop

	pop ebp
	ret 12

countList ENDP

; -- goodbye --
; Procedure to thank user for playing, signals end of program 
; preconditions: String created for programOutro
; postconditions: EDX changed
; receives: Memory offset of programOutro
; returns: None

goodbye PROC
	call crlf
	push ebp
	mov  ebp, esp
	mov  edx, [ebp + 8]
	call writestring
	pop  ebp
	ret  4

goodbye ENDP

END main