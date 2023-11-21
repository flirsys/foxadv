#!/bin/bash
#by FLIRSYS

RED='\e[31m'; GRN='\e[32m'; YLW='\e[33m'; BLU='\e[34m'; MGN='\e[35m'; 
CYN='\e[36m'; GRY='\e[37m'; DEF='\e[0m'; BLD='\e[1m'

main=0 #0-main;1-other

if [ ! -f money.txt ]; then money=0; else read money < money.txt; fi
if [ ! -f click.txt ]; then click=1; else read click < click.txt; fi

bar=""
for ((i=0; i<=54; i++ )) do
    bar=$bar"="
done
declare -A byte_map
for (( x=0; x<=100; x++ )); do
    for (( y=0; y<=200; y++ )); do
        byte_map[${x},${y}]="${GRN}█${DEF}"
    done
done
for (( i=0; i<=200; i++ )); do
    byte_map[0,$i]="${BLU}█${DEF}"
    byte_map[100,$i]="${BLU}█${DEF}"
    byte_map[$((1 + $RANDOM % 99)),$((1 + $RANDOM % 199))]="${YLW}█${DEF}"
done
for (( i=0; i<=100; i++ )); do
    byte_map[$i,0]="${BLU}█${DEF}"
    byte_map[$i,200]="${BLU}█${DEF}"
done

bar_top=$bar"FOXadv"
byff_map=""
player=(1 1 "${CYN}${BLD}█${DEF}")

function p_m_w(){
    x=$((player[1]));y=$((player[0]-1))
    if [ ${byte_map["${y},${x}"]} != "${BLU}█${DEF}" ]; then player=($y $x ${player[2]}); fi
}
function p_m_s(){
    x=$((player[1]));y=$((player[0]+1))
    if [ ${byte_map["${y},${x}"]} != "${BLU}█${DEF}" ]; then player=($y $x ${player[2]}); fi
}
function p_m_a(){
    x=$((player[1]-1));y=$((player[0]))
    if [ ${byte_map["${y},${x}"]} != "${BLU}█${DEF}" ]; then player=($y $x ${player[2]}); fi
}
function p_m_d(){
    x=$((player[1]+1));y=$((player[0]))
    if [ ${byte_map["${y},${x}"]} != "${BLU}█${DEF}" ]; then player=($y $x ${player[2]}); fi
}

while true; do
    byff_map=""
    x_n=0
    n_x=$((player[0]-6));e_x=$((player[0]+6))
    n_y=$((player[1]-27));e_y=$((player[1]+27))
    if [ $n_x -lt 0 ]; then n_x=0; fi
    for ((x=n_x; x<=e_x; x++)) do
        for ((y=n_y; y<=e_y; y++)) do
            if [ $x_n -ge 55 ]; then x_n=0; byff_map="${byff_map}\n"; fi
            ((x_n++))
            if [ ${player[0]} == $x ] && [ ${player[1]} == $y ]; then byff_map=$byff_map"${player[2]}"; else byff_map=$byff_map${byte_map["${x},${y}"]}; fi
        done
    done

    bar_top=$bar"\nFOXadv | Ваши деньги: $money \n$bar"
    clear
    echo -e $bar_top
    if [ $main == 0 ]; then
        echo -e $byff_map
        echo -e $bar
        echo -e "p_yx(${player[0]} ${player[1]}) l_x(${n_x} ${e_x}) l_y(${n_y} ${e_y})"
        echo -e "Управление (WASD)"
        read -n1 input; case $input in
            "p") ((money+=click));;
            "w") p_m_w;;
            "a") p_m_a;;
            "s") p_m_s;;
            "d") p_m_d;;
        esac
    fi

    echo $money > money.txt
    echo $click > click.txt
done