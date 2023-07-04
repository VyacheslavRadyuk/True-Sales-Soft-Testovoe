@IsTest
public with sharing class OrderItemTriggerHandlerTest {
    private static List<Account> accounts;
    private static List<Product__c> products;
    private static List<Order__c> orders;
    private static List<OrderItem__c> orderItems;


    static {
        accounts = TestDataFactory.createAccounts();
        products = TestDataFactory.createProducts();
        orders = TestDataFactory.createOrders(accounts[0].Id);
        orderItems = TestDataFactory.createOrderItems(orders[0].Id, products);
    }

    @IsTest
    static void testAfterInsert() {     
        Test.startTest();
        Database.SaveResult[] result = Database.insert(orderItems, false);    
        Test.stopTest(); 
        
        System.assert(result[0].isSuccess()); 
        System.assert(result[1].isSuccess()); 

        Order__c orderByOrderItems = [SELECT Id, TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id =:orderItems[0].OrderId__c LIMIT 1];

        System.assertEquals(6 ,orderByOrderItems.TotalProductCount__c); 
        System.assertEquals(75 ,orderByOrderItems.TotalPrice__c); 
    }  

    @IsTest
    static void getOrderByIdTest() {
        Order__c orderFromDb = OrderItemTriggerHandler.getOrderById(orders[0].Id);

        System.assertNotEquals(null, orderFromDb.Id);
    }
}