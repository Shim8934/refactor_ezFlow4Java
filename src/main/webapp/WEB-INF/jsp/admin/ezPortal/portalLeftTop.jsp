<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezPortal.i2" />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
			function DeleteCache() {
				if (confirm("<spring:message code='ezPortal.t226'/>")) {
				    var xmlhttp = createXMLHttpRequest();

					xmlhttp.open("POST", "/ezPortal/admin/portalDeleteCache.do", false);
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
						url = "/myoffice/ezPortal/admin/edit/Logo_List.aspx";
						break;
						
					case 3:
						url = "/myoffice/ezPortal/admin/edit/UtilMenuArea_Edit.aspx";
						break;
						
					case 4:
						url = "/myoffice/ezPortal/admin/edit/MainMenuArea_Edit.aspx" ;
						break;
						
					case 5:
						url = "/myoffice/ezPortal/admin/edit/SubMenuItems_Edit.aspx";
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
						url = "/myoffice/ezPortal/admin/portlet_list.aspx";
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
			<div class="left_admin" title="<spring:message code='ezPortal.t228'/>"><spring:message code='ezPortal.t228'/></div>
        	<h2><span onClick="goPage(10)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t990010'/></span><ul></ul></h2>	
			<h2><span onClick="goPage(7)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t409'/></span><ul></ul></h2>	
			<h2><span onClick="goPage(8)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t410'/></span><ul></ul></h2>	
			<h2><span onClick="goPage(9)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t411'/></span><ul></ul></h2>	
			<!--h2><span onClick="goPage(1)"><spring:message code='ezPortal.t232'/></span><ul></ul></h2-->	
			<h2><span onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t61'/></span><ul></ul></h2>	
			<h2><span onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t224'/></span><ul></ul></h2>	
			<h2><span onClick="goPage(4)" style="display:inline-block;width:100%;"><spring:message code='ezPortal.t107'/></span><ul></ul></h2>	
			<%--<h2><span onClick="goPage(5)" style="display:inline-block;width:100%;"><%=RM.GetString("t216")%></span><ul></ul></h2>	--%>
			<%--<h2><span onClick="goPage(6)" style="display:inline-block;width:100%;"><%=RM.GetString("t198")%></span><ul></ul></h2>	--%>
			<div onClick="DeleteCache()"><h2><span id="Del_Cache" onClick=""><spring:message code='ezPortal.t230'/></span><ul></ul></h2></div>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	
	</body>
</html>