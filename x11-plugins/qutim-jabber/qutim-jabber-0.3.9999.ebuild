# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim-protocols"
DESCRIPTION="Jabber protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="+gnutls +gloox-static debug juick openssl"

RDEPEND="net-im/qutim:${SLOT}
	!gloox-static? ( >=net-libs/gloox-0.9.9.5[gnutls?,idn] )
	sys-libs/zlib
	net-dns/libidn
	openssl? ( dev-libs/openssl )
	gnutls? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	gloox-static? ( !net-libs/gloox )
	>=dev-util/cmake-2.6
	!x11-plugins/qutim-protocols:${SLOT}"

PDEPEND="juick? ( x11-plugins/qutim-juick:${SLOT} )"

RESTRICT="debug? ( strip )"

pkg_setup() {
	confutils_use_conflict gnutls openssl
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="$(cmake-utils_use openssl OpenSSL) $(cmake-utils_use gnutls GNUTLS) \
		$(cmake-utils_use !gloox-static GLOOX_EXTERNAL) \
		-DMRIM=off -DOSCAR=off -DQUETZAL=off -DVKONTAKTE=off"
	CMAKE_IN_SOURCE_BUILD=1
	sed -e "s/QutimPlugin/QutimPlugin-${PV}/" -i CMakeLists.txt
	sed -e "s/>qutim\//>qutim-${PV}\//" -i jabber/src/protocol/account/muc/jmucjoin.ui

	for i in $(grep -ril "qutim/" "${S}" | grep -v "\.git"); do
		sed -e "/#include/s/qutim\//qutim-${PV}\//" -i ${i};
	done
}

src_install() {
	cmake-utils_src_install
	 if (use gloox-static); then
		insinto /usr/$(get_libdir)
		doins "${S}/jabber/3rdparty/gloox/src/libgloox.so.9" || die "Plugin installation failed"
		dosym libgloox.so.9 /usr/$(get_libdir)/libgloox.so || die "Plugin installation failed"
	fi
}