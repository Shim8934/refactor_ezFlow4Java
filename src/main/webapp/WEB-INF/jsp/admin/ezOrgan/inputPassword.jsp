<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t228" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var ReturnFunction;
			var confirmStr;
			var companyID;

			$(document).ready(function(){
				try {
					ReturnFunction = opener.inputpassword_dialogArguments[1];
					companyID = opener.userComId
					
					var windowH = window.outerHeight;
					var windowW = window.outerWidth;
					var pwPolicyExplainH = $("#pwPolicyExplain").height();
					window.resizeTo(windowW, windowH + pwPolicyExplainH);
					
				} catch (e) {console.log(e);}
			});		

			function OK_Click(){
				if (NewPassword.value.trim() == "") {
					OpenAlertUI("<spring:message code='ezOrgan.t229' />"); 
					document.getElementById('NewPassword').focus();
					return;
				}
				
				var checkPw = checkPasswordPolicy({
					"pw" : NewPassword.value,
					"chkCompanyId" : companyID,
					"userId" : "<c:out value='${userId}'/>"
				});
				
		        if (!checkPw){
		        	document.getElementById('NewPassword').focus();
		        	return;
		        }

				if (NewPassword.value != ConfirmPassword.value) { 
					OpenAlertUI("<spring:message code='ezOrgan.t230' />");
					document.getElementById('ConfirmPassword').focus();
					return;
				}

                var data = "<c:out value='${userId}'/>";    
                $.ajax({
                    type : "POST",
                    dataType : "xml",
                    url : "/admin/ezOrgan/changePassword.do",
                    async : false,
                    data : {password : NewPassword.value, cn : data},
                    success : function(result) {
                        if (ReturnFunction != null) {
                            ReturnFunction(NewPassword.value); 
                        } else {
                            window.returnValue = NewPassword.value;
                        }
                        OpenAlertUI("<spring:message code='ezOrgan.hyh02' />",FnWindowClose);
                    },
                    error : function() {
                        OpenAlertUI("<spring:message code='ezOrgan.t41' />");
                    }
                });
			}

			function enterCheck(event) {
				if (event.keyCode == "13") {
					OK_Click();
				} 
			}
			
			var resizingFlag;
			var ezapralert_cross_dialogArguments = new Array();
			function OpenAlertUI(pAlertContent, CompleteFunction) {
			    resizingFlag = false;
                var parameter = pAlertContent;
                var url = "/ezApprovalG/ezAprAlert.do";

                ezapralert_cross_dialogArguments[0] = parameter;
                if (CompleteFunction != undefined) {
                    ezapralert_cross_dialogArguments[1] = CompleteFunction;
                } else {
                    ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
                }
                DivPopUpShow(300, 150, url);
                setTimeout(innerPopUpResizng, 100);
            }
            
            function innerPopUpResizng(){
                var getDoc = document.getElementById('iFrameLayer').contentDocument;
                if(!resizingFlag &&  typeof(getDoc.getElementsByClassName('popup_noti_btnarea')[0]) != 'undefined'){
                    resizingFlag = true;
                    document.getElementById('iFrameLayer').contentDocument.getElementsByClassName('popup_noti_btnarea')[0].style.padding = 0
                    document.getElementById('iFrameLayer').contentDocument.getElementsByClassName('popup_noti_btnarea')[0].style.height = '34px';
                    document.getElementById('iFrameLayer').contentDocument.getElementsByClassName('ctxt')[0].style.paddingTop='34px';
                    document.getElementById('iFrameLayer').contentDocument.getElementsByClassName('popup_noti_content')[0].style.height = '94px'
                } else {
                    setTimeout(innerPopUpResizng, 100);
                }
            }
            
            function OpenAlertUI_Complete() {
                DivPopUpHidden();
            }
            
            function FnWindowClose(){
                window.close();
            }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code="ezOrgan.t231" /></h1>
		<div id="close">
			<ul>
				<li><span onclick="window.close()"></span></li>
			</ul>
		</div>
		<div id="pwPolicyExplain" style="margin-top: 5px; color: #393939;"><span>${pwPolicyExplain }</span></div> <!-- el로 값 통째로 넣어줌 -->
		<table class="content" style="margin-top: 3px"> 
			<tr>
				<th><spring:message code="ezOrgan.t232" /></th>
				<td><input id=NewPassword type=password style="width:98%" maxlength="50"></td>
			</tr>
			<tr> 
				<th><spring:message code="ezOrgan.t233" /></th>
				<td><input id=ConfirmPassword type=password style="width:98%" maxlength="50" onkeydown="enterCheck(event)"></td>
			</tr>
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn" onClick="OK_Click()"><span><spring:message code="ezOrgan.t124" /></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
            <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
        </div>
	</body>
</html>