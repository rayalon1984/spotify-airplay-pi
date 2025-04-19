## ✅ Setup Summary Table (for Confluence or README)

| Step | Description | Command / Notes |
|------|-------------|-----------------|
| 1️⃣ | Clone repo | `git clone https://github.com/rayalon1984/spotify-airplay-pi ~/spotify-airplay-pi` |
| 2️⃣ | Build Librespot with libmdns | `ZC_BACKEND=libmdns cargo build --release --no-default-features --features "librespot-playback/alsa-backend with-libmdns"` |
| 3️⃣ | Copy binary | `cp ./target/release/librespot ~/librespot && chmod +x ~/librespot` |
| 4️⃣ | Create systemd service | Copy `systemd/librespot.service` to `~/.config/systemd/user/` |
| 5️⃣ | Enable service | `systemctl --user daemon-reexec && systemctl --user daemon-reload && systemctl --user enable --now librespot.service` |
| 6️⃣ | Authenticate via OAuth | Run librespot manually with `--enable-oauth`, open the URL shown, approve |
| 7️⃣ | Enable crash monitor | Copy `systemd/librespot-check.*` and `scripts/librespot-check.sh`, then run:<br>`systemctl --user enable --now librespot-check.timer` |
| 8️⃣ | Enable linger mode | `sudo loginctl enable-linger pi` (only once per user) |
| 9️⃣ | Verify on network | `avahi-browse -rt _spotify-connect._tcp` |
| ✅ | Done | The Pi should now appear to all users on the local network |
