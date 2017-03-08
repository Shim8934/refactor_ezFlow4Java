<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezAddress.t344' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code="main.lhm01" />" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezAddress.e1' />"></script>
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview_namespace.htc.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <style>.txtClass{box-sizing : border-box; -moz-box-sizing:border-box;}</style>
	    <script type="text/javascript">
	        var addressid = "${addressId}";
	        var folderid = "${folderId}";
	        var ownerid = "${ownerId}";
	        var foldertype = "${folderType}";
	        var changekey = "${changeKey}";
	        var page = 1;
	        var CurPage = "1";
	        var pagecount;
	        var agoNodeIdx = "";
	        var agoNodeBool = false;
	        var searchgubun = "N";
	        var usernm = "${userNM}";
	        var usernm2 = "${userNM2}";
	        var m_selectedTree = null;
	        var gubunpage = "basic";
	        var m_titleSelectedColor = "#fffff4";
	        var pListType = "TXT";
	        var pSeach = false;
	        var m_orgImg = { "normal": "/images/tab_org1.gif", "select": "/images/tab_org.gif" };
	        var m_dlImg = { "normal": "/imagefs/tab_dl1.gif", "select": "/images/tab_dl.gif" };
	        var m_contactImg = { "normal": "/images/tab_addr1.gif", "select": "/images/tab_addr.gif" };
	        var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal" };
	        var AddressTreeView = null;
	        var ua = navigator.userAgent;
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1)
	                window.resizeTo(970, 680);
	            else
	                window.resizeTo(970, 720);
	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	                //document.getElementById("txtlist_Layer").style.height = "455px";
	            }
	            document.getElementById("AddressListView").hotTrackColor = "#F7FAE0";
	            document.getElementById("AddressListView").selectColor = "#ECF3BA";
	            document.getElementById("AddressListView").dataSource = listviewheader;
	            AddressTreeView = new window['treeview.htc'].TreeView('AddressTreeView', 'AddressTreeView');
	            AddressTreeView.attachEvent('requestdata', address_requestdata);
	            AddressTreeView.attachEvent('nodeselect', function () { address_selectnode("node") });
	            AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	            orgTabButton_onClick();
	            ListTypeChangeIcon();
	        }
	        function address_requestdata(event) {
	            if (!event) {
	                event = window.event;
	            }
	            var nodeIdx = event.nodeIdx;
	
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
	            AddressTreeView.putchildxml(nodeIdx, childxml);
	        }
	        
	        var tempfolderid = "";
	        var tempownerid = "";
	        
	        function address_selectnode(pGubun) {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var folderid = AddressTreeView.getvalue(nodeIdx, "folderid");
	            var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
	            var foldertype = AddressTreeView.getvalue(nodeIdx, "type");
	            if (CrossYN())
	                document.getElementById("addressFolderName").textContent = AddressTreeView.selectedNode().textContent;
	            else
	                document.getElementById("addressFolderName").innerText = AddressTreeView.selectedNode().innerText;
	
	            var xmlDom = null;

	            if (tempfolderid != folderid || tempownerid != ownerid) {
	                page = "1";
	            }
	            
	            xmlDom = call_page_address_get_list_mailCall(folderid, ownerid, foldertype,
	                "ADDRESSID,STYPE,SNAME,SCOMPANY,SEMAIL", "NOT SEMAIL=''", page, "25", searchgubun, "<spring:message code='ezAddress.t34' />");
	
	            tempfolderid = folderid;
	            tempownerid = ownerid;
	
	            if (CrossYN()) {
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue + strLang42;
	
	                var temptotal = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                if ((temptotal % 25) == 0)
	                    totalPage = parseInt(temptotal) / 25;
	                else
	                    totalPage = parseInt(temptotal / 25) + 1;
	                pageNum = xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue;
	            }
	            else {
	                document.getElementById('addressFolderCnt').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue + strLang42;
	
	                var temptotal = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                if ((temptotal % 25) == 0)
	                    totalPage = temptotal / 25;
	                else
	                    totalPage = parseInt(temptotal / 25) + 1;
	                pageNum = xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue;
	            }
	            document.getElementById("AddressListView").innerHTML = "";
	            var addressList = new ListView();
	            addressList.SetID("Address");
	            addressList.SetSelectFlag(false);
	            addressList.SetMulSelectable(true);
	            addressList.SetRowOnDblClick("ListViewNodeDblClick");
	            addressList.DataSource(loadXMLString(document.getElementById("listviewheader4").innerHTML.toUpperCase()));
	            addressList.DataBind("AddressListView");
	            addressList.DataSource(get_xmldom_addresslistview(xmlDom));
	            addressList.RowDataBind();
	            for (var i = 0; i < addressList.GetRowCount() ; i++) {
	                addressList.GetDataRows()[i].draggable = true;
	                if (CrossYN())
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                else
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };
	
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    addressList.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
	                }
	
	            }
	            addressList = null;
	            makePageSelPage();
	        }
	        function get_xmldom_addresslistview(xmlDom) {
	            var XmlRows = SelectNodes(xmlDom, "RTNDATA/DATA/ROW");
	            var xmlpara = createXmlDom();
	            var objRoot, objNode, objHeader, HEADERS, HEADER, ROWS, ROW, CELL, CELLVALUE;
	            objRoot = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA");
	            ROWS = createNodeAndAppandNode(xmlpara, objRoot, ROWS, "ROWS");
	            for (var count = 0; count < XmlRows.length; count++) {
	                ROW = createNodeAndAppandNode(xmlpara, ROWS, ROW, "ROW");
	                CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
	                createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SNAME"));
	                if (SelectSingleNodeValue(XmlRows[count], "STYPE") == "G") {
	                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", SelectSingleNodeValue(XmlRows[count], "ADDRESSID"));
	                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "mailgroup");
	                }
	                else {
	                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", "");
	                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "email");
	                }
	                createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA3", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
	                createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA4", SelectSingleNodeValue(XmlRows[count], "FOLDERTYPE"));
	                CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
	                createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SCOMPANY"));
	                CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
	                createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
	            }
	            return xmlpara;
	        }
	        function call_page_address_get_list_mailCall(folderid, ownerid, foldertype, field, filter, page, pagesize, searchgubun, errormesg) {
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "FOLDERID", folderid);
	            createNodeAndInsertText(xmlpara, objNode, "OWNERID", ownerid);
	            createNodeAndInsertText(xmlpara, objNode, "FOLDERTYPE", foldertype);
	            createNodeAndInsertText(xmlpara, objNode, "FIELD", field);
	            createNodeAndInsertText(xmlpara, objNode, "FILTER", filter);
	            createNodeAndInsertText(xmlpara, objNode, "PAGE", page);
	            createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", pagesize);
	            createNodeAndInsertText(xmlpara, objNode, "SEARCHGUBUN", searchgubun);
	            /* if (foldertype == "P")
	                xmlhttp.open("POST", "/myoffice/ezAddress/remoteEWS/address_get_list_mailCall.aspx", false);
	            else
	                xmlhttp.open("POST", "/myoffice/ezAddress/remote/address_get_list_mailCall.aspx", false); */
	            xmlhttp.open("POST", "/ezAddress/addressGetListMailCall.do", false);
	            
	            xmlhttp.send(xmlpara);
	            if (CrossYN())
	                return xmlhttp.responseXML;
	            else
	                return loadXMLString(xmlhttp.responseText);
	        }
	        var totalPage = "";
	        var pageNum = "";
	        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////페이지 네이션 추가
	        function goToPageByNum(Value) {
	            page = Value;
	            makePageSelPage();
	            movePage(page);
	        }
	        function selbeforeBlock() {
	            var pageNum = parseInt(page);
	            pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	        function selbeforeBlock_one() {
	            var pageNum = parseInt(page);
	            if (parseInt(pageNum - 1) > 0)
	                goToPageByNum(parseInt(pageNum - 1));
	            else
	                return;
	        }
	        function selafterBlock() {
	            var pageNum = parseInt(page);
	            pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	        function selafterBlock_one() {
	            var pageNum = parseInt(page);
	            if (parseInt(pageNum + 1) <= totalPage)
	                goToPageByNum(parseInt(pageNum + 1));
	            else
	                return;
	        }
	        function movePage(newPage) {
	            if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	                //page = newPage;
	                //GetAddressMemberList();
	                page = newPage;
	                address_selectnode("page");
	            }
	        }
	        function prevPage_onclick() {
	            newPage = parseInt(page) - 1;
	            if (newPage > 0) {
	                //CurPage = newPage;
	                page = newPage;
	                //GetAddressMemberList();
	                address_selectnode("page");
	            }
	        }
	        function nextPage_onclick() {
	            newPage = parseInt(page) + 1;
	            if (newPage <= parseInt(totalPage)) {
	                //CurPage = newPage;
	                page = newPage;
	                //GetAddressMemberList();
	                address_selectnode("page");
	            }
	        }
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	        var BlockSize = "5";
	        function makePageSelPage() {
	
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            strtext = "<div class=\"pagenavi\">";
	            PagingHTML += strtext;
	            //totalPage = parseInt(document.getElementById("MailList").getAttribute("MaxPage"));
	            pageNum = page;
	            //document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang255 + "<span style='color:#017BEC;'> " + pFolderUnReadCount + " </span>" + strLang257 + " / " + strLang256 + "<span style='color:#017BEC;'> " + pFolderTotalCount + " </span>" + strLang257 + "</b>]";
	            if (totalPage > 1 && pageNum != 1) {
	                PagingHTML += "<span class=\"btnimg\" onclick= 'return goToPageByNum(1)'><img src=\"/images/kr/cm/btn_p_prev.gif\" width=\"16\" height=\"16\"></span>";
	            }
	            else {
	                PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_p_prev01.gif\" width=\"16\" height=\"16\"></span>";
	            }
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    PagingHTML += "<span class=\"btnimg\" onclick= 'return selbeforeBlock()'><img src=\"/images/kr/cm/btn_prev.gif\" width=\"16\" height=\"16\"></span><span class=\"ptxt\" onclick= 'return selbeforeBlock_one()'>" + strLang258 + "</span>";
	                }
	                else {
	                    PagingHTML += "<span class=\"btnimg\" ><img src=\"/images/kr/cm/btn_prev01.gif\" width=\"16\" height=\"16\"></span><span class=\"ptxt\" onclick= 'return selbeforeBlock_one()'>" + strLang258 + "</span>";
	                }
	            }
	            else {
	                PagingHTML += "<span class=\"btnimg\" ><img src=\"/images/kr/cm/btn_prev01.gif\" width=\"16\" height=\"16\"></span><span class=\"ptxt\" onclick= 'return selbeforeBlock_one()'>" + strLang258 + "</span>";
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
	                    PagingHTML += "<span class=\"on\">" + i + "</span>";
	                }
	                else {
	                    PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                }
	            }
	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    PagingHTML += "<span class=\"ptxt\" onclick='return selafterBlock_one()'>" + strLang259 + "</span><span class=\"btnimg\" onclick='return selafterBlock()'><img src=\"/images/kr/cm/btn_next.gif\" width=\"16\" height=\"16\"></span>";
	                }
	                else {
	                    PagingHTML += "<span class=\"ptxt\" onclick='return selafterBlock_one()'>" + strLang259 + "</span><span class=\"btnimg\"><img src=\"/images/kr/cm/btn_next01.gif\" width=\"16\" height=\"16\"></span>";
	                }
	            }
	            else {
	                PagingHTML += "<span class=\"ptxt\" onclick='return selafterBlock_one()'>" + strLang259 + "</span><span class=\"btnimg\"><img src=\"/images/kr/cm/btn_next01.gif\" width=\"16\" height=\"16\"></span>";
	            }
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                PagingHTML += "<span class=\"btnimg\" onclick='return goToPageByNum(" + totalPage + ")'><img src=\"/images/kr/cm/btn_n_next.gif\" width=\"16\" height=\"16\"></span>";
	            }
	            else {
	                PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_n_next01.gif\" width=\"16\" height=\"16\"></span>";
	            }
	            PagingHTML += "</div>";
	            td_Create1(PagingHTML);
	        }
	
	        var g_bChanged = false;
	        var g_bTreeLoad = false;
	
	        function close_onclick() {
	            if (g_bChanged) {
	                if (confirm("<spring:message code='ezAddress.t345' />")) {
	                    add();
	                    return;
	                }
	            }
	
	            window.close();
	        }
	
	        function add() {
	            if (document.getElementById("TextName").value == "") {
	                alert("<spring:message code='ezAddress.t346' />");
	                    return;
	                }
	
	                if (!check_length(document.getElementById("TextName").value, 50, "<spring:message code='ezAddress.t304' />"))
	                    return;
	
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlDom = createXmlDom();
	                //createNodeAndInsertCDataText
	                var objNode, objRow, objRows, objRowRow;
	                objNode = createNodeInsert(xmlDom, objNode, "DATA");
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderid);
	                createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", changekey);
	                createNodeAndInsertText(xmlDom, objNode, "TYPE", foldertype);
	                createNodeAndInsertText(xmlDom, objNode, "OWNERID", ownerid);
	                createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", addressid);
	                createNodeAndInsertCDataText(xmlDom, objNode, "SNAME", document.getElementById("TextName").value);
	                createNodeAndInsertCDataText(xmlDom, objNode, "USERNM", usernm);
	                createNodeAndInsertCDataText(xmlDom, objNode, "USERNM2", usernm2);
	                objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "CONTACTGROUP");
	
	                for (var i = 0; i < document.getElementById("ListViewMsgTo").children.item(0).children.item(1).childNodes.length; i++) {
	                    var strName = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children.item(i).getAttribute("data1");
	                    var strKey = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children.item(i).getAttribute("data4");
	                    var strType = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children.item(i).getAttribute("data5");
	                    objRows = createNodeAndAppandNode(xmlDom, objRow, objRows, "ROW");
	                    createNodeAndAppandNodeCDataText(xmlDom, objRows, objRowRow, "DISPLAYNAME", strName);
	                    createNodeAndAppandNodeCDataText(xmlDom, objRows, objRowRow, "KEY", strKey);
	                    createNodeAndAppandNodeCDataText(xmlDom, objRows, objRowRow, "TYPE", strType);
	                }
	                xmlHTTP.open("POST", "/ezAddress/addressGroupSave.do", false);
	                xmlHTTP.send(xmlDom);
	
	                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
	                    alert("<spring:message code='ezAddress.t347' />");
				    }
				    else {
				        alert("<spring:message code='ezAddress.t348' />");
	
				        try {
				            window.opener.location.reload(false);
				        }
				        catch (e) { }
	
				        window.close();
				    }
	            }
	
	            function check_length(chkstr, maxlength, fieldname) {
	                var length = 0;
	                var i;
	
	                length = chkstr.length;
	
	                if (length > maxlength) {
	                    alert(fieldname + "<spring:message code='ezAddress.t227' />" + maxlength + "<spring:message code='ezAddress.t228' />");
	                      return false
	                  }
	
	                  return true;
	              }
	
	              function delete_member() {
	                  g_bChanged = true;
	
	                  while (true) {
	                      selectindex = document.all("ListMember").selectedIndex;
	
	                      if (selectindex < 0 || selectindex >= document.all("ListMember").length)
	                          return;
	
	                      document.all("ListMember").options[selectindex] = null;
	                  }
	              }
	
	        function applyCurrentData() {
	            var XmlText = getOrganinfo();
	            if (typeof (XmlText) == "undefined")
	                XmlText = "";
	
	            var XmlDom = loadXMLString(XmlText);
	            var count = XmlDom.getElementsByTagName("Table").length;
	
	            if (addressid != "") {
	                if (!CrossYN()) {
	                    document.getElementById("TextName").value = XmlDom.getElementsByTagName("SNAME")[0].text;
	                }
	                else if (CrossYN()) {
	                    document.getElementById("TextName").value = XmlDom.getElementsByTagName("SNAME")[0].textContent;
	                }
	            }
	
	            if (!CrossYN()) {
	                if (XmlDom.getElementsByTagName("NAME")[0] == null || XmlDom.getElementsByTagName("NAME")[0].text == "") {
	                    return;
	                }
	            }
	            else if (CrossYN()) {
	                if (XmlDom.getElementsByTagName("NAME")[0] == null) {
	                    return;
	                }
	            }
	
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strName = "";
	            var strEmail = "";
	            var strKey = "";
	            var strType = "";
	            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	            var ReturnXMLRow = SelectNodes(XmlDom, "NewDataSet/Table");
	            for (var Cnt = 0; Cnt < ReturnXMLRow.length; Cnt++) {
	                strName = SelectSingleNodeValue(ReturnXMLRow[Cnt], "NAME"); //XmlDom.getElementsByTagName("NAME")[i].text;
	                strEmail = SelectSingleNodeValue(ReturnXMLRow[Cnt], "EMAIL"); //XmlDom.getElementsByTagName("EMAIL")[i].text;
	                strKey = SelectSingleNodeValue(ReturnXMLRow[Cnt], "DLKEY"); //XmlDom.getElementsByTagName("DLKEY")[i].text;
	                strType = SelectSingleNodeValue(ReturnXMLRow[Cnt], "TYPE"); //XmlDom.getElementsByTagName("TYPE")[i].text;
	
	                pparsingXML = pparsingXML + "<ROW><CELL><DATA1><![CDATA[" + strName + "]]></DATA1>";
	                pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                pparsingXML = pparsingXML + "<DATA4>" + strKey + "</DATA4>";
	                pparsingXML = pparsingXML + "<DATA5>" + strType + "</DATA5>";
	                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " <" + strEmail + ">" + "]]></VALUE></CELL></ROW>";
	            }
	            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	
	            var Resultxml = loadXMLString(pparsingXML2);
	            var listview = new ListView();
	            listview.SetID("MsgToList");
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(false);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(Resultxml);
	            listview.RowDataBind();
	
	            for (var i = 0; i < listview.GetRowCount(); i++) {
	                listview.GetDataRows()[i].style.whiteSpace = "nowrap";
	                listview.GetDataRows()[i].childNodes[0].setAttribute("height", "");
	                listview.GetDataRows()[i].childNodes[0].style.whiteSpace = "";
	                listview.GetDataRows()[i].childNodes[0].style.overflow = "";
	                listview.GetDataRows()[i].childNodes[0].style.textOverflow = "";
	            }
	        }
	
	
	
	        function getOrganinfo() {
	            if (addressid != "") {
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlDom = createXmlDom();
	
	                var objNode;
	                createNodeInsert(xmlDom, objNode, "DATA");
	                createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", addressid);
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderid);
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", foldertype);
	                createNodeAndInsertText(xmlDom, objNode, "OWNERID", ownerid);
	                
	                /* if (foldertype == "P")
	                    xmlHTTP.open("Post", "/myoffice/ezAddress/remoteEWS/address_get_CurrentData.aspx", false);
	                else
	                    xmlHTTP.open("Post", "/myoffice/ezAddress/remote/address_get_CurrentData.aspx", false); */
	                xmlHTTP.open("Post", "/ezAddress/addressGetCurrentData.do", false);
	                
	                xmlHTTP.send(xmlDom);
	
	                return xmlHTTP.responseText;
	            }
	        }
	
	        function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	            listview.DataBind(pListView);
	            listview.RowDataBind();
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
	
	        function TreeViewNodeClick() {
	            CurPage = "1";
	            listContentArry = new Array();
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
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
	            var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
	            treeView.SetConfig(treeXML);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	        var tempDeptID = "";
	        function displayUserList(DeptID) {
	            if (DeptID != undefined)
	                tempDeptID = DeptID;
				
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : tempDeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", page: CurPage, type : "user"},
		        	success : function(result){
		                pListXML_Info = loadXMLString(result);
		        		
		                DisplayUserImageList();
		                makePageSelPage2();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezAddress.t9' />" + error);
		        	}
		        });
	            
	        }
	
	        var pListXML_Info = "";
	        var g_xmlHTTP = null;
	        function LoadAddressTree() {
	            var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
	            AddressTreeView.config(treeXML);
	            get_Address_FullTree();
	           
	        }
	        var xmlHTTP = null;
	        function get_Address_FullTree() {
	            xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("POST", "/ezAddress/addressGetFullTree.do", true);
	            xmlHTTP.onreadystatechange = event_get_Address_FullTree;
	            xmlHTTP.send();
	        }
	
	        function event_get_Address_FullTree() {
	            if (xmlHTTP.readyState == 4 && xmlHTTP != null) {
	                if (xmlHTTP.status == 200) {
	                    var addresstreexml = loadXMLString(xmlHTTP.responseText);
	                    var IDNodes = addresstreexml.getElementsByTagName("FOLDERID");
	                    var ChangeKeyNodes = addresstreexml.getElementsByTagName("CHANGEKEY");
	                    var OwnerNodes = addresstreexml.getElementsByTagName("OWNERID");
	                    var TypeNodes = addresstreexml.getElementsByTagName("FOLDERTYPE");
	                    var NameNodes = addresstreexml.getElementsByTagName("FOLDERNAME");
	                    var ChildNodes = addresstreexml.getElementsByTagName("CHILDCOUNT");
	                    xmlHTTP = null;
	
	                    var childXML = "<tree><nodes>";
	
	                    for (var i = 0; i < NameNodes.length; i++) {
	                        var strFolderName = NameNodes[i].firstChild.nodeValue;
	
	                        childXML += "<node imgidx='1' caption=\"";
	                        childXML += (strFolderName + "\" ");
	                        childXML += ("ownerid=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("type=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("folderid=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("changekey=\"" + MakeRightField(ChangeKeyNodes[i].firstChild.nodeValue) + "\" ");
	
	                        if (ChildNodes[i].firstChild.nodeValue != "0")
	                            childXML += "hassub='1' ";
	
	                        childXML += "/>";
	                    }
	                    childXML += "</nodes></tree>";
	
	                    AddressTreeView.source(childXML);
	                    AddressTreeView.update();
	                    //AddressTreeView.toggle(1);
	                    AddressTreeView.select(1);
	                }
	                else {
	                    xmlHTTP = null;
	                }
	            }
	        }
	    function pagemove(direction) {
	        if (direction == 0) {
	            if (event.keyCode == 13) {
	                if (page != 0) {
	                    if (page > 0 && page <= parseInt(td_pageCount.innerText)) {
	                        address_selectnode("page");
	                    }
	                }
	            }
	        }
	        else {
	            page = parseInt(page) + parseInt(direction);
	
	            if (page != 0) {
	                if (page > 0 && page <= parseInt(td_pageCount.innerText)) {
	                    address_selectnode("page");
	                }
	            }
	        }
	        return false;
	    }
	
	    function ListViewNodeDblClick(m_selectedWindow) {
	        if (m_selectedWindow != null) {
	            InsertReceiver(m_selectedWindow);
	        }
	    }
	
	    function InsertReceiver(pListView) {
	        if (gubunpage == "basic") {
	            if (m_selectedTree == AddressListView) {
	                var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("Address");
	
	                var arrRows = pListViewDL.GetSelectedRows();
	
	                if (arrRows.length > 0) {
	                    for (var i = 0; i < arrRows.length; i++) {
	                        var pparsingXML = "";
	                        var pparsingXML2 = "";
	
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        var strName = arrRows[i].cells[0].innerText
	                        var strEmail = GetAttribute(arrRows[i], "DATA3");
	                        var strKey = GetAttribute(arrRows[i], "DATA1");
	                        var strType = GetAttribute(arrRows[i], "DATA2");
	
	                        if (strEmail.trim() == "") {
	                            alert(strName + "<spring:message code='ezAddress.t277' />")
	                            continue;
	                        }
	                        if (strName.trim() == "")
	                            strName = strEmail;
	
	                        if (strEmail.trim() == "mail") {
	                            continue;
	                        }
	
	                        if (strType.indexOf("group") > -1) {
	                            alert(strLang43);
	                            continue;
	                        }
	
	                        var listid = "MsgToList";
	
	                        var targetList = new ListView();
	                        targetList.LoadFromID(listid);
	
	                        var bFlag = targetList.ExistRow("DATA2", strEmail);
	                        if (bFlag) {
	                            alert(strName + "<spring:message code='ezAddress.t1101' />");
	                            continue;
	                        }
	                        if (strType == "group") {
	                            alert(strLang43);
	                            continue;
	                        }
	
	                        else {
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1><![CDATA[" + strName + "]]></DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strDeptNM + "]]></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4>" + strEmail + "</DATA4>";
	                            pparsingXML = pparsingXML + "<DATA5>" + strType + "</DATA5>";
	                            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " <" + strEmail + ">" + "]]></VALUE></CELL></ROW>";
	                        }
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	
	                        var listview = new ListView();
	                        listview.LoadFromID(listid);
	
	                        var MaxID = 0;
	                        var InitTr = listview.GetDataRows();
	
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                            if (MaxID < curnum)
	                                MaxID = curnum;
	                        }
	                        var objTr;
	                        if (InitTr.length == 0)
	                            objTr = listview.AddRow(0);
	                        else
	                            objTr = listview.AddRow(InitTr.length);
	                        var trid = listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1);
	                        SetAttribute(objTr, "id", trid);
	                        listview.AddDataRow(objTr, Resultxml);
	                        document.getElementById(trid).style.whiteSpace = "nowrap";
	                        document.getElementById("MsgToList").className = "receiver_list";
	                    }
	                }
	            }
	            else if (m_selectedTree == TreeView) {
	                for (var i = 0; i < listContentArry.length; i++) {
	                    var strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
	                    var strDeptNM = document.getElementById(listContentArry[i]).getAttribute("_data5");
	                    var strEmail = document.getElementById(listContentArry[i]).getAttribute("_data3");
	
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID("MsgToList");
	                    var bFlag = getlistview.ExistRow("DATA2", strEmail);
	
	                    if (bFlag) {
	                        alert(strName + "<spring:message code='ezAddress.t1101' />");
	                        continue;
	                    }
	                    else {
	
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1><![CDATA[" + strName + "]]></DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strDeptNM + "]]></DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4>" + strEmail + "</DATA4>";
	                        pparsingXML = pparsingXML + "<DATA5>email</DATA5>";
	                        pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " <" + strEmail + ">" + "]]></VALUE></CELL></ROW>";
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
	                        document.getElementById("MsgToList").className = "receiver_list";
	                    }
	                }
	            }
	        }
	        if (gubunpage == "direct") {
	            inputAddress();
	        }
	    }
	
	    function inputAddress() {
	        if (document.getElementById("emailname").value == "") {
	            document.getElementById("emailname").focus();
	            alert("<spring:message code='ezAddress.t349' />");
	                return;
	            }
	        else if (document.getElementById("emailaddr").value == "") {
	            document.getElementById("emailaddr").focus();
	                alert("<spring:message code='ezAddress.t350' />");
	                    return;
	                }
	
	            var emailMatch = new RegExp(/^[^/@]{1,30}@[A-Za-z0-9]{2,30}\.[A-Za-z0-9]{2,30}/g);
	            if (!emailMatch.test(document.getElementById("emailaddr").value) && document.getElementById("emailaddr").value != "") {
	                alert("<spring:message code='ezAddress.t1100' />");
	                return;
	            }
	
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strName = "";
	            var strEmail = "";
	            var listid = "MsgToList";
	
	            var listview = new ListView();
	            listview.LoadFromID(listid);
	            strName = document.getElementById("emailname").value;
	            strEmail = document.getElementById("emailaddr").value;
	
	            var bFlag = listview.ExistRow("DATA2", strEmail);
	            if (bFlag) {
	                alert(strName + "<spring:message code='ezAddress.t1101' />");
	
	                return;
	            }
	
	            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	            pparsingXML = pparsingXML + "<ROW><CELL><DATA1><![CDATA[" + strName + "]]></DATA1>";
	            pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	            pparsingXML = pparsingXML + "<DATA4>" + strEmail + "</DATA4>";
	            pparsingXML = pparsingXML + "<DATA5>" + "email" + "</DATA5>";
	            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " <" + strEmail + ">" + "]]></VALUE></CELL></ROW>";
	            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	            Resultxml = loadXMLString(pparsingXML2);
	
	            var MaxID = 0;
	            var InitTr = listview.GetDataRows();
	
	            for (var j = 0  ; j < InitTr.length  ; j++) {
	                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                if (MaxID < curnum)
	                    MaxID = curnum;
	            }
	
	            var objTr = listview.AddRow(0);
	            var trid = listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1);
	            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
	            listview.AddDataRow(objTr, Resultxml);
	            document.getElementById(trid).style.whiteSpace = "nowrap";
	            document.getElementById("emailname").value = "";
	            document.getElementById("emailaddr").value = "";
	        }
	
	        function SelectReceiverWindow(selectedWindow) {
	            selectedWindow.normalColor = m_titleSelectedColor;
	
	            m_selectedWindow = selectedWindow;
	        }
	
	        function on_keydown(evt) {
	            if (evt.keyCode == "13")
	                inputAddress();
	        }
	
	        function DisplayUserImageList() {
	            var xmlRtn = pListXML_Info;
	            document.getElementById("DeptUserImgList").innerHTML = "";
	            document.getElementById("txtlist_Layer").scrollTop = "0";
	            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
	            totalPage2 = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
	            while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	            }
	            while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
	                document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	            }
	            var UserListHTML = "";
	            if (SelectDeptNM.getAttribute("countinfo") != "1") {
	                SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang91001 + "</span>]";
	                SelectDeptNM.setAttribute("countinfo", "1")
	            }
	            if (pListType == "IMG") {
	                document.getElementById("DeptUserImgList").style.display = "";
	                document.getElementById("txtlist_Layer").style.display = "none";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	                if (pSeach) {
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang_2 + "" + "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang1 + "</span>]";
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang_2 + "" + "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang1 + "</span>]";
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
	                    M_TR.setAttribute("draggable", true);
	                    if (CrossYN())
	                        M_TR.ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                    else
	                        M_TR.ondragstart = function (event) { event_listdragstart(this); };
	
	                    if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                        M_TR.ondragend = function (event) { event_listdragend(event); };
	                    }
	                    if (CrossYN()) {
	                        /* for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
	                            }
	                        } */
	                        
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
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
	                        /* for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
	                            }
	                        } */
	                        
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
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
	
	        function orgTabButton_onClick() {
	            m_tabDialogState["org"] = "select";
	            m_tabDialogState["contact"] = "normal";
	            m_tabDialogState["dl"] = "normal";
	            ImageUpdate();
	            document.getElementById("IDListView").style.display = "none";
	            document.getElementById("ManualView").style.display = "none";
	            document.getElementById("TreeViewPane").style.display = "";
	            document.getElementById("subtitle").innerText = "<spring:message code='ezAddress.t351' />";
	
	            m_selectedTree = TreeView;
	            gubunpage = "basic";
	
	            if (g_bTreeLoad == false) {
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
	
	                xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	                xmlHTTP.send(xmlpara);
	
	                var xmlTree = loadXMLString(xmlHTTP.responseText);
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
	
	                recevieListview("MsgToList", "ListViewMsgTo");
	                applyCurrentData();
	
	                g_bTreeLoad = true;
	            }
	        }
	
	        function ImageUpdate() {
	            return (navigator.userAgent.indexOf('Firefox') != -1) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                    contactTabButton.setAttribute('src', m_contactImg[m_tabDialogState["contact"]]);
	                    dlTabButton.setAttribute('src', m_dlImg[m_tabDialogState["dl"]]);
	                }).call(this)
	                : (CrossYN()) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                    contactTabButton.setAttribute('src', m_contactImg[m_tabDialogState["contact"]]);
	                    dlTabButton.setAttribute('src', m_dlImg[m_tabDialogState["dl"]]);
	                }).call(this)
	                :
	                (function () {
	                    orgTabButton.src = m_orgImg[m_tabDialogState["org"]];
	                    contactTabButton.src = m_contactImg[m_tabDialogState["contact"]];
	                    dlTabButton.src = m_dlImg[m_tabDialogState["dl"]];
	                }).call(this)
	            ;
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
	        var loadaddresstree = false;
	        function contactTabButton_onClick() {
	            m_selectedTree = AddressListView;
	            gubunpage = "basic";
	            document.getElementById("IDListView").style.display = "";
	            document.getElementById("TreeViewPane").style.display = "none";
	            document.getElementById("ManualView").style.display = "none";
	            document.getElementById("subtitle").innerText = "<spring:message code='ezAddress.t231' />";
	            if(!loadaddresstree)
	                LoadAddressTree();
	            loadaddresstree = true;
	        }
	
	        function dlTabButton_onClick() {
	            gubunpage = "direct";
	
	            document.getElementById("IDListView").style.display = "none";
	            document.getElementById("ManualView").style.display = "";
	            document.getElementById("TreeViewPane").style.display = "none";
	            document.getElementById("subtitle").innerText = "<spring:message code='ezAddress.t352' />";
	            document.getElementById("emailname").focus();
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
	        function event_listDBclick(obj) {
	            InsertReceiver();
	        }
	        var dropelement = "";
	        function onDragEnter(evt, obj) {
	            evt.stopPropagation();
	            evt.preventDefault();
	            evt.dataTransfer.dropEffect = "copy";
	            evt.dataTransfer.effectAllowed = "copy";
	            dropelement = obj.id;
	        }
	        function onDrop(evt) {
	            evt.stopPropagation();
	            evt.preventDefault();
	            InsertReceiver(document.getElementById(dropelement));
	        }
	
	        function event_listdragstart(obj) {
	            var islist = false;
	            if (m_selectedTree == AddressListView) {
	                var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("Address");
	                for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
	                    if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
	                        islist = true;
	                        break;
	                    }
	                }
	                if (!islist)
	                    obj.onclick();
	            }
	            else if (m_selectedTree == TreeView) {
	                for (var i = 0; i < listContentArry.length; i++) {
	                    if (listContentArry[i] == obj.getAttribute("id")) {
	                        islist = true;
	                        break;
	                    }
	                }
	                if (!islist)
	                    event_listclick(obj);
	            }
	        }
	
	        function event_listdragend(evt) {
	            evt.stopPropagation();
	            evt.preventDefault();
	            if (dropelement != "")
	                InsertReceiver(document.getElementById(dropelement));
	            dropelement = "";
	        }
	        window.ondragover = function () {
	            dropelement = "";
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
	                strtext2 = "<span class='btnimg' onclick= 'return goToPageByNum2(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
	                PagingHTML2 += strtext2;
	            }
	            else {
	                strtext2 = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
	                PagingHTML2 += strtext2;
	            }
	            if (totalPage2 > BlockSize2) {
	                if (pageNum2 > BlockSize2) {
	                    strtext2 = "<span class='btnimg' onclick= 'return selbeforeBlock2()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one2()'>" + strLang258 + "</span>";
	                    PagingHTML2 += strtext2;
	                }
	                else {
	                    strtext2 = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one2()'>" + strLang258 + "</span>";
	                    PagingHTML2 += strtext2;
	                }
	            }
	            else {
	                strtext2 = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one2()'>" + strLang258 + "</span>";
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
	                    strtext2 = "<span class='ptxt' onclick='return selafterBlock_one2()'>" + strLang259 + "</span>";
	                    strtext2 = strtext2 + "<span class='btnimg' onclick='return selafterBlock2()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML2 += strtext2;
	                }
	                else {
	                    strtext2 = "<span class='ptxt' onclick='return selafterBlock_one2()'>" + strLang259 + "</span>";
	                    strtext2 = strtext2 + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML2 += strtext2;
	                }
	            }
	            else {
	                strtext2 = "<span class='ptxt' onclick='return selafterBlock_one2()'>" + strLang259 + "</span>";
	                strtext2 = strtext2 + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML2 += strtext2;
	            }
	            if (totalPage2 > 1 && totalPage2 != 1 && (totalPage2 != pageNum2)) {
	                strtext2 = "<span class='btnimg' onclick='return goToPageByNum2(" + totalPage2 + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	                PagingHTML2 += strtext2;
	            }
	            else {
	                strtext2 = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	                PagingHTML2 += strtext2;
	            }
	            PagingHTML2 += "</div>";
	            td_Create2(PagingHTML2);
	        }
	        function goToPageByNum2(Value) {
	        	p_ListOrderObject = "";		    	
		    	listContentArry = new Array();
		    	
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
	                displayUserList();
	            }
	        }
	        function prevPage_onclick2() {
	            newPage2 = parseInt(CurPage) - 1;
	            if (newPage2 > 0) {
	                CurPage = newPage2;
	                displayUserList();
	            }
	        }
	        function nextPage_onclick2() {
	            newPage2 = parseInt(CurPage) + 1;
	            if (newPage2 <= parseInt(totalPage)) {
	                CurPage = newPage2;
	                displayUserList();
	            }
	        }
	    </script>
	</head>
	<body class="popup" style="overflow: hidden">
	    <xml id="listviewheader" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t358' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t359' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t263' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader2" style="display: none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>	
		        <NAME><spring:message code='ezAddress.t124' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t359' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t192' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader3" style="display: none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t124' /></NAME>
		        <WIDTH>40</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>E-MAIL</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader4" style="display: none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t124' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezAddress.t221' /></NAME>
		        <WIDTH>65</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>E-Mail</NAME>
		        <WIDTH>115</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
	    <form id="Form_address_writegroup" name="Form_address_writegroup" method="post">
	        <div id="menu">
	            <ul>
	                <li><span onclick="add()"><spring:message code='ezAddress.t339' /></span></li>
	            </ul>
	        </div>
	        <div id="close">
	            <ul>
	                <li><span onclick="close_onclick()"><spring:message code='ezAddress.t5' /></span></li>
	            </ul>
	        </div>
	
	        <script type="text/javascript">
	            selToggleList(document.getElementById("menu"), "ul", "li", "0");
	            selToggleList(document.getElementById("close"), "ul", "li", "0");
	        </script>
	
	        <table class="content">
	            <tr>
	                <th><spring:message code='ezAddress.t360' /></th>
	                <td>
	                    <input type="text" id="TextName" name="TextName" style="width:100%" MaxLength="24" class="txtClass"></td>
	            </tr>
	        </table>
	        <table style="margin-top: 10px">
	            <tr>
	                <td>
	                    <table style="width: 100%">
	                        <tr>
	                            <td style="height: 25px;">
	                                <h2 id="subtitle" style="display: none"><spring:message code='ezAddress.t231' /></h2>
	                                <div id="tabnav" style="float: left; width: 100%;">
	                                    <ul>
	                                        <li id="orgTabButton"><span onclick="orgTabButton_onClick()">
	                                            <spring:message code='ezAddress.t351' /></span></li>
	                                        <li id="contactTabButton"><span onclick="contactTabButton_onClick()">
	                                            <spring:message code='ezAddress.t231' /></span></li>
	                                        <li id="dlTabButton"><span onclick="dlTabButton_onClick()">
	                                            <spring:message code='ezAddress.t361' /></span></li>
	                                    </ul>
	                                </div>
	                            <script type="text/javascript">
	                                selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	                            </script>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	                <td></td>
	                <td>
	                    <h2 id="ToTitle" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="font-weight: bold;">
	                        <span style="min-width:45px;" id="ToTitleStr"><spring:message code='ezAddress.t364' /></span>
	                    </h2>
	                </td>
	            </tr>
	            <tr>
	                <td style="width: 670px; height: 375px; vertical-align: top;">
	                    <div id="ManualView" style="DISPLAY: none; height: 478px; padding: 10px;" class="box">
	                        <table class="content">
	                            <tr>
	                                <th><spring:message code='ezAddress.t124' /></th>
	                                <td>
	                                    <input type="text" id="emailname" style="WIDTH: 98%">
	                                </td>
	                            </tr>
	                            <tr>
	                                <th><spring:message code='ezAddress.t224' /></th>
	                                <td>
	                                    <input type="text" id="emailaddr" style="WIDTH: 98%" onkeypress="return on_keydown(event)">
	                                </td>
	                            </tr>
	                        </table>
	                        <br>
	
	                        <div style="text-align: center"><a href="#" class="imgbtn"><span onclick="inputAddress()"><spring:message code='ezAddress.t173' /></span></a></div>
	                    </div>
	                    <div id="TreeViewPane" style="DISPLAY: none;">
	                        <table style="border-collapse: collapse; border-spacing: 0; padding: 0px;">
	                            <tr>
	                                <td>
	                                    <div class="box" style="height: 501px; width: 220px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                                </td>
	                                <td style="width: 5px;"></td>
	                                <td id ="OrganListView" class="listview" style="overflow-y: auto; overflow-x: auto">
	                                    <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                        <tr>
	                                            <th style="white-space:normal">
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
	                                    <div style="vertical-align: top; height: 433px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                        <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
	                                            <tr>
	                                                <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezAddress.t124' /></td>
	                                                <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezAddress.t359' /></td>
	                                                <td class="td_gray" style="font-weight: bold;"><spring:message code='ezAddress.t192' /></td>
	                                            </tr>
	                                        </table>
	                                        <table style="width: 100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
	                                            <tr>
	                                                <td style="width: 110px; font-weight: bold;" class="td_gray">1</td>
	                                                <td style="width: 90px; font-weight: bold;" class="td_gray">2</td>
	                                                <td style="width: 80px; font-weight: bold;" class="td_gray">3</td>
	                                                <td class="td_gray" style="font-weight: bold;">4</td>
	                                            </tr>
	                                        </table>
	                                    </div>
                                        <div style="vertical-align: top; text-align: center; height: 433px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>                                     
	                                    <div id="tblPageRayer2" style="text-align:center;border-top:1px solid #B6B6B6"></div>	                                    
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	                    <div id="IDListView" style="OVERFLOW: hidden;">
	                        <table>
	                            <tr>
	                                <td>
	                                    <div class="box" style="OVERFLOW-Y: auto; OVERFLOW-X: auto; WIDTH: 220px; HEIGHT: 501px; BACKGROUND-COLOR: #ffffff;padding-top:5px" id="AddressTreeView"></div>
	                                </td>
	                                <td style="width: 5px;"></td>
	                                <td>
	                                    <div style="vertical-align: middle; border: 1px solid #bdbdbd; border-bottom: 0px; height: 20px; padding-top: 5px; padding-left: 5px;">
	                                    <img src="/images/ImgIcon/fldr.gif" width="15" height="15" align="absmiddle" hspace="2" style="cursor: pointer">
	                                    <span id="addressFolderName" style="font-weight: bold;"></span>
	                                    -[<span id="addressFolderCnt" style="color: #017BEC; font-weight: bold;"></span>]
	                            </div>
	                                    <div id="AddressListView" style="BORDER: #b6b6b6 1px solid; OVERFLOW: auto; WIDTH: 440px; HEIGHT: 443px; BACKGROUND-COLOR: white" class="listview"></div>
	                                    <div id="tblPageRayer"  style="width:440px;border:#b6b6b6 1px solid;"></div>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	                </td>
	                <td style="width: 30px; text-align: center">
	                    <img src="/images/kr/cm/arr_right.gif" width="16" height="16" onclick="InsertReceiver(ListViewMsgTo)" style="CURSOR: pointer;">
	                    <img src="/images/kr/cm/arr_left.gif" width="16" height="16" onclick="DeleteReceiver(ListViewMsgTo)" style="CURSOR: pointer">
	                </td>
	                <td style="vertical-align: top;">
	                    <div class="listview">
	                        <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event)" style="border: 0px solid; Width: 245px; Height: 503px; overflow:auto;" onrowdblclick="DeleteReceiver(this)" onclick="SelectReceiverWindow(this)"></div>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </form>
	</body>
</html>


