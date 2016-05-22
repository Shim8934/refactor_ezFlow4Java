<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title>left_myoffice</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <script type="text/javascript">
	        var pUse_Editor = "${useEditor}";
	        var subCode = "${subCode}";
	        var funcCode = "1"; //${funCode}
	        var g_szMailFolderURL = "http://${mailServerAddress}/exchange/${userinfo.EmailID}"; //추후 수정
	        var g_firstOpen = true;
	        var lang = "${userinfo.lang}";
	        var pNoneActiveX = "${noneActiveX}";
	        document.onselectstart = function () { return false; };
	        window.onresize = function () {
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.58 + "px";
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.38 + "px";
	            }
	        }
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.58 + "px";
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";
	                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.58 + "px";
	            }
	            document.getElementById("mailexportall").style.display = "none";
	            Function_Flag(funcCode);
	            LoadAddressTree(true);
	        }
	        function write_Letter() {
	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 890)
	                conWidth = 890;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;
	            var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            if (CrossYN() || pNoneActiveX == "YES") {
	                window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	            }
	            else {
	                if (pUse_Editor == "")
	                    window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	                else {
	
	                    window.open("/ezEmail/mailWrite.do?cmd=NEW", "", feature);
	                }
	            }          
	        }
	        function LoadEmailTree() {
	            var PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            PostTreeView.attachEvent('requestdata', requestdata);
	            PostTreeView.attachEvent('nodeselect', selectnode);
	            PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
	            PostTreeView.attachEvent('dragdrop', email_dragdrop);
	            PostTreeView.dragdrop(true);
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (navigator.userAgent.indexOf('MSIE') == -1) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else
	                treeconfig = xmlHTTP.responseXML;
	
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + document.getElementById("RootFolderXML").innerHTML + "</nodes></tree>");
	            PostTreeView.update();
	            if (subCode != "1" && subCode != "") {
	                PostTreeView.select(subCode);
	                selectnode();
	            }
	            else
	                PostTreeView.select(1);
	        }
	        function requestdata(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, true);
	            PostTreeView.putchildxml(nodeIdx, childxml);
	        }
	        function selectnode() {
	            var nodeIdx = PostTreeView.selectedIndex();
	            var href = PostTreeView.getvalue(nodeIdx, "href");
	            var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(PostTreeView.getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(nodeIdx, "href"));
	            try {
	                if (typeof (parent.frames["right"]) != "undefined")
	                    parent.frames["right"].Window_onunload();
	            } catch (e) { }
	            if (g_firstOpen)
	                g_firstOpen = false;
	            else
	                window.open(url, "right");
	            get_unreadcount();
	        }
	        function email_dragdrop(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	
	            var szCommand = (event.bctrl) ? "copy" : "move";
	            var szSubCommand = event.command;
	
	            if (navigator.userAgent.indexOf('MSIE') == -1) {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").move_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").copy_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	            }
	            else {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.move_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.copy_on_dragdrop(PostTreeView.getvalue(event.nodeIdx, "href"));
	                    } catch (e) { }
	                }
	            }
	        }
	        var xmlHTTP_Unread = null;
	        function get_unreadcount_2010() {
	            if (xmlHTTP_Unread != null)
	                return;
	            try {
	                xmlHTTP_Unread = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "URL", PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"));
	                xmlHTTP_Unread.open("POST", "/ezEmail/getFolderUnreadCount.do", true);
	                xmlHTTP_Unread.onreadystatechange = get_unreadend_2010;
	                get_unreadend_2010.href = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	                xmlHTTP_Unread.send(xmlpara);
	            }
	            catch (e) {
	                xmlHTTP_Unread = null;
	            }
	        }
	        function get_unreadend_2010() {
	            if (xmlHTTP_Unread == null || xmlHTTP_Unread.readyState != 4)
	                return;
	            if (xmlHTTP_Unread.status >= 200 && xmlHTTP_Unread.status < 300) {
	                var unreadcount = getNodeText(SelectNodes(xmlHTTP_Unread.responseXML, "DATA")[0]);
	                var caption = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	
	                if (get_unreadend_2010.href == PostTreeView.getvalue(PostTreeView.selectedIndex(), "href")) {
	                    if (unreadcount == "0") {
	                        PostTreeView.putcaption(PostTreeView.selectedIndex(), caption);
	                    }
	                    else {
	                        PostTreeView.putcaption(PostTreeView.selectedIndex(), caption + "(" + unreadcount + ")");
	                        try { parent.frames["right"].mailBoxInfo.childNodes.item(1).innerText = " " + unreadcount + " "; } catch (e) { }
	                    }
	                    xmlDom = null;
	                }
	            }
	            xmlHTTP_Unread = null;
	        }
	        function get_unreadcount() {
	            return get_unreadcount_2010();
	        }
	        function check_pop3() {
	            if (!CrossYN()) {
	                var feature = "dialogWidth:460px; dialogHeight:360px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(460, 360);
	                window.showModalDialog("/myoffice/ezEmail/mail_getpop3.aspx", "check pop3", feature);
	            }
	            else {
	                var OpenWin = window.open("/myoffice/ezEmail/mail_getpop3_cross.aspx", "mail_getpop3_cross", GetOpenWindowfeature(460, 360));
	                try { OpenWin.focus(); } catch (e) { }
	            }
	        }
	        function mail_exportall() {
	            var param = { "href": new Array(), "parent": new Object(), "url": new String() };
	            param["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            param["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            var feature = "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	            feature = feature + GetShowModalPosition(480, 265);
	            window.showModalDialog("/myoffice/ezEmail/htm/mail_exportall.aspx", param, feature);
	        }
	        var mail_foldermanage_Cross_dialogArguments = new Array();
	        function folder_manage() {
	            mail_foldermanage_Cross_dialogArguments[1] = folder_manager_after;
	            var OpenWin = window.open("/ezEmail/mailFolderManage.do", "mail_foldermanage_Cross", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function folder_manager_after(RtnVal) {
	            if (RtnVal) {
	                var href = PostTreeView.getvalue(1, "href");
	                var url = "/ezEmail/mailList.do?dispname=" + encodeURI(PostTreeView.getvalue(1, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(1, "href"));
	                PostTreeView.source("<tree><nodes>" + get_childXML("", true, true) + "</nodes></tree>");
	                PostTreeView.update();
	                if (PostTreeView.selectedIndex() == -1) {
	                    PostTreeView.select(1);
	                }
	                window.open(url, "right");
	            }
	        }
	        function Function_Flag(v_data) {
	            v_data = parseInt(v_data);
	
	            switch (v_data) {
	                case 1:
	                    LoadEmailTree();
	                    break;
	                case 2:
	                    LoadEmailTree();
	                    WebPartToggle(level1El.item(1));
	                    break;
	            }
	        }
	        function WebPartToggle(obj) {
	
	            if (obj.listNum && currentListNum != obj.listNum + 1) {
	                level1El.item(currentListNum - 1).className = null;
	                level2El.item(currentListNum - 1).className = "off";
	            }
	
	            if (level2El.item(obj.listNum).className == "on") {
	                level1El.item(obj.listNum).className = null;
	                level2El.item(obj.listNum).className = "off";
	            }
	            else {
	                level1El.item(obj.listNum).className = "on";
	                level2El.item(obj.listNum).className = "on";
	            }
	
	            currentListNum = obj.listNum + 1;
	
	            setMenu(level2El.item(obj.listNum));
	        }
	        function TreeView_toggle(TreeView, TreeFunc, subfolder) {
	            if (TreeView.style.display == "none") {
	                if (typeof (subfolder) != "undefined")
	                    TreeFunc(subfolder);
	                else
	                    TreeFunc();
	            }
	            else
	                TreeView.style.display = "none";
	        }
	        function Open_Mail(treeid) {
	            PostTreeView.select(treeid);
	        }
	        function Open_Search() {
	            try {
	                var url;
	                url = "/ezEmail/mailSearchView.do";
	                window.open(url, "right");
	            } catch (e) { }
	        }
	        function Open_ReservationManage() {
	            if (!CrossYN()) {
	                var feature = "dialogHeight:350px; dialogWidth:501px; status:no;scroll:auto; help:no; edge:sunken";
	                feature = feature + GetShowModalPosition(501, 350);
	                window.showModalDialog("/myoffice/ezEmail/mail_reservation.aspx", "", feature);
	            }
	            else {
	                var OpenWin = window.open("/ezEmail/mailReservation.do", "mail_reservation_cross", GetOpenWindowfeature(501, 350));
	                try { OpenWin.focus(); } catch (e) { }
	            }
	        }
	        function Open_Restore() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 500) / 2;
	            var pLeft = (pwidth - 700) / 2;
	            var name = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            var path = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            var OpenWin;
	            if (!CrossYN())
	                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted.aspx?name=" + encodeURI(name) + "&path=" + encodeURI(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
	            else
	                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted_cross.aspx?name=" + encodeURI(name) + "&path=" + encodeURI(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function spam_mail() {
	            frmSpam.target = "right";
	            frmSpam.submit();
	        }
	        function mail_export() {
	            try {
	                parent.frames["right"].mail_export();
	            } catch (e) {
	                alert("<spring:message code="ezEmail.t640" />");
	            }
	        }
	        function mail_exportall() {
	            var param = { "href": new Array(), "parent": new Object(), "url": new String() };
	            param["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex, "foldername");
	            param["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex, "href");
	            param["parent"] = window.parent.frames("right");
	            var feature = "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	            feature = feature + GetShowModalPosition(480, 265);
	            window.showModalDialog("/myoffice/ezEmail/htm/mail_exportall.aspx", param, feature);
	        }
	        var mail_import_cross_dialogArguments = new Array();
	        function mail_import() {
	            var param = { "foldername": new Array(), "href": new Object() };
	            param["foldername"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            param["href"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            mail_import_cross_dialogArguments[0] = param;
	            mail_import_cross_dialogArguments[1] = mail_import_Complete;
	            var OpenWin = window.open("/myoffice/ezEmail/htm/mail_import_cross.aspx", "mail_foldermanage_Cross", GetOpenWindowfeature(500, 400));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function mail_import_Complete() {
	            window.parent.frames["right"].MailListRefresh();
	        }
	        function mail_Config() {
	            parent.frames["right"].location.href = "/ezEmail/mailConfig.do";
	        }
	        function Address_Menu_Click() {
	            LoadAddressTree(true);
	            if (AddressTreeView.selectedIndex() == -1)
	                AddressTreeView.select(1);
	            else
	                selectnode_address();
	        }
	        var AddressTreeView = null;
	        function LoadAddressTree() {
	            /* if (AddressTreeView == null) { //주소록할때 주석풀기
	                AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');
	
	                AddressTreeView.attachEvent('requestdata', requestdata_address);
	                AddressTreeView.attachEvent('nodeselect', selectnode_address);
	                AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	            }
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (navigator.userAgent.indexOf('MSIE') == -1) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else {
	                treeconfig = new ActiveXObject("Microsoft.XMLDOM");
	                treeconfig.async = false;
	                treeconfig.loadXML(xmlHTTP.responseText);
	            }
	            AddressTreeView.config(treeconfig);
	            AddressTreeView.source(document.getElementById("AddressFolderXML").innerHTML);
	            AddressTreeView.update();
	
	            if (funcCode == "2") {
	                if (subCode != "1" && subCode != "") {
	                    AddressTreeView.select(subCode);
	                    selectnode_address();
	                }
	                else
	                    AddressTreeView.select(1);
	            } */
	        }
	        function requestdata_address(event) {
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
	        function selectnode_address() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var url = "/myoffice/ezAddress/address_mainlist.aspx?folderid=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "folderid")) + "&ownerid=" + encodeURI(AddressTreeView.getvalue(nodeIdx, "ownerid")) + "&type=" + encodeURI(AddressTreeView.getvalue(nodeIdx, "type"));
	            window.open(url, "right");
	        }
	        var address_foldermanage_dialogArguments = new Array();
	        function address_foldermanage() {
	            address_foldermanage_dialogArguments[1] = address_foldermanage_Complete;
	            var OpenWin = window.open("/myoffice/ezAddress/address_foldermanage.aspx", "address_foldermanage", GetOpenWindowfeature(450, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        function address_foldermanage_Complete(ret) {
	            if (ret != undefined) LoadAddressTree();
	        }
	        function address_Search() {
	            window.open("/myoffice/ezAddress/address_mainsearch.aspx", "right");
	        }
	        function Email_Menu_Click() {
	            PostTreeView.select(1);
	        }
	    </script>
	</head>
	<body class="leftbody" style="overflow: hidden;">
	    <div id="left">
	        <div class="left_mail" title="<spring:message code="ezEmail.t99000012" />"></div>
	        <h2><span onclick="Email_Menu_Click();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000012" /></span></h2>
	        <ul>
	            <div class="tree" style="width: 179px; height: 100%; background-color: #e6e6e6; overflow: auto; margin-left: 20px;" id="PostTreeView"></div>
	            <li><span onclick="write_Letter()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000013" /></span></li>
	            <li><span onclick="folder_manage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t481" /></span></li>
	            <li><span onclick="Open_Search();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t641" /></span></li>
	            <li><span onclick="check_pop3()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t490" /></span></li>
	            <li id="mailexport"><span style="width: 100%; display: inline-block;" onclick="mail_export()"><spring:message code="ezEmail.t378" /></span></li>
	            <li id="mailexportall" style="display: none;"><span style="width: 100%; display: inline-block;" onclick="mail_exportall()"><spring:message code="ezEmail.t99000014" /></span></li>
	            <li id="mailimport"><span onclick="mail_import()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000015" /></span></li>
	            <!-- <li><span onclick="Open_Restore()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000016" /></span></li> -->
	            <li><span onclick="Open_ReservationManage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t605" /></span></li>
	        </ul>
	        <h2><span onclick="Address_Menu_Click();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000041" /></span></h2>
	        <ul>
	            <div class="tree" style="width: 179px; height: 100%; background-color: #e6e6e6; overflow: auto; margin-left: 20px;" id="AddressTreeView"></div>
	            <li><span id='Address_Search' onclick="address_Search();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000042" /></span></li>
	            <li evt="0"><span onclick="address_foldermanage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000043" /></span></li>
	        </ul>
	        <h3><span onclick="mail_Config()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000044" /></span></h3>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    <xml id="RootFolderXML" style="display: none;">
	    ${rootFolderXML}
	    </xml>
	    <xml id="AddressFolderXML" style="display: none;">
	    <%--=RootAddressXML --%>
	    </xml>
	</body>
</html>