# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git eutils cmake-utils confutils

EGIT_REPO_URI="http://git.gitorious.org/qutim/qutim.git"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""
IUSE="debug histman +icq +jabber mrim vkontakte
	kde +yandexnarod +imagepub +massmessaging plugman +urlpreview otr
	sqlhistory vsqlhistory webhistory
	tex weather"
	#linguas_bg linguas_cs linguas_de linguas_ru linguas_uk"

RDEPEND=">=x11-libs/qt-gui-4.4.0
	>=x11-libs/qt-webkit-4.4.0
	!net-im/qutim:0.2
	!net-im/qutim:0.2-live
	!net-im/qutim:live"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0"

PDEPEND="linguas_bg? ( net-im/qutim-l10n:${SLOT}[linguas_bg?] )
	linguas_cs? ( net-im/qutim-l10n:${SLOT}[linguas_cs?] )
	linguas_de? ( net-im/qutim-l10n:${SLOT}[linguas_de?] )
	linguas_ru? ( net-im/qutim-l10n:${SLOT}[linguas_ru?] )
	linguas_uk? ( net-im/qutim-l10n:${SLOT}[linguas_uk?] )
	icq? ( x11-plugins/qutim-icq:${SLOT} )
	jabber? ( x11-plugins/qutim-jabber:${SLOT} )
	mrim? ( x11-plugins/qutim-mrim:${SLOT} )
	vkontakte? ( x11-plugins/qutim-vkontakte:${SLOT} )
	kde? ( kde-misc/qutim-kdeintegration:${SLOT} )
	yandexnarod? ( x11-plugins/qutim-yandexnarod:${SLOT} )
	imagepub? ( x11-plugins/qutim-imagepub:${SLOT} )
	massmessaging? ( x11-plugins/qutim-massmessaging:${SLOT} )
	plugman? ( x11-plugins/qutim-plugman:${SLOT} )
	histman? ( x11-plugins/qutim-histman:${SLOT} )
	urlpreview? ( x11-plugins/qutim-urlpreview:${SLOT} )
	sqlhistory? ( x11-plugins/qutim-sqlhistory:${SLOT} )
	vsqlhistory? ( x11-plugins/qutim-vsqlhistory:${SLOT} )
	webhistory? ( x11-plugins/qutim-webhistory:${SLOT} )
	otr? ( app-crypt/qutim-otr:${SLOT} )
	tex? ( x11-plugins/qutim-tex:${SLOT} )
	weather? ( x11-plugins/qutim-weather:${SLOT} )"

RESTRICT="debug? ( strip )"

pkg_setup() {
	confutils_use_conflict sqlhistory webhistory vsqlhistory
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
