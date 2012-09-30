<!--- @@License: --->
<cfcomponent output='false' extends='nikiru.cfc.dal'>
	
	<!--- Init --->
	<cffunction access='public' name='init'>
		
		<!---  --->
		<!--- Define your database parameters here --->
		<!--- If you are changing any of these setting during runtime you need to restart the server --->
		<!--- If the 'reload' setting is set to TRUE then the settings below will take affect immediately! --->
		<!---  --->
		
		<!--- Setup Tables --->
		<cfset define_table([['tablename','mytable'],['title','varchar(50)'],['sometext','varchar(100)']])>
	
		<!--- Another table --->
		<cfset define_table([['tablename','images'],['img_title','varchar(100)'],['img_date_new','timestamp']])>
	
		<!---  --->
		<!--- That's it. Nothing else to do here. --->
		<!--- Don't forget to restart your application if you are changing these values during runtime! --->
		<!---  --->
		
	</cffunction>
</cfcomponent>