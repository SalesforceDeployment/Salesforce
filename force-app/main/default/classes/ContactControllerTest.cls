@isTest
public with sharing class ContactControllerTest {
    public ContactControllerTest() {
        
    }
    @TestSetup
    static void makeData(){
        integer numberOfrecords = 1;
		List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;
    }
    @isTest private static void findContactsTest(){
        System.Test.startTest();
        ContactController.findContacts('Test');
        contactList.getContacts();
        System.Test.stopTest();
    }
}