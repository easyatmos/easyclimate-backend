import os
import site
import sys
from pathlib import Path

from .version import __version__

_WINDOWS_DLL_DIRECTORY_HANDLES = []


def _register_windows_dll_directories():
    if sys.platform != "win32" or not hasattr(os, "add_dll_directory"):
        return

    candidate_dirs = []
    prefixes = [
        sys.prefix,
        sys.base_prefix,
        os.environ.get("CONDA_PREFIX"),
    ]
    for prefix in prefixes:
        if prefix:
            candidate_dirs.append(Path(prefix) / "Library" / "bin")

    site_dirs = []
    try:
        site_dirs.extend(site.getsitepackages())
    except AttributeError:
        pass
    try:
        site_dirs.append(site.getusersitepackages())
    except AttributeError:
        pass

    for site_dir in site_dirs:
        site_path = Path(site_dir)
        candidate_dirs.extend(
            [
                site_path / "easyclimate_backend.libs",
                site_path / "easyclimate_backend" / ".libs",
                site_path / "Library" / "bin",
            ]
        )

    oneapi_root = os.environ.get("ONEAPI_ROOT")
    if oneapi_root:
        candidate_dirs.append(Path(oneapi_root) / "compiler" / "latest" / "bin")

    program_files_x86 = os.environ.get("ProgramFiles(x86)")
    if program_files_x86:
        candidate_dirs.append(
            Path(program_files_x86) / "Intel" / "oneAPI" / "compiler" / "latest" / "bin"
        )

    seen = set()
    for candidate_dir in candidate_dirs:
        candidate_dir = candidate_dir.resolve()
        if candidate_dir in seen or not candidate_dir.is_dir():
            continue
        seen.add(candidate_dir)
        try:
            _WINDOWS_DLL_DIRECTORY_HANDLES.append(
                os.add_dll_directory(str(candidate_dir))
            )
        except OSError:
            pass


_register_windows_dll_directories()
