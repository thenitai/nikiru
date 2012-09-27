<cfoutput>
<h1>I'm the default view</h1>

Translation: <cfdump var="#application.nikiru.t.getstring('homepage','username')#">

My custom variable <!--- <cfdump var="#variables.controller.customvariable#" /> ---><br />
<!--- The insert <cfdump var="#variables.controller.inserted#" /><br />
The select <cfdump var="#variables.controller.testselect#" /><br />
The delete <cfdump var="#variables.controller.delete#" /> --->
Here is the form:
#variables.controller.createform#

<p>The select</p>

<cfloop query="variables.controller.qry_img">
	#img_title# #img_date_new# <a href="/default/edit_record/#id#">Edit</a><br />
</cfloop>

</cfoutput>