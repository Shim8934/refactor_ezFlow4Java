<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script src="/js/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
	<link rel="stylesheet" href="/js/jsTree/dist/themes/default/style.css" />
	<script type="text/javascript" src="/js/jsTree/dist/jstree.js"></script>
	<script type="text/javascript">
		var primary        = "<c:out value='${primary}'/>";
		var folderId       = "";
		var uppFolderId       = "";
		var selectedFolder = null;
		var arrSubFolder   = [];
		
		
		window.onload = function () {
		};
		$(function() { 
			folderList('C');
	    	folderType = 'C';
	    	
	    	 try {
	            	folderId = parent.moveCopyFolderDlg_cross_dialogArguments[0];
	            } catch (e) { }
//		            if (InputValue != "") {
//		                txt_FolderName.value = InputValue;
//		            }
	            try {
	                txt_FolderName.focus();
	            }
	            catch (e)
	            { }
	    	
	    	
		});	
		function afterSuccess(reason) {
			if (!reason) {
				parent.folderList(folderType);
				parent.DivPopUpHidden();
				window.close();
			}
			else {
				alert(reason);
				return;
			}
		}
		function Window_Close() {
			parent.DivPopUpHidden();
			window.close();
		}
	    function folderList(obj) {
//		    	folderId = "";
			if ( obj == 'C') {
				$element = '#tree';
			}else if (obj == 'D') {
				$element = '#treeDept';
			}else if (obj == 'U') {
				$element = '#treePer';
			}
			folderType = obj;
			
			$.ajax ({
				type :"POST",
				async: false,
				url  : "/ezWebFolder/folderList.do",
				data : { 
						 "folderId"   	 : folderId
						,"uppFolderId"   : uppFolderId
						,"folderType" 	 : obj
						
				},
				dataType: "JSON",
				success : function (data) {
					$.jstree.destroy();
					$('#folderTree').jstree({
						
						'plugins': ["core","types","json_data","themes","ui"],
						'core' : {
							"animation" : 0,
							'data' : data.data,
							"multiple" : false,
							'themes' : {
								"theme"      : "default",
								"dots"       : false,
								'responsive' : false,
								'variant'    : 'small',
								'stripes'    : false
							}
						},
						"types" : {
							"default": {
								"icon" :"/images/OrganTree_cross/fldr.gif" 
							}
						},
						"grid": {
							"width"       : "20",
							"margin-left" : "10"
						}
					});
					uppFolderId = data.data[0].id;
					$('#folderTree').jstree('refresh');
					$('#folderTree').jstree("selected", folderId);
			   		
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			});
			$('#folderTree').on('changed.jstree', function (e, data) {
				var folderId = "";
				uppFolderId = data.selected[0]; 
// 				alert(uppFolderId);
			});
	    }
	    var obj = "";
		function folderCopyMove(obj) {
			if (uppFolderId == "") {
				alert(uppFolderId);
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (folderId == uppFolderId) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			alert("uppFolderId : "+uppFolderId+"folderId : "+ folderId);
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFolder.do",
				data: {
					"folderId"     : folderId
					,"uppFolderId"  : uppFolderId
					,"mode"			: obj
				},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var reason = data.reason;
					afterSuccess(reason);
					
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		/*
		function folderMove() {
			if (uppFolderId == "") {
				alert(uppFolderId);
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (folderId == uppFolderId) {
				alert("같은 폴더로 이동할 수 없습니다.");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFolder.do",
				data: {
					 "folderId"     : folderId
					,"uppFolderId"  : uppFolderId
					,"mode"			: "move"
				},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var reason = data.reason;
					afterSuccess(reason);
				},
 				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		*/
		
	</script>
</head>
<body class="popup">
	<div id="menu">
		<div style="font-weight: bold; font-size: 16px; color: #fff; margin-top: 3px;"><spring:message code='ezWebFolder.t120'/></div>
	</div>
	<div id="close">
		<ul>
			<li><span onclick="Window_Close();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="comp" checked style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('C');"> <span><spring:message code="ezWebFolder.t233"/></span>
			<input name="treeType" id="radio2" type="radio" value="dept"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('D');"> <span><spring:message code="ezWebFolder.t234"/></span>
			<input name="treeType" id="radio3" type="radio" value="user"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('U');"> <span><spring:message code="ezWebFolder.t234"/></span>
		</div>
	</div>
	<div style="margin: 5px 10px 10px 10px; border: 1px solid #666666; min-height: 350px; height: 350px; overflow: auto;" id="folderTree"></div>
	
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
		<a id="btnSave"  class="webfolderBttn" onClick="folderCopyMove('folder-move');"><span><spring:message code='ezWebFolder.t121'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="folderCopyMove('folder-copy');"><span><spring:message code='ezWebFolder.t122'/></span></a>
	</div>
	
</body>
</html>