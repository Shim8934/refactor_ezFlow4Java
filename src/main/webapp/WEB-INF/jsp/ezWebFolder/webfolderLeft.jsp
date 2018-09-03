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
	    <link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
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
		    
			document.onselectstart = function() {
				return false;
			};
		    
		    $(function() { 
				folderList('C');
		    	folderType = 'C';
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
// 						upperId = data.data[0]["parent"];
						var firstNode = "#" + folderId;
						
						$($element).on('loaded.jstree', function() {
							firFolderId = data.data[0]["id"];
							var test = "#" + folderId;
							var elmentTest = document.getElementById(firFolderId);
							var childE = document.getElementById(firFolderId + "_anchor");
							childE.setAttribute("class", "jstree-anchor jstree-clicked");
							elmentTest.setAttribute("aria-selected", "true");
							treeData = data.data;
							addTitle();
							folderId = firFolderId;
							getFileList(folderId);
						}).on('changed.jstree', function (e, data) {
							var folderId = "";
							folderId = data.selected[0];
							getFileList(folderId);
						}).jstree({
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
								
								if (percent < 100) {
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
								}
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
		    	window.parent.frames["right"].location.href = "/ezWebFolder/main.do?folderId="+folderId+"&folderType="+folderType;
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
		</script>
	</head>
	<style>
		.jstree-span-title {display:inline-block; text-overflow:ellipsis; overflow-x:hidden;}
	</style>
	<body class="leftbody" style="overflow: auto; height:100%" onload="drawVolume();">
		<div id="left" style="overflow: none">
			<div class="left_webfolder" title="<spring:message code='ezWebFolder.t10' />"><span><spring:message code='ezWebFolder.t10' /></span>
			</div>
			<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('C');"><spring:message code='ezWebFolder.t233' /></span>
  			</h2>  
    		<ul >
    			<li style="padding: 0px; background: none;">
	    			<div id="tree" class="webfolderTree" ></div>
    			</li>
		    </ul>  	
		    <h2>
  				<span style="display:inline-block; width:100%;" onclick="folderList('D');"><spring:message code='ezWebFolder.t234' /></span>
  			</h2>  
    		<ul >
    			<li style="padding: 0px; background: none;">
    				<div id ="treeDept" class="webfolderTree"></div>
    			</li>
		    </ul>  
		    	
		   	<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('U');"><spring:message code='ezWebFolder.t235' /></span>
  			</h2>  
    		<ul>
	    		<li style="padding: 0px; background: none;">
	    			<div id ="treePer" class="webfolderTree" ></div>
	    		</li>
		    </ul>  
		    
		    <h2>
				<span style="display:inline-block;width:100%;" onclick="getSharedList();"><spring:message code='ezWebFolder.t266' /></span>
			</h2>
			<ul>
				<li><span style="width: 100%; display: inline-block;" onclick="getSharedList();"><spring:message code='ezWebFolder.t214' /></span></li>
				<li><span style="width: 100%; display: inline-block;" onclick="getSharingList();"><spring:message code='ezWebFolder.t267' /></span></li>
			</ul>
		    
		    <h2>
  				<span style="display:inline-block;width:100%;" onclick="moveFavorPage();"><spring:message code='ezWebFolder.t216'/></span>
  			</h2>  
    		<ul>
		    </ul>
		    <h2>
  				<span style="display:inline-block;width:100%;" onclick="getTrashCanList();"><spring:message code='ezWebFolder.t269'/></span>
  			</h2>
    		<ul>
			</ul>			
			<!-- <div style="border:1px solid #e8e8e8;margin:10px 10px 2px;background-color:#f8f8fa">
			    <div id='myProgress' style='margin-left:20px;margin-top:10px'></div>
			    <div style="width:80%">
			    	<div id='myBar'></div>
			    </div>	
			    <div style='text-align:center; margin-top:10px;margin-bottom:5px;font-weight: bold;font-family: dotum;' class="volumes"></div>
		    </div> -->
		    <div class="mail_volume">
		    	<p class="volume_num"><img src="/images/volume_num.png" /></p>
		        <p class="volume_graph" id='myProgress'><span id='myBar'></span></p>
		        <dl class="volumeDL" >
		        	<dt id="useVol"></dt>
		            <dd id="usePer"></dd>
		        </dl>
		    </div>		    
			<h3 style="border-top:0px;">
		        <span onClick="folder_Manage()" style="display:inline-block;width:100%;"><spring:message code='ezWebFolder.t268'/></span><!-- 폴더관리 -->
		    </h3>
			<h3 style="border-top:0px;margin-top:-4px">
				<span onclick="wfConfig();" style="width:100%; display:inline-block;"><spring:message code="ezWebFolder.t236" /></span><!-- 환경설정 -->
			</h3>
			<c:if test="${isWfAdmin == '1'}">
				<h3 style="border-top:0px;margin-top:-4px">
					<span  onclick="wfAdministrator();" style="width:100%; display:inline-block;" ><spring:message code="ezWebFolder.t25" /></span><!-- 웹폴더 관리자 -->
				</h3>
			</c:if>
			<!-- <div id='myProgress' style='margin-left:20px;'>
				<div id='myBar'></div>
			</div> -->
			<!-- <div style='text-align:center; margin-top:10px; margin-bottom:10px; font-weight:bold;' class="volumes"></div> -->
   		    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderLeftPanel">&nbsp;</div>
	    </div>
	    <div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;"></div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");	        
	    </script>
	</body>
</html>
