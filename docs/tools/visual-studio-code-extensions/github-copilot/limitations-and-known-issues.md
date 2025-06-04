---
title: "Limitations and Known Issues with GitHub Copilot for MSSQL"
description: Learn about the limitations, nongoals, and known constraints of GitHub Copilot integration with the MSSQL extension for Visual Studio Code.
author: croblesm
ms.author: roblescarlos
ms.reviewer: randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: vs-code-sql-extensions
ms.topic: conceptual
ms.collection:
  - data-tools
  - ce-skilling-ai-copilot
ai-usage: ai-assisted
ms.custom:
  - build-2025
---

# Limitations and known issues

This article outlines the limitations and known constraints of GitHub Copilot integration with the MSSQL extension for Visual Studio Code. This experience is designed for application developers building with SQL databases, not for database administrators managing infrastructure or production environments. Understanding these boundaries ensures proper expectations and supports a productive development workflow.

## Functional Limitations

- GitHub Copilot **does not have permission to write data**. All generated SQL or ORM (Object-Relational Mapping) code must be manually reviewed and executed by the developer.
- The `@mssql` chat participant **requires an active database connection** via the editor to provide schema-aware suggestions.
- AI-generated responses **should always be reviewed** before use. GitHub Copilot might produce incorrect or suboptimal recommendations.
- This experience is **designed for developers**, not for database or system administrators. While it can generate SQL scripts for administrative tasks, GitHub Copilot does **not support server management operations** such as configuring backup/restore, managing user permissions, or handling SQL Agent jobs.
- GitHub Copilot **does not execute code**. It only suggests code based on context, it will not apply schema changes or run scripts automatically.
- GitHub Copilot sessions **do not persist history when switching context** (for example, changing files or databases). New context resets the chat memory.
- The chat participant operates **within the scope of the currently connected database**. Cross-database operations aren't supported.
- The integration is **optimized for modern SQL Database in Fabric, Azure SQL Database, and SQL Server**. Legacy/deprecated features might be unsupported.
- **Azure Synapse Analytics** and its Dedicated SQL pool (formerly SQL DW) features **are not supported** by this GitHub Copilot integration.
- GitHub Copilot provides the best suggestions when it has access to rich context. Keep your database connection active and relevant code or queries open in the editor. The more context GitHub Copilot has, the more accurate and relevant its suggestions will be.

## Technical Constraints

- **Internet connectivity is required**. GitHub Copilot needs access to the GitHub Copilot cloud service to provide suggestions.
- GitHub Copilot **only accesses open files and the active database connection**. It can't browse folders or repositories unless explicitly opened in the editor.
- GitHub Copilot **does not support offline usage** or disconnected development.
- **Advanced performance tuning** (for example, full telemetry analysis, workload insights) is out of scope. The assistant might suggest optimizations for individual queries but doesn't replace professional tuning tools.
- GitHub Copilot might struggle with deeply nested or multi-join queries, particularly when working with large datasets or under-specified schema context.

## Privacy and Telemetry

- GitHub Copilot does **not persist chat interactions**. Prompts and responses are routed through GitHub's privacy-preserving proxy service without being stored.
- **User prompts and completions are NOT used** to train the Copilot models.
- No chat content is stored by the MSSQL extension or GitHub Copilot.
- **Telemetry collected by the extension is limited** to usage analytics for improving the product and doesn't include personal data.

## Known GitHub Copilot Limitations

These limitations apply to GitHub Copilot more broadly and might affect your experience in the MSSQL extension:

- GitHub Copilot **might hallucinate APIs or schema elements** that don't exist, especially if context is limited.
- GitHub Copilot **does not have real-time knowledge of remote files** unless they're open in your editor.
- GitHub Copilot **does not track variable types or state across long conversations**; results might drift in relevance.

## Share your experience

We'd love to hear your thoughts on GitHub Copilot for the MSSQL extension! Your feedback helps us improve the experience and better support SQL development in Visual Studio Code.

To share feedback or report issues, use the GitHub feedback template: [GitHub Copilot Feedback](https://aka.ms/vscode-mssql-copilot-feedback)

Even brief comments about what's working well, or where you're running into limitations, are extremely helpful.

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
