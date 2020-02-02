project('vkBasalt', ['cpp'], default_options : ['cpp_std=c++17'], version : '0.2.2', meson_version : '>= 0.43')

add_project_arguments('-fPIC', language : 'cpp')
add_project_arguments('-DNOMINMAX', language : 'cpp')
add_project_arguments('-fvisibility=hidden', language : 'cpp')
add_project_arguments('-fvisibility-inlines-hidden', language : 'cpp')


# NOTE: Should be okay for one-time build, but can be bad for development/rebuild.
# https://mesonbuild.com/FAQ.html#why-cant-i-specify-target-files-with-a-wildcard
ls_cmd = find_program('find')

sources = run_command(ls_cmd, 'src',    '-type', 'f', '-name', '*.cpp', '-not', '-name', 'stb_image*').stdout().strip().split('\n')
shaders = run_command(ls_cmd, 'shader', '-type', 'f', '-name', '*.glsl').stdout().strip().split('\n')


# Targets for stb_image and stb_image_resize
stb_image_dep = static_library('stb_image', 'src/stb_image.cpp')


# Target for VkLayer_vkBasalt.so
shared_library('VkLayer_vkBasalt', sources, link_with: [stb_image_dep], install: true)


# Targets for vkBasalt.conf and VkLayer_vkBasalt.json
install_data('config/vkBasalt.conf',         install_dir : 'share/vkBasalt')
install_data('config/VkLayer_vkBasalt.json', install_dir : 'share/vulkan/explicit_layer.d')


# Targets for shaders/*.spv
glsl_compiler = find_program('glslangValidator')

foreach shader : shaders
  custom_target(shader.split('/')[-1] + '.target.name',
    command: [ glsl_compiler, '-V', '-Os', '@INPUT@', '-o', '@BASENAME@.spv' ],
    input: shader,
    output: '@BASENAME@.spv',
    install_dir: 'share/vkBasalt/shader',
    build_by_default: true,
    install: true)
endforeach
