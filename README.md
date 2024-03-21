The Marauder's Map of Magical Integers

##Overview

This repository contains an assembly language program (Proj5_shielkel.asm) authored by Kelly Shields. It's a project completed for Computer Architecture and Assembly
(CS271) at Oregon State University.

##Description

The program generates 200 random integers between 15 and 50, inclusive. It then performs the following operations:

1. Displays the original list of random numbers.
2. Sorts the list in ascending order.
3. Calculates and displays the median value of the sorted list.
4. Displays the sorted list.
5. Counts how many times each number in the range appears in the sorted array and displays this information.
   
##Setup and Usage

To run the program:

1. Ensure you have an x86 architecture emulator or assembler installed (e.g., MASM, NASM).
2. Compile the assembly code (Proj5_shielkel.asm).
3. Execute the compiled program.

   
##Usage Example

```bash
Copy code
$ nasm -f elf Proj5_shielkel.asm
$ ld -m elf_i386 -s -o Proj5_shielkel Proj5_shielkel.o
$ ./Proj5_shielkel
```

##Requirements

Irvine32 Library: This program utilizes procedures from the Irvine32 library for various functionalities.

##License

This project is licensed under the MIT License.
