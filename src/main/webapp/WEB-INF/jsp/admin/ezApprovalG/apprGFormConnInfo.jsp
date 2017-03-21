<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1446' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			var pCompanyID = "<c:out value = '${companyID}' />";
			var xmlhttp = createXMLHttpRequest();
			
			var ReturnFunction;
	
			$(document).ready(function(){
				try {
					try {
	                    ReturnFunction = opener.FormConnInfo_dialogarguments[1];
	                } catch (e) {
	                    try {
	                        ReturnFunction = parent.FormConnInfo_dialogarguments[1];
	                    } catch (e) {
	                    }
	                }
	                
					processidx_onchange();
					processtime_onchange();
					connstringflag_onchange();
					querytype_onchange();
					keykind_onchange();
	
				} catch(e) {
					alert("window_onload : " + e.description);
				} 
			});
	
			function btnOK_onclick() {
				var rtnValue = "<conn processidx=\"" +
	                GetSelectText("processidx") +
	                "\" processtime=\"" +
	                GetSelectText("processtime") +
	                "\">\n	<connstring flag=\"" +
	                GetSelectText("connstringflag") +
	                "\">" +
	                connectionstring.value +
	                "</connstring>\n	<query qtype=\"" +
	                GetSelectText("querytype") +
	                "\">" +
	                query.value + "</query>";
	
	            if (GetSelectText("keykind") != "<spring:message code='ezApproval.t505'/>") {
	                rtnValue = rtnValue + "\n	<keys>\n		<key kind=\"" + GetSelectText("keykind") + "\"></key>\n	</keys>";
	            }
	            rtnValue = rtnValue + "\n</conn>";
	
				window.returnValue = rtnValue;	
	            ReturnFunction(rtnValue)
	            window.close();
			}
	
			function btnCancel_onclick() {
				window.returnValue = "cancel";
	            ReturnFunction("cancel")
	            window.close();
	        }
	
	        function processidx_onchange() {
	            setNodeText(processidxdesc,processidx.value);
	        }
	
	        function processtime_onchange() {
	            setNodeText(processtimedesc,processtime.value);
	        }
	
	        function connstringflag_onchange() {
	            setNodeText(connstringflagdesc,connstringflag.value);
	        }
	
	        function querytype_onchange() {
	            setNodeText(querytypedesc,querytype.value);
	        }
	
	        function keykind_onchange() {
	            setNodeText(keykinddesc,keykind.value);
	        }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code = 'ezApprovalG.t1446' /></h1>
		<table class="content">
			<tr>
		    	<th><spring:message code = 'ezApprovalG.t1448' /></th>
		    	<td>
		    		<select id="processidx" name="select" style="WIDTH:185px" onChange="return processidx_onchange()">
						<c:forEach var="item" items="${processIdxList}">
							<c:set var="item" value="${fn:split(item,';')}" />
	            			<option value="<c:out value='${item[1]}'/>" ><c:out value='${item[0]}'/></option>
	            		</c:forEach>
		      		</select>
		    	</td>
		  	</tr>
		  	<tr>
		  		<th><spring:message code = 'ezApprovalG.t598' /></th>
		    	<td id="processidxdesc"></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t1449' /></th>
		    	<td>
		    		<select id="processtime" name="select" style="WIDTH:185px" onChange="return processtime_onchange()">
						<c:forEach var="item" items="${processTimeList}">
							<c:set var="item" value="${fn:split(item,';')}" />
	            			<option value="<c:out value='${item[1]}'/>" ><c:out value='${item[0]}'/></option>
	            		</c:forEach>
		      		</select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t598' /></th>
		    	<td id="processtimedesc" ></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t1450' /></th>
		    	<td>
		    		<select id="connstringflag" name="select" style="WIDTH:185px" onChange="return connstringflag_onchange()">
						<c:forEach var="item" items="${connStringFlagList}">
							<c:set var="item" value="${fn:split(item,';')}" />
	            			<option value="<c:out value='${item[1]}'/>" ><c:out value='${item[0]}'/></option>
	            		</c:forEach>
		      		</select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t598' /></th>
		    	<td id="connstringflagdesc"></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t1451' /></th>
		    	<td>
		    		<input id="connectionstring" type="textbox" style="WIDTH:230px">
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t1452' /></th>
		    	<td>
		    		<select id="querytype" name="select" style="WIDTH:185px" onChange="return querytype_onchange()">
						<c:forEach var="item" items="${queryTypeList}">
							<c:set var="item" value="${fn:split(item,';')}" />
	            			<option value="<c:out value='${item[1]}'/>" ><c:out value='${item[0]}'/></option>
	            		</c:forEach>
		      		</select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t598' /></th>
		    	<td id="querytypedesc"></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t1453' /></th>
		    	<td height="23"><input id="query" type="textbox" style="WIDTH:230px">
		    	</td>
		  	</tr>
		  	<tr>
		    	<th>Key <spring:message code = 'ezApprovalG.t1454' /></th>
		    	<td height="23">
		    		<select id="keykind" name="select" style="WIDTH:185px" onChange="return keykind_onchange()">
						<c:forEach var="item" items="${keyKindList}">
							<c:set var="item" value="${fn:split(item,';')}" />
	            			<option value="<c:out value='${item[1]}'/>" ><c:out value='${item[0]}'/></option>
	            		</c:forEach>
		      		</select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t598' /></th>
		    	<td id="keykinddesc"></td>
		  	</tr>
		</table>
		
		<div class="btnposition">
			<input type="button" value="<spring:message code = 'ezApprovalG.t20' />" onClick="return btnOK_onclick()">
			<input type="button" value="<spring:message code = 'ezApprovalG.t119' />" onClick="return btnCancel_onclick()">
		</div>
	</body>
</html>