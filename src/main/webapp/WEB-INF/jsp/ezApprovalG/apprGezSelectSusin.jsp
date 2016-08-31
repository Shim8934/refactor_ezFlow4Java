<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code='ezApprovalG.t235'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css"/>
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<link rel="stylesheet" href="/css/organ_tree.css" type="text/css"/>    
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>	
<script type="text/javascript"  src="/js/ezApprovalG/TreeView.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript"  src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
<script type="text/javascript" >
var pDocID;       // DocID Declare Static Variable
var SusinXML;
var xmlhttp = createXMLHttpRequest();
var Resultxml = createXmlDom();
var xmlpara = createXmlDom();
var OrderCell = "";
var arr_userinfo = new Array();
arr_userinfo[0]  = "user";								// 사용자-부서구분
arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";              // 사용자ID
arr_userinfo[2]  = "<c:out value ='${userInfo.displayName1}'/>";         // 사용자명
arr_userinfo[3]  = "<c:out value ='${userInfo.title1}'/>";             // 사용자 직위
arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";              // 사용자 부서 ID    
arr_userinfo[5]  = "<c:out value = '${userInfo.deptName1}'/>";            // 사용자 부서 이름
arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";            // 사용자 직책            
arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";             // E-Mail Address 
arr_userinfo[9]  = " ";
arr_userinfo[10] = "${susinAdmin}";                  // 수신 접수담당자
// 2010.08.11 다국어
arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1} '/>";		// 사용자명(P)
arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2} '/>";		// 사용자명(S)
arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";				// 사용자 직위(P)
arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";				// 사용자 직위(S)
arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";			// 사용자 부서 이름(P)
arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2} '/>";			// 사용자 부서 이름(S)
var p_CompanyID = "${userInfo.companyID}";
// pUserID = arr_userinfo[1];
var RetValue;
var ReturnFunction;
var NonActiveX = "YES";
window.onload = function()
{
    try {
        RetValue = parent.ezSelectSusin_Cross_dialogArguments[0];
        ReturnFunction = parent.ezSelectSusin_Cross_dialogArguments[1];
    } catch (e) {
        try {
            RetValue = opener.ezSelectSusin_Cross_dialogArguments[0];
            ReturnFunction = opener.ezSelectSusin_Cross_dialogArguments[1];
        } catch (e) {
            RetValue = window.dialogArguments;
        }
    }

    pDocID = RetValue[0];
    SusinXML = RetValue[1];
	Tree_setconfig()
	initTreeInfo();
	var listview = new ListView();
	listview.SetID("pUserList");
	listview.SetMulSelectable(false);
	listview.SetRowOnDblClick("list2_onSel_DBclick");

	if (CrossYN())
	    listview.DataSource(userlist_h);
	else {
	    var objXML = createXmlDom();
	    objXML = loadXMLString(userlist_h.xml);
	    listview.DataSource(objXML);
	}

	listview.DataBind("UserList");
	var returnValue = new Array();
	initListView();
    returnValue[0] = "CANCEL";
	window.returnValue = returnValue;
}

function Tree_setconfig() {
    var xmlHTTP = createXMLHttpRequest();    
    xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
    xmlHTTP.send();

    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
        var treeView = new TreeView();
        //Config 설정
        treeView.SetConfig(xmlHTTP.responseXML);
    }
}

// 수신처 지정을 취소하는 작동 function
function AprDeptCancel_onclick()
{
    var returnValue = new Array();
    returnValue[0] = "CANCEL";
	window.returnValue = returnValue;
	window.close();
}
function GetEntryInfo(_DEPTID) {
    
    var result = "";
    var ReceiveDocument = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/admin/ezOrgan/getEntryInfo.do",
		data : {
			cn 	  : _DEPTID,
			prop  : "extensionAttribute11",
			mode  : "dept"
		},
		success: function(xml){
			result = xml;
		}        			
	});
    	

    XmlDom = result;
    ReceiveDocument = SelectSingleNodeValueNew(XmlDom, "DATA/EXTENSIONATTRIBUTE11").trim();
    return ReceiveDocument;
}
// 수신처 List에 추가 하는 함수
function AprDeptAdd_onclick()
{
    var listview = new ListView();
    listview.LoadFromID("divAPRDEPT");
    
	var CurSelRow = listview.GetSelectedRows();
	if(nodeIdx !="")
	{
		//수신처 중복체크 함수 호출
	    var DuplicateFlag = DuplicateAprDeptCheck(APRDEPT, nodeIdx.GetNodeData("CN"));

	    if (GetEntryInfo(nodeIdx.GetNodeData("CN")) == "N") {
	        var pAlertContent = strLang1105;
	        OpenAlertUI(pAlertContent);
	        return;
	    }


		if(DuplicateFlag)
		{
			AprLineAddDept(nodeIdx, CurSelRow);  
		}
		else
		{
			var pAlertContent = "<spring:message code='ezApprovalG.t236'/><br>  <spring:message code='ezApprovalG.t237'/>";
			OpenAlertUI(pAlertContent);
		}
	}
}

