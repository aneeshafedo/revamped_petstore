import ballerina/url;

type SimpleBasicType string|boolean|int|float|decimal;

# Get Encoded URI for a given value.
#
# + value - Value to be encoded
# + return - Encoded string
isolated function getEncodedUri(anydata value) returns string {
    string|error encoded = url:encode(value.toString(), "UTF8");
    if (encoded is string) {
        return encoded;
    } else {
        return value.toString();
    }
}

# Generate header map for given header values.
#
# + headerParam - Headers  map
# + return - Returns generated map or error at failure of client initialization
isolated function getMapForHeaders(map<any> headerParam) returns map<string|string[]> {
    map<string|string[]> headerMap = {};
    foreach var [key, value] in headerParam.entries() {
        if value is string || value is string[] {
            headerMap[key] = value;
        } else if value is int[] {
            string[] stringArray = [];
            foreach int intValue in value {
                stringArray.push(intValue.toString());
            }
            headerMap[key] = stringArray;
        } else if value is SimpleBasicType {
            headerMap[key] = value.toString();
        }
    }
    return headerMap;
}
