; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls.
; Runs on Linux only.
;
; Complements of https://cs.lmu.edu/~ray/notes/nasmtutorial/
; Puzzle posed by Blueberry, https://www.pouet.net/topic.php?which=3637
; -- Looks like opcode magic
;
; To assemble and run:
;
;  Pure assembly executable
;   * ❯ nasm -f elf64 puzzle.asm -o xpuzzle.o -dIS_EXECUTABLE
;   * ❯ ld zpuzzle.o -o puzzle -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
;   * ❯ ./puzzle
;   * ???
;
; C/C++ with linked assembly executable
;   * ❯ nasm -f elf64 puzzle.asm -o puzzle.o
;   * ❯ g++ -fPIC sample.cpp -z noexecstack puzzle.o -o sample
;   * ❯ ./sample
;   * ???
;
; # Using elf64 instead of elf because the target architecture is 64bits
; # dIS_EXECUTABLE defines the preprocessor directive below to set main name to _start
; # lc links to c static library
; # dynamic-linker takes path to dynamic linker shared library to use C library
; ----------------------------------------------------------------------------------------
%ifdef IS_EXECUTABLE
%define puzzle _start   ; An exception to all-caps preprocessor macros so we can see what to extern
%else
%define puzzle puzzle
%endif


global    puzzle
section .data ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    int_x         db    5
%ifdef IS_EXECUTABLE
    template    db    "%d", 10, 0 ; Format string with newline and null terminator
%endif
section .text ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    extern  exit
%ifdef IS_EXECUTABLE
    extern  printf

%endif
puzzle: ;
%ifdef IS_EXECUTABLE
    mov   rax,  1               ; Hardcoding the value for now -- it is a pain to get argv
%else
  ; Standard prologue
  ; ...
  ;
    mov   rax,  rdi             ; Grab integer argument from register
%endif
    bsr   rcx,  rax             ; Find place of most significant digit
    add   rcx,  byte 2          ; add two to that place
    bts   rax,  rcx             ; bit test set bit
%ifdef IS_EXECUTABLE
    mov   rdi,  template        ; load string
    mov   rsi,  rax             ; format number
    xor   rax,  rax             ; zero rax
    call  printf
    mov     edi,  0             ; Argument passed to exit() -- ie return 0 on success
    call    exit                ; call c static library exit
%else
    ret
%endif

