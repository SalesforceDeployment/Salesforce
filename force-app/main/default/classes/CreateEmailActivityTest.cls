/*********************************************************************************************************************
    ClassName CreateEmailActivityTest
    Purpose: This is a test class used to test the CreateEmailActivity functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class CreateEmailActivityTest {
    public CreateEmailActivityTest() {    }

    @TestSetup
    static void makeData(){
        User_Request__c userdata = new User_Request__c();
        userdata.Email__c = 'testingemail@yopmail.com';
        userdata.Email_Verified__c=false;
        insert userdata;
    }
    @istest
    private static void TestinBoundEmail(){

        // Contact Con = new Contact();
        // con.Email = 'someaddress@email.com';
        // con.Validation__c = true;
        // Insert con;

        Integer numberOfrecords = 1;
        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
        // Create the email body
        email.plainTextBody = 'This should become a note';
        email.fromAddress ='test@test.com';
        String contactEmail = 'test@domain.com';
        email.ccAddresses = new String[] {'Test Domain <' + contactEmail + '>'};
        email.subject = 'Dummy Subject';

        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

        CreateEmailActivity testInBound = new CreateEmailActivity();
        testInBound.handleInboundEmail(email, env);
        
        EmailMessage emailMessage = new EmailMessage(); 
        emailMessage.status = '3'; // email was sent 
        emailMessage.fromName = 'Test Name'; // from name 
        emailMessage.subject = 'This is the Subject!'; // email subject 
        emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>'; // email body 
        String[] toIds = new String[]{ contacts[0].id };  
        emailMessage.toIds = toIds; 
 
        insert emailMessage;
        
        EmailMessageRelation emr = new EmailMessageRelation(); 
        emr.emailMessageId = emailMessage.Id; 
        emr.relationId = contacts[0].id; 
        emr.relationType = 'FromAddress'; 
        insert emr;

        test.startTest();
        VerifyEmailController.verifyUserRequestEmail('testingemail@yopmail.com');
        test.stopTest();
    }
    @isTest
    private static void CodeCoverageCall(){
        CreateEmailActivity.CallCodeCoverage();
    }
}