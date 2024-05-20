section .text


get_password:
  _enter

  push 21
  push password
  push ARG_1
  call read

  mov BYTE [password + eax - 1], 0 ; Ajoute du NULL byte
  
  leave
  ret

open_file:
  _enter
  push 0
  push O_RDONLY
  push password_file
  call open

  ;cmp eax, 0xff
  ;je 
  
  leave
  ret

parse_shadow_file:
  _enter

  call open_file
  push eax
  call get_password

  leave
  ret
