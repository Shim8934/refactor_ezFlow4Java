<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/js/ezWebFolder/jsTree/dist/themes/default/style.css')}"/>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jsTree/dist/jstree.js')}"></script>
	<script type="text/javascript">
		var primary = "<c:out value='${primary}'/>";
		var folderId = "";
		var folderType = "";
		var uppFolderId = "";
		var selectedFolder = null;
		var arrSubFolder = [];
		var moveCopyType = "";
		var parentId = "";
		var createId = "";
		var treeData;
		var folderMoveType = "";
		
		window.onload = function() {
			
			try {
				folderId = parent.moveCopyFolderDlg_cross_dialogArguments[0];
				moveCopyType = parent.moveCopyFolderDlg_cross_dialogArguments[1];
				returnFunction = parent.moveCopyFolderDlg_cross_dialogArguments[2];
				folderMoveType = parent.moveCopyFolderDlg_cross_dialogArguments[3];
				
				folderType = folderMoveType != "C" ? "D" : folderMoveType;
				folderList(folderType);
			} catch (e) {}
			
			try {
				txt_FolderName.focus();
			} catch (e) {}
			
			if (folderMoveType == "C") {
				$("input[id='radio1'], label[for='radio1']").css("display", "inline-block")
			} else {
				// radio2.checked = true;
				$("input[id!='radio1'], label[for!='radio1']").css("display", "inline-block")
			}
			
			if (moveCopyType == "move") {
				$('#topMenu').text("<spring:message code='ezWebFolder.t296'/>");
			} else {
				$('#topMenu').text("<spring:message code='ezWebFolder.t297'/>");
			}
			$('input:radio[name=treeType]:input[value=' + folderType + ']').prop("checked", true);
		}
		
		function typeCheck() {
			if (moveCopyType == "move") {
				folderCopyMove('folder-move');
			} else if (moveCopyType == "copy") {
				folderCopyMove('folder-copy');
			}
		}

		function afterSuccess(code, obj) {
			if (code == 0) {
				if (obj == "move") {
					alert("<spring:message code='ezWebFolder.t247'/>");
				} else if (obj == "copy") {
					alert("<spring:message code='ezWebFolder.t248'/>");
				}
				parent.returnFunction(folderType);
				parent.folderList(folderType);
			} else if (code == 3) {
				alert("<spring:message code='ezWebFolder.t300'/>");
				window.close();
			} else if (code == 4) {
				alert("<spring:message code='ezWebFolder.t301'/>");
				window.close();
			} else if (code == 5) {
				alert("<spring:message code='ezWebFolder.t312'/>");
				window.close();
			} else if (code == 6) {
				alert("<spring:message code='ezWebFolder.t313'/>");
				window.close();
			} else if (code == 7) {
				alert("<spring:message code='ezWebFolder.t250'/>");
				window.close();
			} else if (code == 8) {
				alert("<spring:message code='webfolder.duplicate.foldermanage.error'/>");
				window.close();
			} else {
				alert("<spring:message code='ezWebFolder.t305'/>");
				window.close();
				return;
			}
		}

		function windowClose() {
			parent.returnFunction(folderType);
		}

		function folderList(obj) {
			$('#folderTree').jstree('destroy');
			folderType = obj;
			$.ajax({
				type: "POST",
				async: false,
				url: "/ezWebFolder/folderList.do",
				data: {
					"folderId": folderId,
					"uppFolderId": uppFolderId,
					"folderType": obj
				},
				dataType: "JSON",
				success: function(data) {
					//						upperId = data.data[0]["parent"];
					var firstNode = "#" + folderId;
					
					treeData = data;
					addTitle();
					
					$('#folderTree').jstree({
						'plugins': [ "core", "types", "json_data", "themes", "ui" ],
						'core': {
							"animation": 0,
							'data': data.data,
							"multiple": false,
							'themes': {
								"theme": "default",
								"dots": false,
								'responsive': false,
								'variant': 'small',
								'stripes': false
							}
						},
						"types": {
							"default": {
								"icon": "/images/OrganTree_cross/fldr.gif"
							}
						},
						"grid": {
							"width": "20",
							"margin-left": "10"
						}
					}).on('changed.jstree', function(e, data) {
						uppFolderId = data.selected[0];
						parentId = data.node.original.parent;
					});
				},
				error: function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
		}

		function folderCopyMove(obj) {
			if (uppFolderId == "") {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (parentId == "#") {
				if (folderType == "C") {
					alert("<spring:message code='ezWebFolder.t310'/>");
					return;
				}
			}
			
			if (uppFolderId.indexOf("_") > -1) {
				uppFolderId = uppFolderId.substring(0, uppFolderId.indexOf("_"));
			}
			
			if (folderId == uppFolderId) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFolder.do",
				data: {
					"folderId": folderId,
					"uppFolderId": uppFolderId,
					"mode": obj
				},
				dataType: "JSON",
				async: false,
				success: function(data) {
					var code = data.code;
					afterSuccess(code, moveCopyType);
				},
				error: function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
		function addTitle() {
		   	var data = this.treeData;
		   	for ( var i = 0; i < data.length ; i++  ) {
		   		var dataId = data[i]["id"] + "_anchor";
		   		var folderName = data[i]["folderName1"];
		   		var childE = document.getElementById(dataId);
		   		if (childE != null){
					childE.setAttribute("title", folderName);
	    		}
	    	}
	    }
	</script>
</head>
<body class="popup">
	<h1 id="topMenu"><spring:message code='ezWebFolder.t120'/></h1>
	<div id="close">
		<ul>
			<li><span onclick="windowClose();"></span></li>
		</ul>
	</div>
	
	<div style="border: none; height: 30px; position: relative;">
		<div style="text-align: right;margin-right: 10px;">
			<input name="treeType" id="radio1" type="radio" value="C" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle; display: none;" onclick="folderList('C');"><label for="radio1" style="display: none;"><span> <spring:message code="ezWebFolder.t233"/></span></label>
			<input name="treeType" id="radio2" type="radio" value="D" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle; display: none;" onclick="folderList('D');"><label for="radio2" style="display: none;"><span> <spring:message code="ezWebFolder.t234"/></span></label>
			<input name="treeType" id="radio3" type="radio" value="U" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle; display: none;" onclick="folderList('U');"><label for="radio3" style="display: none;"><span> <spring:message code='ezWebFolder.t235'/></span></label>
			<input name="treeType" id="radio4" type="radio" value="S" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle; display: none;" onclick="folderList('S');"><label for="radio4" style="display: none;"><span> <spring:message code='ezWebFolder.t266'/></span></label>
		</div>
	</div>
	<div style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 320px; height: 320px; overflow: auto; padding-top:5px" id="folderTree"></div>
		
	<div class="btnposition btnpositionNew">
        <a id="btnSave" class="imgbtn" onclick="typeCheck();"><span><spring:message code='ezWebFolder.t116'/></span></a>
    </div>	
</body>
</html>