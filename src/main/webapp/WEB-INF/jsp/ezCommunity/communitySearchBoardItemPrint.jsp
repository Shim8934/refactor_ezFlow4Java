<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezCommunity.t1463'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			$(function () {
				var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			
    			for (var i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
					var strSpace = '';
					var strEmergent = '';
					var bTag = '';
					var readCount = '';
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Importance") == "1") {
						strEmergent = "<img src='/images/i_urgency.gif'>&nbsp;";
					}
					
					for (var j = 1; j < SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel"); j++) {
						strSpace += "&nbsp&nbsp;";
						if (j == SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel") - 1) {
							strSpace += "<img src='/images/i_rep.gif' align='absmiddle'>&nbsp;";
						}
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadFlag") != "0") {
						bTag = "";
					} else {
						bTag = "<B>";
					}
					
					listXML += "<tr>";
					listXML += "<td title='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`") + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden'>" + bTag + strEmergent + strSpace + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title").trim() + "</td>"

					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() != "") {
						listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() + "</td>";
					} else {
						listXML += "<td>&nbsp;</td>";
					}
					
					listXML += "<td><div>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim() + "</div></td>";
					listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</td>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						listXML += "<td align=center><img src='/images/i_save01.gif'></td>";
					} else {
						listXML += "<td>&nbsp;</td>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount").trim() == ""){
						readCount = "0";
					} else {
						readCount = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount").trim();
					}
					
					
					if (i > 0 && i % 25 == 0){
						listXML += "<td style='page-break-after:always' align=center>" + readCount + "</td>";
					} else {
						listXML += "<td align=center>" + readCount+ "</td>";
					}
					
					listXML += "</tr>";
    			}
    			
    			$('.popuplist').html($('.popuplist tbody').html() + listXML);
			});
		</script>
	</head>
	
	<body class="popup">
		<h1><spring:message code='ezCommunity.t1463'/></h1>
		<div id="close">
	  		<ul>
		    	<li><span onClick="window.close();"><spring:message code='ezCommunity.t21'/></span></li>
		  	</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<table class="content">
			<tr>
		    	<th><spring:message code='ezCommunity.t1464'/></th>
		        <td>${userInfo.displayName }(${userInfo.deptName })</td>
		    </tr>
		    <tr>
		    	<th ><spring:message code='ezCommunity.t1465'/></th>
		    	<c:if test="${userInfo.primary == '1' }">
		    		<td>${boardInfo.boardName }</td>
		    	</c:if>
		    	<c:if test="${userInfo.primary != '1' }">
		    		<td>${boardInfo.boardName2 }</td>
		    	</c:if>
			</tr>
	        <tr>
				<th ><spring:message code='ezCommunity.t1466'/></th>
		        <td>${strNow }</td>
	        </tr>
	        <tr>
		    	<th ><spring:message code='ezCommunity.t1431'/></th>
		        <td>${searchConfig }</td>
	        </tr>
		</table>
		<br>
		<table width="100%" class="popuplist">
	    	<tr>
	    		<c:choose>
					<c:when test="${pSortBy == 'A.Title'}">
			    		<th onClick="SortPage('A.Title desc')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.Title desc'}">
			    		<th onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/></th>
			    	</c:otherwise>
			    </c:choose>
		        
		        <c:choose>
					<c:when test="${pSortBy == 'A.WriterDeptName'}">
			    		<th width="80" onClick="SortPage('A.WriterDeptName desc')"><spring:message code='ezCommunity.t241'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.WriterDeptName desc'}">
			    		<th width="80" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="80" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241'/></th>
			    	</c:otherwise>
			    </c:choose>
		            
		        <c:choose>
					<c:when test="${pSortBy == 'A.WriterName'}">
			    		<th width="60" onClick="SortPage('A.WriterName desc')"><spring:message code='ezCommunity.t445'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.WriterName desc'}">
			    		<th width="60" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="60" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445'/></th>
			    	</c:otherwise>
			    </c:choose>
			    
			    <c:choose>
					<c:when test="${pSortBy == 'A.ParentWriteDate'}">
			    		<th width="60" onClick="SortPage('A.ParentWriteDate desc')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.ParentWriteDate desc'}">
			    		<th width="60" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="60" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/></th>
			    	</c:otherwise>
			    </c:choose>
			    
			    <c:choose>
					<c:when test="${pSortBy == 'A.Attachments'}">
			    		<th width="10" onClick="SortPage('A.Attachments desc')"><spring:message code='ezCommunity.t172'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.Attachments desc'}">
			    		<th width="10" onClick="SortPage('A.Attachments')"><spring:message code='ezCommunity.t172'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="10" onClick="SortPage('A.Attachments')"><spring:message code='ezCommunity.t172'/></th>
			    	</c:otherwise>
			    </c:choose>
			    
			    <c:choose>
					<c:when test="${pSortBy == 'A.ReadCount'}">
			    		<th width="30" onClick="SortPage('A.ReadCount desc')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:when test="${pSortBy == 'A.Attachments desc'}">
			    		<th width="30" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
			    	</c:when>
			    	<c:otherwise>
			    		<th width="30" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/></th>
			    	</c:otherwise>
			    </c:choose>
			</tr>
		</table>
	</body>
</html>