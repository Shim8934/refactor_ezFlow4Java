<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezCircular.t56' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezCircular/email_tree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script>
	        var lang = "<c:out value='${userinfo.lang}'/>";
	        var PostTreeView = null;
	        var treeconfig = "";
	        var oldFolderId = "<c:out value='${folderId}'/>";
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        
	        function window_onload() {
	            PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else
	                treeconfig = xmlHTTP.responseXML;
	
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + get_childXML("", true, true) + "</nodes></tree>");	            	
				PostTreeView.update();
	        }
	        
	        function btn_Move_onclick() {
	        	if (confirm("<spring:message code='ezApprovalG.hyj06' /><spring:message code='ezResource.t90' />")) {
		        	var folderId = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
		        	var circularIdList = "<c:out value='${circularIdList}'/>";
					var originLoc = "<c:out value='${originLoc}'/>";
	
					if (folderId == oldFolderId) {
						alert("<spring:message code='ezCircular.t109' />");
						return;
					}
	
		        	$.ajax ({
		                type : 'POST',
		                dataType : 'text',
		                cache: false,
		 			   	url : '/ezCircular/moveCircular.do',
		                data : {	
		                		folderId 		: 	folderId,
		                		circularIdList  : 	circularIdList,
		                		oldFolderId 	: 	oldFolderId,
		                		originLoc		:	originLoc,
		                },  
		                success : function(data) {		                  
		             	  window.close();
		                  window.opener.getLeftCount();
		                  window.opener.refresh_onclick();
		                },
		                error : function() {
		                	alert("<spring:message code='ezCircular.t102' />")
		                }
		 			});
	        	}
	        }
	    </script>
	</head>
	<body scroll="no" class="popup" onload="javascript:window_onload()">
	    <h1><spring:message code='ezCircular.t56' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>
	    <table class="content">
	        <tr>
	            <td class="pos1">
	                <div style="border: 0px solid #ddd; height: 262px; width: 470px; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF; padding-left: 4px; padding-top: 5px;" id="PostTreeView">
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	    	<a class="imgbtn"><span onclick="return btn_Move_onclick()"><spring:message code='ezCircular.t56' /></span></a>
	    </div>
	</body>
</html>