# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git-2 eutils qt4-r2 cmake-utils

EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
CMAKE_USE_DIR="${S}/protocols"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim"
DESCRIPTION="IRC protocol plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"

RESTRICT="debug? ( strip )"

MY_PN="oscar"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_ENABLE_ALL_PLUGINS=off -DIRC=on"
	CMAKE_IN_SOURCE_BUILD=1
# 	sed -e "s/QutimPlugin/QutimPlugin-${PV}/" -i CMakeLists.txt
#
# 	for i in $(grep -rl "qutim/" "${S}" | grep -v "\.git"); do
# 		sed -e "/#include/s/qutim\//qutim-${PV}\//" -i ${i};
# 	done
}
