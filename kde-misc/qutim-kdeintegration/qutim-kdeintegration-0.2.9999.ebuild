# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils kde4-base

EGIT_REPO_URI="http://git.gitorious.org/qutim/kde-integration.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="KDEIntegration plugin for net-im/qutim"
HOMEPAGE="http://www.qutim.org/"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64 ~ppc ~ppc64"
IUSE="emoticons +notification phonon spell debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND="${RDEPEND}
        >=dev-util/cmake-2.6
        notification? ( !x11-plugins/qutim-libnotify )
        !x11-plugins/qutim-kdeintegration:0.2
        !x11-plugins/qutim-kdeintegration:live"

RESTRICT="mirror
	debug? ( strip )"

KDE_MINIMAL="4.2"

src_unpack() {
	git_src_unpack
	# Fix
	rm -f ${S}/notification/pics/hi64-app-qutim.png
}

src_prepare() {
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="debug"
	fi
	mycmakeargs="-DUNIX=1 -DAPPLE=0 -DCMAKE_INSTALL_PREFIX=/usr"
	CMAKE_IN_SOURCE_BUILD=1
	# Исправление пути установки
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/crash/CMakeLists.txt
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/emoticons/CMakeLists.txt
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/notification/CMakeLists.txt
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/phonon/CMakeLists.txt
	sed -i "/DESTINATION/s/lib/$(get_libdir)/g" ${S}/speller/CMakeLists.txt

	if ( ! use emoticons ) ; then
		sed -i "/add_subdirectory( emoticons )/d" ${S}/CMakeLists.txt
	fi
	if ( ! use notification ) ; then
		sed -i "/add_subdirectory( notification )/d" ${S}/CMakeLists.txt
	fi
	if ( ! use phonon ) ; then
		sed -i "/add_subdirectory( phonon )/d" ${S}/CMakeLists.txt
	fi
	if ( ! use spell ) ; then
		sed -i "/add_subdirectory( speller )/d" ${S}/CMakeLists.txt
	fi
}
