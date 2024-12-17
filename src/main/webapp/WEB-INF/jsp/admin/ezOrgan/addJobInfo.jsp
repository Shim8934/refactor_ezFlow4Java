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
		<style>
			input:read-only{
				background-color: rgba(239, 239, 239, 0.3);
			}
		</style>
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
			var deptId = "${deptId}";
			var jobId = "${jobId}";
			var useOrganHideFlag = "${useOrganHideFlag}";
	    	
			$(document).ready(function(){
				var toYear = new Date().getFullYear();
				var sYear = parseInt(toYear-90);
				var eYear = parseInt(toYear+10);
				
				if (primaryLang == '3') {
					window.resizeTo(850, 540);
				}

				/* 
				겸직 정보수정시 생년월일 선택 불가능하게 달력 삭제
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
			    }*/
			    
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
	
		        if (RetValue[2] == "") {
		            document.getElementById("DeptName").value = RetValue[1];
		            // 수정(2007.06.26) : 사용자 추가 시 부서명(P/S)이 제대로 보이지 않는 문제 수정
		            document.getElementById("DeptName2").value = RetValue[3];
		            DeptID = RetValue[0];	
		            document.getElementById('btn_PhotoAdd').style.display = "none";
		            document.getElementById('btn_PhotoDel').style.display = "none";
					document.getElementById('CompanyName').value = RetValue[7];
		            
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
					document.getElementById('CompanyName').value = RetValue[7];
	
		            var xmlDom = createXmlDom();
		            
		            $.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/getEntryAddJobInfo.do",
						async : false,
						data : {cn : document.getElementById("UserID").value, deptId : deptId, jobId : jobId,
								prop : "description;extensionAttribute10;extensionAttribute14;displayName;displayName2;title;role;company;extensionAttribute15;telephoneNumber;homePhone;facsimileTelephoneNumber;mobile;postalCode;streetAddress;mail;extensionAttribute1;extensionAttribute2;extensionAttribute6;birth;birthType;extensionAttribute7;extensionAttribute8;furigana;extensionPhone;officeMobile;userTreeFlag;deptName;deptName2;orderBy;postalCode;streetAddress",
								pMode : "addJob" },
						success : function(result){
							var addJobInfoList =  result.split("\\");
							var addJobInfoMap = new Map();
							var addJobInfo =  new Array();

							for(var i = 0; i < addJobInfoList.length; i++){
								var addJobInfo = addJobInfoList[i].split(":");
								var column = addJobInfo[0];
								var value = addJobInfo[1];

								addJobInfoMap.set(column, value);
							}

							document.getElementById("UserName").value = addJobInfoMap.get("displayName");
							document.getElementById("UserName2").value = addJobInfoMap.get("displayName2");
							document.getElementById("SortNum").value = addJobInfoMap.get("orderBy");
							document.getElementById("PhoneNumber").value = addJobInfoMap.get("telephoneNumber");
							document.getElementById("HomePhone").value = addJobInfoMap.get("homePhone");
							document.getElementById("FaxNum").value = addJobInfoMap.get("facsimileTelephoneNumber");
							document.getElementById("Mobile").value = addJobInfoMap.get("mobile");
							document.getElementById("ZipCode").value = addJobInfoMap.get("postalCode");
							document.getElementById("HomeAddr").value = addJobInfoMap.get("streetAddress");
							document.getElementById("MailAlias").value = addJobInfoMap.get("mail");
							document.getElementById("SocialNum").value = addJobInfoMap.get("extensionAttribute14");
							document.getElementById("txtBirth").value = addJobInfoMap.get("birth");
							document.getElementById("userPhotoYN").value = addJobInfoMap.get("extensionAttribute2");
							document.getElementById("furigana").value = addJobInfoMap.get("furigana");
							document.getElementById("txtExtensionPhone").value = addJobInfoMap.get("extensionPhone");
							document.getElementById("txtOfficeMobile").value = addJobInfoMap.get("officeMobile");
							document.getElementById("title").value = addJobInfoMap.get("title");
							document.getElementById("role").value = addJobInfoMap.get("role");
							document.getElementById("DeptName").value = addJobInfoMap.get("deptName");
							document.getElementById("DeptName2").value = addJobInfoMap.get("deptName2");


							var userHide = addJobInfoMap.get("userTreeFlag");
							if (userHide === 'Y') {
								var userTreeFlagTag = document.getElementById("userTreeFlag");
								userTreeFlagTag.checked = true;
							} else {
								var userTreeFlagTag = document.getElementById("userTreeFlag");
								userTreeFlagTag.checked = false;
							}

							if (addJobInfoMap.get("birthType") == "Y" || addJobInfoMap.get("birthType") == ""){
								eval("birth_S").checked = true;
							}else{
								eval("birth_N").checked = true;
							}
							var AclList = addJobInfoMap.get("extensionAttribute1").toLowerCase().trim();
							document.getElementById("SecurityLevel").value = addJobInfoMap.get("extensionAttribute6");

							for (var i = 1; i < 13; i++) {
								try {
									if (AclList.indexOf(eval("Check" + i).value + "=1") > -1){
										eval("Check" + i).checked = true;
									}
								} catch (e) { }
							}
							if (addJobInfoMap.get("extensionAttribute2").trim() != ""){
								document.getElementById("UserPhotoDiv").innerHTML = "<IMG style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + addJobInfoMap.get("extensionAttribute2") + "'>";
							}
						}
					});
		        }
		        if (locale != 'ko') {
		        	$(".onlyUseKo").css("display", "none");
		        }
				
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

				var userTreeFlag = ""; // 조직도 사용여부
				if(document.getElementById("userTreeFlag").checked){
					userTreeFlag = "Y";
				} else {
					userTreeFlag = "N";
				}
				var cn = document.getElementById("UserID").value;
				var orderBy = document.getElementById("SortNum").value
				$.ajax({
					type : "POST",
					dataType : "html",
					url : "/admin/ezOrgan/updateAddJobInfo.do",
					async : true,
					data : {userTreeFlag : userTreeFlag, cn: cn, deptId : deptId, orderBy : orderBy, jobId : jobId
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
	    </script>
	</head>
	<body class="popup">
		<div id="menu">
	    	<ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezOrgan.t167' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	    	<ul>
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>

	    <div style="margin-top:4px;margin-bottom:2px"><span style="color:red;"><spring:message code='ezOrgan.t00018' /></span></div>
	    <table id="Tbl_UserInfo" class="content" style="width:800px">
	        <tr>
	            <td rowspan="<c:out value="${primaryLang eq '3' ? 7 : 6}" />" id="UserPhotoDiv" style="width:119px; height:180px; text-align:center; min-width:119px;">
	                <b><spring:message code='ezOrgan.t272' /></b> 
	            </td>
	            <th style="width: 71px; text-align:center">&nbsp;&nbsp;<spring:message code='ezOrgan.t275' /></th>
	            <td style="width: 240px">
	                <input id="UserID" style="ime-mode: disabled; width: 100%;" maxlength="20"/>
	            </td>
	            <th style="width: 71px; text-align:center">&nbsp;&nbsp;<spring:message code='ezOrgan.t277' /></th>
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
	            <th style="width: 71px; text-align:center">&nbsp;&nbsp;<spring:message code='ezOrgan.t276' /></th>
	            <td style="width: 240px; padding: 0">
	                <table style="width:100%">
	                    <tr class="primary">
	                        <th><c:out value='${primary}'/></th>
	                        <td>
	                            <input name="Input" id="UserName" style="width: 100%"  readonly="readonly" maxlength="50"/>
	                        </td>
	                    </tr>
	                    <tr class="secondary">
	                        <th><c:out value='${secondary}'/></th>
	                        <td>
	                            <input id="UserName2" type="text" style="width: 100%"  readonly="readonly" maxlength="50"/>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t278' /></th>
	            <td style="width: 240px; padding: 0">
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
								<input type="text" id='title' style='width:100%' readonly="readonly">
<%--	                        	<div id="JobTitleOption"></div>--%>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t280' /></th>
	            <td style="width: 240px; padding: 0">
	                <table style="width:100%">
	                    <tr>
	                        <td colspan="2">
								<input type="text" id='role' style='width:100%' readonly="readonly">
<%--	                        	<div id="JobPositionOption"></div>--%>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>       
	        <tr>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t00003' /></th>
	            <td style="width: 240px;">
	                <input type="text" id="txtBirth" style="width:80px;text-align:center;" readonly="readonly"/>
	                <input type="radio" id="birth_S" name="BirthType" Checked disabled/><spring:message code='ezOrgan.t00001' />
	                <input type="radio" id="birth_N" name="BirthType" disabled/><spring:message code='ezOrgan.t00002' />
	            </td>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t283' /></th>
	            <td style="width: 240px;" >
	                <input id="SocialNum" style="width: 100%" readonly="readonly" maxlength="50"/>
	            </td>
	        </tr>
	        <tr>
	            <th style="width: 71px; text-align:center"><spring:message code='ezOrgan.t284' /></th>
	            <td style="width: 240px;">
	                <input id="SecurityLevel" style="width: 100%" maxlength="50" readonly="readonly"/>
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
                    		<input id="ZipCode" style="WIDTH: 100px;" maxlength="6" readonly="readonly"/>
                    		<span><spring:message code='ezOrgan.t286' /></span>
                    	</c:if>
                    </c:if>
                    <c:if test="${primaryLang != '1'}">
                    <input id="ZipCode" style="WIDTH: 100px;" maxlength="6" readonly="readonly" />
                    <span><spring:message code='ezOrgan.t286' /></span>
                    </c:if>
	            </td>
	        </tr>
	        <tr style="display:none">
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t287' /></th>
	            <td colspan="5">
	                <input id="HomeAddr" style="WIDTH: 100%;" maxlength="150" readonly="readonly"/>
	            </td>
	        </tr>
	    </table>
	    <input type="hidden" id="userPhotoYN">
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
     <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
     <span class="loading_layer" style="z-index:6000;position:absolute;top:250px;left:310px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>    
	</body>
</html>