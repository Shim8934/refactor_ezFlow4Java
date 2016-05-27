
function GetAprLineTempletList()
{
	if(ConnectFlag)
	{
		var result = "";
		$.ajax({
			type : "POST",
			dataType : "xml",
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
  
		Resultxml     = result;
		ConnectFlag   = false;
	}	
	return Resultxml;
}

function AprLineTempletNameCheck(p_AprLineTempletName) {
    var AprLineTempletXml = createXmlDom();
    var p_NodeList;
    var p_NodeListLen;
    var p_AprLineTempleNameFlag = false;
    var i;

    AprLineTempletXml = GetAprLineTempletList();
    p_NodeList = SelectNodes(AprLineTempletXml, "APRTEMP/DATA");
    p_NodeListLen = p_NodeList.length;

    for (i = 0 ; i < p_NodeListLen ; i++) {
        var NodeList;
        NodeList = GetChildNodes(p_NodeList[i]);

        if (p_AprLineTempletName == getNodeText(NodeList[0])) {
            p_AprLineTempleNameFlag = true;
            break;
        }
    }

    if (p_AprLineTempleNameFlag && g_TemplateSN == "") {
        var pAlertContent = strLang194 + "<br> " + strLang195;
        OpenAlertUI(pAlertContent);
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

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN() || NonActiveX == "YES") {
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

function OpenAlertUI_Complete(){
    DivPopUpHidden();
}