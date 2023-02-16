#!/bin/bash

dir=$1
dest=$2

for file in `ls $dir` ; do
   if test -d $dir/$file ; then

     if test -d $dir/.$file.directory ; then
        mkdir $dest/$file
         $0 $dir/.$file.directory $dest/$file
     fi

     echo  "$dir/$file --> $dest/$file.mbox"
     python ~/bin/maildir2mbox.py $dir/$file > $dest/$file.mbox
   fi
done

