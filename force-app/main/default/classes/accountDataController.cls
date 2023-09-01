public without sharing class accountDataController {
    
    
    @AuraEnabled(Cacheable=true)
    public static List<Account> accountData(String accId) {
        System.debug('Recordid'+accId);
        return [Select Id,Name FROM Account WHERE Account_Type__c='Institution' AND Id =:accId];
    }
    @AuraEnabled
    public static List<Account> accountContactData(String accconId) {
        Set<Id> accId= new Set<Id>();
        for(AccountContactRelation Acr:[SELECT Id, AccountId,Account.Name, ContactId,Contact.Name 
                                        FROM AccountContactRelation WHERE ContactId =:accconId ORDER BY Account.Name ASC NULLS LAST])
        {
            if(Acr.AccountId!=null){
                accId.add(Acr.AccountId);
            } 
        }
        List<Account> acclist = new List<Account>();
        for(Account acc : [SELECT Id, Name,  ShippingPostalCode, ShippingStreet, Institution_Country__c FROM Account WHERE Id IN: accId WITH SYSTEM_MODE ORDER BY Name ASC NULLS LAST]){
            if(acc != null){
                acclist.add(acc);
            }
        }
        return acclist;
    }
    
    @AuraEnabled
    public static List<Account> accountDataLookup() {
        return [Select Id,Name FROM Account];
    }
    
    @AuraEnabled
    public static List<Account> accountDataForAdminandManagers() {
        return [SELECT Id, Name, RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName = 'Institution' ORDER BY Name ASC NULLS LAST];
    }
    
    @AuraEnabled
    public static Map<string,Boolean> permissionForAdminandManagers() {
        Map<string,Boolean> permissionMap = new Map<string,Boolean> ();
        for(PermissionSetAssignment eachRecord: [SELECT Id, PermissionSetGroup.DeveloperName FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId()]) {
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Patient_Access_Manager') {
                permissionMap.put('Manager', true);
            }
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Bionical_Emas') {
                permissionMap.put('Admin', true);
            }
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Bionical_Medical_Reviewer') {
                permissionMap.put('Reviewer', true);
            }
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Regulatory_Reviewer') {
                permissionMap.put('RegulatoryReviewer', true);
            }
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Project_Manager') {
                permissionMap.put('PM', true);
            }
        }
        return permissionMap;
    }
    @AuraEnabled
    public static Map<String, Boolean> fetchRequestingUserType( String requestedById) {
        Map<String, Boolean> permissionMap = new Map<String, Boolean> ();
        for(PermissionSetAssignment eachRecord: [SELECT Id, PermissionSetGroup.DeveloperName FROM PermissionSetAssignment WHERE AssigneeId =: requestedById]) {
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Patient_Access_Manager') {
                permissionMap.put('Manager', true);
            }
            if(eachRecord.PermissionSetGroup.DeveloperName == 'Bionical_Emas') {
                permissionMap.put('Admin', true);
            }
        }
        return permissionMap;
    }
    @AuraEnabled
    public static List<Contact> contactData(String conId) {
        try {
            List<Contact> contactList = new List<Contact>();
            contactList = [SELECT Id,Name,Title,Phone,Department,email,Role__c,Account.Name,RecordType.Name FROM Contact WHERE Id =:conId LIMIT 1 ];
            return contactList; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());  
        }
    }
    
    @AuraEnabled
    public static List<User> UserData(String userId) {
        System.debug('Recordid'+userId);
        return [Select Id,Name,email FROM User WHERE Id =:userId ];
        
    }
    
    @AuraEnabled
    public static List<AccountContactRelation> getPhysicianData(string accountId, string contactId) 
    {
        List<AccountContactRelation> contactList = new List<AccountContactRelation>();
        if(String.isNotBlank(accountId) && String.isNotBlank(contactId))
        {
            contactList = [SELECT Id, Contact.Id, Contact.Name FROM AccountContactRelation WHERE AccountId =:accountId  AND Contact.Role__c  ='Physician' AND ContactId !=:contactId ORDER BY Contact.Name ASC NULLS LAST];
        }
        else if(String.isNotBlank(accountId))
        {
            contactList = [SELECT Id, Contact.Id, Contact.Name FROM AccountContactRelation WHERE AccountId =:accountId  AND Contact.Role__c  ='Physician' ORDER BY Contact.Name ASC NULLS LAST];
        }
        return contactList;
    }
    
    
    @AuraEnabled
    public static void createApexContactsData(string contactinfo){
        System.debug('Varun contactinfo'+contactinfo);
        list<Contact> conlist=(list<Contact>)Json.deserialize(contactinfo, list<Contact>.class);
        for(Contact condata:conlist)
        {
            Patient_Request__c PAR= new Patient_Request__c();
            
            PAR.Email__c=condata.Email;
            PAR.Name__c=condata.Name;
            insert PAR;
            System.debug('Varun PAR36'+PAR.Email__c); 
        }
        System.debug('Varun conlist39'+conlist);
        try{
            System.debug('Varun conlist40'+conlist);
        }catch(Exception e){
            
        }
    }
    
    public class WrapperaccountData
    {
        @AuraEnabled
        public Account account{get;set;}  
        
        
    }
    
    @AuraEnabled
    public static List<Account> getAccountCountry(Id instititionId) {
        return [SELECT Name, Institution_Country__c FROM Account where Id = :instititionId];
    }
    
    @AuraEnabled
    public static Patient_Request__c getSummaryData(String patientRequestId) {
        return [SELECT Id, Name, Consent_Provided__c, Institutation__r.Name, Project_Group__r.Name, Project_Country_Indication__r.Indication__r.Indication_Name__c, Patient__r.Name, On_Behalf_Of__r.Contact.Name, On_Behalf_Of__r.Contact.Title, On_Behalf_Of__r.Contact.Department, On_Behalf_Of__r.Contact.Phone, On_Behalf_Of__r.Contact.Email, DeliveryAddressContactName__c, DeliveryAddressHospitalName__c,  DeliveryAddress__c, DeliveryAddressCountry__c, DeliveryAddressPostCode__c, DeliveryContactTelephone__c, DeliveryContactOutOfHoursNumber__c, DeliveryContactFax__c, DeliveryContactEmail__c, DeliveryNote__c,(SELECT Id, Country_Supporting_Info_Requrement__r.Parameter_Name__c, Patient_Request_Supporting_Response__c FROM Patient_Request_Supporting_Informations__r), (SELECT Id, Name, Patient__c, Project_Country_Patient_Parameter__r.Parameter_Name__c , Patient_Parameter_Response__c FROM Patient_Request_Parameters__r),(SELECT Id, Name, Project_Country_Eligibility__r.Question__c, Patient_Eligibility_Response__c,Project_Country_Eligibility__r.Eligibility_Type__c  FROM Patient_Request_Eligibilities__r), (SELECT Id, Name,Dosing_Details__r.Strength__c, Quantity__c  FROM Patient_Dosage_Requests__r) FROM Patient_Request__c WHERE Id =:patientRequestId];
    }
    
    @AuraEnabled
    public static List<Account> getPhySicianCountryInstitutions(Id phySicianID) 
    {
        try {
            List<Contact> contactList  = new List<Contact>();
            List<Account> accountList = new List<Account>();
            contactList = [SELECT Account.Institution_Country__c FROM Contact WHERE id =: phySicianID];
            if(!contactList.isEmpty())
            {
                String country = contactList.get(0).Account.Institution_Country__c;
                if(!String.isEmpty(country))
                {
                    accountList = [SELECT Id, Name,  ShippingPostalCode, ShippingStreet, Institution_Country__c FROM Account WHERE Institution_Country__c =: country ORDER BY Name ASC NULLS LAST];
                }
            }
            return accountList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
            
        } 
    }
    
}