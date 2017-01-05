<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
	<head>
	    <title><spring:message code='ezApproval.t504'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        var pCompanyID = "${companyID}";
	        var ret = "cancel";
	        var xmlhttp = createXMLHttpRequest();
	
	        var ReturnFunction;
	        window.onload = function () {
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
	
	            } catch (e) {
	                alert("window_onload : " + e.description);
	            }
	        }
	
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
	
	            ReturnFunction(rtnValue)
	            window.close();
	        }
	
	        function btnCancel_onclick() {
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
	    <h1><spring:message code='ezApproval.t504'/></h1>
	
	    <table class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t506'/></th>
	            <td>
	                <select id="processidx" name="select" style="WIDTH: 185px" onchange="return processidx_onchange()">
	                    ${processIdx}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t507'/></th>
	            <td id="processidxdesc"></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t508'/></th>
	            <td>
	                <select id="processtime" name="select" style="WIDTH: 185px" onchange="return processtime_onchange()">
	                    ${processTime}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t507'/></th>
	            <td id="processtimedesc"></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t509'/></th>
	            <td>
	                <select id="connstringflag" name="select" style="WIDTH: 185px" onchange="return connstringflag_onchange()">
	                    ${connStringFlag}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t507'/></th>
	            <td id="connstringflagdesc"></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t510'/></th>
	            <td>
	                <input id="connectionstring" type="textbox" style="WIDTH: 230px">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t511'/></th>
	            <td>
	                <select id="querytype" name="select" style="WIDTH: 185px" onchange="return querytype_onchange()">
	                    ${queryType}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t507'/></th>
	            <td id="querytypedesc"></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t512'/></th>
	            <td>
	                <input id="query" type="textbox" style="WIDTH: 230px">
	            </td>
	        </tr>
	        <tr>
	            <th>Key <spring:message code='ezApproval.t513'/></th>
	            <td>
	                <select id="keykind" name="select" style="WIDTH: 185px" onchange="return keykind_onchange()">
	                    ${keyKind}
	                </select>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t507'/></th>
	            <td id="keykinddesc"></td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return btnOK_onclick()"><spring:message code='ezApproval.t84'/></span></a>
	        <a class="imgbtn"><span onclick="return btnCancel_onclick()"><spring:message code='ezApproval.t85'/></span></a>
	    </div>
	</body>
</html>