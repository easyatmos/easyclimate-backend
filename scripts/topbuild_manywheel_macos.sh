#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -s) != Darwin || $(uname -m) != arm64 ]]; then
	printf '%s\n' 'This wheel build requires native arm64 macOS.' >&2
	exit 2
fi

python_command=${PYTHON:-python3.13}
if ! python_version=$(
	"$python_command" - <<'PYTHON'
import platform
import sys
import sysconfig

if (
    platform.machine() != "arm64"
    or sys.implementation.name != "cpython"
    or sysconfig.get_config_var("Py_GIL_DISABLED")
):
    sys.exit(1)

print(f"{sys.version_info.major}.{sys.version_info.minor}")
PYTHON
); then
	printf '%s\n' 'Set PYTHON to a native arm64 CPython executable with the GIL enabled.' >&2
	exit 2
fi

case "$python_version" in
3.10 | 3.11 | 3.12 | 3.13) numpy_version=2.2.6 ;;
3.14) numpy_version=2.3.2 ;;
3.15) numpy_version=2.5.2 ;;
*)
	printf 'Unsupported Python version: %s (use 3.10 through 3.15).\n' "$python_version" >&2
	exit 2
	;;
esac

if ! gcc_version=$(gfortran -dumpversion) || ! command -v "gcc-${gcc_version%%.*}" >/dev/null; then
	printf '%s\n' 'Install Homebrew GCC and put its bin directory on PATH.' >&2
	exit 2
fi

# The WRF OpenMP dependency uses GNU flags in both C and Fortran targets.
export CC="gcc-${gcc_version%%.*}" FC=gfortran
export FFLAGS='-fallow-argument-mismatch -ffree-line-length-none'

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
build_dir=$(mktemp -d)
trap 'rm -rf -- "$build_dir"' EXIT

"$python_command" -m venv "$build_dir/venv"
export PATH="$build_dir/venv/bin:$PATH"

mkdir "$build_dir/source"
cd "$build_dir/source"
cp -R "$repo_dir"/{LICENSE,README.md,get_version.py,meson.build,pyproject.toml,easyclimate_backend,subprojects} .
# Delocate bundles the GNU runtimes. Omit Intel-only requirements in the staged source.
sed -i '' -e "/^[[:space:]]*'intel-fortran-rt',/d" -e "/^[[:space:]]*'dpcpp-cpp-rt',/d" pyproject.toml

python -m pip install --only-binary=:all: \
	'meson-python==0.17.1' 'meson==1.6.0' 'build==1.2.2.post1' \
	ninja "numpy==$numpy_version" delocate
python -m build --wheel --no-isolation --outdir "$build_dir/wheels"
delocate-wheel --require-archs arm64 -w "$build_dir/wheelhouse" "$build_dir/wheels/"*.whl

output_dir="$repo_dir/dist/macos-arm64"
mkdir -p "$output_dir"
cp "$build_dir/wheelhouse/"*.whl "$output_dir/"
