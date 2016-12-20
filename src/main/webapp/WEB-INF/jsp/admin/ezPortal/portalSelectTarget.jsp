<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t13'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPortal/TreeView.js"></script>
		<!-- <script type="text/javascript" src="/js/ezPortal/ListView_list.js"></script> -->
		<script type="text/javascript" src="/js/ezResource/control/ListView_list.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript">
		  	var bSearch = false;
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var strLang1 = "<spring:message code='ezPortal.t1056'/>";
	        var strLang2 = "<spring:message code='ezPortal.t1057'/>";
	        var strSearch = "${pSearchString}";
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
	                ReturnFunction = parent.selecttarget_dialogArguments[1];
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.selecttarget_dialogArguments[1];
	                } catch (e) {
	                    
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
	                xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
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

	                if (strSearch != "") {
	                    document.getElementById('keyword').value = strSearch;
	                    search_click();
	                }

	            }
	            catch (ErrMsg) {
	                alert(" TreeViewinitialize : " + ErrMsg.description);
	            }
	        }

	        function Add_UserInfo_onclick() {
	            var listView = new ListView();
	            listView.LoadFromID("MsgToList");

	            var totalRows = listView.GetDataRows();
	            var totalLen = totalRows.length;

	            if (totalLen == 0) {
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
	            var reParam = window.showModalDialog("schedule_Add_User_Cross.aspx?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no" + GetShowModalPosition(695, 430));
	            else
	                var reParam = window.showModalDialog("schedule_Add_User.aspx?cmd=" + cmd + "&num=" + org_num + "&ownerID=" + org_ownerID, g_param, "edge:sunken; dialogHeight:430px;scroll:no; dialogWidth:695px; status:no; help:no");

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
	            xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
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
	        var nodeIdx;
	        function TreeViewNodeClick() {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	        function displayUserList(DeptID) {
	            listContentArry = new Array();

	           /*  var xmlpara = createXmlDom();
	            var objRoot, objNode;
	            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
	            createNodeAndInsertText(xmlpara, objNode, "CELL", "company;description;displayname;title;telephonenumber");
	            createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayname;description;title;company;telephonenumber;extensionattribute2");
	            createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");
	            g_xmlHTTP = createXMLHttpRequest();
	            g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptMemberList.aspx", true);
	            g_xmlHTTP.onreadystatechange = event_displayUserList;
	            g_xmlHTTP.send(xmlpara); */
	            
	            //
	            $.ajax({
  					url : '/ezOrgan/getDeptMemberList.do',
  					method : 'POST',
  					dataType : "text",
  					data : {
  						deptID : DeptID ,
  						cell : "company;description;displayName;title;telephoneNumber",
  						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
  						type : "user"
  					} ,
      				success : function(xml) {
      					pListXML_Info = loadXMLString(xml);
						pSeach = false;
 		                DisplayUserImageList(xml);
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
  						alert("<spring:message code='ezPortal.t14'/>" + textStatus);
  					}
  				});  
	            
	            
	        }
	        function event_displayUserList() {
	            if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	                if (g_xmlHTTP.statusText == "OK") {
	                    pListXML_Info = loadXMLString(g_xmlHTTP.responseText);
	                    g_xmlHTTP = null;
	                    pSeach = false;
	                    DisplayUserImageList();
	                }
	                else
	                    alert("<spring:message code='ezPortal.t14'/>" + g_xmlHTTP.statusText)

	            g_xmlHTTP = null;
	        }
	    }
	    var m_strColorSelect = "#DBE1E7";
	    var m_strColorOver = "#f4f5f5";
	    var m_strColorDefault = "#ffffff";
	    var p_ListOrderObject = null;
	    function event_listMover(obj) {
	        if (p_ListOrderObject != obj) {
	            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
	            }
	        }
	    }
	    function event_listMout(obj) {
	        if (p_ListOrderObject != obj) {
	            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	            }
	        }
	    }
	    function event_listclick(obj) {
	        if (p_ListOrderObject != obj && p_ListOrderObject != null) {
	            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	            }
	        }
	        p_ListOrderObject = obj;
	        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	            obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	        }
	    }
	    function infoview_click() {
	        if (p_ListOrderObject == null || p_ListOrderObject == "") {
	            alert("<spring:message code='ezPortal.t23'/>");
	            return;
	        }
	        var id = p_ListOrderObject.getAttribute("_DATA2");
	        var dept = p_ListOrderObject.getAttribute("_DATA11");
	        if (CrossYN())
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450));
	        else
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450));
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
	            if (email == arrRows[count2].getAttribute("data2"))
	                rtnValue = true;
	        }
	        _listview.LoadFromID("MsgCCList");
	        var arrRows = _listview.GetDataRows();

	        for (count2 = 0; count2 < arrRows.length; count2++) {
	            if (email == arrRows[count2].getAttribute("data2"))
	                rtnValue = true;
	        }
	        _listview.LoadFromID("MsgBCCList");
	        var arrRows = _listview.GetDataRows();

	        for (count2 = 0; count2 < arrRows.length; count2++) {
	            if (email == arrRows[count2].getAttribute("data2"))
	                rtnValue = true;
	        }
	        return rtnValue
	    }
	    var pSeach = false;
	    function DisplayUserImageList() {
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
	            SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	            SelectDeptNM.setAttribute("countinfo", "1")
	        }
	        if (pListType == "IMG") {
	            document.getElementById("DeptUserImgList").style.display = "";
	            document.getElementById("txtlist_Layer").style.display = "none";
	            document.getElementById("txtlist_table").style.display = "none";
	            document.getElementById("Search_txtlist_table").style.display = "none";
	            if (pSeach) {
	                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang2 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                SelectDeptNM.setAttribute("countinfo", "1")
	            }
	        }
	        else {
	            document.getElementById("DeptUserImgList").style.display = "none";
	            document.getElementById("txtlist_Layer").style.display = "";
	            if (!pSeach) {
	                document.getElementById("txtlist_table").style.display = "";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	            }
	            else {
	                document.getElementById("Search_txtlist_table").style.display = "";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang2 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                SelectDeptNM.setAttribute("countinfo", "1")
	            }
	        }
	        for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
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
	                if (CrossYN()) {
	                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                        if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                              trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                        }
	                    }
	                }
	                else {
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
	                    M_TR_IMG.setAttribute("SRC", "/files/upload_personal/photo/" + M_TR.getAttribute("_DATA9"));
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
	                if ("${useOCS}" == "YES") {
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
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    }
	                    else {
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
	                        if ("${useOCS}" == "YES")
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
	                    if ("${useOCS}" == "YES")
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
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450));
	        }
	    }
	    function search_press(e) {
	        if (window.event) {
	            if (window.event.keyCode == 13) {
	                search_click();
	            }
	        }
	        else {
	            if (e.which == 13)
	                search_click();
	        }

	    }

	    function search_click() {
	        if (keyword.value == "") {
	            alert("<spring:message code='ezPortal.t20'/>");
	            keyword.focus();
	            return;
	        }
	  
	         	$.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					data : {
						search : document.getElementById("search_type").value + "::" + keyword.value,
						cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
						type : "user"
					} ,
   				success : function(xml) {
   					pListXML_Info = loadXMLString(xml);
					pSeach = true;
		            DisplayUserImageList(xml);
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezPortal.t14'/>" + textStatus);
					}
				}); 
	        
	        
	    }
	    function event_displayUserList2() {
	        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	            if (g_xmlHTTP.statusText == "OK") {
	                if (g_xmlHTTP.responseXML.getElementsByTagName("ROW").length == 0)
	                    alert("<spring:message code='ezPortal.t22'/>");
	                else {
	                    pListXML_Info = g_xmlHTTP.responseXML;
	                    pSeach = true;
	                    DisplayUserImageList();
	                }
	            }
	            else
	                alert("<spring:message code='ezPortal.t14'/>" + g_xmlHTTP.statusText)

	            g_xmlHTTP = null;
	        }
	    }
	    function deptsearch_click() {

	        if (deptkeyword.value == "") {
	            alert("<spring:message code='ezPortal.t20'/>");
	            deptkeyword.focus();
	            return;
	        }
	    /*     var objNode;
	        var xmlHTTP = createXMLHttpRequest();
	        var xmlDom = createXmlDom();
	        createNodeInsert(xmlDom, objNode, "DATA");
	        createNodeAndInsertText(xmlDom, objNode, "SEARCH", "displayname::" + deptkeyword.value);
	        createNodeAndInsertText(xmlDom, objNode, "CELL", "extensionAttribute3;displayname;extensionAttribute9;");
	        createNodeAndInsertText(xmlDom, objNode, "PROP", "");
	        createNodeAndInsertText(xmlDom, objNode, "TYPE", "group");
	        try {
	            xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx", false);
	            xmlHTTP.send(xmlDom);
	            if (xmlHTTP.statusText != "OK") {
	                alert("<spring:message code='ezPortal.t21'/>" + xmlHTTP.statusText);
	                xmlDom = null;
	                xmlHTTP = null;
	            }
	            else {
	                xmlDom = xmlHTTP.responseXML;
	                adCount = xmlDom.getElementsByTagName("ROW").length;
	            }
	        }
	        catch (e) {
	            alert("<spring:message code='ezPortal.t21'/>" + e.description);
	            xmlDom = null;
	            xmlHTTP = null;
	        } */
	        var xmlDOM = createXmlDom();
	        
	        $.ajax({
				url : '/ezOrgan/getSearchList.do',
				method : 'POST',
				dataType : "xml",
				async : false,
				data : {search : "displayname::" + deptkeyword.value, cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "", type : 'group'}, 
					success : function(result) {
						xmlDOM = result
						var row = SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW");
                		adCount = row.length;
					},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code="ezResource.t2"/>" + textStatus);
					xmlDOM = null;
				}
			}); 

	        if (adCount == 0) {
	            alert("<spring:message code='ezPortal.t22'/>");
	            return;
	        }
	        else if (adCount == 1) {
	            bSearch = true;
	            g_xmlHTTP = createXMLHttpRequest();

	            if (CrossYN())
	                var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	            else
	                var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";

	            g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", true);
	            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            g_xmlHTTP.send(strQuery);
	        }
	        else {
	            var rgParams = new Array();
	            rgParams["addrBook"] = xmlDom;
	            rgParams["deptid"] = "";
	            var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	            feature = feature + GetShowModalPosition(540, 460);
	            window.showModalDialog("checkName2_cross.aspx", rgParams, feature);

	            if (rgParams["deptid"] != "") {
	                bSearch = true;
	                g_xmlHTTP = createXMLHttpRequest();
	                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	                g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            }
	        }
	    }
	    function event_getDeptFullTree() {
	        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	            if (g_xmlHTTP.statusText == "OK") {
	                if (!bSearch) {
	                    try {
	                        if (CrossYN())
	                            opener.opener.top.organview = g_xmlHTTP.responseXML;
	                        else
	                            window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
	                    } catch (e) { }
	                }

	                var treeXML = loadXMLFile("/xml/organtree_config.xml");
	                document.getElementById('TreeView').innerHTML = "";

	                var treeView = new TreeView();
	                treeView.SetConfig(treeXML);
	                treeView.SetID("FromTreeView");
	                treeView.SetUseAgency(true);
	                treeView.SetRequestData("RequestData");
	                treeView.SetNodeClick("TreeViewNodeClick");
	                treeView.DataSource(g_xmlHTTP.responseXML);
	                treeView.DataBind("TreeView");
	            }
	            else {
	                alert("<spring:message code='ezPortal.t14'/>" + g_xmlHTTP.statusText)
	                g_xmlHTTP = null;
	            }
	        }
	    }
	    function ReplaceText(orgStr, findStr, replaceStr) {
	        var re = new RegExp(findStr, "gi");

	        return (orgStr.replace(re, replaceStr));
	    }
	    function onkey_down(e) {
	        if (window.event) {
	            if (window.event.keyCode == 13) {
	                deptsearch_click();
	            }
	        }
	        else {
	            if (e.which == 13) {
	                deptsearch_click();
	            }
	        }
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
	        var rtn = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };

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
	            rtn["deptname2"][i] = GetAttribute(totalRows[i], "DATA5");
	            rtn["jikwe"][i] = GetAttribute(totalRows[i], "DATA7");
	            rtn["phone"][i] = GetAttribute(totalRows[i], "DATA8");
	        }
	        if (ReturnFunction != null)
	            ReturnFunction(rtn)
	        else
	            window.returnValue = rtn;
	        window.close();
	    }
	    function event_listDBclick(obj) {
	        p_ListOrderObject = obj;
	        Save_onclick();
	    }
	    function Save_onclick() {
	        var selid = "";
	        var selname = "";
	        var seldeptname = "";
	        if (p_ListOrderObject != null) {
	            selid = p_ListOrderObject.getAttribute("_DATA2");
	            selname = p_ListOrderObject.getAttribute("_data4");
	            seldeptname = p_ListOrderObject.getAttribute("_data5");

	            if (selid == "Top") selid = "everyone";

	            if (ReturnFunction != null)
	                ReturnFunction(selid + ";" + selname)
	            else
	                window.returnValue = selid + ";" + selname;
	            window.close();
	        }
	        else {
	            dept_select();
	            return;
	        }
	    }
	    function dept_select() {
	        var organTree = new TreeView();
	        organTree.LoadFromID("FromTreeView");
	        var nodeIdx = organTree.GetSelectNode();
	        selname = nodeIdx.NodeName;
	        selid = nodeIdx.GetNodeData("CN");

	        if (selid == "Top") selid = "everyone";

	        if (ReturnFunction != null)
	            ReturnFunction(selid + ";" + selname)
	        else
	            window.returnValue = selid + ";" + selname;

	        window.close();

	    }

		</script>
		
	</head>
	<body class="popup" style="overflow: hidden">

    <xml id="treeconfig" style="display: none;">
    <tree>
        <config>
            <size width="12" height="17"></size>
            <baseimage>
                <dot_continue path="/images/Email/tree/dot_continue.gif"></dot_continue>
                <dot_end path="/images/Email/tree/dot_end.gif"></dot_end>
                <dot_normal path="/images/Email/tree/dot_normal.gif"></dot_normal>
                <minus_end path="/images/Email/tree/minus_end.gif"></minus_end>
                <minus_normal path="/images/Email/tree/minus_normal.gif"></minus_normal>
                <plus_end path="/images/Email/tree/plus_end.gif"></plus_end>
                <plus_normal path="/images/Email/tree/plus_normal.gif"></plus_normal>
                <space path="/images/Email/tree/space.gif"></space>
                <selected path="/images/Email/tree/folderselect.gif"></selected>
            </baseimage>
            <baseclass>
                <normal name="node_normal"></normal>
                <selected name="node_selected"></selected>
                <hover name="node_hover"></hover>
            </baseclass>
            <images>
                <image idx="1" path="/images/Email/tree/folder.gif"></image>
            </images>
        </config>
    </tree>
