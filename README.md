# Reboot Selector
Reboot Selector : programmatically update Grub for headless reboot

A headless server has two hard disks fitted, each with a different OS.
- The BIOS is set to boot from one of the disks - for example Tumbleweed.  
- The Grub2 entry for this hard disk has used os-prober to add both OS to the Grub2 menu.
- For example: 0 for Tumbleweed, 2 for Ubuntu

When running ./choose-os.sh on the Tumbleweed server, changing /etc/default/grub is easy, allowing
the User to choose which OS to boot

When running ./choose-os.sh on the Ubuntu server, the updating of Tumbleweed's Grub2 config is more awkward.
It needs a Chroot from Ubuntu into Tumbleweed to update the bootloader

//end  
2025-04-22
