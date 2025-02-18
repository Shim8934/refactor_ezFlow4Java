<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title><spring:message code="ezWebFolder.t268"/></title>
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/js/ezWebFolder/jsTree/dist/themes/default/style.css')}" />
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jsTree/dist/jstree.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
    <style type="text/css">
    	.jstree-ocl {
    		margin-top: 6px !important;
    	}
    	.jstree-default-small .jstree-node {
    		margin-left: 7px !important;
    	}
    	.jstree-clicked {
    		color: #0470E4 !important;
    		text-decoration: underline !important;
    	}
    	.list_text {
    		font-size: 14px !important;
			cursor : pointer;
    	}
    </style>
    <script>
		var lang = "${userinfo.lang}";
		var PostTreeView = null;
		var treeconfig = "";
		var ReturnFunction;
		var CancelFunction;
		var isDivPopUp = false;
		var isFolderManager = "${isFolderManager}" == "1";
		var parentControll = [];
		
		var createId = "";
		var id = "";
		var parent = "";
		var companyFolderId = "";
		var deptFolderId = "";
		var persFolderId = "";
		var userId = "<c:out value='${userId}'/>";
		var userName = "<c:out value='${userName}'/>";
		var folderId = "";
		var folderType = "<c:out value='${folderType}'/>";
		var folderName1 = "";
		var folderName2 = "";
		var drawVolume = "";
		var treeData;
		var selectedFolderLevel = "";
		
		var inputNameDlg_cross_dialogArguments = new Array();
		var moveCopyFolderDlg_cross_dialogArguments = [];
		var deleteFolderDlg_cross_dialogArguments = [];
		
		window.onload = function() {
			$('input:radio[name=treeType]:input[value=' + folderType + ']').prop("checked", true);
			drawVolume = opener.webfolder_folder_Manage[1];
			folderList(folderType);
		}
		
		document.onselectstart = function() {
			return event.srcElement.tagName == "INPUT" || event.srcElement.tagName == "TEXTAREA";
		}

		function Window_Close() {
			if (ReturnFunction != null) {
				if (!isDivPopUp) {
					//window.opener.drawVolume();
					window.close();
				} else {
					CancelFunction();
				}
			} else {
				//window.opener.drawVolume();
			}
			window.opener.refreshView();
			window.close();
		}

		function folderList(obj) {
			$('#tree').jstree('destroy');
			folderType = obj;
			$.ajax({
				type: "POST",
				async: false,
				url: "/ezWebFolder/folderList.do",
				data: {
					"folderId": folderId,
					"folderType": obj
				},
				dataType: "JSON",
				success: function(data) {
					//						upperId = data.data[0]["parent"];
					parentControll = data.data;
					var firstNode = "#" + folderId;
					treeData = parentControll;
					addTitle();
					$('#tree').on('changed.jstree', function(e, data) {
						folderId = data.selected[0];
						createId = folderId != null ? data.node.original.createId : "";
						folderName1 = folderName1 != null ? data.node.original.folderName1 : "";
						folderName2 = folderName2 != null ? data.node.original.folderName2 : "";
						parent = data.node.original.parent;
						selectedFolderLevel = data.node.original.folderLevel;
					}).jstree({
						'plugins': [ "core", "types", "json_data", "themes", "ui" ],
						'core': {
							"animation": 0,
							'data': data.data,
							"multiple": false,
							'themes': {
								"theme"		: "default",
								"dots"		: false,
								'responsive': false,
								'variant'	: 'small',
								'stripes'	: false
							}
						},
						"types": {
							"default": {
								"icon": "/images/OrganTree_cross/fldr.gif"
							}
						},
						"grid": {
							"width"			: "20",
							"margin-left"	: "10"
						}
					});
					
				},
				error: function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
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
		 
		function radioOnclick(obj) {
			folderId = "";
			folderList(obj);
		}

		function add_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t257'/>");
				return;
			}
			
			if (folderType == "C") {
				if (parent == '#') {
					alert("<spring:message code='ezWebFolder.t326'/>");
					return;
				}
			}
			
			var functionType = "insert";
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}

			inputNameDlg_cross_dialogArguments[0] = folderId;
			inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
			inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
			inputNameDlg_cross_dialogArguments[3] = functionType;
			inputNameDlg_cross_dialogArguments[4] = folderName1;
			inputNameDlg_cross_dialogArguments[5] = folderName2;
			DivPopUpShow(450, 200, "/ezWebFolder/fileRenameConfirm.do?fileId=0");
			functionType = "";
		}

		function update_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t256'/>");
				return;
			}
			
			if (parent == '#') {
				if (folderType == "S") {
					alert("<spring:message code='ezWebFolder.t327'/>");
				} else {
					alert("<spring:message code='ezWebFolder.t328'/>");
				}
				
				return;
			}
			
			if (folderType == "C") {
				for (var i = 0; i < parentControll.length; i++) {
					if (parentControll[i].id == parent) {
						if (parentControll[i].parent == '#') {
							alert("<spring:message code='ezWebFolder.t329'/>");
							return;
						}
					}
				}
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"folderList" : folderId
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.status;
					
					if (result != "ok") {
						alert(messages.strLang42);
					} else {
						var functionType = "update";
				
						if (folderId.indexOf("_") > -1) {
							folderId = folderId.substring(0, folderId.indexOf("_"));
						}
						
						inputNameDlg_cross_dialogArguments.currentName = folderName1;
						inputNameDlg_cross_dialogArguments[0] = folderId;
						inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
						inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
						inputNameDlg_cross_dialogArguments[3] = functionType;
						inputNameDlg_cross_dialogArguments[4] = folderName1;
						inputNameDlg_cross_dialogArguments[5] = folderName2;
						DivPopUpShow(450, 200, "/ezWebFolder/fileRenameConfirm.do?fileId=0");
					}
					
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				},
				complete: function() {
					functionType = "";
				}
			});
		}

		function delete_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t259'/>");
				return;
			}
			
			if (parent == '#') {
				if (folderType == "S") {
					alert("<spring:message code='ezWebFolder.t330'/>");
				} else {
					alert("<spring:message code='ezWebFolder.t331'/>");
				}
				return;
			} 
			
			if (folderType == "C") {
				for (var i = 0; i < parentControll.length; i++) {
					if (parentControll[i].id == parent) {
						if (parentControll[i].parent == '#') {
							alert("<spring:message code='ezWebFolder.t329'/>");
							return;
						}
					}
				}
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"folderList" : folderId,
					"isRecursive" : true
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.status;

					if (result != "ok") {
						alert(messages.strLang41);
					} else {
						if (folderId.indexOf("_") > -1) {
							folderId = folderId.substring(0, folderId.indexOf("_"));
						}
						
						deleteFolderDlg_cross_dialogArguments[0] = folderId;
						deleteFolderDlg_cross_dialogArguments[1] = add_onclick_Complete;
						console.log("folderId delete_onclick function" + folderId);
						console.log("deleteFolderDlg_cross_dialogArguments delete_onclick function" + deleteFolderDlg_cross_dialogArguments[0]);
						DivPopUpShow(335, 200, "/ezWebFolder/folderDelete.do");
					}
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
		}

		function move_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t261'/>");
				return;
			}
			
			if (parent == '#') {
				if (folderType == "S") {
					alert("<spring:message code='ezWebFolder.t332'/>");
				} else {
					alert("<spring:message code='ezWebFolder.t333'/>");
				}
				
				return;
			} 
			if (folderType == "C") {
				for (var i = 0; i < parentControll.length; i++) {
					if (parentControll[i].id == parent) {
						if (parentControll[i].parent == '#') {
							alert("<spring:message code='ezWebFolder.t329'/>");
							return;
						}
					}
				}
			}

			if (folderType == "C" && selectedFolderLevel == "1") {
				alert("<spring:message code='ezWebFolder.t329'/>");
				return;
			}
			
			if (folderType == "C") {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission.do",
					data: {
						"folderList" : folderId,
						"isRecursive" : false
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var isPermitted = data.status == "ok";
						if (!isPermitted) {
							alert("<spring:message code='ezWebFolder.t334'/>");
							return;
						} else {
							if (folderId.indexOf("_") > -1) {
								folderId = folderId.substring(0, folderId.indexOf("_"));
							}
							
							moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
							moveCopyFolderDlg_cross_dialogArguments[1] = "move";
							moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
							moveCopyFolderDlg_cross_dialogArguments[3] = folderType;
							console.log("folderId moveCopy_onclick function" + folderId);
							console.log("moveCopyFolderDlg_cross_dialogArguments delete_onclick function" + moveCopyFolderDlg_cross_dialogArguments[0]);
							DivPopUpShow(360, 470, "/ezWebFolder/folderMove.do");
							
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			} else {
				moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
				moveCopyFolderDlg_cross_dialogArguments[1] = "move";
				moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
				moveCopyFolderDlg_cross_dialogArguments[3] = folderType;
				console.log("folderId moveCopy_onclick function" + folderId);
				console.log("moveCopyFolderDlg_cross_dialogArguments delete_onclick function" + moveCopyFolderDlg_cross_dialogArguments[0]);
				DivPopUpShow(360, 470, "/ezWebFolder/folderMove.do");
			}
		}

		function copy_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t335'/>");
				return;
			}
			
			if (parent == '#' && folderType != "S") {
				alert("<spring:message code='ezWebFolder.t336'/>");
				return;
			}
			
			if (folderType == "C" && selectedFolderLevel == "1") {
				alert("<spring:message code='ezWebFolder.t329'/>");
				return;
			}
			
			if (folderType == "C") {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission.do",
					data: {
						"folderList" : folderId,
						"isRecursive" : false
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var isPermitted = data.status == "ok";
						if (!isPermitted) {
// 							alert("<spring:message code='ezWebFolder.t334'/>");
// 							return;
						} else {
							if (folderId.indexOf("_") > -1) {
								folderId = folderId.substring(0, folderId.indexOf("_"));
							}
							
							moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
							moveCopyFolderDlg_cross_dialogArguments[1] = "copy";
							moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
							moveCopyFolderDlg_cross_dialogArguments[3] = folderType;
							DivPopUpShow(360, 470, "/ezWebFolder/folderMove.do");
							
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			} else {
				moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
				moveCopyFolderDlg_cross_dialogArguments[1] = "copy";
				moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
				moveCopyFolderDlg_cross_dialogArguments[3] = folderType;
				DivPopUpShow(360, 470, "/ezWebFolder/folderMove.do");
			}
		}
		
		function share_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t337'/>");
				return;
			}
			
			if (folderType == "C"){
				alert("<spring:message code='ezWebFolder.pyy01'/>");
				return;
			}
			
			if (parent == '#' && folderType != "S") {
				alert("<spring:message code='ezWebFolder.t338'/>");
				return;
			}
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}
			
			var openWindow = window.open("/ezWebFolder/addShareView.do?folderFileId=" + folderId + "&folderFileType=D", "addShareView", GetOpenWindowfeature(610, 685));
	        try { openWindow.focus(); } catch (e) { }
		}

		function requestdata(event) {
			if (!event)
				event = window.event;
			var nodeIdx = event.nodeIdx;
			if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
				nodeIdx = arguments[0].nodeIdx;
			}
			//             var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false, true)
			//             PostTreeView.putchildxml(nodeIdx, childxml);
		}

		function add_onclick_Complete(szName) {
			DivPopUpHidden();
			folderList(folderType);
		}

		function returnFunction(type) {
			//window.opener.drawVolume();
			folderType = type;
			$('input:radio[name=treeType]:input[value=' + folderType + ']').prop("checked", true);
        	add_onclick_Complete('');
		}
		function refreshView() {
			// 파일과 같은 function타게 하기 위해 생성
		}
		
		function closeAllPopup() {
			add_onclick_Complete();
		}
	</script>
