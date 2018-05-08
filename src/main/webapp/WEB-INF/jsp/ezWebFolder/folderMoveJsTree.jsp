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
		var uppFolderId    = "";
		var selectedFolder = null;
		var arrSubFolder   = [];
		var moveCopyType = "";
		
		
		window.onload = function () {
		};
		$(function() { 
			folderList('C');
	    	folderType = 'C';
	    	
	    	 try {
	            	folderId 		= parent.moveCopyFolderDlg_cross_dialogArguments[0];
	            	moveCopyType 	= parent.moveCopyFolderDlg_cross_dialogArguments[1];
	            	returnFunction 	= parent.moveCopyFolderDlg_cross_dialogArguments[2] ;
	            } catch (e) { }
//		            if (InputValue != "") {
//		                txt_FolderName.value = InputValue;
//		            }
	            try {
	                txt_FolderName.focus();
	            }
	            catch (e)
	            { }
	    	if( moveCopyType == "move") {
	    		$('#topMenu').text("<spring:message code='ezWebFolder.t296'/>");
	    	}else  {
	    		$('#topMenu').text("<spring:message code='ezWebFolder.t297'/>");
	    	}
	    	
	    	
		});	
		function typeCheck(){
			if (moveCopyType == "move") {
				folderCopyMove('folder-move');
			}else if (moveCopyType == "copy"){
				folderCopyMove('folder-copy');
			}
			
		}
		function afterSuccess(code,obj) {
			if (code == 0) {
				if(obj == "move") {
					alert("<spring:message code='ezWebFolder.t298'/>");
				}else if(obj == "copy") {
					alert("<spring:message code='ezWebFolder.t299'/>");
				}
				parent.returnFunction(folderType);
				parent.folderList(folderType);
				parent.DivPopUpHidden();
				window.close();
			}else if (code == 2) {
				alert("<spring:message code='ezWebFolder.t300'/>");
			}else if(code == 4) {
				alert("<spring:message code='ezWebFolder.t301'/>");
				window.close();
			}else {
				alert("<spring:message code='ezWebFolder.t302'/>");
				window.close();
				return;
			}
		}
		function Window_Close() {
			parent.DivPopUpHidden();
			window.close();
		}
	    function folderList(obj) {
//		    	folderId = "";
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
								"icon" :"/images/webfolder/fldr.png"
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
// 			console.log("uppFolderId : "+uppFolderId+"folderId : "+ folderId);
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFolder.do",
				data: {
					"folderId"      : folderId
					,"uppFolderId"  : uppFolderId
					,"mode"			: obj
				},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var code = data.code;
					afterSuccess(code,obj);
					
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
	</script>
</head>
<body class="popup">
	<h1 id ="topMenu"><spring:message code='ezWebFolder.t120'/></h1>
	<div id="close">
		<ul>
			<li><span onclick="Window_Close();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="C" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="folderList('C');"> <span><spring:message code="ezWebFolder.t233"/></span>
			<input name="treeType" id="radio2" type="radio" value="D"         style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="folderList('D');"> <span><spring:message code="ezWebFolder.t234"/></span>
			<input name="treeType" id="radio3" type="radio" value="U"         style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="folderList('U');"> <span><spring:message code='ezWebFolder.t235'/></span>
		</div>
	</div>
	<div style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 320px; height: 320px; overflow: auto; padding-top:5px" id="folderTree"></div>
	
	<div style="margin: 10px 0px 0px; text-align: center">
		<a id="btnSave"  class="webfolderBttn" onClick="typeCheck();"><span>확인</span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="Window_Close();"><span>취소</span></a>
	</div>
	
</body>
</html>