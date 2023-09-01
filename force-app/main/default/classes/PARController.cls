public without sharing class PARController {
    public PARController() {

    }

    public class PARResponseWrapper{
        @AuraEnabled
        public String patientRequestId;
    }

    @AuraEnabled
    public static List<Patient__c> getPatientName(String treatmentid,String hospitalid,String indicationId, String productId){
        try {
            Map<ID, Patient__c> listPatientsMap = new Map<ID, Patient__c>([SELECT Id,Patient_ID__c,Institution__c FROM Patient__c WHERE Project_Group__c = : treatmentid and Institution__c = : hospitalid and Care_Product__c =: productId and Indication__r.Indication__r.Id =: indicationId AND Discontinued__c != true ORDER BY Patient_ID__c ASC]);
            List<Patient_Request__c> listRequests = new List<Patient_Request__c>();
            listRequests = [SELECT Id,Stage__c, Status__c, Patient__c, PatientId__c FROM Patient_Request__c WHERE (Patient__c IN : listPatientsMap.keySet() AND Status__c = 'Delivered')];
            List<Patient__c> listOfPatients = new List<Patient__c>();
            if(!listPatientsMap.isEmpty())
            {
                for(ID patId : listPatientsMap.keySet())
                {
                    for(Patient_Request__c pRequest : listRequests)
                    {
                        if(!String.isBlank(pRequest.PatientId__c))
                        {
                            String pId = pRequest.PatientId__c.substring(0, pRequest.PatientId__c.length() - 2);
                            pId = pId + '01';
                            if(pRequest.Patient__c == patId && pRequest.PatientId__c == pId)
                            {
                                listOfPatients.add(listPatientsMap.get(patId));
                                break;
                            }
                        }
                    }
                }
            }
            return listOfPatients;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, List<PARRecordWrapper.Answers>> getParameters(String patientid,String treatmentid, String reconcilation){
        try {
            List<String> params = new List<String>();
            params.add('Date Of Birth');
            params.add('Initial(s)');
            params.add('Gender');
            Map<String, List<PARRecordWrapper.Answers>> results = new Map<String, List<PARRecordWrapper.Answers>>();
            List<Patient_Request_Parameters__c> listPRP = new  List<Patient_Request_Parameters__c>();
            List<PARRecordWrapper.Answers> answerList = new List<PARRecordWrapper.Answers>();
            List<Patient_Request__c> patientRequestList = new List<Patient_Request__c> ();
            patientRequestList = [SELECT Id, Name, Stage__c, Status__c FROM Patient_Request__c WHERE Patient__c =:patientId];
            System.debug('size ' + patientRequestList.size());
            if(!patientRequestList.isEmpty())
            {
                listPRP = [SELECT Id, Patient_Parameter_Response__c, Project_Country_Patient_Parameter__r.Response_Type__c, Project_Country_Patient_Parameter__c, Project_Country_Patient_Parameter__r.Parameter_Name__c FROM Patient_Request_Parameters__c WHERE Patient__c = :patientid AND Project_Group__c = :treatmentid
                           AND Patient_Request__c = :patientRequestList.get(0).Id AND Project_Country_Patient_Parameter__r.Parameter_Name__c IN : params];
                for(Patient_Request_Parameters__c prp: listPRP){
                    PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
                    answer.Id = prp.Id;
                    if('Date'.equalsignoreCase(prp.Project_Country_Patient_Parameter__r.Response_Type__c))
                    {
                        if(String.isNotEmpty(prp.Patient_Parameter_Response__c))
                        {
                            Date sampleDate = Date.valueOf(prp.Patient_Parameter_Response__c);
                            DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                            answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                        }
                        else {
                            answer.answerDisplay =  prp.Patient_Parameter_Response__c;
                        }
                    }
                    else {
                        answer.answerDisplay =  prp.Patient_Parameter_Response__c;
                    }
                    answer.answer =  prp.Patient_Parameter_Response__c;
                    answer.paramName=prp.Project_Country_Patient_Parameter__r.Parameter_Name__c;
                    answer.pcPatientParamId = prp.Project_Country_Patient_Parameter__c;
                    answerList.add(answer);
                }
                if(patientRequestList.size() == 1)
                {
                    if(patientRequestList.get(0).Status__c == 'Closed - Cancelled' || patientRequestList.get(0).Status__c == 'Closed - Declined')
                    {
                        results.put('Cancelled',answerList);
                    }
                    else {
                        if(reconcilation == 'Recon')
                        {
                            List<Patient_Dosage_Request__c> patientDosageList = new List<Patient_Dosage_Request__c> ();
                            for(Patient_Dosage_Request__c pdr : [SELECT Id, Remaining__c FROM Patient_Dosage_Request__c WHERE Patient_Access_Request__c in :patientRequestList])
                            {
                                if(pdr.Remaining__c != 0)
                                {
                                    results.put('ReconError',answerList) ;
                                    break;
                                }
                            }
                        }
                    }
                }
                else
                {
                    if(patientRequestList.size() > 0)
                    {
                        for(Patient_Request__c patientReq: patientRequestList)
                        {
                            if(patientReq.Status__c != 'Delivered' && patientReq.Status__c != 'Closed - Declined' && patientReq.Status__c != 'Closed - Cancelled')
                            {
                                results.put('StatusError',answerList) ;
                                break;
                            }

                        }
                    }

                    if(reconcilation == 'Recon' & !results.containsKey('StatusError'))
                    {
                        List<Patient_Dosage_Request__c> patientDosageList = new List<Patient_Dosage_Request__c> ();
                        for(Patient_Dosage_Request__c pdr : [SELECT Id, Remaining__c, Patient_Access_Request__r.Status__c FROM Patient_Dosage_Request__c WHERE Patient_Access_Request__c in :patientRequestList])
                        {
                            if(pdr.Remaining__c != 0 && pdr.Patient_Access_Request__r.Status__c != 'Closed - Declined'
                               && pdr.Patient_Access_Request__r.Status__c != 'Closed - Cancelled')
                            {
                                results.put('ReconError',answerList) ;
                                break;
                            }
                        }
                    }

                }
                results.put('success',answerList);
            }
            else {
                results.put('No value',answerList);
            }
            return results;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static PARRecordWrapper createPARRecord(String input,String physicanid){
        PARRecordWrapper inputWrapper =  PARRecordWrapper.parse(input);
        Patient__c p = updateCreatePatient(inputWrapper);
        Patient_Request__c pr = createUpdatePatientRequest(inputWrapper, p);
        if(inputWrapper.answers != null && inputWrapper.answers.size() > 0){
            inputWrapper.answers = updatePatientParameterPII(inputWrapper,inputWrapper.answers,p,pr);
        }
        if(inputWrapper.patientParameters != null && inputWrapper.patientParameters.size() > 0)
            inputWrapper.patientParameters = updatePatientParameter(inputWrapper,inputWrapper.patientParameters,p,pr);
        if(inputWrapper.inclusionEligibilities != null && inputWrapper.inclusionEligibilities.size() > 0)
            inputWrapper.inclusionEligibilities = updateEligibilites(inputWrapper,inputWrapper.inclusionEligibilities,p,pr,'Inclusion Criteria');
        if(inputWrapper.exclusionEligibilities != null && inputWrapper.exclusionEligibilities.size() > 0)
            inputWrapper.exclusionEligibilities = updateEligibilites(inputWrapper,inputWrapper.exclusionEligibilities,p,pr,'Exclusion Criteria');
        updateSupportingInformation(inputWrapper,p,pr);
        updateCreateDosingDetails(inputWrapper);
        return inputWrapper;
    }

    private static void updateCreateDosingDetails(PARRecordWrapper inputWrapper){
        if(inputWrapper.dosingDetailsWrapper != null && inputWrapper.dosingDetailsWrapper.dosingDetails.size() > 0){
            List<Patient_Dosage_Request__c> dosageRequestList = new List<Patient_Dosage_Request__c>();
            Set<Id> patientRequestIds = new Set<Id> ();
            Map<String, Decimal> reassignedQuantityMap = new Map<String, Decimal> ();
            Map<String, String> dosageStrengthMap = new Map<String, String> ();
            for(DosingDetailsWrapper.DosingDetails dd: inputWrapper.dosingDetailsWrapper.dosingDetails) {
                system.debug('dd==>'+dd);
                Patient_Dosage_Request__c pdr = new Patient_Dosage_Request__c();
                pdr.Quantity__c = dd.DefaultQuantity != null ? dd.DefaultQuantity : 0 ;
                pdr.Quantity_Shipped__c = dd.DefaultQuantity != null ? dd.DefaultQuantity : 0 ;
                pdr.Id = dd.patientDosageRequestId;
                pdr.Dosing_Details__c = dd.Id;
                pdr.Patient_Access_Request__c = inputWrapper.Id;
                patientRequestIds.add(inputWrapper.Id);
                if(String.isNotBlank(dd.patientDosageRequestId)) {
                    dosageStrengthMap.put(dd.patientDosageRequestId, dd.Strength);
                }
                dosageRequestList.add(pdr);
            }
            if(!patientRequestIds.isEmpty()) {
                for(Patient_Dosage_Request_History__c historyRec: [SELECT Id, Quantity__c, Patient_Request__c, Patient_Dosage_Request__c, Patient_Dosage_Request__r.Strength__c FROM Patient_Dosage_Request_History__c WHERE Patient_Request__c IN: patientRequestIds]) {
                    if(reassignedQuantityMap.containsKey(historyRec.Patient_Dosage_Request__r.Strength__c)) {
                        Decimal count = reassignedQuantityMap.get(historyRec.Patient_Dosage_Request__r.Strength__c);
                        reassignedQuantityMap.put(historyRec.Patient_Dosage_Request__r.Strength__c, count+historyRec.Quantity__c);
                    } else {
                        reassignedQuantityMap.put(historyRec.Patient_Dosage_Request__r.Strength__c, historyRec.Quantity__c);
                    }
                }
            }
            if(!reassignedQuantityMap.isEmpty() && !dosageStrengthMap.isEmpty()) {
                for(Patient_Dosage_Request__c dosageRec: dosageRequestList) {
                    if(reassignedQuantityMap.get(dosageStrengthMap.get(dosageRec.Id))!=null) {
                        dosageRec.Reassigned_Quantity__c = dosageRec.Quantity__c + reassignedQuantityMap.get(dosageStrengthMap.get(dosageRec.Id));
                    }
                }
            }
            if(!dosageRequestList.isEmpty()) {
                upsert dosageRequestList;
            }
            Map<String,String> dosingIdAndDosingRequestId = new Map<String,String>();
            for(Patient_Dosage_Request__c pdr: dosageRequestList){
                dosingIdAndDosingRequestId.put(pdr.Dosing_Details__c,pdr.Id);
            }
            for(DosingDetailsWrapper.DosingDetails dd: inputWrapper.dosingDetailsWrapper.dosingDetails){
                dd.patientDosageRequestId = dosingIdAndDosingRequestId.get(dd.Id);
            }
        }
    }

    private static void updateSupportingInformation(PARRecordWrapper inputWrapper, Patient__c p,Patient_Request__c pr){
        List<Patient_Request_Supporting__c> prsList = new List<Patient_Request_Supporting__c>();
        if(inputWrapper.supportingInformations != null)
            for(PARRecordWrapper.Answers answer : inputWrapper.supportingInformations)
        {
            Patient_Request_Supporting__c prs = new Patient_Request_Supporting__c();
            prs.Id = answer.Id;
            prs.Country_Supporting_Info_Requrement__c =answer.pcPatientParamId ;
            prs.Patient_Request_Supporting_Response__c = answer.answer;
            prs.Patient__c = p.Id;
            prs.Patient_Request__c= pr.Id;
            prs.Project_Group__c= inputWrapper.treatmentid;
            prsList.add(prs);
        }
        upsert prsList;
        Set<Id> prsIds = new Set<Id>();
        for(Patient_Request_Supporting__c prs: prsList){
            prsIds.add(prs.Id);
        }
        List<Patient_Request_Supporting__c> deleteParams = [select id from Patient_Request_Supporting__c where id not in :prsIds and Patient_Request__c = :pr.Id];
        if(deleteParams.size()>0){
            delete deleteParams;
        }
        prsList = [SELECT Id,Country_Supporting_Info_Requrement__r.Parameter_Name__c,Country_Supporting_Info_Requrement__r.Response_Type__c,Country_Supporting_Info_Requrement__c,Patient_Request_Supporting_Response__c FROM Patient_Request_Supporting__c WHERE id IN :prsIds];
        List<PARRecordWrapper.Answers> answers = new List<PARRecordWrapper.Answers>();
        for(Patient_Request_Supporting__c prs: prsList){
            PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
            answer.Id = prs.Id;
            answer.paramName = prs.Country_Supporting_Info_Requrement__r.Parameter_Name__c;
            answer.pcPatientParamId = prs.Country_Supporting_Info_Requrement__c;
            if('Date'.equalsignoreCase(prs.Country_Supporting_Info_Requrement__r.Response_Type__c))
            {
                if(String.isNotEmpty(prs.Patient_Request_Supporting_Response__c))
                {
                    Date sampleDate = Date.valueOf(prs.Patient_Request_Supporting_Response__c);
                    DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                    answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                }
                else {
                    answer.answerDisplay =   prs.Patient_Request_Supporting_Response__c;
                }
            }
            else {
                answer.answerDisplay =   prs.Patient_Request_Supporting_Response__c;
            }
            answer.answer =   prs.Patient_Request_Supporting_Response__c;
            answers.add(answer);
        }
        inputWrapper.supportingInformations = answers;

    }

    private static List<PARRecordWrapper.Answers> updateEligibilites(PARRecordWrapper inputWrapper,List<PARRecordWrapper.Answers> eligibilities, Patient__c p,Patient_Request__c pr, String type){
        List<Patient_Request_Eligibility__c> preList = new List<Patient_Request_Eligibility__c>();
        if(eligibilities != null)
            for(PARRecordWrapper.Answers answer : eligibilities)
        {
            system.debug('>>>');
            Patient_Request_Eligibility__c pre = new Patient_Request_Eligibility__c();
            pre.Id = answer.Id;
            pre.Project_Country_Eligibility__c =answer.pcPatientParamId ;
            pre.Patient_Eligibility_Response__c = answer.answer;
            pre.Patient__c = p.Id ;
            pre.Patient_Request__c= pr.Id;
            pre.Project_Group__c= inputWrapper.treatmentid;
            answer.Id = pre.Id;
            preList.add(pre);
        }
        upsert preList;
        Set<Id> preIds = new Set<Id>();
        for(Patient_Request_Eligibility__c pre: preList){
            preIds.add(pre.Id);
        }
        List<Patient_Request_Eligibility__c> deleteParams = [select id from Patient_Request_Eligibility__c where id not in :preIds and Patient_Request__c = :pr.Id and Project_Country_Eligibility__r.Eligibility_Type__c = :type];
        if(deleteParams.size()>0){
            delete deleteParams;
        }
        preList = [SELECT Id,Project_Country_Eligibility__r.Question__c, Project_Country_Eligibility__r.Response_Type__c, Project_Country_Eligibility__c,Patient_Eligibility_Response__c FROM Patient_Request_Eligibility__c where id IN :preIds];
        List<PARRecordWrapper.Answers> answers = new List<PARRecordWrapper.Answers>();
        for(Patient_Request_Eligibility__c pre: preList){
            PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
            answer.Id = pre.Id;
            answer.paramName = pre.Project_Country_Eligibility__r.Question__c;
            answer.pcPatientParamId = pre.Project_Country_Eligibility__c;
            if('Date'.equalsignoreCase(pre.Project_Country_Eligibility__r.Response_Type__c))
            {
                if(String.isNotEmpty(pre.Patient_Eligibility_Response__c))
                {
                    Date sampleDate = Date.valueOf(pre.Patient_Eligibility_Response__c);
                    DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                    answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                }
                else {
                    answer.answerDisplay =   pre.Patient_Eligibility_Response__c;
                }
            }
            else {
                answer.answerDisplay =   pre.Patient_Eligibility_Response__c;
            }
            answer.answer =   pre.Patient_Eligibility_Response__c;
            answers.add(answer);
        }
        return answers;
    }


    private static List<PARRecordWrapper.Answers> updatePatientParameterPII(PARRecordWrapper inputWrapper,List<PARRecordWrapper.Answers> answers, Patient__c p,Patient_Request__c pr){
        List<Patient_Request_Parameters__c> prpListPII = new List<Patient_Request_Parameters__c>();
        if(answers != null)
            for(PARRecordWrapper.Answers answer : answers)
        {
            Patient_Request_Parameters__c prp = new Patient_Request_Parameters__c();
            prp.Id = answer.Id;
            prp.Project_Country_Patient_Parameter__c =answer.pcPatientParamId ;
            prp.Patient_Parameter_Response__c = answer.answer;
            prp.Patient__c = p.Id ;
            prp.Patient_Request__c= pr.Id;
            prp.Project_Group__c= inputWrapper.treatmentid;
            prpListPII.add(prp);
        }
        upsert prpListPII;
        Set<Id> prpPIIIds = new Set<Id>();
        for(Patient_Request_Parameters__c prp: prpListPII){
            prpPIIIds.add(prp.Id);
        }
        List<Patient_Request_Parameters__c> deleteRequestParameters = [select id from Patient_Request_Parameters__c where id not in :prpPIIIds and Patient_Request__c = :pr.Id and Project_Country_Patient_Parameter__r.Parameter_Name__c in ('Date of Birth', 'Initial(s)', 'Gender')];
        if(deleteRequestParameters.size()>0){
            delete deleteRequestParameters;
        }
        prpListPII = [SELECT Id,Project_Country_Patient_Parameter__r.Parameter_Name__c,Project_Country_Patient_Parameter__r.Response_Type__c, Project_Country_Patient_Parameter__c,Patient_Parameter_Response__c FROM Patient_Request_Parameters__c where id IN :prpPIIIds];
        List<PARRecordWrapper.Answers> answerList = new List<PARRecordWrapper.Answers>();
        for(Patient_Request_Parameters__c prp: prpListPII){
            PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
            answer.Id = prp.Id;
            if('Date'.equalsignoreCase(prp.Project_Country_Patient_Parameter__r.Response_Type__c))
            {
                if(String.isNotEmpty(prp.Patient_Parameter_Response__c))
                {
                    Date sampleDate = Date.valueOf(prp.Patient_Parameter_Response__c);
                    DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                    answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                }
                else {
                    answer.answerDisplay =  prp.Patient_Parameter_Response__c;
                }
            }
            else {
                answer.answerDisplay =  prp.Patient_Parameter_Response__c;
            }
            answer.answer =  prp.Patient_Parameter_Response__c;
            answer.paramName=prp.Project_Country_Patient_Parameter__r.Parameter_Name__c;
            answer.pcPatientParamId = prp.Project_Country_Patient_Parameter__c;
            answerList.add(answer);
        }
        return answerList;
    }

    private static List<PARRecordWrapper.Answers> updatePatientParameter(PARRecordWrapper inputWrapper,List<PARRecordWrapper.Answers> answers, Patient__c p,Patient_Request__c pr){
        List<Patient_Request_Parameters__c> prpList = new List<Patient_Request_Parameters__c>();
        if(answers != null)
            for(PARRecordWrapper.Answers answer : answers)
        {
            Patient_Request_Parameters__c prp = new Patient_Request_Parameters__c();
            prp.Id = answer.Id;
            prp.Project_Country_Patient_Parameter__c =answer.pcPatientParamId ;
            prp.Patient_Parameter_Response__c = answer.answer;
            prp.Patient__c = p.Id ;
            prp.Patient_Request__c= pr.Id;
            prp.Project_Group__c= inputWrapper.treatmentid;
            prpList.add(prp);
        }
        upsert prpList;
        Set<Id> prpIds = new Set<Id>();
        for(Patient_Request_Parameters__c prp: prpList){
            prpIds.add(prp.Id);
        }
        List<Patient_Request_Parameters__c> deleteRequestParameters = [SELECT id FROM Patient_Request_Parameters__c WHERE id NOT IN :prpIds AND Patient_Request__c = :pr.Id AND Project_Country_Patient_Parameter__r.Parameter_Name__c NOT IN ('Date of Birth', 'Initial(s)', 'Gender')];
        if(deleteRequestParameters.size()>0){
            delete deleteRequestParameters;
        }
        prpList = [SELECT Id,Project_Country_Patient_Parameter__r.Parameter_Name__c,Project_Country_Patient_Parameter__r.Response_Type__c, Project_Country_Patient_Parameter__c,Patient_Parameter_Response__c FROM Patient_Request_Parameters__c where id IN :prpIds];
        List<PARRecordWrapper.Answers> answerList = new List<PARRecordWrapper.Answers>();
        for(Patient_Request_Parameters__c prp: prpList){
            PARRecordWrapper.Answers answer = new PARRecordWrapper.Answers();
            answer.Id = prp.Id;
            if('Date'.equalsignoreCase(prp.Project_Country_Patient_Parameter__r.Response_Type__c))
            {
                if(String.isNotEmpty(prp.Patient_Parameter_Response__c))
                {
                    Date sampleDate = Date.valueOf(prp.Patient_Parameter_Response__c);
                    DateTime dtConverted = Datetime.newInstance(sampleDate.year(), sampleDate.month(),sampleDate.day(),0,0,0);
                    answer.answerDisplay = dtConverted.format('dd MMM yyyy');
                }
                else {
                    answer.answerDisplay =  prp.Patient_Parameter_Response__c;
                }
            }
            else {
                answer.answerDisplay =  prp.Patient_Parameter_Response__c;
            }
            answer.answer =  prp.Patient_Parameter_Response__c;
            answer.paramName=prp.Project_Country_Patient_Parameter__r.Parameter_Name__c;
            answer.pcPatientParamId = prp.Project_Country_Patient_Parameter__c;
            answerList.add(answer);
        }
        return answerList;
    }

    private static Patient_Request__c createUpdatePatientRequest(PARRecordWrapper inputWrapper, Patient__c p){
        try {
            Patient_Request__c pr = new Patient_Request__c();
            pr.Id = inputWrapper.Id;
            pr.Patient__c = p.Id;
            if(String.isNotBlank(inputWrapper.patientName))
            {
                pr.PatientId__c = inputWrapper.patientName;
            }
            pr.Additional_Patient_Information__c = inputWrapper.additionalInformation;
            pr.Institutation__c = inputWrapper.hospitalId;
            List<User> uList = [select Id from user where contactId = :inputWrapper.hcpid];
            if(uList.size() > 0){
                pr.On_Behalf_Of__c = uList.get(0).Id;
            }
            if(inputWrapper.prePopulate != true)
            {
                pr.Requested_By__c = UserInfo.getUserId();
            }
            pr.Project_Group__c = inputWrapper.treatmentid;
            pr.Project_Country_Indication__c = inputWrapper.indicationid;
            pr.Consent_Provided__c = inputWrapper.confirmConsent;
            pr.HCP_Responsible_For_Product_Use__c = inputWrapper.acceptResponsibility;
            pr.Status__c = inputWrapper.status;
            pr.Stage__c = inputWrapper.stage;
            pr.Required_Dose__c = inputWrapper.requireDose;
            pr.BSA__c = inputWrapper.patientBSA;
            pr.Request_Tab_Saved__c = inputWrapper.savedTabNo;
            upsert pr;
            inputWrapper.Id = pr.Id;
            List<Patient_Request__c> parList = [SELECT Id, PatientId__c, Patient__r.SequenceNumber__c FROM Patient_Request__c WHERE Id =:inputWrapper.Id];
            if(parList.size() > 0)
            {
                inputWrapper.patientName = parList.get(0).PatientId__c;
                inputWrapper.pARpatientId = parList.get(0).PatientId__c;
                if(parList.get(0).Patient__r.SequenceNumber__c > 1)
                {
                    String sequence = parList.get(0).Patient__r.SequenceNumber__c > 10 ? String.valueOf(parList.get(0).Patient__r.SequenceNumber__c - 1) : '0' + (parList.get(0).Patient__r.SequenceNumber__c - 1);
                    String pId = parList.get(0).PatientId__c.substring(0, parList.get(0).PatientId__c.length() - 2);
                    String pRId = pId + sequence;
                    List<Patient_Request__c> parNewList = [SELECT Id, PatientId__c FROM Patient_Request__c WHERE PatientId__c = : pRId];
                    updatePreviousPatientRequest(parNewList.get(0).Id);
                }
            }
            return pr;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    private static Patient__c updateCreatePatient(PARRecordWrapper inputWrapper){
        Patient__c p = null;
        Boolean isChanged = false;
        if(inputWrapper.step == true && inputWrapper.prePopulate != true)
        {
            if(inputWrapper.patientId != null){
                p = [select Id,SequenceNumber__c from Patient__c where Id = :inputWrapper.patientId];
                p.SequenceNumber__c = p.SequenceNumber__c +1;

            } else {
                p = new Patient__c();
                integer STRING_LENGTH = 5;
                Integer randomNumber = null;
                while(true){
                    randomNumber = Math.Round(Math.Random() * ((Math.pow(10,STRING_LENGTH) - 1)-Math.pow(10,STRING_LENGTH -1)) + Math.pow(10,STRING_LENGTH -1));
                    List<Patient__c> existingPatients = [select id from Patient__c where RandomSeqNumber__c = :randomNumber];
                    if(existingPatients.size() ==0){
                        break;
                    }
                }
                p.RandomSeqNumber__c = randomNumber;
                p.SequenceNumber__c = 1;
            }
            isChanged = true;
        }
        else {
            p = [select Id,Patient_ID__c from Patient__c where Id = :inputWrapper.patientId];
        }
        if(inputWrapper.answers != null && inputWrapper.answers.size() > 0){
            for(PARRecordWrapper.Answers answer: inputWrapper.answers){
                if('Gender'.equalsignoreCase(answer.paramName)){
                    p.Gender__c = answer.answer;
                } else if('Date of Birth'.equalsignoreCase(answer.paramName)){
                    p.Date_of_Birth__c = Date.valueOf(answer.answer);
                } else if('Initial(s)'.equalsignoreCase(answer.paramName)){
                    p.Initials__c = answer.answer;
                }

            }
        }
        p.Care_Product__c = inputWrapper.product;
        p.Indication__c = inputWrapper.indicationid;
        p.Contact__c = inputWrapper.hcpid;
        p.Institution__c = inputWrapper.hospitalId;
        p.Project_Group__c = inputWrapper.treatmentid;
        upsert p;
        if(isChanged)
        {
            List<Patient__c> pList = [SELECT Id,Patient_ID__c FROM Patient__c WHERE id =:p.Id];
            if(pList.size() > 0)
            {
                inputWrapper.patientName = pList.get(0).Patient_ID__c;
            }
        }
        inputWrapper.patientId = p.Id;
        return p;
    }

    private static void updatePreviousPatientRequest(String patientRequestId){
        Patient_Request__c pr = new Patient_Request__c();
        pr.Id = patientRequestId;
        pr.Follow_Ups_Not_Requried__c = true;
        update pr;
    }

    @AuraEnabled(cacheable=true)
    public static Patient_Request__c getPatienRequestDetails(String parid){
        List<Patient_Request__c> patientRequestList = [SELECT Id, Project_Country_Indication__r.Project_Country__r.Project__r.No_of_weeks_treatment__c, First_Follow_Up__c, Second_Follow_Up__c, Third_Follow_Up__c, Resupply_Due_Date__c, First_Follow_Up_Status__c, Second_Follow_Up_Status__c, Third_Follow_Up_Status__c, Follow_Ups_Not_Requried__c, Date_Delivered__c, Requested_By__c, On_Behalf_Of__c, PARAssignedToPAMUser__c FROM Patient_Request__c WHERE Id = :parid AND Status__c ='Delivered' AND Stage__c ='Dispatched'];
        system.debug('prs==>'+patientRequestList);
        if(!patientRequestList.isEmpty()){
            return patientRequestList.get(0);
        }
        return null;
    }
    @AuraEnabled
    public static void savePatientRequestDetails(String json) {
        Patient_Request__c prWrapper =  (Patient_Request__c)System.JSON.deserialize(json, Patient_Request__c.class);
        system.debug('419==>'+prWrapper);
        update prWrapper;
    }

}