<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code='ezEmail.t535' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <style>
    	.node_normal, .node_selected { width :auto;}
    	.node_div img { margin-bottom: 5px; }
    </style>
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tree.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script>
        var lang = "${userinfo.lang}";
        var PostTreeView = null;
        var treeconfig = "";
        var ReturnFunction;
        var CancelFunction;
        var isDivPopUp = false;
        var isFolderManager = false;
        var shareId = "<c:out value='${shareId}'/>";
        
        if ("${isFolderManager}" == "1") {
        	isFolderManager = true;
        }
        
        document.onselectstart = function () {
            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
                return false;
            else
                return true;
        };
        function window_onload() {
            try {
                ReturnFunction = parent.mail_movecopy_cross_dialogArguments[1];
                CancelFunction = parent.mail_movecopy_cross_dialogArguments[2];
                isDivPopUp = true;
            } catch (e) {
                try {
                    ReturnFunction = opener.mail_movecopy_cross_dialogArguments[1];
                    CancelFunction = opener.mail_movecopy_cross_dialogArguments[2];
                } catch (e) {console.log(e);}
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
                treeconfig = xmlHTTP.responseXML;

            PostTreeView.config(treeconfig);
            PostTreeView.source("<tree><nodes>" + get_childXML("", true, false, isFolderManager) + "</nodes></tree>");
            PostTreeView.update();
            if (PostTreeView.selectedIndex() == -1) {
                PostTreeView.select(1);
            }
        }
        function Window_Close() {
            if (ReturnFunction!=null) {
                if (!isDivPopUp)
                    window.close();
                else
                    CancelFunction();   
            }
            else
                window.close();
        }
        function btn_Copy_onclick() {
            var postTreeSelectIndex = PostTreeView.selectedIndex();
        	if (postTreeSelectIndex == -1) {
                alert("<spring:message code='ezEmail.t536' />");
                return;
            }
            
        	if (isFolderManager && getFolderDeptLevel(postTreeSelectIndex) > 5) {
            	alert("<spring:message code='ezEmail.ksaMailBox01' />");
            	return;
            }
            
            var retVal = new Array();
            retVal["cmd"] = "COPY";
            retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
            if (getparentnode(PostTreeView.selectedNode()) != null) {
                retVal["idx"] = gettopvalue(PostTreeView.selectedNode());
            }
            else {
                retVal["idx"] = PostTreeView.selectedIndex();
            }
            if (ReturnFunction!=null)
            {
                ReturnFunction(retVal);
                if (!isDivPopUp)
                    window.close();
            }
            else {
                window.returnValue = retVal;
                window.close();
            }
        }
        function btn_Move_onclick() {
        	var postTreeSelectIndex = PostTreeView.selectedIndex();
            if (postTreeSelectIndex == -1) {
                alert("<spring:message code='ezEmail.t537' />");
                return;
            }
            
            if (isFolderManager && getFolderDeptLevel(postTreeSelectIndex) > 5) {
            	alert("<spring:message code='ezEmail.ksaMailBox01' />");
            	return;
            }

            var retVal = new Array();
            retVal["cmd"] = "MOVE";
            retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
            if (getparentnode(PostTreeView.selectedNode()) != null) {
                retVal["idx"] = gettopvalue(PostTreeView.selectedNode());
            }
            else {
                retVal["idx"] = PostTreeView.selectedIndex();
            }
            if (ReturnFunction!=null) {
                ReturnFunction(retVal);
                if (!isDivPopUp)
                    window.close();
            }
            else {
                window.returnValue = retVal;
                window.close();
            }
        }

        function onClickKeepMove() {
            const postTreeSelectIndex = PostTreeView.selectedIndex();
            if (postTreeSelectIndex == -1) {
                alert("<spring:message code='ezEmail.t537' />");
                return;
            }

            if (isFolderManager && getFolderDeptLevel(postTreeSelectIndex) > 5) {
                alert("<spring:message code='ezEmail.ksaMailBox01' />");
                return;
            }

            const retVal = [];
            retVal["cmd"] = "KEEP_MOVE";
            retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
            if (getparentnode(PostTreeView.selectedNode()) != null) {
                retVal["idx"] = gettopvalue(PostTreeView.selectedNode());
            }
            else {
                retVal["idx"] = PostTreeView.selectedIndex();
            }
            if (ReturnFunction!=null) {
                ReturnFunction(retVal);
                if (!isDivPopUp)
                    window.close();
            }
            else {
                window.returnValue = retVal;
                window.close();
            }
        }

        function getparentnode(currentnode) {
        	try{
            var tmpnode = currentnode.parentNode.parentNode.parentNode.parentNode.previousSibling.id;
            }catch(exception){
            	var tmpnode = currentnode.parentNode.parentNode.parentNode.parentNode.previousSibling;	
            }
            if (tmpnode == null) return null;

            var parentnode = tmpnode.lastChild;
            return parentnode;
        }
        function gettopvalue(currentnode) {

            if (!CheckRootFolder(currentnode)) {
                var parentnode = getparentnode(currentnode);
                if (CheckRootFolder(parentnode)) {
                    return getnodeidx(parentnode);
                }
                else {
                    return gettopvalue(parentnode, "id");
                }

            }
            else
                return PostTreeView.getvalue(getnodeidx(currentnode), "id");
        }
        function getnodeidx(currentnode) {
            var nodeidval = currentnode.attributes.getNamedItem('id').nodeValue;
            var nodeidvalsubstrstart = nodeidval.lastIndexOf('_') + 1;
            var nodeidvalsubstrend = nodeidval.length;
            var nodeidx = parseInt(nodeidval.substring(nodeidvalsubstrstart, nodeidvalsubstrend), 10);
            return nodeidx;
        }
        function CheckRootFolder(currentnode) {
            if (currentnode.parentNode.parentNode.parentNode.parentNode.id == "PostTreeView")
                return true;
            else
                return false;
        }
        function requestdata(event) {
            if (!event) event = window.event;
            var nodeIdx = event.nodeIdx;

            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                nodeIdx = arguments[0].nodeIdx;
            }
            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false, isFolderManager)
            PostTreeView.putchildxml(nodeIdx, childxml);
        }
        
	     // 폴더 뎁스 레벨
		function getFolderDeptLevel(nodeIdx) {
			var folderUrl = PostTreeView.getvalue(nodeIdx, "href");
			return folderUrl.split(".").length;
		}
        
    </script>
