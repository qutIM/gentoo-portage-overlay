# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4 cmake-utils

EGIT_REPO_URI="http://git.gitorious.org/qutim/plugins.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="MassMessaging plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
	!x11-plugins/${PN}:0.2
	!x11-plugins/${PN}:0.2-live
	!x11-plugins/${PN}:live"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

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
	mycmakeargs="-DWinTLS=0 -DCMAKE_INSTALL_PREFIX=/usr -DUNIX=1 -WIN32=0 -DAPPLE=0 \
		-DQUTIM_PATH=${EGIT_STORE_DIR}/qutim"
	CMAKE_IN_SOURCE_BUILD=1
}

src_install() {
	cmake-utils_src_install
	insinto /usr/$(get_libdir)/qutim
	doins "${S}/lib${MY_PN}.so" || die "Plugin installation failed"
}
