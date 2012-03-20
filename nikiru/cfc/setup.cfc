<cfcomponent output="no">

	<!--- Load all the model files --->
	<cffunction name="load_model">
		<cfargument name="currentDir" required="true">
		<!--- Get CFC in model dir --->
		<cfdirectory action="list" directory="#arguments.currentDir#/models" type="file" listinfo="name" filter="*.cfc" name="m" />
		<!--- Loop over list and store them --->
		<cfloop query="m">
			<!--- Remove .cfc from name --->
			<cfset n = listfirst(name,".")>
			<cfset application.nikiru["#n#"] = createobject(type="component",object="models.#n#")>
		</cfloop>
	</cffunction>

</cfcomponent>