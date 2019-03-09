#!/bin/bash
folderName=$1
executable=$2

if [ ! -f Makefile ]; then
echo "Makefile does not exist!"
exit 7
fi

cd $folderName
make
secssesfullmake=$?

if [ $secssesfullMake -eq 0 ]; then
echo "Compilation fail"
exit 7
fi

valgrind --leak-check=full --error-exitcode=3 ./$executable
valgridgout=$?
valgrind --tool=helgrind --error-exitcode=3 ./$executable
helgrindout=$?

echo "Compilation| Memory leaks| thread race" 

if [[ $valgridgout -ne 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     PASS    |     PASS   " 
exit 0
fi

if [[ $valgridgout -eq 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     FAIL    |     PASS   " 
exit 1
fi

if [[ $valgridgout -ne 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     PASS    |     FAIL   " 
exit 2
fi

if [[ $valgridgout -eq 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     FAIL    |     FAIL   " 
exit 3
fi