// 수신처 List를 삭제 하는 함수
function AprDeptDel_onclick()
{
    var listview = new ListView();
    listview.LoadFromID("divAPRDEPT");
    
	var CurSelRow     = listview.GetSelectedRows();
	var ColRow        = listview.GetDataRows();
	var DeleteState;
	
	if( CurSelRow.length != 0 )
	{
		if( CurSelRow[0].getAttribute("DATA5") == "Y" )
		{
			DeleteState = DeptRowDelelte(Number(listview.GetSelectedIndexes().split(',')[0]),ColRow);
			
			if(DeleteState == "Y")
				listview.DeleteRow(GetAttribute(CurSelRow[0], "id"));			
		}
		else
		{
			OpenAlertUI("<spring:message code='ezApprovalG.t238'/>");
		}
	}
}

//  수신처 지정 Row Delete
function DeptRowDelelte(SelectIndex,ColRow)
{
	var RowDelCheck;
	var ReturnVal = "N";
	TIndex = ColRow.length;
	NIndex = SelectIndex;
	for(i = 0 ; i <= NIndex ; i++ )
	{				
		RowDelCheck = ColRow[i].cells[0].innerText;
		if(CrossYN())
		    ColRow[i].childNodes[0].textContent = RowDelCheck - 1; 
		else
		    ColRow[i].cells[0].innerText = RowDelCheck - 1; 
		var ReturnVal = "Y";
	}
	return ReturnVal;
}

//수신처 추가시 중복체크하는 함수
function DuplicateAprDeptCheck(APRDEPT, arrUserInfo)
{
    var listview = new ListView();                          // ListView 선언
    listview.LoadFromID("divAPRDEPT");                              // ID 지정
	var AprDeptList = listview.GetDataRows();
	var AprDeptListLen = AprDeptList.length;
	var i;
  
	for(i = 0 ; i < AprDeptListLen ; i++)
	{
		if(AprDeptList[i].getAttribute("DATA1") == arrUserInfo)
		{
			return false;
			break;
		}
	}
	return true;
}

