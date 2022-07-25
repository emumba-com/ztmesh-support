curl -L https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent_install_$1.sh | sudo bash -s $1 ; sudo host-agent-cli start -c -t 
