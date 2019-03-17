
#315674028 Ester Reznikov
#308529296 Yaara Goldenberg
#!/bin/bash


folderName=$1
executable=$2
currentfolder=$(pwd)

ans=7

Compliation="FAIL"
Memory_leaks="FAIL"
Thread_race="FAIL"

cd $folderName

make > /dev/null 2>&1
failedmake=$?
#Check if the MakeFile is exists and if it is compiled
if [[ $failedmake -eq 0 ]]; then
valgrind --leak-check=full --error-exitcode=1  ./$executable "${@:3}" > /dev/null 2>&1
  valgrindgout=$?
valgrind --tool=helgrind --error-exitcode=1 ./$executable "${@:3}"> /dev/null 2>&1
  helgrindout=$?

#Check if valgrind and helgrind pass
   if [[ $valgrindgout -ne 1 && $helgrindout -ne 1 ]]; then
    Compliation="PASS"
    Memory_leaks="PASS"
    Thread_race="PASS"
    ans=0
   
#Check if valgrind pass and helgrind failed
   elif [[ $valgrindgout -eq 1 && $helgrindout -ne 1 ]]; then
    Compliation="PASS"
    Memory_leaks="FAIL"
    Thread_race="PASS"
    ans=2
   
#Check if valgrind failed and helgrind pass
   elif [[ $valgrindgout -ne 1 && $helgrindout -eq 1 ]]; then
    Compliation="PASS"
    Memory_leaks="PASS"
    Thread_race="FAIL"
    ans=1
   
#Check if valgrind and helgrind failed
   elif [[ $valgrindgout -eq 1 && $helgrindout -eq 1 ]]; then
    Compliation="PASS"
    Memory_leaks="FAIL"
    Thread_race="FAIL"
    ans=3
   
  fi
fi
cd $currentfolder
echo "Compilation| Memory leaks| thread race" 
echo "    "$Compliation"   |     "$Memory_leaks"    |     "$Thread_race"   " 
exit $ans