//  조직도에서 선택한 수신처를 수신처로 지정하는 Function
function AprLineAddDept(nodeIdx, tr)
{
	var isCurretnCompany = "N";
	
	Resultxml.async=false;
	Resultxml = loadXMLFile("${susinXML}");
	
	var listview = new ListView();                          // ListView 선언
    listview.LoadFromID("divAPRDEPT");                              // ID 지정
    
    DeptAddIndex = listview.GetDataRows().length;
    
    if (DeptAddIndex > 0 && listview.GetDataRows()[0].id.indexOf("noItems") == -1 || DeptAddIndex == 0)
        DeptAddIndex = DeptAddIndex + 1;
	
	var treeView = new TreeView();      //미리 생성된 TreeView의 ID로 TreeView 개체 생성
    treeView.LoadFromID("FromTreeView");
        
    var treeNode = new TreeNode();
    treeNode.LoadFromID(nodeIdx.NodeID);
    
	var strCmpID = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
	var pDeptNm = treeNode.GetNodeData("VALUE");
	      
	var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
	setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);		
	setNodeText(GetChildNodes(objNodes[0])[1], treeNode.GetNodeData("CN"));		
	setNodeText(GetChildNodes(objNodes[0])[2], pDocID);		
	setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);		
	setNodeText(GetChildNodes(objNodes[0])[4], "W");		
	setNodeText(GetChildNodes(objNodes[0])[5], "Y");		
	setNodeText(GetChildNodes(objNodes[0])[6], strCmpID);		
	setNodeText(GetChildNodes(objNodes[0])[7], "");		
	setNodeText(GetChildNodes(objNodes[0])[8], "");		
	setNodeText(GetChildNodes(objNodes[0])[9], "");		
	setNodeText(GetChildNodes(objNodes[0])[10], "");		
	setNodeText(GetChildNodes(objNodes[0])[11], "");		
	setNodeText(GetChildNodes(objNodes[0])[12], treeNode.GetNodeData("DISPLAYNAME"));		
	setNodeText(GetChildNodes(objNodes[0])[13], treeNode.GetNodeData("DISPLAYNAME2"));		
    //setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm + "<spring:message code='ezApprovalG.t177'/>");
    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
	setNodeText(GetChildNodes(objNodes[2])[0], "<spring:message code='ezApprovalG.t239'/>");		
	
	var InitTr = listview.GetDataRows();
	
	var MaxID = 0;
	if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	    for (var j = 0  ; j < InitTr.length  ; j++) {
	        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	        if (MaxID < curnum)
	            MaxID = curnum;
	    }
	}
    
	if(InitTr.length == 0)
	{		
		document.getElementById('APRDEPT').innerHTML = ""; 
	    var listview = new ListView();                          // ListView 선언
        listview.SetID("divAPRDEPT");                              // ID 지정
        listview.SetMulSelectable(true);                       // MultiSelect 여부
        listview.SetRowOnDblClick("AprDept_onDblclick");        
        listview.DataSource(Resultxml);             // DataSource 지정
        listview.DataBind("APRDEPT");                        // ListView DataBind      
	}
	else
	{
		var objTr = listview.AddRow(0);
		SetAttribute(objTr,"id","divAPRDEPT" + "_TR_" + eval(MaxID+1));
		listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);  	
	}
}

function AprLineAddDept2(tr)
{
	var isCurretnCompany = "N";
	
	Resultxml.async=false;
	Resultxml = loadXMLFile("/xml/ezApprovalG/TreeViewEndAddDept.xml");
	
	var listview = new ListView();                          // ListView 선언
    listview.LoadFromID("divAPRDEPT");                              // ID 지정
    
    DeptAddIndex = listview.GetDataRows().length;

    if (DeptAddIndex > 0 && listview.GetDataRows()[0].id.indexOf("noItems") == -1 || DeptAddIndex == 0)
	    DeptAddIndex = DeptAddIndex + 1;

	var strCmpID = tr[0].getAttribute("DATA3");
	var pDeptNm = tr[0].cells[0].innerText;
	
	var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
	setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);		
	setNodeText(GetChildNodes(objNodes[0])[1], tr[0].getAttribute("DATA2"));		
	setNodeText(GetChildNodes(objNodes[0])[2], pDocID);		
	setNodeText(GetChildNodes(objNodes[0])[3], isCurretnCompany);		
	setNodeText(GetChildNodes(objNodes[0])[4], "W");		
	setNodeText(GetChildNodes(objNodes[0])[5], "Y");		
	setNodeText(GetChildNodes(objNodes[0])[6], strCmpID);		
	setNodeText(GetChildNodes(objNodes[0])[7], "");		
	setNodeText(GetChildNodes(objNodes[0])[8], "");		
	setNodeText(GetChildNodes(objNodes[0])[9], "");		
	setNodeText(GetChildNodes(objNodes[0])[10], "");		
	setNodeText(GetChildNodes(objNodes[0])[11], "");		
	setNodeText(GetChildNodes(objNodes[0])[12], tr[0].getAttribute("DATA5"));		
	setNodeText(GetChildNodes(objNodes[0])[13], tr[0].getAttribute("DATA6"));		
    //setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm + "<spring:message code='ezApprovalG.t177'/>");		
    setNodeText(GetChildNodes(objNodes[1])[0], pDeptNm);
	setNodeText(GetChildNodes(objNodes[2])[0], "<spring:message code='ezApprovalG.t239'/>");		
	
	var InitTr = listview.GetDataRows();
	
	var MaxID = 0;
	if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	    for (var j = 0  ; j < InitTr.length  ; j++) {
	        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	        if (MaxID < curnum)
	            MaxID = curnum;
	    }
	}
	
	if(InitTr.length == 0)
	{
	  	document.getElementById('APRDEPT').innerHTML = ""; 
	    var listview = new ListView();                          // ListView 선언
        listview.SetID("divAPRDEPT");                              // ID 지정        
        listview.SetMulSelectable(true);                       // MultiSelect 여부
        listview.SetRowOnDblClick("AprDept_onDblclick");  
        listview.DataSource(Resultxml);             // DataSource 지정
        listview.DataBind("APRDEPT");                        // ListView DataBind      
	}
	else
	{
        var objTr = listview.AddRow(0);
		SetAttribute(objTr,"id","divAPRDEPT" + "_TR_" + eval(MaxID+1));
		listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
	}
	
	DeptAddIndex = DeptAddIndex + 1;
}

