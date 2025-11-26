; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls.
; Runs on 64-bit Linux only.
;
; Complements of https://cs.lmu.edu/~ray/notes/nasmtutorial/
;
; To assemble and run:
;
;  Pure assembly executable
;   * ❯ nasm -f elf64 hewo.asm -o xhewo.o -dIS_EXECUTABLE
;   * ❯ ld xhewo.o -o hewo -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
;   * ❯ ./hewo
;   * Hello, World
;
; C/C++ with linked assembly executable
;   * ❯ nasm -f elf64 hewo.asm -o hewo.o
;   * ❯ g++ -fPIC sample.cpp -z noexecstack hewo.o -o sample
;   * ❯ ./sample
;   * Hello, World
;
; # Using elf64 instead of elf because the target architecture is 64bits
; # dIS_EXECUTABLE defines the preprocessor directive below to set main name to _start
; # lc links to c static library
; # dynamic-linker takes path to dynamic linker shared library to use C library
; ----------------------------------------------------------------------------------------
%ifdef IS_EXECUTABLE
%define hewo _start   ; An exception to all-caps preprocessor macros so we can see what to extern
%else
%define hewo hewo
%endif

global    hewo
hewo:     mov     rax, 1              ; system call for write
          mov     rdi, 1              ; file handle 1 is stdout
          lea     rsi, [rel message]  ; rip address of message -- satisfy c compiler
          mov     rdx, 13             ; number of bytes
          syscall                     ; invoke operating system to do the write
%ifdef IS_EXECUTABLE
          ; If global is "_start", ensure system exits securely -- Raw approach commented out
          ; mov       rax, 60         ; system call for exit
          ; xor       rdi, rdi        ; exit code 0
          ; syscall                   ; invoke operating system to exit
          ; C approach used below -----------------------------------------------------------
          mov     edi,  0             ; Argument passed to exit() -- ie return 0 on success
          call    exit                ; call c static library exit
%endif
section .text
          extern  exit
section .data
message:  db    "Hello, World", 10  ; note the newline at the end
