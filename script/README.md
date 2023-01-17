# Usage

## dvdrip.sh

> Note: You should add **execute** permission with `chmod` command: EX) `chmod a+x dvdrip.sh`

```
$ ./dvdrip.sh ${OUTPUT_FILE_NAME_WITH_OUT_ISO_EXTENSION}
```

If you use multiple drive, you may change a value of `DISKNM` variable to your target device.

You can get **Device Name** of your target device with `drutil status` command.

## cdr2iso.sh

If you already have `.cdr` image, most of case, you only need to chagne `.cdr` extension to `.iso`.

But for special case, `cdr2iso.sh` script performs following command.

```
$ hdiutil makehybrid -iso -joliet -o output.iso input.cdr
```

You can use `cdr2iso.sh` script like below:

```
$ ./cdr2iso.sh ${TARGET_FILE_NAME}.cdr
```

> Note: You can create `cdr` image through _**Applications -> Utilites -> Disk Utility.app**_: Select the `CD/DVD Master` option before create the image.
