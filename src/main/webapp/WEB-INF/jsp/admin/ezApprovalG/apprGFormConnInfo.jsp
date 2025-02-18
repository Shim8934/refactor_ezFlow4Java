<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1446' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
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
				var rtnValue = 
					"<conn processidx=\"" + GetSelectText("processidx") + "\" processtime=\"" + GetSelectText("processtime") + "\">" + 
					"\n\t<connstring flag=\"" + GetSelectText("connstringflag") + "\">" + connectionstring.value + "</connstring>" +
					"\n\t<query qtype=\"" + GetSelectText("querytype") + "\">" + query.value + "</query>" + 
					"\n\t<servicequery>" + servicequery.value + "</servicequery>";
	
	            if (GetSelectText("keykind") != "<spring:message code='ezApproval.t505'/>") {
	                rtnValue = rtnValue + "\n\t<keys>\n\t\t<key kind=\"" + GetSelectText("keykind") + "\"></key>\n\t</keys>";
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
		<div id="close">
            <ul>
                <li><span onclick="return btnCancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content">
			<tr>
		    	<th><spring:message code = 'ezApprovalG.t1448' /></th>
		    	<td>
		    		<select id="processidx" name="select" style="WIDTH:185px" onChange="return processidx_onchange()">
						${processIdx}
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
						${processTime}
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
						${connStringFlag}
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
						${queryType}
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
		    	<th>서비스쿼리입력</th>
		    	<td height="23"><input id="servicequery" type="textbox" style="WIDTH:230px">
		    	</td>
		  	</tr>
		  	<tr>
		    	<th>Key <spring:message code = 'ezApprovalG.t1454' /></th>
		    	<td height="23">
		    		<select id="keykind" name="select" style="WIDTH:185px" onChange="return keykind_onchange()">
						${keyKind}
		      		</select>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code = 'ezApprovalG.t598' /></th>
		    	<td id="keykinddesc"></td>
		  	</tr>
		</table>
		
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="return btnOK_onclick()"><spring:message code = 'ezApprovalG.t20' /></span></a>
		</div>
	</body>
</html>