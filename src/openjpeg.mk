# This file is part of MXE. See LICENSE.md for licensing information.
#Author: Julien Michel <julien.michel@orfeo-toolbox.org>

PKG             := openjpeg
$(PKG)_WEBSITE  := http://www.openjpeg.org/
$(PKG)_DESCR    := OpenJPEG
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a
$(PKG)_SUBDIR   := openjpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/openjpeg.mirror/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc lcms libpng tiff zlib

#git commit 3d95bcf
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/openjpeg.mirror/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DBUILD_TESTING=FALSE -DBUILD_PKGCONFIG_FILES=ON \
        '$(1)'
    $(MAKE) -C '$(1).build' install
endef
