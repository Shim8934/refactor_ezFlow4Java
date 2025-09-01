<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code='ezBoard.t10100'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <style>
        table, td, th, span, input {
            outline: none;         /* 포커스 윤곽선 제거 */
            caret-color: transparent; /* 커서 숨기기 */
        }
        table tr {
            height: 27px;
        }
        td input[type="radio"] {
            vertical-align: middle;
            /*margin: 0px 4px 0px 0px;*/
        }
        #nomalType span, #randomNumType span{
            display: inline-block;
            vertical-align: middle;
            margin-right: 3px;
        }
    </style>
</head>
<body style="overflow:hidden;">
    <div class="popup" style="margin: 0px !important;">
        <h1 style="padding-top: 5px; padding-left: 15px;"><spring:message code='ezSurvey.yjh06'/></h1>
        <div id="close">
            <ul>
                <li><span onClick="close_onclick()"></span></li>
            </ul>
        </div>
        <div style="margin: 10px 15px 22px 15px;">
            <table>
                <tr>
                    <td><span><spring:message code='ezSurvey.yjh12'/></span></td>
                </tr>
                <tr>
                    <td>
                        <span id="nomalType" onclick="type_change(1)"><input type="radio" value="1" checked><span><spring:message code='ezSurvey.yjh13'/></span></span>
                        <span id="randomNumType"  onclick="type_change(2)"><input type="radio" value="2"><span><spring:message code='ezSurvey.yjh14'/></span></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="lottery1"><spring:message code='ezSurvey.yjh15'/></span>
                        <input type="number" id="lotteryCnt" class="lottery1" value="1" min="1" style="width: 50px; margin: 0px 5px;"/>
                        <span class="lottery1"><spring:message code='ezSurvey.t102'/></span>
                        <span class="lottery2" style="display: none;"><spring:message code='ezSurvey.yjh16'/></span>
                    </td>
                </tr>
            </table>
        </div>
        <div class="popup_noti_btnarea">
            <div class="btnposition">
                <input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" id="Submit1" onClick="return OK()" >
                <input type="submit"  value="<spring:message code='ezApprovalG.t119'/>" id="Submit2" onClick="return close_onclick()" >
            </div>
            <span class="bl"> </span> <span class="br"></span>
        </div>
    </div>

    <script type="text/javascript">
        var ReturnFunction;
        var dialogArguments;
        var lotteryType = 1;
        var returnVal = {
            type : lotteryType,
            cnt : 0
        };

        window.onload = function () {
            try {
                dialogArguments = parent.survey_cross_dialogArguments[0];
                ReturnFunction = parent.survey_cross_dialogArguments[1];

                $('#lotteryCnt').attr('max', parent.totalUserCnt);
                lotteryCntKeyEvent();
            } catch (e) {}
        }
        
        function OK() {
            if (lotteryType == 1) {
                var lotteryCnt = $('#lotteryCnt').val();
                if (lotteryCnt > 0 && lotteryCnt <= parent.totalUserCnt) {
                    returnVal.cnt = lotteryCnt;
                } else {
                    alert("<spring:message code='ezSurvey.yjh11'/>");
                    return;
                }
            }
            
            ReturnFunction(returnVal);
        }

        function close_onclick() {
            if (ReturnFunction != null)
                ReturnFunction();
            else
                window.close();
        }

        function type_change(type) {
            if (type == 1) {
                lotteryType = 1
                $('#nomalType').find('input').prop('checked', true);
                $('#randomNumType').find('input').prop('checked', false);
                $('.lottery1').show();
                $('.lottery2').hide();
            } else {
                lotteryType = 2
                $('#nomalType').find('input').prop('checked', false);
                $('#randomNumType').find('input').prop('checked', true);
                $('.lottery1').hide();
                $('.lottery2').show();
            }
            returnVal.type = lotteryType;
        }
        
        function lotteryCntKeyEvent() {
            var max = parent.totalUserCnt;
            
            $('#lotteryCnt').on('input', function() {
                var clean = $(this).val().replace(/[^0-9]/g, '');
                $(this).val(clean);
            });
                        
            $('#lotteryCnt').on('keyup change', function() {
               var val = $(this).val();
               if (val > max) {
                   $(this).val(max);
               } else if (val < 1) {
                   $(this).val(1);
               }
            });

            $('#lotteryCnt').on('paste', function (e) {
                e.preventDefault();
            });
        }
    </script>
</body>
</html>