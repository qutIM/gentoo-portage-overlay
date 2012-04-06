# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit flag-o-matic cmake-utils

DESCRIPTION="Extensible XMPP library"
HOMEPAGE="http://www.qutim.org/jreen"

SRC_URI="http://www.qutim.org/dwnl/33/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc"

RDEPEND=">=x11-libs/qt-core-4.6.0
		 sys-libs/zlib
		 app-crypt/qca
		 app-crypt/qca-cyrus-sasl
		 app-crypt/qca-ossl
		 net-dns/libidn"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8.0
	doc? ( app-doc/doxygen )"

RESTRICT="debug? ( strip )"

CMAKE_USE_DIR="${S}"
CMAKE_IN_SOURCE_BUILD=1

src_configure() {
	if use debug ; then
		filter-flags -O* -f*
		append-flags -O1 -g -ggdb
	fi
	cmake-utils_src_configure
}

