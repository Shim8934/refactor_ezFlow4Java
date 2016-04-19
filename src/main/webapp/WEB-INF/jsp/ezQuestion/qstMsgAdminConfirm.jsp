<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezQuestion.t115" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script src="https://code.jquery.com/jquery-1.12.0.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script language="JavaScript" type="text/javascript">
		
			var brd_id = "${brdID}";
			var item_no = "${itemNo}";
			var receve = "${receve}";
			
		    window.onload = function () {
		        var UserAgentState = navigator.userAgent.toLowerCase();
		        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		        if (!browserIE) {
		            if (UserAgentState.indexOf("firefox") != -1) {
		                window.resizeTo(349, 279);
		            }else if (UserAgentState.indexOf("safari") > 0 && UserAgentState.indexOf("chrome") == -1) {
		                window.resizeTo(346, 243);
		            }else
		                window.resizeTo(346, 269);
		        }
		    }
		
			function btn_OK_onclick() {
				window.opener.location.href = "/ezQuestion/qstResponse.do?"+receve;
				window.close();
			}
			
			function btn_CANCEL_onclick(){
				var EndPollYN, ResponseYN, ResultOpenYN
				var MultiResYN, WriteYN, AdminYN
					
				var g_BrdID =brd_id;
				var pItemNo =item_no;
				$.ajax({
					type: "POST",
					url: "/ezQuestion/qstCallUsersPollStatus.do",
					data: {"brdID":g_BrdID ,"itemNo":pItemNo},
					dataType: "JSON",
					success: function(map){
						EndPollYN = map.endPollYN;
						ResponseYN = map.responseYN;
						ResultOpenYN = map.resultOpenYN;
						MultiResYN = map.multiResYN;
						WriteYN = map.writeYN;
						AdminYN = map.adminYN;
					},
					error: function(e){
						alert(e.message);
					 	
						EndPollYN	 = "";
						ResponseYN	 = "";
						ResultOpenYN = "";
						MultiResYN	 = "";
						WriteYN		 = "N";
						AdminYN		 = "N";
						       
						return false;
					},
					complete:function(){
						if( WriteYN == "Y" || AdminYN == "Y" || (ResultOpenYN=="Y")){
							window.opener.location.href="/ezQuestion/qstResult.do?"+receve;
						}
						window.close();
					}
				});
			}
		</script>			
	</head>
	<body style="overflow:hidden">
    <div class="popup_noti">
    	<div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
 	    	<div class="popup_noti_content">
        		<div  style="padding:10px;">
		        <table>
			        <tr>
			          <td  class="cimg"></td>
			          <td  class="ctxt">
			              <span>
			                  <span class="point"><spring:message code='ezQuestion.t100' /></span><br />
			                  <spring:message code='ezQuestion.t101' /><br />
			                  <spring:message code='ezQuestion.t102' />
			              </span>
			          </td>
			        </tr>
				</table>
			    </div>
	        </div>
	    	<div class="popup_noti_btnarea"> 
	   	    	<div class="btnposition"> 
	            	<input type="submit" value="<spring:message code='ezQuestion.t103' />" id="btn_OpinionOK" onClick="return btn_OK_onclick()">
	            	<input type="submit" value="<spring:message code='ezQuestion.t104' />" id="btn_CANCEL" onClick="return btn_CANCEL_onclick()">
		    	</div>
	    	<span class="bl"></span>
	    	<span class="br"></span>
	    	</div>
    	</div>
	</body>
</html>