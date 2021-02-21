@isTest
public inherited sharing class ContactTriggerTest {
    @TestSetup
    static void makeData(){
        User u = TestDataFactory.createUser();
        Insert u;

        System.runAs(u) {
            Account acc = TestDataFactory.createAccounts(1)[0];
            Insert acc;
            Insert TestDataFactory.createContacts(2, acc.Id);
        }
    }

    private static User getUser() {
        return [SELECT Id,Name FROM User WHERE Username='misterguy@personland.com'];
    }

    @isTest
    public static void autoPrimaryTest(){
        System.runAs(getUser()) {
            Contact c1 = [SELECT PrimaryContact__c FROM Contact WHERE LastName='Test1'];
            System.assert(c1.PrimaryContact__c);
            Contact c2 = [SELECT PrimaryContact__c FROM Contact WHERE LastName='Test2'];
            System.assert(!c2.PrimaryContact__c);
        }
    }

    @isTest
    public static void primaryErrorTest(){
        System.runAs(getUser()) {
            Boolean gotError = false;
            Contact c = [SELECT PrimaryContact__c FROM Contact WHERE PrimaryContact__c=false];
            c.PrimaryContact__c = true;

            try {
                Update c;
            } catch (DmlException e) {
                gotError = true;
                System.assert(e.getMessage().contains('Only one contact per account can be the primary contact.'), e.getMessage());
            }

            System.assert(gotError);
        }
    }

    @isTest
    public static void insertPrimaryErrorTest(){
        
    }
}
