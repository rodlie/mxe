# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imagemagick
$(PKG)_WEBSITE  := https://www.imagemagick.org/
$(PKG)_DESCR    := ImageMagick
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.8-20
$(PKG)_CHECKSUM := cb6192c829f2beb724990bb166180794c1fd811805101065a06ffc9437efbd81
$(PKG)_SUBDIR   := ImageMagick-$($(PKG)_VERSION)
$(PKG)_FILE     := ImageMagick-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.imagemagick.org/download/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xz bzip2 jpeg lcms libpng tiff zlib pthreads openjpeg openexr libraw

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.imagemagick.org/' | \
    $(SED) -n 's,.*<p>The current release is ImageMagick \([0-9][0-9.-]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && LDFLAGS="-lws2_32 -lz" ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-x=no --disable-docs --enable-openmp \
        --with-zlib --with-lzma --with-raw=yes --with-openjp2=yes --enable-hdri --with-quantum-depth=16 \
        --enable-largefile --without-pango --without-webp --without-fftw --without-lqr \
        --without-freetype --with-openexr --with-modules=no --without-fontconfig \
        --enable-zero-configuration --with-package-release-name=Cyan
#    $(SED) -i 's/#define MAGICKCORE_HAVE_PTHREAD 1//g' '$(1)/MagickCore/magick-baseconfig.h'
    $(SED) -i 's/#define MAGICKCORE_ZLIB_DELEGATE 1//g' '$(1)/MagickCore/magick-config.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS=

    '$(1)'/libtool --mode=link --tag=CXX \
        '$(TARGET)-g++' -Wall -Wextra -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-imagemagick.exe' \
        `'$(TARGET)-pkg-config' Magick++-7.Q16HDRI --cflags --libs`
endef
