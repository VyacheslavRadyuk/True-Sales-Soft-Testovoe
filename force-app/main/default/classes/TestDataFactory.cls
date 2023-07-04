@IsTest
public with sharing class TestDataFactory {
    
    public static List<Account> createAccounts() {
        List<Account> accountsToInsert = new List<Account>{
            new Account(Name = 'University of Arizona', AccountNumber = 'CD736025')   
        };
        insert accountsToInsert;
        return accountsToInsert;
    }

    public static List<Product__c> createProducts() {
        List<Product__c> productsToInsert = new List<Product__c>{
            new Product__c(Name = 'Product Test 1', Description__c = 'test1', Family__c = 'Family 1', Type__c = 'Type 1', Price__c = 10.00, Image__c = ''),
            new Product__c(Name = 'Product Test 2', Description__c = 'test2', Family__c = 'Family 2', Type__c = 'Type 2', Price__c = 15.00, Image__c = 'test')
        };
        insert productsToInsert;
        return productsToInsert;
    }

    public static List<Order__c> createOrders(Id accountId) {
        List<Order__c> ordersToInsert = new List<Order__c>{
            new Order__c(AccountId__c = accountId)   
        };
        insert ordersToInsert;
        return ordersToInsert;
    }

    public static List<OrderItem__c> createOrderItems(Id orderId, List<Product__c> products) {
        List<OrderItem__c> orderItemsToInsert = new List<OrderItem__c>{
            new OrderItem__c(OrderId__c = orderId, ProductId__c = products[0].Id, Quantity__c = 3, Price__c = 30.00),
            new OrderItem__c(OrderId__c = orderId, ProductId__c = products[1].Id, Quantity__c = 3, Price__c = 45.00)
        };
        return orderItemsToInsert;
    } 

    public static User createUserMAnager() {
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User newUserToInsert = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = userProfile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stfdfvcx332322andarduser@testorg.com', IsManager__c = true);

        insert newUserToInsert; 
        return newUserToInsert; 
    }
}