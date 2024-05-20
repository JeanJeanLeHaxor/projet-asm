;--------------------------------------------------
; error.asm
;
; Ce fichier contient les différentes fonction affichant les messages d'erreur 
;   et retournant une erreur
;
; Auteur: Louis Deschanel
;--------------------------------------------------

section .text

error_read_password:
  call print_error_read_password_string
  call exit_error

error_short:
  call print_error_short_string
  mov eax, 0
  leave
  ret

error_long:
  call print_error_long_string
  mov eax, 0
  leave
  ret

error_letter:
  call print_error_letter_string
  mov eax, 0
  leave
  ret

error_open_file:
  call print_error_open_file_string
  call exit_error
