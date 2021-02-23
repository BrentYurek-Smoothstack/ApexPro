trigger OpportunityTrigger on Opportunity (before insert, before update) {
    Set<Id> accountIds = new Set<Id>();
    
    for (Opportunity opp : Trigger.new) {
        if (opp.Amount > 20000) {
            accountIds.add(opp.AccountId);
        }
    }

    List<Account> accounts = [SELECT Is_Gold__c FROM Account WHERE Id IN :accountIds];

    for (Account acc : accounts) {
        acc.Is_Gold__c = true;
    }

    Update accounts;
}