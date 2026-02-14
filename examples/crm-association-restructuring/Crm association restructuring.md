# CRM Association Restructuring

This example demonstrates how to audit and restructure CRM associations in HubSpot after a company merger by migrating contact associations from a subsidiary company to a parent company and archiving the outdated relationships.

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/blob/main/ballerina/Package.md#setup-guide) to obtain your access token.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your credentials and company IDs:

   ```toml
   accessToken = "<Your Access Token>"
   parentCompanyId = "<Parent Company ID>"
   subsidiaryCompanyId = "<Subsidiary Company ID>"
   ```

   | Configuration Key      | Description                                              |
   |------------------------|----------------------------------------------------------|
   | `accessToken`          | HubSpot private app access token                         |
   | `parentCompanyId`      | The HubSpot ID of the parent company (migration target)  |
   | `subsidiaryCompanyId`  | The HubSpot ID of the subsidiary company (migration source) |

## Run the Example

Execute the following command to run the example. The script will print its progress to the console as it performs the association restructuring workflow.

```shell
bal run
```

Upon successful execution, you will see output similar to:

```
=== Customer Relationship Mapping Workflow ===
Scenario: Auditing and restructuring CRM associations after company merger

Step 1: Retrieving existing associations between contacts and subsidiary company...
Found 3 contact associations with subsidiary company
  - Contact ID: 101
    Association Type ID: 1, Category: HUBSPOT_DEFINED
...

Step 2: Creating new associations between contacts and parent company...
Batch association creation status: COMPLETE
Successfully created 3 new associations
...

Step 3: Archiving outdated associations with subsidiary company...
Batch archive operation completed
Successfully archived all outdated associations

=== Workflow Complete ===
Summary:
  - Contacts audited: 3
  - New associations created with parent company: 3
  - Outdated associations archived from subsidiary: 3

CRM data hygiene maintained successfully after merger.
```