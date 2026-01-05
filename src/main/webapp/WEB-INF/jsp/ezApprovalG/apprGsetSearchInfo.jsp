<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1325'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfo_Cross.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var lastdate = "<c:out value='${monthEndDay}'/>";
		    var initdate = "<c:out value='${initDate}'/>";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";								
		    arr_userinfo[1]  = "<c:out value='${userInfo.id}'/>";              
		    arr_userinfo[2]  = "<c:out value='${userInfo.displayName}'/>";         
		    arr_userinfo[3]  = "<c:out value='${userInfo.title}'/>";               
		    arr_userinfo[4]  = "<c:out value='${userInfo.deptID}'/>";              
		    arr_userinfo[5]  = "<c:out value='${userInfo.deptName}'/>";            
		    arr_userinfo[6]  = "<c:out value='${userInfo.jikChek}'/>";                         
		    arr_userinfo[8]  = "<c:out value='${userInfo.email}'/>";               
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value='${userInfo.displayName1}'/>";		
		    arr_userinfo[12]  = "<c:out value='${userInfo.displayName2}'/>";		
		    arr_userinfo[13]  = "<c:out value='${userInfo.title1}'/>";				
		    arr_userinfo[14]  = "<c:out value='${userInfo.title2}'/>";				
		    arr_userinfo[15]  = "<c:out value='${userInfo.deptName1}'/>";			
		    arr_userinfo[16]  = "<c:out value='${userInfo.deptName2}'/>";		
		    var ReturnFunction;
		    var Type = "<c:out value='${type}'/>";
		    var ReturnFunction;
		    var approvalFlag = "<c:out value='${approvalFlag}'/>";
		    var openPageInfo;
		    window.onload = function () {
		        try {
		            if (isParentCommonArgsUsed()) {
						openPageInfo = opener == null ? parent.ezCommon_cross_dialogArguments[0] : opener.ezCommon_cross_dialogArguments[0];
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					} else {
						openPageInfo = parent.setsearchinfo_cross_dialogArguments[0];
						ReturnFunction = parent.setsearchinfo_cross_dialogArguments[1];
					}
		        } catch (e) {
		            try {
		            	openPageInfo = opener.setsearchinfo_cross_dialogArguments[0];
		                ReturnFunction = opener.setsearchinfo_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("DocNumber"));
		            KeEventControl(document.getElementById("DocTitle"));
		            KeEventControl(document.getElementById("drafter"));
		            KeEventControl(document.getElementById("drafterdept"));
		        }
		        UserID = arr_userinfo[1];
		
		        if (Type == "APR") {
		            document.getElementById("displayTR1").style.display = "none";
		            document.getElementById("displayTR2").style.display = "none";
		            //2018-09-10 이효진 진행중페이지에서 검색 시 문서번호 숨김
		            document.getElementById("displayTR3").style.display = "none";
		            //window.resizeBy(0, -60);
					if (approvalFlag == "S") {
			            window.resizeTo(600, 400);
					} else {
						if (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) {
			            	window.resizeTo(600, 400);
						} else {
			            	window.resizeTo(600, 400);
						}
					}
		        } else {
		        	if (approvalFlag == "S"){
							resizeTo(600,445);
					} else {
						if (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) {
							resizeTo(600,445);
						}
					}
				}
				if (openPageInfo == "usercontlist") {
					$("#displayTR2").css("display", "none");
					//등록일자
					//$("#Sdatepickerapr").parent().siblings("th").text("<spring:message code='ezApprovalG.t831'/>");
					$("#Sdatepickerapr").parent().siblings("th").text("<spring:message code='ezApprovalG.bhs01'/>");
					window.resizeTo(510, 450);
				}
				
		        reset_onclick();
		        Submit3.focus();
		        
		        //엔터키 눌렀을때도 검색 실행
		        $("input[type=text]").attr("onkeyup", "enterkey(event)");
		    };
		    $(function () {
		        $("#Sdatepickerapr").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerapr").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Sdatepickerend").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerend").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Sdatepickerapp").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerapp").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Sdatepickerrec").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerrec").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		    });
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		     var monthStr = monthMsg.split(";");     
		     var dayMsg = "<spring:message code='ezSchedule.t108' />";
		     var dayStr = dayMsg.split(";");
		    
		     $(function () {
		         $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		          closeText: "<spring:message code='main.t3' />",
		             prevText: "<spring:message code='main.t0604' />",
		             nextText: "<spring:message code='main.t0605' />",
		             currentText: "<spring:message code='main.t0606' />",
		             monthNames: monthStr,
		             monthNamesShort: monthStr,
		             dayNames: dayStr,
		             dayNamesShort: dayStr,
		             dayNamesMin: dayStr,
		             weekHeader: 'Wk',
		             dateFormat: 'yy-mm-dd',
		             firstDay: 0,
		             isRTL: false,
		             duration: 200,
		             showAnim: 'show',
		             showMonthAfterYear: true
		         };
		         $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		     });

		 

		
		    function reset_onclick() {
		        document.getElementById("DocNumber").textContent = "";
		        document.getElementById("DocTitle").textContent = "";
		        document.getElementById("drafter").textContent = "";
		        document.getElementById("FormName").textContent = "";
		        document.getElementById("EndAprYear").textContent = "";
		    }
		    
		    function btnSearch_onclick() {
		    
		        var RtnVal = new Array();
		        var chkVal = false;
		        var i;
		        var draftfrom, draftto, apprfrom, apprto, myapprfrom, myapprto, recvfrom, recvto;
		
		        draftfrom = $("#Sdatepickerapr").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        draftto = $("#Edatepickerapr").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        apprfrom = $("#Sdatepickerend").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        apprto = $("#Edatepickerend").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        myapprfrom = $("#Sdatepickerapp").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        myapprto = $("#Edatepickerapp").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        recvfrom = $("#Sdatepickerrec").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        recvto = $("#Edatepickerrec").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		
		        //2018-10-11 김보미 - 시작일자, 종료일자중 하나만 지정했을 경우 나머지 일자 입력하게끔 알림창 뜨게
		        if (draftfrom != "" && draftto == "" && openPageInfo != "usercontlist") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.kbm02'/>");
		        	return;
		        } else if (draftfrom == "" && draftto != "" && openPageInfo != "usercontlist") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.kbm01'/>");
		        	return;
		        }
		        
		        if (draftfrom != "" && draftto == "" && openPageInfo == "usercontlist") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.psb02'/>");
		        	return;
		        } else if (draftfrom == "" && draftto != "" && openPageInfo == "usercontlist") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.psb01'/>");
		        	return;
		        }
		        
		        if (apprfrom != "" && apprto == "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.kbm04'/>");
		        	return;
		        } else if (apprfrom == "" && apprto != "" ) {
		        	OpenAlertUI("<spring:message code='ezApprovalG.kbm03'/>");
		        	return;
		        }
		        
		        if (myapprfrom != "" && myapprto == "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.kbm06'/>");
		        	return;
		        } else if (myapprfrom == "" && myapprto != "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.kbm05'/>");
		        	return;
		        }
		       
		        if (recvfrom != "" && recvto == "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.psb08'/>");
		        	return;
		        } else if (recvfrom == "" && recvto != "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.psb07'/>");
		        	return;
		        }
		       
			        if (draftfrom != "" && draftto != "" && openPageInfo != "usercontlist") {
			            if (draftfrom > draftto) {
			                OpenAlertUI("<spring:message code='ezApprovalG.psb03'/>");
			                return;
			            }
			        }
			        
			        if (draftfrom != "" && draftto != "" && openPageInfo == "usercontlist") {
			            if (draftfrom > draftto) {
			                OpenAlertUI("<spring:message code='ezApprovalG.psb06'/>");
			                return;
			            }
			        }
			
			        if (apprfrom != "" && apprto != "") {
			            if (apprfrom > apprto) {
			                OpenAlertUI("<spring:message code='ezApprovalG.psb04'/>");
			                return;
			            }
			        }
			
			        if (myapprfrom != "" && myapprto != "") {
			            if (myapprfrom > myapprto) {
			                OpenAlertUI("<spring:message code='ezApprovalG.psb05'/>");
			                return;
			            }
			        }
			        
			        if (recvfrom != "" && recvto != "") {
			            if (recvfrom > recvto) {
			                OpenAlertUI("<spring:message code='ezApprovalG.psb09'/>");
			                return;
			            }
			        }
			        
			     if (approvalFlag == 'G' && Type != "usercontlist") {
			        draftfrom = draftfrom.split("-");
			        draftto = draftto.split("-");
			        apprfrom = apprfrom.split("-");
			        apprto = apprto.split("-");
			        myapprfrom = myapprfrom.split("-");
			        myapprto = myapprto.split("-");
			        RtnVal[0] = DocNumber.value;
			        RtnVal[1] = DocTitle.value;
			        RtnVal[2] = drafter.value;
			        RtnVal[3] = draftfrom[0];
			        RtnVal[4] = draftfrom[1];
			        RtnVal[5] = draftfrom[2];
			        RtnVal[6] = draftto[0];
			        RtnVal[7] = draftto[1];
			        RtnVal[8] = draftto[2];
			        RtnVal[9] = apprfrom[0];
			        RtnVal[10] = apprfrom[1];
			        RtnVal[11] = apprfrom[2];
			        RtnVal[12] = apprto[0];
			        RtnVal[13] = apprto[1];
			        RtnVal[14] = apprto[2];
			        RtnVal[15] = myapprfrom[0];
			        RtnVal[16] = myapprfrom[1];
			        RtnVal[17] = myapprfrom[2];
			        RtnVal[18] = myapprto[0];
			        RtnVal[19] = myapprto[1];
			        RtnVal[20] = myapprto[2];
			
			        if (document.getElementsByName("FormName")[0].id == "FormName") {
			            document.getElementsByName("FormName")[0].id = "";
					}
					// 2021-01-14 폼이름 검색으로 변경 - 박기범
			        // RtnVal[21] = document.getElementsByName("FormName")[0].id;
			        RtnVal[21] = document.getElementsByName("FormName")[0].value;
			        RtnVal[22] = EndAprYear.value;
			        RtnVal[23] = drafterdept.value;

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
					 		RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}
					
					if (window.opener && (opener.pListTypeValue == '4' || opener.pListTypeValue == '97')) {
						 RtnVal[25] = recvfrom;
						 RtnVal[26] = recvto;
						 RtnVal[27] = document.getElementById("sendDept").value;
						 RtnVal[28] = document.getElementById("recDept").value;
						 
						 for (i = 0; i < RtnVal.length; i++) {
							 if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
								 chkVal = true;
								 break;
							 }
						 }
					 } else {
						 for (i = 0; i < 25; i++) {
							 if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
								 chkVal = true;
								 break;
							 }
						 }
					 }
		        } else {
		        	if (draftfrom != "")
		                draftfrom = draftfrom ;
		            else draftfrom = "";

		            if (draftto != "")
		                draftto = draftto ;
		            else draftto = "";

		            if (apprfrom != "")
		                apprfrom = apprfrom + " 00:00:01";
		            else apprfrom = "";

		            if (apprto != "")
		                apprto = apprto + " 23:59:59";
		            else apprto = "";

		            if (myapprfrom != "")
		                myapprfrom = myapprfrom + " 00:00:01";
		            else myapprfrom = "";

		            if (myapprto != "")
		                myapprto = myapprto + " 23:59:59";
		            else myapprto = "";
		            
		            if (recvfrom != "")
		            	recvfrom = recvfrom + " 00:00:01";
		            else recvfrom = "";

		            if (recvto != "")
		            	recvto = recvto + " 23:59:59";
		            else recvto = "";

		            RtnVal[0] = document.getElementById("DocNumber").value;
		            RtnVal[1] = document.getElementById("DocTitle").value;
		            RtnVal[2] = document.getElementById("drafter").value;
		            RtnVal[3] = draftfrom;
		            RtnVal[4] = draftto;
		            RtnVal[5] = apprfrom;
		            RtnVal[6] = apprto;
		            RtnVal[7] = myapprfrom;
		            RtnVal[8] = myapprto;
					// 2021-01-14 폼이름 검색으로 변경 - 박기범
		            // RtnVal[9] = document.getElementById("formid").value;
		            RtnVal[9] = document.getElementsByName("FormName")[0].value;
		            RtnVal[10] = document.getElementById("EndAprYear").value;
		            RtnVal[11] = document.getElementById("drafterdept").value;

		            RtnVal[12] = "";
		            RtnVal[13] = "";
		            RtnVal[25] = recvfrom;

					 // 2021-03-15 키워드 검색 추가 - 박기범
					 if (document.getElementById("keyword").value != "") {
						 if (Type === "APR") {
							 RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						 } else {
							 RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						 }
					 }

		            RtnVal[26] = recvto;
		            RtnVal[27] = document.getElementById("sendDept").value;
		            RtnVal[28] = document.getElementById("recDept").value;

// 		            if (document.getElementById("tbItemCode").value != "") {
// 		                if (SearchType != "APR") {
// 		                    RtnVal[12] += "CAPR;";

// 		                }
// 		                else {
// 		                    RtnVal[12] += "CEND;";
// 		                }

// 		                RtnVal[13] += "<ITEMCODE>" + document.getElementById("tbItemCode").value + "</ITEMCODE>";

// 		            }

		            for (i = 0; i < 29; i++) {
		                if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
		                    chkVal = true;
		                    break;
		                }
		            }

