<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t12" /></title>
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/css/organ_tree.css" />
		<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezResource/control/TreeView.js"></script> 
		<script type="text/javascript" src="/js/ezResource/control/ListView_list.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/NameControl.js"></script>
		<script type="text/javascript">
			var bSearch = false;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var ReturnFunction;

	        document.onselectstart = function () { return false; };
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
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
	                ReturnFunction = opener.gwboard_post_regboardright_dialogArguments[1];
	            }
	            catch (e) {
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
	                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "");
	                xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	                xmlHTTP.send(xmlpara);
	                xmlTree = loadXMLString(xmlHTTP.responseText);
	                var treeXML = loadXMLFile("/xml/ezResource/organtree_config3.xml");
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

	            if (window.dialogArguments != "" && window.dialogArguments != null) {
	                var listView = new ListView();
	                listView.LoadFromID("MsgToList");

	                var totalRows = listView.GetDataRows();
	                var totalLen = totalRows.length;

	                for (var i = 0; i < window.dialogArguments["id"].length; i++) {
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";

	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>"

	                    var strName = window.dialogArguments["name"][i];
	                    var strJikwe = window.dialogArguments["jikwe"][i];
	                    var strPhone = window.dialogArguments["phone"][i];
	                    var strId = window.dialogArguments["id"][i];
	                    var strName1 = window.dialogArguments["name1"][i];
	                    var strName2 = window.dialogArguments["name2"][i];
	                    var strDeptName1 = window.dialogArguments["deptname"][i];
	                    var strDeptName2 = window.dialogArguments["deptname2"][i];

	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                    pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName1 + "]]></DATA2>";
	                    pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
	                    pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptName1 + "]]></DATA4>";
	                    pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptName2 + "]]></DATA5>";
	                    pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
	                    pparsingXML = pparsingXML + "<DATA7>" + strJikwe + "</DATA7>";
	                    pparsingXML = pparsingXML + "<DATA8>" + strPhone + "</DATA8>";
	                    pparsingXML = pparsingXML + "<VALUE>" + strName1 + "</VALUE></CELL></ROW>";

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

	        function Add_UserInfo_onclick() {
	            var listView = new ListView();
	            listView.LoadFromID("MsgToList");

	            var totalRows = listView.GetDataRows();
	            var totalLen = totalRows.length;

	            if (totalLen == 0) {
	                alert("<spring:message code="ezResource.t169" />");
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

	            if (CrossYN())
	                var reParam = window.showModalDialog("/admin/ezResource/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no");
	            else
	                var reParam = window.showModalDialog("/admin/ezResource/scheduleAddUser.do?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no");

	            if (typeof (reParam) != "undefined" && reParam != null) {
	                idDatepicker.vtLocalDate = reParam["startTime"];
	                idDatepicker.vtLocalEndDate = reParam["endTime"];

	                if (reParam["entryList"] != "") {
	                    xmpEntryEmailList.innerText = reParam["entryList"];

	                    DisplayEntryList();
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
	            p_ListOrderObject = "";
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	        function displayUserList(DeptID) {
	        	listContentArry = new Array();

	        	$.ajax({
	        		type : "POST",
	        		dataType : "xml",
	        		async : true,
	        		url : "/ezOrgan/getDeptMemberList.do",
	        		data : {
	        				deptID   : DeptID, 
	        				cell 	 : "company;description;displayName;title;telephoneNumber",
	        				prop   : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
	        				type 	 : "user"
	        				},
	        		success: function(result){

	        			pListXML_Info = loadXMLString(result);
						pSeach = false;
						//DisplayUserImageList(result);
alert("result:"+pListXML_Info);
						     var xmlRtn = result;
	                document.getElementById("DeptUserImgList").innerHTML = "";
	                document.getElementById("txtlist_Layer").scrollTop = "0";
	                document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes
	                while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                    document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	                }
	                while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                    document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	                }
	                var UserListHTML = "";
	                if (SelectDeptNM.getAttribute("countinfo") != "1") {
	                    SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang400 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	                if (pListType == "IMG") {
	                    document.getElementById("DeptUserImgList").style.display = "";
	                    document.getElementById("txtlist_Layer").style.display = "none";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                    if (pSeach) {
	                        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang401 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang400 + "</span>]";
	                        SelectDeptNM.setAttribute("countinfo", "1")
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
	                        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang401 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang400 + "</span>]";
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

	                            for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
	                                if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
	                                    M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
	                                                      trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
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

	                        var Sub_TR1 = document.createElement("TR");
	                        var Sub_TD1 = document.createElement("TD");
	                        Sub_TD1.style.textAlign = "left";
	                        Sub_TD1.setAttribute("class", "name");
	                        var pDisplayName = "";
	                        var useOCS = "${useOCS}";
	                        if (useOCS == "YES") {
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
	                    Sub_TD3_Img.setAttribute("src", "/images/organtree/icon_hp.gif");
	                    Sub_TD3.appendChild(Sub_TD3_Img);
	                    Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
	                    Sub_TR3.appendChild(Sub_TD3);

	                    var Sub_TR4 = document.createElement("TR");
	                    var Sub_TD4 = document.createElement("TD");
	                    Sub_TD4.style.textAlign = "left";
	                    var Sub_TD4_Img = document.createElement("IMG");
	                    Sub_TD4_Img.setAttribute("class", "icon");
	                    Sub_TD4_Img.setAttribute("src", "/images/organtree/icon_mail.gif");
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
	                    
alert("length:"+SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length);
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
	                        
	                        var useOCS = "${useOCS}";
	                        if (useOCS == "YES") {
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
	                    	
	                    	var useOCS = "${useOCS}";
	                    	if (useOCS == "YES") {
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
	        	});
	        }
	        
	        function xmlToString(xml) {
	        	return (new XMLSerializer()).serializeToString(xml);
	        }
	       
	        
	        function event_displayUserList(xml) {
	            if (xml != null) {
alert(xmlToString(xml));
					pListXML_Info = loadXMLString(xmlToString(xml));
					pSeach = false;
					DisplayUserImageList(pListXML_Info);
	            } else {
					alert("<spring:message code="ezResource.t2" />");
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
	            alert("<spring:message code="ezResource.t169" />");
	            return;
	        }
	        var id = p_ListOrderObject.getAttribute("_DATA2");
	        var dept = p_ListOrderObject.getAttribute("_DATA11");
	        var feature = GetOpenPosition(420, 450);
	        if (CrossYN()) {
	            var OpenWin = window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "ShowPersonInfo_cross", GetOpenWindowfeature(420, 450));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        else
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
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
	                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                    }

	                }
	                listContentArry = new Array();
	            }
	            if (PressShiftKey) {
	                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                    }
	                }
	                listContentArry = new Array();
	                if (p_ListOrderObject == null)
	                    return;
	                var PrelistContent = p_ListOrderObject.getAttribute("id");
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

	                } else if (PrePoint > CurPoint) {
	                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                        p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                        }
	                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                    }
	                } else {
	                    return;
	                }

	            } else {
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
	        } else {
	            listEventCheckbox = false;
	        }
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
	                if (!IsInsert) {
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";

	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                    pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
	                    pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
	                    pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptNM + "]]></DATA4>";
	                    pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
	                    pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
	                    pparsingXML = pparsingXML + "<DATA7>" + jickwe + "</DATA7>";
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
	            if (p_ListOrderObject == "") {
	                alert("<spring:message code="ezResource.t169" />");
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
	                        } else {
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + strName + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3>" + strName2 + "</DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4>" + strDeptNM + "</DATA4>";
	                            pparsingXML = pparsingXML + "<DATA5>" + strDeptNM2 + "</DATA5>";
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
	                var listid = "MsgToList";
	            }
	    
	            function CheckMailReceiver(selRow, option) {
	                var rtnValue = false;
	                var email;
	                if (option == "1") {
	                    email = selRow.cells[0].DATA3;
	                } else if (option == "2") {
	                    email = selRow.cells[0].DATA2;
	                } else if (option == "3") {
	                    email = selRow;
	                }

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
	            function DisplayUserImageList(pListXML_Info) {
	                var xmlRtn = pListXML_Info;
	                document.getElementById("DeptUserImgList").innerHTML = "";
	                document.getElementById("txtlist_Layer").scrollTop = "0";
	                document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes
	                while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                    document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	                }
	                while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                    document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	                }
	                var UserListHTML = "";
	                if (SelectDeptNM.getAttribute("countinfo") != "1") {
	                    SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang400 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	                if (pListType == "IMG") {
	                    document.getElementById("DeptUserImgList").style.display = "";
	                    document.getElementById("txtlist_Layer").style.display = "none";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                    if (pSeach) {
	                        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang401 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang400 + "</span>]";
	                        SelectDeptNM.setAttribute("countinfo", "1")
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
	                        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang401 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang400 + "</span>]";
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
	                            for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
	                                if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
	                                    M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
	                                                      trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
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

	                        var Sub_TR1 = document.createElement("TR");
	                        var Sub_TD1 = document.createElement("TD");
	                        Sub_TD1.style.textAlign = "left";
	                        Sub_TD1.setAttribute("class", "name");
	                        var pDisplayName = "";
	                        var useOCS = "${useOCS}";
	                        if (useOCS == "YES") {
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
	                    Sub_TD3_Img.setAttribute("src", "/images/organtree/icon_hp.gif");
	                    Sub_TD3.appendChild(Sub_TD3_Img);
	                    Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
	                    Sub_TR3.appendChild(Sub_TD3);

	                    var Sub_TR4 = document.createElement("TR");
	                    var Sub_TD4 = document.createElement("TD");
	                    Sub_TD4.style.textAlign = "left";
	                    var Sub_TD4_Img = document.createElement("IMG");
	                    Sub_TD4_Img.setAttribute("class", "icon");
	                    Sub_TD4_Img.setAttribute("src", "/images/organtree/icon_mail.gif");
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
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
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
	                        
	                        var useOCS = "${useOCS}";
	                        if (useOCS == "YES") {
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
	                    	
	                    	var useOCS = "${useOCS}";
	                    	if (useOCS == "YES") {
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
	            
	    	function show_member() {
	        	var listview = new ListView();
	        	listview.LoadFromID("Organ");
	        	var length = listview.GetRowCount()
	        	var selectdata = listview.GetSelectedRows();
	        	
	        	if (length > 0) {
	            	var id = GetAttribute(selectdata[0], "DATA2");
	            	var dept = GetAttribute(selectdata[0], "DATA10");
	            	var feature = GetOpenPosition(420, 450);
	            	window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	}
	    	}
	    	
	    	function search_press(e) {
	        	if (window.event) {
	            	if (window.event.keyCode == 13) {
	                	search_click();
	            	}
	        	} else {
	            	if (e.which == 13) {
	                search_click();
	            	}
		        }
	    	}

		    function search_click() {
		        if (keyword.value == "") {
	    	        alert("<spring:message code="ezResource.t129" />");
	        	    keyword.focus();
	            	return;
	        	}
	        	var xmlHTTP = createXMLHttpRequest();
	        	var xmlDom = createXmlDom();
	        	var objNode;
	        	createNodeInsert(xmlDom, objNode, "DATA");
	        	createNodeAndInsertText(xmlDom, objNode, "SEARCH", document.getElementById("search_type").value + "::" + keyword.value);
	        	createNodeAndInsertText(xmlDom, objNode, "CELL", "company;description;displayName;title;telephoneNumber" + document.getElementById("search_type").value);
	        	createNodeAndInsertText(xmlDom, objNode, "PROP", "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2");
	        	createNodeAndInsertText(xmlDom, objNode, "TYPE", "user");

	        	g_xmlHTTP = createXMLHttpRequest();
	        	g_xmlHTTP.open("POST", "/ezOrgan/getSearchList.do", true);
	        	var usedefault;
	        	
	        	if (browserIE) {
	            	usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
	        	} else {
	            	usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
	        	}
	        	g_xmlHTTP.onreadystatechange = event_displayUserList2;
	        	g_xmlHTTP.send(xmlDom);
	    	}
		    
	    	function event_displayUserList2() {
	        	if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	            	if (g_xmlHTTP.statusText == "OK") {
		                if (g_xmlHTTP.responseXML.getElementsByTagName("ROW").length == 0) {
		                    alert("<spring:message code="ezResource.t9900006" />");
	    	            } else {
	        	            pListXML_Info = g_xmlHTTP.responseXML;
	            	        pSeach = true;
	                	    DisplayUserImageList();
	                	}
	            	} else {
	                	alert("오류발생" + g_xmlHTTP.statusText);
	            	}

	            	g_xmlHTTP = null;
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
		        } else {
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
	    	
	    	function makeArray(n) {
	        	this.length = n;
	        	for (var i = 1; i <= n; i++) {
	            	this[i] = 0;
	        	}
	        	return this;
	    	}
	    	var pCompanyID = "everyone";
	    	function close_onclick() {
	        	var listid = "MsgToList";
	        	var selList = new ListView();
	        	selList.LoadFromID(listid);

	        	var totalRows = selList.GetDataRows();
	        	var totalLen = totalRows.length;

	        	if (Check_Everyone.checked) {
		            SelectedACL = new makeArray(totalLen + 1);
	            	if (totalLen == 0) {
	                	SelectedACL[1] = "1^everyone^everyone";
	            	} else {
	                	for (var i = 0; i < totalLen; i++) {
	                    	var strTxt = GetAttribute(totalRows[i], "DATA2");
	                    	var strId = GetAttribute(totalRows[i], "DATA1");

	                    	if (strTxt.charAt(0) == " ") {
		                        strTxt = strTxt.substr(1);
		                    }

	    	                SelectedACL[i + 1] = "1^" + strId + "^" + strTxt;
	        	            if (totalLen == i + 1) {
	            	            SelectedACL[i + 2] = "1^" + pCompanyID + "^everyone";
	                	    }
	                	}
	        	    }
	        	} else {
		            SelectedACL = new makeArray(totalLen);
		            for (var i = 0; i < totalLen; i++) {
	    	            var strTxt = GetAttribute(totalRows[i], "DATA2");
	                	var strId = GetAttribute(totalRows[i], "DATA1");
	                	SelectedACL[i + 1] = "1^" + strId + "^" + strTxt;
	            	}
	        	}

	        	if (ReturnFunction != null) {
		            ReturnFunction(SelectedACL);
		        } else {
	    	        window.returnValue = SelectedACL;
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

	    	function cmdConfirm_onclick() {
		        var listid = "MsgToList";
		        var selList = new ListView();
	    	    selList.LoadFromID(listid);

		        var totalRows = selList.GetDataRows();
	        	var totalLen = totalRows.length;
	        	SelectedACL = new makeArray(ACLCnt);
	        	
	        	for (var i = 0; i < totalLen; i++) {
	            	var strTxt = GetAttribute(totalRows[i], "DATA2");
	            	var strId = GetAttribute(totalRows[i], "DATA1");
	            	SelectedACL[i + 1] = "1^" + strId + "^" + strTxt;
	        	}

	        	var objACL = ACLList;
	        	var ACLCnt = objACL.options.length;

	        	var SelectedACL;

	        	if (Check_Everyone.checked) {
		            SelectedACL = new makeArray(ACLCnt + 1);
		            if (ACLCnt == 0) {
		                SelectedACL[1] = "1^everyone^everyone";
	            	} else {
		                for (var i = 0; i < ACLCnt; i++) {
		                    var objOptions = objACL.options[i];
	    	                var strTxt = objOptions.text;
	    	                
		                    if (strTxt.charAt(0) == " ") {
	                        	strTxt = strTxt.substr(1);
	                    	}

	                    	SelectedACL[i + 1] = objOptions.gubun + "^" + objOptions.value + "^" + strTxt;

	                    	if (ACLCnt == i + 1) {
	                        	SelectedACL[i + 2] = "1^" + pCompanyID + "^everyone";
	                    	}
	                	}
	            	}
	        	} else {
	            	SelectedACL = new makeArray(ACLCnt);
		            for (var i = 0; i < ACLCnt; i++) {
		                var objOptions = objACL.options[i];
	    	            var strTxt = objOptions.text;

	        	        if (strTxt.charAt(0) == " ") {
	            	        strTxt = strTxt.substr(1);
	                	}
	                	SelectedACL[i + 1] = objOptions.gubun + "^" + objOptions.value + "^" + strTxt;
	            	}
	        	}
	        	if (ReturnFunction != null) {
		            ReturnFunction(SelectedACL);
		        } else {
	    	        window.returnValue = SelectedACL;
	        	}
	        	self.close();
	    	}	
		</script>
	</head>
	<body class="popup" style="overflow: hidden">	
		<xml id="treeconfig" style="display: none;">
    		<tree>
        		<config>
            		<size width="12" height="17" />
            		<baseimage>
                		<dot_continue path="/images/Email/tree/dot_continue.gif" />
                		<dot_end path="/images/Email/tree/dot_end.gif" />
                		<dot_normal path="/images/Email/tree/dot_normal.gif" />
                		<minus_end path="/images/Email/tree/minus_end.gif" />
                		<minus_normal path="/images/Email/tree/minus_normal.gif" />
                		<plus_end path="/images/Email/tree/plus_end.gif" />
                		<plus_normal path="/images/Email/tree/plus_normal.gif" />
                		<space path="/images/Email/tree/space.gif" />
                		<selected path="/images/Email/tree/folderselect.gif" />
            		</baseimage>
            		<baseclass>
                		<normal name="node_normal" />
                		<selected name="node_selected" />
                		<hover name="node_hover" />
            		</baseclass>
            		<images>
                		<image idx="1" path="/images/Email/tree/folder.gif" />
            		</images>
        		</config>
    		</tree>
		</xml>
    	<h1 id="h1Title"><spring:message code="ezResource.t12" /></h1>
    	<table style="width: 100%">
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
                                                        	<option selected value="displayname"><spring:message code="ezResource.t135" /></option>
                                                        	<option value="description"><spring:message code="ezResource.t132" /></option>
                                                        	<option value="title"><spring:message code="ezResource.t10" /></option>
                                                        	<option value="telephonenumber"><spring:message code="ezResource.t11" /></option>
                                                        	<option value="mobile"><spring:message code="ezResource.t136" /></option>
                                                        	<option value="HomePhone"><spring:message code="ezResource.t137" /></option>
                                                        	<option value="facsimileTelephoneNumber"><spring:message code="ezResource.t138" /></option>
                                                        	<option value="mail"><spring:message code="ezResource.t139" /></option>
                                                        	<option value="streetAddress"><spring:message code="ezResource.t140" /></option>
                                                    	</select>
                                                    	<input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;">
                                                    		<a class="imgbtn"><span onclick="search_click()"><spring:message code="ezResource.t141" /></span></a>
                                                	</div>
                                            	</td>
                                            	<td>
                                                	<div style="float: right; margin-right: 5px;">
                                                    	<a href="#" class="imgbtn"><span onclick="infoview_click()"><spring:message code="ezResource.t344" /></span></a>
                                                	</div>
                                            	</td>
                                        	</tr>
                                    	</table>
                                	</div>
                            	</div>
                            	<table style="margin-top: 3px;">
                                	<tr>
                                    	<td class="box">
                                        	<div style="width: 220px; height: 465px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
                                    	</td>
                                    	<td></td>
                                    	<td class="listview" style="width: 426px" id="orglistView">
                                        	<table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
                                            	<tr>
                                                	<th style="white-space:normal">
                                                    	<span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
                                                    	<span style="float:right;">
                                                        	<span onclick="ChangeListView_onClick('TXT');">
                                                            	<img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist">
                                                            </span>
                                                        	<span onclick="ChangeListView_onClick('IMG');">
                                                            	<img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist">
                                                            </span>
                                                    	</span>
                                                	</th>
                                            	</tr>
                                        	</table>
                                        	<div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
                                            	<table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
                                                	<tr>
                                                    	<td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code="ezResource.t9" /></td>
                                                    	<td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code="ezResource.t10" /></td>
                                                    	<td class="td_gray" style="font-weight: bold;"><spring:message code="ezResource.t11" /></td>
                                                	</tr>
                                            	</table>
                                            	<table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
    	                                                <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code="ezResource.t132" /></td>
        	                                            <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code="ezResource.t9" /></td>
            	                                        <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code="ezResource.t10" /></td>
                	                                    <td class="td_gray" style="font-weight: bold;"><spring:message code="ezResource.t11" /></td>
                    	                            </tr>
                        	                    </table>
                            	            </div>
                                	        <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
                                		</tr>
                            		</table>
                        		</td>
                        		<td style="width: 30px; text-align: center;">
                            		<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
                            		<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
                        		</td>
                        		<td style="vertical-align: top;">
                            		<h2 id="ToTitle" class="receiver_tltype01" style="cursor: pointer;">
                                	<span style="min-width: 45px;" id="ToTitleStr"><spring:message code="ezResource.t111" /></span>
                            		</h2>
                            		<div class="receiver_borderbox">
                                		<div id="ListViewMsgTo" ondragover="onDragEnter(event)" ondrop="onDrop(event, this)" style="width: 250px; Height: 477px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
                            		</div>
                        		</td>
                    		</tr>
                		</table>
            		</td>
        		</tr>
    		</table>
    		<input type="checkbox" value="x" id="Check_Everyone" name="Check_Everyone"><span class="txt" style="margin-bottom: 3px;"><spring:message code="ezResource.t372" /></span>
    		<br />
    		<div class="btnposition">
        		<a class="imgbtn" onclick="close_onclick()"><span><spring:message code="ezResource.t15" /></span></a>
        		<a class="imgbtn" onclick="window.close()"><span><spring:message code="ezResource.t16" /></span></a>
    		</div>
	</body>
</html>