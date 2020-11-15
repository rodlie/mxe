#JOBS := 8
MXE_TARGETS := i686-w64-mingw32.static x86_64-w64-mingw32.static
MXE_PLUGIN_DIRS := plugins/gcc7 plugins/hevc
LOCAL_PKG_LIST := cc imagemagick7 qtbase fontconfig
#LOCAL_PKG_LIST := cc cmake qtbase fontconfig lcms imagemagick7
.DEFAULT_GOAL := local-pkg-list
local-pkg-list: $(LOCAL_PKG_LIST)
