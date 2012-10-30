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
<cfcomponent output='false' extends='nikiru.cfc.dal'>
	
	<!--- Init --->
	<cffunction access='public' name='init'>
		
		<!---  --->
		<!--- Define your database parameters here --->
		<!--- If you are changing any of these setting during runtime you need to restart the server --->
		<!--- If the 'reload' setting is set to TRUE then the settings below will take affect immediately! --->
		<!---  --->
		
		<!--- Setup Tables --->
		<cfset define_table([['tablename','users'],['user_id','varchar(100)','primary'],['user_email','varchar(200)'],['user_first_name','varchar(200)'],['user_last_name','varchar(300)'],['user_pass','varchar(200)']])>
	
		<!--- Another table --->
		<cfset define_table([['tablename','images'],['img_title','varchar(100)'],['img_date_new','timestamp']])>
		


		<!---  --->
		<!--- That's it. Nothing else to do here. --->
		<!--- Don't forget to restart your application if you are changing these values during runtime! --->
		<!---  --->
		
	</cffunction>
</cfcomponent>