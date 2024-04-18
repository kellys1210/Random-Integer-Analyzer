# Random Integer Analyzer

## Overview

This assembly language program implements various procedures to manipulate strings. It contains procedures to calculate the length of a string, copy a string, concatenate two strings, and compare two strings. These procedures are implemented using low-level string manipulation techniques.

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

## Procedures

1. StrLength
Calculates the length of a null-terminated string.

2. StrCopy
Copies a source string to a destination string.

3. StrConcat
Concatenates two strings, appending the characters of the second string to the end of the first string.

4. StrCompare
Compares two strings lexicographically and returns an integer indicating their relative order.

## Requirements
Irvine32 Library: This program utilizes procedures from the Irvine32 library for various functionalities.
