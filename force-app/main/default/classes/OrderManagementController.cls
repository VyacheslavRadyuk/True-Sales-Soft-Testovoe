public with sharing class OrderManagementController {
    
    @AuraEnabled(cacheable=true)
    public static wrapInitData getInitData(Id recordId, String searchValue, String productType, String productFamily) {
        Account accById = getAccountById(recordId);
        Boolean isManager = isManager();
        List<Product__c> products = getProducts(searchValue, productType, productFamily);
        List<String> productTypes = getProductTypes();
        List<String> productFamilies = getProductFamilies();
        wrapInitData accWrapper = new wrapInitData();
        accWrapper.currentAccount = accById;
        accWrapper.isManager = isManager;
        accWrapper.products = products;
        accWrapper.productTypes = productTypes;
        accWrapper.productFamilies = productFamilies;
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
        @AuraEnabled public List<String> productTypes {get; set;}
        @AuraEnabled public List<String> productFamilies {get; set;}
    }

    @AuraEnabled
    public static void createProduct(String productName, String productType, String productDescription, String productFamily, String productImage) {
        ProductService.createProduct(productName, productType, productDescription, productFamily, productImage);
    }

    public static List<Product__c> getProducts(String searchValue, String productType, String productFamily) {
        List<Product__c> products = new List<Product__c>();
        String query = 'SELECT Id, Name, Description__c FROM Product__c';

        if (String.isBlank(searchValue) && String.isBlank(productType) && String.isBlank(productFamily)) {
        } else if (String.isNotEmpty(searchValue) && String.isBlank(productType) && String.isBlank(productFamily)) {
            searchValue = '%' + searchValue + '%';
            query += ' WHERE (Name LIKE :searchValue OR Description__c LIKE :searchValue)';
        } else if (String.isNotEmpty(searchValue) && (String.isNotEmpty(productType) || String.isNotEmpty(productFamily))) {
            searchValue = '%' + searchValue + '%';
            query += ' WHERE (Name LIKE :searchValue OR Description__c LIKE :searchValue)';
            if (String.isNotEmpty(productType)) {
                query += ' AND Type__c =:productType';
            }
            if (String.isNotEmpty(productFamily)) {
                query += ' AND Family__c =:productFamily';
            }
        } else if (String.isBlank(searchValue) && (String.isNotEmpty(productType) || String.isNotEmpty(productFamily))) {
            query += ' WHERE';

            if (String.isNotEmpty(productType) && String.isNotEmpty(productFamily)) {
                query += ' Type__c =:productType AND Family__c =:productFamily';
            } else if (String.isNotEmpty(productType)) {
                query += ' Type__c =:productType';
            } else if (String.isNotEmpty(productFamily)) {
                query += ' Family__c =:productFamily';
            }
        }

        products = Database.query(query);
        return products;
    }

    public static List<String> getProductTypes() {
        List<String> productTypes = new List<String>();
        Schema.DescribeFieldResult field = Product__c.Type__c.getDescribe();

        for (Schema.PicklistEntry fieldItem : field.getPicklistValues()) {
            productTypes.add(fieldItem.getLabel());
        }

        return productTypes;
    }

    public static List<String> getProductFamilies() {
        List<String> productFamilies = new List<String>();
        Schema.DescribeFieldResult field = Product__c.Family__c.getDescribe();

        for (Schema.PicklistEntry fieldItem : field.getPicklistValues()) {
            productFamilies.add(fieldItem.getLabel());
        }

        return productFamilies;
    }
}