# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git-2 eutils cmake-utils confutils

DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://www.qutim.org"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
CMAKE_USE_DIR="${S}/core"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""

IUSE="debug doc kineticscroller mobile static +webkit linguas_bg linguas_cs linguas_de linguas_ru linguas_uk"

EGIT_BRANCH="master"
EGIT_HAS_SUBMODULES="true"
EGIT_PROJECT="qutim-${SLOT}"

RDEPEND=">=x11-libs/qt-gui-4.6.0
	webkit? ( >=x11-libs/qt-webkit-4.6.0 )
	>=x11-libs/qt-multimedia-4.6.0"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0
	doc? ( app-doc/doxygen )"

PDEPEND="linguas_bg? ( net-im/qutim-l10n:${SLOT}[linguas_bg?] )
	linguas_cs? ( net-im/qutim-l10n:${SLOT}[linguas_cs?] )
	linguas_de? ( net-im/qutim-l10n:${SLOT}[linguas_de?] )
	linguas_ru? ( net-im/qutim-l10n:${SLOT}[linguas_ru?] )
	linguas_uk? ( net-im/qutim-l10n:${SLOT}[linguas_uk?] )
	x11-plugins/qutim-protocols:${SLOT}
	x11-plugins/qutim-plugins:${SLOT}"

RESTRICT="debug? ( strip )"

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
	mycmakeargs=(
		-DQSOUNDBACKEND=0
		$(cmake-utils_use webkit WEBKITCHAT)
		$(cmake-utils_use kineticscroller KINETICSCROLLER)
	)
	if (use static) ; then
		mycmakeargs+=(-DQUTIM_BASE_LIBRARY_TYPE=STATIC)
	fi
	if (use mobile) ; then
		mycmakeargs+=(-DMOBILESETTINGSDIALOG=1)
	else
		mycmakeargs+=(-DSTACKEDCHATFORM=0 -DMOBILECONTACTINFO=0
					  -DMOBILEABOUT=0 -DMOBILESETTINGSDIALOG=0)
	fi
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
