# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_HAS_SUBMODULES="true"

inherit git-2 eutils cmake-utils confutils

EGIT_REPO_URI="git://gitorious.org/qutim/qutim.git"
EGIT_BRANCH="sdk02"
EGIT_COMMIT="${EGIT_BRANCH}"
DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://qutim.org"

LICENSE="GPL-2"
SLOT="0.2-live"
KEYWORDS=""

PROTOCOLS="+icq +jabber mrim vkontakte"
PLUGINS="histman +imagepub kde +massmessaging otr plugman sqlhistory \
	tex +urlpreview vsqlhistory weather webhistory +yandexnarod"
IUSE="debug linguas_bg linguas_cs linguas_de linguas_ru linguas_uk"
IUSE="${PROTOCOLS} ${PLUGINS} ${IUSE}"

RDEPEND=">=x11-libs/qt-gui-4.4.0
	>=x11-libs/qt-webkit-4.4.0"

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
	histman? ( x11-plugins/qutim-histman:${SLOT} )
	imagepub? ( x11-plugins/qutim-imagepub:${SLOT} )
	kde? ( kde-misc/qutim-kdeintegration:${SLOT} )
	massmessaging? ( x11-plugins/qutim-massmessaging:${SLOT} )
	otr? ( app-crypt/qutim-otr:${SLOT} )
	plugman? ( x11-plugins/qutim-plugman:${SLOT} )
	sqlhistory? ( x11-plugins/qutim-sqlhistory:${SLOT} )
	tex? ( x11-plugins/qutim-tex:${SLOT} )
	urlpreview? ( x11-plugins/qutim-urlpreview:${SLOT} )
	vsqlhistory? ( x11-plugins/qutim-vsqlhistory:${SLOT} )
	weather? ( x11-plugins/qutim-weather:${SLOT} )
	webhistory? ( x11-plugins/qutim-webhistory:${SLOT} )
	yandexnarod? ( x11-plugins/qutim-yandexnarod:${SLOT} )"

RESTRICT="debug? ( strip )"

pkg_setup() {
	confutils_use_conflict sqlhistory webhistory vsqlhistory
}

src_unpack() {
	git-2_src_unpack
}

src_prepare() {
	CMAKE_IN_SOURCE_BUILD=1
	if (use debug) ; then
		unset CFLAGS CXXFLAGS
		append-flags -O1 -g -ggdb
		CMAKE_BUILD_TYPE="Debug"
	fi

	sed -e "/find/s/${PN}\/protocol/${P}\/protocol/" \
		-e "s/CURRENT_SOURCE_DIR}\/cmake\/qutimuic/ROOT}\/Modules\/qutimuic-${PV}/" \
		-i cmake/FindQutIM.cmake
	sed -e "s/<${PN}\//<${P}\//" -i cmake/qutimuic.cmake
	sed -e "/SET/s/lib\/${PN}/lib\/${P}/" \
		-e "/TARGET/s/${PN}/${P}/" \
		-e "s/FindQutIM/FindQutIM-${PV}/" \
		-e "s/qutimuic/qutimuic-${PV}/" \
		-e "/ADD_EXE/s/${PN}/${P}/" \
		-e "/INSTALL/s/include\/${PN}/include\/${P}/" \
		-e "/INSTALL/s/applications\"/applications\" RENAME \"${P}.desktop\"/" \
		-e "/INSTALL/s/RENAME \"qutim.png\"/RENAME \"${P}.png\"/" \
		-e "/INSTALL/s/pixmaps\"/pixmaps\" RENAME \"${P}.xpm\"/" -i CMakeLists.txt
	sed -e "s/path += \"qutim\";/path += \"${P}\";/" -i src/pluginsystem.cpp
	sed -e "s/qutIM/qutIM-${SLOT}/" \
		-e "s/qutim/${P}/" -i share/qutim.desktop
	mv cmake/FindQutIM.cmake cmake/FindQutIM-${PV}.cmake
	mv cmake/qutimuic.cmake cmake/qutimuic-${PV}.cmake
	mv "include/${PN}" "include/${P}"

	for i in $(grep -rl "qutim/" "${S}/" | grep -v "\.git"); do
		sed -e "s/qutim\//qutim-${PV}\//" -i ${i};
	done
}

src_install() {
	cmake-utils_src_install
	dodir /usr/share/${P}
	mv icons/${PN}_64.png icons/${P}_64.png
	doicon icons/${P}_64.png || die "Failed to install icon"
}

pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
