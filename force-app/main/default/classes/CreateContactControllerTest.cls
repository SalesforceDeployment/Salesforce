@isTest
public with sharing class CreateContactControllerTest {
    @isTest private static void CreateContactTest(){
        System.Test.startTest();
        try{
            //CreateContactController.CreateContactController();
            new CreateContactController().saveContact();
        } catch(Exception ex){}
        System.Test.stopTest();
    }
    @isTest private static void LookupSearchResultTest(){
        System.Test.startTest();
        UserLookupController.search(UserInfo.getFirstName(), null);
        List<LookupSearchResult> results = UserLookupController.search(UserInfo.getFirstName(), new List<String>{UserInfo.getUserId()});
        if(!results.isEmpty()){
            results[0].getId();
            results[0].getIcon();
            results[0].getSObjectType();
            results[0].getSubtitle();
            results[0].getTitle();
        }else{
            LookupSearchResult ls = new LookupSearchResult(null, 'User', null, null, null);
            ls.getId();
            ls.getIcon();
            ls.getSObjectType();
            ls.getSubtitle();
            ls.getTitle();
        }
        System.Test.stopTest();
    }
}