<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezPMS.t171' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">
var listProjectStatus = '<c:out value="${setting.listProjectStatus}"/>';
var defaultStatus = '<c:out value="${setting.listProjectStatus}"/>';
var progressColor = '<c:out value="${setting.progressColor}"/>';
var completeColor = '<c:out value="${setting.completeColor}"/>';
var overdueColor = '<c:out value="${setting.overdueColor}"/>';
var holdColor = '<c:out value="${setting.holdColor}"/>';
var listNumber = '<c:out value="${setting.listNumber}"/>';
var viewType = '<c:out value="${setting.viewType}"/>';
var projectSort = '<c:out value="${setting.projectSort}"/>';
var currentColor = "";
var statusName = "";

$(function() {
	$("#1tab0").addClass("tabon");
	$("#listcount option[value='" + listNumber + "']").attr("selected", true);
	$("#defaultStatus option[value='" + listProjectStatus + "']").attr("selected", true);
	
	// IE에서는 $("#defaultStatus").val() 방식으로 하면 에러남
	$("#defaultStatus").change(function() {
		defaultStatus = $("#defaultStatus").val();
	})
});

function save_info() {
	progressColor = $("#progressColor").text();
	completeColor = $("#completeColor").text();
	overdueColor = $("#overdueColor").text();
	holdColor = $("#holdColor").text();
	listCount = $("#listcount").val();
	
	var data = {
		projectSort : projectSort,
		viewType : viewType,
		progressColor : progressColor,
		completeColor : completeColor,
		overdueColor : overdueColor,
		holdColor : holdColor,
		listNumber : listCount,
		listProjectStatus : defaultStatus
	}
	
	$.ajax({
		type : "POST",
		url : "/ezPMS/updateMainSetting.do",
		dataType : "text",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function() {
			alert("<spring:message code='ezPMS.t170' />");
		},
		error : function() {
			alert("<spring:message code='ezPMS.t208' />");
		}
	});
					
}

var manycolor_dialogArguments = new Array();

function manyColorShow(statusId) {
	statusName = statusId;
	
	if (statusId == "progressColor") {
		currentColor = $("#progressColor").text();
	} else if (statusId == "completeColor") {
		currentColor = $("#completeColor").text();
	} else if (statusId == "overdueColor") {
		currentColor = $("#overdueColor").text();
	} else if (statusId == "holdColor") {
		currentColor = $("#holdColor").text();
	}
	
	var url = "/ezPMS/getColorPicker.do";
	 GetOpenWindow(url, "manyColor", 265, 350);
   
    
/* 	if (CrossYN()) {
		manycolor_dialogArguments[0] = Name_Complete;
        manycolor_dialogArguments[1] = SelectColor_Complete;
        manycolor_dialogArguments[2] = currentColor;
        manycolor_dialogArguments[3] = originColor;
        manycolor_dialogArguments[4] = originColor2;

       
    } else {
        var retValue = window.showModalDialog("/ezTask/taskManyColor.do", "", "dialogHeight:230px; dialogWidth:280px; status:no;scroll:no; help:no; edge:sunken");
        if (typeof (retValue) != "undefined" && retValue != null) {
            document.getElementById(pID + "Display").style.backgroundColor = retValue;
            document.getElementById(pID).innerText = retValue;
        }
    } */
}

function restoreColor(statusId) {
	var colorId = "";
	
	if (statusId == "progressColor") {
		colorId = "#438ddd";
	} else if (statusId == "completeColor") {
		colorId = "#63c449";
	} else if (statusId == "overdueColor") {
		colorId = "#dd7238";
	} else if (statusId == "holdColor") {
		colorId = "#57c7b6";
	}
	
	$("#" + statusId + "Display").css("background-color", colorId);
	$("#" + statusId).text(colorId);
}
</script>
<style type="text/css">
#contentArea {
	width : 100%;
	height : 91%;
}
</style>
</head>
<body class="mainbody pmsSetting">
    <h1><spring:message code='ezPMS.t171' /></h1>
    <div class="portlet_tabpart01" style="margin-bottom: 10px">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab"><spring:message code='ezPMS.t172' /></span></p>
	   </div>
	</div>
    <div id="contentArea" style="overflow:auto;">
    	<table class="content" style="width:430px;margin-left:15px;">
		       <tr>
					<th><spring:message code='ezPMS.t173' /></th>
					<td>
						<select id="listcount" style="width: 40px; height: 20px;">
							<option value="10">10</option>
							<option value="20">20</option>
							<option value="30">30</option>
							<option value="40">40</option>
							<option value="50">50</option>
						</select>    
					</td>
				</tr>
            	<tr>
                	<th><spring:message code='ezPMS.t174' /></th>
               		<td>
               			<select id="defaultStatus" style="width: 150px">
               				<option value="A"><spring:message code='ezPMS.t271' /></option>
               				<option value="P"><spring:message code='ezPMS.t258' /></option>
               				<option value="W"><spring:message code='ezPMS.t260' /></option>
               				<option value="C"><spring:message code='ezPMS.t261' /></option>
               				<option value="L"><spring:message code='ezPMS.t262' /></option>
               				<option value="S"><spring:message code='ezPMS.t259' /></option>
               				<option value="D"><spring:message code='ezPMS.t263' /></option>
               				<option value="F"><spring:message code='ezPMS.t20' /></option>
               			</select>
               		</td>
            	</tr>
				<tr> 
					<th><spring:message code='ezPMS.t138' /></th>
					<td>
						<table style="table-layout:fixed;">
							<tr>
								<td><div id="progressColorDisplay" style="background-color:${setting.progressColor}; height:21px; border:1px inset gray"></div></td>
								<td id="progressColor" style="display:none;"><c:out value="${setting.progressColor}"/></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('progressColor')"><spring:message code='ezTask.t91' /></span></a></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="restoreColor('progressColor')"><spring:message code='ezPMS.t366' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t34' /></th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id="completeColorDisplay" style="background-color:${setting.completeColor}; height:21px; border:1px inset gray"></div></td>
								<td id="completeColor" style="display:none;"><c:out value="${setting.completeColor}"/></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('completeColor')"><spring:message code='ezTask.t91' /></span></a></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="restoreColor('completeColor')"><spring:message code='ezPMS.t366' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t139' /></th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id="overdueColorDisplay" style="background-color:${setting.overdueColor}; height:21px; border:1px inset gray"></div></td>
								<td id="overdueColor" style="display:none;"><c:out value="${setting.overdueColor}"/></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('overdueColor')"><spring:message code='ezTask.t91' /></span></a></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="restoreColor('overdueColor')"><spring:message code='ezPMS.t366' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezPMS.t277' /></th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id="holdColorDisplay" style="background-color:${setting.holdColor}; height:21px; border:1px inset gray"></div></td>
								<td id="holdColor" style="display:none;"><c:out value="${setting.holdColor}"/></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('holdColor')"><spring:message code='ezTask.t91' /></span></a></td>
								<td style="width:100px"><a class="imgbtn"><span onClick="restoreColor('holdColor')"><spring:message code='ezPMS.t366' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<div align="center" style="width:450px;">
				<div class="btnpositionJsp">
				<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezPMS.t265' /></span></a>
				<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezPMS.t41' /></span></a>
				</div>
			</div>
		</form>
    </div>
</body>
</html>