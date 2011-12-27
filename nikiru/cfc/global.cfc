<!--- @@License: --->
<cfcomponent output="false">
		
	<!--- Load --->
	<cffunction access="public" name="load">
		<cfargument name="thecgi" type="struct" required="true" />
		<!--- set the controller --->
		<cfif arguments.thecgi.query_string EQ "" OR arguments.thecgi.query_string EQ "/">
			<cfset var thecontroller = "default">
			<cfset var thefunction = thecontroller>
			<cfset this.layout = thecontroller>
			<cfset this.view = thecontroller>
		<cfelse>
			<cfset var thecontroller = listfirst(arguments.thecgi.query_string,"/")>
			<cfset var thefunction = listlast(arguments.thecgi.query_string,"/")>
			<cfset this.layout = "default">
			<cfset this.view = thefunction>
		</cfif>
		<!--- Check that there is a controller with this name --->
		<cftry>
			<!--- Controller --->
			<cfinvoke component="controllers.#thecontroller#" method="#thefunction#" returnvariable="con_return" />
			<!--- Load the layout. Did the user define a custom layout for this controller? --->
			<cfif NOT structkeyexists(con_return,"layout")>
				<cfset con_return.layout = this.layout>
			</cfif>
			<!--- Load the view --->
			<cfif NOT structkeyexists(con_return,"view")>
				<cfset con_return.view = this.view>
			</cfif>
			<!--- Set the layout and view into application variables for --->
			<cfset application.nikiru.layout = con_return.layout>
			<cfset application.nikiru.view = con_return.view>
			<!--- Load renderer --->
			<cfinvoke method="render" thestruct="#con_return#" />
			<!--- We cant load the controller or function --->
			<cfcatch>
				<cfdump var="#cfcatch#"><cfabort>
			</cfcatch>
		</cftry>
		<!--- Return --->
		<cfreturn />
	</cffunction>
	
	<!--- Render --->
	<cffunction access="private" output="true" name="render">
		<cfargument name="thestruct" type="struct" required="true" />
		<!--- Params --->
		<cfset var path_views = "../../views/">
		<cfset var path_layouts = "#path_views#layouts/">
		<!--- Put arguments struct from above into variables struct so it is available to the user --->
		<cfset variables.controller = arguments.thestruct>
		<!--- Load the view --->
		<cfsavecontent variable="theview"><cfsetting enablecfoutputonly="false" /><cfinclude template="#path_views##arguments.thestruct.view#.cfm" /><cfsetting enablecfoutputonly="true" /></cfsavecontent>
		<!--- Load view into content variable --->
		<cfset content = theview>
		<!--- Load layout --->
		<cfinclude template = "#path_layouts##arguments.thestruct.layout#.cfm">
		<!--- Return --->
		<cfreturn />
	</cffunction>
	
	<!--- DB: Select --->
	<cffunction access="public" name="db_select">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="fetch" type="string" required="true" />
		<cfargument name="where" type="string" required="false" default="" />
		<cfargument name="orderby" type="string" required="false" default="" />
		<cfargument name="groupby" type="string" required="false" default="" />
		<cfargument name="limit" type="string" required="false" default="" />
			<!--- Param --->
			<cfset var qry = 0>
			<!--- Call our internal function --->
			<cfinvoke component="dal" method="table_select" returnvariable="qry">
				<cfinvokeargument name="table" value="#arguments.table#" />
				<cfinvokeargument name="fetch" value="#arguments.fetch#" />
				<cfinvokeargument name="where" value="#arguments.where#" />
				<cfinvokeargument name="orderby" value="#arguments.orderby#" />
				<cfinvokeargument name="groupby" value="#arguments.groupby#" />
				<cfinvokeargument name="limit" value="#arguments.limit#" />
			</cfinvoke>
		<!--- Return --->
		<cfreturn qry />
	</cffunction>
	
	<!--- DB: Insert --->
	<cffunction access="public" name="db_insert">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="fields" type="string" required="true" />
			<!--- Param --->
			<cfset var qry = 0>
			<!--- Call our internal function --->
			<cfinvoke component="dal" method="table_insert" returnvariable="qry">
				<cfinvokeargument name="table" value="#arguments.table#" />
				<cfinvokeargument name="fields" value="#arguments.fields#" />
			</cfinvoke>
		
		<!--- Return --->
		<cfreturn qry />
	</cffunction>
	
	<!--- DB: Delete --->
	<cffunction access="public" name="db_delete">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="where" type="string" required="true" />
			<!--- Param --->
			<cfset var qry = 0>
			<!--- Call our internal function --->
			<cfinvoke component="dal" method="table_delete" returnvariable="qry">
				<cfinvokeargument name="table" value="#arguments.table#" />
				<cfinvokeargument name="where" value="#arguments.where#" />
			</cfinvoke>
		<!--- Return --->
		<cfreturn qry />
	</cffunction>
	
	<!--- Form --->
	<cffunction access="public" name="formdo">
		<cfargument name="action" type="string" required="true" />
		<cfargument name="table" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="fields" type="array" required="true" />
		<cfargument name="submit" type="array" required="true" />
			<!--- Param --->
			<cfset var form = 0>
			<!--- Call our internal function --->
			<cfinvoke component="fal" method="form_create" returnvariable="form">
				<cfinvokeargument name="action" value="#arguments.action#" />
				<cfinvokeargument name="table" value="#arguments.table#" />
				<cfinvokeargument name="message" value="#arguments.message#" />
				<cfinvokeargument name="fields" value="#arguments.fields#" />
				<cfinvokeargument name="submit" value="#arguments.submit#" />
			</cfinvoke>
	
		<!--- Return --->
		<cfreturn form />
	</cffunction>
	
</cfcomponent>