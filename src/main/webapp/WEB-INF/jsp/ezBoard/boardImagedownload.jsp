<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t1007'/></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript">
	        var ImageCount = "${imageCount}";
	        var BoardID = "<c:out value='${boardID}'/>";
	        var ImageID = "";
	        var DelCount = 0;
	        var ImageFilePath = "";
	        var pNoneActiveX = "YES";
	        var suffix = 0;
	        var agent = navigator.userAgent.toLowerCase();
	        
	        /* 2018-08-29 홍승비 - 사진다운로드 팝업창 세로길이 리사이즈 추가 */
	        window.onresize = function () {
	        	if (agent.indexOf("chrome") != -1) {
	        	 	document.getElementById("imageDiv").style.height = document.documentElement.clientHeight - 90 + "px";
	        	} else {
	        		document.getElementById("imageDiv").style.height = document.documentElement.clientHeight - 94 + "px";
	        	}
	        }
	        
	        /* 2021-01-04 홍승비 - 아무것도 체크하지 않고 저장버튼 누르는 경우 알러트 표출 */
	        function downloadAll(checks) {
	        	var checkedList = $("input:checkbox:checked");
	        	if (checkedList.length < 1) {
	        		alert('<spring:message code="ezBoard.t1017" />');
	        		return;
	        	}
	        	
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
	                    <li ID='CheckImage' ><span onclick='btn_AllCheck_Onclick()'><div class="custom_checkbox"><input type="checkbox" id="maincheck" style="display:none;"/></div><spring:message code='ezBoard.t1011'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onclick="window.close()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td>
	                <div class="layout" id="imageDiv" style="padding-top:10px;padding-bottom:10px;overflow-y:auto;height: 410px;">
	                	<c:set var="result" value="${fn:split(listImages, '|')}"/>
	                	<c:set var="content" value="${fn:split(imageContent, ';')}"/>
	                	<c:set var="fileName" value="${fn:split(fileName, '|')}"/>
	                	<c:set var="encodeFileHref" value="${fn:split(encodeFileHref, '|')}"/>
	                	<c:set var="resultCount" value="${fn:length(result)}"/>
	                	<c:forEach begin="1" end="${resultCount}" step="1" varStatus="vs">
		                    <div style="display:inline-block">
		                    	<div class="custom_checkbox">
			                        <input type="checkbox" value="${fileName[vs.count-1]}" id="check${vs.count-1}" name="checkboxImg"  filehref='${encodeFileHref[vs.count-1]}' onclick="chk_onClick(this)" style="vertical-align: top; position: relative; z-index: 1; left:8px"/>
		                    	</div>
		                        <img src='${result[vs.count-1]}' width='100px' height ='100px' title='${fn:replace(content[vs.count-1],">","")}' id="image${vs.count-1}" name='zb_target_resize' style='cursor:pointer; position: relative; right: 13px' onclick="img_onClick(this)">
		                    </div>
	                	</c:forEach>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>