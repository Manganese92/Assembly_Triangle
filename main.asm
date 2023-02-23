extern printf

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


max_size: dd 400 
min_x: dd 1
max_x: dd 1
min_y: dd 1
max_y: dd 1

point_x: dd 0
point_y: dd 0





section .bss

display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1



tabx:  	resd    3
taby:  	resd    3
i: resb 0





section .text


 

main:

;||||||||||||||||||||||||||||||||||||||||||||
;||||||||| Création d'un triangle |||||||||||
;||||||||||||||||||||||||||||||||||||||||||||

mov dword[i],0
mov rax, 0

nb_aleatoire_x:
    mov ecx,dword[i] 
    call random_point
    mov [tabx + ecx * DWORD], eax
    cmp dword[i],3
    je nb_aleatoire_y
    inc dword[i]
    jmp nb_aleatoire_x
    

nb_aleatoire_y:
    call random_point
    mov [tabx + ecx * DWORD], eax
    cmp dword[i],5
    je min_max
    inc dword[i]
    jmp nb_aleatoire_y



min_max:

    min_max_x:
        mov dword[i],0
        mov ecx,dword[i]
        mov ebx,dword[min_x]  
        mov eax,dword[max_x]

        cmp ebx, [tabx+ ecx*DWORD]
        jl update_min_x
        cmp eax, [tabx+ ecx*DWORD]
        jl update_max_x

        inc dword[i] 
	    cmp dword[i],2  
	    jne min_max_x
        jmp min_max_y 


        update_min_x:
          mov ebx, [tabx+ ecx*DWORD]
          mov dword[min_x], ebx
          jmp min_max_x

        update_max_x:
          mov eax, [tabx+ ecx*DWORD]
          mov dword[min_x], eax
          jmp min_max_x



    min_max_y:
        mov dword[i],0
        mov ecx, dword[i]        
        mov ebx, dword[min_y]  
        mov eax, dword[max_y]

        cmp ebx, [taby+ ecx*DWORD]
        jb update_min_y

        cmp eax, [taby+ ecx*DWORD]
        jb update_max_y

        inc dword[i] 
	    cmp dword[i],2  
	    jne min_max_y
        jmp main_dessin


        update_min_y:
          mov ebx, [taby+ ecx*DWORD]
          mov dword[min_y], ebx
          jmp min_max_y

        update_max_y:
          mov eax, [taby+ ecx*DWORD]
          mov dword[min_y], eax
          jmp min_max_y
   




;||||||||||||||||||||||||||||||||||||||||||||
;||||||||| lignes d'un triangle |||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||

main_dessin:
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
    mov r8d, [tabx + 0 * DWORD]
    mov r9d, [taby + 0 * DWORD]
    mov dword[x1],r8d       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9d        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10d, [tabx + 1 * DWORD]
    mov r11d, [tabx + 1 * DWORD]
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
    mov r8d, [tabx + 1 * DWORD]
    mov r9d, [taby + 1 * DWORD]
    mov dword[x1],r8d       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9d        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10d, [tabx + 2 * DWORD]
    mov r11d, [tabx + 2 * DWORD]
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
    mov r8d, [tabx + 2 * DWORD]
    mov r9d, [taby + 2 * DWORD]
    mov dword[x1],r8d       ;remplacer la valeur par le x mis dans le tableau pour le premier point
    mov dword[y1],r9d        ;remplacer la valeur par le y mis dans le tableau pour le premier point
    mov r10d, [tabx + 0 * DWORD]
    mov r11d, [tabx + 0 * DWORD]
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


;||||||||||||||||||||||||||||||||||||||||||||||||||
;|||Position d'un point par rapport au triangle||||
;||||||||||||||||||||||||||||||||||||||||||||||||||

sens_triangle:
    call determiant 
    cmp rax,0
    jl triangle_direct
    jg triangle_indirect






triangle_direct:
    mov rcx, min_x
    mov rbx, min_y
    mov r8d, max_x
    mov r9d, max_y
    mov point_x, rcx
    mov point_y, rbx

    call determinant_Pab
    cmp rax,0
    jl non_colorier_td

    call determinant_Pbc
    cmp rdx,0
    jl non_colorier_td

    call determinant_Pca
    cmp rsi,0
    jl non_colorier_td

    jmp colorier_td


non_colorier_td:
    cmp rcx, r8d
    je triangle_direct

