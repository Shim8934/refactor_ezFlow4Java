function GetAprDeptTempletList()
{
	if(ConnectFlag)
	{
		var result = "";
		
		$.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/getAprDeptTempletList.do",
			data : {
					userID 	 : pUserID,
					formID   : pFormID
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

function AprDeptTempletNameCheck(p_AprDeptTempletName)
{
	var AprDeptTempletXml = createXmlDom();
	var p_NodeList;
	var p_NodeListLen;
	var p_AprDeptTempleNameFlag = false;
	var i;
	
	AprDeptTempletXml = GetAprDeptTempletList();
	p_NodeList = SelectNodes(AprDeptTempletXml, "APRTEMP/DATA");
	p_NodeListLen = p_NodeList.length;
	
	for(i = 0 ; i < p_NodeListLen ; i++)
	{
		if(p_AprDeptTempletName == getNodeText(GetChildNodes(p_NodeList[i])[0]) )
		{
			if( pDeptTempletName != p_AprDeptTempletName )
			{
				p_AprDeptTempleNameFlag = true;
				break;
			}
		}
	}
	
	if(p_AprDeptTempleNameFlag)
	{
		var pAlertContent = strLang232 + "<br> " + strLang233;
		OpenAlertUI(pAlertContent);
	    TxtAprDeptTempletName.value = "";
		TxtAprDeptTempletName.focus();  
	}
	else
	{
	    if (ReturnFunction != null) {
	        ReturnFunction(p_AprDeptTempletName);
	    }
	    else{
	        window.returnValue = p_AprDeptTempletName;
	        window.close();
	    }
	}
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}