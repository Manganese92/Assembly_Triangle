; Initialize the random number generator
mov eax, [seed]  ; Load the seed into EAX
mul eax, 0xDEADBEEF ; Multiply by a magic constant
add eax, 0xDEADCAFE ; Add another constant
mov [seed], eax   ; Store the result back as the new seed

; Generate a random number between min and max
mov eax, [seed]  ; Load the seed into EAX
mul eax, 0xDEADBEEF ; Multiply by a magic constant
add eax, 0xDEADCAFE ; Add another constant
mov [seed], eax   ; Store the result back as the new seed
mov eax, [min]    ; Load the minimum value
imul eax, [max]   ; Multiply it by the maximum value
cdq               ; Sign-extend EAX into EDX
idiv [max]        ; Divide EDX:EAX by the maximum value
add eax, [min]    ; Add the minimum value back