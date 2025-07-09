<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ChangePersonInfo</title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/composeappt.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript">
			var rsa = new RSAKey();
			
			var getBirthDay = "${birthDay}";
			var useAddressOpenAPI = "${useAddressOpenAPI}";
			var locale = "${locale}";
			var primaryLang = "${primaryLang}";
			var companyID = "${companyID}";
			var userManualFlag = "${userManualFlag}";
			userManualFlag = userManualFlag.toUpperCase();
			
			$(function () {
				var toYear = new Date().getFullYear();
				var sYear = parseInt(toYear-90);
				var eYear = parseInt(toYear+10);
				document.getElementById("TempCalImage").style.display = "none";
			    $("#txtBirth").datepicker({
			    	changeMonth: true,
			        changeYear: true,
			        yearRange: sYear+":"+eYear,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
				});
			    
			    $("#txtBirth").datepicker("option", "dateFormat", "yy-mm-dd");
			    	if (getBirthDay == "") {
			            //var NowDate = new Date();
			            //$("#txtBirth").datepicker('setDate', NowDate);
			        }
			        else
			            $("#txtBirth").datepicker('setDate', getBirthDay);
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
			    
			    window.onload = function () {
			    	rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
			    	
			    	//익스플로러일때 css수정
			    	if (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) {
						$(".imgbtn span").css("line-height","22px");
			    	}
			    	
			    	if (locale != 'ko') {
			        	$(".onlyUseKo").css("display", "none");
			        }
			    	
			    	// /* 2021-05-03 김은실 - [표준] "인사연동으로 등록된 사용자는 전화, 팩스, 생년월일, 프로필 사진을 바꿀수 없도록 한다."를 풀고자 하는 사이트는: 이 부분을 주석처리하면 된다.  
			    	if (userManualFlag != "Y") {
			    		$(".manualFlagNotYDisabled").attr("disabled", "disabled");
			    		$(".manualFlagNotYClickOff *").off("click");
			    		$(".imgbtn.manualFlagNotYOnClickEmpty").attr("onClick", "").css("background-color", "rgba(239, 239, 239, 0.3)");
			    	}
			    	// */
			    }
			    
			    var personpicture_cross_dialogArguments = new Array();
			    
			    function btnPhoto_onclick() {
			        var wWeight = "474";
			        var wHeight = "304";
	
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
	
			        var left = (width - wWeight) / 2;
			        var top = (heigth - wHeight) / 2;
	
			        if (CrossYN()) {
			            personpicture_cross_dialogArguments[1] = btnPhoto_onclick_Complete;
			            var OpenWin = window.open("/ezPersonal/personPicture.do", "PersonPicture_Cross", GetOpenWindowfeature(474, 304));
			            try { OpenWin.focus(); } catch (e) { }
			        }
			        else {
			            var ret;
			            ret = window.showModalDialog("/ezPersonal/personPicture.do", "", "dialogWidth:474px;dialogHeight:304px;dialogleft:" + left + "px;dialogtop:" + top + "px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no");
			            window.location.reload(true);
			        }
			    }
			    
			    /* 2018-12-07 홍승비 - 사원 사진 등록, 변경 시 사진 div만 리로드하도록 수정 */
			    function btnPhoto_onclick_Complete() {
// 					$.ajax({
// 			    		type : "POST",
// 			    		dataType : "html",
// 			    		url : "/ezPersonal/getUserPhoto.do",
// 			    		success : function(result) {
// 							document.getElementById("LiteralPhoto").innerHTML = result;
// 						},
// 			    		error : function() {
// 							window.location.reload(true);
// 			    		}
// 			    	});
					//변경된 파일이 확장자가 같을 경우 이미지 캐시가 남아있어 변경되지 않는것처럼 보이는 현상 때문에 reload
					window.location.reload(true);
			    }
	
			    var address_zip_select_dialogArguments = new Array();
			    
				function zip_find() {
				    /* if (CrossYN()) { */
				    	var OpenWin;
				    	if (useAddressOpenAPI == "YES") {
				    		address_zip_select_dialogArguments[1] = jusoCallBack;
				    		OpenWin = GetOpenWindow("/ezAddress/addressZipCodePopUpOpen.do","address_zip_select", 570, 420, "YES");
				    	} else {
				        	address_zip_select_dialogArguments[1] = zip_find_Complete;
					        OpenWin = GetOpenWindow("/ezAddress/addressZipCodePopUp.do", "address_zip_select", 655, 620, "YES");
				    	}
				    /* }
				    else {
				        var Para = window.showModalDialog("/ezAddress/addressZipCodePopUp.do", "", "dialogWidth:655px;dialogHeight:620px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no" + GetShowModalPosition(655, 620));
				        
				        if (typeof (Para) != "undefined" || Para == "") {
				            document.getElementById("txtZipcode").value = Para[0];
				            document.getElementById("txtAddress").value = Para[1];
				        }
				    } */
				}
				
				function zip_find_Complete(Para) {
					if ((typeof (Para) != "undefined" || Para == "") && Para != "cancel") {
				        document.getElementById("txtZipcode").value = Para[0];
				        document.getElementById("txtAddress").value = Para[1];
				    }
				}
				
				function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
					document.getElementById("txtZipcode").value = zipNo;
					document.getElementById("txtAddress").value = roadFullAddr;
				}
				
				function change_press() {
					if (window.event.keyCode == "13")
					{
						event.returnValue = false;
						document.getElementById("ButtonChangePassword").click();
					}
				}
						
				// 2018-10-22 모바일설정 기능 추가 (yjks)
				function SettingMobile() {
					var wWeight = "660";
			        var wHeight = "370";
	
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
	
			        var left = (width - wWeight) / 2;
			        var top = (heigth - wHeight) / 2;
	
			        if (CrossYN()) {
			            var OpenWin = window.open("/ezPersonal/mobileManaged.do", "PersonPicture_Cross", GetOpenWindowfeature(wWeight, wHeight));
			            try { OpenWin.focus(); } catch (e) { }
			        } else {
			            var ret;
			            ret = window.showModalDialog("/ezPersonal/mobileManaged.do", "", "dialogWidth:405px;dialogHeight:280px;dialogleft:" + left + "px;dialogtop:" 
			            			+ top + "px;toolbar:no;location:no;directories:no;status:no;menubar:no;scroll:no;edge:sunken;help:no");
			            window.location.reload(true);
			        }
				}
				
			    function checkKey() {
					if(event.keyCode == 8) {
						event.target.value = "";
					} else {
						return false;
					}
			    }
			    
			    function ButtonDeleteClick() {
			    	var imgName = document.getElementById("myimg").src; //현재 이미지 src
			    	imgName = imgName.substr(imgName.lastIndexOf("/") + 1);
			    	
			    	var dImgName = "<spring:message code='ezPersonal.i1'/>"; //기본 이미지(사진이 없을 경우) src
			    	dImgName = dImgName.substring(dImgName.lastIndexOf("/") + 1, dImgName.lastIndexOf("."));
			    	
			    	if (imgName.indexOf(dImgName) < 0 && confirm("<spring:message code='ezPersonal.psb01'/>")) {
						$.ajax({
				    		type : "POST",
				    		dataType : "html",
				    		url : "/ezPersonal/deletePicture.do",
				    		success : function(result) {
				    			 if (result == "OK") {
				    				var literalPhoto = document.getElementById("LiteralPhoto"); 
				    				literalPhoto.innerHTML = "<image id=myimg <spring:message code='ezPersonal.i1'/>>";
				    			} 
							},
				    		error : function() {
				    			alert("<spring:message code='ezPersonal.t190'/>");
				    		}
				    	});
			    	}
			     }
			    
				function PassWordChange() {
					// 현재비밀번호가 없을 때
			    	if (document.getElementById('txtOldPassword').value == "") {
						alert("<spring:message code='ezPersonal.t947'/>");
					    document.all['txtOldPassword'].focus();
					    return;
					}
			    	// 새 비밀번호가 없을 때
			    	if (document.getElementById('txtNewPassword').value == "") {
			        	//alert("<spring:message code='ezPersonal.t195'/>");
			            alert("<spring:message code='main.jjh01'/>");
				        document.all['txtNewPassword'].focus();
				        return;
				    }
			    	
					var checkPw = checkPasswordPolicy({
						"pw" : document.getElementById('txtNewPassword').value,
						"useLoginCookie" : true
					});

			        if (!checkPw){
			        	document.getElementById('txtNewPassword').focus();
			        	return;
			        }	
			    	
			        if (document.getElementById('txtNewPassword').value != document.getElementById('txtNewPasswordConfirm').value) {
			            //alert("<spring:message code='ezPersonal.t193'/>");
			            alert("<spring:message code='main.jjh02'/>");
				        document.all['txtNewPassword'].focus();
				        return;
				    }
	
			        // 현재 비밀번호와 새 비밀번호가 동일 한 경우
			        if (document.getElementById('txtOldPassword').value == document.getElementById('txtNewPassword').value) {
			            alert("<spring:message code='ezPersonal.t194'/>");
				        document.all['txtNewPassword'].focus();
				    	return;
				    }
			        
                   /* 현재 persChangePersonInfo.jsp에만 있고, 의미 없는 것으로 보이기 때문에 주석처리 함.
					* - newPw 100자 이상 안됨.
					* 	1. Sep 1 2016	: 초기코드.	commit a9d6239fac seokz * ezHome 제거 -> main으로 변경    git-svn-id: svn://svn.opensol2014.com/repo1/ezEKP4Java@3220 746f5ef6-3e3b-473a-8c3d-618c0f8083c2
					* 	2. Mar 31 2017	: 주석.		commit 6c3e9149f1 JeongSeok Ji * 개인정보관리 비밀번호 관리 유효성검사 부분 수정
					* 	3. Apr 17 2017	: 주석해제됨. commit b030afd938 JeongSeok Ji * 콜론이 포함된 패스워드는 설정할 수 없게 수정
			       if (document.getElementById('txtNewPassword').value.Length > 100) {
						alert("<spring:message code='ezPersonal.t196'/>");
				    	document.all['txtNewPassword'].focus();
				    	return;
					} 
				    
					* - 특수문자 ':' 안됨.
					* 	1. Apr 17 2017	: 추가됨.	commit b030afd938 JeongSeok Ji * 콜론이 포함된 패스워드는 설정할 수 없게 수정
					if (document.getElementById('txtNewPassword').value.indexOf(':') > -1) {
						alert("<spring:message code='ezPersonal.t999900036'/>");
			        	document.all['txtNewPassword'].focus();
			     		return;
			     	}
					*/
			        
			        var xmlHTTP = createXMLHttpRequest();
			        var xmlPara = createXmlDom();
			        var xmlDom = createXmlDom();
			        var objRoot, objNode, subNode;
			        var objNode;
			        createNodeInsert(xmlDom, objNode, "DATA");
			        createNodeAndInsertText(xmlDom, objNode, "OLDPASSWORD", rsa.encrypt(document.getElementById('txtOldPassword').value));
			        createNodeAndInsertText(xmlDom, objNode, "NEWPASSWORD", rsa.encrypt(document.getElementById('txtNewPassword').value));
			        createNodeAndInsertText(xmlDom, objNode, "NEWPASSWORDCONFIRM", rsa.encrypt(document.getElementById('txtNewPasswordConfirm').value));
			        xmlHTTP.open("POST", "/ezPersonal/changePassword.do", false);
			        xmlHTTP.send(xmlDom);
			        // 수정(2007.02.07) : 사용자 생성/수정 루틴 변경 (BE 서버)
			        //var retVal = SelectSingleNodeValueNew(xmlHTTP.responseXML, "DATA");
	
			        if (xmlHTTP.status == 200) {
			            if (xmlHTTP.responseText == "OK") {
			                alert("<spring:message code='ezPersonal.t197'/>");
				            window.top.location.href = '/user/login/actionLogout.do';
			            } else if (xmlHTTP.responseText == "CHKERROR") {    
			                alert("<spring:message code='ezPersonal.t946'/>");
				        } else {
				            alert("<spring:message code='ezPersonal.t198'/>");
				        }
			        }
			    }
			    
			    function ButtonChangeClick() {
			    	var birthType = "";
			    	if ($("input:radio[id='RadBirthType1']").is(":checked") == true) {
			    		birthType = "Y";
			    	} else {
			    		birthType = "N";
			    	}
			    	
			    	<c:if test="${useMailAliasSettingOnLogin}">
			    	var aliasSaveSuccess = false;
			    	
			    	emailCheckContext.submit(function() {
			    		aliasSaveSuccess = true;
					});
					
					if (!aliasSaveSuccess) {
						return;
					}
			    	</c:if>
			    	
			    	var cn = "${userInfo.id}";
			    	
					$.ajax({
			    		type : "POST",
			    		dataType : "html",
			    		url : "/ezPersonal/saveUserInfo.do",
			    		async : false,
			    		data : {
			    			// 2024.02.13 한슬기 : cn, displayName 파라미터 변조하여 수정 불가능한 정보를 수정할 수 있는 문제. cn, displayName 제거
			    			//cn : cn,
			    			//displayName : "${labelDisplayName }",
			    			telephoneNumber : document.getElementById("txtTelePhone").value,
			    			mobile : document.getElementById("txtMobilePhone").value,
			    			homePhone : document.getElementById("txtHomePhone").value,
			    			facsimileTelephoneNumber : document.getElementById("txtFax").value,
			    			postalCode : document.getElementById("txtZipcode").value,
			    			streetAddress : document.getElementById("txtAddress").value,
			    			birth : document.getElementById("txtBirth").value,
			    			birthType : birthType,
			    			info : document.getElementById("txtInfo").value,
			    			extensionPhone : document.getElementById("txtExtensionPhone").value,
			    			officeMobile : document.getElementById("txtOfficeMobile").value
			    		},
			    		success : function(result) {   			
			    			 if (result == "OK") {
			    				 alert("<spring:message code='ezPersonal.t191'/>");
			    			} 
						},
			    		error : function() {
			    			<c:if test="${useMailAliasSettingOnLogin}">
			    			alert("<spring:message code='ezPersonal.t192.aliassuccess'/>");
			    			</c:if>
			    			<c:if test="${not useMailAliasSettingOnLogin}">
			    			alert("<spring:message code='ezPersonal.t192'/>");
			    			</c:if>
			    		}
			    	});
			     }
		  
		</script>
	</head>
	<body class="mainbody"> 
		<form method="post" action=""> 
    		<h1><spring:message code='ezPersonal.t172'/></h1>
    		<h2><spring:message code='ezPersonal.t173'/></h2>
    		<span class="txt">▒&nbsp;<spring:message code='ezPersonal.t174'/></span>
    		<table class="popuplist" width="50%" style="margin-top:5px;">
        		<tr> 
            		<td width="130" rowspan='<c:out value="${primaryLang eq '3' ? 7 : 6}" />' align="center">
                		<div> 
	  	                	<span id="LiteralPhoto">
        		          		${literalPhoto}
                    		</span>
                		</div>
            		</td>
					<th><spring:message code='ezPersonal.t67'/></th> 
            		<td width="100%">
                		${labelCompany }
            		</td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t7'/></th> 
            		<td>
                		${labelDepartment }
            		</td> 
        		</tr>
        		<c:if test="${primaryLang eq '3'}">
				<tr>
					<th><spring:message code='main.ksa01' /></th>
			  		<td>${LiteralFurigana }</td>
				</tr>
				</c:if>
        		<tr> 
            		<th><spring:message code='ezPersonal.t9'/></th> 
            		<td>
            			${labelDisplayName }
            		</td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t69'/></th> 
            		<td>
            			${labelTitle}
            		</td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t175'/></th> 
            		<td>
            			${labelJikChek}
            		</td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t176'/></th> 
					<c:if test="${useMailAliasSettingOnLogin}">
            		<td style="padding: 5px 0px 5px 5px; vertical-align: top;">
						<input id="email-input" type="text" value="${labelMail}" maxlength="20" spellcheck="false" style="ime-mode: disabled;"/>
						<span style="padding-left: 5px;">@${domainName}</span>
						<div class="btnpositionLayer" style="display: inline-block; margin: 0px; padding: 0px; padding-left: 5px; background: none; border: none; vertical-align: middle;">
							<a class="imgbtn" id="email-check"><span><spring:message code='email.alias.button' /></span></a>
						</div>
						<div id="checkmsg" style="height: 0px; opacity: 0; transition: 0.2s all;">
							<br>
						</div>
						<span><spring:message code='email.alias.login.warn' /></span>
					</td>
					</c:if>
					<c:if test="${not useMailAliasSettingOnLogin}">
					<td>
            			${labelMail}
            		</td> 
            		</c:if>
        		</tr> 
    		</table> 
    		<table class="content" width="50%" style="margin-top:10px;"> 
        		<tr>
            		<th><spring:message code='ezPersonal.t177'/></th>
            		<td width="230" style="width:50%"><input type="text" id="txtTelePhone" class="manualFlagNotYDisabled" size="22" value="${txtTelePhone}" maxlength="20" style="width:100%"></td>
            		<th><spring:message code='ezPersonal.t178'/></th>
            		<td><input type="text" id="txtMobilePhone" class="manualFlagNotYDisabled" size="22" value="${txtMobilePhone}" maxlength="20" style="width:100%"> </td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t70'/></th> 
            		<td style="width:50%"> <input type="text" id="txtHomePhone" class="manualFlagNotYDisabled" size="22" value="${txtHomePhone}" maxlength="20" style="width:100%"> </td> 
            		<th><spring:message code='ezPersonal.t179'/></th> 
            		<td> <input type="text" id="txtFax" class="manualFlagNotYDisabled" size="22" value="${txtFax}" maxlength="20" style="width:100%"> </td> 
        		</tr> 
				<tr style=<c:out value="${primaryLang eq '3' ? 'display:table-row' : 'display:none' }"/>>
				  	<th><spring:message code='main.ksa02' /></td>
				  	<td style="width:50%"><input type="text" id="txtExtensionPhone" size="22" value="${LiteralExtensionPhone }" maxlength="50" style="width:100%"></td>
				  	<th><spring:message code='main.ksa03' /></td>
				  	<td><input type="text" id="txtOfficeMobile" size="22" value="${LiteralOfficeMobile }" maxlength="50" style="width:100%"></td>
				</tr>
				<!-- /* 2021-05-03 김은실 - [표준] 집주소 영역을 사용하고자 하는 사이트는: style="display:none"을 삭제하면 된다. -->
        		<tr style="display:none"> 
            		<th rowspan="2"><spring:message code='ezPersonal.t180'/></th> 
            		<td colspan="3" class="onlyUseKo">
                		<c:if test="${primaryLang == '1'}">
                			<c:if test="${useZipCodeSearch == 'YES' && not useOnlyInnerMail}">
                				<input type="text" id="txtZipcode" size="10" value="${txtZipCode}" readonly>
                				<a class="imgbtn imgbck"><span onClick="zip_find();"><spring:message code='ezPersonal.t181'/></span></a>
                			</c:if>
                			<c:if test="${useZipCodeSearch == 'NO' || useOnlyInnerMail}">
                				<input type="text" id="txtZipcode" size="10" value="${txtZipCode}">
                				<span><spring:message code='ezPersonal.t181'/></span>
                			</c:if>
                		</c:if>
                		<c:if test="${primaryLang != '1'}">
                			<input type="text" id="txtZipcode" size="10" value="${txtZipCode}">
                			<span><spring:message code='ezPersonal.t181'/></span>
                		</c:if>
            		</td> 
        		</tr> 
        		<tr style="display:none"> 
            		<td colspan="3"> <input type="text" id="txtAddress" size="72" value="${txtAddress}" style="width:100%"> </td> 
        		</tr> 
        		<!-- */ -->
        		<tr>
            		<th><spring:message code='ezPersonal.t2003'/></th>
            		<td colspan="3" class="manualFlagNotYClickOff">
                		<input type="text" id="txtBirth" class="manualFlagNotYDisabled" style="width:80px;text-align:center;" value="${txtBirth}" oninput="this.value=this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" onkeydown="return checkKey()" readonly="readonly">
                			<img id="TempCalImage" src="/images/ImgIcon/calendar-month.png" style="margin-bottom:-5px"/>
                			&nbsp;&nbsp;
             			   <c:choose>
                				<c:when test="${birthType eq 'Y'}">
                					<span class="onlyUseKo"><div class="custom_radio"><input type="radio" id="RadBirthType1" class="manualFlagNotYDisabled" name="radioGroup"  checked></div><spring:message code='ezPersonal.t2001'/></span>
                					<span class="onlyUseKo"><div class="custom_radio"><input type="radio" id="RadBirthType2" class="manualFlagNotYDisabled" name="radioGroup" ></div><spring:message code='ezPersonal.t2002'/></span>
                				</c:when>                   
                				<c:otherwise>               
                					<span class="onlyUseKo"><div class="custom_radio"><input type="radio" id="RadBirthType1" class="manualFlagNotYDisabled" name="radioGroup" ></div><spring:message code='ezPersonal.t2001'/></span>
                					<span class="onlyUseKo"><div class="custom_radio"><input type="radio" id="RadBirthType2" class="manualFlagNotYDisabled" name="radioGroup"  checked></div><spring:message code='ezPersonal.t2002'/></span>
                				</c:otherwise>
                			</c:choose>
		            </td>
		        </tr>
        		<tr> 
            		<th><spring:message code='ezPersonal.t1820'/><br><spring:message code='ezPersonal.t182'/></th> 
            		<td colspan="3"><textarea id="txtInfo" style="WIDTH:98.3%;HEIGHT:80px;margin-top:3px;margin-bottom:3px; resize:none;" maxlength="450">${txtInfo}</textarea></td> 
        		</tr> 
    		</table> 
    		<div class="btnpositionJsp" style="width:50%">
    			<c:if test="${userMobileManaged == 'YES' }">
       				<a class="imgbtn" onClick="SettingMobile()"><span><spring:message code='ezPersonal.t998'/></span></a>
       			</c:if>
       			<a class="imgbtn manualFlagNotYOnClickEmpty" name="Submit" onClick="return btnPhoto_onclick()"><span><spring:message code='ezPersonal.t183'/></span></a>
       			<a class ="imgbtn manualFlagNotYOnClickEmpty"  onClick="ButtonDeleteClick()" name="ButtonDelete"  id="ButtonDelete" ><span><spring:message code='ezPersonal.t184'/></span></a>
       			<a class ="imgbtn" onClick="ButtonChangeClick()" name="ButtonChange"  id="ButtonChange" ><span><spring:message code='ezPersonal.t34'/></span></a>
       			<a class="imgbtn" name="Submit2" onClick="window.location.href='/ezPersonal/changePersonInfo.do'"><span><spring:message code='ezPersonal.t13'/></span></a>
    		</div>    		
    		<c:if test="${ezOffice365Auth == 'NO' && userManualFlag eq 'Y'}">
    		<h2><spring:message code='ezPersonal.t185'/></h2>
    		<div>▒ <spring:message code='ezPersonal.t186'/></div>
    		<div style="font-size:13px;margin-top:3px;">${pwPolicyExplain }</div> 		
    		<table class="content" style="margin-top:5px;width:50%">
        		<!-- 표준모듈 (2007.02.21) 수정 -->
        		<tr>
            		<th><spring:message code='ezPersonal.t187'/></th> 
            		<td> <input type="password" id="txtOldPassword" size="25" value="" onkeypress="change_press()" style="width:100%"> </td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t188'/></th> 
            		<td> <input type="password" id="txtNewPassword" size="25" value="" onkeypress="change_press()" style="width:100%"> </td> 
        		</tr> 
        		<tr> 
            		<th><spring:message code='ezPersonal.t189'/></th> 
            		<td> <input type="password" id="txtNewPasswordConfirm" size="25" value="" onkeypress="change_press()" style="width:100%"> </td> 
        		</tr>
    		</table> 
    		<div class="btnpositionJsp" style="width:50%">
        		<a class="imgbtn" onclick="return PassWordChange()"><span id="ButtonChangePassword"><spring:message code='ezPersonal.t34'/></span></a>
        		<a class="imgbtn" name="Submit2" onClick="window.location.href='/ezPersonal/changePersonInfo.do'"><span><spring:message code='ezPersonal.t13'/></span></a>
    		</div>
    		</c:if>
		</form>
	<br/>
	<br/>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
		<script type="text/javascript" src="${util.addVer('email.alias.lang', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email-check.js')}"></script>
		<script>
			emailCheckContext.setOnCheckEventListener(function() {
				document.getElementById("checkmsg").style.height = "15px";
			});
		</script>
	</body>
</html>