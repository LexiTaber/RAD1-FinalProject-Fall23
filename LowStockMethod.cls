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
