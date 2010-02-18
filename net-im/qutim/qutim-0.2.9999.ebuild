# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/qutim.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS="~x86 ~amd64"
IUSE="debug histman +icq +jabber mrim vkontakte
      kde +yandexnarod +imagepub +massmessaging plugman +urlpreview otr
      sqlhistory webhistory
      linguas_bg linguas_cs linguas_de linguas_ru linguas_ua"

DEPEND=">=dev-util/cmake-2.6.0
        >=x11-libs/qt-gui-4.4.0
        >=x11-libs/qt-webkit-4.4.0
        !net-im/qutim:0.2
        !net-im/qutim:live"
RDEPEND="${DEPEND}"
if (use linguas_bg) || (use linguas_cs) || (use linguas_de) || (use linguas_ru) || (use linguas_ua) ; then
	PDEPEND="net-im/qutim-l10n:${SLOT}"
fi
PDEPEND="${PDEPEND}
         icq? ( x11-plugins/qutim-icq:${SLOT} )
         jabber? ( x11-plugins/qutim-jabber:${SLOT} )
         mrim? ( x11-plugins/qutim-mrim:${SLOT} )
         vkontakte? ( x11-plugins/qutim-vkontakte:${SLOT} )
         kde? ( kde-misc/qutim-kdeintegration:${SLOT} )
         yandexnarod? ( x11-plugins/qutim-yandexnarod:${SLOT} )
         imagepub? ( x11-plugins/qutim-imagepub:${SLOT} )
         massmessaging? ( x11-plugins/qutim-massmessaging:${SLOT} )
         plugman? ( x11-plugins/qutim-plugman:${SLOT} )
         urlpreview? ( x11-plugins/qutim-urlpreview:${SLOT} )
         sqlhistory? ( x11-plugins/qutim-sqlhistory:${SLOT} )
         webhistory? ( x11-plugins/qutim-webhistory:${SLOT} )
         otr? ( app-crypt/qutim-otr:${SLOT} )"

RESTRICT="debug? ( strip )"

pkg_setup() {
	confutils_use_conflict sqlhistory webhistory
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	CMAKE_IN_SOURCE_BUILD=1
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="Debug"
	fi
	mycmakeargs="-DUNIX=1 -DBSD=0 -DAPPLE=0 -DMINGW=0 -DWIN32=0	-DCMAKE_INSTALL_PREFIX=/usr"
	sed -i "/plugin_path +=/s/lib/$(get_libdir)/" ${S}/src/pluginsystem.cpp
}

src_install() {
	cmake-utils_src_install
	dodir /usr/share/${PN}
	doicon icons/${PN}_64.png || die "Failed to install icon"
}


pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
