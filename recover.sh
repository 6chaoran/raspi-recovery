# Pi Hole
echo installing pi-hole
curl -sSL https://install.pi-hole.net | bash

# lighttpd
echo enable lighttpd dir-listing
echo 'server.dir-listing = "enable"' | sudo tee -a /etc/lighttpd/external.conf
sudo systemctl restart lighttpd.service

# aria
echo installing aria2
sudo apt update
sudo apt install -y aria2

echo "continue
dir=/home/chaoran/Downloads
file-allocation=falloc
max-connection-per-server=4
max-concurrent-downloads=2
max-overall-download-limit=0
min-split-size=25M
rpc-allow-origin-all=true
rpc-secret=100200
input-file=/home/chaoran/tmp/aria2c.session
save-session=/home/chaoran/tmp/aria2c.session" > aria2.daemon
sudo mv aria2.daemon /etc

echo "# Override or Change User and Group per your local environment
[Unit]
Description=Aria2c download manager
After=network.target

[Service]
Type=simple
User=chaoran
Group=chaoran
ExecStartPre=/usr/bin/env touch /home/chaoran/tmp/aria2c.session
ExecStart=/usr/bin/aria2c --console-log-level=warn --enable-rpc --rpc-listen-all --conf-path=/etc/aria2.daemon
TimeoutStopSec=20
Restart=on-failure

[Install]
WantedBy=multi-user.target" > aria2c.service
sudo mv aria2c.service /etc/systemd/system
sudo systemctl daemon-reload

# ariang - aria UI
wget https://github.com/mayswind/AriaNg/releases/download/1.2.4/AriaNg-1.2.4-AllInOne.zip
sudo mkdir --parents /var/www/html/ariang
sudo unzip AriaNg-1.2.4-AllInOne.zip -d /var/www/html/ariang
rm AriaNg-1.2.4-AllInOne.zip 

touch /home/chaoran/tmp/aria2c.session
sudo systemctl start aria2c.service
sudo ln -s /home/chaoran/Downloads /var/www/html/
