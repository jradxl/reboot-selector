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
        *) echo "invalid option $REPLY";;
    esac
done

echo "This Server is: $ID"
echo "Required Server is: $ID2"

if [[ $ID == "opensuse-tumbleweed" ]]; then
    echo "Running on Tumbleweed: Easy as chroot not needed."

    if [[ $ID2 == opensuse-tumbleweed"" ]]; then
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
    echo "Running on Ubuntu: Need to chroot to update /dev/sda"
fi

sleep 2
reboot
