# Fedora Repository Directives for Tino Spin
#
# This file contains the repository configurations for building the Tino Spin
# Following Fedora Spins repository directives

# Fedora Base Repository
repo --name="fedora" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch

# Fedora Updates Repository
repo --name="updates" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch

# Optional: Fedora Updates Testing (comment out if not needed)
# repo --name="updates-testing" --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-testing-f$releasever&arch=$basearch

# Optional: RPM Fusion Free (uncomment if needed for additional software)
# repo --name="rpmfusion-free" --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch

# Optional: RPM Fusion Non-Free (uncomment if needed, but verify licensing)
# repo --name="rpmfusion-nonfree" --mirrorlist=https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch

# Add custom repositories below if needed:
