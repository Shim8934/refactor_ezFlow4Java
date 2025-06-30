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
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript">
			var deptid = "<c:out value='${deptID}'/>";
			var userid = "<c:out value='${userID}'/>";
			var startdate = "<c:out value='${startDate}'/>";
			var enddate = "<c:out value='${endDate}'/>";
			var orguserid = "<c:out value='${userInfo.id}'/>";
			var BReason = "<c:out value='${bReason}'/>";
			var gIsAppoint = "1";
			var gIsProxyUser = false;
			var proxydeptid = "<c:out value='${proxyDeptID}'/>";
			var proxyuserid = "<c:out value='${proxyUserID}'/>";
			var proxystartdate = "";
		    var proxyenddate = "";
		    var Roll = "<c:out value='${userInfo.rollInfo}'/>";
		    var approvalFlag = "<c:out value='${approvalFlag}'/>";
		    var buJaeId = "";
		    var buJaedeptid = "";
		    var proxybuJaeId = "";
		    var proxybuJaedeptid = "";
		    var P_CompanyID = "";
		
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
		        /* if (startdate != "") {
		        	var nowDate = new Date(startdate.substring(0, 4), startdate.substring(5, 7)-1, startdate.substring(8, 10), startdate.substring(11, 13), startdate.substring(14, 15));
		            var nowDate2 = new Date(enddate.substring(0, 4), enddate.substring(5, 7)-1, enddate.substring(8, 10), enddate.substring(11, 13), enddate.substring(14, 15));
		            nowDate.setMonth(nowDate.getMonth());
		            nowDate2.setMonth(nowDate2.getMonth());
		            $("#Sdatepicker").datepicker('setDate', nowDate);
		            $("#Edatepicker").datepicker('setDate', nowDate2);
		            gIsAppoint = "1";
		        } */
		            document.getElementById("absentreason").value = BReason;            
		        
		        if (proxystartdate != "") {
		            gIsProxyUser = true;
		        }
		
		        Sel_Change();
		        
		        // 초기 회사ID 설정
		        P_CompanyID = document.getElementById("ListCompany").value;
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
		        
		    	var uploadSDate = "<c:out value='${startDate}'/>";

	        	var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);

				var uploadEDate = "<c:out value='${endDate}'/>";
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
			var selectperson_cross_dialogArguments = new Array();
			var selectperson_cross_dialogArguments1 = new Array();
			var type_Complete;
			var NoneActiveX = "YES";
			function select_person(type) {
				if (document.getElementById("deptList") != null && document.getElementById("deptList") != "undefined" && document.getElementById("deptList").value != "") {
					buJaedeptid = document.getElementById("deptList").value;
				}
				
				if(document.getElementById('TextName1').value=='' || document.getElementById('TextName1').value == undefined){
					//2018-08-10 구해안 추후에 resource 추가
					alert("<spring:message code='main.t0630'/>");
					return;
				}
			    type_Complete = type;
			    if (CrossYN() || NoneActiveX == "YES") {
			        selectperson_cross_dialogArguments[1] = select_person_Complete;
			        var OpenWin = window.open("/admin/ezApprovalG/DselectPerson.do?type=" + type +"&buJaeId="+buJaeId + "&buJaedeptid="+buJaedeptid, "SelectPerson_cross", GetOpenWindowfeature(760, 535));
			        try { OpenWin.focus(); } catch (e) { }
			    }
			    else {
			        var rtnValue = window.showModalDialog("/admin/ezApprovalG/DselectPerson.do?type=" + type +"&buJaeId="+buJaeId + "&buJaedeptid="+buJaedeptid, "",
		                "dialogHeight:535px;dialogwidth:760px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(760, 535));
		
			        if (typeof (rtnValue) != "undefined" && type == "") {
			            userid = rtnValue.userId;
			            document.getElementById("TextName").value = rtnValue.userName;
			            deptid = rtnValue.deptId;
			        }
			        if (typeof (rtnValue) != "undefined" && type == "Proxy") {
			            proxyuserid = rtnValue.userId;
			            document.getElementById("TextProxyName").value = rtnValue.userName;
			            proxydeptid = rtnValue.deptId;
			        }
			    }
			}
			function select_person1(type) {
			    type_Complete = type;
			    if (CrossYN() || NoneActiveX == "YES") {
			        selectperson_cross_dialogArguments1[1] = select_person_Complete1;
			        var OpenWin = window.open("/admin/ezApprovalG/selectPerson.do?type=" + type + "&selectedCompanyID=" + P_CompanyID, "SelectPerson_cross", GetOpenWindowfeature(760, 535));
			        try { OpenWin.focus(); } catch (e) { }
			    }
			    else {
			        var rtnValue = window.showModalDialog("/admin/ezApprovalG/selectPerson.do?type=" + type + "&selectedCompanyID=" + P_CompanyID, "",
		                "dialogHeight:535px;dialogwidth:760px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(760, 535));
		
			        if (typeof (rtnValue) != "undefined" && type == "") {
			        	buJaeId = rtnValue.userId;
			            document.getElementById("TextName1").value = rtnValue.userName;
			            buJaedeptid = rtnValue.deptId;
			        }
			        if (typeof (rtnValue) != "undefined" && type == "Proxy") {
			        	proxybuJaeId = rtnValue.userId;
			            document.getElementById("TextProxyName1").value = rtnValue.userName;
			            proxybuJaedeptid = rtnValue.deptId;
			        }
			    }
			}
			function select_person_Complete(rtnValue) {
			    if (typeof (rtnValue) != "undefined" && type_Complete == "") {
			        userid = rtnValue.userId;
			        document.getElementById("TextName").value = rtnValue.userName;
			        deptid = rtnValue.deptId;
			        document.getElementById("TR_Absentreason").style.display = "none";
			    }
			    if (typeof (rtnValue) != "undefined" && type_Complete == "Proxy") {
			        proxyuserid = rtnValue.userId;
			        document.getElementById("TextProxyName").value = rtnValue.userName;
			        proxydeptid = rtnValue.deptId;
			    }
			}
			function select_person_Complete1(rtnValue) {
			    if (typeof (rtnValue) != "undefined" && type_Complete == "") {
			    	buJaeId = rtnValue.userId;
			        document.getElementById("TextName1").value = rtnValue.userName;
			        buJaedeptid = rtnValue.deptId;
			        
			        check_substitute(rtnValue);
			    }
			    /* if (typeof (rtnValue) != "undefined" && type_Complete == "Proxy") {
			    	proxybuJaeId = rtnValue.userId;
			        document.getElementById("TextProxyName1").value = rtnValue.userName;
			        proxybuJaedeptid = rtnValue.deptId;
			    } */
			}
			
			function check_substitute(rtnValue){
				$.ajax({
		    		type : "POST",
		    		dataType : 'json',
		    		async : false,
		    		url : "/admin/ezApprovalG/checkSubstitute.do",
		    		data : {
		    				buJaeId  : rtnValue.userId;
		    				},
		    		success: function(result){
		    			$("select#deptList option").remove();
		    			$("#AddJobDept").hide();
		    			
			            if (result.AddJobList.length > 1) {
							$("#AddJobDept").show();
							for (var i = 0; i < result.AddJobList.length; i++) {
								$("#deptList").append("<option value='" + result.AddJobList[i].department + "'>" +
										result.AddJobList[i].description);
							}
			            } else {
			            	buJaedeptid = result.AddJobList[0].department;
			            }
		    			
				        document.getElementById("TextName").value = result.textName;
				        var startdate = result.startDate;
				        var enddate = result.endDate;
		    			
	    				if (startdate != "") {
	    		        	var nowDate = new Date(startdate.substring(0, 4), startdate.substring(5, 7)-1, startdate.substring(8, 10), startdate.substring(11, 13), startdate.substring(14, 16));
	    		            var nowDate2 = new Date(enddate.substring(0, 4), enddate.substring(5, 7)-1, enddate.substring(8, 10), enddate.substring(11, 13), enddate.substring(14, 16));
	    		            nowDate.setMonth(nowDate.getMonth());
	    		            nowDate2.setMonth(nowDate2.getMonth());
	    		            $("#Sdatepicker").datepicker('setDate', nowDate);
	    		            $("#Edatepicker").datepicker('setDate', nowDate2);
	    		            $("#Stimepicker").timepicker('setTime', nowDate);
	    		            $("#Etimepicker").timepicker('setTime', nowDate2);
	    		            document.getElementById("absentreason").value = BReason;            
	    		            gIsAppoint = "1";
	    		        }		
	    				
	    				userid = result.userID;
	    				deptid = result.deptID;
	    				
	    				/* if(!result.subalsinFlag){
	    					
	    					$('#proxyOutput').html("");
	    					
	    				}else{
	    			        $('#proxyOutput').html("");
							output = '';
							
	    					output += "<th><spring:message code='ezPersonal.t399'/></th>";
	    					output += '<td>';
	    					output += '<input type="text" name="TextProxyName" id="TextProxyName" value="'+result.textProxyName+'" Width="120" ReadOnly />';	
	    					output += '    &nbsp;<a class="imgbtn" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person(\'Proxy\')"><spring:message code="ezPersonal.t32"/></span></a>'; 
	    					output += '   <a class="imgbtn" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById(\'TextProxyName\').value=\'\'"><spring:message code="ezPersonal.t33"/></span></a>';
	    					output += '</td>';
	    					
	    					$('#proxyOutput').html(output);
	    					
	    					proxyuserid = result.proxyUserID;
	    					proxydeptid = result.proxyDeptID;
    					} */

						/* 이유정 - 부재자 설정 정보 불러올때 발생하는 스타일 오류 수정 */
						var proxyFlag = false;
						if (result.textName != "" && result.textName != null) {
							proxyFlag = true;
						}

						if (!result.bReasonFlag && !proxyFlag) {
							document.getElementById("TR_Appoint").style.display = "";
							document.getElementById("TR_Absentreason").style.display = "";
							document.getElementById("absentreason").value = "";
						} else {
							if (!result.bReasonFlag && proxyFlag) {
								document.getElementById("TR_Absentreason").style.display = "none";
								document.getElementById("TR_Appoint").style.display = "";
							} else if (result.bReasonFlag && !proxyFlag) {
								document.getElementById("TR_Absentreason").style.display = "";
								document.getElementById("absentreason").value = result.bReason;
								document.getElementById("TR_Appoint").style.display = "none";
							}
						}
		    		}		    		
		    	});
			}
		
		
		    function check_enddate() {
		        if (!gIsAppoint && document.getElementById("TextName").value == "")
		            return false;
		        var initdate = "<c:out value='${initDate}'/>";
		        var strCurrDate = initdate.substr(0, 10);
		        var strStartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        var strEndDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        
		        if (new Date(strCurrDate) > new Date(strStartDate)) {
		            alert("<spring:message code='ezPersonal.t14'/>");
		            return true;
		        } else if (new Date(strCurrDate) > new Date(strEndDate)) {
		            alert("<spring:message code='ezPersonal.t15'/>");
		            return true;
		        } else if (new Date() > new Date(strEndDate + "T" +$("#Etimepicker").val())) {
		        	alert("<spring:message code='ezPersonal.t26'/>");
    				return true;
		        } else if (strStartDate == strEndDate) {
		        	if (gIsAppoint == '1') {
		        		if (Number($("#Stimepicker").val().substring(0,2)) > Number($("#Etimepicker").val().substring(0,2))) {
			        		alert("<spring:message code='ezPersonal.pjj2'/>");
			        		return true;
		        		} else if (Number($("#Stimepicker").val().substring(0,2)) == Number($("#Etimepicker").val().substring(0,2))) {
		        			if (Number($("#Stimepicker").val().substring(3,5)) > Number($("#Etimepicker").val().substring(3,5))) {
		        				alert("<spring:message code='ezPersonal.pjj2'/>");
		        				return true;
		        			} else if  (Number($("#Stimepicker").val().substring(3,5)) == Number($("#Etimepicker").val().substring(3,5))) {
		        				alert("<spring:message code='ezPersonal.pjj1'/>");
		        				return true;
		        			}
		        		} else if ($("#Stimepicker").val() == $("#Etimepicker").val()) {
		        			alert("<spring:message code='ezPersonal.pjj1'/>");
	        				return true;
		        		}
		        	}
		        } else if ((strStartDate > strEndDate)) {
		        	alert("<spring:message code='ezPersonal.t26'/>");
    				return true;
		        } else {
		            return false;
		        }
		    }
		    function OK_Click() {
		        if (check_enddate()) {
		            return;
		        }
		        
		        if (document.getElementById("TextName1").value == "") {
					alert("<spring:message code='main.t0630'/>");
					return;
				} 
		
		        if (gIsAppoint != '2') {
		        	/* document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>"*/
		        	/* if (approvalFlag == "G") { */
			            if (document.getElementById("TextName").value != "" && document.getElementById("absentreason").value != "") {
			                alert("<spring:message code='ezPersonal.t36'/>");
			                return;
			            }
		        	/* } else {
			            if (document.getElementById("TextName").value != "" && document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>") {
			                alert("<spring:message code='ezPersonal.t36'/>");
			                return;
			            }
		        	} */
		        }
				var pProxy = "";
				var pBujae = "";
				
				// 부재자 지정
				
				
		        // 대리 결재자 지정
		        if (document.getElementById("TextName").value != "") {
		            if (buJaeId.toLowerCase() == proxyuserid.toLowerCase()) {
		                alert("<spring:message code='ezPersonal.t16'/>");
		                return;
		            }
		            
		            if (checkMatchingTime(userid)) {
		            	// true를 반환 받으면 경고창 뜨고 저장 안 되겠끔
		            	alert("<spring:message code='ezPersonal.sky0420'/>\n<spring:message code='ezPersonal.sky042001'/>");
		            	return;
		            }
		            
		            pBujae = userid + ":" + document.getElementById("TextName").value + ":" + deptid + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + ":" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() +  " " + $('#Etimepicker').val() + ":";
		        } else if (document.getElementById("TextName1").value != "" && document.getElementById("absentreason").value != "" && document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>") {
		        	pBujae = "" + ":" + "" + ":" + "" + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + ":" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val() + ":" + document.getElementById("absentreason").value;
		            gIsAppoint = "2";
		        } else if($("#TextName").attr("check") == "clear") {
		        	pBujae = "";
		        	gIsAppoint = "3";
		        } else if (document.getElementById("TextName1").value != "" && document.getElementById("absentreason").value == ""){
					 pBujae = "";
			         gIsAppoint = "4";
				} else {
		            pBujae = "";
		            gIsAppoint = "4";
		        } 
		
		        // 대리 수신 담당자 지정
		        
		        if(document.getElementById("TextProxyName")){
		            if (document.getElementById("TextProxyName").value != "") {
		            	pProxy = proxyuserid + "|" + document.getElementById("TextProxyName").value + "|" + proxydeptid + "|" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() +"|"+ $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		                gIsAppoint = "1";
		            }
		            else
		                pProxy = "";
		        }
		        
		        var dept = "";
		        try {
			        dept = document.getElementById("deptList").value;
		        } catch(e) {}   
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApprovalG/saveBujae.do",
		    		data : {
		    				buJaeId : buJaeId,
		    				proxyuserid : proxyuserid,
		    				buJae  : pBujae,
		    				proxy  : pProxy,
		    				dept : dept
		    				},
		    		success: function(text){
			            if (gIsAppoint == "1") {
			                alert("<spring:message code='ezPersonal.t00002'/>"); // 대리 결재자 지정
// 			                window.location.reload(true);
			            }
			            else if (gIsAppoint == "2") {
			                alert("<spring:message code='ezPersonal.t40'/>"); // 부재사유 설정
// 			                window.location.reload(true);
			            }
			            else if (gIsAppoint == "3") {
			                alert("<spring:message code='ezPersonal.t41'/>"); // 설정 해제 
// 			                window.location.reload(true);
			            }
			            else if (gIsAppoint == "4") {
			            	alert("<spring:message code='ezPersonal.t65'/>");// 아무것도 지정 않았을 때
			            }
		    		},
		    		error: function(){
			            if (gIsAppoint == "1") {
			                alert("<spring:message code='ezPersonal.t37'/>");
			            }
			            else if (gIsAppoint == "2") {
			                alert("<spring:message code='ezPersonal.t38'/>");
			            }
			            else if (gIsAppoint == "3") {
			                alert("<spring:message code='ezPersonal.t39'/>");
			            }
			            else if (gIsAppoint == "4") {
			            	alert("<spring:message code='ezEmail.t133'/>");
			            }
		    		}
		    	});
		    }
		
		    function Sel_Change() {
				/* 이유정 - 부재자 설정 정보 불러올때 발생하는 스타일 오류 수정 */
				if (document.getElementById("absentreason").value == "<spring:message code='ezPersonal.t35'/>" || document.getElementById("absentreason").value == "") {
					if (document.getElementById("TextName").value == "") {
						document.getElementById("TR_Appoint").style.display = "";
						document.getElementById("TR_Absentreason").style.display = "";
					} else {
						document.getElementById("TR_Absentreason").style.display = "none";
						document.getElementById("TR_Appoint").style.display = "";
					}
		        } else {
		            document.getElementById("TR_Appoint").style.display = "none";
		            document.getElementById("TextName").value = "";
					document.getElementById("TR_Absentreason").style.display = "";
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
		    					dept   : dept,
		    					bujaeId : buJaeId
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
				        	var nowDate = new Date(startdate.substring(0, 4), startdate.substring(5, 7)-1, startdate.substring(8, 10), startdate.substring(11, 13), startdate.substring(14, 16));
				            var nowDate2 = new Date(enddate.substring(0, 4), enddate.substring(5, 7)-1, enddate.substring(8, 10), enddate.substring(11, 13), enddate.substring(14, 16));
				            nowDate.setMonth(nowDate.getMonth());
				            nowDate2.setMonth(nowDate2.getMonth());
				            $("#Sdatepicker").datepicker('setDate', nowDate);
				            $("#Edatepicker").datepicker('setDate', nowDate2);
							$("#Stimepicker").timepicker('setTime', nowDate);
							$("#Etimepicker").timepicker('setTime', nowDate2);
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
		    
		    // 회사선택 후 부재자 정보 등 초기화 진행
			function selectCompanyID() {
				if (P_CompanyID != document.getElementById("ListCompany").value) {
					P_CompanyID = document.getElementById("ListCompany").value;
					
					 var nowDate = new Date();
					$("#Sdatepicker").datepicker('setDate', nowDate);
					$("#Edatepicker").datepicker('setDate', nowDate);
					
					document.getElementById("TextName1").value = "";
					document.getElementById("deptList").value = "";
					document.getElementById("TextName").value = "";
					
					$("select#deptList option").remove();
	    			$("#AddJobDept").hide();
				}
			}
			
		    function checkMatchingTime(selectPersonId) {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezOrgan/getEntryInfo.do",
		    		data : {
		    			cn : selectPersonId,
		    			prop : "displayName;extensionAttribute5"
		    		},
		    		success: function(xml) {
		    			xmlDom = loadXMLString(xml);
		    		}
		    	});
		    	
		    	var buJaeInfo = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE5");
	    		
	    		if (buJaeInfo != "") {
	        		var oDate = new Date();
	        		var oYear = oDate.getFullYear();
	        		var oMonth = oDate.getMonth() + 1;
	        		var oDay = oDate.getDate();
	        		var oHours = oDate.getHours();
	        		var oMinutes = oDate.getMinutes();
	        		
	        		var sYear = buJaeInfo.split(":")[3].split("-")[0];
	        		var sMonth = buJaeInfo.split(":")[3].split("-")[1];
	        		var sDay = buJaeInfo.split(":")[3].split("-")[2].substring(0, 2);
	        		var sHours = buJaeInfo.split(":")[3].split("-")[2].substring(3, 5); 
	        		var sMinutes = buJaeInfo.split(":")[4]; 
	        		
	        		var bYear = buJaeInfo.split(":")[5].split("-")[0];
	        		var bMonth = buJaeInfo.split(":")[5].split("-")[1];
	        		var bDay = buJaeInfo.split(":")[5].split("-")[2].substring(0, 2);
	        		var bHours = buJaeInfo.split(":")[5].split("-")[2].substring(3, 5); 
	        		var bMinutes = buJaeInfo.split(":")[6]; 
	        		
	        		var currentDate = new Date(oYear, oMonth, oDay, oHours, oMinutes, 0); //현재 시간
	        		var selectPersonBuJaeStartDate = new Date(sYear, sMonth-1, sDay, sHours, sMinutes, 0); //대리결재지정자 부재 시작 시간
	        		var selectPersonBuJaeEndDate = new Date(bYear, bMonth-1, bDay, bHours, bMinutes, 0); //대리결재지정자 부재 종료 시간
	        		var settingStartDate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy/mm/dd' }).val() + " " + $('#Stimepicker').val()); // 부재자 시작시간
	        		var settingEndDate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy/mm/dd' }).val() + " " + $('#Etimepicker').val()); // 부재자 종료시간
	        		
	        		console.log($("#Sdatepicker").datepicker({ dateFormat: 'yy/mm/dd' }).val() + " " + $('#Stimepicker').val() + "  ##### 시작설정시간");
	        		console.log($("#Edatepicker").datepicker({ dateFormat: 'yy/mm/dd' }).val() + " " + $('#Etimepicker').val() + "  ##### 종료설정시간");
	        		
	        		// 1. 부재설정기간이 대리결재자의 부재기간 이후 (설정기간의 시작날 > 대리결재자의 부재기간 종료날) 
	        		if (settingStartDate >= selectPersonBuJaeEndDate ||  settingEndDate <= selectPersonBuJaeStartDate) {
	        			return false;	
	        		}
	        		else {
	        			return true;
	        		}
	        	}
	    		
	    		else { // 대리결재자 지정자의 부재 설정 정보가 없는 경우.
	    			return false;
	    		}
		    }
		</script>
	</head>
	<body class="mainbody" marginwidth="0" marginheight="0">
		<h1><spring:message code='main.t0628'/>
			<%-- 2020-10-20 홍승비 - 회사선택 셀렉트박스 추가 --%>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany" onChange="selectCompanyID()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
		<form id="ManageBujae" method="post">
			<br/>
			<div class="txt">
				<%-- <c:if test="${approvalFlag =='G'}"> --%>
					<div>▒&nbsp;<spring:message code='ezPersonal.t55'/></div>
					<div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.t56'/></div>
					<div style="margin-top:3px"> &nbsp; &nbsp; <spring:message code='ezPersonal.t57'/></div>
					<div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.t58'/></div>
				<%-- </c:if>
				<c:if test="${approvalFlag !='G'}">
					<div style="margin-top:3px">▒&nbsp;<spring:message code='ezPersonal.pjj3'/></div>
				</c:if> --%>
			</div>
			<table class="content" style="width:520px;margin-top:20px">
				<tr id="TR_Appoint1">
					<th><spring:message code='ezApprovalG.t1777'/></th>
					<td>
						<input type="text" name="TextName" id="TextName1" Width="120" value="" ReadOnly />
						&nbsp;<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsAppoint = '1';select_person1('')"><spring:message code='ezPersonal.t32'/></span></a> 
					</td>
				</tr>
				<tr id="AddJobDept" style="display:none;">
						<th><spring:message code='ezPersonal.t305'/></th>
						<td>
							<select id="deptList" onchange="return Sel_AddJobChange();">
							</select>
						</td>
					</tr>
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
				<tr id="TR_Appoint">
					<th><spring:message code='ezPersonal.t31'/></th>
					<td>
						<input type="text" name="TextName" id="TextName" Width="120" value="" ReadOnly />
						&nbsp;<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="gIsAppoint = '1';select_person('')"><spring:message code='ezPersonal.t32'/></span></a> 
		                <a class="imgbtn imgbck" style="vertical-align:middle"><span onClick="gIsAppoint = '2';document.getElementById('TextName').value=''; $('#TextName').attr('check','clear'); document.getElementById('TR_Absentreason').style.display = '';"><spring:message code='ezPersonal.t33'/></span></a>
					</td>
				</tr>
				<tr id="proxyOutput"></tr>
				<%-- <c:if test="${fn:indexOf(fn:toLowerCase(userInfo.rollInfo), 'a=1;') > -1}">
				    <tr>
			            <th><spring:message code='ezPersonal.t399'/></th>
					    <td>
					    	<input type="text" name="TextProxyName" id="TextProxyName" value="" Width="120" ReadOnly />
						    &nbsp;<a class="imgbtn" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person('Proxy')"><spring:message code='ezPersonal.t32'/></span></a> 
			                <a class="imgbtn" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById('TextProxyName').value=''"><spring:message code='ezPersonal.t33'/></span></a>
					    </td>
				    </tr>
				</c:if> --%>
				<c:if test="${approvalFlag eq 'G'}">
					<tr id="TR_Absentreason">
						<th><spring:message code='ezPersonal.t42'/></th>
						<td>
							<SELECT id="absentreason" onchange="return Sel_Change();"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
								<OPTION selected value=""></OPTION>
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
						</td>
					</tr>
				</c:if>
				<c:if test="${approvalFlag eq 'S'}">
					<tr id="TR_Absentreason">
						<th><spring:message code='ezPersonal.t42'/></th>
						<td>
							<SELECT id="absentreason" onchange="return Sel_Change();"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
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
						</td>
					</tr>
				</c:if>
			</table>            
			<div style="width:520px;text-align:center;margin-top:15px;">
				<div class="btnpositionJsp">
			    	<a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezPersonal.t34'/></span></a>
			    	<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezPersonal.t13'/></span></a>
		    	</div>
		  	</div>
		</form>
	</body>
</html>