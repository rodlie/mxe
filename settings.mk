#JOBS := 8
MXE_TARGETS := x86_64-w64-mingw32.static i686-w64-mingw32.static
MXE_PLUGIN_DIRS := plugins/gcc7 plugins/hevc
LOCAL_PKG_LIST := cc cmake lcms imagemagick7 qtbase fontconfig
.DEFAULT_GOAL := local-pkg-list
local-pkg-list: $(LOCAL_PKG_LIST)
