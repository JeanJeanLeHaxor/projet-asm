;--------------------------------------------------
; check.asm
;
; Ce fichier contient les différentes fonctions ayant pour but de vérifier si la chaine de
;   caractères entrée par l'utilisateur est valide
;
; Auteur: Louis Deschanel
;--------------------------------------------------

section .text ; Définition des fonctions et du code

;--------------------------------------------------
; Fonction return_false
;
; Input: None
; Output:
;   - 0 
;
; Objectif: Renvoyer 0
;           Cette fonction n'est jamais appelée via l'instruction call, elle est utilisée au travers de jump

return_false:
  mov eax, 0
  ret

;--------------------------------------------------
; Fonction check_maj_letter
;
; Input:
;   - ARG_1: caractère ascii à tester
; Output:
;   - 0 si le caractère n'est pas une majuscule 
;   - 1 si le caractère est une majuscule 
;
; Objectif: Vérifier si le caractère ascii passer en paramètre est une majuscule (code ascii entre 65 et 90) 

check_maj_letter:
  mov edx, ARG_1  
  cmp dl, 'A'            ; == if (chr < 65) 
  jl return_false
  cmp dl, 'Z'            ; == if (chr > 90)
  jg return_false
  mov eax, 1
  ret

;--------------------------------------------------
; Fonction check_min_letter
;
; Input:
;   - ARG_1: caractère ascii à tester
; Output:
;   - 0 si le caractère n'est pas une minuscule 
;   - 1 si le caractère est une minuscule
;
; Objectif: Vérifier si le caractère ascii passer en paramètre est une minuscule (code ascii entre 97 et 122) 

check_min_letter:
  mov edx, ARG_1  
  cmp dl, 'z'            ; == if (chr < 97) 
  jl return_false
  cmp dl, 'z'            ; == if (chr > 122) 
  jg return_false
  mov eax, 1
  ret

;--------------------------------------------------
; Fonction check_single_letter
;
; Input:
;   - ARG_1: caractère ascii à tester
; Output:
;   - 0 Si le caractère n'est pas valide 
;   - 1 Si le caractère est valide 
;
; Objectif: Vérifier si le caractère passé en argument est une minuscule ou une majuscule

check_single_letter:
  _enter                  ; Prologue

  push ARG_1              ; caractère à vérifier
  call check_maj_letter   ; Vérification majuscule           
  
  mov eax, ecx            ; Sauvegarde du 1er résultat
  call check_min_letter   ; Vérification minuscule

  or eax, ecx             ; OU logique, si l'un des deux tests à fonctionné, le résultat sera 1, si les 2 échouent, le résultat sera 0
  cmp eax, 1
  jne error_letter        ; Si la lettre n'est pas valide, un message d'erreur est affiché

  leave                   ; Epilogue
  ret

;--------------------------------------------------
; Fonction check_len
;
; Input: None
; Output:
;   - 0 Si la chaine est trop courte / trop longue
;   - 1 Si la taille est valide
;
; Objectif: Vérifier que la longueur de l'entrée utilisateur est comprise entre 18 et 21 

check_len:
  cmp BYTE [input_len], 18 ; == if (input_len < 18)
  jl error_short
  cmp BYTE [input_len], 21 ; == if (input_len > 21)
  jg error_long
  mov eax, 1
  ret
