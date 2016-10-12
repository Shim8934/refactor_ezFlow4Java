//#############################################################################################################################################즐겨찾기 관련 소스
function InitAprlineTemplet() {
    GetAprLineTempletList();
}
//#############################################################################################################################################즐겨찾기 리스트 로드
var xmlhttpTempletList;
function GetAprLineTempletList() {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/getLineTemplist.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID
				},
		success: function(text){
			event_GetAprLineTempletList(text);
		}        			
	});
}
function event_GetAprLineTempletList(text)
{
    try
    {
        if (document.getElementById("APRTEMPLIST").innerHTML != "") document.getElementById("APRTEMPLIST").innerHTML = "";
        var TempletList = new ListView();      
        TempletList.SetID("lvAPRTEMPLIST");
        TempletList.SetRowOnClick("lvAPRTEMPLIST_onSel_Click");    
        TempletList.SetSelectFlag(true);
        TempletList.SetHeightFree(true);
        
        TempletList.DataSource(loadXMLString(text));
        TempletList.DataBind("APRTEMPLIST");                        

        var pCurSelRow = TempletList.GetSelectedRows();
        if (pCurSelRow.length != 0) {
            GetAprLineTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
        }
        else{
            document.getElementById("APRTEMP").innerHTML = "";
        }
        Lineinfoini = true;
        
    }
    catch (ErrMsg) 
    {
        alert(" GetAprLineTempletList : " + ErrMsg.description);
    }
}
//#############################################################################################################################################즐겨찾기 리스트 클릭 이벤트
function lvAPRTEMPLIST_onSel_Click() {
    var liveView = new ListView();     
    liveView.SetID("lvAPRTEMPLIST");
    var pCurSelRow = liveView.GetSelectedRows();
    if (pCurSelRow.length != 0) {
        GetAprLineTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
    }
}
//#############################################################################################################################################즐겨찾기 리스트 세부리스트 로드
var xmlHTTPLineTempletInfo;
function GetAprLineTempletInfo(p_AprLineTempletID) {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/aprLineTempletListInfo.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprLineSN: p_AprLineTempletID
				},
		success: function(text){
			event_GetAprLineTempletInfo(text);
		}        			
	});
}
function event_GetAprLineTempletInfo(text)
{
	try
	{
	    //Resultxml = loadXMLString(xmlHTTPLineTempletInfo.responseXML);
	    if (document.getElementById("APRTEMP").innerHTML != "")
	        document.getElementById("APRTEMP").innerHTML = "";
	    var pAPRTEMP = new ListView();     
	    pAPRTEMP.SetID("lvAPRTEMP");
	    pAPRTEMP.SetMulSelectable(false);   
	    pAPRTEMP.SetHeightFree(true);
	    pAPRTEMP.SetSelectFlag(false);
	    pAPRTEMP.DataSource(loadXMLString(text));
	    pAPRTEMP.DataBind("APRTEMP");
	    xmlHTTPLineTempletInfo = null;
	}
	catch (ErrMsg) {
	    alert(" GetAprLineTempletInfo : " + ErrMsg.description);
	}
}
//#############################################################################################################################################즐겨찾기 관련 소스
//#############################################################################################################################################즐겨찾기 저장
var aprlinetempletname_cross_dialogArguments = new Array();
function btn_SaveAprLineTemplet_onclick()
{
    var pAPRLINE = new ListView();    
    pAPRLINE.LoadFromID("lvAPRLINE");
   
	var ListViewLen = pAPRLINE.GetDataRows();
	
	if(ListViewLen.length != "0")
	{
	    var windowName = "/ezApprovalG/aprLineTempletName.do";
	    var dialogValue = new Array();
	    dialogValue[0] = pUserID;
	    dialogValue[1] = pFormID;
	    dialogValue[2] = "";
	    dialogValue[3] = "";
	    p_CheckAprLineTempletSN = "";
	    pAprLineTempletFlag = false;
	    if (CrossYN()) {
	        aprlinetempletname_cross_dialogArguments[0] = dialogValue;
	        aprlinetempletname_cross_dialogArguments[1] = btn_SaveAprLineTemplet_onclick_Complete;
	        DivPopUpShow(360, 220, windowName);
	    }
	    else {
	        var parameter = "status:no;dialogWidth:340px;dialogHeight:205px;scroll:no;edge:sunken";
	       

	        parameter = parameter + GetShowModalPosition(340, 205);
	        var ret = window.showModalDialog(windowName, dialogValue, parameter);
	        if (ret != "cancel") {
	            CreateNewAprLineTemplet(ret);
	        }
	    }
	}else{
	    var pAlertContent = linealt5;
		OpenAlertUI(pAlertContent);
	}
}

