import ballerina/http;
import ballerina/io;
import ballerina/soap.soap11;
import ballerina/xmldata;
 
// ----------------------------------------------------------------------
// ERROR RESPONSE TYPES
// ----------------------------------------------------------------------
// These types define the structure of error responses sent back to the caller.
// They mimic a SOAP fault but are returned as JSON over HTTP.
 
type ErrorResponse record {|
    *http:InternalServerError;   // Indicates HTTP 500 status code
    ErrorMessageBody body;
|};
 
type ErrorMessageBody record {|
    ErrorMessageDetails am\:fault;
|};
 
type ErrorMessageDetails record {|
    string am\:code = "500";
    string am\:type = "Status report";
    string am\:message = "Runtime Error";
    string am\:description;      // Will hold the actual error message
|};
 
// ----------------------------------------------------------------------
// REQUEST TYPES (from JSON payloads)
// ----------------------------------------------------------------------
// Each resource expects a specific JSON structure. These records validate
// the incoming payload and allow safe access to its fields.
 
type CreateMandateRequest record {
    string AcctNumber;
    string AcctName;
    string DateOfBirth;
    string TransType;
    string MerchantId;
    string TransId;
    string BVN;
    float Amount;
    string Currency;
    string HashValue;
};
 
type InBoundPayloadCreateMandate record {
    CreateMandateRequest CreateMandateRequest;
};
 
type CancelMandateRequest record {
    string MandateCode;
    string TransType;
    string MerchantId;
    string TransId;
    string HashValue;
};
 
type InBoundPayloadCancelMandate record {
    CancelMandateRequest CancelMandateRequest;
};
 
type QueryPaymentRequest record {
    string MerchantId;
    string TransId;
    string PaymentRef;
    string HashValue;
};
 
type InBoundPayloadQueryPayment record {
    QueryPaymentRequest QueryPaymentRequest;
};
 
type validateTokenRequest record {
    string MandateCode;
    string Token;
    string TransType;
    string MerchantId;
    string TransId;
    string HashValue;
    string ServiceId;
};
 
type InBoundPayloadValidateToken record {
    validateTokenRequest validateTokenRequest;
};
 
type MakePaymentRequest record {
    string MandateCode;
    float Amount;
    string Currency;
    string TransType;
    string MerchantId;
    string TransId;
    string HashValue;
};
 
type InBoundPayloadMakePayment record {
    MakePaymentRequest MakePaymentRequest;
};
 
type ResendOtpRequest record {
    string MerchantId;
    string TransId;
    string HashValue;
};
 
type InBoundPayloadResendOTP record {
    ResendOtpRequest ResendOtpRequest;
};
 
type CreditMandateRequest record {
    string MerchantId;
    string MandateCode;
    float Amount;
    string Currency;
    string PaymentId;
    string TransType;
    string CreditDescription;
    string TransId;
    string HashValue;
};
 
type InBoundPayloadCreditMandate record {
    CreditMandateRequest CreditMandateRequest;
};
 
type PingRequest record {
    string MerchantId;
    string HashValue;
};
 
type InBoundPayloadPing record {
    PingRequest PingRequest;
};
 
// ----------------------------------------------------------------------
// BACKEND RESPONSE HOLDER
// ----------------------------------------------------------------------
// Used to return both the SOAP envelope (XML) and the raw HTTP response
// from the backend. This allows us to copy HTTP headers from the backend
// to the final response sent to the client.
 
type SoapBackendResponse record {|
    xml envelope;                 // The SOAP envelope returned by the backend
    http:Response httpResponse;   // Full HTTP response containing headers, status, etc.
|};
 
// ----------------------------------------------------------------------
// XML NAMESPACE FOR BACKEND SOAP SERVICE
// ----------------------------------------------------------------------
// The backend expects elements in the "http://tempuri.org/" namespace.
// We declare it with the prefix "tempuri" to easily query XML nodes.
 
xmlns "http://tempuri.org/" as tempuri;
 
