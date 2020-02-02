# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit meson multilib-minimal

DESCRIPTION="A vulkan post processing layer"
HOMEPAGE="https://github.com/DadSchoorse/vkBasalt"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/DadSchoorse/vkBasalt.git"
	EGIT_SUBMODULES=()
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/DadSchoorse/vkBasalt/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64"
	S="${WORKDIR}/vkBasalt-${PV}"
fi

LICENSE="ZLIB"
SLOT="0"

RESTRICT="test"

RDEPEND="media-libs/vulkan-loader[${MULTILIB_USEDEP},layers]"

BDEPEND="dev-util/vulkan-headers
	dev-util/glslang
	>=dev-util/meson-0.49"

DEPEND="${RDEPEND}"

src_prepare() {
	# meson build
	cp "${FILESDIR}/meson.build" ${S}/

	# Vulkan explicit layer file
	cp "${FILESDIR}/VkLayer_vkBasalt.json" ${S}/config/

	# Ignore Debug messages
	for sfile in ${S}/src/*.cpp; do
		sed -E \
			-e 's/(^ *std::cout.*$)/#ifdef LAYER_DEBUG\n\1\n#endif/g' \
			-i "${sfile}"
	done

	default
}

multilib_src_configure() {
	local emesonargs=(
		--unity=on
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}
