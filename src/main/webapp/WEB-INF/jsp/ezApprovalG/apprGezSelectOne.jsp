<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code='ezApprovalG.t223'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<link rel="stylesheet" href="/css/organ_tree.css"   type="text/css">
<script type="text/javascript"  src="/js/ezApprovalG/TreeView.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
var labelcolor = "c6c6c6"
var InitTreeVal = "";	
var pDocID;
var pReceiveSN;
var CurSelNode; //현재선택된 노드
var pAprSate;
var arr_userinfo = new Array();
arr_userinfo[0]  = "user";								// 사용자-부서구분
arr_userinfo[1]  = "${userInfo.id}";              // 사용자ID
arr_userinfo[2]  = "${userInfo.displayName1}";         // 사용자명
arr_userinfo[3]  = "${userInfo.title1}";               // 사용자 직위
arr_userinfo[4]  = "${userInfo.deptID}";              // 사용자 부서 ID    
arr_userinfo[5]  = "${userInfo.deptName1}";            // 사용자 부서 이름
arr_userinfo[6]  = "${userInfo.jikChek}";             // 사용자 직책            
arr_userinfo[8]  = "${userInfo.email}";               // E-Mail Address 
arr_userinfo[9]  = "";
arr_userinfo[10] = "${susinAdmin}";                  // 수신 접수담당자
// 2010.08.11 다국어
arr_userinfo[11]  = "${userInfo.displayName1}";		// 사용자명(P)
arr_userinfo[12]  = "${userInfo.displayName2}";		// 사용자명(S)
arr_userinfo[13]  = "${userInfo.title1}";				// 사용자 직위(P)
arr_userinfo[14]  = "${userInfo.title2}";				// 사용자 직위(S)
arr_userinfo[15]  = "${userInfo.deptName1}";			// 사용자 부서 이름(P)
arr_userinfo[16]  = "${userInfo.deptName2}";			// 사용자 부서 이름(S)
var companyID = "${userInfo.companyID}";// 수신 접수담당자
    var OrderCell = "";
