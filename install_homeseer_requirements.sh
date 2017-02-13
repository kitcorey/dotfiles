#!/usr/bin/env bash
install_requirements() {
    apt_options="--assume-yes"
    apt-get $apt_options install mono-vbnc
    apt-get $apt_options install libmono-system-web4.0.cil
    apt-get $apt_options install libmono-system-design4.0.cil
    apt-get $apt_options install libmono-system-web-extensions4.0-cil
    apt-get $apt_options install libmono-system-runtime-caching4.0-cil
    apt-get $apt_options install flite
    apt-get $apt_options install chromium-browser
}

download_homeseer() {
    homeseer_tar=homeseer.tar
    if [ ! -e "$homeseer_tar" ] ; then
        wget -O $homeseer_tar http://homeseer.com/updates3/hs3_linux_3_0_0_297.tar.gz
        tar xvf $homeseer_tar
    fi
}

#install_requirements
download_homeseer
