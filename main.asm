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

mov byte[i],1

nb_aleatoire_x:
    call random_point
    mov tabx,dx
    cmp byte[i],3
    je nb_aleatoire_y
    inc byte[i]
    jmp nb_aleatoire_x
    

nb_aleatoire_y:
    call random_point
    mov taby,dx
    cmp byte[i],5
    je min_max
    inc byte[i]
    jmp nb_aleatoire_y


mov byte[i],1


min_max:
    min_max_x:
        mov ecx,byte[i]  
        mov eax, tabx[0]
        mov max_x, eax
        mov min_x, eax
        mov eax, [tabx+ ecx*WORD]

        inc byte[i] 
	    cmp byte[i],2  
	    jne min_max_x 

    mov byte[i],1

    min_max_y:
        mov ecx,byte[i]   
        mov eax, taby[0]
        mov max_y, eax
        mov min_y, eax
        mov eax, [taby+ ecx*WORD]

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

    mov dx,max_size
    rdrand ax
    cmp CF,1
    jne rander_point ; est-ce possible ?
    div  dx




ret