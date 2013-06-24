# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P=lib${PN}\-${PV}

if [[ ${PV} != *9999* ]]; then
	SRC_URI="http://qutim.org/dwnl/44/libjreen-1.1.1.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-2"
	EGIT_REPO_URI="git://github.com/euroelessar/jreen.git"
	KEYWORDS=""
fi

inherit qt4-r2 cmake-utils ${GIT_ECLASS}

DESCRIPTION="Qt XMPP library"
HOMEPAGE="https://github.com/euroelessar/jreen"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="
	>=app-crypt/qca-2.0.3
	>=app-crypt/qca-ossl-2.0
	>=app-crypt/qca-cyrus-sasl-2.0
	>=net-dns/libidn-1.20
	>=dev-qt/qtcore-4.6.0:4
	>=dev-qt/qtgui-4.6.0:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