// ----------------------------------------------------------------------
// CONFIGURABLE VARIABLES
// ----------------------------------------------------------------------
// endpoint must be provided at runtime (e.g., via Config.toml or environment variable).
// Example: endpoint = "https://soap-backend.example.com/service"
 
configurable string endpoint =?;
 
// ----------------------------------------------------------------------
// MAIN SERVICE
// ----------------------------------------------------------------------
// Listens on port 9090 and exposes REST endpoints that transform JSON into
// SOAP requests, invoke a backend SOAP service, then forward the backend's
// response (including all HTTP headers) back to the caller.
 
service / on new http:Listener(9090) {
 
    // --------------------------------------------------------------
    // Resource: createmandate
    // --------------------------------------------------------------
    // POST /createmandate
    // Accepts JSON matching CreateMandateRequest, builds a SOAP envelope,
    // calls the backend's createMandate operation, and returns the backend's
    // full response (headers + JSON-converted body).
    resource function post createmandate(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            // 1. Validate and convert JSON to record
            InBoundPayloadCreateMandate payloadRecord = check jsonPayload.cloneWithType();
 
            // 2. Build the SOAP envelope with CDATA containing the XML request
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:createMandate><tem:xmlRequest><![CDATA[<CreateMandateRequest><AcctNumber>${payloadRecord.CreateMandateRequest.AcctNumber}</AcctNumber><AcctName>${payloadRecord.CreateMandateRequest.AcctName}</AcctName><DateOfBirth>${payloadRecord.CreateMandateRequest.DateOfBirth}</DateOfBirth><TransType>${payloadRecord.CreateMandateRequest.TransType}</TransType><MerchantId>${payloadRecord.CreateMandateRequest.MerchantId}</MerchantId><TransId>${payloadRecord.CreateMandateRequest.TransId}</TransId><BVN>${payloadRecord.CreateMandateRequest.BVN}</BVN><Amount>${payloadRecord.CreateMandateRequest.Amount}</Amount><Currency>${payloadRecord.CreateMandateRequest.Currency}</Currency><HashValue>${payloadRecord.CreateMandateRequest.HashValue}</HashValue></CreateMandateRequest>]]></tem:xmlRequest></tem:createMandate></soapenv:Body></soapenv:Envelope>`;
 
            // 3. Invoke the backend SOAP service
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/createMandate", {"Accept": "application/xml"});
 
            // 4. Convert the SOAP response to JSON and forward headers
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: cancelmandate
    // --------------------------------------------------------------
    resource function post cancelmandate(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadCancelMandate payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:cancelMandate><tem:xmlRequest><![CDATA[<CancelMandateRequest><MandateCode>${payloadRecord.CancelMandateRequest.MandateCode}</MandateCode><TransType>${payloadRecord.CancelMandateRequest.TransType}</TransType><MerchantId>${payloadRecord.CancelMandateRequest.MerchantId}</MerchantId><TransId>${payloadRecord.CancelMandateRequest.TransId}</TransId><HashValue>${payloadRecord.CancelMandateRequest.HashValue}</HashValue></CancelMandateRequest>]]></tem:xmlRequest></tem:cancelMandate></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/cancelMandate", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: querypayment
    // --------------------------------------------------------------
    resource function post querypayment(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadQueryPayment payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:queryPayment><tem:xmlRequest><![CDATA[<QueryPaymentRequest><MerchantId>${payloadRecord.QueryPaymentRequest.MerchantId}</MerchantId><TransId>${payloadRecord.QueryPaymentRequest.TransId}</TransId><PaymentRef>${payloadRecord.QueryPaymentRequest.PaymentRef}</PaymentRef><HashValue>${payloadRecord.QueryPaymentRequest.HashValue}</HashValue></QueryPaymentRequest>]]></tem:xmlRequest></tem:queryPayment></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/queryPayment", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: validatetoken
    // --------------------------------------------------------------
    resource function post validatetoken(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadValidateToken payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:validateToken><tem:xmlRequest><![CDATA[<validateTokenRequest><MandateCode>${payloadRecord.validateTokenRequest.MandateCode}</MandateCode><Token>${payloadRecord.validateTokenRequest.Token}</Token><TransType>${payloadRecord.validateTokenRequest.TransType}</TransType><MerchantId>${payloadRecord.validateTokenRequest.MerchantId}</MerchantId><TransId>${payloadRecord.validateTokenRequest.TransId}</TransId><HashValue>${payloadRecord.validateTokenRequest.HashValue}</HashValue><ServiceId>${payloadRecord.validateTokenRequest.ServiceId}</ServiceId></validateTokenRequest>]]></tem:xmlRequest></tem:validateToken></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/validateToken", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: makepayment
    // --------------------------------------------------------------
    resource function post makepayment(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadMakePayment payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:makePayment><tem:xmlRequest><![CDATA[<MakePaymentRequest><MandateCode>${payloadRecord.MakePaymentRequest.MandateCode}</MandateCode><Amount>${payloadRecord.MakePaymentRequest.Amount}</Amount><Currency>${payloadRecord.MakePaymentRequest.Currency}</Currency><TransType>${payloadRecord.MakePaymentRequest.TransType}</TransType><MerchantId>${payloadRecord.MakePaymentRequest.MerchantId}</MerchantId><TransId>${payloadRecord.MakePaymentRequest.TransId}</TransId><HashValue>${payloadRecord.MakePaymentRequest.HashValue}</HashValue></MakePaymentRequest>]]></tem:xmlRequest></tem:makePayment></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/makePayment", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: resendotp
    // --------------------------------------------------------------
    resource function post resendotp(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadResendOTP payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:resendOtp><tem:xmlRequest><![CDATA[<ResendOtpRequest><MerchantId>${payloadRecord.ResendOtpRequest.MerchantId}</MerchantId><TransId>${payloadRecord.ResendOtpRequest.TransId}</TransId><HashValue>${payloadRecord.ResendOtpRequest.HashValue}</HashValue></ResendOtpRequest>]]></tem:xmlRequest></tem:resendOtp></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/resendOtp", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: creditmandate
    // --------------------------------------------------------------
    resource function post creditmandate(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadCreditMandate payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:creditMandate><tem:xmlRequest><![CDATA[<CreditMandateRequest><MerchantId>${payloadRecord.CreditMandateRequest.MerchantId}</MerchantId><MandateCode>${payloadRecord.CreditMandateRequest.MandateCode}</MandateCode><Amount>${payloadRecord.CreditMandateRequest.Amount}</Amount><Currency>${payloadRecord.CreditMandateRequest.Currency}</Currency><PaymentId>${payloadRecord.CreditMandateRequest.PaymentId}</PaymentId><TransType>${payloadRecord.CreditMandateRequest.TransType}</TransType><CreditDescription>${payloadRecord.CreditMandateRequest.CreditDescription}</CreditDescription><TransId>${payloadRecord.CreditMandateRequest.TransId}</TransId><HashValue>${payloadRecord.CreditMandateRequest.HashValue}</HashValue></CreditMandateRequest>]]></tem:xmlRequest></tem:creditMandate></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/creditMandate", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
 
    // --------------------------------------------------------------
    // Resource: ping
    // --------------------------------------------------------------
    resource function post ping(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {
        do {
            InBoundPayloadPing payloadRecord = check jsonPayload.cloneWithType();
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:ping><tem:xmlRequest><![CDATA[<PingRequest><MerchantId>${payloadRecord.PingRequest.MerchantId}</MerchantId><HashValue>${payloadRecord.PingRequest.HashValue}</HashValue></PingRequest>]]></tem:xmlRequest></tem:ping></soapenv:Body></soapenv:Envelope>`;
            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/ping", {});
            return sendResponse(backendResponse);
        } on fail error e {
            return returnErrorResponse(e);
        }
    }
}
 
