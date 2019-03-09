#!/bin/bash
folderName=$1
executable=$2
currentLocation=~pwd

if [ ! -f Makefile ]; then
    echo "Makefile does not exist!"
exit 7
fi

cd $folderName
make
secssesfullmake=$?



if [ [ $secssesfullMake == 0 ] ]; then
echo "Compilation- fail"
exit 7
fi

valgrind --leak-check=full --error-exitcode=1 ./$executable
valgridgout=$?
valgrind --tool=helgrind --error-exitcode=1 ./$executable
helgrindout=$?

if [[ $"valgridgout" -ne 1 && $"helgrindout" -ne 1 ]]; then
echo "Compilation- pass, Memory leaks- pass, thread race- pass" 
exit 0 
fi

if [[ $"valgridgout" -eq 1 && $"helgrindout" -ne 1 ]]; then
echo "Compilation- pass, Memory leaks- fail, thread race- pass" 
exit 2
fi


if [[ $"valgridgout" -ne 1 && $"helgrindout" -eq 1 ]]; then
echo "Compilation- pass, Memory leaks- pass, thread race- fail" 
exit 1
fi

if [[ $"valgridgout" -eq 1 && $"helgrindout" -eq 1 ]]; then
echo "Compilation- pass, Memory leaks- fail, thread race- fail" 
exit 3
fi



