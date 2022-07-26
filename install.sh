
if [[ $1 -eq "dev" ]] ; then
   curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/hostagent_install_0.0.1.sh | sudo bash -s $1  ; sudo ho
st-agent-cli start -c -t
else 
   echo "No script"
fi


 
