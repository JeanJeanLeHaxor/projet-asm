;--------------------------------------------------
; TODO: add description
; Auteur: Louis Deschanel
;--------------------------------------------------

%include "output_message.asm" ;
%include "error.asm"          ;
%include "check.asm"
%include "syscall.asm"
;--------------------------------------------------

section .bss                  ; Définition des variables en lecture et écriture
  input: resb 25              ; Entrée de l'utilisteur: 25 caractères alloués
  input_len: resd 1           ; Longueur de la chaine entrée par l'utilisateur, sera réutilisé à plusieurs endroits

;--------------------------------------------------

section .data                 ; Définition des constantes
  password: db "ThisIsAGoodPassword"

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

exit_error:                
  push 1                      ; La valeur de retour 1 indique qu'il y a eu une erreur
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

  _enter                     ; Prologue

  ; équivalent de read(0, input, 25) 
  push 25
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

  ; Initialisation d'ecx à 0 pour s'en servir comme compteur
  xor ecx, ecx
  
  ; La boucle suivante permet d'itérer sur chaque caractère de la chaine entrée par l'utilisateur
  _check_input_loop:
    cmp ecx, DWORD [input_len]  ; Tant qu'ecx est inférieur à la longueur de la chaine, la boucle continue
    jge _check_input_end
    push ecx                    ; L'index actuel est passé en argument et est sauvegardé
    call check_single_letter    ; Appel de la fonction vérifiant si un caractère est valide
    cmp eax, 1
    jne _check_input_end        ; Si le caractère testé n'est pas valide, la fonction quitte en renvoyant 0
    pop ecx                     ; ecx est récupéré
    inc ecx                     ; Le compteur est incrémenté
    jmp _check_input_loop

_check_input_end:
  leave                         ; Epilogue
  ret

;--------------------------------------------------
; Fonction compare_password
;
; Input: None
; Output:
;   - 0 lorsque l'entrée utilisateur correspond au mot de passe
;   - Une autre valeur si les entrées ne correspondent pas
;
; Objectif: Comparer l'entrée utilisateur avec le mot de passe stocké dans la section .data

compare_password:
  xor ecx, ecx                    ; Initialisation d'edx à 0 pour s'en servir comme compteur
  _strcmp_loop:
    cmp BYTE [password + ecx], 0  ; Si la fin du mot de passe est atteint, la fonction quitte
    je _strcmp_end
    cmp BYTE [input + ecx], 0     ; Si la fin du mot de passe est atteint, la fonction quitte
    je _strcmp_end

    mov al, BYTE [password + ecx]
    cmp al, BYTE [input + ecx]    ; Comparaison entre les deux caractères
    jne _strcmp_end               ; Si les 2 caractères ne sont pas egaux, la fonction quitte
    
    inc ecx
    jmp _strcmp_loop

_strcmp_end:                      ; Le fonction renvoie la différence entre les deux caractères
  xor eax, eax
  mov al, BYTE [password + ecx]
  sub al, BYTE [input + ecx]
  ret

;--------------------------------------------------
; Fonction _start
;
; Input: None
; Output:
;   - 1 si l'utilisateur rentre 5 chaines non égales au mot de passe
;   - 0 si l'utilisateur rentre une chaine de caractères identique au mot de passe
;
;
; Objectif: Demander une entrée utilisateur et la comparer avec une chaine en mémoire

_start:
  _enter                                    ; Prologue
  
  sub esp, 4
  mov DWORD [esp], 0                        ; Le compteur d'essai est initialisé dans la stack avec une valeur de 0

  _start_loop:
    inc DWORD [esp]                         ; Le compteur d'essai est incrémenté
    
    cmp DWORD [esp], 6                      
    jge _end_fail_prog                      ; Si le mot de passe n'a pas été entré au bout de 5 tentative, le programme quitte sur une erreur

    call print_enter_string                 ; Affichage d'un message invitant l'utilisateur à entrer une chaine
    call read_password                      ; Récupération de l'entrée utilisateur
    call check_input                        ; Vérification de la chaine
    cmp eax, 1
    jne _start_loop                         ; Si la chaine n'est pas valide, la boucle recommence

    call compare_password                   ; Si la chaine est valide, la comparaison est effectuée
    cmp eax, 0
    je _end_prog                            ; Si l'entrée utilisateur correspond au mot de passe, le programme quitte sans erreur
   
    call print_error_bad_password_string    ; Si le mot de passe est invalide, un message est affiché
    jmp _start_loop

  call compare_password 
  je _end_prog                              ; Si l'entrée est valide, le programme quitte en affichant un message
  
  jmp _start                                ; Dans le cas contraire, une nouvelle entrée est demandée

_end_fail_prog:                       
  call print_error_validate_password_string ; Affichage d'une erreur 
  call exit_error

_end_prog:
  call print_validate_password_string       ; Affiche sans erreur
  call exit_no_error
