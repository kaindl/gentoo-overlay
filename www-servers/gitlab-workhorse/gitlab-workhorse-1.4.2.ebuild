# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils user

DESCRIPTION="This is the new backend for Git-over-HTTP communication needed for GitLab >= 8.4"
HOMEPAGE="https://gitlab.com/gitlab-org/gitlab-workhorse"
SRC_URI="https://gitlab.com/gitlab-org/${PN}/repository/archive.tar.bz2?ref=v${PV} -> ${P}.tar.bz2"

MY_GIT_COMMIT="a0f050c8fc680faa2c758c11ad2815cfe367db44"
S="${WORKDIR}/${PN}-v${PV}-${MY_GIT_COMMIT}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"

DEPEND=">=dev-lang/go-1.5.1"

src_prepare() {
	epatch "${FILESDIR}/0001-fix-Makefile.patch"
	sed -i -e "s/@@VERSION@@/${PV}/" Makefile
	eapply_user
}

src_install() {
	local dest=/usr/bin

	diropts -m755
	dodir ${dest}

	exeinto ${dest}
	for f in "${PN}" gitlab-zip-cat gitlab-zip-metadata ; do
		doexe "${S}/${f}"
	done

	## RC script ##
	newinitd "${FILESDIR}/${PN}-0.8.2.init" "${PN}"
	newconfd "${FILESDIR}/${PN}-0.8.2.conf" "${PN}"
}
