trigger OrderItemTrigger on OrderItem__c (after insert) {
    switch on Trigger.operationType {    
        when AFTER_INSERT {
            OrderItemTriggerHandler.onAfterInsert(Trigger.newMap);
        } 
    }
}