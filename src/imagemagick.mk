# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imagemagick
$(PKG)_WEBSITE  := https://www.imagemagick.org/
$(PKG)_DESCR    := ImageMagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.9.10-17
$(PKG)_CHECKSUM := 5de296c9588c3ab36cf8f488aab5a5a95d56a3d74f77721d9a42debacc6f5370
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.imagemagick.org/download/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xz bzip2 jpeg lcms libpng tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][0-9.-]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && LDFLAGS="-lws2_32 -lz" ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-x=no --disable-docs --disable-modules --disable-openmp \
        --with-zlib --with-lzma --without-jasper --enable-hdri --with-quantum-depth=16 \
        --enable-largefile --without-pango --without-webp --without-fftw --without-lqr \
        --without-freetype --without-openexr --without-fontconfig \
        --enable-zero-configuration --with-package-release-name=Cyan
    $(SED) -i 's/#define MAGICKCORE_HAVE_PTHREAD 0//g' '$(1)/magick/magick-baseconfig.h'
    $(SED) -i 's/#define MAGICKCORE_ZLIB_DELEGATE 1//g' '$(1)/magick/magick-config.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=

    '$(1)'/libtool --mode=link --tag=CXX \
        '$(TARGET)-g++' -Wall -Wextra -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-imagemagick.exe' \
        `'$(TARGET)-pkg-config' ImageMagick++-6.Q16HDRI --cflags --libs`
endef
