# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtorrent-rasterbar
$(PKG)_WEBSITE  := http://www.rasterbar.com/products/libtorrent/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.9
$(PKG)_CHECKSUM := d57a0f5b159f58003c3031943463503f0d05ae3e428dd7c2383d1e35fb2c4e8c
$(PKG)_SUBDIR   := libtorrent-rasterbar-$($(PKG)_VERSION)
$(PKG)_FILE     := libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://cryon.eu/opensource/libtorrent-rasterbar-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc boost openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/arvidn/libtorrent/releases' | \
    $(SED) -n 's,.*libtorrent-rasterbar-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --with-boost='$(PREFIX)/$(TARGET)' \
        --disable-debug \
        --disable-tests \
        --disable-examples \
        CXXFLAGS='-D_WIN32_WINNT=0x0501 -g -O2'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

#$(PKG)_BUILD_SHARED =
