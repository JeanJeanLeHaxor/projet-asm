;--------------------------------------------------
; syscall.asm
;
; Ce fichier contient les différents syscall utilisé dans les autres fichiers
; Le but est de se rapprocher du langage C avec des interfaces aux appels système
;
; Auteur: Louis Deschanel
;--------------------------------------------------

section .text ; Définition des fonctions et du code

;--------------------------------------------------
; exit(code)

exit:
  _enter                  ; Prologue
  
  mov eax, SYSCALL_EXIT
  mov ebx, ARG_1
  int 0x80
  
  leave                   ; Epilogue
  ret

;--------------------------------------------------
; read(fd, buffer, size)

read:
  _enter                  ; Prologue

  mov eax, SYSCALL_READ
  mov ebx, ARG_1
  mov ecx, ARG_2
  mov edx, ARG_3
  int 0x80

  leave                   ; Epilogue
  ret

;--------------------------------------------------
; write(fd, buffer, size)

write:
  _enter                  ; Prologue

  mov eax, SYSCALL_WRITE
  mov ebx, ARG_1
  mov ecx, ARG_2
  mov edx, ARG_3
  int 0x80
  
  leave                   ; Epilogue
  ret
