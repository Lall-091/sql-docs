---
author: dlevy-msft-sql
ms.author: dlevy
ms.date: 02/05/2026
ms.service: sql
ms.topic: include
---
### [Windows](#tab/windows)

```console
pip install mssql-python
```

### [Alpine](#tab/alpine-linux)

```console
apk add libtool krb5-libs krb5-dev
pip install mssql-python
```

### [Debian/Ubuntu](#tab/debianUbuntu-linux)

```console
apt-get install -y libltdl7 libkrb5-3 libgssapi-krb5-2
pip install mssql-python
```

### [RHEL](#tab/RHEL-linux)

```console
dnf install -y libtool-ltdl krb5-libs
pip install mssql-python
```

### [SUSE](#tab/SUSE-linux)

```console
zypper install -y libltdl7 libkrb5-3 libgssapi-krb5-2
pip install mssql-python
```

### [openSUSE](#tab/openSUSE-linux)

```console
zypper install -y libltdl7
pip install mssql-python
```

### [macOS](#tab/mac)

```console
brew install openssl
pip install mssql-python
```

---
