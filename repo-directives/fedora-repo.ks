# Fedora Repository Directives for Tino Spin (Multi-arch: x86_64 + aarch64)
#
# This file contains the repository configurations for building the Tino Spin
# Supports multi-arch builds via $basearch variable (x86_64, aarch64)

# Fedora Base Repository
repo --name="fedora" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-44&arch=$basearch

# Fedora Updates Repository
repo --name="updates" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f44&arch=$basearch

# Optional: Fedora Updates Testing (uncomment if needed for testing packages)
# repo --name="updates-testing" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-testing-f44&arch=$basearch

# Optional: RPM Fusion Free (uncomment if needed for additional FOSS software)
# repo --name="rpmfusion-free" --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-44&arch=$basearch

# Optional: RPM Fusion Non-Free (uncomment if needed, verify licensing compatibility)
# repo --name="rpmfusion-nonfree" --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-44&arch=$basearch

# COPR repositories (if needed)
# Example: repo --name="copr-hyprland" --baseurl=https://download.copr.fedorainfracloud.org/results/@hyprland/hyprland/fedora-44-$basearch/
