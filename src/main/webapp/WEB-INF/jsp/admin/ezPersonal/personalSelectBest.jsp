<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t299' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var ReturnFunction;
	
			var date = new Date();
			
		    $(document).ready(function () {
		        try {
		            ReturnFunction = parent.select_best_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.select_best_dialogArguments[1];
		            } catch (e) {
		            }
		        }
		        document.getElementById("Sel_Month").value = (date.getMonth() + 1).toString();
		    });
	
		    var pid = "";
		    var pDeptID = "";
		    var selectperson_cross_dialogArguments = new Array();
		    function btnAdd_click() {
		        if (CrossYN()) {
		            selectperson_cross_dialogArguments[1] = btnAdd_click_Complete;
		            var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(660, 535));
		            try { SelectPerson_cross.focus(); } catch (e) {
		            }
		        }
		        else {
		            var rtnValue = window.showModalDialog("/ezPersonal/selectPerson.do?type=EMP", "",
		                "dialogHeight:535px;dialogwidth:660px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken");
	
		            if (typeof (rtnValue) != "undefined") {
		                pid = rtnValue.split(":")[0];
		                pDeptID = rtnValue.split(":")[4];
		                document.getElementById("td_deptName").innerText = rtnValue.split(":")[2];
		                document.getElementById("td_Name").innerText = rtnValue.split(":")[1] + " " + rtnValue.split(":")[3];
		            }
		        }
		    }
	
		    function btnAdd_click_Complete(rtv) {
		        if (typeof (rtv) != "undefined") {
		            pid = rtv.split(":")[0];
		            pDeptID = rtv.split(":")[4];
		            if (CrossYN()) {
		                document.getElementById("td_deptName").textContent = rtv.split(":")[2];
		                document.getElementById("td_Name").textContent = rtv.split(":")[1] + " " + rtv.split(":")[3];
		            }
		            else {
		                document.getElementById("td_deptName").innerText = rtv.split(":")[2];
		                document.getElementById("td_Name").innerText = rtv.split(":")[1] + " " + rtv.split(":")[3];
		            }
		        }
		    }
		    
		    var xmlhttp = createXMLHttpRequest();
		    function btnSave_click() {
		        if (pid == "") {
		            alert("<spring:message code = 'ezPersonal.t00007' />");
		            return;
		        }
		        
		        $.ajax({
	            	type : "POST",
	            	url : "/admin/ezPersonal/setEmployeeMonth.do",
	            	async : false,
	            	data : {type : "INS", userID : pid, deptID : pDeptID, term : date.getFullYear().toString() + "-" + document.getElementById("Sel_Month").value},
	            	dataType : "text",
	            	success : function (result) {
	            		if (result != "OK") {
			                alert("<spring:message code = 'ezPersonal.t00005' />");
			            } else {
			            	alert("<spring:message code = 'ezPersonal.t191' />");
			            	
				            if (ReturnFunction != null) {
				                ReturnFunction();
				            }
				            window.close();
	            		}
	            	}
	            });
		    }

		    function btnCancel_click() {
		        pid = "";
		        document.getElementById("td_deptName").innerText = "";
		        document.getElementById("td_Name").innerText = "";
		        doLayerPopup("hide")
		    }
		</script>
	</head>
	<body class = "popup">
		<h1><spring:message code = 'ezPersonal.t299' /></h1>
	    <div>
	        <table class="content">
	             <tr>
	                <th style="width:100px; text-align:center"><spring:message code = 'ezPersonal.t275' /></th>
	                <td style="width:150px; text-align:center">
	                    <c:out value = '${fn:substring(date, 0, 4) }' /> <spring:message code = 'ezPersonal.t290' />&nbsp; 
	                    <select id="Sel_Month">
	                        <option value="1">1 </option>
	                        <option value="2">2 </option>
	                        <option value="3">3 </option>
	                        <option value="4">4 </option>
	                        <option value="5">5 </option>
	                        <option value="6">6 </option>
	                        <option value="7">7 </option>
	                        <option value="8">8 </option>
	                        <option value="9">9 </option>
	                        <option value="10">10 </option>
	                        <option value="11">11 </option>
	                        <option value="12">12 </option>
	                    </select>&nbsp;<spring:message code = 'ezPersonal.t291' />
	                </td>
	                  <td rowspan="3" style="width:100px; text-align:center">
	                     <div class="btnposition">
	                        <a href="#" class="imgbtn"><span onclick="btnAdd_click();"><spring:message code = 'ezPersonal.t00006' /></span></a>                     
	                    </div>
	                </td>
	            </tr>        
	            <tr>
	                <th style="width:100px; text-align:center"><spring:message code = 'ezPersonal.t305' /></th>
	                <td id="td_deptName" style="width:150px; text-align:center">                    
	                </td>               
	            </tr>         
	            <tr>
	                <th style="width:100px; text-align:center"><spring:message code = 'ezPersonal.t304' /></th>
	                <td id="td_Name" style="width:150px; text-align:center">
	                </td>
	            </tr>                      
	        </table>
	    </div>
	    <div class="btnposition">
	        <a href="#" class="imgbtn"><span onclick="btnSave_click();"><spring:message code = 'ezPersonal.t34' /></span></a>
	        <a href="#" class="imgbtn"><span onclick="return window.close();"><spring:message code = 'ezPersonal.t13' /></span></a>
	    </div>
	</body>
</html>