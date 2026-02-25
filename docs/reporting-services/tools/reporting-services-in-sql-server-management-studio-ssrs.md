---
title: "Reporting Services in SQL Server Management Studio"
description: View information about how to perform reporting tasks and how to create and manage shared schedules in the web portal using SQL Server Management Studio.
ms.date: 02/24/2026
ms.service: reporting-services
ms.subservice: tools
ms.topic: concept-article
ms.custom:
  - updatefrequency5
helpviewer_keywords:
  - "report servers [Reporting Services], how-to topics"
---
# Reporting Services in SQL Server Management Studio (SSRS)
  Report server administrators can use [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)] to:  
  
-   Enable features, set server defaults, and manage running jobs.  
  
-   View custom reports. In Object Explorer, most nodes display a custom reports option. You must have administrator permissions. The schema of a custom report must match the schema of the installed reports. For more information, see [Custom reports in Management Studio](/ssms/object/custom-reports-in-management-studio) and [Find the report definition schema version &#40;SSRS&#41;](../../reporting-services/reports/find-the-report-definition-schema-version-ssrs.md).  
  
 The next section contains links to articles that contain step-by-step instructions for performing various reporting tasks using [!INCLUDE[ssManStudio](../../includes/ssmanstudio-md.md)]. You can also create and manage shared schedules in the web portal.  
  
## In this section  
  
-   [Connect to a Report Server in Management Studio](../../reporting-services/tools/connect-to-a-report-server-in-management-studio.md)  
  
-   [Set report server properties &#40;Management Studio&#41;](../../reporting-services/tools/set-report-server-properties-management-studio.md)  
  
-   [Create, delete, or modify a role &#40;Management Studio&#41;](../../reporting-services/security/role-definitions-create-delete-or-modify.md)  
  
-   [Cancel report server jobs &#40;Management Studio&#41;](../../reporting-services/tools/cancel-report-server-jobs-management-studio.md)  

## Report Server in Management Studio help

This section includes articles about the dialog boxes in [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)] that you can use to manage report servers.

### Cancel report server jobs

Use the **Cancel Report Server Jobs** dialog box to view or cancel in-progress reports. This dialog box shows all jobs that are currently running on the report server. Although you can't pause or restart jobs that are currently processing, you can cancel all jobs or individual jobs if they're taking too long to complete.

You can cancel user jobs and system jobs.

- A user job is any job that an individual user initiates. This job includes running a report on-demand, manually creating a report history snapshot, or manually creating report execution snapshot. An in-progress standard subscription is also a user job.

- A system job is one that the report server initiates. System jobs include scheduled report processing.

To open this page, start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)], connect to a report server, right-click **Jobs**, and then select **Cancel All Jobs**. You can also open **Jobs**, right-click a job that is running on the report server, and select **Cancel Job(s)**.

Before canceling a job, you can view its properties to determine when the job started. For more information, see [Job properties &#40;Management Studio&#41;](../../reporting-services/tools/job-properties-management-studio.md).

> [!NOTE]
> This feature is not supported in [!INCLUDE[ssExpress](../../includes/ssexpress-md.md)] with Advanced Services. The page does not appear when you are running [!INCLUDE[ssExpress](../../includes/ssexpress-md.md)].

**Options**

**Name** - Shows the name of the report. You can identify subscriptions by their descriptions.

**Type** - Valid values are **User** and **System**.

**Start Time** - Shows when the job started.

**User Name** - For jobs that are initiated by a user, this column shows the name of the user.

**Status** - Shows the status of the job. Valid values are **New** and **Running**. Status is always **New** when the job begins. After 60 seconds, status changes to **Running**. You must refresh the page to pick up the change.

**OK** - Cancel a single job or multiple jobs. The jobs are canceled immediately and can't be resumed. If you mistakenly cancel a job, you must request the report or subscription again to start a new job.

### Delete catalog items

Use this page to delete shared schedules and role definitions.

If you delete a shared schedule that is used by multiple reports and subscriptions, the report server creates individual schedules for each report and subscription that previously used the shared schedule. Each new individual schedule contains the date, time, and recurrence pattern that was specified in the shared schedule. [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] doesn't provide central management of individual schedules. If you delete a shared schedule, you now need to maintain the schedule information for each individual item. Before deleting a shared schedule, use the [Reports page](#schedule-properties-reports-page) to determine the reports that currently use the shared schedule.

For role definitions, you can only delete those definitions that aren't actively used in a role assignment. If you try to delete a role that is currently in use, the report server doesn't delete the role and you see an error message to that effect. If this page contains a single role definition that isn't currently in use, you delete it when you select **OK**. If this page contains multiple roles, you can't select which roles to keep or remove. All unused role definitions are deleted when you select **OK**.

You can't undo a delete operation. To recover an item that you deleted, you must either recreate it or restore a backup copy of the report server database.

**Options**

**Name** - Specifies the name of the item you're deleting.

**Type** - Shows the type of item you're deleting.

**Owner** - Shows the name of the owner. In most cases, this name is System.

**Status** - Shows progress information for a delete operation.

**Error** - Displays an error code if an error occurs while deleting an item.

### Job properties

Use the **Job Properties** page to view information about an in-progress report or subscription before you cancel it.

To open this page, start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)], connect to a report server, and open the **Jobs** folder. Right-click a job that is running, and then select **Properties**.