colorier_td:
    ;couleur du point 2
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x00FF00	; Couleur du crayon ; vert
    call XSetForeground

    ; Dessin d'un point vert: coordonnées (100,250)
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx, point_x	; coordonnée source en x
    mov r8d, point_y	; coordonnée source en y
    call XDrawPoint









triangle_indirect:
    mov rcx, min_x
    mov rbx, min_y
    mov r8d, max_x
    mov r9d, max_y
    mov point_x, rcx
    mov point_y, rbx

    call determinant_Pab
    cmp rax,0
    jl non_colorier_ti

    call determinant_Pbc
    cmp rdx,0
    jl non_colorier_ti

    call determinant_Pca
    cmp rsi,0
    jl non_colorier_ti

    jmp colorier_ti


non_colorier_ti:
    cmp rcx, r8d
    je triangle_indirect

colorier_ti:
    ;couleur du point 2
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x00FF00	; Couleur du crayon ; vert
    call XSetForeground

    ; Dessin d'un point vert: coordonnées (100,250)
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx, point_x	; coordonnée source en x
    mov r8d, point_y	; coordonnée source en y
    call XDrawPoint






;||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||| Fin programme |||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||

fin:
; Pour fermer le programme proprement :
mov    rax, 60         
mov    rdi, 0
syscall

ret



;||||||||||||||||||||||||||||||||||||||||||||
;|||||||||||||| Fonctions |||||||||||||||||||
;||||||||||||||||||||||||||||||||||||||||||||


global random_point
global determinant
global determinant_Pab
global determinant_Pbc
global determinant_Pac
mov rax, 0



random_point:

    rdrand ax
    jnc random_point
    div  dword[max_size]



determinant:

    push rbp
    mov rbp, rsp

    ; ===== LOCAL VARIABLES ===== ;
    ; === making space === ;
    ; 3 dwords = 12 bytes
    sub rsp, 12


    ; ===== Xba, Yba, Xbc, Ybc ===== 

    ; Xba = xa - xb
    mov eax, dword[tabx + 0 * dword]
    sub eax, dword[tabx + 1*dword]
    mov dword[rbp - DWORD * 1], eax

    ; Yba = ya - yb
    mov eax, dword[taby + 0*dword]
    sub eax, dword[taby + 1*dword]
    mov dword[rbp - DWORD * 2], eax

    
    ; Xbc = xc - xb
    mov eax, [tabx + 2*dword]
    sub eax, [tabx + 1*dword]
    mov dword[rbp - DWORD * 3], eax

    ; Ybc = yc - yb
    mov eax, [taby + 2*dword]
    sub eax, [taby + 1*dword]
    mov dword[rbp - DWORD * 4], eax


    ; ===== Xba * Ybc  &  Xbc * Yba =====
    
    ; Xba * Ybc
    mov eax, dword[rbp - DWORD * 1]
    imul eax, Dword[rbp - DWORD * 4]
    mov dword[rbp - DWORD * 5], eax

    ; Xbc * Yba
    mov eax, dword[rbp - DWORD * 3]
    imul eax, dword[rbp - DWORD * 2]
    mov dword[rbp - DWORD * 6], eax


    ; ===== (Xba * Ybc) - (Xbc * Yba) ===== 

    mov eax, dword[rbp - DWORD * 5]
    mov ebx, dword[rbp - DWORD * 6]
    sub rax, rbx

    ; ===== END ===== 

mov rsp, rbp
pop rbp



determinant_Pab:

    push rbp
    mov rbp, rsp

    ; ===== LOCAL VARIABLES ===== ;
    ; === making space === ;
    ; 3 dwords = 12 bytes
    sub rsp, 12


    ; ===== Xab, Yab, Xap, Yap ===== 

    ; Xab = xb - xa
    mov eax, dword[tabx + 1 * dword]
    sub eax, dword[tabx + 0*dword]
    mov dword[rbp - DWORD * 1], eax

    ; Yab = yb - ya
    mov eax, dword[taby + 1*dword]
    sub eax, dword[taby + 0*dword]
    mov dword[rbp - DWORD * 2], eax

    
    ; Xap = xp - xa
    mov eax, dword[rcx]
    sub eax, [tabx + 0*dword]
    mov dword[rbp - DWORD * 3], eax

    ; Yap = yp - ya
    mov eax, dword[rbx]
    sub eax, [taby + 0*dword]
    mov dword[rbp - DWORD * 4], eax


    ; ===== Xab * Yap  &  Xap * Yab =====
    
    ; Xab * Yap
    mov eax, dword[rbp - DWORD * 1]
    imul eax, Dword[rbp - DWORD * 4]
    mov dword[rbp - DWORD * 5], eax

    ; Xap * Yab
    mov eax, dword[rbp - DWORD * 3]
    imul eax, dword[rbp - DWORD * 2]
    mov dword[rbp - DWORD * 6], eax


    ; ===== (Xab * Yap) - (Xap * Yab) ===== 

    mov eax, dword[rbp - DWORD * 5]
    mov ebx, dword[rbp - DWORD * 6]
    sub rax, rbx

    ; ===== END ===== 

