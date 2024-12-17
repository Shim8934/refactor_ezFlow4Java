<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t60" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
		<style type="text/css">
			.warningbox{margin:50px auto 0px auto; padding:40px 20px 0px 20px; width:625px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box;}
			.warningbox .warningimg{margin:0px; padding:0px 0px 0px 40px; float:left;}
			.warningbox .warningDL{margin:0px; padding:0px 0px 0px 30px; float:left; overflow:hidden;}
			.warningbox .warningDL dt{margin:0px; padding:12px 0px 5px 0px; font-size:24px; font-weight:bold; color:#3d8fea; letter-spacing:-1px;}
			.warningbox .warningDL dd{margin:0px; padding:0px; font-size:20px; color:#333; letter-spacing:-1px; width:408px;}
			.warningbox .warningDL dd span{ font-size:20px; font-weight:bold;}
    		/* .warningbox01 { width:500px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;}
			.warningbox02 { width:430px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-top:20px}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 10px 5px 115px; margin:0px; display:inline-block;}
			.warningdl dt { height:40px; padding-left:5px; margin-top:10px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;} */
		</style>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pCompanyID	= "<c:out value='${selCompanyID}'/>";
			var pResID		= "<c:out value='${brdID}'/>";

			function cmdDel_onclick() {
				var rv = window.confirm("<spring:message code="ezResource.t61" />")
			
				if( rv == true ) {
					var xmlPara = "";
					var xmlHttp = "";

					if (CrossYN()) {
					    xmlPara = createXmlDom();
					    xmlHttp = createXMLHttpRequest();

					    var objNode;
				    	createNodeInsert(xmlPara, objNode, "PARADATA");
				    	createNodeAndInsertText(xmlPara, objNode, "DATA", pResID);
				    	createNodeAndInsertText(xmlPara, objNode, "DATA", pCompanyID);
					} else {
					    xmlPara = new ActiveXObject("Microsoft.XMLDOM");
				    	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");

				    	var objRootNode = xmlPara.createNode(1, "PARADATA", "");
				    	xmlPara.appendChild(objRootNode);

				    	var objNode = xmlPara.createNode(1, "DATA", "");
				    	objNode.text = pResID;
				    	objRootNode.appendChild(objNode);

				    	var objNode = xmlPara.createNode(1, "DATA", "");
				    	objNode.text = pCompanyID;
				    	objRootNode.appendChild(objNode);
					}

					xmlHttp.open("Post", "/admin/ezResource/callBrdDel.do", false);
					xmlHttp.send(xmlPara);
					if (xmlHttp.status != 200){
						alert("1. <spring:message code="ezResource.t63" />");
						return;
					}

					var rtnText = xmlHttp.responseText
					if (rtnText == "" || rtnText == "False"){
						alert("2. <spring:message code="ezResource.t63" />");
						return;
					}else{
						alert("<spring:message code="ezResource.t64" />");
						window.parent.board_menu.location.href = "/admin/ezResource/gwBoardListManagelistLeft.do?flag=SELECT_YES&selCompany=" + pCompanyID;
					}
				}
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezResource.t27" /></h1>
		<div style="max-width:800px;">
    	<table class="content">
        	<tr>
            	<th><spring:message code="ezResource.t44" /></th>
            	<td><c:out value='${upNm}' /><input type="hidden" id="UPPER_NM" name="UPPER_NM" value="<c:out value='${upNm}' />"></td>
        	</tr>
    	</table>
    	<br>
			<div id="EmptyMsg">
				<div class="warningbox">
			        <p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
			        <dl class="warningDL">
			        	<dt>WARNING</dt>
			        	${pWrnMsg}
			        </dl>
			    </div>
    			<%-- <div class="warningbox01" style="margin-top:50px; width:445px;">
        			<div class="warningbox02" style="width:375px;">
  	        			<div class="warnintxt01" style="text-align:left; display:inline-block;">
	        				<span class="warningimg" style="padding-left:30px;"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin:-10px 0px 0px -10px;"></span>
	        				<dl class="warningdl" style="padding:10px 0px 0px 20px;">
	        					<dt style="margin-top:0px; padding-left:90px;">
	        					<img src="/images/notify/warning01.gif" width="183" height="27">
	        					</dt>
	        					<dd style="font-weight: normal; text-align:center; padding-top:15px; padding-left:55px; height:30px;">
	        					 ${pWrnMsg}
	        					</dd>
	        				</dl>
	        			</div>
	    			</div>
    			</div> --%>
			</div>
	    <br>
		<div class="btnpositionJsp">
			<c:if test="${blnChkDelBtn eq true}">
				<a class="imgbtn"><span onclick="cmdDel_onclick()" ><spring:message code="ezResource.t65" /></span></a>
			</c:if>
		</div>
		</div>
    	<form name="brds">
        	<input type="hidden" id="proc" name="proc" value="DEL">
        	<input type="hidden" id="test" value="">
    	</form>
	</body>
</html>