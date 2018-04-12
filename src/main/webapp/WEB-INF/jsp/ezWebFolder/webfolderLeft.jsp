<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <link rel="stylesheet" href="/js/jsTree/dist/themes/default/style.css" />
		<script type="text/javascript" src="/js/jsTree/dist/jstree.js"></script>
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<script type="text/javascript" >
		    var companyFolderId = "";
		    var deptFolderId    = "";
		    var persFolderId    = "";
// 		    var userId = "<c:out value='${userId}'/>";
// 			var userName = "<c:out value='${userName}'/>";
			var folderId = "";
			var folderUpper = "";
			var folderType = null;
	    	var $element ;
			
		    
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
							 "folderId"   : folderId
							,"folderType" : obj
						},
					dataType: "JSON",
					success : function (data) {
						folderId = data.data[0]["id"];
// 						upperId = data.data[0]["parent"];
						var firstNode = "#" + folderId;
						
						$($element).on('changed.jstree', function (e, data) {
							var folderId = "";
							folderId = data.selected[0];
							if (folderId != undefined) {
								getFileList(folderId);
							}
						})
						.on('loaded.jstree', function() {
							var test = "#" + folderId;
							var elmentTest = document.getElementById(folderId);
							var childE = document.getElementById(folderId + "_anchor");
							
							elmentTest.setAttribute("aria-selected", "true");
							childE.setAttribute("class", "jstree-anchor jstree-clicked");
							
						})
						.jstree({
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
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});
				

		    }
		    
			function drawVolume() {
				$.ajax({
					url: "/ezWebFolder/getUserCapicity.do",
					type: "POST",
					dataType: "JSON",
					success : function(data) {
						var result      = data.userCapacity;
						var totalVolume = result["totalCapacity"] + "GB";
						var useVolume   = getFileSize(result["totalUsed"]);
						var percent     = result["usedRate"];
						var colorClass  = "myBar_green";
						var barElmt     = document.getElementById("myBar");
						var volumeInf   = document.getElementsByClassName("volumes")[0];
						
						barElmt.style.width = percent + "%";
						
						volumeInf.textContent = useVolume + " / " + totalVolume + " (" + percent + "%)";
						
						if (percent > 90) {
							barElmt.className = "myBar_red";
						}
						else if (percent > 70) {
							barElmt.className = "myBar_orange";
						}
						else if (percent > 60) {
							barElmt.className = "myBar_yellow";
						}
						else {
							barElmt.className = "myBar_green";
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});
			}
			
			function getFileSize(fileSize) {
				var fileSize_ = "";
				
				if (fileSize / 1024 / 1024 / 1024 > 1) {
					fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 / 1024 * 10)) / 10).toFixed(1) + "GB";
				}
				else if (fileSize / 1024 / 1024 > 1) {
					fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
				}
				else if (fileSize / 1024 > 1) {
					fileSize_ = parseInt(fileSize / 1024) + "KB";
				}
				else {
					fileSize_ = fileSize + "B";
				}
				
				return fileSize_;
			}
			
		 	// 폴더관리
		    function folder_Manage() {
	        	var OpenWin = window.open("/ezWebFolder/folderManage.do?folderType="+folderType, "", GetOpenWindowfeature(600, 550));
	            try { OpenWin.focus(); } catch (e) { }
	        }	
		    
		    function getFileList(folderId) {
		    	window.parent.frames["right"].location.href = "/ezWebFolder/main.do?folderId="+folderId+"&folderType="+folderType;
		   	}
		    function treeTest() {
		    	window.parent.frames["right"].location.href = "/ezWebFolder/treeTest.do";
		    }
		    function getReceivedShare() {
				window.parent.frames["right"].location.href = "/ezWebFolder/getShareListPage.do";
			}
			
			function getGivenShare() {
				window.parent.frames["right"].location.href = "/ezWebFolder/getGivenShareList.do";
			}
			
			function wfConfig() {
				window.parent.frames["right"].location.href = "/ezWebFolder/webfolderConfig.do";
			}
			
			function getTrashCanList() {
				window.parent.frames["right"].location.href = "/ezWebFolder/trashCan.do";
			}
		</script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%" onload="drawVolume();">
		<div id="left" style="overflow: none">
			<div class="left_webfolder" title="<spring:message code='ezWebFolder.t10' />"><span><spring:message code='ezWebFolder.t10' /></span>
				<img style="width:20px;height:20px;" onClick="refreshView()" class="ui-datepicker-trigger" src="/images/webfolder/reload.png" alt title>
			</div>
			<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('C');"><spring:message code='ezWebFolder.t233' /></span>
  			</h2>  
    		<ul class ="tree">
    			<div id ="tree" style="width:210px; min-height:200px; font-size: 20px; overflow-x: auto;"></div>
<!-- 	  			<li id ="company"></li> -->
		    </ul>  	
		    <h2>
  				<span style="display:inline-block; width:100%;" onclick="folderList('D');"><spring:message code='ezWebFolder.t234' /></span>
  			</h2>  
    		<ul class ="tree">
    			<div id ="treeDept" style="width: 210px; min-height:200px; font-size: 20px; overflow-x: auto;"></div>
<!-- 	  			<li id ="dept"></li> -->
		    </ul>  
		    	
		   	<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('U');"><spring:message code='ezWebFolder.t235' /></span>
  			</h2>  
    		<ul class ="tree">
    			<div id ="treePer" style="width: 210px; min-height:200px; font-size: 20px; overflow-x: auto;"></div>
<!-- 	  			<li id="person"></li> -->
		    </ul>  
		    
		    <h2>
				<span style="display:inline-block;width:100%;" onclick="getReceivedShare();"><spring:message code='ezWebFolder.t266' /></span>
			</h2>
			<ul>
				<li><span style="width: 100%; display: inline-block;" onclick="getReceivedShare();"><spring:message code='ezWebFolder.t214' /></span></li>
				<li><span style="width: 100%; display: inline-block;" onclick="getGivenShare();"   ><spring:message code='ezWebFolder.t266' /></span></span></li>
			</ul>
		    
		    <h2>
  				<span style="display:inline-block;width:100%;"><spring:message code='ezWebFolder.t216'/></span>
  			</h2>  
    		<ul>
		    </ul>
		    <h2>
  				<span style="display:inline-block;width:100%;"><spring:message code='ezWebFolder.t268'/></span>
  			</h2>  
		    <ul>
		    </ul> 

		    <h2>
  				<span style="display:inline-block;width:100%;" onclick="getTrashCanList();"><spring:message code='ezWebFolder.t269'/></span>
  			</h2>
    		<ul>
			</ul>
			<h3>
		        <span onClick="folder_Manage()" style="display:inline-block;width:100%;"><spring:message code='ezWebFolder.t268'/></span><!-- 파일관리 -->
		    </h3>
			<h3>
				<span onclick="wfConfig();" style="width:100%; display:inline-block;"><spring:message code="ezWebFolder.t236" /></span><!-- 환경설정 -->
			</h3>
			<div id='myProgress' style='margin-left:20px;'>
				<div id='myBar'></div>
			</div>
			<div style='text-align:center; margin-top:10px; margin-bottom:10px; font-weight:bold;' class="volumes"></div>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");	        
	    </script>
	</body>
</html>
