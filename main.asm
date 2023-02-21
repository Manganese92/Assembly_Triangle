global main


section .data


section .bss
count 1
max_size 400 
tabx:  	dw    3
taby:  	dw    3


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
        add count
        jmp nb_aleatoire_x
    

    nb_aleatoire_y:
        call random_point
        move tab_y,dx
        cmp count,5
        je min_max
        add count
        jmp nb_aleatoire_y



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