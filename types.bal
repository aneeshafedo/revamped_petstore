import ballerina/http;

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Provides Auth configurations needed when communicating with a remote HTTP endpoint.
    http:BearerTokenConfig|ApiKeysConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# Provides API key configurations needed when communicating with a remote HTTP endpoint.
public type ApiKeysConfig record {|
    string api_key;
|};

public type Category record {
    int id?;
    string name?;
};

public type User record {
    int id?;
    string username?;
    string firstName?;
    string lastName?;
    string email?;
    string password?;
    string phone?;
    # User Status
    int userStatus?;
};

public type UserOk record {
    *http:Ok;
    User body?;
};

public type UserCreated record {
    *http:Created; // there is another body field in this record ? 
    User body?;
};

public type UserBadRequest record {
    *http:BadRequest;
    ErrorResponse body;
};

public type Address record {
    string street?;
    string city?;
    string state?;
    string zip?;
};

public type Tag record {
    int id?;
    string name?;
};

public type Pet record {
    int id?;
    string name;
    Category category?;
    string[] photoUrls;
    Tag[] tags?;
    # pet status in the store
    string status?;
};


public type ErrorResponse record {
    ErrorResponseErrors[] errors?;
};

public type ErrorResponseErrors record {
    string id?;
    string status;
    string code;
    string title;
    string detail;
    record {string pointer?;}|record {string 'parameter?;} 'source?;
};