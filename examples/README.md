# Examples

The `hubspot.crm.associations` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples), covering use cases like creating and deleting associations, CRM association restructuring, and creating and reading associations.

1. [Create delete associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-delete-associations) - Demonstrate how to create and delete associations between CRM objects in HubSpot.

2. [CRM association restructuring](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/crm-association-restructuring) - Restructure and reorganize existing associations between CRM records in HubSpot.

3. [Create read associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-read-associations) - Create new associations and retrieve existing associations between CRM objects.

## Prerequisites

1. Generate HubSpot credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/hubspot.crm.associations/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    token = "<Access Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```