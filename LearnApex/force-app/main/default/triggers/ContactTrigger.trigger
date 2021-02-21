trigger ContactTrigger on Contact (before insert, before update) {
    if (Trigger.isBefore && Trigger.isInsert){
        ContactTriggerClass.primaryContactBeforeInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate){
        ContactTriggerClass.primaryContactBeforeUpdate(Trigger.new);
    }
}