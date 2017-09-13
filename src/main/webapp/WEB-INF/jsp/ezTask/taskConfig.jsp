<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezTask.jsh02' /></title>
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var delaycolor = "";
			var completecolor = "";

			document.onselectstart = function () { return false; };

			window.onload = function(){

			}

			function save_info() {
				var delayColor = $("#DelayColor").text();
				var completeColor = $("#CompleteColor").text();

				$.ajax({
					type : "POST",
					url : "/ezTask/taskSaveConfig.do",
					dataType : "json",
					data : {
						delayColor : delayColor,
						completeColor : completeColor
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

			function manyColorShow(pID) {
				Name_Complete = pID;
				
				if (CrossYN()) {
	                manycolor_dialogArguments[1] = SelectColor_Complete;
	                var OpenWin = window.open("/ezTask/taskManyColor.do", "manyColor", GetOpenWindowfeature(280, 230));
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
	                document.getElementById(Name_Complete + "Display").style.backgroundColor = retValue;
	                document.getElementById(Name_Complete).innerText = retValue;
	            }
	        }

		</script>
		<script language="vbscript">
			Function ReplaceText(str, str1, str2)

			ReplaceText = Replace(str, str1, str2)

			End Function
		</script>
	</head>
	
	<body style="margin-left:10px;overflow:hidden;">
		<form method="post" runat="server">
			<br />
			<h2 class="h2_dot"><spring:message code='ezTask.t239' /></h2> 
			<p>
			<table class="content" style="width:250px;margin-left:15px;">
				<tr> 
					<th><spring:message code='ezTask.t90' /></th>
					<td>
						<table style="table-layout:fixed;">
							<tr>
								<td><div id=DelayColorDisplay style="background-color:${delayColor}; height:21px; border:1px inset gray"></div></td>
								<td id="DelayColor" style="display:none;">${delayColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('DelayColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<th><spring:message code='ezTask.t92' /></th>
					<td>
						<table style="table-layout:fixed">
							<tr>
								<td><div id=CompleteColorDisplay style="background-color:${completeColor}; height:21px; border:1px inset gray"></div></td>
								<td id="CompleteColor" style="display:none;">${completeColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('CompleteColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br />
			<div align="center" style="width:265px;">
				<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezTask.t96' /></span></a>
				<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezTask.t20' /></span></a>
			</div>
		</form>
	</body>
</html>