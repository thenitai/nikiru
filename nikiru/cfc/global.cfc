<!---
*
* This file is part of Nikiru - the web framework that gets out of your way.
*
* Nikiru is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* any later version.
*
* Nikiru is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Nikiru. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the GPL. 
* You should have received a copy of the FLOSS exception
* along with Nikiru. If not, see <http://www.Nikiru.com/licenses/>.
*
--->
<cfcomponent output="false">
		
	<!--- Load --->
	<cffunction access="public" name="load">
		<cfargument name="thecgi" type="struct" required="true" />
		<!--- Params --->
		<cfset var thisstruct = structNew()>
		<cfset var con_return = "">
		<!--- set the controller --->
		<cfif arguments.thecgi.query_string EQ "" OR arguments.thecgi.query_string EQ "/">
			<cfset var thecontroller = "default">
			<cfset var thefunction = thecontroller>
			<cfset thisstruct.layout = thecontroller>
			<cfset thisstruct.view = thecontroller>
		<cfelse>
			<!--- Get the first part of the query string before the & --->
			<cfset var thefirstpart = listfirst(arguments.thecgi.query_string,"&")>
			<cfset thisstruct.args = listlast(arguments.thecgi.query_string,"&")>
			<!--- Controller --->
			<cfset var thecontroller = listfirst(thefirstpart,"/")>
			<!--- Function --->
			<cfset var thefunction = listlast(thefirstpart,"/")>
			<!--- Layout and view --->
			<cfset thisstruct.layout = thecontroller>
			<cfset thisstruct.view = thefunction>
			<!--- If API call --->
			<cfif thecontroller EQ "api">
				<cfset thisstruct.view = "api">
			</cfif>
		</cfif>
		<!--- Check that there is a controller with this name --->
		<cftry>
			<!--- Combine the arguments and the thisstruct --->
			<cfset structAppend(arguments, thisstruct)>
			<!--- Controller --->
			<cfinvoke component="controllers.#thecontroller#" method="#thefunction#" args="#arguments#" returnvariable="con_return" />
			<!--- Load the layout. Did the user define a custom layout for this controller? --->
			<cfif NOT structkeyexists(con_return,"layout")>
				<cfset con_return.layout = thisstruct.layout>
			</cfif>
			<!--- Load the view --->
			<cfif NOT structkeyexists(con_return,"view")>
				<cfset con_return.view = thisstruct.view>
			</cfif>
			<!--- Set the layout and view into application variables for --->
			<cfset application.nikiru.layout = con_return.layout>
			<cfset application.nikiru.view = con_return.view>
			<!--- Load the URL into parameters --->
			<cfset con_return.args = url>
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
		<cfsavecontent variable="variables.content"><cfinclude template="#path_views##arguments.thestruct.view#.cfm" /></cfsavecontent>
		<!--- Load layout --->
		<cfinclude template="#path_layouts##arguments.thestruct.layout#.cfm">
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
	<cffunction access="public" name="form_do">
		<cfargument name="action" type="string" required="true" />
		<cfargument name="table" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="fields" type="array" required="true" />
		<cfargument name="submit" type="array" required="true" />
		<cfargument name="args" type="string" required="false" default="" />
			<!--- Param --->
			<cfset var theform = 0>
			<!--- Call our internal function --->
			<cfinvoke component="fal" method="form_create" returnvariable="theform">
				<cfinvokeargument name="action" value="#arguments.action#" />
				<cfinvokeargument name="table" value="#arguments.table#" />
				<cfinvokeargument name="message" value="#arguments.message#" />
				<cfinvokeargument name="fields" value="#arguments.fields#" />
				<cfinvokeargument name="submit" value="#arguments.submit#" />
				<cfinvokeargument name="args" value="#arguments.args#" />
			</cfinvoke>
		<!--- Return --->
		<cfreturn theform />
	</cffunction>
	
	<!--- Translation --->
	<cffunction access="public" name="T">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="resource" type="string" required="false" default="default" />
		<cfargument name="values" hint="Array of values to substitute for $1, $2 etc in the resource string" type="array" required="false" default="#arrayNew(1)#" />
		<cfargument name="locale" hint="Resource Locale" type="string" required="false" default="en" />
		<!--- Return --->
		<cfreturn application.nikiru.resourcemanager.getString(resourceBundleName=arguments.resource,key=arguments.key,values=arguments.values,locale=arguments.locale) />
	</cffunction>

</cfcomponent>