#!/bin/bash

# NVIDIA 165Hz Fix Script
# Fixes black screen issues when using 165Hz with NVIDIA GPUs over HDMI
# This script adds nvidia-modeset.hdmi_deepcolor=0 to GRUB kernel parameters

echo "🚀 NVIDIA 165Hz Fix Script"
echo "=========================="
echo ""
echo "This script fixes black screen issues with 165Hz displays on NVIDIA GPUs"
echo "by adding nvidia-modeset.hdmi_deepcolor=0 to kernel parameters."
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script needs to be run as root."
    echo "Please run: sudo $0"
    exit 1
fi

# Backup GRUB config
echo "📁 Creating backup of GRUB config..."
cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)

# Check if parameter already exists
if grep -q "nvidia-modeset.hdmi_deepcolor=0" /etc/default/grub; then
    echo "✅ NVIDIA HDMI deep color parameter already present!"
    echo "No changes needed."
    exit 0
fi

# Add the parameter
echo "🔧 Adding nvidia-modeset.hdmi_deepcolor=0 to GRUB_CMDLINE_LINUX_DEFAULT..."

# Get current GRUB_CMDLINE_LINUX_DEFAULT
current_line=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub)

if [ -z "$current_line" ]; then
    # If line doesn't exist, create it
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="nvidia-modeset.hdmi_deepcolor=0"' >> /etc/default/grub
else
    # Add to existing line
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-modeset.hdmi_deepcolor=0"/' /etc/default/grub
    # Clean up double spaces
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\s*\(.*\)\s*"/GRUB_CMDLINE_LINUX_DEFAULT="\1"/' /etc/default/grub
fi

echo "✅ Parameter added successfully!"
echo ""

# Update GRUB
echo "🔄 Updating GRUB configuration..."
grub-mkconfig -o /boot/grub/grub.cfg

if [ $? -eq 0 ]; then
    echo "✅ GRUB updated successfully!"
    echo ""
    echo "🔥 Fix applied! Please reboot to enable 165Hz support."
    echo ""
    echo "After reboot, you can set 165Hz in:"
    echo "  • Hyprland config: monitor=,1920x1080@165,auto,1"
    echo "  • Display settings"
    echo ""
    echo "🎮 Your NVIDIA GPU should now support 165Hz without black screens!"
else
    echo "❌ Error updating GRUB. Please check manually."
    exit 1
fi