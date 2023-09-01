global class PARSendFollowUpEmailSchedule implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    //Variable Section
    global FINAL String strQuery;
    global List<String> errorMessages = new List<String>();
    
    global PARSendFollowUpEmailSchedule() { 
        this.strQuery = getBatchQuery();
    }
    
    //Returns the Query String to Batch constructor to fetch right records.
    private String getBatchQuery() {
        String strQuery = 'select Id,Requested_By__r.Email,First_Follow_Up__c, Second_Follow_Up__c, Third_Follow_Up__c,Resupply_Due_Date__c,First_Follow_Up_Status__c, Second_Follow_Up_Status__c, Third_Follow_Up_Status__c from Patient_Request__c where Follow_Ups_Not_Requried__c = false and Resupply_Due_Date__c != null and Resupply_Due_Date__c > TODAY and Status__c =\'Delivered\' and (First_Follow_Up__c =TODAY or Second_Follow_Up__c = today or Third_Follow_Up__c = today)'; 
        return strQuery;
    }
    
    //Batch Start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }

    //Batch Execute method calls findCostForWoD method
    global void execute(Database.BatchableContext BC, List<sObject> scopeList) {
        System.debug(LoggingLevel.INFO, '== scopeList size ==' + scopeList.size());
        
        List<Patient_Request__c> parList = (List<Patient_Request__c>) scopeList;
        List<Patient_Request__c> updateParList = new List<Patient_Request__c>();
        if(!parList.isEmpty()) { 
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            String followupEmailTemplateId = System.Label.PARFollowupEmailTemplateId;
            //String PARSecondFollowupEmailTemplateId = System.Label.PARSecondFollowupEmailTemplateId;
            //String PARThirdFollowupEmailTemplateId = System.Label.PARThirdFollowupEmailTemplateId;
            date todayDate = date.today();
            for (Patient_Request__c par : parList)
            {
                system.debug('in par');
                Boolean flag = true;
                Messaging.SingleEmailMessage message = null;
                if(par.First_Follow_Up__c != null && todayDate.isSameDay(par.First_Follow_Up__c) && par.First_Follow_Up_Status__c == null){
                    par.First_Follow_Up_Status__c = 'Completed';
                } else if (par.Second_Follow_Up__c != null && todayDate.isSameDay(par.Second_Follow_Up__c) && par.Second_Follow_Up_Status__c == null){
                    par.Second_Follow_Up_Status__c = 'Completed';
                } else if(par.Third_Follow_Up_Status__c == null){
                    par.Third_Follow_Up_Status__c = 'Completed';
                } else {
                    flag = false;
                }
                if(flag){
                    system.debug('par');
                    updateParList.add(par);
                    message = Messaging.renderStoredEmailTemplate(followupEmailTemplateId, par.Requested_By__c, par.Id);
                    system.debug(message.getTemplateId());
                    //message.setTargetObjectId(par.Requested_By__c); 
                    message.setSaveAsActivity(false);
                    message.setOrgWideEmailAddressId( System.label.OrgWideEmail ); 
                    /*List<String> emailscc = new List<String>();
                    emailscc.add('sumanthsrao@gmail.com');
                    emailscc.add('lokrajahuja@gmail.com');
                    message.setCcAddresses(emailscc);*/
                    mailList.add(Message);
                } 
            }
            if(!mailList.isEmpty()) {
                update updateParList;
                Messaging.sendEmail(mailList);
            }
        }
    }  

    //Batch Finish method for after execution of batch work
    global void finish(Database.BatchableContext BC) { 
        AsyncApexJob aaj = [Select Id, Status, NumberOfErrors, JobItemsProcessed, MethodName, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {aaj.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('JOB Salesforce Send Notification Batch: ' + aaj.Status);
        String bodyText='Total Job Items ' + aaj.TotalJobItems + ' Number of records processed ' + aaj.JobItemsProcessed + ' with '+ aaj.NumberOfErrors + ' failures.\n';
        bodyText += 'Number of Error Messages ' + errorMessages.size() + '\n';
        bodyText += 'Error Message' + String.join(errorMessages, '\n');
        mail.setPlainTextBody(bodyText);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //Method which schedules the ProductDownloadBatch
    global void execute(SchedulableContext sc) {        
        PARSendFollowUpEmailSchedule snInstance = new PARSendFollowUpEmailSchedule();
        ID batchprocessid = Database.executeBatch(snInstance);
    }
}