function btn_SaveAprLineTemplet_onclick_Complete(ret) {
    if (ret != "cancel") {
        CreateNewAprLineTemplet(ret);
    }
    else
        DivPopUpHidden();
}

function CreateNewAprLineTemplet(p_AprLineTempletName) {
    var AprLineTemplet = createXmlDom();
    var xmlhttp = createXMLHttpRequest();
    var p_AprLineTempletID;

    AprLineTemplet = AprLineTempletXmlParsing(p_AprLineTempletName);
    AprLineChangeType();
    var AprLineXml = APRLINETEMPLETXMLParsing();
    var AprLineInfo = createXmlDom();
    AprLineInfo = loadXMLString(AprLineXml);

    if (CrossYN()) {
        var xmlRtn = AprLineTemplet.documentElement;
        var Node = AprLineInfo.importNode(xmlRtn, true);
        AprLineInfo.documentElement.appendChild(Node);
    }
    else {
        var xmlRtn = AprLineTemplet.documentElement;
        AprLineInfo.documentElement.appendChild(xmlRtn);
    }

    xmlhttp.open("Post", "/ezApprovalG/createAprLineTemplet.do", false);
    xmlhttp.send(AprLineInfo);

    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var RtnVal = getNodeText(dataNodes[0]);
    if (RtnVal == "TRUE") {
        OpenAlertUI(strLang814, CreateNewAprLineTemplet_Complete);
        if (!CrossYN())
            InitAprlineTemplet();
    } else {
        OpenAlertUI(strLang131);
    }
}

function CreateNewAprLineTemplet_Complete() {
    DivPopUpHidden();
    InitAprlineTemplet();
}
function AprLineTempletXmlParsing(p_AprLineTempletName) {
    var pAprLineSN;
    if (pAprLineTempletFlag) {
        pAprLineSN = p_CheckAprLineTempletSN;
    } else {
        pAprLineSN = "";
    }
    var xmlpara = createXmlDom();
    var objNode;

    createNodeInsert(xmlpara, objNode, "APRTEMP");
    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
    createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);
    createNodeAndInsertText(xmlpara, objNode, "pAprLineSN", pAprLineSN);
    createNodeAndInsertText(xmlpara, objNode, "p_AprLineTempletName", p_AprLineTempletName);

    return xmlpara;
}
//#############################################################################################################################################즐겨찾기 삭제
function btn_DelAprLineTemplet_onclick()
{
    var pAPRTemplist = new ListView();
    pAPRTemplist.LoadFromID("lvAPRTEMPLIST");
    var ListViewLen = pAPRTemplist.GetSelectedRows();
    
    if(ListViewLen.length < 1)
	{
		var pAlertContent = linealt6;
		OpenAlertUI(pAlertContent);
		return;
	}
	var p_SelAprLineTempletSN;
	var pInformationContent = linealt7;
	var Ans = OpenInformationUI(pInformationContent, btn_DelAprLineTemplet_onclick_Complete);
	if (!CrossYN()) {
	    if (Ans) {
	        p_SelAprLineTempletSN = ListViewLen[0].getAttribute("DATA1");
	        DelAprLineTempletList(p_SelAprLineTempletSN);
	    }
	}
}

