<img src="https://github.com/easyatmos/easyclimate-backend/blob/main/docs/source/_static/easyclimate_backend_logo_mini.png?raw=true" alt="easyclimate-backend">

<h2 align="center">easyclimate 后端</h2>

<p align="center">
<a href="https://easyclimate-backend.readthedocs.io/en/latest/"><strong>文档</strong> (最新版)</a> •
<a href="https://easyclimate-backend.readthedocs.io/en/main/"><strong>文档</strong> (main分支)</a> •
<a href="https://easyatmos.github.io/easyclimate-backend/"><strong>文档</strong> (开发版)</a> •
<a href="https://easyatmos.github.io/easyclimate-backend/src/contributing.html"><strong>贡献指南</strong></a>
</p>


![PyPI - 版本](https://img.shields.io/pypi/v/easyclimate-backend)
![PyPI - Python版本](https://img.shields.io/pypi/pyversions/easyclimate-backend)
![PyPI - 下载量](https://img.shields.io/pypi/dm/easyclimate-backend)
[![文档状态](https://readthedocs.org/projects/easyclimate-backend/badge/?version=latest)](https://easyclimate-backend.readthedocs.io/en/latest/?badge=latest)

<div align="center">
<center><a href = "../README.md">English</a> / 简体中文 / <a href = "README_ja_JP.md">日本語</a></center>
</div>

## 🤗 什么是 easyclimate-backend?

easyclimate-backend 专为 [easyclimate](https://github.com/shenyulu/easyclimate) 承担核心运算任务而设计，使前端包能够为用户提供友好的气候分析界面。通过发挥 ``Fortran`` 和 ``C`` 语言的速度与效率优势，确保即使是最复杂的计算任务也能无缝处理。

>   🚨 **本软件包仍在快速开发阶段** 🚨
>
>   所有API（函数/类/接口）均可能变更。随着设计理念的更新和新功能的加入，可能会出现非向后兼容的改动。当前版本尚未完成，请谨慎使用。

## 😯 如何安装?

可通过 Python 包管理工具 [pip](https://pip.pypa.io/en/stable/getting-started/) 安装：

```
pip install easyclimate-backend
```

## ✨ 依赖要求

- python >= 3.10
- Numpy = 2.1.0（仅构建时依赖，编译后的wheel支持NumPy 1.24.3及以上版本，含2.x系列）
- intel-fortran-rt
- dpcpp-cpp-rt

## 🔧 构建说明

### 先决条件（通用）

- Windows：Windows 10 或更高版本
- Linux：glibc 2.28 或更高版本，包括：Debian 10+、Ubuntu 18.10+、Fedora 29+、CentOS/RHEL 8+。

### Windows

1. 安装 Intel® oneAPI HPC Toolkit
   👉 [获取 Intel® oneAPI HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html)
2. 安装 `uv`：

```powershell
winget install uv
```

3. 安装 PowerShell 7
   👉 [在 Windows 上安装 PowerShell](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.5)

4. 激活 Intel oneAPI 环境，并从项目根目录运行构建脚本：

从开始菜单打开 Intel 64 版 Visual Studio 2022（或更高版本）的 Intel oneAPI 命令提示符。

<img src="https://github.com/easyatmos/easyclimate-backend/blob/main/docs/source/_static/fig1.png?raw=true" alt="easyclimate-backend">

此时，将打开一个 cmd 终端窗口，并打印以下信息。

```
:: initializing oneAPI environment...
   Initializing Visual Studio command-line environment...
   Visual Studio version 17.14.23 environment configured.
   "C:\Program Files\Microsoft Visual Studio\2022\Community\"
   Visual Studio command-line environment initialized for: 'x64'
:  advisor -- latest
:  compiler -- latest
:  dal -- latest
:  debugger -- latest
:  dev-utilities -- latest
:  dnnl -- latest
:  dpcpp-ct -- latest
:  dpl -- latest
:  ipp -- latest
:  ippcp -- latest
:  mkl -- latest
:  mpi -- latest
:  ocloc -- latest
:  pti -- latest
:  tbb -- latest
:  umf -- latest
:  vtune -- latest
:: oneAPI environment initialized ::
```

在终端中输入 "pwsh"，然后运行命令

```powershell
pwsh
cd D:\easyclimate-backend # 用您的项目路径替换
.\scripts\build_wheel_windows.ps1
```

4. 生成的 wheel 文件将位于 `dist/` 目录中。

### Linux

1. 在您的系统上安装 Docker。
2. 在项目根目录的 Linux 主机上运行构建脚本：

```bash
cd /path/to/easyclimate-backend
./scripts/topbuild_manywheel_linux.sh
```

生成的 wheel 也将放置在 `dist/` 目录中。

## 🪐 开源软件声明

请参阅[说明文档](https://easyclimate-backend.readthedocs.io/en/latest/src/softlist.html)。
