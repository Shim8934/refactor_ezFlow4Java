<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">	    
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var cn = "${cn}";
		var mode = "${mode}";
		var type = "${type}";
		var jobCnt = "${jobCnt}";
		var companyID = "${companyID}";
		var ReturnFunction;
		var displayName1, displayName2, code, sort, useFlag;
		
		$(document).ready(function() {
			var RetValue;
			
			try {
	            RetValue = opener.titleInfo_dialogArguments[0];
	        	ReturnFunction = opener.titleInfo_dialogArguments[1];
	        } catch(e) {}
	        
	        if (RetValue[0] != "") {
		        document.getElementById("companyName").value = RetValue[0]; 
	        }
	        
	        if (mode == "Add") {
	        	$("#subtitle").text("<spring:message code='ezOrgan.csj11' />");
				$("#btn_span").text("<spring:message code = 'ezAddress.t173'/>");
	        } else if (mode == "Mod") {
	        	$("#subtitle").text("<spring:message code='ezOrgan.csj12' />");
				$("#btn_span").text("<spring:message code = 'ezAddress.t174'/>");
				getTitleInfo();
	        }
		});
		/* 저장, 수정 Button Action */
		function btn_ok() {
			if (ValidationValues()) {
				Save_title();
			}
		}
		/* 유효성 검사 Method */
		function ValidationValues() {
			var rtnVal = false;
			
			cn = document.getElementById("cn").value;
			sort = document.getElementById("sort").value;
			useFlag = document.getElementById("useFlag").value;
			displayName1 = document.getElementById("displayName1").value;
			displayName2 = document.getElementById("displayName2").value;
			
			if (cn.trim() == "" || displayName1.trim() == "" || displayName2.trim() == "") {
				alert("<spring:message code='ezOrgan.csj09' />");
			} else if (!sort.match(/^\d+$/)) {
				alert("<spring:message code='ezOrgan.csj10' />");
			} else if (displayName1.indexOf("&") != -1 || displayName1.indexOf("<") != -1 || displayName1.indexOf(">") != -1 || displayName1.indexOf(";") != -1 || displayName1.indexOf(":") != -1) {
	            alert("<spring:message code='ezOrgan.csj14' />");
			} else if (displayName2.indexOf("&") != -1 || displayName2.indexOf("<") != -1 || displayName2.indexOf(">") != -1 || displayName2.indexOf(";") != -1 || displayName2.indexOf(":") != -1) {
				alert("<spring:message code='ezOrgan.csj14' />");
			} else if (mode == "Add" && !checkTitleCnt(cn)) {
				alert("<spring:message code='ezOrgan.csj08' />");
			} else {
				rtnVal = true;
			}
			
			return rtnVal;
		}
		/* 저장, 수정 Action Method */
		function Save_title() {
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleAction.do",
            	async : false,
            	data : 
            	{
            		cn : cn,
            		type : type,
            		mode : mode,
            		sort : sort,
            		useFlag : useFlag,
            		companyID : companyID,
            		displayName1 : displayName1,
            		displayName2 : displayName2
            	},
            	success : function (result) {
            		var ReturnArray = new Array();
	            		ReturnArray[0] = result;
	            		ReturnArray[1] = mode;
	            		ReturnArray[2] = cn;
	            		
            		if (ReturnFunction != null) {
	            		ReturnFunction(ReturnArray);
            		}
            		window.close();
            	},
            	error : function(e) {
            		alert("<spring:message code='main.sp12' />");
            	}
            });
		}
		/* 수정 시, 직위정보 호출 Method */
		function getTitleInfo() {
			var xmlDom;
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleInfo.do",
            	async : false,
            	data : 
            	{
            		cn : cn,
            		type : type,
            		mode : mode,
            		companyID : companyID
            	},
            	success : function (result) {
            		xmlDom = loadXMLString(result);
            	},
            	error : function(e) {
            	}
            });
			
			if (SelectNodes(xmlDom, "DATA/CN").length > 0) {
				document.getElementById("cn").value = SelectSingleNodeValueNew(xmlDom, "DATA/CN").trim();
				document.getElementById("cn").disabled = true;
				document.getElementById("displayName1").value = SelectSingleNodeValueNew(xmlDom, "DATA/DISPLAYNAME").trim();
				document.getElementById("displayName2").value = SelectSingleNodeValueNew(xmlDom, "DATA/DISPLAYNAME2").trim();
				document.getElementById("useFlag").value = SelectSingleNodeValueNew(xmlDom, "DATA/USEFLAG").trim();
				document.getElementById("sort").value = SelectSingleNodeValueNew(xmlDom, "DATA/SORT").trim();
			}
		}
		/* 직위 중복검사 Method */
		function checkTitleCnt(cn) {
			var rtnFlag = true;
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezOrgan/jobTitleCnt.do",
            	async : false,
            	data : 
            	{
            		cn : cn,
            		type : type,
            		companyID : companyID
            	},
            	success : function (result) {
            		if (parseInt(result) > 0) {
            			rtnFlag = false;
            		}
            	},
            	error : function(e) {
            		rtnFlag = false;
            	}
            });
			return rtnFlag;
		}
	</script>
	<style type="text/css">
		.content input {width:100%;}
		select {width:100%; height:24px;}
	</style>
<title></title>
</head>
<body class="popup">
	<h1 id="subtitle"></h1>
	<div id="close"><ul><li><span onclick="window.close()"></span></li></ul></div>
	<div class="btnposition btnpositionNew" >
		<a class="imgbtn" onClick="btn_ok()"><span id="btn_span"></span></a>
	</div>
	<span style="color:red"><spring:message code='ezOrgan.t00018' /></span>
	<table class="content">
		<tr>
			<th><spring:message code='ezOrgan.t123' /></th>
			<td colspan="2"><input type="text" id="companyName" disabled="disabled"></td>
		</tr>
		<tr>
			<th><spring:message code='ezOrgan.csj03' /><span style="color:red"> *</span></th>
			<td colspan="2"><input type="text" id="cn"/></td>
		</tr>
		<tr>
			<th rowspan="2"><spring:message code='ezOrgan.csj04' /><span style="color:red"> *</span></th>
			<th><spring:message code='ezApprovalG.t1764'/></th>
			<td><input type="text" id="displayName1"/></td>
		</tr>
		<tr>
			<th><spring:message code='ezApprovalG.t1765'/></th>
			<td><input type="text" id="displayName2"/></td>
		</tr>
		<tr>
			<th><spring:message code='ezOrgan.csj05'/></th>
			<td colspan="2">
				<select id="useFlag">
					<option value="Y"><spring:message code='ezOrgan.t161'/></option>
					<option value="N"><spring:message code='ezOrgan.kyj02'/></option>
				</select>
			</td>
		</tr>
		<tr>
			<th><spring:message code='ezOrgan.csj06'/></th>
			<td colspan="2">
				<select id="sort">
					<c:forEach var="i" begin="1" end="${jobCnt}" step="1" varStatus="status">
						<option value="${status.count}">${status.count}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
	</table>
</body>
</html>