sudo apt-get update -y
sudo apt install wireguard -y
sudo apt install unzip -y
sudo apt install curl -y
sudo apt install ipset -y
if [[ $# -eq 0 ]] ; then
    wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relay-agent-latest.zip
    wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relayagent_remove.sh
    wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relay-agent-cli-latest.zip
    wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relayagent.service
    
    sudo unzip -o relay-agent-latest.zip -d /usr/local/bin/
    sudo unzip -o relay-agent-cli-latest.zip -d /usr/local/bin/
    
    mkdir -p /root/.relay-agent
    sudo mv /usr/local/bin/relayagent.version /root/.relay-agent/version
    sudo mv relayagent.service /etc/systemd/system
    sudo mv relayagent_remove.sh /usr/local/bin
    
    sudo systemctl daemon-reload
    sudo systemctl enable relayagent.service
    sudo systemctl status relayagent.service
    sudo sed -i 's@#net.ipv4.ip_forward=1@'"net.ipv4.ip_forward=1"'@' /etc/sysctl.conf
    sudo sysctl -p
    
    sudo rm relay-agent-*.zip
    exit 1
fi

wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relay-agent-latest-$1.zip
wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relay-agent-cli-latest-$1.zip
wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relayagent.service
wget https://en-relay-agent.s3.us-east-2.amazonaws.com/relayagent_remove.sh
# wget https://en-relay-agent.s3.us-east-2.amazonaws.com/docker-compose.yml
# wget https://en-relay-agent.s3.us-east-2.amazonaws.com/prometheus.yml

# sudo docker-compose up -d

sudo unzip -o relay-agent-latest-$1.zip -d /usr/local/bin/
sudo unzip -o relay-agent-cli-latest-$1.zip -d /usr/local/bin/

mkdir -p /root/.relay-agent
sudo mv /usr/local/bin/relayagent.version /root/.relay-agent/version
sudo mv relayagent.service /etc/systemd/system
sudo mv relayagent_remove.sh /usr/local/bin

sudo systemctl daemon-reload
sudo systemctl enable relayagent.service
sudo systemctl status relayagent.service
sudo sed -i 's@#net.ipv4.ip_forward=1@'"net.ipv4.ip_forward=1"'@' /etc/sysctl.conf
sudo sysctl -p

sudo rm relay-agent-*.zip
