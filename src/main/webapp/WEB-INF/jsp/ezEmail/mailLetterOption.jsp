<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<title><spring:message code='ezEmail.t353' /></title>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript">
	
			var offsetMin = "${offsetMin}";
			var individualMailUser = parseInt("${individualMailUser}");
			var shareId = '<c:out value="${shareId}"/>';
			var useSecureMail = '${useSecureMail}';
			
		    var RetValue;
		    var ReturnFunction;
		    var CancelFunction;
		    var isDivPopUp = false;
			
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', utcDate2(offsetMin));
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i', step: 10 });
		        
		     	// 현재 시간을 비교해 다음시간으로 선택.
                NowDate.setMinutes(Math.ceil((NowDate.getMinutes() + 1) / 10) * 10);

		      	$('#Stimepicker').timepicker('setTime', NowDate);
		      	$("#Stimepicker").keydown(function(event) {event.preventDefault();});
		      	
		    });
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		            closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
		            currentText: "<spring:message code='main.t0606' />",
		            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
		            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
		            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
		            weekHeader: "Wk",
		            dateFormat: "yy-mm-dd",
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: "show",
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    
		    window.onload = function () {
		        var rgParams;
		        try {
		            RetValue = parent.letteroption_cross_dialogArguments[0];
		            ReturnFunction = parent.letteroption_cross_dialogArguments[1];
		            CancelFunction = parent.letteroption_cross_dialogArguments[2];
		            isDivPopUp = true;
		            rgParams = RetValue;
		        } catch (e) {
		            try {
		                RetValue = opener.letteroption_cross_dialogArguments[0];
		                ReturnFunction = opener.letteroption_cross_dialogArguments[1];
		                CancelFunction = opener.letteroption_cross_dialogArguments[2];
		                rgParams = RetValue;
		            } catch (e) { rgParams = dialogArguments; }
		        }
		
	            document.getElementById("bodyType").value = RetValue["bodyType"];
		
		        if (rgParams["replySendTime"] == "1") {
		            document.getElementById("responseSendid").checked = true;
		        }
		        else {
		            document.getElementById("responseSendid").checked = false;
		        }
		        
		        var readTypeElement = document.getElementById("responseReadType");
		        var replyReadTime = rgParams["replyReadTime"];
		        
		        if (replyReadTime === "0") {
		            document.getElementById("responseReadid").checked = false;
		            readTypeElement.selectedIndex = "0";
		        } else {
		        	document.getElementById("responseReadid").checked = true;
		        	
			        if ("${useOnlyInnerMail}" === "YES") {
			        	readTypeElement.selectedIndex = "0";
			        } else {
			        	readTypeElement.selectedIndex = replyReadTime === "2" ? "1" : "0";			            
			        }
		        }
		
		        var tmpStr = "";
		        tmpStr = rgParams["delaySendDate"];
		        
		        if (rgParams["delaySendDate"] != "") {
		            document.getElementById("deliverySend").checked = true;
		            tmpStr = rgParams["delaySendDate"];
		            var SetDate = new Date(tmpStr.replace(/-/gi, "/"))
		            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		            $("#Sdatepicker").datepicker('setDate', SetDate);
		            $('#Stimepicker').timepicker('setTime', SetDate);
		            $('#Stimepicker').timepicker({ 'timeFormat': 'H:i', step: 10 });
		        } else {
		            document.getElementById("Stimepicker").disabled = true;
		            $("#Sdatepicker").datepicker('disable');
		        }

		        if (individualMailUser > 0) {
					if (rgParams["EachMail"] == "true") {
			            document.getElementById("eachMailSend").checked = true;
			        } else {
			            document.getElementById("eachMailSend").checked = false;
			        }
		        }

				if (rgParams["secureMail"] == "Security" || rgParams["isSecureMail"] == "true") {
					document.getElementById("chkSecureMail").checked = true;
				}
		    }
		    
		    function cancel() {
		        if (ReturnFunction != null) {
		        	// 2018.08.02 외부용 메일은 예약발송 안되게 하는 로직 삭제
		            // if (deliverySend.checked == true && RetValue["replyReadTime"] == "2") {
		            //    deliverySend.checked = false;
		            //    alert("<spring:message code='ezEmail.t354' />");
		            // }
		            if (!isDivPopUp)
		                window.close();
		            else
		                CancelFunction();
		        }
		        else
		            window.close();
		    }
		
		    function responseSend_onClick() {
	            if (document.getElementById("responseSendid").checked == true) {
	                RetValue["replySendTime"] = "1";
	            } else {
	                RetValue["replySendTime"] = "0";
	            }
		    }
		
		    function responseRead_onClick() {
		    	document.getElementById("responseReadType").disabled = !document.getElementById("responseReadid").checked;
	            /* if (document.getElementById("responseReadid").checked == true) {
	                RetValue["replyReadTime"] = document.getElementById("responseReadType").value
	                document.getElementById("responseReadid").disabled = false;
	            }
	            else {
	                RetValue["replyReadTime"] = "0";
	            } */
		    }
				    
		    function msgCCDisplay_onClick() {
	            RetValue["showMsgCC"] = msgCCDisplay.checked;
	            if (typeof (RetValue["tagMsgCC"]) != "undefined") {
	                if (msgCCDisplay.checked == true) {
	                    RetValue["tagMsgCC"].style.display = "block";

	                    if (typeof (RetValue["tagMsgCC2"]) != "undefined" && RetValue["tagMsgCC2"] != null)
	                        RetValue["tagMsgCC2"].style.display = "block";
	                }
	                else {
	                    RetValue["tagMsgCC"].style.display = "none";

	                    if (typeof (RetValue["tagMsgCC2"]) != "undefined" && RetValue["tagMsgCC2"] != null)
	                        RetValue["tagMsgCC2"].style.display = "none";
	                }
	            }
		    }
		
		    function msgBCCDisplay_onClick() {
	            RetValue["showMsgBCC"] = msgBCCDisplay.checked;
	            if (typeof (RetValue["tagMsgBCC"]) != "undefined") {
	                if (msgBCCDisplay.checked == true) {
	                    RetValue["tagMsgBCC"].style.display = "block";

	                    if (typeof (RetValue["tagMsgBCC2"]) != "undefined" && RetValue["tagMsgBCC2"] != null)
	                        RetValue["tagMsgBCC2"].style.display = "block";
	                }
	                else {
	                    RetValue["tagMsgBCC"].style.display = "none";

	                    if (typeof (RetValue["tagMsgBCC2"]) != "undefined" && RetValue["tagMsgBCC2"] != null)
	                        RetValue["tagMsgBCC2"].style.display = "none";
	                }
	            }
		    }
		
		    function GetStartDate() {
		        var pReservationTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		        pReservationTime = pReservationTime.replace(/-/gi, "/");
		        return pReservationTime;
		    }
		
		    function confirmOption() {
		    	if (document.querySelector('#bodyType').value == "1") {
		    		if (!confirm("<spring:message code='ezEmail.lhm28' />")) {
						return;
					}
		    	}
				
				RetValue["bodyType"] = document.querySelector('#bodyType').value;
		    	
	            if (document.getElementById("responseSendid").checked == true)
	                RetValue["replySendTime"] = "1";
	            else
	                RetValue["replySendTime"] = "0";
	
	            if (document.getElementById("responseReadid").checked == true) {
	                RetValue["replyReadTime"] = document.getElementById("responseReadType").value
	                document.getElementById("responseReadid").disabled = false;
	            }
	            else {
	                RetValue["replyReadTime"] = "0";
	            }
		
		        if (deliverySend.checked == true) {
		            var now = utcDate2(offsetMin);
		            var nowmonth = now.getMonth() + 1;
		            var pTime = now.getFullYear() + "/" + nowmonth + "/" + now.getDate() + " " + now.getHours() + ":" + now.getMinutes();
		            if (GetStartDate() != "" && Date.parse(GetStartDate()) <= Date.parse(pTime)) {
		                alert("<spring:message code='ezEmail.t356' />");
		                return;
		            }
		        }
		
	            if (deliverySend.checked == true) {
	                RetValue["delaySendDate"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	            }
	            else
	                RetValue["delaySendDate"] = "";
	            
	            // 2018.08.02 외부용 메일은 예약발송 안되게 하는 로직 삭제
	            // if (deliverySend.checked == true && RetValue["replyReadTime"] == "2") {
	            //    alert("<spring:message code='ezEmail.t354' />");
	            //    return;
	            // }
	            
	            if (useSecureMail === 'YES' && document.querySelector("#chkSecureMail").checked) {
	                RetValue["secureMail"] = "Security";
	            } else {
	                RetValue["secureMail"] = "Normal";
	            }
		
	            if (individualMailUser > 0) {
	            	
			        if (eachMailSend.checked == true) {
			            RetValue["EachMail"] = "true";
			        } else {
			            RetValue["EachMail"] = "false";
			        }
	            }
	            
		        if (ReturnFunction != null)
		            ReturnFunction(RetValue);
		        else
		            window.close();
		    }
		
		    /* 2023-07-21 이사라 - confirmOption 함수 내에서 처리하도록 수정, 추가로 필요한 경우가 있다면 아래 코드도 수정을 해놨으니 참고
		    function secureMail_onClick() {
	            if (document.querySelector("#chkSecureMail").checked) {
	                RetValue["secureMail"] = "Security";
	            } else {
	                RetValue["secureMail"] = "Normal";
	            }
		    }*/
		
		    function ReservedSend(obj) {
		        if (obj.checked) {
		            document.getElementById("Stimepicker").disabled = false;
		            $("#Sdatepicker").datepicker('enable');
		        } else {
		            document.getElementById("Stimepicker").disabled = true;
		            $("#Sdatepicker").datepicker('disable');
		        }
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.t353' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<h2 id="etcLang"><spring:message code='ezEmail.t358' /></h2>
		<table width="100%" class="content">
			<tr>
				<td style="line-height: 29px;">
					<spring:message code='ezEmail.t367' /> &nbsp;
					<select id="bodyType">
			            <option value="0">HTML</option>
			   		    <option value="1">PlainText</option>
			        </select>
				</td>
			</tr>
		</table>
		<h2 style="margin-top:10px"><spring:message code='ezEmail.t368' /></h2>
		<table style="width:100%;" class="content">
			<tr style="display:none">
				<td>
				    <div class="custom_checkbox">
                        <input type="checkbox" name="responseSend" value="checkbox" onClick="" id = "responseSendid"><span style="vertical-align:middle;">&nbsp;<spring:message code='ezEmail.t369' /></span>
                    </div>
				</td>
			</tr>
			<tr>
				<td>
				    <div class="custom_checkbox">
                        <input type="checkbox" name="responseRead" value="checkbox" onChange="responseRead_onClick()" id = "responseReadid"><span style="vertical-align:middle;">&nbsp;<spring:message code='ezEmail.t370' /> </span>
                        <%-- 2024-11-13 수신확인 외부용을 default로 함, 내부용/외부용 셀렉트박스 display:none 처리 --%>
                        <select style="display:none" id="responseReadType" onChange="" style="vertical-align: middle;" <c:if test="${useReceiptExternal != 'YES'}">disabled</c:if>>
                            <option value="1"><spring:message code='ezEmail.t371' /></option>
                            <c:if test="${useReceiptExternal == 'YES'}">
                            <option value="2"><spring:message code='ezEmail.t372' /></option>
                            </c:if>
                        </select>
                    </div>
				</td>
			</tr>
		</table>
		<%-- <h2 style="margin-top:10px" id="etcLang"><spring:message code='ezEmail.t748' /></h2> --%>
		<h2 style="margin-top:10px" id="etcLang"><spring:message code='ezEmail.t373' /></h2>
		<table width="100%" class="content">
			<tr class="content" style="border-top:none;width:100%;">
				<td>
				    <div class="custom_checkbox">
                        <input type="checkbox" value="1" id="deliverySend" style="margin-top: 2px;" onclick="ReservedSend(this);">&nbsp;<span style="vertical-align:middle;"> <spring:message code='ezEmail.t374' /> </span>
                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
                        <input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" readonly="readonly"/>
                    </div>
				</td>
			</tr>
			<c:if test="${useSecureMail == 'YES'}">
			<tr>
				<td>
				    <div class="custom_checkbox">
                        <input type="checkbox" name="chkSecureMail" id="chkSecureMail" onClick="secureMail_onClick()" value="checkbox">&nbsp;<span style="vertical-align:middle;"> <spring:message code='ezEmail.t749' /> </span>
                    </div>
				</td>
			</tr>
			</c:if>
			<c:if test="${individualMailUser != '0'}">	
			<tr>
				<td>
				    <div class="custom_checkbox">
                        <input type="checkbox" name="eachMailSend" style="margin-top: 2px;" id="eachMailSend" value="checkbox">&nbsp;<span style="vertical-align:middle;"> <spring:message code='ezEmail.t748' /> </span>
                    </div>
				</td>
			</tr>
			</c:if>
		</table>  
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" onClick="confirmOption()" ><span><spring:message code='ezEmail.t38' /></span></a>
		</div>
	</body>
</html>



