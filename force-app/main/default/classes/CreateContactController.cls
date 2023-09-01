public with sharing class CreateContactController {
    public Contact newContact { get; set; }

    public CreateContactController() {
        newContact = new Contact();
        // get the default record type for the account object
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Default').getRecordTypeId();
        // set the default record type for the new contact record
        newContact.RecordTypeId = rtId;
    }

    public PageReference saveContact() {
        insert newContact;
        return new PageReference('/' + newContact.Id);
    }
}