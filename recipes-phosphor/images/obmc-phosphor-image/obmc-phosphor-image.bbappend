#
# meta-custom/recipes-phosphor/images/obmc-phosphor-image/obmc-phosphor-image.bbappend
#

# 1) Create an empty Redfish log file before finalizing rootfs
ROOTFS_POSTPROCESS_COMMAND += "create_redfish_log;"

create_redfish_log() {
    install -d "${IMAGE_ROOTFS}/var/log"
    install -m 0644 /dev/null "${IMAGE_ROOTFS}/var/log/redfish"
}

# 2) Install mDNS, WPA supplicant, IPMI tool, web UI and bmcweb
IMAGE_INSTALL_append = " \
    avahi-daemon \
    wpa-supplicant \
    ipmitool \
    webui-vue \
    bmcweb \
"

# 3) Override the Pi’s boot-time cmdline.txt automatically
ROOTFS_POSTPROCESS_COMMAND += "update_cmdline_txt;"

update_cmdline_txt() {
    # Note: console=serial0,115200 is the Raspberry Pi's UART
    echo 'dwc_otg.lpm_enable=0 console=serial0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait' \
      > "${IMAGE_ROOTFS}/boot/cmdline.txt"
}