</head>
<body scroll="no" class="popup" >
	<h1><spring:message code="ezWebFolder.t268"/></h1> 
	<div id="close">
		<ul>
			<li><span onclick="Window_Close();"></span></li>
		</ul>
	</div>
	
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="C" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="radioOnclick('C');"><label for="radio1"><span> <spring:message code='ezWebFolder.t233'/></span></label>
			<input name="treeType" id="radio2" type="radio" value="D"         style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="radioOnclick('D');"><label for="radio2"><span> <spring:message code='ezWebFolder.t234'/></span></label>
			<input name="treeType" id="radio3" type="radio" value="U"         style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="radioOnclick('U');"><label for="radio3"><span> <spring:message code='ezWebFolder.t235'/></span></label>
			<input name="treeType" id="radio4" type="radio" value="S"         style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="radioOnclick('S');"><label for="radio4"><span> <spring:message code='ezWebFolder.t266'/></span></label>
		</div>
	</div>
	<div style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 350px; height: 350px; overflow: auto;padding-top:5px" id="tree" class="webfolderTree"></div>
	
	<div class="btnpositionNew">
      	<a class="imgbtn" onclick="add_onclick()"><span><spring:message code="ezWebFolder.t255"/></span></a>
      	<a class="imgbtn" onclick="update_onclick()"><span><spring:message code="ezWebFolder.t162"/></span></a>
      	<a class="imgbtn" onclick="move_onclick()"><span><spring:message code="ezWebFolder.t121"/></span></a>
      	<a class="imgbtn" onclick="copy_onclick()"><span><spring:message code="ezWebFolder.t122"/></span></a>
      	<a class="imgbtn" onclick="share_onclick()"><span><spring:message code="ezWebFolder.t254"/></span></a>
      	<a class="imgbtn" onclick="delete_onclick()"><span><spring:message code="ezWebFolder.t111"/></span></a>
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

