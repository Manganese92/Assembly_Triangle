global main


section .data


section .bss

count 1
max_size 400 
min_x
max_x
min_y
max_y
tabx:  	dw    3
taby:  	dw    3
i: resb 0


section .text


 

main:

;||||||||||||||||||||||||||||||||||||||||||||
;||||||||| Création d'un triangle |||||||||||
;||||||||||||||||||||||||||||||||||||||||||||



nb_aleatoire_x:
    call random_point
    move tabx,dx
    cmp count,3
    je nb_aleatoire_y
    inc count
    jmp nb_aleatoire_x
    

nb_aleatoire_y:
    call random_point
    move tab_y,dx
    cmp count,5
    je min_max
    inc count
    jmp nb_aleatoire_y


mov byte[i],1


min_max:
    min_max_x:
        mov ecx,byte[i]  
        move eax, tabx[0]
        move max_x, eax
        move min_x, eax
        move eax, [tabx+ ecx*WORD]

        inc byte[i] 
	    cmp byte[i],2  
	    jne min_max_x 

    mov byte[i],1

    min_max_y:
        mov ecx,byte[i]   
        move eax, taby[0]
        move max_y, eax
        move min_y, eax
        move eax, [taby+ ecx*WORD]

        inc byte[i]
	    cmp byte[i],2
	    jne min_max_y



;||||||||||||||||||||||||||||||||||||||||||||
;||||||||| lignes d'un triangle |||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||


dessin_lignes_triangles:
    
        ; coordonnées de la ligne AB (noire)
    mov r8, tabx[0]
    mov r9, taby[0]
    mov dword[x1],r8       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10, tabx[1]
    mov r11, taby[1]
    mov dword[x2],r10        ;remplacer la valeur par le x mis dans le tableau pour le second point
    mov dword[y2],r11       ;remplacer la valeur par le y mis dans le tableau pour le second point
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[x1]	; coordonnée source en x
    mov r8d,dword[y1]	; coordonnée source en y
    mov r9d,dword[x2]	; coordonnée destination en x
    push qword[y2]		; coordonnée destination en y
    call XDrawLine 


        ; coordonnées de la ligne AB (noire)
    mov r8, tabx[1]
    mov r9, taby[1]
    mov dword[x1],r8       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10, tabx[2]
    mov r11, taby[2]
    mov dword[x2],r10        ;remplacer la valeur par le x mis dans le tableau pour le second point
    mov dword[y2],r11       ;remplacer la valeur par le y mis dans le tableau pour le second point
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[x1]	; coordonnée source en x
    mov r8d,dword[y1]	; coordonnée source en y
    mov r9d,dword[x2]	; coordonnée destination en x
    push qword[y2]		; coordonnée destination en y
    call XDrawLine 


        ; coordonnées de la ligne AB (noire)
    mov r8, tabx[2]
    mov r9, taby[2]
    mov dword[x1],r8       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10, tabx[0]
    mov r11, taby[0]
    mov dword[x2],r10        ;remplacer la valeur par le x mis dans le tableau pour le second point
    mov dword[y2],r11       ;remplacer la valeur par le y mis dans le tableau pour le second point
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[x1]	; coordonnée source en x
    mov r8d,dword[y1]	; coordonnée source en y
    mov r9d,dword[x2]	; coordonnée destination en x
    push qword[y2]		; coordonnée destination en y
    call XDrawLine 



;||||||||||||||||||||||||||||||||||||||||||||
;||||||| determinant d'un triangle ||||||||||
;||||||||||||||||||||||||||||||||||||||||||||






;||||||||||||||||||||||||||||||||||||||||||||||||||
;|||Position d'un point par rapport au triangle||||
;||||||||||||||||||||||||||||||||||||||||||||||||||





;||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||| Fin programme |||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||


; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret



;||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||| Fonctions |||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||


global random_point

random_point:

    move dx,max_size
    rdrand ax
    cmp CF,1
    jne rander_point ; est-ce possible ?
    div  dx




ret