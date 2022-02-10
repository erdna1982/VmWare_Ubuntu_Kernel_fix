#!/bin/bash
vmware-modconfig --console --install-all

echo "generate trusted key"
openssl req -new -x509 -newkey rsa:2048 -keyout /tmp/VMWARE.priv -outform DER -out /tmp/VMWARE.der -nodes -days 36500 -subj "/CN=VMWARE/"

echo "signing vmmon module"
/usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 /tmp/VMWARE.priv /tmp/VMWARE.der $(modinfo -n vmmon)

echo "signing vmnet module"
/usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 /tmp/VMWARE.priv /tmp/VMWARE.der $(modinfo -n vmnet)

echo "importing VMWARE cert"
mokutil --import '/tmp/VMWARE.der'
