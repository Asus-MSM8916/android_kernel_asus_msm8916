# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=GunMetal by YaAlex @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=Z00ED
device.name2=Z00E
device.name3=Z00E_2
device.name4=ASUS_Z00ED
device.name5=ASUS_Z00E_2
supported.versions=6.0-9.0
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# insert init.spectrum.rc in init.rc
insert_line init.rc "import /init.gunmetal.rc" after "import /init.usb.configfs.rc" "import /init.gunmetal.rc";

if [ -f /sys/devices/soc0/soc_id ]; then
    soc_id=`cat /sys/devices/soc0/soc_id`
else
    soc_id=`cat /sys/devices/system/soc/soc0/id`
fi

case "$soc_id" in
    "206" | "247" | "248" | "249" | "250")
		# Apply MSM8916 specific gunmetal profiles
		# insert init.gunmetal.rc in init.rc
		mv /tmp/anykernel/ramdisk/init.gunmetal.rc /tmp/anykernel/ramdisk/init.gunmetal.rc
	;;
esac
cp /tmp/anykernel/ramdisk/1-setprop.sh /system/etc/init.d/1-setprop.sh
chmod +x /system/etc/init.d/1-setprop.sh
write_boot;
## end install

