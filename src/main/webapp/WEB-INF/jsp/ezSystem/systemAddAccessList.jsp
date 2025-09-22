<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSystem.jje20'/></title>
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
	    	.txt_color {
	    		color:#017BEC;
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
		    var preObj = "";
		    var adminChk = "<c:out value='${adminChk}'/>"
		    
		    $(document).ready(function(){
		    	try {
	                ReturnFunction = opener.addjob_config_dialogArguments[1];
	            } catch (e) {}
	            
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
		        } catch (e) { }
		        
		        var strQuery = "<DATA><DEPTID><c:out value='${userInfo.deptID}'/></DEPTID><TOPID>" + topid + "</TOPID><PROP></PROP><ADMINCHK>" + adminChk + "</ADMINCHK><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	
		        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        xmlHTTP.onreadystatechange = event_GetDeptTreeInfo;
		        xmlHTTP.send(strQuery);
	
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
		    	p_ListOrderObject = null;
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
		        SelectDeptNM.setAttribute("countinfo", "")

		        displayUserList(nodeIdx.GetNodeData("CN"));
		    }
		    
		    function displayUserList(DeptID) {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", type : "user"},
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
	        	//InsertReceiver();
	        	btn_Add_onclick();
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
	                    LISTVIEWDATA = LISTVIEWDATA + "</ROWS></LISTVIEWDATA>";
	                    
	                    //document.getElementById('UserAddJobList').innerHTML = "";
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
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<spring:message code='ezOrgan.t101' />" + "" + "&nbsp;&nbsp;<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "</span>";
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<spring:message code='ezOrgan.t101' />" + "" + "&nbsp;&nbsp;<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "</span>";
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
		        document.getElementById("txt_TitleName").value = "";
		        document.getElementById("txt_TitleName2").value = "";
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
		        			prop  : "department"
		        		},
		        		success: function(xml){
		        			result = xml;
		        		}        			
		        	});
		        	
		            ReceiveDocument = SelectSingleNodeValueNew(loadXMLString(result), "DATA/DEPARTMENT");
		        } catch (e) {
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
		        	
		            var dept = new Array();
		            
		            for (var i = 0; i < listContentArry.length; i++) {
		            	dept[i] = document.getElementById(listContentArry[i]).getAttribute("_data13");
		            }
		            
		            if (dept[0] == "") {
		                alert("<spring:message code='ezOrgan.t249' />");
		                return;
		            }
		            
		            //var listview = new ListView();
		            //listview.LoadFromID("lvUserList");
		            //var UserAddjoblistview = new ListView();
		            //UserAddjoblistview.LoadFromID("lvAddjobList");
		            //var bFlag = UserAddjoblistview.ExistRow("data1", dept[0]);
		            var bFlag = false;
		            
		            
		            if (!bFlag) {
    		            var cn = GetAttribute(p_ListOrderObject, "_data2");
    		            var orgDeptId = getDeptId(cn);
    		            var selectedList = document.getElementById("lvAddjobList").childNodes[1].childNodes;
    		            
    		            for (var i = 0; i < selectedList.length; i++) {
    		            	if (selectedList[i].getAttribute("data1") == cn) {
    		            		bFlag = true;
    		            	}
    		            }
    		            
    		            var accessList = window.opener.allComJson;
    		            
    		            for (var i = 0; i < accessList.length; i++) {
    		            	if (accessList[i].cn == cn) {
    		            		bFlag = true;
    		            	}
    		            }
		        	}
		            
		            if (bFlag) {
		                alert(strLang25);
		                pAddFlag = true;
		            } else {
		                pparsingXML2 = "";
		                pparsingXML = "";
		                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                pparsingXML = pparsingXML + "<ROW><CELL>";
		                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(GetAttribute(p_ListOrderObject, "_data4")) + "</VALUE>";
		                pparsingXML = pparsingXML + "<DATA1>" + MakeXMLString(GetAttribute(p_ListOrderObject, "_data2")) + "</DATA1>";
		                pparsingXML = pparsingXML + "<DATA2>" + getDeptId(GetAttribute(p_ListOrderObject, "_data2")) + "</DATA2>";
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
		                SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                listview.AddDataRow(objTr, Resultxml);

		                var _tdlength = document.getElementById("lvAddjobList").getElementsByTagName("TD").length;
		                for (var y = 0; y < _tdlength; y++) {
		                    document.getElementById("lvAddjobList").getElementsByTagName("TD")[y].style.textOverflow = "";
		                    document.getElementById("lvAddjobList").getElementsByTagName("TD")[y].style.overflow = "";
		                }
		            }
		        }
		    }
		    
		    function OK_Click() {
		    	
		    	if (document.getElementById("lvAddjobList") == null || document.getElementById("lvAddjobList") == undefined) {
		    		alert("<spring:message code='ezOrgan.kyj05'/>");
		    		return;
		    	}
		    	
	            var accessList = document.getElementById("lvAddjobList").childNodes[1].childNodes;
	            var strCnList = "";
	            
	            if (accessList.length == 0 || accessList == null) {
	            	alert("<spring:message code='ezOrgan.kyj05'/>");
	            	return;
	            }
	             
	            for (var i = 0; i < accessList.length; i++) {
	            	strCnList += accessList[i].getAttribute("data1");
	            	
	            	if (accessList.length -1 > i) {
	            		strCnList += ";";
	            	}
	            }
	            
	            $.ajax({
					type : "POST",
					url : "/ezSystem/insertAccessId?strCnList=" + strCnList,
					error : function(data) {
						console.log("<spring:message code='ezSystem.jje17'/>");
					},
					complete : function(data) {
						alert("<spring:message code='ezApprovalG.t1581'/>");
						window.opener.IPBandListRemove();
						window.opener.getAccessList_http(window.opener.document.getElementById("ListCompany").value);
						window.close();
				    }
				});
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
		        	data : {search : "displayname::" + document.all("deptkeyword").value, cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "cn", type : 'group'},
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
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>" + topid + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            } else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>" + topid + "</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
		                try { OpenWin.focus(); } catch (e) { }
		            }else{
		                var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(600, 320);
		                window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
		                    } catch (e) { }
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
		        	data : {search : document.getElementById("search_type").value + "::" + document.getElementById("keyword").value, cell : "company;description;displayname;title;telephonenumber;" + document.getElementById("search_type").value, 
		        			prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", type : "user", "company" : topid},
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
		    
		    function dept_select() {
		    	
		    	var selectedDept = $(".node_selected")[0].parentNode;
		    	var deptcn = selectedDept.getAttribute("cn");
		    	var deptname = selectedDept.getAttribute("nodename");
		    	
		    	if (selectedDept == null) {
		    		alert("<spring:message code='ezApprovalG.t1126'/>");
		    		return;
		    	}
		    	
		    	var bFlag = false;
		    	
		    	if (document.getElementById("lvAddjobList") != null) {
		    		var selectedList = document.getElementById("lvAddjobList").childNodes[1].childNodes;
		            
		            for (var i = 0; i < selectedList.length; i++) {
		            	if (selectedList[i].getAttribute("data1") == deptcn) {
		            		bFlag = true;
		            	}
		            }
		    	}
	            var accessList = window.opener.allComJson;
	            
	            for (var i = 0; i < accessList.length; i++) {
	            	if (accessList[i].cn == deptcn) {
	            		bFlag = true;
	            	}
	            }
	            
	            if (bFlag) {
	                alert(strLang25);
	                pAddFlag = true;
	            } else {
	            	
	            	Addjob_Check(deptcn);
	            	
	                pparsingXML2 = "";
	                pparsingXML = "";
	                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                pparsingXML = pparsingXML + "<ROW><CELL>";
	                pparsingXML = pparsingXML + "<VALUE>" + deptname + "</VALUE>";
	                pparsingXML = pparsingXML + "<DATA1>" + deptcn + "</DATA1>";
	                pparsingXML = pparsingXML + "<DATA2>" + deptname + "</DATA2>";
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
	                SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                listview.AddDataRow(objTr, Resultxml);

	                var _tdlength = document.getElementById("lvAddjobList").getElementsByTagName("TD").length;
	                for (var y = 0; y < _tdlength; y++) {
	                    document.getElementById("lvAddjobList").getElementsByTagName("TD")[y].style.textOverflow = "";
	                    document.getElementById("lvAddjobList").getElementsByTagName("TD")[y].style.overflow = "";
	                }
	            }
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
		    
	        function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezSchedule.t1053'/>");
	                return;
	            }
	            
	            var clickList = $("#txtlist_Layer tr[id^=MailUserlist_]");
	            
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var rtn
	            var width = 420, height = 450;
	            var leftPosition, topPosition;
	            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
	                                    <div style="padding-left:5px; height:25px;">
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
	                                <td>
	                                	<div style="float: right; margin-right: 5px; position: relative;">
                                            <a class="imgbtn" id="dept_select"><span onclick="dept_select()" style="z-index:10"><spring:message code='ezEmail.t596'/></span></a>
                                            <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597'/></span></a>
                                        </div>
                                    </td>
	                            </tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 4px;">
	                    <tr>
	                        <td class="box">
	                            <div style="width: 250px; height: 465px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
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
	                <img src="../../../images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="btn_Add_onclick()">
	                <img src="../../../images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()">
	            </td>
	            <td style="vertical-align:top; padding-top:4px; padding-left:3px;">
	                <table>
	                    <tr>
	                        <td>
	                            <h2 id="Addjob" class="receiver_tltype01">
	                                <span style="min-width: 45px;" id="AddjobStr"><spring:message code='ezSystem.jje2'/></span>
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
	</body>	
</html>