// ----------------------------------------------------------------------
// FUNCTION: sendResponse
// ----------------------------------------------------------------------
// Converts the backend SOAP response (XML) into JSON and builds an HTTP response
// that copies all headers from the backend's HTTP response.
//
// Parameters:
//   backendResponse - Contains the SOAP envelope and the raw HTTP response from the backend.
//
// Returns:
//   An http:Response ready to be sent to the caller, or an ErrorResponse if conversion fails.
function sendResponse(SoapBackendResponse backendResponse) returns http:Response|ErrorResponse {
    io:println("sendResponse triggered");
 
    // 1. Extract the <tempuri:xmlResponse> element from the SOAP envelope.
    //    The backend wraps its actual XML response inside this element.
    xml xmlResponse = backendResponse.envelope/**/<tempuri:xmlResponse>;
 
    // 2. Convert that inner XML to a string and parse it back to an XML tree.
    //    This step ensures we have a clean XML document without the SOAP wrapper.
    xml|error value = xml:fromString(xmlResponse.data());
 
    if value is error {
        return returnErrorResponse(value);
    }
 
    // 3. Convert the XML to JSON using the xmldata library.
    json|xmldata:Error returnElementInJson = xmldata:toJson(value);
    if returnElementInJson is error {
        return returnErrorResponse(returnElementInJson);
    }
 
    // 4. Create a new HTTP response and set its status code from the backend.
    http:Response finalResponse = new;
    finalResponse.statusCode = backendResponse.httpResponse.statusCode;
 
    // 5. Copy every HTTP header from the backend response to the new response.
    map<string|string[]> backendHeaders = backendResponse.httpResponse.getHeaders();
    foreach var [headerName, headerValue] in backendHeaders.entries() {
        finalResponse.setHeader(headerName, headerValue);
    }
 
    // 6. Set the JSON payload as the response body.
    finalResponse.setPayload(returnElementInJson);
    return finalResponse;
}
 
