project('_s2h', 'c',
  version : '1.0.0',
  meson_version: '>=1.1.0',
  default_options : ['warning_level=2'],
)

add_languages('fortran', native: false)

py_mod = import('python')

py = py_mod.find_installation(pure: false)
py_dep = py.dependency()

incdir_numpy = run_command(py,
  ['-c', 'import os; os.chdir(".."); import numpy; print(numpy.get_include())'],
  check : true
).stdout().strip()

incdir_f2py = run_command(py,
    ['-c', 'import os; os.chdir(".."); import numpy.f2py; print(numpy.f2py.get_include())'],
    check : true
).stdout().strip()

inc_np = include_directories(incdir_numpy, incdir_f2py)

srcs_local = ['src/s2h.f']

_s2h_source = custom_target('_s2hmodule.c',
  input : ['_s2h.pyf'],
  output : ['_s2hmodule.c', '_s2h-f2pywrappers.f'],
  command : [py, '-m', 'numpy.f2py', '@INPUT@', '--lower', '--build-dir', 'subprojects/s2h']
)

py.extension_module('_s2h',
  srcs_local + _s2h_source,
  incdir_f2py / 'fortranobject.c',
  include_directories: inc_np,
  dependencies : [py_dep],
  install : true,
  install_dir: py.get_install_dir() / 'easyclimate_backend' / 's2h'
)
