# Fedora 44 Migration Guide

## Overview

Tino has been updated to **Fedora 44** (released April 28, 2026), bringing significant improvements in performance, security, and modern desktop technology.

## Major Changes in Fedora 44

### 1. Linux Kernel 6.19+ (Updates to 7.x)

**Initial Release**: Linux kernel 6.19  
**Current Updates**: Kernel 7.0.4 - 7.0.9+ available with security fixes

**What's New**:
- Additional hardware support for newer AMD and ARM devices
- Security fixes for multiple CVEs
- Performance improvements for Wayland compositors
- Enhanced power management for laptops and mobile devices

**Action Required**: Keep system updated with regular `dnf update` to receive latest kernel security patches.

### 2. DNF5 - Next Generation Package Manager

**Major Performance Improvement**: DNF5 is significantly faster than DNF4

**Changes**:
- Anaconda installer now uses DNF5 by default
- PackageKit backend switched to DNF5 (libdnf5)
- Parallel downloads enabled by default (10 concurrent)
- Improved dependency resolution speed
- Smaller memory footprint

**Compatibility**: All DNF4 commands work in DNF5. The `dnf` command automatically uses DNF5 in Fedora 44.

**Configuration**:
```bash
# DNF5 automatically configured in kickstart with:
max_parallel_downloads=10
keepcache=False
```

### 3. Desktop Environment Updates

- **GNOME 50**: Default for Workstation edition (Wayland-only)
- **KDE Plasma 6.6**: New Login Manager replaces SDDM in KDE variants
- **Wayland-First**: Both Budgie and KDE run Wayland by default

