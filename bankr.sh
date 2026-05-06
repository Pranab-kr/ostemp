#!/bin/bash

echo "Enter number of processes"
read n

echo "Enter number of resources"
read m

# Allocation Matrix
echo "Enter Allocation Matrix"
for ((i=0;i<n;i++))
do
    for ((j=0;j<m;j++))
    do
        read alloc[$i,$j]
    done
done

# Maximum Matrix
echo "Enter Maximum Matrix"
for ((i=0;i<n;i++))
do
    for ((j=0;j<m;j++))
    do
        read max[$i,$j]
    done
done

# Available Resources
echo "Enter Available Resources"
for ((j=0;j<m;j++))
do
    read avail[$j]
done

# Calculate Need Matrix = Max - Allocation
for ((i=0;i<n;i++))
do
    for ((j=0;j<m;j++))
    do
        need[$i,$j]=$(( ${max[$i,$j]} - ${alloc[$i,$j]} ))
    done
done

# Initialize finish array
for ((i=0;i<n;i++))
do
    finish[$i]=0
done

count=0

echo "Safe sequence is:"

while [ $count -lt $n ]
do
    found=0

    for ((i=0;i<n;i++))
    do
        if [ ${finish[$i]} -eq 0 ]
        then
            flag=0

            for ((j=0;j<m;j++))
            do
                if [ ${need[$i,$j]} -gt ${avail[$j]} ]
                then
                    flag=1
                    break
                fi
            done

            if [ $flag -eq 0 ]
            then
                echo -n "P$i "

                for ((k=0;k<m;k++))
                do
                    avail[$k]=$(( ${avail[$k]} + ${alloc[$i,$k]} ))
                done

                finish[$i]=1
                found=1
                count=$((count + 1))
            fi
        fi
    done

    if [ $found -eq 0 ]
    then
        echo -e "\nSystem is NOT in safe state"
        exit 1
    fi
done

echo -e "\nSystem is in SAFE state"
