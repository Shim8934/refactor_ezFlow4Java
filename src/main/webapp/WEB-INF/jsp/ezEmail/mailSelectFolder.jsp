<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t169' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script>
	        var lang = "${userinfo.lang}";
	        var ReturnFunction;
	        var CancelFunction;
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        function Window_Close() {
	            if (ReturnFunction!=null)
	                CancelFunction();
	            window.close();
	        }
	        var isDivPopup = false;
	        function window_onload() {
	            try {
	                ReturnFunction = parent.mail_selectfolder_cross_dialogArguments[1];
	                CancelFunction = parent.mail_selectfolder_cross_dialogArguments[2];
	                isDivPopup = true;
	            } catch (e) {
	                ReturnFunction = opener.mail_selectfolder_cross_dialogArguments[1];
	                CancelFunction = opener.mail_selectfolder_cross_dialogArguments[2];
	            }
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.getElementById("headerH1").style.marginTop = "0px";
	                document.getElementById("PostTreeView").style.borderRight = "1px solid #B6B6B6";
	                document.getElementById("PostTreeView").style.marginTop = "0px";
	            }
	            PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            PostTreeView.attachEvent('requestdata', requestdata);
	            PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
	
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else
	                treeconfig = loadXMLString(xmlHTTP.responseText);
	
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + get_childXML("", true, false) + "</nodes></tree>");
	            PostTreeView.update();
	
	            if (PostTreeView.selectedIndex() == -1) {
	                PostTreeView.select(1);
	            }
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
	        function btn_Select_onclick() {
	            if (PostTreeView.selectedIndex() == -1) {
	                alert("<spring:message code='ezEmail.t158' />");
	                return;
	            }
	            var retVal = new Array();
	            retVal["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption");
	            retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            ReturnFunction(retVal);
	            if (!isDivPopup)
	                window.close();
	        }
	        var inputNameDlg_cross_dialogArguments = new Array();
	        function add_onclick() {
	            var szName;
	            if (PostTreeView.selectedIndex() == -1) {
	                alert("<spring:message code='ezEmail.t158' />");
	                return;
	            }
	            inputNameDlg_cross_dialogArguments[0] = "";
	            inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
	            inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden_sub;
	            DivPopUpShow_sub(330, 150, "/ezEmail/inputNameDlg.do");
	        }
	        function add_onclick_Complete(szName) {
	            DivPopUpHidden_sub();
	            if (typeof (szName) == "undefined" || ReplaceText(szName, " ", "") == "")
	                return;
	
	            if (checkBadFolderName(szName))
	                return;
	
	            var szURL = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            var result = make_folder_2010(szURL, szName);
	            if (result != true) {
	                if (result == 405)
	                    alert("<spring:message code='ezEmail.t456' />");
	                else
	                    alert("<spring:message code='ezEmail.t457' />");
	                return;
	            }
	            var childXML = "<node imgidx='1' caption=\"" + MakeRightField(szName) + "\" ";
	            childXML += ("href='" + szURL + "/' ");
	            childXML += "/>";
	            var childxml = get_childXML(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), false, false)
	            PostTreeView.putchildxml(PostTreeView.selectedIndex(), childxml);
	        }
	        function LoadAddressTree(SelectIndex) {
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + get_childXML("", true, false) + "</nodes></tree>");
	            PostTreeView.update();
	            if (SelectIndex <= 5)
	                PostTreeView.toggle(SelectIndex);
	            else
	                PostTreeView.toggle(1);
	
	        }
	        function checkBadFolderName(szName) {
	            var szBadChars = /[\<\>\~\#\%\&\*\+\|\\\.\/]/g;
	            var szChangedName = szName.replace(szBadChars, "");
	
	            if (szChangedName != szName) {
	                alert("<spring:message code='ezEmail.t479' />< ~ # % & * + | \\ . / >)<spring:message code='ezEmail.t480' />");
	                return true;
	            }
	
	            return false;
	        }
	        function make_folder(szURL) {
	            return make_folder_2010(szURL, szName);
	
	            var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
	
	
	            xmlHTTP.open("MKCOL", szURL, false);
	            xmlHTTP.setRequestHeader("Overwrite:", "F");
	            xmlHTTP.setRequestHeader("Content-type", "text/xml");
	            xmlHTTP.setRequestHeader("Translate", "f");
	            xmlHTTP.send();
	
	            if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
	                return true;
	            else
	                return xmlHTTP.status;
	        }
	
	        function make_folder_2010(szURL, szName) {
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlDOM = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlDOM, objNode, "DATA");
	            createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
	            createNodeAndInsertText(xmlDOM, objNode, "NAME", szName);
	            createNodeAndInsertText(xmlDOM, objNode, "CMD", "NEW");
	
	
	            xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
	
	            xmlHTTP.send(xmlDOM);
	
	            if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
	                return true;
	            else
	                return xmlHTTP.status;
	        }
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return orgStr.replace(re, replaceStr);
	        }
	    </script>
	</head>
	
	<body style="overflow: hidden;" class="popup" onload="javascript:window_onload()">
	    <h1 id="headerH1"><spring:message code='ezEmail.t120' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="Window_Close()"><spring:message code='ezEmail.t63' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	    <table class="popuplist" style="width: 100%;">
	        <tr>
	            <td>
	                <div style="border: 0px solid #B6B6B6; behavior: url(/js/ezEmail/Controls/treeview.htc); height: 280px; width: 100%; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF; padding-left: 4px; padding-top: 5px;" id="PostTreeView" onrequestdata="requestdata()">
	                </div>
	            </td>
	            <td style="width: 25px;">
	                <a class="imgbtn"><span onclick="add_onclick()"><spring:message code='ezEmail.t308' /></span></a>
	                <a class="imgbtn"><span onclick="btn_Select_onclick()"><spring:message code='ezEmail.t38' /></span></a>
	                <a class="imgbtn"><span onclick="window.close()"><spring:message code='ezEmail.t39' /></span></a>
	            </td>
	        </tr>
	    </table>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel_sub">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel_sub">
	        <iframe src="/blank.htm" style="border: none;" id="iFrameLayer_sub"></iframe>
	    </div>
	</body>
</html>
