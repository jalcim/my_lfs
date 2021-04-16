#hors du chroot
#exit
sudo umount $LFS/dev{/pts,}
sudo umount $LFS/{sys,proc,run}
sudo strip --strip-debug $LFS/usr/lib/*
sudo strip --strip-unneeded $LFS/usr/{,s}bin/*
sudo strip --strip-unneeded $LFS/tools/bin/*

#sauvegarde
cd $LFS
sudo tar -cJpf $HOME/lfs-temp-tools-10.1-systemd.tar.xz .

#restauration
cd $LFS
rm -rf ./*
tar -xpf $HOME/lfs-temp-tools-10.1-systemd.tar.xz
