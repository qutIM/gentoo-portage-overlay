# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Jabber protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="openssl +gnutls gloox-static debug juick"

RDEPEND="net-im/qutim:${SLOT}
	!gloox-static? ( >=net-libs/gloox-0.9.9.5[gnutls?,idn] )
	sys-libs/zlib
	net-dns/libidn
	openssl? ( dev-libs/openssl )
	gnutls? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	!x11-plugins/${PN}:0.2
	!x11-plugins/${PN}:0.2-live
	!x11-plugins/${PN}:live"

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
	mycmakeargs="$(cmake-utils_use ssl OpenSSL) $(cmake-utils_use gnutls GNUTLS) \
		$(cmake-utils_use !gloox-static GLOOX_EXTERNAL) -DCMAKE_INSTALL_PREFIX=/usr \
		-DMRIM=off -DOSCAR=off -DQUETZAL=off -DVKONTAKTE=off -DQUTIM_PATH=${EGIT_STORE_DIR}/qutim"
	CMAKE_IN_SOURCE_BUILD=1
}