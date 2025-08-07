<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1744'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var gUserID = "";
		    var rsa = new RSAKey();
		    
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    
		    var flag = true;
		    function btn_OpinionOK_onclick() {
		    	if (flag) {
		    		flag = false;
					
		        var rtnVal = "cancel";
		
		        if (trim(document.getElementById("inpPassword").value).length == 0) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1746'/>";
		            showAlert(pAlertContent, btn_OpinionOK_onclick_afterAlert);
// 		            document.getElementById("inpPassword").focus();
// 		            flag = true;
		            return;
		        }
		        else {
		            rtnVal = chkPasswd();
		        }
		        if (rtnVal != "FALSE") {
			        if (ReturnFunction != null)
			            ReturnFunction(rtnVal);
			        else
			            window.returnValue = rtnVal;
		        } else {
		        	flag = true;
		        	var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		    }
		    }
		    
		    function btn_OpinionOK_onclick_afterAlert() {
	            document.getElementById("inpPassword").focus();
	            flag = true;
		    }
		    
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = pAlertContent;
		            var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		            try { ezAPRALERT_Cross.focus(); } catch (e) {
		            }
		        } else {
		            var parameter = pAlertContent;
		            var url = "/ezApprovalG/ezAprAlert.do";
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		    
		    function OpenAlertUI_Complete() {
		    }
		    
		    function btn_OpinionCANCEL_onclick() {
		        if (ReturnFunction != null)
		            ReturnFunction("cancel");
		        else
		            window.returnValue = "cancel";
		        
		        window.close();
		    }
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
// 		        initKey();
				rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		        try {
		            RetValue = parent.ezchkpasswd_all_cross_dialogArguments[0];
		            ReturnFunction = parent.ezchkpasswd_all_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.ezchkpasswd_all_cross_dialogArguments[0];
		                ReturnFunction = opener.ezchkpasswd_all_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        gUserID = RetValue;
		    };
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		    function chkPasswd() {
		        try {
					var result = "";
		        	
		        	$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/chkPasswd.do",
						data : { passWd   : rsa.encrypt(document.all("inpPassword").value),
								 userID   : rsa.encrypt(gUserID)
								},
						success: function(text){
							result = text;
						}        			
					});
		
		            return result;
		        } catch (e) {
		        	 flag = true;
		            alert(e.description);
		            return "";
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
		            //스크롤바 생기는 현상 제거
		            document.getElementById("iFramePanel").style.top = "0px";
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
		    function trim(parm_str) {
		        return rtrim(ltrim(parm_str));
		    }
		    function ltrim(parm_str) {
		        str_temp = parm_str;
		        while (str_temp.length != 0) {
		            if (str_temp.substring(0, 1) == " ") {
		                str_temp = str_temp.substring(1, str_temp.length);
		            } else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		    function rtrim(parm_str) {
		        str_temp = parm_str;
		        while (str_temp.length != 0) {
		            int_last_blnk_pos = str_temp.lastIndexOf(" ");
		            if ((str_temp.length - 1) == int_last_blnk_pos) {
		                str_temp = str_temp.substring(0, str_temp.length - 1);
		            } else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		    
		    function password_OnKeyPress(e) {
		        if (e.keyCode == "13") {
		            btn_OpinionOK_onclick();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1745'/></h1>
		<div id="close">
            <ul>
                <li><span name="btn_OpinionCANCEL" id="btn_OpinionCANCEL" onclick="return btn_OpinionCANCEL_onclick()"></span></li>
            </ul>
        </div>
		<div class="txt"><p style="margin:6px">▒&nbsp;<spring:message code='ezApprovalG.t9999'/></p><p style="margin:6px">▒&nbsp;<spring:message code='ezApprovalG.t1746'/></p></div>
		<div class="nobox">
			<INPUT type="password" class="textarea" id="inpPassword" name="inpPassword" style="width:100%;height:25px;border:1px solid #ccc;margin-top:6px" onkeypress="password_OnKeyPress(event)">
		</div>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"><span name="btn_OpinionOK" id="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()"><spring:message code='ezApprovalG.t20' /></span></a>
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
