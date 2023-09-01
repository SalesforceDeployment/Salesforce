public class DynamicQuestionsWrapper {
    public DynamicQuestionsWrapper() {

    }
    @AuraEnabled
    public String Id;
    @AuraEnabled
    public Boolean isPicklist = false;
    @AuraEnabled
    public Boolean isRichText = false;
    @AuraEnabled
    public Boolean isMultiSelectPicklist = false;
    @AuraEnabled
    public String paramName;
    @AuraEnabled
    public Integer min;
    @AuraEnabled
    public Integer maxLength;
    @AuraEnabled
    public Date maxDate;
    @AuraEnabled
    public String responseType;
    @AuraEnabled
    public String category;
    @AuraEnabled
    public Boolean isRequired=true;
    @AuraEnabled
    public String pcPatientParamId;
    @AuraEnabled
    public Integer sequence;
    @AuraEnabled
    public List<PicklistOptions> options;
    @AuraEnabled
    public List<Rules> rules;

    public class PicklistOptions{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }

    public class Rules{
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String question;
        @AuraEnabled
        public String answer;
        @AuraEnabled
        public string conditionRequirement;
    }
}