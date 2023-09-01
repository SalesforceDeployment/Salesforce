public without sharing class DynamicQuestionsController {

    @AuraEnabled(cacheable=true)
    public static List<DynamicQuestionsWrapper> getPatientParameters(String indicationid,String objectname,String condition, String country, Boolean newPatient){
        system.debug('inside 5==>');
        List<DynamicQuestionsWrapper> questionWrappers = new List<DynamicQuestionsWrapper>();
        String userId = UserInfo.getUserId();
        // String userId ='0052z000004StgXAAS';
        Project_Country_Indication__c pi = [select Project__c,Project_Country__r.Project__c from Project_Country_Indication__c where id = :indicationId];
        String projectid = pi.Project_Country__r.Project__c;
        //User u= [select id,name,Contact.Account.Institution_Country__c from user where id= :userId];
        // String country = u.Contact.Account.Institution_Country__c;
        System.debug('objectname' + objectname);
        System.debug('condition' + condition);
        String newChecking = null;
        if(newPatient)
        {
            newChecking = ' and First__c = true';
        } else{
            newChecking = ' and Repeat__c = true';
        }
        String fields =null;
        if(objectname == 'Project_Country_Eligibility__c'){
            fields= ',Question__c,Eligibility_Type__c,Compulsary_Question__c';
        } else {
            fields = ',Parameter_Name__c';
        }
        String query = 'select Id, Business_Rule__c,First__c, Picklist_Options__c, Project_Country__c, Repeat__c, Response_Type__c'+fields+' from '+objectname+' where Response_Type__c != null and Project_Country__r.Project__c =:projectid and Project_Country__r.Country__c	= :country' + newChecking;
        if(condition != null && condition != ''){
            query += ' and ' + condition;
        }
        query += ' ORDER BY Display_Order__c ASC, CreatedDate ASC';
        List<sObject> paramList = Database.query(query);
        System.debug('paramList' + paramList);
        for(sObject param: paramList){
            DynamicQuestionsWrapper dqw = new DynamicQuestionsWrapper();
            if((String)param.get('Business_Rule__c') == 'Number: Must be greater than 0'){
                dqw.min =1;
            } else if((String)param.get('Business_Rule__c') == 'Maximum Text length is 4 Characters'){
                dqw.maxLength = 4;
            } else if((String)param.get('Business_Rule__c') == 'Calender:Date should not be future date'){
                dqw.maxDate = system.today();
            }
            dqw.pcPatientParamId = (String)param.get('Id');
            if(objectname == 'Project_Country_Eligibility__c'){
                dqw.paramName = (String)param.get('Question__c');
                dqw.isRequired = (Boolean)param.get('Compulsary_Question__c');
                dqw.category = (String)param.get('Eligibility_Type__c');
            } else {
                dqw.paramName = (String)param.get('Parameter_Name__c');
            }
            dqw.responseType = (String)param.get('Response_Type__c');

            if(dqw.responseType == 'picklist' || dqw.responseType == 'Picklist' || dqw.responseType.equalsIgnoreCase('Single Select') || 'Multi Select'.equalsIgnoreCase(dqw.responseType) || 'MultiSelect'.equalsIgnoreCase(dqw.responseType)){
                if('Multi Select'.equalsIgnoreCase(dqw.responseType) || 'MultiSelect'.equalsIgnoreCase(dqw.responseType)){
                    dqw.isMultiSelectPicklist = true;
                } else {
                    dqw.isPicklist = true;
                }
                String picklistValues = (String)param.get('Picklist_Options__c');
                List<String> picklistOptions = picklistValues.split(';');
                List<DynamicQuestionsWrapper.PicklistOptions> options = new List<DynamicQuestionsWrapper.PicklistOptions>();
                for(String value: picklistOptions){
                    DynamicQuestionsWrapper.PicklistOptions option = new DynamicQuestionsWrapper.PicklistOptions();
                    option.label = value;
                    option.value = value;
                    options.add(option);
                }
                dqw.options = options;
            }
            if(dqw.responseType == 'richtext' || dqw.responseType == 'Richtext'){
                dqw.isRichText = true;
            }
            questionWrappers.add(dqw);
        }
        return questionWrappers;
    }

    // New Method to show question based on display rule
    @AuraEnabled(cacheable=true)
    public static List<DynamicQuestionsWrapper> getDisplayRuleQuestions(String indicationid,String objectname,String condition, String country, Boolean newPatient){
        system.debug('dnjfj');
        List<DynamicQuestionsWrapper> questionWrappers = new List<DynamicQuestionsWrapper>();
        String userId = UserInfo.getUserId();
        // String userId ='0052z000004StgXAAS';
        Project_Country_Indication__c pi = [select Project__c,Project_Country__r.Project__c from Project_Country_Indication__c where id = :indicationId];
        String projectid = pi.Project_Country__r.Project__c;
        //User u= [select id,name,Contact.Account.Institution_Country__c from user where id= :userId];
        // String country = u.Contact.Account.Institution_Country__c;
        System.debug('objectname' + objectname);
        System.debug('condition' + condition);
        String newChecking = null;
        system.debug('???newPatient');
        system.debug(newPatient);
        if(newPatient)
        {
            newChecking = ' and First__c = true';
        } else{
            newChecking = ' and Repeat__c = true';
        }
        String fields =null;
        if(objectname == 'Project_Country_Eligibility__c'){
            fields= ',Question__c,Eligibility_Type__c,Compulsary_Question__c';
        } else if(objectname == 'Project_Country_Supporting_Information__c'){
            fields = ',Compulsory_Question__c,Parameter_Name__c';
        }else {
            fields = ',Parameter_Name__c';
        }
        String query = 'select Id,Display_Order__c, Business_Rule__c,First__c, Picklist_Options__c, Project_Country__c, Repeat__c, Response_Type__c'+fields+' from '+objectname+' where Response_Type__c != null and Project_Country__r.Project__c =:projectid and Project_Country__r.Country__c	= :country' + newChecking;
        if(condition != null && condition != ''){
            query += ' and ' + condition;
        }
        query += ' ORDER BY Display_Order__c ASC, CreatedDate ASC';
        List<sObject> paramList = Database.query(query);
        System.debug('paramList' + paramList);
        List<String> paramIds = new List<String>();
        for(sObject obj: paramList){
            paramIds.add((String)obj.get('Id'));
        }

        Map<String, List<DynamicQuestionsWrapper.Rules>> pceDisplayRuleMap = new Map<String, List<DynamicQuestionsWrapper.Rules>>();
        if(objectname == 'Project_Country_Eligibility__c'){
            List<Project_Country_Eligibility_Display_Rule__c> pceDisplayRules =  [select Id,When_Answer_Is__c, Project_Country_Eligibility__c, Display_Rule_Applied_On__c from Project_Country_Eligibility_Display_Rule__c where Display_Rule_Applied_On__c in :paramIds];
            for(Project_Country_Eligibility_Display_Rule__c pcedr: pceDisplayRules){
                List<DynamicQuestionsWrapper.Rules> displayRules = null;
                if(pceDisplayRuleMap.containskey(pcedr.Display_Rule_Applied_On__c)){
                    displayRules = pceDisplayRuleMap.get(pcedr.Display_Rule_Applied_On__c);
                } else {
                    displayRules = new List<DynamicQuestionsWrapper.Rules>();
                    pceDisplayRuleMap.put(pcedr.Display_Rule_Applied_On__c,displayRules);
                }
                DynamicQuestionsWrapper.Rules rule =  new DynamicQuestionsWrapper.Rules();
                rule.id = pcedr.Id;
                rule.question = pcedr.Project_Country_Eligibility__c;
                rule.answer = pcedr.When_Answer_Is__c;
                //rule.conditionRequirement = pcedr.Condition_Requirement__c;
                displayRules.add(rule);
            }
        } else if(objectname == 'Project_Country_Patient_Parameter__c'){
            system.debug(paramIds);
            system.debug('???');
            List<Proj_Country_Patient_Para_Display_Rule__c> pceDisplayRules =  [select Id,When_Answer_Is__c,Project_Country_Patient_Parameter__c, Display_Rule_Applied_On__c from Proj_Country_Patient_Para_Display_Rule__c where Display_Rule_Applied_On__c in :paramIds];
            for(Proj_Country_Patient_Para_Display_Rule__c pcedr: pceDisplayRules){
                List<DynamicQuestionsWrapper.Rules> displayRules = null;
                if(pceDisplayRuleMap.containskey(pcedr.Display_Rule_Applied_On__c)){
                    displayRules = pceDisplayRuleMap.get(pcedr.Display_Rule_Applied_On__c);
                } else {
                    displayRules = new List<DynamicQuestionsWrapper.Rules>();
                    pceDisplayRuleMap.put(pcedr.Display_Rule_Applied_On__c,displayRules);
                }
                DynamicQuestionsWrapper.Rules rule =  new DynamicQuestionsWrapper.Rules();
                rule.id = pcedr.Id;
                rule.question = pcedr.Project_Country_Patient_Parameter__c;
                rule.answer = pcedr.When_Answer_Is__c;
                //rule.conditionRequirement = pcedr.Condition_Requirement__c;
                displayRules.add(rule);
            }
        } else if(objectname == 'Project_Country_Supporting_Information__c'){
                List<Country_SupportingInfo_Req_Display_Rule__c> pceDisplayRules =  [select Id,When_Answer_Is__c,Country_Supporting_Info_Requrement__c, Display_Rule_Applied_On__c from Country_SupportingInfo_Req_Display_Rule__c where Display_Rule_Applied_On__c in :paramIds];
                for(Country_SupportingInfo_Req_Display_Rule__c pcedr: pceDisplayRules){
                    List<DynamicQuestionsWrapper.Rules> displayRules = null;
                    if(pceDisplayRuleMap.containskey(pcedr.Display_Rule_Applied_On__c)){
                        displayRules = pceDisplayRuleMap.get(pcedr.Display_Rule_Applied_On__c);
                    } else {
                        displayRules = new List<DynamicQuestionsWrapper.Rules>();
                        pceDisplayRuleMap.put(pcedr.Display_Rule_Applied_On__c,displayRules);
                    }
                    DynamicQuestionsWrapper.Rules rule =  new DynamicQuestionsWrapper.Rules();
                    rule.id = pcedr.Id;
                    rule.question = pcedr.Country_Supporting_Info_Requrement__c;
                    rule.answer = pcedr.When_Answer_Is__c;
                    //rule.conditionRequirement = pcedr.Condition_Requirement__c;
                    displayRules.add(rule);
                }
        }
        for(sObject param: paramList){
            DynamicQuestionsWrapper dqw = new DynamicQuestionsWrapper();
            dqw.Id = (String)param.get('Id');
            if(param.get('Display_Order__c') != null)
                dqw.sequence = Integer.valueOf(param.get('Display_Order__c'));
            if((String)param.get('Business_Rule__c') == 'Number: Must be greater than 0'){
                dqw.min =1;
            } else if((String)param.get('Business_Rule__c') == 'Maximum Text length is 4 Characters'){
                dqw.maxLength = 4;
            } else if((String)param.get('Business_Rule__c') == 'Calender:Date should not be future date'){
                dqw.maxDate = system.today();
            }
            dqw.pcPatientParamId = (String)param.get('Id');
            if(objectname == 'Project_Country_Eligibility__c'){
                dqw.paramName = (String)param.get('Question__c');
                dqw.isRequired = (Boolean)param.get('Compulsary_Question__c');
                dqw.category = (String)param.get('Eligibility_Type__c');
            } else if(objectname == 'Project_Country_Supporting_Information__c'){
                dqw.isRequired = (Boolean)param.get('Compulsory_Question__c');
                dqw.paramName = (String)param.get('Parameter_Name__c');
            }
            else {
                dqw.paramName = (String)param.get('Parameter_Name__c');
            }
            dqw.responseType = (String)param.get('Response_Type__c');

            if(dqw.responseType == 'picklist' || dqw.responseType == 'Picklist' || dqw.responseType.equalsIgnoreCase('Single Select') || 'Multi Select'.equalsIgnoreCase(dqw.responseType) || 'MultiSelect'.equalsIgnoreCase(dqw.responseType)){
                if('Multi Select'.equalsIgnoreCase(dqw.responseType) || 'MultiSelect'.equalsIgnoreCase(dqw.responseType)){
                    dqw.isMultiSelectPicklist = true;
                } else {
                    dqw.isPicklist = true;
                }
                String picklistValues = (String)param.get('Picklist_Options__c');
                List<String> picklistOptions = picklistValues.split(';');
                List<DynamicQuestionsWrapper.PicklistOptions> options = new List<DynamicQuestionsWrapper.PicklistOptions>();
                for(String value: picklistOptions){
                    DynamicQuestionsWrapper.PicklistOptions option = new DynamicQuestionsWrapper.PicklistOptions();
                    option.label = value;
                    option.value = value;
                    options.add(option);
                }
                dqw.options = options;
            }
            if(dqw.responseType == 'richtext' || dqw.responseType == 'Richtext'){
                dqw.isRichText = true;
            }
            dqw.rules = pceDisplayRuleMap.get((String)param.get('Id'));
            questionWrappers.add(dqw);
        }
        return questionWrappers;
    }
}