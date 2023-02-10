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




//////////////////////
//     ALGO        //
////////////////////

Demander le nombre de triangles

boucle x nombre de triangles:
    boucle coordonées x3:
        génère un x
        le stocker
        génère un y 
        le stocker
        stocker les deux ensembles
    fin boucle


--> faire une ligne à l'horizontale et verticale qui passe par chaque point du triangle 
 