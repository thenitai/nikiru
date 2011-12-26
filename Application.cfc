<!--- @@Copyright: Copyright (c) 2011 __MyCompanyName__. All rights reserved. --->
<!--- @@License: --->
<cfcomponent output="false">
	
	<!--- Application name, should be unique --->
	<cfset this.name = "framework">
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(0,2,0,0)>
	<!--- Should client vars be enabled? --->
	<cfset this.clientManagement = false>
	<!--- Where should we store them, if enable? --->
	<cfset this.clientStorage = "registry">
	<!--- Where should cflogin stuff persist --->
	<cfset this.loginStorage = "session">
	<!--- Should we even use sessions? --->
	<cfset this.sessionManagement = true>
	<!--- How long do session vars persist? --->
	<cfset this.sessionTimeout = createTimeSpan(0,0,20,0)>
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>
	<!--- should cookies be domain specific, ie, *.foo.com or www.foo.com --->
	<cfset this.setDomainCookies = false>
	<!--- should we try to block 'bad' input from users --->
	<cfset this.scriptProtect = "none">
	<!--- should we secure our JSON calls? --->
	<cfset this.secureJSON = false>
	<!--- Should we use a prefix in front of JSON strings? --->
	<cfset this.secureJSONPrefix = "">
	<!--- Used to help CF work with missing files and dir indexes --->
	<cfset this.welcomeFileList = "">
	
	<!--- define custom coldfusion mappings. Keys are mapping names, values are full paths  --->
	<cfset this.mappings = structNew()>
	<!--- define a list of custom tag paths. --->
	<cfset this.customtagpaths = "">
	
	<!--- NIKIRU CONFIGURATION	 --->
	
	
	<!---  --->
	<!--- Define your database parameters here --->
	<!--- If you are changing any of these setting during runtime you need to restart the server --->
	<!---  --->
	
	<!--- Database you are using --->
	<cfset this.db.type = "mysql">
	<!--- DSN you are using (the name you set up in the CFML administration for your database connection) --->
	<cfset this.db.dsn = "nikiru">
	<!--- Schema --->
	<cfset this.db.schema = "nikiru">
	<!--- If set to true the model will be loaded on each request. This should be set to false in production --->
	<cfset this.db.reload = false>
	
	
	<!---  --->
	<!--- That's it. Nothing else to do here. --->
	<!--- Don't forget to restart your application if you are chaning these values during runtime! --->
	<!---  --->
	
	<!--- Are we in debug mode? --->
	<cfset this.debug = false>
	
	<!--- NIKIRU CONFIGURATION DONE!!! --->
	
	
	
	
	<!--- Run when application starts up --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<!--- We check the connection to the DB here --->
		<cfinvoke component="nikiru.cfc.dal" method="connect" thestruct="#this.db#" />
		<!--- Setup model --->
		<cfinvoke component="models.db" method="init" />
		<cfreturn true>
	</cffunction>

	<!--- Run when application stops --->
	<cffunction name="onApplicationEnd" returnType="void" output="false">
		<cfargument name="applicationScope" required="true">
	</cffunction>

	<!--- Fired when user requests a CFM that doesn't exist. --->
	<cffunction name="onMissingTemplate" returnType="boolean" output="false">
		<cfargument name="targetpage" required="true" type="string">
		<cfreturn true>
	</cffunction>
	
	<!--- Run before the request is processed --->
	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<cfargument name="thePage" type="string" required="true">
			<!--- If in debug mode we load the model every time --->
			<cfif this.db.reload>
				<!--- We check the connection to the DB here --->
				<cfinvoke component="nikiru.cfc.dal" method="connect" thestruct="#this.db#" />
				<!--- Setup model --->
				<cfinvoke component="models.db" method="init" />
			</cfif>
			<!--- Call the fw default controller --->
			<cfinvoke component="nikiru.cfc.global" method="load" scriptname="#cgi.script_name#" />
		<cfreturn true>
	</cffunction>

	<!--- Runs before request as well, after onRequestStart --->
	<!--- 
	WARNING!!!!! THE USE OF THIS METHOD WILL BREAK FLASH REMOTING, WEB SERVICES, AND AJAX CALLS. 
	DO NOT USE THIS METHOD UNLESS YOU KNOW THIS AND KNOW HOW TO WORK AROUND IT!
	EXAMPLE: http://www.coldfusionjedi.com/index.cfm?mode=entry&entry=ED9D4058-E661-02E9-E70A41706CD89724
	--->
	<cffunction name="onRequest" returnType="void">
		<cfargument name="thePage" type="string" required="true">	
		<cfinclude template="#arguments.thePage#">
	</cffunction>

	<!--- Runs at end of request --->
	<cffunction name="onRequestEnd" returnType="void" output="false">
		<cfargument name="thePage" type="string" required="true">
	</cffunction>

	<!--- Runs on error --->
	<cffunction name="onError" output="true">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
		<cfdump var="#arguments#"><cfabort>
	</cffunction>

	<!--- Runs when your session starts --->
	<cffunction name="onSessionStart" returnType="void" output="false">
	</cffunction>

	<!--- Runs when session ends --->
	<cffunction name="onSessionEnd" returnType="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" type="struct" required="false">
	</cffunction>
</cfcomponent>