<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>left_myoffice</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="/js/ezEmail/lang/ezEmail_en.js"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script>
    <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>
    <script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
    <script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/ezAddress/address_tree.js"></script>
    <link rel="stylesheet" href="/css/default_kr.css">
    <link rel="stylesheet" href="/css/email_tree.css" type="text/css">
    <script type="text/javascript">
        var pUse_Editor = "${useEditor}";
        var subCode = "${subCode}";
        var funcCode = "${funCode}";
        var g_szMailFolderURL = "http://${serverName}/exchange/${userinfo.EmailID}"; //scheme(http,https) 설정
        var g_firstOpen = true;
        var lang = "${userinfo.lang}";
        var p_Use_IE11Browser = "${useIE11Browser}";
        var PcFolderPath = "${pcFolderPath}";
        window.onresize = function () {
            if (document.documentElement.clientHeight > 800) {
                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.48) + "px";
                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.48 + "px";
            }
            else {
                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.36) + "px";
                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.36 + "px";
            }

        }
        window.onload = function () {
            document.onselectstart = function () { return false; };
            if (document.documentElement.clientHeight > 800) {
                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.48) + "px";
                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.48 + "px";
            }
            else {
                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.36) + "px";
                document.getElementById("AddressTreeView").style.maxHeight = document.documentElement.clientHeight * 0.36 + "px";
            }
            if (!CrossYN()) {
                document.getElementById("mailexportall").style.display = "";
                document.getElementById("mailimport").style.display = "";
            }
            Function_Flag(funcCode);
            LoadAddressTree(true);

            try {
                LoadEmailTree_pc(PcFolderPath);
            }
            catch (e) { }
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
            var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
            //if (CrossYN() || pNoneActiveX == "YES") {            
            if (CrossYN() == "YES") {
                window.open("/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW", "", feature);
            }
            else {
                if(pUse_Editor == "")
                    window.open("/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW", "", feature);
                else
                    window.open("/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW", "", feature);
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
            xmlHTTP.open("GET", "/myoffice/common/organtree_config2.xml", false);
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
            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, true)
            PostTreeView.putchildxml(nodeIdx, childxml);
        }
        function selectnode() {
            var nodeIdx = PostTreeView.selectedIndex();
            var href = PostTreeView.getvalue(nodeIdx, "href");
            var url = "/myoffice/ezEmail/mail_list.aspx?dispname=" + encodeURIComponent(PostTreeView.getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(nodeIdx, "href"));
            try {
                if (typeof (parent.frames["right"]) != "undefined")
                    parent.frames["right"].Window_onunload();
            } catch (e) { }
            if (g_firstOpen)
                g_firstOpen = false;
            else
                parent.frames["right"].location.href = url;
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
                xmlHTTP_Unread.open("POST", "/myoffice/ezEmail/remote/mail_get_folderUnreadCount.aspx", true);
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

                var CurrentFolder = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");

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
            if (!CrossYN())
                window.showModalDialog("/myoffice/ezEmail/mail_getpop3.aspx", "check pop3", "dialogWidth:460px; dialogHeight:360px; scroll:no; status:no; help:no; scroll:no; edge:sunken");
            else
                window.showModalDialog("/myoffice/ezEmail/mail_getpop3_cross.aspx", "check pop3", "dialogWidth:460px; dialogHeight:360px; scroll:no; status:no; help:no; scroll:no; edge:sunken");
        }
        function folder_manage() {
            var ret;
            if (!CrossYN())
                ret = showModalDialog("/myoffice/ezEmail/mail_foldermanage.aspx", null, "dialogHeight:500px; dialogWidth:500px; status:no; help:no; scroll:no; edge:sunken");
            else
                ret = showModalDialog("/myoffice/ezEmail/mail_foldermanage_cross.aspx", null, "dialogHeight:500px; dialogWidth:500px; status:no; help:no; scroll:no; edge:sunken");

            var href = PostTreeView.getvalue(1, "href");
            var url = "/myoffice/ezEmail/mail_list.aspx?dispname=" + escape(PostTreeView.getvalue(1, "foldername")) + "&url=" + encodeURIComponent(PostTreeView.getvalue(1, "href"));
            PostTreeView.source("<tree><nodes>" + get_childXML("", true, true) + "</nodes></tree>");
            PostTreeView.update();
            if (PostTreeView.selectedIndex() == -1) {
                PostTreeView.select(1);
            }
            parent.frames["right"].location.href = url;
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
                url = "/myoffice/ezEmail/mail_search_cross.aspx";
                parent.frames["right"].location.href = url;
            } catch (e) { }
        }
        function Open_ReservationManage() {
            var OpenWin;
            if (!CrossYN())
                OpenWin = window.open("/myoffice/ezEmail/mail_reservation.aspx", "", GetOpenWindowfeature(501, 350));
            else
                OpenWin = window.open("/myoffice/ezEmail/mail_reservation_Cross.aspx", "", GetOpenWindowfeature(501, 350));

            try { OpenWin.focus(); } catch (e) { }
        }
        function Open_Restore() {
            var name = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
            var path = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
            var OpenWin;
            if (!CrossYN())
                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted.aspx?name=" + escape(name) + "&path=" + escape(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
            else
                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted_cross.aspx?name=" + escape(name) + "&path=" + escape(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));

            try { OpenWin.focus(); } catch (e) { }
        }
        function spam_mail() {
            frmSpam.target = "right";
            frmSpam.submit();
        }
        function Open_Func(pthis) {
            switch (pthis.id) {
                case "EMail":
                    window.parent.frames.right.document.location.href = "/myoffice/ezEmail/mail_list.aspx?Subfunction=1";
                    break;

                case "MailEnv":
                    window.parent.frames.item(1).location.href = "/myoffice/" + "ezEmail" + "/environ/mail_usage.aspx";
                    break;

                case "MailEnv_sub1":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_general.aspx";
                    break;

                case "MailEnv_sub2":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_usage.aspx";
                    break;

                case "MailEnv_sub3":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_pop3.aspx";
                    break;

                case "MailEnv_sub4":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_autoforward.aspx";
                    break;

                case "MailEnv_sub5":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_filter.aspx";
                    break;

                case "MailEnv_sub6":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_reject.aspx";
                    break;

                case "MailEnv_sub7":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_autodelete.aspx";
                    break;

                case "MailEnv_sub8":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_setbox.aspx";
                    break;

                case "MailEnv_sub9":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_signature.aspx";
                    break;
                case "MailEnv_sub10":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_outofoffice_prev.aspx";
                    break;
                case "MailEnv_sub11":
                    window.parent.frames.right.document.location.href = "/myoffice/" + "ezEmail" + "/environ/mail_smartReject.aspx";
                    break;
                default:
                    break;
            }
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
            param["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
            param["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href")
            param["parent"] = parent.frames["right"];            

            window.showModalDialog("/myoffice/ezEmail/htm/mail_exportall.aspx", param, "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken");
        }
        function mail_import() {
            var param = new Array();
            var nodeIdx = PostTreeView.selectedIndex();
            param["foldername"] = PostTreeView.getvalue(nodeIdx, "foldername");
            param["folderpath"] = PostTreeView.getvalue(nodeIdx, "href");
            param["parent"] = window;
            
            if (!CrossYN())
                window.showModalDialog("/myoffice/ezEmail/htm/mail_import.aspx", param, "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken");
            else
                window.showModalDialog("/myoffice/ezEmail/htm/mail_import_cross.aspx", param, "dialogWidth:480px; dialogHeight:265px; scroll:no; status:no; help:no; scroll:no; edge:sunken");
        }
        function mail_list_Refresh() {
            parent.frames["right"].MailListRefresh();
            get_unreadcount();
        }
        function mail_Config() {
            parent.frames["right"].location.href = "/myoffice/ezEmail/environ/mail_config.aspx";
        }
        var p_bopenpage;
        var AddressTreeView = null;
        function LoadAddressTree() {
            if (AddressTreeView == null) {
                AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');

                AddressTreeView.attachEvent('requestdata', requestdata_address);
                AddressTreeView.attachEvent('nodeselect', selectnode_address);
                AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
            }

            var xmlHTTP = createXMLHttpRequest();
            xmlHTTP.open("GET", "/myoffice/common/organtree_config2.xml", false);
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
            }
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
            var url = "/myoffice/ezAddress/address_mainlist.aspx?folderid=" + encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "folderid")) + "&ownerid=" + escape(AddressTreeView.getvalue(nodeIdx, "ownerid")) + "&type=" + escape(AddressTreeView.getvalue(nodeIdx, "type"));

            parent.frames["right"].location.href = url;
        }
        function address_requestdata() {
            var nodeIdx = window.event.nodeIdx;
            var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
            AddressTreeView.putchildxml(nodeIdx, childxml);
        }
        function address_foldermanage() {
            var ret;
            ret = showModalDialog("/myoffice/ezAddress/address_foldermanage.aspx", null, "dialogHeight:500px; dialogWidth:450px; status:no; help:no; scroll:no; edge:sunken");
            if (ret != undefined) LoadAddressTree();
        }
        function address_Search() {
            window.open("/myoffice/ezAddress/address_mainsearch.aspx", "right");
        }
        function Address_Menu_Click() {
            if (AddressTreeView.selectedIndex() == -1)
                AddressTreeView.select(1);
            else
                selectnode_address();
        }
        function Email_Menu_Click() {
            PostTreeView.select(1);
        }
        function folder_manage_pc() {
            window.open("/myoffice/ezEmail/PC_Email/PC_mail_foldermanage.aspx", "", GetOpenWindowfeature(400, 400));
        }
        function requestdata_pc() {
            if (!event) event = window.event;
            var nodeIdx = event.nodeIdx;
            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                nodeIdx = arguments[0].nodeIdx;
            }
            var childxml = PcGet_childXML(PostTreeView_pc.getvalue(nodeIdx, "href"), false, true)
            PostTreeView_pc.putchildxml(nodeIdx, childxml);
        }
        function PcGet_childXML(PcFolderPath) {
            if (PcFolderPath == "") {
                document.getElementById('noPcBox').style.display = "";
                return;
            }
            var folderXML = ezEmailClient.GetSubFolder(PcFolderPath);
            if (folderXML == "") {
                var result = ezEmailClient.CreateFolder(PcFolderPath + "\\개인편지");
                if (result.indexOf("ERROR") > 0) {
                    OpenAlertUI("초기편지함 생성중 에러발생. " + result);
                    return false;
                }
                else {
                    folderXML = ezEmailClient.GetSubFolder(PcFolderPath);
                }
            }
            return folderXML;
        }
        var PostTreeView_pc = null;
        function LoadEmailTree_pc(PcFolderPath) {
            if (PcFolderPath != "") {
                document.getElementById('noPcBox').style.display = "none";
                document.getElementById("PostTreeView_pc").style.display = "";
            }

            var folderXML = PcGet_childXML(PcFolderPath);
            if (folderXML.indexOf("경로를 찾을 수 없습니다.") < 0) {

                var xmlHTTP = createXMLHttpRequest();
                xmlHTTP.open("GET", "/myoffice/common/organtree_config2.xml", false);
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

                PostTreeView_pc = new TreeView('PostTreeView_pc', 'PostTreeView_pc');
                PostTreeView_pc.attachEvent('requestdata', requestdata_pc);
                PostTreeView_pc.attachEvent('nodeselect', selectnode_pc);
                PostTreeView_pc.attachEvent('dragdrop', email_dragdrop_pc);
                PostTreeView_pc.dragdrop(true);
                PostTreeView_pc.config(treeconfig);
                PostTreeView_pc.source("<tree><nodes>" + folderXML + "</nodes></tree>");
                PostTreeView_pc.update();
                xmlDom = null;
            }
            else {
                document.getElementById("PostTreeView_pc").style.display = "none";
                document.getElementById("noPcBox").style.display = "";
            }
        }
        var nodeIdx = "";
        function PcTree_getFolderPath() {
            return PostTreeView_pc.getvalue(nodeIdx, "href");
        }
        function selectnode_pc() {
            nodeIdx = PostTreeView_pc.selectedIndex();
            var href = PostTreeView_pc.getvalue(nodeIdx, "href");
            window.parent.frames["right"].location.href = "/myoffice/ezEmail/PC_Email/PC_mail_list.aspx";
        }
        function getFolderPath_pc() {
            var nodeIdx = PostTreeView_pc.selectedIndex();
            if (nodeIdx >= 0) {
                return PostTreeView_pc.getvalue(nodeIdx, "href")
            }
            else {
                return PcFolderPath;
            }
        }
        function email_dragdrop_pc() {
            var szCommand = (window.event.bctrl) ? "copy" : "move";
            var szSubCommand = window.event.command;
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
        function Archive_Menu_Click() {
            if (PostTreeView_pc != null) {
                if (PostTreeView_pc.selectedIndex() == -1)
                    PostTreeView_pc.select(1);
                else
                    selectnode_pc();
            }
        }
    </script>
</head>
<body class="leftbody" style="overflow: hidden;">
    <!--<object id="ezEmailClient" style="display: none; left: 0px; top: 0px" classid="clsid:D969B2C0-F76B-4E63-971F-CB794B9B9513" viewastext></object>-->
    <!--<object id="ezEmailClient" style="display: none; left: 0px; top: 0px" classid="clsid:C7A425C7-0BD5-4F9E-82DC-15D8627F8C07" viewastext></object>-->
    
    <div id="left">
        <div class="left_mail" title="<spring:message code="ezEmail.t99000012" />"></div>
        <h2><span onclick="Email_Menu_Click();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000012" /></span></h2>
        <ul>
            <div class="tree" style="width: 179px; height: 100%; background-color: #e6e6e6; overflow: auto; max-height: 300px; margin-left: 20px;" id="PostTreeView" ondragdrop="email_dragdrop()"></div>
            <li evt="0"><span onclick="write_Letter()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000013" /></span></li>
            <li evt="0"><span onclick="folder_manage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t481" /></span></li>
            <li><span onclick="Open_Search();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t641" /></span></li>
            <li evt="0"><span onclick="check_pop3()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t490" /></span></li>
            <li evt="0" id="mailexport"><span style="width: 100%; display: inline-block;" onclick="mail_export()"><spring:message code="ezEmail.t99000077" /></span></li>
            <li evt="0" id="mailexportall" style="display: none;"><span style="width: 100%; display: inline-block;" onclick="mail_exportall()"><spring:message code="ezEmail.t392" /></span></li>
            <li evt="0" id="mailimport" style="display: none;"><span onclick="mail_import()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000015" /></span></li>
            <li evt="0"><span onclick="Open_Restore()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000016" /></span></li>
            <li evt="0"><span onclick="Open_ReservationManage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t605" /></span></li>
        </ul>
        
        <c:if test="${param.use_ArchiveMailBox=='YES'}">
	        <h2><span onclick="Archive_Menu_Click()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t10002" /></span></h2>
	        <ul>
	            <div id="noPcBox" style="display: none; margin-left: 20px; margin-bottom: 10px; padding-top: 5px;">[<spring:message code="ezEmail.t10003" />]</div>
	            <div id="PostTreeView_pc" class="tree" style="width: 179px; height: 100px; background-color: #e6e6e6; overflow: auto; max-height: 300px; margin-left: 20px;" ondragdrop="email_dragdrop_pc()"></div>
	            <li evt="0"><span onclick="folder_manage_pc()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t10004" /></span></li>
	        </ul>
        </c:if>

        <h2><span onclick="Address_Menu_Click();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000041" /></span></h2>
        <ul>
            <div class="tree" style="width: 179px; height: 100%; background-color: #e6e6e6; overflow: auto; max-height: 300px; margin-left: 20px;" id="AddressTreeView"></div>
            <li><span id='Address_Search' onclick="address_Search();" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000042" /></span></li>
            <li evt="0"><span onclick="address_foldermanage()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000043" /></span></li>
        </ul>
        <h3 evt="0" style="height: auto"><span onclick="mail_Config()" style="width: 100%; display: inline-block;"><spring:message code="ezEmail.t99000044" /></span></h3>
    </div>
    <script type="text/javascript">
        initToggleList(document.getElementById("left"), "h2", "ul", "li");
    </script>
    <xml id="RootFolderXML" style="display: none;">
    <%--=RootFolderXML --%>
    </xml>
    <xml id="AddressFolderXML" style="display: none;">
    <%--=RootAddressXML --%>
    </xml>
</body>
</html>