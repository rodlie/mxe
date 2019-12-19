#!/bin/sh
make clean || true
rm -rf .ccache || true
make MXE_USE_CCACHE= || echo "FAILED!!!"

