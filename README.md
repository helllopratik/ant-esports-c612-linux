# Ant Esports C612 Linux Temperature Display

An **unofficial Linux utility** to display real-time CPU temperature on the  
**Ant Esports C612 CPU cooler digital display**.

This project enables the cooler’s display **without Windows software** by
communicating directly with the device over USB HID.

> [!CAUTION]
>This project is **not affiliated with or endorsed by Ant Esports**.


---

## ✨ Features

- Live CPU temperature display
- No background Windows software required
- Uses standard Linux tools (`hidapi`, `lm-sensors`)
- Lightweight CLI application
- Stable, continuous updates
- Works on X11 / Wayland / headless systems

---

## 🧩 Supported Device

- **Ant Esports C612**
  - USB VID:PID → `5131:2007`
  - Digital display (temperature only, white color)

---

## 🚫 Limitations (Hardware)

Due to hardware and firmware limitations of the C612:

- ❌ Display color cannot be changed (white only)
- ❌ Branding / text cannot be modified
- ❌ Custom graphics are not supported

The display supports **numeric temperature only**.

---

## 📜 Quick Installation
```bash
chmod +x install-ant-c612.sh
sudo ./install-ant-c612.sh
```

## 🔧 Dependencies

Install required packages:

### Ubuntu / Debian
```bash
sudo apt update
sudo apt install -y libhidapi-dev lm-sensors gcc
```

### Arch Linux
```bash
sudo pacman -S hidapi lm_sensors gcc
```

### Fedora
```bash
sudo dnf install hidapi-devel lm_sensors gcc
```
## 🧪 Enable Sensors (Required Once)
```bash
sudo sensors-detect
```
Accept defaults and reboot if prompted.
## ✅ Verify
```bash
sensors
```
## 🛠 Build
```bash
gcc ant_c612_temp.c -o ant_c612_temp -lhidapi-hidraw
```
## ▶ Run
```bash
sudo ./ant_c612_temp
```
You should immediately see the CPU temperature update on the cooler display.

## 🔍 If the Program Fails to Open the Device
1️⃣ Find USB VID & PID
```bash
lsusb
```
Example Output
```yaml
Bus 001 Device 004: ID 5131:2007 MSR MSR-101U Mini HID magnetic card reader
```
If your VID:PID is different, Edit the values in the source code and Recompile.

2️⃣ Check HID device nodes
```bash
sudo ls -l /dev/hidraw*
```
## 🔐 Optional: Run Without sudo (udev rule)

Create a rule:
```bash
sudo nano /etc/udev/rules.d/99-ant-c612.rules
```
Add:
```bash
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="5131", ATTRS{idProduct}=="2007", MODE="0666"
```
Reload:
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```
## 📂 Project Files

ant_c612_temp.c — main source code 

README.md — documentation 

compatible.txt — tested / compatible devices 

LICENSE — MIT License

## ⚖️ Legal Notice

This software is a clean-room, community-developed project created for
interoperability with hardware already owned by the user.

No proprietary code, firmware, or binaries are included.


