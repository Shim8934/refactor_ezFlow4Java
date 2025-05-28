<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
    <head>
        <title><spring:message code="login.kdh013"/></title>
    
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" >
        <link href="${util.addVer('/css/login.css')}" rel="stylesheet" type="text/css" />
        <link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
    
        <script type="text/javascript">
            var timerCount = 180;
            var isSend = false;
            var timer;
            var limit = 180;
            var mobileNo = "${mobileNo}";
            var loginId = "${cn}";
            var useShowAuthCode = ${useShowAuthCode};

            function fnInit () {
                makeRightsYearString();
            }
    
            history.pushState(null, null, location.href);
            window.onpopstate = function (event) {
                history.go(1);
            }
    
            //인증번호 등록
            function doOk() {
                var fm = document.forms[0];
                var sCertNum = fm.CertNum.value;
    
                if (sCertNum == "") {
                    alert('<spring:message code="login.kdh014"/>');
                    return;
                }
    
                if (sCertNum != document.getElementById("authCode").value) {
                    alert('<spring:message code="login.zno017"/>');
                    return;
                }

                $.ajax({
                    type:"POST",
                    dataType:"text",
                    url:"/user/login/resetPw/sendAuthCodeBySMS.do",
                    async : false,
                    data:{
                        type : "tempPW",
                        cn : loginId,
                        mobileNo : mobileNo
                    },
                    success: function(result){

                        if (result === 'ERROR') {
                            alert('<spring:message code="login.kdh015"/>');
                            return;
                        } else {
                            alert('<spring:message code="login.kdh016"/>');
                            if (useShowAuthCode) {
                                document.getElementById("authCode").value = result;
                                alert(result);
                            }
                            doClose();
                        }

                    }
                });
            }
    
    
            function doClose() {
                window.location.href = "/user/login/login.do";
            }
    
            //인증번호 요청
            function requestCertNum() {
                var url = "";
    
                if (mobileNo === "") {
                    alert('<spring:message code="login.kdh017"/>');
                    return;
                } else if (isSend) {
                    alert('<spring:message code="login.kdh018"/>');
                    return;
                }
                
                $.ajax({
                    type:"POST",
                    dataType:"text",
                    url:"/user/login/resetPw/sendAuthCodeBySMS.do",
                    async : false,
                    data:{
                        type : 'authCode',
                        cn : loginId,
                        mobileNo : mobileNo
                    },
                    success: function(result){
                        
                       if (result === 'ERROR') {
                           alert('<spring:message code="login.kdh019"/>');
                           return;
                       }else if (result === 'FAIL') {
                           alert('<spring:message code="login.kdh020"/>');
                           return;
                       } else {
                           if (useShowAuthCode) {
                               document.getElementById("authCode").value = result;
                           }
                           alert('<spring:message code="login.kdh021"/>');
                           isSend = true;
                           timerCheck();
                       }
                       
                    }
                });
                if (isSend) {
                    timer = setInterval(timerCheck, 1000);
                }
            }

            //타이머
            function timerCheck() {
                limit = limit - 1;
                var min = parseInt(limit / 60);
                var sec = limit % 60;
                document.getElementById("remainTime").style.display='block';
                if (min != 0) {
                    document.getElementById("remainTime").innerHTML = "&nbsp;<spring:message code="login.kdh022"/> : " + min + '<spring:message code="ezAttitude.t19"/> ' + sec + '<spring:message code="ezEmail.t182"/>';
                } else if (min == 0 && limit > 0) {
                    document.getElementById("remainTime").innerHTML = "&nbsp;<spring:message code="login.kdh022"/> : " + sec + '<spring:message code="ezEmail.t182"/>';
                } else {
                    clearInterval(timer);
    
                    limit = 180;
                    isSend = false;
                    document.getElementById('authCode').value = '';
                    document.getElementById("remainTime").innerHTML = "";
                    document.getElementById("remainTime").style.display='none';
                }
            }
    
            function key_press() {
                if (window.event.keyCode == "13")
                    doOk();
            }

            /* 2021-04-09 홍승비 - 로그인 페이지의 연도 자동 업데이트 */
            function makeRightsYearString() {
                var date = new Date();
                var year = date.getFullYear();
                var rightsYearString = "ⓒ 2000-" + year + ". KAONi Co., Ltd. All rights reserved.";

                document.getElementById("rightsYearP").innerText = rightsYearString;
            }

            function clearInput(obj){
                obj.addEventListener("click",function(){
                    var clearObj = $(obj).prev();
                    clearObj.val("");
                    clearObj.attr("class","focus");
                    clearObj.focus();
                })
            }

            $(document).ready(function(){
                $(".input_wrap > input").on({
                    focus : function(){
                        $(this).addClass("focus");
                    },
                    blur : function(){
                        if($(this).val().length == 0){
                            $(this).removeClass("focus")
                        }
                    }
                })
            })
        </script>
    </head>
    <body class="login_body password_reset" onload="fnInit()">
        <div class="login_wrapper">
            <div class="login_backImg"></div>
            <div class="right_wrap">
                <div class="login_layout">
                    <c:if test="${useShowAuthCode eq 'true'}">
                        <div id="authCode_wrapper"><input name="authCode" id="authCode" value=""> : <spring:message code="login.kdh023"/></div>
                    </c:if>

                    <div class="login_form">
                        <form style="display: inherit;" id="" name="" method="post">
                            <p class="logo">
                                <spring:message code="login.kdh013"/>
                            </p>
                            <fieldset>
                                <!-- 로그인화면 -->
                                <div class="web_login_wrap" style="display: block;">
                                    <p class="input_wrap">
                                        <input id="userName" class="input_text" type="text" placeholder='<spring:message code="ezStatistics.t1015"/> ' value="${userName}" disabled="disabled">
                                    </p>
                                    <p class="input_wrap">
                                        <input id="mobileNo" class="input_text" type="text" placeholder='<spring:message code="ezEmail.t99000046"/> ' value="${mobileNo}" disabled="disabled">
                                    </p>
        
                                    <ul class="newBtn">
                                        <li class="ok" onclick="requestCertNum()"><spring:message code="login.zno008"/></li>
                                        <li onclick="doClose()"><spring:message code="main.t135"/></li>
                                    </ul>
                                    <span class="time_mes" id="remainTime" style="display: none;"></span>
                                    <div class="confirmBox">
                                        <p class="input_wrap">
                                            <input id="authcodeCheck" name="CertNum" class="input_text" type="text" onkeypress="key_press();" placeholder='<spring:message code="login.zno013"/>'>
                                            <span class="btnClear" id="" onclick="clearInput(this)"></span>
                                        </p>
                                        <p class="btn" onclick="doOk()"><spring:message code="main.t4008"/></p>
                                    </div>
                                </div>
                            </fieldset>
                        </form>
                    </div>
                </div>
                <div class="login_img">
                    <div class="login_img_text">
                        <p class="img_title"><spring:message code="login.kdh004"/></p>
                        <ol>
                            <li><spring:message code="login.kdh024"/></li>
                            <li><spring:message code="login.kdh025"/></li>
                            <li><spring:message code="login.kdh026"/></li>
                            <li class="point"><spring:message code="login.kdh027"/><br/><spring:message code="login.kdh028"/></li>
                        </ol>

                    </div>
                </div>
                <div class="copy"><p id="rightsYearP"></p></div>
            </div>
        </div>
    </body>
</html>