//From Alyssa Buda's Gist: https://gist.github.com/alyssabuda/4d00d577efb45c4b0da46a0704e3ae1f
public with sharing class StockItemHandler {
    //added with sharing 
    //call a method for a before insert
    
    public static void stockBeforeInsert(List<Stock_Item__c> newStock){
        
        List<String> stockNames = new List <string>(); 
        for (Stock_Item__c existingStock : [SELECT Id, Name, Description__c, Item_Name__c from Stock_Item__c]){
            stockNames.add(existingStock.Item_Name__c);
        }
        
        for (Stock_Item__c newItem : newStock){
            if(stockNames.contains(newItem.Item_Name__c)){
                newItem.Item_Name__c = newItem.Item_Name__c + ' Duplicate Item';
            }
        }
    }
    
    public static void stockAfterDelete(List<Stock_Item__c> itemDeleted, Map<Id, Stock_Item__c> deletedMap){
        
        List<Case> casesToInsert = new List <Case>();
        
        for (Stock_Item__c stockItem : itemDeleted){
            if(stockItem.Stock_on_Hand__C > 0){
                Case c = new Case();
                c.Status = 'New';
                c.OwnerId = stockItem.OwnerId; 
                c.Origin = 'Stock Deletion';
                c.Subject = 'Item Deleted With Remaining Stock';
                c.Description = 'Stock Item Name: ' + stockItem.Item_Name__c + 
                    			' Stock Item ID:' + stockItem.id +
                  			    ' Quantity on Hand:' + stockItem.Stock_on_Hand__c; 
                casesToInsert.add(c);
                
            }
            
            insert casesToInsert;
        }
        
    }
    
}
