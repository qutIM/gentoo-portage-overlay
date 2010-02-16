# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="sdk02"                                
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Jabber protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64"
IUSE="openssl +gnutls +gloox-static debug juick"

RDEPEND="net-im/qutim:${SLOT}
         !gloox-static? ( >=net-libs/gloox-0.9.9.5 )
         sys-libs/zlib
         net-dns/libidn
         openssl? ( dev-libs/openssl )
         gnutls? ( net-libs/gnutls )"

DEPEND="${RDEPEND}
        >=dev-util/cmake-2.6
        !x11-plugins/qutim-jabber:0.2
        !x11-plugins/qutim-jabber:live"

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
	mycmakeargs="-DWinTLS=0 -DCMAKE_INSTALL_PREFIX=/usr -DUNIX=1 -WIN32=0 -DAPPLE=0"
	if (use openssl) ; then
		mycmakeargs="${mycmakeargs} -DOpenSSL=1 -DGNUTLS=0"
	fi
	if (use gnutls) ; then
		mycmakeargs="${mycmakeargs} -DOpenSSL=0 -DGNUTLS=1"
	fi
	if (use gloox-static) ; then
		mycmakeargs="${mycmakeargs} -DGLOOX_SHARED=0"
	else
		mycmakeargs="${mycmakeargs} -DGLOOX_SHARED=1"
	fi
	CMAKE_IN_SOURCE_BUILD=1
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/CMakeLists.txt
}


src_install() {
	cmake-utils_src_install
	into /usr
	dodir /usr/include/qutim
	cp ${S}/include/qutim/*.h ${D}/usr/include/qutim/ || die "Failed to install headers"
}
