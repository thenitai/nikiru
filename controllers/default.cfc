<!--- @@License: --->
<cfcomponent output="false" extends="nikiru.cfc.global">
	
	<cffunction access="public" name="default">
		<!--- Do something here --->
		<cfset this.customvariable = "the index">
		<!--- Load custom layout for this action --->
		<!--- <cfset this.layout = "index"> --->
		<!--- Load the view --->
		<!--- <cfset this.view = "myview" /> --->
		
		<!--- Insert --->
		<!--- The insert will return the created ID --->
		<!--- <cfset this.inserted = db_insert(table='images',fields='img_title:some value,img_date_new:today')> --->
		
		<!--- Select --->
		<!--- Paramaters to pass are: --->
		<!--- table,fetch,where,orderby,groupby,limit --->
		<!--- <cfset this.testselect = db_select(table='images',fetch='id',where='id = "#this.inserted#"',orderby='',groupby='',limit='')> --->
		
		<!--- 
			Form
			Form takes arguments: 
			action = insert, update (you need to pass id of record)
			table = what table to take action on
			message = The text shown to user after submit
			fields = An array of fields (desc below)
			submit = An array for the submit (desc below)
		--->
		
		<!--- Define fields: Label, fieldid, field type, required (true/false), initial field value (optional) --->
		<cfset arrFields = [["Enter name","img_title","text","true"]] />
		<!--- Define Submit button: Label, action (in case for custom ajax or js call) (optional) --->
		<cfset arrSubmit = [["Insert this record"]] />
		<!--- This is the actual form call --->
		<cfset this.createform = formdo(action='insert',table='images',message='We have successfully added the record!',fields='#arrFields#',submit='#arrSubmit#')>
		
		<!--- Form End --->
		
		<!--- Delete --->
		<!--- Paramaters to pass are: --->
		<!--- table,where (if the where is empty you will remove aLL records in the table !!! )--->
		<!--- <cfset this.delete = db_delete(table='images',where='id = "#this.inserted#"')> --->
		
		<!--- Return --->
		<cfreturn this />
	</cffunction>
	
	<cffunction access="public" name="test">
		<!--- Do something here --->
		<cfset this.result = "the test">
		<!--- Return --->
		<cfreturn this />
	</cffunction>
	
	<cffunction access="public" name="test2">
		<!--- Load the view --->
		<cfset this.view = "test" />
		<!--- Do something here --->
		<cfset this.result = "the test2 view">
		<!--- Return --->
		<cfreturn this />
	</cffunction>
	
</cfcomponent>