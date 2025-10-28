<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t1' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
			var ezapropinion_cross_dialogArguments = new Array();
			var xSelA = "";
			var xSelB = "";
			var xSelC = "";
			
			window.onload = function(){
				var agent = navigator.userAgent.toLowerCase(); 
				if (!CrossYN() || agent.search( "trident" ) > -1 ) {
					document.getElementById("c_clubdesc").style.marginBottom = "0px";
				}
			}
			
			function btn_CommSave() {
				if (document.frmCommunityBasicInfo.txt_CommunityName.value == "") {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t2' />");
					alert("<spring:message code = 'ezCommunity.t2' />");
					
					document.frmCommunityBasicInfo.txt_CommunityName.focus();
					
					return;	
				}
				
				if (document.frmCommunityBasicInfo.txt_CommunityName.value.length > 50) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t3' />");
					alert("<spring:message code = 'ezCommunity.t3' />");
					
					document.frmCommunityBasicInfo.txt_CommunityName.focus();
					
					return;	
				}
				
				if (document.frmCommunityBasicInfo.c_clubdesc.value == "") {
					alert("커뮤니티 소개를 입력 해주세요.");
					document.frmCommunityBasicInfo.c_clubdesc.value.focus();
					return;	
				}
				
				if (document.frmCommunityBasicInfo.c_clubdesc.value.length > 2000) {
					alert("<spring:message code = 'ezCommunity.t1009' />");
					document.frmCommunityBasicInfo.c_clubdesc.value.focus();
					return;	
				}
				
				selA = parseInt(document.frmCommunityBasicInfo.cCateA[document.frmCommunityBasicInfo.cCateA.selectedIndex].value);
				selB = parseInt(document.frmCommunityBasicInfo.cCateB[document.frmCommunityBasicInfo.cCateB.selectedIndex].value);
				selC = parseInt(document.frmCommunityBasicInfo.cCateC[document.frmCommunityBasicInfo.cCateC.selectedIndex].value);
				xSelA = document.frmCommunityBasicInfo.cCateA[document.frmCommunityBasicInfo.cCateA.selectedIndex].value;
				xSelB = document.frmCommunityBasicInfo.cCateB[document.frmCommunityBasicInfo.cCateB.selectedIndex].value;
				xSelC = document.frmCommunityBasicInfo.cCateC[document.frmCommunityBasicInfo.cCateC.selectedIndex].value;
				
				if (selA == 0) {
				//if (selA == 0 && selB == 0 && selC == 0) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t4' />");
					alert("<spring:message code = 'ezCommunity.t4' />");
					
					frmCommunityBasicInfo.c_cate_a.focus();
					
					return;
				}
				//2018-07-03 김보미 - b태그 삭제
// 				var pInformationContent = "<spring:message code = 'ezCommunity.t5' /><b class='point'><spring:message code = 'ezCommunity.t6' /></b> <spring:message code = 'ezCommunity.t7' />";
				var pInformationContent = "<spring:message code = 'ezCommunity.t5' /><spring:message code = 'ezCommunity.t6' /> <spring:message code = 'ezCommunity.t7' />";
				Ans = OpenInformationUI(pInformationContent, btn_CommSave_Complate);
			}
			
			function btn_CommSave_Complate(Ans) {
				if(Ans) {
					try {
						$.ajax({
							type : "POST",
							async : false,
							url : "/admin/ezCommunity/admCommunityInfoEditOk.do",
							data : {code     : code,
									clubName : document.frmCommunityBasicInfo.txt_CommunityName.value,
									clubDesc : document.frmCommunityBasicInfo.c_clubdesc.value,
									cCateA   : xSelA,
									cCateB   : xSelB,
									cCateC   : xSelC
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
					window.opener.location.reload();
					window.close();
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
			<div id="close">
	            <ul>
	                <li><span name="button3" onClick="window.close()"></span></li>
	            </ul>
	        </div>
			<table class="content">
				<tr>
					<th ><spring:message code = 'ezCommunity.t9' /></th>
					<td id="pCommunitySysop"><c:out value = '${club.c_SysopID}' />
				  (${club.userName})</td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t9991' /></th>
					<td><input type="text" style="width:100%" name="txt_CommunityName" maxlength="50" value="${club.c_ClubName}"></td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t11' /></th>
					<td><span id="idSpan">${idSpanValue }</span></td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t12' /></th>
					<td>
						<div class="custom_radio">
							<c:choose>
								<c:when test="${club.c_ClubConfirmType == '2'}">
									<input type="radio" name="c_clubtype" value="2" checked disabled><label><spring:message code = 'ezCommunity.t13' /></label>
									<input type="radio" name="c_clubtype" value="3" disabled ><label><spring:message code = 'ezCommunity.t14' /></label>
								</c:when>
								
								<c:when test="${club.c_ClubConfirmType == '3' }">
									<input type="radio" name="c_clubtype" value="2" disabled><label><spring:message code = 'ezCommunity.t13' /></label>
									<input type="radio" name="c_clubtype" value="3" checked disabled ><label><spring:message code = 'ezCommunity.t14' /></label>
								</c:when>
								
								<c:otherwise>
									<input type="radio" name="c_clubtype" value="2" disabled><label><spring:message code = 'ezCommunity.t13' /></label>
									<input type="radio" name="c_clubtype" value="3" disabled ><label><spring:message code = 'ezCommunity.t14' /></label>
								</c:otherwise>	
							</c:choose>
						</div>
						<br>
					</td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t15' /></th>
					<td>
						<div class="custom_radio">
							<c:choose>
								<c:when test="${club.c_ClubGubun == '2'}">
									<input type="radio" name="c_clubgubun" value="2" checked disabled ><label><spring:message code = 'ezCommunity.t16' /></label>
									<input type="radio" name="c_clubgubun" value="3" disabled ><label><spring:message code = 'ezCommunity.t17' /></label>
								</c:when>
								
								<c:when test="${club.c_ClubGubun == '3' }">
									<input type="radio" name="c_clubgubun" value="2" disabled ><label><spring:message code = 'ezCommunity.t16' /></label>
									<input type="radio" name="c_clubgubun" value="3" checked disabled ><label><spring:message code = 'ezCommunity.t17' /></label>
								</c:when>
								
								<c:otherwise>
									<input type="radio" name="c_clubgubun" value="2" disabled ><label><spring:message code = 'ezCommunity.t16' /></label>
									<input type="radio" name="c_clubgubun" value="3" disabled ><label><spring:message code = 'ezCommunity.t17' /></label>
								</c:otherwise>	
							</c:choose>
						</div>
						<br>
					</td>
				</tr>
				<tr>
					<th><spring:message code = 'ezCommunity.t1529' /><spring:message code = 'ezCommunity.t18' /></th>
					<td style="padding:0px;">
					<textarea id="c_clubdesc" maxlength="2000" name="c_clubdesc" style="Width:97%; Height:120px; cursor:default; border:none; 
						font: 9pt <spring:message code = 'ezCommunity.t19' /> resize:none;"><c:out value = '${club.c_ClubDesc}' /></textarea></td>
				</tr>
			</table>

			<div class="btnpositionNew">
                <a class="imgbtn" style="vertical-align:middle"><span name="button3" onClick="btn_CommSave()"><spring:message code = 'ezCommunity.t20' /></span></a>
			</div>
		</form>
	</body>
</html>
