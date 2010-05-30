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
	sed -e "/Exec/s/qutim/${P}/" -i share/applications/qutim.desktop
	mv "${S}/cmake/QutimPlugin.cmake" "${S}/cmake/Qutim-${PV}-Plugin.cmake"
	mv "${S}/icons/qutim_64.png" "${S}/icons/${P}_64.png"
	mv "${S}/share/applications/qutim.desktop" "${S}/share/applications/${P}.desktop"
	mv "${S}/share/icons/hicolor/64x64/apps/qutim.png" "${S}/share/icons/hicolor/64x64/apps/${P}.png"
	mv "${S}/share/icons/hicolor/scalable/apps/qutim.svg" "${S}/share/icons/hicolor/scalable/apps/${P}.svg"
	mv "${S}/share/pixmaps/qutim.xpm" "${S}/share/pixmaps/${P}.xpm"
	mv "${S}/share/qutim" "${S}/share/${P}"
	sed -e "/SET/s/PLUGINS_DEST \"lib\/qutim/PLUGINS_DEST \"lib\/${P}/" \
		-e "/ADD_EXE/s/${PN}/${P}/" -e "/set_target/s/${PN}/${P}/" \
		-e "/TARGET_LINK/s/${PN}/${P}/" -e "s/^[ \t]*lib${PN}/lib${P}/" \
		-e "/INSTALL/s/${PN}/${P}/" -e "s/QutimPlugin/Qutim-${PV}-Plugin/" -i CMakeLists.txt
	sed -e "/install/s/PREFIX}\/share/PREFIX}\/share\/doc/" -e "s/${PN}/${P}/" \
		-e "/install/s/DIR}\/doc/DIR}\/doc\/html/" -i libqutim/CMakeLists.txt
	sed -e "s/QutimPlugin/Qutim-${PV}-Plugin/" -i examples/autosettingsitem/CMakeLists.txt
	sed -e "s/QutimPlugin/Qutim-${PV}-Plugin/" -i examples/simplesettingsdialog/CMakeLists.txt

	for i in $(grep -ril qutim_64 "${S}" | grep -v "\.git"); do
# 		einfo "qutim_64: ${i}"
		sed -e "s/qutim_64/${P}_64/" -i ${i};
	done
	
	for i in $(grep -ril qutim.png "${S}" | grep -v "\.git"); do
# 		einfo "qutim.png: ${i}"
		sed -e "s/qutim.png/${P}.png/" -i ${i};
	done
	## end of slotting... ##
}

src_install() {
	cmake-utils_src_install
	mv "${D}/usr/$(get_libdir)/lib${P}.so" "${D}/usr/$(get_libdir)/lib${PN}.so.${PV}"
	doicon "icons/${P}_64.png" || die "Failed to install icon"
	dosym "lib${PN}.so.${PV}" "/usr/$(get_libdir)/lib${PN}.so"
	dosym "${P}" "/usr/bin/${PN}"
}

pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
