@isTest
private class salesforceBaseRecordUrlCtrlTest {
    @isTest
    static void testsalesforceBaseRecordUrlCtrl() {
        String sURL = '';
	    Test.startTest();
        salesforceBaseRecordUrlCtrl url = new salesforceBaseRecordUrlCtrl();
        //sURL = url.getRecordIdURL();
    	//sURL = url.getPortalBaseURL();
    	url.recordId = 'abc';
        Test.stopTest();    
    }    
}