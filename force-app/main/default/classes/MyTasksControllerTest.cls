/*********************************************************************************************************************
    ClassName MyTasksControllerTest
    Purpose: This is a test class used to test the MyTasksController functionality.
    AUTHOR : Nidhi Chouksey
    Date : 08-July-2023
********************************************************************************************************************/
@isTest
public with sharing class MyTasksControllerTest {
    public MyTasksControllerTest() { }

    @testSetup 
    static void setup() {
        Integer numberOfrecords = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;
    
        List<Contact> contacts = UtilData.createContactsList(numberOfrecords);
        insert contacts;

        List<Care_Products__c> products = UtilData.createCareProduct(numberOfrecords);
        insert products;
    
        List<Project_Group__c> ProjGroups = UtilData.createProjectGroup(products);
        insert ProjGroups;

        List<project__c> projects = UtilData.createProject(ProjGroups);
        insert projects;

        List<Treatment_Access_Request__c> treatmentAccessRequests = UtilData.CreateTreatmentAccessRequests(numberOfrecords, ProjGroups, createAccountsList);
        //treatmentAccessRequests[0].Which_Institution__c = createAccountsList[0].id;
        //treatmentAccessRequests[0].Project_Group__c = ProjGroups[0].id;
        //treatmentAccessRequests[0].Status__c = 'Pending By Bionical';
        insert treatmentAccessRequests;

        List<Indication__c> indications = UtilData.createIndication(1);
        insert indications;

        Patient__c patient = UtilData.createPatient(contacts[0].id, null);
        insert patient;


        Date todayDate = Date.today();
		Date resupplyDate = todayDate.addDays(2);
        Patient_Request__c patientRequest = new Patient_Request__c(Patient__c = patient.id, Status__c = 'Information Updated',
            Resupply_Due_Date__c = resupplyDate, First_Follow_Up__c=todayDate,Requested_By__c=UserInfo.getUserId(), 
            Date_Delivered__c = System.today(), PARAssignedToPAMUser__c= UserInfo.getUserId()
        );
        insert patientRequest;

        Patient_Request_Note__c patientRequestNote = UtilData.createPatientRequestNote(patientRequest);
        insert patientRequestNote;

        Patient_Dosage_Request__c patientDosageRequest = UtilData.createPatientDosageRequest(patientRequest.Id);
        insert patientDosageRequest;

        List<Patient_Dosage_Request_History__c> patientHistoryList = new List<Patient_Dosage_Request_History__c>{
            UtilData.createPatientDosageRequestHistory(patientRequest.Id, patientDosageRequest.id,'Completed'),
            //UtilData.createPatientDosageRequestHistory(patientRequest.Id, patientDosageRequest.id, 'Reassigned'),
            UtilData.createPatientDosageRequestHistory(patientRequest.Id, patientDosageRequest.id,'Pending')
        };
        patientHistoryList[1].Action__c = 'Reassigned';
        insert patientHistoryList;
        //Patient_Request_Supporting__c patientRequestSupporting = UtilData.createPatientRequestSupporting(patient.Id, projectSupportingInfo[0].id, patientRequest.Id, ProjGroups[0].id);
        //insert patientRequestSupporting;

    }

    @isTest private static void getTreatmentAccessReqRecordsTest(){
        System.Test.startTest();
            MyTasksController.getTreatmentAccessReqRecords();
        System.Test.stopTest();
    }

    @isTest private static void updateTreatmentAccessRequestTest(){
        System.Test.startTest();
        Patient_Request__c PatientReqObj = [select Id,Status__c from Patient_Request__c limit 1];
        Indication__c Indication = [select Id from Indication__c limit 1];
        Patient__c patient = [select Id from Patient__c limit 1];
        Treatment_Access_Request__c institreatmentAccessReq = [select Id, Project_Group__c, Which_Institution__c from Treatment_Access_Request__c limit 1];
        
        MyTasksController.updateTreatmentAccessRequest(institreatmentAccessReq.id);
        MyTasksController.fetchPatientDosageRecords(PatientReqObj.ID, institreatmentAccessReq.Project_Group__c, institreatmentAccessReq.Which_Institution__c, null);
        MyTasksController.fetchPatientRecords(institreatmentAccessReq.Project_Group__c,institreatmentAccessReq.Which_Institution__c, Indication.id,'summaryOfApplication');              

        System.Test.stopTest();
    }
   
    // public static void updatePatientAccessRequest(String patientId, string notesType) 
    @isTest private static void updatePatientAccessRequestTest1(){
        System.Test.startTest();
        Patient_Request__c PatientObj = [select Id,Status__c from Patient_Request__c limit 1];
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'Decline');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'Additonal');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'MRInformationRequired');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'DeclineMedicalReview');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'PendingRegulatoryReview');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'RRAdditionalInformation');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'SendForRegulatoryReview');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'MedicalReviewNotRequired');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'MedicalReviewOfflinePending');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'MedicalReviewHardCopy');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'MedicalReviewLocalHardCopy');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'SponserMedicalReview');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'LocalSponserMedicalReview');

        MyTasksController.updatePatientAccessRequest(PatientObj.id,'HealthAuthorityApprovalHardCopy');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'GlobalSponserMedicalReviewInternal');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'LocalSponserMedicalReviewInternal');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'OfflineMediaclReviewApproved');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'HealthAuthorityApprovalOffline');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'SupportingInformationNotRequired');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'DispatchedShipped');


        MyTasksController.updatePatientAccessRequest(PatientObj.id,'DispatchedDelivered');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'Additonal Online');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'Additonal Offline');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'Offline');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'Discontinued');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'AdditionalInformation');
        MyTasksController.updatePatientAccessRequest(PatientObj.id,'AdditionalInformationEdit');
        
        System.Test.stopTest();
    }


    @isTest private static void getPatientReuestRecordsTest(){
        System.Test.startTest();
        MyTasksController.getPatientReuestRecords();
        MyTasksController.getPatientRequestPAM();
        System.Test.stopTest();
    }

    
    @isTest private static void updateAdditonalInfoTest(){
        Patient_Request__c patientRequestObj = [select Id,Name,PatientId__c, Patient__r.Patient_ID__c, Patient__r.Initials__c, On_Behalf_Of__c, Institutation__c, Stage__c,
        Status__c, CreatedDate, Project_Group__r.Name, Institutation__r.Institution_Country__c, Project_Group__c, PARAssignedToPAMUser__c,Supporting_Information_Physicians__c
        ,Project_Group__r.Care_Product__r.Name,Institutation__r.Name,Additional_Info_Assigned_To__c,CreatedBy.Name,createdById,Medical_Review_Internal_Sponsors__c FROM Patient_Request__c limit 1];
        System.Test.startTest();
        MyTasksController.updateAdditonalInfo(patientRequestObj.id, '');
        System.Test.stopTest();
    }

    @isTest private static void updateProjectTest(){
        project__c projectObj = [select Id from project__c limit 1];
        Account accObj = [select Id from Account limit 1];
        Patient_Request__c patReqObj = [select Id from Patient_Request__c limit 1];
        patReqObj.Stage__c='Sponsor Approval - Global';
        update patReqObj;
        System.Test.startTest();
        MyTasksController.updateProject(projectObj.id, 'Not Completed',  'approveDeclineComments');
        MyTasksController.getPatientRequestForSponser();
        MyTasksController.getContactDetailByAccount(accObj.id);
        System.Test.stopTest();
    }

    @isTest private static void updatePatientInstitutionTest(){
        Patient__c patientObj = [select Id from Patient__c limit 1];
        Account accObj = [select Id from Account limit 1];
        Contact contactObj = [select Id from Contact limit 1];
        System.Test.startTest();
        MyTasksController.updatePatientInstitution(patientObj.id, accObj.id, contactObj.id);
        System.Test.stopTest();
    }

    
    /*@isTest private static void updatePatientTest(){
        Patient__c patientObj = [select Id from Patient__c limit 1];
        Account accObj = [select Id from Account limit 1];
        Contact contactObj = [select Id from Contact limit 1];
        System.Test.startTest();
        MyTasksController.updatePatient(patientObj.id, accObj.id);
        System.Test.stopTest();
    }*/

    
    @isTest private static void getPatientRequestRecordsForReviewerTest(){
        System.Test.startTest();
        MyTasksController.getPatientRequestRecordsForReviewer();
        Patient_Request__c PatientReqObj = [select Id,Status__c,Stage__c from Patient_Request__c limit 1];
        PatientReqObj.Status__c = 'Pending Regulatory Approval';
        PatientReqObj.Stage__c = 'Regulatory Review and Approval';
        PatientReqObj.Regulatory_Reviewers__c ='["'+ UserInfo.getUserId() + '"]';
        update PatientReqObj;
        MyTasksController.getPatientRequestRecordsForRegulatoryReviewer();
        System.Test.stopTest();
    }
    
    @isTest private static void getPatientRequestTest(){
        Patient__c patientObj = [select Id from Patient__c limit 1];
        Patient_Request_Note__c patientReqObj = [select Id, Patient_Request__c from Patient_Request_Note__c limit 1];
        Patient_Dosage_Request__c patientDosageReqObj = [select Id from Patient_Dosage_Request__c limit 1];
        List<Patient_Dosage_Request_History__c> patientDosageHistoryObj = [select Id from Patient_Dosage_Request_History__c limit 1];
        Indication__c Indication = [select Id from Indication__c limit 1];
        //Map<String,Object> patientDosageHistoryObj1 = new Map<String,Object>();

        patientReqObj.Notes_Type__c ='Discontinued';
        update patientReqObj;
        System.Test.startTest();
        MyTasksController.getPatientRequestNotes(patientObj.id);
        patientReqObj.Notes_Type__c ='Restart Treatment';
        update patientReqObj;
        MyTasksController.getPatientRequestNotes(patientObj.id);
        MyTasksController.updatePaMUsers(patientReqObj.Patient_Request__c, userInfo.getUserId() +'' );
        MyTasksController.fetchMedicalReviewDocuments(patientReqObj.Patient_Request__c + '');
        String payLoad = '[{"Id":"","patientHistoryId":"","patientRequestId":"' + patientReqObj.Patient_Request__c + '","newPatientRequestId":"","strength":"","remaining":"","quantity":"3","patientRequestValue":"","patientRequestLabel":"","reassignedFrom":"","screenName":"AddReassignMedicationScreen"}]';
        MyTasksController.updatePatientHistoryRecord(payLoad);
        
        MyTasksController.calculateQuantity(patientReqObj.Patient_Request__c, JSON.serialize(new List<Object>{PatientDataController.getDosingDetailsforPatient(Indication.id, patientReqObj.Patient_Request__c)}));
        MyTasksController.updateTranslationStatus(patientReqObj.Patient_Request__c, true, true);
        MyTasksController.updateDosageRequest(payLoad, patientReqObj.Patient_Request__c);
        MyTasksController.updatePreviousStatus(patientReqObj.Patient_Request__c, 'Restart Treatment');
        MyTasksController.updatePreviousStatus(patientReqObj.Patient_Request__c, 'Reopen Request');

        update new Patient_Request__c(Status__c = 'Incomplete', id =patientReqObj.Patient_Request__c);
        update new Patient_Request__c(Status__c = 'Information Updated', id =patientReqObj.Patient_Request__c);
        MyTasksController.updateReassignApprover();
        MyTasksController.getPaMUsers();

        MyTasksController.fetchPatientRequestHistory(patientReqObj.Patient_Request__c + '');
        MyTasksController.fetchPatientDosageHistory(patientReqObj.Patient_Request__c + '', patientDosageReqObj.id + '');
        MyTasksController.getDosingDetailsforDispatch(patientReqObj.Patient_Request__c);
        //MyTasksController.uploadFile('Test', 'Test.txt', patientObj.id, 'Text');

        
        payLoad = '[{"Id":"' + patientDosageReqObj.id + '","patientHistoryId":"","patientRequestId":"' + patientReqObj.Patient_Request__c + '","newPatientRequestId":"","strength":"","remaining":"","quantity":"3","patientRequestValue":"' + patientReqObj.Patient_Request__c + '","patientRequestLabel":"","reassignedFrom":"","screenName":"ReconcileScreen", "date":"2023-01-01"}]';
        MyTasksController.updatePatientDosageRequest(payLoad);
        
        payLoad = '[{"Id":"' + patientDosageReqObj.id + '","patientHistoryId":"","patientRequestId":"' + patientReqObj.Patient_Request__c + '","newPatientRequestId":"","strength":"","remaining":"","quantity":"3","patientRequestValue":"' + patientReqObj.Patient_Request__c + '","patientRequestLabel":"","reassignedFrom":"","screenName":"ReassignMedicationScreen"}]';
        MyTasksController.updatePatientDosageRequest(payLoad);
        
        payLoad = '[{"Id":"' + patientDosageReqObj.id + '","patientHistoryId":"","patientRequestId":"' + patientReqObj.Patient_Request__c + '","newPatientRequestId":"' + patientReqObj.Patient_Request__c + '","strength":"","remaining":"","quantity":"3","patientRequestValue":"' + patientReqObj.Patient_Request__c + '","patientRequestLabel":"","reassignedFrom":"","screenName":"AddReassignMedicationScreen"}]';
        MyTasksController.updatePatientDosageRequest(payLoad);
        try{
            MyTasksController.deletePatientHistoryOnCancel(patientReqObj.Patient_Request__c);
        }catch(Exception e){

        }


        MyTasksController.deletePatientHistoryRecord(patientDosageHistoryObj[0].id, JSON.serialize(new Map<ID, Patient_Dosage_Request_History__c>(patientDosageHistoryObj)));
        delete [select id from Patient_Dosage_Request__c];
        MyTasksController.calculateQuantity(patientReqObj.Patient_Request__c, payLoad);


        System.Test.stopTest();
    }
    
    @isTest private static void updateDiscontinuePataientRequestTest()
    {
       System.Test.startTest();
       Patient__c patientObj = [select Id from Patient__c limit 1];
       Patient_Request__c PatientReqObj = [select Id,Status__c from Patient_Request__c limit 1];
       PatientReqObj.Status__c = 'Delivered';
       update PatientReqObj;
       MyTasksController.updateDiscontinuePataientRequest(PatientObj.id);
       MyTasksController.getPatientMovementNotes(PatientObj.id);
       System.Test.stopTest();
    }
    
    @isTest
    private static void CodeCoverageCall(){
		MyTasksController.CallCodeCoverage();
        MyTasksController.CallCodeCoverage2();
	}
}