// 수신처의 발송상태를 토글하는 함수.
var send_Code = new Array();
var send_Name = new Array();
function ChangeSendStatus()
{
    var listview = new ListView();                          // ListView 선언
    listview.LoadFromID("divAPRDEPT");                              // ID 지정
    
	var CurSelRow     = listview.GetSelectedRows();
	var ColRow        = listview.GetDataRows();
	
	if( CurSelRow.length > 0 )
	{
		if( CurSelRow[0].getAttribute("DATA5") == "N" )
		{
			if( CurSelRow[0].getAttribute("DATA4") == "W" )
			{
				SetAttribute(CurSelRow[0], "DATA4", send_Code[CurSelRow[0].cells[0].innerText]);
				setNodeText(CurSelRow[0], send_Name[CurSelRow.item[0].cells[0].innerText]);
			}
			else
			{
				send_Code[CurSelRow[0].cells[0].innerText] = CurSelRow[0].getAttribute("DATA4");
				send_Name[CurSelRow[0].cells[0].innerText] = CurSelRow[0].cells[2].innerText;
				
				CurSelRow[0].setAttribute("DATA4","W");
				CurSelRow[0].cells[2].innerText = "<spring:message code='ezApprovalG.t239'/>";
			}
		}
		else
		{
			OpenAlertUI("<spring:message code='ezApprovalG.t240'/><br>  <spring:message code='ezApprovalG.t241'/>'<spring:message code='ezApprovalG.t239'/>'<spring:message code='ezApprovalG.t242'/>");
		}
	}
	else
	{
		OpenAlertUI("<spring:message code='ezApprovalG.t243'/>");
	}
}
    // START
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
    }
    function OpenAlertUI_Complete() {
        DivPopUpHidden();
    }
    // END

