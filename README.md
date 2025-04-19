<<<<<<< Updated upstream
# 🎶 Spotify Airplay Pi Setup

Turn your Raspberry Pi into a **Spotify Connect** + **AirPlay-compatible** speaker.  
This custom `librespot` build includes Zeroconf (`libmdns`) support so **all users on your LAN** can discover and use it — no matter their Spotify account.

---

## ✅ Required Packages

| Package              | Purpose                             | Install Command                 |
|---------------------|-------------------------------------|----------------------------------|
| `🟢 git`             | Clone the repository                | `sudo apt install git`           |
| `🛠️ build-essential` | Compiler tools (gcc, make, etc.)    | `sudo apt install build-essential` |
| `🎧 libasound2-dev`  | ALSA audio backend support          | `sudo apt install libasound2-dev` |
| `📡 avahi-daemon`    | Zeroconf (mDNS) broadcasting        | `sudo apt install avahi-daemon`  |
| `🧰 pkg-config`      | Build helper for Rust crates        | `sudo apt install pkg-config`    |
| `🔐 libssl-dev`      | TLS libraries                       | `sudo apt install libssl-dev`    |
| `🌐 curl`            | Fetch and install Rust              | `sudo apt install curl`          |

> **Install all at once:**
```bash
sudo apt update && sudo apt install git build-essential libasound2-dev avahi-daemon pkg-config libssl-dev curl
```

---

## 🦀 Install Rust (with rustup)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

---

## ⚡ TL;DR: Quick Install Script

Use the auto-setup script on new Raspberry Pis:

[**install.sh**](https://github.com/rayalon1984/spotify-airplay-pi/blob/main/install.sh)

```bash
curl -sL https://raw.githubusercontent.com/rayalon1984/spotify-airplay-pi/main/install.sh | bash
```

---

## 🧑‍💻 Manual Step-by-Step Install

### 1. Clone & Build Librespot

```bash
cd ~
git clone https://github.com/rayalon1984/spotify-airplay-pi.git
cd spotify-airplay-pi

ZC_BACKEND=libmdns cargo build --release \
  --no-default-features \
  --features "librespot-playback/alsa-backend with-libmdns"

cp ./target/release/librespot ~/librespot
chmod +x ~/librespot
```

---

### 2. Create the systemd user service

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/librespot.service
```

Paste:

```ini
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
```

---

### 3. Enable and start the service

```bash
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now librespot.service
sudo loginctl enable-linger pi
```

---

### 4. Authenticate via Spotify OAuth (once per device)

```bash
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
```

Paste the URL into your browser and approve access.  
Your credentials will be saved to `~/.cache/librespot/credentials.json`.

---

### 5. Verify it's working

```bash
avahi-browse -rt _spotify-connect._tcp
```

Look for your `Pi` listed in the output.  
Should be visible on **any Spotify account** in the same Wi-Fi.

---

## 🛠️ Troubleshooting

- **Device not visible:** Ensure `avahi-daemon` is installed and running.
- **Spotify can’t connect:** Run OAuth manually (`--enable-oauth`).
- **Name doesn’t show:** Add `--name "MySpeaker"` to your Exec line.
- **Use custom port:** `--zeroconf-port 57621`
- **View logs:**  
  `journalctl --user -u librespot.service -f`

---

## 👤 Author

**[rayalon1984](https://github.com/rayalon1984)**  
GitHub repo: [spotify-airplay-pi](https://github.com/rayalon1984/spotify-airplay-pi)
=======
# spotify-airplay-pi

**Spotify Connect + AirPlay-compatible build of Librespot for Raspberry Pi**  
Built from a legacy `librespot` commit with full support for ALSA audio backend and Zeroconf mDNS advertising (via `libmdns`) so all users on the local network can see and use the device — even across different Spotify accounts.

## Features
- **Spotify Connect** device on your network
- **Zeroconf support** with `libmdns`, visible to all users
- **ALSA backend** for direct audio output
- Autostart using `systemd --user`

## Install (on new Raspberry Pi)

```bash
git clone https://github.com/rayalon1984/spotify-airplay-pi ~/spotify-airplay-pi
cd ~/spotify-airplay-pi

# Build Librespot with libmdns Zeroconf support
ZC_BACKEND=libmdns cargo build --release \
  --no-default-features \
  --features "librespot-playback/alsa-backend with-libmdns"

# Install binary
cp ./target/release/librespot ~/librespot
chmod +x ~/librespot

Systemd Autostart

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

Then:

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now librespot.service
sudo loginctl enable-linger pi

Troubleshooting
	•	Make sure avahi-daemon is installed and running.
	•	For Zeroconf to be visible across accounts, --zeroconf-backend libmdns must be used.
	•	If the port is in use, try --zeroconf-port 57621.
	•	See log with: journalctl --user -u librespot.service -f

Author

github.com/rayalon1984

>>>>>>> Stashed changes
