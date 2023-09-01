@isTest
public class TriggerOnContactTest {
    @isTest
    static void CreateContactTest() {
        Integer numberOfrecords = 1;
        
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;
        
        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;
        contacts[0].Email = 'test@nyc.com';
        update contacts;
    }
}