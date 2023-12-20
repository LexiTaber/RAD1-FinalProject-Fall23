@isTest
private class StockItemHandlerTest {

    @isTest
    static void testStockBeforeInsertNoDuplicates() {
        // Test case where there are no duplicates in the database or new records
        List<Stock_Item__c> newStock = new List<Stock_Item__c>();
        newStock.add(new Stock_Item__c(Item_Name__c = 'UniqueItem1'));
        newStock.add(new Stock_Item__c(Item_Name__c = 'UniqueItem2'));

        Test.startTest();
        StockItemHandler.stockBeforeInsert(newStock);
        Test.stopTest();

        // Verify that no errors were added
        for (Stock_Item__c newItem : newStock) {
            System.assertEquals(null, newItem.getErrors());
        }
    }

    @isTest
    static void testStockBeforeInsertWithDuplicates() {
        // Test case where there are duplicates in the database
        List<Stock_Item__c> existingStock = new List<Stock_Item__c>();
        existingStock.add(new Stock_Item__c(Item_Name__c = 'DuplicateItem1'));
        insert existingStock;

        List<Stock_Item__c> newStock = new List<Stock_Item__c>();
        newStock.add(new Stock_Item__c(Item_Name__c = 'DuplicateItem1'));

        Test.startTest();
        StockItemHandler.stockBeforeInsert(newStock);
        Test.stopTest();

        // Verify that errors were added for the duplicate record
        for (Stock_Item__c newItem : newStock) {
            System.assertNotEquals(null, newItem.getErrors());
        }
    }

    @isTest
    static void testStockBeforeDelete() {
        // Test case for stockBeforeDelete method
        Stock_Item__c stockToDelete = new Stock_Item__c(
            Item_Name__c = 'StockToDelete',
            Stock_on_Hand__c = 5
        );
        insert stockToDelete;

        Test.startTest();
        delete stockToDelete;
        Test.stopTest();

        // Verify that a case was inserted for the deleted stock item
        List<Case> cases = [SELECT Subject, Description FROM Case];
        System.assertEquals(1, cases.size());
        System.assertEquals('Alert: Item Deleted With Remaining Stock', cases[0].Subject);
        System.assertEquals(
            'Stock Item Name: StockToDelete\n Stock Item ID:' + stockToDelete.Id + '\n Quantity on Hand:5',
            cases[0].Description
        );
    }

    @isTest
    static void testStockBeforeDeleteNoCases() {
        // Test case for stockBeforeDelete method when Stock_on_Hand__c is 0
        Stock_Item__c stockToDelete = new Stock_Item__c(
            Item_Name__c = 'StockToDelete',
            Stock_on_Hand__c = 0
        );
        insert stockToDelete;

        Test.startTest();
        delete stockToDelete;
        Test.stopTest();

        // Verify that no cases were inserted since Stock_on_Hand__c is 0
        List<Case> cases = [SELECT Id FROM Case];
        System.assertEquals(0, cases.size());
    }
}
