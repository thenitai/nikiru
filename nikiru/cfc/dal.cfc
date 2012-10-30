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
<cfcomponent output="false">
	
	<cfset this.mysql_db_params = "ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_bin">

	<!--- Setup Connection to the DB --->
	<cffunction access="public" name="connect">
		<cfargument name="thestruct" type="struct" required="true" />
		<cftry>
			<!--- Test the db connection here --->
			<cfif thestruct.type EQ "mysql" OR thestruct.type EQ "h2">
				<cfquery name="testdb" datasource="#thestruct.dsn#">
				SELECT table_name
				FROM information_schema.tables
				LIMIT 1
				</cfquery>
			</cfif>
			<!--- If connection could be established --->
			<cfset application.db.type = thestruct.type>
			<cfset application.db.dsn = thestruct.dsn>
			<cfset application.db.schema = thestruct.schema>
			<cfcatch>
				Your database connection is not setup properly. <a href="bluedragon/administrator/login.cfm">Go to the admin to fix this!</a>
				<br />
				<cfdump var="#cfcatch#"><cfabort>
			</cfcatch>
		</cftry>
		<!--- Return --->
		<cfreturn />
	</cffunction>
	
	<!--- Define Table --->
	<cffunction access="public" name="define_table">
		<cfargument name="thearray" type="array" required="true" />
		<!--- Arry[1] is the table name --->
		<cfset var tablename = arguments.thearray[1][2]>
		<!--- Drop all primary keys for this table --->
		<cftry>
			<cfif application.db.type EQ "mysql" OR application.db.type EQ "h2">
				<cfquery datasource="#application.db.dsn#">
				ALTER TABLE #tablename# DROP PRIMARY KEY
				</cfquery>
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
		<!--- Create table --->
		<cftry>
			<cfif application.db.type EQ "mysql" OR application.db.type EQ "h2">
				<cfquery name="tbl" datasource="#application.db.dsn#">
				SELECT table_name
				FROM information_schema.tables
				WHERE lower(table_name) = <cfqueryparam value="#lcase(tablename)#" cfsqltype="cf_sql_varchar" />
				AND lower(table_schema) = <cfqueryparam value="#lcase(application.db.schema)#" cfsqltype="cf_sql_varchar" />
				</cfquery>
				<cfif tbl.recordcount EQ 0>
					<cfquery datasource="#application.db.dsn#">
					CREATE TABLE #tablename# (id varchar(100), PRIMARY KEY(id))
					#this.mysql_db_params#
					</cfquery>
				</cfif>
			</cfif>
			<cfcatch>
				<cflog application="true" file="Nikiru" type="error" text="#cfcatch.message# #cfcatch.detail# #cfcatch.ExtendedInfo#" />
			</cfcatch>
		</cftry>
		<!--- The rest of the array are fields --->
		<cfloop index="f" from="2" to="#arrayLen(arguments.thearray)#">
			<cftry>
				<cfif application.db.type EQ "mysql" OR application.db.type EQ "h2">
					<!--- Query information schema first --->
					<cfquery datasource="#application.db.dsn#" name="info">
					SELECT column_name
					FROM information_schema.columns
					WHERE lower(table_name) = <cfqueryparam value="#lcase(tablename)#" cfsqltype="cf_sql_varchar" />
					AND lower(column_name) = <cfqueryparam value="#lcase(arguments.thearray[f][1])#" cfsqltype="cf_sql_varchar" />
					AND lower(table_schema) = <cfqueryparam value="#lcase(application.db.schema)#" cfsqltype="cf_sql_varchar" />
					</cfquery>
					<!--- NOT found --->
					<cfif info.recordcount EQ 0>
						<!--- Check if there might be a column with this name, if so then change it before adding one --->
						<cfquery datasource="#application.db.dsn#">
						ALTER TABLE #tablename# ADD COLUMN #arguments.thearray[f][1]# #arguments.thearray[f][2]#
						</cfquery>
					<cfelse>
						<cfquery datasource="#application.db.dsn#">
						ALTER TABLE #tablename# CHANGE COLUMN #arguments.thearray[f][1]# #arguments.thearray[f][1]# #arguments.thearray[f][2]#
						</cfquery>
					</cfif>
				</cfif>
				<cfcatch>
					<cflog application="true" file="Nikiru" type="error" text="#cfcatch.message# #cfcatch.detail# #cfcatch.ExtendedInfo#" />
				</cfcatch>
			</cftry>
			<!--- Check for primary key value and add it --->
			<cftry>
				<cfif application.db.type EQ "mysql" OR application.db.type EQ "h2">
					<cfif ArrayIsDefined(arguments.thearray[f],3) AND arguments.thearray[f][3] EQ "primary">
						<cfquery datasource="#application.db.dsn#">
						ALTER TABLE #tablename# ADD PRIMARY KEY (#arguments.thearray[f][1]#)
						</cfquery>
					</cfif>
				</cfif>
				<cfcatch>
					<cflog application="true" file="Nikiru" type="error" text="#cfcatch.message# #cfcatch.detail# #cfcatch.ExtendedInfo#" />
				</cfcatch>
			</cftry>
		</cfloop>
		<!--- Cachekey --->
		<cfset session.cachekey = createuuid()>
		<!--- Return --->
		<cfreturn />
	</cffunction>
	
	<!--- Select Table --->
	<cffunction access="public" name="table_select">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="fetch" type="string" required="true" />
		<cfargument name="where" type="string" required="false" default="" />
		<cfargument name="orderby" type="string" required="false" default="" />
		<cfargument name="groupby" type="string" required="false" default="" />
		<cfargument name="limit" type="string" required="false" default="" />
		<!--- Param --->
		<cfset var qry = 0>
		<!--- Cachekey --->
		<cfif !structKeyExists(session,"cachekey")>
			<cfset session.cachekey = createuuid()>
		</cfif>
		<!--- Get field type for the where --->
		<!--- <cfinvoke component="dal" method="getfieldtype" returnvariable="datatype">
			<cfinvokeargument name="table" value="#arguments.table#" />
			<cfinvokeargument name="columnname" value="#listfirst(i,":")#" />
		</cfinvoke> --->
		<!--- Query --->
		<cfquery datasource="#application.db.dsn#" name="qry" cachedwithin="1">
		SELECT /* #session.cachekey# */ <cfif arguments.fetch EQ "">*<cfelse>#arguments.fetch#</cfif>
		FROM #arguments.table#
		<cfif arguments.where NEQ "">
			WHERE #arguments.where#
		</cfif>
		<cfif arguments.orderby NEQ "">
			ORDER BY #arguments.orderby#
		</cfif>
		<cfif arguments.limit NEQ "">
			LIMIT #arguments.limit#
		</cfif>
		</cfquery>
		<!--- Return --->
		<cfreturn qry />
	</cffunction>
	
	<!--- Insert Table --->
	<cffunction access="public" name="table_insert">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="fields" type="string" required="true" />
		<!--- Param --->
		<cfset var qry = 0>
		<cfset var theid = createuuid()>
		<!--- Do an insert of the ID --->
		<cfquery datasource="#application.db.dsn#">
		INSERT INTO #arguments.table#
		(id)
		VALUES(
			<cfqueryparam value="#theid#" cfsqltype="cf_sql_varchar" />
		)
		</cfquery>
		<cfset var thewhere = 'id = "#theid#" '>
		<!--- Now loop over the fields and do the update --->
		<cfinvoke component="dal" method="table_update" returnvariable="qry">
			<cfinvokeargument name="table" value="#arguments.table#" />
			<cfinvokeargument name="fields" value="#arguments.fields#" />
			<cfinvokeargument name="where" value="#thewhere#" />
		</cfinvoke>
		<!--- Cachekey --->
		<cfset session.cachekey = createuuid()>
		<!--- Return --->
		<cfreturn theid />
	</cffunction>
	
	<!--- Update Table --->
	<cffunction access="public" name="table_update">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="fields" type="string" required="true" />
		<cfargument name="where" type="string" required="false" />
		<!--- Param --->
		<cfset var status = true>
		<!--- Loop over the fields --->
		<cfloop list="#arguments.fields#" index="i" delimiters=",">
			<!--- Get field type --->
			<cfinvoke component="dal" method="getfieldtype" returnvariable="datatype">
				<cfinvokeargument name="table" value="#arguments.table#" />
				<cfinvokeargument name="columnname" value="#listfirst(i,":")#" />
			</cfinvoke>
			<!--- Update record --->
			<cfquery datasource="#application.db.dsn#">
			UPDATE #arguments.table#
			SET #lcase(listfirst(i,":"))# =
				<cfif datatype EQ "varchar" OR datatype CONTAINS "text">
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#listlast(i,":")#">
				<cfelseif datatype EQ "timestamp">
					<cfif listlast(i,":") EQ "today">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#listlast(i,":")#">
					</cfif>
				<cfelseif datatype EQ "date">
					<cfif listlast(i,":") EQ "today">
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_date" value="#listlast(i,":")#">
					</cfif>
				</cfif>
			<cfif arguments.where NEQ "">
				WHERE #arguments.where#
			</cfif>
			</cfquery>
		</cfloop>
		<!--- Cachekey --->
		<cfset session.cachekey = createuuid()>
		<!--- Return --->
		<cfreturn status />
	</cffunction>
	
	<!--- Delete Table --->
	<cffunction access="public" name="table_delete">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="where" type="string" required="true" />
		<!--- Param --->
		<cfset var status = true>
		<!--- Delete from table --->
		<cftry>
			<cfquery datasource="#application.db.dsn#">
			DELETE FROM #arguments.table#
			<cfif arguments.where NEQ "">
				WHERE #arguments.where#
			</cfif>
			</cfquery>
			<cfcatch>
				<cfdump var="#cfcatch#"><cfabort>
				<cfset var status = false>
			</cfcatch>
		</cftry>
		<!--- Cachekey --->
		<cfset session.cachekey = createuuid()>
		<!--- Return --->
		<cfreturn status />
	</cffunction>
	
	
	<!--- Get field type --->
	<cffunction access="public" name="getfieldtype">
		<cfargument name="table" type="string" required="true" />
		<cfargument name="columnname" type="string" required="true" />
		<!--- Query --->
		<cfquery datasource="#application.db.dsn#" name="qry_type">
		SELECT <cfif application.db.type EQ "h2">type_name as data_type<cfelse>data_type</cfif>
		FROM <cfif application.db.type EQ "oracle">all_tab_columns<cfelse>information_schema.columns</cfif>
		WHERE lower(table_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.table)#">
		AND lower(column_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.columnname#">
		</cfquery>
		<!--- Return --->
		<cfreturn qry_type.data_type />
	</cffunction>
	
</cfcomponent>