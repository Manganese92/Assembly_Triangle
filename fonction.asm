
max_size 400

global random_point

random_point:

    move dx,max_size
    rdrand ax
    cmp CF,1
    jne rander_point ; est-ce possible ?
    div  dx




ret