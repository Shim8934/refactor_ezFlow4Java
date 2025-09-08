<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t250" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>   
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <!-- data picker -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- data picker -->
		<script type="text/javascript">
			var DeptID = "";
			var OrgUserID = "";
			var Tab1_flag = true;
			var getBirthDay = "<c:out value='${birthDay}'/>";
		    var ReturnFunction;
		    var RetValue;
	    	var useAddressOpenAPI = "${useAddressOpenAPI}"
	    	var useBizmekaSpambox = "${useBizmekaSpambox}";
	    	var locale = "<c:out value='${locale}'/>";
	    	var companyID;
	    	var pUserTitleID = "";
	    	var pUserPositionID = "";
	    	var jobTitleID, jobTitleName, jobTitleName2;
	    	var jobPositionID, jobPositionName, jobPositionName2;
	    	var primaryLang = "${primaryLang}";
	    	
			$(document).ready(function(){
				var toYear = new Date().getFullYear();
				var sYear = parseInt(toYear-90);
				var eYear = parseInt(toYear+10);
				
				if (primaryLang == '3') {
					window.resizeTo(850, 540);
				}
				
				$("#txtBirth").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        yearRange: sYear+":"+eYear,  
			        //autoSize: true,
			        showOn: "button",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
			    });
			    $("#txtBirth").datepicker("option", "dateFormat", "yy-mm-dd");
			    if (getBirthDay == "") {
			        //var NowDate = new Date();
			        //$("#txtBirth").datepicker('setDate', NowDate);
			    }
			    else {
			        $("#txtBirth").datepicker('setDate', getBirthDay);
			    }
			    
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
			            constrainInput: false,
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			    });			    
			    
				try {
	                ReturnFunction = opener.userinfo_dialogArguments[1];
	                RetValue = opener.userinfo_dialogArguments[0];
	            } catch (e) {
	                RetValue = window.dialogArguments;
	            }
	            
	            if (RetValue[2] != "") {
            		companyID = getUserCompanyID(RetValue[2]);
		        } else {
            		companyID = RetValue[4];
		        }

	            /* dhlee: Safari에서 영문 입력이 되지 않아 제거함.
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("UserName"));
		                KeEventControl(document.getElementById("UserName2"));
		                KeEventControl(document.getElementById("Password"));
		                KeEventControl(document.getElementById("DeptName"));
		                KeEventControl(document.getElementById("DeptName2"));
		                KeEventControl(document.getElementById("JobTitle"));
		                KeEventControl(document.getElementById("JobTitle2"));
		                KeEventControl(document.getElementById("JobPosition"));
		                KeEventControl(document.getElementById("JobPosition2"));
		                KeEventControl(document.getElementById("HomeAddr"));
		                KeEventControl(document.getElementById("ZipCode"));
		                KeEventControl(document.getElementById("FaxNum"));
		                KeEventControl(document.getElementById("PhoneNumber"));
		                KeEventControl(document.getElementById("HomePhone"));
		                KeEventControl(document.getElementById("Mobile"));
		                KeEventControl(document.getElementById("SocialNum"));
		                KeEventControl(document.getElementById("SecurityLevel"));
		                KeEventControl(document.getElementById("UserID"));
		                KeEventControl(document.getElementById("SortNum"));
		            }
		        }catch (e){ }
		        */
				document.getElementById("userTreeFlag").checked = true;
				
		        if (RetValue[2] == "") {
		            document.getElementById("DeptName").value = RetValue[1];
		            // 수정(2007.06.26) : 사용자 추가 시 부서명(P/S)이 제대로 보이지 않는 문제 수정
		            document.getElementById("DeptName2").value = RetValue[3];
		            DeptID = RetValue[0];	
		            document.getElementById('btn_PhotoAdd').style.display = "none";
		            document.getElementById('btn_PhotoDel').style.display = "none";
		            document.getElementById('btn_PasswordReset').style.display = "none";
					document.getElementById("CompanyName").value = RetValue[6];
		            
		            getJobInfoInit();
		            
		        } else {
		            OrgUserID = RetValue[2];
		            document.getElementById("DeptName").value = RetValue[1];
		            document.getElementById("UserID").value = OrgUserID;
		            document.getElementById("UserID").readOnly = true;
		            document.getElementById("Password").readOnly = true;
		            // 수정(2007.03.08) : 사용자 추가 시에는 메일 아이디를 별도로 입력 못하게 하고, 수정 시에는 정보만 보여주도록 수정
		            document.getElementById("MailAlias").style.display = "";
		            document.getElementById("MailAlias").readOnly = true;
		            document.getElementById("UserName").focus();
		            document.getElementById("mailtitle").innerText = "<spring:message code='ezOrgan.t99' />";
		            document.getElementById("mailcontext").style.display = "none";
	
		            var xmlDom = createXmlDom();
		            
		            $.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/getEntryInfo.do",
						async : false,
						data : {cn : document.getElementById("UserID").value, prop : "description;extensionAttribute10;extensionAttribute14;displayName;title;company;extensionAttribute15;telephoneNumber;homePhone;facsimileTelephoneNumber;mobile;postalCode;streetAddress;mail;extensionAttribute1;extensionAttribute2;extensionAttribute6;birth;birthType;extensionAttribute7;extensionAttribute8;furigana;extensionPhone;officeMobile;userTreeFlag", pMode : "user" },
						success : function(result){
							xmlDom = loadXMLString(result);
							document.getElementById("UserName").value = SelectSingleNodeValueNew(xmlDom, "DATA/DISPLAYNAME1").trim();
			                document.getElementById("UserName2").value = SelectSingleNodeValueNew(xmlDom, "DATA/DISPLAYNAME2").trim();
// 			                document.getElementById("JobTitle").value = SelectSingleNodeValueNew(xmlDom, "DATA/TITLE1").trim();
//			                document.getElementById("JobTitle2").value = SelectSingleNodeValueNew(xmlDom, "DATA/TITLE2").trim();
			                document.getElementById("SortNum").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE15").trim();
			                document.getElementById("PhoneNumber").value = SelectSingleNodeValueNew(xmlDom, "DATA/TELEPHONENUMBER").trim();
			                document.getElementById("HomePhone").value = SelectSingleNodeValueNew(xmlDom, "DATA/HOMEPHONE").trim();
			                document.getElementById("FaxNum").value = SelectSingleNodeValueNew(xmlDom, "DATA/FACSIMILETELEPHONENUMBER").trim();
			                document.getElementById("Mobile").value = SelectSingleNodeValueNew(xmlDom, "DATA/MOBILE").trim();
			                document.getElementById("ZipCode").value = SelectSingleNodeValueNew(xmlDom, "DATA/POSTALCODE").trim();
			                document.getElementById("HomeAddr").value = SelectSingleNodeValueNew(xmlDom, "DATA/STREETADDRESS").trim();
			                document.getElementById("MailAlias").value = SelectSingleNodeValueNew(xmlDom, "DATA/MAIL").trim();
// 			                document.getElementById("JobPosition").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE101").trim();
// 			                document.getElementById("JobPosition2").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE102").trim();
			                document.getElementById("DeptName").value = SelectSingleNodeValueNew(xmlDom, "DATA/DESCRIPTION1").trim();
			                document.getElementById("DeptName2").value = SelectSingleNodeValueNew(xmlDom, "DATA/DESCRIPTION2").trim();
			                document.getElementById("SocialNum").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE14").trim();
			                document.getElementById("CompanyName").value = SelectSingleNodeValueNew(xmlDom, "DATA/COMPANY").trim();
			                document.getElementById("txtBirth").value = SelectSingleNodeValueNew(xmlDom, "DATA/BIRTH").trim();
			                document.getElementById("userPhotoYN").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE2").trim();
			                document.getElementById("furigana").value = SelectSingleNodeValueNew(xmlDom, "DATA/FURIGANA").trim();
			                document.getElementById("txtExtensionPhone").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONPHONE").trim();
			                document.getElementById("txtOfficeMobile").value = SelectSingleNodeValueNew(xmlDom, "DATA/OFFICEMOBILE").trim();

							var userHide = SelectSingleNodeValueNew(xmlDom, "DATA/USERTREEFLAG").trim();
							if (userHide === 'Y') {
								var userTreeFlagTag = document.getElementById("userTreeFlag");
								userTreeFlagTag.checked = true;
							} else {
								var userTreeFlagTag = document.getElementById("userTreeFlag");
								userTreeFlagTag.checked = false;
							}
							
			                try {
				                if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE7").trim() != "") {
				                	pUserTitleID = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE7").trim();
				                	getJobOptionInfo("001");
				                	document.getElementById(pUserTitleID).selected = "true";
				                } else {
				                	getJobOptionInfo("001");
				                }
			                } catch(e) {
			                	console.error(e.message);
			                }
			                try {
				                if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE8").trim() != "") {
				                	pUserPositionID = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE8").trim();
				    		    	getJobOptionInfo("002");
				                	document.getElementById(pUserPositionID).selected = "true";
				                } else {
				    		    	getJobOptionInfo("002");
				                }
			                } catch(e) {
			                	console.error(e.message);
			                }
			                
			                titleChange();
			                positionChange();
			                
			                if (SelectSingleNodeValueNew(xmlDom, "DATA/BIRTHTYPE").trim() == "Y" || SelectSingleNodeValueNew(xmlDom, "DATA/BIRTHTYPE").trim() == ""){
			                    document.getElementById("birth_S").checked = true;
			                }else{
			                    document.getElementById("birth_N").checked = true;
			                }
			                var AclList = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE1").toLowerCase().trim();
			                document.getElementById("SecurityLevel").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE6").trim();
			                
			                for (var i = 1; i < 13; i++) {
			                    try {
			                        if (AclList.indexOf(document.getElementById("Check" + i).value + "=1") > -1){
			                            document.getElementById("Check" + i).checked = true;
			                        }
			                    } catch (e) {console.log(e);}
			                }
			                if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE2").trim() != ""){
			                    document.getElementById("UserPhotoDiv").innerHTML = "<IMG style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE2") + "'>";
			                }
						}
		            });
		        }
				if (RetValue[8] != "" && typeof RetValue[8] != "undefined") {
					document.getElementById('pwPolicyExplain').innerHTML = RetValue[8];
				}
		        if (locale != 'ko') {
		        	$(".onlyUseKo").css("display", "none");
		        }
				
				var useOrganHideFlag = "${useOrganHideFlag}";
				var treeFlagClass = document.querySelectorAll(".treeFlag");
				if ("NO" === useOrganHideFlag) {
					treeFlagClass.forEach(function (treeFlag) {
						treeFlag.style.display = "none";
					});
				}
			});
			
			function KeEventControl(obj) {
				useragt = navigator.userAgent.toUpperCase();
		        //사파리 브라우저일 경우
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0){
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126){
		                return false;
		            }
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32 || parseInt(window.event.keyCode) == 192){
		               		return false;
		            }
		        };
		        obj.onkeypress = function () {
		            if (parseInt(window.event.keyCode) == 9){
		                return false;
		            }
		        };
		    }
			var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id){
		            obj.className = "";
		        }
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null){
		                document.getElementById(Tab1_SelectID).className = "";
		            }
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    function ChangeTab(obj) {
		        var pSelectTab = obj.getAttribute("divname");
		        switch (pSelectTab) {
		            case "Organ_div1":
		                break;
		        }
		    }
		    function Tab1_NewTabIni(pTabNodeID) {
		    	if (document.getElementById(pTabNodeID) != null) {
			        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
			            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
			                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
			                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
			                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
			                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
	
			                    if (Tab1_flag) {
			                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
			                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
			                        Tab1_flag = false;
			                    }
	
			                }
			            }
			        }
		    	}
		    }
		    
		    function Check_ID(pValue) {
				var regex = /^[a-z0-9\_\-\.]+$/;
				
				return regex.test(pValue);
			}
		    
			function showProgress() {
			    document.getElementById("progressPanel").style.display = "";
			    document.getElementById("loadingLayer").style.display = "";
			}

			function hideProgress() {
			    document.getElementById("progressPanel").style.display = "none";
			    document.getElementById("loadingLayer").style.display = "none";
			}
		    
		    function OK_Click() {
		    	if (RetValue[5] != "" && RetValue[5] == "addJob") {
		    		alert("<spring:message code='ezOrgan.psb02' />");
					return;
            	}
		        if (document.getElementById("UserID").value.trim() == "") {
		            alert("<spring:message code='ezOrgan.t253' />");
		            return;
		        }
		        /* if ((RetValue[2] == "") && (document.getElementById("UserID").value.length < 3)) {
		            alert("<spring:message code='ezOrgan.t254' />");
		            return;
		        } */
		        if (!Check_ID(document.getElementById("UserID").value)) {
		            alert("<spring:message code='ezOrgan.t255' />");
		            return;
		        }
		        if (UserName.value == "") {
		            alert("<spring:message code='ezOrgan.t256' />");
		            return;
		        }
		        if (DeptID != "" && Password.value == "") {
		            alert("<spring:message code='ezOrgan.t257' />");
		            return;
		        }
		        var checkPw = checkPasswordPolicy({
					"pw" : document.getElementById('Password').value,
					"chkCompanyId" : companyID,
					"userId" : document.getElementById("UserID").value,
					"usePropParams" : true,
					"TELEPHONENUMBER" : PhoneNumber.value,
					"MOBILE" : Mobile.value,
					"HOMEPHONE" : HomePhone.value,
					"BIRTH" : document.getElementById("txtBirth").value
				});

		        if (RetValue[2] == "" && !checkPw){
		        	document.getElementById('Password').focus();
		        	return;
		        }
				var regexForName = /[()&<>\\']/;

				if (regexForName.test(UserName.value)) {
					alert("<spring:message code='ezOrgan.t259' /> (,),&,<,>,\\,' <spring:message code='ezOrgan.t260' />");
					return;
				}

				if (regexForName.test(UserName2.value)) {
					alert("<spring:message code='ezOrgan.t259' /> (,),&,<,>,\\,' <spring:message code='ezOrgan.t260' />");
					return;
				}
		        
// 		        if (JobTitle.value.indexOf("&") != -1 || JobTitle.value.indexOf("<") != -1 || JobTitle.value.indexOf(">") != -1) {
// 		            alert("<spring:message code='ezOrgan.t262' /><,> <spring:message code='ezOrgan.t260' />");
// 		            return;
// 		        }
// 		        if (JobTitle2.value.indexOf("&") != -1 || JobTitle2.value.indexOf("<") != -1 || JobTitle2.value.indexOf(">") != -1) {
// 		            alert("<spring:message code='ezOrgan.t262' /><,> <spring:message code='ezOrgan.t260' />");
// 		            return;
// 		        }
// 		        if (JobPosition.value.indexOf("&") != -1 || JobPosition.value.indexOf("<") != -1 || JobPosition.value.indexOf(">") != -1) {
// 		            alert("<spring:message code='ezOrgan.t263' /><,> <spring:message code='ezOrgan.t260' />");
// 		            return;
// 		        }
// 		        if (JobPosition2.value.indexOf("&") != -1 || JobPosition2.value.indexOf("<") != -1 || JobPosition2.value.indexOf(">") != -1) {
// 		            alert("<spring:message code='ezOrgan.t263' /><,> <spring:message code='ezOrgan.t260' />");
// 		            return;
// 		        }
		        if (trim(SecurityLevel.value) != "" && parseInt(SecurityLevel.value) != SecurityLevel.value) {
		            alert("<spring:message code='ezOrgan.t265' />");
		            return;
		        }
		        
		        if (!SortNum.value.match(/^\d*$/)) {
		        	alert("<spring:message code='ezOrgan.t226' />: <spring:message code='ezEmail.t99000066'/>");
					return;
				}
		        
		        // 표준모듈 (2007.02.21) 수정 : 사용자 추가일 경우만, 체크한다.
		        if (RetValue[2] == "") {
		            if (MailAlias.value != "" && MailAlias.value.indexOf("@") != -1) {
		                alert("<spring:message code='ezOrgan.t267' />");
		                return;
		            }
		        }
				var mailNickName = "";
				var birthtype = "";
				
				if (MailAlias.value == ""){
					mailNickName =  document.getElementById("UserID").value;
				}else{
					mailNickName = MailAlias.value;
				}				
				if (document.getElementById("birth_S").checked == true){
					birthtype = "Y";
				}else{
					birthtype = "N";
				}

		        // 번호 입력 시에는 숫자 [+ -] 만 입력 가능
		        var checkNumberArr = [PhoneNumber.value, HomePhone.value, Mobile.value, FaxNum.value];
		        var regex2 = /^[0-9+\- ]+$/;
				for (var checkItem of checkNumberArr) {
					if ("" != checkItem && !regex2.test(checkItem)) {
						alert("<spring:message code='ezOrgan.ls009' />");
						return false;
					}
				}

				if (useBizmekaSpambox == "YES") {
					showProgress();
				}
				
				if(jobTitleID == ""){
					jobTitleID = "0";
				}
				
				if(jobPositionID == "") {
					jobPositionID = "0";
				}

				var userTreeFlag = document.getElementById("userTreeFlag");
				var checkUserTreeFlag = userTreeFlag.checked;
				var userTreeFlagValue = "N";
				if (checkUserTreeFlag) {
					userTreeFlagValue = "Y";
				}
				
				$.ajax({
					type : "POST",
					dataType : "html",
					url : "/admin/ezOrgan/saveUserInfo.do",
					async : true,
					data : {parentCn : DeptID, cn : document.getElementById("UserID").value, displayName : UserName.value, displayName2 : UserName2.value, password : Password.value,
						    mailNickName : mailNickName, title : jobTitleName, title2 : jobTitleName2, extensionAttribute15 : SortNum.value, extensionAttribute6 : SecurityLevel.value,
						    extensionAttribute14 : SocialNum.value, extensionAttribute10 : jobPositionName, extensionAttribute102 : jobPositionName2, telephoneNumber : PhoneNumber.value,
						    homePhone : HomePhone.value, facsimileTelephoneNumber : FaxNum.value, mobile : Mobile.value, postalCode : ZipCode.value, streetAddress : HomeAddr.value,
						    birthType : birthtype, birth : document.getElementById("txtBirth").value, manualFlag : "Y", extensionAttribute7 : jobTitleID, extensionAttribute8 : jobPositionID ,
			    			officeMobile : document.getElementById("txtOfficeMobile").value,
			    			extensionPhone : document.getElementById("txtExtensionPhone").value,
			    			furigana : document.getElementById("furigana").value, userTreeFlag : userTreeFlagValue
					},
					success : function(result) {
					    if (useBizmekaSpambox == "YES") {
					    	hideProgress();
					    }
					    
					    setTimeout(function() {
 							if (result == "PRE") {
 								focusInput(document.getElementById("UserID"));
 								alert("<spring:message code='ezOrgan.t119' />");
 							} else if (result == "PRE_CN") {
 								focusInput(document.getElementById("UserID"));
 								alert("<spring:message code='ezOrgan.t119.2' />");
 							} else if (result == "PRE_EMPLOYEE_NUMBER") {
 								focusInput(document.getElementById("SocialNum"));
 								alert("<spring:message code='ezOrgan.t119.3' />");
 							} else if (result == "EMAIL_ERROR") {
 								alert("<spring:message code='ezOrgan.t269' />");
 							} else if (result == "NO_LICENSE_KEY") {
 								alert("<spring:message code='ezOrgan.x0010' />");
 							} else if (result == "INVALID_LICENSE_KEY") {
 								alert("<spring:message code='ezOrgan.x0011' />");
 							} else if (result == "MAX_USER_REACHED") {
 								alert("<spring:message code='ezOrgan.x0012' />");
 							} else {
 								if (ReturnFunction != null) {
 				                	ReturnFunction(DeptID);
 								} else {
 				                	window.returnValue = DeptID;
 								}
 							
 				            	window.close();
 							}
					    }, 100);
					},
					error : function() {
					    if (useBizmekaSpambox == "YES") {
					    	hideProgress();
					    }
					    
					    setTimeout(function() {
							alert("<spring:message code='ezOrgan.t269' />");
					    }, 100);
					}
				});
		    }

			function focusInput(element) {
				if (element && !element.readOnly) {
					element.focus();
				}
			}

		    function trim(str) {
		        while (str && str.indexOf(" ") == 0)
		            str = str.substring(1);

		        while (str && str.lastIndexOf(" ") == str.length - 1)
		            str = str.substring(0, str.length - 1);

		        return str;
		    }
		    var address_zip_select_dialogArguments = new Array();
		    function GetPostCode() {
		    	address_zip_select_dialogArguments[0] = "";
		        
		        var OpenWin;
		    	if (useAddressOpenAPI == "YES") {
		    		address_zip_select_dialogArguments[1] = jusoCallBack;
		    		OpenWin = GetOpenWindow("/ezAddress/addressZipCodePopUpOpen.do","address_zip_select", 570, 420, "YES");
		    	} else {
		        	address_zip_select_dialogArguments[1] = GetPostCode_Complete;
			        OpenWin = GetOpenWindow("/ezAddress/addressZipCodePopUp.do", "address_zip_select", 655, 620, "YES");
		    	}
		    }
		    function GetPostCode_Complete(Para) {
		        DivPopUpHidden();

		        if ((typeof (Para) != "undefined" || Para == "") && Para != "cancel") {
		        	ZipCode.value = Para[0];
		            HomeAddr.value = Para[1];
		        }
		    }
		    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
		    	DivPopUpHidden();
	        	ZipCode.value = zipNo;
	            HomeAddr.value = roadFullAddr;
			}
		    var personpicture_cross_dialogArguments = new Array();
		    function btnPhoto_onclick() {
		    	if (RetValue[5] != "" && RetValue[5] == "addJob") {
		    		alert("<spring:message code='ezOrgan.psb02' />");
					return;
            	}
		    	//2016-04-19 장진혁과장 -- Cross 버전 사용으로 주석 처리
		        //if (CrossYN()) {
	            personpicture_cross_dialogArguments[0] = document.getElementById("UserID").value;
	            personpicture_cross_dialogArguments[1] = btnPhoto_onclick_Complete;
	            personpicture_cross_dialogArguments[2] = document.getElementById("userPhotoYN").value;
	            DivPopUpShow(415, 285, "/admin/ezOrgan/personPicture.do");
		        <%-- }else {
		            if (navigator.appName.indexOf("Microsoft") > -1)
		                ret = window.showModalDialog("PersonPicture.aspx", document.getElementById("UserID").value, "status:no;dialogWidth:405px;dialogHeight:330px;scroll:no;edge:sunken");
		            else
		                ret = window.showModalDialog("PersonPicture_Cross.aspx", document.getElementById("UserID").value, "status:no;dialogWidth:405px;dialogHeight:330px;scroll:no;edge:sunken" + GetShowModalPosition(405, 390));
		            if (ret != undefined) {
		                alert("<%=RM.GetString("t273")%>");
		                UserPhotoDiv.innerHTML = "<IMG style='width:120px; height:130px;' SRC='/myoffice/Common/ezCommon_InterFace.aspx?TYPE=PERSONAL&FILENAME=" + ret + "' >";
		            }
		        } --%>
		    }
		    function btnPhoto_onclick_Complete(ret, viewTmp) {
		        DivPopUpHidden();

		        if (ret != undefined) {
		            alert("<spring:message code='ezOrgan.t273' />");
		            document.getElementById("userPhotoYN").value = ret;

		            // 2021-10-07 김은실 - (경기대학교) [QC149] 관리자>조직도>조직도관리>사진변경>기존이미지 남아있음 수정 (CrossYN()를 쓰기에는 IE전체가 그런 것 같음. + 11버전은 msie이 없어서 구분이 안됨.)
		            if (/WOW|MSIE/i.test(navigator.userAgent)) {
			            UserPhotoDiv.innerHTML = "<img style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + viewTmp + "' />";
		            } else {
			            UserPhotoDiv.innerHTML = "<img style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + ret + "' />";
		            }
		        }
		    }
		    function deleteImg() {	
		    	if (RetValue[5] != "" && RetValue[5] == "addJob") {
		    		alert("<spring:message code='ezOrgan.psb02' />");
					return;
            	}
		        $.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveUserInfo.do",
					data : {parentCn : "", cn : document.getElementById("UserID").value, prop : "", extensionAttribute2 : ""},
					async : false,
					success : function(result){
						if(result != "OK"){
							alert("<spring:message code='ezOrgan.t270' />");
						}else{
							alert("<spring:message code='ezOrgan.t271' />");
							UserPhotoDiv.innerHTML = "<B><spring:message code='ezOrgan.t272' /></B>";
							location.href = location.href;
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t270' />");
					}
				});
		    }
		    // 직위/직책 정보 init
		    function getJobInfoInit() {
		    	getJobOptionInfo("001");
		    	getJobOptionInfo("002");
		    	titleChange();
		    	positionChange();
		    }
		    // 직위/직책 조회 (pType ==> 001:직위, 002:직책)
		    function getJobOptionInfo(pType) {
		    	var xmldom;
		    	var _html = "";
		    	var pUserJobID = "";
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/getJobOptionInfo.do",
					data : {
						type : pType,
						companyID : companyID
					},
					async : false,
					success : function(result){
						xmldom = loadXMLString(result);
					},
					error : function(){
					}
				});
		    	
	    		if (pType == "001") {
	    			_html += "<select id='titleSelector' style='width:100%;height:25px;' onchange='titleChange()'>";
	    			pUserJobID = pUserTitleID;
	    		} else {
	    			_html += "<select id='positionSelector' style='width:100%;height:25px;' onchange='positionChange()'>";
	    			pUserJobID = pUserPositionID;
	    		}
	    		
	    		// option (해당없음) 표출
   				_html += "<option id='' nmval='' nmval2=''>(<spring:message code='ezApprovalG.t852' />)</option>";
	    		
		    	var oRows = SelectNodes(xmldom, "DATA/ROWS/ROW");
		    	if (oRows.length > 0) {
		    		for (var i = 0; i < oRows.length; i++) {
		    			var pUseFlag	= SelectSingleNodeValueNew(oRows[i], "USEFLAG");
		    			var pJobID 		= SelectSingleNodeValueNew(oRows[i], "JOBID");
		    			var pJobName 	= SelectSingleNodeValueNew(oRows[i], "NAME1");
		    			var pJobName2 	= SelectSingleNodeValueNew(oRows[i], "NAME2");
		    			
		    			if (pUseFlag != "N" || pJobID == pUserJobID) {
		    				_html += "<option id='" + pJobID + "' nmval='" + pJobName + "' nmval2='" + pJobName2 + "'>";
		    				
		    				if ("${userPrimary}" == "1") {
		    					_html += pJobName;
			    			} else {
			    				_html += pJobName2;
			    			}
		    				_html += "</option>";
		    			}
		    		}
		    		_html += "</select>";
		    	} else {
		    		_html += "</select>";
		    	}
		    	
	    		if (pType == "001") {
		    		document.getElementById("JobTitleOption").innerHTML = _html;
	    		} else {
		    		document.getElementById("JobPositionOption").innerHTML = _html;
	    		}
		    }
		    
		    function titleChange() {
		    	if ($("#titleSelector option:selected").length > 0) {
		    		jobTitleID 		= $("#titleSelector option:selected").attr("id") != "" ? $("#titleSelector option:selected").attr("id") : "0";
		    		jobTitleName 	= $("#titleSelector option:selected").attr("nmval");
		    		jobTitleName2 	= $("#titleSelector option:selected").attr("nmval2");
		    	} else {
		    		jobTitleID 		= "";
			    	jobTitleName 	= "";
			    	jobTitleName2 	= "";
		    	}
		    }
		    
		    function positionChange() {
		    	if ($("#positionSelector option:selected").length > 0) {
		    		jobPositionID 		= $("#positionSelector option:selected").attr("id") != "" ? $("#positionSelector option:selected").attr("id") : "0";
		    		jobPositionName 	= $("#positionSelector option:selected").attr("nmval");
		    		jobPositionName2 	= $("#positionSelector option:selected").attr("nmval2");
		    	} else {
		    		jobPositionID 		= "";
		    		jobPositionName 	= "";
		    		jobPositionName2 	= "";
		    	}
		    }
		    
		    function getUserCompanyID(userID) {
		    	var rtnVal = "";
		    	$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/getUserCompanyID.do",
					data : {
						cn : userID
					},
					async : false,
					success : function(result) {
						rtnVal = result;
					},
					error : function(){
					}
				});
		    	return rtnVal;
			}
			
			function checkKey() {
				if(event.keyCode == 8) {
					event.target.value = "";
				} else {
					return false;
				}
			}

			function passwordReset() {
				var getBirth = document.getElementById("txtBirth").value;

				if(getBirth.length != 0) {
					var newPassword = getBirth.replace(/-/g, '');
					var data = document.getElementById("UserID").value;

					$.ajax({
						type: "POST",
						dataType: "xml",
						url: "/admin/ezOrgan/changePassword.do",
						async: false,
						data: {password: newPassword, cn: data},
						success: function (result) {
							$.ajax({
								type: "POST",
								dataType: "xml",
								url: "/admin/ezOrgan/loginCntReset.do",
								async: false,
								data: {password: newPassword, cn: data},
								success: function (result) {
									alert("<spring:message code='ezOrgan.hyh02' />");
								},
								error: function () {
									alert("<spring:message code='ezOrgan.t41' />");
								}
							});

						},
						error: function () {
							alert("<spring:message code='ezOrgan.t41' />");
						}
					});
				} else {
					alert("<spring:message code='ezOrgan.khj004' />");
				}
			}
	    </script>
	</head>
	<body class="popup">
		<div id="menu">
	    	<ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezOrgan.t167' /></span></li>
	            <li id="btn_PhotoAdd"><span onclick="btnPhoto_onclick()"><spring:message code='ezOrgan.t281' /></span></li>
	            <li id="btn_PhotoDel"><span onclick="deleteImg()"><spring:message code='ezOrgan.t282' /></span></li>
	            <li id="btn_PasswordReset"><span onclick="passwordReset()"><spring:message code='ezOrgan.khj003' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	    	<ul>
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>

	    <div style="margin-top:4px;margin-bottom:2px"><span style="color:red;"><spring:message code='ezOrgan.t00018' /></span></div>
		<div id='pwPolicyExplain' style="font-size:13px;margin-top: 3px;"></div>
		<table id="Tbl_UserInfo" class="content" style="width:800px">
	        <tr>
	            <td rowspan="<c:out value="${primaryLang eq '3' ? 7 : 6}" />" id="UserPhotoDiv" style="width:119px; height:180px; text-align:center; min-width:119px;">
	                <b><spring:message code='ezOrgan.t272' /></b> 
	            </td>
	            <th style="width: 71px; text-align:center">&nbsp;&nbsp;<spring:message code='ezOrgan.t275' /><span style="color:red"> *</span></th>
	            <td style="width: 240px">
	                <input id="UserID" style="ime-mode: disabled; width: 100%;" maxlength="20"/>
	            </td>
	            <th style="width: 71px; text-align:center">&nbsp;&nbsp;<spring:message code='ezOrgan.t277' /><span style="color:red"> *</span></th>
	            <td style="width: 240px;">
	                <input type="password" id="Password" style="width: 100%" maxlength="50"/>
	            </td>
	        </tr>
	        <tr style=<c:out value="${primaryLang eq '3' ? 'display:table-row' : 'display:none' }"/>>
	        	<th style="width: 71px; text-align:center"><spring:message code='main.ksa01' /></th>
	            <td style="width: 240px"><input id="furigana" style="width: 100%;" maxlength="20"></td>
	        	<th style="width: 71px; text-align:center"></th>
	        	<td style="width: 240px; padding: 0">
	        </tr>
	        <tr>
	            <th style="width: 71px; text-align:center">&nbsp;&nbsp;<spring:message code='ezOrgan.t276' /><span style="color:red"> *</span></th>
	            <td style="width: 240px; padding: 0">
	                <table style="width:100%">
	                    <tr class="primary">
	                        <th><c:out value='${primary}'/></th>
	                        <td>
	                            <input name="Input" id="UserName" style="width: 100%" maxlength="50"/>
	                        </td>
	                    </tr>
	                    <tr class="secondary">
	                        <th><c:out value='${secondary}'/></th>
	                        <td>
	                            <input id="UserName2" type="text" style="width: 100%" maxlength="50"/>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t278' /></th>
	            <td style="width: 320px; padding: 0">
	                <table style="width:100%">
	                    <tr class="primary">
	                        <th><c:out value='${primary}'/></th>
	                        <td>
	                            <input name="Input3" id="DeptName" style="width: 100%" readonly="readonly" maxlength="50"/>
	                        </td>
	                    </tr>
	                    <tr class="secondary">
	                        <th><c:out value='${secondary}'/></th>
	                        <td>
	                            <input id="DeptName2" type="text" style="width: 100%" readonly="readonly" maxlength="50"/>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>       
	        <tr>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t279' /></th>
	            <td style="width: 240px; padding: 0">
	                <table style="width:100%">
	                    <tr>
	                        <td colspan="2">
	                        	<div id="JobTitleOption"></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t280' /></th>
	            <td style="width: 240px; padding: 0">
	                <table style="width:100%">
	                    <tr>
	                        <td colspan="2">
	                        	<div id="JobPositionOption"></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>       
	        <tr>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t00003' /></th>
	            <td style="width: 260px;">
	               <input type="text" id="txtBirth" style="width:80px;text-align:center;" onkeydown="return checkKey()" readonly="readonly" autocomplete="off"/>&nbsp;
	                <div class="custom_radio" style="float: right;">
	                    <input type="radio" id="birth_S" name="BirthType" Checked /><label for="birth_S"><spring:message code='ezOrgan.t00001' /></label>
	                    <input type="radio" id="birth_N" name="BirthType" style="margin-left: 5px !important;"/><label for="birth_N" style="margin-right: 7px !important"><spring:message code='ezOrgan.t00002' /></label>
	                </div>
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t283' /></th>
	            <td style="width: 240px;" >
	                <input id="SocialNum" style="width: 100%" maxlength="50"/>
	            </td>
	        </tr>
	        <tr>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t284' /></th>
	            <td style="width: 240px;">
	                <input id="SecurityLevel" style="width: 100%" maxlength="50"/>
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t226' /></th>
	            <td style="width: 240px;">
	                <input id="SortNum" style="width: 100%" maxlength="10" />
	            </td>
	        </tr>
	        </tr>
			<tr>
				<th style="width: 71px; text-align:center"><spring:message code='ezOrgan.khj002' /></th>
				<td style="width: 240px;">
					<input id="CompanyName" style="width: 100%" readonly="readonly" maxlength="50"/>
				</td>
				<th class="treeFlag" style="width: 71px; text-align:center"><spring:message code='ezOrgan.kdh07' /></th>
				<td class="treeFlag" style="width: 240px;">
					<input type="checkbox" id="userTreeFlag"/>
				</td>
			</tr>
	    </table>
	    <br />
	    <table id="Tbl_Contract" class="content" style="width:800px;">
	        <tr>
	            <th id="mailtitle" style="width: 80px; text-align:center"><spring:message code='ezOrgan.t99' /></th>
	            <td colspan="5">
	                <input id="MailAlias" style="WIDTH: 100%; display: none" size="11" />
	                <span id="mailcontext"><spring:message code='ezOrgan.t289' /></span>
	            </td>
	        </tr>
	        <tr>
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t95' /></th>
	            <td style="width: 186px">
	                <input id="PhoneNumber" style="width: 100%" maxlength="50"/>
	            </td>
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t97' /></th>
	            <td style="width: 186px">
	                <input id="HomePhone" style="width: 100%" maxlength="50"/>
	            </td>
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t96' /></th>
	            <td style="width: 186px">
	                <input id="Mobile" style="width: 100%" maxlength="50"/>
	            </td>
	        </tr>
	       <tr>
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t98' /></th>
	            <td style="width: 190px">
	                <input id="FaxNum" style="width: 100%" maxlength="50"/>
	            </td>
				<th style="width: 80px; text-align:center"><c:if test="${primaryLang eq '3' }"><spring:message code='main.ksa02' /></c:if></th>
	            <td style="width: 190px"><input type="text" id="txtExtensionPhone" size="22" value="${LiteralExtensionPhone }" maxlength="50" <c:out value="${primaryLang eq '3' ?  'style=width:100%' : 'style=display:none' }"/> ></td>
	            <th style="width: 80px; text-align:center"><c:if test="${primaryLang eq '3' }"><spring:message code='main.ksa03' /></c:if></th>
	            <td style="width: 190px"><input type="text" id="txtOfficeMobile" size="22" value="${LiteralOfficeMobile }" maxlength="50" <c:out value="${primaryLang eq '3' ?  'style=width:100%' : 'style=display:none' }"/>></td>
	        </tr>
	        <!-- /* 2021-05-03 김은실 - [표준] 집주소 영역을 사용하고자 하는 사이트는: style="display:none"을 삭제하면 된다. -->
	        <tr class="onlyUseKo" style="display:none">
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t286' /></th>
	            <td colspan="5">
                    <c:if test="${primaryLang == '1'}">
                    	<c:if test="${useZipCodeSearch == 'YES' && not useOnlyInnerMail}">
	                		<input id="ZipCode" style="WIDTH: 100px;" maxlength="6" readonly="readonly" />
	                		<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="GetPostCode()"><spring:message code='ezOrgan.t286' /></span></a>
                    	</c:if>
                    	<c:if test="${useZipCodeSearch == 'NO' || useOnlyInnerMail}">
                    		<input id="ZipCode" style="WIDTH: 100px;" maxlength="6" />
                    		<span><spring:message code='ezOrgan.t286' /></span>
                    	</c:if>
                    </c:if>
                    <c:if test="${primaryLang != '1'}">
                    <input id="ZipCode" style="WIDTH: 100px;" maxlength="6" />
                    <span><spring:message code='ezOrgan.t286' /></span>
                    </c:if>
	            </td>
	        </tr>
	        <tr style="display:none">
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t287' /></th>
	            <td colspan="5">
	                <input id="HomeAddr" style="WIDTH: 100%;" maxlength="150"/>
	            </td>
	        </tr>
	        <!-- */ -->
	    </table>
	    <input type="hidden" id="userPhotoYN">
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <script type="text/javascript">
		    Tab1_NewTabIni("tab1");
		</script>
     <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
     <span class="loading_layer" style="z-index:6000;position:absolute;top:250px;left:310px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>    
	</body>
</html>