# Ant Esports C612 Linux Temperature Display

An **unofficial Linux utility** to display real-time CPU temperature on the  
**Ant Esports C612 CPU cooler digital display**.

This project enables the cooler’s display **without Windows software** by
communicating directly with the device over USB HID.

> ⚠️ This project is **not affiliated with or endorsed by Ant Esports**.

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

## 🔧 Dependencies

Install required packages:

### Ubuntu / Debian
```bash
sudo apt update
sudo apt install -y libhidapi-dev lm-sensors gcc
