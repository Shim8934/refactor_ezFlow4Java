<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezAttitude.t109'/></title>
	    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <style>
	    	.mainlist tr td:first-child {
	    		padding-left:15px;	    		
	    	}
	    	.mainlist_free tbody tr td:first-child{
	    		padding-left:15px;
	    	}
	    	.mainlist_free thead tr th:first-child{
	    		padding-left:15px;
	    	}
	    	#left h2 {
	    		background: url('/images/OrganTree_cross/ic-open.gif') no-repeat 6px 7px;
	    	}
	    	
	    	#left h2, #TopBoards h2.off {
  	    		border-top:1px solid transparent; 
  				border-bottom: 1px solid transparent;  
			}

	    	#left h2.on, #TopBoards h2.on {
	    	    font-weight: bold;
			    background: url('/images/OrganTree_cross/ic-open.gif') no-repeat 6px 7px !important;
			    background-color: #F8F9FB !important;
			    color: #333333 !important;
    			border-top: 1px solid #d1ddec !important;
    			border-bottom: 1px solid #d1ddec !important; 
	    	}
	    	
	    	span.node_normal {
	    		padding-top: 7px!important;
	    		padding-left: 30px!important;
	    		color: #333333!important;
	    		font-weight: normal;
	    		overflow: hidden!important; 
	    		white-space: nowrap!important; 
	    		text-overflow: ellipsis!important;
	    		max-width: 200px!important;
	    	}
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">
	        var m_orgImg = { "normal": "/images/tab_org1.gif", "select": "/images/tab_org.gif" };
	        var m_dlImg = { "normal": "/imagefs/tab_dl1.gif", "select": "/images/tab_dl.gif" };
	        var m_contactImg = { "normal": "/images/tab_addr1.gif", "select": "/images/tab_addr.gif" };
	        var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal" };
	        var m_receiverTitleList;
	        var m_receiverWindowList;
	        var m_titleNoneSelectedColor = "white";
	        var m_titleSelectedColor = "#f4faff";
	        var m_selectedWindow = null;
	        var m_selectedTree = null;
	        var g_fnaddReceiver;
	        var g_xmlHTTP = null;
	        var bSearch = false;
	        var addrsearh = false;
	        var page = 1;
	        var CurPage = "1";
	        var pagecount;
	        var agoNodeIdx = "";
	        var agoNodeBool = false;
	        var searchgubun = "N";
	        var userid = "${userInfo.id}";
	        var deptid = "${userInfo.deptID}";
	        var companyid = "<c:out value='${companyID}'/>";
	        var susinTo = 0;
	        var AddressTreeView = null;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (!CrossYN()) ? true : false;
	        var type = "<c:out value='${type}'/>";
	        var rulekind = "${ruleKind}";
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var strLang_2 = "<spring:message code='ezEmail.t655' />";
	        var strSearch = "";
	        var ua = navigator.userAgent;
	        var tabSel = "";
