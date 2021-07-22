projectDirs=( "/media/shared/codebase" "/home/cpt-n3m0/projects" )
notifs=( )
outputfile='/tmp/gitstatuses'

for d in "${projectDirs[@]}"
do
  cd $d
  for p in $(ls -d */)
  do
    cd $p
    if test -d ".git"
    then

      tmpout=/tmp/gitProjectsStatusesOut
      git status > /tmp/gpso
      egrep '^Changes not staged for commit:$' /tmp/gpso > $tmpout

      while read s; do
        notifs+=("$s $d/$p")
      done < $tmpout
    fi
    cd ..
  done
done
echo > $outputfile
if [ ${#notifs[@]} -eq 0 ]
then
  printf "  All projects are in order"
else
  for s in "${notifs[@]}"
  do
    printf "  * $s\n" >> $outputfile
  done
fi
