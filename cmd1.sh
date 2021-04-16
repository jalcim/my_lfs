1) Créer un système de fichiers sur la partition

mkfs -v -t ext4 /dev/<xxx>
mkswap /dev/<yyy>


#2) Définir la variable $LFS
export LFS=/home/ghost/my_lfs/mnt_lfs

#3) monter la partition
mkdir -pv $LFS
sudo mount -v -t ext4 /dev/sda3 $LFS

ou dans /etc/fstab
sudo echo "/dev/<xxx>  /mnt/lfs ext4   defaults      1     1" >> /etc/fstab

#4) download des packets
sudo mkdir -v $LFS/sources
sudo chmod -v a+wt $LFS/sources
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
pushd $LFS/sources
md5sum -c md5sums
popd

#5) Créer un ensemble limité de répertoire dans le système de fichiers LFS 
sudo mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
case $(uname -m) in
    x86_64) sudo mkdir -pv $LFS/lib64 ;;
esac

sudo mkdir -pv $LFS/tools

#6) Ajouter l'utilisateur LFS
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs

sudo chown -v lfs $LFS/{usr,lib,var,etc,bin,sbin,tools,sources}
case $(uname -m) in
    x86_64) sudo chown -v lfs $LFS/lib64 ;;
    esac

su - lfs

#7) Configurer l'environnement ($USER == LFS)
cat > ~/.bash_profile <<EOF
 "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
EOF

cat > ~/.bashrc <<EOF
 "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
EOF

#####imperatif !!! (en sudo)
[ ! -e /etc/bash.bashrc ] || sudo mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

source ~/.bash_profile

#8) LES SBU
export MAKEFLAGS='-j4'#max8
