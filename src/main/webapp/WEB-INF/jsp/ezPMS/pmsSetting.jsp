<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezCircular.t10'/></title>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<link rel="stylesheet" href="/css/Tab.css" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>	
<script type="text/javascript">
var listProjectStatus = '${setting.listProjectStatus}';
var progressColor = '${setting.progressColor}';
var completeColor = '${setting.completeColor}';
var overdueColor = '${setting.overdueColor}';
var holdColor = '${setting.holdColor}';
var listNumber = '${setting.listNumber}';
var viewType = '${setting.viewType}';
var projectSort = '${setting.projectSort}';
var currentColor = "";
var statusName = "";

$(function(){
	$("#1tab0").addClass("tabon");
	console.log(listNumber);
	console.log(listProjectStatus);
	$("#listcount option[value='" + listNumber + "']").attr("selected", true);
	$("#defaultStatus option[value='" + listProjectStatus + "']").attr("selected", true);
});

function save_info() {
	progressColor = $("#progressColor").text();
	completeColor = $("#completeColor").text();
	overdueColor = $("#overdueColor").text();
	holdColor = $("#holdColor").text();
	listCount = $("#listcount").val();
	defaultStatus = $("#defaultStatus").val();
	
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
			alert("저장되었습니다.");
		},
		error : function() {
			alert("오류가 발생했습니다.");
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

</script>
<style type="text/css">
#contentArea {
	width : 100%;
	height : 91%;
}
</style>
</head>
<body class="mainbody">
    <h1>프로젝트관리 환경설정</h1>
    <div class="portlet_tabpart01" style="margin-bottom: 10px">
	   <div class="portlet_tabpart01_top" id="tab1">
	   		<p id="FBoard_sub0"><span id="1tab0" divname="FBoard_div0" class="tab">기본환경설정</span></p>
	   </div>
	</div>
    <div id="contentArea" style="overflow:auto;">
    	<table class="content" style="width:303px;margin-left:15px;">
		       <tr>
					<th>리스트 개수</th>
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
                	<th>기본 프로젝트 화면</th>
                		<td>
                			<select id="defaultStatus" style="width: 120px">
                				<option value="A">전체 프로젝트</option>
                				<option value="P">진행 프로젝트</option>
                				<option value="W">대기 프로젝트</option>
                				<option value="C">완료 프로젝트</option>
                				<option value="L">지연 프로젝트</option>
                				<option value="S">보류 프로젝트</option>
                				<option value="D">삭제 프로젝트</option>
                				<option value="F">자주가는 프로젝트</option>
                			</select>
                		</td>
            	</tr>
				<tr> 
					<th>진행중인 업무</th>
					<td>
						<table style="table-layout:fixed;">
							<tr>
								<td><div id="progressColorDisplay" style="background-color:${setting.progressColor}; height:21px; border:1px inset gray"></div></td>
								<td id="progressColor" style="display:none;">${setting.progressColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('progressColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>완료된 업무</th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id="completeColorDisplay" style="background-color:${setting.completeColor}; height:21px; border:1px inset gray"></div></td>
								<td id="completeColor" style="display:none;">${setting.completeColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('completeColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>기한이 지난 업무</th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id="overdueColorDisplay" style="background-color:${setting.overdueColor}; height:21px; border:1px inset gray"></div></td>
								<td id="overdueColor" style="display:none;">${setting.overdueColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('overdueColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>보류된 업무</th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id="holdColorDisplay" style="background-color:${setting.holdColor}; height:21px; border:1px inset gray"></div></td>
								<td id="holdColor" style="display:none;">${setting.holdColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('holdColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br />
			<div align="center" style="width:265px;">
				<a class="imgbtn" onClick="save_info()"><span>저장</span></a>
				<a class="imgbtn" onClick="window.location.reload(false)"><span>취소</span></a>
			</div>
		</form>
    </div>
</body>
</html>