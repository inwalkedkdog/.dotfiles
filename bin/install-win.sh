cd $SRCROOT
for i in `find . -name "*.sys" | grep amd64 | grep -v libprov | grep -v libcmuser`;
do
    echo "cp $i /tmp"
    cp $i /tmp/iot-win
done

# copy to C:\Windows\System32\drivers

