;--------------------------------------------------
; shadow.asm
;
; Ce fichier regroupe les différente fonctions permettant d'ouvrir le fichier
;   qui contient le mot de passe et de le récupérer dans une variable
;
; Auteur: Louis Deschanel
;--------------------------------------------------

section .text                       ; Définition du code

;--------------------------------------------------
; Fonction get_password
;
; Input: 
;   - 1: File descriptor du fichier contenant le mot de passe
; Output: None 
;
; Objectif: Lire le mot de passe contenu dans un fichier 

get_password:
  _enter                            ; Prologue

  push 21                           ; Taille à lire
  push password                     ; Buffer contenant le mot de passe
  push ARG_1                        ; file descriptor
  call read                         ; Appel de read

  mov BYTE [password + eax - 1], 0  ; Ajoute du NULL byte
  
  leave                             ; Epilogue
  ret

;--------------------------------------------------
; Fonction open_file
;
; Input: None
; Output: File descriptor du fichier contenant le mot de passe 
;
; Objectif: Ouvrir le fichier contenant le mot de passe

open_file:
  _enter                            ; Prologue

  push 0                            ; mode (non utilisé)
  push O_RDONLY                     ; Flag O_RDONLY pour ouvrir le fichier en lecture seule
  push password_file                ; Nom du fichier à ouvrir
  call open                         ; Appel d'open

  ; Si le retour d'open est -1, l'ouverture à échouée, le programme quitte
  cmp eax, 0xff
  je error_open_file
  
  leave                             ; Epilogue
  ret

;--------------------------------------------------
; Fonction parse_shadow_file
;
; Input: None
; Output: None 
;
; Objectif: Ouvrir un fichier puis récupérer son contenu pour le stocker dans une variable 

parse_shadow_file:
  _enter                            ; Prologue

  call open_file                    ; Ouverture du fichier contenant le mot de passe

  push eax                          ; Le file descriptor est passé est argument
  call get_password                 ; Lecture du mot de passe

  leave                             ; Epilogue
  ret