> [!NOTE]
> This feature is not supported in [!INCLUDE[ssExpress](../../includes/ssexpress-md.md)] with Advanced Services. The page does not appear when you are running [!INCLUDE[ssExpress](../../includes/ssexpress-md.md)].

**Tasks**

Before you can view information about a job, refresh the page to retrieve information about jobs that are currently running on the report server:

1. Open the report server folder.

2. Right-click **Jobs**, and then select **Refresh**.

3. If a job is listed, right-click the job, and then select **Properties**.

**Options**

**Job ID** - A GUID that is assigned to a job while it's processing. The value is randomly generated each time a report or subscription runs.

**Job Status** - Valid values are **New** and **Running**. Status is always **New** when the job begins. After 60 seconds, status changes to **Running**. You must refresh the page to pick up the change.

**Job Type** - Valid values are **User** and **System**. A user job is any job that an individual user initiates. This job includes running a report on-demand, manually generating a report history snapshot, or manually creating a report execution snapshot. An in-progress standard subscription is also a user job. A system job is a job that the report server initiates. System jobs include report processing that a schedule triggers.

**Job Action** - For reports, this column shows the report execution processes that are underway. This value is always **Render**.

**Job Description** - [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] doesn't provide job descriptions by default.

**Server Name** - Shows the name of the report server that is processing the job. If you configured a scale-out deployment, this value shows which server is processing the job.

**Report Name** - Shows the name of the report. You can identify subscriptions by their descriptions.

**Report Path** - Shows the path of the report in the report server folder hierarchy.

**Start Time** - Shows when the process started.

**User Name** - For processes initiated by a user, this column shows the name of the user. For system jobs, the user name is the name of the report server.

### New shared schedule

Use this page to create a shared schedule to run published reports and subscriptions. Shared schedules can be used in place of report-specific or subscription-specific schedules. Centralized schedule information and the ability to pause and resume scheduled operations are two key features that distinguish shared schedules from item-specific schedules.

Not all frequency combinations can be supported in a single schedule. For example, if you want to run a report at 12:00 P.M. and 4:00 P.M. every Friday, you must create two daily schedules. These schedules should specify a Friday run date, with one having a start time of 12:00 P.M. and the other with a start time of 4:00 P.M.

Schedule processing is based on the local time of the report server that hosts and processes the schedule.

To open this page, start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)], connect to a report server, right-click **Shared Schedule**, and select **New Schedule**. To save the schedule, SQL Server Agent service must be running.

