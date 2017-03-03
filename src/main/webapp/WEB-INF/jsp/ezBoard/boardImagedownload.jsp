<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t1007'/></title>
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        var ImageCount = "${imageCount}";
	        var BoardID = "${boardID}";
	        var ImageID = "";
	        var DelCount = 0;
	        var ImageFilePath = "";
	        var pNoneActiveX = "YES";
	        var suffix = 0;
	        function downloadAll(checks) {
	            if (checks[suffix]) {
	                if (checks[suffix].checked) {
	                    location.href = GetAttribute(checks[suffix++], "filehref");
	                    setTimeout(function () { downloadAll(checks); }, 1000);
	                } else {
	                    suffix++;
	                    downloadAll(checks);
	                }
	            } else
	                suffix = 0;
	        }
	
	        function btn_Save_Onclick() {
                checks = document.getElementsByName('checkboxImg');
                downloadAll(checks);
	        }
	
	        function btn_AllCheck_Onclick() {
	            if (document.getElementById("maincheck").checked == false) {
	                document.getElementById("maincheck").checked = true;
	
	                for (var i = 0; i < ImageCount; i++) {
	                    document.getElementById("check" + i).checked = true;
	                }
	            } else {
	                document.getElementById("maincheck").checked = false;
	
	                for (var i = 0; i < ImageCount; i++) {
	                    document.getElementById("check" + i).checked = false;
	                }
	            }
	        }
	
	        function chk_onClick(obj)
	        {
	            SetAttribute(obj, "checked", "true");
	        }
	        
	        function img_onClick(obj)
	        {
	        	if (obj.parentNode.children[0].checked) {
	        		obj.parentNode.children[0].checked = false;
	        	} else {
	        		obj.parentNode.children[0].checked = true;
	        	}
	        }
	    </script>
	</head>
	<body  class="popup">
	    <table class="layout">
	         <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                    <li ID='btn_Delete' ><span onclick="btn_Save_Onclick()"><spring:message code='ezBoard.t98'/></span></li>
	                    <li ID='CheckImage' ><span onclick='btn_AllCheck_Onclick()'><input type="checkbox" id="maincheck" style="display:none;"/><spring:message code='ezBoard.t1011'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onclick="window.close()"><spring:message code='ezBoard.t12'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td>
	                <div class="layout" style="padding-top:10px;padding-bottom:10px;overflow-y:scroll;height: 410px;">
	                	<c:set var="result" value="${fn:split(listImages, ';')}"/>
	                	<c:set var="content" value="${fn:split(imageContent, ';')}"/>
	                	<c:set var="fileName" value="${fn:split(fileName, ';')}"/>
	                	<c:set var="encodeFileHref" value="${fn:split(encodeFileHref, ';')}"/>
	                	<c:set var="resultCount" value="${fn:length(result)}"/>
	                	<c:forEach begin="1" end="${resultCount}" step="1" varStatus="vs">
		                    <span style="display:inline-block; padding:3px">
		                        <input type="checkbox" value="${fileName[vs.count-1]}" id="check${vs.count-1}" name="checkboxImg"  filehref='${encodeFileHref[vs.count-1]}' onclick="chk_onClick(this)" style="position:fixed"/>
		                        <img src='${result[vs.count-1]}' width='85px' height ='85px' title='${content[vs.count-1]}' id="image${vs.count-1}" name='zb_target_resize' style='cursor:pointer;' onclick="img_onClick(this)">
		                    </span>
	                	</c:forEach>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>