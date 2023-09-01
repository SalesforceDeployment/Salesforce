public class ProjectHandler {
    
    public class InputVariable{
        @InvocableVariable
        public String projectId;
    }
    
    @InvocableMethod(label='Clone Project' )
    public static void cloneProject(List<InputVariable> userInput){
        String projectId = userInput.get(0).projectId;
        Project__c p = [select Id, Additional_Product_Information__c,Approval_Level__c,Approval_Needed__c,First_Order_Only__c,Name,No_of_weeks_treatment__c,Organisation__c,Parent_Project__c,Project_Code__c,Project_Group__c,Project_Status__c,Reconciliation_Required__c,Regulatory_Review__c,Version__c from Project__c where Id = :projectId];
        Project__c newP = p.clone(false,true);
        newP.Version__c = p.Version__c + 1;
        newP.Project_Status__c = 'Draft Creation in Progress';
        newP.Parent_Project__c = projectId;
        newP.Sponsor__c = null;
        insert newP;
        
        cloneProjectCountry(projectId,newP.Id);
        cloneProjectRegulatoryReview(projectId,newP.Id);
        cloneProjectOrgMembers(projectId,newP.Id);
        cloneProjectBionicalMedicalReviewer(projectId,newP.Id);
        cloneProjectPatientParameter(projectId,newP.Id);
        cloneProjectRegulatoryConsent(projectId,newP.Id);
        cloneProjectEligibility(projectId,newP.Id);
        cloneSupportingInformation(projectId,newP.Id);
        cloneProjectIndication(projectId,newP.Id);
        cloneFilesFromOldProjectToNew(projectId,newP.Id);
        // cloneProjectRequest(projectId,newP.Id);
    }
    
    private static void cloneProjectRegulatoryReview(String oldPId,String newPId){
        List<Project_Regulatory_Reviewers__c> oldprReviewers = [select Id, Regulatory_Reviewer__c,Description__c,Project__c from Project_Regulatory_Reviewers__c where Project__c = :oldPId];
        List<Project_Regulatory_Reviewers__c> newprReviewers = new List<Project_Regulatory_Reviewers__c>();
        for(Project_Regulatory_Reviewers__c pr:oldprReviewers){
            Project_Regulatory_Reviewers__c newPr = pr.clone(false,true); 
            newPr.Project__c = newPId;
            newprReviewers.add(newPr);
        }
        if(newprReviewers.size() > 0)
            insert newprReviewers;
    }
    
    private static void cloneProjectOrgMembers(String oldPId,String newPId){
        List<Project_Organization_Member__c> oldPOrgMembers = [select Id,Name,Organization__c,Organization_Contact__c,Description__c,Project__c from Project_Organization_Member__c where Project__c =:oldPId];
        List<Project_Organization_Member__c> newPOrgMembers = new List<Project_Organization_Member__c>();
        for(Project_Organization_Member__c om:oldPOrgMembers){
            Project_Organization_Member__c newPOrgMember = om.clone(false,true); 
            newPOrgMember.Project__c = newPId;
            newPOrgMembers.add(newPOrgMember);
        }
        if(newPOrgMembers.size() > 0)
            insert newPOrgMembers;
    }
    
    private static void cloneProjectBionicalMedicalReviewer(String oldPId, String newPId){
        List<Project_Bionical_Medical_Reviewer__c> reviewser = [select Id,Project__c, Bionical_Medical_Reviewer__c,Description__c from Project_Bionical_Medical_Reviewer__c where Project__c =:oldPId];
        List<Project_Bionical_Medical_Reviewer__c> newReviewers = new List<Project_Bionical_Medical_Reviewer__c>();
        for(Project_Bionical_Medical_Reviewer__c r:reviewser){
            Project_Bionical_Medical_Reviewer__c newR = r.clone(false,true); 
            newR.Project__c = newPId;
            newReviewers.add(newR);
        }
        if(newReviewers.size() > 0)
            insert newReviewers;    
    }
    
    private static void cloneProjectPatientParameter(String oldPId, String newPId){
        List<Project_Patient_Parameter__c> oldPPP = [select Id,Project__c,Name,Parameter_NAme__c,First__c,Repeat__c,Business_Rule__c,Picklist_Options__c,Response_Type__c,Display_Order__c from Project_Patient_Parameter__c where Project__c =:oldPId];
        List<Project_Patient_Parameter__c> newPPPs = new List<Project_Patient_Parameter__c>();
        for(Project_Patient_Parameter__c ppp:oldPPP){
            Project_Patient_Parameter__c newPPP = ppp.clone(false,true); 
            newPPP.Project__c = newPId;
            newPPPs.add(newPPP);
        }
        if(newPPPs.size() > 0)
            insert newPPPs; 
        Map<String,String> pppOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPPP.size();i++){
            pppOldIdAndNewIdMap.put(oldPPP.get(i).Id, newPPPs.get(i).Id);
        }
        clonePPPDisplayRules(oldPId,pppOldIdAndNewIdMap);
    }
    
    private static void clonePPPDisplayRules(String oldPId, Map<String,String> pppOldIdAndNewIdMap){
        List<Project_Patient_Parameter_Display_Rule__c> oldPPPDRs = [select Id,Project_Patient_Parameter__c, When_Answer_Is__c, Display_Rule_Applied_On__c from Project_Patient_Parameter_Display_Rule__c where Project_Patient_Parameter__r.Project__c =:oldPId];
        List<Project_Patient_Parameter_Display_Rule__c> newPPPDRs = new List<Project_Patient_Parameter_Display_Rule__c>();
        for(Project_Patient_Parameter_Display_Rule__c pcppdr:oldPPPDRs){
            Project_Patient_Parameter_Display_Rule__c newPppdr = pcppdr.clone(false,true); 
            newPppdr.Project_Patient_Parameter__c = pppOldIdAndNewIdMap.get(newPppdr.Project_Patient_Parameter__c);
            newPppdr.Display_Rule_Applied_On__c = pppOldIdAndNewIdMap.get(newPppdr.Display_Rule_Applied_On__c);
            newPPPDRs.add(newPppdr);
        }
        if(newPPPDRs.size() > 0)
            insert newPPPDRs;
    }
    
    private static void cloneProjectRegulatoryConsent(String oldPId, String newPId){
        List<Project_Regulatory_Consent__c> oldPRCs = [select Id,Name,Consent_Title__c,Sequence_Order__c,Consent_Description__c from Project_Regulatory_Consent__c where Project__c =:oldPId];
        List<Project_Regulatory_Consent__c> newPRCs = new List<Project_Regulatory_Consent__c>();
        for(Project_Regulatory_Consent__c prc:oldPRCs){
            Project_Regulatory_Consent__c newPrc = prc.clone(false,true); 
            newPrc.Project__c = newPId;
            newPRCs.add(newPrc);
        }
        if(newPRCs.size() > 0)
            insert newPRCs;        
    }
    
    private static void cloneProjectEligibility(String oldPId, String newPId){
        List<Project_Eligibility__c> oldPEs = [select Id, Project__c, Name,Compulsary_Question__c,Eligibility_Type__c,Business_Rule__c,First__c,Repeat__c,Picklist_Options__c,Question__c,Question_Type__c,Display_Order__c from Project_Eligibility__c where Project__c =:oldPId];
        List<Project_Eligibility__c> newPEs = new List<Project_Eligibility__c>();
        for(Project_Eligibility__c pe:oldPEs){
            Project_Eligibility__c newPe = pe.clone(false,true); 
            newPe.Project__c = newPId;
            newPEs.add(newPe);
        }
        if(newPEs.size() > 0)
            insert newPEs;
        Map<String,String> peOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPEs.size();i++){
            peOldIdAndNewIdMap.put(oldPEs.get(i).Id, newPEs.get(i).Id);
        }
        clonePDisplayRules(oldPId,peOldIdAndNewIdMap);
    }
    
    
    private static void clonePDisplayRules(String oldPId, Map<String,String> peOldIdAndNewIdMap){
        List<Project_Eligibility_Display_Rule__c> oldPEDRs = [select Id,Project_Eligibility__c, When_Answer_Is__c, Display_Rule_Applied_On__c from Project_Eligibility_Display_Rule__c  where project_Eligibility__r.Project__c =:oldPId];
        List<Project_Eligibility_Display_Rule__c> newPEDRs = new List<Project_Eligibility_Display_Rule__c>();
        for(Project_Eligibility_Display_Rule__c pcedr:oldPEDRs){
            Project_Eligibility_Display_Rule__c newPedr = pcedr.clone(false,true); 
            newPedr.Project_Eligibility__c = peOldIdAndNewIdMap.get(newPedr.Project_Eligibility__c);
            newPedr.Display_Rule_Applied_On__c = peOldIdAndNewIdMap.get(newPedr.Display_Rule_Applied_On__c);
            newPEDRs.add(newPedr);
        }
        if(newPEDRs.size() > 0)
            insert newPEDRs;
    }
    
    private static void cloneSupportingInformation(String oldPId, String newPId){
        List<Project_Supporting_Information__c> oldPSIs = [select Id, Project__c, Name,Question__c,First__c,Repeat__c,Response_Type__c,Business_Rule__c,Compulsory_Question__c,Picklist_Options__c,Display_Order__c from Project_Supporting_Information__c where Project__c =:oldPId];
        List<Project_Supporting_Information__c> newPSIs = new List<Project_Supporting_Information__c>();
        for(Project_Supporting_Information__c psi:oldPSIs){
            Project_Supporting_Information__c newPsi = psi.clone(false,true); 
            newPsi.Project__c = newPId;
            newPSIs.add(newPsi);
        }
        if(newPSIs.size() > 0)
            insert newPSIs;
        Map<String,String> psiOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPSIs.size();i++){
            psiOldIdAndNewIdMap.put(oldPSIs.get(i).Id, newPSIs.get(i).Id);
        }
        clonePsiDisplayRules(oldPId,psiOldIdAndNewIdMap);
    }
    
    private static void clonePsiDisplayRules(String oldPId, Map<String,String> psiOldIdAndNewIdMap){
        List<Supporting_Info_Req_Display_Rule__c> oldPSIDRs = [select Id,Supporting_Information_Requirement__c, When_Answer_Is__c, Display_Rule_Applied_On__c from Supporting_Info_Req_Display_Rule__c  where Supporting_Information_Requirement__r.Project__c =:oldPId];
        List<Supporting_Info_Req_Display_Rule__c> newPSIDRs = new List<Supporting_Info_Req_Display_Rule__c>();
        for(Supporting_Info_Req_Display_Rule__c pcsidr:oldPSIDRs){
            Supporting_Info_Req_Display_Rule__c newPsidr = pcsidr.clone(false,true); 
            newPsidr.Supporting_Information_Requirement__c = psiOldIdAndNewIdMap.get(newPsidr.Supporting_Information_Requirement__c);
            newPsidr.Display_Rule_Applied_On__c = psiOldIdAndNewIdMap.get(newPsidr.Display_Rule_Applied_On__c);
            newPSIDRs.add(newPsidr);
        }
        if(newPSIDRs.size() > 0)
            insert newPSIDRs;
    }
    
    private static void cloneProjectIndication(String oldPId, String newPId){
        List<Project_Indication__c> oldPIs = [select Id, Project__c,Name, Indication__c, Is_Cloned__c from Project_Indication__c where Project__c =:oldPId];
        List<Project_Indication__c> newPIs = new List<Project_Indication__c>();
        for(Project_Indication__c pi:oldPIs){
            Project_Indication__c newPi = pi.clone(false,true); 
            newPi.Project__c = newPId;
            newPi.Is_Cloned__c = true;
            newPIs.add(newPi);
        }
        if(newPIs.size() > 0)
            insert newPIs;  
    }
    
    // private static void cloneProjectRequest(String oldPId, String newPId){
    //     List<Patient_Request__c> oldPRs = [select Id,name,Project__c from Patient_Request__c where Project__c =:oldPId];
    //     List<Patient_Request__c> newPRs = new List<Patient_Request__c>();
    //     for(Patient_Request__c pr:oldPRs){
    //         Patient_Request__c newPr = pr.clone(false,true); 
    //         newPr.Project__c = newPId;
    //         newPRs.add(newPr);
    //     }
    //     if(newPRs.size() > 0)
    //         insert newPRs;  
    // }
    
    private static void cloneProjectCountry(String oldPId, String newPId){
        List<Project_Country__c> oldPCs = [select Id,Name,Project__c, Country__c,Allow_Initial_Patient_Requests__c,Allow_Repeat_Patient_Requests__c,Approval_Needed__c,First_Order_Only__c,Approval_Level__c,Adverse_Event_Telephone__c,Adverse_Event_Fax__c,Additional_Product_Information__c ,Required_Dose_Field_enabled__c,Patient_BSA__c,ShowEligibilityCriteriaInTA__c,Adverse_Event_Email__c from Project_Country__c where Project__c =:oldPId];
        List<Project_Country__c> newPCs = new List<Project_Country__c>();
        Set<Id> newProjId = new Set<Id>();
        for(Project_Country__c pc:oldPCs){
            Project_Country__c newPc = pc.clone(false,true); 
            newPc.Project__c = newPId;
            newProjId.add(newPId);
            newPCs.add(newPc);
        }
        if(newPCs.size() > 0)
            insert newPCs;  
        Map<String,String> pcOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i =0;i<newPCs.size();i++){
            pcOldIdAndNewIdMap.put(oldPCs.get(i).Id,newPCs.get(i).Id);
        }
        clonePCRegulatoryConsent(oldPId,pcOldIdAndNewIdMap);
        clonePCPatientParameter(oldPId,pcOldIdAndNewIdMap);
        clonePCEligibility(oldPId,pcOldIdAndNewIdMap);
        clonePCSupportingInfo(oldPId,pcOldIdAndNewIdMap);
        clonePCCountryIndication(oldPId,pcOldIdAndNewIdMap);
        cloneFilesFromOldProjectCountryToNew(oldPCs,newPCs,pcOldIdAndNewIdMap);
    }
    
    private static void clonePCRegulatoryConsent(String oldPId, Map<String,String> pcOldIdAndNewIdMap){
        List<Project_Country_Regulatory_Consent__c> oldPCRCs = [select Id,Consent_Description__c,Consent_Title__c,Project_Country__c,Sequence_Order__c from Project_Country_Regulatory_Consent__c where Project__c =:oldPId];
        List<Project_Country_Regulatory_Consent__c> newPCRCs = new List<Project_Country_Regulatory_Consent__c>();
        for(Project_Country_Regulatory_Consent__c pcrc:oldPCRCs){
            Project_Country_Regulatory_Consent__c newPcrc = pcrc.clone(false,true); 
            newPcrc.Project_Country__c = pcOldIdAndNewIdMap.get(newPcrc.Project_Country__c);
            newPCRCs.add(newPcrc);
        }
        if(newPCRCs.size() > 0)
            insert newPCRCs;
    }
    
    private static void clonePCPatientParameter(String oldPId, Map<String,String> pcOldIdAndNewIdMap){
        List<Project_Country_Patient_Parameter__c> oldPCPPs = [select Id,Business_Rule__c,First__c,Parameter_Name__c,Picklist_Options__c,Project_Country__c,Repeat__c,Response_Type__c,Display_Order__c from Project_Country_Patient_Parameter__c where Project__c =:oldPId];
        List<Project_Country_Patient_Parameter__c> newPCPPs = new List<Project_Country_Patient_Parameter__c>();
        for(Project_Country_Patient_Parameter__c pcpp:oldPCPPs){
            Project_Country_Patient_Parameter__c newPcpp = pcpp.clone(false,true); 
            newPcpp.Project_Country__c = pcOldIdAndNewIdMap.get(newPcpp.Project_Country__c);
            newPCPPs.add(newPcpp);
        }
        if(newPCPPs.size() > 0)
            insert newPCPPs;
        Map<String,String> pcppiOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPCPPs.size();i++){
            pcppiOldIdAndNewIdMap.put(oldPCPPs.get(i).Id, newPCPPs.get(i).Id);
        }
        clonePCPatientParameterDisplayRules(oldPId,pcppiOldIdAndNewIdMap);
    }
    
    private static void clonePCPatientParameterDisplayRules(String oldPId, Map<String,String> pcppiOldIdAndNewIdMap){
        List<Proj_Country_Patient_Para_Display_Rule__c> oldPCEDRs = [select Id,Project_Country_Patient_Parameter__c, When_Answer_Is__c, Display_Rule_Applied_On__c from Proj_Country_Patient_Para_Display_Rule__c where Project_Country_Patient_Parameter__r.Project__c =:oldPId];
        List<Proj_Country_Patient_Para_Display_Rule__c> newPCEDRs = new List<Proj_Country_Patient_Para_Display_Rule__c>();
        for(Proj_Country_Patient_Para_Display_Rule__c pcedr:oldPCEDRs){
            Proj_Country_Patient_Para_Display_Rule__c newPcedr = pcedr.clone(false,true); 
            newPcedr.Project_Country_Patient_Parameter__c = pcppiOldIdAndNewIdMap.get(newPcedr.Project_Country_Patient_Parameter__c);
            newPcedr.Display_Rule_Applied_On__c = pcppiOldIdAndNewIdMap.get(newPcedr.Display_Rule_Applied_On__c);
            newPCEDRs.add(newPcedr);
        }
        if(newPCEDRs.size() > 0)
            insert newPCEDRs;
    }
    
    
    private static void clonePCEligibility(String oldPId, Map<String,String> pcOldIdAndNewIdMap){
        List<Project_Country_Eligibility__c> oldPCEs = [select Id,Business_Rule__c,Compulsary_Question__c,Eligibility_Type__c,First__c,Picklist_Options__c,Project_Country__c,Question__c,Repeat__c,Response_Type__c,Display_Order__c from Project_Country_Eligibility__c where Project__c =:oldPId];
        system.debug(oldPCEs.size());
        system.debug(oldPId);
        List<Project_Country_Eligibility__c> newPCEs = new List<Project_Country_Eligibility__c>();
        for(Project_Country_Eligibility__c pce:oldPCEs){
            Project_Country_Eligibility__c newPce = pce.clone(false,true); 
            newPce.Project_Country__c = pcOldIdAndNewIdMap.get(newPce.Project_Country__c);
            newPCEs.add(newPce);
        }
        if(newPCEs.size() > 0)
            insert newPCEs;
        Map<String,String> pceOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPCEs.size();i++){
            pceOldIdAndNewIdMap.put(oldPCEs.get(i).Id, newPCEs.get(i).Id);
        }
        clonePCDisplayRules(oldPId,pceOldIdAndNewIdMap);
        
    }
    
    private static void clonePCDisplayRules(String oldPId, Map<String,String> pceOldIdAndNewIdMap){
        List<Project_Country_Eligibility_Display_Rule__c> oldPCEDRs = [select Id,Project_Country_Eligibility__c, When_Answer_Is__c, Display_Rule_Applied_On__c from Project_Country_Eligibility_Display_Rule__c where Project_Country_Eligibility__r.Project__c =:oldPId];
        List<Project_Country_Eligibility_Display_Rule__c> newPCEDRs = new List<Project_Country_Eligibility_Display_Rule__c>();
        for(Project_Country_Eligibility_Display_Rule__c pcedr:oldPCEDRs){
            Project_Country_Eligibility_Display_Rule__c newPcedr = pcedr.clone(false,true); 
            newPcedr.Project_Country_Eligibility__c = pceOldIdAndNewIdMap.get(newPcedr.Project_Country_Eligibility__c);
            newPcedr.Display_Rule_Applied_On__c = pceOldIdAndNewIdMap.get(newPcedr.Display_Rule_Applied_On__c);
            newPCEDRs.add(newPcedr);
        }
        if(newPCEDRs.size() > 0)
            insert newPCEDRs;
    }
    
    private static void clonePCSupportingInfo(String oldPId, Map<String,String> pcOldIdAndNewIdMap){
        List<Project_Country_Supporting_Information__c> oldPCSIs = [select Id,Business_Rule__c,Compulsory_Question__c,First__c,Parameter_Name__c,Picklist_Options__c,Project_Country__c,Repeat__c,Response_Type__c,Display_Order__c from Project_Country_Supporting_Information__c where Project__c =:oldPId];
        List<Project_Country_Supporting_Information__c> newPCSIs = new List<Project_Country_Supporting_Information__c>();
        for(Project_Country_Supporting_Information__c pcsi:oldPCSIs){
            Project_Country_Supporting_Information__c newPcsi = pcsi.clone(false,true); 
            newPcsi.Project_Country__c = pcOldIdAndNewIdMap.get(newPcsi.Project_Country__c);
            newPCSIs.add(newPcsi);
        }
        if(newPCSIs.size() > 0)
            insert newPCSIs;
        Map<String,String> pcsiOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPCSIs.size();i++){
            pcsiOldIdAndNewIdMap.put(oldPCSIs.get(i).Id, newPCSIs.get(i).Id);
        }
        clonePCSupportingInfoDisplayRules(oldPId,pcsiOldIdAndNewIdMap);
    }
    
    private static void clonePCSupportingInfoDisplayRules(String oldPId, Map<String,String> pcsiOldIdAndNewIdMap){
        List<Country_SupportingInfo_Req_Display_Rule__c> oldPCSIs = [select Id,Country_Supporting_Info_Requrement__c, When_Answer_Is__c, Display_Rule_Applied_On__c from Country_SupportingInfo_Req_Display_Rule__c where Country_Supporting_Info_Requrement__r.Project__c =:oldPId];
        List<Country_SupportingInfo_Req_Display_Rule__c> newPCSIs = new List<Country_SupportingInfo_Req_Display_Rule__c>();
        for(Country_SupportingInfo_Req_Display_Rule__c pcsidr:oldPCSIs){
            Country_SupportingInfo_Req_Display_Rule__c newPcedr = pcsidr.clone(false,true); 
            newPcedr.Country_Supporting_Info_Requrement__c = pcsiOldIdAndNewIdMap.get(newPcedr.Country_Supporting_Info_Requrement__c);
            newPcedr.Display_Rule_Applied_On__c = pcsiOldIdAndNewIdMap.get(newPcedr.Display_Rule_Applied_On__c);
            newPCSIs.add(newPcedr);
        }
        if(newPCSIs.size() > 0)
            insert newPCSIs;
    }
    
    private static void clonePCCountryIndication(String oldPId, Map<String,String> pcOldIdAndNewIdMap){
        List<Project_Country_Indication__c> oldPCIs = [select Id,Description__c,Indication__c,Project_Country__c from Project_Country_Indication__c where ProjectRecordID__c =:oldPId];
        List<Project_Country_Indication__c> newPCIs = new List<Project_Country_Indication__c>();
        for(Project_Country_Indication__c pci:oldPCIs){
            Project_Country_Indication__c newPci = pci.clone(false,true); 
            newPci.Project_Country__c = pcOldIdAndNewIdMap.get(newPci.Project_Country__c);
            newPCIs.add(newPci);
            
        }
        if(newPCIs.size() > 0)
            insert newPCIs;
        Map<String,String> pciOldIdAndNewIdMap = new Map<String,String>();
        for(Integer i = 0;i < oldPCIs.size();i++){
            pciOldIdAndNewIdMap.put(oldPCIs.get(i).Id, newPCIs.get(i).Id);
        }
        clonePCIndicationDosing(oldPId,pciOldIdAndNewIdMap);
    } 
    
    private static void clonePCIndicationDosing(String oldPId, Map<String,String> pciOldIdAndNewIdMap){
        List<Project_Country_Indication_Dosing__c> oldPCIDs = [Select Id, Can_be_overridden_by_HCP__c,Default_Quantity__c,Strength__c,Description__c,Project_Country_Indication__c from Project_Country_Indication_Dosing__c where Project_Country_Indication__r.Project_Country__r.Project__c =:oldPId];
        List<Project_Country_Indication_Dosing__c> newPCIDs = new List<Project_Country_Indication_Dosing__c>();
        for(Project_Country_Indication_Dosing__c pcid:oldPCIDs){
            Project_Country_Indication_Dosing__c newPcid = pcid.clone(false,true); 
            newPcid.Project_Country_Indication__c = pciOldIdAndNewIdMap.get(newPcid.Project_Country_Indication__c);
            newPCIDs.add(newPcid);
            
        }
        if(newPCIDs.size() > 0)
            insert newPCIDs;
    }
    
    private static void cloneFilesFromOldProjectToNew(String oldProjectId ,String newProjectId ){
        Set<ID> fileIDs = new Set<ID>();
        List<ContentDocumentLink> toBeClonedContentDocumentLinks = [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink WHERE LinkedEntityId=:oldProjectId];
        for(ContentDocumentLink cdl : toBeClonedContentDocumentLinks){
            fileIDs.add(cdl.ContentDocumentId);
        }
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title, VersionData FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        List<ContentVersion> listCV = new List<ContentVersion>();
        for (ContentVersion docLink : docs) {
            ContentVersion cv = new ContentVersion();
            cv.VersionData = docLink.VersionData ;
            cv.Title = docLink.Title;
            cv.PathOnClient = docLink.Title + '.' + docLink.FileExtension;
            listCV.add(cv);
        }
        insert listCV;
        List<ContentDocumentLink> listContentDocumentLink = new List<ContentDocumentLink>();
        Map<Id, ContentVersion> docConventVersion = new Map<Id,ContentVersion>([Select Id, ContentDocumentId From ContentVersion where id in :listCV]);
        for (ContentVersion conVer : listCV) {
            ContentVersion contentVersion = docConventVersion.get(conVer.Id);
            ContentDocumentLink objCDL = new ContentDocumentLink(
                ContentDocumentId = contentVersion.ContentDocumentId,
                LinkedEntityId = newProjectId,
                Visibility = 'AllUsers',
                ShareType = 'V'
            );
            
            listContentDocumentLink.add(objCDL);
            
        }
        insert listContentDocumentLink;
    } 
    
    private static void cloneFilesFromOldProjectCountryToNew(List<Project_Country__c> oldPId, List<Project_Country__c> NewProjCountry, Map<String,String> pcOldIdAndNewIdMap){
        List<Project_Country__c> oldPCIs = [select Id from Project_Country__c where Id IN : oldPId];
        Set<Id> Ids = new Set<Id>();
        for(Project_Country__c oldPC : oldPCIs){
            Ids.add(oldPC.Id);
        }
        Set<ID> fileIDs = new Set<ID>();
        List<ContentDocumentLink> toBeClonedContentDocumentLinks = [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink WHERE LinkedEntityId In : Ids];
        Map<String, String> mapContentDocAndEntityID = new MAp<String, String>();
        for(ContentDocumentLink cdl : toBeClonedContentDocumentLinks){
            fileIDs.add(cdl.ContentDocumentId);
            mapContentDocAndEntityID.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
        }
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title, VersionData FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        List<ContentVersion> listCV = new List<ContentVersion>();
        for (ContentVersion docLink : docs) {
            ContentVersion cv = new ContentVersion();
            cv.VersionData = docLink.VersionData ;
            cv.Title = docLink.Title;
            cv.PathOnClient = docLink.Title + '.' + docLink.FileExtension;
            cv.OldContentVersionId__c = docLink.ContentDocumentId;
            listCV.add(cv);
            
        }
        insert listCV;
        
        List<ContentDocumentLink> listContentDocumentLink = new List<ContentDocumentLink>();
        Map<Id, ContentVersion> docConventVersion = new Map<Id,ContentVersion>([Select Id, ContentDocumentId ,OldContentVersionId__c From ContentVersion where id in :listCV]);
        for (ContentVersion conVer : listCV) {
            ContentVersion contentVersion = docConventVersion.get(conVer.Id);
            if(mapContentDocAndEntityID.get(conVer.OldContentVersionId__c)!= null){
                
                ContentDocumentLink objCDL = new ContentDocumentLink(
                    ContentDocumentId = contentVersion.ContentDocumentId,
                    LinkedEntityId = pcOldIdAndNewIdMap.get(mapContentDocAndEntityID.get(conVer.OldContentVersionId__c)), //mapContentDocAndEntityID.get(conVer.OldContentVersionId__c),//;//NewProjCountry[0].Id,
                    Visibility = 'AllUsers',
                    ShareType = 'V'
                );
                
                
                listContentDocumentLink.add(objCDL);
                
            }
            
        }
        insert listContentDocumentLink;
        
        
    } 
    
}