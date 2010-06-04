# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim-protocols"
DESCRIPTION="Jabber protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="openssl +gnutls +gloox-static debug juick"

RDEPEND="net-im/qutim:${SLOT}
	!gloox-static? ( >=net-libs/gloox-0.9.9.5 )
	sys-libs/zlib
	net-dns/libidn
	openssl? ( dev-libs/openssl )
	gnutls? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"

PDEPEND="juick? ( x11-plugins/qutim-juick:${SLOT} )"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

pkg_setup() {
	confutils_use_conflict gnutls openssl
	if ! (use gloox-static) && (use gnutls) ; then
		confutils_require_built_with_any net-libs/gloox gnutls
	fi
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	S=${S}/${MY_PN}
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="\
		$(cmake-utils_use ssl OpenSSL) \
		$(cmake-utils_use gnutls GNUTLS) \
		$(cmake-utils_use !gloox-static GLOOX_SHARED)"
	CMAKE_IN_SOURCE_BUILD=1
	sed -e "s/qutim/qutim-${PV}/" -i "${S}/CMakeLists.txt"

	for i in $(grep -ril "<qutim/" "${S}" | grep -v "\.git"); do
		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
	done
}

src_install() {
	cmake-utils_src_install
	dodir "/usr/include/qutim-${PV}"
	cp "${S}"/include/qutim/*.h "${D}/usr/include/qutim-${PV}/" || die "Failed to install headers"
}
