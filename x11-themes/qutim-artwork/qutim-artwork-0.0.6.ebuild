# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Artwork for net-im/qutim"
HOMEPAGE="http://www.qutim.org"
LICENSE="GPL-2"

FTPIURI="ftp://svtdpi_guest:wPeBC4J@www.svtdpi.com.ua/artwork/"
SRC_URI="${FTPIURI}/chatstyles/qutim_chatstyle_1.tar.bz2
	${FTPIURI}/smileys/emoticons-tango-smile.zip
	${FTPIURI}/smileys/qip_infium_smile_pack.tar.bz2
	${FTPIURI}/traythemes/qutim_traythemes.tar.bz2
	${FTPIURI}/statusicons/qutim_statusicons.tar.bz2
	${FTPIURI}/webkitstyles/qutim-webkitstyle.tar.bz2
	sounds? ( ${FTPIURI}/sounds/qutim_sounds_2.tar.bz2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sounds"

CHATSTYLES="Peabody_Classic
	Aandy_Minimalizm"

WEBKITSTYLES=""

SMILEYS="Tango-smile
	qip_infium_smile_pack"

TRAYTHEMES="Aero_by_Faust
	Cherry_by_Faust
	Chlorine2
	Chlorine3
	pink
	pink-no-avatar
	Tango"

SOUNDS="Cosmiq
	ICQ6
	QIP
	Starpack
	Trillian
	Worms"

STATUSICONS="Kolobok
	MacOS
	QIP
	RQ1
	RQ2
	Tango"

RESTRICT="mirror"

DEPEND="net-im/qutim:0.2-live"

S=${WORKDIR}

src_prepare()
{
	mkdir emoticons
	for FILE in ${SMILEYS} ; do
		if [ -e ${FILE} ] ; then
			mv ${FILE} emoticons
		fi
	done;

	mkdir traythemes
	for FILE in ${TRAYTHEMES} ; do
		if [ -e ${FILE} ] ; then
			mv ${FILE} traythemes
		fi
	done;

	if (use sounds) ; then
		mkdir sounds
		for FILE in ${SOUNDS} ; do
			if [ -e ${FILE} ] ; then
				mv ${FILE} sounds
			fi
		done;
	fi
}

src_install()
{
	SHARE_DIR="usr/share/qutim-0.2.9999"
	dodir "${SHARE_DIR}"
	mv {chatstyle,webkitstyle,emoticons,traythemes,statusicons} "${D}/${SHARE_DIR}/"

	if (use sounds) ; then
		mv sounds "${D}/${SHARE_DIR}/"
	fi
}

pkg_postinst()
{
	if (use sounds) ; then
		elog ""
		elog "To use the sounds you need to import them in qutim settings."
		elog ""
	fi
}