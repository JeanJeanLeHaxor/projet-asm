%include "defined.asm"

section .data
  enter_string: db "Entrez le mot de passe: ", 0
  enter_string_len: equ $ -enter_string

  input_valid_string: db "Entrée valide.", 0xa, 0
  input_valid_string_len: equ $ -input_valid_string


  error_read_password_string: db "Une erreur s'est produite pendant la lecture du mot de passe.", 0xa, 0
  error_read_password_string_len: equ $ -error_read_password_string

  error_short_string: db "Chaîne de charactères trop courte.", 0xa, 0
  error_short_string_len: equ $ -error_short_string
  
  error_long_string db  "Chaîne de charactères trop longue.", 0xa, 0
  error_long_string_len: equ $ -error_long_string
  
  error_letter_string: db "Chaîne de charactère non conforme.", 0xa, 0
  error_letter_string_len: equ $ -error_letter_string


section .text

print_enter_string:
  mov eax, SYSCALL_WRITE
  mov ebx, STDOUT
  mov ecx, enter_string
  mov edx, enter_string_len
  int 0x80
  ret

print_input_valid_string:
  mov eax, SYSCALL_WRITE
  mov ebx, STDOUT
  mov ecx, input_valid_string
  mov edx, input_valid_string_len
  int 0x80
  ret

; Error messages:

print_error_read_password_string:
  mov eax, SYSCALL_WRITE
  mov ebx, STDERR
  mov ecx, error_read_password_string
  mov edx, error_read_password_string_len
  int 0x80
  ret

print_error_short_string:
  mov eax, SYSCALL_WRITE
  mov ebx, STDERR
  mov ecx, error_short_string
  mov edx, error_short_string_len
  int 0x80
  ret

print_error_long_string:
  mov eax, SYSCALL_WRITE
  mov ebx, STDERR
  mov ecx, error_long_string
  mov edx, error_long_string_len
  int 0x80
  ret

print_error_letter_string:
  mov eax, SYSCALL_WRITE
  mov ebx, STDERR
  mov ecx, error_letter_string
  mov edx, error_letter_string_len
  int 0x80
  ret