// 	        var deptList = '${deptList}';
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	        document.onkeydown = function (evt) {
	            if (!MACSAFARIYN()) {
	                var e = evt;
	                if (e == null) e = window.event;
	                if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1){
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
	        }
	        var RetValue;
	        var ReturnFunction;
	        window.onload = function () {
	            try {
	                RetValue = parent.mail_newreceiverchoose_dialogArguments[0];
	                ReturnFunction = parent.mail_newreceiverchoose_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.mail_newreceiverchoose_dialogArguments[0];
	                    ReturnFunction = opener.mail_newreceiverchoose_dialogArguments[1];
	                } catch (e) { }
	            }
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            ListTypeChangeIcon();
	
	            if (ReturnFunction == null)
	                g_fnaddReceiver = window.dialogArguments["addReceiver"];
	            try {
	                document.getElementById('TreeView').innerHTML = "";
	                var wholeHtml = '<div id="FromTreeView" nodeclick="TreeViewNodeClick" requestdata="RequestData" selectnodeid="' + deptid + '">';
	                wholeHtml += '<div id="left">';
	                //2019-09-24 김보미 - 부서명에 특수문자(")가 있을경우에 deptList값이 잘려 부서리스트가 출력되지 않는 버그 수정
// 	                for (var i = 0; i < deptList.length ; i ++) {
// 						if (deptList[i].authType == 'M') {
// 							var html = '<h2 onclick="node_select(&quot;' + deptList[i].deptId + '&quot;, &quot;&quot;, &quot;FromTreeView&quot;, TreeViewNodeClick);" class="node_div off" id="' + deptList[i].deptId + '" nodename="' + deptList[i].deptName + '" manageflag="M" value="' + deptList[i].deptName + '" cn="'+ deptList[i].deptId +'" isleaf="TRUE" ' + 
// 							'style="padding-left:0px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">';
// 							html += '<span id="spn_' + deptList[i].deptId + '" class="node_normal" onclick="node_select(&quot;' + deptList[i].deptId + '&quot;, &quot;&quot;, &quot;FromTreeView&quot;, TreeViewNodeClick);" style="cursor: pointer; display: inline-block;">' + deptList[i].deptName + '</span>';
// 							html += '<div id="' + deptList[i].deptId + '_sub" style="display: none;"></div></li>';
// 							wholeHtml += html;
// 						}
// 					}
					<c:forEach var="dept" items="${deptList}">
						<c:if test="${dept.authType == 'M'}">
							wholeHtml += '<h2 onclick="node_select(&quot;' + "<c:out value='${dept.deptId}' />" + '&quot;, &quot;&quot;, &quot;FromTreeView&quot;, TreeViewNodeClick);" class="node_div off" id="' + "<c:out value='${dept.deptId}' />" + '" nodename="' + "<c:out value='${dept.deptName}'/>" + '" manageflag="M" value="' + "<c:out value='${dept.deptName}'/>" + '" cn="'+ "<c:out value='${dept.deptId}' />" +'" isleaf="TRUE" ' + 
							'style="padding-left:0px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">';
							wholeHtml += '<span id="spn_' + "<c:out value='${dept.deptId}' />" + '" class="node_normal" onclick="node_select(&quot;' + "<c:out value='${dept.deptId}' />" + '&quot;, &quot;&quot;, &quot;FromTreeView&quot;, TreeViewNodeClick);" style="cursor: pointer; display: inline-block;">' + "<c:out value='${dept.deptName}'/>" + '</span>';
							wholeHtml += '<div id="' + "<c:out value='${dept.deptId}' />" + '_sub" style="display: none;"></div></li>';
							
						</c:if>
					</c:forEach>
	                wholeHtml += '</div></div>';
	                document.getElementById('TreeView').innerHTML += wholeHtml; 

					if ($("h2#"+deptid).length > 0) {
						$("h2#"+deptid).click();
					}else {
						$("h2")[0].click();
					}
	                if (strSearch != "") {
	                    document.getElementById('keyword').value = strSearch;
	                    search_click();
	                }
	            }
	            catch (ErrMsg) {
	                alert(" TreeViewinitialize : " + ErrMsg.description);
	            }
	            
                var arrayDept = $("#TreeView div.node_div"); 

	            if (type == "auto") {
					remove_key_event();
	            }

	        }

	        function confirm_onClick() {
				if (type == "auto") {
	                confirm_onClick_auto();
	                return;
	            }

// 	            if (ReturnFunction != null)
// 	                ReturnFunction(ListViewMsgTo, ListViewMsgCC, ListViewMsgBCC);
// 	            else {
// 	                g_fnaddReceiver(ListViewMsgTo, ListViewMsgCC, ListViewMsgBCC);
// 	            }
	            window.close();
	        }
	        function confirm_onClick_auto() {
                if (listContentArry != "") {
                	var selectedTr = document.getElementById(listContentArry[0]);
                    var strId = selectedTr.getAttribute("_data2");
                    var strName = "";
                    strName += selectedTr.getAttribute("_data4") == "" ? "" : selectedTr.getAttribute("_DATA4");
                    strName += selectedTr.getAttribute("_data6") == "" ? "" : "[" + selectedTr.getAttribute("_DATA6") + "]";;
                    var strDeptName = selectedTr.getAttribute("_data5");
                }
                else {
                    alert("<spring:message code='ezAttitude.t110'/>");
                    return;
                }

	            if (ReturnFunction != null)
	                ReturnFunction(strId, strName, strDeptName);
	            
	            window.close();
	        }
	        
	        var nodeIdx;
	        function TreeViewNodeClick() {
	            issearch = false;
	            CurPage = "1";
	            listContentArry = new Array();
	            p_ListOrderObject = "";
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;margin-right:3px;margin-top:-2px;\" >" + nodeIdx.GetNodeData("VALUE");
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	        var tempDeptID = "";
	        function displayUserList(DeptID) {
	            if (DeptID != undefined)
	                tempDeptID = DeptID;
	            listContentArry = new Array();
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : tempDeptID, cell : "company;department;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", page: CurPage, type : "user"},
		        	success : function(result){
		                pListXML_Info = loadXMLString(result);
		        		
		                pSeach = false;
		                DisplayUserImageList();
		                makePageSelPage2();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t60' />" + error);
		        	}
		        });
	        }
	        
		    var m_strColorSelect = "#f1f8ff";
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
		    	if (type == "auto") {
		    		return;
		    	}
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
		    	if (type == "auto") {
		    		return;
		    	}
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            if (!event) event = window.event;
		        }
		        switch (event.keyCode) {
		            case 16: PressShiftKey = true; break;
		            case 17: PressCtrlKey = true; break;
		        }
		    }

		    var listContentArry = new Array();
		    var listSubContentArry = new Array();
		    var listEventCheckbox = false;
		    var listSubEventCheckbox = false;
		    function event_listclick(obj) {
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

		    function DisplayUserImageList() {
		        p_ListOrderObject = "";
		        var xmlRtn = pListXML_Info;
		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
		        totalPage2 = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
		        
		        var tbody = document.getElementById("txtlist_table").getElementsByTagName("TBODY");
		        
		        while (tbody.item(0).childNodes.length > 1) {
		        	tbody.item(0).removeChild(tbody.item(0).childNodes.item(1));
		        }
		        
		        var searchTbody = document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY");
		        while (searchTbody.item(0).childNodes.length > 1) {
		        	searchTbody.item(0).removeChild(searchTbody.item(0).childNodes.item(1));
		        }
		        
		        var UserListHTML = "";
		        if (SelectDeptNM.getAttribute("countinfo") != "1") {
		            SelectDeptNM.innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "</span>";
		            SelectDeptNM.setAttribute("countinfo", "1")
		        }
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("tblPageRayer2").style.display = "";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle; margin-right:3px; margin-top:-2px;\" >" + strLang_2 + "" + "&nbsp;&nbsp;<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "</span>";
		                SelectDeptNM.setAttribute("countinfo", "1")
		            }
		        }
		        else {
		            document.getElementById("DeptUserImgList").style.display = "none";
		            document.getElementById("txtlist_Layer").style.display = "";
		            document.getElementById("tblPageRayer2").style.display = "";
		            if (!pSeach) {
		                document.getElementById("txtlist_table").style.display = "";
		                document.getElementById("Search_txtlist_table").style.display = "none";
		            }
		            else {
		                document.getElementById("Search_txtlist_table").style.display = "";
		                document.getElementById("txtlist_table").style.display = "none";
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle; margin-right:3px; margin-top:-2px;\" >" + strLang_2 + "" + "&nbsp;&nbsp;<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "</span>";
		                SelectDeptNM.setAttribute("countinfo", "1")
		            }
		        }
		        
		        var row = SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW");
		        
		        for (var i = 0; i < row.length; i++) {
       				if (pListType == "IMG") {
		                var MainTable = document.createElement("TABLE");
		                MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
		                MainTable.setAttribute("cellspacing", "0");
		                MainTable.setAttribute("cellpadding", "0");
		                if (pListType == "IMG")
		                    MainTable.style.marginTop = "5px";
		
		                MainTable.style.marginLeft = "auto";
		                MainTable.style.marginRight = "auto";
		                var M_TR = document.createElement("TR");
		                M_TR.setAttribute("id", "MailUserlist_" + i);
		                M_TR.style.cursor = "pointer";
		                M_TR.onmouseover = function () { event_listMover(this); };
		                M_TR.onmouseout = function () { event_listMout(this); };
		                M_TR.onclick = function () { event_listclick(this); };
		                M_TR.ondblclick = function () { event_listDBclick(this); };
		                M_TR.onselectstart = function () { return false; };
// 		                M_TR.setAttribute("draggable", true);
		                if (CrossYN())
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
		                else
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); };
		
		                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                    M_TR.ondragend = function (event) { event_listdragend(event); };
		                }
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        if (row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(row.item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
		                        }
		                    }
		                }
		                else {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                        		row.item(i).childNodes.item(0).childNodes.item(NodeCount).text);
		                    }
		                }
		
		                var M_TR_TD = document.createElement("TD");
		                M_TR_TD.setAttribute("class", "pictd");
		                var M_TR_DIV = document.createElement("DIV");
		                M_TR_DIV.setAttribute("class", "pic");
		                if (M_TR.getAttribute("_DATA9") != "") {
		                    var M_TR_IMG = document.createElement("IMG");
		                    M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
		                    M_TR_IMG.setAttribute('onerror', "this.style.display='none'");
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
		                if ("${useOcs}" == "YES") {
		                    pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
		                }
		                pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
		                pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
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
		                Sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
		                Sub_TD3.appendChild(Sub_TD3_Img);
		                Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
		                Sub_TR3.appendChild(Sub_TD3);
		
		                var Sub_TR4 = document.createElement("TR");
		                var Sub_TD4 = document.createElement("TD");
		                Sub_TD4.style.textAlign = "left";
		                var Sub_TD4_Img = document.createElement("IMG");
		                Sub_TD4_Img.setAttribute("class", "icon");
		                Sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
		                Sub_TD4.appendChild(Sub_TD4_Img);
		                Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
		                Sub_TR4.appendChild(Sub_TD4);
		
		                M_TR_TDS_Table.appendChild(Sub_TR1);
		                M_TR_TDS_Table.appendChild(Sub_TR2);
		                M_TR_TDS_Table.appendChild(Sub_TR3);
		                M_TR_TDS_Table.appendChild(Sub_TR4);
		
		                M_TR.appendChild(M_TR_TD2);
		                MainTable.appendChild(M_TR);
		                document.getElementById("DeptUserImgList").appendChild(MainTable);
		            }
		            else {
		                var M_TR = document.createElement("TR");
		                M_TR.setAttribute("id", "MailUserlist_" + i);
		                M_TR.style.cursor = "pointer";
		                M_TR.onmouseover = function () { event_listMover(this); };
		                M_TR.onmouseout = function () { event_listMout(this); };
		                M_TR.onclick = function () { event_listclick(this); };
		                M_TR.ondblclick = function () { event_listDBclick(this); };
		                M_TR.onselectstart = function () { return false; };
		                M_TR.setAttribute("draggable", true);
		                if (CrossYN())
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
		                else
		                    M_TR.ondragstart = function (event) { event_listdragstart(this); };
		
		                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                    M_TR.ondragend = function (event) { event_listdragend(event); };
		                }
		                
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        if (row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(row.item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
		                        }
		                    }
		                }
		                else {
		                    for (var NodeCount = 0; NodeCount < row.item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + row.item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                          row.item(i).childNodes.item(0).childNodes.item(NodeCount).text);
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
		                    if ("${useOcs}" == "YES")
		                        M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
		                    else
		                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
		
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
		                }
		                else {
		                    var M_TR_TD1 = document.createElement("TD");
		                    M_TR_TD1.style.overflow = "hidden";
		                    M_TR_TD1.style.textOverflow = "ellipsis";
		                    M_TR_TD1.style.whiteSpace = "nowrap";
		                    M_TR_TD1.style.width = "150px";
		                    if ("${useOcs}" == "YES")
		                        M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
		                    else
		                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
		
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
	        function show_member() {
	            var listview = new ListView();
	            listview.LoadFromID("Organ");
	            var length = listview.GetRowCount()
	            var selectdata = listview.GetSelectedRows();
	            if (length > 0) {
	                var id = GetAttribute(selectdata[0], "DATA2");
	                var dept = GetAttribute(selectdata[0], "DATA10");
	                window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
	            if ($.trim(keyword.value) == "") {
	                alert("<spring:message code='ezEmail.t10' />");
	                keyword.focus();
	                return;
	            }
	            if (type == "search") {
	                CurPage = "1";
	                issearch = true;
	            }
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezAttitude/getSearchList.do",
		        	async : true,
		        	data : {
		        			search : document.getElementById("search_type").value + "::" + keyword.value, 
		        			cell : "company;department;displayName;title;telephoneNumber;"+ document.getElementById("search_type").value, 
		        			prop : "mail;displayName;description;title;company;telephonenumber;extensionAttribute2", 
		        			page : CurPage, 
		        			type : "user",
		        			companyID : companyid
		        			},
		        	success : function(result){	
		        		pListXML_Info = loadXMLString(result);
		        		if (pListXML_Info.getElementsByTagName("ROW").length == 0) {
		        		    issearch = false;
	                        alert(strLang155);	                        
		        		} else {
	                        listContentArry = new Array();
	                        pSeach = true;
	                        DisplayUserImageList();
	                        makePageSelPage2();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t578' />" + error);
		        	}
		        });
	            
	            var usedefault;
	            if (browserIE) {
	                usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
	            }
	            else {
	                usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
	            }
		     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
	            PressShiftKey = false;
	            
	        }
	        
	        /* 2024-07-25 홍승비 - 사용하지 않는 기존 조직도 검색 함수 제거 (현재는 /ezOrgan/getSearchList.do가 아닌 /ezAttitude/getSearchList.do를 사용함) */
	        
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
	            listContentArry = new Array();
	            pListType = Div;
	            ListTypeChangeIcon();
	            DisplayUserImageList();
	        }
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }

	        function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezEmail.t579' />");
	                return;
	            }
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var rtn
	            var width = 420, height = 450;
	            var leftPosition, topPosition;
	            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        function open_userinfo(cn) {
	            window.showModalDialog("/ezCommon/showPersonInfo.do?id=" + cn, "", "dialogHeight=450px;dialogWidth=420px;status:no;scroll:auto; help:no; edge:sunken");
	        }
	      
	        function MakeXMLString(pOrgString) {
	            if (pOrgString == undefined) return;
	            return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
	        }

            function trim(str) {
                var re = /^\s+|\s+$/g;
                return str.replace(re, '');
            }

            function OnlyNumber() {
                if ((event.keyCode < 48) || (event.keyCode > 57)) {
                    event.returnValue = false;
                }
            }

            var BlockSize2 = 10;
            function td_Create2(strtext) {
                document.getElementById("tblPageRayer2").innerHTML = strtext;
            }
            function makePageSelPage2() {
                var strtext2;
                var PagingHTML2 = "";
                document.getElementById("tblPageRayer2").innerHTML = "";
                strtext2 = "<div class='pagenavi'>";
                PagingHTML2 += strtext2;
                var pageNum2 = CurPage;
                if (totalPage2 > 1 && pageNum2 != 1) {
                    strtext2 = "<span class='btnimg first' onclick= 'return goToPageByNum2(1)'></span>";
                    PagingHTML2 += strtext2;
                }
                else {
                    strtext2 = "<span class='btnimg first disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                if (totalPage2 > BlockSize2) {
                    if (pageNum2 > BlockSize2) {
                        strtext2 = "<span class='btnimg prev' onclick= 'return selbeforeBlock2()'></span>";
                        PagingHTML2 += strtext2;
                    }
                    else {
                        strtext2 = "<span class='btnimg prev disabled'</span>";
                        PagingHTML2 += strtext2;
                    }
                }
                else {
                    strtext2 = "<span class='btnimg prev disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                var MaxNum2;
                var i;
                var startNum2 = (parseInt((pageNum2 - 1) / BlockSize2) * BlockSize2) + 1;
                if (totalPage2 >= (startNum2 + parseInt(BlockSize2))) {
                    MaxNum2 = (startNum2 + parseInt(BlockSize2)) - 1;
                }
                else {
                    MaxNum2 = totalPage2;
                }
                for (i = startNum2; i <= MaxNum2; i++) {
                    if (i == pageNum2) {
                        strtext2 = "<span class='on'>" + i + "</span>";
                        PagingHTML2 += strtext2;
                    }
                    else {
                        strtext2 = "<span onclick='goToPageByNum2(" + i + ")'>" + i + "</span>";
                        PagingHTML2 += strtext2;
                    }
                }
                if (totalPage2 > BlockSize2) {
                    if (totalPage2 >= parseInt(((parseInt((pageNum2 - 1) / BlockSize2) + 1) * BlockSize2) + 1)) {
                        strtext2 = "";
                        strtext2 = strtext2 + "<span class='btnimg next' onclick='return selafterBlock2()'></span>";
                        PagingHTML2 += strtext2;
                    }
                    else {
                        strtext2 = "";
                        strtext2 = strtext2 + "<span class='btnimg next disabled'></span>";
                        PagingHTML2 += strtext2;
                    }
                }
                else {
                    strtext2 = "";
                    strtext2 = strtext2 + "<span class='btnimg next disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                if (totalPage2 > 1 && totalPage2 != 1 && (totalPage2 != pageNum2)) {
                    strtext2 = "<span class='btnimg last' onclick='return goToPageByNum2(" + totalPage2 + ")'></span>";
                    PagingHTML2 += strtext2;
                }
                else {
                    strtext2 = "<span class='btnimg last disabled'></span>";
                    PagingHTML2 += strtext2;
                }
                PagingHTML2 += "</div>";
                td_Create2(PagingHTML2);
            }
            function goToPageByNum2(Value) {
                CurPage = Value;
                makePageSelPage2();
                movePage2(CurPage);
            }
            function selbeforeBlock2() {
                var pageNum = parseInt(CurPage);
                pageNum = ((parseInt(pageNum / BlockSize2) - 1) * BlockSize2) + 1;
                goToPageByNum2(pageNum);
            }
            function selbeforeBlock_one2() {
                var pageNum = parseInt(CurPage);
                if (parseInt(pageNum - 1) > 0)
                    goToPageByNum2(parseInt(pageNum - 1));
                else
                    return;
            }
            function selafterBlock2() {
                var pageNum = parseInt(CurPage);
                pageNum = ((parseInt((pageNum - 1) / BlockSize2) + 1) * BlockSize2) + 1;
                goToPageByNum2(pageNum);
            }
            function selafterBlock_one2() {
                var pageNum = parseInt(CurPage);
                if (parseInt(pageNum + 1) <= totalPage2)
                    goToPageByNum2(parseInt(pageNum + 1));
                else
                    return;
            }
            function movePage2(newPage2) {
                if (parseInt(newPage2) > 0 && parseInt(newPage2) <= parseInt(totalPage2)) {
                    CurPage = newPage2;
                    if (issearch)
                        search_click();
                    else
                        displayUserList();
                }
            }
            function prevPage_onclick2() {
                newPage2 = parseInt(CurPage) - 1;
                if (newPage2 > 0) {
                    CurPage = newPage2;
                    if (issearch)
                        search_click();
                    else
                        displayUserList();
                }
            }
            function nextPage_onclick2() {
                newPage2 = parseInt(CurPage) + 1;
                if (newPage2 <= parseInt(totalPage)) {
                    CurPage = newPage2;
                    if (issearch)
                        search_click();
                    else
                        displayUserList();
                }
            }
            
            function node_select(pNodeID, pNodeNM, pTreeID, callbackFunc) {
                var treeDiv = document.getElementById(pTreeID);
                var preSelectID = GetAttribute(treeDiv, "SELECTNODEID");

                if (preSelectID != "" && preSelectID != "undefined") {
                    var objH2 = $("h2#"+preSelectID);
                    objH2.attr('class','off');
                }

                if (pNodeID != "" && pNodeID != "undefined") {
                	var objH2 = $("h2#"+pNodeID);
                    objH2.attr('class','on');

                    treeDiv.setAttribute("SELECTNODEID", pNodeID);
                    
                    if (callbackFunc != null & typeof (callbackFunc) == "function")
                        callbackFunc(pNodeID, pNodeNM);
                }
            }
            
            function event_listDBclick(){
            	confirm_onClick();
            }
	    </script>
	</head>
	<body class="popup" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<xml id="listviewheader" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t586' /></NAME>
		        <WIDTH>40</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>E-MAIL</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader2" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>	
		        <NAME><spring:message code='ezEmail.t31' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t28' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t29' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader3" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t57' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader4" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t31' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t712' /></NAME>
		        <WIDTH>65</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>E-Mail</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
	    <h1 id="h1Title"><spring:message code='ezAttitude.t109'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table style="width:100%;">
	        <tr>
	            <td style="vertical-align: top;">
	                <table id="TreeViewTD">
	                    <tr>
	                        <td>
	                            <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border-bottom: 0px; height:26px;">
	                                    <table style="margin-top: 4px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezEmail.t31' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezEmail.t26' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezEmail.t28' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezEmail.t99000045' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezEmail.t99000046' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezEmail.t29' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezEmail.t99000047' /></option>
	                                                        <c:if test="${primaryLang eq '3' }">
		                                                    <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
		                                                    <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
		                                                    </c:if>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezEmail.t99000048' /></option>
	                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezEmail.t99000049' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeypress="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px; height:21px">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezEmail.t37' /></span></a>
	
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px; position: relative;">
	                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px;padding: 0px;">
<!-- 	                                        <div style="width: 220px; height: 465px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div> -->
	                                        <div style="width: 220px; height: 485px; overflow-x: auto; overflow-y: auto; padding: 0px;" id="TreeView"></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="width: 432px" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                            <tr>
	                                                <th style="white-space:normal;background-color: white;border-top:1px solid #ddd;border-bottom:1px solid #eaeaea">
	                                                    <span id="SelectDeptNM" style="font-weight: normal; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: middle;"></span>
	                                                    <span style="float:right; position: relative;">
	                                                        <span onclick="ChangeListView_onClick('TXT');">
	                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');">
	                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 411px; overflow: auto; width: 446px;" id="txtlist_Layer">
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 150px;color:#333;background-color: #f8f8fa"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="width: 130px;color:#333;background-color: #f8f8fa"><spring:message code='ezEmail.t28' /></td>
	                                                    <td style="color:#333;background-color: #f8f8fa"><spring:message code='ezEmail.t99000045' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 110px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezEmail.t26' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="width: 80px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezEmail.t28' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezEmail.t99000045' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 410px; overflow: auto; display: none; width: 446px;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer2"  style="text-align:center;"></div>
	                                	</td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <table style="width: 100%; text-align: center;">
	        <tr>
	            <td class="btnposition btnpositionNew">
	                <a class="imgbtn" onclick="confirm_onClick()" id="cmd_ok"><span><spring:message code='ezEmail.t599' /></span></a>
	            </td>
	        </tr>
	    </table>
	</body>
</html>
