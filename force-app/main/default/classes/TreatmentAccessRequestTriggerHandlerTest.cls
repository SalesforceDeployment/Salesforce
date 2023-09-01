@isTest
public class TreatmentAccessRequestTriggerHandlerTest {
    @testSetup 
    static void setup() {
        Integer numberOfrecords = 3;
        List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
        insert careProducts;
        List<Project_Group__c> ProjectGroups = UtilData.createProjectGroupsTreatmentLookup(careProducts);
        insert ProjectGroups;        
        List<Account> accounts = UtilData.createAccountsList(numberOfrecords);
        insert accounts;
        List<Treatment_Access_Request__c> treatmentAccessRequests = UtilData.CreateTreatmentAccessRequests(numberOfrecords, ProjectGroups, accounts);
        insert treatmentAccessRequests;
    }
    @isTest
    static void getTreatmentRequestTest() {
        Group testGroup = new Group(Name='PAM Queue', Type='Queue');
        insert testGroup;
    }
}