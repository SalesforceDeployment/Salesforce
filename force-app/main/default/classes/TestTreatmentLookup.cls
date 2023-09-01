@isTest
private class TestTreatmentLookup {
   /* @isTest
    static void testGetAllindication() {
        Id RecordTypeIdApplication = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Institution').getRecordTypeId();
        	//system.debug(RecordTypeIdApplication);
//Id techdicerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('record type name').getRecordTypeId();

        // Create test care product
        Care_Products__c testCareProduct = new Care_Products__c(Name = 'Test Care Product');
        insert testCareProduct;

        // Create test project group
        Project_Group__c testProjectGroup = new Project_Group__c(Name = 'Test Project Group', Status__c='Live',Care_Product__c = testCareProduct.Id);
        insert testProjectGroup;
       //organization
       
        // Create test project
        Project__c testProject = new Project__c(Name = 'Test Project',Project_Code__c='123',Project_Group__c = testProjectGroup.Id);
        insert testProject;
        
        //instutation
        //Institution__c testins= new Institution__c();

        // Create test indication
        Indication__c testIndication = new Indication__c(Project__c = testProject.Id, Indication_Name__c = 'Test',RecordTypeId=RecordTypeIdApplication);
        insert testIndication;

        //Test.startTest();
        List<TreatmentLookup.WrapperTreatmentLookup> result = TreatmentLookup.getAllindication();
        //Test.stopTest();

        System.assertEquals(1, result.size());
        TreatmentLookup.WrapperTreatmentLookup wrapper = result[0];
        System.assertEquals(testCareProduct.Id, wrapper.careProducts.Id);
        System.assertEquals(testProjectGroup.Id, wrapper.projectGroup.Id);
        System.assertEquals(testProject.Id, wrapper.project.Id);
        System.assertEquals(testIndication.Id, wrapper.indication.Id);
    }*/
    @isTest
    static void testGetpassedIndication() {
        // Create test data
        Care_Products__c testCareProduct = new Care_Products__c(Name = 'Test Care Product');
        insert testCareProduct;

        Project_Group__c testProjectGroup = new Project_Group__c(Name = 'Test Project Group', Care_Product__c = testCareProduct.Id);
        insert testProjectGroup;

        Project__c testProject = new Project__c(Name = 'Test Project', Project_Group__c = testProjectGroup.Id);
        insert testProject;

        Indication__c testIndication = new Indication__c(Indication_Name__c = 'Test Indication', Project__c = testProject.Id);
        insert testIndication;

        // Call the method being tested
        List<TreatmentLookup.WrapperIndicationDetails> result = TreatmentLookup.getpassedIndication(testIndication.Id);

        // Verify the result
        System.assertEquals(1, result.size());
        TreatmentLookup.WrapperIndicationDetails wrapper = result[0];
        System.assertEquals(testCareProduct.Id, wrapper.careProducts.Id);
        System.assertEquals(testProjectGroup.Id, wrapper.projectGroup.Id);
        System.assertEquals(testProject.Id, wrapper.project.Id);
        System.assertEquals(testIndication.Id, wrapper.indication.Id);
    }
}