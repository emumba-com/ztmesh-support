echo ${GITHUB_REF##*/}
if [[ ${GITHUB_REF##*/} -eq "host-agent" ]]; then
   curl -L https://raw.githubusercontent.com/extremenetworks/ztmesh-support/4d65ca99ac4a30585be1fc059d3111600dde7c81/hostagent_install_0.0.1.sh | sudo bash -s $1  ; sudo ho
st-agent-cli start -c -t
fi

