import ballerina/io;
import ballerina/http;

public function main() returns error? {
    Client petstoreClient = check new (config = {auth: {api_key: "1234"}});

    User user = {
        firstName: "Test",
        lastName: "User",
        username: "testUser"
    };

    // user knows the type that he is getting. If the type is different returns error
    UserCreated res1 = check petstoreClient->/one/user.post(user);

    http:Response|UserCreated|UserBadRequest|error res2 = petstoreClient->/four/user.post(user);
    if res2 is UserCreated {
        io:println("Operation is success");
    } else {
        io:println("Operation is failed!!!");
    }


}
