#!/bin/bash

clear
OLDIFS=IFS
IFS=","
INPUT=notas.csv
porcentagemTotal=100

echo "Nome da disciplina: "
read nomeDisciplina

echo "Valor nominal da Prova 1:"
read notaNominalP1

echo "Valor nominal da Prova 2:"
read notaNominalP2

echo "Valor nominal da Prova 3:"
read notaNominalP3

echo "Valor nominal da Prova 4:"
read notaNominalP4

if [ -d "boletins" ]; 
then
    rm -rf boletins
fi

[ ! -f $INPUT ] && { echo "$INPUT" file not found; exit 99; }

while read matricula nome percentualProva1 percentualProva2 percentualProva3 percentualProva4
do

    p1=$(echo $percentualProva1 $notaNominalP1 $porcentagemTotal | awk '{ printf "%.2f", ($1 * $2) / $3  }')
    p2=$(echo $percentualProva2 $notaNominalP2 $porcentagemTotal | awk '{ printf "%.2f", ($1 * $2) / $3  }')
    p3=$(echo $percentualProva3 $notaNominalP3 $porcentagemTotal | awk '{ printf "%.2f", ($1 * $2) / $3  }')
    p4=$(echo $percentualProva4 $notaNominalP4 $porcentagemTotal | awk '{ printf "%.2f", ($1 * $2) / $3  }')

    sumNotasTotal=$(($notaNominalP1 + $notaNominalP2 + $notaNominalP3 + $notaNominalP4))
    sumNotasAluno=$(echo $percentualProva1 $notaNominalP1 $percentualProva2 $notaNominalP2 $percentualProva3 $notaNominalP3 $percentualProva4 $notaNominalP4 $porcentagemTotal | awk '{ printf "%.2f", (($1 * $2) / $9) + (($3 * $4) / $9) + (($5 * $6) / $9) + (($7 * $8) / $9) }')
    mediaAluno=$(echo $percentualProva1 $notaNominalP1 $percentualProva2 $notaNominalP2 $percentualProva3 $notaNominalP3 $percentualProva4 $notaNominalP4 $porcentagemTotal | awk '{ printf "%.2f", (((($1 * $2) / $9) + (($3 * $4) / $9) + (($5 * $6) / $9) + (($7 * $8) / $9)) * ($2 + $4 + $6 + $8)) / $9 }')

    if [ ! -d "boletins" ]; 
    then
        mkdir boletins
    fi

    if [ ! -e "boletins/$matricula.txt" ]; then    
        echo "Disciplina: $nomeDisciplina" >> boletins/$matricula.txt
    fi

    echo "Aluno: $nome" >> boletins/$matricula.txt

    echo " " >> boletins/$matricula.txt

    echo "Prova 1: $p1 pontos de $notaNominalP1" >> boletins/$matricula.txt
    echo "Prova 2: $p2 pontos de $notaNominalP2" >> boletins/$matricula.txt
    echo "Prova 3: $p3 pontos de $notaNominalP3" >> boletins/$matricula.txt
    echo "Prova 4: $p4 pontos de $notaNominalP4" >> boletins/$matricula.txt
    
    echo " " >> boletins/$matricula.txt

    echo "Pontos totais: $sumNotasAluno de $sumNotasTotal pontos" >> boletins/$matricula.txt
    echo "Média: $mediaAluno% de $porcentagemTotal%" >> boletins/$matricula.txt

done < $INPUT

IFS=OLDIFS