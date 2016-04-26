<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <link rel="stylesheet" href="/css/previewmail.css" type="text/css">
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var pUse_Editor = "<c:out value='${use_editor}'/>";
	    	var pUse_IE11Browser = "<c:out value='${use_ie11Browser}'/>";
	    	
	    	document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
	                return false;
	            } else {
	                return true;
	            }
	        };
	        
	        var topid = "";
	        var Tab1_flag = true;
	        var CardHeader1 = "<spring:message code='ezOrgan.t263' />";
	        var CardHeader2 = "<spring:message code='ezOrgan.t189' />";
	        var CardHeader3 = "<spring:message code='ezOrgan.t264' />";
	    	
			$(document).ready(function() {
				AddJob_List();
			});			
			
			function company_change() {
		        AddJob_List();
		    }
		    
		    function AddJob_List() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/admin/ezOrgan/getAddJobList.do",
		        	data : {companyID : document.getElementById("ListCompany").value},
		        	success : function(result){
		        		var xmldom = result;
		                var headerData = createXmlDom();
		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                if (CrossYN()) {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }

		                document.getElementById("AddJobListView").innerHTML = "";

		                var listview = new ListView();
		                listview.SetID("lvAddJobList");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnClick("UserAddjobList");
		                listview.SetSelectFlag(false);
		                listview.SetRowOnDblClick("User_View");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("AddJobListView");
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t2' />" + error);
		        	}
		        });		        
		    }
		    
		    var clickTabID = "1tab1";
		    function ChangeTab(obj) {
		        var pSelectTab = obj.getAttribute("divname");
		        clickTabID = obj.id;
		        DelType = pSelectTab;
		        type = pSelectTab + "=1";        
		    }
		    
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id){
		            obj.className = "";
		        }
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";

		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;

		                    if (Tab1_flag) {
		                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
		                        Tab1_flag = false;
		                    }
		                }
		            }
		        }
		    }
		    
		    function UserAddjobList() {
		        var listview = new ListView();
		        listview.LoadFromID("lvAddJobList");		        
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/admin/ezOrgan/getUserAddJobList.do",
		        	data : {cn : listview.GetSelectedRows()[0].getAttribute("DATA1")},
		        	success : function(result){
		        		document.getElementById("AddJobList").innerHTML = "";
		                var UserAddJobList = SelectNodes(result, "DATA/ROW");
		                
		                for (var Cnt = 0; Cnt < UserAddJobList.length; Cnt++) {
		                    var DivLayer = document.createElement("DIV");
		                    DivLayer.setAttribute("id", "Cardlist_" + Cnt);                    
		                    DivLayer.className = "address_boxlist";
		                    DivLayer.style.cursor = "pointer";
		                    DivLayer.style.display = "inline-block";
		                    DivLayer.style.marginRight = "5px";
		                    DivLayer.style.marginBottom = "10px";
		                    DivLayer.style.height = "80px";
		                    DivLayer.setAttribute("_CN", getNodeText(SelectNodes(UserAddJobList[0], "CN")[Cnt]));
		                    DivLayer.setAttribute("_DEPTID", getNodeText(SelectNodes(UserAddJobList[0], "DEPARTMENT")[Cnt]));
		                    DivLayer.setAttribute("_T1", getNodeText(SelectNodes(UserAddJobList[0], "TITLE1")[Cnt]));
		                    DivLayer.setAttribute("_T2", getNodeText(SelectNodes(UserAddJobList[0], "TITLE2")[Cnt]));
		                    DivLayer.onclick = function () { event_Cardlistclick(this); };
		                    DivLayer.onselectstart = function () { return false; };

		                    var oTable = document.createElement("TABLE");
		                    oTable.setAttribute("style", "width:248px");
		                    var oTr = document.createElement("TR");
		                    oTable.appendChild(oTr);

		                    var SubDivLayer = document.createElement("DIV");
		                    SubDivLayer.className = "back";
		                    SubDivLayer.style.height = "80px";

		                    var SubDIVTag = document.createElement("DIV");
		                    SubDIVTag.className = "topinfo";
		                    SubDIVTag.innerHTML = "<img src=\"/images/icon/i_group.gif\" style=\"vertical-align:middle;margin-top:-4px;\" /> " + getNodeText(SelectNodes(UserAddJobList[0], "COMPANY")[Cnt]);

		                    var oTd = document.createElement("TD");
		                    oTd.setAttribute("style", "width:99%");
		                    oTd.appendChild(SubDIVTag);
		                    oTr.appendChild(oTd);

		                    var ImgPTag = document.createElement("DIV");
		                    ImgPTag.setAttribute("id", "Cardlist_" + Cnt);
		                    ImgPTag.onclick = function () { event_DeleteClick(this) };
		                    ImgPTag.className = "topinfo";
		                    ImgPTag.innerHTML = "<img src=\"/images/icon/btn_topBtn.png\" />";

		                    var oTd = document.createElement("TD");
		                    oTd.appendChild(ImgPTag);
		                    oTr.appendChild(oTd);

		                    var ULTag = document.createElement("ul");
		                    var UITag1 = document.createElement("li");
		                    UITag1.className = "name";
		                    if (CrossYN()) {
		                        UITag1.textContent = getNodeText(SelectNodes(UserAddJobList[0], "DESCRIPTION")[Cnt]);
		                    } else {
		                        UITag1.innerText = getNodeText(SelectNodes(UserAddJobList[0], "DESCRIPTION")[Cnt]);
		                    }
		                    var UITag3 = document.createElement("li");
		                    UITag3.innerHTML = "<span class=\"point_txt\">" + getNodeText(SelectNodes(UserAddJobList[0], "DISPLAYNAME")[Cnt]) + " (" + getNodeText(SelectNodes(UserAddJobList[0], "TITLE")[Cnt]) + ")</span>";                    

		                    var EndDiv = document.createElement("DIV");
		                    EndDiv.className = "shadow";

		                    DivLayer.appendChild(SubDivLayer);
		                    DivLayer.appendChild(EndDiv);
		                    SubDivLayer.appendChild(oTable);

		                    SubDivLayer.appendChild(ULTag);
		                    ULTag.appendChild(UITag1);
		                    ULTag.appendChild(UITag3);
		                    document.getElementById("AddJobList").appendChild(DivLayer);
		                }	
		        	}
		        });		        
		    }
		    
		    function event_DeleteClick(obj) {
		        AddJob_Del('DEL', obj);
		    }
		    
		    var listContentArry = new Array();
		    var listEventCheckbox = false;
		    var _RowObject = null;		    
		    function AddJob_Del(mode, obj) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		        var xmlPara = createXmlDom();
		        var objRoot, objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");

		        if (mode == "DEL") {
		            if (_RowObject == null || _RowObject == "") {
		                alert("<spring:message code='ezOrgan.t196' />");
		                return;
		            }
		            _RowObject = document.getElementById(_RowObject.id);

		            if (document.getElementById("AddJobList").childNodes.length == 1) {
		                var listview = new ListView();
		                listview.LoadFromID("lvAddJobList");
		                for (var i = 0; i < document.getElementById("AddJobList").childNodes.length ; i++) {
		                    createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(listview.GetSelectedRows()[0], "data1"));
		                    createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid"));
		                    createNodeAndInsertText(xmlDom, objNode, "TITLE", "");
		                }
		                mode = "";
		            } else {
		                for (var i = 0; i < document.getElementById("AddJobList").childNodes.length ; i++) {
		                    if (GetAttribute(_RowObject, "_DEPTID") != GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid")) {
		                        createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(_RowObject, "_CN"));
		                        createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid"));
		                        createNodeAndInsertText(xmlDom, objNode, "TITLE", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_t1") + ":" + GetAttribute(document.getElementById("AddJobList").childNodes[i], "_t2"));
		                    }
		                }
		            }
		        } else {
		            var listview = new ListView();
		            listview.LoadFromID("lvAddJobList");

		            if (listview.GetSelectedRows() == null || listview.GetSelectedRows() == "") {
		                alert("<spring:message code='ezOrgan.t9901' />");
		                return;
		            }
		            
		            if (confirm(strLang30)) {
		                for (var i = 0; i < document.getElementById("AddJobList").childNodes.length ; i++) {
		                    createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(listview.GetSelectedRows()[0], "data1"));
		                    createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(document.getElementById("AddJobList").childNodes[i], "_deptid"));
		                    createNodeAndInsertText(xmlDom, objNode, "TITLE", "");
		                }
		            } else {
		                window.location.reload(false);
		                return;
		            }
		        }

		        xmlHTTP.open("POST", "/admin/ezOrgan/saveSubTitle.do", false);
		        xmlHTTP.send(xmlDom);

		        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
		            alert("<spring:message code='ezOrgan.t197' />");
		            return;
		        } else {
		            alert("<spring:message code='ezOrgan.t198' />");
		            _RowObject = null;
		            
		            if (mode == "DEL") {
		                UserAddjobList();
		            } else {
		                window.location.reload(false);
		            }
		            return;
		        }
		    }
		    
		    function event_Cardlistclick(obj) {
		        if (!listEventCheckbox) {
		            if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    _RowObject = document.getElementById(listContentArry[Cnt]);
		                    _RowObject.className = "address_boxlist";
		                }
		                listContentArry = new Array();
		            }
		            if (PressShiftKey) {
		                var SelectedPreObj = null;
		                var PrelistContent;
		                
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    _RowObject = document.getElementById(listContentArry[Cnt]);
		                    
		                    if (Cnt == 0) {
		                        SelectedPreObj = _RowObject;
		                    }
		                    _RowObject.className = "address_boxlist";
		                }
		                listContentArry = new Array();
		                
		                if (SelectedPreObj == null) {
		                    PrelistContent = _RowObject.getAttribute("id");
		                } else {
		                    PrelistContent = SelectedPreObj.getAttribute("id");
		                }
		                _RowObject = obj;

		                var CurlistContent = obj.getAttribute("id");
		                var PrePoint = parseInt(PrelistContent.replace("Cardlist_", ""));
		                var CurPoint = parseInt(CurlistContent.replace("Cardlist_", ""));
		                
		                if (PrePoint < CurPoint) {
		                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
		                        _RowObject = document.getElementById("Cardlist_" + Cnt);
		                        _RowObject.className = "address_onboxlist";
		                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
		                    }
		                } else if (PrePoint > CurPoint) {
		                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
		                        _RowObject = document.getElementById("Cardlist_" + Cnt);
		                        _RowObject.className = "address_onboxlist";
		                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
		                    }
		                } else {
		                    return;
		                }
		            } else {
		                _RowObject = obj;
		                var insertFlag = true;
		                
		                for (var i = 0; i < listContentArry.length; i++) {
		                    if (listContentArry[i] == _RowObject.getAttribute("id")) {
		                        insertFlag = false;
		                        
		                        if (PressCtrlKey) {
		                            listContentArry.splice(i, 1);
		                            _RowObject.className = "address_boxlist";
		                        }
		                    }
		                }
		                if (insertFlag) {
		                    _RowObject.className = "address_onboxlist";
		                    listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
		                }
		            }
		        } else {
		            listEventCheckbox = false;
		        }
		    }
		    
		    var addjob_config_dialogArguments = new Array();
		    function AddJob_Add() {        
		        var Params = new Array();
		        var result = "";
		        
		        //2016-04-25 장진혁과장 -- Cross 버전 선택 주석처리
		        //if (CrossYN()) {
	            addjob_config_dialogArguments[0] = Params;
	            addjob_config_dialogArguments[1] = AddJob_Add_Complete;
	            var OpenWin = window.open("/admin/ezOrgan/addJobConfig.do?companyID=" + document.getElementById("ListCompany").value, "AddJob_Config", GetOpenWindowfeature(970, 600));
	            try { OpenWin.focus(); } catch (e) { }
		        /* } else {
		            window.showModalDialog("AddJob_Config.aspx?companyid=" + document.getElementById("ListCompany").value, Params, "dialogHeight:600px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(970, 600));
		            window.location.reload(false);
		        } */
		    }
		    
		    function AddJob_Add_Complete() {
		        window.location.reload(false);
		    }
		    
		    function User_View() {
		        var listview = new ListView();
		        listview.LoadFromID("lvAddJobList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        }

		        var id = listview.GetSelectedRows()[0].getAttribute("DATA1");
		        
		      	//2016-04-25 장진혁과장 -- Cross 버전 선택 주석처리
		        //if (CrossYN()) {		       
	            addjob_config_dialogArguments = new Array();
	            addjob_config_dialogArguments[1] = AddJob_Add_Complete;		            
	            var OpenWin = window.open("/admin/ezOrgan/addJobConfig.do?userID=" + encodeURI(id) + "&companyID=" + document.getElementById("ListCompany").value, "AddJob_Config", GetOpenWindowfeature(970, 580));
	            try { OpenWin.focus(); } catch (e) { }
		        /* } else {
		            window.showModalDialog("Addjob_Config.aspx?userid=" + escape(id) + "&companyid=" + document.getElementById("ListCompany").value, "", "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(970, 580));
		            window.location.reload(false);
		        } */
		    }
	    </script>
	</head>
	<body class="mainbody">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t218' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t67' /></NAME>
		        		<WIDTH>20%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t69' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t68' /></NAME>
		        		<WIDTH>20%</WIDTH>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t123' /></NAME>
		        		<WIDTH>10%</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <form id="Form1" method="post">
		    <h1><spring:message code='ezOrgan.t00013' /></h1>
		    <div id="mainmenu">
		    	<span><b><spring:message code='ezOrgan.t00006' /></b></span>
	            <div style="margin-top:5px;margin-bottom:10px">		           
		            <select id="ListCompany" onchange="company_change()">
		            	<c:forEach var="item" items="${list}">
		            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		            	</c:forEach>
		            </select>
	            </div>
		        <ul>		            
		            <li><span onClick="AddJob_Add()"><spring:message code='ezOrgan.t00014' /></span></li>
		            <li><span onClick="AddJob_Del('DEL', '')"><spring:message code='ezOrgan.t00015' /></span></li>
		            <li><span onClick="AddJob_Del('ALL', '')"><spring:message code='ezOrgan.t00016' /></span></li>            
		            <li><span onClick="email_onclick()"><spring:message code='ezOrgan.t00010' /></span></li>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
		    </script>
		    <div class="portlet_tabpart01" style="padding-bottom:3px">
		        <div class="portlet_tabpart01_top" id="tab1" style="width:500px;">
	                <p id="AddJob_sub1"><span divname="AddJob1" id="1tab1"><spring:message code='ezOrgan.t00017' /></span></p>               
		        </div>
		    </div>
		    <table style="width:100%">
		        <tr>
		            <td style="width:500px">
		                <div class="listview" style="Width:500px; border-top:0px;">
		                    <div id="AddJobListView" style="border: 0px solid #B6B6B6; Width: 500px; Height:600PX; overflow-x: auto; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
		                </div>
		            </td>
		            <td style="padding-left:3px; vertical-align:top">            
		                 <div style="height:100%; width:550px;" id="AddJobList" >
		                </div>      
		            </td>
		        </tr>
		    </table>    
		</form>         
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>