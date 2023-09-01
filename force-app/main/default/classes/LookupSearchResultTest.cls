@isTest
public class LookupSearchResultTest {
    @isTest
    static void fetchData_Test() {
        Integer numberOfrecords = 1;
        List<Account> createAccountsList = UtilData.createAccountsList(numberOfrecords);
        insert createAccountsList;
        LookupSearchResult testRecord = new LookupSearchResult(createAccountsList[0].Id, 'Account', 'test', 'test', 'test');
        testRecord.getId();
        testRecord.getIcon();
        testRecord.getSObjectType();
        testRecord.getSubtitle();
        testRecord.getTitle();
    }
}