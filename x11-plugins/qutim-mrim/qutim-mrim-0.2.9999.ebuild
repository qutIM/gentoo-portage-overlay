# Copyright 1999-2008 Gentoo Foundation             
# Distributed under the terms of the GNU General Public License v2
# $Header: $                                                      

EAPI="2"

inherit git eutils cmake-utils

EGIT_REPO_URI="http://git.gitorious.org/qutim/protocols.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="@Mail.Ru protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND="net-im/qutim:0.2-live"

DEPEND="${RDEPEND}
        >=dev-util/cmake-2.6
        !x11-plugins/qutim-mrim:live
        !x11-plugins/qutim-mrim:0.2"

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
	mycmakeargs="-DAPPLE=0 -DUNIX=1 -DWIN32=0 -DCMAKE_INSTALL_PREFIX=/usr"
	CMAKE_IN_SOURCE_BUILD=1
	sed -i '/if ( !WIN32 )/d' ${S}/CMakeLists.txt
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/CMakeLists.txt
}
