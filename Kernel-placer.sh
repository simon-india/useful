#!/bin/sh
# installs kernel only, this should be run only from the kernel source directory

error() # error
{
  echo "ERROR: $1"
  exit 1
}

# make sure we are root
if test ~ != '/root'
then
  error 'This script must be run as root'
fi

# remove the old
rm -f /boot/config.old
rm -f /boot/System.map.old
rm -f /boot/vmlinuz.old

# rename the present
mv /boot/config /boot/config.old
mv /boot/System.map /boot/System.map.old
mv /boot/vmlinuz /boot/vmlinuz.old

# copy in the new
cp arch/x86/boot/bzImage /boot/vmlinuz
cp System.map /boot
cp .config /boot/config

# for elilo
bootdir="/boot/efi/EFI/Slackware"
if test -d "$bootdir"
then
  cp arch/x86/boot/bzImage "$bootdir"/vmlinuz
fi

# change permissions of vmlinuz
chmod a-rwx,u+r /boot/vmlinuz

# check install
echo
if cmp arch/x86/boot/bzImage /boot/vmlinuz
then
  echo 'Kernel installed correctly'
else
  error 'Kernel install failed'
fi
if cmp System.map /boot/System.map
then
  echo 'System.map installed correctly'
else
  error 'System.map install failed'
fi
if cmp .config /boot/config
then
  echo 'Kernel config installed correctly'
else
  error 'Kernel config install failed'
fi
if test -d "$bootdir"
then
  if cmp arch/x86/boot/bzImage "$bootdir"/vmlinuz
  then
    echo 'kernel installed to EFI correctly'
  else
    error 'kernel install to EFI failed'
  fi
fi
echo
echo 'Kernel install completed successfully'
echo 'Remember to run lilo if you use it'
echo

exit 0
