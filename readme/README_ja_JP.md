<img src="https://github.com/easyatmos/easyclimate-backend/blob/main/docs/source/_static/easyclimate_backend_logo_mini.png?raw=true" alt="easyclimate-backend">

<h2 align="center">easyclimateのバックエンド</h2>

<p align="center">
<a href="https://easyclimate-backend.readthedocs.io/en/latest/"><strong>ドキュメント</strong> (最新版)</a> •
<a href="https://easyclimate-backend.readthedocs.io/en/main/"><strong>ドキュメント</strong> (mainブランチ)</a> •
<a href="https://easyatmos.github.io/easyclimate-backend/"><strong>ドキュメント</strong> (開発版)</a> •
<a href="https://easyatmos.github.io/easyclimate-backend/src/contributing.html"><strong>コントリビューション</strong></a>
</p>


![PyPI - バージョン](https://img.shields.io/pypi/v/easyclimate-backend)
![PyPI - Pythonバージョン](https://img.shields.io/pypi/pyversions/easyclimate-backend)
![PyPI - ダウンロード数](https://img.shields.io/pypi/dm/easyclimate-backend)
[![ドキュメント状態](https://readthedocs.org/projects/easyclimate-backend/badge/?version=latest)](https://easyclimate-backend.readthedocs.io/en/latest/?badge=latest)

<div align="center">
<center><a href = "../README.md">English</a> / <a href = "README_zh_CN.md">简体中文</a> / 日本語</center>
</div>


## 🤗 easyclimate-backendとは？

easyclimate-backendは[easyclimate](https://github.com/shenyulu/easyclimate)の基盤処理を担当し、フロントエンドパッケージがユーザーフレンドリーな気象解析インターフェースを提供できるように設計されています。``Fortran``と``C``言語の速度と効率性を活用することで、最も計算量の多いタスクでもシームレスに処理します。

>   🚨 **本パッケージは急速な開発進行中** 🚨
>
>   全てのAPI（関数/クラス/インターフェース）は変更される可能性があります。設計思想の更新や新機能追加に伴い、後方互換性のない変更が発生する場合があります。完成版ではないため、利用には注意が必要です。

## 😯 インストール方法

Pythonパッケージ管理ツール[pip](https://pip.pypa.io/en/stable/getting-started/)を使用してインストール可能です：

```
pip install easyclimate-backend
```

## ✨ 動作要件

- Python >= 3.10
- Numpy = 2.1.0（ビルド時のみ必須。ビルド済みwheelはNumPy 1.24.3以降（2.x系含む）に対応）
- intel-fortran-rt
- dpcpp-cpp-rt

## 🔧 ビルド手順

### 前提条件（一般）

- Windows：Windows 10 以上
- Linux：glibc 2.28 以降、以下を含む：Debian 10+、Ubuntu 18.10+、Fedora 29+、CentOS/RHEL 8+。

### Windows

1. Intel® oneAPI HPC Toolkit をインストール
   👉 [Intel® oneAPI HPC Toolkit を入手](https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html)
2. `uv` をインストール：

```powershell
winget install uv
```

3. PowerShell 7 をインストール
   👉 [Windows に PowerShell をインストールする](https://learn.microsoft.com/ja-jp/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.5)

4. Intel oneAPI 環境をアクティブ化し、プロジェクトのルートからビルドスクリプトを実行：

スタートメニューから、Intel 64 版 Visual Studio 2022（またはそれ以上のバージョン）の Intel oneAPI コマンド プロンプトを開きます。

<img src="https://github.com/easyatmos/easyclimate-backend/blob/main/docs/source/_static/fig1.png?raw=true" alt="easyclimate-backend">

この時点で、cmd ターミナルウィンドウが開き、以下の情報が表示されます。

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

ターミナルで "pwsh" と入力し、次にコマンドを実行します。

```powershell
pwsh
cd D:\easyclimate-backend # プロジェクトパスを置き換え
.\scripts\build_wheel_windows.ps1
```

4. 生成された wheel ファイルは `dist/` ディレクトリにあります。

### Linux

1. システムに Docker をインストール。
2. プロジェクトのルートにある Linux ホストでビルドスクリプトを実行：

```bash
cd /path/to/easyclimate-backend
./scripts/topbuild_manywheel_linux.sh
```

生成された wheel も `dist/` ディレクトリに配置されます。

## 🪐 オープンソースソフトウェア声明

[説明文書](https://easyclimate-backend.readthedocs.io/en/latest/src/softlist.html)を参照してください。