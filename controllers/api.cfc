<!--- @@License: --->
<cfcomponent output="false" extends="nikiru.cfc.global">

	<cffunction access="remote" name="myapi">
		<cfargument name="args" type="struct" />

		<cfset var q = db_select(table='images',fetch='id,img_title,img_date_new',where='',orderby='',groupby='',limit='')>
		
		<cfset this.apireturn = serializejson(q)>

		<!--- Return --->
		<cfreturn this />
	</cffunction>

</cfcomponent>