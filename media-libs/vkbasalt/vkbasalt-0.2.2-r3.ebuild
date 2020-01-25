# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit meson multilib-minimal

DESCRIPTION="A vulkan post processing layer"
HOMEPAGE="https://github.com/DadSchoorse/vkBasalt"

EGIT_REPO_URI="https://github.com/DadSchoorse/vkBasalt.git"
EGIT_SUBMODULES=()
EGIT_BRANCH="wip-reshade-fx"
inherit git-r3
SRC_URI=""
KEYWORDS="-* ~amd64"

LICENSE="ZLIB"
SLOT="0"

RESTRICT="test"

RDEPEND="media-libs/vulkan-loader[${MULTILIB_USEDEP},layers]
	dev-util/reshade-shaders"

BDEPEND="dev-util/vulkan-headers
	dev-util/glslang
	dev-util/reshade-fx
	>=dev-util/meson-0.49"

DEPEND="${RDEPEND}"

src_prepare() {
	# meson build
	cp "${FILESDIR}/vkbasalt-0.3.0-meson.build" ${S}/meson.build

	# Vulkan explicit layer file
	cp "${FILESDIR}/VkLayer_vkBasalt.json" ${S}/config/

	default

	# Ignore Debug messages
	for sfile in ${S}/src/*.cpp; do
		sed -E \
			-e 's/(^ *std::cout.*$)/#ifdef LAYER_DEBUG\n\1\n#endif/g' \
			-i "${sfile}"
	done

	# Fix ReShadeFX path
	for sfile in ${S}/src/*; do
		sed -E \
			-e 's#../reshade/source/#reshade/#g' \
			-i "${sfile}"
	done
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
