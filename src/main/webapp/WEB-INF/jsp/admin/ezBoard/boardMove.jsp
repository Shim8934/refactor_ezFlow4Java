<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t65" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
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
		        var BoardMoveSelect_Cross = window.open("/admin/ezBoard/boardMoveSelect.do", "boardMoveSelect", GetOpenWindowfeature(340, 656));
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
		    		data : "POST",
		    		dataType : "text",
		    		url : "/admin/ezBoard/moveBoard.do",
		    		data : { orgBoardID : OrgBoardID, newParentBoardID : SelectedBoardID, newBoardGroupID : selectedBoardGroupID },
		    		success : function(){
		    			alert("<spring:message code='ezBoard.t126'/>");
			    		parent.window.location.reload();
		    		},
		    		error : function(){
		    			alert("<spring:message code='ezBoard.t127'/>");
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
		<c:if test="${hasSubBoard == '1'}">
			<br/>
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114" /></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table>
			<br/>
			<h2><spring:message code="ezBoard.t129" /></h2>
		</c:if>
		<c:if test="${hasSubBoard != '1'}">
			<h1><spring:message code="ezBoard.t65" /></h1>
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114" /></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table>
			<br/>
			<h2><spring:message code="ezBoard.t130" /></h2>
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t131" /></th>
			    	<td><c:out value='${boardName}'/></td>
			  	</tr>
			</table>
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
			    	<th ><spring:message code="ezBoard.t133" /></th>
			    	<td ID="pSelectBoardName" width="100%" style="height:27px;padding-left:3px"></td>
			  	</tr>
			</table>
			<br/>
			<div id=MoveCheck style=display:none  class="btnposition">
			    <a class="imgbtn" name="cmdOk" ><span onClick="Move()" onkeydown="onkey_down()"><spring:message code="ezBoard.t134" /></span></a>
			</div>
		</c:if>
	</body>
</html>