;--------------------------------------------------
; TODO: add description
; Auteur: Louis Deschanel
;--------------------------------------------------

%include "output_message.asm" ;
%include "defined.asm"        ; Contient tous les alias d'appel système et autres pour faciliter la lecture
%include "error.asm"          ;
%include "check.asm"

;--------------------------------------------------

section .bss                  ; Définition des variables en lecture et écriture
  input: resb 22              ; Entrée de l'utilisteur: 22 caractères alloués pour les 21 lettres + le retour à la ligne ('\n') TODO à revérifier
  input_len: resd 1           ; Longueur de la chaine entrée par l'utilisateur, sera réutilisé à plusieurs endroits

;--------------------------------------------------

section .text                 ; Définition des fonctions et du code
global _start

;--------------------------------------------------
; Fonction exit_no_error
;
; Input:  None
; Output: None
;
; Objectif: Quitter le programme sans erreur via un l'appel système exit, équivalent de exit(0) en C

exit_no_error:                
  push 0                      ; La valeur de retour 0 indique qu'il n'y a pas eu d'erreur
  call exit

;--------------------------------------------------
; Fonction exit_error
;
; Input:  None
; Output: None
;
; Objectif: Quitter le programme avec erreur via un l'appel système exit, équivalent de exit(1) en C

exit_no_error:                
  push 0                      ; La valeur de retour 1 indique qu'il n'y a eu une erreur
  call exit

;--------------------------------------------------
; Fonction read_password
;
; Input: None
; Output: None 
;
; Objectif: Lire une entrée utilisateur depuis l'entrée standard pour 
;             le stocker dans la variable input et stocker sa longueur dans la variable input_len

read_password:

  _enter                      ; Prologue

  ; équivalent de read(0, input, 22) 
  push 22
  push input
  push STDIN
  call read

  ; Si -1 est renvoyé par read, une erreur s'est produite, le programme quitte en affichant une erreur
  cmp eax, 0xff
  je error_read_password
 
  ; La longueur de la chaine entrée par l'utilisateur est sauvegardé dans la variable globale
  dec eax
  mov DWORD [input_len], eax
  
  ; Un NULL byte est ajouté à la fin de l'entrée utilisateur
  mov BYTE [input + eax], 0
  
  leave                       ; Epilogue
  ret

;--------------------------------------------------
; Fonction check_input
;
; Input: None
; Output:
;   - 1 si la chaine entrée par l'utilisateur est valide
;   - 0 si la chaine entrée par l'utilisateur n'est pas valide
;
; Objectif: Vérifier que l'entrée utilisateur est valide selon plusieurs critères:
;             - Taille de l'entrée comprise entre 18 et 21 caractères
;             - L'entrée ne contient que des lettres minuscules ou majusucules

check_input:
  _enter                        ; Prologue

  ; La fonction de vérification de longueur est appelée
  call check_len
  cmp eax, 1
  jne _check_input_end          ; Si la longueur n'est pas valide, la fonction quitte en renvoyant 0

  ; Initialisation d'edx à 0 pour s'en servir comme compteur et d'edx à 0 pour l'utiliser afin de stocker les caractères
  xor ecx, ecx
  
  ; La boucle suivante permet d'itérer sur chaque caractère de la chaine entrée par l'utilisateur
  _check_input_loop:
    cmp ecx, DWORD [input_len]  ; Tant qu'ecx est inférieur à la longueur de la chaine, la boucle continue
    jge _check_input_end
    push ecx                    ; L'index actuel est passé en argument
    call check_single_letter    ; Appel de la fonction vérifiant si un caractère est valide
    cmp eax, 1
    jne _check_input_end        ; Si le caractère testé n'est pas valide, la fonction quitte en renvoyant 0
    inc ecx                     ; Le compteur est incrémenté
    jmp _check_input_loop

_check_input_end:
  leave                         ; Epilogue
  ret

;--------------------------------------------------
; Fonction _start
;
; Input: None
; Output:
;   - 1 en cas d'erreur lors de la lecture de l'entrée utilisateur
;   - 0 lorsque l'utilisateur rentre une chaine valide
;
;
; Objectif: Demander une entrée utilisateur en boucle et quitter lorsque celle ci est valide

_start:
  call print_enter_string       ; Affichage d'un message invitant l'utilisateur à entrer une chaine
  call read_password            ; Récupération de l'entrée utilisateur
  
  call check_input              ; Vérification de la chaine
  cmp eax, 1
  je _end_prog                  ; Si l'entrée est valide, le programme quitte en affichant un message
  
  jmp _start                    ; Dans le cas contraire, une nouvelle entrée est demandée

_end_prog:
  call print_input_valid_string
  call exit_no_error
