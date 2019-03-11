

#!/bin/bash

#Ester Reznikov 315674028
#Yaara Goldenberg 308529296
folderName=$1
executable=$2
currentfolder=$(pwd)

exit 0


cd $folderName
make
secssesfullmake=$?

if [[ $secssesfullMake -ne 0 ]]; then
echo "Compilation fail"
cd $currentfolder
exit 7
fi

valgrind --leak-check=full --error-exitcode=3  ./$executable @$2 >/dev/null 2>/dev/null
valgridgout=$?
valgrind --tool=helgrind --error-exitcode=3 ./$executable @$2 >/dev/null 2>/dev/null
helgrindout=$?

echo "Compilation| Memory leaks| thread race" 

if [[ $valgridgout -ne 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     PASS    |     PASS   " 
cd $currentfolder
exit 0
fi

if [[ $valgridgout -eq 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     FAIL    |     PASS   " 
cd $currentfolder
exit 1
fi

if [[ $valgridgout -ne 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     PASS    |     FAIL   " 
cd $currentfolder
exit 2
fi

if [[ $valgridgout -eq 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     FAIL    |     FAIL   " 
cd $currentfolder
exit 3
fi



