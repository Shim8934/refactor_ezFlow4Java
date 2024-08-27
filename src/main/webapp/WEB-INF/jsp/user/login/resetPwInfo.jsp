<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title><spring:message code="login.zno025"/></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <link href="${util.addVer('/css/login.css')}" rel="stylesheet" type="text/css" />
        <link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
        <script type="text/javascript">
            function fnInit () {
                makeRightsYearString();
            }

            /* 2021-04-09 홍승비 - 로그인 페이지의 연도 자동 업데이트 */
            function makeRightsYearString() {
                var date = new Date();
                var year = date.getFullYear();
                var rightsYearString = "ⓒ 2000-" + year + ". KAONi Co., Ltd. All rights reserved.";

                document.getElementById("rightsYearP").innerText = rightsYearString;
            }
    
    
            function doOk() {
                var loginId = document.getElementById('loginId').value;
                var userName = document.getElementById('userName').value;

                document.getElementById('error_mes_id').style.display = 'none';
                document.getElementById('error_mes_name').style.display = 'none';
    
                if (loginId == "") {
                    alert('<spring:message code="login.kdh012"/>');
                    document.getElementById('loginId').focus();
                    return;
                }
    
                if (userName == "") {
                    alert('<spring:message code="login.kdh011"/>');
                    document.getElementById('userName').focus();
                    return;
                }
    
                $.ajax({
                    type:"POST",
                    dataType:"text",
                    url:"/user/login/resetPw/checkUserInfo.do",
                    async : false,
                    data:{
                        cn : loginId,
                        userName : userName
                    },
                    success: function(result){
                        switch (result) {
                            case 'NOEXIST':
                                document.getElementById('error_mes_id').style.display = 'block';
                                break;
                            case 'DIFFNAME' :
                                document.getElementById('error_mes_name').style.display = 'block';
                                break;
                            case 'OK' :
                                window.location.href = "/user/login/resetPw/authNumberPage.do?cn=" + loginId + "&userName=" + encodeURIComponent(userName);
                                break;
                        }
                    }
                });
                
            }
    
            function doClose() {
                window.location.href = "/user/login/login.do";
            }
    
            function key_press() {
                if (window.event.keyCode == "13")
                    doOk();
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
        <div class="login_wrapper ">
            <div class="login_backImg">

            </div>
            <div class="right_wrap">
                <div class="login_layout">
                    <div class="login_form">
                        <form style="display: inherit;" id="" name="" method="post">
                        <p class="logo">
                            <spring:message code="login.zno025"/>
                        </p>
                        <fieldset>
                            <!-- 로그인화면 -->
                            <div class="web_login_wrap" style="display: block;">
                                <p class="input_wrap">
                                    <input id="loginId" name="loginId" class="input_text" type="text" placeholder='<spring:message code="ezEmail.t263"/>'>
                                    <span class="btnClear" id="" onclick="clearInput(this)"></span>
                                </p>
                                <span class="error_mes" id="error_mes_id" style="display: none;"><spring:message code="login.kdh002"/></span><!-- 아이디 입력 오류 시 display 스타일로 제어 -->
                                <p class="input_wrap">
                                    <input id="userName" name="userName" class="input_text" type="text" onkeypress="key_press();" placeholder='<spring:message code="ezPortal.t7"/>'>
                                    <span class="btnClear" id="" onclick="clearInput(this)"></span>
                                </p>
                                <span class="error_mes" id="error_mes_name" style="display: none;"><spring:message code="login.kdh003"/></span><!-- 사용자명 입력 오류 시 display 스타일로 제어 -->
    
                                <ul class="newBtn">
                                    <li class="ok" onclick="doOk()"><spring:message code="main.t4008"/></li>
                                    <li onclick="doClose()"><spring:message code="main.t135"/></li>
                                </ul>
    
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
                <div class="login_img">
                    <div class="login_img_text">
                        <p class="img_title"><spring:message code="login.kdh004"/></p>
                        <ol>
                            <li><spring:message code="login.kdh005"/></li>
                            <li><spring:message code="login.kdh006"/></li>
                            <li class="point"><spring:message code="login.kdh007"/></li>
                        </ol>

                        <p class="img_title2">※ <spring:message code="login.kdh008"/></p>
                        <dl>
                            <dt><spring:message code="login.kdh009"/></dt>
                            <dd>- <spring:message code="login.kdh010"/> ☎ 02-0000-0000</dd>
                        </dl>
                    </div>
                </div>

                <div class="copy">
                    <p id="rightsYearP"></p>
                </div>
            </div>
        </div>
    </body>
</html>