# Random Integer Analyzer

## Overview

Random Integer Analyzer is an assembly language program that generates 200 random integers between 15 and 50 (inclusive), sorts them, calculates and displays the median value, and counts the occurrence of each number in the range.

## Description

The program generates 200 random integers between 15 and 50, inclusive. It then performs the following operations:

1. Displays the original list of random numbers.
2. Sorts the list in ascending order.
3. Calculates and displays the median value of the sorted list.
4. Displays the sorted list.
5. Counts how many times each number in the range appears in the sorted array and displays this information.

## Usage

To run the program:

1. Assemble the assembly code using an x86 architecture emulator or assembler (e.g., MASM, NASM).
2. Execute the compiled program.

```bash
nasm -f elf Proj5_shielkel.asm
ld -m elf_i386 -s -o Proj5_shielkel Proj5_shielkel.o
./Proj5_shielkel
```

## Program Flow

1. Introduction: Displays program information, including the name, author, and functionality.
2. Random Number Generation: Generates 200 random integers between 15 and 50.
3. Display Unsorted List: Shows the list of generated random numbers before sorting.
4. Sorting: Sorts the list of random numbers in ascending order.
5. Display Sorted List: Shows the sorted list of random numbers.
6. Calculate and Display Median: Calculates the median value of the sorted list and displays it.
7. Count Occurrences: Counts the occurrence of each generated number within the specified range.
8. Display Counts: Shows the count of each generated number in the range.

