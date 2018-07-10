<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabAddRelated">
		<h1 id="cabMagHeader" role='<c:out value="${node}"></c:out>'><spring:message code="ezCabinet.t125"/></h1>
		
		<div class = "addRelatedConfig" id = "addRelated">
		     <a class = "cabRadio"><input type="radio" name = "checkCabinet" ><span><spring:message code="ezCabinet.t126"/></span><br></a>
		     <a class = "cabRadio"><input type="radio" name = "checkCabinet" ><span><spring:message code="ezCabinet.t127"/></span>    </a>
		</div>
		
		
		<div class="cabMgTree" style="position: relative;">
			<div id="cabinetMgTree" style="width: 100%; height: 100%; position: absolute; z-index: 1;"></div>
			<div id="fogPanel" style="width: 100%; height: 100%; z-index: 2; background-color: transparent; position: absolute; display: none; top: 0px; left: 0px;"></div>
		</div>
		
		<div class="cabdivBttn" id="cabMgDivBttn">
			<a class="cabBttn"><span><spring:message code="ezCabinet.t79"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t15"/></span></a>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
			(function() {
				var myCabinetTree = new CabinetTree();
				initEvents();
				
				function initEvents() {
					myCabinetTree.setTreeInfo({
						treeId     : "cabinetMgTree",
						treeType   : "cabinet",
						type       : "normal",
						initialUrl : "/ezCabinet/getMyCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : null,
						dblClick   : null
					});
					
					myCabinetTree.makeTree({cabinetNode : document.getElementById("cabMagHeader").getAttribute("role")});
					
					document.onselectstart   = function() {return false;};
					
					var cabMgConfig          = document.getElementById("addRelated");
				    var listMgConfig         = cabMgConfig.children;
				    
				    listMgConfig[0].onclick  = function() {sendMailCabinet();};
				    listMgConfig[1].onclick  = function() {directCabinect();};
					
					var cabMgBttnElmt        = document.getElementById("cabMgDivBttn");
					var listMgBttns          = cabMgBttnElmt.children;
					
					listMgBttns[0].onclick   = function(e) {addRelatedCabinet();};
					listMgBttns[1].onclick   = function(e) {closeWindow();};
					
					function sendMailCabinet(){
						document.getElementById("fogPanel").style.display = "";
					}
					
					function directCabinect(){
						//* Note add function here
					}
					
					function closeWindow() {window.close();}
					
					function addRelatedCabinet() {
						//*Note add function here
					}
				}
				
			})();
		</script>
	</body>
</html>

