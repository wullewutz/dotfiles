# Configure NAS
echo "192.168.178.42    nas" >> /etc/hosts
echo "nas:/wullewutz    /mnt/nas    nfs rsize=8192,wsize=8192,users,noauto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,hard,intr,noatime	0	0" >> /etc/fstab

