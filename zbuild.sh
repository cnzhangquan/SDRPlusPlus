#!/bin/bash

# dnf -y install gcc g++ make cmake glfw-devel fftw-devel volk-devel rtaudio-devel libusb1-devel libzstd-devel rtl-sdr-devel ncurses-devel

rm -fr build
mkdir -p build

pushd build

cmake .. -DCMAKE_INSTALL_PREFIX=/opt/sdrpp -DOPT_BUILD_RTL_SDR_SOURCE=ON -DOPT_BUILD_SDRPLAY_SOURCE=OFF -DOPT_BUILD_AIRSPY_SOURCE=OFF -DOPT_BUILD_AIRSPYHF_SOURCE=OFF -DOPT_BUILD_HACKRF_SOURCE=OFF -DOPT_BUILD_PLUTOSDR_SOURCE=OFF

make -j4
make DESTDIR=$PWD/X install
cp ../sdrpp-dev.desktop X/opt/sdrpp/share/applications/


pushd X/opt
zip -r ../../../sdrpp-1.2.0.dev.$(date +%Y%m%d).zip sdrpp
popd

rm -fr build

popd

