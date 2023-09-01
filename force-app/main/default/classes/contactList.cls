public with sharing class contactList {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Email, Phone FROM Contact Limit 1];
        
    }
   
}