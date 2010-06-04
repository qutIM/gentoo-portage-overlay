# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4 cmake-utils

EGIT_REPO_URI="http://git.gitorious.org/qutim/plugins.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim-plugins"
DESCRIPTION="Plugin manager for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="debug tools"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

DOCS="AUTHORS changelog"

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
	sed -e "/FIND_PATH/s/qutim/qutim-${PV}/" -e "/INSTALL/s/qutim/qutim-${PV}/" -i "${S}/CMakeLists.txt"
	for i in $(grep -ril "<qutim/" "${S}" | grep -v "\.git"); do
		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
	done
	CMAKE_IN_SOURCE_BUILD=1
}