> [!NOTE]
> This feature is not available in every edition of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)]. For a list of features that are supported by the editions of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)], see [Features supported by the editions of SQL Server 2012](/previous-versions/sql/sql-server-2012/cc645993(v=sql.110)) (https://go.microsoft.com/fwlink/?linkid=232473).

**Options**

**Name** - Enter a name for the shared schedule. This name appears in drop-down lists when users select a shared schedule for reports and subscriptions. Be sure to provide a descriptive name that fits easily within a list and that easily distinguishes one shared schedule from another. A name must contain at least one alphanumeric character. It can also include spaces and some symbols. Don't use the following characters when specifying a name:

` ; ? : \@ & = + , $ / * < > " /  `

**Begin running this schedule on** - Specify a start date for this schedule.

**Stop this schedule on** - Specify an expiration date for this schedule.

**Type** - Specifies whether the recurrence pattern is based primarily on hours, days, weeks, or months.

**Hour (Recurrence Pattern)** - Select options to run a scheduled operation in intervals of an hour (for example, to run a report every 6 hours). You can specify the interval in hours and minutes.

**Day (Recurrence Pattern)** - Select options to run a scheduled operation in intervals of days (for example, to run a report every 2 days). You can specify the interval in days and at the hour and minute you want the schedule to run.

**Week (Recurrence Pattern)** - Select options to run a scheduled operation in intervals of a week or when the pattern that you want to repeat is based on weeks (for example, to run a report every other week). You can specify a weekly schedule to the day, hour, and minute that you want the schedule to run.

**Month (Recurrence Pattern)** - Select options to run a scheduled operation in intervals of a month or when the pattern that you want to repeat is based on months. You can specify a monthly schedule to the day, hour, and minute that you want the schedule to run. You can omit specific months from the schedule.

**Once** - Select this option to create a schedule that runs only once, on a specific date and time.

### New system role

Use this page to create a system-level role definition. A system role definition specifies a set of system-level tasks that apply to a report server as whole.

> [!NOTE]
> Role definitions are used only on a report server that runs in native mode. If the report server is configured for SharePoint integration, this page is not available.

**Options**

**Name** - Enter the name of the role definition. A role definition name must be unique within the report server namespace. A name must contain at least one alphanumeric character. It can also include spaces and some symbols. Don't use the following characters when specifying a name:

`; ? : \@ & = + , $ / * < > " /`

**Description** - Provide a description that explains how to use the role and enumerates what the role supports.

**Task** - Select the system-level tasks that can be performed through this role. You can't create new tasks or modify the existing tasks that [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] supports. You can't choose item-level tasks for a system role definition.

**Task Description** - Shows a description of the task that enumerates the operations or permissions that the task supports.

### New user role

Use this page to create an item-level role definition. An item-level role definition is a named collection of tasks that enumerate the tasks a user can perform in relation to folders, reports, models, resources, and shared data sources. An example of an item-level role definition is the predefined Browser role that identifies the kinds of actions a report end user might require. These actions are for navigating folders and viewing reports.

Role definitions are intended to be few in number. Most organizations only require a few role definitions. However, if the predefined role definitions are insufficient, you can vary them or create new ones.

> [!NOTE]
> Role definitions are used only on a report server that runs in native mode. If the report server is configured for SharePoint integration, this page is not available.

**Options**

**Name** - Enter the name of the role definition. A role definition name must be unique within the report server namespace. A name must contain at least one alphanumeric character. It can also include spaces and some symbols. Don't use the following characters when specifying a name:

`; ? : \@ & = + , $ / * < > " /`

**Description** - Enter a description that explains how to use the role and enumerates what the role supports.

**Task** - Select the tasks that can be performed through this role. You can't create new tasks or modify the existing tasks that [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] supports. Only item-level tasks can be used in an item-level role definition.

**Task Description** - Shows a description of the task that enumerates the operations or permissions that the task supports.

### Schedule properties (General page)

Use the [!INCLUDE[ssRSnoversion_md](../../includes/ssrsnoversion-md.md)] page in [!INCLUDE[ssManStudioFull_md](../../includes/ssmanstudiofull-md.md)] to view or modify a shared schedule. Shared schedules can be used in place of report-specific or subscription-specific schedules. Changes to the schedule are applied after you save the schedule. Editing a schedule has no effect on jobs that are currently in progress. If you edit a schedule while it's being used, all currently processing reports and subscriptions triggered from that schedule are allowed to finish.

Not all frequency combinations can be supported in a single schedule. For example, if you want to run a report at 12:00 P.M. and 4:00 P.M. every Friday, you must create two daily schedules. These schedules should specify a Friday run date, with one having a start time of 12:00 P.M. and the other with a start time of 4:00 P.M.

Schedule processing is based on the local time of the report server that hosts and processes the schedule.

To open this page:
1) Start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)].
2) Connect to a report server.
3) Expand the **Shared Schedules** folder.
4) Right-click a shared schedule, and select **Properties**.

