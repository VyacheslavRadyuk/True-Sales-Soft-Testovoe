@IsTest
public with sharing class OrderManagementControllerTest {
    private static List<Account> accounts;
    private static List<Product__c> products;
    private static User userManager;

    static {
        accounts = TestDataFactory.createAccounts();
        products = TestDataFactory.createProducts();
        userManager = TestDataFactory.createUserMAnager();
    }

    @IsTest
    static void testGetInitData() {  
        String searchValue = ''; 
        String productType = '';
        String productFamily = '';   

        System.runAs(userManager) {
            OrderManagementController.wrapInitData initData = OrderManagementController.getInitData(accounts[0].Id, searchValue, productType, productFamily);

            System.assertEquals(accounts[0], initData.currentAccount); 
            System.assertEquals(true, initData.isManager); 
            System.assertEquals([SELECT Id, Name, Description__c, Family__c, Type__c, Price__c, Image__c FROM Product__c WHERE Id IN :products], initData.products); 
            System.assertEquals(OrderManagementController.getProductTypes(), initData.productTypes); 
            System.assertEquals(OrderManagementController.getProductFamilies(), initData.productFamilies); 
        }
    }  

    @IsTest
    static void testGetAccountById() {  
        Account accFromDb = OrderManagementController.getAccountById(accounts[0].Id);

        System.assertEquals(accounts[0].Id, accFromDb.Id); 
    }  

    @IsTest
    static void testIsManager() {  
        System.runAs(userManager) {
            Boolean isManager = OrderManagementController.isManager();

            System.assertEquals(true, isManager); 
        }
    }  

    @IsTest
    static void testGetProducts() {  
        String searchValue = ''; 
        String productType = '';
        String productFamily = ''; 
        List<Product__c> products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(2, products.size());

        searchValue = 'test1'; 
        productType = '';
        productFamily = ''; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());

        searchValue = 'test1'; 
        productType = 'Type 1';
        productFamily = ''; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());

        searchValue = 'test1'; 
        productType = '';
        productFamily = 'Family 1'; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());

        searchValue = ''; 
        productType = 'Type 1';
        productFamily = ''; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());

        searchValue = ''; 
        productType = '';
        productFamily = 'Family 1'; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());

        searchValue = ''; 
        productType = 'Type 1';
        productFamily = 'Family 1'; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());

        searchValue = 'test1'; 
        productType = 'Type 1';
        productFamily = 'Family 1'; 
        products = OrderManagementController.getProducts(searchValue, productType, productFamily);
        System.assertEquals(1, products.size());
    }  

    @IsTest
    static void testGetProductTypes() {  
        List<String> productTypes = OrderManagementController.getProductTypes();
        System.assertEquals('Type 1', productTypes[0]);
        System.assertEquals('Type 2', productTypes[1]);
        System.assertEquals('Type 3', productTypes[2]);
    }  

    @IsTest
    static void testGetProductFamilies() {  
        List<String> productFamilies = OrderManagementController.getProductFamilies();
        System.assertEquals('Family 1', productFamilies[0]);
        System.assertEquals('Family 2', productFamilies[1]);
        System.assertEquals('Family 3', productFamilies[2]);
    }  

    @IsTest
    static void testCreateOrder() {  
        String jsonProductData = '[{"id":\"' + products[0].Id + '\","price":10,"size":3}, {"id":\"' + products[1].Id + '\","price":15,"size":3}]';
        List<OrderManagementController.ProductsDataWrapper> productsData = (List<OrderManagementController.ProductsDataWrapper>)JSON.deserialize(jsonProductData, List<OrderManagementController.ProductsDataWrapper>.class);
        String createdOrderId = OrderManagementController.createOrder(productsData, accounts[0].Id);
        Order__c getOrderAfterCreating = [SELECT Id, AccountId__c FROM Order__c WHERE Id =:createdOrderId LIMIT 1];
        List<OrderItem__c> getOrderItemsByOrderId = [SELECT Id, OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c =:createdOrderId];

        System.assertEquals(accounts[0].Id, getOrderAfterCreating.AccountId__c);
        System.assertEquals(createdOrderId, getOrderItemsByOrderId[0].OrderId__c);
        System.assertEquals(products[0].Id, getOrderItemsByOrderId[0].ProductId__c);
        System.assertEquals(3, getOrderItemsByOrderId[0].Quantity__c);
        System.assertEquals(30, getOrderItemsByOrderId[0].Price__c);
        System.assertEquals(createdOrderId, getOrderItemsByOrderId[1].OrderId__c);
        System.assertEquals(products[1].Id, getOrderItemsByOrderId[1].ProductId__c);
        System.assertEquals(3, getOrderItemsByOrderId[1].Quantity__c);
        System.assertEquals(45, getOrderItemsByOrderId[1].Price__c);
    }   
}