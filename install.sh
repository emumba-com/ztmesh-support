#/bin/bash
if [ "$1" == "staging" ]; then
   curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/hostagent_install_0.0.1.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t
else
   echo $1
fi 

 
