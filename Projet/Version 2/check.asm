section .text

return_false:
  mov eax, 0
  ret

check_maj_letter:
  cmp edx, 'A' ; if char < A 
  jl return_false
  cmp edx, 'Z' ; if char > Z
  jg return_false
  mov eax, 1
  ret

check_min_letter:
  cmp edx, 'a' ; if char < A 
  jl return_false
  cmp edx, 'z' ; if char > Z
  jg return_false
  mov eax, 1
  ret

; edx: letter
check_single_letter:
  call check_maj_letter
  push eax
  call check_min_letter
  pop edx
  or eax, edx
  cmp eax, 1
  jne error_letter
  ret

; rdi = string, rcx = read_len
check_len:
  cmp ecx, 18
  jl error_short
  cmp ecx, 21
  jg error_long
  mov eax, 1
  ret
