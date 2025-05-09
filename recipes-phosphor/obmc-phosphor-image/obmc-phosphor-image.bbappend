# Enable systemd-timesyncd so the BMC has correct time (TLS certs rely on real time)
#IMAGE_INSTALL_append = " systemd-timesyncd"

# Create the Redfish log file directory so bmcweb doesn't crash (exit-code 255)
ROOTFS_POSTPROCESS_COMMAND += "create_redfish_log;"

create_redfish_log() {
    install -d "${IMAGE_ROOTFS}/var/log"
    install -m 0644 /dev/null "${IMAGE_ROOTFS}/var/log/redfish"
}

# Also ensure avahi (mDNS), WPA supplicant, IPMI tool and the web UI are in the image
IMAGE_INSTALL_append += " avahi-daemon wpa-supplicant ipmitool webui-vue bmcweb"

# 4) Override cmdline.txt so you don’t have to edit the SD card by hand
ROOTFS_POSTPROCESS_COMMAND += "update_cmdline_txt;"

update_cmdline_txt() {
    # overwrite boot/cmdline.txt
    echo 'dwc_otg.lpm_enable=0 console=serial0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait' \
      > "${IMAGE_ROOTFS}/boot/cmdline.txt"
}

