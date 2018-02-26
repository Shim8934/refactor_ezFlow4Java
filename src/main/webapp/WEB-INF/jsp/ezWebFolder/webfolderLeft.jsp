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
	    <link rel="stylesheet" href="/js/jsTree/src/themes/default/style.css" />
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
		<script type="text/javascript" >	        
		    var companyFolderId = "";
		    var deptFolderId    = "";
		    var persFolderId    = "";
		    var userId = "<c:out value='${userId}'/>";
			var userName = "<c:out value='${userName}'/>";
			var folderId = "1";
			var folderType = null;
			
		    window.onload = function () {
		    	
		    	folderList('C');
		    	
		    	folderType = 'C';
		    };
		    function folderList(obj) {
		    	var $element = null;
				if ( obj == 'C') {
					$element = '#tree';
				}else if (obj == 'D') {
					$element = '#treeDept';
				}else if (obj == 'U') {
					$element = '#treePer';
				}
// 				folderId =data.selected[0];
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
// 						var div = document.createElement('div');
// 						div.innerHTML = document.getElementById('tree').innerHTML;
// 						document.getElementsByTagName('left_webfolder').appendChild(this);
						
						
						$($element).jstree({
							'core' : {
								'data' : data.folderList.folderList,
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
								"width"       : "25",
								"margin-left" : "10"
							},
							'plugins': ["types","json_data","core","themes","ui"]
						})
						folderId = data.folderList.folderList[0].id;
// 						parent = data.folderList.folderList[0].parent;
						getFileList(folderId);
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});
				$($element).on("changed.jstree", function (e, data) {
				   folderId =data.selected[0]; 
				   console.log("The selected nodes are:" + folderId);
// 				   alert(folderId);
				   getFileList(folderId);
				});
		    }
		    
		    function goPage(idx) {
		    	switch (idx) {
		    		case 3:
		    			var url = "/ezWebFolder/test.do";
		    			window.parent.frames["right"].location.href = url;
		    			break;		    		
		    	}
		    }
		    
		    // 완정 수정해야함
		    function getCompanyList(folderType) {
		    	var folderID = null;
		    	switch(folderType) {
		    		case "1":
		    			folderID = companyFolderId;
		    			break;
		    		case "2":
		    			folderID = deptFolderId;
		    			break;
		    		case "3":
		    			folderID = persFolderId;
		    			break;
		    	}
		    	
		    	$.ajax({
					type: "POST",
					url: "/ezWebFolder/folderList.do",
					data: {
						"folderType" : folderType,
						"folderId"   : folderID
					},
					dataType: "JSON",
					async: true,
					success : function(data) {				
						var result = data.folderList;												
						console.log(result);						
				    	folderList();
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});	
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
			.leftbody ul li {
			    cursor: pointer;
 			    border-bottom: 0px ; 
/* 			    background: url(/images/kr/left/left_dot02.gif) 25px 9px no-repeat rgb(255, 255, 255); */
			    padding: 4px 7px 4px 5px;
			    margin-left : 5px;
			}
			#left ol{margin:0}
			#left ol li, #left ol.on, #left ol.off{
				cursor: pointer;
 			    border-bottom: 0px ; 
				list-style:none;
				padding: 4px 7px 4px 5px;
			    margin-left : 5px;
			    background-color:#f8f8f8;
			}
			#left ol.on, #TopBoards ol.on {display: block;}
			#left ol.off, #TopBoards ol.off {display: none;}
			#left ol li.on, #TopBoards ol li.on{
				font-weight:bold;
				color:#333333;
				
			}
			#left ol li ul{
				background-color:#f8f8f8;
				margin:0;
			}
	    </style>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
		<div id="left" style="overflow: auto">
			<div class="left_webfolder" title="<spring:message code='ezWebFolder.t10' />"></div>
			<h2>
<<<<<<< HEAD
  				<span style="display:inline-block;width:100%;" onclick="folderList('C');">회사폴더</span>
  			</h2>  
    		<ol>
	  			<li id ="company"><div id ="tree" style="width:100%;min-height:200px; font-size: 20px;"></div></li>
		    </ol>  	
		    <h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('D');">부서폴더</span>
  			</h2>  
    		<ol>
	  			<li id ="dept"><div id ="treeDept" style="width:100%; min-height:200px; font-size: 20px;"></div></li>
<!-- 		        <li><span id="organ_1" style="width: 100%; display: inline-block;" onClick="goPage(3)" >오픈솔루션팀</span></li> -->
<!-- 		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >ezEKP</span></li>		         -->
		    </ol>  
		    	
		   	<h2>
  				<span style="display:inline-block;width:100%;" onclick="folderList('U');">개인폴더</span>
  			</h2>  
    		<ol>
	  			<li id="person"><div id ="treePer" style="width:100%;min-height:200px; font-size: 20px;"></div></li>
<!-- 		        <li><span id="organ_2" style="width: 100%; display: inline-block;" onClick="treeTest()" >영화</span></li> -->
<!-- 		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="fileList()" >문서</span></li>		         -->
<!-- 		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="getFileList()" >파일</span></li>		         -->
		    </ol>  
		    
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
    		<ol>
<!-- 		        <li><span id="organ_4" style="width: 100%; display: inline-block;" onClick="" >테스트 5</span></li> -->
<!-- 		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >테스트 6</span></li>		         -->
		    </ol>  	   
		    
		    <h2>
  				<span style="display:inline-block;width:100%;">휴지통</span>
  			</h2>  
    		<ol>
<!-- 		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >테스트  7</span></li> -->
<!-- 		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >테스트  8</span></li>		         -->
		    </ol>       

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
	        initToggleList(document.getElementById("left"), "h2", "ol", "li");	        
	    </script>
	</body>
</html>
