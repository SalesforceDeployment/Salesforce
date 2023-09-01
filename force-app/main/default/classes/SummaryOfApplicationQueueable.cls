public without sharing class SummaryOfApplicationQueueable implements Queueable, Database.AllowsCallouts {
    public string jsonString;
    public SummaryOfApplicationQueueable(String jsonString) {
        this.jsonString = jsonString;
    }
    public void execute(QueueableContext context) {
        Map<String, Object> patientObject = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug('inside 7-->'+patientObject);
        system.debug('inside 9-->'+string.valueOf(patientObject.get('isPii')));
        PageReference pdfPage = Page.SummaryOfApplication;
        pdfPage.getParameters().put('currentRecordId', string.valueOf(patientObject.get('patientReqId')));
        pdfPage.getParameters().put('isStep7', string.valueOf(patientObject.get('isStep7')));
        pdfPage.getParameters().put('isPii', string.valueOf(patientObject.get('isPii')));
        pdfPage.getParameters().put('isTC', string.valueOf(patientObject.get('isTC')));
        pdfPage.getParameters().put('projectGroup', string.valueOf(patientObject.get('projectGroup')));
        pdfPage.getParameters().put('projectCountry', string.valueOf(patientObject.get('projectCountry')));
        pdfPage.getParameters().put('isReviewer', string.valueOf(patientObject.get('isReviewer')));
        system.debug('userdata-->'+userinfo.getFirstName());
        blob pdfBody;
        if (!Test.isRunningTest()) {
            pdfBody = pdfPage.getContentAsPDF();
        } else{
            pdfBody = Blob.valueof('For test class');
        } 
        system.debug('blob-->'+pdfBody);
        ContentVersion CV = new ContentVersion();
        CV.Title = 'PatientAccessRequest.pdf';
        CV.PathOnClient = 'PatientAccessRequest.pdf';
        CV.VersionData = pdfBody;
        insert CV;
        system.debug('inside cv-->'+cv.Id);
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
            LinkedEntityId = string.valueOf(patientObject.get('patientReqId')),
            ContentDocumentId = conDoc,
            shareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentDocumentLink;
    }
}