// ----------------------------------------------------------------------
// FUNCTION: returnErrorResponse
// ----------------------------------------------------------------------
// Builds a standardized HTTP 500 error response when something fails
// during request processing or backend invocation.
//
// Parameters:
//   e - The error that occurred.
//
// Returns:
//   An http:Response with status 500 containing a JSON fault structure.
function returnErrorResponse(error e) returns http:Response {
    ErrorResponse errorR = {
        body: {
            am\:fault: {
                am\:description: e.toString()
            }
        }
    };
    http:Response resp = new;
    resp.statusCode = 500;
    resp.setPayload(errorR);
    return resp;
}
 
// ----------------------------------------------------------------------
// FUNCTION: soapBackendInvocation
// ----------------------------------------------------------------------
// Invokes a backend SOAP service over HTTP/HTTPS, using mutual TLS as configured.
// This function uses sendReceiveWithResponse to capture the full HTTP response,
// including headers and status code.
//
// Parameters:
//   endpoint   - The backend SOAP service URL.
//   payload    - The SOAP envelope XML to send.
//   soapAction - The SOAPAction HTTP header value.
//   headers    - Additional HTTP headers to include (e.g., Accept).
//
// Returns:
//   A SoapBackendResponse containing the SOAP envelope and the raw HTTP response,
//   or an error if the invocation fails.
function soapBackendInvocation(string endpoint, xml payload, string soapAction, map<string|string[]> headers) returns SoapBackendResponse|error {
    // Create the SOAP 1.1 client with custom HTTP configuration.
    // The backend expects mutual TLS: client certificate is loaded from /usr/app/server.pem.
    // Hostname verification is disabled (only for testing/internal networks – use cautiously).
    soap11:Client soapClient = check new (endpoint, {
        httpConfig: {
            timeout: 150,          // 150 seconds timeout
            secureSocket: {
                enable: true,
                cert: "/usr/app/server.pem",   // Path to client certificate
                verifyHostName: false           // Disable hostname verification (not recommended for production)
            }
        }
    });
 
    // Send the SOAP message and receive the full HTTP response.
    // The path is empty because the endpoint URL already contains the full path.
    soap11:ResponseWithResponse soapResponse = check soapClient->sendReceiveWithResponse(payload, soapAction, headers, path = "");
 
    // Return both the SOAP envelope and the underlying http:Response.
    return {
        envelope: soapResponse.envelope,
        httpResponse: soapResponse.httpResponse
    };
}