
function GetAprLineTempletList()
{
	if(ConnectFlag)
	{
		var result = "";
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/aprLineTempletList.do",
			data : {
					formID  : pFormID,
					userID 	: pUserID
					},
			success: function(xml){
				result = xml;
			}        			
		});	
  
		Resultxml     = loadXMLString(result);
		ConnectFlag   = false;
	}	
	return Resultxml;
}

function AprLineTempletNameCheck(p_AprLineTempletName) {
    var AprLineTempletXml = createXmlDom();
    var p_NodeList;
    var p_NodeListLen;
    var p_AprLineTempleNameFlag = true;
    var i;

    AprLineTempletXml = GetAprLineTempletList();
    p_NodeList = SelectNodes(AprLineTempletXml, "APRTEMP/DATA");
    p_NodeListLen = p_NodeList.length;

    for (i = 0 ; i < p_NodeListLen ; i++) {
        var NodeList;
        NodeList = GetChildNodes(p_NodeList[i]);
        if (p_AprLineTempletName == getNodeText(NodeList[0])) {
                p_AprLineTempleNameFlag = false;
                break;
        }
    }

    if (!p_AprLineTempleNameFlag) {
    	alert(strLangS194 + "\n" + strLangS195);
//        var pAlertContent = strLangS194 + "<br> " + strLangS195;
//        OpenAlertUI(pAlertContent);
        document.getElementById("TxtAprLineTempletName").value = "";
        document.getElementById("TxtAprLineTempletName").focus();
    } else {
        if (ReturnFunction != null) {
            ReturnFunction(p_AprLineTempletName);
        }
        else {
            window.returnValue = p_AprLineTempletName;
            window.close();
        }
    }
}