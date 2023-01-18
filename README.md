# Ripping CD/DVD to ISO image from MacOS with Termianl Script

Information about create ISO image from CD/DVD on MacOS.

I also make [`ripdvd.sh` script file](https://github.com/JinQ-git/DVDRipForMac/blob/main/script/ripdvd.sh) & [`ripdvdvolume.sh` script file](https://github.com/JinQ-git/DVDRipForMac/blob/main/script/ripdvdvolume.sh) for convinence in [`script`](https://github.com/JinQ-git/DVDRipForMac/blob/main/script) directory.

## Get CD/DVD information for dump

First, insert your CD/DVD and then check that MacOS has mounted it in as a Volume. (It will appear on the Desktop or you can check it through Finder)

Open **Terminal.app**. Use `drutil` to get information about your CD/DVD.

```
$ drutil status
 Vendor   Product           Rev 
 HL-DT-ST DVDRAM GP65NS60   PF00

           Type: DVD-ROM              Name: /dev/disk4
       Sessions: 1                  Tracks: 1 
   Overwritable:   00:00:00         blocks:        0 /   0.00MB /   0.00MiB
     Space Free:   00:00:00         blocks:        0 /   0.00MB /   0.00MiB
     Space Used:  169:24:52         blocks:   762352 /   1.56GB /   1.45GiB
    Writability: 
      Book Type: DVD-ROM (v1)
```

Note the device _**Name**_ (`/dev/disk4`).

> Note: _**Space Used**_ is a **Disc Size** not **Volume Size**.

## 1. Dump Total CD/DVD

When you want dump your CD/DVD not only Volume(s) but also entire Disc, try follow sequence.

1. Unmount your drive.
1. Simply use `dd` command.
1. Mount your drive again.

```
$ diskutil unmountDisk /dev/disk4
$ dd if=/dev/disk4 of=output.iso status=progress
$ diskutil mountDisk /dev/disk4
```

> You should change `/dev/disk4` part, from above commands, to your **Device Name** that is got from above sequence.

> You may change `output.iso` part to yout own name what you want.


## 2. Dump First Volume of CD/DVD

### Confirmation CD/DVD Information

Use `diskutil` for additional information.

> Note: You should change `/dev/disk4` part, from below command, to your **Device Name** that is got from above sequence.

```
$ diskutil information /dev/disk4
   Device Identifier:         disk4
   Device Node:               /dev/disk4
   Whole:                     Yes
   Part of Whole:             disk4
   Device / Media Name:       HL-DT-ST DVDRAM GP65NS60

   Volume Name:               
   Mounted:                   Yes
   Mount Point:               /Volumes/Untitled

   Content (IOContent):       None
   File System Personality:   ISO
   Type (Bundle):             cd9660
   Name (User Visible):       ISO 9660

   OS Can Be Installed:       No
   Media Type:                
   Protocol:                  USB
   SMART Status:              Not Supported

   Disk Size:                 1.6 GB (1561296896 Bytes) (exactly 3049408 512-Byte-Units)
   Device Block Size:         2048 Bytes

   Volume Total Space:        1.6 GB (1561296896 Bytes) (exactly 3049408 512-Byte-Units)
   Volume Used Space:         1.6 GB (1561296896 Bytes) (exactly 3049408 512-Byte-Units) (100.0%)
   Volume Free Space:         0 B (0 Bytes) (exactly 0 512-Byte-Units) (0.0%)
   Allocation Block Size:     2048 Bytes

   Media OS Use Only:         No
   Media Read-Only:           Yes
   Volume Read-Only:          Yes (read-only mount flag set)

   Device Location:           External
   Removable Media:           Removable
   Media Removal:             Software-Activated

   Solid State:               Info not available
   Virtual:                   No

   Optical Drive Type:        CD-ROM, CD-R, CD-RW, DVD-ROM, DVD-R, DVD-R DL, DVD-RW, DVD-RAM, DVD+R, DVD+R DL, DVD+RW
   Optical Media Type:        DVD-ROM
   Optical Media Erasable:    No
```

Note the _**Allocation Block Size**_ (`2048 Bytes`) and the _**Volume Total Space**_ (`1561296896 Bytes` or `exactly 3049408 512-Byte-Units`).

In most of case, _**Allocation Block Size**_  should be `2048 Bytes` (ISO 9660 standard).

Note that, _**Disc Size**_ may not eaqual with _**Volume Total Space**_. 

We need a _**Volume Total Space**_ not a _**Disc Size**_.

With a value of the _**Volume Total Space**_, we calculate a number of block based on `_**Allocation Block Size**_-Byte-Units`.

Simply dvide _**Volume Total Space**_ value with _**Allocation Block Size**_.

In this case,

1. 3049308 x 512 = 1561296896
1. 1561296896 / 2048 = 762352

We now know that, a number of blocks of our disc is 762352 2048-byte-units.

We will use this value(762352) when dump our CD/DVD.

### Dump your CD/DVD

Before dump your CD/DVD, you should unmount your drive first.

> Note: You should change `/dev/disk4` part, from below commands, to your **Device Name** that is got from above sequence.

```
$ diskutil unmountDisk /dev/disk4
```

Now, use `dd` command for create ISO image.

```
$ dd if=/dev/disk4 of=output.iso bs=2048 count=762352 status=progress
```

1. Change a value of `if=` option to your device name,
1. Change a value of `of=` option to output file name that you want with `.iso` extension
1. Fix a value of `bs=` to `2048` or you can change it to _**Allocation Block Size**_ value.
1. Depends on `bs=` value, you should calculate this value with below formula.
   > _**Volume Total Space**_ x 512 / _**Allocation Block Size**_

   For example, in this case, `3049408 x 512 / 2048 = 762352`: So, use `count=762352`

This sequence take a time depens on your disc size. (For me, take about 30 min. dump about 7.9 GiB)

Finally, remount your drive.

```
$ diskutil mountDisk /dev/disk4
```

Done!!
