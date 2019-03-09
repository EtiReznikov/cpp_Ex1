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
echo "Compilation"
echo "   fail"
exit 7
fi

valgrind --leak-check=full --error-exitcode=3 ./$executable
valgridgout=$?
valgrind --tool=helgrind  ./$executable
helgrindout=$?



echo "Compilation| Memory leaks| thread race" 

if [[ $valgridgout -ne 3 && $helgrindout -eq 0 ]]; then
echo "    pass   |     pass    |     pass   " 
exit 0
fi

if [[ $valgridgout -eq 3 && $helgrindout -eq 0 ]]; then
echo "    pass   |     fail    |     pass   " 
exit 1
fi

if [[ $valgridgout -ne 3 && $helgrindout -ne 0 ]]; then
echo "    pass   |     pass    |     fail   " 
exit 2
fi

if [[ $valgridgout -eq 3 && $helgrindout -ne 0 ]]; then
echo "    pass   |     fail    |     fail   " 
exit 3
fi



