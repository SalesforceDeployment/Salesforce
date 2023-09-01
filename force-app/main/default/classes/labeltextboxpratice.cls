public with sharing class labeltextboxpratice {
    @AuraEnabled(cacheable=true)
    public static List<String> labelTwoTextbox() {
        List<String> labelList = new List<String>{'Label1', 'Label2', 'Label3', 'Label4', 'Label5'};
        System.debug(labelList);
        return labelList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> checkBoxValues() {
        List<String> checkboxList = new List<String>{'Male', 'Female'};
        System.debug(checkboxList);
        return checkboxList;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getDropdownValues() {
        
        return new List<String>{'India', 'USA', 'Canada'};
    }
}