trigger StockItemTrigger on Stock_Item__c (before insert, before delete) {
    
    //Instantiate StockItemHandler
    
    //Before Insert Handling
    if(Trigger.isInsert && Trigger.isBefore) {
        StockItemHandler.stockBeforeInsert(Trigger.new);
        //call the class in your handler for before insert
    }
    
    //Before Delete Handling
    if(Trigger.isDelete && Trigger.isBefore) {
        StockItemHandler.stockBeforeDelete(Trigger.old, Trigger.oldMap);
        //call the class in your handler for before delete
    }
    
    
}