mov rsp, rbp
pop rbp



determinant_Pbc:

    push rbp
    mov rbp, rsp

    ; ===== LOCAL VARIABLES ===== ;
    ; === making space === ;
    ; 3 dwords = 12 bytes
    sub rsp, 12


    ; ===== Xbc, Ybc, Xbp, Ybp ===== 

    ; Xbc = xc - xb
    mov edx, dword[tabx + 2 * dword]
    sub edx, dword[tabx + 1*dword]
    mov dword[rbp - DWORD * 1], edx

    ; Ybc = yc - yb
    mov edx, dword[taby + 2*dword]
    sub edx, dword[taby + 1*dword]
    mov dword[rbp - DWORD * 2], edx

    
    ; Xbp = xp - xb
    mov edx, dword[rcx]
    sub edx, [tabx + 1*dword]
    mov dword[rbp - DWORD * 3], edx

    ; Ybp = yp - yb
    mov edx, dword[rbx]
    sub edx, [taby + 1*dword]
    mov dword[rbp - DWORD * 4], edx


    ; ===== Xbc * Ybp  &  Xbp * Ybc =====
    
    ; Xbc * Ybp
    mov edx, dword[rbp - DWORD * 1]
    imul edx, Dword[rbp - DWORD * 4]
    mov dword[rbp - DWORD * 5], edx

    ; Xbp * Ybc
    mov edx, dword[rbp - DWORD * 3]
    imul edx, dword[rbp - DWORD * 2]
    mov dword[rbp - DWORD * 6], edx


    ; ===== (Xbc * Ybp) - (Xbp * Ybc) ===== 

    mov edx, dword[rbp - DWORD * 5]
    mov ebx, dword[rbp - DWORD * 6]
    sub rdx, rbx

    ; ===== END ===== 

mov rsp, rbp
pop rbp




determinant_Pca:

    push rbp
    mov rbp, rsp

    ; ===== LOCAL VARIABLES ===== ;
    ; === making space === ;
    ; 3 dwords = 12 bytes
    sub rsp, 12


    ; ===== Xca, Yca, Xcp, Ycp ===== 

    ; Xca = xa - xc
    mov esi, dword[tabx + 0 * dword]
    sub esi, dword[tabx + 2*dword]
    mov dword[rbp - DWORD * 1], edx

    ; Yca = xa - yc
    mov esi, dword[taby + 0*dword]
    sub esi, dword[taby + 2*dword]
    mov dword[rbp - DWORD * 2], edx

    
    ; Xcp = xp - xc
    mov esi, dword[rcx]
    sub esi, [tabx + 1*dword]
    mov dword[rbp - DWORD * 3], esi

    ; Ybp = yp - yb
    mov esi, dword[rbx]
    sub esi, [taby + 1*dword]
    mov dword[rbp - DWORD * 4], esi


    ; ===== Xca * Ycp  &  Xcp * Yca =====
    
    ; Xca * Ycp
    mov esi, dword[rbp - DWORD * 1]
    imul esi, Dword[rbp - DWORD * 4]
    mov dword[rbp - DWORD * 5], esi

    ; Xcp * Yca
    mov esi, dword[rbp - DWORD * 3]
    imul esi, dword[rbp - DWORD * 2]
    mov dword[rbp - DWORD * 6], esi


    ; ===== (Xca * Ycp) - (Xcp * Yca) ===== 

    mov esi, dword[rbp - DWORD * 5]
    mov esi, dword[rbp - DWORD * 6]
    sub rsi, rbx

    ; ===== END ===== 

mov rsp, rbp
pop rbp






ret