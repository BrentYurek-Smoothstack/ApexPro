trigger CaseTrigger on Case (before insert) {
    Map<Id, Integer> ownerNumCases = new Map<Id, Integer>();
    Integer caseLimit = (Integer)[SELECT Cases_Allowed_Per_Month__c FROM Case_Limit__mdt WHERE MasterLabel='Standard' LIMIT 1].Cases_Allowed_Per_Month__c;
    for (Case c : Trigger.new) {
        //get the number of cases for the owner
        Integer numCases = ownerNumCases.get(c.OwnerId);
        if (numCases == null) {
            numCases = [SELECT count() FROM Case WHERE OwnerId=:c.OwnerId AND CreatedDate=THIS_MONTH];
        }

        //add a case to that number
        ownerNumCases.put(c.OwnerId, ++numCases);

        //check if the number of cases is greater than the limit and act accordingly
        if (numCases > caseLimit) {
            User u = [SELECT Id, Name FROM User WHERE Id=:c.OwnerId];
            c.AddError(caseLimit + ' cases already created this month for user ' + u.Name + ' (' + u.Id + ').');
        }
    }
}