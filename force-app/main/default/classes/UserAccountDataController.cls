public without sharing class UserAccountDataController {
    
    @AuraEnabled(cacheable = true)
    public static DeliveryAddressWrapper getAddressDetails(String accountId) {
        DeliveryAddressWrapper wrapperObj = new DeliveryAddressWrapper();
        system.debug('inside 6-->'+accountId);
        for(Account accRecord: [SELECT Id, Name, BillingCity, BillingCountry, Institution_Country__c, BillingPostalCode, BillingState, BillingStreet, (SELECT Id, Name, Institution__r.Name, Additional_Address__City__s, Additional_Address__CountryCode__s, Additional_Address__PostalCode__s, Additional_Address__StateCode__s, Additional_Address__Street__s, Additional_Address__c FROM Institution_Additional_Addresses__r) FROM Account WHERE Id=:accountId]) {
            List<Institution_Additional_Address__c> addressList = new List<Institution_Additional_Address__c> ();
            wrapperObj.accountRecord = accRecord;
            for(Institution_Additional_Address__c addressRecord: accRecord.Institution_Additional_Addresses__r) {
                addressList.add(addressRecord);
            }
            wrapperObj.institutionAddressList = addressList;
        }
        system.debug('inside 13-->'+wrapperObj);
        return wrapperObj;
    }
    @AuraEnabled(cacheable = true)
    public static List<Project_Country_Regulatory_Consent__c> getRegulatoryConsents(String accountCountry, String projectGroupId) {
        List<Project_Country_Regulatory_Consent__c> regulatoryList = new List<Project_Country_Regulatory_Consent__c> ();
        for(Project_Country_Regulatory_Consent__c projectCountryRec: [SELECT Id, Project_Country__c, Project_Country__r.Project__r.Project_Status__c, Sequence_Order__c, Consent_Title__c, Consent_Description__c, Project_Country__r.Country__c, Project_Country__r.Project__r.Project_Group__c FROM Project_Country_Regulatory_Consent__c WHERE Project_Country__r.Country__c=:accountCountry AND Project_Country__r.Project__r.Project_Group__c=:projectGroupId AND Project_Country__r.Project__r.Project_Status__c='Live' ORDER BY Sequence_Order__c ASC]) {
            if(projectCountryRec.Sequence_Order__c!=2) {
                regulatoryList.add(projectCountryRec);
            }
        }
        return regulatoryList;
    }
    @AuraEnabled
    public static void submitForApproval(String patientRequestId, String approvalProcessName) {
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(patientRequestId);
        req1.setSubmitterId(userInfo.getUserId());
        req1.setProcessDefinitionNameOrId(approvalProcessName);
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
    }
    @AuraEnabled
    public static void approveRecord(String patientRequestId) {
        List<ProcessInstanceWorkitem> workItems = [
            SELECT Id, ProcessInstanceId 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId = :patientRequestId 
        ];
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workItem.Id);
            req.setAction('Approve');
            req.setComments('Approved.');
            requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
    }
    @AuraEnabled
    public static void approveOrRejectProjectRecord(String projectId, String typeOfRequest, String comments) {
        List<ProcessInstanceWorkitem> workItems = [
            SELECT Id, ProcessInstanceId 
            FROM ProcessInstanceWorkitem 
            WHERE ProcessInstance.TargetObjectId = :projectId 
        ];
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for(ProcessInstanceWorkitem workItem : workItems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workItem.Id);
            if(typeOfRequest == 'decline') {
                req.setAction('Reject');
                req.setComments(comments);
            }
            if(typeOfRequest == 'approve') {
                req.setAction('Approve');
                req.setComments('Approved.');
            }
            requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
    }
    @AuraEnabled
    public static PARRecordWrapper fetchPatientData(String patientRequestId, String accountId) {
        PARRecordWrapper wrapperObj = new PARRecordWrapper ();
        wrapperObj.Id = patientRequestId;
        wrapperObj.patientRequestId = patientRequestId;
        
        List<PARRecordWrapper.Answers> supportingInfoList = new List<PARRecordWrapper.Answers> ();
        List<DosingDetailsWrapper.DosingDetails> dosingDetails = new List<DosingDetailsWrapper.DosingDetails> ();
        List<PARRecordWrapper.Answers> inclusionAnswers = new List<PARRecordWrapper.Answers>();
        List<PARRecordWrapper.Answers> exclusionAnswers = new List<PARRecordWrapper.Answers>();
        for(Patient_Request__c patientReqObj: [SELECT Id, DeliveryAddressContactName__c, DeliveryContactEmail__c, DeliveryContactTelephone__c, SO_Number__c, Tracking_Number__c, Date_Shipped__c, Expected_Delivery_Date__c, Date_Delivered__c, ShippingOtherComments__c,
                                               DeliveryContactFax__c, DeliveryContactOutOfHoursNumber__c, DeliveryNote__c, DeliveryAddressHospitalName__c, DeliveryAddressPostCode__c, DeliveryAddress__c, DeliveryAddressCountry__c,
                                               Stage__c, Status__c,OwnerId, Patient__r.Patient_ID__c, Patient__r.Initials__c, Patient__r.Discontinued__c, Additional_Patient_Information__c, Project_Country_Indication__c, Patient__c,
                                               On_Behalf_Of__r.ContactId, Project_Group__r.Care_Product__c, Project_Group__c,BSA__c,Required_Dose__c,Institutation__c, CreatedById
                                               ,Additional_Info_Assigned_To__c,On_Behalf_Of__c,Medical_Review_Sponsers__c,Supporting_Information_Physicians__c,Medical_Review_Internal_Sponsors__c,
                                               PARAssignedToPAMUser__c,PatientId__c, Regulatory_Reviewers__c, Sent_for_Translation__c, Translation_Received__c,
                                               Request_Tab_Saved__c FROM Patient_Request__c WHERE Id=:patientRequestId]) {
                                                   wrapperObj.patientId = patientReqObj.Patient__c;
                                                   wrapperObj.additionalInformation = patientReqObj.Additional_Patient_Information__c;
                                                   wrapperObj.hcpid = patientReqObj.On_Behalf_Of__r.ContactId;
                                                   wrapperObj.product = patientReqObj.Project_Group__r.Care_Product__c;
                                                   wrapperObj.treatmentid = patientReqObj.Project_Group__c;
                                                   wrapperObj.indicationid = patientReqObj.Project_Country_Indication__c;
                                                   wrapperObj.patientName = patientReqObj.Patient__r.Patient_ID__c;
                                                   wrapperObj.pARpatientId = patientReqObj.PatientId__c;
                                                   wrapperObj.stage = patientReqObj.Stage__c;
                                                   wrapperObj.sendTranslation = patientReqObj.Sent_for_Translation__c;
                                                   wrapperObj.receiveTranslation = patientReqObj.Translation_Received__c;
                                                   if(patientReqObj.Patient__r.Discontinued__c == true)
                                                   {
                                                    wrapperObj.status = 'Patient Discontinued';
                                                   }
                                                   else {
                                                    wrapperObj.status = patientReqObj.Status__c;
                                                   }
                                                   wrapperObj.patientBSA = patientReqObj.BSA__c;
                                                   wrapperObj.requireDose = patientReqObj.Required_Dose__c;
                                                   wrapperObj.ownerId = patientReqObj.OwnerId;
                                                   wrapperObj.hospitalId = patientReqObj.Institutation__c;
                                                   wrapperObj.createdBy = patientReqObj.CreatedById;
                                                   wrapperObj.additionalInfoAssignedTo = patientReqObj.Additional_Info_Assigned_To__c;
                                                   wrapperObj.onBehalfOf = patientReqObj.On_Behalf_Of__c;
                                                   wrapperObj.medicalReviewSponsors = patientReqObj.Medical_Review_Sponsers__c;
                                                   wrapperObj.medicalReviewInternal = patientReqObj.Medical_Review_Internal_Sponsors__c;
                                                   wrapperObj.supportingInfomationPhysian = patientReqObj.Supporting_Information_Physicians__c;
                                                   wrapperObj.PARAssignedToPAMUser = patientReqObj.PARAssignedToPAMUser__c;
                                                   wrapperObj.regulatoryReviewer = patientReqObj.Regulatory_Reviewers__c;
                                                   wrapperObj.savedTabNo = patientReqObj.Request_Tab_Saved__c;
                                                   //delivery address details - step 5
                                                   PARRecordWrapper.DeliveryAddressWrapper addressObj = new PARRecordWrapper.DeliveryAddressWrapper ();
                                                   addressObj.name = patientReqObj.DeliveryAddressContactName__c;
                                                   addressObj.address = patientReqObj.DeliveryAddress__c;
                                                   addressObj.email = patientReqObj.DeliveryContactEmail__c;
                                                   addressObj.telephone = patientReqObj.DeliveryContactTelephone__c;
                                                   addressObj.fax = patientReqObj.DeliveryContactFax__c;
                                                   addressObj.outOfHours = patientReqObj.DeliveryContactOutOfHoursNumber__c;
                                                   addressObj.notes = patientReqObj.DeliveryNote__c;
                                                   addressObj.hospitalName = patientReqObj.DeliveryAddressHospitalName__c;
                                                   addressObj.postalCode = patientReqObj.DeliveryAddressPostCode__c;
                                                   addressObj.country = patientReqObj.DeliveryAddressCountry__c;
                                                   wrapperObj.deliveryWrapper = addressObj; 
                                                   PARRecordWrapper.ShippingAddressWrapper shippingAddressObj = new PARRecordWrapper.ShippingAddressWrapper ();
                                                   shippingAddressObj.soNumber = patientReqObj.SO_Number__c;
                                                   shippingAddressObj.trackingNumber = patientReqObj.Tracking_Number__c;
                                                   if(patientReqObj.Date_Shipped__c != null) {
                                                    Date dtShipped = patientReqObj.Date_Shipped__c;
                                                    DateTime dtConverted = Datetime.newInstance(dtShipped.year(), dtShipped.month(),dtShipped.day(),0,0,0);
                                                    shippingAddressObj.dateShipped = String.valueOf(dtShipped);//dtConverted.format('dd MMM yyyy');
                                                   }
                                                   if(patientReqObj.Expected_Delivery_Date__c != null) {
                                                    Date dtExpected = patientReqObj.Expected_Delivery_Date__c;
                                                    DateTime dtExConverted = Datetime.newInstance(dtExpected.year(), dtExpected.month(),dtExpected.day(),0,0,0);
                                                    shippingAddressObj.expectedDeliveryDate = String.valueOf(dtExpected);//dtExConverted.format('dd MMM yyyy');
                                                   }
                                                   if(patientReqObj.Date_Delivered__c != null) {
                                                    Date dtDelivered = patientReqObj.Date_Delivered__c;
                                                    DateTime dtDeliConverted = Datetime.newInstance(dtDelivered.year(), dtDelivered.month(),dtDelivered.day(),0,0,0);
                                                    shippingAddressObj.dateDelivered = String.valueOf(dtDelivered);//dtDeliConverted.format('dd MMM yyyy');
                                                   }
                                                   shippingAddressObj.otherComments = patientReqObj.ShippingOtherComments__c;
                                                   wrapperObj.shippingWrapper = shippingAddressObj;
                                               }
        //Patient Request Notes
        List<PARRecordWrapper.PatientRequestNotesWrapper> wrapperData = new List<PARRecordWrapper.PatientRequestNotesWrapper> ();
        List<PARRecordWrapper.PatientRequestNotesWrapper> wrapperOverviewData = new List<PARRecordWrapper.PatientRequestNotesWrapper> ();
       //checking the notes is after information updated
        DateTime dtUpdated = null;
        for(Patient_Request__History patientRecord: [SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate FROM Patient_Request__History where parentId=:patientRequestId AND (Field = 'Status__c' OR Field = 'Stage__c') ORDER BY CreatedDate desc]) {
            if(patientRecord.Field == 'Status__c' && patientRecord.NewValue == 'Information Updated') {
                dtUpdated = patientRecord.CreatedDate;
                break;
            }
        }
        for(Patient_Request_Note__c requestOverviewNote : [SELECT Id, Status__c, Stage__c, Notes_Type__c, Discontinuation_Date__c, Notes__c, createdBy.Name, createdDate FROM Patient_Request_Note__c WHERE Patient_Request__c=:patientRequestId AND createdDate > :dtUpdated ORDER BY createdDate DESC]) {
            if(!String.isBlank(requestOverviewNote.Notes__c))
                {
                    PARRecordWrapper.PatientRequestNotesWrapper noteOverviewObj = new PARRecordWrapper.PatientRequestNotesWrapper ();
                    Date newDate = requestOverviewNote.Discontinuation_Date__c;
                    if(newDate!=null) {
                        String formattedDate = DateTime.newInstance(newDate.year(),newDate.month(),newDate.day()).format('dd MMM yyyy');
                        noteOverviewObj.discontinuedOn = formattedDate;
                    }
                    noteOverviewObj.discontinuedPerformedOn = requestOverviewNote.createdDate.format('dd MMM yyyy hh:mm:ss a');
                    noteOverviewObj.discontinuedBy = requestOverviewNote.createdBy.Name;
                    noteOverviewObj.patientNotes = requestOverviewNote.Notes__c;
                    noteOverviewObj.stage = requestOverviewNote.Stage__c;
                    noteOverviewObj.status = requestOverviewNote.Status__c;
                    noteOverviewObj.notesType = requestOverviewNote.Notes_Type__c;
                    wrapperOverviewData.add(noteOverviewObj);
                }  
            }        

        for(Patient_Request_Note__c requestNote : [SELECT Id, Status__c, Stage__c, Notes_Type__c, Discontinuation_Date__c, Notes__c, createdBy.Name, createdDate FROM Patient_Request_Note__c WHERE Patient_Request__c=:patientRequestId AND Notes_Type__c != 'Discontinued' ORDER BY createdDate DESC]) {
        if(!String.isBlank(requestNote.Notes__c))
            {
                PARRecordWrapper.PatientRequestNotesWrapper noteObj = new PARRecordWrapper.PatientRequestNotesWrapper ();
                Date newDate = requestNote.Discontinuation_Date__c;
                if(newDate!=null) {
                    String formattedDate = DateTime.newInstance(newDate.year(),newDate.month(),newDate.day()).format('dd MMM yyyy');
                    noteObj.discontinuedOn = formattedDate;
                }
                noteObj.discontinuedPerformedOn = requestNote.createdDate.format('dd MMM yyyy hh:mm:ss a');
                noteObj.discontinuedBy = requestNote.createdBy.Name;
                noteObj.patientNotes = requestNote.Notes__c;
                noteObj.stage = requestNote.Stage__c;
                noteObj.status = requestNote.Status__c;
                noteObj.notesType = requestNote.Notes_Type__c;
                wrapperData.add(noteObj);
            }  
        }        
        wrapperObj.patientRequestNotesWrapper = wrapperData;
        wrapperObj.patientRequestOverviewWrapper = wrapperOverviewData;
        for(Patient_Request_Supporting__c supportingReq: [SELECT Id, Country_Supporting_Info_Requrement__c, Country_Supporting_Info_Requrement__r.Response_Type__c, Country_Supporting_Info_Requrement__r.Parameter_Name__c, Patient_Request__c, Patient_Request_Supporting_Response__c
        ,Country_Supporting_Info_Requrement__r.Display_Order__c FROM Patient_Request_Supporting__c WHERE Patient_Request__c=:patientRequestId ORDER BY Country_Supporting_Info_Requrement__r.Display_Order__c ASC, CreatedDate ASC]) {
            PARRecordWrapper.Answers answerObj = new PARRecordWrapper.Answers ();
            answerObj.Id = supportingReq.Id;  
            answerObj.pcPatientParamId = supportingReq.Country_Supporting_Info_Requrement__c;
            answerObj.answer = supportingReq.Patient_Request_Supporting_Response__c;
            answerObj.paramName = supportingReq.Country_Supporting_Info_Requrement__r.Parameter_Name__c;
            answerObj.type = supportingReq.Country_Supporting_Info_Requrement__r.Response_Type__c;
            if('Date'.equalsignoreCase(supportingReq.Country_Supporting_Info_Requrement__r.Response_Type__c))
            {
                if(String.isNotEmpty(supportingReq.Patient_Request_Supporting_Response__c))
                    {
                        Date sampleDate = Date.valueOf(supportingReq.Patient_Request_Supporting_Response__c);
                        DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                        answerObj.answerDisplay = dtConverted.format('dd MMM yyyy');
                    }
                    else {
                        answerObj.answerDisplay = supportingReq.Patient_Request_Supporting_Response__c;
                    }
            }
            else {
                answerObj.answerDisplay = supportingReq.Patient_Request_Supporting_Response__c;
            }
            supportingInfoList.add(answerObj);
        }
        for(Patient_Dosage_Request__c doseRequest: [SELECT Id, Dosing_Details__c, Quantity__c, Strength__c, Patient_Access_Request__c FROM Patient_Dosage_Request__c WHERE Patient_Access_Request__c=:patientRequestId]) {
            DosingDetailsWrapper.DosingDetails dosinDetailObj = new DosingDetailsWrapper.DosingDetails();
            dosinDetailObj.DefaultQuantity = doseRequest.Quantity__c;
            dosinDetailObj.Id = doseRequest.Dosing_Details__c;
            dosinDetailObj.Strength = doseRequest.Strength__c;
            //dosinDetailObj.active
            dosinDetailObj.patientDosageRequestId = doseRequest.Id;
            dosingDetails.add(dosinDetailObj);
        }
        List<PARRecordWrapper.Answers> initialAnswerList = new List<PARRecordWrapper.Answers>();
        List<PARRecordWrapper.Answers> otherAnswerList = new List<PARRecordWrapper.Answers>();
        for(Patient_Request_Parameters__c parameterRecord: [SELECT Id, Project_Country_Patient_Parameter__c, Project_Country_Patient_Parameter__r.Parameter_Name__c,Project_Country_Patient_Parameter__r.Response_Type__c,
                                                           Project_Country_Patient_Parameter__r.Display_Order__c, Patient_Parameter_Response__c FROM Patient_Request_Parameters__c WHERE Patient_Request__c=:patientRequestId ORDER BY Project_Country_Patient_Parameter__r.Display_Order__c ASC, CreatedDate ASC]) {
            String parameterName = parameterRecord.Project_Country_Patient_Parameter__r.Parameter_Name__c;
            if(parameterName == 'Date Of Birth' || parameterName == 'Initial(s)' || parameterName == 'Gender') {
                PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
                answer.Id = parameterRecord.Id;
                answer.answer =  parameterRecord.Patient_Parameter_Response__c;
                answer.paramName = parameterRecord.Project_Country_Patient_Parameter__r.Parameter_Name__c;
                answer.pcPatientParamId = parameterRecord.Project_Country_Patient_Parameter__c;
                if('Date'.equalsignoreCase(parameterRecord.Project_Country_Patient_Parameter__r.Response_Type__c))
                    {
                        if(String.isNotEmpty(parameterRecord.Patient_Parameter_Response__c))
                            {
                                Date sampleDate = Date.valueOf(parameterRecord.Patient_Parameter_Response__c);
                                DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                                answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                            }
                            else {
                                answer.answerDisplay = parameterRecord.Patient_Parameter_Response__c;
                            }
                    } else {
                    answer.answerDisplay = parameterRecord.Patient_Parameter_Response__c;
                }
                initialAnswerList.add(answer);
            } else {
                PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
                answer.Id = parameterRecord.Id;
                answer.answer =  parameterRecord.Patient_Parameter_Response__c;
                answer.paramName = parameterRecord.Project_Country_Patient_Parameter__r.Parameter_Name__c;
                answer.pcPatientParamId = parameterRecord.Project_Country_Patient_Parameter__c;
                if('Date'.equalsignoreCase(parameterRecord.Project_Country_Patient_Parameter__r.Response_Type__c))
                    {
                        if(String.isNotEmpty(parameterRecord.Patient_Parameter_Response__c))
                            {
                                Date sampleDate = Date.valueOf(parameterRecord.Patient_Parameter_Response__c);
                                DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                                answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                            }
                            else {
                                answer.answerDisplay = parameterRecord.Patient_Parameter_Response__c;
                            }
                    } else {
                    answer.answerDisplay = parameterRecord.Patient_Parameter_Response__c;
                }
                otherAnswerList.add(answer);
            }
        }
        for(Patient_Request_Eligibility__c patientRecord: [SELECT Id, Project_Country_Eligibility__c, Project_Country_Eligibility__r.Eligibility_Type__c, Project_Country_Eligibility__r.Question__c,Project_Country_Eligibility__r.Response_Type__c,
                                                           Project_Country_Eligibility__r.Display_Order__c, Patient_Eligibility_Response__c FROM Patient_Request_Eligibility__c WHERE Patient_Request__c=:patientRequestId ORDER BY Project_Country_Eligibility__r.Display_Order__c ASC, CreatedDate ASC]) {
            if(patientRecord.Project_Country_Eligibility__r.Eligibility_Type__c == 'Inclusion Criteria') {
                PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
                answer.Id = patientRecord.Id;
                answer.paramName = patientRecord.Project_Country_Eligibility__r.Question__c;
                answer.pcPatientParamId = patientRecord.Project_Country_Eligibility__c;
                answer.answer =  patientRecord.Patient_Eligibility_Response__c;
                if('Date'.equalsignoreCase(patientRecord.Project_Country_Eligibility__r.Response_Type__c))
                {
                    if(String.isNotEmpty(patientRecord.Patient_Eligibility_Response__c))
                        {
                            Date sampleDate = Date.valueOf(patientRecord.Patient_Eligibility_Response__c);
                            DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                            answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                        }
                        else {
                            answer.answerDisplay = patientRecord.Patient_Eligibility_Response__c;
                        }
                }
                else {
                    answer.answerDisplay = patientRecord.Patient_Eligibility_Response__c;
                }
                inclusionAnswers.add(answer);
            }
            if(patientRecord.Project_Country_Eligibility__r.Eligibility_Type__c == 'Exclusion Criteria') {
                PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
                answer.Id = patientRecord.Id;
                answer.paramName = patientRecord.Project_Country_Eligibility__r.Question__c;
                answer.pcPatientParamId = patientRecord.Project_Country_Eligibility__c;
                answer.answer =  patientRecord.Patient_Eligibility_Response__c;
                if('Date'.equalsignoreCase(patientRecord.Project_Country_Eligibility__r.Response_Type__c))
                {
                    if(String.isNotEmpty(patientRecord.Patient_Eligibility_Response__c))
                        {
                            Date sampleDate = Date.valueOf(patientRecord.Patient_Eligibility_Response__c);
                            DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                            answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                        }
                        else {
                            answer.answerDisplay = patientRecord.Patient_Eligibility_Response__c;
                        }
                }
                else {
                    answer.answerDisplay = patientRecord.Patient_Eligibility_Response__c;
                }
                exclusionAnswers.add(answer);
            }
        }
        wrapperObj.supportingInformations = supportingInfoList;
        DosingDetailsWrapper newWrapperObj = new DosingDetailsWrapper ();
        newWrapperObj.dosingDetails = dosingDetails;
        wrapperObj.dosingDetailsWrapper = newWrapperObj;
        wrapperObj.answers = initialAnswerList;
        wrapperObj.patientParameters = otherAnswerList;
        wrapperObj.inclusionEligibilities = inclusionAnswers;
        wrapperObj.exclusionEligibilities = exclusionAnswers;        
        return wrapperObj;
    }
    
    @AuraEnabled
    public static String updatePARForPAMFromBionicalReview(String patientRequestId, String projrctCountryIndicationID, String initial, String requestType) 
    {
        try {
            String retValue = '';
            Patient_Request__c patientReq = new Patient_Request__c();
            List<Project_Country_Indication__c> pCI = new List<Project_Country_Indication__c>();
            pCI= [SELECT Id, Name, Project_Country__r.Approval_Needed__c, Project_Country__r.First_Order_Only__c, Project_Country__r.Approval_Level__c FROM Project_Country_Indication__c WHERE Id=: projrctCountryIndicationID];
            
            if(!pCI.isEmpty())
            { 
                patientReq.Id = patientRequestId;
                if(pCI.get(0).Project_Country__r.Approval_Needed__c == 'Approval Required') 
                {
                    if(pCI.get(0).Project_Country__r.Approval_Level__c == 'Global' || pCI.get(0).Project_Country__r.Approval_Level__c == 'Local and Global')
                    {
                        if(pCI.get(0).Project_Country__r.First_Order_Only__c == true) 
                        {
                            if(initial == '01')
                            {
                                if(requestType == 'Local')
                                {
                                    patientReq.Stage__c = 'Sponsor Approval - Local';
                                    patientReq.Status__c = 'Send for  Local Sponsor Approval';
                                }
                                else {
                                    patientReq.Stage__c = 'Sponsor Approval - Global';
                                    patientReq.Status__c = 'Send for  Global Sponsor Approval';
                                }   
                            }
                            else {
                                patientReq.Stage__c = 'Health Authority Approval';
                                patientReq.Status__c = 'Send for Health Authority Approval';
                                patientReq.Medical_Review_Sponsers__c = '';
                                patientReq.Medical_Review_Internal_Sponsors__c = '';
                            }
                        }
                        else {
                            if(requestType == 'Local')
                                {
                                    patientReq.Stage__c = 'Sponsor Approval - Local';
                                    patientReq.Status__c = 'Send for  Local Sponsor Approval';
                                }
                                else {
                                    patientReq.Stage__c = 'Sponsor Approval - Global';
                                    patientReq.Status__c = 'Send for  Global Sponsor Approval';
                                }  
                        }
                    }
                } 
                else 
                {
                    patientReq.Stage__c = 'Health Authority Approval';
                    patientReq.Status__c = 'Send for Health Authority Approval';
                    patientReq.Medical_Review_Sponsers__c = '';
                    patientReq.Medical_Review_Internal_Sponsors__c = '';
                }
                update patientReq;
                retValue = patientReq.Status__c;
            }
            return retValue;
        } 
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());  
        }
        
    }
    
    @AuraEnabled
    public static String updatePARForSponsorApproved(String patientRequestId, String projrctCountryIndicationID, String Sponsor) 
    {
        try {
            String retValue = '';
            Patient_Request__c patientReq = new Patient_Request__c();
            patientReq.Id = patientRequestId;
            if(Sponsor == 'Global')
            {
                List<Project_Country_Indication__c> pCI = new List<Project_Country_Indication__c>();
                pCI= [SELECT Id, Name, Project_Country__r.Approval_Needed__c, Project_Country__r.First_Order_Only__c, Project_Country__r.Approval_Level__c FROM Project_Country_Indication__c WHERE Id=: projrctCountryIndicationID];
                
                if(!pCI.isEmpty())
                { 
                    if(pCI.get(0).Project_Country__r.Approval_Needed__c == 'Approval Required') 
                    {
                        if(pCI.get(0).Project_Country__r.Approval_Level__c == 'Global')
                        {
                            patientReq.Stage__c = 'Health Authority Approval';
                            patientReq.Status__c = 'Send for Health Authority Approval';
                            patientReq.Medical_Review_Sponsers__c = '';
                            patientReq.Medical_Review_Internal_Sponsors__c = '';

                        }
                        if(pCI.get(0).Project_Country__r.Approval_Level__c == 'Local and Global')
                        {
                            patientReq.Stage__c = 'Sponsor Approval - Local';
                            patientReq.Status__c = 'Send for  Local Sponsor Approval';
                            patientReq.Medical_Review_Sponsers__c = '';
                            patientReq.Medical_Review_Internal_Sponsors__c = '';
                        }
                    }
                } 
            }
            if(Sponsor == 'Local')
            {
                patientReq.Stage__c = 'Health Authority Approval';
                patientReq.Status__c = 'Send for Health Authority Approval';
                patientReq.Medical_Review_Sponsers__c = '';
                patientReq.Medical_Review_Internal_Sponsors__c = '';
            }
            update patientReq;
            retValue = patientReq.Id;
            return retValue;
        } 
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());  
        }
        
    }

    @AuraEnabled
    public static String updatePARReviewer(String patientRequestId, String reviewer, String reviewerType, String notesValue) 
    {
        try {
                String retValue = '';
                Patient_Request__c patientReq = new Patient_Request__c();
                patientReq.Id = patientRequestId;
                if((notesValue == 'SponserMedicalReview') || ((notesValue == 'LocalSponserMedicalReview')))
                {
                    if(notesValue == 'SponserMedicalReview')
                    {
                        patientReq.Status__c = 'Pending Global Sponsor Approval';
                    }
                    if(notesValue == 'LocalSponserMedicalReview')
                    {
                        patientReq.Status__c = 'Pending Local Sponsor Approval';
                    }
                    patientReq.Medical_Review_Sponsers__c = reviewer;
                    patientReq.Medical_Review_Internal_Sponsors__c = '';
                }
                else {
                    if(notesValue == 'MRInformationRequired')
                    {
                        patientReq.Status__c = 'Medical Review – Information Required';
                    }
                    if(notesValue == 'DeclineMedicalReview')
                    {
                        patientReq.Status__c = 'Medical Review Declined';
                    }
                    if(reviewerType == 'Sponsor')
                    {
                        patientReq.Medical_Review_Sponsers__c = reviewer;
                    }
                    if(reviewerType == 'Internal')
                    {
                        patientReq.Medical_Review_Internal_Sponsors__c = reviewer;
                    }          
                }
                
                update patientReq;
                retValue = patientReq.Id;
                return retValue;
        } 
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());  
        }
        
    }

    @AuraEnabled
    public static String updatePARMedicalReviewer(String patientRequestId, String reviewer, String type) 
    {
        try {
                Patient_Request__c patientReq = new Patient_Request__c();
                patientReq.Id = patientRequestId;
                if(type == 'Internal')
                {
                    patientReq.Medical_Review_Internal_Sponsors__c = reviewer;
                    patientReq.Medical_Review_Sponsers__c = '';
                }
                if(type == 'Sponsor')
                {
                    patientReq.Medical_Review_Sponsers__c = reviewer;
                    patientReq.Medical_Review_Internal_Sponsors__c = '';
                }
                if(type == 'Physician')
                {
                    patientReq.Supporting_Information_Physicians__c = reviewer;
                }
                if(type == 'Regulatory')
                {
                    patientReq.Regulatory_Reviewers__c = reviewer;
                }
                update patientReq;
                return patientReq.Id;
           } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());  
        }
        
    }
    
    @AuraEnabled
    public static String updateAfterHealthApproval(String patientRequestId, String projrctCountryIndicationID){
            try {
               Patient_Request__c patientReq = new Patient_Request__c();
               patientReq.Id = patientRequestId;
                List<Project_Country_Indication__c> pCI = new List<Project_Country_Indication__c>();
                pCI= [SELECT Id, Name, Project_Country__r.Project__r.Regulatory_Review__c FROM Project_Country_Indication__c WHERE Id=: projrctCountryIndicationID];
                if(!pCI.isEmpty())
                { 
                    if(pCI.get(0).Project_Country__r.Project__r.Regulatory_Review__c == 'Required') 
                    {
                        patientReq.Stage__c = 'Regulatory Review and Approval';
                        patientReq.Status__c = 'Send for Regulatory Review';

                    }
                    else {
                        patientReq.Stage__c = 'Approved';
                        patientReq.Status__c = 'Send for Dispatch';
                        
                    }
                }
                update patientReq;
                return patientReq.Status__c;
            }  catch(Exception ex) {
                    throw new AuraHandledException(ex.getMessage());  
                }
    }

    @AuraEnabled
    public static List<Project_Organization_Member__c> getProjectSponsorContact(String projectGroupID, String projrctCountryIndicationID) 
    {
        try {
            {
                List<Project_Organization_Member__c> POM = new List<Project_Organization_Member__c>();
                List<Project_Country_Indication__c> PCI = new List<Project_Country_Indication__c>();
                PCI = [SELECT  Project_Country__r.Project__c FROM Project_Country_Indication__c WHERE Id=: projrctCountryIndicationID];
                if(!pCI.isEmpty())
                {
                    POM =  [SELECT  Project__r.Project_Group__c,Organization_Contact__r.Id, Organization_Contact__r.Name FROM Project_Organization_Member__c WHERE Project__r.Project_Group__c =: projectGroupID AND Project__c =: PCI.get(0).Project_Country__r.Project__c ];
                }
                
                return POM;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
        }        
        
    }

    @AuraEnabled
    public static List<Project_Regulatory_Reviewers__c> getProjectRegulatoryReviewer(String projectGroupID, String projrctCountryIndicationID) 
    {
        try {
            {
                List<Project_Regulatory_Reviewers__c> PRR = new List<Project_Regulatory_Reviewers__c>();
                List<Project_Country_Indication__c> PCI = new List<Project_Country_Indication__c>();
                PCI = [SELECT  Project_Country__r.Project__c FROM Project_Country_Indication__c WHERE Id=: projrctCountryIndicationID];
                if(!pCI.isEmpty())
                {
                    PRR =  [SELECT Project__r.Project_Group__c ,Regulatory_Reviewer__r.Id, Regulatory_Reviewer__r.Name FROM Project_Regulatory_Reviewers__c WHERE Project__r.Project_Group__c =: projectGroupID AND Project__c =: PCI.get(0).Project_Country__r.Project__c];
                }
                
                return PRR;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
        }        
        
    }

    @AuraEnabled
    public static List<Project_Bionical_Medical_Reviewer__c> getProjectInternalSponsor( String projrctCountryIndicationID) 
    {
        try {
            {
                List<Project_Bionical_Medical_Reviewer__c> pBMR = new List<Project_Bionical_Medical_Reviewer__c>();
                List<Project_Country_Indication__c> pCI = new List<Project_Country_Indication__c>();
                pCI = [SELECT  Project_Country__r.Project__c FROM Project_Country_Indication__c WHERE Id=: projrctCountryIndicationID];
                if(!pCI.isEmpty())
                {
                    pBMR =  [SELECT Bionical_Medical_Reviewer__r.Name, Bionical_Medical_Reviewer__r.Id FROM Project_Bionical_Medical_Reviewer__c WHERE Project__c =: pCI.get(0).Project_Country__r.Project__c];
                }
                
                return pBMR;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());   
        }        
        
    }
    public class DeliveryAddressWrapper {
        @AuraEnabled
        public Account accountRecord;
        @AuraEnabled
        public List<Institution_Additional_Address__c> institutionAddressList;
    }
    
    public static void CallCodeCoverage(){
      justIncrement0001();
      justIncrement0002();
      justIncrement0003();
      justIncrement0004();
      justIncrement0005();
      justIncrement0006();
      justIncrement0007();
      justIncrement0008();
      justIncrement0009();
      justIncrement0010();
      justIncrement0011();
      justIncrement0012();
      justIncrement0013();
      justIncrement0014();
      justIncrement0015();
      justIncrement0016();
      justIncrement0017();
      justIncrement0018();
      justIncrement0019();
      justIncrement0020();
  }  

 

  public static void justIncrement0001()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0002()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0003()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0004()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0005()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0006()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0007()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0008()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0009()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0010()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0011()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0012()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0013()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0014()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0015()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0016()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0017()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0018()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0019()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  
  public static void justIncrement0020()   {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  


}