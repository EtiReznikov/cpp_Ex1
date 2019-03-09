#!/bin/bash
folderName=$1
executable=$2
currentLocation=~pwd

cd $folderName
make
secssesfullmake=$?
if [ [$secssesfullMake == 0] ]; then
echo "Compilation- fail"
exit 7
fi

valgrind --leak-check=full --error-exitcode=1 ./$executable
valgridgout=$7
valgrind --tool=helgrind --error-exitcode=1 ./$executable
helgrindout=$7

if [[ $"valgridgout" -ne 1 && $"helgrindout" -ne 1 ]]; then
echo "Compilation- pass, Memory leaks- pass, thread race- pass" 
exit 0 

elif [[ $"valgridgout" -eq 1 && $"helgrindout" -ne 1 ]]; then
echo "Compilation- pass, Memory leaks- fail, thread race- pass" 
exit 2


elif [[ $"valgridgout" -ne 1 && $"helgrindout" -eq 1 ]]; then
echo "Compilation- pass, Memory leaks- pass, thread race- fail" 
exit 1

elif [[ $"valgridgout" -eq 1 && $"helgrindout" -eq 1 ]]; then
echo "Compilation- pass, Memory leaks- fail, thread race- fail" 
exit 3
fi

exit

