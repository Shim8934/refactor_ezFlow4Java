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
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<script type="text/javascript" src="/js/jsTree/dist/jstree.js"></script>
		<script type="text/javascript" >
		    var companyFolderId = "";
		    var deptFolderId    = "";
		    var persFolderId    = "";
// 		    var userId = "<c:out value='${userId}'/>";
// 			var userName = "<c:out value='${userName}'/>";
			var folderId = "1";
			var folderType = null;
	    	var $element ;
			
		    
		    $(function() { 
				folderList('C');
		    	folderType = 'C';
		    	
				});		
		    
		    function folderList(obj) {
// 		    	folderId = "";
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
						$($element).jstree({
							
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
						folderId = data.data[0].id;
						$($element).jstree('refresh');
// 				   		$($element).jstree("selected", folderId);
						getFileList(folderId);
				   		
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});
				$($element).on('changed.jstree', function (e, data) {
					var folderId = "";
					folderId = data.selected[0]; 
					if (folderId == undefined) {
// 						console.log("The selected nodes are:" + folderId);
					}else {
						getFileList(folderId);
					}
				});
		    }
		    
		 // 폴더관리
		    function folder_Manage() {
	        	var OpenWin = window.open("/ezWebFolder/folderManage.do", "", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }	
		    
		    function getFileList(folderId) {
		    	// + 버튼 누르면 오른쪽 화면 뜨고 오른쪽 화면에서 ajax로 띄움
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
	    </script>
	    <style>
		    .jstree-default a { 
				white-space:normal ; height: auto; 
			}
			.jstree-anchor {
			    height: auto !important;
			}
			.jstree-default li > ins { 
			    vertical-align:top; 
			}
			.jstree-leaf {
			    height: auto;
			}
			.jstree-leaf a{
			    height: auto !important;
			}
	    </style>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
		<div id="left" style="overflow: none">
			<div class="left_webfolder" title="<spring:message code='ezWebFolder.t10' />"><span>웹폴더</span></div>
			<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('C');">회사폴더</span>
  			</h2>  
    		<ul>
    			<div id ="tree" style="width:100%;min-height:200px; font-size: 20px;"></div>
<!-- 	  			<li id ="company"></li> -->
		    </ul>  	
		    <h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('D');">부서폴더</span>
  			</h2>  
    		<ul>
    			<div id ="treeDept" style="width:100%; min-height:200px; font-size: 20px;"></div>
<!-- 	  			<li id ="dept"></li> -->
		    </ul>  
		    	
		   	<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('U');">개인폴더</span>
  			</h2>  
    		<ul>
    			<div id ="treePer" style="width:100%;min-height:200px; font-size: 20px;"></div>
<!-- 	  			<li id="person"></li> -->
		    </ul>  
		    
		    <h2>
				<span style="display:inline-block;width:100%;" onclick="getReceivedShare();">공유폴더</span>
			</h2>
			<ul>
				<li><span id="organ"     style="width: 100%; display: inline-block;" onclick="getReceivedShare();">공유받은 폴더</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onclick="getGivenShare();"   >공유한 폴더</span></li>
			</ul>
		    
		    <h2>
  				<span style="display:inline-block;width:100%;">츨겨찾기</span>
  			</h2>  
    		<ul>
		    </ul>  	   
<!-- 		    <h2> -->
<!--   				<span style="display:inline-block;width:100%;">폴더관리</span> -->
<!--   			</h2>   -->
<!-- 		    <ul> -->
<!-- 		    </ul>  -->
		    <h2>
  				<span style="display:inline-block;width:100%;">휴지통</span>
  			</h2>  
    		<ul>
		    </ul>   
		        

<!-- 			<h3> -->
<!-- 		        <span onclick="boardConfig()" style="width:100%; display:inline-block;">휴지통</span> -->
<!-- 		    </h3> -->
			<h3>
		        <span onClick="folder_Manage()" style="display:inline-block;width:100%;">폴더관리</span>
		    </h3>
			<h3>
		        <span onclick="boardConfig()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.t0005" /></span>
		    </h3>
		    <c:if test="${applyFlag == 'OK'}">
		        <h3 style="border-top:0px">
		            <span onclick="Apprboard()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.t999001" /></span>
		        </h3>
		    </c:if>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");	        
	    </script>
	</body>
</html>
