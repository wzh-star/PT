#!/bin/bash
apt -y update
apt -y upgrade
apt -y install wget
apt-get update
apt-get install python unzip python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako
wget https://down.ymgblog.com/deluge/deluge-1.3.15.zip
unzip deluge-1.3.15.zip
cd deluge-1.3.15
python setup.py build
python setup.py install --install-layout=deb
python setup.py clean -a
cd ~
touch /etc/systemd/system/deluged.service
echo "[Unit]
Description=Deluge Bittorrent Client Daemon
Documentation=man:deluged
After=network-online.target
[Service]
Type=simple
User=root
UMask=007
ExecStart=/usr/bin/deluged -d
ExecStop=/usr/bin/kill /usr/bin/deluged
Restart=on-failure
TimeoutStopSec=300
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/deluged.service
touch /etc/systemd/system/deluge-web.service
echo "[Unit]
Description=Deluge Bittorrent Client Web Interface
Documentation=man:deluge-web
After=network-online.target deluged.service
Wants=deluged.service
[Service]
Type=simple
User=root
UMask=007
ExecStart=/usr/bin/deluge-web -p 8112
ExecStop=/usr/bin/kill /usr/bin/deluge-web
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/deluge-web.service
systemctl enable deluged
systemctl enable deluge-web
systemctl start deluged
systemctl start deluge-web
echo "现在访问<http://IP地址:8112>就可以进入Deluge的WebUI.输入密码后，点击 connect 就可以连接上服务器，开始使用了.WebUI 默认密码：deluge"
echo "Finished!"
