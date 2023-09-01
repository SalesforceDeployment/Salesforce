public with sharing class adminSupportingDetails {
    @AuraEnabled(cacheable=true)
        public static Map<ID, String> getadminRelatedFilesByRecordId(String recordId) {
            // Get record file IDs    
            System.debug('Supporting recordId'+recordId);    
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
            return mapIdTitle;
        }
    
     @AuraEnabled(cacheable=true)
     public static list<ID> getfileIds(String recordId) {
            // Get record file IDs    
            System.debug('Supporting recordId'+recordId);    
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
           list<id> ctnlist = new list<id>();
            for (ContentVersion docLink : docs) {
                ctnlist.add(docLink.ContentDocumentId);
            }
            return ctnlist;
        }
}