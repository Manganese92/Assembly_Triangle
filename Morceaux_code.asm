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





; Génère un entier aléatoire compris entre min et max
; Entrées :
;   min : valeur minimale (inclus)
;   max : valeur maximale (inclus)
; Sortie :
;   eax : entier aléatoire généré

generate_random:
    push ebx            ; sauvegarde ebx
    push edx            ; sauvegarde edx
    push ecx            ; sauvegarde ecx

    ; Initialisation de la graine aléatoire
    xor eax, eax        ; eax = 0
    mov ebx, [esp + 12] ; ebx = max
    mov ecx, [esp + 8]  ; ecx = min
    sub ebx, ecx        ; ebx = max - min
    inc ebx             ; ebx = max - min + 1
    or ebx, 1           ; ebx = (max - min + 1) | 1
    mov edx, ebx        ; edx = (max - min + 1) | 1
    mov ecx, [esp + 16] ; ecx = seed
    xor ebx, ecx        ; ebx = seed ^ ((max - min + 1) | 1)
    mul ebx             ; eax = seed * ((max - min + 1) | 1)
    xor edx, eax        ; edx = (max - min + 1) | 1 ^ seed * ((max - min + 1) | 1)
    mov ebx, edx        ; ebx = (max - min + 1) | 1 ^ seed * ((max - min + 1) | 1)
    add eax, ebx        ; eax = seed * ((max - min + 1) | 1) + (max - min + 1) | 1 ^ seed * ((max - min + 1) | 1)

    ; Génération d'un entier aléatoire
    mov ebx, [esp + 12] ; ebx = max
    mov ecx, [esp + 8]  ; ecx = min
    sub ebx, ecx        ; ebx = max - min
    inc ebx             ; ebx = max - min + 1
    xor edx, edx        ; edx = 0
    div ebx             ; eax = random_number, edx = random_number % (max - min + 1)
    add eax, ecx        ; eax = random_number + min

    pop ecx             ; restaure ecx
    pop edx             ; restaure edx
    pop ebx             ; restaure ebx
    ret                 ; retourne eax
