public with sharing class StockItemHandler {
    //AB - added with sharing 
    //AB - call a method for a before insert
    
    public static void stockBeforeInsert(List<Stock_Item__c> newStock){
        //LT - changed form list to set, to force unique values without SOQL query
        //LT - removed SOQL query and restructured for loop to if/else
        Set<String> stockNames = new Set<string>(); 
        for (Stock_Item__c newItem : newStock) {
            if (stockNames.contains(newItem.Name)) {
                newItem.addError('A Stock Item with this name already exists.');
            } else {
                stockNames.add(newItem.Name);
            }
        }
    }
    
    public static void stockAfterDelete(List<Stock_Item__c> itemDeleted, Map<Id, Stock_Item__c> deletedMap){
        
        List<Case> casesToInsert = new List <Case>();
        
        for (Stock_Item__c stockItem : itemDeleted){
            // LT - updated >0 to !=0, with the reasoning that since the field allows for negative values the case should be created anytime the stockItem is deleted when the Stock_on_Hand__c field is non-zero (for example: backlogged or out of stock items with oustanding orders, which could be captured )
            if(stockItem.Stock_on_Hand__C != 0){
                Case c = new Case();
                c.Status = 'New';
                c.OwnerId = stockItem.OwnerId; 
                c.Origin = 'Stock Deletion';
                c.Subject = 'Alert: Item Deleted With Remaining Stock';
                c.Description = 'Stock Item Name: ' + stockItem.Item_Name__c + 
                    ' Stock Item ID:' + stockItem.id +
                    ' Quantity on Hand:' + stockItem.Stock_on_Hand__c; 
                casesToInsert.add(c);
                
            }
        }
        // LT - moved this outside of the for loop to avoid a DML within loop
        insert casesToInsert;
    } 
}
