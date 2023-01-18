# Usage

## ripdvd.sh & ripdvdvolume.sh

> Note: You should add **execute** permission with `chmod` command: EX) `chmod a+x ripdvd.sh`

```
$ ./ripdvd.sh ${OUTPUT_FILE_NAME_WITH_OUT_ISO_EXTENSION}
or
$ ./ripdvdvolume.sh ${OUTPUT_FILE_NAME_WITH_OUT_ISO_EXTENSION}
```

If you use multiple drive, you may change a value of `DISKNM` variable to your target device.

You can get **Device Name** of your target device with `drutil status` command.