var pUserID = arr_userinfo[1];
// 수정(2006.01.12) : 발송의뢰 선택 시 회사의 문서과를 디폴트로 보여주도록 수정
var pMDeptInfo = "${mDeptInfo}";
var rtnVal = new Array("");
var ReturnFunction;
var g_xmlHTTP = null;
window.onload = function()
{
	try
	{
	    try {
	        ReturnFunction = parent.ezselectone_cross_dialogArguments[1]
	    } catch (e) {
	        try {
	            ReturnFunction = opener.ezselectone_cross_dialogArguments[1]
	        } catch (e) {
	        }
	    }

		var listview = new ListView();                          // ListView 선언
        listview.SetID("OrganList");                              // ID 지정
        listview.SetMulSelectable(false);                       // MultiSelect 여부
        listview.SetHeightFree(false);     
        listview.SetRowOnDblClick("btnAssign_onclick");

        if (CrossYN())
            listview.DataSource(listviewheader);
        else {
            var objXML = createXmlDom();
            objXML = loadXMLString(listviewheader.xml);
            listview.DataSource(objXML);
        }

        listview.DataBind("OrganListView");                        // ListView DataBind
        if (pMDeptInfo == "") {
            InitTreeVal = arr_userinfo[4];
        }
        else {
            InitTreeVal = pMDeptInfo;
        }
		
		Tree_setconfig();
		TreeViewinitialize(InitTreeVal, companyID, "", "${serverName}");	
			  
		rtnVal[0] = "cancel";
		rtnVal[1] = "";
		rtnVal[2] = "";
		rtnVal[3] = "";
		rtnVal[4] = "";
		rtnVal[5] = "";
		//2010.08.14 다국어 추가
		rtnVal[6] = ""; //username2
		rtnVal[7] = ""; //deptname2
		rtnVal[8] = ""; //jobtitle2	
	}
	catch(ErrMsg)
	{
		alert("window_onload : " + ErrMsg.description);
	}
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

function btnAssign_onclick()
{
	try
	{
		var listview = new ListView(); 
        listview.LoadFromID("OrganList");
        var pCurSelRow = listview.GetSelectedRows();
    		
        if (pCurSelRow.length == 0) {
            var pAlertContent = "<spring:message code='ezApprovalG.t224'/>";
            OpenAlertUI(pAlertContent);
        }
        else {
            rtnVal[0] = "OK";
            rtnVal[1] = pCurSelRow[0].getAttribute("DATA2");	// ID
            rtnVal[2] = pCurSelRow[0].getAttribute("DATA8");  // NAME
            rtnVal[3] = pCurSelRow[0].getAttribute("DATA10");  // JobTitle
            rtnVal[4] = pCurSelRow[0].getAttribute("DATA3");		// DeptID
            rtnVal[5] = pCurSelRow[0].getAttribute("DATA12");	// DeptName
            //2010.08.16 다국어 추가
            rtnVal[6] = pCurSelRow[0].getAttribute("DATA9"); //username2
            rtnVal[7] = pCurSelRow[0].getAttribute("DATA13"); //deptname2
            rtnVal[8] = pCurSelRow[0].getAttribute("DATA11"); //jobtitle2

            if (ReturnFunction != null)
                ReturnFunction(rtnVal);
            window.close();
        }
	}
	catch(ErrMsg)
	{
		alert(ErrMsg.description);
	}
}

function btnCancel_onclick()
{
	rtnVal[0] = "cancel";
	rtnVal[1] = "";
	rtnVal[2] = "";
	rtnVal[3] = "";
	rtnVal[4] = "";
	rtnVal[5] = "";
	rtnVal[6] = "";
	rtnVal[7] = "";
	rtnVal[8] = "";
	if (ReturnFunction != null)
	    ReturnFunction("cancel");
	window.close();
}

function btn_searchUser_onclick()
{
  try{
	var strSearch = document.getElementById("textUser").value + "";
	if (textUser.value =="")
	{
	  	var pAlertContent = "<spring:message code='ezApprovalG.t226'/>";
		OpenAlertUI(pAlertContent);
	  	TreeViewNodeClick()
	}
	else if (strSearch.length < 2 )
	{
		var pAlertContent = "<spring:message code='ezApprovalG.t227'/>";
        OpenAlertUI(pAlertContent);
	}
	else
	{
		  $.ajax({
		    	type : "POST",
		    	dataType : "xml",
		    	url : "/ezOrgan/getSearchList.do",
		    	async : false,
		    	data : {search : "displayname::"+ strSearch + ";;extensionAttribute1::i=1" + ";;extensionAttribute1::i=1" , cell : "displayname;title;description;telephonenumber", prop : "Department;extensionAttribute4", type : "user"},
		    	success : function(result){	
		    		event_displayUserList(result);
		    	},
		    	error : function(error){
		    		alert("<spring:message code='ezOrgan.t60' />" + xmlHTTP.statusText);
		    	}
		    });	
	}
  }catch(ErrMsg){
    alert(ErrMsg.description);
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

    function OpenAlertUI_Complete() {
        DivPopUpHidden();
    }

function TreeViewNodeClick()
{
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");

	var nodeIdx = treeView.GetSelectNode();
	displayUserList(nodeIdx.GetNodeData("CN"));
}

function displayUserList(DeptID)
{
    $.ajax({
    	type : "POST",
    	dataType : "xml",
    	url : "/ezOrgan/getSearchList.do",
    	async : false,
    	data : {search : "EXACT_Department::" + DeptID + ";;extensionAttribute1::i=1" , cell : "displayname;title;description;telephonenumber", prop : "Department;extensionAttribute4;displayname;title;description", type : "user"},
    	success : function(result){	
    		event_displayUserList(result);

    	},
    	error : function(error){
    		alert("<spring:message code='ezOrgan.t60' />" + xmlHTTP.statusText);
    	}
    });	
   
}

function event_displayUserList(result)
{
    if (SelectNodes(result, "LISTVIEWDATA/ROWS/ROW").length > 0) {
        var listview = new ListView();
        listview.LoadFromID("OrganList");
        listview.DataSource(result);
        listview.RowDataBind();
    }
    else {
        document.getElementById("OrganListView").innerHTML = "";
        var listview = new ListView();
        listview.SetID("OrganList");
        listview.SetMulSelectable(false);
        listview.SetRowOnDblClick("btnAssign_onclick");
        listview.DataSource(listviewheader);
        listview.DataBind("OrganListView");
    }
}

function textUser_onkeypress()
{
	if (window.event.keyCode == "13")
	{
		btn_searchUser_onclick();
	}
}
</script>
</head>
<body class="popup">
<xml id="listviewheader" style="display:none">
  <LISTVIEWDATA>
    <HEADERS>
      <HEADER>
        <NAME><spring:message code='ezApprovalG.t229'/></NAME>
        <WIDTH>50</WIDTH>
      </HEADER>
      <HEADER>
        <NAME><spring:message code='ezApprovalG.t230'/></NAME>
        <WIDTH>50</WIDTH>
      </HEADER>
      <HEADER>
        <NAME><spring:message code='ezApprovalG.t108'/></NAME>
        <WIDTH>70</WIDTH>
      </HEADER>
      <HEADER>
        <NAME><spring:message code='ezApprovalG.t231'/></NAME>
        <WIDTH>70</WIDTH>
      </HEADER>
    </HEADERS>
  </LISTVIEWDATA>
</xml>
<h1><spring:message code='ezApprovalG.t223'/></h1>
    <table style="margin-top:-15px;" >
        <tr>
        <td style="vertical-align:top"><h2><spring:message code='ezApprovalG.t232'/></h2>
        <div class="box" style="overflow:auto;height:380px; width:250px" id="TreeView"></div></td>
        <td style="vertical-align:top;padding-left:5px" ><h2><spring:message code='ezApprovalG.t233'/></h2>
        <div class="listview">
        <DIV id="OrganListView" class="text" style="overflow:auto; border:0;Width:320px; Height:358px;margin:1px 1px 1px 1px;"></DIV>
        </div>
        <table style="width:100%">
        <tr>
        <td style="width:25px"><input type="text" id="textUser" name="textUser" style="width:130px;" value="" onKeyPress="return textUser_onkeypress()">
        <a class="imgbtn" style="vertical-align:middle"><span onClick="return btn_searchUser_onclick()"><spring:message code='ezApprovalG.t234'/></span></a></td>
        </tr>
        </table></td>
        </tr>
    </table>
<div class="btnposition">
   <a class="imgbtn"><span onClick="return btnAssign_onclick()" ><spring:message code='ezApprovalG.t20'/></span></a>
   <a class="imgbtn"><span onClick="return btnCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
</div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
