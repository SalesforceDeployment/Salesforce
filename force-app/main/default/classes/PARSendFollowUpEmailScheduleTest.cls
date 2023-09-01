@istest
public class PARSendFollowUpEmailScheduleTest {
    
    @isTest
    static void testPatientRequestFollowUpBatch(){
        Date todayDate = Date.today();
		Date resupplyDate = todayDate.addDays(2);
        Patient_Request__c pr = new Patient_Request__c(Status__c = 'Delivered',Resupply_Due_Date__c = resupplyDate, First_Follow_Up__c=todayDate,Requested_By__c=UserInfo.getUserId());
        insert pr;
        Test.startTest();
        PARSendFollowUpEmailSchedule psfe= new PARSendFollowUpEmailSchedule();
        String jobId = System.schedule('myJobTestJobName', '0 0 0 15 3 ?', psfe);
        psfe.execute(null);
        Test.stopTest();
      }

}