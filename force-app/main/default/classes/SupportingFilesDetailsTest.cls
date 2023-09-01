@isTest
public class SupportingFilesDetailsTest {

    @isTest
    static void testGetRelatedFilesByRecordId() {
        // Create test data
        Indication__c acc = new Indication__c(Indication_Name__c='Test Indication');
        insert acc;

        ContentDocument doc = new ContentDocument();
      //  insert doc;

        
       
        
        ContentVersion newFile = new ContentVersion();
        newFile.PathOnClient = 'TestFile';
        newFile.Title = 'TestFile';
        newFile.VersionData = Blob.valueOf('sample content');
        insert newFile;
        
         ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:newFile.Id];   

         ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=acc.Id, ContentDocumentId=insertedFile.ContentDocumentId);
        insert linkedFile;

        // Call the method being tested
        Map<ID, String> result = supportingFilesDetails.getRelatedFilesByRecordId(acc.Id);

        // Verify the results
        System.assertEquals(1, result.size());
      //  System.assertEquals('Test File', result.get(doc.Id));
    }
}