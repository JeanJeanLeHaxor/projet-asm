;--------------------------------------------------
; output_message.asm
;
; Ce fichier centralise les messages qui sont affichés pour l'utilisateur
; Les messages d'erreurs sont affichés sur STDERR, les autres sur STDOUT
;
; Auteur: Louis Deschanel
;--------------------------------------------------

%include "defined.asm"

section .data ; Définition des constantes

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


section .text ; Définition des fonctions et du code

print_enter_string:
  push enter_string_len
  push enter_string
  push STDOUT
  call write
  ret

print_input_valid_string:
  push input_valid_string_len
  push input_valid_string
  push STDOUT
  call write
  ret

; Error messages:

print_error_read_password_string:
  push error_read_password_string_len
  push error_read_password_string
  push STDERR
  call write
  ret

print_error_short_string:
  push error_short_string_len
  push error_short_string
  push STDERR
  call write
  ret

print_error_long_string:
  push error_long_string_len
  push error_long_string
  push STDERR
  call write
  ret

print_error_letter_string:
  push error_letter_string_len
  push error_letter_string
  push STDERR
  call write
  ret
