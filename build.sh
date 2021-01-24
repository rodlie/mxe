#!/bin/bash
CLEAN=${CLEAN:-0}

if [ "$CLEAN" = 1 ]; then
    make clean || true
    rm -rf .ccache || true
fi

make MXE_USE_CCACHE= || echo "FAILED!!!"
