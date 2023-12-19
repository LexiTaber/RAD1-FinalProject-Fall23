trigger StockItemTrigger on Stock_Item__c (before insert, before delete, after delete) {

    //Instantiate StockItemHandler
    

    //Before Insert Handling
    if(Trigger.isInsert && Trigger.isBefore) {
        StockItemHandler.stockBeforeInsert(Trigger.new);
        //call the class in your handler for before insert
    }
    //After Delete Handling
    if(Trigger.isDelete && Trigger.isAfter) {
        StockItemHandler.stockAfterDelete(Trigger.old, Trigger.oldMap);

        //call the class in your handler for before delete
    }

    //Before Delete Handling
    if(Trigger.isDelete && Trigger.isBefore) {

        //call the class in your handler for before delete
    }


}