// 		            RtnVal = SearchDateXML(RtnVal);

		        }
		        if (!chkVal) {
		            RtnVal = "";
		            OpenAlertUI("<spring:message code='ezApprovalG.t1329'/>");
		        }
		        else {
// 		            if (ReturnFunction != null)
// 		                ReturnFunction(RtnVal);
// 		            else
// 		                window.returnValue = RtnVal;
// 		            window.close();
					btnClose_onclick(RtnVal);
		        }
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		
// 		    function btncancel_onclick() {
// 		    	 if (ReturnFunction != null)
// 		             ReturnFunction(false);
// 		         else
// 		             window.returnValue = false;
// 		        window.close();
// 		    }
		    
		    // var getformcont_cross_dialogArguments = new Array();
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		        parameter[0] = arr_userinfo[4];
		        parameter[1] = "999";
		
		        // getformcont_cross_dialogArguments[0] = parameter;
		        // getformcont_cross_dialogArguments[1] = btn_FormSelect_onclick_Complete;
		
		        // 기존 문서검색 창 url
 		        // var url = "/ezApprovalG/getFormCont.do";
		        var url = "/ezApprovalG/getMiniFormCont.do";
		        var feature = "status:no;dialogWidth:490px;dialogHeight:340px;edge:sunken;scroll:no";
		        feature = feature + GetShowModalPosition(490, 340);
		
		        // getformcont_Cross_OpenWin = window.open(url, "getformcont_Cross", GetOpenWindowfeature(715, 570));
		        // try { getformcont_Cross_OpenWin.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = parameter;
				showPopup(url, 490, 340, "getformcont_Cross", GetOpenWindowfeature(490, 340), btn_FormSelect_onclick_Complete);
		        //window.resizeTo(800, 650);
		        //var Positon = getPositionOpenWin(800, 650);
		        //opener.OpenWin2.moveTo(Positon[0], Positon[1]);
		        //setTimeout(function () { DivPopUpShow(713, 570, "/myoffice/ezApprovalG/formContainer/getFormCont_Cross.aspx"); }, 100);
		    }
		
		    function getPositionOpenWin(popUpW, popUpH) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = 0;
		        var top = 0;
		        var pleftpos;
		        pleftpos = parseInt(width) - popUpW;
		        heigth = parseInt(heigth) - popUpH;
		        width = parseInt(width) - pleftpos;
		        left = pleftpos / 2;
		        top = heigth / 2;
		
		        var Positon = new Array(left, top);
		
		        return Positon;
		    }
		
		    function btn_FormSelect_onclick_Complete(retVal) {
				hidePopup();
		        //window.resizeTo(530, 410)
		        //var Positon = getPositionOpenWin(530, 410);
		        //opener.OpenWin2.moveTo(Positon[0], Positon[1]);
		        //DivPopUpHidden();
		        if (approvalFlag == "G") {
			        if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
			        	document.getElementsByName("FormName")[0].id = retVal[2];
			            document.getElementsByName("FormName")[0].value = retVal[3];
			        }
		        } else {
		        	if (typeof (retVal) != "undefined" && retVal[0] != "cancel" && retVal != "") {
		                document.getElementById("formid").value = retVal[2];
		                document.getElementById("FormName").value = retVal[3];
		            }
		            DivPopUpHidden();
		        }
		    }
		    function btnToDaySearch_onclick() {
		        var RtnVal = new Array();
		        if (approvalFlag =='G') {
			        var d = new Date();
			        
			        RtnVal[0] = DocNumber.value;
			        RtnVal[1] = DocTitle.value;
			        RtnVal[2] = drafter.value;
			
			        if (Type == "APR") {
			            RtnVal[3] = d.getFullYear();
			            RtnVal[4] = (d.getMonth() + 1);
			            RtnVal[5] = d.getDate();
			            RtnVal[6] = d.getFullYear();
			            RtnVal[7] = (d.getMonth() + 1);
			            RtnVal[8] = d.getDate();
			            RtnVal[9] = "";
			            RtnVal[10] = "";
			            RtnVal[11] = "";
			            RtnVal[12] = "";
			            RtnVal[13] = "";
			            RtnVal[14] = "";
			        }
			        else {
			            RtnVal[3] = "";
			            RtnVal[4] = "";
			            RtnVal[5] = "";
			            RtnVal[6] = "";
			            RtnVal[7] = "";
			            RtnVal[8] = "";
			            RtnVal[9] = d.getFullYear();
			            RtnVal[10] = (d.getMonth() + 1);
			            RtnVal[11] = d.getDate();
			            RtnVal[12] = d.getFullYear();
			            RtnVal[13] = (d.getMonth() + 1);
			            RtnVal[14] = d.getDate();
			        }
			
			        RtnVal[15] = "";
			        RtnVal[16] = "";
			        RtnVal[17] = "";
			        RtnVal[18] = "";
			        RtnVal[19] = "";
			        RtnVal[20] = "";
			        if (document.getElementsByName("FormName")[0].id == "FormName") {
			            document.getElementsByName("FormName")[0].id = "";
			        }
			
			        // 2021-01-14 폼이름 검색으로 변경 - 박기범
			        // RtnVal[21] = document.getElementsByName("FormName")[0].id;
			        RtnVal[21] = document.getElementsByName("FormName")[0].value;
			        RtnVal[22] = EndAprYear.value;
			        RtnVal[23] = drafterdept.value;

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
							RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}

// 			        if (ReturnFunction != null)
// 			            ReturnFunction(RtnVal);
// 			        else
// 			            window.returnValue = RtnVal;
// 			        window.close();
					btnClose_onclick(RtnVal);
			    } else {
		    	  RtnVal[0] = document.getElementById("DocNumber").value;
		          RtnVal[1] = document.getElementById("DocTitle").value;
		          RtnVal[2] = document.getElementById("drafter").value;
		          RtnVal[3] = "";
		          RtnVal[4] = "";
		          RtnVal[5] = initdate.substring(0, 10) + " 00:00:01";
		          RtnVal[6] = initdate.substring(0, 10) + " 23:59:59";
		          RtnVal[7] = "";
		          RtnVal[8] = "";
		          // 2021-01-14 폼이름 검색으로 변경 - 박기범
		          // RtnVal[9] = document.getElementById("formid").value;
		          RtnVal[9] = document.getElementsByName("FormName")[0].value;
		          RtnVal[10] = document.getElementById("EndAprYear").value;
		          RtnVal[11] = document.getElementById("drafterdept").value;
		          RtnVal[12] = "";
		          RtnVal[13] = "";

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
							RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}

