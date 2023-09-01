/*********************************************************************************************************************
    ClassName ProjectTaskRelatedTest
    Purpose: This is a test class used to test the ProjectTaskRelated functionality.
    AUTHOR : G Soundarya
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class PARControllerTest {
    public PARControllerTest() {    }

    @testSetup 
    static void setup() {

        Integer numberOfrecords = 1;
        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

        Patient__c patient = UtilData.createPatient(contacts[0].id, null);
        insert patient;

        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> projectGroups = UtilData.createProjectGroup(products);
        insert projectGroups;
        
        List<Account> institutions = UtilData.createAccountsList(numberOfrecords);
        insert institutions;
        
        List<Indication__c> indications = UtilData.createIndication(numberOfrecords);
        insert indications;
        
        List<project__c> projects = UtilData.createProjects(projectGroups);
        projects[0].No_of_weeks_treatment__c = 1;
        insert projects;
        
        List<Project_Country__c> projectCountries = UtilData.createProjectCountry(projects);
        insert projectCountries;
        
        List<Project_Country_Indication__c> projectCountryIndications = UtilData.createProjectCountryIndications(indications,projectCountries);
        insert projectCountryIndications;
        
        patient.Project_Group__c = projectGroups[0].id;
        patient.Institution__c = institutions[0].id;
        patient.Care_Product__c = products[0].id;
        patient.Indication__c = projectCountryIndications[0].id;
        patient.SequenceNumber__c = 2;
        patient.RandomSeqNumber__c = 11100;
        update patient;

        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        patientRequest.Status__c = 'Delivered';
        patientRequest.Patient__c = patient.Id;
        patientRequest.PatientIDField__c = String.valueOf(patient.Id);
        insert patientRequest;
        
        Patient_Request__c patientRequest2 = UtilData.createPatientRequest();
        patientRequest2.Status__c = 'Delivered';
        patientRequest2.Patient__c = patient.Id;
        patientRequest2.PatientIDField__c = String.valueOf(patient.Id);
        patientRequest2.PatientId__c = '-11100-02';
        insert patientRequest2;
        
        
        List<Project_Country_Patient_Parameter__c > projCountryPatientParam = UtilData.createProjectCountryPatientParameter(projectCountries);
        projCountryPatientParam[0].Parameter_Name__c = 'Gender';
        projCountryPatientParam[0].Response_Type__c = 'Date';
        insert projCountryPatientParam;
        
        List<Project_Country_Patient_Parameter__c > projCountryPatientParam1 = UtilData.createProjectCountryPatientParameter(projectCountries);
        projCountryPatientParam1[0].Parameter_Name__c = 'Height';
        projCountryPatientParam1[0].Response_Type__c = 'Text';
        insert projCountryPatientParam1;
        
        Patient_Request_Parameters__c patReqParams = UtilData.createPatientRequestParameters(patient.id,projCountryPatientParam[0].id,
                                                                                            patientRequest.id,projectGroups[0].id);
        patReqParams.Patient_Parameter_Response__c = '2023-05-01';
        insert patReqParams;
        
        Patient_Request_Parameters__c patReqParams1 = UtilData.createPatientRequestParameters(patient.id,projCountryPatientParam1[0].id,
                                                                                            patientRequest.id,projectGroups[0].id);
        patReqParams1.Patient_Parameter_Response__c = '20 CM';
        insert patReqParams1;
        
        Patient_Dosage_Request__c patientDosReq = UtilData.createPatientDosageRequest(patientRequest.id);
        insert patientDosReq;
        
        /*Patient_Dosage_Request__c patientDosReq2 = UtilData.createPatientDosageRequest(patientRequest2.id);
        insert patientDosReq2;*/
        
        
    }

    @isTest
    private static void getParametersTest(){
        Patient__c patient = [select Id,name,SequenceNumber__c from Patient__c limit 1];
        Care_Products__c productss = [select id from Care_Products__c limit 1];
        Patient_Request__c req = [select id, Status__c, PatientId__c from Patient_Request__c limit 1];
        Project_Group__c projectGroup = [select id,name from Project_Group__c limit 1];
        Account acc = [select id,name from Account limit 1];
        Project_Country_Indication__c countryIndications = [select id,name from Project_Country_Indication__c limit 1];
        Project_Country_Patient_Parameter__c proCountryPatParam = [select id,name from Project_Country_Patient_Parameter__c limit 1];
        DosingDetailsWrapper.DosingDetails dosingDet = new DosingDetailsWrapper.DosingDetails();
        DosingDetailsWrapper dosingWrapper = new DosingDetailsWrapper();
        dosingWrapper.dosingDetails.add(dosingDet);
        PARRecordWrapper.Answers ans = new PARRecordWrapper.Answers();
        PARRecordWrapper newWrapper = new PARRecordWrapper();
        newWrapper.patientId = patient.Id;
        newWrapper.dosingDetailsWrapper = dosingWrapper;
        newWrapper.supportingInformations.add(ans);
        newWrapper.step = false;
        newWrapper.prePopulate = true;
        
        test.startTest();
        PARController.getPatientName(projectGroup.id,acc.id,countryIndications.id,productss.id);
        PARController.getParameters(patient.id,projectGroup.id,'Recon');
       // PARController.createPARRecord(JSON.serialize(newWrapper),patient.id);
        PARController.getPatienRequestDetails(req.id);
        test.stopTest();
    }
    
    @isTest
    public static void createPARRecordTest1(){
        Patient__c patient = [select Id, Name, SequenceNumber__c from Patient__c limit 1];
        
        Patient_Request__c req = [select Id, Status__c, PatientId__c from Patient_Request__c limit 1];
        Project_Group__c projectGroup = [select Id, Name from Project_Group__c limit 1];
        List<Project_Country__c> projectCountry = [select Id, Name from Project_Country__c limit 1];
        
        Project_Country_Supporting_Information__c newProjSuppInfo = UtilData.createProjectCountrySupportingInformation(patient.id,
                                                                                                                      projectCountry[0].id);
        newProjSuppInfo.Response_Type__c = 'Date';
        insert newProjSuppInfo;
        
        Patient_Request_Supporting__c patReqSupp = UtilData.createPatientRequestSupporting(patient.Id,newProjSuppInfo.Id,req.Id,projectGroup.Id);
        patReqSupp.Country_Supporting_Info_Requrement__c = newProjSuppInfo.id;
        patReqSupp.Patient_Request_Supporting_Response__c = '2023-05-01';
        insert patReqSupp;
        
        List<Project_Country_Eligibility__c> projCountryElig = UtilData.createProjectCountryEligibilities(projectCountry);
        insert projCountryElig;
        
        Patient_Request_Eligibility__c patReqElig = UtilData.createPatientRequestEligibility(patient.Id,projCountryElig[0].id,
                                                                                            req.Id,projectGroup.Id);
        insert patReqElig;
        
		DosingDetailsWrapper.DosingDetails dosingDet = new DosingDetailsWrapper.DosingDetails();
        DosingDetailsWrapper dosingWrapper = new DosingDetailsWrapper();
        dosingWrapper.dosingDetails.add(dosingDet);
       // PARRecordWrapper.patientParameters prm = new PARRecordWrapper.patientParameters();
            
        PARRecordWrapper.Answers ans = new PARRecordWrapper.Answers();
        PARRecordWrapper newWrapper = new PARRecordWrapper();
       // newWrapper.Id = req.Id;
        newWrapper.patientId = patient.Id;
        newWrapper.step = true;
        newWrapper.prePopulate = false;
        system.debug('req.PatientId__c==>'+req.PatientId__c);
        //newWrapper.patientName = req.PatientId__c;
        newWrapper.dosingDetailsWrapper = dosingWrapper;
        newWrapper.supportingInformations.add(ans); 
        newWrapper.inclusionEligibilities.add(ans);
        newWrapper.answers.add(ans);
        newWrapper.patientParameters.add(ans);
        
        test.startTest();
        PARController.createPARRecord(JSON.serialize(newWrapper),patient.id);
        PARController.savePatientRequestDetails(JSON.serialize(req));
        test.stopTest();
    }
    
    @isTest
    public static void createPARRecordTest2(){
        Patient__c patient = [select Id,name from Patient__c limit 1];
        Patient_Request__c req = [select id,Status__c from Patient_Request__c limit 1];
        req.Stage__c = 'Dispatched';
        update req;
        
        PARRecordWrapper.Answers ans = new PARRecordWrapper.Answers();
        PARRecordWrapper newWrapper = new PARRecordWrapper();
        newWrapper.step = true;
        newWrapper.prePopulate = false;
        newWrapper.answers.add(ans);
        
        test.startTest();
        PARController.createPARRecord(JSON.serialize(newWrapper),patient.id);
        PARController.getPatienRequestDetails(req.id);
        test.stopTest();
    }
}