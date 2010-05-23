# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="All protocol plugins for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug +gloox-static +gnutls +icq +jabber juick mrim openssl quetzal vkontakte"

RDEPEND="net-im/qutim:${SLOT}
	jabber? ( net-dns/libidn
		sys-libs/zlib
		!gloox-static? ( >=net-libs/gloox-0.9.9.5[gnutls?,idn] )
		gnutls? ( net-libs/gnutls )
		openssl? ( dev-libs/openssl ) )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	!x11-plugins/qutim-icq
	!x11-plugins/qutim-jabber
	!x11-plugins/mrim
	!x11-plugins/quetzal
	!x11-plugins/vkontakte"

PDEPEND="jabber? ( juick? ( x11-plugins/qutim-juick:${SLOT} ) )"

RESTRICT="debug? ( strip )"

pkg_setup() {
	 if use jabber; then
		confutils_use_conflict gnutls openssl
	fi
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
		$(cmake-utils_use !gloox-static GLOOX_EXTERNAL) $(cmake-utils_use icq OSCAR) \
		$(cmake-utils_use jabber JABBER) $(cmake-utils_use mrim MRIM) \
		$(cmake-utils_use quetzal QUETZAL) $(cmake-utils_use vkontakte VKONTAKTE) \
		-DCMAKE_INSTALL_PREFIX=/usr -DQUTIM_PATH=${EGIT_STORE_DIR}/qutim"
	CMAKE_IN_SOURCE_BUILD=1
}

# src_install() {
# 	cmake-utils_src_install
# 	insinto /usr/$(get_libdir)/qutim
# 	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
# }
