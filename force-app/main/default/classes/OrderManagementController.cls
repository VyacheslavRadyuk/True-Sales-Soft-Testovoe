public with sharing class OrderManagementController {
    
    @AuraEnabled(cacheable=true)
    public static wrapInitData getInitData(Id recordId) {
        Account accById = getAccountById(recordId);
        Boolean isManager = isManager();
        List<Product__c> products = getProducts();
        wrapInitData accWrapper = new wrapInitData();
        accWrapper.currentAccount = accById;
        accWrapper.isManager = isManager;
        accWrapper.products = products;
        return accWrapper;
    }

    public static Account getAccountById(Id recordId) {
        return [SELECT Id, Name, AccountNumber FROM Account WHERE Id =:recordId LIMIT 1];
    }

    public static Boolean isManager() {
        return [SELECT Id, IsManager__c FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1].IsManager__c;
    }

    public class wrapInitData {
        @AuraEnabled public Account currentAccount {get; set;}
        @AuraEnabled public Boolean isManager {get; set;}
        @AuraEnabled public List<Product__c> products {get; set;}
    }

    @AuraEnabled
    public static void createProduct(String productName, String productType, String productDescription, String productFamily, String productImage) {
        ProductService.createProduct(productName, productType, productDescription, productFamily, productImage);
    }

    public static List<Product__c> getProducts() {
        return [SELECT Id, Name, Description__c FROM Product__c LIMIT 50000];
    }
}