public inherited sharing class ContactTriggerClass {
    @TestVisible
    private static final String primaryContactError = 'Only one contact per account can be the primary contact.';
    
    public static void primaryContactBeforeInsert(List<Contact> contacts){
        Map<Id, Boolean> accountHasNoPrimaryContact = new Map<Id, Boolean>();
        
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                Boolean noPrimaryContact;
                if ((noPrimaryContact = accountHasNoPrimaryContact.get(c.AccountId)) == null) {
                    noPrimaryContact = [SELECT count() FROM Contact WHERE AccountId=:c.AccountId AND PrimaryContact__c=true] == 0;
                    accountHasNoPrimaryContact.put(c.AccountId, noPrimaryContact);
                }
                if (noPrimaryContact) {
                    c.PrimaryContact__c = true;
                    accountHasNoPrimaryContact.put(c.AccountId, false);
                }else if (c.PrimaryContact__c == true) {
                    c.PrimaryContact__c.addError(primaryContactError);
                }
            }
        }
    }

    public static void primaryContactBeforeUpdate(List<Contact> contacts){
        Map<Id, Integer> accountNumPrimaryContacts = new Map<Id, Integer>();
        Map<Id, Id> accountPrimaryContactId = new Map<Id, Id>();
        
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                if (c.PrimaryContact__c == true) {
                    Integer numPrimaryContacts = accountNumPrimaryContacts.get(c.AccountId);
                    if (numPrimaryContacts == null) {
                        numPrimaryContacts = [SELECT count() FROM Contact WHERE AccountId=:c.AccountId AND PrimaryContact__c=true];
                        accountNumPrimaryContacts.put(c.AccountId, numPrimaryContacts);
                    }

                    if (numPrimaryContacts == 0) {
                        accountNumPrimaryContacts.put(c.AccountId, ++numPrimaryContacts);
                        accountPrimaryContactId.put(c.AccountId, c.Id);
                    } else if (numPrimaryContacts == 1) {
                        Id primaryContactId = accountPrimaryContactId.get(c.AccountId);
                        if (primaryContactId == null) {
                            primaryContactId = [SELECT Id FROM Contact WHERE AccountId=:c.AccountId AND PrimaryContact__c=true].Id;
                            accountPrimaryContactId.put(c.AccountId, primaryContactId);
                        }
                        if (primaryContactId != c.Id) {
                            c.PrimaryContact__c.addError(primaryContactError);
                        }
                    } else {
                        c.PrimaryContact__c.addError(primaryContactError);
                    }
                }
            }
        }
    }
}
