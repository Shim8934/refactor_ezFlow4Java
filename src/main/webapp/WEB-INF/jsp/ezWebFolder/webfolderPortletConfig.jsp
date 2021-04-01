<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/ezWebFolder/jsTree/dist/themes/default/style.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jsTree/dist/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jstreeManage.js')}"></script>
	<script type="text/javascript">
		// 2020-12-15 김은실 - [카이스트] 테스트 거의 다 완료되고, 다른 문제 안 생기면 주석 깨끗히 정리 하겠습니다
		/* var listCnt = "<c:out value="${wfListConfig.envValue}"/>"; */
		// "/ezWebFolder/folderList.do"를 위한 변수
		var folderId = "";
	    var firFolderId = "";
	    var treeData;
	    var parentId = "";
	    var f_Level = "";
	    // webfolderPortletConfig.jsp를 위한 변수
		var selectFolderId = "<c:out value="${folderId}"/>";
		
// 		document.onselectstart = function () { return false; };
		window.onload = function () {
/* 			if (navigator.userAgent.indexOf('Firefox') != -1) {
				document.body.style.MozUserSelect    = 'none';
				document.body.style.WebkitUserSelect = 'none';
				document.body.style.khtmlUserSelect  = 'none';
				document.body.style.oUserSelect      = 'none';
				document.body.style.UserSelect       = 'none';
			} */
			configTreeFolderList();
		}
		function Change_Click() {
			var targetFolderId = document.querySelector("[aria-selected='true']").getAttribute("id");
			if(!Boolean(targetFolderId)){
				alert("error");
			}
			$.ajax({
				url : '/ezWebFolder/savePortletConfig.do',
				method : 'POST',
				dataType : 'JSON',
				data : {
					"selectFolderId" : selectFolderId,
					"targetFolderId" : targetFolderId
				} ,
				success : function(data, textStatus, jqXHR) {
					var code = data.code;
					
					switch(code) {
						case 0: 
							alert('<spring:message code="ezWebFolder.t182"/>');
							selectFolderId = targetFolderId;
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert('Error : ' + jqXHR.status + ", " + textStatus);
				}
			});
		}
/*		
		function Cancel_Click() {
			document.getElementById("listcount").value = listCnt;
		}
		
		function Change_Click() {
			var listCount = document.getElementById("listcount").value;
			
			$.ajax({
				url : '/ezWebFolder/saveGeneralList.do',
				method : 'POST',
				dataType : 'JSON',
				data : {
					"listCount" : listCount
				} ,
				success : function(data, textStatus, jqXHR) {
					var code = data.code;
					
					switch(code) {
						case 0: 
							alert('<spring:message code="ezWebFolder.t182"/>');
							listCnt = listCount;
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert('Error : ' + jqXHR.status + ", " + textStatus);
				}
			});
		} */
//		function event_folderMenu(event){}
//		function HiddenFolderMenu(){}
		function addTitle() {
	    	var data = this.treeData;
	    	for ( var i = 0; i < data.length ; i++  ) {
	    		var dataId = data[i]["id"] + "_anchor";
	    		var folderName = data[i]["text"];
	    		var folderLevel = data[i].folderLevel;
	    		var childE = document.getElementById(dataId);
	    		if (childE != null){
					childE.setAttribute("title", folderName);
					childE.setAttribute("folderLevel", folderLevel);
	    		}
	    	}
	    }
		function configTreeFolderList() {
	    	$('#ConfigTree').jstree('destroy');
			$.ajax ({
				type :"POST",
				async: true,
				url  : "/ezWebFolder/folderList.do",
				data : {
						 "folderId"   : folderId
						,"folderType" : "C"
						,"subTypeC"   : "task"
					},
				dataType: "JSON",
				success : function (data) {
					// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: 해당폴더가 없음 화면
					if(data.data.length == 1){
						window.parent.parent.frames["left"].openWebFolderRightWarning();
						return;
					}

					var firstNode = "#" + folderId;
					
					$('#ConfigTree').on('loaded.jstree', function() {
						firFolderId = data.data[0]["id"];
						var test = "#" + folderId;
						var elmentTest = document.getElementById(firFolderId);
						var childE = document.getElementById(firFolderId + "_anchor");
						childE.setAttribute("class", "jstree-anchor jstree-clicked");
						elmentTest.setAttribute("aria-selected", "true");
//						$('.jstree-anchor').attr('oncontextmenu', 'event_folderMenu(event);');
//						$('.jstree-anchor').attr('onclick', 'HiddenFolderMenu();');

						treeData = data.data;
						addTitle();
						folderId = firFolderId;
						parentId = data.data[0].parent;
						f_Level = data.data[0].folderLevel;
						
						// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: 회사레벨 펼치고, 회사폴더 숨기기
						// 2020-11-26 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
//						if("${subTypeC}") {
							for(var i = 0; i < data.data.length; i++){ 
								if(data.data[i].parent == folderId){
									parentId = folderId;
									folderId = data.data[i]["id"];
									f_Level = data.data[i].folderLevel
									break;
								}
							}
							$('#ConfigTree>ol>li>i').click();
							$('#ConfigTree>ol>li').css('left','-20px');
							$('#ConfigTree>ol>li>i').css('display','none');
							$('#ConfigTree>ol>li>a').css('display','none');
							//$('#ConfigTree>ol>li>ol>li:first-child>a').addClass('jstree-clicked');
							//$('#${folderId}_anchor').addClass('jstree-clicked');
//						}

//						if (${ subTypeC eq 'meeting' }){
//							$('#tree>ol>li>ol>li>a>i').css('background-image', 'url("/images/webfolder/conference_file.png")');
//						} else {
//							if (${ subTypeC eq 'task' }) {
								$("#ConfigTree>ol>li>ol>li>a>i").css('background-image', 'url("/images/webfolder/business_data.png")');
//							} else {
//								$('#tree>ol>li>ol>li>a>i').css('background-image', 'url("/images/webfolder/agenda_item.png")');
//							}
//						}
								selectConfigFolder(selectFolderId);
				/* 	}).on('changed.jstree', function (e, data) {
						var folderId = "";
						folderId = data.selected[0];
						f_Level = data.node.original.folderLevel;
						parentId = data.node.parent; */
					}).jstree({
						'plugins': ["core","types","json_data","themes","contextmenu","ui"],
						'core' : {
							"animation" : 0,
							'data' : data.data,
							"multiple" : false,
							'themes' : {
								"theme"      : "default",
								"dots"       : false,
								'responsive' : false,
								'variant'    : 'small',
								'stripes'    : false,
								"load_open"	 : true
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
				},
				error : function(error) {
//						alert("<spring:message code='ezWebFolder.t134' />" + error + (ssss) );
				}
			});
//			$(".lnbUL li .jstree-node").css("margin","0px 0px 0px 10px");
	    }
	    
	    // jstree의 특성상 loaded.jstree가 다른 function 뒤에 실행되므로 jstree가 필요한 상황이면 load된 후 function실행하도록 
/* 	    function folderList2(obj) {
	    	$($element).jstree('destroy');
			if ( obj == 'C') {
				$element = '#tree';
			} else if (obj == 'D') {
				$element = '#treeDept';
			} else if (obj == 'U') {
				$element = '#treePer';
			}
			
			folderType = obj;
			$.ajax ({
				type :"POST",
				async: true,
				url  : "/ezWebFolder/folderList.do",
				data : {
						 "folderId"   : folderId
						,"folderType" : obj
					},
				dataType: "JSON",
				success : function (data) {
					var firstNode = "#" + folderId;

					$($element).on('loaded.jstree', function() {

						$('.jstree-anchor').attr('oncontextmenu', 'event_folderMenu(event);');
						$('.jstree-anchor').attr('onclick', 'HiddenFolderMenu();');
						firFolderId = folderId;
						treeData = data.data;
						f_Level = data.data[0].folderLevel;
						addTitle();
						selectFolder(folderId);
						
					}).on('changed.jstree', function (e, data) {
						try {
							if(data.node.parent != undefined ){
								folderId = data.selected[0];
								parentId = data.node.parent;
								f_Level = data.node.original.folderLevel;
								getFileList(folderId);
							}
						} catch(e){}
						
					}).jstree({
						'plugins': ["core","types","json_data","themes","contextmenu","ui"],
						'core' : {
							"animation" : 0,
							'data' : data.data,
							"multiple" : false,
							'themes' : {
								"theme"      : "default",
								"dots"       : false,
								'responsive' : false,
								'variant'    : 'small',
								'stripes'    : false,
								"load_open": true
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
				},
				error : function(error) {
//						alert("<spring:message code='ezWebFolder.t134' />" + error + (ssss) );
				}
			});
	    } */
	    function selectConfigFolder(folderId){
			var jstree = $('#ConfigTree').jstree()
			jstree.settings.core.check_callback = true;
			$('#ConfigTree').jstree().deselect_all(true); 
			$('#ConfigTree').jstree().select_node(folderId , true); 
	    }
	</script>
</head>
<body style="margin-left: 10px; margin-right: 10px;">
	<br/>
	<%-- <h2><spring:message code="ezWebFolder.t238" /></h2> --%>
	<span class="txt"><spring:message code="ezWebFolder.kes018"/></span>
	<br />
	<table class="content" style="width: 623px;margin-top:5px">
		<tr>
			<th><spring:message code="ezWebFolder.kes014" /></th>
			<td>
    			<div style="height: 350px; overflow: auto;">
	    			<div id="ConfigTree" class="webfolderTree" ></div>
    			</div>
			</td>
		</tr>
	</table>
	<div style="width:609px;" class="btnpositionJsp">      
		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezWebFolder.t133" /></span></a>
		<%-- 2020-12-14 김은실 - [카이스트] 업무자료실 포틀릿 설정 : 취소는 필요 없을 것으로 보입니다.
		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezWebFolder.t112" /></span></a>
		 --%>
	</div>
</body>
</html>