// 		          if (document.getElementById("keyword").value != "") {
// 		              if (SearchType != "APR") {
// 		                  RtnVal[12] += "KAPR;";
// 		              }
// 		              else {
// 		                  RtnVal[12] += "KEND;";
// 		              }
// 		              RtnVal[13] += "<KEYWORD>" + document.getElementById("keyword").value + "</KEYWORD>";
// 		          }
// 		          else {
// 		              RtnVal[12] = "";
// 		          }

// 		          if (document.getElementById("tbItemCode").value != "") {


// 		              if (SearchType != "APR") {
// 		                  RtnVal[12] += "CAPR;";

// 		              }
// 		              else {
// 		                  RtnVal[12] += "CEND;";
// 		              }

// 		              RtnVal[13] += "<ITEMCODE>" + document.getElementById("tbItemCode").value + "</ITEMCODE>";
// 		          }

// 		          RtnVal = SearchDateXML(RtnVal);

// 		          if (ReturnFunction != null) {
// 		              ReturnFunction(RtnVal);
// 		          }
// 		          else {
// 		              window.returnValue = RtnVal;
// 		          }
// 		          window.close();
				btnClose_onclick(RtnVal);
		      }
		      }
		    
		    
		    function btnWeekSearch_onclick() {
		        var RtnVal = new Array();
		        var CurrentWeek = new Array();
		        CurrentWeek = getWeek();
		
		        var sDay = makeString(2, "0", String(CurrentWeek[0].getDate()));
		        var sMonth = makeString(2, "0", String(CurrentWeek[0].getMonth() + 1));
		        var sYear = CurrentWeek[0].getFullYear();
		
		        var sDay2 = makeString(2, "0", String(CurrentWeek[1].getDate()));
		        var sMonth2 = makeString(2, "0", String(CurrentWeek[1].getMonth() + 1));
		        var sYear2 = CurrentWeek[1].getFullYear();
		        if (sMonth2 == "00") {
		            sMonth2 = "12";
		            sYear2 = String(Number(sYear2 - 1));
		        }
		
		        if (approvalFlag == 'G') {
			        RtnVal[0] = DocNumber.value;
			        RtnVal[1] = DocTitle.value;
			        RtnVal[2] = drafter.value;
			        if (Type == "APR") {
			            
			            RtnVal[3] = sYear;
			            RtnVal[4] = sMonth;
			            RtnVal[5] = sDay;
			            RtnVal[6] = sYear2;
			            RtnVal[7] = sMonth2;
			            RtnVal[8] = sDay2;
			            RtnVal[9] = "";
			            RtnVal[10] = "";
			            RtnVal[11] = "";
			            RtnVal[12] = "";
			            RtnVal[13] = "";
			            RtnVal[14] = "";
			        }
			        else {
			            RtnVal[3] = "";
			            RtnVal[4] = "";
			            RtnVal[5] = "";
			            RtnVal[6] = "";
			            RtnVal[7] = "";
			            RtnVal[8] = "";
			            RtnVal[9] = sYear;
			            RtnVal[10] = sMonth;
			            RtnVal[11] = sDay;
			            RtnVal[12] = sYear2;
			            RtnVal[13] = sMonth2;
			            RtnVal[14] = sDay2;
			        }
			        RtnVal[15] = "";
			        RtnVal[16] = "";
			        RtnVal[17] = "";
			        RtnVal[18] = "";
			        RtnVal[19] = "";
			        RtnVal[20] = "";
			        if (document.getElementsByName("FormName")[0].id == "FormName") {
			            document.getElementsByName("FormName")[0].id = "";
			        }
			        // 2021-01-14 폼이름 검색으로 변경 - 박기범
			        // RtnVal[21] = document.getElementsByName("FormName")[0].id;
			        RtnVal[21] = document.getElementsByName("FormName")[0].value;
			        RtnVal[22] = EndAprYear.value;
			        RtnVal[23] = drafterdept.value;

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
							RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}
			        
// 			        if (ReturnFunction != null)
// 			            ReturnFunction(RtnVal);
// 			        else
// 			            window.returnValue = RtnVal;
// 			        window.close();
					btnClose_onclick(RtnVal);
		        } else {
		        	 RtnVal[0] = document.getElementById("DocNumber").value;
		             RtnVal[1] = document.getElementById("DocTitle").value;
		             RtnVal[2] = document.getElementById("drafter").value;

		             RtnVal[3] = "";
		             RtnVal[4] = "";
		             RtnVal[5] = sYear + "-" + sMonth + "-" + sDay + " 00:00:01";
		             RtnVal[6] = sYear2 + "-" + sMonth2 + "-" + sDay2 + " 23:59:59";
		             RtnVal[7] = "";
		             RtnVal[8] = "";

		             // 2021-01-14 폼이름 검색으로 변경 - 박기범
		             // RtnVal[9] = document.getElementById("formid").value;
		             RtnVal[9] = document.getElementsByName("FormName")[0].value;
		             RtnVal[10] = document.getElementById("EndAprYear").value;
		             RtnVal[11] = document.getElementById("drafterdept").value;
		             RtnVal[12] = "";
		             RtnVal[12] = "";
		             RtnVal[13] = "";

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
							RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}
