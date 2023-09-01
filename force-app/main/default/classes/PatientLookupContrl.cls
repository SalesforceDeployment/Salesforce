public without sharing class PatientLookupContrl {
    
    @AuraEnabled(cacheable=true)
    public static List<Patient_Request__c> getPhysicianPatients(){
        
        List<Patient_Request__c> patientListRecord = new List<Patient_Request__c> ();
        String profileName = getPersona();
        Set<Id> accId= new Set<Id>();
        List<Account> institutins = PatientLookupContrl.getInstitutions();
        for(Account Acr: institutins)
        {
            accId.add(Acr.Id);
        }
        if(profileName == 'Physician' || profileName == 'Pharmacist'){
            for (Patient_Request__c patObj : [ SELECT  Id, Name, Stage__c, Status__c,Institutation__c, On_Behalf_Of__r.Name,DeliveryAddressCountry__c,Patient__c,
                                              Patient__r.Patient_ID__c,Patient__r.Indication__r.Indication__r.Indication_Name__c, Institutation__r.Institution_Country__c, Institutation__r.Name,
                                              Project_Group__c,  Project_Group__r.Care_Product__r.Name, Patient__r.Initials__c, Patient__r.Date_of_Birth__c,Owner.Name,PatientId__c
                                              FROM Patient_Request__c
                                              WHERE Institutation__c =:accId LIMIT 2000]) {
                                                  patientListRecord.add(patObj);
                                              }
            if (patientListRecord.size () == 0) {
                throw new AuraHandledException ('No Record Found..');
            }
        }else if(profileName == 'Sponsor' || profileName == 'Internal Reviewer' || profileName == 'Regulatory Reviewer'){
            for (Patient_Request__c patObj : [ SELECT  Id, Name, Stage__c, Status__c,Institutation__c, On_Behalf_Of__r.Name,DeliveryAddressCountry__c,Patient__c,
                                            Patient__r.Patient_ID__c,Patient__r.Indication__r.Indication__r.Indication_Name__c, Institutation__r.Institution_Country__c, Institutation__r.Name,
                                            Project_Group__c,  Project_Group__r.Care_Product__r.Name, Patient__r.Initials__c, Patient__r.Date_of_Birth__c,Owner.Name,PatientId__c
                                            FROM Patient_Request__c
                                            WHERE Institutation__c =:accId
                                            AND CreatedById=:UserInfo.getUserId() LIMIT 2000]) {
                                                patientListRecord.add(patObj);
                                            }
                if (patientListRecord.size () == 0) {
                throw new AuraHandledException ('No Record Found..');
                }
        }else{
            patientListRecord = [ SELECT  Id, Name, Stage__c, Status__c, On_Behalf_Of__r.Name,Institutation__c,DeliveryAddressCountry__c,Patient__c, Patient__r.Patient_ID__c,
                                 Patient__r.Indication__r.Indication__r.Indication_Name__c, Institutation__r.Institution_Country__c, Institutation__r.Name, Project_Group__c,  Project_Group__r.Care_Product__r.Name,
                                 Patient__r.Initials__c, Patient__r.Date_of_Birth__c,Owner.Name,PatientId__c
                                 FROM Patient_Request__c
                                 WHERE Institutation__c =:accId LIMIT 2000];
        }
        return patientListRecord;
    }
    
    @AuraEnabled
    public static List<Patient_Request__c> getFilteredPatients(String patientId,String initial, Date birthDate, List<String> selectedInstitutions,
                                                               List<String> selectecTretments, List<String> selectedStatus, List<String> selectedCounrties){
                                                                   try {
                                                                       String mainQuery = 'select  Id, Name, Stage__c, Status__c, On_Behalf_Of__r.Name,DeliveryAddressCountry__c,Institutation__c,'+
                                                                           'Patient__c, Patient__r.Patient_ID__c,Patient__r.Indication__r.Indication__r.Indication_Name__c, Institutation__r.Institution_Country__c'+
                                                                           ', Institutation__r.Name, Project_Group__c,  Project_Group__r.Care_Product__r.Name, Patient__r.Initials__c, Patient__r.Date_of_Birth__c,'+
                                                                           'Owner.Name, PatientId__c, PARAssignedToPAMUser__r.Name from Patient_Request__c where Institutation__r.Account_Type__c = \'Institution\'';//changes done on 03/06/2023
                                                                       List<String> whereQ = new List<String>(); //changes done on 03/06/2023
                                                                       if(!String.isBlank(patientId)){
                                                                           String pId ='%' + patientId + '%'; //changes done on 06/13/2023
                                                                           whereQ.add('PatientId__c LIKE :pId'); //changes done on 06/13/2023
                                                                       }
                                                                       if(!String.isBlank(initial)){
                                                                           String initialvalue ='%' + initial + '%';
                                                                           whereQ.add('Patient__r.Initials__c LIKE :initialvalue'); //changes done on 06/13/2023
                                                                       }
                                                                       if(birthDate != null){
                                                                           whereQ.add('Patient__r.Date_of_Birth__c =:birthDate');
                                                                       }
                                                                       if(selectedInstitutions.size()>0){
                                                                           whereQ.add('Institutation__c IN:selectedInstitutions');//changes done on 03/06/2023
                                                                       }
                                                                       if(selectecTretments.size()>0){
                                                                           whereQ.add('Project_Group__c IN:selectecTretments');//changes done on 03/06/2023
                                                                       }
                                                                       if(selectedStatus.size()>0){
                                                                           whereQ.add('Status__c IN:selectedStatus');//changes done on 03/06/2023
                                                                       }
                                                                       if(selectedCounrties.size()>0){
                                                                           whereQ.add('Institutation__r.Institution_Country__c IN:selectedCounrties');//changes done on 03/06/2023
                                                                       }
                                                                       if(!whereQ.isEmpty()){ //changes done on 03/06/2023
                                                                           mainQuery += ' AND ' + string.join(whereQ, ' AND '); //changes done on 03/06/2023
                                                                       }
                                                                       
                                                                       List<Patient_Request__c> patientListRecord = new List<Patient_Request__c> ();
                                                                       String profileName = getPersona();
                                                                       if(profileName == 'Physician'  || profileName == 'Pharmacist'){
                                                                           string currentUserId = UserInfo.getUserId();//changes done on 03/06/2023
                                                                           if(selectedInstitutions.size() == 0){
                                                                               Set<Id> accId= new Set<Id>();
                                                                               List<Account> institutins = PatientLookupContrl.getInstitutions();
                                                                               for(Account Acr: institutins)
                                                                               {
                                                                                   accId.add(Acr.Id);
                                                                               }
                                                                               mainQuery = mainQuery + ' AND Institutation__c IN :accId';
                                                                           }
                                                                           mainQuery = mainQuery + ' ORDER BY PatientId__c ASC NULLS LAST LIMIT 2000';
                                                                           patientListRecord = Database.query(mainQuery);
                                                                           if (patientListRecord.size () == 0) {
                                                                               throw new AuraHandledException('No Record Found..');
                                                                           }
                                                                       } else if(profileName == 'Sponsor'  || profileName == 'Internal Reviewer'){
                                                                           string currentUserId = UserInfo.getUserId();//changes done on 03/06/2023
                                                                           mainQuery = mainQuery+' AND (Stage__c != \'Create Patient Access Request\' AND Stage__c != \'Physician Approval\' AND Stage__c != \'Bionical Review\') ORDER BY PatientId__c ASC NULLS LAST LIMIT 2000';//changes done on 03/06/2023
                                                                           patientListRecord = Database.query(mainQuery);
                                                                           if (patientListRecord.size () == 0) {
                                                                               throw new AuraHandledException('No Record Found..');
                                                                           }
                                                                       }
                                                                       else if(profileName == 'Regulatory Reviewer'){
                                                                        string currentUserId = UserInfo.getUserId();//changes done on 03/06/2023
                                                                        mainQuery = mainQuery+' AND ((Stage__c = \'Approved\' OR Stage__c = \'Dispatched\' OR Stage__c = \'Regulatory Review and Approval\')';
                                                                        mainQuery = mainQuery+' AND (Status__c != \'Closed - Cancelled\' AND Patient__r.Discontinued__c = false AND Status__c != \'Closed - Declined\')) ORDER BY PatientId__c ASC NULLS LAST LIMIT 2000';//changes done on 03/06/2023
                                                                        patientListRecord = Database.query(mainQuery);
                                                                        if (patientListRecord.size () == 0) {
                                                                            throw new AuraHandledException('No Record Found..');
                                                                        }
                                                                    } else{
                                                                           mainQuery = mainQuery+' ORDER BY PatientId__c ASC NULLS LAST LIMIT 2000';//changes done on 03/06/2023
                                                                           patientListRecord = Database.query(mainQuery);
                                                                       }
                                                                       return patientListRecord;
                                                                   } catch (Exception e) {
                                                                       throw new AuraHandledException(e.getMessage());
                                                                   }
                                                               }
    @AuraEnabled(cacheable=true)
    public static String isPhyscian(){
        String profileName = '';
        profileName = getPersona();
        return profileName;
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getInstitutions(){
        String persona = '';
        persona = getPersona();
        Id contactId = [select Id, AccountId, ContactId from User where id =: UserInfo.getUserId() LIMIT 1 ].ContactId;
        Id accountId = [select Id, AccountId, ContactId from User where id =: UserInfo.getUserId() ].AccountId;
        List<Account> acclist = new List<Account>();
        if(persona == 'Physician' || persona == 'Pharmacist'){
            List<Account> allAssociatedAccounts =  accountDataController.accountContactData(contactId);
            acclist = allAssociatedAccounts;
        }
        else if(persona == 'Sponsor' || persona == 'Internal Reviewer' || persona == 'Regulatory Reviewer'){
            List<Institution_Treatment__c> institTreatList = getInstitutionTreatment(persona,accountId);
            Set<Id> instiIds= new Set<Id>();
            for(Institution_Treatment__c intreat : institTreatList){
                instiIds.add(intreat.Institution__c);
            }
            acclist = [Select Id, Name,  ShippingPostalCode, ShippingStreet, Institution_Country__c FROM Account WHERE Account_Type__c = 'Institution' AND Id =:instiIds ORDER BY Name];
        }
        else{
            acclist = accountDataController.accountDataForAdminandManagers();
        }
        return acclist;
    }
    @AuraEnabled
    public static String getPersona()
    {
        String persona = '';
        Id contactId = [select Id, AccountId, ContactId from User where id =: UserInfo.getUserId() LIMIT 1 ].ContactId;
        if(contactId != null)
        {
            List<Contact> contact = accountDataController.contactData(contactId);
            if(contact.get(0).RecordType.Name == 'Organisation')
            {
                persona = 'Sponsor';  
            }
            else {
                persona = contact.get(0).Role__c;
            }
        }
        else {
            Map<string,Boolean> access = accountDataController.permissionForAdminandManagers();
            if(access.get('Manager') == true)
            {
                persona = 'PAM' ; 
            }
            if(access.get('Admin') == true)
            {
                persona = 'Bionical EMAS' ; 
            }
            if(access.get('Reviewer') == true)
            {
                persona = 'Internal Reviewer' ; 
            }
            if(access.get('RegulatoryReviewer') == true)
            {
                persona = 'Regulatory Reviewer' ; 
            }
            if(access.get('PM') == true)
            {
                persona = 'PM' ; 
            }
        }
        return persona;
    }
    @AuraEnabled
    public static List<Institution_Treatment__c> getInstitutionTreatment(String persona, Id accountId){
        try {
            List<Project__c> projects = new  List<Project__c>();
            List<Institution_Treatment__c> insTreatmentList= new List<Institution_Treatment__c>();
            if(persona == 'Internal Reviewer'){
                set<Id> projIds = new set<Id>();
                List<Project_Bionical_Medical_Reviewer__c> medicalReview = [SELECT id, Project__c, Bionical_Medical_Reviewer__c FROM Project_Bionical_Medical_Reviewer__c WHERE Bionical_Medical_Reviewer__c =: UserInfo.getUserId()];
                for(Project_Bionical_Medical_Reviewer__c medProj : medicalReview ){
                    projIds.add(medProj.Project__c);
                }
                projects = [SELECT id, Name,Organisation__c,Project_Group__c FROM Project__c WHERE id IN :projIds AND Project_Status__c='Live'];
            }
            else if(persona == 'Regulatory Reviewer')
            {
                set<Id> projIds = new set<Id>();
                List<Project_Regulatory_Reviewers__c> regulatoryReviewer = [SELECT Id , Name,Project__c, Regulatory_Reviewer__c FROM Project_Regulatory_Reviewers__c WHERE Regulatory_Reviewer__c =: UserInfo.getUserId()];
                for(Project_Regulatory_Reviewers__c rReviewer : regulatoryReviewer ){
                    projIds.add(rReviewer.Project__c);
                }
                projects = [SELECT id, Name,Organisation__c,Project_Group__c FROM Project__c WHERE id IN :projIds AND Project_Status__c='Live'];
            } else{
                projects = projectDataController.projectData(accountId);
            }
            Set<Id> pgIds= new Set<Id>();
            for(Project__c proj: projects){
                pgIds.add(proj.Project_Group__c);
            }
            insTreatmentList = [SELECT Id, Name,Treatment_Name__c,Country__c,Institution__c, Treatment__r.Name, Treatment__r.Id, Treatment__r.Care_Product__r.Id,Treatment__c, Treatment__r.Care_Product__r.Name FROM Institution_Treatment__c WHERE  Treatment__c  IN : pgIds ORDER BY Country__c ASC];
            return insTreatmentList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //////////////////////////////////////////////////////////
    @AuraEnabled(cacheable=true)
    public static List<InstitutionTreatmentList> getTreatmentsFromPR(){
        Id accountId = [select Id, AccountId, ContactId from User where id =: UserInfo.getUserId() ].AccountId;
        String profileName = getPersona();
        Set<Id> pgIds= new Set<Id>();
        List<Institution_Treatment__c> institTreatList = new List<Institution_Treatment__c>();
        List<InstitutionTreatmentList> data = new List<InstitutionTreatmentList>();
        List<Project_Group__c> projectGroups = new List<Project_Group__c>();
        if(profileName == 'Sponsor' || profileName == 'Internal Reviewer' || profileName == 'Regulatory Reviewer'){
            institTreatList = getInstitutionTreatment(profileName,accountId);
            Set<Id> treatIds= new Set<Id>();
            for(Institution_Treatment__c intreat : institTreatList){
                treatIds.add(intreat.Treatment__c);
            }
            projectGroups = [SELECT Id, IsDeleted, Name, Care_Product__c, Description__c, Visible_for_HCP_to_request_access__c, Status__c, Treatment_Detail__c, Legacy_ID__c, Project_Date__c  FROM Project_Group__c WHERE id IN :treatIds ORDER BY Name];
            
            for(Project_Group__c projgroup : projectGroups){
                InstitutionTreatmentList wrapper = new InstitutionTreatmentList();
                wrapper.institutions = new Set<Id>();
                for(Institution_Treatment__c instTreat: institTreatList){
                    if(instTreat.Treatment__r.Id == projgroup.Id ){
                        wrapper.projectGroupName = instTreat.Treatment__r.Name;
                        wrapper.institutions.add(instTreat.Institution__c);
                        wrapper.projectGroup = instTreat.Treatment__c;
                    }
                    
                }
                data.add(wrapper);
            }
            
        }else{
            Set<Id> accId= new Set<Id>();
            List<Account> institutins = PatientLookupContrl.getInstitutions();
            for(Account Acr: institutins)
            {
                accId.add(Acr.Id);
            }
            projectGroups = [SELECT Id, IsDeleted, Name, Care_Product__c, Description__c, Visible_for_HCP_to_request_access__c, Status__c, Treatment_Detail__c, Legacy_ID__c, Project_Date__c  from Project_Group__c  ORDER BY Name];
            institTreatList = [SELECT Id, Name,Treatment_Name__c,Institution__c, Treatment__r.Name, Treatment__r.Id, Treatment__r.Care_Product__r.Id, Treatment__r.Care_Product__r.Name from Institution_Treatment__c WHERE  Institution__c  =: accId];
            
            for(Project_Group__c projgrp: projectGroups){
                InstitutionTreatmentList wrapper = new InstitutionTreatmentList();
                wrapper.institutions = new Set<Id>();
                for(Institution_Treatment__c insTreat: institTreatList){
                    if(insTreat.Treatment__r.Id == projgrp.Id ){
                        wrapper.projectGroupName = projgrp.Name;
                        wrapper.institutions.add(insTreat.Institution__c);
                        wrapper.projectGroup = projgrp.Id;
                    }
                    
                }
                if(wrapper.institutions.size()>0){
                    data.add(wrapper);
                } 
            }
        }
        return data;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<MyWrapper> getPickValues(){
        Id accountId = [select Id, AccountId, ContactId from User where id =: UserInfo.getUserId() ].AccountId;
        String profileName = getPersona();
        List<MyWrapper> data = new List<MyWrapper>();
        List<Schema.PicklistEntry> picklistValues = Patient_Request__c.Status__c.getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> CountryValues = Account.Institution_Country__c.getDescribe().getPicklistValues();
        
        MyWrapper wrapper = new MyWrapper();
        
        wrapper.statusPicklistValues = new List<String>();
        wrapper.countryPicklistValues = new List<String>();
        for (Schema.PicklistEntry picklistValue : picklistValues) {
            wrapper.statusPicklistValues.add(String.valueOf(picklistValue.getValue()));
        }
        if(profileName == 'Sponsor' || profileName == 'Internal Reviewer' || profileName == 'Regulatory Reviewer'){
            List<Institution_Treatment__c> institTreatList = getInstitutionTreatment(profileName,accountId);
            Set<String> countries= new Set<String>();
            for(Institution_Treatment__c intreat : institTreatList){
                countries.add(intreat.Country__c);
            }
            for(String country : countries ){
                wrapper.countryPicklistValues.add(String.valueOf(country));
            }
        }else{
            Set<Id> accId= new Set<Id>();
            List<Account> institutins = PatientLookupContrl.getInstitutions();
            for(Account Acr: institutins)
            {
                accId.add(Acr.Id);
            }
            List<Institution_Treatment__c> institTreatList = [SELECT Id, Name,Treatment_Name__c,Country__c,Institution__c, Treatment__r.Name, Treatment__r.Id, Treatment__r.Care_Product__r.Id, Treatment__r.Care_Product__r.Name from Institution_Treatment__c WHERE  Institution__c  IN : accId];
            Set<String> countries= new Set<String>();
            for(Institution_Treatment__c intreat : institTreatList){
                countries.add(intreat.Country__c);
            }
            for(String country : countries ){
                wrapper.countryPicklistValues.add(String.valueOf(country));
            }
            // for (Schema.PicklistEntry country : CountryValues) {
            //     wrapper.countryPicklistValues.add(String.valueOf(country.getValue()));
            // }
        }
        
        System.debug('statusPicklistValues: ' + wrapper.statusPicklistValues);
        System.debug('countryPicklistValues: ' + wrapper.countryPicklistValues);
        data.add(wrapper);
        return data;
    }
    public class MyWrapper {
        @AuraEnabled public List<String> statusPicklistValues { get; set; }
        @AuraEnabled public List<String> countryPicklistValues { get; set; }
    }
    public class InstitutionTreatmentList {
        @AuraEnabled public String projectGroupName { get; set; }
        @AuraEnabled public String projectGroup { get; set; }
        @AuraEnabled public Set<Id> institutions { get; set; }
    }
    
}