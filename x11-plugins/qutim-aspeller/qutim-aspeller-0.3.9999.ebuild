# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils qt4-r2 cmake-utils

DESCRIPTION="Aspeller plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
CMAKE_USE_DIR="${S}/plugins"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug"

EGIT_BRANCH="master"
EGIT_HAS_SUBMODULES="true"
EGIT_PROJECT="qutim-${SLOT}"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	app-text/aspell"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_ENABLE_ALL_PLUGINS=off \
		-DASPELLER=on"
# 	for i in $(grep -rl "<qutim/" "${S}" | grep -v "\.git"); do
# 		sed -e "s/<qutim\//<qutim-${PV}\//" -i "${i}";
# 	done
# 	sed -e "s/qutim/qutim-${PV}/" \
# 		-e "s/QutimPlugin/QutimPlugin-${PV}/" -i "${S}/CMakeLists.txt"
	CMAKE_IN_SOURCE_BUILD=1
}
