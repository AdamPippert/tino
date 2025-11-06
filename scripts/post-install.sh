#!/bin/bash
#
# Tino Fedora Spin - Post-Installation Script
#
# This script runs after the base system installation to perform
# additional customization and configuration.

set -e  # Exit on error

echo "Starting Tino Spin post-installation customization..."

# System Configuration
echo "Configuring system settings..."

# Example: Set timezone (modify as needed)
# timedatectl set-timezone America/New_York

# Example: Enable services
# systemctl enable firewalld
# systemctl enable sshd

# User Configuration
echo "Applying user configurations..."

# Example: Create default user directories
# mkdir -p /etc/skel/{Documents,Downloads,Projects}

# Example: Set default shell configurations
# cat > /etc/skel/.bashrc << 'EOF'
# # Custom bash configuration for Tino Spin
# alias ll='ls -alF'
# alias la='ls -A'
# EOF

# Package Management
echo "Running package management tasks..."

# Example: Update system
# dnf -y update

# Example: Clean package cache
# dnf clean all

# Security Hardening
echo "Applying security configurations..."

# Example: Configure firewall rules
# firewall-cmd --permanent --add-service=ssh
# firewall-cmd --reload

# Custom Configurations
echo "Applying custom configurations..."

# Add your custom post-installation tasks here

echo "Post-installation customization completed successfully!"
exit 0
