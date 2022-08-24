#/bin/bash
if [[ $# -eq 1 ]] ; then
   if [ "$1" == "dev" ]; then
      echo "$#"
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1 
   elif [ "$1" == "staging" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.1.sh | sudo bash -s $1  

   elif [ "$1" == "qa" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1 

   elif [ "$1" == "beta" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.1.sh | sudo bash -s $1 

   elif [ "$1" == "beta01" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1

   elif [ "$1" == "qa-chaos" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1 

   elif [ "$1" == "qa-loadtesting" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1 

   elif [ "$1" == "feature-1" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1 

   else
      echo "No environment exists named $1"

   fi 
  
fi


if [[ $# -eq 2 ]] ; then

   if [ "$1" == "dev" ]; then
      echo "$#"
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1 ; sudo host-agent-cli start -c -t $2
   elif [ "$1" == "staging" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.1.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   elif [ "$1" == "qa" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   elif [ "$1" == "beta" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.1.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   elif [ "$1" == "beta01" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   elif [ "$1" == "qa-chaos" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   elif [ "$1" == "qa-loadtesting" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   elif [ "$1" == "feature-1" ]; then
      curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/host-agent/scripts/hostagent_install_0.0.2.sh | sudo bash -s $1  ; sudo host-agent-cli start -c -t $2

   else
      echo "No environment exists named $1"

   fi 
   
fi
