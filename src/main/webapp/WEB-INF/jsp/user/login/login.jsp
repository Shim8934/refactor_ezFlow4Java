<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
	<head> 
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="shortcut icon" href="/images/favicon.ico">
		<link href="${util.addVer('/css/login.css')}" rel="stylesheet" type="text/css" />
<%-- 		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css"> --%>
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<style>
			.blocker {
				text-align: center;
			}
			.modal p {
				background:none; padding: 7px 0px;
			}			
			.warning_wrap{ overflow:hidden; width:600px; margin:auto}
			.warning_wrap p{ margin:0px; padding:0px; font-family:Malgun Gothic, Meiryo UI; text-align:center; float:left;}
			.warning_wrap dl{ margin:7px 0px 0px 20px;; padding:0px; font-family:Malgun Gothic, Meiryo UI; float:left; overflow:hidden;}
			.warning_wrap dt{ font-size:18px; color:#000; padding:0px 0px 5px 0px; margin:0px; font-weight:bold; border-bottom:1px solid #d7d7d7;}
			.warning_wrap dd.count{ color:#000; font-weight:normal; font-size:15px; padding:10px 0px;}
			.warning_wrap dd.count .pointRed{ color:#ff0000; font-weight:bold; display:inline-block; font-family: Malgun Gothic, Meiryo UI; font-size:15px;}
			.warning_wrap dd{color:#8e8e8e; font-size:12px; padding:0px 0px 2px 0px; margin:0px;letter-spacing:-1px;}
			
			.otp_qr{ overflow:hidden; width:575px; margin: 0 auto}
			.otp_qr p{ margin:0px; padding:0px; font-family:Malgun Gothic, Meiryo UI; text-align:center; float:left;}
			.otp_qr dl{ width: 100%; margin:7px 0px 0px 0px; padding:0px; font-family:Malgun Gothic, Meiryo UI; float:left; overflow:hidden;}
			.otp_qr dt{ font-size:18px; color:#000; padding:0px 0px 13px 14px; margin:0px; font-weight:bold; border-bottom:1px solid #d7d7d7;}
			.otp_qr dd.count{ color:#000; font-weight:normal; font-size:15px; padding:10px 0px;}
			.otp_qr dd.count .pointRed{ color:#ff0000; font-weight:bold; display:inline-block; font-family: Malgun Gothic, Meiryo UI; font-size:15px;}
			.otp_qr dd{text-align: center; color:#797979; font-size:15px; padding:0px 0px 5px 0px; margin:0px;letter-spacing:-1px;}
			
			.password_reset{ margin:0 auto; padding:0px; width:405px;}
			.password_reset .passwordTitle{ margin:0px; padding:0px; font-family:Malgun Gothic, Meiryo UI; font-size:17px; color:#000; text-align:center; line-height:25px; border-bottom: none;}
			.password_reset .passwordTitle span{ display:inline-block; color:#006be4; font-family:Malgun Gothic, Meiryo UI; font-size:17px;}
			.password_reset .passwordForm{ margin:15px 0px 0px; padding:8px 5px; list-style:none;}
			.password_reset .passwordForm li{ margin:0px 0px 14px 0px; padding:0px 15px 0px; font-size:13px; clear:both; overflow:hidden;}
			.password_reset .passwordForm li .formText{ display:inline-block; line-height:35px; font-size:13px; font-weight: bold;}
			.password_reset .passwordForm li .formID{ display:inline-block; font-weight:bold;font-size:13px; float:right; width:199px; height:35px; line-height:35px; border:1px solid #d9d9d9; border-radius:2px; -webkit-border-radius:2px; -moz-border-radius:2px; text-align:center; box-sizing:border-box;}
			.password_reset .passwordForm li .formInput{ display:inline-block; float:right; font-size:13px;}
			.password_reset .passwordForm li .formInput input{font-size:13px; width:199px; height:35px; line-height:35px; border:1px solid #d9d9d9; border-radius:2px; -webkit-border-radius:2px; -moz-border-radius:2px; padding:0px 0px 0px 5px;}
			.password_reset .passwordForm li.grayText{ color:#8e8e8e; font-size:12px; margin:0px; padding:0px}
			#exDiv3 dl{margin-top: 20px;}
			.warning_wrap .layerTitle{margin-bottom: 20px;}
			.modal:not(#exDiv10){max-width: 600px !important;}
			
			/* 2018-11-06 포탈개인화 로고 설정 - 유은정 */
			/*.logo img {width:137px; height:38px;} */
			
			#findPwd {
				color: #393939;
			}
			
			#findPwd:hover {
				color:#0470e4;
			}
			
			.redText {
				color:#ff0000;
			}
			
			#exDiv6 #div6_PwPolicyExplain p {
				padding:0;
			}

			/* otp 인증 임시 스타일*/
			#uotp::placeholder {
				color:#fff;
				font-weight: 600;
			}
			
			/* IE 버전 input 자동 생성 CSS 삭제 */
			input[type="text"]::-ms-clear, input[type="password"]::-ms-reveal {
			  display: none;
			}
		</style>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript">
			var lastLoginAttempt = 0;
			var loginCooldown = 1000; // 1초 (1000 밀리초)
			var pwPolicyExplain = "${pwPolicyExplain}";
			var usefidoforce = "${usefidoforce}";
		
			function actionLogin() {
				var currentTime = new Date().getTime();

				// 중복 실행 방지: 1초 이내에 다시 로그인 시도를 막음
				if (currentTime - lastLoginAttempt < loginCooldown) {
					return;
				}

			    if (document.loginForm.id.value =="") {
			        alert("<spring:message code='main.jjs02'/>");
			        document.loginForm.id.focus();
			        return;
			    } else if (document.loginForm.password.value =="") {
			        alert("<spring:message code='main.jjs01'/>");
			        document.loginForm.password.focus();
			        return;
			    } else {
			    	var frm = document.loginForm;
			    	var rsa = new RSAKey();
					rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
					
					saveid(frm);

					frm.encryptID.value = rsa.encrypt(frm.id.value.toLowerCase());
					frm.encryptPass.value = rsa.encrypt(frm.password.value);
					frm.encryptOTP.value = rsa.encrypt(frm.otp.value);
					frm.id.value = "";
					frm.password.value = "";
					frm.otp.value = "";

					// fido test
					if ('true' == usefidoforce) {
						frm.password.value = 'usefidoforce';
					}

					frm.action="<c:url value='/user/login/actionLogin.do'/>";        
					frm.submit();

					lastLoginAttempt = new Date().getTime();
			    }
			}
			
			function passwordUpdateNextTime() {
		    	var frm = document.loginForm;
		    	var rsa = new RSAKey();
				rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
				
				frm.encryptID.value = "<c:out value='${encryptID}' />";
				frm.encryptPass.value = "<c:out value='${encryptPass}' />";
				frm.encryptOTP.value = "<c:out value='${encryptOTP}' />";
				frm.nextTime.value = "YES";
				frm.action="<c:url value='/user/login/actionLogin.do'/>";        
				frm.submit();
			}
			
			function setCookie (name, value, expires) {
			    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
			}
			
			function getCookie(Name) {
			    var search = Name + "="
			    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
			        offset = document.cookie.indexOf(search)
		   
			        if (offset != -1) { // 쿠키가 존재하면
			            offset += search.length
			            // set index of beginning of value
			            end = document.cookie.indexOf(";", offset);     
			            document.getElementById("uid").className = "input_text focus";
			            document.getElementById("upw").focus();
			            // 쿠키 값의 마지막 위치 인덱스 번호 설정
			            if (end == -1)
			                end = document.cookie.length
			            return unescape(document.cookie.substring(offset, end))
			        }
			    } else {			    	
					document.getElementById("uid").focus();
			    }
			    return "";
			}
			
			function saveid(form) {
			    var expdate = new Date();			    
			    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
			    if (form.checkId.checked)
			        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
			    else
			        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
			    setCookie("saveid", form.id.value, expdate);
			}
			
			function getid(form) {
			    form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
			}
			
			function fnInit() {
			    var message = document.loginForm.message.value;
			    var multiLoginFlag = "<c:out value='${multiLoginFlag}' />";
			    
			    // 로그인 페이지가 로드된 프레임이 Top 프레임이 아니면 Top 프레임으로 로드시킨다.
                if (top != self) {
                    //top.location.href = self.location.href;
                    //멀티 로그인 기능때문에 변경
                    top.reloadLoginPage(multiLoginFlag, document.URL);
                    return;
                } else {
               		history.pushState(null, null, "login.do");
                }
			    
			    if(message == "oldBrowser"){
			    	alert("<spring:message code='main.t0631'/>"
			    		+ "\nInternet Explorer 10 <spring:message code='main.t0632'/>"
			    		+ "\n(<spring:message code='main.t0633'/> : Internet Explorer 11)");
			    	return false;
			    }
			    
			    if ("${isWrongPass}" == "Y") {
			    	$("#imgMnt").html("<img src='/images/warning2.png'>");
			    	$("#exDiv2").modal();
			    } else if(message == "oldBrowser"){
		    		alert("<spring:message code='main.t0631'/>"
			    		+ "\nInternet Explorer 10 <spring:message code='main.t0632'/>"
			    		+ "\n(<spring:message code='main.t0633'/> : Internet Explorer 11)");
			    	return false;
				// setTFA를 호출하는 flag 형태로 사용
			    } else if (message.indexOf("setflagTFA") !== -1) {
			    	var setArr = message.split(":");
			    	document.loginForm.message.value = "";
			    	
			    	var frm = document.loginForm;
			    	var rsa = new RSAKey();
			    	rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
			    	
			    	setTFA(rsa.encrypt(setArr[1]));
			    } else if (message === "multiLoginNoti") {
					$("#imgMnt3").html("<img src='/images/warning2.png'>");
			        $("#exDiv4").modal();
			    } else if (message === "stopUser") {
					$("#imgMnt4").html("<img src='/images/warning2.png'>");
			        $("#exDiv5").modal();
			    } else if ("${threeLineMSG}" == "Y") {
			    	$("#imgMnt7").html("<img src='/images/warning2.png'>");
			    	$("#exDiv7").modal();
			    } else if(message == "emptyOtp"){
			    	setTimeout(function() {
			    		alert("<spring:message code='fail.common.login.otp.warning1'/>");
			    	}, 100);
			    } else if (message === "loginSessionFlag") {
					$("#imgMnt9").html("<img src='/images/warning2.png'>");
					$("#exDiv9").modal();
				} else if (message === "organInfoChangedFlag") {
					$("#imgMnt11").html("<img src='/images/warning2.png'>");
					$("#exDiv11").modal();
				} else if (message === "loginBlock") {
					$("#imgMnt10").html("<img src='/images/warning2.png'>");
					$("#exDiv10").modal();
				} else if (message != "") {
// 			        alert(message);
					$("#layerTitle").text(message);
					$("#imgMnt2").html("<img src='/images/warning2.png'>");
			        $("#exDiv3").modal();
			    }

				var pwInput = document.getElementById('upw'); // 해당 ID로 비밀번호 입력 요소 가져오기
				var capsLock = document.getElementById('capsLock'); // CapsLock 경고 표시 요소
				var pwView = document.querySelector('.pw #pw_view'); // 로그인 > 비밀번호 보기 

				pwInput.addEventListener('keydown', function (e) {
					if (e.getModifierState && e.getModifierState('CapsLock')) {
						capsLock.style.display = 'block';
					} else {
						capsLock.style.display = 'none';
					}
				});

				pwInput.addEventListener('blur', function () {
					capsLock.style.display = 'none';
					if (pwInput.value.length == 0) pwView.style.display = 'none';
				});

				pwInput.addEventListener('focus', function () {
					pwView.style.display = 'block';
				});
				
			    getid(document.loginForm);
			    document.loginForm.message.value = "";
			    
				if ("${isExpireDate}" == "Y") {
					$("#exDiv").modal();
					$("#exDiv").show(function() {						
						$("#txtOldPassword").focus();
					});
			    }
				
				// 하단의 연도 문자열 표출
				makeRightsYearString();
				
				const togglePasswords = document.querySelectorAll('.pw_view');

				togglePasswords.forEach((toggle) => {
					toggle.addEventListener('click', function () {
						const passwordInput = this.parentNode.querySelector('input[type="password"], input[type="text"]');
						const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
						passwordInput.setAttribute('type', type);
					});
				});
				
			}
			
			function setting_click() {
			    var ver = navigator.userAgent;
			    window.open("/docs/usersetting_IE8.html", "", "height=768,width=1024, scrollbars=yes, status = yes, toolbar=yes, menubar=yes, location=yes, resizable=yes");
			}
			
			function PassWordChange() {
				if (document.getElementById('txtOldPassword').value == "") {
					alert("<spring:message code='ezPersonal.t947'/>");
				    document.all['txtOldPassword'].focus();
				    return;
				}
				if (document.getElementById('txtNewPassword').value == "") {
		            alert("<spring:message code='main.jjh01'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }
				
				var companyID = "${companyId}";
				var checkPw = loginCheckPasswordPolicy({
					"pw" : document.getElementById('txtNewPassword').value,
					"chkCompanyId" : companyID,
					"userId" : document.getElementById("chooseId").getAttribute("data-userId")
				});

		        if (!checkPw){
		        	document.getElementById('txtNewPassword').focus();
		        	return;
		        }				
				
				if (document.getElementById('txtOldPassword').value == document.getElementById('txtNewPassword').value) {
		            alert("<spring:message code='ezPersonal.t194'/>");
			        document.all['txtNewPassword'].focus();
			        return;
			    }
		        if (document.getElementById('txtNewPassword').value != document.getElementById('txtNewPasswordConfirm').value) {
		            alert("<spring:message code='main.jjh02'/>");
			        document.all['txtNewPasswordConfirm'].focus();
			        return;
			    }
				
				var resetPasswordFlag = "${resetPassword}";
				resetPasswordFlag = resetPasswordFlag ==="" ? 'N' : resetPasswordFlag;
		        
		        var frm = document.loginForm;
		        var rsa = new RSAKey();
				rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "html",				    		
		    		async : false,
		    		data : {
		    			USERID : rsa.encrypt(document.getElementById("chooseId").getAttribute("data-userId")),
		    			OLDPASSWORD : rsa.encrypt(document.getElementById('txtOldPassword').value),
		    			NEWPASSWORD : rsa.encrypt(document.getElementById('txtNewPassword').value),
		    			NEWPASSWORDCONFIRM : rsa.encrypt(document.getElementById('txtNewPasswordConfirm').value),
						RESETPASSWORDFLAG : resetPasswordFlag
		    		},
		    		url : "/user/login/changePassword.do",
		    		success: function(text){
		    			if (text == 'OK') {
		    				//alert("<spring:message code='ezPersonal.t197'/>");
		    				
		    				if (${useOTP} && ${isFirstLogin == 'Y'}) {
		    					alert("<spring:message code='ezPersonal.ls001'/>");
		    					setTFA(rsa.encrypt(document.getElementById("chooseId").getAttribute("data-userId")));
		    				} else {
		    					alert("<spring:message code='ezPersonal.t197'/>");
			    				window.top.location.href = '/user/login/login.do';
		    				}

		    			} else if (text == 'LOGINERROR') {
		    				alert("<spring:message code='ezPersonal.t946'/>");		    				
		    			} else {
		    				alert("<spring:message code='fail.common.login'/>");
		    			}
		    		},
		    		error: function(err){
		    			alert("<spring:message code='ezPersonal.t198'/>");
		    		}
		        });	        
		    }
			
			function setTFA(userId){
				$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		data : {
		    			userId : userId
		    		},
		    		url : "/user/login/setTFA.do",
		    		success: function(result){
		    			if (result != "fail") {
		    				var resultArr = result.split("::");
		    				var otpKey = resultArr[0];
		    				var qrImagePath = resultArr[1];
		    				$("#exDiv8").modal();
		    				
		    				document.getElementById("otpkey").innerText = otpKey;
		    				document.getElementById("qr").innerHTML = "<image src=" + qrImagePath + " />";
		    			    document.loginForm.message.value = "";
		    			} else {
			    			alert("<spring:message code='login.ls004'/>");
		    			}
		    		},
		    		error : function err(){
		    			alert("<spring:message code='login.ls004'/>");
		    		}
				});
			}

			function openFindPwd(){
				sabun = "";
				certificationNum = "";
				$("#certificationNum").val("");
				$("#certificationPwd").val("");
				$("#sabun").val("");
				$("#exDiv6").modal();
				$("#div6_PwPolicyExplain").html("");
			}
			
			function sendFindPwd(){
				var frm = document.loginForm;
		        var rsa = new RSAKey();
				rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
				
				sabun = $("#sabun").val();
				
				if(!sabun || sabun == ""){
					alert("사번을 입력하십시오.");
					return;
				}
				
				$.ajax({
		    		type : "POST",
		    		data : {
		    			sabun : rsa.encrypt(sabun)
		    		},
		    		url : "/user/login/sendFindPwd.do",
		    		success: function(text){
		    			alert(text);
		    		},
		    		error: function(err){
		    			alert("인증번호 발송 도중 오류가 발생하였습니다.");
		    		}
		        });	 
			}
			
			function checkCertification(){
				var frm = document.loginForm;
		        var rsa = new RSAKey();
				rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
				
				certificationNum = $("#certificationNum").val();
				
				if(!sabun || sabun == ""){
					alert("인증번호를 발급받으십시오.");
					return;
				}
				if(!certificationNum || certificationNum == ""){
					alert("인증번호를 입력하십시오.");
					return;
				}
				
				$.ajax({
		    		type : "POST",
		    		async : false,
		    		data :
		    			{
		    				certificationNum : rsa.encrypt(certificationNum),
		    				sabun : rsa.encrypt(sabun)
		    			}
		    		,
		    		url : "/user/login/checkCertification.do",
                    dataType : "json",
		    		success: function(text){
		    			alert(text.resultMsg);
		    			
		    			if (text.resultKey == 1) {
		    				$("#div6_PwPolicyExplain").html(text.pwPolicyExplain);
		    			}
		    		},
		    		error: function(err){
		    			alert("인증번호 확인  도중 오류가 발생하였습니다.");
		    		}
		        });	 
			}
			
			function changePasswordByCertification(){
				var frm = document.loginForm;
		        var rsa = new RSAKey();
		        rsa.setPublic(frm.publicModulus.value, frm.publicExponent.value);
		        
		        if(!sabun || sabun == ""){
					alert("인증번호를 발급받으십시오.");
					return;
				}
				if(!certificationNum || certificationNum == ""){
					alert("인증번호를 입력하십시오.");
					return;
				}
		        
				$.ajax({
		    		type : "POST",
		    		async : false,
		    		data :
		    			{
		    				certificationNum : rsa.encrypt(certificationNum),
		    				sabun : rsa.encrypt(sabun),
		    				certificationPwd : rsa.encrypt(document.getElementById('certificationPwd').value),
		    				certificationPwdRe : rsa.encrypt(document.getElementById('certificationPwdRe').value)
		    			}
		    		,
		    		url : "/user/login/changePasswordByCertification.do",
		    		success: function(text){
		    			var resultArr = text.split("|")
		    			if(resultArr[0] == "success"){
		    				$.modal.close();
		    			}
		    			alert(resultArr[1]);
		    		},
		    		error: function(err){
		    			alert("비밀번호 변경 도중 오류가 발생했습니다..");
		    		}
		        });	 
			}
			
			/* 2021-04-09 홍승비 - 로그인 페이지의 연도 자동 업데이트 */
			function makeRightsYearString() {
				var date = new Date();
				var year = date.getFullYear();
				var rightsYearString = "ⓒ 2000-" + year + ". KAONi Co., Ltd. All rights reserved.";
				
				document.getElementById("rightsYearP").innerText = rightsYearString;
			}
			
			// 2023-09-21 황인경 - 디자인 개선 > 로그인 페이지 > 아이디/비밀번호 입력칸 clear
	        function clearInput(obj){
	            obj.addEventListener("click",function(){
	            	var clearObj = $(obj).prev();
	                clearObj.val("");
	                clearObj.attr("class","input_text focus");
	                clearObj.focus();
	            })
	        }
			
			function resetPassword () {
				window.location.href = "/user/login/resetPw/resetPwInfo.do";
			}
	
			function openBoardItem(itemID, boardType, boardID) {
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 890) / 2;
				
				var url = "/ezBoard/boardItemView.do";
				if (boardType === "3" || boardType === "4") {
					url = "/ezBoard/boardItemViewPhoto.do";
				} else if (boardType === "7" ) {
					url = "/ezBoard/boardIte mViewMovie.do";
				}
				
				url += "?&itemID=" + encodeURIComponent(itemID) + "&boardID=" + encodeURIComponent(boardID);
				window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=890,top=" + pTop + ",left=" + pLeft, "");
			}
			
			function openBoardList(boardID, boardType) {
				var url = "/ezBoard/boardItemList.do"
				if (boardType === "3" || boardType === "4") {
					url = "/ezBoard/boardItemListPhoto.do";
				} else if (boardType === "7" ) {
					url = "/ezBoard/boardItemListMovie.do";
				}

				url += "?boardID=" + encodeURIComponent(boardID) + "&boardType=" + boardType;
				window.open(url, "_blank", "height=720,width=890")
			}
    	</script>
	</head>	
	<body class="login_body" onload="fnInit()">
		<div class="login_wrapper">
			<div class="login_backImg">
				<c:if test="${guestPermitYN eq 'YES' && showGuestBoardYN eq 'YES'}">
					<div class="contents_guestBoardList">
						<dl class="contents_tabGuestBoard">
							<dt>${boardInfo.boardName}</dt>
							<c:if test="${fn:length(gBoardList) > 0 }">
								<dd class="btn_more" onclick="openBoardList('${boardInfo.boardID}', '${boardInfo.guBun}')"></dd>
							</c:if>
						</dl>
						<ul class="contents_listGuestBoard">
							<c:choose>
								<c:when test="${fn:length(gBoardList) eq 0 }">
									<dl class="nodata_sIcon">
										<dt><img src="/images/kr/main/noData_sIcon.png"></dt>
										<dd><spring:message code='ezCommunity.kmsc01'/></dd>
									</dl>
								</c:when>
								<c:when test="${fn:length(gBoardList) ne 0 }">
									<c:forEach items="${gBoardList}" var="list" begin="0" end="4" >
										<li>
											<c:if test="${list.notice eq '1'}">
												<span class="icon">
													<img src="/images/i_notice.gif">
												</span>
											</c:if>
											<c:if test="${list.itemLevel > 1}">
												<span class="icon">
													<img src="/images/dum.gif" width="${(list.itemLevel - 1) * 10 }" height="1" border="0">
													<img src="/images/i_rep.gif" alt border="0">
												</span>
											</c:if>
											<c:if test="${list.writeDate >= pastDate}">
												<span class="icon"><img src="/images/kr/community/communityPortlet_iconnew.gif"></span>
											</c:if>
											<span class="txt" onclick="openBoardItem('${list.itemID}', '${boardInfo.guBun}', '${boardInfo.boardID}')">${list.title}</span><span class="date">${fn:substring(list.writeDate, 0, 10) }</span>
										</li>
									</c:forEach>
								</c:when>
							</c:choose>
						</ul>
					</div>
				</c:if>
			</div>
			<div class="right_wrap">
				<div class="login_layout">
        			<div class="login_form">	                
						<form style="display: inherit;" id="loginForm" name="loginForm" method="post">
		                	<input type="hidden" name="publicModulus" value="${publicModulus}"/>
		                	<input type="hidden" name="publicExponent" value="${publicExponent}"/>
		                	<input type="hidden" name="encryptID" />
		                	<input type="hidden" name="encryptPass"/>
		                	<input type="hidden" name="encryptOTP"/>
		                	<input type="hidden" name="nextTime"/>
		                	
		                    <fieldset>
		                    	<p class="logo" ><img style ="width: 229px; height: 81px;" src="<c:out value='${logoUrl }'/>"></p>
		                        <p class="id_txt"><spring:message code="main.login.design01"/></p>
		                        <p class="id">
		                        	<input id="uid" name="id" placeholder="<spring:message code="main.login.design02"/>" style="ime-mode:disabled;" class="input_text" type="text" onblur="if (this.value.length==0) {this.className='input_text', document.getElementById('BC').style.display = 'none';} else {this.className='input_text'};" onfocus="this.className='input_text focus', document.getElementById('BC').style.display = 'block';" onKeyPress="if(event.keyCode==13) document.loginForm.password.focus();" maxlength="20"/>
		                        	<span class="btnClear" id="BC" onclick="clearInput(this)" style="display:none;"></span>
		                        </p>
		                        <p class="pw_txt"><spring:message code="main.login.design03"/></p>
		                        <p class="pw">
		                        	<input id="upw" name="password" maxlength="50" style="padding-right: 90px" placeholder="<spring:message code="main.login.design04"/>" class="input_text" type="password" onchange="if(this.value.length!=0){this.className='input_text focus'}" onblur="if (this.value.length==0) {this.className='input_text', document.getElementById('BC2').style.display = 'none';} else {this.className='input_text'};" onfocus="this.className='input_text focus', document.getElementById('BC2').style.display = 'block';" onKeyPress="if(event.keyCode==13) actionLogin();" autocomplete="off" />
		                        	<span class="btnClear" id="BC2" onclick="clearInput(this)" style="display:none;"></span>
									<span class="pw_view" id="pw_view" onclick="this.classList.toggle('on')" style="display:none;"></span>
		                        </p>
									<div class="capsLock" id="capsLock" style="display:none">Caps Lock이 켜져 있습니다.</div>
		                        <c:choose>
			                        <c:when test="${useOTP}">
										<p class="otp_txt">OTP</p>
				                        <p class="otp" title="<spring:message code="info.otp.msg" />">
											<input id="uotp" name="otp" placeholder="<spring:message code="main.login.ls001"/>" class="input_text" type="text" onblur="if (this.value.length==0) {this.className='input_text', document.getElementById('BC3').style.display = 'none';} else {this.className='input_text'};" onfocus="this.className='input_text focus', document.getElementById('BC3').style.display = 'block';" onkeypress="if(event.keyCode==13) document.loginForm.password.focus();">
											<span class="btnClear" id="BC3" onclick="clearInput(this)" style="display:none;"></span>
				                        </p>
			                        </c:when>
			                        <c:otherwise>
				                        <input id="uotp" name="otp" type="hidden" style="display:none" />
			                        </c:otherwise>
		                        </c:choose>
		                        <p class="btn_login">
		                        	<label for="LoginButton" class="btn_login" onclick="javascript:actionLogin()" style="cursor:pointer">
		                        		<span id="LoginBtnSpan" style="font-size:20px;"><spring:message code="main.login.design05"/></span>
		                        	</label>
		                        </p>
		                        <div class="btnBox">
			                        <p class="saveid">
			                        	<input type="checkbox" value="" id="checkId" name="checkId" />
			                        	<label for="checkId"><span></span><spring:message code="main.login.design06"/></label>
			                        </p>
	  		                        <c:if test="${usePasswordReset == 'YES'}"> 
				                        <p class="find_pw">
			                                <a id="findPwd" onclick="resetPassword();" ><spring:message code="login.zno025"/></a>
			                            </p>
	 	                            </c:if>
	                        	</div>
		                    </fieldset>
		                    <input type="hidden" name="message" value="${message}" />
				    	</form>
					</div>	
				</div>
				<div class="copy">
                	<p id="rightsYearP"></p>
           		</div>
			</div>
		</div>				
		<div class="noti_layer" style="position:absolute;top:295px;left:800px;display:none;" id="divCapsLock">
			<span class="arrow">
				<img src="/images/login/notilayer_bg_arrow.gif" width="7" height="6" style="vertical-align:top; z-index:10;" />
			</span>
			<p><span>[<strong class="yellow_txt">Caps Lock</strong>]?pCapsLockMsg?></span></p>
		</div>
		<div id="exDiv" style="display: none; margin-bottom: 100px;padding: 67px 20px 32px;" class="modal">
			<div id="close">
				<ul>
					<li><a rel="modal:close"><span></span></a></li>
				</ul>
			</div>
			<div class="password_change">
				<div class="passwordTitle">
					<span class="password_lock"></span>
					<div class="password_tit">
						<p class="tit_01">
							<c:choose>
								<c:when test="${isFirstLogin == 'Y' && resetPassword != 'Y'}">
									<spring:message code='login.kdh029'/>
								</c:when>
								<c:when test="${isFirstLogin != 'Y' && resetPassword != 'Y'}">
									<spring:message code='login.kdh030'/>
								</c:when>
								<c:otherwise>
									<spring:message code='login.kdh032'/>
								</c:otherwise>
							</c:choose>
						</p>
						<p class="tit_02">
<%--							<span><spring:message code='main.login.design03'/></span>--%>
							<spring:message code='login.kdh031' htmlEscape="false"/>
						</p>
					</div>
				</div>
				<ul class="passwordForm">
					<li>
						<div>${pwPolicyExplain}</div>
					</li>
					<li style="padding-top:10px;">
						<span class="formText"><spring:message code='main.jjh09'/></span>
						<span class="formID" id="chooseId" data-userId="${userId}">${loginId}</span>
					</li>
					<li>
						<span class="formText">
							<c:if test="${resetPassword == 'Y'}"><spring:message code='login.kdh001'/></c:if>
							<c:if test="${resetPassword != 'Y'}"><spring:message code='ezPersonal.t949'/> </c:if>
						</span><span class="formInput"><input type="password" id="txtOldPassword" maxlength="50" style="padding-right: 50px" onkeypress="if(event.keyCode==13) PassWordChange();"><span class="pw_view" onclick="this.classList.toggle('on');"></span></span></li>
					<li><span class="formText"><spring:message code='main.jjh05'/></span><span class="formInput"><input type="password" id="txtNewPassword"  maxlength="50" style="padding-right: 50px" onkeypress="if(event.keyCode==13) PassWordChange();"><span class="pw_view" onclick="this.classList.toggle('on');"></span></span></li>
					<li><span class="formText"><spring:message code='main.jjh06'/></span><span class="formInput"><input type="password" id="txtNewPasswordConfirm" maxlength="50" style="padding-right: 50px" onkeypress="if(event.keyCode==13) PassWordChange();"><span class="pw_view" onclick="this.classList.toggle('on');"></span></span></li>

					<li style="padding-bottom:10px;padding-top:3px" class="grayText"></li>
				</ul>
			</div>
			<div class="btnpositionLayer" style="background-color: white;border:0px">
				<a class="imgbtn ok" onclick="javascript:PassWordChange()"><span><spring:message code='ezSchedule.t4' /></span></a>
				<c:if test="${isFirstLogin != 'Y' && resetPassword != 'Y'}">
					<a class="imgbtn" onClick="passwordUpdateNextTime()" ><span><spring:message code='main.hdp01'/></span></a>
				</c:if>
			</div>

			<a href="#close-modal" rel="modal:close" class="close-modal ">Close</a></div>

		<%-- 2018-05-24 홍승비 - 비밀번호 오류 시 레이어팝업 출력 --%>
		<div id="exDiv2" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:20px">
		    	<p style="border:0px" id="imgMnt"></p>
		        <dl>
		        	<dt>${message1}</dt>
		            <dd class="count">${message2}<span class="pointRed">${message3}</span>${message4}</dd>
		            <dd>${message5}</dd>
     				<c:choose>
						<c:when test="${useOTP}">
							<dd><spring:message code='fail.common.login.otp.warning2'/></dd>
						</c:when>
						<c:otherwise>
							<dd><spring:message code='fail.common.login.warning6'/></dd>
						</c:otherwise>
					</c:choose>
		        </dl>
		    </div>
			<%-- <div style="height:150px;border:1px solid rgb(0, 72, 149);margin:5px;border-radius:10px">
				<div style="color:rgb(0, 72, 149);padding:18px 0px 10px 20px;font-size:12px;white-space: pre-wrap;">▒ ${message1}<span class="spanMsg">${message2}</span>${message3}
				</div>
			</div>		
			<div class="btnposition" style="margin-top:0px;">
			    <a class="imgbtn" rel="modal:close"><span><spring:message code='ezSchedule.t4' /></span></a>
			</div>	 --%>
		</div>

<!-- 		2018-07-20 강민석 존재하지 않는 ID를 입력했을 경우 alert -> layer 팝업으로 변경 -->
		<div id="exDiv3" style="display:none;max-width:620px; min-height:190px;padding:27px 0;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:20px">
				<p style="border:0px" id="imgMnt2"></p>
		        <dl style="width: 65%;">
					<dt id="layerTitle" class="layerTitle">${message1}</dt>
					<c:choose>
						<c:when test="${useOTP}">
							<dd><spring:message code='fail.common.login.otp.warning2'/></dd>
						</c:when>
						<c:otherwise>
							<dd><spring:message code='fail.common.login.warning6'/></dd>
						</c:otherwise>
					</c:choose>
		        </dl>
		    </div>
		</div>
		
		<!-- 2018-12-24 김보혜 멀티로그인으로 인해 강제 로그아웃 됐을 시 알림 레이어 팝업 -->
		<div id="exDiv4" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:20px">
				<p style="border:0px" id="imgMnt3"></p>
		        <dl>
					<dt id="layerTitle1" class="layerTitle"><spring:message code="ezSystem.kbh01" /></dt>
		            <dd><spring:message code="ezSystem.kbh02" /></dd>
		            <dd><spring:message code="ezSystem.kbh03" /></dd>
		        </dl>
		    </div>
		</div>
		
		<!-- 2019-08-12 홍대표 정지된 사용자를 알리는 레이어 팝업 -->
		<div id="exDiv5" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:80px">
				<p style="border:0px; padding-left: 30px;" id="imgMnt4"></p>
		        <dl style="margin-top: 23px; margin-left: 50px;">
					<dt id="layerTitle1" class="layerTitle"><spring:message code="ezOrgan.hdp14" /></dt>
		            <dd><spring:message code="ezOrgan.hdp15" /></dd>
		            <dd><spring:message code="ezOrgan.hdp16" /></dd>
		        </dl>
		    </div>
		</div>
		
		<div id="exDiv6" style="display:none;margin-bottom:100px;padding:15px;max-width:none;width:700px;">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>			
			<div class="password_reset" style="width:660px;">
				<p class="passwordTitle" style="border-bottom:0px">
					<spring:message code="login.zno025" />
				</p>
				<ul class="passwordForm">
					<li style="margin-bottom:0px;" class="redText">▒ <spring:message code="login.zno006" /></li>
					<li class="redText">▒ <spring:message code="login.zno007" /></li>
					<table class="mainlist" style="width: 100%; ">
					<tbody>
						<tr>
							<th style="text-align: center;width: 35%;">1. <spring:message code="login.zno008" /></th>
							<td>
								<input type="text" id="sabun" style="width: 160px;" value="">
								<span style="color: #8e8e8e;"><spring:message code="login.zno009" /></span><br/>
								<a class="imgbtn" onclick="sendFindPwd();" style="margin-top:8px; background-color: #f1f3f5">
									<span><spring:message code="login.zno010" /></span>
								</a>
								<span style="color: #8e8e8e; top:10px; letter-spacing: -1px;">▒ <spring:message code="login.zno011" /></span>
							</td>
						</tr>
						<tr>
							<th style="text-align: center;width: 35%;">2. <spring:message code="login.zno012" /></th>
							<td>
								<input type="text" id="certificationNum" style="width: 160px;" value="">
								<span style="color: #8e8e8e;"><spring:message code="login.zno013" /></span><br/>
								<a class="imgbtn" onclick="checkCertification();" style="margin-top:8px; background-color: #f1f3f5">
									<span><spring:message code="login.zno012" /></span>
								</a>
								<span style="color: #8e8e8e; top:10px; letter-spacing: -1px;">▒ <spring:message code="login.zno014" /></span>
							</td>
						</tr>
						<tr>
							<th style="text-align: center;width: 35%;">3. <spring:message code="login.zno015" /></th>
							<td>
								<input type="password" id="certificationPwd" style="margin-bottom:8px; width: 160px;" value="">
								<span style="color: #8e8e8e;"><spring:message code="ezPersonal.t950" /></span><br/>
								<input type="password" id="certificationPwdRe" style="width: 160px;" value="">
								<span style="color: #8e8e8e;"><spring:message code="ezPersonal.t951" /></span><br/>
								<span id="div6_PwPolicyExplain" style="color: #8e8e8e; top:10px; letter-spacing: -2.1px;"></span>
								<br>
								<a class="imgbtn" onclick="changePasswordByCertification()" style="margin-top:8px; background-color: #f1f3f5">
									<span><spring:message code="ezCircular.t25"/></span>
								</a>
							</td>
						</tr>
					</tbody>
				</table>
				</ul>
			</div>
		</div>

		<%-- 2023-03-23 이사라 - OTP 오류 시 레이어팝업 출력 --%>
		<div id="exDiv7" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap" style="padding-left:20px">
		    	<p style="border:0px" id="imgMnt7"></p>
		        <dl>
		        	<dt>${message1}</dt>
		        	<br>
		            <dd>${message2}</dd>
		            <c:choose>
                        <c:when test="${useOTP}">
							<dd><spring:message code='fail.common.login.otp.warning2'/></dd>
						</c:when>
                        <c:otherwise>
	                        <dd><spring:message code='fail.common.login.warning6'/></dd>
                        </c:otherwise>
                     </c:choose>
		        </dl>
			</div>
		</div>
		
		<%-- 2023-03-23 이사라 - OTP 셋업 레이어팝업 출력 --%>
		<div id="exDiv8" style="display:none;max-width:620px;padding-top:27px;margin-bottom:100px">
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span></span></a></li>
	            </ul>
	        </div>
			<div class="warning_wrap otp_qr" style="padding-left:">
		        <dl>
		        	<dt><spring:message code='login.ls001' /></dt>
		        	<br>
		            <dd><spring:message code='login.ls002' /></dd>
		            <dd><spring:message code='login.ls003' /></dd>
		            <dd>
		            	<br>
		            	<span id=otpkey style='font-size: 13px; letter-spacing: 0.7px'></span>
		            </dd>
		            <dd><span id=qr></span></dd>
		        </dl>
			</div>

			<!-- 2023-07-10 김혜지 세션 만료시 알림 레이어 팝업 -->
			<div id="exDiv9" style="display:none;max-width:620px;height:190px;padding-top:27px;margin-bottom:100px">
				<div id="close">
					<ul>
						<li><a rel="modal:close"><span></span></a></li>
					</ul>
				</div>
				<div class="warning_wrap">
					<p style="border:0px; padding-left: 10px;" id="imgMnt9"></p>
					<dl>
						<dt id="layerTitle9" class="layerTitle" style="width: 346.38px"><spring:message code="ezOrgan.hj01" /></dt>
						<dd><spring:message code="ezOrgan.hj02" /></dd>
					</dl>
				</div>
			</div>

			<div id="exDiv10" style="display:none;max-width:730px;height:190px;padding-top:27px;margin-bottom:100px">
				<div id="close">
					<ul>
						<li><a rel="modal:close"><span></span></a></li>
					</ul>
				</div>
				<div class="warning_wrap" style="margin:10px 0px 10px 27px; width:680px;">
					<p style="border:0px" id="imgMnt10"></p>
					<dl style="margin:-108px 0px 0px 150px;">
						<dt>${message1}</dt>
						<br>
						<dd>${message2}</dd>
						<c:choose>
							<c:when test="${useOTP}">
								<dd><spring:message code='fail.common.login.otp.warning2'/></dd>
							</c:when>
							<c:otherwise>
								<dd><spring:message code='fail.common.login.warning6'/></dd>
							</c:otherwise>
						</c:choose>
					</dl>
				</div>
			</div>
			<!-- 2025.04.08 김승연 조직 정보 변경 시 알림 레이어 팝업-->
			<div id="exDiv11" style="display:none;max-width:690px;height:190px;padding-top:27px;margin-bottom:100px">
				<div id="close">
					<ul>
						<li><a rel="modal:close"><span></span></a></li>
					</ul>
				</div>
				<div class="warning_wrap" style="padding-left:20px">
					<p style="border:0px" id="imgMnt11"></p>
					<dl>
						<dt id="layerTitle11" class="layerTitle"><spring:message code="ezOrgan.sy01" /></dt>
						<dd><spring:message code="ezOrgan.sy02" /></dd>
					</dl>
				</div>
			</div>
			</div>
		</div>
	</body>
</html>
