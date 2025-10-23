<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezTask.jsh02' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var delaycolor = "";
			var completecolor = "";
			var originColor = "<c:out value='${originColor}'/>"; // 색상편집에서 지연된 업무의 상위색
			var originColor2 = "<c:out value='${originColor2}'/>"; // 색상편집에서 완료된 업무의 상위색

			document.onselectstart = function () { return false; };

			window.onload = function(){

			}

			function save_info() {
				var delayColor = $("#DelayColor").text();
				var completeColor = $("#CompleteColor").text();
				var listCount = $("#listcount").val();
				var selectTaskStatus = $("#selectTaskStatus").val();
				
				$.ajax({
					type : "POST",
					url : "/ezTask/taskSaveConfig.do",
					dataType : "json",
					data : {
						delayColor : delayColor,
						completeColor : completeColor,
						originColor : originColor,
						originColor2 : originColor2,
						listCount : listCount,
						selectTaskStatus : selectTaskStatus
					},
					success : function() {
						alert("<spring:message code='ezTask.t89' />");
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
								
			}

			var manycolor_dialogArguments = new Array();
			var Name_Complete;
			var currentColor;

			function manyColorShow(pID) {
				Name_Complete = pID;

				if (Name_Complete == "DelayColor") {
					currentColor = $("#DelayColor").text();
				} else {
					currentColor = $("#CompleteColor").text();
				}

				if (CrossYN()) {
					manycolor_dialogArguments[0] = Name_Complete;
	                manycolor_dialogArguments[1] = SelectColor_Complete;
	                manycolor_dialogArguments[2] = currentColor;
	                manycolor_dialogArguments[3] = originColor;
	                manycolor_dialogArguments[4] = originColor2;

	                var OpenWin = window.open("/ezTask/taskManyColor.do", "manyColor", GetOpenWindowfeature(265, 350));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var retValue = window.showModalDialog("/ezTask/taskManyColor.do", "", "dialogHeight:230px; dialogWidth:280px; status:no;scroll:no; help:no; edge:sunken");
	                if (typeof (retValue) != "undefined" && retValue != null) {
	                    document.getElementById(pID + "Display").style.backgroundColor = retValue;
	                    document.getElementById(pID).innerText = retValue;
	                }
	            }
			}

			function SelectColor_Complete(retValue) {
	            if (typeof (retValue) != "undefined" && retValue != null) {
	                document.getElementById(Name_Complete + "Display").style.backgroundColor = retValue.split(",")[0];
	                document.getElementById(Name_Complete).innerText = retValue.split(",")[0];
	                if (Name_Complete == "DelayColor") {
		                originColor = retValue.split(",")[1];
	                } else {
						originColor2 = retValue.split(",")[1];
	                }
	            }
	        }

		</script>
		<script language="vbscript">
			Function ReplaceText(str, str1, str2)

			ReplaceText = Replace(str, str1, str2)

			End Function
		</script>
	</head>
	
	<body style="margin-left:10px;overflow:hidden;" class="taskConfig">
		<form method="post" runat="server">
			<br />
			<h2 style="font-weight: normal">▒&nbsp;<spring:message code='ezTask.jsh13' /></h2> 
			<h2 style="font-weight: normal;margin-top:5px">▒&nbsp;<spring:message code='ezTask.t239' /></h2> 
			<p>
			<table class="content" style="width:300px;margin-left:15px;">
					<tr>
                	<th><spring:message code='ezTask.jsh15' /></th>
                		<td>
                    		<select id="listcount" name="pListCount" style="WIDTH: 120px">
                				<option value='10' ${taskGeneralVO.listCount == '10' ? 'selected' : ''}>10</option>
								<option value='20' ${taskGeneralVO.listCount == '20' ? 'selected' : ''}>20</option>
                      			<option value='30' ${taskGeneralVO.listCount == '30' ? 'selected' : ''}>30</option>
                      			<option value='40' ${taskGeneralVO.listCount == '40' ? 'selected' : ''}>40</option>
                      			<option value='50' ${taskGeneralVO.listCount == '50' ? 'selected' : ''}>50</option>
                   			</select>
                    	<spring:message code='ezTask.t110' />
                    	</td>
            	</tr>
            	<tr>
                	<th><spring:message code='ezTask.jsh14' /></th>
                		<td>
                			<select id="selectTaskStatus" name="pSelectTask" style="WIDTH: 120px">
                				<option value="taskpr" ${taskGeneralVO.selectTaskStatus == 'taskpr' ? 'selected' : ''}><spring:message code='ezTask.t200901' /></option>
                				<option value="taskre" ${taskGeneralVO.selectTaskStatus == 'taskre' ? 'selected' : ''}><spring:message code='ezTask.t200902' /></option>
                				<option value="taskdi" ${taskGeneralVO.selectTaskStatus == 'taskdi' ? 'selected' : ''}><spring:message code='ezTask.t200903' /></option>
                			</select>
                		</td>
            	</tr>
				<tr> 
					<th><spring:message code='ezTask.t90' /></th>
					<td>
						<table style="table-layout:fixed;">
							<tr>
								<td><div id=DelayColorDisplay style="background-color:<c:out value='${delayColor}'/>; height:21px; border:1px inset gray"></div></td>
								<td id="DelayColor" style="display:none;"><c:out value='${delayColor}'/></td>
								<td style="width:100px"><a class="imgbtn imgbck"><span onClick="manyColorShow('DelayColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<th><spring:message code='ezTask.t92' /></th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id=CompleteColorDisplay style="background-color:<c:out value='${completeColor}'/>; height:21px; border:1px inset gray"></div></td>
								<td id="CompleteColor" style="display:none;"><c:out value='${completeColor}'/></td>
								<td style="width:100px"><a class="imgbtn imgbck"><span onClick="manyColorShow('CompleteColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<div align="center" style="width:280px;">
				<div class="btnpositionJsp">
					<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezTask.t96' /></span></a>
					<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezTask.t20' /></span></a>
				</div>	
			</div>
		</form>
	</body>
</html>