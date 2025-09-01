<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1325' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var initdate = "<c:out value = '${initDate}' />";
	        var aprFlag = "<c:out value = '${aprFlag}' />";
	        var approvalFlag = "<c:out value = '${approvalFlag}' />";
	        
	        var ReturnFunction;
	        var ReturnQueryMap = new Map(); // subQuery를 대체하기 위한 맵 변수 (관리자단 전체완료문서 페이지에서만 사용)
	        
	        $(document).ready(function(){
	            if (CrossYN()) {
	                if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					} else {
						ReturnFunction = opener.ezStatisticsSearch_Cross_dialogArguments[1];
					}
	                
	                try {
						if (typeof(opener.ezStatisticsSearch_QueryMap) != "undefined" && opener.ezStatisticsSearch_QueryMap != null) {
							ReturnQueryMap = opener.ezStatisticsSearch_QueryMap;
						}
	                } catch (e) {
						if (typeof(parent.ezStatisticsSearch_QueryMap) != "undefined" && parent.ezStatisticsSearch_QueryMap != null) {
							ReturnQueryMap = parent.ezStatisticsSearch_QueryMap;
						}
					}
	            }
	            
	            var ua = navigator.userAgent;
	            
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("DocNumber"));
	                KeEventControl(document.getElementById("DocTitle"));
	                KeEventControl(document.getElementById("drafter"));
	                KeEventControl(document.getElementById("drafterdept"));
	            }
	
	            if (aprFlag == 'END') {
	                document.getElementById("ENDDATETR").style.display = "";
	                document.getElementById("DOCNUM").style.display = "";
	            } else {
	                document.getElementById("ENDDATETR").style.display = "NONE";
	                document.getElementById("DOCNUM").style.display = "NONE";
	            }
	
	            initdatepicker();
	            initdatepicker1();
	
	            reset_onclick();
	            //Submit3.focus();
	            
	            if (approvalFlag == 'S') {
	            	$(".approvalG").hide();
	            	$(".approvalS").show();
	            } else {
	            	$(".approvalG").show();
	            	$(".approvalS").hide();
	            }
	            
	            setAutoCompleteOff(); //#15157 자동완성 방지 메소드 추가
	            
	          	//엔터키 눌렀을때도 검색 실행
		        $("input[type=text]").attr("onkeyup", "enterkey(event)");
	        });
	
	        function initdatepicker() {
	        	$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true,
		            beforeShow: function(input) {
		    		    var i_offset= $(input).offset();
		    		    setTimeout(function(){
		    		       $('#ui-datepicker-div').css({'left': i_offset.left + 85});
		    		    })
		    		} 
		        });
				
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true,
		            beforeShow: function(input) {
		    		    var i_offset= $(input).offset();
		    		    setTimeout(function(){
		    		       $('#ui-datepicker-div').css({'left': i_offset.left + 85});
		    		    })
		    		} 
		        });

		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', "");

		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', "");
		        
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
		    }
	        
	        function initdatepicker1() {
	        	$("#S1datepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
				
		        $("#E1datepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });

		        $("#S1datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#S1datepicker").datepicker('setDate', "");

		        $("#E1datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#E1datepicker").datepicker('setDate', "");
		        
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
		    }
		
		    function reset_onclick() {
		        document.getElementById("DocNumber").value = "";
		        document.getElementById("DocTitle").value = "";
		        document.getElementById("drafter").value = "";
		        document.getElementById("FormName").value = "";
		        document.getElementById("Sdatepicker").value = "";
		        document.getElementById("S1datepicker").value = "";
		        document.getElementById("Edatepicker").value = "";
		        document.getElementById("E1datepicker").value = "";
		        document.getElementById("keyword").value = "";
		    }
		    
		    function btnSearch_onclick() {
		        var RtnVal = new Array();
		        var chkVal = false;
		        var i;
		        var draftfrom, draftto, apprfrom, apprto;
		
		        draftfrom = document.getElementById("Sdatepicker").value;
		        draftto = document.getElementById("Edatepicker").value;
		        apprfrom = document.getElementById("S1datepicker").value;
		        apprto = document.getElementById("E1datepicker").value;
		        
		        /* if (draftfrom != "" && draftto != "") {
		            if (draftfrom > draftto) {
		                OpenAlertUI("<spring:message code ='ezApprovalG.t1326' /><br><spring:message code ='ezApprovalG.t1327' />");
		                return;
		            }
		        }
		
		        if (apprfrom != "" && apprto != "") {
		            if (apprfrom > apprto) {
		                OpenAlertUI("<spring:message code ='ezApprovalG.t1328' /><br><spring:message code ='ezApprovalG.t1327' />");
		                return;
		            }
		        } */
		        
		        if (draftfrom != "" && draftto == "") {
		        	showAlert("<spring:message code='ezApprovalG.kbm02'/>");
		        	return;
		        } else if (draftfrom == "" && draftto != "" ) {
		        	showAlert("<spring:message code='ezApprovalG.kbm01'/>");
		        	return;
		        }
		        
		        if (apprfrom != "" && apprto == "") {
		        	showAlert("<spring:message code='ezApprovalG.kbm04'/>");
		        	return;
		        } else if (apprfrom == "" && apprto != "" ) {
					showAlert("<spring:message code='ezApprovalG.kbm03'/>");
		        	return;
		        }
		        
		        if (draftfrom != "" && draftto != "") {
		            if (draftfrom > draftto) {
						showAlert("<spring:message code='ezApprovalG.psb03'/>");
		                return;
		            }
		        }
		
		        if (apprfrom != "" && apprto != "") {
		            if (apprfrom > apprto) {
						showAlert("<spring:message code='ezApprovalG.psb04'/>");
		                return;
		            }
		        }
		        
		        if (draftfrom == "") {
		            draftfrom = "--";
		        }
		        if (draftto == "") {
		            draftto = "--";
		        }
		        if (apprfrom == "") {
		            apprfrom = "--";
		        }
		        if (apprto == "") {
		            apprto = "--";
		        }
		
		        draftfrom = draftfrom.split("-");
		        draftto = draftto.split("-");
		        apprfrom = apprfrom.split("-");
		        apprto = apprto.split("-");
		
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
		        
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
				// 2021-01-13 박기범 : 문서명(16) 조회 추가 및 문서아이디(15)검색 제거.
				// RtnVal[15] = document.getElementsByName("FormName")[0].id;
				RtnVal[15] = "";
		        RtnVal[16] = document.getElementsByName("FormName")[0].value;
		        RtnVal[17] = document.getElementById("drafterdept").value;
		        RtnVal[18] = "";
		        ReturnQueryMap.set("keyword", "");
            	ReturnQueryMap.set("itemcode", "");
		        
		        /* 2024-03-20 홍승비 - SQL Injection 제거 > 관리자 > 전체문서조회(완료문서) > 검색 쿼리를 문자열이 아닌 개별 파라미터로 전달하도록 신규 변수 추가 */
		        // 해당 검색 팝업창은 다른 관리자단 문서 조회 기능에서도 사용되므로, 기존 RtnVal[18]에 담긴 쿼리 문자열은 유지함.
		        if (keyword.value != "") {
		            RtnVal[18] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
		            ReturnQueryMap.set("keyword", document.getElementById("keyword").value);
		        }
		
		        if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
		            if (RtnVal[18] != "") {
		                RtnVal[18] = RtnVal[18] + " and ";
		            }
		            RtnVal[18] = RtnVal[18] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
		            ReturnQueryMap.set("itemcode", document.getElementsByName("tbItemCode").value);
		        }
		
		        RtnVal[19] = approvUser.value;
		
		        for (i = 0; i < 20; i++) {
		            if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
		                chkVal = true;
		                break;
		            }
		        }
		
		        if (!chkVal) {
		            RtnVal = "";
					showAlert("<spring:message code ='ezApprovalG.t1329' />");
		        } else {
		            if (CrossYN()) {
		                ReturnFunction(RtnVal);
		            } else {
		                window.returnValue = RtnVal;
		            }
		            
		            window.close();
		        }
		    }
		    
		    // var ezapralert_cross_dialogArguments = new Array();
		    // function OpenAlertUI(pAlertContent) {
		    //     if (CrossYN()) {
		    //         ezapralert_cross_dialogArguments[0] = pAlertContent;
		    //         var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		    //         try { ezAPRALERT_Cross.focus(); } catch (e) {
		    //         }
		    //     } else {
		    //         var parameter = pAlertContent;
		    //         var url = "/ezApprovalG/ezAprAlert.do";
		    //         var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		    //         var RtnVal = window.showModalDialog(url, parameter, feature);
		    //     }
		    // }
		    //
		    // function OpenAlertUI_Complete() {
		    // }
		    //
		    // function btncancel_onclick() {
		    //     window.close();
		    // }
		/*
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		        parameter[0] = arr_userinfo[4];
		        parameter[1] = "999";
		
		        var url = "getFormCont.aspx";
		        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no"
		        var retVal = window.showModalDialog(url, parameter, feature);
		
		        if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
		            document.getElementsByName("FormName")[0].id = retVal[2];
		            document.getElementsByName("FormName")[0].value = retVal[3];
		        }
		    }
		*/
		    var getformcont_cross_dialogArguments = new Array();//150709 이윤호 양식명으로 검색 추가
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		        parameter[0] = "<c:out value = '${userInfo.deptID}' />";
		        parameter[1] = "999";
		        getformcont_cross_dialogArguments[0] = parameter;
		        getformcont_cross_dialogArguments[1] = btn_FormSelect_onclick_Complete;
		        var retVal = window.open("/ezApprovalG/getFormCont.do", "", GetOpenWindowfeature(715, 580));
		    }
		
		    function btn_FormSelect_onclick_Complete(retVal) {
		        if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
		            document.getElementsByName("FormName")[0].id = retVal[2];
		            document.getElementsByName("FormName")[0].value = retVal[3];
		        }
		    }
		
		    function btnToDaySearch_onclick() {
		        var RtnVal = new Array();
		        var d = new Date();
		
		        RtnVal[0] = document.getElementById("DocNumber").value;
		        RtnVal[1] = document.getElementById("DocTitle").value;
		        RtnVal[2] = document.getElementById("drafter").value;
		
		        if (aprFlag == 'END') {
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
		        } else {
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
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = approvUser.value;
		        RtnVal[20] = "";
		        ReturnQueryMap.set("keyword", "");
            	ReturnQueryMap.set("itemcode", "");
		        
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        // 2021-01-13 박기범 : 문서명(16) 조회 추가 및 문서아이디(15)검색 제거.
				// RtnVal[15] = document.getElementsByName("FormName")[0].id;
				RtnVal[15] = "";
		        RtnVal[16] = document.getElementsByName("FormName")[0].value;
		        RtnVal[23] = document.getElementById("drafterdept").value;
		        RtnVal[24] = "";
		        
		        if (document.getElementById("keyword").value != "") {
		            RtnVal[24] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
		        } else {
		            RtnVal[24] = "";
		        }
		
		        if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
		            if (RtnVal[24] != "") {
		                RtnVal[24] = RtnVal[24] + " and ";
		            }
		            
		            RtnVal[24] = RtnVal[24] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
		        }
		        
		        if(CrossYN()) {
					ReturnFunction(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        
		        window.close();
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
		
		        RtnVal[0] = document.getElementById("DocNumber").value;
		        RtnVal[1] = document.getElementById("DocTitle").value;
		        RtnVal[2] = document.getElementById("drafter").value;
		        
		        if (aprFlag == 'END') {
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
		    	} else {
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
		        
			    RtnVal[15] = "";
			    RtnVal[16] = "";
			    RtnVal[17] = "";
			    RtnVal[18] = "";
			    RtnVal[19] = approvUser.value;
			    RtnVal[20] = "";
			    ReturnQueryMap.set("keyword", "");
            	ReturnQueryMap.set("itemcode", "");
			    
			    if (document.getElementsByName("FormName")[0].id == "FormName") {
			        document.getElementsByName("FormName")[0].id = "";
			    }
			    // 2021-01-13 박기범 : 문서명(16) 조회 추가 및 문서아이디(15)검색 제거.
				// RtnVal[15] = document.getElementsByName("FormName")[0].id;
				RtnVal[15] = "";
		        RtnVal[16] = document.getElementsByName("FormName")[0].value;
			    RtnVal[23] = document.getElementById("drafterdept").value;
			    RtnVal[24] = "";
			    
			    if (keyword.value != "") {
			        RtnVal[24] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
			    } else {
			        RtnVal[24] = "";
			    }
		
			    if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
			        if (RtnVal[24] != "") {
			            RtnVal[24] = RtnVal[24] + " and ";
			        }
			
			        RtnVal[24] = RtnVal[24] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
			    }
			    
			    if (CrossYN()) {
					ReturnFunction(RtnVal);
			    } else {
			        window.returnValue = RtnVal;
			    }
			    
			    window.close();
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
			
			    RtnVal[0] = document.getElementById("DocNumber").value;
			    RtnVal[1] = document.getElementById("DocTitle").value;
			    RtnVal[2] = document.getElementById("drafter").value;
			    
		    	if (aprFlag == 'END') {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = "";
		            RtnVal[6] = "";
		            RtnVal[7] = "";
		            RtnVal[8] = "";
		            RtnVal[9] = sYear;
		            RtnVal[10] = sMonth;
		            RtnVal[11] = "01";
		            RtnVal[12] = sYear2;
		            RtnVal[13] = sMonth2;
		            RtnVal[14] = sDay2;
		        } else {
		            RtnVal[3] = sYear;
		            RtnVal[4] = sMonth;
		            RtnVal[5] = "01";
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
		    	
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = approvUser.value;
		        RtnVal[20] = "";
		        ReturnQueryMap.set("keyword", "");
            	ReturnQueryMap.set("itemcode", "");
		
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        // 2021-01-13 박기범 : 문서명(16) 조회 추가 및 문서아이디(15)검색 제거.
				// RtnVal[15] = document.getElementsByName("FormName")[0].id;
				RtnVal[15] = "";
		        RtnVal[16] = document.getElementsByName("FormName")[0].value;
		        RtnVal[23] = document.getElementById("drafterdept").value;
		        RtnVal[24] = "";
		        
		        if (document.getElementById("keyword").value != "") {
		            RtnVal[24] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
		        } else {
		            RtnVal[24] = "";
		        }
		
		        if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
		            if (RtnVal[24] != "") {
		                RtnVal[24] = RtnVal[24] + " and ";
		            }
		
		            RtnVal[24] = RtnVal[24] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
		        }
		        
		        if (CrossYN()) {
					ReturnFunction(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        
		        window.close();
		    }
		    
			function btnItemCode_onclick() {
		        var url = "../DocNum/docnumui.aspx";
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
		        
		        if (nowMonth <= 0) {
		            RtnVal[0] = new Date(nowYear - 1, 11, nowDay);
		        } else {
		            RtnVal[0] = new Date(nowYear, nowMonth - 1, nowDay);
		        }
		        
		        RtnVal[1] = new Date(nowYear, nowMonth, nowDay);
		        return RtnVal;
		    }
		    
		  	//#15157 자동완성 방지 메소드 추가
		    function setAutoCompleteOff() {
		    	var inputAry = document.getElementsByTagName("input");
		    	for (var i = 0; i < inputAry.length; i++) {
		    		inputAry[i].setAttribute("autocomplete", "off");
		    	}
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
	    <h1><spring:message code ='ezApprovalG.t1325' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr style="display: none">
            	<th><spring:message code ='ezApprovalG.t1197' /></th>
	            <td>
	                <input type="text" name="tbItemCode" style="width: 60px" readonly="readonly">
	                <input type="text" name="tbItemName" style="width: 140px" readonly="readonly">
	                <a class="imgbtn imgbck"><span onclick="return btnItemCode_onclick()"><spring:message code ='ezApprovalG.t1197' /></span></a>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t442' /></th>
	            <td>
	                <input type="text" id="FormName" name="FormName" style="width: 200px;">
	                <a class="imgbtn imgbck"><span onclick="return btn_FormSelect_onclick()"><spring:message code ='ezApproval.t113' /></span></a>
	            </td>
	        </tr>
	        <tr id="DOCNUM" class = 'approvalG'>
	            <th><spring:message code ='ezApprovalG.t440' /></th>
	            <td>
	                <input type="text" id="DocNumber" name="DocNumber" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t1330' /></th>
	            <td>
	                <input type="text" id="DocTitle" name="DocTitle" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t445' /></th>
	            <td>
	                <input type="text" id="drafter" name="drafter" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr class = 'approvalG'>
	            <th><spring:message code ='ezApprovalG.t15000' /></th>
	            <td>
	                <input type="text" id="approvUser" name="approvUser" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t1331' /></th>
	            <td>
	                <input type="text" id="drafterdept" name="drafterdept" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t1332' /></th>
	            <td>
	                <input readonly="readonly" id='Sdatepicker' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
	                <input readonly="readonly" id='Edatepicker' type="text" style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
	            </td>
	        </tr>
	        
	        <tr id="ENDDATETR" class = 'approvalG'>
	            <th><spring:message code ='ezApprovalG.t1334' /></th>
	            <td>
	                <input readonly="readonly" id='S1datepicker' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
	                <input readonly="readonly" id='E1datepicker' type="text" style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
	            </td>
	        </tr>
	        <tr id="KEYWORDTR" style="">
	            <th><spring:message code ='ezApprovalG.t1200' /></th>
	            <td>
	                <input type="text" id="keyword" name="keyword" style="width: 100%" maxlength="50">
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="return btnSearch_onclick()"><spring:message code ='ezApprovalG.t111' /></span></a>
	        <a class="imgbtn"><span onclick="return btnToDaySearch_onclick()"><spring:message code ='ezApprovalG.t1336' /></span></a>
	        <a class="imgbtn"><span onclick="return btnWeekSearch_onclick()"><spring:message code ='ezApprovalG.t1337' /></span></a>
	        <a class="imgbtn"><span onclick="return btnMonthSearch_onclick()"><spring:message code ='ezApprovalG.t1557' /></span></a>
	    </div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
