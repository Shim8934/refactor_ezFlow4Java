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
	<body class="popup cabAddRelated" style="overflow: hidden;">
		<h1 id="cabMagHeader"><spring:message code="ezCabinet.t125"/></h1>
		
		<div class="addRlWrapper">
			<c:if test="${activeFlag == '1'}">
				<div class="addRelatedConfig" id="addRelated">
					<a class="cabRadio">
						<input type="radio" name="checkCabinet" id="1"/>
						<label for="1"><span><spring:message code="ezCabinet.t126"/></span></label><br>
					</a>
					<a class="cabRadio">
						<input type="radio" name="checkCabinet" id="2" checked="checked"/>
						<label for="2"><span><spring:message code="ezCabinet.t127"/></span></label>
					</a>
				</div>
			</c:if>
			
			<div id="cabMgTreeId" class="cabMgRelTree">
				<div id="cabinetMgTree" class="mdlRelTree"></div>
				<div id="fogPanel"      class="mdlFog"    ></div>
			</div>
		</div>
		
		<div class="cabdivBttn" id="cabMgDivBttn">
			<a class="cabBttn"><span><spring:message code="ezCabinet.t79"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t15"/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
			var CabinetRlModule = function() {
				var rlWindow      = null;
				var cabinetId     = null;
				var myCabinetTree = new CabinetTree();
				var moduleType    = null;
				
				function initEvents(mdlType) {
					moduleType = mdlType;
					myCabinetTree.setTreeInfo({
						treeId     : "cabinetMgTree",
						treeType   : "cabinet",
						type       : "list",
						initialUrl : "/ezCabinet/getAllCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : null,
						dblClick   : null
					});
					
					myCabinetTree.makeTree({cabinetNode : document.getElementById("cabMagHeader").getAttribute("role")});
					
					document.onselectstart   = function(e) {return false;};
					var cabMgConfig          = document.getElementById("addRelated");
					
					if (cabMgConfig) {
						var listMgConfig        = cabMgConfig.children;
						listMgConfig[0].onclick = function(e) {autoSelect();};
						listMgConfig[1].onclick = function(e) {directSelect();};
					}
					
					var cabMgBttnElmt        = document.getElementById("cabMgDivBttn");
					var listMgBttns          = cabMgBttnElmt.children;
					
					listMgBttns[0].onclick   = function(e) {addRelatedCabinet();};
					listMgBttns[1].onclick   = function(e) {closeWindow();};
				}
				
				function autoSelect(){
					var cabinetMainDiv = document.getElementById("cabMgTreeId");
					var fogPanel = document.getElementById("fogPanel");
					fogPanel.style.display = "";
					cabinetMainDiv.style.backgroundColor = "#f1f1f1";
				}
				
				function directSelect(){
					var fogPanel = document.getElementById("fogPanel");
					var cabinetMainDiv = document.getElementById("cabMgTreeId");
					cabinetMainDiv.style.backgroundColor = "#fff";
					fogPanel.style.display = "none";
					console.log("${module}");
				}
				
				function closeWindow() {window.close();}
				
				function addRelatedCabinet() {
					var msgToGot = window.opener.document.getElementById("MsgToGot").value;
					var mailSubject = window.opener.document.getElementById("mailSubject").value;
					var messageFrame = window.opener.document.getElementById("message");
					var contentWd    = messageFrame.contentWindow || messageFrame.contentDocument;
					var normalScreen = contentWd.document.getElementById("normalScreen").innerHTML;
					var ifrmPreViewRayer = contentWd.document.getElementById("ifrmPreViewRayer");
					//console.log(contentWd.document.body.innerHTML);
					
					if(document.getElementById("1").checked){
						console.log(normalScreen);
						console.log(mailSubject);
						console.log(msgToGot);
					    
						$.ajax({
							type: "POST",
							url: "/ezCabinet/saveRelatedItem.do",
							data: {
								"title"       : mailSubject,
								"author"      : msgToGot,
								"cabinetId"   : cabinetId,
								
								"normalScreen": JSON.stringify(normalScreen)
							},
							dataType: "JSON",
							async: false,
							success : function(data) {
								var code = data.code;
								
								switch(code) {
									case 0 : afterSaveSuccessfully()            ; break;
									case 1 : alert(CabinetMessages.strParamErr) ; break;
									case 2 : alert(CabinetMessages.strError)    ; break;
									case 3 : alert(CabinetMessages.strPerm)     ; break;
									case 4 : alert(CabinetMessages.strError)    ; break;
									default: alert(CabinetMessages.strError)    ; return;
								}
							},
							error : function(error) {
								alert(CabinetMessages.strError + error);
							}
						}); 
						
						
					}else if(document.getElementById("2").checked){
						
					}
					
					function afterSaveSuccessfully() {alert(CabinetMessages.strSave); closeWindow();}
				}
				
				return {init : initEvents};
			}();
		</script>
		<script type="text/javascript">CabinetRlModule.init("<c:out value='${module}'/>");</script>
	</body>
</html>

