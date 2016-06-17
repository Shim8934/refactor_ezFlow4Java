<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t75" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezResource.e1' />" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js" ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js" ></script>
		<script type="text/javascript" src="/js/ezResource/admin/gwBoardsInfo.js" ></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pUserID = "${userInfo.id}"
			var pDeptID = "${userInfo.deptID}"
			var g_BrdID = "${brdID}";
			var L_brd_level = "${brdLevel}";
			var L_brd_ref = "${brdRef}";
			var pCompanyID = "${selCompanyID}";

			var p_SrcBrdID = g_BrdID;		
			var p_SrcBrdLevel = L_brd_level;
			var p_SrcBrdRef = L_brd_ref;	
			var p_SrcBrdUpper = "${brdUpper}";
			var p_TBrd_Level;	
			var p_TBrd_Ref;		
			var p_TBrd_ID;		
			var p_TBrd_UpID;	
			var p_TBrd_NM;		
			var p_TBrd_Explain;

			function cmdOk_onclick() {
			    if ((typeof (p_TBrd_ID) != "undefined") && p_TBrd_ID != "") {
					if(( p_TBrd_ID == p_SrcBrdID ) || ( p_TBrd_ID == p_SrcBrdUpper )  )	{
						alert("<spring:message code='ezResource.t76' />");
						return;
					} else {
					    if (confirm("<spring:message code='ezResource.t77' />") == true) {
					        var rv = BrdMove_xmlhttp(p_SrcBrdID, p_TBrd_ID);

					        if (rv) {
					            alert("<spring:message code='ezResource.t78' />");
					            parent.window.location.reload();
					        } else {
					            alert("<spring:message code='ezResource.t79' />");
					        }
					    }
					}
				}else{
					alert("<spring:message code='ezResource.t80' />");
				}
			}

			function BrdMove_xmlhttp(pSrcID, pTargetID) {
			    try{	
			    	var xmlhttp = "";		
			    	var xmlRtn = "";
			    	if (CrossYN()) {
			    	    xmlhttp = createXMLHttpRequest();
			    	    xmlRtn = createXmlDom();
			    	} else {
			    	    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			    	    xmlRtn = new ActiveXObject("Microsoft.XMLDOM");
			    	}

					var szUrl = "/admin/ezResource/callBrdMove.do?srcID=" + pSrcID + "&targetID=" + pTargetID + "&strPara=" +pCompanyID;

					xmlhttp.open("POST", szUrl, false);
					xmlhttp.send();
					if( xmlhttp.responseText == "False" ){
						return(false);			
					}else{
						return(true);
					}
			    } catch(e) { 
				}
			}

			window.onload = function () {
				var p_UserID = pUserID;
				var p_DeptID = pDeptID;

				var SelectedNode = "";
				    SelectedNode = window.parent.frames["board_menu"].TreeView.selectedIndex();
				    document.getElementById("pUpExp").textContent = window.parent.frames["board_menu"].TreeView.getvalue(SelectedNode, "DATA9");
			}

			var organ_cross_dialogArguments = new Array();
			
			function cmdSelect_onclick() {

				var para = new Array();
				var retVal = new Array();
				var url = "/admin/ezResource/organ.do";
				para[1] = pCompanyID;
				
				if (CrossYN()) {
				    organ_cross_dialogArguments[0] = para;
				    organ_cross_dialogArguments[1] = cmdSelect_onclick_Complete;

				    var OpenWin = window.open(url, "organ", GetOpenWindowfeature(360, 440));
			        try { OpenWin.focus(); } catch (e) { }
				}
				else {
				    retVal = window.showModalDialog(url, para, "dialogWidth:360px;dialogHeight:440px;status:no;help:no;scroll:no");

				    if (typeof (retVal) != "undefined") {
				        p_TBrd_Level = retVal[0];
				        p_TBrd_Ref = retVal[1];
				        p_TBrd_ID = retVal[2];
				        p_TBrd_UpID = retVal[3];
				        p_TBrd_NM = retVal[4];
				        p_TBrd_Explain = retVal[5];

				        if (CrossYN()) {
				            document.getElementById("txtTBrd_NM").textContent = p_TBrd_NM;
				            document.getElementById("txtTBrd_Explain").textContent = p_TBrd_Explain;
				        } else {
				            txtTBrd_NM.innerText = p_TBrd_NM;
				            txtTBrd_Explain.innerText = p_TBrd_Explain;
				        }
				    }
				}
			}
			
			function cmdSelect_onclick_Complete(retVal) {
			    if (typeof (retVal) != "undefined") {
			        p_TBrd_Level = retVal[0];
			        p_TBrd_Ref = retVal[1];
			        p_TBrd_ID = retVal[2];
			        p_TBrd_UpID = retVal[3];
			        p_TBrd_NM = retVal[4];
			        p_TBrd_Explain = retVal[5];

			        if (CrossYN()) {
			            document.getElementById("txtTBrd_NM").textContent = p_TBrd_NM;
			            document.getElementById("txtTBrd_Explain").textContent = p_TBrd_Explain;
			        } else {
			            txtTBrd_NM.innerText = p_TBrd_NM;
			            txtTBrd_Explain.innerText = p_TBrd_Explain;
			        }
			    }
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code='ezResource.t26' /></h1>
		<br>
		<br>
		<table class="content">
  			<tr>
    			<th><spring:message code='ezResource.t44' /></th>
    			<td>${upNm} <input type="hidden" id="UPPER_NM" name="UPPER_NM" value="${upNm}"></td>
  			</tr>
		</table>
		<br>
		<div class="txt"><h2><spring:message code='ezResource.t82' /></h2> (<spring:message code='ezResource.t83' /></div>
			<table class="content">
  				<tr>
    				<th> <spring:message code='ezResource.t84' /></th>
    				<td>${upNm} </td>
  				</tr>
  				<tr>
    				<th> <spring:message code='ezResource.t47' /></th>
    				<td id="pUpExp">&nbsp;</td>
  				</tr>
			</table>
			<br>
			<h2><spring:message code='ezResource.t85' /></h2>
			
			<c:if test="${brdID ne null || brdID != ''}">
				<c:if test="${brdID > 1}">
					<div id="mainmenu">
  					<ul>
    					<li><span onClick="return cmdSelect_onclick()"><spring:message code='ezResource.t86' /></span></li>
  					</ul>
				</div>
				<script type="text/javascript">
					selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
				</script>
				</c:if>
			</c:if>
			
			<c:choose>
				<c:when test="${brdID eq 1}">
					<div class="txt"> ${wrnMsg}</div>
				</c:when>
				<c:otherwise>
					<table class="content">
  						<tr>
    						<th><spring:message code='ezResource.t87' /></th>
    						<td id="txtTBrd_NM">&nbsp;</td>
  						</tr>
  						<tr>
    						<th> <spring:message code='ezResource.t47' /></th>
    						<td id="txtTBrd_Explain">&nbsp;</td>
  						</tr>
  					</table>
				</c:otherwise>
			</c:choose>
			
		<div class="btnposition">
     		<a class="imgbtn"><span onclick="cmdOk_onclick()" ><spring:message code='ezResource.t88' /></span></a>
		</div>
		<form name="brds">
  			<input type="hidden" id="proc" name="proc" value="MOV">
		</form>
	</body>
</html>