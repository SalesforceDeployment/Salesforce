@isTest
public class UtilDataTest {
    @isTest
    static void UtilDataTestMethod(){
        Integer numberOfrecords = 2;
        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        List<project__c> projects = UtilData.createProject(ProjGroups);
        List<Indication__c> indications = UtilData.createIndication(numberOfrecords);
        List<Project_Patient_Parameter__c> projectPatientParameters = UtilData.createProjectPatientParameter(projects);
        List<Project_Indication__c> projectIndications = UtilData.createProjectIndication(projects,indications,numberOfrecords);
        List<Project_Organization_Member__c> projectOrganizationMembers = UtilData.createProjectOrganizationMember(projects);
        List<Project_Regulatory_Consent__c > projectRegulatorConsents = UtilData.createProjectRegulatorConsent(projects);
        List<Project_Country__c > projectCountries = UtilData.createProjectCountry(projects);
        List<Project_Eligibility__c > projectEligibilities = UtilData.createProjectEligibility(projects);
        List<Project_Supporting_Information__c > projectSuportingInformation = UtilData.createProjectSuportingInformation(projects);
        List<Care_Products__c> careProducts = UtilData.createCareProducts(numberOfrecords);
        List<Project_Group__c> projectGroups = UtilData.createProjectGroups(products);
        List<project__c> createProjects = UtilData.createProjects(projectGroups);
        List<Indication__c> createIndications = UtilData.createIndications(projects);
        List<Project_Indication__c> createProjectIndications = UtilData.createProjectIndications(projects,indications);
        List<Project_Country__c> createProjectCountries = UtilData.createProjectCountries(projects);
        List<Project_Country_Eligibility__c > projectCountryEligibilities = UtilData.createProjectCountryEligibilities(createProjectCountries);
        List<Dosing_Detail__c > dosingDetails = UtilData.createDosingDetails(indications);
        List<Project_Eligibility__c> projectEligiblityList = UtilData.createProjectEligiblityList(projects);
        List<Project_Country_Indication__c> projectCountryIndications = UtilData.createProjectCountryIndications(indications, createProjectCountries);
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        List<Contact> createContactsList = UtilData.createContactsList(numberOfrecords);
        List<Institution_Treatment__c> institutionTreatments = UtilData.createInstitutionTreatmentList(createAccountsList,projectGroups);
        List<Institution_Treatment_Indication__c> institutionTreatmentIndicationList = UtilData.createInstitutionTreatmentIndicationList(institutionTreatments,indications);
        List<Project_Group__c> projectGroupsTreatmentLookup = UtilData.createProjectGroupsTreatmentLookup(products);
        List<Treatment_Access_Request__c> treatmentAccessRequests = UtilData.CreateTreatmentAccessRequests(numberOfrecords, projectGroups, createAccountsList);
        List<project__c> liveProjects = UtilData.createLiveProjects(projectGroups);
        
    }
}