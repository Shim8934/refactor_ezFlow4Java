<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Top_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			 var g_SelectedObj = null;
		        var g_UID = "";
		        var g_UseFlag = "";
		        var g_UserACL = "${result}";
		        document.onselectstart = function () { return false; }
				function setValue(pUID, pObj) {
				    g_UID = pUID;
				    if (g_SelectedObj == null) {
				        pObj.style.backgroundColor = "#e4e8ec";
				        g_SelectedObj = pObj;
				    }
				    else {
				        pObj.style.backgroundColor = "#e4e8ec";
				        if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
				        g_SelectedObj = pObj;
				    }
				}
				
				function selectItem(pUID, pObj) {
					location.href = "/ezPortal/topMenu.do?pageID=" + pUID;
				}
				
				var themeinfo_dialogArguments = new Array();
				function newpage() {
				    themeinfo_dialogArguments[1] = newpage_Complete;
				    var OpenWin = window.open("/admin/ezPortal/themeInfo.do?mode=new", "ThemeInfo", GetOpenWindowfeature(550, 500));
				    try { OpenWin.focus(); } catch (e) { }
				}
				
				function newpage_Complete() {
				    window.location.reload();
				}
				
				function Modify_Theme() {
				    if (g_UID == "") {
				        alert("<spring:message code='ezPortal.t990009'/>");
				        return;
				    }
				    Theme_onClick(g_UID);
				}
		        function Theme_onClick(pUID) {
		            themeinfo_dialogArguments = new Array();
		            themeinfo_dialogArguments[1] = newpage_Complete;
		            var OpenWin = window.open("/admin/ezPortal/themeInfo.do?mode=modify&uID=" + pUID, "ThemeInfo", GetOpenWindowfeature(550, 500));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        function deleteTopMenu() {
		            if (g_UID == "") {
		                alert("<spring:message code='ezPortal.t990009'/>");
					    return;
					}
		            if (confirm("<spring:message code='ezPortal.t54'/>")) {
		                var xmlpara = createXmlDom();
		                var objNode;
		                objNode = createNodeInsert(xmlpara, objNode, "DATA");
		                createNodeAndInsertText(xmlpara, objNode, "THEMEID", g_UID);
		                xmlhttp = null;
		                xmlhttp = createXMLHttpRequest();
		                xmlhttp.open("POST", "/admin/ezPortal/deleteThemeInfo.do", false);
		                xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
		                xmlhttp.send(xmlpara);
		                if (xmlhttp.responseText == "OK") {
		                    alert("<spring:message code='ezPortal.t55'/>");
		                    document.location.reload();
		                }
		                else {
		                    if (xmlhttp.responseText == "BOTH")
		                        alert("<spring:message code='ezPortal.t990013'/>");
		                    else if (xmlhttp.responseText == "TOP")
		                        alert("<spring:message code='ezPortal.t990014'/>");
		                    else if (xmlhttp.responseText == "MAIN")
		                        alert("<spring:message code='ezPortal.t990015'/>");
		                    else
		                        alert("<spring:message code='ezPortal.t239'/>" + xmlhttp.responseText);
		                }
		                xmlhttp = null;
		            }
		        }
		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezPortal.t990010'/></h1>
	    <div id="mainmenu">
	        <ul>
	            <c:if test="${result == '1'}">
	            	<li><span onclick="newpage()"><spring:message code='ezPortal.t247'/></span></li>
	            	<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
	            	<li><span onclick="Modify_Theme()"><spring:message code='ezPortal.t336'/></span></li>
	            	<li><span onclick="deleteTopMenu()"><spring:message code='ezPortal.t67'/></span></li>
	            </c:if>
	        </ul>
	    </div>
		<div style="width:100%;">
	    <table class="themelist_box " >
	        <colgroup>
	            <col width="195px">
	            <col>
	        </colgroup>
	        <tr>
	        <th colspan="2" style="font-weight: normal; background-color: #f8f8fa; color:#333;"><spring:message code='ezPortal.t990011'/></th>
	        </tr>
	
	        <c:forEach items="${list}" var="item">
	        	<tr data1='${item.uID}' style="height: 170px;cursor:pointer;" onClick="setValue('${item.uID}', this)" ondblclick="Theme_onClick('${item.uID}');">
	        		<td>
	                	<img src='${item.imageURL}' class="theme_img">
	            	</td>
	            	<td width="100%">
	            		<c:choose>
	            			<c:when test="${userInfo.primary == '1'}">
	            				<p class="themelist_title">${item.displayName}</p>
	            			</c:when>
	            			<c:when test="${userInfo.primary == '2'}">
	            				<p class="themelist_title">${item.displayName2}</p>
	            			</c:when>
	            			<c:when test="${userInfo.primary == '3'}">
	            				<p class="themelist_title">${item.displayName3}</p>
	            			</c:when>
	            			<c:when test="${userInfo.primary == '4'}">
	            				<p class="themelist_title">${item.displayName4}</p>
	            			</c:when>
	            		</c:choose>
		              	<table class="theme_sublist" style="width: 100%;margin: 0px; padding: 0px;">
	    	            	<colgroup>
	        	       			<col width="100px">
	            	    			<col>
	                		</colgroup>
	                		<tr>
								<th><spring:message code='ezPortal.t258'/> </th>
	                      		<td>${fn:substring(item.modifyDate, 0, 16)}</td>
	                		</tr>
	                  		<tr>
		                    	<th width="100" ><spring:message code='ezPortal.t990002'/></th>
	                      		<td>${item.topURL}</td>
	                		</tr>
	                  		<tr>
		                  		<th><spring:message code='ezPortal.t990003'/></th>
	                    		<td>${item.mainURL}</td>
							</tr>
						</table>
	    	        </td>
		        </tr>
	        </c:forEach>
	    </table>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    <br>
	    <br>
	</body>
</html>