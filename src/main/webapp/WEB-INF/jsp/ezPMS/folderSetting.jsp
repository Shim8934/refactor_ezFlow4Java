<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezPMS.t334' /></title>
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/pms.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<script type="text/javascript">
var projectId = opener.projectId;
var folderId = 0;
var folderCount = 0;

$(function() {
	setFolderList();
});

function addFolder() {
	folderCount = $(".jstree-node").length;
	DivPopUpShow(330, 170, "/ezPMS/inputFolderName.do?mode=new");
}

function updateFolder() {
	folderCount = $(".jstree-node").length;
	
	//선택된 폴더가 있어야함
	if ($(".jstree-clicked").length <= 0) {
		alert('<spring:message code="ezPMS.t345"/>');
		return;
	}
	
	folderId = $(".jstree-clicked").parent().attr("id");
	
	DivPopUpShow(330, 170, "/ezPMS/inputFolderName.do?mode=modify&projectId=" + projectId + "&folderId=" + folderId);
}

function deleteFolder() {
	
	var response = confirm('<spring:message code="ezPMS.t346"/>') 
	
	if (response) {
		//선택된 폴더가 있어야함
		if ($(".jstree-clicked").length <= 0) {
			alert('<spring:message code="ezPMS.t345"/>');
			return;
		}
		
		//최소 하나 이상의 폴더가 있어야함.
		if ($(".jstree-node").length == 1) {
			alert('<spring:message code="ezPMS.t347"/>');
			return;
		}
		
		folderId = $(".jstree-clicked").parent().attr("id");
		
		$.ajax({
			type : "post",
			url : "/ezPMS/deleteFolder.do",
			data : {
				folderId : folderId,
				projectId : projectId
			},
			dataType : "text",
			success : function(data) {
				if (data == "permitted") {
					setFolderList();
					parent.opener.location.reload();
				} else {
					alert('<spring:message code="ezPMS.t344"/>');
					return;
				}
			}
		});
	} else {
		return;
	}
	
}

function setFolderList() {
	$('#folderTree').jstree('destroy');
	
	$.ajax({
		type: "POST",
		async: false,
		url: "/ezPMS/getFolderList.do",
		data: {
			"projectId": projectId,
			"location" : "folderSetting"
		},
		dataType: "json",
		success: function(data) {
			var treeData = data;
			
			for (var i = 0; i < treeData.length; i++) {
				var taskName = treeData[i].text;
				taskName = revertString(taskName);
				treeData[i].text = taskName;
			}
			
			$('#folderTree').jstree({
				'core' : {
					'data' : treeData,
					'multiple' : false,
					'animation' : 0,
					'themes' : {
						"theme": "default",
						"dots": false,
						'responsive': false,
						'variant': 'small',
						'stripes': false
					}
				},
				'plugins' : [ "core", "types", "json_data", "themes", "ui","sort" ],
				'sort' : function(a, b) {
					var a1 = this.get_node(a);
					var b1 = this.get_node(b);
					
					return (a1.original.sort > b1.original.sort) ? 1 : -1;
				},
				"types": {
					"default" : {
						"icon": "/images/OrganTree_cross/fldr.gif"
					}
				}
			});
		}
	});
}
</script>
</head>
<body scroll="no" class="popup" >
	<h1><spring:message code='ezPMS.t334' /></h1> 
	<div id="close">
		<ul>
			<li><span onclick="window.close()"></span></li>
		</ul>
	</div>
	<div id="folderTree" style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 350px; height: 350px; overflow: auto;padding-top:5px" ></div>
	<div class="btnpositionNew">
      	<a class="imgbtn" onclick="addFolder()"><span><spring:message code="ezPMS.t335"/></span></a>
      	<a class="imgbtn" onclick="updateFolder()"><span><spring:message code="ezPMS.t110"/></span></a>
      	<a class="imgbtn" onclick="deleteFolder()"><span><spring:message code="ezPMS.t11"/></span></a>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
	    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
	</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>