

#!/bin/bash


folderName=$1
executable=$2
currentfolder=$(pwd)

ans=7

Compliation="FAIL"
Memory_leaks="FAIL"
Thread_race="FAIL"

cd $folderName

if [ -f Makefile ]; then

make > /dev/null 2&>1
secssesfullmake=$?

if [[ $secssesfullMake -eq 0 ]]; then
valgrind --leak-check=full --error-exitcode=1  ./$executable "${@:2}" > /dev/null 2&>1
  valgridgout=$?
valgrind --tool=helgrind --error-exitcode=1 ./$executable "${@:2}"> /dev/null 2&>1
  helgrindout=$?

   if [[ $valgridgout -ne 1 && $helgrindout -ne 1 ]]; then
    Compliation="PASS"
    Memory_leaks="PASS"
    Thread_race="PASS"
    ans=0
   

   elif [[ $valgridgout -eq 1 && $helgrindout -ne 1 ]]; then
    Compliation="PASS"
    Memory_leaks="FAIL"
    Thread_race="PASS"
    ans=2
   

   elif [[ $valgridgout -ne 1 && $helgrindout -eq 1 ]]; then
    Compliation="PASS"
    Memory_leaks="PASS"
    Thread_race="FAIL"
    ans=1
   

   elif [[ $valgridgout -eq 1 && $helgrindout -eq 1 ]]; then
    Compliation="PASS"
    Memory_leaks="FAIL"
    Thread_race="FAIL"
    ans=3
   
  fi

 fi
fi
cd $currentfolder
echo "Compilation| Memory leaks| thread race" 
echo "    "$Compliation"   |     "$Memory_leaks"    |     "$Thread_race"   " 
exit $ans



