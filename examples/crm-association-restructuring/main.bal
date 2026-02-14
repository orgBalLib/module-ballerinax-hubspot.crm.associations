import ballerina/io;
import ballerinax/hubspot.crm.associations;

configurable string accessToken = ?;

configurable string parentCompanyId = "12345678901";
configurable string subsidiaryCompanyId = "98765432109";

public function main() returns error? {
    associations:ConnectionConfig connectionConfig = {
        auth: {
            token: accessToken
        }
    };
    
    associations:Client hubspotClient = check new (connectionConfig);
    
    io:println("=== Customer Relationship Mapping Workflow ===");
    io:println("Scenario: Auditing and restructuring CRM associations after company merger\n");

    io:println("Step 1: Retrieving existing associations between contacts and subsidiary company...");
    
    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging subsidiaryAssociations = 
        check hubspotClient->/objects/["companies"]/[subsidiaryCompanyId]/associations/["contacts"]();
    
    int associationCount = subsidiaryAssociations.results.length();
    io:println("Found ", associationCount, " contact associations with subsidiary company");
    
    string[] contactIds = [];
    foreach associations:MultiAssociatedObjectWithLabel associationItem in subsidiaryAssociations.results {
        string contactId = associationItem.toObjectId.toString();
        contactIds.push(contactId);
        io:println("  - Contact ID: ", contactId);
        foreach associations:AssociationSpecWithLabel assocType in associationItem.associationTypes {
            io:println("    Association Type ID: ", assocType.typeId, ", Category: ", assocType.category);
        }
    }
    
    int totalContacts = contactIds.length();
    io:println("\nTotal contacts to migrate: ", totalContacts);

    io:println("\nStep 2: Creating new associations between contacts and parent company...");
    
    if contactIds.length() > 0 {
        associations:PublicDefaultAssociationMultiPost[] newAssociationInputs = [];
        
        foreach string currentContactId in contactIds {
            associations:PublicDefaultAssociationMultiPost associationInput = {
                'from: {
                    id: currentContactId
                },
                to: {
                    id: parentCompanyId
                }
            };
            newAssociationInputs.push(associationInput);
        }
        
        associations:BatchInputPublicDefaultAssociationMultiPost batchCreatePayload = {
            inputs: newAssociationInputs
        };
        
        associations:BatchResponsePublicDefaultAssociation createResponse = 
            check hubspotClient->/associations/["contacts"]/["companies"]/batch/associate/default.post(batchCreatePayload);
        
        io:println("Batch association creation status: ", createResponse.status);
        int createdCount = createResponse.results.length();
        io:println("Successfully created ", createdCount, " new associations");
        
        foreach associations:PublicDefaultAssociation resultItem in createResponse.results {
            io:println("  - Contact ", resultItem.'from.id, " -> Parent Company ", resultItem.to.id);
        }
        
        int|() numErrorsValue = createResponse.numErrors;
        if numErrorsValue is int && numErrorsValue > 0 {
            io:println("  Errors encountered: ", numErrorsValue);
        }
    } else {
        io:println("No contacts found to migrate.");
    }

    io:println("\nStep 3: Archiving outdated associations with subsidiary company...");
    
    if contactIds.length() > 0 {
        associations:PublicAssociationMultiArchive[] archiveInputs = [];
        
        foreach string currentContactId in contactIds {
            associations:PublicAssociationMultiArchive archiveInput = {
                'from: {
                    id: currentContactId
                },
                to: [
                    {
                        id: subsidiaryCompanyId
                    }
                ]
            };
            archiveInputs.push(archiveInput);
        }
        
        associations:BatchInputPublicAssociationMultiArchive batchArchivePayload = {
            inputs: archiveInputs
        };
        
        error? archiveResponse = 
            hubspotClient->/associations/["contacts"]/["companies"]/batch/archive.post(batchArchivePayload);
        
        if archiveResponse is error {
            io:println("Archive operation failed: ", archiveResponse.message());
            return archiveResponse;
        }
        
        io:println("Batch archive operation completed");
        io:println("Successfully archived all outdated associations");
    } else {
        io:println("No associations to archive.");
    }

    io:println("\n=== Workflow Complete ===");
    io:println("Summary:");
    int finalContactCount = contactIds.length();
    io:println("  - Contacts audited: ", finalContactCount);
    io:println("  - New associations created with parent company: ", finalContactCount);
    io:println("  - Outdated associations archived from subsidiary: ", finalContactCount);
    io:println("\nCRM data hygiene maintained successfully after merger.");
}