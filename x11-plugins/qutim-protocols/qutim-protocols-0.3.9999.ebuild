# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Protocols meta ebuild for net-im/qutim"
HOMEPAGE="http://www.qutim.org"

LICENSE="GPL-2"
SLOT="0.3-live"
KEYWORDS=""

PROTOCOLS_GOOD="+icq +jabber irc vkontakte mrim"
PROTOCOLS_BAD="astral libpurple"

IUSE="${PROTOCOLS_GOOD} ${PROTOCOLS_BAD} debug"

RDEPEND="net-im/qutim:${SLOT}"

DEPEND=${RDEPEND}

PDEPEND="astral? ( x11-plugins/qutim-astral:${SLOT}[debug?] )
	icq? ( x11-plugins/qutim-icq:${SLOT}[debug?] )
	irc? ( x11-plugins/qutim-irc:${SLOT}[debug?] )
	jabber? ( x11-plugins/qutim-jabber:${SLOT}[debug?] )
	libpurple? ( x11-plugins/qutim-quetzal:${SLOT}[debug?] )
	mrim? ( x11-plugins/qutim-mrim:${SLOT}[debug?] )
	vkontakte? ( x11-plugins/qutim-vkontakte:${SLOT}[debug?] )"

RESTRICT="debug? ( strip )"

pre_src_unpack() {
	# Some Bash magick
	useArr=$(echo $USE | tr ";" "\n")
	for oneUse in $useArr
	do
	  if (has $oneUse $PROTOCOLS_BAD) ; then
	    ewarn "WARNING: You have enabled the build of the ${oneUse} protocol which is known to be not working for now"
	  fi
	done
}
