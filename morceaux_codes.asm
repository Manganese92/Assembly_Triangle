section .data
  ; Tableaux contenant les coordonnées x et y des points a et b
  tabx dd 14, 25
  taby dd 20, 69

section .text
  global _start

  _start:
    ; Initialisation des registres
    mov esi, tabx ; Pointeur vers le tableau des coordonnées x
    mov edi, taby ; Pointeur vers le tableau des coordonnées y
    movd xmm0, dword [esi] ; Chargement de xa dans xmm0
    movd xmm1, dword [edi] ; Chargement de ya dans xmm1

    ; Boucle pour parcourir tous les points dans la plage xmin-ymin à xmax-ymax
    mov eax, ebx ; Copie de xmin dans eax
    boucle_y:
      cmp eax, ecx ; Comparaison avec xmax
      jg fin_boucle ; Fin de la boucle si on a atteint xmax

      mov ebx, edx ; Copie de ymin dans ebx
      boucle_x:
        cmp ebx, esi ; Comparaison avec ymax
        jg fin_ligne ; Fin de la ligne si on a atteint ymax

        ; Calcul du déterminant pour les points a et b
        sub dword [esi], xmm0 ; xb = xa - xb
        sub dword [edi], xmm1 ; yb = ya - yb
        imul eax, edi ; xa * yb
        imul ebx, esi ; xb * ya
        sub eax, ebx ; xa * yb - xb * ya

        ; Affichage du déterminant
        mov esi, eax ; Déplacement du déterminant dans esi
        mov eax, 4 ; Code pour l'appel système write
        mov ebx, 1 ; Descripteur de fichier (stdout)
        mov ecx, msg ; Pointeur vers le message
        mov edx, msglen ; Longueur du message
        int 0x80 ; Appel système write
        mov eax, 4 ; Code pour l'appel système write
        mov ebx, 1 ; Descripteur de fichier (stdout)
        mov ecx, newline ; Pointeur vers le caractère de nouvelle ligne
        mov edx, 1 ; Longueur du caractère de nouvelle ligne
        int 0x80 ; Appel système write

        ; Réinitialisation des coordonnées des points a et b
        mov esi, tabx ; Pointeur vers le tableau des coordonnées x
        mov edi, taby ; Pointeur vers le tableau des coordonnées y
        movd xmm0, dword [esi] ; Chargement de xa dans xmm0
        movd xmm1, dword [edi] ; Chargement de ya dans xmm1

        ; Incrémentation de la coordonnée y
        add ebx, 1
        jmp boucle_x

      fin_ligne:
        ; Réinitialisation de la coordonnée y et incrémentation de la coordonnée x
        mov ebx, edx ; Copie de ymin dans ebx
        add eax, 
