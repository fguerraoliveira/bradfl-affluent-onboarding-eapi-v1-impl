%dw 2.0

var BASE_API_CALL_PROPNAME = "api-call."
var BASE_SERVICE_OP_PROPNAME= "operations."
var SECURE_PROPERTY_PREFIX = "secure::"

fun securePropertySetup(secureProperty=false):String =
	if(!secureProperty) 
		"" 
	else 
		SECURE_PROPERTY_PREFIX

fun serviceProperty(baseServicePropertyName:String, propertyName:String, secureProperty=false):String =
		Mule::p(securePropertySetup(secureProperty) ++ baseServicePropertyName ++ propertyName)		

fun callProperty(baseServicePropertyName:String, operation:String, apiCallName:String, propertyName:String, secureProperty=false):String =
	(Mule::p(securePropertySetup(secureProperty) ++ BASE_API_CALL_PROPNAME ++ apiCallName ++ operation ++ propertyName)) default
		(Mule::p(securePropertySetup(secureProperty) ++ baseServicePropertyName ++ BASE_SERVICE_OP_PROPNAME ++ operation ++ propertyName))


fun createClientIdSecretHeader(baseServicePropertyName:String, clientIdHeaderName:String, clientSecretHeaderName:String, secureProperty=false):Object =
	do {
		
		var clientId = serviceProperty(baseServicePropertyName, "auth.clientId.value", secureProperty)
		var clientSecret = serviceProperty(baseServicePropertyName, "auth.clientSecret.value", secureProperty)
		---
		{
			(clientIdHeaderName): clientId,
			(clientSecretHeaderName): clientSecret
		}
	}

fun createAuthHeadersIfEnabled(baseServicePropertyName:String, clientIdHeaderName:String, clientSecretHeaderName:String, secureProperty=false) =
	do {
		var authEnabled = serviceProperty(baseServicePropertyName, "auth.enabled", secureProperty)
		---
		if(authEnabled)
			createClientIdSecretHeader(baseServicePropertyName, clientIdHeaderName, clientSecretHeaderName, secureProperty)
		else
			{}
	}