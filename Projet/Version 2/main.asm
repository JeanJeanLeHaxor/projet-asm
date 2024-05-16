%include "output_message.asm"
%include "defined.asm"
%include "error.asm"
%include "check.asm"

section .data
  password: db "ThisIsMyGoodPassword"

section .bss
  input: resb 22
  input_len: resd 1

section .text

global _start

exit:
  mov eax, SYSCALL_EXIT
  mov ebx, 0
  int 0x80


; read(0, password, 22)
read_password:
  mov eax, SYSCALL_READ
  mov ebx, STDIN
  mov ecx, password
  mov edx, 22
  int 0x80

  ; check if an error occured
  cmp eax, 0xff
  je error_read_password
  

  dec eax
  ; save password lenght
  mov DWORD [input_len], eax
  
  ; add a NULL byte at the end of the input
  mov BYTE [input + eax], 0
  ret

; TODO: verifier taille
check_input: 
  mov ecx, DWORD [input_len]
  call check_len
  cmp eax, 1
  jne _check_input_end

  xor ecx, ecx
  xor edx, edx

  _check_input_loop:
    cmp ecx, DWORD [input_len] ; demander opti memoire ?
    jge _check_input_end
    mov dl, BYTE [input + ecx]
    call check_single_letter
    cmp eax, 1
    jne _check_input_end
    inc ecx
    jmp _check_input_loop
_check_input_end:
  ret

compare_string:
  xor ecx, ecx
  _compare_string_loop:
    cmp BYTE [password + ecx], 0
    je _end_compare_string
    cmp BYTE [input + ecx], 0
    mov al, BYTE [password + ecx]
    cmp al, BYTE [input + ecx]
    jne _end_compare_string
    inc ecx
    jmp _compare_string_loop 

  _end_compare_string:
    mov al, BYTE [password + ecx]
    sub al, BYTE [input + ecx]
    ret

; TODO à demander :
; - Faut t'il suivre la calling convention (push on stack)
; - Est t'il mieux de sauvegarder le resultat puis de verifier dans main
; ou est ce ok de jmp error directement

_start:
  call print_enter_string
  call read_password
  call check_input
  cmp eax, 1
  je _end_prog
  jmp _start

_end_prog:
  call print_input_valid_string
  call exit
