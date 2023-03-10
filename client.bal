import ballerina/jballerina.java;
import ballerina/http;

# This is a sample Pet Store Server based on the OpenAPI 3.0 specification.  You can find out more about
# Swagger at [https://swagger.io](https://swagger.io). In the third iteration of the pet store, we've switched to the design first approach!
# You can now help us improve the API whether it's by making changes to the definition itself or to the code.
# That way, with time, we can improve the API in general, and expose some of the new features in OAS3.
#
# _If you're looking for the Swagger 2.0/OAS 2.0 version of Petstore, then click [here](https://editor.swagger.io/?url=https://petstore.swagger.io/v2/swagger.yaml). Alternatively, you can load via the `Edit > Load Petstore OAS 2.0` menu option!_
#
# Some useful links:
# - [The Pet Store repository](https://github.com/swagger-api/swagger-petstore)
# - [The source API definition for the Pet Store](https://github.com/swagger-api/swagger-petstore/blob/master/src/main/resources/openapi.yaml)
public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(string serviceUrl = "https://petstore3.swagger.io/api/v3") returns error? {
        http:ClientConfiguration httpClientConfig = {auth:{username: "test", password: "abc123"}};
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }

    # Create user
    #
    # + payload - Created user object 
    # + return - successful operation 
    resource isolated function post user(User payload) returns User|error {
        string resourcePath = string `/user`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        User response = check self.clientEp->post(resourcePath, request);
        return response;
    }

    // option 1 : Using typdesc inferrence 

    //
    resource isolated function post one/user(User payload, typedesc<http:Response|UserCreated|UserBadRequest> returnType = <>) returns
        returnType|error = @java:Method {
        'class: "io.ballerina.openapi.client.api.client.Functions"
    } external;

    // since the user will not expect o have an error it is more conveient to send a particular error when found only.
    // but this way is not working
    resource isolated function post two/user(User payload, typedesc<http:Response|UserCreated> returnType = <>)
        returns returnType|UserBadRequest = @java:Method {
        'class: "io.ballerina.openapi.client.api.client.Functions"
    } external;

    // typedesc is only allowed in external functions
    resource isolated function post three/user(User payload, typedesc<http:Response|UserCreated|UserBadRequest> returnType = <>) returns
        returnType|error {

    }

    // option 2 : Using union return type 
    resource isolated function post four/user(User payload) returns http:Response|UserOk|UserCreated|UserBadRequest|error {
        string resourcePath = string `/user`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->post(resourcePath, request);

        if response.statusCode == http:STATUS_OK {
            http:StatusOK STATUS_OK_OBJ = new;
            string[] headerNames = response.getHeaderNames();
            map<string|int|boolean|string[]|int[]|boolean[]> headers = {};
            foreach string headerName in headerNames {
                headers[headerName] = check response.getHeader(headerName);
            }
            json userJson = check response.getJsonPayload();
            User userBody = check userJson.cloneWithType();
            UserOk userOk = {
                status: STATUS_OK_OBJ,
                mediaType: response.getContentType(),
                headers: headers,
                body: userBody
            };
            return userOk;
        }
        if response.statusCode == http:STATUS_CREATED {
            http:StatusCreated STATUS_CREATED_OBJ = new;
            // why we cant get all the headers at once without giving names
            string[] headerNames = response.getHeaderNames();
            map<string|int|boolean|string[]|int[]|boolean[]> headers = {};
            foreach string headerName in headerNames {
                headers[headerName] = check response.getHeader(headerName);
            }
            json userJson = check response.getJsonPayload();
            User userBody = check userJson.cloneWithType();
            UserCreated userCreated = {
                status: STATUS_CREATED_OBJ,
                mediaType: response.getContentType(),
                headers: headers,
                body: userBody
            };
            return userCreated;
        } else if response.statusCode == http:STATUS_BAD_REQUEST {
            http:StatusBadRequest STATUS_BAD_REQUEST_OBJ = new;
            UserBadRequest userBadRequest = {
                status: STATUS_BAD_REQUEST_OBJ,
                mediaType: response.getContentType(),
                body: check response.getJsonPayload().ensureType(ErrorResponse)
            };
            return userBadRequest;
        }
        return response;
    }

    # Get user by user name
    #
    # + username - The name that needs to be fetched. Use user1 for testing.  
    # + return - successful operation 
    resource isolated function get user/[string username]() returns User|error {
        string resourcePath = string `/user/${getEncodedUri(username)}`;
        User response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Update user
    #
    # + username - name that need to be deleted 
    # + payload - Update an existent user in the store 
    # + return - successful operation 
    resource isolated function put user/[string username](User payload) returns http:Response|error {
        string resourcePath = string `/user/${getEncodedUri(username)}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        http:Response response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Delete user
    #
    # + username - The name that needs to be deleted 
    # + return - Invalid username supplied 
    resource isolated function delete user/[string username]() returns http:Response|error {
        string resourcePath = string `/user/${getEncodedUri(username)}`;
        http:Response response = check self.clientEp->delete(resourcePath);
        return response;
    }
}