// 수신처 지정 ListView 초기화 함수
function initListView(){

	if (SusinXML == "")
	{
		$.ajax({
			type : "POST",
			dataType : "xml",
			async : false,
			url : "/ezApprovalG/aprDeptRequest.do",
			data : {
				docID : pDocID,
				mode  : "RES"
			},
			success: function(xml){
				result = xml;
			}        			
		});
		
		var listview = new ListView();                          // ListView 선언
        listview.SetID("divAPRDEPT");                              // ID 지정
        listview.SetMulSelectable(true);                       // MultiSelect 여부
        listview.SetSelectFlag(false);	
        listview.SetRowOnDblClick("AprDept_onDblclick");        
        listview.DataSource(result);             // DataSource 지정
        listview.DataBind("APRDEPT");                        // ListView DataBind      
	}
	else{
		var xmlSusin = createXmlDom();
		xmlSusin = loadXMLString(SusinXML);
		
		Resultxml.async=false;
		Resultxml = loadXMLFile("TreeViewEndAddDept.xml");
		
		var rows = xmlSusin.getElementsByTagName("RECEIPTPOINTNAME")
		for(i=rows.length - 1; i>=0; i--)
		{
			var objNodes = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL");
			objNodes.item(0).childNodes(0).text = xmlSusin.getElementsByTagName("DEPTMEMBERSN").item(i).text;
			objNodes.item(0).childNodes(1).text = xmlSusin.getElementsByTagName("RECEIPTPOINTID").item(i).text;		// DEPTID
			objNodes.item(0).childNodes(2).text = pDocID;															// DocID
			objNodes.item(0).childNodes(3).text = xmlSusin.getElementsByTagName("EXTRECEPTYN").item(i).text;		// EXTRECEIPTYN
			objNodes.item(0).childNodes(4).text = xmlSusin.getElementsByTagName("PROCESSYN").item(i).text;			// PROCESSYN
			objNodes.item(0).childNodes(5).text = xmlSusin.getElementsByTagName("CANEDITYN").item(i).text;			// CANEDITYN
			objNodes.item(0).childNodes(6).text = xmlSusin.getElementsByTagName("EXTRECEPTEMAIL").item(i).text;		// EXTRECEPTEMAIL
			objNodes.item(0).childNodes(7).text = xmlSusin.getElementsByTagName("RECEIPTMEMBERID").item(i).text;	// ID
			objNodes.item(0).childNodes(8).text = xmlSusin.getElementsByTagName("DATA8").item(i).text;	// RECEIPTMEMBERNAME
			objNodes.item(0).childNodes(9).text = xmlSusin.getElementsByTagName("DATA13").item(i).text;		// RECEIPTMEMBERNAME2
			objNodes.item(0).childNodes(10).text = xmlSusin.getElementsByTagName("DATA9").item(i).text;		//RECEIPTMEMBERJOBTITLE1 
			objNodes.item(0).childNodes(11).text = xmlSusin.getElementsByTagName("DATA12").item(i).text;		// RECEIPTMEMBERJOBTITLE2
			objNodes.item(0).childNodes(12).text = xmlSusin.getElementsByTagName("DATA10").item(i).text;		// RECEIPTPOINTNAME
			objNodes.item(0).childNodes(13).text = xmlSusin.getElementsByTagName("DATA11").item(i).text;		// RECEIPTPOINTNAME2
			
			objNodes.item(1).childNodes(0).text = xmlSusin.getElementsByTagName("RECEIPTPOINTNAME").item(i).text; //RECEIPTPOINTNAME
			objNodes.item(2).childNodes(0).text = xmlSusin.getElementsByTagName("PROCESS").item(i).text;
			
			var listview = new ListView();
			listview.LoadFromID(divAPRDEPT);
			
			var InitTr = listview.GetDataRows();
			if(InitTr.length == 0)
			{
	  			var listview = new ListView();                          // ListView 선언
                listview.SetID("divAPRDEPT");                              // ID 지정
                listview.SetMulSelectable(true);                       // MultiSelect 여부
                listview.SetSelectFlag(false);	
                listview.SetRowOnDblClick("AprDept_onDblclick");        
                listview.DataSource(Resultxml);             // DataSource 지정
                listview.DataBind("APRDEPT");                        // ListView DataBind      
			}
			else
			{
				var objTr = listview.AddRow(0);
		        SetAttribute(objTr,"id","divAPRDEPT" + "_TR_" + eval(MaxID+1));
		        listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
			}
		}
	}
}

// 수신처 지정를 DB에 저장 작동하는function
function AprDeptSave_onclick()
{
    var returnValue = new Array();
	var rtnVal = makertnVal();
    returnValue[0] = "OK";
    returnValue[1] = rtnVal;
	//window.returnValue = returnValue;
	//window.close();

	if (ReturnFunction != null) {
	    ReturnFunction(returnValue);
	    window.close();
	}
	else {
	    window.returnValue = "cancel";
	    window.close();
	}
}

