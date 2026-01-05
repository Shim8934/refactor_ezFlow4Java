<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t10025'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style type="text/css">
			/* 첨부파일 아이콘 변경 */
			#lstAttachLink img{width: 18px;height: 18px;vertical-align: middle;margin: 0 2px 4px 0;}
		</style>
    </head>
	<body class="popup">
	    <h1><spring:message code='ezBoard.t10025'/></h1>
	    <div id="close">
	           <ul>
	               <li><span onclick="window_close()"></span></li>
	           </ul>
	       </div>
	    <span>&nbsp;▒ <spring:message code='ezApprovalG.t00009'/></span>
	    <table class="mainlist" style="width: 550px; margin-left: 5px;margin-top:7px">
	        <tr>
				<th style="width:30px;"><div class='custom_checkbox'><input id="cbx_all" type="checkbox" onclick="checkAll()" value="all" /></div></th>
	            <th><spring:message code='ezApprovalG.t00010'/></th>
	        </tr>                
	    </table>
	    <div style="overflow-y:auto; overflow-x:auto; height:250px; width: 555px;">
	        <table class="mainlist" id="lstAttachLink" style="width: 99%; margin-left: 5px;">
	        <c:forEach var="attach" items="${attachList}">
	        	<tr>
	        		<td style="width: 30px">
						<div class='custom_checkbox'><input type="checkbox" onclick="checkSelects()" name="fileSelect" value="${attach.fileName}" filepath="${attach.filePath}" ></div>
	        		</td>
	        		<td>
	                <c:choose>
		    		<c:when test="${fn:contains(attach.fileName, '.jpg') || fn:contains(attach.fileName, '.jpeg') || fn:contains(attach.fileName, '.bmp') || fn:contains(attach.fileName, '.gif') || fn:contains(attach.fileName, '.png') || fn:contains(attach.fileName, '.tif') || fn:contains(attach.fileName, '.tiff')}">
				        <img src='/images/image.svg'>
		    		</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.doc') || fn:contains(attach.fileName, '.docx')}">
				        <img src='/images/doc.svg'>
		    		</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.xls') || fn:contains(attach.fileName, '.xlsx')}">
				        <img src='/images/xls.svg'>
		    		</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.ppt') || fn:contains(attach.fileName, '.pptx')  || fn:contains(attach.fileName, '.pps') || fn:contains(attach.fileName, '.ppsx')}">
				        <img src='/images/ppt.svg'>
		    		</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.txt')}">
				        <img src='/images/txt.svg'>
		    		</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.zip')}">
				        <img src='/images/zip.svg'>
		    		</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.pdf')}">
				        <img src='/images/pdf.svg'>
		    		</c:when>
					<c:when test="${fn:contains(attach.fileName, '.hwp')}">
						<img src='/images/hwp.svg'>
					</c:when>
		    		<c:when test="${fn:contains(attach.fileName, '.ecm')}">
				        <img src='/images/ecm.svg'>
		    		</c:when>
		    		<c:otherwise>
				        <img src='/images/etc.svg'>
		    		</c:otherwise>
		    	    </c:choose>
		    	    <c:url value="/ezCommunity/getCommunityAttachInfo.do" var="url">
		    	    	<c:param name="filePath" value="${attach.filePath}"/>
		    	    	<c:param name="fileName" value="${attach.fileName}"/>
	    	    	</c:url>
	                    <a href="${url}">${attach.fileName}</a>
	        		</td>
	        	</tr>
	        </c:forEach>
	        
	        </table>
	    </div>
	    <br />
	     <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span style="text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>	        
	    </div>
	    <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	</body>
    <script type="text/javascript">
    
   	var cbx_all = document.getElementById('cbx_all');
    var selectCheckboxes = document.getElementsByName('fileSelect');

    // 2024-09-30 조수빈 - 최상단 체크박스 값에 따라 하위의 체크박스들이 일괄 선택/해제 되도록 함
    function checkAll() {

		for (var i = 0; i < selectCheckboxes.length; i++) {
		    selectCheckboxes[i].checked = cbx_all.checked;
		}
    }
    
    // 2024-09-30 조수빈 -하위의 체크박스들이 모두 체크된 경우 최상단 체크박스가 선택 / 하나라도 해제된 경우 최상단 체크박스가 해제되도록 함.
    function checkSelects() {
		var allChecked = true;
		
		for (var i = 0; i < selectCheckboxes.length; i++) {
			if (!selectCheckboxes[i].checked) {
				allChecked = false;
				break;
			}
		}

		cbx_all.checked = allChecked;
	}
    
	var suffix = 0;	
    
    function btn_OK() {
		var checks = document.getElementById('lstAttachLink');
		var checkedFiles = $("#lstAttachLink").find("input:checkbox[name='fileSelect']:checked");
		var checkedFilesLength = checkedFiles.length;
		var filePath = ""; // 전체파일경로
		var filePathTemp = "";
		var fileNames = ""; // 파일이름
		var fileNamesUID = ""; // 파일이름(UID 포함)
		
		if (checkedFilesLength == 1) { // 하나만 저장
			if (checks.getElementsByTagName("input").item(suffix)) {
	            if (checks.getElementsByTagName("input").item(suffix).checked) {
	                location.href = GetAttribute(checks.getElementsByTagName("a").item(suffix++), "href");
	                setTimeout(function () { downloadAll(checks) }, 1000);
	            } else {
	                suffix++;
	                downloadAll(checks);
	            }
	        } else {
	            suffix = 0;
	        }
		} else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
			filePath = GetAttribute(checkedFiles.get(0), "filepath");
			filePath = filePath.substr(0, filePath.lastIndexOf("/") + 1);
			
			for (var i = 0; i < checkedFilesLength; i++) {
				filePathTemp = GetAttribute(checkedFiles.get(i), "filepath"); // 각 파일의 풀경로
				fileNames += MakeXMLString(checkedFiles.get(i).value) + ":"; // 각 파일의 이름을 :로 이어붙인 것
				fileNamesUID += MakeXMLString(filePathTemp.substr(filePathTemp.lastIndexOf("/"), filePathTemp.length)) + ":"; // 각 파일의 이름+UID를 :로 이어붙인 것
			}
			
			var $frm = $("<form></form>");
	    	$frm.attr('action', "/ezCommunity/downloadAttachAll.do");
	    	$frm.attr('method', 'post');
	    	$frm.appendTo('body');
	
	    	param1 = $('<input type="hidden" value="' + filePath + '" name="filePath" />');
	    	param2 = $("<input type='hidden' value='" + fileNames + "' name='fileNames' />");
	    	param3 = $("<input type='hidden' value='" + fileNamesUID + "' name='fileNamesUID' />");
	    	
	    	$frm.append(param1).append(param2).append(param3);
	    	$frm.submit();
		} else { // 체크된 파일 없음
			return;
		}
   	}
    
    function window_close() {
        window.close();
    }
    </script>
</html>