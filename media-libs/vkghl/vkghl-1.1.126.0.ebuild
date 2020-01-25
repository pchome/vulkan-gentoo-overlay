# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/LunarG/VulkanTools.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/LunarG/VulkanTools/archive/sdk-${PV}.tar.gz -> VulkanTools-sdk-${PV}.tar.gz"
	S="${WORKDIR}/VulkanTools-sdk-${PV}"
fi

inherit python-any-r1 cmake-multilib flag-o-matic

DESCRIPTION="Force anisotropy, mip LOD Bias, VSYNC and limit frame rate for Vulkan-driven games"
HOMEPAGE="https://github.com/pchome/VkGHL"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="X wayland"

DEPEND="${PYTHON_DEPS}
	dev-util/vulkan-headers
	media-libs/vulkan-loader:=[${MULTILIB_USEDEP},wayland?,X?]
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)"

src_prepare() {
	cmake-utils_src_prepare

	# clear layers we won't build
	for d in layer_factory/*_layer; do rm -r "${d}"; done
	
	# create/copy layer files
	local layer_dir="${S}/layer_factory/VkGHL"
	mkdir -p "${layer_dir}"
	echo '#include "vkghl.h"' > "${layer_dir}/interceptor_objects.h"

	cp "${FILESDIR}/README.md" "${S}"
	cp "${FILESDIR}/vkghl.h" "${layer_dir}"
	
	# fix Vulkan 1.2 uint64_t return
	sed -E \
		-e "s#(^.*)'uint32_t': (.*$)#\1'uint32_t': \2\n\1'uint64_t': \2#" \
		-i "${S}/scripts/layer_factory_generator.py" || die
}

multilib_src_configure() {
	append-cppflags "-I/usr/include/vulkan"

	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_TESTS=OFF
		-DBUILD_LAYERSVT=OFF
		-DBUILD_VKTRACE=OFF
		-DBUILD_VIA=OFF
		-DBUILD_VLF=ON
		-DBUILD_LAYERMGR=OFF
		-DBUILD_VKTRACE_REPLAY=OFF
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_LOADER_INSTALL_DIR="/usr"
		-DVULKAN_VALIDATIONLAYERS_INSTALL_DIR="/usr"
		-DVULKAN_HEADERS_INSTALL_DIR="/usr"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install

	# move /usr/etc/vulkan to /usr/share/vulkan
	[ ! -d "${ED}/usr/share/vulkan" ] && mv "${ED}/usr/etc/vulkan" "${ED}/usr/share/"
	rm -r "${ED}/usr/etc"
}
