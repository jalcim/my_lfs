m4()
{
    tar -xJf m4-1.4.18.tar.xz
    cd m4-1.4.18
    
    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
    echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

    ./configure --prefix=/usr   \
		--host=$LFS_TGT \
		--build=$(build-aux/config.guess)
    make -j8
    make DESTDIR=$LFS install
    cd ..
}

ncurses()
{
    tar -xzvf ncurses-6.2.tar.gz
    cd ncurses-6.2
    sed -i s/mawk// configure
    mkdir build
    cd build
    ../configure
    make -C include
    make -C progs tic
    cd ..
    ./configure --prefix=/usr                \
		--host=$LFS_TGT              \
		--build=$(./config.guess)    \
		--mandir=/usr/share/man      \
		--with-manpage-format=normal \
		--with-shared                \
		--without-debug              \
		--without-ada                \
		--without-normal             \
		--enable-widec

    make -j8

    make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
    echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

    mv -v $LFS/usr/lib/libncursesw.so.6* $LFS/lib
    ln -sfv ../../lib/$(readlink $LFS/usr/lib/libncursesw.so) $LFS/usr/lib/libncursesw.so
    cd ..
}

bash()
{
    tar -xzvf bash-5.1.tar.gz
    cd bash bash-5.1
    ./configure --prefix=/usr                   \
		--build=$(support/config.guess) \
		--host=$LFS_TGT                 \
		--without-bash-malloc

    make -j8
    make DESTDIR=$LFS install

    mv $LFS/usr/bin/bash $LFS/bin/bash
    ln -sv bash $LFS/bin/sh
    cd ..
}

coreutils()
{
    tar -xJf coreutils-8.32.tar.xz
    cd coreutils-8.32
    ./configure --prefix=/usr                     \
		--host=$LFS_TGT                   \
		--build=$(build-aux/config.guess) \
		--enable-install-program=hostname \
		--enable-no-install-program=kill,uptime
    make -j8
    make DESTDIR=$LFS install

    mv -v $LFS/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} $LFS/bin
    mv -v $LFS/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm}        $LFS/bin
    mv -v $LFS/usr/bin/{rmdir,stty,sync,true,uname}               $LFS/bin
    mv -v $LFS/usr/bin/{head,nice,sleep,touch}                    $LFS/bin
    mv -v $LFS/usr/bin/chroot                                     $LFS/usr/sbin
    mkdir -pv $LFS/usr/share/man/man8
    mv -v $LFS/usr/share/man/man1/chroot.1                        $LFS/usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/'                                           $LFS/usr/share/man/man8/chroot.8
    cd ..
}

diffutils()
{
    tar -xJf diffutils-3.7.tar.xz
    cd diffutils-3.7
    ./configure --prefix=/usr --host=$LFS_TGT
    make -j8
    make DESTDIR=$LFS install
    cd ..
}

file()
{
    tar -xzvf file-5.39.tar.gz
    cd file-5.39
    mkdir build
    cd build
    ../configure --disable-bzlib      \
		 --disable-libseccomp \
		 --disable-xzlib      \
		 --disable-zlib
    make -j8
    cd ..
    ./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
    make -j8 FILE_COMPILE=$(pwd)/build/src/file
    make DESTDIR=$LFS install
    cd ..
}

findutils()
{
    tar -xJf findutils-4.8.0.tar.xz
    cd findutils-4.8.0
    ./configure --prefix=/usr   \
		--host=$LFS_TGT \
		--build=$(build-aux/config.guess)

    make -j8
    make DESTDIR=$LFS install
    mv -v $LFS/usr/bin/find $LFS/bin
    sed -i 's|find:=${BINDIR}|find:=/bin|' $LFS/usr/bin/updatedb
    cd ..
}

gawk()
{
    tar -xJf gawk-5.1.0.tar.xz
    cd gawk-5.1.0
    sed -i 's/extras//' Makefile.in
    ./configure --prefix=/usr   \
		--host=$LFS_TGT \
		--build=$(./config.guess)
    make -j8
    make DESTDIR=$LFS install
    cd ..
}

grep()
{
    tar -xJf grep-3.6.tar.xz
    cd grep-3.6
    ./configure --prefix=/usr   \
		--host=$LFS_TGT \
		--bindir=/bin

    make -j8
    make DESTDIR=$LFS install
    cd ..
}

