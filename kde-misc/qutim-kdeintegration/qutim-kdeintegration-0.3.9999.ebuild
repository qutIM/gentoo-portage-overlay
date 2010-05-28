# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils kde4-base

EGIT_REPO_URI="http://git.gitorious.org/qutim/kde-integration.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="KDEIntegration plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org/"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="emoticons +notification phonon spell debug"

RDEPEND="net-im/qutim:${SLOT}
	notification? ( !x11-plugins/qutim-libnotify )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	!x11-plugins/${PN}:0.2
	!x11-plugins/${PN}:0.2-live
	!x11-plugins/${PN}:live"

RESTRICT="mirror
	debug? ( strip )"

KDE_MINIMAL="4.2"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DQUTIM_PATH=/usr/$(get_libdir)/qutim"
	CMAKE_IN_SOURCE_BUILD=1
	
	sed -e "/set(QUTIM_CMAKE/s/\${QUTIM_PATH}\/cmake/\${CMAKE_ROOT}\/Modules/" \
		-i CMakeLists.txt
}
