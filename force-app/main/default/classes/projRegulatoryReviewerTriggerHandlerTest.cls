@isTest
public class projRegulatoryReviewerTriggerHandlerTest {
    
    @testSetup    
    static void setup() {        
        Integer numberOfrecords = 1;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole roleRecord = [SELECT Id FROM UserRole WHERE Name='Regulatory Reviewer'];
        User standardUser = new User(
            Username = 'standardbioni12user@testorg.com',
            Alias = 'standt',
            email = 'standardbioni1user@testorg.com',
            emailencodingkey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            UserRoleId  = roleRecord.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            IsActive = true
        );
        insert standardUser;
        system.runAs(standardUser) {
            List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
            insert careProducts;
            
            List<Project_Group__c> ProjectGroups = UtilData.createProjectGroupsTreatmentLookup(careProducts);
            insert ProjectGroups;
            
            List<project__c> projects = UtilData.createProject(ProjectGroups);
            insert projects;
            
            Project__c p1 = projects[0];
            p1.Project_Status__c = 'Draft in Review';
            upsert p1;
            p1.Project_Status__c ='Draft Project Approved';
            upsert p1;
            try {
                Project_Regulatory_Reviewers__c reviewerRecord = new Project_Regulatory_Reviewers__c ();
                reviewerRecord.Project__c = projects[0].Id;
                reviewerRecord.Regulatory_Reviewer__c = standardUser.Id;
                reviewerRecord.Description__c = 'test1';
                insert reviewerRecord;
            } catch(DmlException e){
                System.debug(e.getMessage());
            }
            
        }
    }
    @isTest
    public static void projectReviewerRecordInsertTest () {
        User userRecord = [SELECT Id FROM User LIMIT 1];
        Project__c projectRecord = [SELECT Id FROM Project__c LIMIT 1];
        try {
            Project_Regulatory_Reviewers__c reviewerRecord = new Project_Regulatory_Reviewers__c ();
            reviewerRecord.Project__c = projectRecord.Id;
            reviewerRecord.Regulatory_Reviewer__c = userRecord.Id;
            reviewerRecord.Description__c = 'test1';
            insert reviewerRecord;
        } catch(DmlException e){
            System.debug(e.getMessage());
        }
    }
     @isTest
    public static void projectReviewerRecordDeleteTest () {
        User userRecord = [SELECT Id FROM User LIMIT 1];
        Project__c projectRecord = [SELECT Id FROM Project__c LIMIT 1];
        try {
            Project_Regulatory_Reviewers__c reviewerRecord = new Project_Regulatory_Reviewers__c ();
            reviewerRecord.Project__c = projectRecord.Id;
            reviewerRecord.Regulatory_Reviewer__c = userRecord.Id;
            insert reviewerRecord;
            delete reviewerRecord;
        } catch(DmlException e){
            System.debug(e.getMessage());
        }
    }
}