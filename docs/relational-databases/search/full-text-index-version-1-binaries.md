---
title: "List of Version 1 Filters and Word Breakers"
titleSuffix: SQL Server Full-Text Search
description: View list of SQL Server Full-Text Search version 1 filters and word breakers.
author: rwestMSFT
ms.author: randolphwest
ms.date: 01/12/2026
ms.service: sql
ms.subservice: search
ms.topic: concept-article
helpviewer_keywords:
  - "full-text search [SQL Server], word breakers"
  - "full-text search [SQL Server], filters"
  - "filters [full-text search]"
  - "word breakers [full-text search]"
monikerRange: "=azuresqldb-current || >=sql-server-2016 || >=sql-server-linux-2017 || =azuresqldb-mi-current"
---
# List of version 1 filters and word breakers (SQL Server Search)

[!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] installs new word breakers and filters, replacing all the previous versions of these components. Binaries installed with [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] are called **version 2**, and binaries installed with [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)] and earlier versions are called **version 1**.

To keep using version 1 binaries after performing an in-place upgrade to [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)], copy the filter, word breaker, and other dependent binaries from the previous [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] instance's `C:\Program Files\Microsoft SQL Server\MSSQL16.<instance-name>\MSSQL\Binn` directory to the corresponding `C:\Program Files\Microsoft SQL Server\MSSQL17.<instance-name>\MSSQL\Binn` folder.

The upgrade preserves the associated registry settings and doesn't remove them in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)].

## List of version 1 filters

| Filter | Extension | CLSID |
| --- | --- | --- |
| `msfte.dll` | `.asm`, `.bat`, `.c`, `.cmd`, `.cpp`, `.cxx`, `.def`, `.dic`, `.h`, `.hpp`, `.hxx`, `.ibq`, `.idl`, `.inc`, `.inf`, `.ini`, `.inx`, `.js`, `.log`, `.m3u`, `.pl`, `.rc`, `.reg`, `.rtf`, `.txt`, `.url`, `.vbs`, `.wtx` | `C7310720-AC80-11D1-8DF3-00C04FB6EF4F` |
| `nlhtml.dll` | `.ascx`, `.asp`, `.aspx`, `.hhc`, `.htm`, `.html`, `.htw`, `.htx`, `.odc`, `.stm` | `E0CA5340-4534-11CF-B952-00AA0051FE20` |
| `xmltfilt.dll` | `.xml` | `41B9BE05-B3AF-460C-BF0B-2CDD44A093B1` |

## List of version 1 word breakers

