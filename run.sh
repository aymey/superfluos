#!/bin/sh

case $1 in
    # TODO: make debug actually work
    "debug")    st -e gdb -q -ex "target remote localhost:1234" &
                qemu-system-i386 -s -S os.bin # -gdb
                ;;
    *)          qemu-system-i386 -drive format=raw,file="os.bin",index=0 -m 128M
                ;;
esac
