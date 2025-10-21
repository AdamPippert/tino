# Tino - an Omarchy inspired Fedora Spin - multi-arch (aarch64 + x86_64) Hyprland/Wayland
# Targeted for UTM on Apple Silicon, AMD Strix Halo, and RK3588 (Orange Pi 5).
# Lean defaults; per-arch firmware in %post; SDDM (Wayland) + Hyprland session.

# ----- Install basics -----
lang en_US.UTF-8
keyboard us
timezone UTC --utc
rootpw --lock
services --enabled=NetworkManager,sshd,power-profiles-daemon,sddm --disabled=cups,pcscd,abrt-journal-core,abrt-oops,abrt-xorg,ModemManager
firewall --enabled --service=ssh
selinux --enforcing
bootloader --timeout=1
# For live ISO composes, anaconda/lorax will inject appropriate bootloader bits.

# Partitioning (for installed systems; live ISO will ignore and use squashfs)
zerombr
clearpart --all --initlabel
part /boot/efi --fstype=efi --size=600
part /boot     --fstype=ext4 --size=1024
part swap      --size=2048
part /         --fstype=ext4 --grow --size=8192

# Optional test user (commented). Uncomment for pre-created VM login.
# user --name=omarchy --groups=wheel --password=omarchy --plaintext

# Network
network --bootproto=dhcp --hostname=omarchy

# ----- Packages -----
%packages
@core
# Desktop & compositor
hyprland
sddm
xdg-desktop-portal
xdg-desktop-portal-wlr
wl-clipboard
wlr-randr
waybar
foot

# Audio / media
pipewire
pipewire-alsa
pipewire-pulseaudio
wireplumber

# Graphics / GL / Vulkan
mesa-dri-drivers
mesa-vulkan-drivers
vulkan-loader
vulkan-tools
kernel-modules-extra

# Fonts (lightweight but readable)
google-noto-sans-fonts
google-noto-sans-mono-fonts
google-noto-emoji-fonts

# Networking / Wi-Fi / BT
NetworkManager-wifi
iwd
bluez
bluez-tools

# Quality-of-life CLI
vim-minimal
nano
git
curl
wget
zip
unzip
tar
bzip2
xz

# System tools
htop
lm_sensors
fwupd
openssh-clients
rsync
jq

# For VMs and installers
qgnomeplatform-qt5
qgnomeplatform-qt6

# Remove heavy or unneeded defaults often pulled by deps
# (Livemedia will respect excludes during compose)
%end

# ----- Post-config (runs in target root) -----
%post --erroronfail --log=/root/ks-post.log
set -euxo pipefail

ARCH="$(uname -m)"

# SDDM on Wayland + default Hyprland session
mkdir -p /etc/sddm.conf.d
cat >/etc/sddm.conf.d/wayland.conf <<'EOF'
[General]
Numlock=on

[Theme]
Current=breeze

[Wayland]
CompositorCommand=/usr/bin/hyprland
SessionCommand=/usr/share/wayland-sessions/hyprland.desktop
EnableHiDPI=true
EOF

# Autologin stub (disabled). Uncomment to speed up VM testing.
# cat >/etc/sddm.conf.d/autologin.conf <<'EOF'
# [Autologin]
# User=omarchy
# Session=hyprland.desktop
# Relogin=true
# EOF

# PipeWire real-time & basics handled by Fedora defaults; ensure WirePlumber enabled
systemctl enable --now wireplumber.service || true

# Make Wayland portals default sane
mkdir -p /etc/xdg/portals
cat >/etc/xdg/portals/wlr-portals.conf <<'EOF'
[preferred]
default=xdg-desktop-portal-wlr
EOF

# Touchpad/keyboard sensible defaults via hwdb (helps embedded boards/laptops)
mkdir -p /etc/systemd/hwdb.d
cat >/etc/systemd/hwdb.d/99-omarchy-input.hwdb <<'EOF'
# Example: make caps Lock an extra Ctrl
evdev:atkbd:dmi:*
 KEYBOARD_KEY_3a=leftctrl
EOF
systemd-hwdb update || true

# Power profiles for laptops/UTM guests
systemctl enable power-profiles-daemon.service || true

# SSH for remote admin (optional: comment to disable)
systemctl enable sshd.service || true

# ------------------ Per-arch tailoring ------------------
if [ "$ARCH" = "x86_64" ]; then
  # AMD GPUs (Strix Halo): ensure firmware present for latest kernels
  dnf -y install linux-firmware amdgpu-firmware || true
  # Vulkan ICDs generally covered by mesa-vulkan-drivers
fi

if [ "$ARCH" = "aarch64" ]; then
  # Orange Pi 5 / RK3588: panfrost driver in kernel + mesa. Pull rockchip bits.
  # Some boards use extra firmware packages; install broadly but harmlessly in VMs.
  dnf -y install linux-firmware firmware-rockchip || true
  # Bluetooth stacks are variable across boards; include tools already.
fi

# UTM detection tweaks (cosmetic): if running under QEMU/UTM, prefer virtio.
if dmidecode -s system-product-name 2>/dev/null | grep -qi 'QEMU' ; then
  # Ensure virtualized time sync is fast
  systemctl enable systemd-timesyncd.service || true
fi

# Trim & journald limits to keep root small
cat >/etc/systemd/journald.conf.d/omarchy.conf <<'EOF'
[Journal]
SystemMaxUse=200M
RuntimeMaxUse=100M
EOF

# dnf: keep cache small on installed systems (builder nodes will override)
echo 'keepcache=False' >> /etc/dnf/dnf.conf

%end

# ----- Desktop first boot tweaks (tiny) -----
%post --nochroot
set -euxo pipefail
# Nothing host-side yet; kept for future live-image brand assets.
%end

# ----- Reboot -----
reboot
