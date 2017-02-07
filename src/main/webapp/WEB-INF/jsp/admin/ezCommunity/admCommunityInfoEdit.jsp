<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t1' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
			var ezapropinion_cross_dialogArguments = new Array();
			var xSelA = "";
			var xSelB = "";
			var xSelC = "";
			
			
			function btn_CommSave() {
				if (document.frmCommunityBasicInfo.txt_CommunityName.value == "") {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t2' />");
					alert("<spring:message code = 'ezCommunity.t2' />");
					
					document.frmCommunityBasicInfo.txt_CommunityName.focus();
					
					return;	
				}
				
				if (document.frmCommunityBasicInfo.txt_CommunityName.value.length > 100) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t3' />");
					alert("<spring:message code = 'ezCommunity.t3' />");
					
					document.frmCommunityBasicInfo.txt_CommunityName.focus();
					
					return;	
				}
	
				selA = parseInt(document.frmCommunityBasicInfo.cCateA[document.frmCommunityBasicInfo.cCateA.selectedIndex].value);
				selB = parseInt(document.frmCommunityBasicInfo.cCateB[document.frmCommunityBasicInfo.cCateB.selectedIndex].value);
				selC = parseInt(document.frmCommunityBasicInfo.cCateC[document.frmCommunityBasicInfo.cCateC.selectedIndex].value);
				xSelA = document.frmCommunityBasicInfo.cCateA[document.frmCommunityBasicInfo.cCateA.selectedIndex].value;
				xSelB = document.frmCommunityBasicInfo.cCateB[document.frmCommunityBasicInfo.cCateB.selectedIndex].value;
				xSelC = document.frmCommunityBasicInfo.cCateC[document.frmCommunityBasicInfo.cCateC.selectedIndex].value;
				
				if (selA == 0 && selB == 0 && selC == 0) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t4' />");
					alert("<spring:message code = 'ezCommunity.t4' />");
					
					frmCommunityBasicInfo.c_cate_a.focus();
					
					return;
				}
				
				var pInformationContent = "<spring:message code = 'ezCommunity.t5' /><b class='point'><spring:message code = 'ezCommunity.t6' /></b> <spring:message code = 'ezCommunity.t7' />";
				Ans = OpenInformationUI(pInformationContent, btn_CommSave_Complate);
			}
			
			function btn_CommSave_Complate(Ans) {
				if(Ans) {
					try {
						$.ajax({
							type : "POST",
							async : false,
							url : "/admin/ezCommunity/admCommunityInfoEditOk.do",
							data : {code	:	code,
									clubName	:	document.frmCommunityBasicInfo.txt_CommunityName.value,
									cCateA	:	xSelA,
									cCateB	:	xSelB,
									cCateC	:	xSelC
								   },
							success : function(result) {
								if (result == "OK") {
									//document.frmCommunityBasicInfo.submit();
									//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
									//OpenAlertUI("<spring:message code = 'ezCommunity.t8' />");
									alert("<spring:message code = 'ezCommunity.t8' />");
		 	 					}
							}
						});
					} catch (e) {
						console.log(e.message);
					}
				}
				
				try {
					window.opener.location.reload(true);
				} catch(e) {}
			}
			
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezCommunity/ezAPROPINION.do";
		        
		        if (CrossYN()) {
		        	ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined) {
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            } else {
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            }
		            
		            var ezSealInfo = window.open(url, "", GetOpenWindowfeature(330, 205));
	                try { ezSealInfo.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(325, 200);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        
		        return RtnVal;
		    }
		    
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<form method="post" name="frmCommunityBasicInfo" action="/admin/ezCommunity/admCommunityInfoEditOk.do">
			<input type="hidden" name="code" value="${code}">
			<h1><spring:message code = 'ezCommunity.t1' /></h1>
			<table class="content">
				<tr>
					<th ><spring:message code = 'ezCommunity.t9' /></th>
					<td id="pCommunitySysop"><c:out value = '${club.c_SysopID}' />
				  (${club.userName})</td>
				</tr>
				<tr>
					<th>Community <spring:message code = 'ezCommunity.t10' />					</th>
					<td><input type="text" style="width:100%" name="txt_CommunityName" value="${club.c_ClubName}"></td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t11' />					</th>
					<td><span id="idSpan">${idSpanValue }</span></td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t12' /></th>
					<td>
						<c:choose>
							<c:when test="${club.c_ClubConfirmType == '2'}">
								<input type="radio" name="c_clubtype" value="2" checked disabled><spring:message code = 'ezCommunity.t13' />
								<input type="radio" name="c_clubtype" value="3" disabled ><spring:message code = 'ezCommunity.t14' />
							</c:when>
							
							<c:when test="${club.c_ClubConfirmType == '3' }">
								<input type="radio" name="c_clubtype" value="2" disabled><spring:message code = 'ezCommunity.t13' />
								<input type="radio" name="c_clubtype" value="3" checked disabled ><spring:message code = 'ezCommunity.t14' />
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="c_clubtype" value="2" disabled><spring:message code = 'ezCommunity.t13' />
								<input type="radio" name="c_clubtype" value="3" disabled ><spring:message code = 'ezCommunity.t14' />
							</c:otherwise>	
						</c:choose>

						<br>
					</td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t15' /></th>
					<td>
						<c:choose>
							<c:when test="${club.c_ClubGubun == '2'}">
								<input type="radio" name="c_clubgubun" value="2" checked disabled ><spring:message code = 'ezCommunity.t16' />
								<input type="radio" name="c_clubgubun" value="3" disabled ><spring:message code = 'ezCommunity.t17' />
							</c:when>
							
							<c:when test="${club.c_ClubGubun == '3' }">
								<input type="radio" name="c_clubgubun" value="2" disabled ><spring:message code = 'ezCommunity.t16' />
								<input type="radio" name="c_clubgubun" value="3" checked disabled ><spring:message code = 'ezCommunity.t17' />
							</c:when>
							
							<c:otherwise>
								<input type="radio" name="c_clubgubun" value="2" disabled ><spring:message code = 'ezCommunity.t16' />
								<input type="radio" name="c_clubgubun" value="3" disabled ><spring:message code = 'ezCommunity.t17' />
							</c:otherwise>	
						</c:choose>
						
						<br>
					</td>
				</tr>
				<tr>
					<th>Community <spring:message code = 'ezCommunity.t18' /></th>
					<td><textarea name="c_clubdesc" style="Width:320px; Height:120px; font: 9pt <spring:message code = 'ezCommunity.t19' />" readonly><c:out value = '${club.c_ClubDesc}' /></textarea></td>
				</tr>
			</table>

			<div class="btnposition">
                <a class="imgbtn" style="vertical-align:middle"><span name="button3" onClick="btn_CommSave()"><spring:message code = 'ezCommunity.t20' /></span></a>
                <a class="imgbtn" style="vertical-align:middle"><span name="button3" onClick="window.close()"><spring:message code = 'ezCommunity.t21' /></span></a>
			</div>
		</form>
	</body>
</html>