**Impact on Tino**: We continue using SDDM with Hyprland (not affected by KDE's switch to Plasma Login Manager).

### 4. Developer Toolchain

- **GCC 16** (prerelease): Latest compiler with improved optimization
- **Golang 1.26**: Updated Go language support
- **Python 3.13**: Latest Python runtime
- **MariaDB 11.8**: Database updates
- **Django 6.x**: Web framework updates
- **Ansible 13**: Infrastructure automation updates

### 5. Security Improvements

**Critical Security Focus**: Fedora 44 included major security fixes in its final release

**Key Updates**:
- **Firefox 150**: Closes over 200 known security vulnerabilities
- **PackageKit**: Privilege escalation patch included
- **Kernel 7.0.9**: Multiple important security fixes
- **Reproducible Builds**: Enhanced package build security

## Hyprland Compatibility

### Known Issues

**Dependency Conflicts**: Some users reported Hyprland compatibility issues after upgrading to Fedora 44 due to library updates:

- `libdisplay-info` - Display information library
- `aquamarine` - Compositor rendering library

**Mitigation Strategy**:

1. **Fresh Install Recommended**: For new systems, install Fedora 44 from scratch rather than upgrading
2. **COPR Repository**: Use the `solopasha/hyprland` or `ashbuk/Hyprland-Fedora` COPR for latest compatible builds
3. **Version Check**: Kickstart includes Hyprland version check to detect compatibility issues
4. **Rebuild Option**: If issues occur, Hyprland may need to be rebuilt against Fedora 44 libraries

### Tino's Approach

Our kickstart includes:
- Latest Hyprland from Fedora repositories (if available)
- Fallback to COPR if needed
- Version sanity check in post-install
- Warning system for potential compatibility issues

## Network Configuration Changes

**Breaking Change**: Anaconda installer behavior changed for network profiles

**Old Behavior**: Anaconda created default network profiles for ALL wired devices  
**New Behavior**: Only devices configured during installation get network profiles

**Impact**: 
- Devices configured via kickstart, boot options, or UI will have profiles
- Unconfigured devices won't have automatic profiles

**Tino Configuration**: DHCP configured in kickstart, so primary network interface will work automatically.

## Package Updates

### Added for Fedora 44
- `plymouth` and `plymouth-system-theme` - Boot splash support
- `xdg-desktop-portal-hyprland` - Recommended portal implementation
- `polkit-kde-plasma` - Replaces deprecated `polkit-gnome`
- `usbguard` - USB device security
- `fail2ban` - Intrusion prevention

### Security Tools
- Enhanced kernel parameters for security hardening
- SSH hardening configurations
- SystemD service sandboxing

## Migration Path

### For Fresh Installations

1. **Use Fedora 44 Live ISO**: Build with updated kickstart
2. **Verify Hardware Support**: Check kernel 6.19+ compatibility
3. **Follow Post-Install Steps**: Run system updates immediately

### For Existing Fedora 41/42/43 Systems

**Recommended**: Fresh install for cleanest experience

**If Upgrading**:
```bash
# Backup your data first!
sudo dnf system-upgrade download --releasever=44
sudo dnf system-upgrade reboot

# After upgrade, verify Hyprland
hyprland --version

# Rebuild if necessary (from COPR or source)
```

**Warning**: Hyprland users may experience issues. Consider backing up and doing a fresh install.

## Post-Migration Checklist

### Immediate Actions

- [ ] Run `sudo dnf update` to get latest security patches
- [ ] Verify Hyprland starts and functions correctly
- [ ] Check kernel version: `uname -r` (should be 6.19+ or 7.x)
- [ ] Verify DNF5 is active: `dnf --version` (should show DNF5)
- [ ] Test Wayland portal: Screen sharing should work
- [ ] Verify polkit agent: System authentication prompts should appear

### Security Verification

- [ ] Check firewall: `sudo firewall-cmd --list-all`
- [ ] Verify SELinux: `sestatus` (should show "enforcing")
- [ ] Check fail2ban: `sudo fail2ban-client status`
- [ ] Review SSH config: `/etc/ssh/sshd_config.d/99-tino-hardening.conf`
- [ ] Test USBGuard: `sudo usbguard list-devices`

### Performance Verification

- [ ] Test DNF5 speed: `time sudo dnf check-update`
- [ ] Verify parallel downloads: Check `/etc/dnf/dnf.conf`
- [ ] Test Hyprland performance: Should be smooth with kernel 6.19+
- [ ] Check systemd boot time: `systemd-analyze`

## Troubleshooting

### Hyprland Won't Start

**Symptoms**: Black screen, compositor crash, or error messages about libraries

**Solutions**:
1. Check logs: `journalctl -xeu sddm`
2. Verify dependencies: `ldd $(which hyprland)`
3. Try COPR repository: `sudo dnf copr enable solopasha/hyprland`
4. Rebuild from source if necessary

### DNF5 Issues

**Symptoms**: Package installation failures, dependency errors

**Solutions**:
1. Clear cache: `sudo dnf clean all`
2. Rebuild cache: `sudo dnf makecache`
3. Check for held packages: `sudo dnf list --upgrades`

### Network Profiles Missing

**Symptoms**: Network devices don't connect automatically

**Solutions**:
1. Check NetworkManager: `nmcli device status`
2. Create profile manually: `nmcli connection add type ethernet ifname <device>`
3. Enable DHCP: `nmcli connection modify <name> ipv4.method auto`

## Known Limitations

### 1. Hyprland Rebuild Risk
- Third-party Wayland compositors may need rebuilding after Fedora upgrades
- Keep COPR repositories enabled for latest compatible versions

### 2. Network Profile Behavior
- New installer network behavior may require manual profile creation for some devices
- Primary interface configured in kickstart should work automatically

### 3. SDDM vs Plasma Login Manager
- KDE variants switched to Plasma Login Manager
- Tino continues using SDDM (unaffected)
- Future Fedora versions may deprecate SDDM entirely

## Performance Improvements

### DNF5 Benchmarks
- **Speed**: 2-5x faster package operations compared to DNF4
- **Memory**: 30-40% lower memory usage
- **Parallel**: Up to 10 concurrent downloads by default

### Kernel 6.19+ Benefits
- Improved Wayland performance
- Better power management (laptops/mobile)
- Enhanced hardware support (newer AMD/ARM)
- Security hardening features

## Security Enhancements

### Fedora 44 Specific
- **Firefox 150**: 200+ CVEs fixed
- **PackageKit**: Privilege escalation patched
- **Kernel 7.x**: Multiple security updates
- **Reproducible Builds**: Enhanced supply chain security

### Tino Hardening (Applied)
- Kernel security parameters (kptr_restrict, BPF hardening)
- SSH hardening (strong ciphers, connection limits)
- fail2ban intrusion prevention
- USBGuard device protection
- SystemD service sandboxing

## References

- [Fedora 44 Release Announcement](https://fedoramagazine.org/announcing-fedora-linux-44/)
- [Fedora 44 Beta Announcement](https://fedoramagazine.org/announcing-fedora-linux-44-beta/)
- [Fedora 44 Release Features](https://www.linuxteck.com/fedora-linux-44-new-features/)
- [DNF5 Migration Guide](https://fedoraproject.org/wiki/Changes/SwitchToDnf5)
- [Fedora 44 ChangeSet](https://fedoraproject.org/wiki/Releases/44/ChangeSet)
- [Hyprland Fedora 44 Issues](https://www.verona.se/post/hyprland-after-f44-upgrade/)

## Support

For issues specific to Tino on Fedora 44:
1. Check `docs/SECURITY.md` for security-related issues
2. Review kickstart logs: `/root/ks-post.log`
3. Check Hyprland compatibility with COPR repositories
4. Report bugs via GitHub issues

---

**Last Updated**: July 2026  
**Fedora Version**: 44  
**Kernel Version**: 6.19+ (7.0.4 - 7.0.9+)  
**DNF Version**: DNF5
