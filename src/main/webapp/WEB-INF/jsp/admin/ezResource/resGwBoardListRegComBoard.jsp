<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t30" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js" ></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pCompanyID	= "${selCompanyID}";
			var pUserID		= "${userInfo.id}";
			var pBrdID		= "${brdID}"; 
			var sAdminfg	= '${adminFg}';

			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
					return false;
				else
					return true;
			};

			window.onload = function () {
				var pReplyMail = "${rePlyMail}";
			}

			function cmdOK_onclick(){
				if( Brd_NM.value == "" ) {
					alert("<spring:message code="ezResource.t31" />");
					return;
				}

		    	var pParentClsID = pBrdID;
				var pMakerDeptID = "${userInfo.deptID}"; 
				var pMakerDeptNm = "${userInfo.deptName1}";
				var pMakerUserID = pUserID;
				var pMakerUserNm = "${userInfo.displayName1}";
				var pMakerPosition = "${userInfo.title1}";
				var pMakerCall = "";
				var strCompanyID = pCompanyID;

				var xmlPara = "";
				var xmlHttp = "";

				if (CrossYN()) {
				    xmlPara = createXmlDom();
			    	xmlHttp = createXMLHttpRequest();

			    	var objNode;
			    	createNodeInsert(xmlPara, objNode, "PARADATA");
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pParentClsID);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerDeptID);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerDeptNm);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerUserID);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerUserNm);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerPosition);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerCall);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", Brd_NM.value);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", Brd_Explain.value);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", BRD_ACCESS.value);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", strCompanyID);
			    	if (Brd_NM2.value == "") {
				        Brd_NM2.value = Brd_NM.value;
			    	}
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", Brd_NM2.value);
				} else {
			    	xmlPara = new ActiveXObject("Microsoft.XMLDOM");
			    	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");

			    	var objRootNode = xmlPara.createNode(1, "PARADATA", "");
			    	xmlPara.appendChild(objRootNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pParentClsID;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerDeptID;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerDeptNm;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerUserID;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerUserNm;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerPosition;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerCall;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = Brd_NM.value;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = Brd_Explain.value;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = BRD_ACCESS.value;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = strCompanyID;
			    	objRootNode.appendChild(objNode);

			    	if (Brd_NM2.value == "") {
				        Brd_NM2.value = Brd_NM.value;
			    	}
			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = Brd_NM2.value;
			    	objRootNode.appendChild(objNode);
				}

				xmlHttp.open("Post", "/admin/ezResource/callBrdMod.do", false);
				xmlHttp.send(xmlPara)

				if (xmlHttp.status != 200){
					alert("1. <spring:message code="ezResource.t42" />");
					return;
				}

				var rtnText = xmlHttp.responseText
alert("rtnText:"+rtnText);
				if (rtnText == "" || rtnText == "False"){
					alert("2. <spring:message code="ezResource.t42" />");
					return;
				}else{
			    	alert("<spring:message code="ezResource.t43" />");

			    /* 
		         일반설정에서 저장 후 gwboard_list_managelist_left를 호출할 때 flag값이 SELECT_NO일 경우 Call_BrdMod.aspx에서 좌측 트리뷰 선택 값을 삭제하는데
		         그럴 경우 아무 액션을 하지 않고 바로 좌측 메뉴의 "분류이동"을 클릭 하게 되면 선택한 자원의 값이 없기 때문에 빨간창 오류가 발생함.
		         오류가 난 상태에서 좌측 "일반설정"을 다시 클릭해도 선택 값이 없어서 빨간창 오류 발생.
		        */
			    	window.parent.board_menu.location.href = "/admin/ezResource/gwBoardListManagelistLeft.do?flag=SELECT_YES"; //flag=SELECT_NO -> SELECT_YES
				}
			}

			function UpdateMenuNode(){
		    	var objSelected = "";
		    	if (CrossYN()) {
			        objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex();
		    	} else {
			        objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex;
		    	}

				objSelected.value =  Brd_NM.value;
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezResource.t22" /></h1>
		<table class="content">
  			<tr>
    			<th><spring:message code="ezResource.t44" /></th>
    			<td>${getBrdInfo.brdNm}<input type=hidden id="UPPER_NM" name="UPPER_NM" value="${getBrdInfo.brdNm}"></td>
  			</tr>
		</table>
		<br>
		<table class="content">
  			<tr>
    			<th><spring:message code="ezResource.t45" /></th>
    			<td width="100%"><input type="text"  id="BRD_ID" name="BRD_ID" value="${brdID}" style="width:99%" readonly></td>
  			</tr>
  			<tr>
    			<th><spring:message code="ezResource.t46" /></th>
    			<td style="padding:0">
		 			<table style="width:100%">
						<tr class="primary">
							<th>${langPrimary}</th>
							<td><input type="text"  id="Brd_NM" name="Brd_NM" value="${getBrdInfo.brdNm}" style="width:99%"></td>
						</tr>
						<tr class="secondary">
							<th>${langSecondary}</th>
							<td><input type="text"  id="Brd_NM2" name="Brd_NM2" value="${getBrdInfo.brdNm2}" style="width:99%"></td>
						</tr>
					</table>
    			</td>
  			</tr>
  			<tr>
    			<th><spring:message code="ezResource.t47" /></th>
    			<td><textarea id="Brd_Explain" style="font-size:9pt ; width:98%" rows="3">${getBrdInfo.brdExplain}</textarea></td>
  			</tr>
  			<tr style="display:none">  
    			<th><spring:message code="ezResource.t48" /></th>
    			<td>
    				<c:choose>
    					<c:when test="${getBrdInfo.brdGb eq 4}">
    						<input type="radio" id="BRD_GB" name="BRD_GB" value="4" checked> <spring:message code="ezResource.t49" />
    					</c:when>
    					<c:otherwise>
    						<input type="radio" id="BRD_GB" name="BRD_GB" value="4"> <spring:message code="ezResource.t49" />
    					</c:otherwise>
    				</c:choose>
    			</td>
  			</tr>
  			<tr style="display:none">
    			<th><spring:message code="ezResource.t50" /></th>
				<td>
      					<c:choose>
							<c:when test="${getBrdInfo.brdPostTerm eq 0}">
								<input type="radio" id="term" name="term" onClick="BRD_POSTTERM.value='';" value="0" checked>
    							<spring:message code="ezResource.t51" />
      							<input type="radio" id="Radio1" name="term" onClick="BRD_POSTTERM.value='365';" value="1" checked>
      							<input type="text"  id="BRD_POSTTERM" value="${getBrdInfo.brdPostTerm}" style="font-size:9pt ; width:30px">
      							<spring:message code="ezResource.t52" />
							</c:when>
							<c:otherwise>
								<input type="radio" id="term" name="term" onClick="BRD_POSTTERM.value='';" value="0">
    							<spring:message code="ezResource.t51" />
      							<input type="radio" id="Radio1" name="term" onClick="BRD_POSTTERM.value='365';" value="1">
      							<input type="text"  id="BRD_POSTTERM"  value="" style="font-size:9pt ; width:30px">
      							<spring:message code="ezResource.t52" />
							</c:otherwise>      					
      					</c:choose>
				</td>
  			</tr>
  			<tr style="display:none">
    			<th style="vertical-align:top"><spring:message code="ezResource.t53" /></th>
    			<td><textarea id="BRD_ACCESS" style="font-size:9pt ; width:100%" rows="3"> ${getBrdInfo.brdAccess}</textarea></td>
  			</tr>
		</table>
		<div class="btnposition">
    		<a class="imgbtn"><span onclick="cmdOK_onclick()" ><spring:message code="ezResource.t54" /></span></a>
		</div>
		<form name="brds">
	  		<input type="hidden" id="proc" name="proc" value="MOD">
		</form>
	</body>
</html>