gzip()
{
    tar -xJf gzip-1.10.tar.xz
    cd gzip-1.10
    ./configure --prefix=/usr --host=$LFS_TGT
    make -j8
    make DESTDIR=$LFS install
    mv -v $LFS/usr/bin/gzip $LFS/bin
    cd ..
}

make()
{
    tar -xzvf make-4.3.tar.gz
    cd make make-4.3
    ./configure --prefix=/usr   \
		--without-guile \
		--host=$LFS_TGT \
		--build=$(build-aux/config.guess)
    make -j8
    make DESTDIR=$LFS install
    cd ..
}

patch()
{
    tar -xJf patch-2.7.6.tar.xz
    cd tar -xJf patch-2.7.6
    ./configure --prefix=/usr   \
		--host=$LFS_TGT \
		--build=$(build-aux/config.guess)
    make -j8
    make DESTDIR=$LFS install
    cd ..
}

sed()
{
    tar -xJf sed-4.8.tar.xz
    cd sed-4.8
    ./configure --prefix=/usr   \
		--host=$LFS_TGT \
		--bindir=/bin

    make -j8
    make DESTDIR=$LFS install
    cd ..
}


tar()
{
    tar -xJf tar-1.34.tar.xz
    cd tar-1.34
    ./configure --prefix=/usr                     \
		--host=$LFS_TGT                   \
		--build=$(build-aux/config.guess) \
		--bindir=/bin

    make -j8
    make DESTDIR=$LFS install
    cd ..
}

xz()
{
    tar -xJf xz-5.2.5.tar.xz
    cd xz-5.2.5

    ./configure --prefix=/usr                     \
       --host=$LFS_TGT                   \
       --build=$(build-aux/config.guess) \
       --disable-static                  \
       --docdir=/usr/share/doc/xz-5.2.5
    
    make -j8
    make DESTDIR=$LFS install
    mv -v $LFS/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat}  $LFS/bin
    mv -v $LFS/usr/lib/liblzma.so.*                       $LFS/lib
    ln -svf ../../lib/$(readlink $LFS/usr/lib/liblzma.so) $LFS/usr/lib/liblzma.so
    cd ..
}

binutils_passe2()
{
    cd binutils-2.36.1
    mkdir build2
    cd build2
    ../configure                   \
	--prefix=/usr              \
	--build=$(../config.guess) \
	--host=$LFS_TGT            \
	--disable-nls              \
	--enable-shared            \
	--disable-werror           \
	--enable-64-bit-bfd

    make -j8
    make DESTDIR=$LFS install
    install -vm755 libctf/.libs/libctf.so.0.0.0 $LFS/usr/lib
    cd ../..
}

gcc_passe2()
{
    cd gcc-10.2.0
    tar -xf ../mpfr-4.1.0.tar.xz
    mv -v mpfr-4.1.0 mpfr
    tar -xf ../gmp-6.2.1.tar.xz
    mv -v gmp-6.2.1 gmp
    tar -xf ../mpc-1.2.1.tar.gz
    mv -v mpc-1.2.1 mp

    case $(uname -m) in
	x86_64)
	    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	    ;;
    esac

    mkdir build2
    cd    build2
    mkdir -pv $LFS_TGT/libgcc
    ln -s ../../../libgcc/gthr-posix.h $LFS_TGT/libgcc/gthr-default.h

    ../configure                                       \
	--build=$(../config.guess)                     \
	--host=$LFS_TGT                                \
	--prefix=/usr                                  \
	CC_FOR_TARGET=$LFS_TGT-gcc                     \
	--with-build-sysroot=$LFS                      \
	--enable-initfini-array                        \
	--disable-nls                                  \
	--disable-multilib                             \
	--disable-decimal-float                        \
	--disable-libatomic                            \
	--disable-libgomp                              \
	--disable-libquadmath                          \
	--disable-libssp                               \
	--disable-libvtv                               \
	--disable-libstdcxx                            \
	--enable-languages=c,c++

    make -j8
    make #obligatoire !
    make DESTDIR=$LFS install
    
    ln -sv gcc $LFS/usr/bin/cc
    cd ../..
}
