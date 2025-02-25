---
title: Work with Regular Expressions
description: Use regular expressions to filter and manipulate text strings in SQL Server.
author: MikeRayMSFT
ms.author: wiassaf
ms.reviewer: abhtiwar, randolphwest, wiassaf, 
ms.date: 12/31/2024
ms.service: sql
ms.topic: quickstart
helpviewer_keywords:
  - "Regular expressions functions"
  - regex
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =fabric"
---

# Regular expressions preview 

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

This article introduces regular expressions for SQL Server.

[!INCLUDE [preview](../../includes/preview.md)]

A regular expression, or regex, is a sequence of characters that defines a search pattern for text. Regex is commonly used for a variety of tasks including pattern matching, data validation, data transformation, and querying. It offers a flexible and an efficient way to search, manipulate, and handle complex data operations.

This implementation of regular expression is based on the [RE2 regular expression library](https://github.com/google/re2/). For more information, visit [RE2 Regular Expression Syntax](https://cran.r-project.org/web/packages/re2/vignettes/re2_syntax.html#:~:text=The%20simplest%20regular%20expression%20is,matches%20a%20literal%20plus%20character).

For example:

[!INCLUDE [regexp-function-descriptions](../../includes/regexp-function-descriptions.md)]

Regular expressions can be composed of literal characters and meta-characters, which have special meanings and functions.

A simple regular expression is a single literal character. Characters match themselves, except for the meta-characters. Meta-characters include `*`, `+`, `?`, `(`, `)`, or `|`. To match a meta-character, escape it with a backslash. For example, `\*` matches the literal asterisk (`*`) character.

## Accepted regular expression characters

### Single character expressions

| Kinds of single-character expressions | Examples |
|---------------------------------------|----------|
| any character, possibly including newline (s=true) | `.` |
| character class | `[xyz]` |
| negated character class | `[^xyz]` |
| [Perl character classes](#perl-character-classes) | `\d` |
| negated Perl character class | `\D` |
| [ASCII character classes](#ascii-character-classes) | `[[:alpha:]]` |
| negated ASCII character class | `[[:^alpha:]]` |
| Unicode character class (one-letter name) | `\pN` |
| Unicode character class | `\p{Greek}` |
| negated Unicode character class (one-letter name) | `\PN` |
| negated Unicode character class | `\P{Greek}` |

### Perl character classes

The following table lists currently supported Perl character classes.

| Perl character classes (all ASCII-only) | Description |
|-----------------------------------------|-------------|
| `\d`                                    | digits ( `[0-9]`) |
| `\D`                                    | not digits ( `[^0-9]`) |
| `\s`                                    | whitespace ( `[\t\n\f\r ]`) |
| `\S`                                    | not whitespace ( `[^\t\n\f\r ]`) |
| `\w`                                    | word characters ( `[0-9A-Za-z_]`) |
| `\W`                                    | not word characters ( `[^0-9A-Za-z_]`) |

## ASCII character classes

The following table lists currently supported ASCII character classes.

|ASCII character classes  |Description  |
|---------|---------|
| `[[:alnum:]]`           | alphanumeric ( `[0-9A-Za-z]`) |
| `[[:alpha:]]`           | alphabetic ( `[A-Za-z]`) |
| `[[:ascii:]]`           | ASCII ( `[\x00-\x7F]`) |
| `[[:blank:]]`           | blank ( `[\t ]`) |
| `[[:cntrl:]]`           | control ( `[\x00-\x1F\x7F]`) |
| `[[:digit:]]`           | digits ( `[0-9]`) |
| `[[:graph:]]`           |	graphical ( `[!-~]` or ``[A-Za-z0-9!“#$%&’()*+,\-./:;<=>?@[\\\]^_`{|}~]``) |
| `[[:lower:]]`           | lower case ( `[a-z]`) |
| `[[:print:]]`           | printable ( `[ -~]` or `[ [:graph:]]`) |
| `[[:punct:]]`           | punctuation ( `[!-/:-@[-\``{-~]`) |
| `[[:space:]]`           | whitespace ( `[\t\n\v\f\r ]`) |
| `[[:upper:]]`           | upper case ( `[A-Z]`) |
| `[[:word:]]`            | word characters ( `[0-9A-Za-z_]`) |
| `[[:xdigit:]]`          | hex digit ( `[0-9A-Fa-f]`) |


### Literal characters

- Letters
- Numbers
- Symbols

### Metacharacters

- `*` matches zero or more occurrences of the preceding character
- `^` matches the beginning of a line

### Groupings

Group and capture parts of the pattern with:

- Parentheses `( )`
- Brackets `[ ]`
- Braces `{ }`

### Flags

Use flags to modify the expression behavior. For example:

- `i`
- `m`
- `s`
- `c`

This implementation supports the POSIX standard of regular expressions following RE2, and has support for the PCRE/PCRE2 flavor of regular expressions syntax, which is compatible with most modern regular expression engines and tools. There are different flavors of regular expressions, such as POSIX, ANSI, Perl, and PCRE, which have different syntax and features.

## Requirements

- A SQL client tool, such as Azure Data Studio, SQL Server Management Studio, or Visual Studio Code.
- A basic knowledge of SQL syntax and queries.
- A basic understanding of regular expression syntax and concepts.

## FAQ

### What is the performance impact of using regex?

Regex queries may have a performance impact depending on the complexity of the regex pattern, the size of the text data, and the number of rows involved. You can use the execution plan and statistics to monitor and optimize the performance of your regex queries.

## Known Issues, behaviors, and limitations

These are the items that are not currently supported in this preview:

- LOB data types (**varchar(max)** or **nvarchar(max)**) for `string_expressions`
- Regular expression functions are not supported on memory-optimized OLTP tables

## Related content

- [Regular expressions functions preview (Transact-SQL)](../../t-sql/functions/regular-expressions-functions-transact-sql.md)