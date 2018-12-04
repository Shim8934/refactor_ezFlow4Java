<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t250" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
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
	    	
			$(document).ready(function(){
				var toYear = new Date().getFullYear();
				var sYear = parseInt(toYear-70);
				var eYear = parseInt(toYear+10);
				
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
	            
	            if (RetValue[4] != "") {
	            	if (RetValue[5] != "" && RetValue[5] == "addJob") {
	            		companyID = getUserCompanyID(RetValue[2]);
	            	} else {
			        	companyID = RetValue[4];
	            	}
			        getTitleOption();
			        getPositionOption();
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
		        }else{
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
						data : {cn : document.getElementById("UserID").value, prop : "description;extensionAttribute10;extensionAttribute14;displayName;title;extensionAttribute15;telephoneNumber;homePhone;facsimileTelephoneNumber;mobile;postalCode;streetAddress;mail;extensionAttribute1;extensionAttribute2;extensionAttribute6;birth;birthType;extensionAttribute7;extensionAttribute8", pMode : "user" },
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
			                document.getElementById("txtBirth").value = SelectSingleNodeValueNew(xmlDom, "DATA/BIRTH").trim();
			                
			                try {
				                if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE7").trim() != "") {
				                	document.getElementById(SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE7").trim()).selected = "true";
				                	titleChange();
				                }
				                if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE8").trim() != "") {
				                	document.getElementById(SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE8").trim()).selected = "true";
				                	positionChange();
				                }
			                } catch(e) {}
			                
			                if (SelectSingleNodeValueNew(xmlDom, "DATA/BIRTHTYPE").trim() == "Y" || SelectSingleNodeValueNew(xmlDom, "DATA/BIRTHTYPE").trim() == ""){
			                    eval("birth_S").checked = true;
			                }else{
			                    eval("birth_N").checked = true;
			                }
			                var AclList = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE1").toLowerCase().trim();
			                document.getElementById("SecurityLevel").value = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE6").trim();
			                
			                for (var i = 1; i < 13; i++) {
			                    try {
			                        if (AclList.indexOf(eval("Check" + i).value + "=1") > -1){
			                            eval("Check" + i).checked = true;
			                        }
			                    } catch (e) { }
			                }
			                if (SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE2").trim() != ""){
			                    document.getElementById("UserPhotoDiv").innerHTML = "<IMG style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE2") + "'>";
			                }
						}
		            });
		        }
		        if (locale != 'ko') {
		        	$(".onlyUseKo").css("display", "none");
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
		    function Check_ID(pValue) {
		        for (var iCnt = 0 ; iCnt < pValue.length ; iCnt++) {
		            if (pValue.charCodeAt(iCnt) >= 65 && pValue.charCodeAt(iCnt) <= 90) {
		                // A-Z
		            }
		            else if (pValue.charCodeAt(iCnt) >= 97 && pValue.charCodeAt(iCnt) <= 122) {
		                // a-z
		            }
		            else if (pValue.charCodeAt(iCnt) >= 48 && pValue.charCodeAt(iCnt) <= 57) {
		                // 0-9
		            }
		            else if (pValue.charCodeAt(iCnt) == 45) {
		                // -
		            }
		            else if (pValue.charCodeAt(iCnt) == 46) {
		                // .
		            }
                    else if (pValue.charCodeAt(iCnt) == 95) {
                        // _
                    }		            
		            else {
		                return false;
		            }
		        }
		        return true;
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
		        if (document.getElementById("UserID").value == "") {
		            alert("<spring:message code='ezOrgan.t253' />");
		            return;
		        }
		        // 2009.11.10 - 아이디 대문자 체크
		        if ("<c:out value='${checkID}'/>" == "YES") {
		            for (i = 0; i < document.getElementById("UserID").value.length; i++) {
		                if (document.getElementById("UserID").value.charCodeAt(i) >= 65 && document.getElementById("UserID").value.charCodeAt(i) <= 90) {
		                    alert("<spring:message code='ezOrgan.t308' />");
		                    return;
		                }
		            }
		        }
		        if (document.getElementById("UserID").value.length < 3) {
		            alert("<spring:message code='ezOrgan.t254' />");
		            return;
		        }
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
				if (RetValue[2] == "" && !CheckPassword(document.getElementById('Password').value)) {
					alert("<spring:message code='main.jjh04'/>");
					document.getElementById('Password').focus();
					return;
				}	        
		        if (UserName.value.indexOf("(") != -1 || UserName.value.indexOf(")") != -1) {
		            alert("<spring:message code='ezOrgan.t258' />");
		            return;
		        }
		        if (UserName.value.indexOf("&") != -1 || UserName.value.indexOf("<") != -1 || UserName.value.indexOf(">") != -1) {
		            alert("<spring:message code='ezOrgan.t259' /><,> <spring:message code='ezOrgan.t260' />");
		            return;
		        }
		        if (UserName2.value.indexOf("&") != -1 || UserName2.value.indexOf("<") != -1 || UserName2.value.indexOf(">") != -1) {
		            alert("<spring:message code='ezOrgan.t259' /><,> <spring:message code='ezOrgan.t260' />");
		            return;
		        }
		        if (document.getElementById("UserID").value.indexOf("&") != -1 || document.getElementById("UserID").value.indexOf("<") != -1 || document.getElementById("UserID").value.indexOf(">") != -1) {
		            alert("<spring:message code='ezOrgan.t261' /><,> <spring:message code='ezOrgan.t260' />");
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
				if (eval("birth_S").checked == true){
					birthtype = "Y";
				}else{
					birthtype = "N";
				}

				if (useBizmekaSpambox == "YES") {
					showProgress();
				}
				
				$.ajax({
					type : "POST",
					dataType : "html",
					url : "/admin/ezOrgan/saveUserInfo.do",
					async : true,
					data : {parentCn : DeptID, cn : document.getElementById("UserID").value, displayName : UserName.value, displayName2 : UserName2.value, password : Password.value,
						    mailNickName : mailNickName, title : jobTitle, title2 : jobTitle2, extensionAttribute15 : SortNum.value, extensionAttribute6 : SecurityLevel.value,
						    extensionAttribute14 : SocialNum.value, extensionAttribute10 : jobPosition, extensionAttribute102 : jobPosition2, telephoneNumber : PhoneNumber.value,
						    homePhone : HomePhone.value, facsimileTelephoneNumber : FaxNum.value, mobile : Mobile.value, postalCode : ZipCode.value, streetAddress : HomeAddr.value,
						    birthType : birthtype, birth : document.getElementById("txtBirth").value, manualFlag : "Y", extensionAttribute7 : jobID, extensionAttribute8 : jobID2 
					},
					success : function(result) {
					    if (useBizmekaSpambox == "YES") {
					    	hideProgress();
					    }
					    
					    setTimeout(function() {
 							if (result == "PRE") {
 								alert("<spring:message code='ezOrgan.t119' />");
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
		    function btnPhoto_onclick_Complete(ret) {
		        DivPopUpHidden();

		        if (ret != undefined) {
		            alert("<spring:message code='ezOrgan.t273' />");
		            UserPhotoDiv.innerHTML = "<img style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + ret + "' />";		            
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
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t270' />");
					}
				});
		    }
		    var jobTitle, jobTitle2, jobID;
		    function getTitleOption() {
		    	var xmldom, rtnVal, flag, i;
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/jobTitleListView.do",
					data : {
						type : "001",
						companyID : companyID
					},
					async : false,
					success : function(result){
						xmldom = loadXMLString(result);
					},
					error : function(){
					}
				});
		    	
		    	var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
			    	flag = true;
			    	rtnVal = "<select id='titleSelector' style='width:100%;height:25px;' onchange='titleChange()'>";
			    	for (i = 0; i < oRows.length; i++) {
			    		if (SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE") != "N") {
				    		if (flag) {
					    		jobID = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1");
					    		jobTitle = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
					    		jobTitle2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
					    		flag = false;
				    		}
				    		
				    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1")) 
						    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
						    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) + "'>";
					    		
				    		if ("${userPrimary}" == "1") {
					    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE"));
				    		} else {
					    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE"));
				    		}
				    		
				    		rtnVal += "</option>";
			    		}
			    	}
			    	rtnVal += "</select>";
			    } else {
			    	rtnVal = "<select id='titleSelector' style='width:100%;height:25px;'></select>";
			    	jobID = ""; jobTitle = ""; jobTitle2 = "";
			    }
			    
		    	document.getElementById("JobTitleOption").innerHTML = rtnVal;
		    }
		    function titleChange() {
		    	var target = document.getElementById("titleSelector");
		    	var option = target.options[target.options.selectedIndex];
		    	jobID = option.id;
		    	jobTitle = option.getAttribute("nmval");
		    	jobTitle2 = option.getAttribute("nmval2");
		    }
		    
		    var jobPosition, jobPosition2, jobID2;
		    function getPositionOption() {
		    	var xmldom, rtnVal, flag, i;
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/jobTitleListView.do",
					data : {
						type : "002",
						companyID : companyID
					},
					async : false,
					success : function(result){
						xmldom = loadXMLString(result);
					},
					error : function(){
					}
				});
		    	
		    	var oRows = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
			    if (oRows.length > 0) {
			    	flag = true;
			    	rtnVal = "<select id='positionSelector' style='width:100%;height:25px;' onchange='positionChange()'>";
			    	for (i = 0; i < oRows.length; i++) {
			    		if (SelectSingleNodeValue(GetChildNodes(oRows[i])[2],"VALUE") != "N") {
			    			if (flag) {
					    		jobID2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1");
					    		jobPosition = SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE");
					    		jobPosition2 = SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE");
					    		flag = false;
				    		}
				    		
				    		rtnVal += "<option id='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"DATA1")) 
						    		+ "' nmval='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE")) 
						    		+ "' nmval2='" + MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE")) + "'>";
					    		
				    		if ("${userPrimary}" == "1") {
					    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[0],"VALUE"));
				    		} else {
					    		rtnVal += MakeXMLString(SelectSingleNodeValue(GetChildNodes(oRows[i])[1],"VALUE"));
				    		}
				    		
				    		rtnVal += "</option>";
			    		}
			    	}
			    	rtnVal += "</select>";
			    } else {
			    	rtnVal = "<select id='positionSelector' style='width:100%;height:25px;'></select>";
			    	jobID2 = ""; jobPosition = ""; jobPosition2 = "";
			    }
			    
		    	document.getElementById("JobPositionOption").innerHTML = rtnVal;
		    }
		    function positionChange() {
		    	var target = document.getElementById("positionSelector");
		    	var option = target.options[target.options.selectedIndex];
		    	jobID2 = option.id;
		    	jobPosition = option.getAttribute("nmval");
		    	jobPosition2 = option.getAttribute("nmval2");
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
	            <li id="btn_PhotoAdd"><span onclick="btnPhoto_onclick()"><spring:message code='ezOrgan.t281' /></span></li>
	            <li id="btn_PhotoDel"><span onclick="deleteImg()"><spring:message code='ezOrgan.t282' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	    	<ul>
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p><span id="1tab1" divname="Organ_div1"><spring:message code='ezOrgan.t274' /></span></p>
	        </div>
	    </div>
	    <div style="margin-top:4px;margin-bottom:2px"><span style="color:red;"><spring:message code='ezOrgan.t00018' /></span></div>
	    <table id="Tbl_UserInfo" class="content" style="width:800px">
	        <tr>
	            <td rowspan="5" id="UserPhotoDiv" style="width:119px; height:180px; text-align:center; min-width:119px;">
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
	            <td style="width: 240px;">
	                <input type="text" id="txtBirth" style="width:80px;text-align:center;" readonly="readonly"/>	                
	                <input type="radio" id="birth_S" name="BirthType" Checked /><spring:message code='ezOrgan.t00001' />
	                <c:if test="${locale eq 'ko'}">
	                <input type="radio" id="birth_N" name="BirthType" /><spring:message code='ezOrgan.t00002' />
	                </c:if>
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
	            <th style="width: 80px; text-align:center"></th>
	            <td style="width: 190px"></td>
	            <th style="width: 80px; text-align:center"></th>
	            <td style="width: 190px"></td>
	        </tr>
	        <tr class="onlyUseKo">
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t286' /></th>
	            <td colspan="5">
                    <c:if test="${primaryLang == '1'}">
                    	<c:if test="${useZipCodeSearch == 'YES'}">
	                		<input id="ZipCode" style="WIDTH: 100px;" maxlength="6" readonly="readonly" />
	                		<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="GetPostCode()"><spring:message code='ezOrgan.t286' /></span></a>
                    	</c:if>
                    	<c:if test="${useZipCodeSearch == 'NO'}">
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
	        <tr>
	            <th style="width: 80px; text-align:center"><spring:message code='ezOrgan.t287' /></th>
	            <td colspan="5">
	                <input id="HomeAddr" style="WIDTH: 100%;" maxlength="150"/>
	            </td>
	        </tr>
	    </table>   
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