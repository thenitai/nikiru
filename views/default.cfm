<cfoutput>
<h1>I'm the default view</h1>

My custom variable <!--- <cfdump var="#variables.controller.customvariable#" /> ---><br />
<!--- The insert <cfdump var="#variables.controller.inserted#" /><br />
The select <cfdump var="#variables.controller.testselect#" /><br />
The delete <cfdump var="#variables.controller.delete#" /> --->
Here is the form:
#variables.controller.createform#



</cfoutput>