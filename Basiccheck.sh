

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
$ans=7
echo $ans
exit $ans
fi

valgrind --leak-check=full --error-exitcode=3  ./$executable 
valgridgout=$?
valgrind --tool=helgrind --error-exitcode=3 ./$executable 
helgrindout=$?

echo "Compilation| Memory leaks| thread race" 

if [[ $valgridgout -ne 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     PASS    |     PASS   " 
cd $currentfolder
$ans=0
echo $ans
exit 0
fi

if [[ $valgridgout -eq 3 && $helgrindout -ne 3 ]]; then
echo "    PASS   |     FAIL    |     PASS   " 
cd $currentfolder
$ans=1
echo $ans
exit 1
fi

if [[ $valgridgout -ne 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     PASS    |     FAIL   " 
cd $currentfolder
$ans=2
echo $ans
exit 2
fi

if [[ $valgridgout -eq 3 && $helgrindout -eq 3 ]]; then
echo "    PASS   |     FAIL    |     FAIL   " 
cd $currentfolder
$ans=3
echo $ans
exit 3
fi



