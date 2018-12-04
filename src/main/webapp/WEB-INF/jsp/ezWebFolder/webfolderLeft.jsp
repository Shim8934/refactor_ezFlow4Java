<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">	        
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/ezWebFolder/jsTree/dist/themes/default/style.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/jsTree/dist/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	#mCSB_1_container {
				margin-right: 0px;
			}
	    </style>
		<script type="text/javascript" >
		    var companyFolderId = "";
		    var deptFolderId    = "";
		    var persFolderId    = "";
			var folderId = "";
			var folderUpper = "";
			var folderType = null;
	    	var $element ;
	    	var useBottomFrameOnly = "${useBottomFrameOnly}";
		    var firFolderId = "";
		    var flag = "";
		    var treeData;
		    var allFileFlag = "N";
		    var parentId = "";
		    
			document.onselectstart = function() {
				return false;
			};
		    
		    $(function() { 
				folderList('C');
		    	folderType = 'C';
		    	
		    	leftResize();
		        $(".webfolderListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});
			});
		    
		    function refreshView(){
		    	$.jstree.destroy()
		    	folderList(folderType);
		    }
		    
		    function folderList(obj) {
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
							getFileList(folderId);
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
		    		var folderName = data[i]["folderName1"];
		    		var childE = document.getElementById(dataId);
		    		if (childE != null){
// 		    			dataId = data[i]["id"];
// 			    		folderName = data[i]["folderName1"];
// 			    		childE = document.getElementById(dataId);
						childE.setAttribute("title", folderName);
		    		}
		    	}
		    }
			function drawVolume() {
				$.ajax({
					url: "/ezWebFolder/getUserCapicity.do",
					type: "POST",
					dataType: "JSON",
					async : true,
					success : function(data) {
						var code = data.code;
						switch(code) {
							case 0: 
								var result      = data.userCapacity;
								var totalVolume = result["totalCapacity"] + "GB";
								var useVolume   = getFileSize(result["totalUsed"]);
								var percent     = result["usedRate"];
								var colorClass  = "myBar_green";
								var barElmt     = document.getElementById("myBar");
								var volumeInf   = document.getElementsByClassName("volumes")[0];

								$("#myBar").css({
									"width" : percent + "%"
								});

		                 	    $("#usePer").text(percent+"%");
			                 	   
			                 	   //용량 체크(색깔로)
		                 	    if (percent >= 80) {
		                 	   		colorClass = "myBar_red";
		                 	       	//$(".volumeDL dd").css("color", "#ff4040");
		                 	    } else if (percent >= 70) {
							   		colorClass = "myBar_yellow";
							   		//$(".volumeDL dd").css("color", "#ff9c00");
		                 	    } else {
		                 		  	colorClass = "myBar_green";
		                 		  	//$(".volumeDL dd").css("color", "#0470e4");
		                 	    }                  		   
			                 	            
			                 	$("#myBar").addClass(colorClass);
								
								/* if (percent < 100) {
									barElmt.style.width = percent + "%";
								} else {
									barElmt.style.width = "100%";
								}
								$("#useVol").html(useVolume + "<span>/ " + totalVolume + "</span>");
								$("#usePer").text(percent+"%");
														
								if (percent >= 80) {
									barElmt.className = "myBar_red";
									$(".volumeDL dd").css("color", "#ff4040");
								} else if (percent >= 70) {
									barElmt.className = "myBar_yellow";
									$(".volumeDL dd").css("color", "#ff9c00");
								} else {
									barElmt.className = "myBar_green";
									$(".volumeDL dd").css("color", "#0470e4");
								} */
						}
					},
					error : function(error) {
// 						alert("<spring:message code='ezWebFolder.t134' />" + error + (tttt));
					}
				});
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
		    	webfolder_folder_Manage[1] = drawVolume;
	        	var OpenWin = window.open("/ezWebFolder/folderManage.do?folderType="+folderType, "", GetOpenWindowfeature(600, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
		    
		    function getFileList(folderId) {
		    	if (parentId == "#") {
		    		parentId = "root";
		    	}
		    	window.parent.frames["right"].location.href = "/ezWebFolder/main.do?folderId="+folderId+"&folderType="+folderType+"&allFileFlag="+allFileFlag+"&parentId="+parentId;
		    	allFileFlag = "N";
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
				window.parent.frames["right"].location.href = "/ezWebFolder/webfolderConfig.do";
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
	        	$(".webfolderListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
	        
	        function openFolder(val01) {
	        	if ($("#"+val01+"UL").attr("class") == "lnbUL off") {
	        		$(".lnb H2").not("#option").attr("class", "off");
	        		$(".lnb UL").not("#option").attr("class", "lnbUL off");
	        		
	        		$("#"+val01+"H2").attr("class", "on");
	        		$("#"+val01+"UL").attr("class", "lnbUL on");
	        		$("#"+val01).attr("class", "sub_iconLNB tree_arrow_up");
	        		
	        		if (val01 == "company") {
	        			folderList('C')
	        		} else if (val01 == "dept") {
	        			folderList('D');
	        		} else if (val01 == "personal") {
	        			folderList('U');
	        		} 
	        	} else {
	        		$("#"+val01+"H2").attr("class", "off");
	        		$("#"+val01+"UL").attr("class", "lnbUL off");	        		
	        		$("#"+val01).attr("class", "");
	        	}
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
		</script>
	</head>
	<style>
		.jstree-span-title {display:inline-block; text-overflow:ellipsis; overflow-x:hidden; margin-left:3px}
	</style>
	<body class="newLeft" onload="drawVolume();">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezWebFolder.t10' />"><spring:message code='ezWebFolder.t10' />
	        	<span class="sub_iconLNB tree_leftconfig" onclick="wfConfig();" title="<spring:message code="ezWebFolder.t236" />"></span>
	        </div>
	        <!--<div class="btn_writeBox">
	        	<p class="btn_write01"><span class="sub_iconLNB tree_write"></span>게시글 등록</p>
	        </div>-->
	        <div class="webfolderListBox" style="overflow:hidden; padding-right: 0;">
		        <h2 class="on" id="companyH2">
	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('company')"><spring:message code='ezWebFolder.t233' /></span>
		        </h2>
		        <ul class="lnbUL" id="companyUL">
	    			<div id="tree" class="webfolderTree" ></div>
			    </ul>
			    <h2 class="off" id="deptH2">
	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('dept')"><spring:message code='ezWebFolder.t234' /></span>
		        </h2>
		        <ul class="lnbUL off" id="deptUL">
    				<div id ="treeDept" class="webfolderTree"></div>
			    </ul>
			    <h2 class="off" id="personalH2">
	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('personal')"><spring:message code='ezWebFolder.t235' /></span>
		        </h2>
		        <ul class="lnbUL off" id="personalUL">
    				<div id ="treePer" class="webfolderTree" ></div>
			    </ul>
			    <h2 class="off" id="shareH2">
	            	<span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="openFolder('share')"><spring:message code='ezWebFolder.t266' /></span>
		        </h2>
			    <ul class="lnbUL off" id="shareUL">
                   	<li><span class="sub_iconLNB tree_appr"></span><span class="list_text" onclick="getSharedList();"><spring:message code='ezWebFolder.t214' /></span></li>
                   	<li><span class="sub_iconLNB tree_appr_ing"></span><span class="list_text" onclick="getSharingList();"><spring:message code='ezWebFolder.t267' /></span></li>
				</ul>
				<ul class="lnbUL" id="option">
                   	<li><span class="sub_iconLNB tree_board_star"></span><span class="list_text" onclick="moveFavorPage();"><spring:message code='ezWebFolder.t216'/></span></li>
                   	<li><span class="sub_iconLNB tree_delete"></span><span class="list_text" onclick="getTrashCanList();"><spring:message code='ezWebFolder.t269'/></span></li>
                   	<li><span class="sub_iconLNB tree_manage" style="float:left"></span><span class="list_text" onClick="folder_Manage()"><spring:message code='ezWebFolder.t268'/></span></li>
                   	<c:if test="${isWfAdmin == '1'}">
						<li><span class="sub_iconLNB tree_appr_department"></span><span class="list_text" onclick="wfAdministrator();"><spring:message code="ezWebFolder.t25" /></span></li><!-- 웹폴더 관리자 -->
					</c:if>
				</ul>
			</div>	
			<div class="mail_space">
	        	<span class="mail_spaceText"><spring:message code="ezWebFolder.t148" />&nbsp;<span class="userPer" id="usePer"></span></span><span  id="myBar" class="mailBar"></span>
	        </div>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="folderPanel" onclick="HiddenFolderMenu();" >&nbsp;</div>
	    <div id="folderMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
		    <table cellpadding=2 cellspacing=1 border=0 style="width:130px;" class="popuplist">
			    <tr>
			        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="allFile();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-msg-read.gif" align="absmiddle" hspace="5"/>모든파일보기</span></td>
			    </tr>
		    </table>
		</div>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderLeftPanel">&nbsp;</div>
	    <div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;"></div>
	</body>
</html>
