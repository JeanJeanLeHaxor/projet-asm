;--------------------------------------------------
; defined.asm
;
; Ce fichier contient les différents define utilisé pour permettre une meilleur compréhension du code 
;
; Auteur: Louis Deschanel
;--------------------------------------------------


;--------------------------------------------------
; Définition des différents flux 

%define STDIN 0
%define STDOUT 1
%define STDERR 2


;--------------------------------------------------
; Définition des différents syscall 

%define SYSCALL_EXIT 1
%define SYSCALL_READ 3
%define SYSCALL_WRITE 4

;--------------------------------------------------
; Définition des arguments
; La calling convention 'Right-To-Left' est utilisée pour une meilleur compréhension lors de la lecture du code
%define ARG_1 DWORD [esp + 8]
%define ARG_2 DWORD [esp + 12]
%define ARG_3 DWORD [esp + 16]


;--------------------------------------------------
; Définiton du prologue

%macro _enter 0
push ebp
mov ebp, esp
%endmacro