> [!NOTE]
>This feature is not available in every edition of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)] and this page does not appear when you are running an edition which does not have this feature. For a list of features that are supported by the editions of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)], see [Editions and supported features of SQL Server 2022](../../sql-server/editions-and-components-of-sql-server-2022.md).

**Options**

**Name** - Specifies the name for the shared schedule.

**Begin running this schedule on** - Specifies a start date for this schedule.

**Stop this schedule on** - Specifies an expiration date for this schedule.

**Type** - Specifies whether the recurrence pattern is based primarily on hours, days, weeks, months, or only runs once.

**Hour (Recurrence Pattern)** - Specifies options for running a scheduled operation in intervals of an hour (for example, to run a report every 6 hours). You can specify the interval in hours and minutes.

**Day (Recurrence Pattern)** - Specifies options for running a scheduled operation in intervals of days (for example, to run a report every 2 days). You can specify the interval in days and at the hour and minute you want the schedule to run.

**Week (Recurrence Pattern)** - Specifies options for running a scheduled operation in intervals of a week or when the pattern that you want to repeat is based on weeks (for example, to run a report every other week). You can specify a weekly schedule to the day, hour, and minute that you want the schedule to run.

**Month (Recurrence Pattern)** - Specifies options for running a scheduled operation in intervals of a month or when the pattern that you want to repeat is based on months. You can specify a monthly schedule to the day, hour, and minute that you want the schedule to run. You can omit specific months from the schedule.

**Once** - Specifies a schedule that runs only once, on a specific date and time.

### Schedule properties (Reports page)

Use the [!INCLUDE[ssRSnoversion_md](../../includes/ssrsnoversion-md.md)] schedule properties page in [!INCLUDE[ssManStudioFull_md](../../includes/ssmanstudiofull-md.md)] to view a list of all reports that use the specific shared schedule. Schedules can be used to refresh report snapshots, generate report history, trigger a subscription, or expire a cached copy of the report. To find out how the schedule is used, view the property and subscription information of the report.

Although this page shows each report that uses the shared schedule, it doesn't indicate how many times the shared schedule is used within that single report. For example, suppose 20 different subscribers to the Company Sales report use the same shared schedule to trigger subscription processing. In this case, the Company Sales report appears once in this list, even though the report has 20 references to the shared schedule.

To open the schedule properties page:
1. Start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)].
2. Connect to a report server.
3. Open the **Shared Schedules** folder.
4. Right-click a shared schedule, select **Properties**.
5. Select **Reports**.

You can also manage shared schedules from the **Site Settings** of the [!INCLUDE[ssRSnoversion_md](../../includes/ssrsnoversion-md.md)] Web Portal.

> [!NOTE]
> This feature is not available in every edition of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)]. For a list of features that are supported by the editions of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)], see [Editions and supported features of SQL Server 2022](../../sql-server/editions-and-components-of-sql-server-2022.md).

**Options**

**Folder** - Specifies the path of the report.

**Report** - Specifies the name of the report that uses the schedule.

### Server properties (General page)

Use this page to: 
- View or modify the title used in Report Manager
- Enable or disable My Reports
- Select a role definition for My Reports security
- Enable or disable the client print control

**To open this page:**
1) Start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)]
2) Connect to a report server instance.
3) Right-click the report server name, and then select **Properties**.

The server mode determines which server properties you can set. If you manage a report server that is configured for SharePoint integrated mode, you can't enable My Reports or set the title for the web portal.

**Options**

**Name** - Enter a name that appears on top of the web portal. By default, this value is [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)] [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)]. The name that you specify appears only in Report Manager.

**Version** - This property is read-only. Specifies the version of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)] [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] that you're using.

**Edition** - This property is read-only. Specifies the current report server instance. Report Manager isn't available in every edition of [!INCLUDE[msCoName](../../includes/msconame-md.md)] [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)]. For a list of features that the editions of [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)] support, see [Editions and supported features of SQL Server 2022](../../sql-server/editions-and-components-of-sql-server-2022.md).

**Authentication Mode** - This property is read-only. It identifies the types of authentication requests accepted by the report server instance. To change the authentication mode, you must edit the **RSReportServer.config** file. For more information, see [Authentication with the report server](../../reporting-services/security/authentication-with-the-report-server.md).

