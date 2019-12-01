# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libressl
$(PKG)_WEBSITE  := https://www.libressl.org/
$(PKG)_DESCR    := LibreSSL is a version of the TLS/crypto stack forked from OpenSSL in 2014
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.2
$(PKG)_CHECKSUM := df7b172bf79b957dd27ef36dcaa1fb162562c0e8999e194aa8c1a3df2f15398e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)/libressl' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
