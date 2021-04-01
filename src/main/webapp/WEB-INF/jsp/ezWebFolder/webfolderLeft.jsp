<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	   	<link rel="stylesheet" href="${util.addVer('ezWebFolder.e1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">	        
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/ezWebFolder/jsTree/dist/themes/default/style.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jsTree/dist/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jstreeManage.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	#mCSB_1_container {
				margin-right: 0px;
			}
			.mCustomScrollBox{ /* contains plugin's markup */
				/* height: 93%; */
			}
			.lnbUL {
				padding-bottom: 0px;
			}
			.lnbUL li {
				margin: 0px 0px 0px 10px;
				overflow: visible;
			}
			.jstree-anchor {
				margin-bottom:3px;
			} 
	    </style>
		<script type="text/javascript" >
		    var companyFolderId = "";
		    var deptFolderId    = "";
		    var persFolderId    = "";
			var folderId = "";
			var folderUpper = "";
			var folderType = "<c:out value='${folderType}'/>";
	    	var $element ;
	    	var useBottomFrameOnly = "${useBottomFrameOnly}";
		    var firFolderId = "";
		    var flag = "";
		    var treeData;
		    var allFileFlag = "N";
		    var parentId = "";
		    var selectFolderData = "";
		    var warningFlag = "N";
		    var subTypeC = "${subTypeC}";
		    var folderListCount = "${folderListCount}";
		    
			document.onselectstart = function() {
				return false;
			};
		    
		    $(function() { 
		    	if (folderType == "D") {
		    		openFolder('dept');	
		    	} else if (folderType == "U") {
		    		openFolder('personal');
		    	} 
		    	
		    	if(Boolean("${PortletFolderId}".trim())) {
		    		// 2021-01-13 김은실 - 포틀릿 more을 타고 온 경우: PortletFolderId 값이 있음.
		    		folderListOverloading(folderType, false, "${PortletFolderId}".trim());
		    	} else {
					folderList(folderType);
		    	}
		    	
		    	leftResize();
		        $(".webfolderListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});

				$(document).on("click", "span.list_text", function(){
		        	 $("#left li").removeClass("on");
		        	 $(this).parent().addClass("on");
		         });
			});
		    
		    function refreshView(){
		    	if (folderType == 'C' || folderType == 'D' || folderType == 'U' ) {
			    	$.jstree.destroy()
			    	folderList(folderType);
		    	}
		    }
		    
		    function folderList(obj) {
		    	folderListOverloading(obj, true, "");
		    }
			var firstLevelArray = []; 
		    function folderListOverloading(obj, isFirstLevelDisplay, PortletFolderId) {
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
							,"subTypeC" : "${subTypeC}"
						},
					dataType: "JSON",
					success : function (data) {
						// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: 해당폴더가 없음 화면
						if(data.data.length == 1){
							openWebFolderRightWarning();
							return;
						}

						var firstNode = "#" + folderId;
						
						$($element).on('loaded.jstree', function() {
							firFolderId = data.data[0]["id"];
							var test = "#" + folderId;
							var elmentTest = document.getElementById(firFolderId);
							var childE = document.getElementById(firFolderId + "_anchor");
							childE.setAttribute("class", "jstree-anchor jstree-clicked");
							elmentTest.setAttribute("aria-selected", "true");
							$('.jstree-anchor').attr('oncontextmenu', 'event_folderMenu(event);');
							$('.jstree-anchor').attr('onclick', 'HiddenFolderMenu();');

							treeData = data.data;
							addTitle();
							folderId = firFolderId;
							parentId = data.data[0].parent;
							
							// 2021-01-19 김은실 - (카이스트) [메일 접수] 웹폴더 수정 요청 사항 전달해 드립니다.
							firstLevelArray = [];
							for(var i = 0; i < data.data.length; i++){ 
								if(data.data[i].parent == folderId){
									firstLevelArray.push(data.data[i]["id"]);
								}
							}
							if( ! firstLevelArray.length > 0 ){
								openWebFolderRightWarning();
								console.log('비정상 데이터 : voc요망.');
								console.log('parentId : ' + parentId);
								console.log('folderId : ' + folderId);
								console.log('data.data : ' + data.data);
								console.log('firstLevelArray : ' + firstLevelArray);
								return;
							}
								
							// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: 회사레벨 펼치고, 회사폴더 숨기기
								$('#tree>ol>li>i').click();
								$('#tree>ol>li').css('left','-20px');
								$('#tree>ol>li>i').css('display','none');
								$('#tree>ol>li>a').css('display','none');
								switch ("${subTypeC}") {
								case "task":
									$("#tree>ol>li>ol>li>a>i").css('background-image', 'url("/images/webfolder/business_data.png")');
									break;
								case "meeting":
									$('#tree>ol>li>ol>li>a>i').css('background-image', 'url("/images/webfolder/conference_file.png")');
									break;
								case "dean":
									$('#tree>ol>li>ol>li>a>i').css('background-image', 'url("/images/webfolder/agenda_item.png")');
									break;
								}
						
						}).on('changed.jstree', function (e, data) {
							var folderId = "";
							folderId = data.selected[0];
							parentId = data.node.parent;
							getFileList(folderId);
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
						}).on("ready.jstree", function(event) {
							$(this).jstree("open_all");
							for ( var i in firstLevelArray) {
								$("#tree").jstree("toggle_node", '#' + firstLevelArray[i]);
							}
							
							if(Boolean(PortletFolderId)){
								selectFolder(PortletFolderId);
								$('#' + PortletFolderId + '_anchor').click();
							} else if(isFirstLevelDisplay){
								$('#' + firstLevelArray[0] + '_anchor').click();
							} else {
								getFileList(folderId);
							}
						});
					},
					error : function(error) {
// 						alert("<spring:message code='ezWebFolder.t134' />" + error + (ssss) );
					}
				});
				$(".lnbUL li .jstree-node").css("margin","0px 0px 0px 10px");
		    }
		    
		    // jstree의 특성상 loaded.jstree가 다른 function 뒤에 실행되므로 jstree가 필요한 상황이면 load된 후 function실행하도록 
		    function folderList2(obj) {
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
							,"subTypeC" : "${subTypeC}"
						},
					dataType: "JSON",
					success : function (data) {
						var firstNode = "#" + folderId;

						$($element).on('loaded.jstree', function() {

							$('.jstree-anchor').attr('oncontextmenu', 'event_folderMenu(event);');
							$('.jstree-anchor').attr('onclick', 'HiddenFolderMenu();');
							firFolderId = folderId;
							treeData = data.data;
							addTitle();

							// 2020-12-15 김은실 - [카이스트] 회사 폴더별 관리자 지원 기능(수정):복사 후 left
							$('#tree>ol>li>i').click();
							$('#tree>ol>li').css('left','-20px');
							$('#tree>ol>li>i').css('display','none');
							$('#tree>ol>li>a').css('display','none');
							switch ("${subTypeC}") {
							case "task":
								$("#tree>ol>li>ol>li>a>i").css('background-image', 'url("/images/webfolder/business_data.png")');
								break;
							case "meeting":
								$('#tree>ol>li>ol>li>a>i').css('background-image', 'url("/images/webfolder/conference_file.png")');
								break;
							case "dean":
								$('#tree>ol>li>ol>li>a>i').css('background-image', 'url("/images/webfolder/agenda_item.png")');
								break;
							}
							
						}).on('changed.jstree', function (e, data) {
							try {
								if(data.node.parent != undefined ){
									folderId = data.selected[0];
									parentId = data.node.parent;
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
						}).on("ready.jstree", function(event) {
							$(this).jstree("open_all");

							for ( var i in firstLevelArray) {
								$("#tree").jstree("toggle_node", '#' + firstLevelArray[i]);
							}
							
							// 삭제하거나 어떤 변화가 있을 때 자꾸 다 닫히는 게 거슬린다면.. : selectFolder(selectFolderData == ""? folderId : selectFolderData); 
							//									   + getFileList()에 selectFolderData = folderId;
							selectFolder(folderId);
						});
					},
					error : function(error) {
// 						alert("<spring:message code='ezWebFolder.t134' />" + error + (ssss) );
					}
				});
		    }
		    
		    function addTitle() {
		    	var data = this.treeData;
		    	for ( var i = 0; i < data.length ; i++  ) {
		    		var dataId = data[i]["id"] + "_anchor";
		    		var folderName = data[i]["text"];
		    		var childE = document.getElementById(dataId);
		    		if (childE != null){
						childE.setAttribute("title", folderName);
		    		}
		    	}
		    }
			
			function getFileSize(fileSize) {
				var fileSize_ = "";
				
				if (fileSize / 1024 / 1024 / 1024 > 1) {
					fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 / 1024 * 10)) / 10).toFixed(1) + "GB";
				} else if (fileSize / 1024 / 1024 > 1) {
					fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
				} else if (fileSize / 1024 > 1) {
					fileSize_ = parseInt(fileSize / 1024) + "KB";
				} else {
					fileSize_ = fileSize + "B";
				}
				
				return fileSize_;
			}
			
			var webfolder_folder_Manage = new Array();
		 	// 폴더관리
		    function folder_Manage() {
		    	webfolder_folder_Manage[1] = function() {};
	        	var OpenWin = window.open("/ezWebFolder/folderManage.do?folderType="+folderType, "", GetOpenWindowfeature(600, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
		    
		    function getFileList(folderId) {
		    	if (parentId == "#") {
		    		parentId = "root";
		    	}
		    	$.ajax({
					type: "POST",
					url: "/ezWebFolder/selectedFolderCheckPermission.do",
					data: {
						"folderId" : folderId
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.status;
						
						if (result == "ok") {
					    	// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: isDean으로 구분 추가
					    	// 2020-11-25 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: subTypeC으로 구분 수정
					    	window.parent.frames["right"].location.href = "/ezWebFolder/main.do?folderId="+folderId+"&folderType="+folderType+"&allFileFlag="+allFileFlag+"&parentId="+parentId+"&subTypeC=${subTypeC}";
					    	allFileFlag = "N";
						} else {
							alert("<spring:message code='ezWebFolder.t300'/>");
							return;
						}
						
					},
					error : function(error) {
// 						alert("에러");
						return;
					}
		    	});
		    	
		   	}
		    
		    function getSharedList() {
		    	folderType = "S";
				window.parent.frames["right"].location.href = "/ezWebFolder/webfolderSharedList.do";
			}
			
			function getSharingList() {
				folderType = "S";
				window.parent.frames["right"].location.href = "/ezWebFolder/webfolderSharingList.do";
			}
			
			function moveFavorPage() {
				setRightFrame("/ezWebFolder/favorite.do");
			}
			
			function wfConfig() {
				if (warningFlag == "N") {
					window.parent.frames["right"].location.href = "/ezWebFolder/webfolderConfig.do";
				}
			}
			
			function getTrashCanList() {
				window.parent.frames["right"].location.href = "/ezWebFolder/trashCan.do";
			}
			
			function showPanel() {
				document.getElementById("webFolderLeftPanel").style.display = "block";
			    document.getElementById("webFolderLeftPanel").style.background = "rgba(0,0,0,0.5)";
			    
			    if (useBottomFrameOnly == "NO") {
					parent.parent.frames["topFrame"].contentWindow.showProgress();
				}
			}
			
			function hiddenPanel() {
				document.getElementById("webFolderLeftPanel").style.display = "none";
				
				if (useBottomFrameOnly == "NO") {
					parent.parent.frames["topFrame"].contentWindow.hideProgress();
				}
			}
			
			function setRightFrame(url) {
				window.parent.frames["right"].location.href = url;
			}
			
			function wfAdministrator() {
				window.open("/admin/ezWebFolder/webFolderConfig.do", "", "");
			}
			
			function leftResize(){
				var webfolderListBoxOT_Height = 0;
				$.each($(".webfolderListBoxOT"), function(i,e) {
					webfolderListBoxOT_Height += e.offsetHeight;
				});
				
	        	$(".webfolderListBox").height(window.innerHeight - webfolderListBoxOT_Height);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
	        
	        function openFolder(val01) {
	        	/* 
	        	if ($("#"+val01+"UL").attr("class") == "lnbUL off") {
	        		$(".lnb H2").not("#option").attr("class", "off");
	        		$(".lnb UL").not("#option").attr("class", "lnbUL off");
	        		
	        		$("#"+val01+"H2").attr("class", "on");
	        		$("#"+val01+"UL").attr("class", "lnbUL on");
	        		$("#"+val01).attr("class", "sub_iconLNB tree_arrow_up");
	        	 */
	        		
	        		if (val01 == "company") {
	        			/* 
	        			folderList('C')
	        			 */
	        			folderListOverloading('C', false, "");
	        		} else if (val01 == "dept") {
	        			folderList('D');
	        		} else if (val01 == "personal") {
	        			folderList('U');
	        		} 
	        	/* 
	        	} else {
	        		$("#"+val01+"H2").attr("class", "off");
	        		$("#"+val01+"UL").attr("class", "lnbUL off");	        		
	        		$("#"+val01).attr("class", "");
	        	}
	        	 */
	        }
	        
			function event_folderMenu(event){
				var currentId = "#"+event.currentTarget.id;
				var id = $(currentId).closest("li").attr('id');
				folderId = id;
				console.log(currentId);
				console.log(folderId);
				
				var id = $(currentId).closest("li").attr('id');
		    	if (!event) event = window.event;
		        var EventMouseX = event.clientX;
		        var EventMouseY = event.clientY;

		        var listsizeheight = document.documentElement.clientHeight;
		        var listsizewidth = document.documentElement.clientWidth;
		        var EventDivSize = EventMouseY + 240;
		        if (listsizeheight < EventDivSize) {
		            var Div_ = EventDivSize - listsizeheight;
		            EventMouseY = EventMouseY - Div_;
		        }

		        EventDivSize = EventMouseX + 140;
		        if (listsizewidth < EventDivSize) {
		            var Div_ = EventDivSize - listsizewidth;
		            EventMouseX = EventMouseX - Div_;
		        }
		        
		        document.getElementById("folderPanel").style.display = "";
		        document.getElementById("folderMenuDiv").style.left = EventMouseX + "px";
		        document.getElementById("folderMenuDiv").style.top = EventMouseY + "px";
		        document.getElementById("folderMenuDiv").style.display = "";
		       
		    }
		    
			function HiddenFolderMenu(){
		    	document.getElementById("folderPanel").style.display = "none";
		        document.getElementById("folderMenuDiv").style.display = "none";
		    }
		    
			function allFile() {
				allFileFlag = "all";
				getFileList(folderId);
			}
			
			// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: 해당폴더가 없음 화면
			function openWebFolderRightWarning() {
				warningFlag = "Y";
				window.parent.frames["right"].location.href = "/ezWebFolder/openWebFolderRightWarning.do?subTypeC=${subTypeC}";
			}

			function appliWebFolder() {
				if (typeof window.parent.frames["right"].applicationPopUp === "function") { 
					window.parent.frames["right"].applicationPopUp("${subTypeC}");
				}
			}
			
			function fileTransactionHistory(obj) {
				window.parent.frames["right"].location.href = "/admin/ezWebFolder/webfolderAdminFileHistory.do?adminFlag=user";
			}
		</script>
	</head>
	<style>
		.jstree-span-title {display:inline-block; text-overflow:ellipsis; overflow-x:hidden; height:20px;}
	</style>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	        <%-- 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴 구분 --%>
	        <%-- 
	        <c:choose>
		    	<c:when test="${ folderType eq 'D' || folderType eq 'd' }">
		    		<div class="left_title" title="<spring:message code='ezWebFolder.kes008'/>"/><spring:message code='ezWebFolder.kes008' />
			        	<!-- <span class="sub_iconLNB tree_leftconfig" onclick="wfConfig();" title="<spring:message code="ezWebFolder.t236" />"></span> -->
			        </div>
			        <div class="webfolderListBox" style="overflow:hidden; padding-right: 0;">
					    <h2 class="off" id="deptH2">
			            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('dept')"><spring:message code='ezWebFolder.t234' /></span>
				        </h2>
				        <ul class="lnbUL off" id="deptUL">
		    				<div id ="treeDept" class="webfolderTree"></div>
					    </ul>
		    	</c:when>
		    	<c:otherwise>
		    	 --%>
		    		<div class="left_title webfolderListBoxOT" title="<spring:message code='ezWebFolder.t233'/>"/><spring:message code="${subTypeC eq 'task'? 'ezWebFolder.kes008' : subTypeC eq 'meeting'? 'ezWebFolder.kes011' : 'ezWebFolder.t233' }" />
           			<c:if test="${ subTypeC eq 'task' }">
	        			<span class="sub_iconLNB tree_leftconfig" onclick="wfConfig();" title="<spring:message code="ezWebFolder.t236" />"></span>
					</c:if>
			        </div>
			        <c:if test="${subTypeC eq 'task' || subTypeC eq 'meeting'}">
				        <div class="btn_writeBox webfolderListBoxOT" style="background:#1f8ecd; height: auto;">
				        	<p class="btn_write01" onclick="appliWebFolder()" style="min-height: 30px; height: auto;">
				        		<span class="sub_iconLNB tree_write"></span>
				        		<spring:message code="${subTypeC eq 'task'? 'ezWebFolder.ksa18' : 'ezWebFolder.ksa19'}"/>
				        	</p>
				        </div>
			        </c:if>
			        <div class="webfolderListBox" style="overflow:hidden; padding-right: 0;">
				        <h2 class="on" id="companyH2">
			            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('company')"><spring:message code="${subTypeC eq 'task'? 'ezWebFolder.kes008' : subTypeC eq 'meeting'? 'ezWebFolder.kes011' : 'ezWebFolder.t233' }" /></span>
				        </h2>
				        <ul class="lnbUL" id="companyUL">
			    			<div id="tree" class="webfolderTree" style="overflow:auto;"></div>
					    </ul>
					    <%-- 
		    	</c:otherwise>
	    	</c:choose>
	    	 --%>
	    	<%-- 2020-11-30 김은실 - (카이스트) 공유폴더 사용 X
           	<c:if test="${ subTypeC ne 'meeting' }">
			    <h2 class="off" id="shareH2">
	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('share')"><spring:message code='ezWebFolder.t266' /></span>
		        </h2>
			    <ul class="lnbUL off" id="shareUL">
                   	<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text" onclick="getSharedList();"><spring:message code='ezWebFolder.t214' /></span></li>
                   	<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text" onclick="getSharingList();"><spring:message code='ezWebFolder.t267' /></span></li>
				</ul>
			</c:if>
			 --%>
				<ul class="lnbUL" id="option" style="padding:5px;">
			<!-- 2020-11-30 김은실 - (카이스트) 공유폴더 사용 X -->
           		<c:if test="${ subTypeC eq 'task' }">
                   	<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text" onclick="moveFavorPage();"><spring:message code='ezWebFolder.t216'/></span></li>
				</c:if>
                   	<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text" onclick="getTrashCanList();"><spring:message code='ezWebFolder.t269'/></span></li>
				<c:if test="${ subTypeC eq 'task' && folderListCount > 0}">                   	
					<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text" onclick="fileTransactionHistory(this);">파일이력 관리</span></li>
         		</c:if>
                   	<%-- 2020-11-30 김은실 - (카이스트) 공유폴더 사용 X
                   	<c:if test="${ subTypeC eq 'task' }">
                   		<li><span class="sub_iconLNB tree_dot_li" style="float:left"></span><span class="list_text" onClick="folder_Manage()"><spring:message code='ezWebFolder.t268'/></span></li>
                   	</c:if>
                   	 --%>
<!--                    	웹폴더 관리자 사용자화면에서 제거  -->
<%--                    	<c:if test="${isWfAdmin == '1'}"> --%> 
<%-- 						<li><span class="sub_iconLNB tree_appr_department"></span><span class="list_text" onclick="wfAdministrator();"><spring:message code="ezWebFolder.t25" /></span></li><!-- 웹폴더 관리자 --> --%>
<%-- 					</c:if> --%>
				</ul>
			</div>	
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="folderPanel" onclick="HiddenFolderMenu();" >&nbsp;</div>
	    <div id="folderMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
		    <table cellpadding=2 cellspacing=1 border=0 style="width:130px;" class="popuplist">
			    <tr>
			        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="allFile();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/newAttach.gif" align="absmiddle" hspace="5"/>모든파일보기</span></td>
			    </tr>
		    </table>
		</div>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderLeftPanel">&nbsp;</div>
	    <div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;"></div>
	</body>
</html>
