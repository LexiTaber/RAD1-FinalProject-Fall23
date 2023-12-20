public with sharing class StockItemHandler {
    //AB - added with sharing 
    //AB - call a method for a before insert
    
    public static void stockBeforeInsert(List<Stock_Item__c> newStock){
        Set<String> stockNames = new Set<string>(); 
        for (Stock_Item__c existingStock : [
            SELECT Item_Name__c FROM Stock_Item__c]){
                stockNames.add(existingStock.Item_Name__c);
            }
        for (Stock_Item__c newItem: newStock){  
            if (stockNames.contains(newItem.Item_Name__c)) {
                //changed the name change to addError to prevent duplicative records from being created
                newItem.addError('A Stock Item with this name already exists.');
                System.debug('Duplicate found for ' + newItem.Item_Name__c);
            } else {
                stockNames.add(newItem.Item_Name__c);
            }
        }
    }
    
    public static void stockBeforeDelete(List<Stock_Item__c> itemDeleted, Map<Id, Stock_Item__c> deletedMap){
        \\AB - renamed to stockBeforeDelete 
        List<Case> casesToInsert = new List <Case>();
        
        for (Stock_Item__c stockItem : itemDeleted){
            /* LT - updated >0 to !=0. Negative values are currently not allowed  with the reasoning that if the field allowed for negative values the case would still be created
			(for example: backlogged or out of stock items with oustanding orders, which could be captured )*/
            if(stockItem.Stock_on_Hand__C != 0){
                Case c = new Case();
                c.Status = 'New';
                c.OwnerId = stockItem.OwnerId; 
                c.Origin = 'Stock Deletion';
                c.Subject = 'Alert: Item Deleted With Remaining Stock';
                c.Description = 'Stock Item Name: ' + stockItem.Item_Name__c + '\n'+
                                    ' Stock Item ID:' + stockItem.id + '\n' +
                                        ' Quantity on Hand:' + stockItem.Stock_on_Hand__c; 
                casesToInsert.add(c);
                //AB - added '\n' to insert line breaks in description 
            }
        }
        // LT - moved this outside of the for loop to avoid a DML within loop
        insert casesToInsert;
    }
    
    // LT - added getLowStockItems method
    public static List<Stock_Item__c> getLowStockItems() {
        List<Stock_Item__c> lowStockItems = new List<Stock_Item__c>();
        
        for (Stock_Item__c stockItem : [SELECT Id, Item_Name__c, Minimum_Stock_Level__c, Stock_on_Hand__c, Item_Stock_is_Low__c
                                        FROM Stock_Item__c]) {
                                            if (stockItem.Stock_on_Hand__c <= stockItem.Minimum_Stock_Level__c) {
                                                lowStockItems.add(stockItem);
                                            }
                                        }
        
        return lowStockItems;
    }
}
