# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit multilib-minimal

DESCRIPTION="Frame rate limiter for Linux/OpenGL/Vulkan"
HOMEPAGE="https://gitlab.com/torkel104/libstrangle"
SRC_URI="https://gitlab.com/torkel104/libstrangle/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="
	virtual/opengl[${MULTILIB_USEDEP}]
	dev-util/vulkan-headers
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	multilib_copy_sources
}

multilib_src_configure() {
	sed -E \
		-e "s#^CC=#CC?=#" \
		-e "s#^CXX=#CXX?=#" \
		-e "s#^CFLAGS=#CFLAGS=${CFLAGS} #" \
		-e "s#^CXXFLAGS=#CXXFLAGS=${CXXFLAGS} #" \
		-e "s#^LDFLAGS=#LDFLAGS=${LDFLAGS} #" \
		-e "s#^LDXXFLAGS=#LDXXFLAGS=${LDFLAGS} #" \
		-e "s#libdir=.*#libdir=${EPREFIX}/usr/$(get_libdir)#" \
		-i makefile || die
}

multilib_src_compile() {
	emake prefix="${EPREFIX}/usr" native
}

multilib_src_install() {
	newlib.so build/libstrangle_native.so libstrangle.so
	newlib.so build/libstrangle_native_nodlsym.so libstrangle_nodlsym.so
	newlib.so build/libstrangle_vk_native.so libstrangle_vk.so
}

multilib_src_install_all() {
	newbin "${S}/src/strangle.sh" strangle
	newbin "${S}/src/stranglevk.sh" stranglevk

	insinto ${EPREFIX}/usr/share/vulkan/implicit_layer.d/
	doins "${S}/src/vulkan/libstrangle_vk.json"
	
	dodoc "${S}/README.md"
}
