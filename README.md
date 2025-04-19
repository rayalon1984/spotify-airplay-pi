Spotify Airplay Pi Setup

This guide walks you through setting up your Raspberry Pi as a Spotify Connect and AirPlay compatible speaker using a custom Librespot build that supports Zeroconf broadcasting for all network users.

⸻

1. Clone and build the Librespot binary with libmdns support

sudo apt update && sudo apt install -y libasound2-dev libavahi-client-dev libssl-dev build-essential git curl pkg-config

cd ~
git clone https://github.com/rayalon1984/spotify-airplay-pi.git
cd spotify-airplay-pi

# Build with libmdns
ZC_BACKEND=libmdns cargo build --release \
  --no-default-features \
  --features "librespot-playback/alsa-backend with-libmdns"

# Install to home
cp ./target/release/librespot ~/librespot
chmod +x ~/librespot



⸻

2. Create the systemd user service

mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/librespot.service

Paste:

[Unit]
Description=Librespot - Spotify Connect for Pi
After=network.target sound.target

[Service]
ExecStart=/home/pi/librespot \
  --name "Pi" \
  --backend alsa \
  --device hw:0,0 \
  --bitrate 320 \
  --volume-ctrl linear \
  --disable-audio-cache \
  --cache /home/pi/.cache/librespot \
  --zeroconf-backend libmdns

Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target



⸻

3. Enable and start the service

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now librespot.service
sudo loginctl enable-linger pi



⸻

4. Authenticate with Spotify via OAuth

Run manually (only once per device):

~/librespot \
  --name "Pi" \
  --backend alsa \
  --device hw:0,0 \
  --bitrate 320 \
  --volume-ctrl linear \
  --disable-audio-cache \
  --cache ~/.cache/librespot \
  --zeroconf-backend libmdns \
  --enable-oauth \
  --oauth-port 5597

Paste the link shown in the terminal into your browser, approve, and you’re done.

Credentials are saved to ~/.cache/librespot/credentials.json.

⸻

5. Verify visibility on the network

avahi-browse -rt _spotify-connect._tcp

You should see your Pi listed with name Pi, visible to all Spotify accounts in the same LAN.

⸻

6. Optional install script

You can use this on new Raspberry Pis to repeat the process automatically:

Install script:
https://github.com/rayalon1984/spotify-airplay-pi/blob/main/install.sh
⸻

Troubleshooting
	•	Device not visible: Ensure avahi-daemon is running.
	•	Port conflicts: Use --zeroconf-port 57621 if needed.
	•	Log viewer: journalctl --user -u librespot.service -f
	•	Different Pi user: Adjust /home/pi to your username.

⸻

Author

rayalon1984
https://github.com/rayalon1984/spotify-airplay-pi
