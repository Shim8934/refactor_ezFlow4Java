<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t4465'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<style type="text/css">
			input {
				width: 144px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript">
			var deptid = "${deptID}";
			var userid = "${userID}";
			var startdate = "${startDate}";
			var enddate = "${endDate}";
			var orguserid = "${userInfo.id}";
			var BReason = "${bReason}";
			var gIsAppoint = "1";
			var gIsProxyUser = false;
			var proxydeptid = "${proxyDeptID}";
			var proxyuserid = "${proxyUserID}";
			var proxystartdate = "";
		    var proxyenddate = "";
		    var Roll = "${userInfo.rollInfo}";
		    var approvalFlag = "${approvalFlag}";
		    var addJobList = "${addJobList}";
		
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (startdate == "" && enddate == "") {
		            var nowDate = new Date();
		
		            $("#Sdatepicker").datepicker('setDate', nowDate);
		            $("#Edatepicker").datepicker('setDate', nowDate);
		
		            idDatepicker_Temp = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            D2_Temp = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        }
		        if (startdate != "") {
		        	var nowDate = new Date(startdate.substring(0, 4), startdate.substring(5, 7)-1, startdate.substring(8, 10), startdate.substring(11, 13), startdate.substring(14, 15));
		            var nowDate2 = new Date(enddate.substring(0, 4), enddate.substring(5, 7)-1, enddate.substring(8, 10), enddate.substring(11, 13), enddate.substring(14, 15));
		            nowDate.setMonth(nowDate.getMonth());
		            nowDate2.setMonth(nowDate2.getMonth());
		            $("#Sdatepicker").datepicker('setDate', nowDate);
		            $("#Edatepicker").datepicker('setDate', nowDate2);
		            document.getElementById("absentreason_1").value = BReason;
		            $('#TextName_1').attr('deptId', deptid);
		            $('#TextName_1').attr('userId', userid);
		            $.each($('select[id^=absentreason]:not(select[id=absentreason_1])'), function(i, item) {
		            	var proxy = $(this).attr('proxy');
		            	var proxySplit = '';
		            	var proxySpAbUsrId = '';
		            	var proxySpAbUsrNm = '';
		            	var proxySpAbDptId = '';
		            	var proxySpAbCd = '';
		            	var isSelected = false;
		            	
		            	if(proxy != undefined) {
		            		proxySplit = proxy.split(':');
		            		proxySpAbUsrId = proxySplit[0];
		            		proxySpAbUsrNm = proxySplit[1];
		            		proxySpAbDptId = proxySplit[3];
		            		proxySpAbCd = proxySplit[proxySplit.length-1];
		            		
		            		if(proxySpAbUsrId != '') {
		            			$(this).parent().parent().prev().find('input[id^=TextName_'+(i+2)+']').val(proxySpAbUsrNm);
		            			$(this).parent().parent().prev().find('input[id^=TextName_'+(i+2)+']').attr('userId', proxySpAbUsrId);
		            			$(this).parent().parent().prev().find('input[id^=TextName_'+(i+2)+']').attr('deptId', proxySpAbDptId);
		            			$(this).parent().parent().hide();
		            		} else {
		            			$.each($(this).context.options, function(j, jtem) {
			            			if($(this).val() == proxySpAbCd) {
			            				isSelected = true;
			            			}
			            		});
			            		if(isSelected) {
			            			$(this).val(proxySpAbCd).trigger('change');
			            		}
		            		}
		            	}
		            });
		            /* $.each($('tr[id^=TR_Appoint]'), function(i, item) {
		            	var deptId1 = $(this).attr("deptId");
		            	$.each($('tr[id^=TR_Appoint]'), function(j, item2) {
		            		var deptId2 = $(this).attr("deptId");
		            		if(i<j) {
		            			if(deptId1 == deptId2) {
		            				$('tr[id^=TR_Appoint_'+(j+1)+']').attr("removeTr", "Y");
		            				$('tr[id^=TR_Select_'+(j+1)+']').attr("removeTr", "Y");
		            			}
		            		}
		            	});
		            });
		            $.each($('tr[id^=TR_Appoint]'), function(i, item) {
		            	if($(this).attr("removeTr") ==  "Y") {
		            		$(this).remove();
		            		$('tr[id^=TR_Select_'+(i+1)+']').remove();
		            	}
		            });
		            $.each($('tr[id^=TR_Appoint]'), function(i, item) {
		            	$(this).attr("id", "TR_Appoint_"+(i+1));
		            });
		            $.each($('tr[id^=TR_Select]'), function(i, item) {
		            	$(this).attr("id", "TR_Select_"+(i+1));
		            }); */
		            
		            gIsAppoint = "1";
		        }
		        if (proxystartdate != "") {
		            gIsProxyUser = true;
		        }
		        Sel_Change('1');
		    };
			
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        
		    	var uploadSDate = "${startDate}";

	        	var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);

				var uploadEDate = "${endDate}";
				var eYear = uploadEDate.substring(0, 4);
				var eMonth = uploadEDate.substring(5, 7);
				var eDay = uploadEDate.substring(8, 10);
				var eHour = uploadEDate.substring(11, 13);
				var eMin = uploadEDate.substring(14, 16);
				
	        	var SDate = new Date("");
	        	SDate.setFullYear(sYear, sMonth-1, sDay);
		        SDate.setHours(sHour, sMin, 0, 0);
	        	//SDate.setHours(SDate.getHours() - 9);
	        	
	        	var EDate = new Date();
		        EDate.setFullYear(eYear, eMonth-1, eDay);
		        EDate.setHours(eHour, eMin, 0, 0);
		        
		        /* 2020-01-28 홍승비 - 데이트피커와 타임피커의 사용자 직접입력 방지 */
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
	    	   	$('#Stimepicker').timepicker();
	        	$('#Stimepicker').timepicker('setTime', SDate);
	        	$('#Stimepicker').timepicker({
	        		'timeFormat': 'H:i',
	        		'disableTextInput': true
	        	});
				$("#Stimepicker").on("focus", function(){
					$(this).trigger("blur");
				});

	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', EDate);
	        	$('#Etimepicker').timepicker();
	        	$('#Etimepicker').timepicker('setTime', EDate);
	        	$('#Etimepicker').timepicker({
	        		'timeFormat': 'H:i',
	        		'disableTextInput': true
	        	});
				$("#Etimepicker").on("focus", function(){
					$(this).trigger("blur");
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
		
			function DateFormat(obj)
			{
		 	    var yy = String(obj.getFullYear()).substring(0,4);
		 	    if (String(obj.getMonth()+1).length == 1) {
		  	    var mm = "0" + (obj.getMonth()+1); }
		 	    else {
		  	    var mm = obj.getMonth()+1;
		 	    }
		 	    if (String(obj.getDate()).length == 1) {
		  	    var dd = "0" + obj.getDate(); }
		 	    else {
		  	    var dd = obj.getDate();
		 	    }
		 	    var date = String(yy) +"-"+ String(mm) +"-"+ String(dd);
		 	    return date;
			}
			// var selectperson_cross_dialogArguments = new Array();
			var type_Complete;
			var NoneActiveX = "YES";
			function select_person(type, tagName) {
				var selectedDept = deptid;
				if (document.getElementById("deptList") != null && document.getElementById("deptList") != "undefined") {
					selectedDept = document.getElementById("deptList").value;
				}
				
			    type_Complete = type;
			    if (CrossYN() || NoneActiveX == "YES") {
			        // selectperson_cross_dialogArguments[1] = select_person_Complete;
			        // var OpenWin = window.open("/ezPersonal/selectPerson.do?type=" + type + "&dept=" + selectedDept + "&tagName=" + tagName, "SelectPerson_cross", GetOpenWindowfeature(860, 535));
			        // try { OpenWin.focus(); } catch (e) { }
					showPopup("/ezPersonal/selectPerson.do?type=" + type + "&dept=" + selectedDept + "&tagName=" + tagName, 860, 535, "SelectPerson_cross", GetOpenWindowfeature(860, 535), select_person_Complete);
			    }
			    else {
			        var rtnValue = window.showModalDialog("/ezPersonal/selectPerson.do?type=" + type + "&dept=" + selectedDept + "&tagName=" + tagName, "",
		                "dialogHeight:535px;dialogwidth:860px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(860, 535));
		
			        if (typeof (rtnValue) != "undefined" && type == "") {
			            userid = rtnValue.userId;
			            document.getElementById(rtnValue.tagName).value = rtnValue.userName;
			            deptid = rtnValue.deptId;
			        }
			        if (typeof (rtnValue) != "undefined" && type == "Proxy") {
			            proxyuserid = rtnValue.userId;
			            document.getElementById("TextProxyName").value = rtnValue.userName;
			            proxydeptid = rtnValue.deptId;
			        }
			    }
			}
			function select_person_Complete(rtnValue, tagName) {
				hidePopup();
				if (rtnValue == "cancel") {
					return;
				}
				
				if (typeof (rtnValue) != "undefined" && type_Complete == "") {
			        userid = rtnValue.userId;
                    document.getElementById(rtnValue.tagName).value = rtnValue.userName;
                    deptid = rtnValue.deptId;
			        $('#'+ rtnValue.tagName).attr('userId', userid);
		            $('#'+ rtnValue.tagName).attr('deptId', deptid);
		            $('#'+ rtnValue.tagName).parent().parent().next().hide();
			    }
			    if (typeof (rtnValue) != "undefined" && type_Complete == "Proxy") {
                    proxyuserid = rtnValue.userId;
                    document.getElementById("TextProxyName").value = rtnValue.userName;
                    proxydeptid = rtnValue.deptId;
			    }
			}
		
		    function check_enddate() {
		        if (!gIsAppoint && document.getElementById("TextName").value == "")
		            return false;
		        var initdate = "${initDate}";
		        var strCurrDate = initdate.substr(0, 10);
		        var strStartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        var strEndDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        
		        if (new Date(strCurrDate) > new Date(strStartDate)) {
		            showAlert("<spring:message code='ezPersonal.t14'/>");
		            return true;
		        } else if (new Date(strCurrDate) > new Date(strEndDate)) {
		            showAlert("<spring:message code='ezPersonal.t15'/>");
		            return true;
		        } else if (new Date() > new Date(strEndDate + "T" +$("#Etimepicker").val())) {
		        	showAlert("<spring:message code='ezPersonal.t26'/>");
    				return true;
		        } else if (strStartDate == strEndDate) {
		        	if (gIsAppoint == '1') {
		        		if (Number($("#Stimepicker").val().substring(0,2)) > Number($("#Etimepicker").val().substring(0,2))) {
			        		showAlert("<spring:message code='ezPersonal.pjj2'/>");
			        		return true;
		        		} else if (Number($("#Stimepicker").val().substring(0,2)) == Number($("#Etimepicker").val().substring(0,2))) {
		        			if (Number($("#Stimepicker").val().substring(3,5)) > Number($("#Etimepicker").val().substring(3,5))) {
		        				showAlert("<spring:message code='ezPersonal.pjj2'/>");
		        				return true;
		        			} else if  (Number($("#Stimepicker").val().substring(3,5)) == Number($("#Etimepicker").val().substring(3,5))) {
		        				showAlert("<spring:message code='ezPersonal.pjj1'/>");
		        				return true;
		        			}
		        		} else if ($("#Stimepicker").val() == $("#Etimepicker").val()) {
		        			showAlert("<spring:message code='ezPersonal.pjj1'/>");
	        				return true;
		        		}
		        	}
		        } else if ((strStartDate > strEndDate)) {
		        	showAlert("<spring:message code='ezPersonal.t26'/>");
    				return true;
		        } else {
		            return false;
		        }
		    }
		    function OK_Click() {
		        if (check_enddate()) {
		            return;
		        }
				/*
		        if (gIsAppoint != '2') {
		            
		        	if (document.getElementById("TextName").value != "" && document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>") {
		                showAlert("<spring:message code='ezPersonal.t36'/>");
		                return;
		            }
		        }
				*/
				var pProxy = "";
				var pBujae = "";
		        // 대리 결재자 지정
		        /*
		        if (document.getElementById("TextName").value != "") {
		            if (orguserid.toLowerCase() == userid.toLowerCase()) {
		                showAlert("<spring:message code='ezPersonal.t16'/>");
		                return;
		            }
		            pBujae = userid + ":" + document.getElementById("TextName").value + ":" + deptid + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + ":" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() +  " " + $('#Etimepicker').val() + ":";
		        } else if (document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>") {
		        	pBujae = "" + ":" + "" + ":" + "" + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + ":" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val() + ":" + document.getElementById("absentreason").value;
		            gIsAppoint = "2";
		        } else if($("#TextName").attr("check") == "clear") {
		        	pBujae = "";
		        	gIsAppoint = "3";
		        } else {
		            pBujae = "";
		            gIsAppoint = "4";
		        }
				*/
		        // 대리 수신 담당자 지정
		        /* if (Roll.toLowerCase().indexOf("a=1;") > -1) {
		            if (document.getElementById("TextProxyName").value != "") {
		            	pProxy = proxyuserid + ":" + document.getElementById("TextProxyName").value + ":" + proxydeptid + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + ":" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val() + ":";
		            	pProxy = proxyuserid + "|" + document.getElementById("TextProxyName").value + "|" + proxydeptid + "|" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() +"|"+ $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		                gIsAppoint = "1";
		            }
		            else
		                pProxy = "";
		        }
		        else
		            pProxy = ""; */
		        var formArray = new Array();
		        var dept = "";
		        pProxy = $('#Sdatepicker').val() + " " + $('#Stimepicker').val() + ":" + $('#Edatepicker').val() + " " + $('#Etimepicker').val();
		        
		        try {
			        $.each($('tr[id^=TR_Appoint_]'), function(i, item) {
			        	var jo = new Object();
						var proxy = '';
						var abUserId = $(this).find('input[id^=TextName_'+(i+1)+']').attr('userId');
						var abUserNm = $(this).find('input[id^=TextName_'+(i+1)+']').val();
						var abDeptId = $(this).find('input[id^=TextName_'+(i+1)+']').attr('deptId');
						var abSelect = $(this).next().find('select[id^=absentreason_'+(i+1)+']').val();
			        	
						if(abUserId == '' && abSelect == "<spring:message code='ezPersonal.t35'/>") {
							proxy = '';
						} else if(abUserId == '' && abSelect != "<spring:message code='ezPersonal.t35'/>") {
							proxy = abUserId +':' + abUserNm + ':' + abDeptId + ':' + pProxy + ':' + abSelect;
						} else {
							proxy = abUserId +':' + abUserNm + ':' + abDeptId + ':' + pProxy;
						}
			        	//proxy = 아이디 + ':' + 이름 + ':' + 부서 + pProxy;
			        	jo.count = i;
			        	jo.deptId = $(this).attr('deptId');	// 본부서,겸직부서
			        	jo.jobId = ($(this).attr('jobId') == undefined) ? $(this).attr('title') : $(this).attr('jobId');
			        	jo.proxy = proxy;
			        	
			        	formArray.push(jo);
			        });
		        } catch(e) {
		        	showAlert('<spring:message code="ezPersonal.tt16"/>');
		        }
		        
		        try {
			        dept = document.getElementById("deptList").value;
		        } catch(e) {}    
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujaeUser.do",
		    		data : {
		    				formArray : JSON.stringify(formArray)
		    				},
		    		success: function(text){
			            /*
		    			if (gIsAppoint == "1") {
			                showAlert("<spring:message code='ezPersonal.t00002'/>"); // 대리 결재자 지정
// 			                window.location.reload(false);
			            }
			            else if (gIsAppoint == "2") {
			                showAlert("<spring:message code='ezPersonal.t40'/>"); // 부재사유 설정
// 			                window.location.reload(false);
			            }
			            else if (gIsAppoint == "3") {
			                showAlert("<spring:message code='ezPersonal.t41'/>"); // 설정 해제 
// 			                window.location.reload(false);
			            }
			            else if (gIsAppoint == "4") {
			            	showAlert("<spring:message code='ezPersonal.t65'/>");// 아무것도 지정 않았을 때
			            }
			            */
			            showAlert("<spring:message code='ezPersonal.tt16'/>");
		    		},
		    		error: function(){
			            /*
		    			if (gIsAppoint == "1") {
			                showAlert("<spring:message code='ezPersonal.t37'/>");
			            }
			            else if (gIsAppoint == "2") {
			                showAlert("<spring:message code='ezPersonal.t38'/>");
			            }
			            else if (gIsAppoint == "3") {
			                showAlert("<spring:message code='ezPersonal.t39'/>");
			            }
			            else if (gIsAppoint == "4") {
			            	showAlert("<spring:message code='ezEmail.t133'/>");
			            }
			            */
			            showAlert("<spring:message code='ezPersonal.tt14'/>");
		    		}
		    	});
		        document.location.reload(true);
		    }
		
		    function Sel_Change(no)
		    {
		        if (document.getElementById("absentreason_"+no).value == "<spring:message code='ezPersonal.t35'/>") {
		            document.getElementById("TR_Appoint_"+no).style.display = "";
		        }
		        else {
		            document.getElementById("TR_Appoint_"+no).style.display = "none";
		            document.getElementById("TextName_"+no).value = "";
		            $('#TextName_'+no).attr('userId', '');
		            $('#TextName_'+no).attr('deptId', '');
		        }
		    }
		    
		    function Sel_AddJobChange() {
		        var dept = "";
		        try {
			        dept = document.getElementById("deptList").value;
		        } catch(e) {}   
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "JSON",
		    		async : false,
		    		url : "/ezPersonal/manageAddJobBujaeG.do",
		    		data : {
		    					dept   : dept
		    				},
		    		success: function(text){
		  			  deptid = text.deptID;
					  userid = text.userID;
					  startdate = text.startDate;
					  enddate = text.endDate;
					  BReason = text.bReason;
					  gIsAppoint = "1";
					  gIsProxyUser = false;
					  proxydeptid = text.proxyDeptID;
					  proxyuserid = text.proxyUserID;
					  proxystartdate = "";
				      proxyenddate = "";
				      Roll = text.userInfo.rollInfo;
				      
				      if (startdate == "" && enddate == "") {
				            var nowDate = new Date();
				
				            $("#Sdatepicker").datepicker('setDate', nowDate);
				            $("#Edatepicker").datepicker('setDate', nowDate);
				
				            idDatepicker_Temp = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				            D2_Temp = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				        }
				        if (startdate != "") {
				        	var nowDate = new Date(startdate.substring(0, 4), startdate.substring(5, 7)-1, startdate.substring(8, 10), startdate.substring(11, 13), startdate.substring(14, 15));
				            var nowDate2 = new Date(enddate.substring(0, 4), enddate.substring(5, 7)-1, enddate.substring(8, 10), enddate.substring(11, 13), enddate.substring(14, 15));
				            nowDate.setMonth(nowDate.getMonth());
				            nowDate2.setMonth(nowDate2.getMonth());
				            $("#Sdatepicker").datepicker('setDate', nowDate);
				            $("#Edatepicker").datepicker('setDate', nowDate2);
				            document.getElementById("absentreason").value = BReason;            
				            $("#TextName").val(text.textName);     
				            gIsAppoint = "1";
				            Sel_Change();
				        }
				        
				        if (proxystartdate != "") {
				            gIsProxyUser = true;
				        }
		    		}
		        });
		    }
		</script>
	</head>
	<body>
		<form id="ManageBujae" method="post">
			<br/>
			<%-- <c:if test="${approvalFlag =='G'}"> --%>
				<span class="txt">▒ <spring:message code='ezPersonal.t55' /></span><br/>
				<span class="txt">▒ <spring:message code='ezPersonal.t56' /></span><br/>
				<span class="txt">&emsp;&nbsp;<spring:message code='ezPersonal.t57' /></span><br/>
				<span class="txt">▒ <spring:message code='ezPersonal.t58' /></span><br/>
			<%-- </c:if>
			<c:if test="${approvalFlag !='G'}">
				<span class="txt">▒ <spring:message code='ezPersonal.pjj3' /></span><br/>
			</c:if> --%>
			<%-- 
				<div class="txt">
				<c:if test="${approvalFlag =='G'}">
					<div>▒&nbsp;<spring:message code='ezPersonal.t55'/></div>
					<div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.t56'/></div>
					<div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.t57'/></div>
				    <div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.t58'/></div>
			    </c:if>
			    <c:if test="${approvalFlag !='G'}">
			    	<div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.pjj3'/></div>
			    </c:if>
			</div> 
			--%>
			<table class="content" style="width:520px;margin-top:10px">
				<%-- <c:if test="${not empty addJobList}">
					<tr>
						<th><spring:message code='ezPersonal.t305'/></th>
						<td>
							<select id="deptList" onchange="return Sel_AddJobChange();">
								<option selected value="${userInfo.deptID}">${userInfo.deptName}</option>
								<c:forEach var="addJob" items="${addJobList}" varStatus="status">
									<c:if test="${userInfo.companyID == addJob.physicalDeliveryOfficeName}">
										<option value="${addJob.department}">${addJob.description}</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
				</c:if> --%>
				<tr> 
					<th><spring:message code='ezPersonal.t22'/></th>
					<td>
						<table>
							<tr>
								<td>
								<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
	           						~
	           					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="TR_Appoint_1" deptId="${userInfo.deptID}">
					<th><spring:message code='ezPersonal.t31'/></th>
					<td style="padding:3px 4px;">
						<input type="text" name="TextName_1" id="TextName_1" Width="120" value="${textName}" deptId="" userId="" ReadOnly />
						<c:choose>
							<c:when test="${userInfo.lang == 1}">
								<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsAppoint = '1';select_person('', 'TextName_1')"><spring:message code='ezPersonal.t32'/></span></a> 
				                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsAppoint = '2';document.getElementById('TextName_1').value=''; $('#TextName_1').attr('check','clear'); $('#TextName_${status.count+1}').attr('deptId', ''); $('#TextName_${status.count+1}').attr('userId', ''); $('#TR_Select_${status.count+1}').show();"><spring:message code='ezPersonal.t33'/></span></a>
				                ${userInfo.deptName} [${userInfo.title}]
							</c:when>
							<c:otherwise>
								<a class="imgbtn imgbck" style="vertical-align:middle; margin-bottom:1px;"><span onclick="gIsAppoint = '1';select_person('', 'TextName_1')"><spring:message code='ezPersonal.t32'/></span></a> 
				                <a class="imgbtn imgbck" style="vertical-align:middle; margin-bottom:1px;"><span onClick="gIsAppoint = '2';document.getElementById('TextName_1').value=''; $('#TextName_1').attr('check','clear'); $('#TextName_${status.count+1}').attr('deptId', ''); $('#TextName_${status.count+1}').attr('userId', ''); $('#TR_Select_${status.count+1}').show();"><spring:message code='ezPersonal.t33'/></span></a>
				                <p style="margin:5px 0 0 0; line-height:1.3;">${userInfo.deptName} [${userInfo.title}]</p>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<%-- <c:if test="${fn:indexOf(fn:toLowerCase(userInfo.rollInfo), 'a=1;') > -1}">
					<c:if test="${approvalFlag eq 'S'}">
						<tr>
				            <th><spring:message code='ezPersonal.t399'/></th>
						    <td>
						    	<input type="text" name="TextProxyName" id="TextProxyName" value="${textProxyName}" Width="120" ReadOnly />
							    <a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person('Proxy')"><spring:message code='ezPersonal.t32'/></span></a> 
				                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById('TextProxyName').value=''"><spring:message code='ezPersonal.t33'/></span></a>
						    </td>
					    </tr>
					</c:if>
				    <tr>
			            <th><spring:message code='ezPersonal.t399'/></th>
					    <td>
					    	<input type="text" name="TextProxyName" id="TextProxyName" value="${textProxyName}" Width="120" ReadOnly />
						    <a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person('Proxy')"><spring:message code='ezPersonal.t32'/></span></a> 
			                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById('TextProxyName').value=''"><spring:message code='ezPersonal.t33'/></span></a>
					    </td>
				    </tr>
				</c:if> --%>
				<c:if test="${approvalFlag eq 'G'}">
					<tr id="TR_Select_1" <c:choose><c:when test="${fn:trim(textName) ne ''}">style="display:none;"</c:when></c:choose> >
						<th><spring:message code='ezPersonal.t42'/></th>
						<td>
							<SELECT id="absentreason_1" onchange="return Sel_Change('1');"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
								<OPTION selected value="<spring:message code='ezPersonal.t35'/>"></OPTION>
								<OPTION value="b1"><spring:message code='ezPersonal.b1'/></OPTION>
								<OPTION value="b2"><spring:message code='ezPersonal.b2'/></OPTION>
								<OPTION value="b3"><spring:message code='ezPersonal.b3'/></OPTION>
								<OPTION value="b4"><spring:message code='ezPersonal.b4'/></OPTION>
								<OPTION value="b5"><spring:message code='ezPersonal.b5'/></OPTION>
								<OPTION value="b6"><spring:message code='ezPersonal.b6'/></OPTION>
								<OPTION value="b7"><spring:message code='ezPersonal.b7'/></OPTION>
								<OPTION value="b8"><spring:message code='ezPersonal.b8'/></OPTION>
								<OPTION value="b9"><spring:message code='ezPersonal.b9'/></OPTION>
								<OPTION value="b10"><spring:message code='ezPersonal.b10'/></OPTION>
								<OPTION value="b11"><spring:message code='ezPersonal.b11'/></OPTION>
								<OPTION value="b12"><spring:message code='ezPersonal.b12'/></OPTION>
							</SELECT>
							${userInfo.deptName} [${userInfo.title}]
						</td>
					</tr>
				</c:if>
				<c:if test="${approvalFlag eq 'S'}">
					<tr id="TR_Select_1" <c:choose><c:when test="${fn:trim(textName) ne ''}">style="display:none;"</c:when></c:choose> >
						<th><spring:message code='ezPersonal.t42'/></th>
						<td>
							<SELECT id="absentreason_1" onchange="return Sel_Change('1');"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
								<OPTION selected value="<spring:message code='ezPersonal.t35'/>"></OPTION>
								<OPTION value="b1"><spring:message code='ezPersonal.b1'/></OPTION>
								<OPTION value="b2"><spring:message code='ezPersonal.b2'/></OPTION>
								<OPTION value="b3"><spring:message code='ezPersonal.b3'/></OPTION>
								<OPTION value="b4"><spring:message code='ezPersonal.b4'/></OPTION>
								<OPTION value="b5"><spring:message code='ezPersonal.b5'/></OPTION>
								<OPTION value="b6"><spring:message code='ezPersonal.b6'/></OPTION>
								<OPTION value="b7"><spring:message code='ezPersonal.b7'/></OPTION>
								<OPTION value="b8"><spring:message code='ezPersonal.b8'/></OPTION>
								<OPTION value="b9"><spring:message code='ezPersonal.b9'/></OPTION>
								<OPTION value="b10"><spring:message code='ezPersonal.b10'/></OPTION>
								<OPTION value="b11"><spring:message code='ezPersonal.b11'/></OPTION>
								<OPTION value="b12"><spring:message code='ezPersonal.b12'/></OPTION>
							</SELECT>
							${userInfo.deptName} [${userInfo.title}]
						</td>
					</tr>
				</c:if>
				<c:forEach var="addJob" items="${addJobList}" varStatus="status">
					<tr id="TR_Appoint_${status.count+1}" deptId="${addJob.department}" jobId="${addJob.jobID}">
						<th><spring:message code='ezPersonal.t31'/></th>
						<td style="padding:3px 4px;">
							<input type="text" name="TextName_${status.count+1}" id="TextName_${status.count+1}" Width="120" value="" deptId="" userId="" ReadOnly />
							<c:choose>
								<c:when test="${userInfo.lang == 1}">
									<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsAppoint = '1';select_person('', 'TextName_${status.count+1}');"><spring:message code='ezPersonal.t32'/></span></a> 
					                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsAppoint = '2';document.getElementById('TextName_${status.count+1}').value=''; $('#TextName_${status.count+1}').attr('check','clear'); $('#TextName_${status.count+1}').attr('deptId', ''); $('#TextName_${status.count+1}').attr('userId', ''); $('#TR_Select_${status.count+1}').show();""><spring:message code='ezPersonal.t33'/></span></a>
					                ${addJob.description} [${addJob.title}]
				                </c:when>
				                <c:otherwise>
									<a class="imgbtn imgbck" style="vertical-align:middle; margin-bottom:1px;"><span onclick="gIsAppoint = '1';select_person('', 'TextName_${status.count+1}');"><spring:message code='ezPersonal.t32'/></span></a> 
					                <a class="imgbtn imgbck" style="vertical-align:middle; margin-bottom:1px;"><span onClick="gIsAppoint = '2';document.getElementById('TextName_${status.count+1}').value=''; $('#TextName_${status.count+1}').attr('check','clear'); $('#TextName_${status.count+1}').attr('deptId', ''); $('#TextName_${status.count+1}').attr('userId', ''); $('#TR_Select_${status.count+1}').show();""><spring:message code='ezPersonal.t33'/></span></a>
					                <p style="margin:5px 0 0 0; line-height:1.3;">${addJob.description} [${addJob.title}]</p>
				                </c:otherwise>
			                </c:choose>
						</td>
					</tr>
					<%-- <c:if test="${fn:indexOf(fn:toLowerCase(userInfo.rollInfo), 'a=1;') > -1}">
						<c:if test="${approvalFlag eq 'S'}">
							<tr>
					            <th><spring:message code='ezPersonal.t399'/></th>
							    <td>
							    	<input type="text" name="TextProxyName" id="TextProxyName" value="${textProxyName}" Width="120" ReadOnly />
								    <a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person('Proxy')"><spring:message code='ezPersonal.t32'/></span></a> 
					                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById('TextProxyName').value=''"><spring:message code='ezPersonal.t33'/></span></a>
							    </td>
						    </tr>
						</c:if>
					    <tr>
				            <th><spring:message code='ezPersonal.t399'/></th>
						    <td>
						    	<input type="text" name="TextProxyName" id="TextProxyName" value="${textProxyName}" Width="120" ReadOnly />
							    <a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person('Proxy')"><spring:message code='ezPersonal.t32'/></span></a> 
				                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById('TextProxyName').value=''"><spring:message code='ezPersonal.t33'/></span></a>
						    </td>
					    </tr>
					</c:if> --%>
					<c:if test="${approvalFlag eq 'G'}">
						<tr id="TR_Select_${status.count+1}">
							<th><spring:message code='ezPersonal.t42'/></th>
							<td>
								<SELECT id="absentreason_${status.count+1}" onchange="return Sel_Change('${status.count+1}');" proxy="${addJob.extensionAttribute5}"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
									<OPTION selected value="<spring:message code='ezPersonal.t35'/>"></OPTION>
									<OPTION value="b1"><spring:message code='ezPersonal.b1'/></OPTION>
									<OPTION value="b2"><spring:message code='ezPersonal.b2'/></OPTION>
									<OPTION value="b3"><spring:message code='ezPersonal.b3'/></OPTION>
									<OPTION value="b4"><spring:message code='ezPersonal.b4'/></OPTION>
									<OPTION value="b5"><spring:message code='ezPersonal.b5'/></OPTION>
									<OPTION value="b6"><spring:message code='ezPersonal.b6'/></OPTION>
									<OPTION value="b7"><spring:message code='ezPersonal.b7'/></OPTION>
									<OPTION value="b8"><spring:message code='ezPersonal.b8'/></OPTION>
									<OPTION value="b9"><spring:message code='ezPersonal.b9'/></OPTION>
									<OPTION value="b10"><spring:message code='ezPersonal.b10'/></OPTION>
									<OPTION value="b11"><spring:message code='ezPersonal.b11'/></OPTION>
									<OPTION value="b12"><spring:message code='ezPersonal.b12'/></OPTION>
								</SELECT>
								${addJob.description} [${addJob.title}]
							</td>
						</tr>
					</c:if>
					<c:if test="${approvalFlag eq 'S'}">
						<tr id="TR_Select_${status.count+1}">
							<th><spring:message code='ezPersonal.t42'/></th>
							<td>
								<SELECT id="absentreason_${status.count+1}" onchange="return Sel_Change('${status.count+1}');" proxy="${addJob.extensionAttribute5}"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
									<OPTION selected value="<spring:message code='ezPersonal.t35'/>"></OPTION>
									<OPTION value="b1"><spring:message code='ezPersonal.b1'/></OPTION>
									<OPTION value="b2"><spring:message code='ezPersonal.b2'/></OPTION>
									<OPTION value="b3"><spring:message code='ezPersonal.b3'/></OPTION>
									<OPTION value="b4"><spring:message code='ezPersonal.b4'/></OPTION>
									<OPTION value="b5"><spring:message code='ezPersonal.b5'/></OPTION>
									<OPTION value="b6"><spring:message code='ezPersonal.b6'/></OPTION>
									<OPTION value="b7"><spring:message code='ezPersonal.b7'/></OPTION>
									<OPTION value="b8"><spring:message code='ezPersonal.b8'/></OPTION>
									<OPTION value="b9"><spring:message code='ezPersonal.b9'/></OPTION>
									<OPTION value="b10"><spring:message code='ezPersonal.b10'/></OPTION>
									<OPTION value="b11"><spring:message code='ezPersonal.b11'/></OPTION>
									<OPTION value="b12"><spring:message code='ezPersonal.b12'/></OPTION>
								</SELECT>
								${addJob.description} [${addJob.title}]
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</table>            
			<div style="width:520px;text-align:center;">
				<div class="btnpositionJsp">
		    		<a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezPersonal.t34'/></span></a>
		    		<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezPersonal.t13'/></span></a>
		    	</div>	
		  	</div>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
