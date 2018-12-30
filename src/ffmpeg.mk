# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ffmpeg
$(PKG)_WEBSITE  := https://ffmpeg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.5
$(PKG)_CHECKSUM := 741cbd6394eaed370774ca4cc089eaafbc54d0824b9aa360d4b3b0cbcbc4a92c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_URL_2    := https://launchpad.net/ffmpeg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 yasm zlib xz openjpeg jpeg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ffmpeg.org/releases/' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|git' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --enable-cross-compile \
        --arch=$(firstword $(subst -, ,$(TARGET))) \
        --target-os=mingw32 \
        --prefix='$(PREFIX)/$(TARGET)' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared ) \
        --yasmexe='$(TARGET)-yasm' \
        --disable-debug \
        --disable-pthreads \
        --enable-w32threads \
        --extra-libs='-mconsole' \
        --disable-libass \
        --enable-small \
        --disable-programs \
        --disable-doc \
        --enable-avdevice \
        --enable-avcodec \
        --enable-avformat \
        --enable-swscale \
        --disable-swresample \
        --disable-postproc \
        --disable-avfilter \
        --disable-avresample \
        --disable-network \
        --enable-demuxers \
        --enable-decoders \
        --disable-encoders \
        --disable-hwaccels \
        --enable-muxers \
        --enable-parsers \
        --disable-bsfs \
        --enable-protocols \
        --disable-devices \
        --disable-filters \
        --disable-librsvg \
        --enable-libopenjpeg \
        --disable-libxml2 \
        --disable-openssl
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
