<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			window.onload = function () {
				<c:if test="${firstScreen_Mail == 'YES'}">
					document.getElementById("logo").onclick();
			    </c:if>
			}
			
			document.onselectstart = function () {
	        	if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            	return false;
	        	else
	            	return true;
			};
			
			function DeleteCache() {
				if (confirm("<spring:message code='ezPortal.t226'/>")) {
				    var xmlhttp = createXMLHttpRequest();

					xmlhttp.open("POST", "/admin/ezPortal/deleteCache.do", false);
					xmlhttp.send("<DATA><UID>all</UID></DATA>");
					
					var result = xmlhttp.responseText;
					
					if (result == "OK") {
						alert("<spring:message code='ezPortal.t227'/>");
					}
					else {
						alert(result);
					}
				}
			}
			
			function goPage(idx) {
				var url = "";
				switch(idx) {
					case 1:
						url = "/admin/ezPortal/topList.do";
						break;
					
					case 2:
						url = "/admin/ezPortal/logoList.do";
						break;
						
					case 3:
						url = "/admin/ezPortal/utilMenuAreaEdit.do";
						break;
						
					case 4:
						url = "/admin/ezPortal/mainMenuAreaEdit.do" ;
						break;
						
					case 5:
						url = "/admin/ezPortal/subMenuItemsEdit.do";
						break;
						
				    case 6:
	                    if(CrossYN())
	                        url = "/myoffice/ezPortal/admin/edit/Skin_Edit_Cross.aspx";
	                    else
	                        url = "/myoffice/ezPortal/admin/edit/Skin_Edit.aspx";
						break;
						
						
					// 20071024
					// submenu 포탈 좌측 메뉴로 이동
					case 7:
						url = "/admin/ezPortal/topList.do";
						break;
						
					case 8:
						url = "/admin/ezPortal/portalPageList.do";
						break;
						
					case 9:
						url = "/admin/ezPortal/portletList.do";
						break;

				    case 10:
				        url = "/admin/ezPortal/themeList.do";
				        break;
								
				}
				window.open(url,"right");
			}    
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
		<div id="left">
			
			<div class="left_admin" title="<spring:message code='ezPortal.t228'/>"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code='ezPortal.t228'/></div>
			
			<c:choose>
				<c:when test="${firstScreen_Mail == 'YES'}">
					<h2><span id="logo" onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t61'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t224'/></span><ul></ul></h2>	
					<div onClick="DeleteCache()"><h1 style="padding-top:10px;padding-bottom:10px;padding-left:19px;border-bottom:1px solid #ccc;cursor: pointer;"><span id="Del_Cache" onClick=""><spring:message code='ezPortal.t230'/></span><ul></ul></h1></div>
				</c:when>
				<c:otherwise>
					<h2><span onClick="goPage(10)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t990010'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(7)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t409'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(8)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t410'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(9)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t411'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t61'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t224'/></span><ul></ul></h2>	
					<h2><span onClick="goPage(4)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t107'/></span><ul></ul></h2>	
					<div onClick="DeleteCache()"><h1 style="padding-top:10px;padding-bottom:10px;padding-left:19px;border-bottom:1px solid #eaeaea;cursor: pointer;"><span id="Del_Cache" onClick=""><spring:message code='ezPortal.t230'/></span><ul></ul></h1></div>
				</c:otherwise>
			</c:choose>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	
	</body>
</html>