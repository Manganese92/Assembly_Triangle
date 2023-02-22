; external functions from X11 library
extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XDrawPoint
extern XFillArc
extern XNextEvent

; external functions from stdio library (ld-linux-x86-64.so.2)    
extern printf
extern exit

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16
%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1



;||||||||||||||||||||||||||||||||||||||||||||
;||||||||||||| Global main ||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||




global main



section .data

event:		times	24 dq 0

x1:	dd	0
x2:	dd	0
y1:	dd	0
y2:	dd	0


max_size: dw 400 
min_x: dw 0
max_x: dw 0
min_y: dw 0
max_y: dw 0





section .bss

display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1



tabx:  	resw    3
taby:  	resw    3
i: resb 0





section .text


 

main:

;||||||||||||||||||||||||||||||||||||||||||||
;||||||||| Création d'un triangle |||||||||||
;||||||||||||||||||||||||||||||||||||||||||||

mov word[i],1

nb_aleatoire_x:
    movzx ecx,word[i] 
    call random_point
    mov [tabx + ecx * WORD],dx
    cmp word[i],3
    je nb_aleatoire_y
    inc word[i]
    jmp nb_aleatoire_x
    

nb_aleatoire_y:
    call random_point
    mov [tabx + ecx * WORD],dx
    cmp word[i],5
    je min_max
    inc word[i]
    jmp nb_aleatoire_y


mov word[i],1


min_max:
    min_max_x:
        movzx ecx,word[i]  
        mov eax, [tabx + 0 * WORD]
        mov dword[max_x], eax
        mov dword[min_x], eax
        mov eax, [tabx+ ecx*WORD]

        inc word[i] 
	    cmp word[i],2  
	    jne min_max_x 

    mov byte[i],1

    min_max_y:
        movzx ecx,word[i]   
        mov eax, [taby + 0 * WORD]
        mov dword[max_y], eax
        mov dword[min_y], eax
        mov eax, [taby+ ecx*WORD]

        inc word[i]
	    cmp word[i],2
	    jne min_max_y



;||||||||||||||||||||||||||||||||||||||||||||
;||||||||| lignes d'un triangle |||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||


xor     rdi,rdi
call    XOpenDisplay	; Création de display
mov     qword[display_name],rax	; rax=nom du display

; display_name structure
; screen = DefaultScreen(display_name);
mov     rax,qword[display_name]
mov     eax,dword[rax+0xe0]
mov     dword[screen],eax

mov rdi,qword[display_name]
mov esi,dword[screen]
call XRootWindow
mov rbx,rax

mov rdi,qword[display_name]
mov rsi,rbx
mov rdx,10
mov rcx,10
mov r8,400	; largeur
mov r9,400	; hauteur
push 0xFFFFFF	; background  0xRRGGBB
push 0x00FF00
push 1
call XCreateSimpleWindow
mov qword[window],rax

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,131077 ;131072
call XSelectInput

mov rdi,qword[display_name]
mov rsi,qword[window]
call XMapWindow

mov rsi,qword[window]
mov rdx,0
mov rcx,0
call XCreateGC
mov qword[gc],rax

mov rdi,qword[display_name]
mov rsi,qword[gc]
mov rdx,0x000000	; Couleur du crayon
call XSetForeground

boucle: ; boucle de gestion des évènements
mov rdi,qword[display_name]
mov rsi,event
call XNextEvent

cmp dword[event],ConfigureNotify	; à l'apparition de la fenêtre
je dessin							; on saute au label 'dessin'

cmp dword[event],KeyPress			; Si on appuie sur une touche
je closeDisplay						; on saute au label 'closeDisplay' qui ferme la fenêtre
jmp boucle



dessin:
    
        ;couleur de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000	; Couleur du crayon ; noir
    call XSetForeground
        ; coordonnées de la ligne AB (noire)
    mov r8d, [tabx + 0 * WORD]
    mov r9d, [taby + 0 * WORD]
    mov dword[x1],r8d       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9d        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10d, [tabx + 1 * WORD]
    mov r11d, [tabx + 1 * WORD]
    mov dword[x2],r10d        ;remplacer la valeur par le x mis dans le tableau pour le second point
    mov dword[y2],r11d       ;remplacer la valeur par le y mis dans le tableau pour le second point
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[x1]	; coordonnée source en x
    mov r8d,dword[y1]	; coordonnée source en y
    mov r9d,dword[x2]	; coordonnée destination en x
    push qword[y2]		; coordonnée destination en y
    call XDrawLine 


        ;couleur de la ligne 2
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000	; Couleur du crayon ; noir
    call XSetForeground
        ; coordonnées de la ligne BC (noire)
    mov r8d, [tabx + 1 * WORD]
    mov r9d, [taby + 1 * WORD]
    mov dword[x1],r8d       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9d        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10d, [tabx + 2 * WORD]
    mov r11d, [tabx + 2 * WORD]
    mov dword[x2],r10d        ;remplacer la valeur par le x mis dans le tableau pour le second point
    mov dword[y2],r11d       ;remplacer la valeur par le y mis dans le tableau pour le second point
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[x1]	; coordonnée source en x
    mov r8d,dword[y1]	; coordonnée source en y
    mov r9d,dword[x2]	; coordonnée destination en x
    push qword[y2]		; coordonnée destination en y
    call XDrawLine 


        ;couleur de la ligne 3
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000	; Couleur du crayon ; noir
    call XSetForeground
        ; coordonnées de la ligne CA (noire)
    mov r8d, [tabx + 2 * WORD]
    mov r9d, [taby + 2 * WORD]
    mov dword[x1],r8d       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9d        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10d, [tabx + 0 * WORD]
    mov r11d, [tabx + 0 * WORD]
    mov dword[x2],r10d        ;remplacer la valeur par le x mis dans le tableau pour le second point
    mov dword[y2],r11d       ;remplacer la valeur par le y mis dans le tableau pour le second point
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[x1]	; coordonnée source en x
    mov r8d,dword[y1]	; coordonnée source en y
    mov r9d,dword[x2]	; coordonnée destination en x
    push qword[y2]		; coordonnée destination en y
    call XDrawLine 

jmp flush

flush:
mov rdi,qword[display_name]
call XFlush
jmp boucle
mov rax,34
syscall

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit

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

    mov dx,max_size
    rdrand ax
    jnc random_point
    div  dx




ret