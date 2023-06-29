public with sharing class ProductService {
    public class GlyffixException extends Exception {}
    private static final String URL_TEMPLATE_GLYFFIX_REMOTE_SITE = '{0}?word={1}';
    private static final String GLYFFIX_NAMED_CREDENTIAL_END_POINT = 'callout:Glyffix_Endpoint';
    private static final String HTTP_METHOD_GET = 'GET';
    private static final Integer RESPONSE_STATUS_CODE_200 = 200;
    private static final String GLYFFIX_CUSTOM_EXCEPTION_ERROR = 'An error occurred in the callout process, or the responsive returned with an error!!!';
    private static final String META_DATA = 'data';
    private static final String PRODUCT_IMAGE = 'imageurl';

    public static void updateProduct(Product__c newProduct, String dataProductImages) {
        newProduct.Image__c = dataProductImages;
        update newProduct;
    }

    public static Product__c getProductById(Id productId) {
        return [SELECT Id, Name FROM Product__c WHERE Id =:productId LIMIT 1];
    }

    @Future(callout=true)
    public static void getImagesForProducts(Id productId) {
        Product__c productToUpdate = getProductById(productId);
        String template = URL_TEMPLATE_GLYFFIX_REMOTE_SITE;
        List<Object> parameters = new List<Object> {GLYFFIX_NAMED_CREDENTIAL_END_POINT, productToUpdate.Name};
        String url = String.format(template, parameters);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod(HTTP_METHOD_GET);
        HTTPResponse response = http.send(request);
        String dataProductImages = '';

        if(response.getStatusCode() != RESPONSE_STATUS_CODE_200) { 
            throw new GlyffixException(GLYFFIX_CUSTOM_EXCEPTION_ERROR);
        } else {    
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
            List<Object> myMapObjects = (List<Object>) meta.get(META_DATA); 
            
            for (Integer i = 0; i < myMapObjects.size(); i++) {
                Map<String, Object> temporaryMap = (Map<String, Object>)myMapObjects[i]; 
                dataProductImages += (String)temporaryMap.get(PRODUCT_IMAGE) + '\n'; 
            }     
        }
        updateProduct(productToUpdate, dataProductImages);
    }
}