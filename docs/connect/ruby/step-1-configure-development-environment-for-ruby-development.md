---
title: "Step 1: Configure development environment for Ruby"
description: "Step 1 of this getting started guide involves installing Ruby and an ODBC driver for SQL Server into your development environment."
author: David-Engel
ms.author: davidengel
ms.date: "03/25/2026"
ms.service: sql
ms.subservice: connectivity
ms.custom: linux-related-content
ms.topic: how-to
---
# Step 1: Configure development environment for Ruby development

Configure your development environment with the prerequisites to develop an application by using the Ruby Driver for SQL Server.

The Ruby Driver uses the TDS protocol, which is enabled by default in SQL Server and Azure SQL Database. No additional configuration is required.

## Windows

1. **Download Ruby Installer**
   If your machine doesn't have Ruby, install it. Go to the [Ruby download page](https://rubyinstaller.org/downloads/) and download the latest **Ruby+Devkit** installer for your architecture (x64 or x86). For example, download **Ruby+Devkit 3.2.x (x64)**.

1. **Install Ruby**
   Run the installer:
   1. Select your language, and agree to the terms.
   1. On the install settings screen, select the check boxes next to both **Add Ruby executables to your PATH** and **Associate `.rb` and `.rbw` files with this Ruby installation**.
   1. After installation, the MSYS2 setup dialog appears. Select option **3** (MSYS2 and MINGW development toolchain) and press **Enter** to install the build tools.

1. **Open a new command prompt**

1. **Install TinyTDS gem**
   ```
   gem install tiny_tds
   ```

> [!NOTE]
> Previous versions of Ruby (2.x) required a separate DevKit download and `dk.rb init` / `dk.rb install` commands. Ruby 3.0 and later versions include the MSYS2 DevKit in the installer, so separate DevKit setup is no longer required.

## Ubuntu Linux

1. **Open terminal**

1. **Install Ruby and prerequisites**
   ```bash
   sudo apt-get update
   sudo apt-get install -y ruby-full build-essential
   ```

1. **Verify Ruby installation**
   ```bash
   ruby -v
   ```

1. **Install FreeTDS**
   ```bash
   sudo apt-get install -y freetds-dev freetds-bin
   ```

1. **Install TinyTDS**
   ```bash
   gem install tiny_tds
   ```  
  
## macOS

macOS includes a system Ruby installation, but for best results, install a current version by using Homebrew.

1. **Open terminal**

1. **Install Homebrew package manager**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

1. **Install Ruby** (optional, if you need a newer version than the system Ruby)
   ```bash
   brew install ruby
   ```

1. **Install FreeTDS**
   ```bash
   brew install FreeTDS
   ```

1. **Install TinyTDS gem**
   ```bash
   gem install tiny_tds
   ```

## Related content

- [Step 2: Create a SQL database for Ruby development](step-2-create-a-sql-database-for-ruby-development.md)
- [Step 3: Proof of concept connecting to SQL using Ruby](step-3-proof-of-concept-connecting-to-sql-using-ruby.md)
