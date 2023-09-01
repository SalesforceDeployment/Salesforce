public class UtilData {
    
   Public static List<Care_Products__c> createCareProduct(Integer len){

        List<Care_Products__c> careProductList = new List<Care_Products__c>();
        for(Integer i = 0; i<len; i++){
            Care_Products__c product = new Care_Products__c();
            product.Name = 'test'+i;
            careProductList.add(product);
        }
        return careProductList;
    }
    
    public static List<Project_Group__c> createProjectGroup(List<Care_Products__c> products){
        
        List<Project_Group__c> projGroupList = new List<Project_Group__c>();
        for(Integer i = 0; i<products.size(); i++){
            Project_Group__c projGroup = new Project_Group__c();
            projGroup.Name = 'Project Group '+i;
            
            /*if(i == 0){
                projGroup.Status__c = 'Closed';
            }else{
                projGroup.Status__c = 'Live';
            }*/
            projGroup.Status__c = 'Live';
            projGroup.Care_Product__c = products[i].Id;
            
            projGroupList.add(projGroup);
        }
        return projGroupList;
    }
    
    public static List<project__c> createProject(List<Project_Group__c> ProjGroups){
        List<project__c> projectsList = new List<project__c>();
        
        for(integer i=0; i<ProjGroups.size(); i++){
            project__c project = new project__c();
            project.Name = 'project '+i;
            project.Project_Code__c = 'CODE';
            project.No_of_weeks_treatment__c   = 3 ;
            
            if(i == 0){
                project.Project_Status__c = 'Draft Creation in Progress';
            }
            /*else{
                project.Project_Status__c = 'Closed';
            }*/
            
            project.Project_Group__c = ProjGroups[i].Id;
            projectsList.add(project);
        }
        return projectsList;
    }
    
    public static List<Indication__c> createIndication(Integer len){
        List<Indication__c> indicationsList = new List<Indication__c>();
        for(Integer i=0; i<len; i++){
            Indication__c indication = new Indication__c();
            indication.Indication_Name__c = 'Indication '+i;
            
            indicationsList.add(indication);
        }
        return indicationsList;
    }
    
    public static List<Project_Indication__c> createProjectIndication(List<project__c> projects, List<Indication__c> indications, Integer len){
        List<Project_Indication__c> projectIndicationsList = new  List<Project_Indication__c>();
        
        for(Integer i=0; i<len; i++){
            Project_Indication__c projectIndications = new Project_Indication__c();
            projectIndications.Project__c = projects[i].Id;
            projectIndications.Indication__c = indications[i].Id;
            
            projectIndicationsList.add(projectIndications);
        }
        
        return projectIndicationsList;
    }
    
    
    public static List<Project_Patient_Parameter__c> createProjectPatientParameter(List<project__c> projects){
        List<Project_Patient_Parameter__c> projectPatientParameterList = new List<Project_Patient_Parameter__c>();
        
        for(Integer i=0; i<projects.size(); i++){
            Project_Patient_Parameter__c projectPatientParameter = new Project_Patient_Parameter__c();
            projectPatientParameter.Project__c = projects[i].Id;
            
            projectPatientParameterList.add(projectPatientParameter);
        }
        
        return projectPatientParameterList;
    }
    
     public static List<Project_Organization_Member__c> createProjectOrganizationMember(List<project__c> projects){
        List<Project_Organization_Member__c> projectOrganizationMemberList = new List<Project_Organization_Member__c>();
        
        for(Integer i=0; i<projects.size(); i++){
            Project_Organization_Member__c projectOrganizationMember = new Project_Organization_Member__c();
            projectOrganizationMember.Project__c = projects[i].Id;
            
            projectOrganizationMemberList.add(projectOrganizationMember);
        }
        
        return projectOrganizationMemberList;
    }
    
    public static List<Project_Regulatory_Consent__c > createProjectRegulatorConsent(List<project__c> projects){
        List<Project_Regulatory_Consent__c > projectRegulatorConsentList = new List<Project_Regulatory_Consent__c >();
        
        for(Integer i=0; i<projects.size(); i++){
            Project_Regulatory_Consent__c projectRegulatorConsent = new Project_Regulatory_Consent__c();
            projectRegulatorConsent.Project__c = projects[i].Id;
            
            projectRegulatorConsentList.add(projectRegulatorConsent);
        }
        
        return projectRegulatorConsentList;
    }
    
    public static List<Project_Country__c > createProjectCountry(List<project__c> projects){
        List<Project_Country__c > projectCountriesList = new List<Project_Country__c >();
        
        for(Integer i=0; i<projects.size(); i++){
            Project_Country__c projectCountry = new Project_Country__c();
            projectCountry.Project__c = projects[i].Id;
            
            projectCountriesList.add(projectCountry);
        }
        
        return projectCountriesList;
    }
    
    public static List<Project_Country_Supporting_Information__c > createProjSuppInfo(List<Project_Country__c> projCountries){
        List<Project_Country_Supporting_Information__c > projectSuppInfoList = new List<Project_Country_Supporting_Information__c >();
        
        for(Integer i=0; i<projCountries.size(); i++){
            Project_Country_Supporting_Information__c projectSuppInfo = new Project_Country_Supporting_Information__c();
            projectSuppInfo.Project_Country__c = projCountries[i].Id;
            
            projectSuppInfoList.add(projectSuppInfo);
        }
        
        return projectSuppInfoList;
    }
    
    public static List<Project_Eligibility__c > createProjectEligibility(List<project__c> projects){
        List<Project_Eligibility__c > projectEligibilityList = new List<Project_Eligibility__c >();
        
        for(Integer i=0; i<projects.size(); i++){
            Project_Eligibility__c projectEligibility = new Project_Eligibility__c();
            projectEligibility.Project__c = projects[i].Id;
            
            projectEligibilityList.add(projectEligibility);
        }
        
        return projectEligibilityList;
    }
    
    public static List<Project_Supporting_Information__c > createProjectSuportingInformation(List<project__c> projects){
        List<Project_Supporting_Information__c > projectSuportingInformationList = new List<Project_Supporting_Information__c >();
        
        for(Integer i=0; i<projects.size(); i++){
            Project_Supporting_Information__c projectSuportingInformation = new Project_Supporting_Information__c();
            projectSuportingInformation.Project__c = projects[i].Id;
            
            projectSuportingInformationList.add(projectSuportingInformation);
        }
        
        return projectSuportingInformationList;
    }
    
    Public static List<Care_Products__c> createCareProducts(Integer len){

        List<Care_Products__c> careProductList = new List<Care_Products__c>();
        for(Integer i = 0; i<len; i++){
            Care_Products__c product = new Care_Products__c();
            product.Name = 'test'+i;
            careProductList.add(product);
        }
        return careProductList;
    }
    
     public static List<Project_Group__c> createProjectGroups(List<Care_Products__c> products){
        
        List<Project_Group__c> projGroupList = new List<Project_Group__c>();
        for(Integer i = 0; i<products.size(); i++){
            Project_Group__c projGroup = new Project_Group__c();
            projGroup.Name = 'Project Group '+i;
            
            /*if(i == 0){
                projGroup.Status__c = 'Closed';
            }else{
                projGroup.Status__c = 'Live';
            } */
            projGroup.Care_Product__c = products[i].Id;
            
            projGroupList.add(projGroup);
        }
        return projGroupList;
    }
    
    public static List<project__c> createProjects(List<Project_Group__c> ProjGroups){
        List<project__c> projectsList = new List<project__c>();
        
        for(integer i=0; i<ProjGroups.size(); i++){
            project__c project = new project__c();
            project.Name = 'project '+i;
            project.Project_Code__c = 'CODE';
            
            /*if(i == 0){
                 project.Project_Status__c = 'Draft Creation in Progress';
            }else{
                project.Project_Status__c = 'Draft in Review';
            }*/
            
            project.Project_Status__c = 'Draft Creation in Progress';
            
            project.Project_Group__c = ProjGroups[i].Id;
            projectsList.add(project);
        }
        return projectsList;
    }
    
    public static List<Indication__c> createIndications(List<Project__c> Projects){
        List<Indication__c> indicationsList = new List<Indication__c>();
        
        for(integer i=0; i<Projects.size(); i++){
            Indication__c indication = new Indication__c();
            indication.Indication_Name__c  = 'indication '+i;            
            
            indication.Project__c  = Projects[i].Id;
            indicationsList.add(indication);
        }
        return indicationsList;
    }
    
    
    public static List<Project_Indication__c> createProjectIndications(List<Project__c> Projects,List<Indication__c> indications){
        List<Project_Indication__c> projectIndicationsList = new List<Project_Indication__c>();
        
        for(integer i=0; i<Projects.size(); i++){
            Project_Indication__c projectIndication = new Project_Indication__c();
            projectIndication.Indication__c = indications[i].Id;            
            
            projectIndication.Project__c  = Projects[i].Id;
            projectIndicationsList.add(projectIndication);
        }
        return projectIndicationsList;
    }
    
    public static List<Project_Country__c> createProjectCountries(List<Project__c> projects){
        List<Project_Country__c> projCountries = new List<Project_Country__c>();
        
         for(Integer i = 0; i<projects.size(); i++){
            Project_Country__c projCountry = new Project_Country__c();
            projCountry.Country__c = 'India';
            projCountry.Adverse_Event_Email__c = 'india'+i+'@gmail.com';
            //projCountry.Adverse_Event_Fax__c = '9876201340';
            projCountry.ShowEligibilityCriteriaInTA__c = true;
            projCountry.Project__c = projects[i].Id;
            projCountries.add(projCountry);
        }
        return projCountries;
    }
    
     public static List<Project_Country_Eligibility__c > createProjectCountryEligibilities(List<Project_Country__c> projectCountries){
        List<Project_Country_Eligibility__c > projectCountryEligibilityList = new List<Project_Country_Eligibility__c>();
        
         for(Integer i = 0; i<projectCountries.size(); i++){
            Project_Country_Eligibility__c projCountryEligibity = new Project_Country_Eligibility__c();
            projCountryEligibity.Project_Country__c  = projectCountries[i].Id;
            projCountryEligibity.Compulsary_Question__c  = true;
            projCountryEligibity.Eligibility_Type__c = 'Inclusion Criteria';
            projCountryEligibity.Response_Type__c = 'Test';
            projCountryEligibity.Picklist_Options__c = 'a,b';
            projCountryEligibity.First__c = true;
            projectCountryEligibilityList.add(projCountryEligibity);
        }
        return projectCountryEligibilityList;
        
    }
   
     public static List<Dosing_Detail__c > createDosingDetails(List<Indication__c> indications){
        List<Dosing_Detail__c> dosingDetailsList = new List<Dosing_Detail__c>();
        
         for(Integer i = 0; i<indications.size(); i++){
            Dosing_Detail__c dosingDetail = new Dosing_Detail__c();
            dosingDetail.Strength__c = 'Strength '+i; 
            dosingDetail.Indication__c  = indications[i].Id;
            dosingDetailsList.add(dosingDetail);
        }
        return dosingDetailsList;
    }
    
    public static List<Project_Eligibility__c> createProjectEligiblityList(List<Project__c> projects){
        List<Project_Eligibility__c> projectEligibilityList = new List<Project_Eligibility__c>();
        
         for(Integer i = 0; i<projects.size(); i++){
            Project_Eligibility__c  projectEligibility = new Project_Eligibility__c();
            projectEligibility.Eligibility_Type__c = 'Inclusion Criteria'; 
            projectEligibility.Project__c  = projects[i].Id;
            projectEligibility.Question__c = 'What is your project eligiblity skills?';
            projectEligibilityList.add(projectEligibility);
        }
        return projectEligibilityList;
    }
    
    public static List<Project_Country_Indication__c> createProjectCountryIndications(List<Indication__c> indications, List<Project_Country__c> projectCountries){
        List<Project_Country_Indication__c> projectIndicationCountries = new List<Project_Country_Indication__c>();
        
         for(Integer i = 0; i<indications.size(); i++){
            Project_Country_Indication__c projCountryIndication = new Project_Country_Indication__c();
            projCountryIndication.Indication__c  = indications[i].Id;
            projCountryIndication.Project_Country__c  = projectCountries[i].Id;
            projectIndicationCountries.add(projCountryIndication);
        }
        return projectIndicationCountries;
    }
    
    public static List<Account> createAccountsList(integer len){
        List<Account> accounts = new List<Account>();
        for(integer i=0;i<len;i++){
            Account acc = new Account();

            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Institution').getRecordTypeId();
            system.debug('recordTypeId ::' + recordTypeId);
            acc.RecordTypeId = recordTypeId;
            acc.Name = 'Demo Account';
            acc.Institution_Country__c = 'India';
            acc.BillingCity = 'Jaipur';
            acc.BillingState = 'Raj';
            acc.BillingCountry = 'India';
            acc.BillingPostalCode = '302012';
            acc.Due_Diligence_Complete__c = true;
            accounts.add(acc);
        }
        return accounts;
    }
    
    public static List<Contact> createContactsList(integer len){
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = createAccountsList(len);
        for(integer i=0;i<len;i++){
            Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Institution').getRecordTypeId();
            Contact cont = new Contact();
            cont.RecordTypeId =recordTypeId;
            cont.LastName = 'Test Contact';
            cont.AccountId = accounts[i].Id;
            cont.Phone = '1234567890';
            cont.Email = 'test@test.com';
            cont.Role__c = 'Physician';
            cont.Validation__c = true;
            contacts.add(cont);
        }
        return contacts;
    }
    
    public static List<Institution_Treatment__c> createInstitutionTreatmentList(List<Account> accounts,List<Project_Group__c> projectGroups){
        List<Institution_Treatment__c> institutionTreatments = new List<Institution_Treatment__c>();
        for(integer i=0;i<projectGroups.size();i++){
            Institution_Treatment__c institutionTreat = new Institution_Treatment__c();
            institutionTreat.Institution__c = accounts[i].Id;
            institutionTreat.Treatment__c = projectGroups[i].Id;
            institutionTreatments.add(institutionTreat);
        }
        return institutionTreatments;
    }
    
    public static List<Institution_Treatment_Indication__c> createInstitutionTreatmentIndicationList(List<Institution_Treatment__c> institutionTreatments,List<Indication__c> indications){
        List<Institution_Treatment_Indication__c> institutionTreatmentIndications = new List<Institution_Treatment_Indication__c>();
        for(integer i=0;i<indications.size();i++){
            Institution_Treatment_Indication__c institutionTreatIndication = new Institution_Treatment_Indication__c();
            institutionTreatIndication.Institution_Treatment__c = institutionTreatments[i].Id;
            institutionTreatIndication.Indication__c = indications[i].Id;
            institutionTreatmentIndications.add(institutionTreatIndication);
        }
        return institutionTreatmentIndications;
    }
    
    public static List<Project_Group__c> createProjectGroupsTreatmentLookup(List<Care_Products__c> products){
        
        List<Project_Group__c> projGroupList = new List<Project_Group__c>();
        for(Integer i = 0; i<products.size(); i++){
            Project_Group__c projGroup = new Project_Group__c();
            projGroup.Name = 'Project Group '+i;
            projGroup.Status__c = 'Live';
            projGroup.Care_Product__c = products[i].Id;
            
            projGroupList.add(projGroup);
        }
        return projGroupList;
    }
    
    public static List<Treatment_Access_Request__c> CreateTreatmentAccessRequests(Integer numberOfRecords, List<Project_Group__c> projectGroups, List<Account> accounts){
        List<Treatment_Access_Request__c> treatmentAccessRequests = new List<Treatment_Access_Request__c>();
        
        for(integer i=0; i<numberOfRecords; i++){
            Treatment_Access_Request__c request = new Treatment_Access_Request__c();
            request.Project_Group__c  = projectGroups[i].Id;
            request.Which_Institution__c  = accounts[i].Id;
            //request.Status__c  = 'Approved';
            treatmentAccessRequests.add(request);
            
        }
        return treatmentAccessRequests;
    }
        
    public static List<project__c> createLiveProjects(List<Project_Group__c> ProjGroups){
        List<project__c> projectsList = new List<project__c>();
        
        for(integer i=0; i<ProjGroups.size(); i++){
            project__c project = new project__c();
            project.Name = 'project '+i;
            project.Project_Code__c = 'CODE';            
            project.Project_Status__c = 'Draft in Review';
            
            project.Project_Group__c = ProjGroups[i].Id;
            projectsList.add(project);
        }
        return projectsList;
    }
    
    public static List<Project_Country_Patient_Parameter__c > createProjectCountryPatientParameter(List<Project_Country__c> projectCountries){
        List<Project_Country_Patient_Parameter__c > projCountryPatientParameterList = new List<Project_Country_Patient_Parameter__c>();
        
         for(Integer i = 0; i<projectCountries.size(); i++){
            Project_Country_Patient_Parameter__c projCountryPatientParameter = new Project_Country_Patient_Parameter__c();
            projCountryPatientParameter.Project_Country__c  = projectCountries[i].Id;
            projCountryPatientParameter.Parameter_Name__c  = 'Parameter '+1;
            projCountryPatientParameter.Response_Type__c  = 'MultiSelect';
            projCountryPatientParameter.Picklist_Options__c = 'a,b';
            projCountryPatientParameterList.add(projCountryPatientParameter);
        }
        return projCountryPatientParameterList;
    }
    
    public static List<Project_Country_Regulatory_Consent__c> createProjectCountryRegulatoryConsent(List<Project_Country__c> projectCountries){
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = new List<Project_Country_Regulatory_Consent__c>();
        
        for(Integer i = 0; i<projectCountries.size(); i++){
            Project_Country_Regulatory_Consent__c ProjectCountryRegulatoryConsent = new Project_Country_Regulatory_Consent__c();
            ProjectCountryRegulatoryConsent.Project_Country__c  = projectCountries[i].Id;
            ProjectCountryRegulatoryConsent.Consent_Title__c  = 'Consent '+1;
            ProjectCountryRegulatoryConsent.Sequence_Order__c = 2;
            ProjectCountryRegulatoryConsentList.add(ProjectCountryRegulatoryConsent);
            
        }
        return ProjectCountryRegulatoryConsentList;
    }
    //Nidhi---------------------
    public static List<Institution_Additional_Address__c> createInstitutionAddress(List<Account> accounts ){
        List<Institution_Additional_Address__c> recList = new List<Institution_Additional_Address__c>();
        for(Integer i = 0; i<accounts.size(); i++){
            Institution_Additional_Address__c obj = new Institution_Additional_Address__c(
                Institution__c =  accounts[i].id,
                Additional_Address__Street__s =  'Sunflower Road',
                Additional_Address__City__s =  'Dubai',
                Additional_Address__PostalCode__s =  null,
                Additional_Address__StateCode__s =  null,
                Additional_Address__CountryCode__s =  'AE',
                Additional_Address__Latitude__s =  null,
                Additional_Address__Longitude__s =  null,
                Additional_Address__GeocodeAccuracy__s =  null,
                Description__c =  null,
                Legacy_ID__c =  null
            );
            recList.add(obj);
        }
        return recList;
    }

    public static Patient__c createPatient(ID contactId){
        Patient__c obj = new Patient__c(
            Discontinued__c = false,
            Date_of_Birth__c = System.today() - 20*365,
            Gender__c = null,
            Initials__c = 'Tara',
            //Care_Product__c = a1R2z000000BwqJEAS,
            //Indication__c = indicationId,
            //Patient_ID__c = 1231-49470-01,
            Created_by_HCP__c = null,
            Updated_By_HCP__c = null,
            Patient_Declined__c = false,
            Project_Group__c = null,
            Contact__c = contactId,
            Institution__c = null,
            Legacy_ID__c = null
        
        );
        return obj;
    }
    
    public static Patient__c createPatient(ID contactId, ID indicationId){
        Patient__c obj = new Patient__c(
            Discontinued__c = false,
            Date_of_Birth__c = System.today() - 20*365,
            Gender__c = null,
            Initials__c = 'Tara',
            //Care_Product__c = a1R2z000000BwqJEAS,
            //Indication__c = indicationId,
            //Patient_ID__c = 1231-49470-01,
            Created_by_HCP__c = null,
            Updated_By_HCP__c = null,
            Patient_Declined__c = false,
            Project_Group__c = null,
            Contact__c = contactId,
            Institution__c = null,
            Legacy_ID__c = null
        
        );
        return obj;
    }
    public static Patient_Request__c createPatientRequest(){
        Date todayDate = Date.today();
		Date resupplyDate = todayDate.addDays(2);
        Patient_Request__c pr = new Patient_Request__c(Status__c = 'Delivered',Resupply_Due_Date__c = resupplyDate, First_Follow_Up__c=todayDate,Requested_By__c=UserInfo.getUserId());
        return pr;
    }

    public static Patient_Request_Note__c createPatientRequestNote(Patient_Request__c patientRequest){
        Patient_Request_Note__c patientRequestNote = new Patient_Request_Note__c(
            Patient_Request__c = patientRequest.id,
            Notes__c = 'null',
            Legacy_ID__c = null,
            Notes_Type__c = 'Sponser Medical Review',
            Patient_Discontinuation_Reason__c = null,
            Discontinuation_Date__c = null
        );
        return patientRequestNote;

         //requestOverviewNote : [SELECT Id, Status__c, Stage__c, Notes_Type__c, Discontinuation_Date__c, Notes__c, createdBy.Name, createdDate FROM Patient_Request_Note__c WHERE Patient_Request__c=:patientRequestId AND createdDate > :dtUpdated ORDER BY createdDate DESC]) {

    }
     public static Patient_Request_Supporting__c createPatientRequestSupporting(ID patientId, ID csirId, ID patientRequestId, ID ProjectGroupId){
        Patient_Request_Supporting__c patientRequestSupporting = new Patient_Request_Supporting__c(
            Patient__c = patientId,
            Country_Supporting_Info_Requrement__c = csirId,
            Patient_Request_Supporting_Response__c = null,
            Patient_Request__c = patientRequestId,
            Project_Group__c = ProjectGroupId,
            Legacy_ID__c = null,
            Additional_Information__c = null
        );
        return patientRequestSupporting;
        //Patient_Request_Supporting__c supportingReq: [SELECT Id, Country_Supporting_Info_Requrement__c, Country_Supporting_Info_Requrement__r.Response_Type__c, Country_Supporting_Info_Requrement__r.Parameter_Name__c, Patient_Request__c, Patient_Request_Supporting_Response__c FROM Patient_Request_Supporting__c WHERE Patient_Request__c=:patientRequestId]) {
            
    }
    
     public static Patient_Dosage_Request__c createPatientDosageRequest(ID patientRequestId){
        Patient_Dosage_Request__c patientDosageRequest = new Patient_Dosage_Request__c(
            Patient_Access_Request__c = patientRequestId,
            Quantity_Shipped__c	= 0,
            Quantity__c = 5,
            Reassigned_Quantity__c = 10
        );
        return patientDosageRequest;
        //Patient_Dosage_Request__c doseRequest: [SELECT Id, Dosing_Details__c, Quantity__c, Strength__c, Patient_Access_Request__c FROM Patient_Dosage_Request__c WHERE Patient_Access_Request__c=:patientRequestId]) {
            
    }
     public static Patient_Request_Parameters__c createPatientRequestParameters(ID patientId, ID projCountryPatientParameterId, ID patientRequestId, ID ProjectGroupId){
        Patient_Request_Parameters__c PatientRequestParameters = new Patient_Request_Parameters__c(
            Patient_Request__c = patientRequestId,
            Patient__c = patientId,
            Project_Country_Patient_Parameter__c = projCountryPatientParameterId,
            Patient_Parameter_Response__c = 'Test',
            Project_Group__c = ProjectGroupId,
            Legacy_ID__c = null
        );
        return PatientRequestParameters;
        //Patient_Request_Parameters__c parameterRecord: [SELECT Id, Project_Country_Patient_Parameter__c, Project_Country_Patient_Parameter__r.Parameter_Name__c,Project_Country_Patient_Parameter__r.Response_Type__c, Patient_Parameter_Response__c FROM Patient_Request_Parameters__c WHERE Patient_Request__c=:patientRequestId]) {
            
    }
     public static Patient_Request_Eligibility__c createPatientRequestEligibility(ID patientId, ID projectCountryEligibilityId, ID patientRequestId, ID ProjectGroupId){
        Patient_Request_Eligibility__c PatientRequestEligibility = new Patient_Request_Eligibility__c(
            Patient_Eligibility_Response__c = 'No',
            Patient_Request__c = patientRequestId,
            Project_Country_Eligibility__c = projectCountryEligibilityId,
            Project_Group__c = ProjectGroupId,
            Patient__c = patientId,
            Legacy_ID__c = null
        );
        return PatientRequestEligibility;
        //Patient_Request_Eligibility__c patientRecord: [SELECT Id, Project_Country_Eligibility__c, Project_Country_Eligibility__r.Eligibility_Type__c, Project_Country_Eligibility__r.Question__c,Project_Country_Eligibility__r.Response_Type__c, Patient_Eligibility_Response__c FROM Patient_Request_Eligibility__c WHERE Patient_Request__c=:patientRequestId]) {
            
    }
    
    public static Patient_Dosage_Request_History__c createPatientDosageRequestHistory(ID patientReqId, ID patientReqDosageId, String status){
        Patient_Dosage_Request_History__c newPatientHistory = new Patient_Dosage_Request_History__c ();
        newPatientHistory.Patient_Dosage_Request__c = patientReqDosageId;
        newPatientHistory.Quantity__c = 5;
        newPatientHistory.Patient_Request__c = patientReqId;
        newPatientHistory.Date__c = system.today();
        newPatientHistory.Action__c = 'Reassigned';
        newPatientHistory.Status__c = status;
        return newPatientHistory;
    }

    public static Project_Country_Indication_Dosing__c createProjectCountryIndicationDosing(ID ProjectCountryIndicationId){
        Project_Country_Indication_Dosing__c ProjectCountryIndicationDosing = new Project_Country_Indication_Dosing__c (
            Project_Country__c = null,
            Project_Country_Indication__c = ProjectCountryIndicationId,
            Can_be_overridden_by_HCP__c = true,
            Default_Quantity__c = 5,
            Description__c = null,
            Strength__c = '150 mg Vials'
        );
        return ProjectCountryIndicationDosing;
    }

    public static Project_Country_Eligibility_Display_Rule__c createProjectCountryEligibilityDisplayRule(ID ProjectCountryEligibilityId1, ID ProjectCountryEligibilityId2){
        Project_Country_Eligibility_Display_Rule__c ProjectCountryEligibilityDisplayRule = new Project_Country_Eligibility_Display_Rule__c (
            Project_Country_Eligibility__c = ProjectCountryEligibilityId1,
            When_Answer_Is__c = 'test',
            Display_Rule_Applied_On__c = ProjectCountryEligibilityId2,
            Legacy_ID__c = null
        );
        return ProjectCountryEligibilityDisplayRule;
    }
    public static Project_Country_Supporting_Information__c createProjectCountrySupportingInformation(ID ProjectId, ID ProjectCountryId){
        Project_Country_Supporting_Information__c ProjectCountrySupportingInformation = new Project_Country_Supporting_Information__c (
            Project_Country__c = ProjectCountryId,
            Business_Rule__c = null,
            First__c = false,
            Picklist_Options__c = null,
            Repeat__c = false,
            Response_Type__c = 'MultiSelect',
            Parameter_Name__c = 'last 6 months of medical history',
            Patient__c = null,
            Patient_Request_Information_Requrement__c = null,
            Patient_Request__c = null,
            Project_Group__c = null,
            Legacy_ID__c = null,
            Compulsory_Question__c = false
        );
        return ProjectCountrySupportingInformation;
    }
    public static Proj_Country_Patient_Para_Display_Rule__c createProjectCountryIndicationDosing(ID ProjectCountryPatientParameteId1, ID ProjectCountryPatientParameteId2){
        Proj_Country_Patient_Para_Display_Rule__c ProjCountryPatient_ParaDisplayRule = new Proj_Country_Patient_Para_Display_Rule__c (
            Display_Rule_Applied_On__c	= ProjectCountryPatientParameteId1,
            Legacy_ID__c = 'ID:' + ProjectCountryPatientParameteId1,
            Project_Country_Patient_Parameter__c	= ProjectCountryPatientParameteId2,
            When_Answer_Is__c =	'Long Text Area(131072)'
        );
        return ProjCountryPatient_ParaDisplayRule;
    }
    /*
    public static Project_Country_Indication_Dosing__c create(ID ){
        Project_Country_Indication_Dosing__c ProjectCountryIndicationDosing = new Project_Country_Indication_Dosing__c (
            
        
        );
        return ProjectCountryIndicationDosing;
    }
    */
    
    public static List<Account> createOrganizationAccount(integer len){
        List<Account> accounts = new List<Account>();
        for(integer i=0;i<len;i++){
            Account acc = new Account();

            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Organisation').getRecordTypeId();
            system.debug('recordTypeId ::' + recordTypeId);
            acc.RecordTypeId = recordTypeId;
            acc.Name = 'Demo Account';
            acc.Institution_Country__c = 'India';
            acc.BillingCity = 'Jaipur';
            acc.BillingState = 'Raj';
            acc.BillingCountry = 'India';
            acc.BillingPostalCode = '302012';
            acc.Due_Diligence_Complete__c = true;
            accounts.add(acc);
        }
        return accounts;
    }

}