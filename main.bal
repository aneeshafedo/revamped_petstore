import ballerina/io;
import ballerina/http;

public function main() returns error? {
    Client petstoreClient = check new ();

    User user = {
        firstName: "Test",
        lastName: "User",
        username: "testUser"
    };

    // user knows the type that he is getting. If the type is different returns error
    // UserCreated res1 = check petstoreClient->/one/user.post(user);
    
    http:Response|UserCreated|UserBadRequest|UserOk|error res2 = petstoreClient->/four/user.post(user);
    if res2 is UserCreated {
        io:println("Operation is success. \n User Details : ", res2, "status code : ", res2.status.code);
    } else if res2 is UserOk {
        io:println("Operation is success. \n User Details : ", res2, "status code : ", res2.status.code);
    } else if res2 is http:Response {
        io:println("payload : ", res2.getTextPayload(), "status code : ", res2.statusCode);
    } else {
        io:println("Operation is failed!!!\n");
    }


}
