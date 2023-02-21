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
        mov ecx,byte[i]      ; on copie i dans ecx
        move eax, tabx[0]
        move max_x, eax
        move min_x, eax
        move eax, [tabx+ ecx*WORD]

        inc byte[i]             ; on incrémente i
	    cmp byte[i],2         ; on compare i avec 2 
	    jb min_max_x      ; si i<10, on saute à boucle_demande


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