// 		             if (document.getElementById("keyword").value != "") {
// 		                 if (SearchType != "APR") {
// 		                     RtnVal[12] += "KAPR;";
// 		                 }
// 		                 else {
// 		                     RtnVal[12] += "KEND;";
// 		                 }
// 		                 RtnVal[13] += "<KEYWORD>" + document.getElementById("keyword").value + "</KEYWORD>";
// 		             }
// 		             else {
// 		                 RtnVal[12] = "";
// 		             }

// 		             if (document.getElementById("tbItemCode").value != "") {

// 		                 if (SearchType != "APR") {
// 		                     RtnVal[12] += "CAPR;";

// 		                 }
// 		                 else {
// 		                     RtnVal[12] += "CEND;";
// 		                 }

// 		                 RtnVal[13] += "<ITEMCODE>" + document.getElementById("tbItemCode").value + "</ITEMCODE>";
// 		             }

// 		             RtnVal = SearchDateXML(RtnVal);

// 		             if (ReturnFunction != null) {
// 		                 ReturnFunction(RtnVal);
// 		             }
// 		             else {
// 		                 window.returnValue = RtnVal;
// 		             }
// 		             window.close();
					btnClose_onclick(RtnVal);
		        }
		    }
		    function makeString(strLen, empCh, custStr) {
		        var index;
		        var szEmpty = "";
		
		        for (index = custStr.length; index < strLen; index++) {
		            szEmpty += empCh;
		        }
		        return (szEmpty + custStr);
		    }
		    function btnMonthSearch_onclick() {
		        var RtnVal = new Array();
		        var d = new Date();
		
		        var CurrentWeek = new Array();
		        CurrentWeek = getMonth();
		
		        var sDay = makeString(2, "0", String(CurrentWeek[0].getDate()));
		        var sMonth = makeString(2, "0", String(CurrentWeek[0].getMonth() + 1));
		        var sYear = CurrentWeek[0].getFullYear();
		
		        var sDay2 = makeString(2, "0", String(CurrentWeek[1].getDate()));
		        var sMonth2 = makeString(2, "0", String(CurrentWeek[1].getMonth() + 1));
		        var sYear2 = CurrentWeek[1].getFullYear();
		        if (sMonth2 == "00") {
		            sMonth2 = "12";
		            sYear2 = String(Number(sYear2 - 1));
		        }
		
		        if (approvalFlag == 'G') {
		        	RtnVal[0] = DocNumber.value;
			        RtnVal[1] = DocTitle.value;
			        RtnVal[2] = drafter.value;
			        if (Type == "APR") {
			            RtnVal[3] = sYear;
			            RtnVal[4] = sMonth;
			            RtnVal[5] = sDay;
			            RtnVal[6] = sYear2;
			            RtnVal[7] = sMonth2;
			            RtnVal[8] = sDay2;
			            RtnVal[9] = "";
			            RtnVal[10] = "";
			            RtnVal[11] = "";
			            RtnVal[12] = "";
			            RtnVal[13] = "";
			            RtnVal[14] = "";
			        }
			        else {
			            RtnVal[3] = "";
			            RtnVal[4] = "";
			            RtnVal[5] = "";
			            RtnVal[6] = "";
			            RtnVal[7] = "";
			            RtnVal[8] = "";
			            RtnVal[9] = sYear;
			            RtnVal[10] = sMonth;
			            RtnVal[11] = sDay;
			            RtnVal[12] = sYear2;
			            RtnVal[13] = sMonth2;
			            RtnVal[14] = sDay2;
			        }
			       
			        RtnVal[15] = "";
			        RtnVal[16] = "";
			        RtnVal[17] = "";
			        RtnVal[18] = "";
			        RtnVal[19] = "";
			        RtnVal[20] = "";
			
			        if (document.getElementsByName("FormName")[0].id == "FormName") {
			            document.getElementsByName("FormName")[0].id = "";
			        }
			        // 2021-01-14 폼이름 검색으로 변경 - 박기범
			        // RtnVal[21] = document.getElementsByName("FormName")[0].id;
			        RtnVal[21] = document.getElementsByName("FormName")[0].value;
			        RtnVal[22] = EndAprYear.value;
			        RtnVal[23] = drafterdept.value;

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
							RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}
			
// 			        if (ReturnFunction != null)
// 			            ReturnFunction(RtnVal);
// 			        else
// 			            window.returnValue = RtnVal;
// 			        window.close();
					btnClose_onclick(RtnVal);
		        } else {
		        	RtnVal[0] = document.getElementById("DocNumber").value;
		            RtnVal[1] = document.getElementById("DocTitle").value;
		            RtnVal[2] = document.getElementById("drafter").value;
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = sYear + "-" + sMonth + "-" + sDay + " 00:00:01";
		            RtnVal[6] = sYear2 + "-" + sMonth2 + "-" + sDay2 + " 23:59:59";
		            RtnVal[7] = "";
		            RtnVal[8] = "";

		             // 2021-01-14 폼이름 검색으로 변경 - 박기범
		             // RtnVal[9] = document.getElementById("formid").value;
		             RtnVal[9] = document.getElementsByName("FormName")[0].value;
		             RtnVal[10] = document.getElementById("EndAprYear").value;
		             RtnVal[11] = document.getElementById("drafterdept").value;
		             RtnVal[12] = "";
		             RtnVal[13] = "";

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (document.getElementById("keyword").value != "") {
						if (Type === "APR") {
							RtnVal[24] = "KAPR;" + document.getElementById("keyword").value;
						} else {
							RtnVal[24] = "KEND;" + document.getElementById("keyword").value;
						}
					}
// 		             if (document.getElementById("keyword").value != "") {
// 		                 if (SearchType != "APR") {
// 		                     RtnVal[12] += "KAPR;";
// 		                 }
// 		                 else {
// 		                     RtnVal[12] += "KEND;";
// 		                 }
// 		                 RtnVal[13] += "<KEYWORD>" + document.getElementById("keyword").value + "</KEYWORD>";
// 		             }
// 		             else {
// 		                 RtnVal[12] = "";
// 		             }

// 		             if (document.getElementById("tbItemCode").value != "") {


// 		                 if (SearchType != "APR") {
// 		                     RtnVal[12] += "CAPR;";

// 		                 }
// 		                 else {
// 		                     RtnVal[12] += "CEND;";
// 		                 }

// 		                 RtnVal[13] += "<ITEMCODE>" + document.getElementById("tbItemCode").value + "</ITEMCODE>";
// 		             }

		 			for (i = 0; i < 14; i++) {
			            if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
			                chkVal = true;
			                break;
			            }
		       		 }
