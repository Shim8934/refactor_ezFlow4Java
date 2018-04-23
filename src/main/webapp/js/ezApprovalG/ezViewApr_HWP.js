
function openOpinionViewUI() {
	var parameter = new Array();
	parameter[0]  = pDocID;
	parameter[1]  = pOpinionType;   
	parameter[2]  = "";
	parameter[3]  = ""; 
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = "hwp";
    
	var url = "/ezApprovalG/aprOpinion.do";
	var feature = "status:no;dialogWidth:530px;dialogHeight:520px;scroll:no;edge:sunken"
	var ret = window.showModalDialog(url,parameter,feature);
}

function OpenInformationUI(pInformationContent) { 
    var parameter = pInformationContent;
	var url = "/ezApprovalG/ezAprOpinion.do";
	var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);

	return RtnVal;
}

function OpenAlertUI(pAlertContent) {
	var parameter	= pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	var RtnVal		= window.showModalDialog(url,parameter,feature);
}

function setMenuBar(id,flag)
{
	var strCmd, display_Value
		
	if(flag) 
		display_Value = ""
	else
		display_Value = "none"
	
	strCmd = id + ".style.display='" + display_Value + "'"
	eval(strCmd); 
}

function getHistory() {
    var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + docHref.substr(docHref.length - 3, docHref.length).toLowerCase();
	centerOpenWindow(URL, 730, 430);
}

function centerOpenWindow(wfileLocation, wWeight, wHeight)
{
	try{
		var heigth = window.screen.availHeight;
		var width = window.screen.availWidth;
		
		var left = (width - wWeight) / 2;
		var top = (heigth - wHeight) / 2;
		
		window.open(wfileLocation, "" ,"toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	
	}catch(e){
		alert("centerOpenWindow :: " + e.description);
	}
}
function SignCheck() {
    var SignXML = createXmlDom();

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();


    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);

    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/getSignInfo.aspx", false);
    xmlhttp.send(xmlpara);

    if (loadXMLString(xmlhttp.responseText).xml == "")
        return;

    var NodeList;
    NodeList = loadXMLString(xmlhttp.responseText).selectNodes("SIGNINFOS/SIGNINFO");
    if (NodeList.length <= 0)
        return;

    SignXML = loadXMLString(xmlhttp.responseText);
    var rtnVal = putSignXML(SignXML);
    if (rtnVal) {
        SaveFile();
    }
}

function putSignXML(SignXML) {
    var retVal = false;
    try {
        var NodeList;
        NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
        if (NodeList.length > 0) {
            for (i = 0; i < NodeList.length; i++) {
                var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
                var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
                var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));

                if (HwpCtrl.CheckFieldExist(SignName)) {
                    retVal = true;
                    if (SignType == "TEXT") {
                        HwpCtrl.SetFieldText(SignName, SignCont);
                    }
                    else if (SignType == "HTML") {
                        HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
                    }
                    else if (SignType == "PROXY") {
                        HwpCtrl.SetFieldText(SignName, " ");
                        HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SignCont), 3, 0, 0, true, 2);
                        HwpCtrl.AppendFieldText(SignName, strLang17, true);
                    }
                    else if (SignType == "IMAGE") {
                        var img = SignCont.split("::");
                        HwpCtrl.SetFieldText(SignName, "");
                        if (img.length >= 1)
                            HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]), 3, 0, 0, true, 2);

                        if (img.length >= 2)
                            HwpCtrl.AppendFieldText(SignName, img[1], true);
                    }
                }
            }
        }
    } catch (e) {
        alert("putSignXML : " + e.description);
        return false;
    }
    return retVal;
}

function SaveFile() {

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));


    xmlhttp.open("POST", "aspx/SaveFileHWP.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
