<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t00013' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <style>
	    	.box {
	    		border-right:0px;
	    	}
	    	.mainlist tr td:first-child {
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
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var topid = "<c:out value='${topID}'/>";
		    var cn = "<c:out value='${userID}'/>";
		    var deptid = "<c:out value='${userInfo.deptID}'/>";
		    var g_szAuthor = "";
		    var g_senderinfo = "<c:out value='${userInfo.companyName1}'/>" + ", " + "<c:out value='${userInfo.deptName1}'/>" + ", " + "<c:out value='${userInfo.title1}'/>";
		    var g_szUserID = "<c:out value='${userInfo.email}'/>";
		    var name = "";
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var pListType = "TXT";
		    var pListXML_Info = null;
		    var xmlHTTP = createXMLHttpRequest();
		    var xmlHTTP2 = createXMLHttpRequest();
		    var ReturnFunction;
		    var isfirst = true;
		    var preObj = "";
			var deptTreeTopId = "${deptTreeTopId}";
			var selCompany = "${selCompany}";

		    $(document).ready(function(){
		    	try {
	                ReturnFunction = opener.addjob_config_dialogArguments[1];
	            } catch (e) {console.log(e);}
	            
	        	try {
	            	var ua = navigator.userAgent;
	            	
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text") {
		                        KeEventControl(input[i]);
		                    }
		                }
		            }
		        } catch (e) {console.log(e);}
		        
		        document.getElementById('keyword').value = cn;
				// 무조건 선택된 회사의 조직도가 나오게 변경 함.
		        var strQuery = "<DATA><DEPTID></DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
	
		        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        xmlHTTP.onreadystatechange = event_GetDeptTreeInfo;
		        xmlHTTP.send(strQuery);

				document.getElementById("TreeFrame").src = "/admin/ezOrgan/addjobAdd.do?companyID=" + selCompany;
	
		        ListTypeChangeIcon();
		        
		        ChangeListView_onClick(getOrganListType());
				
		    });
		    
		    function event_GetDeptTreeInfo() {
		    	if (xmlHTTP != null && xmlHTTP.readyState == 4) {
		        	if (xmlHTTP.status == 200) {
		            	var xmlTree = loadXMLString(xmlHTTP.responseText);
		                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(xmlTree);
		                treeView.DataBind("TreeView");

		                xmlHTTP = null;
		                isfirst = false;
		            } else {
		                alert("<spring:message code='ezOrgan.t13' />" + xmlHTTP.status);
		                xmlHTTP = null;
		            }
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
		        createNodeAndInsertText(xmlpara, objNode, "DISPLAY_TRASH_DEPT", "");
				createNodeAndInsertText(xmlpara, objNode, "ADMINORGAN", "y");

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
		    
		    function TreeViewNodeClick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
		        SelectDeptNM.setAttribute("countinfo", "")

		        if (isfirst && cn != "") {
		            document.getElementById('search_type').selectedIndex = 1;
		            
		            $.ajax({
			        	type : "POST",
			        	dataType : "text",
			        	url : "/ezOrgan/getSearchList.do",
			        	async : false,
			        	data : {search : "cn::" + cn, cell : "company;description;displayname;title;telephonenumber;"+ document.getElementById("search_type").value, prop : 'mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;usertype', type : 'user', adminOrgan : "y"},
			        	success : function(xml){	
			        		result=loadXMLString(xml);
			        		var headerData = createXmlDom();
		                    headerData = result;
// 		                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

		                    if (CrossYN()) {
		                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                        var Node = headerData.importNode(xmlRtn, true);
		                        headerData.documentElement.appendChild(Node);
		                    } else {
		                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                        headerData.documentElement.appendChild(xmlRtn);
		                    }
		                    pListXML_Info = headerData;
		                    pSeach = true;
		                    DisplayUserImageList();

		                    if ("<c:out value='${use_ocs}'/>" == "YES") {
		                        check_presence();
		                    }
			        	},
			        	error : function(error){
			        		alert("<spring:message code='ezOrgan.t9' />" + error);
			        	}
			        });			           
		        } else {
		            displayUserList(nodeIdx.GetNodeData("CN"));
		        }
		    }
		    
		    function displayUserList(DeptID) {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;usertype", type : "user",adminOrgan : "y"},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var headerData = createXmlDom();
		                headerData = result;
// 		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

		                if (CrossYN()) {
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }
		                pListXML_Info = headerData;
		                pSeach = false;
		                DisplayUserImageList();

		                if ("<c:out value='${use_ocs}'/>" == "YES") {
	                        check_presence();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t9' />" + error);
		        	}
		        });
		        
		        $.ajax({
					url : "/ezOrgan/getDeptMemberListCount.do",
					method : "POST",
					dataType : "json",
					data : {
						deptID : DeptID
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
	        
	        var listContentArry = new Array();
	        var listSubContentArry = new Array();
	        var listEventCheckbox = false;
	        var listSubEventCheckbox = false;
	        function event_listclick(obj) {
	        	if(preObj!=obj){
	            if (!listEventCheckbox) {
	                if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        
	                        if(p_ListOrderObject != null){
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
	                        }
	                    }
	                    listContentArry = new Array();
	                }
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
	                            if (listContentArry.length == 0) {
	                                p_ListOrderObject = "";
	                            }
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
	            Addjob_Check(GetAttribute(p_ListOrderObject, "_data2"));
	        	}
	        	preObj = obj;
	        }
	        
	        function event_listdblclick(obj) {
	        	InsertReceiver();
	        }
	        
	        function Addjob_Check(UserID) {
	            var listview = new ListView();
	            listview.LoadFromID("lvUserList");
	            var xmlDom = createXmlDom();
		            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getUserAddJobList.do",
		        	async : false,
		        	data : {cn : UserID},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		xmlDom = result;		        		
	                    var LISTVIEWDATA = "<LISTVIEWDATA><ROWS>";
	                    for (var i = 0; i < xmlDom.documentElement.getElementsByTagName("ROW").length; i++) {
	                        LISTVIEWDATA = LISTVIEWDATA + "<ROW><CELL>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<VALUE>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("DISPLAYNAME")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "changeComTapString" + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("COMPANY")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "changeDeptTapString" + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("DESCRIPTION")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + " (" + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("TITLE")[i]));
	                        var role = MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("ROLE")[i]));
	                        if (null != role && "" != role){
	                        LISTVIEWDATA = LISTVIEWDATA + " / " + role + ")";	                        	
	                        } else {
	                        	LISTVIEWDATA = LISTVIEWDATA + ")";
	                        }
	                        LISTVIEWDATA = LISTVIEWDATA + "</VALUE>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA1>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("DEPARTMENT")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA1>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA2>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("CN")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA2>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA3>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("TITLE1")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA3>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA4>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("TITLE2")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA4>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA5>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("DESCRIPTION")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA5>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA6>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("JOBID")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA6>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA7>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("ROLE")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA7>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA8>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("ROLE2")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA8>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<DATA9>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("ROLEID")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</DATA9>";
	                        LISTVIEWDATA = LISTVIEWDATA + "<MANUAL_FLAG>";
	                        LISTVIEWDATA = LISTVIEWDATA + MakeXMLString(getNodeText(xmlDom.documentElement.getElementsByTagName("MANUALFLAG")[i]));
	                        LISTVIEWDATA = LISTVIEWDATA + "</MANUAL_FLAG>";
	                        LISTVIEWDATA = LISTVIEWDATA + "</CELL></ROW>";
	                    }
	                    LISTVIEWDATA = LISTVIEWDATA + "</ROWS></LISTVIEWDATA>";
	                    
	                    document.getElementById('UserAddJobList').innerHTML = "";
	                    var Resultxml = loadXMLString(LISTVIEWDATA);
	                    var pAclList = new ListView();
	                    pAclList.SetID("lvAddjobList");
	                    pAclList.SetMulSelectable(false);
	                    pAclList.SetHeightFree(true);
	                    pAclList.DataSource(Resultxml);
	                    pAclList.DataBind("UserAddJobList");		               
		        	} 
	            });
	        }
	        
	        function InsertReceiver() {
	            document.getElementById('layer_popup').style.display = "";       
	        }
	        
	        function DeleteReceiver() {
	            var listid = "lvAddjobList";
	            var selList = new ListView();
	            selList.LoadFromID(listid);

	            var arrRows = selList.GetSelectedRows();
	            var strName = "";

	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
		    
		    pSeach = false;
		    function DisplayUserImageList() {
		        var xmlRtn = pListXML_Info;
		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
		        
		        while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        var UserListHTML = "";
		        /* if (SelectDeptNM.getAttribute("countinfo") != "1") {
		            //SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
		            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang24 + "</span>]";
	        		}
		            
		            SelectDeptNM.setAttribute("countinfo", "1")
		        } */
		        
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + "<spring:message code='ezOrgan.t101' />" + "</span>" + "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "</span></span>";
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + "<spring:message code='ezOrgan.t101' />" + "</span>" + "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "</span></span>";
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
	                    M_TR.ondblclick = function () { event_listdblclick(this); };
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
	                    
	                    if( !pSeach && $(M_TR).attr("_DATA19" ) == "addJob"){
		            		pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
		            	} else if( pSeach && $(M_TR).attr("_DATA19") == "addJob" ){
		            		pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
		            	}
	                    
	                    if ("<c:out value='${use_ocs}'/>" == "YES") {
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
	                } else {
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
 	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listdblclick(this); };
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
	                        
	                        var jobName = "";
	                        if($(M_TR).attr("_DATA19") == "addJob"){
			            		jobName += "<spring:message code='ezOrgan.psb03'/> ";
			            	}	      
	                        
	                        jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD3.innerHTML = jobName;
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
	                        var jobName = "";
	                        if($(M_TR).attr("_DATA19") == "addJob"){
			            		jobName += "<spring:message code='ezOrgan.psb03'/> ";
			            	}	      
	                        
	                        jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD2.innerHTML = jobName;

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
		    
		    function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
		        } else {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
		        }
		    }
		    
		    function btn_cancel_onclick() {
		        document.getElementById('layer_popup').style.display = "none";
// 		        document.getElementById("txt_TitleName").value = "";
// 		        document.getElementById("txt_TitleName2").value = "";
		    }
		    
		    function closeWindow() {
		        if (ReturnFunction != null) {
		            ReturnFunction("true");
		        } else {
		            window.returnValue = "true";
		        }
		        window.close();
		    }
		    
		    function getDeptId(userId) {
		        return getEntryInfo(userId, "department");
		    }
		    
		    function getEntryInfo(userId, propStr) {
		    	var ReceiveDocument = "";

		        try {
		        	var result = "";
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/admin/ezOrgan/getEntryInfo.do",
		        		data : {
		        			cn 	  : userId,
		        			prop  : propStr
		        		},
		        		success: function(xml){
		        			result = xml;
		        		}        			
		        	});
		        	
		            ReceiveDocument = SelectSingleNodeValueNew(loadXMLString(result), "DATA/" + propStr.toUpperCase());
		        } catch (e) {
		            console.log(e);
		        } 
		        
		        return ReceiveDocument;
		    }
		    
		    function btn_Add_onclick() {
		        var pparsingXML = "";
		        var pparsingXML2 = "";
		        var pAddFlag = false;
		        
		        if (p_ListOrderObject == null || p_ListOrderObject == "") {
		            alert(strLang13);
		            return;
		        } else {
		            var dept;
		            
		            if (CrossYN()) {
		                dept = document.getElementById("TreeFrame").contentWindow.OK_Click().split(';');
		            } else {
		                dept = document.getElementById("TreeFrame").contentWindow.OK_Click().split(';');
		            }		            
		            if (dept[0] == "") {
		                alert("<spring:message code='ezOrgan.t249' />");
		                return;
		            }

		            
 					if (jobTitle.trim() == "") {
						alert("<spring:message code='ezOrgan.kyj07' />");
						return;
					}
						
		            var listview = new ListView();
		            listview.LoadFromID("lvUserList");
		            var UserAddjoblistview = new ListView();
		            UserAddjoblistview.LoadFromID("lvAddjobList");
					jobRoleID = jobRoleID != "" ? jobRoleID : "0";
		        	var bFlag = UserAddjoblistview.ExistRow2({"data1":dept[0], "data6":jobTitleID});
					let cn = GetAttribute(p_ListOrderObject, "_data2");
					let roleVal = document.getElementById("lvAddjobList").querySelector('tbody').children;
		        	
		        	if (!bFlag) { // 원부서의 직위 체크
		        		var orgDeptId = getDeptId(cn);
						var orgJobId = getEntryInfo(cn, "extensionAttribute7");
						var orgRoleId = getEntryInfo(cn, "extensionAttribute8");
						bFlag = ((dept[0] == orgDeptId) && (jobTitleID == orgJobId)) ? true : false;
		        	}
					
					if(jobCheck(cn, dept[0], jobTitleID, jobRoleID)){
						alert(strLang25);
						return;
					}
		            
					/* var bFlag = UserAddjoblistview.ExistRow("data1", dept[0]);
		            
		            if (!bFlag) {
    		            var cn = GetAttribute(p_ListOrderObject, "_data2");
    		            var orgDeptId = getDeptId(cn);
    		            bFlag = dept[0] == orgDeptId ? true : false;
		        	} */
		        	
		        	// // 중복겸직가능 //2023-12-12 동일 부서의 동일 겸직(직위 동일, 직책만 다른 경우) 가능하도록 수정되어 해당 부분 주석
		        	// bFlag = false;
		        	
		            if (bFlag) {
		                alert(strLang25);
		                return;
		            } else {
		            	var compName = new Array();
				        $.ajax({
				        	type : "POST",
				        	dataType : "text",
				        	url : "/admin/ezOrgan/addJobCompanyName.do",
				        	async : false,
				        	data : {displayName : dept[0]},
				        	success : function(data){
				        		compName = data.split(":");
				        	}
				        });
		                pparsingXML2 = "";
		                pparsingXML = "";
		                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                pparsingXML = pparsingXML + "<ROW><CELL>";
// 		                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(dept[1]) + " (" + MakeXMLString(document.getElementById("txt_TitleName").value) + " : " + MakeXMLString(document.getElementById("txt_TitleName2").value) + ")</VALUE>";
 		               	if(compName[1] === "1") {
 		               		pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(p_ListOrderObject, "_data11"));
 		               	} else {
 		               		pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(p_ListOrderObject, "_data12"));
 		               	}
 		               	pparsingXML = pparsingXML + "changeComTapString" + compName[0];
 		               	pparsingXML = pparsingXML + "changeDeptTapString" + MakeXMLString(dept[1]) + " (" ;

 		               	if(compName[1] === "1") {
 		               		pparsingXML = pparsingXML + MakeXMLString(jobTitle);
 		               		if ("" != jobRole) {
 		               			pparsingXML = pparsingXML + " / " + MakeXMLString(jobRole);
 		               		}
 		               	} else {
 		               		pparsingXML = pparsingXML + MakeXMLString(jobTitle2);
 		               		if ("" != jobRole) {
		               			pparsingXML = pparsingXML + " / " + MakeXMLString(jobRole2);
		               		}	
 		               	}
 		               	pparsingXML = pparsingXML + ")</VALUE>";
		                pparsingXML = pparsingXML + "<DATA1>" + MakeXMLString(dept[0]) + "</DATA1>";
		                pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(GetAttribute(p_ListOrderObject, "_data2")) + "</DATA2>";
// 		                pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(document.getElementById("txt_TitleName").value) + "</DATA3>";
// 		                pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(document.getElementById("txt_TitleName2").value) + "</DATA4>";
		                pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(jobTitle) + "</DATA3>";
		                pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(jobTitle2) + "</DATA4>";
		                pparsingXML = pparsingXML + "<DATA5>" + MakeXMLString(dept[1]) + "</DATA5>";
		                pparsingXML = pparsingXML + "<DATA6>" + MakeXMLString(jobTitleID) + "</DATA6>";
		                pparsingXML = pparsingXML + "<DATA7>" + MakeXMLString(jobRole) + "</DATA7>";
		                pparsingXML = pparsingXML + "<DATA8>" + MakeXMLString(jobRole2) + "</DATA8>";
		                pparsingXML = pparsingXML + "<DATA9>" + MakeXMLString((jobRoleID != "" ? jobRoleID : "0")) + "</DATA9>";
		                pparsingXML = pparsingXML + "<MANUAL_FLAG>Y</MANUAL_FLAG>";
		                pparsingXML = pparsingXML + "</CELL></ROW>";
		                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                Resultxml = loadXMLString(pparsingXML2);

		                var listview = new ListView();
		                listview.LoadFromID("lvAddjobList");		                
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
		                
		                if (MaxCntNum != 0) {
		                    MaxCntNum = MaxCntNum + 1;
		                }
		                SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + (MaxID + 1));
		                listview.AddDataRow(objTr, Resultxml);

		                var _tdlength = document.getElementById("lvAddjobList").getElementsByTagName("TD").length;
		                for (var y = 0; y < _tdlength; y++) {
		                    document.getElementById("lvAddjobList").getElementsByTagName("TD")[y].style.textOverflow = "";
		                    document.getElementById("lvAddjobList").getElementsByTagName("TD")[y].style.overflow = "";
		                }
		            }
		        }
		        document.getElementById('layer_popup').style.display = "none";
