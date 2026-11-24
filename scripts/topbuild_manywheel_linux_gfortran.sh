#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
	set -- cp310 cp311 cp312 cp313 cp314 cp315
fi

manylinux2014_abis=()
manylinux_2_28_abis=()
for abi in "$@"; do
	case "$abi" in
	cp310 | cp311 | cp312 | cp313) manylinux2014_abis+=("$abi") ;;
	cp314 | cp315) manylinux_2_28_abis+=("$abi") ;;
	*)
		printf 'Unsupported Python tag: %s (use cp310 through cp315)\n' "$abi" >&2
		exit 2
		;;
	esac
done

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)

build_wheels() {
	local platform="$1"
	shift
	local output_dir="$repo_dir/dist/gfortran-${platform%_x86_64}"
	mkdir -p "$output_dir"

	docker run --rm --platform linux/amd64 -i \
		--mount "type=bind,source=$repo_dir,target=/source,readonly" \
		--mount "type=bind,source=$output_dir,target=/output" \
		"quay.io/pypa/$platform:latest" bash -s -- "$platform" "$@" <<'BUILD'
set -euo pipefail

platform="$1"
shift
build_dir=$(mktemp -d)
mkdir "$build_dir/source"
cd "$build_dir/source"
cp -r /source/{LICENSE,README.md,get_version.py,meson.build,pyproject.toml,easyclimate_backend,subprojects} .
# GNU runtimes are bundled by auditwheel, so omit the Intel-only runtime requirements.
sed -i -e "/^[[:space:]]*'intel-fortran-rt',/d" -e "/^[[:space:]]*'dpcpp-cpp-rt',/d" pyproject.toml

export CC=gcc FC=gfortran
# The bundled Fortran uses legacy argument passing and long free-form lines.
export FFLAGS="-fallow-argument-mismatch -ffree-line-length-none"
mkdir wheelhouse

for abi in "$@"; do
	case "$abi" in
	cp314) numpy_version=2.3.2 ;;
	cp315) numpy_version=2.5.2 ;;
	*) numpy_version=2.2.6 ;;
	esac
	venv="$build_dir/venv-$abi"
	"/opt/python/$abi-$abi/bin/python" -m venv "$venv"
	export PATH="$venv/bin:$PATH"
	python -m pip install --only-binary=:all: \
		'meson-python==0.17.1' 'meson==1.6.0' 'build==1.2.2.post1' \
		'ninja==1.11.1.2' "numpy==$numpy_version"
	python -m build --wheel --no-isolation --outdir "wheels-$abi"
	auditwheel repair --plat "$platform" --wheel-dir wheelhouse "wheels-$abi"/*.whl
done

cp wheelhouse/*.whl /output/
BUILD
}

if ((${#manylinux2014_abis[@]} > 0)); then
	build_wheels manylinux2014_x86_64 "${manylinux2014_abis[@]}"
fi
if ((${#manylinux_2_28_abis[@]} > 0)); then
	build_wheels manylinux_2_28_x86_64 "${manylinux_2_28_abis[@]}"
fi
