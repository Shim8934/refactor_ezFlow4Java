<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value="${title}" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/ezSchedule/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/ListView_list.js"></script>
        <script type="text/javascript" src="/js/Common.js"></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
		<script type="text/javascript">
	        var pStartTime = "<c:out value='${startTime}' />";
	        var pEndTime = "<c:out value='${endTime}' />";	        
	        var bSearch = false;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var CurPage = "1";
	        var strSearch = "<c:out value='${pSearchString}' />";
	        var RetValue;
	        var ReturnFunction;

	        document.onselectstart = function () { return false; };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                //window.focus();
	            }
	        }
	        document.onkeydown = function (evt) {
	            var e = evt;
	            if (e == null) e = window.event;
	            if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
	                if ((e.keyCode > 47) && (e.keyCode < 58)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode > 95) && (e.keyCode < 106)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode > 64) && (e.keyCode < 91)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode == 106) ||
	                    (e.keyCode == 107) ||
	                    (e.keyCode == 109) ||
	                    (e.keyCode == 110) ||
	                    (e.keyCode == 111) ||
	                    (e.keyCode == 186) ||
	                    (e.keyCode == 187) ||
	                    (e.keyCode == 188) ||
	                    (e.keyCode == 189) ||
	                    (e.keyCode == 190) ||
	                    (e.keyCode == 191) ||
	                    (e.keyCode == 192) ||
	                    (e.keyCode == 219) ||
	                    (e.keyCode == 220) ||
	                    (e.keyCode == 221) ||
	                    (e.keyCode == 222)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode == 229)) {
	                    e.returnValue = false;
	                }
	            }
	        }
	        window.onload = function () {
	            try {
	                RetValue = parent.schedule_select_entity_dialogArguments[0];
	                ReturnFunction = parent.schedule_select_entity_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.schedule_select_entity_dialogArguments[0];
	                    ReturnFunction = opener.schedule_select_entity_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }

	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }

	            ListTypeChangeIcon();
	            recevieListview("MsgToList", "ListViewMsgTo");
	            try {
	            	var xmlpara = createXmlDom();
	            	var xmlTree = createXmlDom();
	            	var xmlHTTP = createXMLHttpRequest();
	            	var objNode;
	            	createNodeInsert(xmlpara, objNode, "DATA");
	            	createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${deptID}");
	            	createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
	            	createNodeAndInsertText(xmlpara, objNode, "PROP", "");
	            	xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            	xmlHTTP.send(xmlpara);
	            	xmlTree = loadXMLString(xmlHTTP.responseText);
	            	var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	            	document.getElementById('TreeView').innerHTML = "";
	            	var treeView = new TreeView();
	            	treeView.SetConfig(treeXML);
	            	treeView.SetID("FromTreeView");
	            	treeView.SetUseAgency(true);
	            	treeView.SetRequestData("RequestData");
	            	treeView.SetNodeClick("TreeViewNodeClick");
	            	treeView.DataSource(xmlTree);
	            	treeView.DataBind("TreeView");
	            }
	            catch (ErrMsg) {
	                alert(" TreeViewinitialize : " + ErrMsg.description);
	            }

	            if (RetValue != null) {
	                var listView = new ListView();
	                listView.LoadFromID("MsgToList");

	                listView.DeleteRow(listView.GetDataRows()[0].id);

	                var totalRows = listView.GetDataRows();
	                var totalLen = totalRows.length;

	                var dialoglength = 0;
	                dialoglength = RetValue.length;

	                for (var i = 0; i < dialoglength; i++) {
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";

	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>"

	                    var strName;
	                    var strId;
	                    var strDeptName1;

	                    if (CrossYN()) {
	                        strName = RetValue["name"][i];
	                        strId = RetValue["id"][i];
	                        strDeptName1 = RetValue["deptname"][i];
	                    }
	                    else {
	                        strName = window.dialogArguments["name"][i];
	                        strId = window.dialogArguments["id"][i];
	                        strDeptName1 = window.dialogArguments["deptname"][i];
	                    }

	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                    pparsingXML = pparsingXML + "<DATA2>" + strName + "</DATA2>";
	                    pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptName1 + "]]></DATA4>";
	                    pparsingXML = pparsingXML + "<VALUE>" + strName + "</VALUE></CELL></ROW>";

	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
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
	        }

	        function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
	    	    treeNode.LoadFromID(TreeIdx);
	        	var deptID = treeNode.GetNodeData("CN");
	        	GetDeptsubTreeInfo(deptID, TreeIdx);
	    	}
	    	function GetDeptsubTreeInfo(deptID, TreeIdx) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
	    	    var xmlpara = createXmlDom();
		        var objNode;
	        	createNodeInsert(xmlpara, objNode, "DATA");
	        	createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
	        	createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
	        	xmlHTTP.open("POST", "/ezOrgan/getDeptsubTreeInfo.do", false);
	        	xmlHTTP.send(xmlpara);
	        	xmlRtn = loadXMLString(xmlHTTP.responseText);
	        	if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	    	        } else {
	                	xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	            	}
	        	}
	        	var treeView = new TreeView();
	        	treeView.LoadFromID("FromTreeView");
	        	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	    	}
	        function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetHeightFree(true);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	            listview.DataBind(pListView);
	            listview.RowDataBind();
	        }
	        function DeleteReceiver(pListView) {
	            var selList = new ListView();
	            selList.LoadFromID("MsgToList");
	            var arrRows = selList.GetSelectedRows();
	            var strName = "";
	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
	        var nodeIdx;
	        function TreeViewNodeClick() {
	            issearch = false;
	            CurPage = "1";
	            p_ListOrderObject = "";
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	        var tempDeptID = "";
	        function displayUserList(DeptID) {
		        if (DeptID != undefined) {
	            	tempDeptID = DeptID;
		        }

	        	$.ajax({
  					url : '/ezOrgan/getDeptMemberList.do',
  					method : 'POST',
  					dataType : "text",
  					data : {
  						deptID : tempDeptID ,
  						cell : "company;description;displayName;title;telephoneNumber",
  						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
  						page : CurPage ,
  						type : "user"
  					} ,
      				success : function(xml) {
 		                event_displayUserList(loadXMLString(xml));
 		                
 		                //2016-10-17 자바스크립트 실행순서때문에 자꾸 getDeptMemberList.do리스트가 나중에 나와서 window.onload 밑에있던부분 이쪽으로 위치 이동
 		               	if (strSearch != "") {
 			            	document.getElementById('keyword').value = strSearch;
 							search_click("search"); 
 							strSearch = "";
 		              	}
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
  						alert(error);
  					}
	  			});   
	        	 
	    	}
	        function event_displayUserList(xml) {
		        if (xml != null) {
    	            pListXML_Info = xml;
    	            xml = null;
                	pSeach = false;
                	DisplayUserImageList();
                	makePageSelPage();
		        } 
		    }
		    var m_strColorSelect = "#DBE1E7";
		    var m_strColorOver = "#f4f5f5";
		    var m_strColorDefault = "#ffffff";
		    var p_ListOrderObject = null;
		    function event_listMover(obj) {
		        for (var i = 0; i < listContentArry.length; i++) {
		            if (document.getElementById(listContentArry[i]) == obj) {
		                return;
		            }
		        }
		        if (p_ListOrderObject != obj) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
		            }
		        }
		    }
		    function event_listMout(obj) {
	
		        for (var i = 0; i < listContentArry.length; i++) {
		            if (document.getElementById(listContentArry[i]) == obj) {
		                return;
		            }
		        }
		        if (p_ListOrderObject != obj) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		            }
		        }
		    }
		    var PressShiftKey = false;
		    var PressCtrlKey = false;
		    function event_listOnkeyUp(event) {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            if (!event) event = window.event;
		        }
		        switch (event.keyCode) {
		            case 16: PressShiftKey = false; break;
		            case 17: PressCtrlKey = false; break;
		            case 46: deleteWork(false); break;
		        }
	
		    }
		    function event_listOnkeyDown(event) {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            if (!event) event = window.event;
		        }
		        switch (event.keyCode) {
		            case 16: PressShiftKey = true; break;
		            case 17: PressCtrlKey = true; break;
		        }
		    }
		    function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezSchedule.t1053' />");
	                return;
	            }
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            var dept = p_ListOrderObject.getAttribute("_DATA11");
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 450) / 2;
	            var pLeft = (pwidth - 420) / 2;
	            
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px,  top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
		    var listContentArry = new Array();
		    var listsubContentArry = new Array();
		    var listEventCheckbox = false;
		    var listsubEventCheckbox = false;
		    function event_listclick(obj) {
		        if (!listEventCheckbox) {
		            if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
		                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                    }
	
		                }
		                listContentArry = new Array();
		            }
		            if (PressShiftKey) {
		                var SelectedPreObj = null;
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
		                    if (Cnt == 0)
		                        SelectedPreObj = p_ListOrderObject;
	
		                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                    }
		                }
		                listContentArry = new Array();
		                if (p_ListOrderObject == null)
		                    return;
	
		                var PrelistContent;
		                if (SelectedPreObj == null)
		                    PrelistContent = p_ListOrderObject.getAttribute("id");
		                else
		                    PrelistContent = SelectedPreObj.getAttribute("id");
	
		                p_ListOrderObject = obj;
	
		                var CurlistContent = obj.getAttribute("id");
		                var PrePoint = parseInt(PrelistContent.replace("MailUserlist_", ""));
		                var CurPoint = parseInt(CurlistContent.replace("MailUserlist_", ""));
		                if (PrePoint < CurPoint) {
	
		                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
		                        p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
		                        }
		                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
		                    }
	
		                }
		                else if (PrePoint > CurPoint) {
		                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
		                        p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
		                        }
		                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
		                    }
		                }
		                else
		                    return;
	
		            }
		            else {
		                p_ListOrderObject = obj;
		                var insertFlag = true;
		                for (var i = 0; i < listContentArry.length; i++) {
		                    if (listContentArry[i] == p_ListOrderObject.getAttribute("id")) {
		                        insertFlag = false;
		                        if (PressCtrlKey) {
		                            listContentArry.splice(i, 1);
		                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                            }
		                            if (listContentArry.length == 0)
		                                p_ListOrderObject = "";
		                        }
		                    }
		                }
		                if (insertFlag) {
		                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
		                    }
	
		                    listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
		                }
		            }
		        }
		        else
		            listEventCheckbox = false;
		    }
		    function event_listDBclick(obj) {
		        InsertReceiver("MsgToList");
		    }
		    function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	            if (listContentArry != "") {
	                for (var i = 0; i < listContentArry.length; i++) {
	                    var strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
	                    var strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
	                    var strDeptNM = document.getElementById(listContentArry[i]).getAttribute("_data5");
	                    var strEmail = document.getElementById(listContentArry[i]).getAttribute("_data3");
	                    var strName2 = document.getElementById(listContentArry[i]).getAttribute("_data11");
	                    var strDeptNM2 = document.getElementById(listContentArry[i]).getAttribute("_data13");
	                    var jickwe = document.getElementById(listContentArry[i]).getAttribute("_data14");
	                    var phone = document.getElementById(listContentArry[i]).getAttribute("_data8");
	
	                    var listid = "MsgToList";
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID(listid);
	                    var IsInsert = CheckMailReceiver(strId, "3");
	                    if (strId == "<c:out value='${userID}' />") {
	                        alert("<spring:message code='ezSchedule.t352' />");
	                        continue;
	                    }
	
	                    if (!IsInsert) {
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + strName + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3>" + strName2 + "</DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptNM + "]]></DATA4>";
	                        pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
	                        pparsingXML = pparsingXML + "<DATA6>" + strName + "</DATA6>";
	                        pparsingXML = pparsingXML + "<DATA7>" + jickwe + "</DATA7>";
	                        pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
	                        pparsingXML = pparsingXML + "<VALUE>" + strName + "</VALUE></CELL></ROW>";
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	
	                        var listview = new ListView();
	                        listview.LoadFromID(listid);
	
	                        var MaxID = 0;
	                        var InitTr = listview.GetDataRows();
	                        var MaxCntNum = 0;
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                            if (MaxID < curnum) {
	                                MaxID = curnum;
	                                MaxCntNum = j;
	                            }
	                        }
	
	                        var objTr = listview.AddRow(InitTr.length);
	                        if (MaxCntNum != 0)
	                            MaxCntNum = MaxCntNum + 1;
	                        SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                        listview.AddDataRow(objTr, Resultxml);
	
	                        var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                        for (var y = 0; y < _tdlength; y++) {
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                        }
	
	                    }
	                }
	
	            }
	            else {
	                if (p_ListOrderObject == "") {
	                    alert("<spring:message code='ezSchedule.t1053' />");
	                    return;
	                }
	                if (p_ListOrderObject != "") {
	                    var strId = p_ListOrderObject.getAttribute("_data2");
	                    var strName = p_ListOrderObject.getAttribute("_data4");
	                    var strDeptNM = p_ListOrderObject.getAttribute("_data5");
	                    var strEmail = p_ListOrderObject.getAttribute("_data3");
	                    var strName2 = p_ListOrderObject.getAttribute("_data11");
	                    var strDeptNM2 = p_ListOrderObject.getAttribute("_data13");
	                    var jickwe = p_ListOrderObject.getAttribute("_data14");
	                    var phone = p_ListOrderObject.getAttribute("_data8");
	
	                    var listid = "MsgToList";
	                
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID(listid);
	                    var bFlag = getlistview.ExistRow("DATA2", strEmail);
	
	                    if (bFlag) {
	                        pAddFlag = true;
	                    }
	                    else {
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + strName + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3>" + strName2 + "</DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptNM + "]]></DATA4>";
	                        pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
	                        pparsingXML = pparsingXML + "<DATA6>" + strName + "</DATA6>";
	                        pparsingXML = pparsingXML + "<DATA7>" + jickwe + "</DATA7>";
	                        pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
	                        pparsingXML = pparsingXML + "<VALUE>" + strName + "</VALUE></CELL></ROW>";
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	
	                        var listview = new ListView();
	                        listview.LoadFromID(listid);
	
	                        var MaxID = 0;
	                        var InitTr = listview.GetDataRows();
	                        var MaxCntNum = 0;
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                            if (MaxID < curnum) {
	                                MaxID = curnum;
	                                MaxCntNum = j;
	                            }
	                        }
	
	                        var objTr = listview.AddRow(InitTr.length);
	                        if (MaxCntNum != 0)
	                            MaxCntNum = MaxCntNum + 1;
	                        SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                        listview.AddDataRow(objTr, Resultxml);
	
	                        var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                        for (var y = 0; y < _tdlength; y++) {
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                            document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                        }
	                    }
	                }
	            }
			                
		        var listid ="MsgToList";
		        
		    }
	        function CheckMailReceiver(selRow, option) {
	            var rtnValue = false;
	            var email;
	            if (option == "1")
	                email = selRow.cells[0].DATA3;
	            else if (option == "2")
	                email = selRow.cells[0].DATA2;
	            else if (option == "3")
	                email = selRow;

	            var _listview = new ListView();
	            _listview.LoadFromID("MsgToList");
	            var arrRows = _listview.GetDataRows();
	            for (count2 = 0; count2 < arrRows.length; count2++) {
	                if (email == arrRows[count2].getAttribute("data1"))
	                    rtnValue = true;
	            }
	            return rtnValue
	        }
	        var pSeach = false;
	        function DisplayUserImageList() {
		        var xmlRtn = pListXML_Info;
		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
		        totalPage = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
		        
		        while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        var UserListHTML = "";
		        if (SelectDeptNM.getAttribute("countinfo") != "1") {
		            SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang256 + "</span>]";
		            SelectDeptNM.setAttribute("countinfo", "1")
		        }
		        
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang257 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang256 + "</span>]";
		                SelectDeptNM.setAttribute("countinfo", "1");
		            }
		        } else {
	                document.getElementById("DeptUserImgList").style.display = "none";
	                document.getElementById("txtlist_Layer").style.display = "";
	                
	                if (!pSeach) {
	                    document.getElementById("txtlist_table").style.display = "";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                } else {
	                    document.getElementById("Search_txtlist_table").style.display = "";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang257 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang256 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }

	            for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                if (pListType == "IMG") {
	                    var MainTable = document.createElement("TABLE");
	                    MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
	                    MainTable.setAttribute("cellspacing", "0");
	                    MainTable.setAttribute("cellpadding", "0");
	                    
	                    if (pListType == "IMG") {
	                        MainTable.style.marginTop = "5px";
	                    }
	                    MainTable.style.marginLeft = "auto";
	                    MainTable.style.marginRight = "auto";
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };                    
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    } else {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                        }
	                    }

	                    var M_TR_TD = document.createElement("TD");
	                    M_TR_TD.setAttribute("class", "pictd");
	                    var M_TR_DIV = document.createElement("DIV");
	                    M_TR_DIV.setAttribute("class", "pic");
	                    
	                    if (M_TR.getAttribute("_DATA9") != "") {	                    	
	                        var M_TR_IMG = document.createElement("IMG");
	                        M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
	                        M_TR_IMG.setAttribute("width", "90px");
	                        M_TR_IMG.setAttribute("height", "90px");
	                        M_TR_DIV.appendChild(M_TR_IMG);
	                    }
	                    M_TR_TD.appendChild(M_TR_DIV);
	                    M_TR.appendChild(M_TR_TD);

	                    var M_TR_TD2 = document.createElement("TD");
	                    M_TR_TD2.style.width = "300px";

	                    var M_TR_TDS_Table = document.createElement("TABLE");
	                    M_TR_TDS_Table.setAttribute("class", "organinfo");
	                    M_TR_TD2.appendChild(M_TR_TDS_Table);

	                    var sub_TR1 = document.createElement("TR");
	                    var sub_TD1 = document.createElement("TD");
	                    sub_TD1.style.textAlign = "left";
	                    sub_TD1.setAttribute("class", "name");
	                    var pDisplayName = "";
	                    if ("<c:out value='${use_ocs}'/>" == "YES") {
	                        pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
	                    }
	                    pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
	                    pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
	                    sub_TD1.innerHTML = pDisplayName;
	                    sub_TR1.appendChild(sub_TD1);

	                    var sub_TR2 = document.createElement("TR");
	                    var sub_TD2 = document.createElement("TD");
	                    sub_TD2.style.textAlign = "left";
	                    sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
	                    sub_TR2.appendChild(sub_TD2);

	                    var sub_TR3 = document.createElement("TR");
	                    var sub_TD3 = document.createElement("TD");
	                    sub_TD3.style.textAlign = "left";
	                    var sub_TD3_Img = document.createElement("IMG");
	                    sub_TD3_Img.setAttribute("class", "icon");
	                    sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
	                    sub_TD3.appendChild(sub_TD3_Img);
	                    sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
	                    sub_TR3.appendChild(sub_TD3);

	                    var sub_TR4 = document.createElement("TR");
	                    var sub_TD4 = document.createElement("TD");
	                    sub_TD4.style.textAlign = "left";
	                    var sub_TD4_Img = document.createElement("IMG");
	                    sub_TD4_Img.setAttribute("class", "icon");
	                    sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
	                    sub_TD4.appendChild(sub_TD4_Img);
	                    sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
	                    sub_TR4.appendChild(sub_TD4);

	                    M_TR_TDS_Table.appendChild(sub_TR1);
	                    M_TR_TDS_Table.appendChild(sub_TR2);
	                    M_TR_TDS_Table.appendChild(sub_TR3);
	                    M_TR_TDS_Table.appendChild(sub_TR4);

	                    M_TR.appendChild(M_TR_TD2);
	                    MainTable.appendChild(M_TR);	                    
	                    
	                    document.getElementById("DeptUserImgList").appendChild(MainTable);
	                } else {
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
 	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    } else {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                        }
	                    }

	                    if (pSeach) {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "110px";
	                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");

	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.overflow = "hidden";
	                        M_TR_TD2.style.textOverflow = "ellipsis";
	                        M_TR_TD2.style.whiteSpace = "nowrap";
	                        M_TR_TD2.style.width = "90px";
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
	                            M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD3.style.width = "80px";

	                        var M_TR_TD4 = document.createElement("TD");
	                        M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        M_TR.appendChild(M_TR_TD4);
	                        document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    } else {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "150px";
	                        
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
	                            M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.width = "80px";
	                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");

	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    }
	                }
	            }
	        }		    
		    function search_press(e) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		                search_click("search");
		            }
		        }
		        else {
		            if (e.which == 13)
		                search_click("search");
		        }
	
		    }
		    var issearch = false;
		    function search_click(type) {
		        listContentArry = new Array();
		        if (keyword.value == "") {
		            alert("<spring:message code='ezSchedule.t8' />");
		            keyword.focus();
		            return;
		        }
		        if (type == "search") {
		            CurPage = "1";
		            issearch = true;
		        }
		
		        $.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					data : {
						search : document.getElementById("search_type").value + "::" + keyword.value,
						cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
						page : CurPage ,
						type : "user"
					} ,
   					success : function(xml) {
   						event_displayUserList2(loadXMLString(xml));
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code="ezResource.t2"/>" + textStatus);
					}
				});
		
		        var usedefault;
		        if (browserIE) {
		            usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
		        }
		        else {
		            usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
		        }
		    }
		    function event_displayUserList2(xml) {
		        if (xml != null) {
	                if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length == 0) {
                    	alert("<spring:message code='ezPersonal.t211'/>");
	                } else {
	                    pListXML_Info = xml;
                    	pSeach = true;
                    	DisplayUserImageList();
                    	makePageSelPage();
                	}
	    	    }
	    	}
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
	
		        return (orgStr.replace(re, replaceStr));
		    }
		    function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
		        }
		        else {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
		        }
		    }
		    function ChangeListView_onClick(Div) {
		        pListType = Div;
		        ListTypeChangeIcon();
		        DisplayUserImageList();
		    }
		    function keyword_Clear() {
		        document.getElementsByName('keyword').item(0).value = "";
		    }
	
		    function close_onclick() {
		        var rtn = { "id": new Array(), "name": new Array(), "deptname": new Array() };
	
		        var listid = "MsgToList";
		        var selList = new ListView();
		        selList.LoadFromID(listid);
	
		        var totalRows = selList.GetDataRows();
		        var totalLen = totalRows.length;
		        for (var i = 0; i < totalLen; i++) {
		            rtn["id"][i] = GetAttribute(totalRows[i], "DATA1");
		            rtn["name"][i] = GetAttribute(totalRows[i], "DATA2");
		            rtn["deptname"][i] = GetAttribute(totalRows[i], "DATA4");
		        }
		        if (ReturnFunction != null) {
		            ReturnFunction(rtn);
		        }
		        else {
		            window.returnValue = rtn;
		        }
		        window.close();
		    }
		    function onDragEnter(evt) {
		        evt.stopPropagation();
		        evt.preventDefault();
		        evt.dataTransfer.dropEffect = "copy";
		        evt.dataTransfer.effectAllowed = "copy";
		    }
		    function onDrop(evt, element) {
		        evt.stopPropagation();
		        evt.preventDefault();
		        InsertReceiver(element);
		    }
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang268 + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang268 + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang268 + "</span>";
		            PagingHTML += strtext;
		        }
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        }
		        else {
		            MaxNum = totalPage;
		        }
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang269 + "</span>";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang269 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang269 + "</span>";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		    function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPage();
		        movePage(CurPage);
		    }
		    function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            if (issearch)
		                search_click();
		            else
		                displayUserList();
		        }
		    }
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            CurPage = newPage;
		            if (issearch)
		                search_click();
		            else
		                displayUserList();
		        }
		    }
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
		            if (issearch)
		                search_click();
		            else
		                displayUserList();
		        }
		    }	
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1 id="h1Title"><c:out value="${title}" /></h1>
		<table style="width:100%">
			<tr>
				<td>
	        		<table id="TreeViewTD">
	                	<tr>
	                    	<td>
	                            <div class="portlet_tabpart03" style="background-color: #e9e9e9; margin-top: 4px;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                                    <table style="margin-top: 3px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type">
	                                                        <option selected value="displayname"><spring:message code='ezSchedule.t18' /></option>
	                                                        <option value="description"><spring:message code='ezSchedule.t12' /></option>
	                                                        <option value="title"><spring:message code='ezSchedule.t14' /></option>
	                                                        <option value="telephonenumber"><spring:message code='ezSchedule.t1050' /></option>
	                                                        <option value="mobile"><spring:message code='ezSchedule.t1051' /></option>
	                                                        <option value="HomePhone"><spring:message code='ezSchedule.t20' /></option>
	                                                        <option value="facsimileTelephoneNumber"><spring:message code='ezSchedule.t21' /></option>
	                                                        <option value="mail"><spring:message code='ezSchedule.t22' /></option>
	                                                        <option value="streetAddress"><spring:message code='ezSchedule.t23' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezSchedule.t24' /></span></a>
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px;">
	                                                    <a href="#" class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezSchedule.t1052' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px">
	                                        <div style="width: 220px; height: 465px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="width: 426px" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                            <tr>
	                                                <th style="white-space:normal">
	                                                    <span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                                    <span style="float:right;">
	                                                        <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                            <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezSchedule.t18' /></td>
	                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezSchedule.t14' /></td>
	                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezSchedule.t1050' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezSchedule.t12' /></td>
	                                                    <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezSchedule.t18' /></td>
	                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezSchedule.t14' /></td>
	                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezSchedule.t1050' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer" style="text-align:center;border-top:1px solid #B6B6B6"></div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"/><br/>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)"/>
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="ToTitle" class="receiver_tltype01" style="cursor: pointer;">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezSchedule.t163' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 477px; overflow-x: auto; overflow-y: auto;"  ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
	    	</tr> 
	 	</table> 
	    <br />
		<div class="btnposition">	    	
	    	<a class="imgbtn" onClick="close_onclick()" ><span><spring:message code='ezSchedule.t4' /></span></a>
	    	<a class="imgbtn" onClick="window.close();" ><span><spring:message code='ezSchedule.t5' /></span></a>
		</div>
	</body>
</HTML>