</head>
<body scroll="no" class="popup" onload="javascript:window_onload()">
    <h1><spring:message code='ezEmail.t482' /></h1>
    <div id="close">
        <ul>
            <li><span onclick="Window_Close();"></span></li>
        </ul>
    </div>
    <table class="content" style="height: 100%; width: 100%;">
        <tr>
            <td class="pos1">
                <div onclick="toggleTreeNode(false)" class="toggleTreeNode off" id="toggleTreeNode">
                    <span class="treeNode_toggle_icon"></span>
                    <spring:message code='ezEmail.kdh06' />
                </div>
                <div style="border: 0px solid #ddd; min-height: 520px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF; padding-left: 4px; padding-top: 5px; padding-bottom: 30px;" id="PostTreeView">
                </div>
            </td>
        </tr>
    </table>
    <div class="btnpositionNew">
    	<a class="imgbtn"><span onclick="return btn_Move_onclick()"><spring:message code='ezEmail.t538' /></span></a>
    	<a class="imgbtn"><span onclick="return btn_Copy_onclick()"><spring:message code='ezEmail.t539' /></span></a>
        <a class="imgbtn"><span onclick="return onClickKeepMove()"><spring:message code='ezEmail.keepmove' /></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div style="border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
        <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
    </div>
</body>
</html>



