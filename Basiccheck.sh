

#!/bin/bash


folderName=$1
executable=$2
currentfolder=$(pwd)
ans=0

cd $folderName
make
secssesfullmake=$?

if [[ $secssesfullMake -ne 0 ]]; then
echo "Compilation fail"
cd $currentfolder
ans=7
exit $ans
fi

valgrind --leak-check=full --error-exitcode=3  ./$executable > /dev/null 2&>1
valgridgout=$?
valgrind --tool=helgrind --error-exitcode=3 ./$executable > /dev/null 2&>1
helgrindout=$?

echo "Compilation| Memory leaks| thread race" 

if [[ $valgridgout -ne 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     PASS    |     PASS   " 
ans=0
fi

if [[ $valgridgout -eq 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     FAIL    |     PASS   " 
ans=1
fi

if [[ $valgridgout -ne 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     PASS    |     FAIL   " 
ans=2
fi

if [[ $valgridgout -eq 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     FAIL    |     FAIL   " 
ans=3
fi

cd $currentfolder
exit $ans



