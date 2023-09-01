public with sharing class parAddress {
    
  @AuraEnabled(cacheable=true)
  public static List<Institution_Additional_Address__c> getAccountAddress(){

    return [SELECT Id, Name, Additional_Address__City__s, Additional_Address__Street__s, Additional_Address__PostalCode__s, Additional_Address__StateCode__s  from Institution_Additional_Address__c where Institution__r.Id = '0012z00000Kv2Z4AAJ'];
    }
}