// return Value 를 만든다.
function makertnVal()
{
	var xmlpara = createXmlDom();
	
	var objRoot, objNode, subNode, subNode2;
	
	objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
	createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
	createNodeAndInsertText(xmlpara, objNode, "COMPANYID", p_CompanyID);	
	objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "RECEIPTS");
			
	var listview = new ListView();
	listview.LoadFromID("divAPRDEPT");
	
	var i;
	var rows = listview.GetDataRows();
	
	for(i=0; i<rows.length; i++)
	{
	    subNode = createNodeAndAppandNode(xmlpara, objNode, subNode, "RECEIPT");
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTPOINTID", rows[i].getAttribute("DATA1"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTPOINTNAME", rows[i].getAttribute("DATA12"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "EXTRECEPTYN", rows[i].getAttribute("DATA3"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "PROCESSYN", rows[i].getAttribute("DATA4"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "PROCESSSN", "1");
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "CANEDITYN", "N");
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "EXTRECEPTEMAIL", rows[i].getAttribute("DATA6"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTMEMBERID", rows[i].getAttribute("DATA7"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTMEMBERNAME", rows[i].getAttribute("DATA8"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "PROCESSDATE", "");
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTMEMBERJOBTITLE", rows[i].getAttribute("DATA10"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "DEPTMEMBERSN", rows[i].childNodes[0].innerText);
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "PROCESS", rows[i].childNodes[2].innerText);
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTPOINTNAME2", rows[i].getAttribute("DATA13"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTMEMBERNAME2", rows[i].getAttribute("DATA9"));
	    createNodeAndAppandNodeText(xmlpara, subNode, subNode2, "RECEIPTMEMBERJOBTITLE2", rows[i].getAttribute("DATA11"));
	}
	return xmlpara;
}

var g_progresswin = null;	// 조직도정보 처리중 표시
function showProgress()
{
	g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape("<spring:message code='ezApprovalG.t244'/>") , "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
}

function hideProgress()
{
	try
	{
		if (g_progresswin)
			g_progresswin.close();
	}
	catch(e) {}
}

