# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4

EGIT_REPO_URI="http://git.gitorious.org/qutim/plugins.git"
EGIT_BRANCH="sdk02"                                
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Plugin manager for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
        !x11-plugins/${PN}:0.2
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
	fi
	append-flags -fPIC

	if (use tools) ; then
		mycmakeargs="-DTOOLS=true"
	fi
	mycmakeargs="${mycmakeargs} -DCMAKE_INSTALL_PREFIX=/usr -DAPPLE=0 -DUNIX=1"
	CMAKE_IN_SOURCE_BUILD=1
}

src_install() {
	cmake-utils_src_install
}

