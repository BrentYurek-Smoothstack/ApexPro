public inherited sharing class TestDataFactory {
    public static Opportunity createOpportunity(Id AccountId) {
        return new Opportunity(
            AccountId = AccountId,
            Name = 'Test',
            CloseDate = Date.newInstance(2021, 2, 11),
            StageName = 'Needs Analysis'
       );
    }

    public static List<Account> createAccounts(Integer num) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 1; i <= num; i++) {
            accounts.add(new Account(Name='Test'+i));
        }
        return accounts;
    }

    public static List<Contact> createContacts(Integer num, Id AccountId) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= num; i++) {
            contacts.add(new Contact(LastName='Test'+i, AccountId=AccountId));
        }
        return contacts;
    }

    public static List<Contact> createContacts(Integer num) {
        return createContacts(num, null);
    }

    public static Lead createLead() {
        return new Lead(LastName='Test', Company='Test', Status='Open - Not Contacted');
    }

    public static Task createTask() {
        return new Task(Subject='Test', Priority='Normal', Status='Not Started');
    }

    public static List<Case> createCases(Integer num) {
        List<Case> cases = new List<Case>();
        for (Integer i = 1; i <= num; i++) {
            cases.add(new Case(Subject='Test'+i, Status='New', Origin='Email'));
        }
        return cases;
    }

    public static User createUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        return new User(LastName = 'Guy',
                        FirstName='Mister',
                        Alias = 'mguy',
                        Email = 'misterguy@personland.com',
                        Username = 'misterguy@personland.com',
                        ProfileId = p.Id,
                        TimeZoneSidKey = 'GMT',
                        LanguageLocaleKey = 'en_US',
                        EmailEncodingKey = 'UTF-8',
                        LocaleSidKey = 'en_US'
                        );
    }
}