man_pages()
{
    tar -xJf man-pages-5.10.tar.xz
    cd man-pages-5.10
    make install
    cd ..
}

iana_etc()
{
    tar -xzvf iana-etc-20210202.tar.gz
    cd iana-etc-20210202
    cp services protocols /etc
    cd ..
}

glibc_passe2()
{
    tar -xJf glibc-2.33.tar.xz
    cd glibc-2.33
    patch -Np1 -i ../glibc-2.33-fhs-1.patch
    sed -e '402a\      *result = local->data.services[database_index];' \
	-i nss/nss_database.c
    mkdir build2
    cd       build2
    ../configure --prefix=/usr                            \
		 --disable-werror                         \
		 --enable-kernel=3.2                      \
		 --enable-stack-protector=strong          \
		 --with-headers=/usr/include              \
		 libc_cv_slibdir=/lib
    make -j8
    make check
    
    cd ../..
}
