import ballerina/http;

import ballerina/io;

import ballerina/soap.soap11;

import ballerina/xmldata;
 
 
type ErrorResponse record {|

    *http:InternalServerError;

    map<string|string[]> headers;

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
 
 
type OutBoundPayload record {|

    *http:Ok;

    map<string|string[]> headers;

    json body;

|};
 
 
xmlns "http://tempuri.org/" as tempuri;
 
 
configurable string endpoint =?;
 
 
service / on new http:Listener(9090) {
 
 
    resource function post createmandate(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadCreateMandate payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:createMandate><tem:xmlRequest><![CDATA[<CreateMandateRequest><AcctNumber>${payloadRecord.CreateMandateRequest.AcctNumber}</AcctNumber><AcctName>${payloadRecord.CreateMandateRequest.AcctName}</AcctName><DateOfBirth>${payloadRecord.CreateMandateRequest.DateOfBirth}</DateOfBirth><TransType>${payloadRecord.CreateMandateRequest.TransType}</TransType><MerchantId>${payloadRecord.CreateMandateRequest.MerchantId}</MerchantId><TransId>${payloadRecord.CreateMandateRequest.TransId}</TransId><BVN>${payloadRecord.CreateMandateRequest.BVN}</BVN><Amount>${payloadRecord.CreateMandateRequest.Amount}</Amount><Currency>${payloadRecord.CreateMandateRequest.Currency}</Currency><HashValue>${payloadRecord.CreateMandateRequest.HashValue}</HashValue></CreateMandateRequest>]]></tem:xmlRequest></tem:createMandate></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/createMandate", {"Accept": "application/xml"}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }
 
 
    }
 
 
    resource function post cancelmandate(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadCancelMandate payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:cancelMandate><tem:xmlRequest><![CDATA[<CancelMandateRequest><MandateCode>${payloadRecord.CancelMandateRequest.MandateCode}</MandateCode><TransType>${payloadRecord.CancelMandateRequest.TransType}</TransType><MerchantId>${payloadRecord.CancelMandateRequest.MerchantId}</MerchantId><TransId>${payloadRecord.CancelMandateRequest.TransId}</TransId><HashValue>${payloadRecord.CancelMandateRequest.HashValue}</HashValue></CancelMandateRequest>]]></tem:xmlRequest></tem:cancelMandate></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/cancelMandate", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
    resource function post querypayment(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadQueryPayment payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:queryPayment><tem:xmlRequest><![CDATA[<QueryPaymentRequest><MerchantId>${payloadRecord.QueryPaymentRequest.MerchantId}</MerchantId><TransId>${payloadRecord.QueryPaymentRequest.TransId}</TransId><PaymentRef>${payloadRecord.QueryPaymentRequest.PaymentRef}</PaymentRef><HashValue>${payloadRecord.QueryPaymentRequest.HashValue}</HashValue></QueryPaymentRequest>]]></tem:xmlRequest></tem:queryPayment></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/queryPayment", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
    resource function post validatetoken(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadValidateToken payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml ` <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"> <soapenv:Body><tem:validateToken><tem:xmlRequest><![CDATA[<validateTokenRequest><MandateCode>${payloadRecord.validateTokenRequest.MandateCode}</MandateCode><Token>${payloadRecord.validateTokenRequest.Token}</Token><TransType>${payloadRecord.validateTokenRequest.TransType}</TransType><MerchantId>${payloadRecord.validateTokenRequest.MerchantId}</MerchantId><TransId>${payloadRecord.validateTokenRequest.TransId}</TransId><HashValue>${payloadRecord.validateTokenRequest.HashValue}</HashValue><ServiceId>${payloadRecord.validateTokenRequest.ServiceId}</ServiceId></validateTokenRequest>]]></tem:xmlRequest></tem:validateToken></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/validateToken", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
    resource function post makepayment(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadMakePayment payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:makePayment><tem:xmlRequest><![CDATA[<MakePaymentRequest><MandateCode>${payloadRecord.MakePaymentRequest.MandateCode}</MandateCode><Amount>${payloadRecord.MakePaymentRequest.Amount}</Amount><Currency>${payloadRecord.MakePaymentRequest.Currency}</Currency><TransType>${payloadRecord.MakePaymentRequest.TransType}</TransType><MerchantId>${payloadRecord.MakePaymentRequest.MerchantId}</MerchantId><TransId>${payloadRecord.MakePaymentRequest.TransId}</TransId><HashValue>${payloadRecord.MakePaymentRequest.HashValue}</HashValue></MakePaymentRequest>]]></tem:xmlRequest></tem:makePayment></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/makePayment", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
    resource function post resendotp(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadResendOTP payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:resendOtp><tem:xmlRequest><![CDATA[<ResendOtpRequest><MerchantId>${payloadRecord.ResendOtpRequest.MerchantId}</MerchantId><TransId>${payloadRecord.ResendOtpRequest.TransId}</TransId><HashValue>${payloadRecord.ResendOtpRequest.HashValue}</HashValue></ResendOtpRequest>]]></tem:xmlRequest></tem:resendOtp></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/resendOtp", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
    resource function post creditmandate(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadCreditMandate payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:creditMandate><tem:xmlRequest><![CDATA[<CreditMandateRequest><MerchantId>${payloadRecord.CreditMandateRequest.MerchantId}</MerchantId><MandateCode>${payloadRecord.CreditMandateRequest.MandateCode}</MandateCode><Amount>${payloadRecord.CreditMandateRequest.Amount}</Amount><Currency>${payloadRecord.CreditMandateRequest.Currency}</Currency><PaymentId>${payloadRecord.CreditMandateRequest.PaymentId}</PaymentId><TransType>${payloadRecord.CreditMandateRequest.TransType}</TransType><CreditDescription>${payloadRecord.CreditMandateRequest.CreditDescription}</CreditDescription><TransId>${payloadRecord.CreditMandateRequest.TransId}</TransId><HashValue>${payloadRecord.CreditMandateRequest.HashValue}</HashValue></CreditMandateRequest>]]></tem:xmlRequest></tem:creditMandate></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/creditMandate", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
    resource function post ping(@http:Payload json jsonPayload) returns OutBoundPayload|ErrorResponse {
 
 
        do {
 
 
            InBoundPayloadPing payloadRecord = check jsonPayload.cloneWithType();
 
 
            xml payload = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Body><tem:ping><tem:xmlRequest><![CDATA[<PingRequest><MerchantId>${payloadRecord.PingRequest.MerchantId}</MerchantId><HashValue>${payloadRecord.PingRequest.HashValue}</HashValue></PingRequest>]]></tem:xmlRequest></tem:ping></soapenv:Body></soapenv:Envelope>`;
 
 
            return sendResponse(check soapBackendInvocation(endpoint, payload, "http://tempuri.org/ping", {}));
 
 
        } on fail error e {

            return returnErrorResponse(e);

        }

    }
 
 
}
 
 
function sendResponse(xml result) returns OutBoundPayload|ErrorResponse {
 
 
    io:println("sendResponse triggered");
 
 
    xml xmlResponse = result/**/<tempuri:xmlResponse>;

    xml|error value = xml:fromString(xmlResponse.data());
 
 
    if value is error {

        return returnErrorResponse(value);

    }

    json|xmldata:Error returnElementInJson = xmldata:toJson(value);
 
 
    if returnElementInJson is error {

        return returnErrorResponse(returnElementInJson);

    }
 
 
    return {

        headers: {

            "X-Frame-Options": "DENY",

            "Content-Security-Policy": "default-src 'none'"

        },

        body: returnElementInJson

    };
 
 
}
 
 
function returnErrorResponse(error e) returns ErrorResponse {
 
 
    ErrorResponse errorR = {

        headers: {

            "X-Frame-Options": "DENY",

            "Content-Security-Policy": "default-src 'none'"

        },

        body: {

            am\:fault: {

                am\:description: e.toString()

            }

        }

    };
 
 
    return errorR;
 
 
}
 
 
function soapBackendInvocation(string endpoint, xml payload, string soapAction, map<string|string[]> headers) returns xml|error {
 
 
    soap11:Client soapClient = check new (endpoint, {

        httpConfig: {

            timeout: 150,

            secureSocket: {

                enable: true,

                cert: "/usr/app/server.pem",

                verifyHostName: false

            }

        }

    });
 
 
    xml result = check soapClient->sendReceive(payload, soapAction, headers, path = "");
 
 
    return result;
 
 
}
 
