<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<title><spring:message code="ezSystem.ksaPwPolicy01" /></title>
</head>
<body class="mainbody" style="overflow:hidden;">
<div class="contentlist_layout">
	<h1>
		<spring:message code='ezSystem.ksaPwPolicy01' />
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select class="companySelect" id="companyList" onchange="company_change()">
			<c:forEach var="company" items="${companyList}">
				<option value="${company.cn }" ${company.cn eq companyID ? 'selected' : ''}><c:out value='${company.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>
	<br>
	
	<span class="txt">▒ <spring:message code='ezSystem.ksaPwPolicy02' /></span>
	<br><br>
	
	<div id="Personal_Config_DIV">
		<div <c:if test="${isDotNetAdmin eq true}">style="display:none;"</c:if>>
		    <h2 class="h2_dot"><spring:message code='ezSystem.ksaPwPolicy03' /></h2>
		    <table class="content">
		        <tbody>
		            <tr>
		                <th><spring:message code='ezSystem.x0005' /></th>
		                <td>
		                    <select id="UseMaxPeriod" onchange="UseMaxPeriod_onChange(this)">
		                        <option value="notuse" checked><spring:message code='ezSystem.ksaPwPolicy07' /></option>
		                        <option value="use"><spring:message code='ezSystem.ksaPwPolicy06' /></option>
		                    </select>
		                    <input type="int" id="MaxPeriodNumber" style="width: 50px; " maxlength="3">
		                    	<spring:message code='ezSystem.ksaPwPolicy24' />
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezSystem.x0038' /></th>
		                <td>
		                    <select id="UseMaxLoginFailCount" onchange="UseMaxLoginFailCount_onChange(this)">
		                        <option value="notuse" checked><spring:message code='ezSystem.ksaPwPolicy07' /></option>
		                        <option value="use"><spring:message code='ezSystem.ksaPwPolicy06' /></option>
		                    </select>
		                    <input type="int" id="MaxLoginFailCount" style="width: 50px;" maxlength="4">
		                    	<spring:message code='ezSystem.ksaPwPolicy25' />
		                </td>
		            </tr>
					<tr>
						<th><spring:message code='ezSystem.x0050' /></th>
						<td>
							<input type="int" id="LoginLockedDuration" style="width: 50px;" maxlength="4">
							<spring:message code='ezSystem.x0051' />
						</td>
					</tr>
		            <tr>
		                <th><spring:message code='ezSystem.ls01' /></th>
		                <td>
		                    <select id="ProhUsePrevPwd">
		                        <option value="yes"><spring:message code='ezSystem.hsb01' /></option>
		                        <option value="no" checked><spring:message code='ezSystem.hsb02' /></option>
		                    </select>
		                </td>
		            </tr>
					<tr id="rememberPWCount" style="display: none">
						<th><spring:message code="ezSystem.kdh08"/> </th>
						<td>
							<select id="PrevPwdCount" >
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
							</select>
						</td>
					</tr>
		        </tbody>
		    </table>
		</div>
		
	    <h2 class="h2_dot" style="margin-top:15px"><spring:message code='ezSystem.ksaPwPolicy04' /></h2>
	    <table class="content">
	        <tbody>
	            <tr>
	                <th><spring:message code='ezSystem.ksaPwPolicy05' /></th>
	                <td>
	                    <select id="UsePatternPolicy" onchange="UsePatternPolicy_onChange(this)">
	                        <option value="notuse" checked><spring:message code='ezSystem.ksaPwPolicy07' /></option>
	                        <option value="use"><spring:message code='ezSystem.ksaPwPolicy06' /></option>
	                    </select>
	                </td>
	            </tr>
	        </tbody>
	    </table>
	    
	    <table id="tblPatternPolicy" class="content" style="margin-top: 10px; display:none;">
	        <tbody>
	            <tr>
	                <th><spring:message code='ezSystem.ksaPwPolicy08' /></th>
	                <td>
	                    <select id="UseEngType" onchange="UseEngType_onChange(this)">
	                        <option value="notuse" checked><spring:message code='ezSystem.ksaPwPolicy09' /></option>
	                        <option value="use"><spring:message code='ezSystem.ksaPwPolicy10' /></option>
	                    </select>
	                </td>
	            </tr>
	            <tr>
	                <td colspan="2" style="padding-left:20px">
	                    <input type="checkbox" id="chkEngCapitalLetter" name="chkPattern" onchange="Pattern_onchange()" disabled="" style="background-color: rgb(235, 235, 228);">&nbsp;<spring:message code='ezSystem.ksaPwPolicy11' />&nbsp;&nbsp;
	                    <input type="checkbox" id="chkEngSmallLetter" name="chkPattern" onchange="Pattern_onchange()" disabled="" style="background-color: rgb(235, 235, 228);">&nbsp;<spring:message code='ezSystem.ksaPwPolicy12' />
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezSystem.ksaPwPolicy13' /></th>
	                <td>
	                    <input type="checkbox" id="chkNumber" name="chkPattern" onchange="Pattern_onchange()">
	                </td>
	            </tr>
	            <tr>
	                <th style="border-bottom:2px dashed #b0b0b0"><spring:message code='ezSystem.ksaPwPolicy14' /></th>
	                <td style="border-bottom:2px dashed #b0b0b0">
	                    <input type="checkbox" id="chkSpecial" name="chkPattern" onchange="Pattern_onchange()">
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezSystem.ksaPwPolicy15' /></th>
	                <td id="tdPattern"></td>
	            </tr>
				<c:forEach begin="0" end="3" var="i">
		            <tr>
		                <td id="tdAdd${4-i}" _Pattern='Y' _PatternCnt="${4-i}" colspan="2" style="padding-left:20px">
		                    <spring:message code='ezSystem.ksaPwPolicy19' arguments="${4-i}" /> : 
		                    <select onchange="AddCheck_onChange(this)">
		                        <option value="unlimit"><spring:message code='ezSystem.ksaPwPolicy20' /></option>
		                        <option value="limit"><spring:message code='ezSystem.ksaPwPolicy06' /></option>
		                        <option value="notuse"><spring:message code='ezSystem.ksaPwPolicy21' /></option>
		                    </select>
		                    &nbsp;<input type="int" style="width:30px;ime-mode: disabled;" maxlength="2" /> 
		                    <spring:message code='ezSystem.ksaPwPolicy26' />
		                </td>
		            </tr>
	            </c:forEach>
	        </tbody>
	    </table>
		<div class="btnpositionJsp">
			<a id="btn_save" onClick="saveOnClick()" class="imgbtn"><span><spring:message code='ezSystem.ksaPwPolicy22' /></span></a>
			<a id="btn_cancle" onClick="cancelOnClick()" class="imgbtn"><span><spring:message code='ezSystem.ksaPwPolicy23' /></span></a>
		</div>
	</div>
