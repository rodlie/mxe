# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imagemagick
$(PKG)_WEBSITE  := https://www.imagemagick.org/
$(PKG)_DESCR    := ImageMagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.9.9-51
$(PKG)_CHECKSUM := aa5f6b1e97bd98fbf642c47487531bea0faf675c728d01130b52d2b46849104a
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.imagemagick.org/download/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xz bzip2 jpeg lcms libpng pthreads tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][0-9.-]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && LDFLAGS="-lws2_32 -lz" ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-x=no --disable-docs --disable-modules \
        --with-zlib --with-lzma --without-xz --without-jasper --enable-hdri --with-quantum-depth=32 \
        --enable-largefile --without-pango --without-webp --without-fftw --without-lqr \
        --without-freetype --without-openexr --without-fontconfig
    $(SED) -i 's/#define MAGICKCORE_HAVE_PTHREAD 1//g' '$(1)/magick/magick-baseconfig.h'
    $(SED) -i 's/#define MAGICKCORE_ZLIB_DELEGATE 1//g' '$(1)/magick/magick-config.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=

    '$(1)'/libtool --mode=link --tag=CXX \
        '$(TARGET)-g++' -Wall -Wextra -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-imagemagick.exe' \
        `'$(TARGET)-pkg-config' ImageMagick++-6.Q32HDRI --cflags --libs`
endef
