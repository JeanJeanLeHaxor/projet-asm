;--------------------------------------------------
; defined.asm
;
; Ce fichier contient les différents define utilisé pour permettre une meilleur compréhension du code
;
; Auteur: Louis Deschanel
;--------------------------------------------------

section .text

error_read_password:
  call print_error_read_password_string
  call exit 

error_short:
  call print_error_short_string
  mov eax, 0
  ret

error_long:
  call print_error_long_string
  mov eax, 0
  ret

error_letter:
  call print_error_letter_string
  mov eax, 0
  ret
