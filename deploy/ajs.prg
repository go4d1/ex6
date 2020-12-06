************************************************************************
*PROCEDURE aJS
****************************
***  Function: Processes incoming Web Requests for aJS
***            requests. This function is called from the wwServer
***            process.
***      Pass: loServer -   wwServer object reference
*************************************************************************
Lparameter loServer
Local loProcess
Private Request, Response, Server, Session, Process
Store Null To Request, Response, Server, Session, Process

#INCLUDE WCONNECT.H

loProcess = Createobject("aJS", loServer)
loProcess.lShowRequestData = loServer.lShowRequestData

If Vartype(loProcess)#"O"
*** All we can do is return...
	Return .F.
Endif

*** Call the Process Method that handles the request
loProcess.Process()

*** Explicitly force process class to release
loProcess.Dispose()

Return

*************************************************************
Define Class aJS As WWC_RESTPROCESS
*************************************************************

*** Response class used - override as needed
	cResponseClass = [WWC_PAGERESPONSE]

*** Default for page script processing if no method exists
*** 1 - MVC Template (ExpandTemplate())
*** 2 - Web Control Framework Pages
*** 3 - MVC Script (ExpandScript())
	nPageScriptMode = 3

*!* cAuthenticationMode = "UserSecurity"  && `Basic` is default


*** ADD PROCESS CLASS EXTENSIONS ABOVE - DO NOT MOVE THIS LINE ***


	#If .F.
* Intellisense for THIS
		Local This As aJS Of aJS.prg
	#Endif

*********************************************************************
* Function aJS :: OnProcessInit
************************************
*** If you need to hook up generic functionality that occurs on
*** every hit against this process class , implement this method.
*********************************************************************
	Function OnProcessInit

*!* LOCAL lcScriptName, llForceLogin
*!*	THIS.InitSession("MyApp")
*!*
*!*	lcScriptName = LOWER(JUSTFNAME(Request.GetPhysicalPath()))
*!*	llIgnoreLoginRequest = INLIST(lcScriptName,"default","login","logout")
*!*
*!*	IF !THIS.Authenticate("any","",llIgnoreLoginRequest)
*!*	   IF !llIgnoreLoginRequest
*!*		  RETURN .F.
*!*	   ENDIF
*!*	ENDIF

*** Explicitly specify that pages should encode to UTF-8
*** Assume all form and query request data is UTF-8
	Response.Encoding = "UTF8"
	Request.lUtf8Encoding = .T.


*** Add CORS header to allow cross-site access from other domains/mobile devices on Ajax calls
*!* Response.AppendHeader("Access-Control-Allow-Origin","*")
*!* Response.AppendHeader("Access-Control-Allow-Origin",Request.ServerVariables("HTTP_ORIGIN"))
*!* Response.AppendHeader("Access-Control-Allow-Methods","POST, GET, DELETE, PUT, OPTIONS")
*!* Response.AppendHeader("Access-Control-Allow-Headers","Content-Type, *")
*!* *** Allow cookies and auth headers
*!* Response.AppendHeader("Access-Control-Allow-Credentials","true")
*!*
*!* *** CORS headers are requested with OPTION by XHR clients. OPTIONS returns no content
*!*	lcVerb = Request.GetHttpVerb()
*!*	IF (lcVerb == "OPTIONS")
*!*	   *** Just exit with CORS headers set
*!*	   *** Required to make CORS work from Mobile devices
*!*	   RETURN .F.
*!*	ENDIF


	Return .T.
	Endfunc

	Function a1()
	=opendbf('act')
	Locate For pk = 10346
	Scatter Name oA Memo
	Return oA
	Endfunc


	Function c1()
	=opendbf('act')
	Select act,body,email From act Where Recno() < 10 Into Cursor cJS
	Return "cursor:cJS"

	Endfu

	Function c2()
	SET STEP ON 
	endfu


*********************************************************************
	Function TestPage
***********************
	Lparameters lvParm
*** Any posted JSON string is automatically deserialized
*** into a FoxPro object or value

	#If .F.
* Intellisense for intrinsic objects
		Local Request As wwRequest, Response As wwPageResponse, Server As wwServer, ;
			Process As wwProcess, Session As wwSession
	#Endif

*** Simply create objects, collections, values and return them
*** they are automatically serialized to JSON
	loObject = Createobject("EMPTY")
	AddProperty(loObject,"name","TestPage")
	AddProperty(loObject,"description",;
		"This is a JSON API method that returns an object.")
	AddProperty(loObject,"entered",Datetime())

*** To get proper case you have to override property names
*** otherwise all properties are serialized as lower case in JSON
	Serializer.PropertyNameOverrides = "Name,Description,Entered"


	Return loObject

*** To return a cursor use this string result:
*!* RETURN "cursor:TCustomers"


*** To return a raw Response result (non JSON) use:
*!*	JsonService.IsRawResponse = .T.   && use Response output
*!*	Response.ExpandScript()
*!*	RETURN                            && ignored

	Endfunc


*********************************************************************
	Function HelloScript()
***********************

	Select Top 10 Time, script, querystr, Verb, remoteaddr ;
		FROM wwRequestLog  ;
		INTO Cursor TRequests ;
		ORDER By Time Desc

	loObj = Createobject("EMPTY")
	AddProperty(loObj,"message","Surprise!!! This is not a script response! Instead we'll return you a cursor as a JSON result.")
	AddProperty(loObj,"requestName","Recent Requests")
	AddProperty(loObj,"recentRequests","cursor:TRequests")
	AddProperty(loObj,"recordCount",_Tally)

*** Normalize property names
	Serializer.PropertyNameOverrides = "requestName,recentRequests,recordCount"
	Return loObj
	Endfunc




*************************************************************
*** PUT YOUR OWN CUSTOM METHODS HERE
***
*** Any method added to this class becomes accessible
*** as an HTTP endpoint with MethodName.Extension where
*** .Extension is your scriptmap. If your scriptmap is .rs
*** and you have a function called Helloworld your
*** endpoint handler becomes HelloWorld.rs
*************************************************************


Enddefine
