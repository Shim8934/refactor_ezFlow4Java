<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t20'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script> 
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>

		<style>
			.editVersionContainer {
				display: flex;
				align-items: center;
				justify-content: center;
				margin-top: 5px;
				margin-bottom: 0px;
			}
			.editVersionContainer label {
				margin-right: 15px; /* 라벨 간 간격 조절 */
			}
		</style>
		<script type="text/javascript">
			var RetValue;
		    var ReturnFunction;
		    var winFlag;
		    var type = '${type}';
		    var formURL = '${formURL}';
		    var formDocType = '${formDocType}';
			var editModeYN = '${editModeYN}';
		    window.onload = function () {
		        try {
		            RetValue = parent.ezapropinion_cross_dialogArguments[0];
		            ReturnFunction = parent.ezapropinion_cross_dialogArguments[1];
		            winFlag = parent.ezapropinion_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                RetValue = opener.ezapropinion_cross_dialogArguments[0];
		                ReturnFunction = opener.ezapropinion_cross_dialogArguments[1];
			            winFlag = opener.ezapropinion_cross_dialogArguments[2];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        document.getElementById("pMessageContent").innerHTML = RetValue;
		        document.getElementById("Submit1").focus();
				
		        if (MACSAFARIYN()) {
		            window.resizeTo(330, 251);
		        }
		        
		     	// 2025-03-12 조수빈 - 다국어의 경우 메세지가 길어져 하단의 버튼이 밀리는 결함 발생.
	            var thisFrame = window.parent.document.getElementById("iFrameLayer");
	            
	            // 현재의 iframe 높이가 내부의 높이보다 작을 때 맞추도록 분기처리
	            if (thisFrame && parseFloat(thisFrame.style.height) < document.body.clientHeight) {
	            	window.parent.document.getElementById("iFrameLayer").style.height = document.body.clientHeight + 'px';
	            }
		    };
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent)) {
		        window.resizeTo(347, 290);
		    }
		
		    if (navigator.userAgent.indexOf('Firefox') != -1) {
		        window.resizeTo(348, 287);
		    }
		    else if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
		        window.resizeTo(348, 250);
		    }
		    
		    /* 2023-08-03 홍승비 - 일괄결재 시 중복 결재 등, 모든 알러트의 '확인'버튼 연속 클릭 동작을 방지하도록 disable 처리 */
		    function btn_OpinionOK_onclick() {
		    	document.getElementById("Submit1").disabled = true;
		    	
		        if (ReturnFunction != null) {
					if(editModeYN == "Y"){
						ReturnFunction(true, document.querySelector('input[name="editMode"]:checked').value);
					}else{
						ReturnFunction(true, type, formURL, formDocType);
					}
		            
		            if (winFlag) {
			            window.close();
		            }
		        } else {
		            window.returnValue = true;
		            window.close();
		        }
		    }
		    function btn_OpinionCANCEL_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction(false);
		            
		            if (winFlag) {
			            window.close();
		            }
		        } else {
		            window.returnValue = false;
		            window.close();
		        }
		    }
		</script>
	</head>
	<body style="overflow:hidden;">
	   <!--  popup -->
	    <div class="popup_noti">
		    <div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content" style="height: 100%;">
	        <div  style="padding:10px;">
	          <table>
	            <tr>
	              <td  class="cimg"></td>
	              <td  class="ctxt" >
					  <span id="pMessageContent" ></span>
					  <c:if test="${editModeYN == 'Y'}">
						   <span id="editVersionArea">
							  <p class="editVersionContainer">
								  <div class='custom_radio'><input type="radio" id="editMode1" name="editMode" value="1" checked>
								  <label for="editMode1"><spring:message code='ezApprovalG.EKMH01'/></label></div>
								  <div class='custom_radio'><input type="radio" id="editMode2" name="editMode" value="2">
								  <label for="editMode2"><spring:message code='ezApprovalG.EKMH02'/></label></div>
							  </p>
					  		</span>
					  </c:if>
				  </td>
	            </tr>
	     </table>
	 	    </div>
	    </div>
	    <div class="popup_noti_btnarea"> 
	   	    <div class="btnposition"> 
			   <c:choose>
			   		<c:when test="${type eq 'seal'}">
						<input type="submit"  value="부서관인" name="btn_OpinionOK" id="Submit1" onClick="return btn_OpinionOK_onclick()" > 
						<input type="submit"  value="회사관인" name="btn_OpinionCANCEL" id="Submit2" onClick="return btn_OpinionCANCEL_onclick()" >
					</c:when>
					<c:otherwise>
						<input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" name="btn_OpinionOK" id="Submit1" onClick="return btn_OpinionOK_onclick()" > 
						<input type="submit"  value="<spring:message code='ezApprovalG.t119'/>" name="btn_OpinionCANCEL" id="Submit2" onClick="return btn_OpinionCANCEL_onclick()" >
					</c:otherwise>
			   </c:choose>
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
	</body>
</html>
