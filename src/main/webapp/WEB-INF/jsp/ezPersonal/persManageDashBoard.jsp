<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS" type="text/javascript">
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
			
			function Save_DashBoard() {
				var dashBoard_val = "";
				
				if (document.getElementById("ApprovDashBoardN").checked) {
					dashBoard_val = "N";
				} else {
					dashBoard_val = "Y";
				}

		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveDashBoard.do",
		    		data : {dashBoardVal  : dashBoard_val},
					success:  function(req) {
						if(req == "OK"){
							showAlert("<spring:message code='ezApprovalG.t1581'/>");
						}
					},
					error : function() {
							showAlert("<spring:message code='ezApprovalG.t1296'/>");
					}	
		    	});
			}
		</script>
	</head>
	<body>
		<form id="Form1" method="post" >
			<br />
			<span class="txt">▒ <spring:message code='ezPersonal.dashBoard02' /></span>
			<table class="content" style="width:450px;margin-top:10px">
		    	<tr>
		    		<th><spring:message code='ezPersonal.t513'/></th>
		    		<td>
				    	<c:if test="${dashBoardFlag != 'N'}">
					      <input style="margin-top:0px;" type="radio" id="ApprovDashBoardY" name="ApprovDashBoard" checked='checked'/><label for ="ApprovDashBoardY" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t937'/></label>
				      	  <input style="margin-top:0px;" type="radio" id="ApprovDashBoardN" name="ApprovDashBoard"/><label for ="ApprovDashBoardN" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t1000'/></label>
				    	</c:if>
				    	<c:if test="${dashBoardFlag == 'N'}">
					      <input style="margin-top:0px;" type="radio" id="ApprovDashBoardY" name="ApprovDashBoard"/><label for ="ApprovDashBoardY" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t937'/></label>
				      	  <input style="margin-top:0px;" type="radio" id="ApprovDashBoardN" name="ApprovDashBoard" checked='checked'/><label for ="ApprovDashBoardN" style="cursor:pointer;vertical-align:middle"><spring:message code='ezPersonal.t1000'/></label>
				    	</c:if>
				    </td>
		  		</tr>
		  	</table>
			<br />
			</div>
			<div class="btnpositionJsp" style="width:436px">
			    <a class="imgbtn" onClick="Save_DashBoard()" ><span><spring:message code='ezPersonal.t34'/></span></a>
			    <a class="imgbtn" onClick="Cancel_Click()" ><span><spring:message code='ezPersonal.t13'/></span></a>
			</div>
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		</form>
	</body>
</html>