// 		             RtnVal = SearchDateXML(RtnVal);

// 		             if (ReturnFunction != null) {
// 		                 ReturnFunction(RtnVal);
// 		             }
// 		             else {
// 		                 window.returnValue = RtnVal;            
// 		             }
// 		             window.close();
					btnClose_onclick(RtnVal);
		        }
		        
		    }
		    function btnItemCode_onclick() {
		        var url = "../DocNum/docnumui_Cross.aspx";
		        var retVal = window.showModalDialog(url, "", "dialogWidth:670px;dialogHeight:350px;status:no;help:no;scroll:no;edge:sunken");
		
		        if (retVal[0] != "cancel") {
		            tbItemCode.value = retVal[0];
		            tbItemName.value = retVal[1];
		        }
		    }
		    function getWeek() {
		        var szYear = initdate.substring(0, 4);
		        var szMonth = initdate.substring(5, 7);
		        var szDay = initdate.substring(8, 10);
		        var szHr = initdate.substring(11, 13);
		        var szMin = initdate.substring(14, 16);
		        var szSec = initdate.substring(17, 19);
		
		        var now = new Date(szYear, szMonth - 1, szDay, szHr, szMin, szSec);
		
		        var nowDayOfWeek = now.getDay();
		        var nowDay = now.getDate();
		        var nowMonth = now.getMonth();
		        var nowYear = now.getYear();
		        nowYear += (nowYear < 2000) ? 1900 : 0;
		
		        var RtnVal = new Array();
		        RtnVal[0] = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek);
		        RtnVal[1] = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek));
		
		        return RtnVal;
		    }
		    function getMonth() {
		        var szYear = initdate.substring(0, 4);
		        var szMonth = initdate.substring(5, 7);
		        var szDay = initdate.substring(8, 10);
		        var szHr = initdate.substring(11, 13);
		        var szMin = initdate.substring(14, 16);
		        var szSec = initdate.substring(17, 19);
		        var now = new Date(szYear, szMonth - 1, szDay, szHr, szMin, szSec);
		
		        var nowDayOfWeek = now.getDay();
		        var nowDay = now.getDate();
		
		        var nowMonth = now.getMonth();
		
		        var nowYear = now.getYear();
		        nowYear += (nowYear < 2000) ? 1900 : 0;
		
		        var RtnVal = new Array();
		        if (nowMonth <= 0)
		            RtnVal[0] = new Date(nowYear - 1, 11, nowDay);
		        else
		            RtnVal[0] = new Date(nowYear, nowMonth - 1, nowDay);
		
		        RtnVal[1] = new Date(nowYear, nowMonth, nowDay);
		
		        return RtnVal;
		    }

		    function enterkey(e) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	btnSearch_onclick();
		            }
		        }
		        else {
		            if (e.which == 13) {
		            	btnSearch_onclick();
		            }
		        }
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1325'/></h1>
		<div id="close">
            <ul>
                <li><span id="Submit4" onclick="return btnClose_onclick(false)"></span></li>
            </ul>
        </div>
		<table  class="content">
		  <tr>
		    <th ><spring:message code='ezApprovalG.t442'/></th>
		    <c:choose>
		    	<c:when test="${userInfo.lang == '1'}">
				    <td ><input type="text" id="FormName" name="FormName" style="width:200px" >
		      		<a  class="imgbtn imgbck" style="vertical-align:middle; margin-top:1.48px;"><span onClick="return btn_FormSelect_onclick()"><spring:message code='ezApprovalG.t442'/></span></a></td>
		    	</c:when>
		    	<c:otherwise>
				    <td ><input type="text" id="FormName" name="FormName" style="width:193px" >
		      		<a  class="imgbtn imgbck" style="vertical-align:middle"><span onClick="return btn_FormSelect_onclick()"><spring:message code='ezApprovalG.t442'/></span></a></td>
		    	</c:otherwise>
		    </c:choose>
		  </tr>
		  <tr id="displayTR3">
		    <th ><spring:message code='ezApprovalG.t440'/></th>
		    <td ><input type="text" id="DocNumber" name="DocNumber" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApprovalG.KMH02'/></th>
		    <td ><input type="text" id="DocTitle" name="DocTitle" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		  	<th ><spring:message code='ezApprovalG.t1200'/></th>
		  	<td ><input type="text" id="keyword" name="keyword" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		  	</td>
		  </tr>
		  <c:choose>
		  	<c:when test="${searchType eq 'recDept'}">
			  	<tr>
				    <th ><spring:message code='ezApprovalG.psb1331'/></th>
				    <td ><input type="text" id="sendDept" name="sendDept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				</tr>
				<tr>
				    <th ><spring:message code='ezApprovalG.psb1332'/></th>
				    <td ><input type="text" id="recDept" name="recDept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				</tr>
				<tr>
				    <th ><spring:message code='ezApprovalG.psb1334'/></th>
				    <td >
				        <input type="text" id="Sdatepickerrec" style="width:80px;text-align:center" readonly>&nbsp;~
				        <input type="text" id="Edatepickerrec" style="width:80px;text-align:center" readonly>
				    </td>
			 	</tr>
			 	<tr style="display:none;">
				    <th ><spring:message code='ezApprovalG.t445'/></th>
				    <td ><input type="text" id="drafter" name="drafter" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				  </tr>
				  <tr style="display:none;">
				    <th ><spring:message code='ezApprovalG.t1331'/></th>
				    <td ><input type="text" id="drafterdept" name="drafterdept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				  </tr>
				  <tr style="display:none">
				    <th ><spring:message code='ezApprovalG.t1553'/></th>
				    <td ><input type="text" id="EndAprYear" name="EndAprYear" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				  </tr>
				  <tr style="display:none;">
				    <th ><spring:message code='ezApprovalG.t1332'/></th>
				    <td >
				        <input type="text" id="Sdatepickerapr" style="width:80px;text-align:center" readonly>&nbsp;~
				        <input type="text" id="Edatepickerapr" style="width:80px;text-align:center" readonly>
				    </td>
				  </tr>
		  	</c:when>
		  	<c:otherwise>
		  		<tr style="display:none;">
				    <th ><spring:message code='ezApprovalG.psb1331'/></th>
				    <td ><input type="text" id="sendDept" name="sendDept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				</tr>
				<tr style="display:none;">
				    <th ><spring:message code='ezApprovalG.psb1332'/></th>
				    <td ><input type="text" id="recDept" name="recDept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				</tr>
				<tr style="display:none;">
				    <th ><spring:message code='ezApprovalG.psb1334'/></th>
				    <td >
				        <input type="text" id="Sdatepickerrec" style="width:80px;text-align:center" readonly>&nbsp;~
				        <input type="text" id="Edatepickerrec" style="width:80px;text-align:center" readonly>
				    </td>
			 	</tr>
				  <tr>
				    <th ><spring:message code='ezApprovalG.t445'/></th>
				    <td ><input type="text" id="drafter" name="drafter" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				  </tr>
				  <tr>
				    <th ><spring:message code='ezApprovalG.t1331'/></th>
				    <td ><input type="text" id="drafterdept" name="drafterdept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				  </tr>
				  <tr style="display:none">
				    <th ><spring:message code='ezApprovalG.t1553'/></th>
				    <td ><input type="text" id="EndAprYear" name="EndAprYear" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
				    </td>
				  </tr>
				  <tr>
				    <th ><spring:message code='ezApprovalG.t1332'/></th>
				    <td >
				        <input type="text" id="Sdatepickerapr" style="width:80px;text-align:center" readonly>&nbsp;~
				        <input type="text" id="Edatepickerapr" style="width:80px;text-align:center" readonly>
				    </td>
				  </tr>
		  	</c:otherwise>
		  </c:choose>
		    
		  <tr id="displayTR1">
		    <th ><spring:message code='ezApprovalG.t1334'/></th>
		    <td >
		        <input type="text" id="Sdatepickerend" style="width:80px;text-align:center" readonly>&nbsp;~
		        <input type="text" id="Edatepickerend" style="width:80px;text-align:center" readonly>
		    </td>
		  </tr>
		  <tr id="displayTR2">
		    <th ><spring:message code='ezApprovalG.pjj32'/></th>
		    <td >
		        <input type="text" id="Sdatepickerapp" style="width:80px;text-align:center" readonly>&nbsp;~
		        <input type="text" id="Edatepickerapp" style="width:80px;text-align:center" readonly>
		    </td>
		      </tr>
		</table>
		
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" style="padding-left: 8px"><span style="padding-right: 8px;" onClick="return btnSearch_onclick()" id="Submit3"><spring:message code='ezApprovalG.t111'/></span></a>
			<a class="imgbtn" style="padding-left: 8px"><span style="padding-right: 8px;" onClick="return btnToDaySearch_onclick()" id="Submit0"><spring:message code='ezApprovalG.t1336'/></span></a>
			<a class="imgbtn" style="padding-left: 8px"><span style="padding-right: 8px;" onClick="return btnWeekSearch_onclick()" id="Submit1"><spring:message code='ezApprovalG.t1337'/></span></a>
			<a class="imgbtn" style="padding-left: 8px"><span style="padding-right: 8px;" onClick="return btnMonthSearch_onclick()" id="Submit2"><spring:message code='ezApprovalG.t1557'/></span></a>			
		</div>
		<c:if test ="${approvalFlag =='S'}">
		<input type="text" id="formid" name="formid" style="width:1px;display:none" disabled="disabled" /> 
		</c:if>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>