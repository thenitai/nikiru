<!--- @@Copyright: Copyright (c) 2011 __MyCompanyName__. All rights reserved. --->
<!--- @@License: --->
<cfoutput>
This is a default layout that loads the view <br />
I'm loading view: #application.nikiru.view#
	<!--- Variable to fill --->
	#content#
	<!--- 	Something after the view --->
	<p>Loading this after the view has loaded. Maybe some footer here</p>
</cfoutput>