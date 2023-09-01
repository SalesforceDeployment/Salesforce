/*********************************************************************************************************************
    ClassName DynamicQuestionsControllerTest
    Purpose: This is a test class used to test the DynamicQuestionsController functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class DynamicQuestionsControllerTest {
    public DynamicQuestionsControllerTest() {}

    @testSetup 
    static void setup() {
        Integer numberOfrecords = 1;

        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;

        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

        List<Institution_Additional_Address__c> institutionAdditionalAddressList =  UtilData.createInstitutionAddress(createAccountsList);
        insert institutionAdditionalAddressList;

        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
        
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;
        
        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;

        List<Indication__c> indications = UtilData.createIndications(projects);
        insert indications; 
        
        List<Project_Country__c> projCountries = UtilData.createProjectCountry(projects);
        insert projCountries;

        List<Project_Country_Indication__c > projectIndicationCountries = UtilData.createProjectCountryIndications(indications,projCountries);
        insert projectIndicationCountries;
        
        List<Project_Country_Regulatory_Consent__c> ProjectCountryRegulatoryConsentList = UtilData.createProjectCountryRegulatoryConsent(projCountries);
        insert ProjectCountryRegulatoryConsentList;

        List<Project_Country_Patient_Parameter__c> projCountryPatientParameterList = UtilData.createProjectCountryPatientParameter(projCountries);
        projCountryPatientParameterList[0].First__c = true;
        insert projCountryPatientParameterList;

        List<Project_Country_Supporting_Information__c> projectSupportingInfo = UtilData.createProjSuppInfo(projCountries);
        projectSupportingInfo[0].First__c = true;
        insert projectSupportingInfo;

        List<Project_Country_Eligibility__c> projectCountryEligibilityList = UtilData.createProjectCountryEligibilities(projCountries);
        insert projectCountryEligibilityList;

        Patient__c patient = UtilData.createPatient(contacts[0].id);
        insert patient;

        Patient_Request__c patientRequest = UtilData.createPatientRequest();
        insert patientRequest;

        Patient_Request_Note__c patientRequestNote = UtilData.createPatientRequestNote(patientRequest);
        insert patientRequestNote;

        Patient_Request_Supporting__c patientRequestSupporting = UtilData.createPatientRequestSupporting(patient.Id, projectSupportingInfo[0].id, patientRequest.Id, ProjGroups[0].id);
        insert patientRequestSupporting;
        
        Patient_Dosage_Request__c patientDosageRequest = UtilData.createPatientDosageRequest(patientRequest.Id);
        insert patientDosageRequest;
        
        Patient_Request_Parameters__c PatientRequestParameters = UtilData.createPatientRequestParameters(patient.Id, projCountryPatientParameterList[0].id, patientRequest.Id, ProjGroups[0].id);
        insert PatientRequestParameters;
         
        Patient_Request_Eligibility__c PatientRequestEligibility = UtilData.createPatientRequestEligibility(patient.Id, projectCountryEligibilityList[0].id, patientRequest.Id, ProjGroups[0].id);
        insert PatientRequestEligibility;
        
        Project_Country_Eligibility_Display_Rule__c ProjectCountryEligibilityDisplayRule = UtilData.createProjectCountryEligibilityDisplayRule(projectCountryEligibilityList[0].id, projectCountryEligibilityList[0].id);
        insert ProjectCountryEligibilityDisplayRule;

        Project_Country_Supporting_Information__c ProjectCountrySupportingInformation = UtilData.createProjectCountrySupportingInformation(projects[0].id, projCountries[0].id);
        insert ProjectCountrySupportingInformation;

        Proj_Country_Patient_Para_Display_Rule__c ProjectCountryIndicationDosing = UtilData.createProjectCountryIndicationDosing(projCountryPatientParameterList[0].id, projCountryPatientParameterList[0].id);
        insert ProjectCountryIndicationDosing;

        List<Project_Country_Eligibility__c> projCountryEligiList = UtilData.createProjectCountryEligibilities(projCountries);
        projCountryEligiList[0].Response_Type__c ='MultiSelect';
        projCountryEligiList[0].First__c = true;
        insert projCountryEligiList;    
    }

    @isTest private static void getPatientParametersTest(){
        Project_Country_Indication__c prjCountryIndiObj = [select Id FROM Project_Country_Indication__c limit 1];
        Project_Country_Eligibility__c prjCountryEligility = [select Id,Response_Type__c,Project_Country__r.Project__c,Project_Country__r.Country__c, First__c FROM Project_Country_Eligibility__c limit 1];
        prjCountryEligility.First__c = true;
        update prjCountryEligility;
        system.debug('@@@ prjCountryEligility :: ' + prjCountryEligility);
        System.Test.startTest();
            DynamicQuestionsController.getPatientParameters(prjCountryIndiObj.id, 'Project_Country_Eligibility__c', '', '',true);
            DynamicQuestionsController.getDisplayRuleQuestions(prjCountryIndiObj.id, 'Project_Country_Eligibility__c', '', '', true);
            DynamicQuestionsController.getDisplayRuleQuestions(prjCountryIndiObj.id, 'Project_Country_Patient_Parameter__c', '', '', true);
            DynamicQuestionsController.getDisplayRuleQuestions(prjCountryIndiObj.id, 'Project_Country_Supporting_Information__c', '', '', true);
        System.Test.stopTest();
    }

}