**URL** - This property is read-only. Specifies the URL to the Report Server Web service. This value is specified in the [!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] Configuration tool. For more information, see [Configure a URL  &#40;Report Server Configuration Manager&#41;](../../reporting-services/install-windows/configure-a-url-ssrs-configuration-manager.md).

**Enable a My Reports folder for each user** - Make **My Reports** available to users. This option is only available for native mode report servers.

**Select the role to apply to each My Reports folder** - Specify a role definition to use for My Reports security. The role definition identifies the set of tasks that are supported in each My Reports folder.

### Server properties (Execution page)

Use this page to set a timeout value for report execution. This value applies to all reports that the current report server instance processes. You can override this value for individual reports. The value you specify must accommodate all report processing that occurs on the report server. It must also accommodate query processing performed on the database server when the report server retrieves data that is used in the report.

To open this page, start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)], connect to a report server instance, right-click the report server name, and select **Properties**. Select **Execution** to open this page.

**Options**

**Do not timeout report execution** - Allow a report server unlimited time to complete report processing.

**Limit report execution to the following number of seconds** - Set a time constraint on report execution. The time period starts when the report is requested. If the time period ends before the report is fully processed, the report server cancels the process and any in-process queries to external data sources.

### Server properties (History page)

Use this [!INCLUDE[ssRSnoversion_md](../../includes/ssrsnoversion-md.md)] page in [!INCLUDE[ssManStudioFull_md](../../includes/ssmanstudiofull-md.md)] to set a default value for the number of copies of report history to retain. The default value provides an initial setting that establishes report history limits for all reports. You can vary these settings for individual reports.

Report history is a collection of report snapshots that include report data and layout that is current for the report at the time the snapshot is created. You can use report history to keep a copy of a report as it was on a specific date or time. You can create and manage report history for individual reports that run on a native mode report server. Or, you can create and manage report history for a report server that is configured for SharePoint integrated mode.

Report history snapshots are stored in the report server database. If you keep an unlimited number of snapshots, be sure to periodically check the database size to ensure it isn't growing too fast or consuming too much disk space.

To open this page:
1) Start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)].
2) Connect to a report server instance.
3) Right-click the report server name, and select **Properties**.
4) Select **History** to open this page.

**Options**

**Keep an unlimited number of snapshots in report history** - Retain all report history snapshots. You must manually delete snapshots to reduce the size of report history.

**Limit the copies of report history** - Retain a set number of report history snapshots. When the limit is reached, older copies are removed from report history to make room for newer copies.

If you limit report history later, when the existing report history exceeds the limit you specify, the report server reduces the existing report history to the new limit. The oldest report snapshots are deleted first. If report history is empty or below the limit, new report snapshots are added. When the limit is reached, the oldest snapshot is deleted when a new report snapshot is added.

### Server properties (Logging page)

Use this [!INCLUDE[ssRSnoversion_md](../../includes/ssrsnoversion-md.md)] page in [!INCLUDE[ssManStudioFull_md](../../includes/ssmanstudiofull-md.md)] to set limits on the report execution data that the report server collects by a report server. Execution data is stored internally in the report server database. You can track report activity for report server that runs in native mode or SharePoint integrated mode. If the report server is part of a scale-out deployment, the report execution log maintains a record of all report activity for the entire deployment in a single log file.

To open this page:
1) Start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)]
2) Connect to a report server.
3) Right-click the report server name and select **Properties**. 
4) Select **Logging** to open this page.

**Options**

**Enable report execution logging** - Select to create and store information about report activity on the server. If this option is enabled, the report server tracks which reports are used. It also tracks the frequency of report processing, the type of report operation that was performed, the output format, and who ran the report. For more information about other data points that are captured in the log, see [Report Server ExecutionLog and the ExecutionLog3 View](../../reporting-services/report-server/report-server-executionlog-and-the-executionlog3-view.md).

**Remove log entries older than this number of days** - Specify the number of days after which log entries are trimmed from the report execution log. The default value is 60 days.

### Server properties (Security page)

