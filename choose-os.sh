#!/bin/bash

ID=""
source /etc/os-release
ID2=""

PS3='Please choose OS to boot: '
options=("Tumbleweed" "Ubuntu" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Tumbleweed")
            ID2="opensuse-tumbleweed"
            break
            ;;
        "Ubuntu")
            ID2="ubuntu"
            break
            ;;
        "Quit")
	    echo "Quiting..."
            exit
            break
            ;;
        *) echo "invalid option";;
    esac
done

echo "This Server is: $ID"
echo "Required Server is: $ID2"

if [[ $ID == "opensuse-tumbleweed" ]]; then
    echo "Running on Tumbleweed: Easy as chroot not needed."

    if [[ $ID2 == "opensuse-tumbleweed" ]]; then
        sed -i 's/GRUB_DEFAULT=[0-9]*/GRUB_DEFAULT=0/g' /etc/default/grub
        echo "Rebooting into Tumbleweed ..."
    fi

    if [[ $ID2 == "ubuntu" ]]; then
        sed -i 's/GRUB_DEFAULT=[0-9]*/GRUB_DEFAULT=2/g' /etc/default/grub
        echo "Rebooting into Ubuntu ..."
    fi
    update-bootloader
fi

if [[ $ID == "ubuntu" ]]; then
    echo "Running on Ubuntu: Need to chroot to update /dev/sdb2"
    mountpoint -q /mnt/disk1
    ret="$?"
    if [[ "$ret" ==  0 ]]; then
        echo "Mounted ..."
    else
        echo "Not Yet Mounted ..."
        mount /dev/sdb2 /mnt/disk1/
    fi

    if [[ $ID2 == "opensuse-tumbleweed" ]]; then
        sed -i 's/GRUB_DEFAULT=[0-9]*/GRUB_DEFAULT=0/g' /mnt/disk1/etc/default/grub
        echo "Rebooting into Tumbleweed ..."
    fi

    if [[ $ID2 == "ubuntu" ]]; then
        sed -i 's/GRUB_DEFAULT=[0-9]*/GRUB_DEFAULT=2/g' /mnt/disk1/etc/default/grub
        echo "Rebooting into Ubuntu ..."
    fi

    mount --bind /proc /mnt/disk1/proc/
    mount --bind /dev/ /mnt/disk1/dev/
    mount --bind /sys/ /mnt/disk1/sys/

    chroot /mnt/disk1 /bin/bash -x <<'EOF'
    sleep 2
    /sbin/update-bootloader
    sleep 2
EOF
    echo "Finished Chroot..."
    umount /mnt/disk1/proc/
    umount /mnt/disk1/dev/
    umount /mnt/disk1/sys/
    umount /mnt/disk1
fi

sleep 2
echo "Rebooting as requested ..."
reboot