function btn_DelAprLineTemplet_onclick_Complete(Ans) {
    if (Ans) {
        var pAPRTemplist = new ListView();
        pAPRTemplist.LoadFromID("lvAPRTEMPLIST");
        var ListViewLen = pAPRTemplist.GetSelectedRows();
        p_SelAprLineTempletSN = ListViewLen[0].getAttribute("DATA1");
        DelAprLineTempletList(p_SelAprLineTempletSN);
    }
    DivPopUpHidden();
}
//#############################################################################################################################################즐겨찾기 삭제
function DelAprLineTempletList(p_SelAprLineTempletSN) {
	var result = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/delAprLineTempletList.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprLineSN: p_SelAprLineTempletSN
				},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
	
    var dataNodes = GetChildNodes(result);
    var RtnVal = getNodeText(dataNodes[0]);

    if (RtnVal != "TRUE") {
        var parameter = strLang192 + "<br> " + strLang164;
        OpenAlertUI(parameter);
    } else {
        InitAprlineTemplet();
    }
}
//#############################################################################################################################################즐겨찾기 수정
function btn_ModifyToAprLine_onclick() {
    var pAPRTemplist = new ListView(); 
    pAPRTemplist.LoadFromID("lvAPRTEMPLIST");
    var ListViewLen = pAPRTemplist.GetSelectedRows();
    
    if(ListViewLen.length < 1)
	{
		return;
	}
    
    p_CheckAprLineTempletSN = ListViewLen[0].getAttribute("DATA1");
    p_CheckAprLineTempletName = ListViewLen[0].getAttribute("DATA2");
    if (p_CheckAprLineTempletSN == "") {
        var pAlertContent = linealt8;
        OpenAlertUI(pAlertContent);
        return;
    }
    else {
        var windowName = "/ezApprovalG/aprLineTempletName.do";
        var dialogValue = new Array();
        dialogValue[0] = pUserID;
        dialogValue[1] = pFormID;
        dialogValue[2] = p_CheckAprLineTempletSN;
        dialogValue[3] = p_CheckAprLineTempletName;
        if (CrossYN()) {
            aprlinetempletname_cross_dialogArguments[0] = dialogValue;
            aprlinetempletname_cross_dialogArguments[1] = btn_ModifyToAprLine_onclick_Complete;

            DivPopUpShow(360, 220, windowName);
        }
        else {
            var parameter = "status:no;dialogWidth:340px;dialogHeight:205px;scroll:no;edge:sunken";
            parameter = parameter + GetShowModalPosition(340, 205);
            var ret = window.showModalDialog(windowName, dialogValue, parameter);
            if (ret != "cancel") {
                pAprLineTempletFlag = true;
                CreateNewAprLineTemplet(ret);
            }
        }
    }
}

function btn_ModifyToAprLine_onclick_Complete(ret) {
    if (ret != "cancel") {
        pAprLineTempletFlag = true;
        CreateNewAprLineTemplet(ret);
    }
    else
        DivPopUpHidden();
}
//#############################################################################################################################################즐겨찾기 적용
function btn_AddToAprLine_onclick()
{
    var pAPRTemplist = new ListView();      
    pAPRTemplist.LoadFromID("lvAPRTEMPLIST");
    var ListViewLen = pAPRTemplist.GetSelectedRows();

    if(ListViewLen.length < 1)
	{
		return;
	}

    p_CheckAprLineTempletSN = ListViewLen[0].getAttribute("DATA1");
	if(p_CheckAprLineTempletSN == "")
	{
		var pAlertContent = linealt8;
		OpenAlertUI(pAlertContent);
		return;
	}
	else if(p_CheckAprLineTempletSN == linealt9)
	{
		p_CheckAprLineTempletSN = "1";
	}
	if(pReDraftAprLineFlag)
	{
	    var pAlertContent = linealt10;
		OpenAlertUI(pAlertContent);
	}
	else
	{
		AddToAprLineFromAprLineTemplet(p_CheckAprLineTempletSN);		
		pAprLineTempletFlag = true;
		p_CheckAprLineTempletSN = ListViewLen[0].getAttribute("DATA1"); 
		p_CheckAprLineTempletName = ListViewLen[0].getAttribute("DATA2");
	}
	initJunGyul();
}
//#############################################################################################################################################즐겨찾기 적용
function AddToAprLineFromAprLineTemplet(p_CheckAprLineTempletSN) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/addToAprLine.do",
		data : {
				userID 	 : pUserID,
				formID   : pFormID,
				aprSN	 : p_CheckAprLineTempletSN
				},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});

    Resultxml = result;
    if (document.getElementById("APRLINE").innerHTML != "")
        document.getElementById("APRLINE").innerHTML = "";

    var pAPRLINE = new ListView();  
    pAPRLINE.SetID("lvAPRLINE");
    pAPRLINE.SetMulSelectable(false);
    pAPRLINE.SetHeightFree(true);
    pAPRLINE.SetRowOnClick("OnSelChange_onclick");
    pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
    pAPRLINE.SetSelectFlag(false);

    var lastlineRows = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
    var pDraftWriterID;
    var pDraftDepteID;

    pDraftWriterID = getNodeText(lastlineRows[lastlineRows.length - 1].childNodes[0].childNodes[4]);
    pDraftDepteID = getNodeText(lastlineRows[lastlineRows.length - 1].childNodes[0].childNodes[6]);
    
    if (pUserID == pDraftWriterID && pDraftDepteID == arr_userinfo[4]) {
        aprlinecount = 0;
        pAPRLINE.DataSource(Resultxml);
        pAPRLINE.DataBind("APRLINE");
        LineAprTyepSetAll();
    }
    else {
        OpenAlertUI(strLang364);
    }
}