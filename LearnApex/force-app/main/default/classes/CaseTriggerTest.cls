@isTest
public inherited sharing class CaseTriggerTest {
    @TestSetup
    public static void makeData(){
        Insert TestDataFactory.createUser();
    }

    @isTest
    public static void testLimit(){
        Integer caseLimit = (Integer)[SELECT Cases_Allowed_Per_Month__c FROM Case_Limit__mdt WHERE MasterLabel='Standard' LIMIT 1].Cases_Allowed_Per_Month__c;
        Boolean gotError = false;
        User u = [SELECT Id,Name FROM User WHERE Username='misterguy@personland.com'];
        System.runAs(u) {
            try {
                Insert TestDataFactory.createCases(caseLimit + 1);
            } catch (DmlException e) {
                gotError = true;
                System.assert(e.getMessage().contains(caseLimit + ' cases already created this month for user ' + u.Name + ' (' + u.Id + ').'), e.getMessage());
            }
        }
        System.assert(gotError);
    }
}
