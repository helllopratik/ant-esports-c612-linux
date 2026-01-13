#!/usr/bin/env bash

# ================== COLOR DEFINITIONS ==================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# ================== FUNCTIONS ==================
info()    { echo -e "${BLUE}${BOLD}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${RESET}   $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[WARN]${RESET} $1"; }
error()   { echo -e "${RED}${BOLD}[ERROR]${RESET} $1"; exit 1; }

# ================== ROOT CHECK ==================
if [[ $EUID -ne 0 ]]; then
  error "Please run this script as root (use sudo)."
fi

# ================== START ==================
echo -e "${CYAN}${BOLD}"
echo "=============================================="
echo " Ant Esports C612 Linux Background Installer "
echo "=============================================="
echo -e "${RESET}"

# ================== STEP 1: DEPENDENCIES ==================
info "Installing required dependencies (hidapi, lm-sensors, gcc)..."

if command -v apt &>/dev/null; then
  apt update && apt install -y libhidapi-dev lm-sensors gcc
elif command -v pacman &>/dev/null; then
  pacman -Sy --noconfirm hidapi lm_sensors gcc
elif command -v dnf &>/dev/null; then
  dnf install -y hidapi-devel lm_sensors gcc
else
  error "Unsupported package manager. Install dependencies manually."
fi

success "Dependencies installed."

# ================== STEP 2: SENSORS ==================
info "Ensuring lm-sensors is configured..."
sensors &>/dev/null || warn "Run 'sudo sensors-detect' later if temperature is not detected."

# ================== STEP 3: BUILD ==================
info "Compiling ant_c612_temp.c..."

if [[ ! -f ant_c612_temp.c ]]; then
  error "ant_c612_temp.c not found in current directory."
fi

gcc ant_c612_temp.c -o ant_c612_temp -lhidapi-hidraw \
  || error "Compilation failed."

success "Compilation successful."

# ================== STEP 4: INSTALL BINARY ==================
info "Installing binary to /usr/local/bin..."

install -m 755 ant_c612_temp /usr/local/bin/ant_c612_temp \
  || error "Failed to install binary."

success "Binary installed."

# ================== STEP 5: SYSTEMD SERVICE ==================
info "Creating systemd service..."

SERVICE_FILE="/etc/systemd/system/ant-c612.service"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Ant Esports C612 CPU Temperature Display (Unofficial)
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/local/bin/ant_c612_temp
Restart=always
RestartSec=2
User=root
NoNewPrivileges=true
ProtectSystem=full
ProtectHome=true

[Install]
WantedBy=multi-user.target
EOF

success "Systemd service created."

# ================== STEP 6: ENABLE SERVICE ==================
info "Enabling service to start on boot..."

systemctl daemon-reload
systemctl enable ant-c612.service

success "Service enabled at startup."

# ================== STEP 7: START SERVICE ==================
info "Starting service now..."

systemctl start ant-c612.service

sleep 1

if systemctl is-active --quiet ant-c612.service; then
  success "Service is running in background."
else
  error "Service failed to start. Check: systemctl status ant-c612.service"
fi

# ================== DONE ==================
echo
echo -e "${GREEN}${BOLD}Installation complete!${RESET}"
echo -e "${CYAN}✔ Runs automatically on boot"
echo -e "✔ No terminal needed"
echo -e "✔ CPU temperature now updates on display${RESET}"
echo
