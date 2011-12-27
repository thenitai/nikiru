<!--- @@License: --->
<cfcomponent output="false">
	
	<!--- Create the form --->
	<!--- This actually also calls the action after the submit --->
	<cffunction access="public" name="form_create">
		<cfargument name="action" type="string" required="true" />
		<cfargument name="table" type="string" required="true" />
		<cfargument name="message" type="string" required="true" />
		<cfargument name="fields" type="array" required="true" />
		<cfargument name="submit" type="array" required="true" />
		<!--- Do action and show result --->
		<cfif structkeyexists(form,"action") OR structkeyexists(url,"action")>
			<!--- Do the action here --->
			<cfset var thefields = "">
			<!--- Insert --->
			<cfif arguments.action EQ "insert">
				<!--- Put the form fields and values together --->
				<!--- img_title:some value,img_date_new:today --->
				<cfloop array="#arguments.fields#" delimiters="," index="i">
					<cfset thefields= thefields & "#i[2]#:#evaluate(i[2])#,">
				</cfloop>
				<!--- Remove the last comma --->
				<cfset var l = len(thefields)>
				<cfset thefields = removechars(thefields,l,1)>
				<!--- Call the function --->
				<cfinvoke component="dal" method="table_insert" returnvariable="qry">
					<cfinvokeargument name="table" value="#arguments.table#" />
					<cfinvokeargument name="fields" value="#thefields#" />
				</cfinvoke>
			</cfif>
			<!--- Output to view --->
			<cfsavecontent variable="theform"><cfoutput>
			<p>#arguments.message#</p>
			</cfoutput></cfsavecontent>
		<cfelse>
			<!--- Param --->
			<cfset var theform = "">
			<!--- Unique id for this form --->
			<cfset var formid = replace(createuuid(),"-","","all")>
			<!--- Save form to variable --->
			<cfsavecontent variable="theform"><cfoutput>
			<form enctype="multipart/form-data" action="" method="post" name="#formid#" id="#formid#">
				<input type="hidden" name="action" value="#arguments.action#" />
				<input type="hidden" name="table" value="#arguments.table#" />
				<!---
				Loop over the array and get values. We know the array has
				form label, formid, form type, required (true/false), value of field (optional)
				--->
				<cfloop array="#arguments.fields#" delimiters="," index="i">
					<p>
					<label for="#i[2]#">#i[1]#</label><br/>
					<cfif i[3] EQ "text">
						<input type="text" name="#i[2]#" id="#i[2]#" value="<cfif ArrayIsDefined(i,5)>#i[5]#</cfif>" />
					</cfif>
					</p>
				</cfloop>
				<p>
					<input type="submit" name="submitbut" value="#arguments.submit[1][1]#" />
				</p>
			</form>
			<!--- The JS for above form --->
			
			</cfoutput></cfsavecontent>
		</cfif>		
		<!--- Return --->
		<cfreturn theform>
	</cffunction>
	
</cfcomponent>