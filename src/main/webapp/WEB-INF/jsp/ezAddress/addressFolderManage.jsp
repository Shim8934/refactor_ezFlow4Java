<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezAddress.t144' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/Controls/treeview.htc.js"></script>
	    <script>
	        var companyadmin = "${companyAdmin}";
	        var deptadmin = "${deptAdmin}";
	        var szNames = "";
	        var _folderID = "";
	        var inputNameOKFlag = false;
	        var ReturnFunction;
	        var ReturnValue;
	        var DivPopup = false;
	        var pNoneActiveX = "${noneActiveX}";
	        window.onload = function () {
	            window.returnValue = 0;
	            LoadAddressTree();
	            try {
	                ReturnFunction = opener.address_foldermanage_dialogArguments[1];
	            } catch (e) {
	                try {
	                    ReturnFunction = parent.address_foldermanage_dialogArguments[1];
	                    DivPopup = true;
	                } catch (e) { }
	            }
	        }
	        window.onunload = function () {
	            if (ReturnFunction!=null && !DivPopup)
	                ReturnFunction(ReturnValue);
	        }
	        function Window_close() {
	            if (DivPopup) {
	                ReturnValue = 0;
	                ReturnFunction(ReturnValue);
	            }
	            else {
	                window.returnValue = 0;
	                window.close();
	            }
	        }
	        var AddressTreeView = null;
	        function LoadAddressTree() {
	            if (AddressTreeView == null) {
	                AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');
	                AddressTreeView.attachEvent('requestdata', requestdata);
	                AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	            }
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
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
	            AddressTreeView.toggle(1);
	            if (AddressTreeView.selectedIndex() == -1) {
	                AddressTreeView.select(1);
	            }
	        }
	        function requestdata(event) {
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
	        function select_onclick() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (nodeIdx == -1) {
	                alert("<spring:message code='ezAddress.t148' />");
	                return;
	            }
	            var type = AddressTreeView.getvalue(nodeIdx, "type");
	            var folderID = AddressTreeView.getvalue(nodeIdx, "folderid");
	            if (ReturnFunction!=null) {
	                ReturnValue = type + ":" + folderID;
	                ReturnFunction(ReturnValue);
	            }
	            else {
	                window.returnValue = type + ":" + folderID;
	                window.close();
	            }
	        }
	        var inputnamedlg_cross_dialogArguments = new Array();
	        function add_onclick() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (nodeIdx == -1) {
	                alert("<spring:message code='ezAddress.t148' />");
	                return;
	            }
	            if (AddressTreeView.getvalue(nodeIdx, "type") == "D" && deptadmin != "Y") {
	                alert("<spring:message code='ezAddress.t149' />");
	                return;
	            }
	            if (AddressTreeView.getvalue(nodeIdx, "type") == "C" && companyadmin != "Y") {
	                alert("<spring:message code='ezAddress.t150' />");
	                return;
	            }
	            szNames = "";
	            if (CrossYN() || (pNoneActiveX=="YES")) {
	                inputnamedlg_cross_dialogArguments[0] = "";
	                inputnamedlg_cross_dialogArguments[1] = add_onclick_Complete;
	                inputnamedlg_cross_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(330, 150, "/ezAddress/addressInputNameDlg.do");
	            }
	            else {
	                var feature = "dialogHeight:200px; dialogwidth:330px; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(330, 200);
	                var ArgObjet = new Array();
	                ArgObjet[0] = window;
	                ArgObjet[1] = szNames;
	                window.showModalDialog("/ezAddress/addressInputNameDlg.do", ArgObjet, feature);
	                add_onclick_Complete();
	            }
	        }
	        function add_onclick_Complete()
	        {
	            DivPopUpHidden();
	            if (inputNameOKFlag == false)
	                return;
	
	            inputNameOKFlag = false;
	            if (get_length(szName) > 100) {
	                alert("<spring:message code='ezAddress.t151' />");
	                return;
	            }
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertCDataText(xmlDom, objNode, "PARENTID", AddressTreeView.getvalue(nodeIdx, "folderid"));
	            createNodeAndInsertCDataText(xmlDom, objNode, "NAME", szName);
	            createNodeAndInsertCDataText(xmlDom, objNode, "TYPE", AddressTreeView.getvalue(nodeIdx, "type"));
	            createNodeAndInsertCDataText(xmlDom, objNode, "OWNERID", AddressTreeView.getvalue(nodeIdx, "ownerid"));
	            
	            /* if (AddressTreeView.getvalue(nodeIdx, "type") == "P")
	                xmlHTTP.open("POST", "/myoffice/ezAddress/remoteews/address_add_folder.aspx", false);
	            else
	                xmlHTTP.open("POST", "/myoffice/ezAddress/remote/address_add_folder.aspx", false); */
	            xmlHTTP.open("POST", "/ezAddress/addressAddFolder.do", false);
	            
	            xmlHTTP.send(xmlDom);
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText == "ERROR") {
	                alert("<spring:message code='ezAddress.t152' />");
	            }
	            else {
	                alert("<spring:message code='ezAddress.t153' />");
	
	                var childXML = "<node imgidx='1' caption=\"" + MakeRightField(szName) + "\" ownerid='" +
	                        MakeRightField(AddressTreeView.getvalue(nodeIdx, "ownerid")) +
	                        "' type='" + AddressTreeView.getvalue(nodeIdx, "type") +
	                        "' folderid='" + xmlHTTP.responseText + "' />";
	                AddressTreeView.addnode(nodeIdx, childXML);
	                if (ReturnFunction!=null)
	                    ReturnValue = 1;
	                else
	                    window.returnValue = 1;
	            }
	        }
	        function modify_onclick() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (nodeIdx == -1) {
	                alert("<spring:message code='ezAddress.t148' />");
	                return;
	            }
	            else if (AddressTreeView.getvalue(nodeIdx, "nodelevel") == "Y") {
	                alert("<spring:message code='ezAddress.t154' />");
	                    return;
	                }
	            if (AddressTreeView.getvalue(nodeIdx, "TYPE") == "D" && deptadmin != "Y") {
	                alert("<spring:message code='ezAddress.t155' />");
	                return;
	            }
	            if (AddressTreeView.getvalue(nodeIdx, "TYPE") == "C" && companyadmin != "Y") {
	                alert("<spring:message code='ezAddress.t156' />");
	                return;
	            }
	            szNames = AddressTreeView.getvalue(nodeIdx, "caption");
	            _foldertype = AddressTreeView.getvalue(nodeIdx, "type");
	            _folderID = AddressTreeView.getvalue(nodeIdx, "folderid");
	            if (CrossYN() || (pNoneActiveX == "YES")) {
	                inputnamedlg_cross_dialogArguments[0] = szNames;
	                inputnamedlg_cross_dialogArguments[1] = modify_onclick_Complete;
	                inputnamedlg_cross_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(330, 150, "/ezAddress/addressInputNameDlg.do");
	            }
	            else {
	                var ArgObjet = new Array();
	                var feature = "dialogHeight:200px; dialogwidth:330px; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(330, 200);
	                ArgObjet[0] = window;
	                ArgObjet[1] = szNames;
	                window.showModalDialog("/ezAddress/addressInputNameDlg.do", ArgObjet, feature);
	                modify_onclick_Complete();
	            }
	        }
	        function modify_onclick_Complete() {
	            DivPopUpHidden();
	            var nodeIdx = AddressTreeView.selectedIndex();
	            _folderID = "";
	            if (inputNameOKFlag == false)
	                return;
	
	            inputNameOKFlag = false;
	            if (get_length(szName) > 100) {
	                alert("<spring:message code='ezAddress.t151' />");
	                return;
	            }
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertCDataText(xmlDom, objNode, "FOLDERID", AddressTreeView.getvalue(nodeIdx, "folderid"));
	            createNodeAndInsertCDataText(xmlDom, objNode, "CHANGEKEY", AddressTreeView.getvalue(nodeIdx, "changekey"));
	            createNodeAndInsertCDataText(xmlDom, objNode, "FOLDERTYPE", AddressTreeView.getvalue(nodeIdx, "type"));
	            createNodeAndInsertCDataText(xmlDom, objNode, "FOLDERNAME", szName);
	            
	            /* if (AddressTreeView.getvalue(nodeIdx, "type") == "P")
	                xmlHTTP.open("POST", "/myoffice/ezAddress/RemoteEWS/address_mod_folder.aspx", false);
	            else
	                xmlHTTP.open("POST", "/myoffice/ezAddress/Remote/address_mod_folder.aspx", false); */
	            xmlHTTP.open("POST", "/ezAddress/addressModFolder.do", false);
	            
	            xmlHTTP.send(xmlDom);
	
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                alert("<spring:message code='ezAddress.t157' />");
	            else {
	                alert("<spring:message code='ezAddress.t158' />");
	                AddressTreeView.putcaption(nodeIdx, szName);
	                if (ReturnFunction!=null)
	                    ReturnValue = 1;
	                else
	                    window.returnValue = 1;
	            }
	        }
	        function delete_onclick() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (nodeIdx == -1) {
	                alert("<spring:message code='ezAddress.t148' />");
	                return;
	            }
	            else if (AddressTreeView.getvalue(nodeIdx, "nodelevel") == "Y") {
	                alert("<spring:message code='ezAddress.t159' />");
	                return;
	            }
	            else if (AddressTreeView.haschild(nodeIdx)) {
	                alert("<spring:message code='ezAddress.t160' />");
	                    return;
	                }
	        if (AddressTreeView.getvalue(nodeIdx, "TYPE") == "D" && deptadmin != "Y") {
	            alert("<spring:message code='ezAddress.t161' />");
	                return;
	            }
	            if (AddressTreeView.getvalue(nodeIdx, "TYPE") == "C" && companyadmin != "Y") {
	                alert("<spring:message code='ezAddress.t162' />");
	                return;
	            }
	            if (confirm("<spring:message code='ezAddress.t163' />")) {
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlDom = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlDom, objNode, "DATA");
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERID", AddressTreeView.getvalue(nodeIdx, "folderid"));
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", AddressTreeView.getvalue(nodeIdx, "type"));
	                
	                /* if (AddressTreeView.getvalue(nodeIdx, "type") == "P")
	                    xmlHTTP.open("POST", "/myoffice/ezAddress/RemoteEWS/address_del_folder.aspx", false);
	                else
	                    xmlHTTP.open("POST", "/myoffice/ezAddress/Remote/address_del_folder.aspx", false); */
	                xmlHTTP.open("POST", "/ezAddress/addressDelFolder.do", false);
	                
	                xmlHTTP.send(xmlDom);
	
	                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                    alert("<spring:message code='ezAddress.t164' />");
	
	                else {
	                    alert("<spring:message code='ezAddress.t165' />");
	                    LoadAddressTree();
	                    if (ReturnFunction!=null)
	                        ReturnValue = 1;
	                    else
	                        window.returnValue = 1;
	                }
	            }
	        }
	        var address_movecopy_dialogArguments = new Array();
	        function move_onclick() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (nodeIdx == -1) {
	                alert("<spring:message code='ezAddress.t148' />");
	                return;
	            }
	            else if (AddressTreeView.getvalue(nodeIdx, "nodelevel") == "Y") {
	                alert("<spring:message code='ezAddress.t166' />");
	                return;
	            }
	            else if (AddressTreeView.getvalue(nodeIdx, "hassub") == "1") {
	                alert("<spring:message code='ezAddress.t167' />");
	                return;
	            }
	            if (AddressTreeView.getvalue(nodeIdx, "type") == "D" && deptadmin != "Y") {
	                alert("<spring:message code='ezAddress.t168' />");
	                return;
	            }
	            if (AddressTreeView.getvalue(nodeIdx, "type") == "C" && companyadmin != "Y") {
	                alert("<spring:message code='ezAddress.t169' />");
	                return;
	            }
	            if (CrossYN() || (pNoneActiveX == "YES")) {
	                address_movecopy_dialogArguments[0] = "";
	                address_movecopy_dialogArguments[1] = move_onclick_Complete;
	                address_movecopy_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(320, 375, "/ezAddress/addressMoveCopy.do?checkadmin=1");
	            }
	            else {
	                var feature = "dialogHeight:375px; dialogWidth:320px; status:no; help:no; edge:sunken";
	                feature = feature + GetShowModalPosition(320, 375);
	                var moveUrl = window.showModalDialog("/ezAddress/addressMoveCopy.do?checkadmin=1", null, feature);
	                if (typeof (moveUrl) == "undefined")
	                    return;
	                if (moveUrl["folderid"] == AddressTreeView.getvalue(nodeIdx, "folderid") && moveUrl["ownerid"] == AddressTreeView.getvalue(nodeIdx, "ownerid")) {
	                    alert("<spring:message code='ezAddress.t170' />");
	                    return;
	                }
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlDom = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlDom, objNode, "DATA");
	                createNodeAndInsertText(xmlDom, objNode, "FOLDERID", AddressTreeView.getvalue(nodeIdx, "folderid"));
	                createNodeAndInsertText(xmlDom, objNode, "TYPE", AddressTreeView.getvalue(nodeIdx, "type"));
	                createNodeAndInsertText(xmlDom, objNode, "CMD", moveUrl["cmd"]);
	                createNodeAndInsertText(xmlDom, objNode, "NEWPARENTID", moveUrl["folderid"]);
	                createNodeAndInsertText(xmlDom, objNode, "NEWOWNERID", moveUrl["ownerid"]);
	                createNodeAndInsertText(xmlDom, objNode, "NEWFOLDERTYPE", moveUrl["foldertype"]);
	                xmlHTTP.open("POST", "/ezAddress/addressMoveCopyFolder.do", false);
	                xmlHTTP.send(xmlDom);
	                if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                    alert("<spring:message code='ezAddress.t171' />");
	                else {
	                    alert("<spring:message code='ezAddress.t172' />");
	                    LoadAddressTree();
	                    if (CrossYN())
	                        ReturnValue = 1;
	                    else
	                        window.returnValue = 1;
	                }
	            }
	        }
	        function move_onclick_Complete(moveUrl) {
	            DivPopUpHidden();
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (typeof (moveUrl) == "undefined")
	                return;
	            if (moveUrl["folderid"] == AddressTreeView.getvalue(nodeIdx, "folderid") && moveUrl["ownerid"] == AddressTreeView.getvalue(nodeIdx, "ownerid")) {
	                alert("<spring:message code='ezAddress.t170' />");
	                return;
	            }
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDom = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertText(xmlDom, objNode, "FOLDERID", AddressTreeView.getvalue(nodeIdx, "folderid"));
	            createNodeAndInsertText(xmlDom, objNode, "TYPE", AddressTreeView.getvalue(nodeIdx, "type"));
	            createNodeAndInsertText(xmlDom, objNode, "CMD", moveUrl["cmd"]);
	            createNodeAndInsertText(xmlDom, objNode, "NEWPARENTID", moveUrl["folderid"]);
	            createNodeAndInsertText(xmlDom, objNode, "NEWOWNERID", moveUrl["ownerid"]);
	            createNodeAndInsertText(xmlDom, objNode, "NEWFOLDERTYPE", moveUrl["foldertype"]);
	            xmlHTTP.open("POST", "/ezAddress/addressMoveCopyFolder.do", false);
	            xmlHTTP.send(xmlDom);
	            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
	                alert("<spring:message code='ezAddress.t171' />");
	            else {
	                alert("<spring:message code='ezAddress.t172' />");
	                LoadAddressTree();
	                if (ReturnFunction!=null)
	                    ReturnValue = 1;
	                else
	                    window.returnValue = 1;
	            }
	        }
	        function get_length(chkstr) {
	            var length = 0;
	            var i;
	
	            for (i = 0; i < chkstr.length; i++)
	                if (chkstr.charCodeAt(i) > 256)
	                    length = length + 2;
	                else
	                    length++;
	
	            return length;
	        }
	    </script>
	</head>
	<body class="popup" style="overflow: hidden">
	
	    <h1>${title}</h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="Window_close();"><spring:message code='ezAddress.t5' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	    <div style="margin-top: -5px; margin-bottom: 5px;">
		    <c:choose>
		    	<c:when test="${show == 'Y'}">
		    		<a class="imgbtn"><span onclick="select_onclick()"><spring:message code='ezAddress.t25' /></span></a>
		        	<a class="imgbtn"><span onclick="add_onclick()"><spring:message code='ezAddress.t173' /></span></a>
		        	<a class="imgbtn"><span onclick="modify_onclick()"><spring:message code='ezAddress.t174' /></span></a>
		    	</c:when>
		    	<c:otherwise>
		    		<a class="imgbtn"><span onclick="add_onclick()"><spring:message code='ezAddress.t173' /></span></a>
		        	<a class="imgbtn"><span onclick="modify_onclick()"><spring:message code='ezAddress.t174' /></span></a>
		        	<a class="imgbtn"><span onclick="delete_onclick()"><spring:message code='ezAddress.t175' /></span></a>
		        	<a class="imgbtn"><span onclick="move_onclick()"><spring:message code='ezAddress.t176' /></span></a>
		    	</c:otherwise>
		    </c:choose>
	    </div>
	    <table class="content" style="width: 100%;">
	        <tr>
	            <td class="pos1" style="padding-right: 8px; width: 100%;">
	                <div class="tree" style="border: 0; margin-left: 5px; width: 100%; height: 370px; overflow: auto" id="AddressTreeView"></div>
	            </td>
	        </tr>
	    </table>
	    <xml id="AddressFolderXML" style="display: none;">
			${rootAddressXML}
		</xml>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>


