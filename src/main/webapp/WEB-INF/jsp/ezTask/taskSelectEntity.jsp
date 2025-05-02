<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><c:out value = '${title }' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <style>
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
	    <script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>	    
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezTask/TreeView_Task.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezTask/ListView_list.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/NameControl.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
		var g_xmlHTTP = null;
	    var pListType = "TXT";
	    var pSeach = false;
	    var UserAgentState = navigator.userAgent.toLowerCase();
	    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	    var pListXML_Info = null;
	    var returnval = null;
	    var strLang_1 = "<spring:message code='ezTask.t190' />";
	    var type = "<c:out value='${type }'/>";
	    var primary = "<c:out value='${userInfo.primary}'/>";
	    var CurPage = "1";
	    var ReturnFunction;
	        
	    window.onload = function () {
	        try {
	            dialogArguments = opener.task_select_entity_cross_dialogArguments[0];
	            ReturnFunction = opener.task_select_entity_cross_dialogArguments[1];
	        } catch (e) { }

	        if (window.dialogArguments != "" && window.dialogArguments != null) {
	            var pparsingXML2 = "";
	            var pparsingXML = "";
	            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	            for (var i = 0; i < dialogArguments["id"].length; i++) {
	                pparsingXML = pparsingXML + "<ROW><CELL><DATA1><![CDATA[" + dialogArguments["name"][i] + "]]></DATA1>";
	                pparsingXML = pparsingXML + "<DATA2><![CDATA[" + dialogArguments["name2"][i] + "]]></DATA2>";
	                pparsingXML = pparsingXML + "<DATA3><![CDATA[" + dialogArguments["deptname"][i] + "]]></DATA3>";
	                pparsingXML = pparsingXML + "<DATA4><![CDATA[" + dialogArguments["deptname2"][i] + "]]></DATA4>";
	                pparsingXML = pparsingXML + "<DATA5><![CDATA[" + dialogArguments["id"][i] + "]]></DATA5>";
	                pparsingXML = pparsingXML + "<DATA6><![CDATA[" + dialogArguments["email"][i] + "]]></DATA6>";
	               
	                if (type == 1) {
		                pparsingXML = pparsingXML + "<NAME><![CDATA[" + "MsgToList" + "]]></NAME>";	                	
	                }
	                if (primary == 1) {
	                	pparsingXML = pparsingXML + "<VALUE><![CDATA[" + dialogArguments["name"][i] + " <" + dialogArguments["email"][i] + ">" + "]]></VALUE></CELL></ROW>";
	                } else {
	                	pparsingXML = pparsingXML + "<VALUE><![CDATA[" + dialogArguments["name2"][i] + " <" + dialogArguments["email"][i] + ">" + "]]></VALUE></CELL></ROW>";
	                }
	            }
	            
	            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	            returnval = loadXMLString(pparsingXML2);
	        }

	        var strQuery = "<DATA><DEPTID>${userinfo.deptID }</DEPTID><TOPID>Top</TOPID><PROP>displayName</PROP></DATA>";
	        var xmlHTTP = createXMLHttpRequest();
	        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	        xmlHTTP.send(strQuery);

	        var xmlHTTP = createXMLHttpRequest();
	        var xmlpara = createXmlDom();

	        var objNode;
	        createNodeInsert(xmlpara, objNode, "DATA");
	        createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID }");
	        createNodeAndInsertText(xmlpara, objNode, "TOPID", "${userInfo.companyID }");
	        createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");

	        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	        xmlHTTP.send(xmlpara);

	        var xmlTree = loadXMLString(xmlHTTP.responseText);
	        var treeXML = loadXMLFile("/xml/organtree_config3.xml");

	        document.getElementById('TreeView').innerHTML = "";
	        var treeView = new TreeView();
	        treeView.SetConfig(treeXML);
	        treeView.SetID("FromTreeView");
	        treeView.SetUseAgency(true);
	        treeView.SetRequestData("RequestData");
	        treeView.SetNodeClick("TreeViewNodeClick");
	        treeView.DataSource(xmlTree);
	        treeView.DataBind("TreeView");

	        ListTypeChangeIcon();
	        recevieListview("MsgToList", "ListViewMsgTo");

	        if (type == "1")
	            document.getElementById("ToTitleStr").innerHTML = "<spring:message code='ezTask.t2005' />";
	        else
	            document.getElementById("ToTitleStr").innerHTML = "<spring:message code='ezTask.t137' />";
	            
	        ChangeListView_onClick(getOrganListType());
	    }
	    function TreeViewNodeClick() {
	        issearch = false;
	        CurPage = "1";
	        p_ListOrderObject = "";
	        var treeView = new TreeView();
	        treeView.LoadFromID("FromTreeView");
	        var nodeIdx = treeView.GetSelectNode();
	        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:top;padding-right:3px;\" >"
	    		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
	    		+ "<span id='countInfo'></span>";
	        SelectDeptNM.setAttribute("countinfo", "")
	        displayUserList(nodeIdx.GetNodeData("CN"));
	        listContentArry = new Array();
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
	            }
	            else {
	                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	            }
	        }
	        var treeView = new TreeView();
	        treeView.LoadFromID("FromTreeView");
	        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
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
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezTask.t193'/>");
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
	    
	    function search_press(evt) {
	        if (window.event) {
	            if (window.event.keyCode == 13) {
	                search_click("search");
	            }
	        }
	        else {
	            if (evt.which == 13)
	                search_click("search");
	        }
	    }
	    var issearch = false;
	    function search_click(type) {
	    	// 목록에서 선택만 한 후 검색하여 추가 시 error 수정
	    	listContentArry = new Array();

	        if (document.getElementById("keyword").value == "" || $.trim($("#keyword").val()) == "") {
	            alert("<spring:message code='ezTask.t990' />");
	            document.getElementById("keyword").focus();
	            return;
	        }
	        if (type == "search") {
	            CurPage = "1";
	            issearch = true;
	        }
	        if (document.getElementById("search_type").value == "description") {
	            deptsearch_click();
	            return;
	        }

	        $.ajax({
				url : '/ezOrgan/getSearchList.do',
				method : 'POST',
				dataType : "text",
				data : {
					search : document.getElementById("search_type").value + "::" + document.getElementById("keyword").value,
					cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
					prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
					page : CurPage ,
					type : "user"
				} ,
					success : function(xml) {
						event_displayUserList2(xml);
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezTask.t193' />");
				}
			});
	     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
            PressShiftKey = false;
	    }
	
	    var rgParams = new Array();
	    var checkname2_cross_dialogArguments = new Array();
	    function deptsearch_click() {
	        if (document.getElementById("keyword").value == "") {
	            alert("<spring:message code='ezTask.t990' />");
	            document.getElementById("keyword").focus();
	            return;
	        }
// 	        var objNode;
// 	        var xmlHTTP = createXMLHttpRequest();
// 	        var xmlDom = createXmlDom();
// 	        createNodeInsert(xmlDom, objNode, "DATA");
// 	        createNodeAndInsertText(xmlDom, objNode, "SEARCH", "displayName::" + document.getElementById("keyword").value);
// 	        createNodeAndInsertText(xmlDom, objNode, "CELL", "extensionAttribute3;displayName;extensionAttribute9;");
// 	        createNodeAndInsertText(xmlDom, objNode, "PROP", "");
// 	        createNodeAndInsertText(xmlDom, objNode, "TYPE", "group");
// 	        try {
// 	            xmlHTTP.open("POST", "/ezOrgan/getSearchList.do", false);
// 	            xmlHTTP.send(xmlDom);
// 	            if (xmlHTTP.statusText != "OK") {
// 	                alert("<spring:message code='ezTask.t195' />" + xmlHTTP.statusText);
// 	                xmlDom = null;
// 	                xmlHTTP = null;
// 	            }
// 	            else {
// 	                xmlDom = loadXMLString(xmlHTTP.responseText)
// 	                adCount = xmlDom.getElementsByTagName("ROW").length;
// 	            }
// 	        }
// 	        catch (e) {
// 	            alert("<spring:message code='ezTask.t195' />" + e.description);
// 	            xmlDom = null;
// 	            xmlHTTP = null;
// 	        }

			var xmlDom = createXmlDom();
			var adCount = "";
			$.ajax({
				url : '/ezOrgan/getSearchList.do',
				method : 'POST',
				dataType : "text",
				async : false,
				data : {
					search : "displayName::" + document.getElementById("keyword").value,
					cell : "extensionAttribute3;displayName;extensionAttribute9;",
					prop : "",
					type : "group"
				} ,
					success : function(xml) {
						xmlDom = loadXMLString(xml);
						adCount = xmlDom.getElementsByTagName("ROW").length;					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezTask.t195' />");
				}
			});

			if (adCount == 0) {
	            alert("<spring:message code='ezTask.t192' />");
	            return;
	        }
	        else if (adCount == 1) {
	            bSearch = true;
	            g_xmlHTTP = createXMLHttpRequest();

	            var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDom.getElementsByTagName("DATA2").item(0)) + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	            
	            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            g_xmlHTTP.send(strQuery);
	        }
	        else {
	            rgParams["addrBook"] = xmlDom;
	            rgParams["deptid"] = "";

	            checkname2_cross_dialogArguments[0] = rgParams;	            
	            checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;

	            if (CrossYN()) {
	            	/* 2018-04-26 김민성 - 중복 부서 검색시 팝업창 뜨도록 수정  */
	                //DivPopUpShow(595, 310, "/ezTask/taskCheckName2.do");
	                var OpenWin = window.open("/ezTask/taskCheckName2.do", "checkname2_cross", GetOpenWindowfeature(600, 320));
	             	 OpenWin.focus();
	            }
	            else {
	                var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	                feature = feature + GetShowModalPosition(540, 460);
	                window.showModalDialog("/ezTask/taskCheckName2.do", rgParams, feature);

	                if (rgParams["deptid"] != "") {
	                    bSearch = true;
	                    g_xmlHTTP = createXMLHttpRequest();
	                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                    g_xmlHTTP.send(strQuery);
	                }
	            }
	        }
	    }

	    function deptsearch_click_Complete(retVal) {

	        if (retVal == "dontprocess") {
	        }
	        else if (retVal == "delete") {
	        }
	        else
	        {
	            bSearch = true;
	            g_xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><DEPTID>" + retVal + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            g_xmlHTTP.send(strQuery);
	        }
	        DivPopUpHidden();

	    }

	    function event_displayUserList2(xml) {    	
            var ResposeXML = loadXMLString(xml);
            if (ResposeXML.getElementsByTagName("ROW").length == 0) {
                alert("<spring:message code='ezTask.t196' />");	                	
            } else {     	
                pListXML_Info = ResposeXML;
                pSeach = true;
                DisplayUserImageList();
                makePageSelPage();
            }
            g_xmlHTTP = null;
	    }
	    function infoview_click() {
	        if (p_ListOrderObject == null || p_ListOrderObject == "") {
	            alert("<spring:message code='ezTask.t12' />"); 
	            return;
	        }
	        var id = GetAttribute(p_ListOrderObject,"_DATA2");
	        /* var dept = GetAttribute(p_ListOrderObject,"_DATA11"); */
	        var dept = $('.node_selected').parent().attr("cn");
	        var feature = GetOpenPosition(420, 450);
	        
	        if (CrossYN())
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        else
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    }
	    function event_getDeptFullTree() {
	        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	            if (g_xmlHTTP.status == 200) {
	                setNodeText(document.getElementById("TreeView"), "");

	                var xmlDom = createXmlDom();
	                xmlDom = loadXMLFile("/xml/organtree_config3.xml");

	                var treeView = new TreeView();
	                treeView.SetID("FromTreeView");
	                treeView.SetConfig(xmlDom);
	                treeView.SetUseAgency(true);
	                treeView.SetRequestData("RequestData");
	                treeView.SetNodeClick("TreeViewNodeClick");
	                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
	                treeView.DataBind("TreeView");
	                treeView = null;
	            }
	            else {
	                alert("<spring:message code='ezTask.t193' />" + g_xmlHTTP.status)
	                g_xmlHTTP = null;
	            }
	        }
	    }

	    function close_onclick() {
	        var rtn = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

	        var listview = new ListView();
	        listview.LoadFromID("MsgToList");

	        for (var i = 0; i < listview.GetRowCount(); i++) {
	            rtn["name"][i] = GetAttribute(listview.GetDataRows()[i],"DATA1");
	            rtn["name1"][i] = GetAttribute(listview.GetDataRows()[i],"DATA1");
	            rtn["name2"][i] = GetAttribute(listview.GetDataRows()[i],"DATA2");
	            rtn["id"][i] = GetAttribute(listview.GetDataRows()[i],"DATA5");
	            rtn["deptname"][i] = GetAttribute(listview.GetDataRows()[i],"DATA3");
	            rtn["deptname2"][i] = GetAttribute(listview.GetDataRows()[i],"DATA4");
	            rtn["email"][i] = GetAttribute(listview.GetDataRows()[i],"DATA6");
	        }
	     
	        if (ReturnFunction != null) {
	        	ReturnFunction(rtn);
	        } else {
	        	window.returnValue = rtn;
	        } 
	    }

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
	        /* if (SelectDeptNM.getAttribute("countinfo") != "1" && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) != null && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])!= "") {
	            if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang43 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang43 + "</span>]";
	        		}
	            
	            SelectDeptNM.setAttribute("countinfo", "1")
	        } */
	        
	        if (pListType == "IMG") {
	            document.getElementById("DeptUserImgList").style.display = "";
	            document.getElementById("txtlist_Layer").style.display = "none";
	            document.getElementById("txtlist_table").style.display = "none";
	            document.getElementById("Search_txtlist_table").style.display = "none";
	            
	            if (pSeach) {
	                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + strLang44 + "</span>" + "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>" + SelectSingleNodeValueNew(xmlRtn,"LISTVIEWDATA/TOTALCOUNT") + "</span></span>";
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
                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + strLang44 + "</span>" + "<span id='countInfo' class='txt_color'>&nbsp;&nbsp;<span class='txt_color'>" + SelectSingleNodeValueNew(xmlRtn,"LISTVIEWDATA/TOTALCOUNT") + "</span></span>";
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
                    M_TR.ondblclick = function () { event_listDBclick(this); };
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
                    M_TR.ondblclick = function () { event_listDBclick(this); };
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

	    var listContentArry = new Array();
	    var listEventCheckbox = false;
	    var listSubEventCheckbox = false;
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
	                    PrelistContent = GetAttribute(p_ListOrderObject,"id");
	                else
	                    PrelistContent = GetAttribute(SelectedPreObj,"id");

	                p_ListOrderObject = obj;

	                var CurlistContent = GetAttribute(obj,"id");
	                var PrePoint = parseInt(PrelistContent.replace("MailUserlist_", ""));
	                var CurPoint = parseInt(CurlistContent.replace("MailUserlist_", ""));
	                if (PrePoint < CurPoint) {

	                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
	                        p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                        }
	                        listContentArry[listContentArry.length] = GetAttribute(p_ListOrderObject,"id");
	                    }

	                }
	                else if (PrePoint > CurPoint) {
	                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                        p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                        }
	                        listContentArry[listContentArry.length] = GetAttribute(p_ListOrderObject,"id");
	                    }
	                }
	                else
	                    return;

	            }
	            else {
	                p_ListOrderObject = obj;
	                var insertFlag = true;
	                for (var i = 0; i < listContentArry.length; i++) {
	                    if (listContentArry[i] == GetAttribute(p_ListOrderObject,"id")) {
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

	                    listContentArry[listContentArry.length] = GetAttribute(p_ListOrderObject,"id");
	                }
	            }
	        }
	        else
	            listEventCheckbox = false;
	    }
	    function event_listDBclick(obj) {
	        InsertUser();
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
	        setOrganListType(pListType);
	    }

	    function InsertUser() {
	    	
            if (p_ListOrderObject == "") {
                alert("<spring:message code='ezSchedule.t1053' />");
                return;
            }
            
	    	// 공유자
	    	if (type == 2) {
		        for (var i = 0; i < listContentArry.length; i++) {
		            var strUserid = GetAttribute(document.getElementById(listContentArry[i]),"_data2");
		            var strName = GetAttribute(document.getElementById(listContentArry[i]),"_data10");
		            var strName2 = GetAttribute(document.getElementById(listContentArry[i]),"_data11");
		            var strDeptNM = GetAttribute(document.getElementById(listContentArry[i]),"_data12");
		            var strDeptNM2 = GetAttribute(document.getElementById(listContentArry[i]),"_data13");
		            var strEmail = GetAttribute(document.getElementById(listContentArry[i]),"_data3");
		           
		            var getlistview = new ListView();
		            getlistview.LoadFromID("MsgToList");
		            var bFlag = getlistview.ExistRow("DATA6", strEmail);

		            if (bFlag) {
		                continue;
		            } else if (strUserid == "${userInfo.id }"){
		                alert("<spring:message code='ezTask.t199' />");
		            } else {
		                pparsingXML2 = "";
		                pparsingXML = "";
		                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
		                pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName2) + "</DATA2>";
		                pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(strDeptNM) + "</DATA3>";
		                pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(strDeptNM2) + "</DATA4>";
		                pparsingXML = pparsingXML + "<DATA5>" + strUserid + "</DATA5>";
		                pparsingXML = pparsingXML + "<DATA6>" + strEmail + "</DATA6>";
		              
		                if (primary == 1) {
			                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		                } else {
		                	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName2) + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		                }
		                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                Resultxml = loadXMLString(pparsingXML2);

		                var listview = new ListView();
		                listview.LoadFromID("MsgToList");

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
		                var trid = listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1);
	                
		                SetAttribute(objTr, "id", trid);
		                listview.AddDataRow(objTr, Resultxml);
		                document.getElementById(trid).style.whiteSpace = "nowrap";
		            }
		        }
		    // 담당자
	    	} else {
	    		if (listContentArry.length > 1) {
	    			alert("<spring:message code='ezTask.jsh09' />");
	        		return;
	    		}

	    		if (listContentArry.length != 0) {
		            var strUserid = GetAttribute(document.getElementById(listContentArry[0]),"_data2");
		            var strName = GetAttribute(document.getElementById(listContentArry[0]),"_data10");
		            var strName2 = GetAttribute(document.getElementById(listContentArry[0]),"_data11");
		            var strDeptNM = GetAttribute(document.getElementById(listContentArry[0]),"_data12");
		            var strDeptNM2 = GetAttribute(document.getElementById(listContentArry[0]),"_data13");
		            var strEmail = GetAttribute(document.getElementById(listContentArry[0]),"_data3");
		            		            
		            var getlistview = new ListView();
		            getlistview.LoadFromID("MsgToList");
		            var bFlag = getlistview.ExistRow("DATA6", strEmail);
	
		            if (bFlag) {
	// 	                continue;
		            } else if (strUserid == "${userInfo.id }"){
		                alert("<spring:message code='ezTask.t199' />");
		            } else {
			    		var listid = "MsgToList";
				        var selList = new ListView();
				        selList.LoadFromID(listid);
		
				        var arrRows = selList.GetDataRows();
		
			            // 담당자로 한명을 선택 후 다른 사람을 다시 선택하면 기존의 값 삭제
			            if (arrRows.length > 0) {
			    			$("tr[name=MsgToList]").remove();
			    		}
		
		                pparsingXML2 = "";
		                pparsingXML = "";
		                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
		                pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName2) + "</DATA2>";
		                pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(strDeptNM) + "</DATA3>";
		                pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(strDeptNM2) + "</DATA4>";
		                pparsingXML = pparsingXML + "<DATA5>" + strUserid + "</DATA5>";
		                pparsingXML = pparsingXML + "<DATA6>" + strEmail + "</DATA6>";
		                
		                if (primary == 1) {
			                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		                } else {
		                	pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName2) + " &lt;" + strEmail + "&gt;" + "</VALUE></CELL></ROW>";
		                }
		                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                Resultxml = loadXMLString(pparsingXML2);
		
		                var listview = new ListView();
		                listview.LoadFromID("MsgToList");
		
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
		                var trid = listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1);
		                
		                SetAttribute(objTr, "id", trid);
		                SetAttribute(objTr, "name", "MsgToList");
		                listview.AddDataRow(objTr, Resultxml);
		                document.getElementById(trid).style.whiteSpace = "nowrap";
		            }
	    		}
	    	}
	    }

	    function recevieListview(pID, pListView) {
	        var listview = new ListView();
	        listview.SetID(pID);
	        listview.SetSelectFlag(false);
	        listview.SetMulSelectable(true);
	        listview.SetRowOnDblClick("DeleteUser");
	        if (returnval != null) {
	            listview.DataSource(returnval);
	        } else {
		        listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	        }

	        listview.DataBind(pListView);
	        listview.RowDataBind();

	        for (var i = 0; i < listview.GetRowCount(); i++) {
	            listview.GetDataRows()[i].style.whiteSpace = "nowrap";
	        }
	        document.getElementById(pID).className = "receiver_list";
	    }

	    function DeleteUser() {
	        var listid = "MsgToList";
	        var selList = new ListView();
	        selList.LoadFromID(listid);

	        var arrRows = selList.GetSelectedRows();
	        var strName = "";

	        for (var i = 0; i < arrRows.length; i++) {
	            selList.DeleteRow(arrRows[i].id);
	        }
	    }
	    function keyword_Clear() {
	        document.getElementsByName('keyword').value = "";
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
	        InsertUser(element);
	    }
	    function MakeXMLString(pOrgString) {
	        if (pOrgString == undefined) return;
	        return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
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
	        }
	        else {
	            strtext = "<span class='btnimg first disabled'></span>"
	            PagingHTML += strtext;
	        }
	        if (totalPage > BlockSize) {
	            if (pageNum > BlockSize) {
	                strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span class='btnimg prev disabled'></span>";
	                PagingHTML += strtext;
	            }
	        }
	        else {
	            strtext = "<span class='btnimg prev disabled'></span>";
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

	        // 페이지에 아무것도 없을 때 1 나오게 수정
	        if (i == 1) {
            	strtext = "<span class='on'>" + i + "</span>";
                PagingHTML += strtext;
            }

	        if (totalPage > BlockSize) {
	            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	            }
	        }
	        else {
	            strtext = "";
	            strtext = strtext + "<span class='btnimg next disabled'></span>";
	            PagingHTML += strtext;
	        }
	        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg last disabled'></span>";
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
	</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<h1 id="h1Title"><c:out value="${title}" /></h1>
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
	                    	<td>
	                            <div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 4px;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
	                                    <table style="margin-top: 3px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                <div style="margin-left: 5px;">
	                                                    <select id="search_type" style="height:22px">
	                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezTask.t17' /></option>
	                                                        <option value="description" usedefault="1"><spring:message code='ezTask.t15' /></option>
	                                                        <option value="title" usedefault="1"><spring:message code='ezTask.t201' /></option>
	                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezTask.t1000' /></option>
	                                                        <option value="mobile" usedefault="0"><spring:message code='ezTask.t1001' /></option>
	                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezTask.t202' /></option>
	                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezTask.t1005' /></option>
	                                                        <c:if test="${primaryLang eq '3' }">
		                                                    <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
		                                                    <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
		                                                    </c:if>
	                                                        <option value="mail" usedefault="0"><spring:message code='ezTask.t1002' /></option>
	                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezTask.t1003' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px; height:24px">
	                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezTask.t183' /></span></a>
	                                                </div>
	                                            </td>
	                                            <td>
	                                                <div style="float: right; margin-right: 5px; position:relative;">
	                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezTask.t1004' /></span></a>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </div>
	                            </div>
	                            <table style="margin-top: 3px;">
	                                <tr>
	                                    <td class="box" style="border-right:0px">
	                                        <div style="width: 220px; height: 505px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                                    </td>
	                                    <td></td>
	                                    <td class="listview" style="width: 426px" id="orglistView">
	                                        <table style="width: 100%; margin-top: -1px; height:35px;" class="popup_mainlist">
	                                            <tr>
	                                                <th style="white-space:normal;background-color: white;border-top:0px solid #ddd;border-bottom:1px solid #eaeaea">
	                                                    <span id="SelectDeptNM" style="font-weight: normal; width: 380px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                                    <span style="float:right; position:relative;">
	                                                        <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 426px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 150px;color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezTask.t17' /></td>
	                                                    <td style="width: 130px;color:#333;background-color: #f8f8fa"><spring:message code='ezTask.t201' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezTask.t1000' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 130px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezTask.t15' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezTask.t17' /></td>
	                                                    <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezTask.t201' /></td>
	                                                    <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezTask.t1000' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 426px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                                        <div id="tblPageRayer" style="text-align:center;"></div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">                            
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertUser(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteUser(ListViewMsgTo)">
	                        </td>
	                        <td style="vertical-align: top;">
	                            <h2 id="ToTitle" class="receiver_tltype01" style="cursor: pointer;">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezTask.t137' /></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 503px; overflow-x: auto; overflow-y: auto;"  ondblclick="DeleteUser(ListViewMsgTo)"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
	    	</tr> 
	 	</table>	    
		<div class="btnposition btnpositionNew">
	    	<a class="imgbtn" onClick="close_onclick()" ><span><spring:message code='ezTask.t19' /></span></a>
		</div>
	</body>
</html>