making_dir()
{
    mkdir -pv /{boot,home,mnt,opt,srv}
    mkdir -pv /etc/{opt,sysconfig}
    mkdir -pv /lib/firmware
    mkdir -pv /media/{floppy,cdrom}
    mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
    mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
    mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
    mkdir -pv /usr/{,local/}share/man/man{1..8}
    mkdir -pv /var/{cache,local,log,mail,opt,spool}
    mkdir -pv /var/lib/{color,misc,locate}

    ln -sfv /run /var/run
    ln -sfv /run/lock /var/lock

    install -dv -m 0750 /root
    install -dv -m 1777 /tmp /var/tmp
}

mtab_and_hosts()
{
    ln -sv /proc/self/mounts /etc/mtab
    echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
}

passwd()
{
    cat > /etc/passwd <<EOF
 "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
    EOF
}

group()
{
    cat > /etc/group <<EOF
 "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
uuidd:x:80:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF
    EOF

}

unprivileger_user()
{
    echo "tester:x:$(ls -n $(tty) | cut -d" " -f3):101::/home/tester:/bin/bash" >> /etc/passwd
    echo "tester:x:101:" >> /etc/group
    install -o tester -d /home/tester
    exec /bin/bash --login +h
}

journal_de_log()
{
    touch /var/log/{btmp,lastlog,faillog,wtmp}
    chgrp -v utmp /var/log/lastlog
    chmod -v 664  /var/log/lastlog
    chmod -v 600  /var/log/btmp
}

libstdcpp_passe2()
{
    cd sources/gcc-10.2.0
    ln -s gthr-posix.h libgcc/gthr-default.h
    mkdir build_c++2
    cd    build_c++2
    ../libstdc++-v3/configure            \
	CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
	--prefix=/usr                    \
	--disable-multilib               \
	--disable-nls                    \
	--host=$(uname -m)-lfs-linux-gnu \
	--disable-libstdcxx-pch

    make -j8
    make install
    cd ../..
}

gettext()
{
    tar -xJf gettext-0.21.tar.xz
    cd gettext-0.21
    ./configure --disable-shared
    make -j8
    cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
    cd ..
}

bison()
{
    tar -xJf bison-3.7.5.tar.xz
    cd bison-3.7.5
    ./configure --prefix=/usr \
		--docdir=/usr/share/doc/bison-3.7.5

    make -j8
    make install
    cd ..
}

perl()
{
    tar -xJf perl-5.32.1.tar.xz
    cd perl-5.32.1
    sh Configure -des                                        \
       -Dprefix=/usr                               \
       -Dvendorprefix=/usr                         \
       -Dprivlib=/usr/lib/perl5/5.32/core_perl     \
       -Darchlib=/usr/lib/perl5/5.32/core_perl     \
       -Dsitelib=/usr/lib/perl5/5.32/site_perl     \
       -Dsitearch=/usr/lib/perl5/5.32/site_perl    \
       -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl \
       -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl

    make -j8
    make install
    cd ..
}

python()#a verifier !
{
    tar -xJf Python-3.9.2.tar.xz
    cd Python-3.9.2
    ./configure --prefix=/usr   \
		--enable-shared \
		--without-ensurepip
    make -j8
    make install
    cd ..
}

texinfo()
{
    tar -xJf texinfo-6.7.tar.xz
    cd texinfo-6.7
    ./configure --prefix=/usr
    make -j8
    make install
    cd ..
}

util_linux()
{
    tar -xJf util-linux-2.36.2.tar.xz
    cd util-linux-2.36.2
    mkdir -pv /var/lib/hwclock
    ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
		--docdir=/usr/share/doc/util-linux-2.36.2 \
		--disable-chfn-chsh  \
		--disable-login      \
		--disable-nologin    \
		--disable-su         \
		--disable-setpriv    \
		--disable-runuser    \
		--disable-pylibmount \
		--disable-static     \
		--without-python     \
		runstatedir=/run
    make -j8
    make install
    cd ..
}

clean()
{
    find /usr/{lib,libexec} -name \*.la -delete
    rm -rf /usr/share/{info,man,doc}/*
}
