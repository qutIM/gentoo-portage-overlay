# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit git-2 eutils kde4-base cmake-utils

DESCRIPTION="KDEIntegration plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org/"
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
	>=dev-util/cmake-2.6"

RESTRICT="mirror
	debug? ( strip )"

KDE_MINIMAL="4.2"

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_ENABLE_ALL_PLUGINS=0 -DKDEINTEGRATION=1"
	CMAKE_IN_SOURCE_BUILD=1
#	sed -e "s/QutimPlugin/QutimPlugin-${PV}/" -i CMakeLists.txt
#	for i in $(grep -rl "<qutim/" "${S}" | grep -v "\.git"); do
#		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
#	done
}
