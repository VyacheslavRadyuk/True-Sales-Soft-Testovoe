public with sharing class ProductService {
    public class GlyffixException extends Exception {}
    private static final String URL_TEMPLATE_GLYFFIX_REMOTE_SITE = '{0}?word={1}';
    private static final String GLYFFIX_NAMED_CREDENTIAL_END_POINT = 'callout:Glyffix_Endpoint';
    private static final String HTTP_METHOD_GET = 'GET';
    private static final Integer RESPONSE_STATUS_CODE_200 = 200;
    private static final String GLYFFIX_CUSTOM_EXCEPTION_ERROR = 'An error occurred in the callout process, or the responsive returned with an error!!!';
    private static final String META_DATA = 'data';
    private static final String PRODUCT_IMAGE = 'imageurl';

    @Future(callout=true)
    public static void getImagesForProducts(String productName, String productType, String productDescription, String productFamily, Decimal productPrice) {
        String template = URL_TEMPLATE_GLYFFIX_REMOTE_SITE;
        List<Object> parameters = new List<Object> {GLYFFIX_NAMED_CREDENTIAL_END_POINT, productName};
        String url = String.format(template, parameters);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod(HTTP_METHOD_GET);
        HTTPResponse response = http.send(request);
        String dataProductImage = '';

        if(response.getStatusCode() != RESPONSE_STATUS_CODE_200) { 
            throw new GlyffixException(GLYFFIX_CUSTOM_EXCEPTION_ERROR);
        } else {    
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
            List<Object> myMapObjects = (List<Object>) meta.get(META_DATA); 
            Map<String, Object> temporaryMap = (Map<String, Object>)myMapObjects[0]; 
            dataProductImage += (String)temporaryMap.get(PRODUCT_IMAGE);   
        }
        insertProduct(productName, productType, productDescription, productFamily, productPrice, dataProductImage);
    }

    public static void createProduct(String productName, String productType, String productDescription, String productFamily, String productImage, Decimal productPrice) {
        if(String.isBlank(productImage)) {
            getImagesForProducts(productName, productType, productDescription, productFamily, productPrice);
        } else {
            insertProduct(productName, productType, productDescription, productFamily, productPrice, productImage);
        }
    }

    public static void insertProduct(String productName, String productType, String productDescription, String productFamily, Decimal productPrice, String productImage) {
        Product__c productToInsert = new Product__c();
        productToInsert.Name = productName;
        productToInsert.Type__c = productType;
        productToInsert.Description__c = productDescription;
        productToInsert.Family__c = productFamily;
        productToInsert.Image__c = productImage;
        productToInsert.Price__c = productPrice;
        insert productToInsert;
    }
}