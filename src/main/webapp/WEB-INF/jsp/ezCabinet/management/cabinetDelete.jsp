<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="cabDeloff" id="cabDelDiv">
	
	<div class="popup_noti">
		<div class="popup_noti_title" style="height:10px;">
			<span class="tl"></span>
			<span class="tr"></span>
		</div>
		
		<div class="popup_noti_content">
			<div style="padding:10px;">
				<table>
					<tr>
						<td class="cimg"></td>
						<td class="ctxt" id="pMessageContent"><spring:message code='ezCabinet.t86'/></td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="popup_noti_btnarea cabdelpp">
			<div class="btnposition" id="cabDelBttn">
				<input type="button" value="<spring:message code='ezCabinet.t46'/>">
				<input type="button" value="<spring:message code='ezCabinet.t15'/>">
			</div>
			<span class="bl"></span>
			<span class="br"></span>
		</div>
	</div>
</div>