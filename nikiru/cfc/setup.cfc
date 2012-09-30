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