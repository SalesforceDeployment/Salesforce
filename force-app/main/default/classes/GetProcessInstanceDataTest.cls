@isTest
public with sharing class GetProcessInstanceDataTest {


    @isTest
    public static void setup() {
        //create a record
        // Insert an account
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Institution').getRecordTypeId();
        Account curAccount = new Account(Name='Test',
        RecordTypeId= recordTypeId,
        annualRevenue=100.0,
        Due_Diligence_Complete__c = true,
        BillingStreet = 'Test Street',
        BillingCity = 'Test City',
        BillingState = 'Delhi',
        BillingCountry = 'India',
        BillingPostalCode = '000000'
        );
        insert curAccount;

        User testUser1 = insertStandardUser();

        //create an approval process
        String responseBody = '{"status":"success"}';
        Integer responseCode = 200;
        Test.setMock(HttpCalloutMock.class, new MockClass(responseBody,responseCode));
        //GenerateApprovalProcess.createApprovalProcess();

        //ApprovalSubmitter curSubmitter = new ApprovalSubmitter();
        //curSubmitter.type = 'allInternalUsers';
        //curProcess.allowedSubmitters.add(curSubmitter);


        String approvalProcessName = '';

        //submitRecord(curAccount, testUser1, approvalProcessName);


    }

    public static void submitRecord(Account curAccount, User testUser1, String approvalProcessName) {

        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 =
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(curAccount.id);

        // Submit on behalf of a specific submitter
        req1.setSubmitterId(testUser1.Id);

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('PTO_Request_Process');
        req1.setSkipEntryCriteria(true);

        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);

        // Verify the result
        System.assert(result.isSuccess());

        System.assertEquals(
            'Pending', result.getInstanceStatus(),
            'Instance Status'+result.getInstanceStatus());
        //add a step to the process assigned to the user
        //submit the approval process
    }


    // This method dynamically creates a username prefix that will make ensure username uniqueness.
    @isTest
    public static String getUserNamePrefix(){
        return UserInfo.getOrganizationId() + System.now().millisecond();
    }

    // Other create and insert methods here…
    @isTest
    public static User insertStandardUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User standardUser = new User(
          Username = getUserNamePrefix() + 'standarduser@testorg.com',
          Alias = 'standt',
          email = 'standarduser@testorg.com',
          emailencodingkey = 'UTF-8',
          LastName = 'Testing',
          LanguageLocaleKey = 'en_US',
          LocaleSidKey = 'en_US',
          ProfileId = p.Id,
          TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert standardUser;
        return standardUser;
    }
    @isTest
    public static void CanRetrieveProcessInstanceWorkItems () {

//        String actorId = 'actorId';
//
//
//        String testResponseList = GetProcessInstanceData.Retrieve(actorId);
//
//        System.assertEquals(testResponseList,'foo');
//

    }

}