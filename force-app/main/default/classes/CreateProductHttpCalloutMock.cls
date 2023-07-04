@IsTest
public class CreateProductHttpCalloutMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();   
        response.setHeader('Content-Type', 'application/json');        
        response.setBody('{"data": [{"id": 4719,"imageurl": "http://www.glyffix.com/Image/ShowUploadedImage/4719"}]}');
        response.setStatusCode(200);                  
        return response; 
    } 
}