</div>
<script type="text/javascript">
	var select_companyList = document.getElementById("companyList");

	window.onload = function () {
		company_change();
		
		document.getElementById('ProhUsePrevPwd').addEventListener('change', function() {
			var selectedValue = this.value;
			var value = document.getElementById('rememberPWCount');
			
			value.style.display = selectedValue === 'yes' ? '' : 'none';
		});
    };
    
    function company_change() {
        GetPWDPolicy();
    }

	function GetPWDPolicy() {
		var selectCompany = select_companyList.value;

		$.ajax({
			type:"POST",
			data:{"companyId":selectCompany},
			url:"/admin/ezSystem/getPasswordPolicy.do",
			success:function(data) {
				onreadystatechange_GetPWDPolicy(data);
			}, error : function() {
				alert("<spring:message code='ezEmail.lhm14'/>");
			}
		})
    }
	
	function onreadystatechange_GetPWDPolicy(data) {
        if (data == "") return;
        
        var expirePassPeriod = data.expirePassPeriod; // 암호 만료기간
    	var useExpirePassPeriod_Val = (expirePassPeriod <= 0) ? "notuse" : "use"; 
    	var maxPeriodNum_Val = (expirePassPeriod <= 0) ? "" : expirePassPeriod;
        document.getElementById("UseMaxPeriod").value = useExpirePassPeriod_Val; // 암호 만료기간 사용여부
        document.getElementById("MaxPeriodNumber").value = maxPeriodNum_Val; // 암호 만료기간 n일

        var maxLoginFailCount = data.maxAllowedCountOfLoginFail; // 암호 최대 오류 횟수
        var useMaxLoginCount_Val = (maxLoginFailCount <= 0) ? "notuse" : "use";
    	var maxLoginFailNum_Val = (maxLoginFailCount <= 0) ? "" : maxLoginFailCount;
        document.getElementById("UseMaxLoginFailCount").value = useMaxLoginCount_Val; // 암호 최대 오류 횟수 사용여부
        document.getElementById("MaxLoginFailCount").value = maxLoginFailNum_Val; // 암호 최대 오류 횟수 n번

		var loginLockedDuration = data.LoginLockedDuration; // 계정 잠금 처리 시간
		var loginLockedDuration_Val = (loginLockedDuration <= 0) ? "" : loginLockedDuration;
		document.getElementById("LoginLockedDuration").value = loginLockedDuration_Val; // 암호 최대 오류 횟수 n번
        
        var prohUsePrevPwd = data.useChkPrevPwd; // 2021-11-10 이사라 : 가장 최근 암호 사용 금지 여부
        var prohUsePrevPwd_Val = prohUsePrevPwd == "NO" ? "no" : "yes";
        document.getElementById("ProhUsePrevPwd").value = prohUsePrevPwd_Val;

        var usePwPatternPolicy = data.usePasswordPatternPolicy; // 암호 패턴 사용 여부
       	var usePwPatternPolicy_Val = usePwPatternPolicy == "NO" ? "notuse" : "use"; 
       	document.getElementById("UsePatternPolicy").value = usePwPatternPolicy_Val;
		   
		var rememberPWCount = data.rememberPWCount;
		var element = document.getElementById('PrevPwdCount');  //select box
		for (var i=0; i<element.length; i++){
			//select box의 option value가 입력 받은 value의 값과 일치할 경우 selected
			if(element.options[i].value == rememberPWCount){
				element.options[i].selected = true;
			}
		}

		var value = document.getElementById('rememberPWCount');
		value.style.display = prohUsePrevPwd_Val === 'yes' ? '' : 'none';
		
        
        var pwPolicyMap = data.pwPolicyMap;
        if (pwPolicyMap != null && typeof pwPolicyMap != "undefined") {
        	var pwPolicy = pwPolicyMap.pwPolicy;
            var pwPolicyPattern = pwPolicyMap.pwPolicyPattern;
            
            var pEngCharType = pwPolicy.ENG_CHAR_TYPE; // 영문 대/소문자 패턴 구분 사용여부 및 대 소문자 구분
            if (emptyCheck(pEngCharType)) {
            	var usePatternPolicy = pEngCharType == "N" ? "notuse" : "use"; 
            	document.getElementById("UseEngType").value = usePatternPolicy;
            	
            	var engCapitalLetter = pwPolicy.USE_ENG_CAPITAL_LETTER;
            	engCapitalLetter = (engCapitalLetter == "N" || pEngCharType == "N") ? true : false ;
            	var engSmallLetter = pwPolicy.USE_ENG_SMALL_LETTER;
            	engSmallLetter = (engSmallLetter == "N" || pEngCharType == "N") ? true : false ;
            	
            	document.getElementById("chkEngCapitalLetter").checked = engCapitalLetter;
                document.getElementById("chkEngSmallLetter").checked = engSmallLetter;
            }
           
            var pUseNumber = pwPolicy.USE_NUMBER; // 숫사 사용여부
            if (emptyCheck(pUseNumber)) {
            	var useNumber = pUseNumber == "N" ? true : false; 
                document.getElementById("chkNumber").checked = useNumber;
            }
            
            var pUseSpecialChar = pwPolicy.USE_SPECIAL_CHAR; // 특수문자
            if (emptyCheck(pUseSpecialChar)) {
            	var useSpecialChar = pUseSpecialChar == "N" ? true : false; 
                document.getElementById("chkSpecial").checked = useSpecialChar;
            }
            
            var matcheElements = document.querySelectorAll("td[_PatternCnt]");
            
            Array.prototype.forEach.call(matcheElements,function(e, i) {
	   			var querySelectElement = e.querySelector("SELECT");
	   			querySelectElement.value = "unlimit";
        	});
            <%-- IE에서는 forEach 메소드 미지원해서 위와 같이 수정. 2021-04-23 심기영
            matcheElements.forEach(function(e, i) {
	   			var querySelectElement = e.querySelector("SELECT");
	   			querySelectElement.value = "unlimit";
        	});
            --%>
            
            if (pwPolicyPattern.length > 0) {
	            for (var i = 0; i < pwPolicyPattern.length; i++) {
	            	var nowPattern = pwPolicyPattern[i];
	            	if (nowPattern.USE_PATTERN_COUNT != "") {
	            		var QueryElement = document.querySelector("TD[_PatternCnt='" + nowPattern.USE_PATTERN_COUNT + "']");
	            		var QuerySelectElement = QueryElement.querySelector("SELECT");
	                    var QueryInputElement = QueryElement.querySelector("INPUT");
	                    
	                    if (QueryElement != null) {
	                    	var numberChar = nowPattern.NUMBER_OF_CHAR;
	                        if (numberChar == "0") {
	                            if (QuerySelectElement != null) {
	                                QuerySelectElement.value = "notuse";
	                            }
	                        }
	                        else {
	                            if (QuerySelectElement != null) {
	                                QuerySelectElement.value = "limit";
	                                if (QueryInputElement != null) {
	                                    QueryInputElement.value = numberChar;
	                                }
	                            }
	                        }
	                    }
	            	}
	            }
            }
        } else {
        	document.getElementById("chkEngCapitalLetter").checked = false;
        	document.getElementById("chkEngSmallLetter").checked = false;
        	document.getElementById("chkNumber").checked = false;
        	document.getElementById("chkSpecial").checked = false;
        	
        	var matcheElements = document.querySelectorAll("td[_PatternCnt]");
            matcheElements.forEach(function(e, i) {
	   			var querySelectElement = e.querySelector("SELECT");
	   			querySelectElement.value = "notuse";
        	});
        }
        
        initContent();
    }
	
	function initContent() {
         UseMaxPeriod_onChange(document.getElementById("UseMaxPeriod"));
         UseMaxLoginFailCount_onChange(document.getElementById("UseMaxLoginFailCount"));
         UsePatternPolicy_onChange(document.getElementById("UsePatternPolicy"));
         UseEngType_onChange(document.getElementById("UseEngType"));

         Pattern_onchange();

         var matcheElements = document.querySelectorAll("td[_PatternCnt]");
         matcheElements.forEach(function(e, i) {
			var querySelectElement = e.querySelector("SELECT");
			if (querySelectElement != null) {
			    AddCheck_onChange(querySelectElement);
			}
     	});
         /* if (matcheElements.length > 0) {
             for (var i=0; i < matcheElements.length; i++) {
                 var querySelectElement = matcheElements[i].querySelector("SELECT");
                 if (querySelectElement != null) {
                     AddCheck_onChange(querySelectElement);
                 }
             }
         } */
     }	

	function UseMaxPeriod_onChange(thisObj) {
		var disabledChk = thisObj.value == "use" ? false : true;
		var disabledColor = thisObj.value == "use" ? "" : "#EBEBE4";
		
        document.getElementById("MaxPeriodNumber").disabled = disabledChk;
        document.getElementById("MaxPeriodNumber").style.backgroundColor = disabledColor;
        if (disabledChk) {
	        document.getElementById("MaxPeriodNumber").value = "";
        }
    }
	
	function UseMaxLoginFailCount_onChange(thisObj) {
		var disabledChk = thisObj.value == "use" ? false : true;
		var disabledColor = thisObj.value == "use" ? "" : "#EBEBE4";
		
        document.getElementById("MaxLoginFailCount").disabled = disabledChk;
        document.getElementById("MaxLoginFailCount").style.backgroundColor = disabledColor;
        document.getElementById("LoginLockedDuration").disabled = disabledChk;
        document.getElementById("LoginLockedDuration").style.backgroundColor = disabledColor;
        if (disabledChk) {
	        document.getElementById("MaxLoginFailCount").value = "";
	        document.getElementById("LoginLockedDuration").value = "";
        }
	}

    function UsePatternPolicy_onChange(thisObj) {
		var disabledChk = thisObj.value == "use" ? "" : "none";
        document.getElementById("tblPatternPolicy").style.display = disabledChk;
    }

    function UseEngType_onChange(thisObj) {
		var disabledChk = thisObj.value == "use" ? false : true;
		var disabledColor = thisObj.value == "use" ? "" : "#EBEBE4";

        document.getElementById("chkEngCapitalLetter").disabled = disabledChk;
        document.getElementById("chkEngCapitalLetter").style.backgroundColor = disabledColor;
        document.getElementById("chkEngSmallLetter").disabled = disabledChk;
        document.getElementById("chkEngSmallLetter").style.backgroundColor = disabledColor;

        if (thisObj.value != "use") {
            document.getElementById("chkEngCapitalLetter").checked = false;
            document.getElementById("chkEngSmallLetter").checked = false;
        }
        
        Pattern_onchange();
    }
	
    function Pattern_onchange() {
        var PatternContent = "";
        var PatternCount = 0;
        if (document.getElementById("UseEngType").value == "use") {
            if (!document.getElementById("chkEngCapitalLetter").checked) {
                PatternContent = (PatternCount + 1).toString() + ". " + "<spring:message code='ezSystem.ksaPwPolicy27' />";
                PatternCount += 1;
            }

            if (!document.getElementById("chkEngSmallLetter").checked) {
                if (PatternContent !== "") {
                    PatternContent += ", ";
                }
                PatternContent += (PatternCount + 1).toString() + ". " + "<spring:message code='ezSystem.ksaPwPolicy28' />";
                PatternCount += 1;
            }
        }
        else {
            PatternContent = (PatternCount + 1).toString() + ". " + "<spring:message code='ezSystem.ksaPwPolicy16' />";
            PatternCount += 1;
        }

        if (!document.getElementById("chkNumber").checked) {
            if (PatternContent !== "") {
                PatternContent += ", ";
            }
            PatternContent += (PatternCount + 1).toString() + ". " + "<spring:message code='ezSystem.ksaPwPolicy17' />";
            PatternCount += 1;
        }
        
        if (!document.getElementById("chkSpecial").checked) {
            if (PatternContent !== "") {
                PatternContent += ", ";
            }
            PatternContent += (PatternCount + 1).toString() + ". " + "<spring:message code='ezSystem.ksaPwPolicy18' />";
            PatternCount += 1;
        }

        document.getElementById("tdPattern").innerText = PatternContent;
        for (var i = 0; i < 4; i++) {
            if (i < PatternCount) {
                document.getElementById("tdAdd" + (i + 1).toString()).style.display = "";
            }
            else {
                document.getElementById("tdAdd" + (i + 1).toString()).style.display = "none";
                document.getElementById("tdAdd" + (i + 1).toString()).querySelector("select").selectedIndex = 0;
                document.getElementById("tdAdd" + (i + 1).toString()).querySelector("input[type=int]").value = "";
                document.getElementById("tdAdd" + (i + 1).toString()).querySelector("input[type=int]").disabled = true;
                document.getElementById("tdAdd" + (i + 1).toString()).querySelector("input[type=int]").style.backgroundColor = "#EBEBE4";
            }
        }
    }
	
	function emptyCheck(obj) {
		return (obj != null && obj != "undefined" && obj != "") ? true : false;
	}
    
	function saveOnClick() {
	    SetPWDPolicy();
	}

	function cancelOnClick() {
	    GetPWDPolicy();
	}
    
	function SetPWDPolicy() {
		var selectCompany = select_companyList.value;

		if (!SetPWDPolicy_check()) {return; }
		
		var setUsePeriod = document.getElementById("UseMaxPeriod").value == "use" ? document.getElementById("MaxPeriodNumber").value : "0";
	    var setLoginFailCnt= document.getElementById("UseMaxLoginFailCount").value == "use" ? document.getElementById("MaxLoginFailCount").value : "0";
	    var setLoginLockedDuration= document.getElementById("UseMaxLoginFailCount").value == "use" ? document.getElementById("LoginLockedDuration").value : "0";
	    var setProhUsePrevPwd = document.getElementById("ProhUsePrevPwd").value == "yes" ? "YES" : "NO"; // 2021-11-10 이사라
	    var setRememberPWCount = document.getElementById("PrevPwdCount").value; // 2024-07-16 김대현
		var setUsePatternPolicy = document.getElementById("UsePatternPolicy").value == "use" ? "YES" : "NO";
		
		var data = new Object();
		data.companyId = selectCompany;
		data.setConfig = [
		              	{name : "ExpirePassPeriod", value : setUsePeriod},
		              	{name : "MaxAllowedCountOfLoginFail", value : setLoginFailCnt},
		              	{name : "LoginLockedDuration", value : setLoginLockedDuration},
		              	{name : "useChkPrevPwd", value : setProhUsePrevPwd}, // 2021-11-10 이사라
		              	{name : "RememberPWCount", value :setRememberPWCount}, // 2024-07-16 김대현
		              	{name : "UsePasswordPatternPolicy", value : setUsePatternPolicy}
		               ];
		data.patternType = {"useEngType" : document.getElementById("UseEngType").value == "use" ? "Y" : "N",
		                    "engCapitalLetter" : document.getElementById("chkEngCapitalLetter").checked ? "N" : "Y",
		                    "engSmallLetter" : document.getElementById("chkEngSmallLetter").checked ? "N" : "Y",
		                    "useNumber" : document.getElementById("chkNumber").checked ? "N" : "Y",
		                    "useSpecial" : document.getElementById("chkSpecial").checked ? "N" : "Y"
		                   };
		data.patternSetting;
	    
		var matcheElements = document.querySelectorAll("td[_Pattern='Y']");
		var patternSettingTmp = new Array();
	    for (var i = 0; i < matcheElements.length; i++) {
            var SELECTObj = matcheElements[i].querySelector("SELECT");
            if (SELECTObj !== null) {
            	var obj = new Object();
                if (SELECTObj.value == "limit") {
                	obj.settingCnt = matcheElements[i].getAttribute("_PatternCnt");
                	obj.settingNumber = matcheElements[i].querySelector("input[type=int]").value;

                	patternSettingTmp.push(obj);
                }
                else if (SELECTObj.value == "notuse") {
                	obj.settingCnt = matcheElements[i].getAttribute("_PatternCnt");
                	obj.settingNumber = "0";

                	patternSettingTmp.push(obj);
                }
            }
	    }
	    data.patternSetting = patternSettingTmp;

		$.ajax({
			type:"POST",
			data:{"data":JSON.stringify(data)},
			url:"/admin/ezSystem/updatePasswordPolicy.do",
			success:function() {
				alert("<spring:message code='main.sp10'/>");
				GetPWDPolicy();
			}, error : function() {
				alert("<spring:message code='main.sp12'/>");
			}
		})
		
	}

	function SetPWDPolicy_check() {
		// 암호 사용기간 설정을 사용으로 했을 경우 기간 입력 체크
		if (document.getElementById("UseMaxPeriod").value == "use") {
			var maxPeriodNumVal = document.getElementById("MaxPeriodNumber").value;
		    if (maxPeriodNumVal == "" || Number(maxPeriodNumVal) <= 0) {
		        alert("<spring:message code='ezSystem.ksaPwPolicy29' />");
		        return false;
		    }
		}
		// 암호 오류 최대 횟수 사용으로 했을 경우 횟수 입력 체크
		if (document.getElementById("UseMaxLoginFailCount").value == "use") {
			var maxLoginFailCntVal = document.getElementById("MaxLoginFailCount").value;
			var loginLockedDurationVal = document.getElementById("LoginLockedDuration").value;
		    if (maxLoginFailCntVal == "" || Number(maxLoginFailCntVal) <= 0) {
		        alert("<spring:message code='ezSystem.ksaPwPolicy30' />");
		        return false;
		    } else if (loginLockedDurationVal == "" || Number(loginLockedDurationVal) <= 0) {
				alert("<spring:message code='ezSystem.khjPwPolicy37' />");
				return false;
			}
		}
		// 암호 패턴 설정 사용여부
		if (document.getElementById("UsePatternPolicy").value == "use") {
	        // 암호패턴 체크 확인
	        var chkPatternElements = document.getElementsByName("chkPattern");
	        var chkPattern_CheckCount = 0;
	        for (var i = 0; i < chkPatternElements.length; i++) {
	            if (chkPatternElements[i].checked) {
	                chkPattern_CheckCount++;
	            }
	        }
	
	        if (chkPattern_CheckCount == 4) {
	            alert("<spring:message code='ezSystem.ksaPwPolicy31' />");
	            return false;
	        }
	
	        // 암호 패턴별 설정 입력 체크
	        var matcheElements = document.querySelectorAll("td[colspan='2']");
	        var totalCount = 0;
	        var notUseCount = 0;
	        if (matcheElements.length > 0) {
	            for (var i = 0; i < matcheElements.length; i++) {
	                if (matcheElements[i].style.display == "") {
	                    var SELECTObj = matcheElements[i].querySelector("SELECT");
	                    if (SELECTObj !== null) {
	                        totalCount++;
	                        if (SELECTObj.value == "limit") {
	                        	var limitVal = matcheElements[i].querySelector("input[type=int]").value;
	                            if (limitVal == "" || Number(limitVal) <= 0) {
	                	            alert("<spring:message code='ezSystem.ksaPwPolicy32' />");
	                                return false;
	                            }
	                        }
	                        else if (SELECTObj.value == "notuse") {
	                            notUseCount++;
	                        }
	                    }
	                }
	            }
	
	            if (totalCount > 0 && notUseCount > 0 && totalCount == notUseCount) {
    	            alert("<spring:message code='ezSystem.ksaPwPolicy33' />");
	                return false;
	            }
	        }
	    }
		
		return true;
	}
      
	function AddCheck_onChange(thisObj) {
	    var TextBoxObj = thisObj.parentElement.querySelector("input[type=int]");
	    if (TextBoxObj !== null) {
	        if (thisObj.value == "limit") {
	            TextBoxObj.disabled = false;
	            TextBoxObj.style.backgroundColor = "";
	        }
	        else {
	            TextBoxObj.value = "";
	            TextBoxObj.disabled = true;
	            TextBoxObj.style.backgroundColor = "#EBEBE4";
	        }
	    }
	}
	
</script>

</body>
</html>