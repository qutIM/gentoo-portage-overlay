# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils qt4-r2 cmake-utils

EGIT_REPO_URI="git://github.com/euroelessar/qutim.git" 
CMAKE_USE_DIR="${S}/plugins"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_PROJECT="qutim"
DESCRIPTION="AWN dock integration plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug"

RDEPEND="net-im/qutim:${SLOT}
	gnome-extra/avant-window-navigator"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6"

RESTRICT="debug? ( strip )"

MY_PN=${PN#qutim-}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_ENABLE_ALL_PLUGINS=off \
		-DAWN=on"
# 	for i in $(grep -rl "<qutim/" "${S}" | grep -v "\.git"); do
# 		sed -e "s/<qutim\//<qutim-${PV}\//" -i "${i}";
# 	done
# 	sed -e "s/qutim/qutim-${PV}/" \
# 		-e "s/QutimPlugin/QutimPlugin-${PV}/" -i "${S}/CMakeLists.txt"
# 	sed -e "s/NotificationsLayer/notificationslayer.h/" -i "${S}/src/captchasender.cpp"
	CMAKE_IN_SOURCE_BUILD=1
}