</xml>
    <h1 id="h1Title"><spring:message code='ezPortal.t13'/></h1>
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
                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezPortal.t7'/></option>
                                                        <option value="description" usedefault="1"><spring:message code='ezPortal.t5'/></option>
                                                        <option value="title" usedefault="1"><spring:message code='ezPortal.t34'/></option>
                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezPortal.t35'/></option>
                                                        <option value="mobile" usedefault="0"><spring:message code='ezPortal.t1050'/></option>
                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezPortal.t1051'/></option>
                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezPortal.t1052'/></option>
                                                        <option value="mail" usedefault="0"><spring:message code='ezPortal.t38'/></option>
                                                        <option value="streetAddress" usedefault="0"><spring:message code='ezPortal.t1053'/></option>
                                                    </select>
                                                    <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;">
                                                    <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezPortal.t252'/></span></a>

                                                </div>
                                            </td>
                                            <td>
                                                <div style="float: right; margin-right: 5px;">
                                                    <a href="#" class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezPortal.t47'/></span></a>
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
                                                <th>
                                                    <span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
                                                    <span style="float:right;">
                                                        <span onclick="ChangeListView_onClick('TXT');">
                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
                                                        <span onclick="ChangeListView_onClick('IMG');">
                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
                                                    </span>
                                                </th>
                                            </tr>
                                        </table>
                                        <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
                                            <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
                                                <tr>
                                                    <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezPortal.t7'/></td>
                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezPortal.t34'/></td>
                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezPortal.t1054'/></td>
                                                </tr>
                                            </table>
                                            <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
                                                <tr>
                                                    <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezPortal.t5'/></td>
                                                    <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezPortal.t7'/></td>
                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezPortal.t34'/></td>
                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezPortal.t1054'/></td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br />
    <div class="btnposition">
        <a class="imgbtn"><span onclick="dept_select()"><spring:message code='ezPortal.t43'/></span></a>
        <a class="imgbtn" onclick="Save_onclick()"><span><spring:message code='ezPortal.t45'/></span></a>
        <a class="imgbtn" onclick="window.close()"><span><spring:message code='ezPortal.t46'/></span></a>
    </div>
	</body>
</html>