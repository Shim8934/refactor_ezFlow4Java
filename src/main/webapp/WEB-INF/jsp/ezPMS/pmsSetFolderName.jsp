<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>

<script type="text/javascript">
var mode = "${mode}";
var projectId = parent.projectId;
var folderId = parent.folderId;
var order = parent.folderCount + 1;

$(function() {
	if (mode == "new") {
		$("#title").text('<spring:message code="ezPMS.t335"/>');
	} else {
		$("#title").text('<spring:message code="ezPMS.t110"/>')
		
		var folderDetails = JSON.parse(JSON.stringify(${folderDetails}));
		
		$("#folderName1").val(folderDetails.text);
		$("#folderName2").val(folderDetails.text2);
	}
});

function setFolderName() {
	var folderName1 = $("#folderName1").val();
	var folderName2 = $("#folderName2").val();
	
	if (folderName1 == "" || folderName1 == null) {
		alert("<spring:message code='ezPMS.t342'/>");
		return;
	}
	
	if (folderName2 == "" || folderName2 == null) {
		folderName2 = folderName1;
	}
	
	$.ajax({
		type: "POST",
		async: false,
		url: "/ezPMS/setFolderName.do",
		data: {
			projectId : projectId,
			mode : mode,
			folderId : folderId,
			folderName1 : folderName1,
			folderName2 : folderName2,
			order : order
		},
		dataType: "text",
		success: function(data) {
			if (mode == "modify" && data == "rejected") {
				alert("<spring:message code='ezPMS.t343'/>");
				popupClose();
			} else if (mode == "new" && data == "rejected") {
				alert("<spring:message code='ezPMS.t348'/>");
				popupClose();
			} else {
				parent.folderId = 0;
				parent.setFolderList();
				parent.opener.location.reload();
				popupClose();
			}
		}
	});
}
</script>
</head>
<body class="popup">
	    <h1 id="title"></h1>
	    <div id="close">
            <ul>
                <li><span onclick="popupClose()"></span></li>
            </ul>
        </div>
	    <!-- <div class="txt"><span></span></div> -->
	    <div class="nobox">
	    	<span id="lang1"><spring:message code='ezPMS.t337'/></span>
	        <input id="folderName1" type="text" maxlength="50" style="width: 60%;margin-top:3px;height:25px">
	        <br>
	    	<span id="lang2"><spring:message code='ezPMS.t338'/></span>
	        <input id="folderName2" type="text" maxlength="50" style="width: 60%;margin-top:3px;height:25px">
	    </div>
	    <div class="btnposition btnpositionNew">
	        <a id="btn_ok" class="imgbtn" onclick="setFolderName()"><span><spring:message code='ezPMS.t43'/></span></a>
	    </div>	
	</body>
</html>