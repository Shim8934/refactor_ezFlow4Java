<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title><spring:message code="ezWebFolder.t268"/></title>
    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
	<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1'/>"></script>
    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
    <link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/js/ezWebFolder/jsTree/dist/themes/default/style.css")%>" />
    <link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezWebFolder/webfolder.css")%>" type="text/css">
	<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezWebFolder/jsTree/dist/jstree.js")%>"></script>
    <script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
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
		var folderType = "${folderType}";
		var folderName1 = "";
		var folderName2 = "";
		var drawVolume = "";
		
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
					window.opener.drawVolume();
					window.close();
				} else {
					CancelFunction();
				}
			} else
				window.opener.drawVolume();
			window.close();
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
					"folderType": obj
				},
				dataType: "JSON",
				success: function(data) {
					//						upperId = data.data[0]["parent"];
					parentControll = data.data;
					var firstNode = "#" + folderId;
					
					$('#folderTree').jstree({
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
								"icon": "/images/webfolder/fldr.png"
							}
						},
						"grid": {
							"width"			: "20",
							"margin-left"	: "10"
						}
					}).on('changed.jstree', function(e, data) {
						folderId = data.selected[0];
						createId = folderId != null ? data.node.original.createId : "";
						folderName1 = folderName1 != null ? data.node.original.folderName1 : "";
						folderName2 = folderName2 != null ? data.node.original.folderName2 : "";
						parent = data.node.original.parent;
					});
					
				},
				error: function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
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
			DivPopUpShow(330, 170, "/ezWebFolder/inputNameDlg.do");
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
			
			if (userId != createId) {
				alert("<spring:message code='ezWebFolder.t258'/>");
				return;
			}
			
			var functionType = "update";
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}
			
			inputNameDlg_cross_dialogArguments[0] = folderId;
			inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
			inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
			inputNameDlg_cross_dialogArguments[3] = functionType;
			inputNameDlg_cross_dialogArguments[4] = folderName1;
			inputNameDlg_cross_dialogArguments[5] = folderName2;
			DivPopUpShow(330, 170, "/ezWebFolder/inputNameDlg.do");
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
			
			if (userId != createId) {
				alert("<spring:message code='ezWebFolder.t260'/>");
				return;
			}
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}
			
			deleteFolderDlg_cross_dialogArguments[0] = folderId;
			deleteFolderDlg_cross_dialogArguments[1] = add_onclick_Complete;
			console.log("folderId delete_onclick function" + folderId);
			console.log("deleteFolderDlg_cross_dialogArguments delete_onclick function" + deleteFolderDlg_cross_dialogArguments[0]);
			DivPopUpShow(335, 225, "/ezWebFolder/folderDelete.do");
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
			
			if (userId != createId) {
				alert("<spring:message code='ezWebFolder.t334'/>");
				return;
			}
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}
			
			moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
			moveCopyFolderDlg_cross_dialogArguments[1] = "move";
			moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
			console.log("folderId moveCopy_onclick function" + folderId);
			console.log("moveCopyFolderDlg_cross_dialogArguments delete_onclick function" + moveCopyFolderDlg_cross_dialogArguments[0]);
			DivPopUpShow(330, 470, "/ezWebFolder/folderMove.do");
		}

		function copy_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t335'/>");
				return;
			}
			
			if (parent == '#' && folderType != "S") {
				alert("<spring:message code='ezWebFolder.t336'/>");
				alert("<spring:message code='ezWebFolder.t336'/>");
				return;
			}
			
			if (folderId.indexOf("_") > -1) {
				folderId = folderId.substring(0, folderId.indexOf("_"));
			}
			
			moveCopyFolderDlg_cross_dialogArguments[0] = folderId;
			moveCopyFolderDlg_cross_dialogArguments[1] = "copy";
			moveCopyFolderDlg_cross_dialogArguments[2] = returnFunction;
			DivPopUpShow(330, 470, "/ezWebFolder/folderMove.do");
		}
		
		function share_onclick() {
			if (folderId == "") {
				alert("<spring:message code='ezWebFolder.t337'/>");
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
			folderType = type;
			$('input:radio[name=treeType]:input[value=' + folderType + ']').prop("checked", true);
        	add_onclick_Complete('');
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
	<div style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 350px; height: 350px; overflow: auto;padding-top:5px" id="folderTree"></div>
	
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

