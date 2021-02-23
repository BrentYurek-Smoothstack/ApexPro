@isTest
public inherited sharing class OpportunityTriggerTest {
    @TestSetup
    static void makeData(){
        Insert TestDataFactory.createAccounts(2);
    }

    @isTest
    static void makeGoldTest(){
        Account acc = [SELECT Id FROM Account WHERE Name='Test1'];
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        opp.Amount = 20001;
        Insert opp;
        acc = [SELECT Id, Is_Gold__c FROM Account WHERE Id=:acc.Id];
        System.assert(acc.Is_Gold__c);
    }

    @isTest
    static void makeGoldBatchTest(){
        List<Account> accounts = [SELECT Id FROM Account];
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account acc : accounts) {
            Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
            opp.Amount = 20001;
            opportunities.add(opp);
        }
        Insert opportunities;
        accounts = [SELECT Id, Is_Gold__c FROM Account];
        for (Account acc : accounts) {
            System.assert(acc.Is_Gold__c);
        }
    }
}
