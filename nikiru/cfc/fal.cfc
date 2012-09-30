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
		<cfargument name="args" type="string" required="false" default="" />
		<!--- Params --->
		<cfset var thefields = "">
		<!--- Do action and show result --->
		<cfif structkeyexists(form,"action") OR structkeyexists(url,"action")>
			<!--- Insert --->
			<cfif arguments.action EQ "insert">
				<!--- Put the form fields and values together --->
				<!--- img_title:some value,img_date_new:today --->
				<cfloop array="#arguments.fields#" delimiters="," index="i">
					<cfset thefields = thefields & "#i[2]#:#evaluate(i[2])#,">
				</cfloop>
				<!--- Remove the last comma --->
				<cfset var l = len(thefields)>
				<cfset thefields = removechars(thefields,l,1)>
				<!--- Call the function --->
				<cfinvoke component="dal" method="table_insert" returnvariable="qry">
					<cfinvokeargument name="table" value="#arguments.table#" />
					<cfinvokeargument name="fields" value="#thefields#" />
				</cfinvoke>
			<!--- UPDATE --->
			<cfelseif arguments.action EQ "update">
				<!--- Put the form fields and values together --->
				<!--- img_title:some value,img_date_new:today --->
				<cfloop array="#arguments.fields#" delimiters="," index="i">
					<cfset thefields= thefields & "#i[2]#:#evaluate(i[2])#,">
				</cfloop>
				<!--- Remove the last comma --->
				<cfset var l = len(thefields)>
				<cfset thefields = removechars(thefields,l,1)>
				<!--- Put together the where --->
				<cfset var thewhere = "id = ""#listfirst(arguments.args,"/")#"""> 
				<!--- Call the function --->
				<cfinvoke component="dal" method="table_update" returnvariable="qry">
					<cfinvokeargument name="table" value="#arguments.table#" />
					<cfinvokeargument name="fields" value="#thefields#" />
					<cfinvokeargument name="where" value="#thewhere#" />
				</cfinvoke>
			</cfif>
			<!--- Output to view --->
			<!--- <cfsavecontent variable="theform"><cfoutput>
			<p>#arguments.message#</p>
			</cfoutput></cfsavecontent> --->
		</cfif>
	
			<!--- Param --->
			<cfset var theform = "">
			<cfset var thefields = "">
			<!--- Unique id for this form --->
			<cfset var formid = createuuid("")>
			<!--- If this is for update we fetch the record --->
			<cfif arguments.action EQ "update">
				<!--- Get the id to query --->
				<cfset var id = listfirst(arguments.args,"/")>
				<!--- FormID --->
				<cfset var formid = id>
				<!--- Put the form fields and values together --->
				<cfloop array="#arguments.fields#" delimiters="," index="i">
					<cfset thefields = thefields & "#i[2]#,">
				</cfloop>
				<!--- Remove the last comma --->
				<cfset var l = len(thefields)>
				<cfset thefields = removechars(thefields,l,1)>
				<cfset var thewhere = "id = ""#id#"""> 
				<!--- Query table --->
				<cfinvoke component="dal" method="table_select" returnvariable="qry">
					<cfinvokeargument name="table" value="#arguments.table#" />
					<cfinvokeargument name="fetch" value="#thefields#" />
					<cfinvokeargument name="where" value="#thewhere#" />
				</cfinvoke>
			</cfif>
			<!--- Save form to variable --->
			<cfsavecontent variable="theform"><cfoutput>
			<form enctype="multipart/form-data" action="" method="post" name="#formid#" id="#formid#">
				<input type="hidden" name="action" value="#arguments.action#" />
				<input type="hidden" name="table" value="#arguments.table#" />
				<input type="hidden" name="args" value="#arguments.args#" />
				<!---
				Loop over the array and get values. We know the array has
				form label, formid, form type, required (true/false), value of field (optional)
				--->
				<cfloop array="#arguments.fields#" delimiters="," index="i">
					<p>
						<label for="#i[2]#">#i[1]#</label><br/>
						<cfif i[3] EQ "text">
							<input type="text" name="#i[2]#" id="#i[2]#" value="<cfif ArrayIsDefined(i,5)>#i[5]#<cfelseif arguments.action EQ "update">
							<cfset q = "qry.#i[2]#">#evaluate(q)#</cfif>" />
						</cfif>
					</p>
				</cfloop>
				<p>
					<input type="submit" name="submitbut" value="#arguments.submit[1][1]#" class="btn" />
				</p>
			</form>
			<!--- The JS for above form --->

			<!--- Output to view --->
			<cfif structkeyexists(form,"action")>
			<p>#arguments.message#</p>
			</cfif>
			</cfoutput></cfsavecontent>
			
		<!--- Return --->
		<cfreturn theform>
	</cffunction>
	
</cfcomponent>