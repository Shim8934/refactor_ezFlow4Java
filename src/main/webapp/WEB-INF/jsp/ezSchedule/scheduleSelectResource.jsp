<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t1101' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/style.css')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <%-- <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" /> --%>
	    <style>
	    	.mainlist tr th {
	    	
	    		border-top:0px;
	    	}
	    </style>
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezResource/organtreeview.htc.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezResource/ResTreeInfo_cross.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezSchedule/ListView_list.js')}"></script>        
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script>			
		    var brdGubun = "<c:out value='${brd_Gubun}'/>";					// Board 구분 == Brd_GB (1:일반, 2:하위자원)
		    var g_UserID = "<c:out value='${userInfo.id}'/>";
		    var g_DeptID = "<c:out value='${userInfo.deptID}'/>";
		    var g_DeptPath = "${userInfo.deptPathCode}";
		    var pCompanyID = "<c:out value='${userInfo.companyID}'/>";
		    var g_AccessCode = "0";
		    var selectNo = "<c:out value='${selectNo}'/>";
		    var ReturnValue_CN = new Array();
		    var ReturnValue_Name = new Array();
		    var ReturnValue_NameEng = new Array();
		    var pStartTime = "<c:out value='${startTime}'/>";
		    var pEndTime = "<c:out value='${endTime}'/>";
		    var m_strColorSelect = "#f1f8ff";
		    var m_strColorOver = "#f4f5f5";
		    var m_strColorDefault = "#ffffff";
		    var RetValue;
		    var ReturnFunction;
	
		    function TreeView_onNodeDblClick() {
		        TreeView.toggle(TreeView.selectedIndex());
		    }
	
		    window.onload = function () {
	
		        try {            
		            RetValue = parent.schedule_repetition_cross_dialogArguments[0];
		            ReturnFunction = parent.schedule_repetition_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.schedule_repetition_cross_dialogArguments[0];
		                ReturnFunction = opener.schedule_repetition_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
	
		        var TreeView = new organtreeview('TreeView', 'TreeView');
		        TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
		        TreeView.attachEvent('nodeselect', TreeView_onNodeClick);
		        TreeView.attachEvent('nodedblclick', InsertReceiver);
	
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
		        xmlHTTP.send();
	
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            TreeView.server("${serverName}");
		            TreeView.config(xmlHTTP.responseXML);
		            TreeView.update();
		        }
	
		        recevieListview("MsgToList", "ListView");
	
		        argumentEmpty = false;
		        if (RetValue.length == 2) {
		            argumentEmpty = true;
		        }
	
		        if (argumentEmpty) {
		            var listView = new ListView();
		            listView.LoadFromID("MsgToList");
		            var totalRows = listView.GetDataRows();
		            var totalLen = totalRows.length;
		            var dialoglength = 0;
		            dialoglength = RetValue[0].length;
	
		            for (var i = 0; i < dialoglength; i++) {
		                var pparsingXML = "";
		                var pparsingXML2 = "";
		                pparsingXML2 = "<LISTVIEWDATA><ROWS>"
	
		                var strName;
		                var strCN;
		                strName = RetValue[1][i];
		                strCN = RetValue[0][i];
		                pparsingXML = pparsingXML + "<ROW><CELL><CN>" + strCN + "</CN>";
		                pparsingXML = pparsingXML + "<NAME><![CDATA[" + strName + "]]></NAME>";
		                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
		                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
		                var Resultxml = loadXMLString(pparsingXML2);
		                var listview = new ListView();
		                listview.LoadFromID("MsgToList");
	
		                var MaxID = 0;
		                var InitTr = listview.GetDataRows();
		                for (var j = 0  ; j < InitTr.length  ; j++) {
		                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                    if (MaxID < curnum)
		                        MaxID = curnum;
		                }
	
		                var objTr = listview.AddRow(InitTr.length);
		                SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                listview.AddDataRow(objTr, Resultxml);
		            }
		        }       
		        TreeLoad();
		    }
	
		    function recevieListview(pID, pListView) {		        
		        var listview = new ListView();
		        listview.SetID(pID);
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("DeleteReceiver");        
		        listview.DataSource(listviewheader);        
		        listview.DataBind(pListView);
		        listview.RowDataBind();		        
		    }
	
		    function locationInfo(pBrdNm) {
		        var idx = "7";
			        
		        navigation_info = "<a href='/ezResource/resMain.do' target='main' class='n'><spring:message code='ezResource.t334' /></a>"
	
		        if (pBrdNm != "")
		            navigation_info += " > " + pBrdNm + "</a>";
		    }
	
		    function TreeLoad() {
		        //initTreeInfo("", g_UserID, g_DeptID);
		    	g_DeptBoardYN = false;
		       	var xmlhttp = createXMLHttpRequest();
		    	var xmlpara = createXmlDom();
		    	var xmlRtn = createXmlDom(); 
		    	
		    	var objNode;		
		    	createNodeInsert(xmlpara, objNode, "BRDLIST"); 
		    	createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", "1");
		    	createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
		    	createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
		    	createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "Y");
		    	createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
		    	createNodeAndInsertText(xmlpara, objNode, "USER_ID", g_UserID);
		    	createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
		    	createNodeAndInsertText(xmlpara, objNode, "ADMIN_CHECK", "N");
		    	
		    	xmlhttp.open("POST","/ezResource/callNodeTreeData.do?flag=" + encodeURIComponent(selectNo), false);
		    	xmlhttp.send(xmlpara);
		    	
		    	var XMLstring = xmlhttp.responseXML;

		    	// 표준모듈 (2007.05.30) : HTC TreeView로 변경	
		    	//xmlRtn = loadXMLString(XMLstring);	
		    	TreeView.source(XMLstring);
		    	TreeView.update();
		    }
	
		    function TreeView_onNodeExpanded(event) {
		        //displayBrdTree.call(this, g_UserID, g_DeptID, event);
		    	if (!event) event = window.event;
		    	var nodeIdx = event.nodeIdx;
		    	var p_BrdID = TreeView.getvalue(nodeIdx, "DATA1");
		    	
		    	var xmlhttp = createXMLHttpRequest();
				var xmlpara = createXmlDom();
				var xmlRtn = createXmlDom(); 
				
				var objNode;		
			    createNodeInsert(xmlpara, objNode, "BRDLIST"); 
			    createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_BrdID);
			    createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
			    createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
			    createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
			    createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
			    createNodeAndInsertText(xmlpara, objNode, "USER_ID", g_UserID);
			    createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
			    createNodeAndInsertText(xmlpara, objNode, "ADMIN_CHECK", "N");
			    
				xmlhttp.open("POST","/ezResource/callNodeTreeData.do",false);
				xmlhttp.send(xmlpara);
				
				xmlRtn = xmlhttp.responseXML;
			
		        TreeView.putchildxml(nodeIdx, xmlRtn);
		    }
	
		    function TreeView_onNodeClick() {
	
		    }
		    
		    function InsertReceiver() {
		        var listview = new ListView();
		        listview.LoadFromID("MsgToList");
	
		        var nodeIdx = TreeView.selectedIndex();
		        var p_BrdID = TreeView.getvalue(nodeIdx, "DATA1");
	
		        var brdGubun = TreeView.getvalue(nodeIdx, "DATA7");
	
		        var Addflg = true;
		        var getACL = "";
	
		        if (brdGubun == 2) {
		            for (var i = 0; i < listview.GetRowCount() ; i++) {
		                if (listview.GetDataRows()[i].getAttribute("CN") == TreeView.getvalue(nodeIdx, "DATA1")) {
		                    Addflg = false;
		                    break;
		                }
		            }
	
		            if (Addflg == true) {
		                getACL = fun_GetACL(TreeView.getvalue(nodeIdx, "DATA1"));
	
		                if (getACL == "Y" || getACL == "U") {
	
	
	
		                    var pparsingXML = "";
		                    var pparsingXML2 = "";
	
		                    pparsingXML2 = "<LISTVIEWDATA><ROWS>"
	
		                    var strName = TreeView.getvalue(nodeIdx, "VALUE");
		                    var strCN = TreeView.getvalue(nodeIdx, "DATA1");
	
	
		                    pparsingXML = pparsingXML + "<ROW><CELL><CN>" + strCN + "</CN>";
		                    pparsingXML = pparsingXML + "<NAME><![CDATA[" + strName + "]]></NAME>";
		                    pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
	
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
		                    var Resultxml = loadXMLString(pparsingXML2);
	
	
		                    var MaxID = 0;
		                    var InitTr = listview.GetDataRows();
	
		                    for (var j = 0  ; j < InitTr.length  ; j++) {
		                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum)
		                            MaxID = curnum;
		                    }
	
		                    var objTr = listview.AddRow(InitTr.length);
		                    SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
	
		                }
		                else {
		                    alert("<spring:message code='ezSchedule.t1110' />");
		                }
		            }
		            else {
		                alert("<spring:message code='ezSchedule.t1109' />");
		            }
		        }
		        else {
		            alert("<spring:message code='ezSchedule.t1108' />");
		        }
		    }
	
		    function DeleteReceiver(pListView) {
		        var listid = "MsgToList";
		        var selList = new ListView();
		        selList.LoadFromID(listid);
	
		        var arrRows = selList.GetSelectedRows();
		        var strName = "";
	
		        for (var i = 0; i < arrRows.length; i++) {
		            selList.DeleteRow(arrRows[i].id);
		        }
	
		    }
	
		    function btn_OK() {
		        var listview = new ListView();
		        listview.LoadFromID("MsgToList");
	
		        for (var i = 0 ; i < listview.GetRowCount() ; i++) {
		            ReturnValue_CN[i] = listview.GetDataRows()[i].getAttribute("CN");
		            ReturnValue_Name[i] = listview.GetDataRows()[i].getAttribute("NAME");
		        }
	
		        var Para = new Array();
	
		        Para[0] = ReturnValue_CN;
		        Para[1] = ReturnValue_Name;
	
		        if (ReturnFunction != null) {
		            ReturnFunction(Para);
		            parent.DivPopUpHidden();
		        }
		        else {
		            window.returnValue = Para;
		            window.close();
		        }
		    }
	
		    function btn_close() {
		        if (ReturnFunction != undefined)
		            parent.DivPopUpHidden();
		        else
		            window.close();
		    }
	
		    function fun_GetACL(pBordID) {
		        var xmlHttp = createXMLHttpRequest();
		        var Return = "";
		        try {		            
		            xmlHttp.open("POST", "/ezResource/scheduleAddGetACL.do?brdID=" + pBordID, false);
		            xmlHttp.send();
	
		            if (xmlHttp.status == "200") {
		                var dataNodes = GetChildNodes(xmlHttp.responseXML);
		                Return = getNodeText(dataNodes[0]);
		            }
		            else
		                Return = "ERROR"
	
		        }
		        catch (e) {
		            alert(e.description);
		            Return = "ERROR"
		        }
		        xmlHttp = null;
		        return Return;
		    }
		    
		    var schedule_resource_info_cross_dialogArguments = new Array();
		    function Add_ResourceInfo() {
		        var listview = new ListView();
		        listview.LoadFromID("MsgToList");
	
		        if (listview.GetRowCount() == 0) {
		            alert("<spring:message code='ezSchedule.t1107' />");
		            return;
		        }
	
		        var rtn = { "id": new Array(), "name": new Array(), "deptname": new Array() };
	
		        for (var i = 0; i < listview.GetRowCount() ; i++) {
		            rtn["id"][i] = listview.GetDataRows()[i].getAttribute("CN");
		            rtn["name"][i] = listview.GetDataRows()[i].getAttribute("NAME");
		            rtn["deptname"][i] = "";
		        }
	
		        var g_param = new Array();
	
		        g_param["startTime"] = pStartTime;
		        g_param["endTime"] = pEndTime;
		        g_param["entryList"] = rtn;
	
		        var cmd, org_num, org_ownerID;
		        var feature = GetShowModalPosition(695, 430);
		        if (ReturnFunction != undefined) {
		            schedule_resource_info_cross_dialogArguments[0] = g_param;
		            schedule_resource_info_cross_dialogArguments[1] = Add_ResourceInfo_Complete;
		            var OpenWin = window.open("/ezSchedule/scheduleResourceInfo.do", "schedule_resource_info_Cross", GetOpenWindowfeature(695, 430));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var reParam = window.showModalDialog("/ezSchedule/scheduleResourceInfo.do", g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no" + feature);
	
		            if (typeof (reParam) != "undefined" && reParam != null) {
		                idDatepicker.vtLocalDate = reParam["startTime"];
		                idDatepicker.vtLocalEndDate = reParam["endTime"];
	
		                if (reParam["entryList"] != "") {
		                    xmpEntryEmailList.innerText = reParam["entryList"];
	
		                    DisplayEntryList();
		                }
		            }
		        }
		    }
	
		    function Add_ResourceInfo_Complete(reParam) {
		        idDatepicker.vtLocalDate = reParam["startTime"];
		        idDatepicker.vtLocalEndDate = reParam["endTime"];
	
		        if (reParam["entryList"] != "") {
		            xmpEntryEmailList.innerText = reParam["entryList"];
	
		            DisplayEntryList();
		        }
		    }
		</script>
	</head>
	
	<body class="popup">
	    <xml id="listviewheader" style="display:none;">
	    	<LISTVIEWDATA>
	        	<HEADERS>
	          		<HEADER>
	            		<NAME><spring:message code='ezSchedule.t1103' /></NAME>
	            		<WIDTH>200</WIDTH>
	          		</HEADER>      
	        	</HEADERS>
	      	</LISTVIEWDATA>
	    </xml>
	    <h1><spring:message code='ezSchedule.t1101' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="btn_close()"></span></li>
            </ul>
        </div>
	    <table>
	    	<tr>
	        	<td>
	                <h2><span id="menu01" ><spring:message code='ezSchedule.t1104' /></span></h2>
	                <div class="box" style="height:300px;width:245px;overflow-x:auto;overflow-y:auto;" id="TreeView"></div>
	            </td>
	            <td style="width: 30px; text-align: center;">
                    <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;margin-top:22px" onclick="InsertReceiver()"><br/>
                    <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()">
                </td>
	            <td>
	                <h2><span id="Span1"><spring:message code='ezSchedule.t1105' /></span></h2>
	                <div class="listview">
	                    <div id="ListView" STYLE="border:0; Width:245px; Height:302px; overflow:auto;"></div>
	                </div> 
	            </td>
	        </tr>      
	    </table>
	    <div class="btnpositionNew">
	   		<a class="imgbtn"><span onClick="Add_ResourceInfo()"><spring:message code='ezSchedule.t1106' /></span></a>
	        <a class="imgbtn"><span onClick="btn_OK()"><spring:message code='ezSchedule.t190' /></span></a>
	    </div>			
	</body>
</html>