// 조직도 트리뷰 Initial Display
function initTreeInfo()
{	
	//showProgress();
	
	try
	{
		TreeViewinitialize(arr_userinfo[4], p_CompanyID , "extensionAttribute2;extensionAttribute3;displayName;displayName2", "${serverName}");
	}
	catch(ErrMsg)
	{
		alert(ErrMsg.description);  
	}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

var nodeIdx;
function TreeViewNodeClick()
{
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");

	nodeIdx = treeView.GetSelectNode();	
}

function TreeViewNodeDbClick()
{
    AprDeptAdd_onclick();
}

// 이름찾기버튼
function btn_searchUser_onclick()
{
	searchUserList();
}

function searchUserList()
{
	try
	{
		var strSearch = textUser.value + "";
		if (textUser.value =="")
		{
	  		var pAlertContent = "<spring:message code='ezApprovalG.t245'/>";
			OpenAlertUI(pAlertContent);
			textUser.focus();
		}
		else if (strSearch.length < 2 )
		{
			var pAlertContent = "<spring:message code='ezApprovalG.t246'/>";
			OpenAlertUI(pAlertContent);
			textUser.focus();
		}
		else
		{
		    $.ajax({
		    	type : "POST",
		    	dataType : "xml",
		    	url : "/ezOrgan/getSearchList.do",
		    	async : false,
		    	data : {search : "displayname::" + strSearch + ";;extensionAttribute2::"+p_CompanyID , cell : "displayname", prop : "extensionAttribute2;extensionAttribute3;displayname;displayname2", type : "group"},
		    	success : function(result){	
		    		event_displayUserList(result);
		    	},
		    	error : function(error){
		    		alert("<spring:message code='ezOrgan.t60' />" + xmlHTTP.statusText);
		    	}
		    });	
		}
	}
	catch(ErrMsg)
	{
		alert(ErrMsg.description);
	}
}

function event_displayUserList(result)
{    
		if (result.getElementsByTagName("ROW").length > 0)
		{
		    var pUserList = new ListView();      //// ListView 선언
            pUserList.LoadFromID("pUserList");            
			pUserList.SetSelectFlag(false);			
            pUserList.DataSource(result);                             // DataSource 지정
            pUserList.RowDataBind("UserList");                          // ListView DataBind
        }			
		else
			alert("<spring:message code='ezApprovalG.t247'/>")

		result = null;
}

function list2_onSel_DBclick()
{
	AprDeptAdd2_onclick()
}

//리스트뷰에서 가져오는 것.
function AprDeptAdd2_onclick()
{
    var listview = new ListView();
    listview.LoadFromID("pUserList");
    
	var CurSelRow = listview.GetSelectedRows();
	if (CurSelRow.length > 0)
	{
		var DuplicateFlag = DuplicateAprDeptCheck(APRDEPT, CurSelRow[0].getAttribute("DATA2"));
		if(DuplicateFlag)
		{
			AprLineAddDept2(CurSelRow);  
		}
		else
		{
			var pAlertContent = "<spring:message code='ezApprovalG.t236'/><br>  <spring:message code='ezApprovalG.t237'/>";
			OpenAlertUI(pAlertContent);
		}		
	}
	else
	{
		var pAlertContent = "<spring:message code='ezApprovalG.t248'/>";
		OpenAlertUI(pAlertContent);
	}
}

function textUser_onkeypress()
{
	if (window.event.keyCode == "13")
	{
		btn_searchUser.focus();
	}
}

function AprDept_onDblclick()
{
	AprDeptDel_onclick();
	return;
}
</script>
</head>
<body class="popup">
<xml id="userlist_h" style="display:none">
	<LISTVIEWDATA>
		<HEADERS>
			<HEADER>
				<NAME><spring:message code='ezApprovalG.t249'/></NAME>
				<WIDTH>80</WIDTH>
			</HEADER>
		</HEADERS>
		<ROWS></ROWS>
	</LISTVIEWDATA>
</xml>
<h1><spring:message code='ezApprovalG.t235'/></h1>

			<table style="width:730px">
				<tr>
					<td style="vertical-align:top; width:300px">
						<table>
							<tr>
                                <td style="vertical-align:top" colspan="2" ><h2><spring:message code='ezApprovalG.t232'/></h2>									
                                    <div class="box" style="overflow:auto;height:305px;width:300px;" id="TreeView"></div>
                                </td>
							</tr>
							<tr>
								<td style="padding-top:5px" ><div class="listview">	
								<div id="UserList" style="overflow:auto;Border:0;Width:100%; Height:160px;"></div>
								</div></td>
							</tr>
							<tr>
								<td style="height:30px; text-align:right">
									<input id="textUser" style="width:100px" name="textUser" onKeyPress="return textUser_onkeypress()" tabindex="1">
                                    <a class="imgbtn" style="vertical-align:middle">
                                        <span id="btn_searchUser" onKeyPress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()" ><spring:message code='ezApprovalG.t250'/></span>
                                    </a>
								</td>
							</tr>
						</table>
					</td>
                    <td style="width:50px;text-align:center">
                        <img id="AprDeptAdd"  alt="<spring:message code='ezApprovalG.t251'/>" src="/images/arr_right.gif" width="16"
				            height="16" onClick="return AprDeptAdd_onclick()"
				            onmouseover="MM_swapImage('Image10','','/images/arrow_next.gif',1)" onMouseOut="MM_swapImgRestore()" style="CURSOR:pointer"><br>
		                <img id="AprDeptDel" alt="<spring:message code='ezApprovalG.t252'/>"  src="/images/arr_left.gif"  width="16"
				            height="16" onClick="return AprDeptDel_onclick()" onMouseOut="MM_swapImgRestore()"
				            onMouseOver="MM_swapImage('Image11','','/images/arrow_delete1.gif',1)" style="CURSOR:pointer"><br><br><br>
		                <img id="AprDeptAdd2" alt="<spring:message code='ezApprovalG.t251'/>"  src="/images/arr_right.gif" style="CURSOR:pointer" width="16" height="16" onClick="return AprDeptAdd2_onclick()" onMouseOut="MM_swapImgRestore()"
				            onmouseover="MM_swapImage('Image10','','/images/arrow_next.gif',1)">
                    </td>
					<td style="vertical-align:top">
						<table>
							<tr>
							  <td style="white-space:nowrap" ><h2><spring:message code='ezApprovalG.t253'/></h2></td>
											<td style="display:none"><a class="imgbtn"><span onClick="return btn_DeptGroupAdd()" ><spring:message code='ezApprovalG.t254'/></span></a></td>
						  </tr>
							<tr>
								<td colspan="2" style="vertical-align:top">
                                    <div class="listview">									
									    <div id="APRDEPT" style="overflow:auto;border:0;HEIGHT: 500px; WIDTH: 400px;margin:1px 1px 1px 1px;">
									</div></div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

<div class="btnposition">
<a class="imgbtn"><span id="AprDeptSave" onclick="return AprDeptSave_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
<a class="imgbtn"><span id="AprDeptCancel" onclick="return AprDeptCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>  
</div>
<%--START--%>
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
</div>
<%--END--%>
</body>
</html>
