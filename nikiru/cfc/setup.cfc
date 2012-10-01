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
<cfcomponent output="no">

	<!--- Load Modules --->
	<cffunction name="load_modules">
		<cfargument name="currentDir" required="true">
		<!--- Param --->
		<cfset var m = "">
		<!--- Get CFC in model dir --->
		<cfdirectory action="list" directory="#arguments.currentDir#/modules" type="file" listinfo="name" filter="*.cfc" name="m" />
		<!--- Loop over list and store them --->
		<cfloop query="m">
			<!--- Remove .cfc from name --->
			<cfset n = listfirst(name,".")>
			<cfset application.nikiru["#n#"] = createobject(type="component",object="modules.#n#")>
		</cfloop>
	</cffunction>

	<!--- Load Models --->
	<cffunction name="load_models">
		<cfargument name="currentDir" required="true">
		<!--- Param --->
		<cfset var m = "">
		<!--- Get CFC in model dir --->
		<cfdirectory action="list" directory="#arguments.currentDir#/models" type="file" listinfo="name" filter="*.cfc" name="m" />
		<!--- Loop over list and store them --->
		<cfloop query="m">
			<!--- Remove .cfc from name --->
			<cfset n = listfirst(name,".")>
			<cfinvoke component="models.#n#" method="init" />
		</cfloop>
	</cffunction>

</cfcomponent>