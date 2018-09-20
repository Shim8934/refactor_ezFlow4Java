<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t10018'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript">
			var selectedApproveMember = "";
			var ReturnFunction;
			window.onload = function (){
				try {
					selectedApproveMember = parent.apropinionsendmail_cross_dialogArguments[0];
		            ReturnFunction = parent.apropinionsendmail_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		            	selectedApproveMember = opener.apropinionsendmail_cross_dialogArguments[0];
		                ReturnFunction = opener.apropinionsendmail_cross_dialogArguments[1];
		            } catch (e) {
		            }
		        }
		        
		        if (selectedApproveMember == "") {
		        	selectedApproveMember = 0;
		        }
		        
		        $("input[name=approveMember][value=" + selectedApproveMember + "]").prop("checked", true);
			}
			
			function confirm_click() {
				var checkedValue = $("input[name=approveMember]:checked").val();
				if (ReturnFunction != null) {
					ReturnFunction(checkedValue);
				}
			}
			
			function Cancel() {
		        if (ReturnFunction != null) {
		            ReturnFunction();
		        }
			}
		</script>
	</head>
	<body class="popup">
		<h1>발송메일 결재자 선택</h1>
		<div id="close">
            <ul>
                <li><span onclick="return Cancel()"></span></li>
            </ul>
        </div>
		<span>▒ 기안부서에서 메일을 받을 사람을 선택하세요. <br/>수신결재가 완료되면 선택된 결재자에게 자동으로 메일이 발송됩니다.</span>
		<table class="content" style="margin-top:10px">
			<tr><th><input id='noselect' name ='approveMember' type='radio' value="0"></th>
			<td><label for="noselect">선택안함</label></td></tr>
			<tr><th><input id='drafter' name ='approveMember' type='radio' value="1"></th>
			<td><label for="drafter">기안자</label></td></tr>
			<tr><th ><input id='approver' name='approveMember' type='radio' value="2"></th>
			<td><label for="approver">결재자</label></td> </tr>
			<tr><th ><input id='all' name='approveMember' type='radio' value="3"></th>
			<td><label for="all">모두</label></td> </tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a id="Submit1" class="imgbtn" onClick="return confirm_click()"><span>확인</span></a>
		    <a id="Submit2" class="imgbtn" onClick="return Cancel()" ><span>취소</span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>