| Language | LCID | Word breaker | Other dependent files | CLSID |
| --- | --- | --- | --- | --- |
| Neutral | 0 | `NaturalLanguage6.dll` | `NlsData0000.dll` | `1D49F57D-47D2-4AEE-A69B-593EC558773F` |
| Arabic | 1025 | `MsWb7.dll` | `Prm0001.bin` | `04B37E30-C9A9-4A7D-8F20-792FC87DDF71` |
| Bulgarian | 1026 | `NaturalLanguage6.dll` | `NlsData0002.dll`<br />`NlsLexicons0002.dll` | `B675B948-FBA8-46A4-A4C7-D4291785127B` |
| Catalan | 1027 | `NaturalLanguage6.dll` | `NlsData0003.dll`<br />`NlsLexicons0003.dll` | `3D0B8752-68F8-4F39-929D-DE20ED323F45` |
| Traditional Chinese | 1028 | `MsWb70404.dll` | `NL7Data0404.dll`<br />`NL7Lexicons0404.dll`<br />`NL7Models0404.dll` | `E9B1DF65-08F1-438B-8277-EF462B23A792` |
| Czech | 1029 | `MsWb7.dll` | `Prm0005.bin` | `468BFC77-3876-4A47-A6FF-F5F6E8EA7968` |
| Danish | 1030 | `MsWb7.dll` | `Prm0006.bin` | `4645F4F2-6359-4D81-BFB5-DAFBF89812B4` |
| German | 1031 | `MsWb7.dll` | `Prm0007.bin` | `DFA00C33-BF19-482E-A791-3C785B0149B4` |
| Greek | 1032 | `MsWb7.dll` | `Prm0008.bin` | `0F7679E0-1386-493C-AF00-DAC67B1B16B1` |
| English | 1033 | `MsWb7.dll` | `Prm0009.bin` | `9FAED859-0B30-4434-AE65-412E14A16FB8` |
| French | 1036 | `NaturalLanguage6.dll` | `NlsData000c.dll`<br />`NlsLexicons000c.dll` | `92F2118A-E813-4A4D-9DE2-F96A9DC02C53` |
| Hebrew | 1037 | `NaturalLanguage6.dll` | `NlsData000d.dll`<br />`NlsLexicons000d.dll` | `E5B2CB7A-FD35-4D4B-A147-176FEB42244B` |
| Icelandic | 1039 | `NaturalLanguage6.dll` | `NlsData000f.dll`<br />`NlsLexicons000f.dll` | `53DA1CBB-0F45-46A4-AA6E-47CAAD84C921` |
| Italian | 1040 | `NaturalLanguage6.dll` | `NlsData0010.dll`<br />`NlsLexicons0010.dll` | `7E352021-69D6-4553-86AC-430B0D8FF913` |
| Japanese | 1041 | `MsWb70011.dll` | `NL7Data0011.dll`<br />`NL7Lexicons0011.dll`<br />`NL7Models0011.dll` | `04096682-6ECE-4E9E-90C1-52D81F0422ED` |
| Korean | 1042 | `korwbrkr.dll` | `korwbrkr.lex` | `737FC9B5-BC66-4953-B7DB-B79A72A592A5` |
| Dutch | 1043 | `MsWb7.dll` | `Prm0013.bin` | `69483C30-A9AF-4552-8F84-A0796AD5285B` |
| Bokmål | 1044 | `NaturalLanguage6.dll` | `NlsData0414.dll`<br />`NlsLexicons0414.dll` | `A9C6B8DD-3CBB-44CB-AA44-4B1C0DBB404D` |
| Polish | 1045 | `MsWb7.dll` | `Prm0015.bin` | `0D5EBEA3-B982-46B9-9378-4C238262C12C` |
| Brazilian | 1046 | `NaturalLanguage6.dll` | `NlsData0416.dll`<br />`NlsLexicons0416.dll` | `A25A5CCD-80F4-4E02-AADD-7F39CC55E737` |
| Romanian | 1048 | `NaturalLanguage6.dll` | `NlsData0018.dll`<br />`NlsLexicons0018.dll` | `D0458F37-2228-4FC7-9E66-34133DF4C929` |
| Russian | 1049 | `MsWb7.dll` | `Prm0019.bin` | `AAA3D3BD-6DE7-4317-91A0-D25E7D3BABC3` |
| Croatian | 1050 | `NaturalLanguage6.dll` | `NlsData001a.dll`<br />`NlsLexicons001a.dll` | `712720F4-F4FF-46CF-B6EC-2CC24FC873A5` |
| Slovak | 1051 | `NaturalLanguage6.dll` | `NlsData001b.dll`<br />`NlsLexicons001b.dll` | `2652B813-2260-4EF3-A311-74A7AC6513D7` |
| Swedish | 1053 | `NaturalLanguage6.dll` | `NlsData001d.dll`<br />`NlsLexicons001d.dll` | `2CB861BB-B1B4-4E14-A1A7-D3FB30C3F5CF` |
| Thai | 1054 | `MsWb7001e.dll` | `NL7Data001e.dll`<br />`NL7Lexicons001e.dll`<br />`NL7Models001e.dll` | `F70C0935-6E9F-4EF1-9F06-7876536DB900` |
| Turkish | 1055 | `MsWb7.dll` | `Prm001f.bin` | `54A12380-E78E-4980-BD96-2EF7076B5BB0` |
| Urdu | 1056 | `NaturalLanguage6.dll` | `NlsData0020.dll`<br />`NlsLexicons0020.dll` | `F3AEB884-58C8-40CF-AED3-E7EEFFFAA04A` |
| Indonesian | 1057 | `NaturalLanguage6.dll` | `NlsData0021.dll`<br />`NlsLexicons0021.dll` | `F7B02D8A-65DB-41CB-894D-5BBBF96C1B42` |
| Ukrainian | 1058 | `NaturalLanguage6.dll` | `NlsData0022.dll`<br />`NlsLexicons0022.dll` | `773229CD-D53C-4211-ACD8-8F2C7BF2AE7C` |
| Slovenian | 1060 | `NaturalLanguage6.dll` | `NlsData0024.dll`<br />`NlsLexicons0024.dll` | `8A899610-150A-40DB-B57A-940EDB3203CE` |
| Latvian | 1062 | `NaturalLanguage6.dll` | `NlsData0026.dll`<br />`NlsLexicons0026.dll` | `C700F6EF-A80F-4B24-922A-32308B6FF0C3` |
| Lithuanian | 1063 | `NaturalLanguage6.dll` | `NlsData0027.dll`<br />`NlsLexicons0027.dll` | `1C0D39B2-C788-40D2-B062-FDF8293D7BC6` |
| Vietnamese | 1066 | `NaturalLanguage6.dll` | `NlsData002a.dll`<br />`NlsLexicons002a.dll` | `70878DCD-56F6-4681-BC52-BC7F58EDF723` |
| Hindi | 1081 | `NaturalLanguage6.dll` | `NlsData0039.dll`<br />`NlsLexicons0039.dll` | `0F0549A6-C2E0-442A-85D7-20E3DB9B6A1F` |
| Malay - Malaysia | 1086 | `NaturalLanguage6.dll` | `NlsData003e.dll`<br />`NlsLexicons003e.dll` | `EB6C9433-4AAB-4B71-8B18-8F7A3812E43A` |
| Bengali (India) | 1093 | `NaturalLanguage6.dll` | `NlsData0045.dll`<br />`NlsLexicons0045.dll` | `05C9DA2B-6DFF-42C7-81CC-706DAE08BC7A` |
| Punjabi | 1094 | `NaturalLanguage6.dll` | `NlsData0046.dll`<br />`NlsLexicons0021.dll` | `9FE6E853-B35F-4FE4-B006-33148455093E` |
| Gujarati | 1095 | `NaturalLanguage6.dll` | `NlsData0047.dll`<br />`NlsLexicons0047.dll` | `04DA8451-7F63-4870-A4D7-F55BE66BFDFB` |
| Tamil | 1097 | `NaturalLanguage6.dll` | `NlsData0049.dll`<br />`NlsLexicons0049.dll` | `6C53A912-47C6-4959-B342-DF6C9DA9D494` |
| Telugu | 1098 | `NaturalLanguage6.dll` | `NlsData004a.dll`<br />`NlsLexicons004a.dll` | `136E0057-D7ED-4B85-9F62-1318CFE1573B` |
| Kannada | 1099 | `NaturalLanguage6.dll` | `NlsData0004.dll`<br />`NlsLexicons0004.dll` | `4495524E-2E54-472D-86D7-D671CA588F01` |
| Malayalam | 1100 | `NaturalLanguage6.dll` | `NlsData004c.dll`<br />`NlsLexicons004c.dll` | `69ED626B-904D-4DEF-B919-9EF7E4E339DD` |
| Marathi | 1102 | `NaturalLanguage6.dll` | `NlsData004e.dll`<br />`NlsLexicons004e.dll` | `8B3302D7-95F6-4BC5-A06A-0D6DEF15DB69` |
| Simplified Chinese | 2052 | `MsWb70804.dll` | `NL7Data0804.dll`<br />`NL7Lexicons0804.dll`<br />`NL7Models0804.dll` | `E0831C90-BAB0-4CA5-B9BD-EA254B538DAC` |
| British English | 2057 | `MsWb7.dll` | `Prm0009.bin` | `9FAED859-0B30-4434-AE65-412E14A16FB8` |
| Portuguese | 2070 | `NaturalLanguage6.dll` | `NlsData0816.dll`<br />`NlsLexicons0816.dll` | `C4BF21DA-F1E5-4C7F-A611-2698645B19EF` |
| Serbian (Latin) | 2074 | `NaturalLanguage6.dll` | `NlsData081a.dll`<br />`NlsLexicons081a.dll` | `EE38A9FC-437F-4D03-A593-BB92AF0D153C` |
| Chinese (Hong Kong SAR, PRC) | 3076 | `MsWb70404.dll` | `NL7Data0404.dll`<br />`NL7Lexicons0404.dll`<br />`NL7Models0404.dll` | `E9B1DF65-08F1-438B-8277-EF462B23A792` |
| Spanish | 3082 | `NaturalLanguage6.dll` | `NlsData000a.dll`<br />`NlsLexicons000a.dll` | `68DC71DC-2327-4040-8F03-50D6A9805049` |
| Serbian (Cyrillic) | 3098 | `NaturalLanguage6.dll` | `NlsData0c1a.dll`<br />`NlsLexicons0c1a.dll` | `C28DA8E5-39C2-4F62-82FA-C61D39A196DF` |
| Chinese (Singapore) | 4100 | `MsWb70804.dll` | `NL7Data0804.dll`<br />`NL7Lexicons0804.dll`<br />`NL7Models0804.dll` | `E0831C90-BAB0-4CA5-B9BD-EA254B538DAC` |
| Chinese (Macao SAR) | 5124 | `MsWb70404.dll` | `NL7Data0404.dll`<br />`NL7Lexicons0404.dll`<br />`NL7Models0404.dll` | `E9B1DF65-08F1-438B-8277-EF462B23A792` |

## Related content

- [View or change registered filters and word breakers (SQL Server Search)](view-or-change-registered-filters-and-word-breakers.md)
- [Configure and Manage Filters for Search](configure-and-manage-filters-for-search.md)
- [Configure and manage word breakers and stemmers for search (SQL Server)](configure-and-manage-word-breakers-and-stemmers-for-search.md)
