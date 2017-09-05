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
// 			var autodelete = "_autodelete";

			document.onselectstart = function () { return false; };

			window.onload = function(){
// 				if (delaycolor != "") {
// 					if (autodelete != "0") {
// 						document.getElementById("CheckDelete").checked = false;
// 						document.getElementById("TextDelete").value = autodelete;
// 					}
// 				}
			}

// 			function CheckDeleteClick() {
// 				if (document.getElementById("CheckDelete").checked == true) {
// 					document.getElementById("TextDelete").value = "";
// 					document.getElementById("TextDelete").readOnly = true;
// 				} else {
// 					document.getElementById("TextDelete").readOnly = false;				
// 				}
// 			}

			function save_info() {
// 				if (document.getElementById("TextDelete").value != "" && parseInt(document.getElementById("TextDelete").value) != document.getElementById("TextDelete").value ||
// 					parseInt(document.getElementById("TextDelete").value) > 5000) {
// 						alert("<spring:message code='ezTask.t85' />");
// 						document.getElementById("TextDelete").focus();
// 						return;
// 				}
				var delayColor = $("#DelayColor").text();
				var completeColor = $("#CompleteColor").text();

// 				if (getNodeText(document.getElementById("DelayColor")) == "") {
// 					alert("<spring:message code='ezTask.t86' />");
// 					return;
// 				}

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
// 				if (getNodeText(document.getElementById("CompleteColor")) == "") {
// 					alert("<spring:message code='ezTask.t87' />");
// 					return;
// 				}

// 				var xmlDom = createXmlDom();
// 				var xmlHTTP = createXMLHttpRequest();
// 				var objRoot;

// 				createNodeInsert(xmlDom, xmlDom, "DATA");
// 				createNodeAndInsertText(xmlDom, xmlDom, "DELAYCOLOR", getNodeText(document.getElementById("DelayColor")));
// 				createNodeAndInsertText(xmlDom, xmlDom, "COMPLETECOLOR", getNodeText(document.getElementById("CompleteColor")));
				
// 				if (document.getElementById("TextDelete").value == "") {
// 					createNodeAndInsertText(xmlDom, xmlDom, "AUTODELETE", "0");					
// 				} else {
// 					createNodeAndInsertText(xmlDom, xmlDom, "AUTODELETE", document.getElementById("TextDelete").value);					
// 				}

// 				xmlHTTP.open("POST", "/ezTask/taskSaveConfig.do", false);
// 				xmlHTTP.send(xmlDom);

// 				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
// 					alert("<spring:message code='ezTask.t88' />");					
// 				} else {
// 					alert("<spring:message code='ezTask.t89' />");
// 					document.location.reload();
// 				}
				
// 				xmlHTTP = null;
			}

			var manycolor_dialogArguments = new Array();
			var Name_Complete;

			function manyColorShow(pID) {
				Name_Complete = pID;
				
				if (CrossYN()) {
	                manycolor_dialogArguments[1] = SelectColor_Complete;
	                var OpenWin = window.open("/ezTask/taskManyColor.do", "manyColor", GetOpenWindowfeature(294, 260));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var retValue = window.showModalDialog("/ezTask/taskManyColor.do", "", "dialogHeight:260px; dialogWidth:294px; status:no;scroll:no; help:no; edge:sunken");
	                if (typeof (retValue) != "undefined" && retValue != null) {
	                    document.getElementById(pID + "Display").style.backgroundColor = retValue;
	                    document.getElementById(pID).innerText = retValue;
	                }
	            }
// 				var color = showModalDialog("/ezTask/taskManyColor.do", null, "dialogHeight:290px; dialogWidth:286px; status:no;scroll:no; help:no; edge:sunken");

// 				if(typeof(color) != "undefined") {
// 					document.getElementById(pID + "Display").style.backgroundColor = color;
// 					document.getElementById(pID + "Value").innerText = color;
// 					setNodeText(document.getElementById(pID), color);
// 				}
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
			<table class="content" style="width:450px;margin-left:15px;">
				<tr> 
					<th><spring:message code='ezTask.t90' /></th>
					<td>
						<table style="table-layout:fixed;">
							<tr>
								<td id="DelayColorDisplay" style="background-color:${delayColor};width:100px"></td>
								<td id="DelayColor" style="width:70px; padding-left:10px">${delayColor}</td>
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
								<td id="CompleteColorDisplay" style="background-color:${completeColor};width:100px"></td>
								<td id="CompleteColor" style="width:70px; padding-left:10px">${completeColor}</td>
								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('CompleteColor')"><spring:message code='ezTask.t91' /></span></a></td>
							</tr>
						</table>
					</td>
				</tr>

<!-- 				<tr style="display:none"> -->
<%-- 					<th><spring:message code='ezTask.t93' /></th> --%>
<!-- 					<td> -->
<%-- 						<input type="text" id="TextDelete" name="TextDelete" value="" size="8" readonly><spring:message code='ezTask.t94' /> --%>
<%-- 						<input type="checkbox" id="CheckDelete" value="radiobutton" onClick="CheckDeleteClick()" checked><spring:message code='ezTask.t95' /> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
			</table>
			<br />
			<div align="center" style="width:465px;">
				<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezTask.t96' /></span></a>
				<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezTask.t20' /></span></a>
			</div>
		</form>
	</body>
</html>