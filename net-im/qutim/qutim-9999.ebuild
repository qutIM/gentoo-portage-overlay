# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

unset _live_inherits

if [[ ${PV} == *9999* ]]; then
	EGIT_BRANCH="master"
	EGIT_HAS_SUBMODULES="true"
	EGIT_PROJECT="qutim"
	EGIT_REPO_URI="git://github.com/euroelessar/qutim.git"
	_live_inherits=git-2
else
	SRC_URI="http://qut.im/dwnl/34/qutim-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit flag-o-matic cmake-utils ${_live_inherits}

DESCRIPTION="Multiprotocol instant messenger"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc kineticscroller mobile static +webkit"

RDEPEND=">=x11-libs/qt-gui-4.6.0
	webkit? ( >=x11-libs/qt-webkit-4.6.0 )
	>=x11-libs/qt-multimedia-4.6.0"

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
