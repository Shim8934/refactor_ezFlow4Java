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
	    	
	    	
		});	
		function typeCheck(){
			if (moveCopyType == "move") {
				folderCopyMove('folder-move');
			}else if (moveCopyType == "copy"){
				folderCopyMove('folder-copy');
			}
			
		}
		function afterSuccess(code) {
			if (code == '0') {
				parent.folderList(folderType);
				parent.returnFunction(folderType);
				parent.DivPopUpHidden();
				window.close();
			}else if(code == '2') {
				alert("하위 파일 또는 폴더를 이동 또는 복사할 권한이 없습니다.");
				window.close();
			}else {
				alert("복사 또는 이동에 문제가 생김");
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
					afterSuccess(code);
					
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
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
			<input name="treeType" id="radio1" type="radio" value="C" checked style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('C');"> <span><spring:message code="ezWebFolder.t233"/></span>
			<input name="treeType" id="radio2" type="radio" value="D"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('D');"> <span><spring:message code="ezWebFolder.t234"/></span>
			<input name="treeType" id="radio3" type="radio" value="U"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="folderList('U');"> <span><spring:message code='ezWebFolder.t235'/></span>
		</div>
	</div>
	<div style="margin: 5px 10px 10px 10px; border: 1px solid #666666; min-height: 350px; height: 350px; overflow: auto;" id="folderTree"></div>
	
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
		<a id="btnSave"  class="webfolderBttn" onClick="typeCheck();"><span>확인</span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="Window_Close();"><span>취소</span></a>
	</div>
	
</body>
</html>