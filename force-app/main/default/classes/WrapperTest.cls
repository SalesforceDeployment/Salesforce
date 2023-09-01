/*********************************************************************************************************************
    ClassName : WrapperTest
    Purpose : This is a test class used to code coverage of all the WrapperClasses functionality.
    AUTHOR : Nidhi Chouksey
    Date : 09-July-2023
********************************************************************************************************************/
@isTest
public with sharing class WrapperTest {
	
    public static testMethod void productTreatmentWrapperTest() {
        Test.startTest();
        List<ProductTreatmentWrapper> wrapperObj = new List<ProductTreatmentWrapper>();
        ProductTreatmentWrapper.Criteria  criteriaWrapper = new ProductTreatmentWrapper.Criteria();
        ProductTreatmentWrapper.parse(JSON.serialize(wrapperObj));
        Test.stopTest();
    }
    
    @isTest
    public static void projectWrappTest(){
        Test.startTest();
        ProjectWrapp projWrapp = new ProjectWrapp('Test');
        
        List<Care_Products__c> products = UtilData.createCareProduct(1);
        insert products;
        
        List<Project_Group__c> projectGroups = UtilData.createProjectGroup(products);
        insert projectGroups;
        
        List<project__c> projects = UtilData.createProjects(projectGroups);
        projWrapp.addProject(projects[0]);
        
        ProjectWrapper projWrapper = new ProjectWrapper('Test');
        projWrapper.addProject(projects[0]);
        
        DosingDetailsWrapper dosingDetailWrapper = new DosingDetailsWrapper();
        DosingDetailsWrapper.parse(JSON.serialize(dosingDetailWrapper));
        Test.stopTest();
    }
    
    @isTest
    public static void fileListTest(){
        Test.startTest();
        List<Care_Products__c> products = UtilData.createCareProduct(1);
        insert products;

        List<Contact> conData = UtilData.createContactsList(1);
        insert conData;
        
        ContentVersion cv = new ContentVersion();
        	cv.ContentLocation = 'S';
        	cv.PathOnClient = 'fileName';
        	cv.Title = 'fileName';
        	cv.VersionData = Blob.valueOf('sample text');
        	cv.IsMajorVersion = false;
        	insert cv;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = conData[0].id; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe.Visibility = 'AllUsers';
        insert cDe;
        
        FilesList.getContentDocs(conData[0].id);
        
        UserRequestCtrl usrReqCtrl = new UserRequestCtrl();
        usrReqCtrl.getsalesforceBaseURL();
        
        //CommunityLoginAPI.login();
        Test.stopTest();
    }
    
}