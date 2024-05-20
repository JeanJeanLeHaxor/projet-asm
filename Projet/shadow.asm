
get_salt:
  _enter

  push 4
  push salt
  push ARG_1
  call read
 
  leave
  ret

get_hash:
  _enter

  push 32
  push hash
  push ARG_1
  call read
  
  leave
  ret

open_file:
  _enter
  push 0
  push O_RDONLY ;0
  push password_file
  call open

  cmp eax, 0xff
  je
  
  leave
  ret

parse_shadow_file:
  _enter

  call open_file
  push eax
  call get_salt
  call get_hash

  leave
  ret
