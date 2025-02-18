<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t169' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/mailbox_valid.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script>
	        var lang = "${userInfo.lang}";
	        var ReturnFunction;
	        var retVal = new Array();
	        retVal["isFolderChanged"] = false;
	        var shareId = "${shareId}";
			var treeconfig = "";
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        
	        function Window_Close() {
	            if (ReturnFunction != null)
	            	ReturnFunction(retVal);
	            window.close();
	        }
	        
	        var isDivPopup = false;
	        function window_onload() {
	            try {
	                ReturnFunction = parent.mail_selectfolder_cross_dialogArguments[1];
	                isDivPopup = true;
	            } catch (e) {
	                ReturnFunction = opener.mail_selectfolder_cross_dialogArguments[1];
	            }
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.getElementById("headerH1").style.marginTop = "0px";
	                document.getElementById("PostTreeView").style.borderRight = "1px solid #ddd";
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
	            PostTreeView.source("<tree><nodes>" + get_childXML("", true, false, false) + "</nodes></tree>");
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
	            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false, false)
	            PostTreeView.putchildxml(nodeIdx, childxml);
	        }
	        function btn_Select_onclick() {
	            if (PostTreeView.selectedIndex() == -1) {
	                alert("<spring:message code='ezEmail.t158' />");
	                return;
	            }
	            
	            retVal["name"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption");
	            retVal["url"] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            
	            if (ReturnFunction != null) {
	            	ReturnFunction(retVal);
	            }
	            
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
				
				// 폴더 뎁스 레벨
				var folderUrl = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");

				if (folderUrl.split(".").length > 5) {
					alert("<spring:message code='ezEmail.ksaMailBox01' />");
					return;
				}

				inputNameDlg_cross_dialogArguments[0] = "";
	            inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
	            inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden_sub;
	            DivPopUpShow_sub(330, 150, "/ezEmail/inputNameDlg.do");
	        }

	        function add_onclick_Complete(szName) {
				const jmochaSafeName = replaceMailboxNameForJmocha(szName);
	            DivPopUpHidden_sub();

				if (!jmochaSafeName || checkBadFolderName(jmochaSafeName)) {
	                return;
	            }
	
				const result = mail_make_folder("NEW", PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), "", jmochaSafeName);
	            
	            if (result != "OK") {
		            if (result == "ALREADY_EXISTS") {
		                alert("<spring:message code='ezEmail.t456' />");
		            } else {
		                alert("<spring:message code='ezEmail.t457' />");
		            }
		            return;
		        }
	            
	            var childxml = get_childXML(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), false, false, false);
                PostTreeView.putchildxml(PostTreeView.selectedIndex(), childxml);

				LoadAddressTree(PostTreeView.selectedIndex());
                retVal["isFolderChanged"] = true;
	        }
	        
	        function LoadAddressTree(SelectIndex) {
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + get_childXML("", true, false, false) + "</nodes></tree>");
	            PostTreeView.update();
	            PostTreeView.toggle(SelectIndex);

				if (typeof getAllSubTree === 'undefined' || getAllSubTree === false) {
					getAllSubTree = true;
				}
				var openTree = document.getElementById('toggleTreeNode')
				openTree.className = openTree.className.replace('on', 'off');
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
	            <li><span onclick="Window_Close()"></span></li>
	        </ul>
	    </div>
		<table class="popuplist" style="width:100%;margin-top:5px; height: 100%">
	        <tr>
	            <td>
					<div onclick="toggleTreeNode(false)" class="toggleTreeNode off" id="toggleTreeNode">
						<span class="treeNode_toggle_icon"></span>
						<spring:message code='ezEmail.kdh06' />
					</div>
	                <div style="border: 0px solid #ddd; behavior: url(/js/ezEmail/Controls/treeview.htc); height: 235px; width: 100%; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF; padding-left: 4px; padding-top: 5px;" id="PostTreeView" onrequestdata="requestdata()">
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	    	<a class="imgbtn"><span onclick="add_onclick()"><spring:message code='ezEmail.t308' /></span></a>
        	<a class="imgbtn"><span onclick="btn_Select_onclick()"><spring:message code='ezEmail.t38' /></span></a>
        </div>	
		
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_sub">&nbsp;</div>
		<div style="border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
			<img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel_sub">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer_sub"></iframe>
	    </div>
	</body>
</html>
