echo $1
sudo apt-get update -y
sudo apt install wireguard -y
sudo apt install unzip -y
sudo apt install curl -y
sudo apt install ipset -y

prom_install() {
  wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
  tar xvfz node_exporter-*.*-amd64.tar.gz
  mv node_exporter-*.*-amd64/node_exporter /usr/local/bin/
  useradd -rs /bin/false node_exporter
  cat >/etc/systemd/system/node_exporter.service <<EOF
  [Unit]
  Description=Node Exporter
  After=network.target
  [Service]  
  User=node_exporter
  Group=node_exporter
  Type=simple
  ExecStart=/usr/local/bin/node_exporter --collector.systemd
  [Install]
  WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl start node_exporter
  systemctl enable node_exporter
  wget https://ztmesh-support.s3.us-east-2.amazonaws.com/systemd_exporter
  mv systemd_exporter /usr/local/bin/
  sudo chmod +x /usr/local/bin/systemd_exporter
  cat >/etc/systemd/system/systemd_exporter.service <<'EOL'
  [Unit]  
  Description=Systemd exporter  service
  After=network.target
  [Service]      
  ExecStart=/usr/local/bin/systemd_exporter --collector.unit-whitelist=hostagent.service
  Restart=always    
  RestartSec=10    
  KillSignal=SIGINT
  SyslogIdentifier=systemd_exporter-service      
  PrivateTmp=true  
  [Install]      
  WantedBy=multi-user.target
EOL
  sudo systemctl daemon-reload
  systemctl start systemd_exporter.service
  systemctl enable systemd_exporter.service
  useradd --no-create-home --shell /bin/false prometheus
  mkdir /etc/prometheus
  mkdir /var/lib/prometheus
  mkdir /data-agent
  chown -R prometheus /data-agent
  chown prometheus:prometheus /etc/prometheus
  curl -LO https://github.com/prometheus/prometheus/releases/download/v2.32.0/prometheus-2.32.0.linux-amd64.tar.gz
  tar xvf prometheus-2.32.0.linux-amd64.tar.gz
  cp prometheus-2.32.0.linux-amd64/prometheus /usr/local/bin/
  chown prometheus:prometheus /usr/local/bin/prometheus
  sudo cp -r prometheus-2.32.0.linux-amd64/consoles /etc/prometheus
  sudo cp -r prometheus-2.32.0.linux-amd64/console_libraries /etc/prometheus
  rm -rf prometheus-2.32.0.linux-amd64.tar.gz prometheus-2.32.0.linux-amd64
  sudo chown -R prometheus:prometheus /etc/prometheus
  sudo chown -R prometheus:prometheus /var/lib/prometheus
  cat >/etc/systemd/system/prometheus.service <<'EOL'
  [Unit]
  Description=Prometheus
  Wants=network-online.target
  After=network-online.target
  [Service]
  User=prometheus
  Group=prometheus
  Type=simple
  ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries --enable-feature=agent
  [Install]
  WantedBy=multi-user.target
EOL
  wget https://ztmesh-support.s3.us-east-2.amazonaws.com/service-connector/prometheus-"$1".yml
  IP="$(wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4)"
  REG="$(wget -q -O - http://169.254.169.254/latest/meta-data/placement/region)"
  if [[ $IP -eq "" ]]; then
    IP=$(curl ifconfig.me)
    sed -i "s/node: .*/node: $IP/g" prometheus-"$1".yml
  else
   sed -i "s/node: .*/node: $IP-$REG/g" prometheus-"$1".yml
  fi
  sudo mv prometheus-"$1".yml prometheus.yml
  sudo mv prometheus.yml /etc/prometheus/
  sudo systemctl daemon-reload
  sudo systemctl start prometheus
  sudo systemctl enable prometheus
}



if [[ $# -eq 0 ]] ; then
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/host-agent-latest-demo.zip
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/host-agent-cli-latest-demo.zip
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent_remove.sh
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent.service
    sudo unzip -o host-agent-latest-demo.zip -d /usr/local/bin/
    sudo unzip -o host-agent-cli-latest-demo.zip -d /usr/local/bin/
     
    ENV=`cat /usr/local/bin/.env`
    echo $ENV
    prom_install $ENV

           
    mkdir -p /root/.host-agent
    sudo mv /usr/local/bin/hostagent.version /root/.host-agent/version
    sudo mv hostagent_remove.sh /usr/local/bin/
    sudo mv hostagent.service /etc/systemd/system
        
    sudo systemctl daemon-reload
    sudo systemctl enable hostagent.service
    sudo sed -i 's@#net.ipv4.ip_forward=1@'"net.ipv4.ip_forward=1"'@' /etc/sysctl.conf
    sudo sysctl -p
    sudo rm host-agent-*.zip
    exit 1
cat fi

if [[ $# -eq 1 ]] ; then
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/host-agent-latest-$1.zip
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/host-agent-cli-latest-$1.zip
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent_remove.sh
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent.service

    sudo unzip -o host-agent-latest-$1.zip -d /usr/local/bin/
    sudo unzip -o host-agent-cli-latest-$1.zip -d /usr/local/bin/
    ENV=`cat /usr/local/bin/.env`
    echo $ENV
    prom_install $ENV

    mkdir -p /root/.host-agent
    sudo mv /usr/local/bin/hostagent.version /root/.host-agent/version
    sudo mv hostagent_remove.sh /usr/local/bin/
    sudo mv hostagent.service /etc/systemd/system
    
    sudo systemctl daemon-reload
    sudo systemctl enable hostagent.service
    sudo sed -i 's@#net.ipv4.ip_forward=1@'"net.ipv4.ip_forward=1"'@' /etc/sysctl.conf
    sudo sysctl -p
    sudo rm host-agent-*.zip
fi

if [[ $# -eq 2 ]] ; then
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/host-agent-$1-$2.zip
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/host-agent-cli-$1-$2.zip
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent_remove.sh
    wget https://en-host-agent.s3.us-east-2.amazonaws.com/hostagent.service

    sudo unzip -o host-agent-$1-$2.zip -d /usr/local/bin/
    sudo unzip -o host-agent-cli-$1-$2.zip -d /usr/local/bin/
    
    ENV=`cat /usr/local/bin/.env`
    echo $ENV
    prom_install $ENV

    mkdir -p /root/.host-agent
    sudo mv /usr/local/bin/hostagent.version /root/.host-agent/version
    sudo mv hostagent_remove.sh /usr/local/bin/
    sudo mv hostagent.service /etc/systemd/system
    
    sudo systemctl daemon-reload
    sudo systemctl enable hostagent.service
    sudo sed -i 's@#net.ipv4.ip_forward=1@'"net.ipv4.ip_forward=1"'@' /etc/sysctl.conf
    sudo sysctl -p
    sudo rm host-agent-*.zip
fi 
