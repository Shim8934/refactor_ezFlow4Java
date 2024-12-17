<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t65" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />	    
	    <style>
	    .mwidth tr td:firstchild {
	    	border : 1px solid #ddd;
	    }
	    #pSelectBoardName {
	    	border : 1px solid #d2d2d2;
	    }
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
		<script type="text/javascript" language="javascript">			
			var SelectedBoardID = "";
			var SelectedBoardName = "";
			var SelectedBoardParentBoardID = "";
			var selectedBoardGroupID = "";			
			var OrgBoardID = "<c:out value='${boardID}'/>";	
			var OrgBoardGroupID = "<c:out value='${boardGroupID}'/>";
			
			var boardmoveselect_cross_dialogArguments = new Array();
			function MoveSelect(){
			    var parameter = new Array();
			    parameter[0] = OrgBoardID;
			    parameter[1] = OrgBoardGroupID;

			    //if (CrossYN()) {
		        boardmoveselect_cross_dialogArguments[0] = parameter;
		        boardmoveselect_cross_dialogArguments[1] = MoveSelect_Complete;
		        var BoardMoveSelect_Cross = window.open("/admin/ezBoard/boardMoveSelect.do", "boardMoveSelect", GetOpenWindowfeature(355, 600));
		        try { 
		        	BoardMoveSelect_Cross.focus(); 
		        }catch (e) {}
			    /* }else{
			        var url = "/admin/ezBoard/boardMoveSelect.do";
			        var feature = "status:no;dialogWidth:340px;dialogHeight:656px;help:no;scroll:no;edge:sunken";
			        feature = feature + GetShowModalPosition(340, 656);
			        var ret = window.showModalDialog(url, parameter, feature);

			        if (typeof (ret) == "undefined") return;

			        if (ret[0] == "cancel") {
			            alert("<spring:message code='ezBoard.t128'/>");
				    }
				    else {
				        SelectedBoardID = ret[0];
				        selectedBoardGroupID = ret[1];
				        pSelectBoardName.innerHTML = ret[2];
				        MoveCheck.style.display = "";
				    }
			    } */		   
			}
			
			function Move(){
	    		if (pSelectBoardName.innerText == ""){
		    		alert("<spring:message code='ezBoard.t124'/>");
		    		return;
		    	}
		    	
		    	if (OrgBoardID == selectedBoardGroupID){
		    		alert("<spring:message code='ezBoard.t125'/>");
		    		return;
		    	}
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		url : "/admin/ezBoard/moveBoard.do",
		    		data : {
		    			orgBoardID : OrgBoardID,
		    			newParentBoardID : SelectedBoardID,
		    			newBoardGroupID : selectedBoardGroupID
		    		},
		    		success : function(){
		    			alert("<spring:message code='ezBoard.t126'/>");
			    		parent.window.location.reload();
		    		},
		    		error : function(request, status, error){
		    			if (request.status == 600) { // 상위게시판을 자신의 하위게시판으로 이동하는 경우
							alert("<spring:message code='ezBoard.hsbMv01'/>");
		    			} else if (request.status == 601) { // 그룹사게시판과 일반게시판 간에 이동하는 경우
		    				alert("<spring:message code='ezBoard.hsbMv02'/>");
		    			} else {
		    				alert("<spring:message code='ezBoard.t127'/>");
		    			}
		    		}
		    	});		    	
		    }
			
			function MoveSelect_Complete(ret) {
		        if (typeof (ret) == "undefined") return;

		        if (ret[0] == "cancel") {
		            alert("<spring:message code='ezBoard.t128'/>");
		        }
		        else {
		            SelectedBoardID = ret[0];
		            selectedBoardGroupID = ret[1];
		            pSelectBoardName.innerText = ret[2];
		            MoveCheck.style.display = "";
		        }
		    }
	    </script>
	</head>
	<body class="mainbody">
	<div style="max-width:800px;">
		<c:if test="${hasSubBoard == '1'}">
			<br/>
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114" /></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table>
			<br/>
			<h2 style="font-weight: normal">▒ <spring:message code="ezBoard.t129" /></h2>
		</c:if>
		<c:if test="${hasSubBoard != '1'}">
			<h1><spring:message code="ezBoard.t65" /></h1>
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114" /></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table>
			<%-- <br/>
			<h2 style="font-weight: normal">▒ <spring:message code="ezBoard.t130" /></h2>
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t131" /></th>
			    	<td><c:out value='${boardName}'/></td>
			  	</tr>
			</table> --%>
			<br/>
			<div id="mainmenu">
				<ul>
			    	<li><span onclick="MoveSelect()"><spring:message code="ezBoard.t132" /></span></li>
			  	</ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<table border="1" cellpadding="3" cellspacing="0" bordercolor="b6b6b6" class="mwidth" style="border-collapse:collapse">
				<tr>
			    	<th style="font-weight: normal"><spring:message code="ezBoard.t133" /></th>
			    	<td id="pSelectBoardName" width="100%" style="height:27px;padding-left:3px;"></td>
			  	</tr>
			</table>
			<div id=MoveCheck style=display:none  class="btnpositionJsp">
			    <a class="imgbtn" name="cmdOk" ><span onClick="Move()" onkeydown="onkey_down()"><spring:message code="ezBoard.t134" /></span></a>
			</div>
		</c:if>
		</div>
	</body>
</html>