Use this [!INCLUDE[ssRSnoversion_md](../../includes/ssrsnoversion-md.md)] page in [!INCLUDE[ssManStudioFull_md](../../includes/ssmanstudiofull-md.md)] to turn off features that can potentially compromise a report server. Turning off these features limits some functionality, but can improve the overall security of the report server by mitigating specific threats.

To open this page:
1) Start [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)].
2) Connect to a report server instance.
3) Right-click the report server name, and select **Properties**.
4) Select **Security** to open this page.

**Options**

**Enable Windows-Integrated Security for report data sources** - Specify whether a connection to a report data source uses the Windows security token of the user who requested the report.

If you turn off the feature, the Windows-Integrated Security feature in the report data source property pages becomes unavailable. If your report data sources are configured for Windows-integrated security and you turn off this feature, the report server immediately updates all your data source connection properties to prompt for credentials.

**Enable unplanned reporting** - Specify whether users can perform unplanned queries from a Report Builder report. In this context, new reports are automatically generated when a user chooses data of interest.

Setting this option determines whether the **EnableLoadReportDefinition** property on the report server is set to **True** or **False**. If you clear this option, the property is set to **False** and report server doesn't generate clickthrough reports that are created during data exploration. All calls to the **LoadReportDefinition** method are blocked.

Turning off this option mitigates a threat whereby a malicious user launches a denial of service attack by overloading the report server with **LoadReportDefinition** requests.

### Server properties (Advanced page)

Use this page to set system properties on the report server. There are many ways to set system properties. This tool provides a graphical user interface so that you can set properties without having to write code.

To open this page, start SQL Server Management Studio, connect to a report server instance, right-click the report server name, and select **Properties**. Select **Advanced** to open this page.

### System role properties

Use the System Roles page to view the system role definitions that are currently defined for the report server. A system role definition contains a named collection of tasks that are performed relative to the entire site, instead of an individual item. Role definitions are assigned to a user or groups to create a resulting role assignment. The tasks in the role definition specify what the user or group can do.

[!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] has two predefined system role definitions: **System Administrator** and **System User**. You can modify these role definitions by changing the task list, or you can create a new system role that supports a different combination of tasks. Editing a role definition affects all role assignments that include the role definition.

> [!NOTE]
> System role assignments are used only on a report server that runs in native mode. If the report server is configured for SharePoint integration, this page is not available.

**Options**

**Name** - Specifies the name of the system role definition.

**Description** - Shows a description of the system role definition. In [!INCLUDE[ssNoVersion](../../includes/ssnoversion-md.md)] [!INCLUDE[ssManStudio](../../includes/ssmanstudio-md.md)], this description is only visible in this page. Users who view this item through Report Manager might see this description when browsing the folder hierarchy.

**Task** - Lists all system-level tasks that can be selected for this role definition. You can add or remove items from the predefined task list to define how users access a given item through this role. You can't create new tasks, and you can't modify existing tasks.

**Description** - Provides information about each task. You can't modify task descriptions.

### User role properties

Use this page to view which tasks are included in an item-level role definition. You can also use this page to change the task list or modify a role description.

An item-level role definition is a named collection of tasks that users perform relative to a specific item (that is, a folder, report, resource, or shared data source). Role definitions are assigned to a user or group to create a role assignment in Report Manager. The tasks in the role definition describe what the user or group can do.

[!INCLUDE[ssRSnoversion](../../includes/ssrsnoversion-md.md)] includes many predefined item-level role definitions that you can work with. You can modify the role definitions by changing the task list of each one. Editing a role definition affects all role assignments that include the role definition.

> [!NOTE]
> User role assignments are used only on a report server that runs in native mode. If the report server is configured for SharePoint integration, this page displays read-only information about the roles and permission levels that are defined on the SharePoint site.

**Options**

**Name** - Specifies the name of the role definition.

**Description** - Shows a description of the role definition. In [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)], this description is only visible in this page. In Report Manager, this description helps users decide whether to use the role in a role assignment.

**Task** - Lists all item-level tasks that can be selected for this role definition. You can add or remove items from the predefined task list to define how users access a given item through this role. You can't create new tasks, and you can't modify existing tasks. The task list of a role definition appears only in [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)].

**Task Description** - Provides information about each task. You can't modify task descriptions.

## Related content

- [SQL Server Management Studio (SSMS)](/ssms/sql-server-management-studio-ssms)
