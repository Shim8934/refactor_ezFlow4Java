<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
<!-- 		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> -->
<!-- 		<title>환경설정</title> -->
<!-- 		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> -->
<%-- 		<link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css"> --%>
<!-- 		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script> -->
<!-- 		<script type="text/javascript"> -->
<%-- 			var delaycolor = "<%= _delaycolor %>"; --%>
<%-- 			var completecolor = "<%= _completecolor %>"; --%>
<%-- 			var autodelete = "<%= _autodelete %>"; --%>

// 			document.onselectstart = function () { return false; };

// 			window.onload = function(){
// 				if (delaycolor != "") {
// 					if (autodelete != "0") {
// 						document.getElementById("CheckDelete").checked = false;
// 						document.getElementById("TextDelete").value = autodelete;
// 					}
// 				}
// 			}

// 			function CheckDeleteClick() {
// 				if (document.getElementById("CheckDelete").checked == true) {
// 					document.getElementById("TextDelete").value = "";
// 					document.getElementById("TextDelete").readOnly = true;
// 				} else {
// 					document.getElementById("TextDelete").readOnly = false;				
// 				}
// 			}

// 			function save_info() {
// 				if (document.getElementById("TextDelete").value != "" && parseInt(document.getElementById("TextDelete").value) != document.getElementById("TextDelete").value ||
// 					parseInt(document.getElementById("TextDelete").value) > 5000) {
<%-- 						alert("<%=RM.GetString("t85")%>"); --%>
// 						document.getElementById("TextDelete").focus();
// 						return;
// 				}

// 				if (getNodeText(document.getElementById("DelayColor")) == "") {
<%-- 					alert("<%=RM.GetString("t86")%>"); --%>
// 					return;
// 				}

// 				if (getNodeText(document.getElementById("CompleteColor")) == "") {
<%-- 					alert("<%=RM.GetString("t87")%>"); --%>
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

// 				xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_save_config.aspx", false);
// 				xmlHTTP.send(xmlDom);

// 				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
<%-- 					alert("<%=RM.GetString("t88")%>");					 --%>
// 				} else {
<%-- 					alert("<%=RM.GetString("t89")%>");					 --%>
// 				}
// 			}
			
// 			function manyColorShow( pID ) {
// 				var color = showModalDialog("/myoffice/ezEmail/htm/manyColor.aspx", null, "dialogHeight:290px; dialogWidth:286px; status:no;scroll:no; help:no; edge:sunken");

// 				if( typeof(color) != "undefined" ) {
// 					document.getElementById(pID + "Display").style.backgroundColor = color;
// 					setNodeText(document.getElementById(pID), color);
// 				}
// 			}
<!-- 		</script> -->
<!-- 		<script language="vbscript"> -->
			Function ReplaceText(str, str1, str2)

			ReplaceText = Replace(str, str1, str2)

			End Function
		</script>
<!-- 	</head> -->
	
<!-- 	<body style="margin-left:10px;overflow:hidden;"> -->
<!-- 		<form method="post" runat="server"> -->
<!-- 			<br /> -->
<%-- 			<h2 class="h2_dot"><%=RM.GetString("t239")%></h2>  --%>
<!-- 			<p> -->
<!-- 			<table class="content" style="width:450px;margin-left:15px;"> -->
<!-- 				<tr>  -->
<%-- 					<th><%=RM.GetString("t90")%></th> --%>
<!-- 					<td> -->
<!-- 						<table style="table-layout:fixed;"> -->
<!-- 							<tr> -->
<%-- 								<td id="DelayColorDisplay" style="background-color:#<%=_delaycolor%>;width:100px"></td> --%>
<%-- 								<td id="DelayColor" style="width:70px; padding-left:10px">#<%=_delaycolor%></td> --%>
<%-- 								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('DelayColor')"><%=RM.GetString("t91")%></span></a></td> --%>
<!-- 							</tr> -->
<!-- 						</table> -->
<!-- 					</td> -->
<!-- 				</tr> -->

<!-- 				<tr> -->
<%-- 					<th><%=RM.GetString("t92")%></th> --%>
<!-- 					<td> -->
<!-- 						<table style="table-layout:fixed"> -->
<!-- 							<tr> -->
<%-- 								<td id="CompleteColorDisplay" style="background-color:#<%=_completecolor%>;width:100px"></td> --%>
<%-- 								<td id="CompleteColor" style="width:70px; padding-left:10px">#<%=_completecolor%></td> --%>
								
<%-- 								<td style="width:100px"><a class="imgbtn"><span onClick="manyColorShow('CompleteColor')"><%=RM.GetString("t91")%></span></a></td> --%>
<!-- 							</tr> -->
<!-- 						</table> -->
<!-- 					</td> -->
<!-- 				</tr> -->

<!-- 				<tr style="display:none"> -->
<%-- 					<th><%=RM.GetString("t93")%></th> --%>
<!-- 					<td> -->
<%-- 						<input type="text" id="TextDelete" name="TextDelete" value="" size="8" readonly><%=RM.GetString("t94")%> --%>
<%-- 						<input type="checkbox" id="CheckDelete" value="radiobutton" onClick="CheckDeleteClick()" checked><%=RM.GetString("t95")%> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 			</table> -->
<!-- 			<br /> -->
<!-- 			<div align="center" style="width:465px;"> -->
<%-- 				<a class="imgbtn" onClick="save_info()"><span><%=RM.GetString("t96")%></span></a> --%>
<%-- 				<a class="imgbtn" onClick="window.location.reload(false)"><span><%=RM.GetString("t20")%></span></a> --%>
<!-- 			</div> -->
<!-- 		</form> -->
	</body>
</html>