# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit git-2 eutils kde4-base

EGIT_REPO_URI="git://gitorious.org/qutim/plugins.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="KDEIntegration plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org/"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""
IUSE="emoticons notification phonon spell debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6
	notification? ( !x11-plugins/qutim-libnotify )"

RESTRICT="mirror
	debug? ( strip )"

KDE_MINIMAL="4.2"

src_unpack() {
	git-2_src_unpack
	# Fix
	rm -f "${S}/notification/pics/hi64-app-qutim.png"
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	CMAKE_IN_SOURCE_BUILD=1
	# Исправление пути установки

	mv notification/qutim.notifyrc "notification/qutim-${PV}.notifyrc"
	for i in . crash emoticons notification phonon speller; do
		sed -e "s/qutim/qutim-${PV}/" -i "${i}/CMakeLists.txt"
	done

	for i in $(grep -ril "<qutim/" "${S}" | grep -v "\.git"); do
		sed -e "s/<qutim\//<qutim-${PV}\//" -i ${i};
	done

	if ( ! use emoticons ) ; then
		sed -i "/add_subdirectory( emoticons )/d" "${S}/CMakeLists.txt"
	fi
	if ( ! use notification ) ; then
		sed -i "/add_subdirectory( notification )/d" "${S}/CMakeLists.txt"
	fi
	if ( ! use phonon ) ; then
		sed -i "/add_subdirectory( phonon )/d" "${S}/CMakeLists.txt"
	fi
	if ( ! use spell ) ; then
		sed -i "/add_subdirectory( speller )/d" "${S}/CMakeLists.txt"
	fi
}