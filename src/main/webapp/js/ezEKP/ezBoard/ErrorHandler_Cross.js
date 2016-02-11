
window.onerror = function(errorMsg, url, lineNumber)
{
	window.event.cancelbubble = true;	
	window.event.returnValue = true;


	var fileLocation = window.document.location;
	var fileModified = window.document.fileModifiedDate;

	var config = "height=200px,width=700px, status = no, toolbar=no, menubar=no, location=no, resizable=1";
	window.open("/myoffice/common/ScriptErrorHandler.asp?fileLocation=" + escape(fileLocation) + "&fileModified=" + fileModified, "",config); 
}

