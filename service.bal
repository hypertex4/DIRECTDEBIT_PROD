import ballerina/http;

import ballerina/io;

import ballerina/xmldata;
 
type ErrorResponse record {|

    *http:InternalServerError;

    ErrorMessageBody body;

|};
 
type ErrorMessageBody record {|

    ErrorMessageDetails am\:fault;

|};
 
type ErrorMessageDetails record {|

    string am\:code = "500";

    string am\:type = "Status report";

    string am\:message = "Runtime Error";

    string am\:description;

|};
 
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
 
type SoapBackendResponse record {|

    xml envelope;

    http:Response httpResponse;

|};
 
xmlns "http://tempuri.org/" as tempuri;
 
configurable string endpoint =?;
 
service / on new http:Listener(9090) {
 
    resource function post createmandate(@http:Payload json jsonPayload) returns http:Response|ErrorResponse {

        do {

            InBoundPayloadCreateMandate payloadRecord = check jsonPayload.cloneWithType();

            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:createMandate><tem:xmlRequest><![CDATA[<CreateMandateRequest><AcctNumber>${payloadRecord.CreateMandateRequest.AcctNumber}</AcctNumber><AcctName>${payloadRecord.CreateMandateRequest.AcctName}</AcctName><DateOfBirth>${payloadRecord.CreateMandateRequest.DateOfBirth}</DateOfBirth><TransType>${payloadRecord.CreateMandateRequest.TransType}</TransType><MerchantId>${payloadRecord.CreateMandateRequest.MerchantId}</MerchantId><TransId>${payloadRecord.CreateMandateRequest.TransId}</TransId><BVN>${payloadRecord.CreateMandateRequest.BVN}</BVN><Amount>${payloadRecord.CreateMandateRequest.Amount}</Amount><Currency>${payloadRecord.CreateMandateRequest.Currency}</Currency><HashValue>${payloadRecord.CreateMandateRequest.HashValue}</HashValue></CreateMandateRequest>]]></tem:xmlRequest></tem:createMandate></soapenv:Body></soapenv:Envelope>`;

            SoapBackendResponse backendResponse = check soapBackendInvocation(endpoint, payload, "http://tempuri.org/createMandate", {"Accept": "application/xml"});

            return sendResponse(backendResponse);

        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
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
 
function sendResponse(SoapBackendResponse backendResponse) returns http:Response|ErrorResponse {

    io:println("sendResponse triggered");
 
    xml xmlResponse = backendResponse.envelope/**/<tempuri:xmlResponse>;

    xml|error value = xml:fromString(xmlResponse.data());

    if value is error {

        return returnErrorResponse(value);

    }
 
    json|xmldata:Error returnElementInJson = xmldata:toJson(value);

    if returnElementInJson is error {

        return returnErrorResponse(returnElementInJson);

    }
 
    http:Response finalResponse = new;

    finalResponse.statusCode = backendResponse.httpResponse.statusCode;
 
    string[] headerNames = backendResponse.httpResponse.getHeaderNames();

    foreach string headerName in headerNames {

        string|http:HeaderNotFoundError headerValue = backendResponse.httpResponse.getHeader(headerName);

        if headerValue is string {

            finalResponse.setHeader(headerName, headerValue);

        }

    }
 
    finalResponse.setPayload(returnElementInJson);

    return finalResponse;

}
 
function returnErrorResponse(error e) returns http:Response {

    http:Response resp = new;

    resp.statusCode = 500;

    json errorBody = {

        body: {

            am\:fault: {

                am\:description: e.toString()

            }

        }

    };

    resp.setPayload(errorBody);

    return resp;

}
 
function soapBackendInvocation(string endpoint, xml payload, string soapAction, map<string|string[]> headers) returns SoapBackendResponse|error {

    http:Client httpClient = check new (endpoint, {

        timeout: 150,

        secureSocket: {

            enable: true,

            cert: "/usr/app/server.pem",

            verifyHostName: false

        }

    });
 
    string soapEnvelope = payload.toString();
 
    map<string|string[]> requestHeaders = {

        "Content-Type": "text/xml; charset=utf-8",

        "SOAPAction": soapAction

    };

    foreach var [key, value] in headers.entries() {

        requestHeaders[key] = value;

    }
 
    http:Response resp = check httpClient->post("/", requestHeaders, soapEnvelope);
 
    xml|error responseXml = resp.getXmlPayload();

    if responseXml is error {

        return responseXml;

    }
 
    return {

        envelope: responseXml,

        httpResponse: resp

    };

}
Info
A soft buzz and a dusting of pollen can shape the 
 
