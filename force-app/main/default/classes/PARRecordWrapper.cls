//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class PARRecordWrapper {

	public class Answers {
		@AuraEnabled
		public String Id;
		@AuraEnabled
		public String pcPatientParamId; // Project country patient parameter
		@AuraEnabled
		public String answer;
		@AuraEnabled
		public String paramName; // Project country patient parameter
		@AuraEnabled
		public String type; // Project country patient parameter
		@AuraEnabled
		public String answerDisplay; // To display date value 
	}

	@AuraEnabled
	public String Id;
	@AuraEnabled
	public Boolean prePopulate;  // to check if the value is for edit then dont increment the PAtient Id
	@AuraEnabled
	public String patientId;
	@AuraEnabled
	public String createdBy; //to check who created the record in summary page
	@AuraEnabled
	public String onBehalfOf; //to check On Behalf of the record in summary page
	@AuraEnabled
	public String additionalInfoAssignedTo; //to whom the additonal info is assigned in summary page
	@AuraEnabled
	public String medicalReviewSponsors; //to whom the request is assigned for Meidcal Review
	@AuraEnabled
	public String medicalReviewInternal; //to whom the request is assigned for Meidcal Review
	@AuraEnabled
	public String supportingInfomationPhysian; //to whom the request is assigned for supporting Document
	@AuraEnabled
	public String PARAssignedToPAMUser; // To which PAM this request is assigned to get that information
	@AuraEnabled
	public String regulatoryReviewer; // To whom the request is assigned for Regulatory review
	@AuraEnabled
	public Boolean sendTranslation; // Sent_for_Translation__c
	@AuraEnabled
	public Boolean receiveTranslation; // Translation_Received__c
	@AuraEnabled
	public String ownerId;  //   OwnerId
	@AuraEnabled
	public String patientRequestId; //PAtient Request Id
	@AuraEnabled
	public String hospitalId; //PAtient Request
	@AuraEnabled
	public String additionalInformation; //PAtient Request
	@AuraEnabled
	public String hcpid; //On_Behalf_Of__c => contact id
	@AuraEnabled
	public String product; //PAtient Request
	@AuraEnabled
	public String treatmentid; //PAtient Request  project groupid
	@AuraEnabled
	public String indicationid; // PAtient Request  project groupid
	@AuraEnabled
	public String requireDose; // PAtient Request  Required_Dose__c
	@AuraEnabled
	public Decimal patientBSA; // PAtient Request  BSA__c
	@AuraEnabled
	public Boolean step; // PAtient Request  Required_Dose__c
	@AuraEnabled
	public String patientName; // Patient => PAtient Id
	@AuraEnabled
	public String pARpatientId; // PAtient Request => PatientId__c
	@AuraEnabled
	public String status;
	@AuraEnabled
	public String stage;
	@AuraEnabled
	public Boolean confirmConsent = false; //default false
	@AuraEnabled
	public Boolean acceptResponsibility = false; //default false
	@AuraEnabled
	public Decimal savedTabNo; // PAtient Request  Request_Tab_Saved
	@AuraEnabled
	public List<Answers> answers = new List<Answers>();//Initial(s), Date Of Birth and Gender
	@AuraEnabled
	public List<Answers> inclusionEligibilities = new List<Answers>(); //Inclusion Criteria
	@AuraEnabled
	public List<Answers> exclusionEligibilities = new List<Answers>(); //Exclusion Criteria
	@AuraEnabled
	public List<Answers> supportingInformations = new List<Answers>(); //Supporting information
	@AuraEnabled
	public List<Answers> patientParameters = new List<Answers>(); // other questions
	@AuraEnabled
	public DosingDetailsWrapper dosingDetailsWrapper;
	@AuraEnabled
    public DeliveryAddressWrapper deliveryWrapper;
    @AuraEnabled
    public ShippingAddressWrapper shippingWrapper;
    @AuraEnabled
    public List<PatientRequestNotesWrapper> patientRequestNotesWrapper;
	@AuraEnabled
    public List<PatientRequestNotesWrapper> patientRequestOverviewWrapper;
    
    public class DeliveryAddressWrapper {
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String address;
		@AuraEnabled
		public String email;
		@AuraEnabled
		public String telephone;
		@AuraEnabled
		public String fax;
        @AuraEnabled
		public String outOfHours;
		@AuraEnabled
		public String notes;
		@AuraEnabled
		public String hospitalName;
		@AuraEnabled
		public String postalCode;
		@AuraEnabled
		public String country;
	}
    public class ShippingAddressWrapper {
		@AuraEnabled
		public String soNumber;
		@AuraEnabled
		public String trackingNumber;
		@AuraEnabled
		public String dateShipped;
		@AuraEnabled
		public String expectedDeliveryDate;
		@AuraEnabled
		public String dateDelivered;
        @AuraEnabled
		public String otherComments;
	}
    public class PatientRequestNotesWrapper {
        @AuraEnabled
		public string discontinuedOn;
		@AuraEnabled
		public string discontinuedPerformedOn;
		@AuraEnabled
		public String discontinuedBy;
		@AuraEnabled
		public String patientNotes;
        @AuraEnabled
		public String stage;
		@AuraEnabled
		public String status;
        @AuraEnabled
		public String notesType;
    }

	public static PARRecordWrapper parse(String json) {
		return (PARRecordWrapper) System.JSON.deserialize(json, PARRecordWrapper.class);
	}
}