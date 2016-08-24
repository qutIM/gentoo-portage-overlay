# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

EGIT_BRANCH="qt4"
EGIT_HAS_SUBMODULES="true"
EGIT_PROJECT="qutim"
EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"

inherit flag-o-matic cmake-utils git-2

DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc kineticscroller mobile +sound static +webkit"

RDEPEND=">=dev-qt/qtgui-4.6.0
	webkit? ( >=dev-qt/qtwebkit-4.6.0 )
	>=dev-qt/qtmultimedia-4.6.0"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0
	doc? ( app-doc/doxygen )"

PDEPEND="net-im/qutim-l10n:${SLOT}
	x11-plugins/qutim-protocols:${SLOT}
	x11-plugins/qutim-plugins:${SLOT}"

RESTRICT="debug? ( strip )"

CMAKE_USE_DIR="${S}/core"
CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	if use debug ; then
		filter-flags -O* -f*
		append-flags -O1 -g -ggdb
	fi
	mycmakeargs=(
		-DQSOUNDBACKEND=0
		-DQUTIM_INSTALL_ICONS=1
		$(cmake-utils_use sound QUTIM_INSTALL_SOUND_THEME)
		$(cmake-utils_use webkit WEBKITCHAT)
		$(cmake-utils_use kineticscroller)
	)
	if use static ; then
		mycmakeargs+=( -DQUTIM_BASE_LIBRARY_TYPE=STATIC )
	fi
	if use mobile ; then
		mycmakeargs+=( -DMOBILESETTINGSDIALOG=1 )
	else
		mycmakeargs+=( -DSTACKEDCHATFORM=0 -DMOBILECONTACTINFO=0
					   -DMOBILEABOUT=0 -DMOBILESETTINGSDIALOG=0 )
	fi
	cmake-utils_src_configure
}

pkg_postinst() {
	einfo
	einfo "Many plugins is unstable. If you have problems with qutim try to unmerge unnecessary plugins."
	einfo
}