// 		        document.getElementById("txt_TitleName").value = "";
// 		        document.getElementById("txt_TitleName2").value = "";
		    }
		    
		    function OK_Click() {
	            var Addjoblistview = new ListView();
	            Addjoblistview.LoadFromID("lvAddjobList");
	            
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert(strLang13);
	                return;
	            }

	            var AddjobText = "";
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	            var xmlPara = createXmlDom();
	            var objRoot, objNode, subNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	            
	            for (var i = 0; i < Addjoblistview.GetRowCount() ; i++) {
	                createNodeAndInsertText(xmlDom, objNode, "CN", GetAttribute(p_ListOrderObject, "_data2"));
	                createNodeAndInsertText(xmlDom, objNode, "DEPTID", GetAttribute(Addjoblistview.GetDataRows()[i], "data1"));
	                createNodeAndInsertText(xmlDom, objNode, "TITLE", GetAttribute(Addjoblistview.GetDataRows()[i], "data3") + ":" + GetAttribute(Addjoblistview.GetDataRows()[i], "data4"));
	                createNodeAndInsertText(xmlDom, objNode, "JOBID", GetAttribute(Addjoblistview.GetDataRows()[i], "data6"));
	                createNodeAndInsertText(xmlDom, objNode, "ROLE", GetAttribute(Addjoblistview.GetDataRows()[i], "data7"));
	                createNodeAndInsertText(xmlDom, objNode, "ROLE2", GetAttribute(Addjoblistview.GetDataRows()[i], "data8"));
	                createNodeAndInsertText(xmlDom, objNode, "ROLEID", GetAttribute(Addjoblistview.GetDataRows()[i], "data9"));
	                createNodeAndInsertText(xmlDom, objNode, "MANUAL_FLAG", GetAttribute(Addjoblistview.GetDataRows()[i], "manual_flag"));

	                AddjobText = AddjobText + "- " + GetAttribute(Addjoblistview.GetDataRows()[i], "data5") + " (" + GetAttribute(Addjoblistview.GetDataRows()[i], "data3") + ":" + GetAttribute(Addjoblistview.GetDataRows()[i], "data4") + ")<BR>";
	            }
	            if (Addjoblistview.GetRowCount() == 0) {
	                alert("<spring:message code='ezOrgan.t330' />");
	                return;
	            }
	            xmlHTTP.open("POST", "/admin/ezOrgan/saveSubTitle.do", false);
	            xmlHTTP.send(xmlDom);

	            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
	                if (xmlHTTP.responseText == "EXIST") {
	                    alert("<spring:message code='ezOrgan.t202' />");
	                } else {
	                    alert("<spring:message code='ezOrgan.t203' />");
	                }
	            } else {
	            	// TODO : 2016-04-26 장진혁과장 --senmail 관련 자바스크립트 구현 필요
	                //sendmail(GetAttribute(p_ListOrderObject, "_data2"), strLang27, AddjobText);
	                alert("<spring:message code='ezOrgan.t204' />");
	            }
	            
	            try {
 			    	//window.opener.AddJob_List();
 			    	opener.parent.left.goPage(13); // right 리로드하여 각 프레임의 count, list가 적용되도록 수정
 			    	window.close();
 			    } catch (e) {
 			    	window.close();
 			    }
	        }
		    
		    var rgParams = new Array();
		    var checkname2_cross_dialogArguments = new Array();
		    function deptsearch_click() {
		        if (document.all("deptkeyword").value == "") {
		        	alert("<spring:message code='ezOrgan.t56' />");
		            document.all("deptkeyword").focus();
		            return;
		        }
		        var xmlDOM = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {
						search: "displayname::" + encodeURIComponent(document.all("deptkeyword").value),
						cell: "extensionAttribute3;displayname;extensionAttribute9;",
						prop: "cn",
						type: 'group',
						company: selCompany,
						adminOrgan: "y"
					},
		        	success : function(xml){	
		        		result=loadXMLString(xml);
		        		xmlDOM = result;
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t11' />" + error);
		        		xmlDOM = null;
		        	}
		        });
		        
		        if (adCount == 0) {
		        	alert("<spring:message code='ezOrgan.t61' />");
		            return;
		        } else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();

		            if (CrossYN()) {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
		            } else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
		            }
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        } else {
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            
		            if (CrossYN()){
		                checkname2_cross_dialogArguments[0] = rgParams;
		                checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;		                
		                var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(598, 340));
		                try { OpenWin.focus(); } catch (e) {console.log(e);}
		            }else{
		                var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(600, 320);
		                window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
		                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		                    g_xmlHTTP.send(strQuery);
		                }
		            }
		        }
		    }
		    function deptsearch_click_Complete() {
		        if (rgParams["deptid"] != "") {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + selCompany + "/organ</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT><ADMINORGAN>y</ADMINORGAN></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		    }
		    var bSearch = true;
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                if (!bSearch) {
		                    try {
		                        if (CrossYN()) {
		                            opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        } else {
		                            window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        }
		                    } catch (e) {console.log(e);}
		                }

		                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
		                document.getElementById('TreeView').innerHTML = "";

		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
		                treeView.DataBind("TreeView");
		            } else {
		                alert("<spring:message code='ezOrgan.t9' />" + g_xmlHTTP.status);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    
		    function search_click(){
				if (keyword.value == ""){
					alert("<spring:message code='ezOrgan.t56' />");
					keyword.focus();
					return;
				}			   
			    				
				$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",		        	
		        	data : {
						search: document.getElementById("search_type").value + "::" + encodeURIComponent(document.getElementById("keyword").value),
						cell: "company;description;displayname;title;telephonenumber;" + document.getElementById("search_type").value,
						prop: "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;usertype",
						type: "user",
						company: selCompany,
						adminOrgan: "y"
					},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var usedefault;		                
		                var headerData = createXmlDom();
// 		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                headerData = result;
		                
		                if (CrossYN()) {
		                	usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                	usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }
		                pListXML_Info = headerData;
		                pSeach = true;
		                DisplayUserImageList();

		                if ("<c:out value='${use_ocs}'/>" == "YES") {
		                    check_presence();
		                }
		                
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t9' />");
					}
		        });				
				// [2006. 02. 10. 이민수] 검색을 완료하면 TextBox를 초기화하도록 변경
				//keyword.value = "";
			}
		    
		    function deptsearch_press() {
	            if (window.event.keyCode == "13") {
	                deptsearch_click();
	                event.cancelBubble = true;
	                event.returnValue = false;
	            }
	        }
		    
		    function search_press(){
				if (window.event.keyCode == "13"){
					search_click();
				}
			}
		    
		    String.prototype.trim = function () {
		        return this.replace(/(^\s*)|(\s*$)/g, "");
		    }
		    function keyword_Clear() {
		        document.getElementById("keyword").value = "";
		    }
		    
		    function ChangeListView_onClick(Div) {
		        pListType = Div;
		        ListTypeChangeIcon();
		        DisplayUserImageList();
		        setOrganListType(pListType);
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
	          			deptNameWidth = 360 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 357) {
	          			deptNameWidth = 358 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
		    
	        var jobTitle, jobTitle2, jobTitleID, jobRole, jobRole2, jobRoleID;
		    function getTitleOption(companyID) {
		    var typeAry = ['001', '002'];
		    var xmldom, rtnVal, flag, i;
		    typeAry.forEach(function(type) {
		    	$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/jobTitleListView.do",
					data : {
						type : type,
						companyID : companyID
					},
					async : false,
					success : function(result){
						xmldom = loadXMLString(result);
					},
					error : function(){
					}
				});
		    	
		    	var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
		    	if (type == '001') {
					if (oRows.length > 0) {
				    	flag = true;
				    	rtnVal = "<select id='titleSelector' style='width:100%;height:25px;' onchange='jobChange(this)'>";
				    	for (i = 0; i < oRows.length; i++) {
				    		if (SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE") != "N") {
					    		if (flag) {
	// 					    		jobID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
	// 					    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
	// 					    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE");
						    		jobTitleID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1");
						    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
						    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
						    		flag = false;
						    		console.log("jobTitle = ",jobTitleID, jobTitle, jobTitle2);
					    		}
					    		
	// 				    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
	// 						    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) 
	// 						    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE")) + "'>";
					    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1")) 
							    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
							    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) + "'>";
						    		
					    		if ("${userInfo.primary}" == "1") {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE"));
					    		} else {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE"));
					    		}
					    		
					    		rtnVal += "</option>";
				    		}
				    	}
				    	rtnVal += "</select>";
				    } else {
				    	rtnVal = "<select id='titleSelector' style='width:100%;height:25px;'></select>";
				    	jobTitleID = ""; jobTitle = ""; jobTitle2 = "";
				    }
						document.getElementById("JobTitleOption").innerHTML = rtnVal;
		    	} else if (type == '002') {
					if (oRows.length > 0) {
				    	flag = true;
				    	rtnVal = "<select id='roleSelector' style='width:100%;height:25px;' onchange='jobChange(this)'>";
					    		rtnVal += "<option id='' nmval='' nmval2=''>(<spring:message code='ezApprovalG.t852' />)</option>";
				    	for (i = 0; i < oRows.length; i++) {
				    		if (SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE") != "N") {
					    		if (flag) {
	// 					    		jobID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
	// 					    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
	// 					    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE");
						    		jobRoleID = "";
						    		jobRole = "";
						    		jobRole2 = "";
						    		flag = false;
					    		}
	// 				    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
	// 						    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) 
	// 						    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE")) + "'>";
					    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1")) 
							    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
							    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) + "'>";
						    		
					    		if ("${userInfo.primary}" == "1") {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE"));
					    		} else {
						    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE"));
					    		}
					    		
					    		rtnVal += "</option>";
				    		}
				    	}
				    	rtnVal += "</select>";
				    } else {
				    	rtnVal = "<select id='roleSelector' style='width:100%;height:25px;'></select>";
				    	jobRoleID = ""; jobRole = ""; jobRole2 = "";
				    }
					document.getElementById("JobRoleOption").innerHTML = rtnVal;
		    	}
			    
				});
		    
		    
		    }
		    
		    function jobChange(selectValue) {
		    	//var target = document.getElementById("titleSelector");
		    	//var option = target.options[target.options.selectedIndex];
		    	var option = selectValue.options[selectValue.options.selectedIndex];
		    	if (selectValue.id == 'titleSelector') {
		    		jobTitleID = option.id != "" ? option.id : "0";
			    	jobTitle = option.getAttribute("nmval");
			    	jobTitle2 = option.getAttribute("nmval2");
		    	} else {
		    		jobRoleID = option.id != "" ? option.id : "0";
		    		jobRole = option.getAttribute("nmval");
		    		jobRole2 = option.getAttribute("nmval2");
		    	}
		    }
			
			function jobCheck(cn, deptId, jobId, roleId){
				var result_data;
				
				$.ajax({
					type : "POST",
					url : "/admin/ezOrgan/getUserJobCheck",
					async : false,
					data : {cn : cn ,
							deptId : deptId,
							jobId : jobId, 
							roleId : roleId}, 
					success : function(data){
							result_data = data;
						}	
				});
				
				return result_data;
				
			}
	    </script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t67' /></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t69' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t97' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>	
	    <div id="menu">
	        <ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezOrgan.t167' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="closeWindow()"></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	    <table id="TreeViewTD" style="margin-top:25px;">
	        <tr>
	            <td>
	                <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea;">
	                    <div class="portlet_tabpart03_top" id="tab1">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
                                        <div style="padding-left:5px">
                                        <input type="text" name="Input" id="deptkeyword" style="WIDTH: 120px; height:22px;" onkeypress="deptsearch_press()">
                                        <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezOrgan.t93' /></span></a>
                                        </div>
	                                </td>
	                                <td>
	                                    <div style="float:right; height:25px;">
	                                        <select id="search_type" style="height:22px;">
	                                            <option selected value="displayname"><spring:message code='ezOrgan.t67' /></option>
					                            <option value="cn"><spring:message code='ezOrgan.t94' /></option>
					                            <option value="description"><spring:message code='ezOrgan.t68' /></option>
					                            <option value="title"><spring:message code='ezOrgan.t69' /></option>
					                            <option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
					                            <option value="mobile"><spring:message code='ezOrgan.t96' /></option>
					                            <option value="HomePhone"><spring:message code='ezOrgan.t97' /></option>
					                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98' /></option>
					                            <option value="mail"><spring:message code='ezOrgan.t99' /></option>
					                            <option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100' /></option>
	                                        </select>
	                                        <input type="text" id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; height:22px; margin: 0px;">
	                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101' /></span></a>&nbsp;
	                                    </div>
	                                </td>    
	                                <td></td>
	                            </tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 4px;">
	                    <tr>
	                        <td class="box">
	                            <div style="width: 250px; height: 472px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                        </td>
	                        <td></td>
	                        <td class="listview" style="width: 426px" id="orglistView">
	                            <table style="width: 100%; margin-top: -1px; height:35px" class="popup_mainlist">
	                                <tr>
	                                    <th style="white-space:normal;background-color: white;border-top:0px;border-bottom:1px solid #eaeaea">
											<span id="SelectDeptNM" style="font-weight: normal; width: 380px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                        <span style="float:right;">
	                                            <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                            <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                        </span>
	                                    </th>
	                                </tr>
	                            </table>
	                            <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 170px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t67' /></td>
	                                        <td style="width: 150px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t69' /></td>
	                                        <td class="td_gray" style="color:#333;background-color: #f8f8fa;"><spring:message code='ezOrgan.t97' /></td>
	                                    </tr>
	                                </table>
	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 130px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t68' /></td>
	                                        <td style="width: 90px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t67' /></td>
	                                        <td style="width: 90px; color:#333;background-color: #f8f8fa;" class="td_gray"><spring:message code='ezOrgan.t69' /></td>
	                                        <td class="td_gray" style="color:#333;background-color: #f8f8fa;"><spring:message code='ezOrgan.t97' /></td>
	                                    </tr>
	                                </table>
	                            </div>
	                            <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                    	</td>        
	                    </tr>
	                </table>
	            </td>        
	            <td style="text-align:center; padding-left:3px;">
	                <img src="../../../images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver()">
	                <img src="../../../images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()">
	            </td>
	            <td style="vertical-align:top; padding-top:4px; padding-left:3px;">
	                <table>
	                    <tr>
	                        <td>
	                            <h2 id="Addjob" class="receiver_tltype01">
	                                <span style="min-width: 45px;" id="AddjobStr"><spring:message code='ezOrgan.t205' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="UserAddJobList" style="width: 230px; Height: 476px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver()"></div>
	                            </div>
	                        </td>
	                    </tr>                    
	                </table>                                      
	            </td>
	        </tr>
	    </table>	
	    <div id="layer_popup" style="border:1px; border-color:black; position:absolute;left:300px;top:100px;background-color:#ffffff; display:none">
	        <div class="popupwrap1">
	            <div class="popupwrap2">                
	                <h2> * <spring:message code='ezOrgan.t199' /> / <spring:message code='ezOrgan.t234' /></h2>
	                <table class="content" style="width:300px">                    
	                    <tr>
	                        <td colspan="2" style="padding:0px; margin:0px;">
	                            <iframe id="TreeFrame" style="border:0px; height: 300px;" scrolling="auto"></iframe>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<th style="text-align:center">
	                    		<spring:message code='main.t77' />
	                    	</th>
	                    	<td>
	                    		<div id="JobTitleOption" style="width:225px;"></div>
	                    	</td>
	                    </tr>
	                    <tr>
	                    	<th style="text-align:center">
	                    		<spring:message code='ezOrgan.t1500' />
	                    	</th>
	                    	<td>
	                    		<div id="JobRoleOption" style="width:225px;"></div>
	                    	</td>
	                    </tr>
	                   <%--  <tr class="primary">
	                        <th style="text-align:center"><c:out value='${primary}'/></th>
	                        <td style="padding-left:1px;"><input id="txt_TitleName" type="text" style="width:98%" maxlength="50"></td>
	                    </tr>
	                    <tr class="secondary">
	                        <th style="text-align:center"><c:out value='${secondary}'/></th>
	                        <td style="padding-left:1px;"><input id="txt_TitleName2" type="text" style="width:98%" maxlength="50"></td>
	                    </tr> --%>
	                </table>
	                <div class="btnposition" style="width:300px">
	                <a id="btn_ok" class="imgbtn" onClick="btn_Add_onclick()"><span><spring:message code='ezOrgan.t110' /></span></a>
	                <a id="btn_cancel" class="imgbtn" onClick="btn_cancel_onclick()"><span><spring:message code='ezOrgan.t125' /></span></a>
	                </div> 
	            </div>
	        </div>
	    </div>  	       
	</body>	
</html>