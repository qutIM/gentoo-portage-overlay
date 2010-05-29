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
IUSE="debug histman icq jabber kde mrim yandexnarod +massmessaging +meta-protocols"
	#linguas_bg linguas_cs linguas_de linguas_ru linguas_uk"

RDEPEND=">=x11-libs/qt-gui-4.4.0
	>=x11-libs/qt-webkit-4.4.0
	>=x11-libs/qt-multimedia-4.4.0
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
	meta-protocols? ( x11-plugins/qutim-protocols
		!x11-plugins/qutim-icq
		!x11-plugins/qutim-jabber
		!x11-plugins/qutim-mrim
		!x11-plugins/qutim-quetzal
		!x11-plugins/qutim-vkontakte )
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

HTML_DOCS=( "${D}/share/${PN}/doc" )

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
	## slotting... ##
#	sed -e "/PROJECT/s/${PN}/${P}/" \
#		-e "/ADD_/s/${PN}/${P}/" -e "/set_target/s/${PN}/${P}/" \
#		-e "/TARGET_LINK/s/${PN}/${P}/" -e "s/QutimPlugin/Qutim-${PV}-Plugin/" \
#		-e "/INSTALL/s/${PN}/${P}/" -e "s/^[ \t]*lib${PN}/lib${P}/" -i CMakeLists.txt
#	sed -e "s/${PN}/${P}/" -i libqutim/CMakeLists.txt
#	sed -e "/exec/s/qutim/${P}/" -i share/applications/qutim.desktop
	
# 	for i in $(grep -ril qutim_64 "${S}" | grep -v "\.git"); do
# 		einfo "qutim_64: ${i}"
# 		sed -e "s/qutim_64/${P}_64/" -i ${i};
# 	done
# 	
# 	for i in $(grep -ril qutim.png "${S}" | grep -v "\.git"); do
# 		einfo "qutim.png: ${i}"
# 		sed -e "s/qutim.png/${P}.png/" -i ${i};
# 	done
}

# src_preinst() {
# 	mv cmake/QutimPlugin.cmake "cmake/Qutim-${PV}-Plugin.cmake"
# 	mv icons/qutim_64.png "icons/${P}_64.png"
# 	mv share/applications/qutim.desktop "share/applications/${P}.desktop"
# 	mv share/icons/hicolor/64x64/apps/qutim.png "share/icons/hicolor/64x64/apps/${P}.png"
# 	mv share/icons/hicolor/scalable/apps/qutim.svg "share/icons/hicolor/scalable/apps/${P}.svg"
# 	mv share/pixmaps/qutim.xpm "share/pixmaps/${P}.xpm"
# 	mv share/qutim "share/${P}"
# 	## end of slotting  ##
# }

src_install() {
	cmake-utils_src_install
	doicon "icons/${PN}_64.png" || die "Failed to install icon"
	#doicon "icons/${P}_64.png" || die "Failed to install icon"
	dosym "lib${P}.so" "/usr/$(get_libdir)/lib${PN}.so"
}

pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
