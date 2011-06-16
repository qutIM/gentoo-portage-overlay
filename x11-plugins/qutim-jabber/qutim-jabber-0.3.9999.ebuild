# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils cmake-utils confutils

DESCRIPTION="Jabber protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
CMAKE_USE_DIR="${S}/protocols"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug"

EGIT_BRANCH="master"
EGIT_HAS_SUBMODULES="true"
EGIT_PROJECT="qutim-${SLOT}"

RDEPEND="net-im/qutim:${SLOT}
	>=x11-libs/qt-core-4.6.3
	sys-libs/zlib
	net-dns/libidn
	app-crypt/qca
	app-crypt/qca-cyrus-sasl
	app-crypt/qca-ossl"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"

RESTRICT="debug? ( strip )"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_ENABLE_ALL_PLUGINS=off -DJABBER=on"
	CMAKE_IN_SOURCE_BUILD=1
}

src_install() {
	cmake-utils_src_install
}
