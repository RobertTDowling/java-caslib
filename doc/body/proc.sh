#!/bin/sh

list="Variable VarSet VarMap Evec EvecMap Scalar Term Polynomial" 

for i in $list; do
    printf "%10s:" $i
    for j in $list; do
	grep $j $i.body > /dev/null && printf " %10s" $j || printf " %10s" ""
    done
    echo ""
done
