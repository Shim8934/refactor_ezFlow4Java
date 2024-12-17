<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t285' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <style>
	    	#txtlist_table tr td:first-child {
	    		padding-left:15px;
	    	}
	    	/* 조직도 #SelectDeptNM(부서명[사원수]) 부분 */
			#spn_deptName {
				text-overflow: ellipsis;
				white-space: nowrap;
				overflow: hidden;
				display: inline-block;
			}
			#countInfo {
				overflow: hidden;
				display: inline-block;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezSchedule/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/ListView_list.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>        
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        
		<script type="text/javascript">
	        var pStartTime = "<c:out value='${startTime}' />";
	        var pEndTime = "<c:out value='${endTime}' />";
	        var pGubun = "<c:out value='${gubun}' />";
	        var type = "<c:out value='${type}' />";
	        var bSearch = false;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var CurPage = "1";
	        var strSearch = "<c:out value='${pSearchString}' />";
	        var RetValue;
	        var ReturnFunction;
	        var deptClickFlag; // 2018-05-11 (문성업) 직원 맴버를 전원 클릭하는 것 같은 효과를 나타내는 마우스 효과 (수정)
	        
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
	                RetValue = parent.schedule_select_attendant_dialogArguments[0];
	                ReturnFunction = parent.schedule_select_attendant_dialogArguments[1];                
	            } catch (e) {
	                try {
	                    RetValue = opener.schedule_select_attendant_dialogArguments[0];
	                    ReturnFunction = opener.schedule_select_attendant_dialogArguments[1];
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
	            if (pGubun == "") {
// 	                document.getElementById("btnAddUser").style.display = "";
	                if (CrossYN())
	                    document.getElementById("ToTitleStr").textContent = "<spring:message code='ezAttitude.t282' />";
	                else
	                    document.getElementById("ToTitleStr").innerText = "<spring:message code='ezAttitude.t282' />";
	            }

	            $("#1tab1").click();
	            ChangeTab(document.getElementById("1tab1"));
	            getCircularDept();
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
	            	
	                if (type == "group") {
	                    document.getElementById("ToTitleStr").textContent = "<spring:message code='ezAttitude.t282' />";	
	                }
	            }
	            catch (ErrMsg) {
	                alert(" TreeViewinitialize : " + ErrMsg.description);
	            }
	            
	            var listView = new ListView();
	            listView.LoadFromID("MsgToList");
	
	            var totalRows = listView.GetDataRows();
	            var totalLen = totalRows.length;
	
	            var stridlength = 0;
	            if (RetValue != undefined && RetValue["id"] != undefined && RetValue["id"] != "")
	                stridlength = RetValue["id"].length;

	            for (var i = 0; i < stridlength; i++) {
	                var pparsingXML = "";
	                var pparsingXML2 = "";
	
	                pparsingXML2 = "<LISTVIEWDATA2><ROWS>"
	                var strName;
	                var strId;
	                var strName1;
	                var strName2;
	                var strDeptName1;
	                var strDeptName2;

	                strName = RetValue["name"][i];
	                strId = RetValue["id"][i];
	                strName1 = RetValue["name1"][i];
	                strName2 = RetValue["name2"][i];
	                strDeptName1 = RetValue["deptname"][i];
	                strDeptName2 = RetValue["deptname2"][i];
	
	                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
	                pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
	                pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptName1 + "]]></DATA4>";
	                pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptName2 + "]]></DATA5>";
	                pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
	                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
	                
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
	            
	            ChangeListView_onClick(getOrganListType());
	        }
	
	        var schedule_add_user_cross_dialogArguments = new Array();
	        function Add_UserInfo_onclick() {
	            var listView = new ListView();
	            listView.LoadFromID("MsgToList");
	
	            var totalRows = listView.GetDataRows();
	            var totalLen = totalRows.length;

	            if (totalLen == 0) {
	                alert("<spring:message code='ezCircular.t147' />");
	                return;
	            }
	
	            var rtn = { "id": new Array(), "name": new Array(), "deptname": new Array() };
	
	            for (var i = 0; i < totalLen; i++) {
	                rtn["name"][i] = GetAttribute(totalRows[i], "DATA2");
	                rtn["id"][i] = GetAttribute(totalRows[i], "DATA1");
	                rtn["deptname"][i] = GetAttribute(totalRows[i], "DATA4");
	            }
	
	            var g_param = new Array();
	
	            g_param["startTime"] = pStartTime;
	            g_param["endTime"] = pEndTime;
	            g_param["entryList"] = rtn;
	
	            var cmd, org_num, org_ownerID;
	
	            var feature = GetShowModalPosition(695, 430);
	            if (CrossYN()) {
	                schedule_add_user_cross_dialogArguments[0] = g_param;
	                schedule_add_user_cross_dialogArguments[1] = Add_UserInfo_onclick_Complete;
	                var OpenWin = window.open("/ezSchedule/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, "schedule_Add_User_Cross", GetOpenWindowfeature(695, 430));
	                try { OpenWin.focus(); } catch (e) { }
	            } else{
	                var reParam = window.showModalDialog("/ezSchedule/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no" + feature);
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
	
	        function Add_UserInfo_onclick_Complete(reParam) {
	            idDatepicker.vtLocalDate = reParam["startTime"];
	            idDatepicker.vtLocalEndDate = reParam["endTime"];
	
	            if (reParam["entryList"] != "") {
	                xmpEntryEmailList.innerText = reParam["entryList"];
	                DisplayEntryList();
	            }
	        }
	        function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
	    	    treeNode.LoadFromID(TreeIdx);
	        	var deptID = treeNode.GetNodeData("CN");
	        	GetDeptSubTreeInfo(deptID, TreeIdx);
	    	}
	    	function GetDeptSubTreeInfo(deptID, TreeIdx) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
	    	    var xmlpara = createXmlDom();
		        var objNode;
	        	createNodeInsert(xmlpara, objNode, "DATA");
	        	createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
	        	createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
	        	xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
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
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
	            	+ "<span id='spn_deptName' title='" + ReplaceText(nodeIdx.GetNodeData("VALUE"), "&", "&amp;") + "'>" + ReplaceText(nodeIdx.GetNodeData("VALUE"), "&", "&amp;") + "</span>"
	            	+ "<span id='countInfo'></span>";
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
  						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department",
  						page : CurPage ,
  						type : "user"
  					} ,
      				success : function(xml) {
 		                event_displayUserList(loadXMLString(xml));
 		                
 		                // 2016-10-17 자바스크립트 실행순서때문에 자꾸 getDeptMemberList.do리스트가 나중에 나와서 window.onload 밑에있던부분 이쪽으로 위치 이동
 		               	if (strSearch != "") {
 			            	document.getElementById('keyword').value = strSearch;
 							search_click("search"); 
 							strSearch = "";
 		              	}
 		                
 		               /** boh add : 부서 클릭하면 부서 전체 list 추가하기  2018-05-11 (문성업)수정 */ 
						deptClickFlag = true; 
						listContentArry = new Array();
						
						var tempListContent = $("#txtlist_table tr[id^='MailUserlist_']");
						var tempListLen = tempListContent.length;
						for(var i = 0; i < tempListLen; i++) {
							listContentArry[i] = tempListContent[i].getAttribute("id");
						}
						/** boh end */
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
  						alert(error);
  					}
	  			});
	        	
	        	$.ajax({
					url : "/ezOrgan/getDeptMemberListCount.do",
					method : "POST",
					dataType : "json",
					data : {
						deptID : tempDeptID
					},
					success : function(result) {
						if (SelectDeptNM.getAttribute("countinfo") != "1" && !pSeach ) {
							var id = $("span[class=node_selected]").eq(0).closest("div").attr("id");
							var strIsLeaf = $("div#" + id + "").attr("isleaf");
							
							if (result.containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
								document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span> / <span class='txt_color'>" + parseInt(result.totalCount + result.totalCount2) + "</span>";
							} else {
								document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span>";
							}
							//2018-08-01 김보미 - 부서명 [사원수] 가 넘치는지 확인하는 함수
							deptNameLong(result.containLow, strIsLeaf);
							
			            	SelectDeptNM.setAttribute("countinfo","1")
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
	        
	        var m_strColorSelect = "#f1f8ff";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var p_ListOrderObject = null;
	        function event_listMover(obj) {
	        	if(!deptClickFlag){ //2018-05-11 (문성업)수정
	                 for (var i = 0; i < listContentArry.length; i++) {
	                     if (document.getElementById(listContentArry[i]) == obj) {
	                    return;
	                     }
	                }
	            }
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
	                }
	            }
	        }
	        function event_listMout(obj) {
	          if(!deptClickFlag){ // 2018-05-11 (문성업)수정
	            for (var i = 0; i < listContentArry.length; i++) {
	                if (document.getElementById(listContentArry[i]) == obj) {
	                    return;
	                }
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
	                alert("<spring:message code='ezCircular.t148' />");
	                return;
	            }
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            var dept = p_ListOrderObject.getAttribute("_DATA10");
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 450) / 2;
	            var pLeft = (pwidth - 420) / 2;
	            
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px,  top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        
	        var listContentArry = new Array();
	        var listSubContentArry = new Array();
	        var listEventCheckbox = false;
	        var listSubEventCheckbox = false;
	        function event_listclick(obj) {
	        	deptClickFlag = false; // 2018-05-11 (문성업)수정
	            if (!listEventCheckbox) {
	                if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        
	                        if (p_ListOrderObject != null) {
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
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
	                    if (p_ListOrderObject == null || p_ListOrderObject == "")
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
	                    if (PrePoint <= CurPoint) { // 2018-05-18 문성업 (수정)
	
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
		    
            var strId = "";
            var strName = "";
            var strDeptNM = "";
            var strEmail = "";
            var strName2 = "";
            var strDeptNM2 = "";
            var jickwe = "";
            var phone = "";
            var department = "";
            
		    function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	           
	            if (_RowObjectID == null && Tab1_SelectID == "1tab2") {
	            	alert("<spring:message code='ezCircular.t53'/>");
	            } else if (_RowObjectID != null && Tab1_SelectID == "1tab2") {
	            	if (_RowObjectName.trim() == "deptList") {
		            	for (var i = 0; i < $("#List_TBODY2 tr").length; i++) {
		            		strId = $("#List_TBODY2 tr").eq(i).find("#data7").text();
		                    strName = $("#List_TBODY2 tr").eq(i).find("#data5").text();
	
		                    strDeptNM = "";
		                    strEmail = "";
		                    strName2 = "";
		                    strDeptNM2 = "";
		                    jickwe = "";
		                    phone = "";
		                    department = "";
		
		                    var listid = "MsgToList";
		                    var getlistview = new ListView();
		                    getlistview.LoadFromID(listid);
		                    var IsInsert = CheckMailReceiver(strId, "3");
		                    if (strId == "<c:out value='${userID}' />") {
		                        alert("<spring:message code='ezCircular.t149' />");
		                        continue;
		                    }
		
		                    if (!IsInsert) {
		                        pparsingXML2 = "";
		                        pparsingXML = "";
		                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		
		                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
		                        pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
		                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
		                        pparsingXML = pparsingXML + "<DATA4><![CDATA[" + department + "]]></DATA4>";
		                        pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
		                        pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
		                        pparsingXML = pparsingXML + "<DATA7><![CDATA[" + jickwe + "]]></DATA7>";
		                        pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
		                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
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
	            	} else {
	            		strId = $("[name='" + _RowObjectName + "'").find("#data7").text();
	                    strName = $("[name='" + _RowObjectName + "'").find("#data5").text();

	                    strDeptNM = "";
	                    strEmail = "";
	                    strName2 = "";
	                    strDeptNM2 = "";
	                    jickwe = "";
	                    phone = "";
	
	                    var listid = "MsgToList";
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID(listid);
	                    var IsInsert = CheckMailReceiver(strId, "3");
	                    
	                    if (strId == "<c:out value='${userID}' />") {
	                        alert("<spring:message code='ezCircular.t149' />");
	                        return;
	                    }
	
	                    if (!IsInsert) {
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4><![CDATA[" + department + "]]></DATA4>";
	                        pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
	                        pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
	                        pparsingXML = pparsingXML + "<DATA7><![CDATA[" + jickwe + "]]></DATA7>";
	                        pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
	                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
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
	            } else { //** 2018.05.11  회람자 정렬로 배열 되게 수정, 퇴직자 출력되지 않기 (문성업) - 시작 부분  
		           if (p_ListOrderObject == "" || p_ListOrderObject == null) { 
		                    /* alert("<spring:message code='ezCircular.t148' />");
		                    return; */
		        	   if (listContentArry != "") {
	 		                for (var i = 0; i < listContentArry.length; i++) {
	 		                	strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
	 		                    strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
	 		                    strDeptNM = document.getElementById(listContentArry[i]).getAttribute("_data5");
	 		                    strEmail = document.getElementById(listContentArry[i]).getAttribute("_data3");
	 		                    strName2 = document.getElementById(listContentArry[i]).getAttribute("_data11");
	 		                    strDeptNM2 = document.getElementById(listContentArry[i]).getAttribute("_data13");
	 		                    jickwe = document.getElementById(listContentArry[i]).getAttribute("_data14");
	 		                    phone = document.getElementById(listContentArry[i]).getAttribute("_data8");
	 		                    department = document.getElementById(listContentArry[i]).getAttribute("_data10");
	 		                    
	 		                    
	 		                    var listid = "MsgToList";
	 		                    var getlistview = new ListView();
	 		                    getlistview.LoadFromID(listid);
	 		                    var IsInsert = CheckMailReceiver(strId, "3");
	 		                    
	 		                    if (strId == "<c:out value='${userID}' />") {
	 		                        alert("<spring:message code='ezCircular.t149' />");
	 		                        continue;
	 		                    }
	 		
	 		                    
	 		                    if (!IsInsert) {
	 		                        pparsingXML2 = "";
	 		                        pparsingXML = "";
	 		                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	 		
	 		                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	 		                        pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
	 		                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
	 		                        pparsingXML = pparsingXML + "<DATA4><![CDATA[" + department + "]]></DATA4>";
	 		                        pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
	 		                        pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
	 		                        pparsingXML = pparsingXML + "<DATA7><![CDATA[" + jickwe + "]]></DATA7>";
	 		                        pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
	 		                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
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
						} else { // 2018.05.18 문성업 (수정) - 메시지 삭제
							return;
						}    
					} else { //끝 **
						if (listContentArry != "") {
							for (var i = 0; i < listContentArry.length; i++) {
								strId = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data2");
								strName = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data4");
								strDeptNM = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data5");
								strEmail = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data3");
								strName2 = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data11");
								strDeptNM2 = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data13");
								jickwe = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data14");
								phone = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data8");
								department = document.getElementById(
										listContentArry[i]).getAttribute(
										"_data10");

								var listid = "MsgToList";
								var getlistview = new ListView();
								getlistview.LoadFromID(listid);
								var IsInsert = CheckMailReceiver(strId, "3");

								if (strId == "<c:out value='${userID}' />") {
									alert("<spring:message code='ezCircular.t149' />");
									continue;
								}

								if (!IsInsert) {
									pparsingXML2 = "";
									pparsingXML = "";
									pparsingXML2 = "<LISTVIEWDATA2><ROWS>";

									pparsingXML = pparsingXML
											+ "<ROW><CELL><DATA1>" + strId
											+ "</DATA1>";
									pparsingXML = pparsingXML
											+ "<DATA2><![CDATA[" + strName
											+ "]]></DATA2>";
									pparsingXML = pparsingXML
											+ "<DATA3><![CDATA[" + strName2
											+ "]]></DATA3>";
									pparsingXML = pparsingXML
											+ "<DATA4><![CDATA[" + department
											+ "]]></DATA4>";
									pparsingXML = pparsingXML
											+ "<DATA5><![CDATA[" + strDeptNM2
											+ "]]></DATA5>";
									pparsingXML = pparsingXML
											+ "<DATA6><![CDATA[" + strName
											+ "]]></DATA6>";
									pparsingXML = pparsingXML
											+ "<DATA7><![CDATA[" + jickwe
											+ "]]></DATA7>";
									pparsingXML = pparsingXML + "<DATA8>"
											+ phone + "</DATA8>";
									pparsingXML = pparsingXML
											+ "<VALUE><![CDATA[" + strName
											+ "]]></VALUE></CELL></ROW>";
									pparsingXML2 = pparsingXML2 + pparsingXML
											+ "</ROWS></LISTVIEWDATA2>";
									Resultxml = loadXMLString(pparsingXML2);

									var listview = new ListView();
									listview.LoadFromID(listid);

									var MaxID = 0;
									var InitTr = listview.GetDataRows();
									var MaxCntNum = 0;
									for (var j = 0; j < InitTr.length; j++) {
										var curnum = Number(
												listview
														.GetSelectedRowID(j)
														.substring(
																listview
																		.GetSelectedRowID(
																				j)
																		.lastIndexOf(
																				'_') + 1),
												listview.GetSelectedRowID(j).length);
										if (MaxID < curnum) {
											MaxID = curnum;
											MaxCntNum = j;
										}
									}

									var objTr = listview.AddRow(InitTr.length);
									if (MaxCntNum != 0)
										MaxCntNum = MaxCntNum + 1;
									SetAttribute(
											objTr,
											"id",
											listview
													.GetSelectedRowID(MaxCntNum)
													.substring(
															0,
															listview
																	.GetSelectedRowID(
																			MaxCntNum)
																	.lastIndexOf(
																			'_') + 1)
													+ eval(MaxID + 1));
									listview.AddDataRow(objTr, Resultxml);

									var _tdlength = document.getElementById(
											listid).getElementsByTagName("TD").length;
									for (var y = 0; y < _tdlength; y++) {
										document.getElementById(listid)
												.getElementsByTagName("TD")[y].style.textOverflow = "";
										document.getElementById(listid)
												.getElementsByTagName("TD")[y].style.overflow = "";
									}

								}
							}
						} else {
							strId = p_ListOrderObject.getAttribute("_data2");
							strName = p_ListOrderObject.getAttribute("_data4");
							strDeptNM = p_ListOrderObject
									.getAttribute("_data5");
							strEmail = p_ListOrderObject.getAttribute("_data3");
							strName2 = p_ListOrderObject
									.getAttribute("_data11");
							strDeptNM2 = p_ListOrderObject
									.getAttribute("_data13");
							jickwe = p_ListOrderObject.getAttribute("_data14");
							phone = p_ListOrderObject.getAttribute("_data8");
							department = p_ListOrderObject.getAttribute("_data10");

							var listid = "MsgToList";

							var getlistview = new ListView();
							getlistview.LoadFromID(listid);
							var bFlag = getlistview.ExistRow("DATA2", strName); //2018.05.16 (문성업) 수정  - 시작 
							
							if (strId == "<c:out value='${userID}' />") {
								alert("<spring:message code='ezCircular.t149' />");
								return;
							} // 회람자 한 명 누른 상태에서 shift+마우스 왼클릭 하고 화살표를 누르면 회람자가 연속으로 출력되지 않거나 작성자도 출력되지 않게 수정 - 끝

							if (bFlag) {
								pAddFlag = true;
							} else {
								/* pparsingXML2 = ""; 2018.05.18 (문성업) -사용하지 않음 
								pparsingXML = "";
								pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
								pparsingXML = pparsingXML
										+ "<ROW><CELL><DATA1>" + strId
										+ "</DATA1>";
								pparsingXML = pparsingXML + "<DATA2><![CDATA["
										+ strName + "]]></DATA2>";
								pparsingXML = pparsingXML + "<DATA3><![CDATA["
										+ strName2 + "]]></DATA3>";
								pparsingXML = pparsingXML + "<DATA4><![CDATA["
										+ strDeptNM + "]]></DATA4>";
								pparsingXML = pparsingXML + "<DATA5><![CDATA["
										+ strDeptNM2 + "]]></DATA5>";
								pparsingXML = pparsingXML + "<DATA6><![CDATA["
										+ strName + "]]></DATA6>";
								pparsingXML = pparsingXML + "<DATA7><![CDATA["
										+ jickwe + "]]></DATA7>";
								pparsingXML = pparsingXML + "<DATA8>" + phone
										+ "</DATA8>";
								pparsingXML = pparsingXML + "<VALUE><![CDATA["
										+ strName + "]]></VALUE></CELL></ROW>";
								pparsingXML2 = pparsingXML2 + pparsingXML
										+ "</ROWS></LISTVIEWDATA2>";
								Resultxml = loadXMLString(pparsingXML2);

								var listview = new ListView();
								listview.LoadFromID(listid);
								
								var MaxID = 0;
								var InitTr = listview.GetDataRows();
								var MaxCntNum = 0;
								for (var j = 0; j < InitTr.length; j++) {
									var curnum = Number(
											listview
													.GetSelectedRowID(j)
													.substring(
															listview
																	.GetSelectedRowID(
																			j)
																	.lastIndexOf(
																			'_') + 1),
											listview.GetSelectedRowID(j).length);
									if (MaxID < curnum) {
										MaxID = curnum;
										MaxCntNum = j;
									}
								}

								var objTr = listview.AddRow(InitTr.length);
								if (MaxCntNum != 0)
									MaxCntNum = MaxCntNum + 1;
								SetAttribute(objTr, "id", listview
										.GetSelectedRowID(MaxCntNum).substring(
												0,
												listview.GetSelectedRowID(
														MaxCntNum).lastIndexOf(
														'_') + 1)
										+ eval(MaxID + 1));
								listview.AddDataRow(objTr, Resultxml);

								var _tdlength = document.getElementById(listid)
										.getElementsByTagName("TD").length;
								for (var y = 0; y < _tdlength; y++) {
									document.getElementById(listid)
											.getElementsByTagName("TD")[y].style.textOverflow = "";
									document.getElementById(listid)
											.getElementsByTagName("TD")[y].style.overflow = "";
								} */
							}
						}
					}
				}

				var listid = "MsgToList";
				//2018-07-06 즐겨찾기 추가 로직 개선 배현상
				//_RowObjectID = null;
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
					if (email.trim() == $("tr[id*='MsgToList_TR']").eq(count2)
							.attr("data1").trim()) {
						rtnValue = true;
						break;
					}
				}

				return rtnValue
			}

			var pSeach = false;
			function DisplayUserImageList() {
				var xmlRtn = pListXML_Info;
				document.getElementById("DeptUserImgList").innerHTML = "";
				document.getElementById("txtlist_Layer").scrollTop = "0";
				document.getElementById("txtlist_table").getElementsByTagName(
						"TBODY").item(0).childNodes;
				totalPage = Math.ceil(new Number(getNodeText(SelectNodes(
						xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));

				while (document.getElementById("txtlist_table")
						.getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
					document.getElementById("txtlist_table")
							.getElementsByTagName("TBODY").item(0).removeChild(
									document.getElementById("txtlist_table")
											.getElementsByTagName("TBODY")
											.item(0).childNodes.item(1));
				}

				while (document.getElementById("Search_txtlist_table")
						.getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
					document.getElementById("Search_txtlist_table")
							.getElementsByTagName("TBODY").item(0).removeChild(
									document.getElementById(
											"Search_txtlist_table")
											.getElementsByTagName("TBODY")
											.item(0).childNodes.item(1));
				}

				var UserListHTML = "";
				/* if (SelectDeptNM.getAttribute("countinfo") != "1" && SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length != null && SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length != "") {
					if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang256 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang256 + "</span>]";
	        		}
					
					SelectDeptNM.setAttribute("countinfo", "1")
				} */

				if (pListType == "IMG") {
					document.getElementById("DeptUserImgList").style.display = "";
					document.getElementById("txtlist_Layer").style.display = "none";
					document.getElementById("txtlist_table").style.display = "none";
					document.getElementById("Search_txtlist_table").style.display = "none";

					if (pSeach) {
						document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >"
								+ strLang257
								+ ""
								+ "-[<span class='txt_color'>"
								//2018-07-10 김보미 - 전체 결과 갯수로 변경
	 							//+ SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length
								+ getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])
								+ strLang256 + "</span>]";
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
						document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >"
							+ "<span id='spn_deptName'>" + strLang257
								+ "</span>"
								+ "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>"
								//2018-07-10 김보미 - 전체 결과 갯수로 변경
	 							//+ SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length
								+ getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])
								+ "</span></span>";					// 2018-12-12 김민성 - 조직도 검색 결과 UI 통일
						SelectDeptNM.setAttribute("countinfo", "1")
					}
				}

				for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
					if (pListType == "IMG") {
						var MainTable = document.createElement("TABLE");
						MainTable.setAttribute("class",
								pListType == "IMG" ? "organwrap"
										: "organwrap_list");
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
						M_TR.onmouseover = function() {
							event_listMover(this);
						};
						M_TR.onmouseout = function() {
							event_listMout(this);
						};
						M_TR.onclick = function() {
							event_listclick(this);
						};
						M_TR.ondblclick = function() {
							event_listDBclick(this);
						};
						M_TR.setAttribute("draggable", true);
						M_TR.onselectstart = function() {
							return false;
						};

						if (CrossYN()) {
							for (var NodeCount = 0; NodeCount < SelectNodes(
									xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes
									.item(0).childNodes.length; NodeCount++) {
								if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW")
										.item(i).childNodes.item(0).childNodes
										.item(NodeCount).nodeName != "#text") {
									M_TR
											.setAttribute(
													"_"
															+ SelectNodes(
																	xmlRtn,
																	"LISTVIEWDATA/ROWS/ROW")
																	.item(i).childNodes
																	.item(0).childNodes
																	.item(NodeCount).nodeName,
													trim_Cross(SelectNodes(
															xmlRtn,
															"LISTVIEWDATA/ROWS/ROW")
															.item(i).childNodes
															.item(0).childNodes
															.item(NodeCount).textContent));
								}
							}
						} else {
							for (var NodeCount = 0; NodeCount < SelectNodes(
									xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes
									.item(0).childNodes.length; NodeCount++) {
								M_TR
										.setAttribute(
												"_"
														+ SelectNodes(xmlRtn,
																"LISTVIEWDATA/ROWS/ROW")
																.item(i).childNodes
																.item(0).childNodes
																.item(NodeCount).nodeName,
												SelectNodes(xmlRtn,
														"LISTVIEWDATA/ROWS/ROW")
														.item(i).childNodes
														.item(0).childNodes
														.item(NodeCount).text);
							}
						}

						var M_TR_TD = document.createElement("TD");
						M_TR_TD.setAttribute("class", "pictd");
						var M_TR_DIV = document.createElement("DIV");
						M_TR_DIV.setAttribute("class", "pic");

						if (M_TR.getAttribute("_DATA9") != "") {
							var M_TR_IMG = document.createElement("IMG");
							M_TR_IMG.setAttribute("SRC",
									"/admin/ezOrgan/getPersonalInfo.do?fileName="
											+ M_TR.getAttribute("_DATA9"));
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

						var Sub_TR1 = document.createElement("TR");
						var Sub_TD1 = document.createElement("TD");
						Sub_TD1.style.textAlign = "left";
						Sub_TD1.setAttribute("class", "name");
						var pDisplayName = "";
						if ("<c:out value='${use_ocs}'/>" == "YES") {
							pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '"
									+ GetGUID()
									+ ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\""
									+ M_TR.getAttribute("_DATA3")
									+ "\",this);'/></span>";
						}
						pDisplayName += M_TR.getAttribute("_DATA4") == "" ? ""
								: M_TR.getAttribute("_DATA4");
						pDisplayName += M_TR.getAttribute("_DATA6") == "" ? ""
								: "[" + M_TR.getAttribute("_DATA6") + "]";
						Sub_TD1.innerHTML = pDisplayName;
						Sub_TR1.appendChild(Sub_TD1);

						var Sub_TR2 = document.createElement("TR");
						var Sub_TD2 = document.createElement("TD");
						Sub_TD2.style.textAlign = "left";
						Sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
						Sub_TR2.appendChild(Sub_TD2);

						var Sub_TR3 = document.createElement("TR");
						var Sub_TD3 = document.createElement("TD");
						Sub_TD3.style.textAlign = "left";
						var Sub_TD3_Img = document.createElement("IMG");
						Sub_TD3_Img.setAttribute("class", "icon");
						Sub_TD3_Img.setAttribute("src",
								"/images/OrganTree/icon_hp.gif");
						Sub_TD3.appendChild(Sub_TD3_Img);
						Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - "
								: M_TR.getAttribute("_DATA8");
						Sub_TR3.appendChild(Sub_TD3);

						var Sub_TR4 = document.createElement("TR");
						var Sub_TD4 = document.createElement("TD");
						Sub_TD4.style.textAlign = "left";
						var Sub_TD4_Img = document.createElement("IMG");
						Sub_TD4_Img.setAttribute("class", "icon");
						Sub_TD4_Img.setAttribute("src",
								"/images/OrganTree/icon_mail.gif");
						Sub_TD4.appendChild(Sub_TD4_Img);
						Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
						Sub_TR4.appendChild(Sub_TD4);

						M_TR_TDS_Table.appendChild(Sub_TR1);
						M_TR_TDS_Table.appendChild(Sub_TR2);
						M_TR_TDS_Table.appendChild(Sub_TR3);
						M_TR_TDS_Table.appendChild(Sub_TR4);

						M_TR.appendChild(M_TR_TD2);
						MainTable.appendChild(M_TR);

						document.getElementById("DeptUserImgList").appendChild(
								MainTable);
					} else {
						var M_TR = document.createElement("TR");
						M_TR.setAttribute("id", "MailUserlist_" + i);
						M_TR.style.cursor = "pointer";
						M_TR.onmouseover = function() {
							event_listMover(this);
						};
						M_TR.onmouseout = function() {
							event_listMout(this);
						};
						M_TR.onclick = function() {
							event_listclick(this);
						};
						M_TR.ondblclick = function() {
							event_listDBclick(this);
						};
						M_TR.setAttribute("draggable", true);
						M_TR.onselectstart = function() {
							return false;
						};

						if (CrossYN()) {
							for (var NodeCount = 0; NodeCount < SelectNodes(
									xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes
									.item(0).childNodes.length; NodeCount++) {
								if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW")
										.item(i).childNodes.item(0).childNodes
										.item(NodeCount).nodeName != "#text") {
									M_TR
											.setAttribute(
													"_"
															+ SelectNodes(
																	xmlRtn,
																	"LISTVIEWDATA/ROWS/ROW")
																	.item(i).childNodes
																	.item(0).childNodes
																	.item(NodeCount).nodeName,
													trim_Cross(SelectNodes(
															xmlRtn,
															"LISTVIEWDATA/ROWS/ROW")
															.item(i).childNodes
															.item(0).childNodes
															.item(NodeCount).textContent));
								}
							}
						} else {
							for (var NodeCount = 0; NodeCount < SelectNodes(
									xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes
									.item(0).childNodes.length; NodeCount++) {
								M_TR
										.setAttribute(
												"_"
														+ SelectNodes(xmlRtn,
																"LISTVIEWDATA/ROWS/ROW")
																.item(i).childNodes
																.item(0).childNodes
																.item(NodeCount).nodeName,
												SelectNodes(xmlRtn,
														"LISTVIEWDATA/ROWS/ROW")
														.item(i).childNodes
														.item(0).childNodes
														.item(NodeCount).text);
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
								M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '"
										+ GetGUID()
										+ ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\""
										+ M_TR.getAttribute("_DATA3")
										+ "\",this);'/></span>"
										+ M_TR.getAttribute("_DATA4");
							} else {
								M_TR_TD2.innerHTML = M_TR
										.getAttribute("_DATA4");
							}
							var M_TR_TD3 = document.createElement("TD");
							M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? ""
									: M_TR.getAttribute("_DATA6");
							M_TR_TD3.style.width = "80px";

							var M_TR_TD4 = document.createElement("TD");
							M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? ""
									: M_TR.getAttribute("_DATA8");

							M_TR.appendChild(M_TR_TD1);
							M_TR.appendChild(M_TR_TD2);
							M_TR.appendChild(M_TR_TD3);
							M_TR.appendChild(M_TR_TD4);
							document.getElementById("Search_txtlist_table")
									.getElementsByTagName("TBODY").item(0)
									.appendChild(M_TR);
						} else {
							var M_TR_TD1 = document.createElement("TD");
							M_TR_TD1.style.overflow = "hidden";
							M_TR_TD1.style.textOverflow = "ellipsis";
							M_TR_TD1.style.whiteSpace = "nowrap";
							M_TR_TD1.style.width = "150px";

							if ("<c:out value='${use_ocs}'/>" == "YES") {
								M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '"
										+ GetGUID()
										+ ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\""
										+ M_TR.getAttribute("_DATA3")
										+ "\",this);'/></span>"
										+ M_TR.getAttribute("_DATA4");
							} else {
								M_TR_TD1.innerHTML = M_TR
										.getAttribute("_DATA4");
							}
							var M_TR_TD2 = document.createElement("TD");
							M_TR_TD2.style.width = "80px";
							M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? ""
									: M_TR.getAttribute("_DATA6");

							var M_TR_TD3 = document.createElement("TD");
							M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? ""
									: M_TR.getAttribute("_DATA8");

							M_TR.appendChild(M_TR_TD1);
							M_TR.appendChild(M_TR_TD2);
							M_TR.appendChild(M_TR_TD3);
							document.getElementById("txtlist_table")
									.getElementsByTagName("TBODY").item(0)
									.appendChild(M_TR);
						}
					}
				}
			}
			function search_press(e) {
				if (window.event) {
					if (window.event.keyCode == 13) {
						search_click("search");
					}
				} else {
					if (e.which == 13)
						search_click("search");
				}

			}
			var issearch = false;
			function search_click(type) {
				listContentArry = new Array();

				if ($.trim($("#keyword").val()) == "") {
					alert("<spring:message code='ezCircular.t189' />");
					document.all("keyword").focus();
					return;
				}

				if (specialChk(keyword.value)) {
					alert("<spring:message code='ezCircular.t134' />");
					return;
				}

				if (keyword.value == "") {
					alert("<spring:message code='ezCircular.t135' />");
					keyword.focus();
					return;
				}
				if (type == "search") {
					CurPage = "1";
					issearch = true;
				}

				$
						.ajax({
							url : '/ezOrgan/getSearchList.do',
							method : 'POST',
							dataType : "text",
							data : {
								search : document.getElementById("search_type").value
										+ "::" + keyword.value,
								cell : "company;description;displayName;title;telephoneNumber;"
										+ document
												.getElementById("search_type").value,
								prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
								page : CurPage,
								type : "user"
							},
							success : function(xml) {
								event_displayUserList2(loadXMLString(xml));
							},
							error : function(jqXHR, textStatus, errorThrown) {
								alert("<spring:message code='ezCircular.t151'/>"
										+ textStatus);
							}
						});

				var usedefault;
				if (browserIE) {
					usedefault = document.getElementById("search_type").options[document
							.getElementById("search_type").selectedIndex].usedefault;
				} else {
					usedefault = GetAttribute(document
							.getElementById("search_type").options[document
							.getElementById("search_type").selectedIndex],
							"usedefault");
				}
		     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
	            PressShiftKey = false;
			}
			function event_displayUserList2(xml) {
				if (xml != null) {
					if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length == 0) {
						alert("<spring:message code='ezCircular.t152'/>");
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
					document.getElementById("imglist").setAttribute("src",
							"/images/kr/cm/btn_onimglist.gif");
					document.getElementById("txtlist").setAttribute("src",
							"/images/kr/cm/btn_list.gif");
				} else {
					document.getElementById("imglist").setAttribute("src",
							"/images/kr/cm/btn_imglist.gif");
					document.getElementById("txtlist").setAttribute("src",
							"/images/kr/cm/btn_onlist.gif");
				}
			}
			function ChangeListView_onClick(Div) {
				pListType = Div;
				ListTypeChangeIcon();
				DisplayUserImageList();
				setOrganListType(pListType);
			}
			function keyword_Clear() {
				document.getElementById("keyword").value = "";
			}
			var rtn;
			function btnok_onclick() {
				rtn = {
					"id" : new Array(),
					"name" : new Array(),
					"deptname" : new Array(),
					"name1" : new Array(),
					"name2" : new Array(),
					"deptname2" : new Array(),
					"jikwe" : new Array(),
					"phone" : new Array()
				};

				var listid = "MsgToList";
				var selList = new ListView();
				selList.LoadFromID(listid);

				var totalRows = selList.GetDataRows();
				var totalLen = totalRows.length;

				for (var i = 0; i < totalLen; i++) {
					rtn["id"][i] = GetAttribute(totalRows[i], "DATA1");
					rtn["name"][i] = GetAttribute(totalRows[i], "DATA2");
					rtn["name1"][i] = GetAttribute(totalRows[i], "DATA2");
					rtn["name2"][i] = GetAttribute(totalRows[i], "DATA3");
					rtn["deptname"][i] = GetAttribute(totalRows[i], "DATA4");
					//rtn["deptname2"][i] = GetAttribute(totalRows[i], "DATA5");
					//rtn["jikwe"][i] = GetAttribute(totalRows[i], "DATA7");
					//rtn["phone"][i] = GetAttribute(totalRows[i], "DATA8");
				}

				if (!CrossYN()) {
					window.returnValue = rtn;
				}

				if (ReturnFunction != null)
					ReturnFunction(rtn);
				else
					window.returnValue = rtn;

				window.close();
			}

			/* window.onunload = function () {
			    if (ReturnFunction != null)
			        ReturnFunction(rtn);
			    else
			        window.returnValue = rtn;
			} */

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
					strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg first disabled'></span>"
					PagingHTML += strtext;
				}
				if (totalPage > BlockSize) {
					if (pageNum > BlockSize) {
						strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg prev disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg prev disabled'></span>";
					PagingHTML += strtext;
				}
				var MaxNum;
				var i;
				var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
				if (totalPage >= (startNum + parseInt(BlockSize))) {
					MaxNum = (startNum + parseInt(BlockSize)) - 1;
				} else {
					MaxNum = totalPage;
				}
				for (i = startNum; i <= MaxNum; i++) {
					if (i == pageNum) {
						strtext = "<span class='on'>" + i + "</span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span onclick='goToPageByNum(" + i + ")'>"
								+ i + "</span>";
						PagingHTML += strtext;
					}
				}
				if (totalPage > BlockSize) {
					if (totalPage >= parseInt(((parseInt((pageNum - 1)
							/ BlockSize) + 1) * BlockSize) + 1)) {
						strtext = "";
						strtext = strtext
								+ "<span class='btnimg next' onclick='return selafterBlock()'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext
								+ "<span class='btnimg next disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext
							+ "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
				}
				if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
					strtext = "<span class='btnimg last' onclick='return goToPageByNum("
							+ totalPage
							+ ")'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg last disabled'></span>";
					PagingHTML += strtext;
				}
				PagingHTML += "</div>";
				td_Create1(PagingHTML);
			}
			function goToPageByNum(Value) {
				p_ListOrderObject = "";
				listContentArry = new Array();

				CurPage = Value;
				makePageSelPage();
				movePage(CurPage);
			}
			function selbeforeBlock() {
				var pageNum = parseInt(CurPage);
				if (pageNum % BlockSize == 0) {
					pageNum = pageNum - 1;
				}
				pageNum = ((parseInt(pageNum / BlockSize)) * BlockSize);
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
				if (parseInt(newPage) > 0
						&& parseInt(newPage) <= parseInt(totalPage)) {
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

			function getCircularDept() {
				$
						.ajax({
							url : '/ezCircular/getcircularDeptList.do',
							type : 'POST',
							dataType : "json",
							data : {},
							success : function(result) {
								circularDeptList = "";
								list = result.circularDeptList;

								list
										.forEach(function(vo, index) {
											circularDeptList += ("<tr id='"
													+ vo.circularBMID + "' name='deptList' style='cursor:pointer' onmouseover='event_Mover(this)' onmouseout='event_Mout(this)' onclick='event_click(this)' ondblclick='event_listDBclick(this)'>");
											circularDeptList += ("<td style='width:5%'>"
													+ (index + 1) + "</td>");
											circularDeptList += ("<td style='width:45%'>"
													+ vo.title + "</td>");
											circularDeptList += ("<td style='width:20%'>"
													+ vo.regDate.substring(0,
															16) + "</td>");

											if (vo.memberNameCount == 0) {
												circularDeptList += ("<td style='width:30%'>"
														+ vo.memberName + "</td>");
											} else {
												circularDeptList += ("<td style='width:30%'>"
														+ vo.memberName
														+ " <spring:message code='ezCircular.t50' /> "
														+ vo.memberNameCount
														+ " <spring:message code='ezCircular.t51' />" + "</td>");
											}

											//circularDeptList += ("<td style='width:13%'>");
											circularDeptList += ("</tr>");
										});

								$("#List_TBODY").html("");
								$("#List_TBODY").append(circularDeptList);
							}
						});
			}

			function event_Mover(obj) {
				if (obj != _RowObject) {
					obj.style.backgroundColor = "#EDEDED";
				}
			}

			function event_Mout(obj) {
				if (obj != _RowObject) {
					obj.style.backgroundColor = "#FFFFFF";
				}
			}

			var _RowObject = null;
			var _RowObjectID = null;
			var _RowObjectName = null;
			var _RowObjectArray = new Array();

			function event_click(obj) {
				if (_RowObject != null) {
					_RowObject.style.backgroundColor = "#ffffff";
				}

				_RowObject = obj;
				_RowObjectID = obj.id;
				_RowObjectName = $(obj).attr("name");

				obj.style.backgroundColor = "#f1f8ff";

				$
						.ajax({
							url : '/ezCircular/getcircularDeptName.do',
							type : 'POST',
							dataType : "json",
							data : {
								circularBMID : obj.id
							},
							success : function(result) {
								circularDeptNamelist = "";
								list = result.circularDeptNamelist;

								list
										.forEach(function(vo, index) {
											circularDeptNamelist += ("<tr id='nameList"
													+ index
													+ "' name='nameList"
													+ index + "' style='cursor:pointer' onmouseover='event_Mover(this)' onmouseout='event_Mout(this)' onclick='event_click2(this)' ondblclick='event_listDBclick(this)'>");
											circularDeptNamelist += ("<td id='data1' style='width:55%'>"
													+ (index + 1) + "</td>");
											circularDeptNamelist += ("<td id='data2' style='width:15%'>"
													+ vo.company + "</td>");
											circularDeptNamelist += ("<td id='data3' style='width:17%'>"
													+ vo.description + "</td>");
											circularDeptNamelist += ("<td id='data4' style='width:12%'>"
													+ vo.title + "</td>");
											circularDeptNamelist += ("<td id='data5' style='width:13%'>"
													+ vo.memberName + "</td>");
											circularDeptNamelist += ("<td id='data6' style='width:38%'>"
													+ vo.mail + "</td>");
											circularDeptNamelist += ("<td id='data7' style='display:none'>"
													+ vo.memberID + "</td>");
											circularDeptNamelist += ("</tr>");
										});

								$("#List_TBODY2").html("");
								$("#List_TBODY2").append(circularDeptNamelist);
							}
						})
			}

			function event_click2(obj) {
				if (_RowObject != null) {
					_RowObject.style.backgroundColor = "#ffffff";
				}

				_RowObject = obj;
				_RowObjectID = obj.id;
				_RowObjectName = $(obj).attr("name");
				obj.style.backgroundColor = "#f1f8ff";
			}

			var Tab1_SelectID = "1tab1";
			function ChangeTab(obj) {
				var pSelectTab = GetAttribute(obj, "tdname");

				switch (pSelectTab) {
				case "circularOrgan":
					if (document.getElementById("circularOrgan_content").style.display == "none") {
						document.getElementById("circularOrgan_content").style.display = "";
						document.getElementById("circularDept_content").style.display = "none";
// 						$("#List_TBODY tr").css("backgroundColor", "#ffffff"); // 탭 바꾸면 즐겨찾기에 선택되어있던 것 해제, 즐겨찾기
// 						$("#List_TBODY2 tr").css("backgroundColor", "#ffffff"); // 탭 바꾸면 즐겨찾기에 선택되어있던 것 해제, 즐겨찾기 구성원
//						_RowObjectID = null; // 탭 바꾸면 기존에 가지고 있던 값 초기화
					}
					break;
				case "circularDept":
					if (document.getElementById("circularDept_content").style.display == "none") {
						document.getElementById("circularOrgan_content").style.display = "none";
						document.getElementById("circularDept_content").style.display = "";
					}
					break;
				}
			}

			function Tab1_MouseClick(obj) {
				obj.className = "tabon";
				if (obj.id != Tab1_SelectID) {
					if (Tab1_SelectID != ""
							&& document.getElementById(Tab1_SelectID) != null)
						document.getElementById(Tab1_SelectID).className = "";

					obj.className = "tabon";
					Tab1_SelectID = obj.id;
					ChangeTab(obj);
				}
			}
			
	        function setOrganListType(pListType) {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/setListType.do",
	        		async : false,
	        		data : {
	        			listType : pListType
	        		},
	        		success : function(result) {
	        			
	        		}
	        		
	        	})
	        }
	        
	        function getOrganListType() {
	        	var organListType = "TXT";
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/getListType.do",
	        		async : false,
	        		success : function(result) {
	        			organListType = result;
	        		}
	        	})
	        	return organListType;
	        }
	        
		    //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
	        function deptNameLong(containLow, strIsLeaf) {
	        	var deptNameWidth = "";
	        	var sum = $("#spn_deptName").width() + $("#countInfo").width();
	        	
	          	if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
	          		if (sum > 359) {
	          			deptNameWidth = 340 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 357) {
	          			deptNameWidth = 338 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
		    
	        /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != Tab1_SelectID) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1 id="h1Title" style="height: 20px;"><spring:message code='ezAttitude.t285' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table style="width:100%">
			<tr>
				<td>
	        		<table id="TreeViewTD">
	                	<tr>
	                		<div class="portlet_tabpart01" style="margin-top: 25px; margin-bottom: 2px;">
	        					<div class="portlet_tabpart01_top" id="tab1" style="width:664px;">
					            	<p><span id="1tab1" tdname="circularOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezCircular.t41' /></span></p>
						        </div>
						    </div>
	                    	<td id="circularOrgan_content" style="display:none;">
	                            <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 1px; padding:0px; border-top: 0px;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea; height:30px;">
	                                    <table style="margin-top: 5px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type" style="height:21px">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezCircular.t80' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezCircular.t78' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezCircular.t154' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezCircular.t155' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezCircular.t156' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezCircular.t157' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezCircular.t158' /></option>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezCircular.t159' /></option>
	                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezCircular.t160' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;height:21px">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezCircular.t85' /></span></a>
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px;">
	                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezCircular.t161' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px">
	                                        <div style="width: 220px; height: 500px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="width: 426px" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                            <tr>
	                                                <th style="white-space:normal;background-color: white;border-top:0px solid #ddd;border-bottom:1px solid #eaeaea">
														<span id="SelectDeptNM" style="font-weight: normal; width: 380px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: middle; margin-top:-6px"></span>
	                                                    <span style="float:right;">
	                                                        <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 418px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 150px;color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezCircular.t80' /></td>
	                                                    <td style="width: 130px;color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezCircular.t154' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezCircular.t155' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 130px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezCircular.t78' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezCircular.t80' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezCircular.t154' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezCircular.t155' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 418px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer" style="text-align:center; height:32px;margin-bottom:10px"></div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td id="circularDept_content" style="display:none; width:664px;">
	                        	<table style="width:100%">
	                                <tr>
	                                    <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                        <h2 class="h2_dot" style="padding-top: 2px;"><spring:message code='ezCircular.t87'/></h2>
	                                        <div class="border_gray">
	                                            <div id="circularDept" style="Width: 100%; Height: 182px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table class="mainlist" style="width: 100%;">
								                        <thead id="List_THEAD">
									                        <tr>
									                        <!-- 18-05-24 김민성 - 회람자 추가시 즐겨찾기 작성일 -> 등록일로 수정 -->
									                        <!-- 18-12-03 김민성 - 컬럼 사이즈 변경 -->
									                        	<th style="width: 5%;"><span><spring:message code='ezCircular.t31' /></span></th>
									                            <th style="width: 45%; "><span><spring:message code='ezCircular.t32' /></span></th>
									                            <th style="width: 20%; "><span><spring:message code='ezBoard.t5007' /></span></th>
									                            <th style="width: 30%; "><span><spring:message code='ezCircular.t34' /></span></th>
									                            <!-- <th style="width: 13%; "></th> -->
									                        </tr>
								                        </thead>
								                        <tbody id="List_TBODY">					                        
								                        </tbody>
								                    </table>
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="vertical-align: top;">
	                                        <div class="border_gray">
	                                            <div id="circularTemp" style="Width: 100%; Height: 321px; OVERFLOW: AUTO; padding-top: 0px;">
	                                            	<table id="List" class="mainlist" style="width:100%">
														<thead id="List_THEAD2">
															<tr>
																<th id="TH_0" style="width:5%"><spring:message code='ezCircular.t31' /></th>
																<th id="TH_1" style="width:15%"><spring:message code='ezCircular.t76' /></th>
																<th id="TH_2" style="width:17%"><spring:message code='ezCircular.t78' /></th>
																<th id="TH_3" style="width:12%"><spring:message code='ezCircular.t79' /></th>
																<th id="TH_4" style="width:13%"><spring:message code='ezCircular.t80' /></th>
																<th id="TH_5" style="width:38%"><spring:message code='ezCircular.t81' /></th>
															</tr>
														</thead>
														<tbody id="List_TBODY2">
														</tbody>
													</table>
	                                            </div>
                                            </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="ToTitle" class="receiver_tltype01" style="margin-top:4px;position: absolute;top: 56px;width: 237px;">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezAttitude.t282' /></span>
	                            </h2>
	                            <div class="receiver_borderbox" style="border-top: 1px solid #ddd;">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 539px; overflow-x: auto; overflow-y: auto;"  ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
	    	</tr> 
	 	</table>	    
		<div class="btnposition btnpositionNew">
	    	<a class="imgbtn" onClick="btnok_onclick()" ><span><spring:message code='ezCircular.t65' /></span></a>
		</div>
	</body>
</HTML>
