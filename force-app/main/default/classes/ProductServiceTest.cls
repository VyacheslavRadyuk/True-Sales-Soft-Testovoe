@IsTest
public with sharing class ProductServiceTest {

    @IsTest
    private static void testCreateProductWithoutImage() {       
        Test.setMock(HttpCalloutMock.class, new CreateProductHttpCalloutMock());
        String productName = 'Ax';
        String productType = 'Type 1';
        String productDescription = 'test1';
        String productFamily = 'Family 1';
        String productImage = '';
        Decimal productPrice = 10.00;

        
        Test.startTest();
            OrderManagementController.createProduct(productName, productType, productDescription, productFamily, productImage, productPrice);
        Test.stopTest();

        Product__c productByName = [SELECT Id, Image__c FROM Product__c WHERE Name =:productName LIMIT 1];
        System.assertNotEquals(null, productByName.Image__c);
        System.assertEquals('http://www.glyffix.com/Image/ShowUploadedImage/4719', productByName.Image__c);
    }

    @IsTest
    private static void testCreateProductWithImage() {       
        String productName = 'Ax';
        String productType = 'Type 1';
        String productDescription = 'test1';
        String productFamily = 'Family 1';
        String productImage = 'custom image test';
        Decimal productPrice = 10.00;

        
        Test.startTest();
            OrderManagementController.createProduct(productName, productType, productDescription, productFamily, productImage, productPrice);
        Test.stopTest();

        Product__c productByName = [SELECT Id, Image__c FROM Product__c WHERE Name =:productName LIMIT 1];
        System.assertNotEquals(null, productByName.Image__c);
        System.assertEquals(productImage, productByName.Image__c);
    }
}