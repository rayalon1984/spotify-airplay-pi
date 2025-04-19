#!/bin/bash

set -e

echo ">>> Cloning Librespot legacy build with libmdns support..."
git clone https://github.com/rayalon1984/spotify-airplay-pi.git ~/spotify-airplay-pi
cd ~/spotify-airplay-pi

echo ">>> Building Librespot..."
ZC_BACKEND=libmdns cargo build --release \
  --no-default-features \
  --features "librespot-playback/alsa-backend with-libmdns"

echo ">>> Installing binary..."
cp ./target/release/librespot ~/librespot
chmod +x ~/librespot

echo ">>> Creating systemd service..."
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/librespot.service <<EOF
[Unit]
Description=Librespot - Spotify Connect for Pi
After=network.target sound.target

[Service]
ExecStart=/home/pi/librespot \\
  --name "Pi" \\
  --backend alsa \\
  --device hw:0,0 \\
  --bitrate 320 \\
  --volume-ctrl linear \\
  --disable-audio-cache \\
  --cache /home/pi/.cache/librespot \\
  --zeroconf-backend libmdns

Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

echo ">>> Enabling librespot systemd service..."
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now librespot.service
sudo loginctl enable-linger pi

echo ">>> Done! Device should now be visible to all Spotify accounts on the network."
