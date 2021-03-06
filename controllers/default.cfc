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
<cfcomponent output="false" extends="nikiru.cfc.global">
	
	<cffunction access="remote" name="default" returnType="struct" returnformat="json">
		<!--- Struct --->
		<cfset var s = structNew()>
		<!--- Do something here --->
		<cfset s.customvariable = "the index">
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
		<cfset var arrFields = [["Enter name","img_title","text","true"]] />
		<!--- Define Submit button: Label, action (in case for custom ajax or js call) (optional) --->
		<cfset var arrSubmit = [["Insert this record"]] />
		<!--- This is the actual form call --->
		<cfset s.createform = form_do(action='insert',table='images',message='We have successfully added the record!',fields='#arrFields#',submit='#arrSubmit#')>
		
		<cfset s.qry_img = db_select(table='images',fetch='id,img_title,img_date_new',where='',orderby='',groupby='',limit='')>
		
		<!--- Form End --->
		
		
		
		<!--- Delete --->
		<!--- Paramaters to pass are: --->
		<!--- table,where (if the where is empty you will remove ALL records in the table !!! )--->
		<!--- <cfset this.delete = db_delete(table='images',where='id = "#this.inserted#"')> --->
		


		<!--- Return --->
		<cfreturn s />
	</cffunction>
	
	<cffunction access="public" name="edit_record">
		<cfargument name="args" type="struct" required="false" />
		<!--- Define fields: Label, fieldid, field type, required (true/false), initial field value (optional) --->
		<cfset var arrFields = [["Enter name","img_title","text","true"]] />
		<!--- Define Submit button: Label, action (in case for custom ajax or js call) (optional) --->
		<cfset var arrSubmit = [["Update this record"]] />
		<!--- Update form --->
		<cfset this.updateform = form_do(action='update',table='images',message='We have successfully updated the record!',fields='#arrFields#',submit='#arrSubmit#',args=arguments.args.args)>
		<!--- Translation --->
		<cfset this.username = T('username')>
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