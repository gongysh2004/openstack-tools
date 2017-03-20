# vmping netname pingcount vm1ip vm2ip ...
networkname=
pingcount=-1
vmips=() 
let i=1
while [ $# -gt 0 ]
do
if [[ x"$networkname"y == "xy" ]]; then
    networkname=$1
elif [[ x"$pingcount"y == "x-1y" ]]; then
    pingcount=$1
else
    vmips+=($1)
fi
let i=$i+1
shift
done
if [[ x"$networkname"y == "xy" ]]; then
    echo "Must specify a network name"
    exit 1
fi
if [[ x"${#vmips[@]}"y == "x0y" ]]; then
    echo "Must specify at lease one VM IP to ping"
    exit 1
fi
netid=`openstack network show $networkname -c id -f value`
if [[ "$?" != "0" ]]; then
    echo "fail to get net id for $networkname"
    exit 1
fi
if [[ "$pingcount" == "0" ]]; then
    pingc=""
else
    pingc="-c $pingcount"
fi
for vmip in "${vmips[@]}"; do
   echo -e "ping $vmip..\n"
   sudo ip netns exec qdhcp-$netid ping $pingc $vmip
done
