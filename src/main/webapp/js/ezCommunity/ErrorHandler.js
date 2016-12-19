window.onerror = function () {
    window.event.cancelbubble = true;
    window.event.returnValue = true;

    var fileLocation = window.document.location;
    var fileModified = window.document.fileModifiedDate;
    /*
        var config = "status:false;dialogWidth:600px;dialogHeight:140px;scroll:no;status:no;edge:sunken";
        window.showModalDialog("/myoffice/common/ScriptErrorHandler.asp?fileLocation=" + escape(fileLocation) + "&fileModified=" + fileModified, "",config); 
    */
}