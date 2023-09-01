public class ParentChildRelatedRecords {

    public static void getRelatedRecords(){
        /*set<id> careProductIds = new set<id>();
        List<Care_Products__c> prodList = [select id, name,(select id, name,Care_Product__c from Project_Group__c) 
                                           from Care_Products__c];
        for(Care_Products__c Cprod : prodList){
            careProductIds.add(Cprod.id);
        }
    }*/
    Map<Id, Project_Group__c> mapChildIds = new Map<Id, Project_Group__c>([
        											Select Id, Name, Care_Product__c
        											from Project_Group__c
        											where Care_Product__c != null
        											]);
}
}