<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>EmployeeofMonth</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
	
			var select_best_dialogArguments = new Array();
		    function btn_Select() {
		        if (CrossYN()) {
		            select_best_dialogArguments[1] = btn_Select_Complete;
		            var Select_Best = window.open("/admin/ezPersonal/selectBest.do", "SelectBest", GetOpenWindowfeature(400, 200));
		            try { Select_Best.focus(); } catch (e) {
		            }
		        }/*  else {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (width - 500) / 2;
		            var top = (heigth - 400) / 2;
		            var rtnValue = window.showModalDialog("Select_Best.aspx", "",
		                  "dialogHeight:200px;dialogwidth:400px;dialogleft:left = " + left + ";dialogtop:" + top + ", status:no;toolbar:no;location:no;scroll:no;edge:sunken, top=" + top + ",left = " + left);
		            window.location.reload(false);
		        } */
		    }
	
		    function btn_Select_Complete(){
		        window.location.reload(false);
		    }
	
		    function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
		    
		    function btnDel_click(temp) {
		        if (confirm("<spring:message code = 'ezPersonal.t00003' />")) {
		            $.ajax({
		            	type : "POST",
		            	url : "/admin/ezPersonal/setEmployeeMonth.do",
		            	async : false,
		            	data : {type : "DEL", userID : "", deptID : "", term : temp},
		            	dataType : "text",
		            	success : function (result) {
		            		if (result != "OK") {
				                alert("<spring:message code = 'ezPersonal.t302' />");
				            } else {
				                alert("<spring:message code = 'ezPersonal.t00004' />");
				                window.location.reload(false);
		            		}
		            	}
		            });
		        }
		    }
		</script>
	</head>
	<body class = "mainbody">
		<form id="form1">
		    <h1><spring:message code = 'ezPersonal.t299' /></h1>
		
		    <div id="mainmenu">
				<ul>
		            <li><span onClick="btn_Select()"><spring:message code = 'ezPersonal.t105' /></span></li>
				</ul>
		    </div>
		    <div>
		        <table class="mainlist" style="width:100%"> 
					<tr> 
						<th style="width:10%; text-align:center"><spring:message code = 'ezPersonal.t290' />/<spring:message code = 'ezPersonal.t291' /></th> 
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t304' /></th> 
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t69' /></th> 
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t7' /></th>
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t67' /></th> 
				        <th style="width:10%; text-align:center"></th> 
					</tr> 
					
					<c:forEach var="item" items="${list }">
						<tr> 
							<td style="text-align:center">${item.term}</td> 
							<td style="text-align:center">
								<span style="cursor:pointer; color:blue" onclick="OpenUserInfo('${item.cn}')">${item.displayName }</span>
					        </td> 
					        <td style="text-align:center">${item.title}</td> 
							<td style="text-align:center">${item.description}</td> 
							<td style="text-align:center">${item.company}</td>
					        <td style="text-align:center"><a class="imgbtn"><span onClick="btnDel_click('${item.term}')" ><spring:message code = 'ezPersonal.t99' /></span></a></td>
						</tr> 
					</c:forEach>
				</table> 
		    </div>   
	    </form>
	</body>
</html>