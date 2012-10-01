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

	<cffunction access="remote" name="myapi">
		<cfargument name="args" type="struct" />

		<cfset var q = db_select(table='images',fetch='id,img_title,img_date_new',where='',orderby='',groupby='',limit='')>
		
		<cfset this.apireturn = serializejson(q)>

		<!--- Return --->
		<cfreturn this />
	</cffunction>

</cfcomponent>

