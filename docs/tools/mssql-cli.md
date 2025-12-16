---
title: mssql-cli
description: "mssql-cli is an interactive command-line query tool for SQL Server that runs on Windows, macOS, or Linux."
author: rwestMSFT
ms.author: randolphwest
ms.reviewer: alayu, maghan
ms.date: 12/16/2025
ms.service: sql
ms.subservice: tools-other
ms.topic: concept-article
ms.collection:
  - data-tools
ms.custom:
  - tools|mssql-cli
  - linux-related-content
monikerRange: "=azuresqldb-current || =azure-sqldw-latest || >=sql-server-2016 || >=sql-server-linux-2017"
---

# mssql-cli command-line query tool for SQL Server (Preview)

[!INCLUDE [sql-asdb-asa](../includes/applies-to-version/sql-asdb-asa.md)]

> [!IMPORTANT]  
> **mssql-cli** is deprecated. We recommend that you use **sqlcmd** (Go) instead. For more information, see [sqlcmd utility](sqlcmd/sqlcmd-utility.md).

**mssql-cli** is an interactive command-line tool for querying SQL Server and runs on Windows, macOS, or Linux.

## Install mssql-cli

For detailed installation instructions, see the [Installation guide](https://github.com/dbcli/mssql-cli/tree/master/doc/installation). The most common install scenarios are summarized in the following sections.

### Windows and macOS installation

**mssql-cli** is installed on Windows and macOS using `pip`:

```bash
pip install mssql-cli
```

For more detailed instructions, see the [Installation guide](https://github.com/dbcli/mssql-cli/tree/master/doc/installation).

### Linux installation

After you register the Microsoft repository, **mssql-cli** can be installed and upgraded through package managers on several Linux distributions.

The following example applies to Ubuntu 18.04 (Bionic), more information and examples for other distributions can be found in the [Installation guide](https://github.com/dbcli/mssql-cli/tree/master/doc/installation).

- Import the public repository GPG keys:

  ```bash
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
  ```

- Register the Microsoft Ubuntu repository:

  ```bash
  sudo apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod
  ```

- Update the list of products:

  ```bash
  sudo apt-get update
  ```

- Install **mssql-cli**:

  ```bash
  sudo apt-get install mssql-cli
  ```

- Install missing dependencies:

  ```bash
  sudo apt-get install -f
  ```

## mssql-cli documentation

Documentation for **mssql-cli** is located in the [mssql-cli GitHub repository](https://github.com/dbcli/mssql-cli).

- [Main page/readme](https://github.com/dbcli/mssql-cli)
- [Installation guide](https://github.com/dbcli/mssql-cli/tree/master/doc/installation)
- [Usage guide](https://github.com/dbcli/mssql-cli/blob/master/doc/usage_guide.md)

## Related content

- [sqlcmd utility](sqlcmd/sqlcmd-utility.md)
