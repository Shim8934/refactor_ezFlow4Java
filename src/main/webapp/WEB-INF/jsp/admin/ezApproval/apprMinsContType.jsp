<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t742'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/MinsContType_Cross.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var i, pXML;
	        var xmlhttp = createXMLHttpRequest();
	        var Arr_ContType1 = new Array();
	        var Arr_ContType2 = new Array();
	        var P_companyID
	        var count, StateCount, chkVal;
	        var listview = new ListView();
	        var listview2 = new ListView();
	
	        var text1 = "<spring:message code='ezApproval.hyj1'/>";
	        var text2 = "<spring:message code='ezApproval.t235'/>";
	        var pparsingXML = "";
	
	        window.onload = function () {
	            try {
	                dialogArguments = opener.minsconttype_dialogArguments[0];
	            } catch (e) { }
	
	            P_companyID = dialogArguments["P_companyID"];
	            InitlvDocTypeList();
	            InitlvContTypeList();
	
	        }
	
	        function lvDocTypeList_onSel_Changed() {
	        }
	
	        function lvDocTypeList_onSel_Click() {
	        }
	
	        function lvDocTypeList_onSel_DBclick() {
	        }
	
	        function lvDocTypeList_onclick() {
	        }
	
	        function lvContDocList_onSel_Changed() {
	        }
	
	        function lvContDocList_onSel_Click() {
	        }
	
	        function lvContDocList_onSel_DBclick() {
	        }
	
	        function lvContDocList_onclick() {
	        }
	
	        function DocStateReg_onclick() {
	            if (DocStateName.value != "")
	                DocStateReg();
	            else
	                alert("<spring:message code='ezApproval.t743'/>");
	        }
	
	        function DocTypeDel_onclick() {
	            DocTypeDel();
	        }
	
	        function DocTypeIns_onclick() {
	            DocTypeIns();
	        }
	
	        function RowDel_onclick() {
	            RowDel();
	        }
	
	        function save_onclick() {
	            ContSave();
	        }
	
	        function close_onclick() {
	            window.close();
	        }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApproval.t742'/></h1>
	    <table>
	        <tr>
	            <td style="vertical-align: top">
	                <div class="listview">
	                    <div id="lvDocTypeList" style="BORDER: 0; HEIGHT: 270px; WIDTH: 220px; overflow-x: hidden; overflow-y: auto"></div>
	                </div>
	            </td>
	            <td style="width: 30px; text-align: center">
	                <img src="/images/arr_right.gif" style="cursor: pointer" width="16" height="16" id="formIns" onclick="DocTypeIns_onclick()"><br>
	                <img src="/images/arr_left.gif" style="cursor: pointer" width="16" height="16" id="formDel" onclick="DocTypeDel_onclick()">
	            </td>
	            <td style="vertical-align: top">
	                <div class="listview">
	                    <div id="lvContDocList" style="BORDER: 0; HEIGHT: 270px; WIDTH: 310px; overflow-x: hidden; overflow-y: auto"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition">
	        <a class="imgbtn" onclick="save_onclick()"><span><spring:message code='ezApproval.t66'/></span></a>
	        <a class="imgbtn" onclick="close_onclick()"><span><spring:message code='ezApproval.t70'/></span></a>
	    </div>
	</body>
</html>