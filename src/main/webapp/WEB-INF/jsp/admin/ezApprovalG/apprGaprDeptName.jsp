<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<title>
	<c:if test ="${approvalFlag =='G'}"><spring:message code = 'ezApprovalG.lhj19' /></c:if>
	<c:if test = "${approvalFlag == 'S'}" ><spring:message code = 'ezApprovalG.lhj20' /></c:if>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript">
    function btn_SaveAprDeptTempletName_onclick() {
        var p_AprDeptTempletName = trim(document.getElementById('Text1').value);
        if (p_AprDeptTempletName.length <= 0) {
            var pAlertContent = "<spring:message code='ezApprovalG.t349'/>";
            OpenAlertUI(pAlertContent);

            document.getElementById('Text1').focus();
        }
        else {
        	  if (!CheckLen(document.getElementById('Text1'), 100)) {
                  return;
              }

              if (ReturnFunction != null) {
                  ReturnFunction(p_AprDeptTempletName);
                  //2018-09-03 관리자 팝업호출 close추가
                  window.close();
              }
              else {
                  window.returnValue = p_AprDeptTempletName;
                  window.close();
        }
    }
    }  
    function btn_CancelAprDeptTempletName_onclick() {
        window.returnValue = "cancel";
        window.close();    	
    }
    
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        try {
            RetValue = parent.aprdeptname_cross_dialogArguments[0];
            ReturnFunction = parent.aprdeptname_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.aprdeptname_cross_dialogArguments[0];
                ReturnFunction = opener.aprdeptname_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        document.getElementById('Text1').value = RetValue;
        document.getElementById('Text1').focus();
    }
    
    function OpenAlertUI(pAlertContent) {
        var parameter = pAlertContent;
        var url = "/ezApprovalG/ezAprAlert.do";
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    function trim(parm_str) {
        if (parm_str == "")
            return ""
        else
            return rtrim(ltrim(parm_str));
    }
    function ltrim(parm_str) {
        var str_temp = parm_str;
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
        var str_temp = parm_str;
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
    function CheckLen(pObj, pSize) {
        var ch;
        var count = 0;
        var pKoreanLen = parseInt(parseInt(pSize) / 2, 10);
        var nlen = pObj.value.length;
        for (var k = 0; k < nlen; k++) {
            ch = pObj.value.charAt(k);
            if (escape(ch).length > 4)
                count += 2;
            else
                count++;
        }
        if (parseInt(count) > parseInt(pSize)) {
            alert("<spring:message code='ezApprovalG.t343'/>" + pSize + " byte <spring:message code='ezApprovalG.t344'/>" + pKoreanLen + " <spring:message code='ezApprovalG.t345'/>");
            pObj.focus();
            return false;
        }
        else
            return true;
    }
</script>
</head>
<body class="popup">
	<h1>
		<c:if test ="${approvalFlag =='G'}"><spring:message code = 'ezApprovalG.lhj19' /></c:if>
		<c:if test = "${approvalFlag == 'S'}" ><spring:message code = 'ezApprovalG.lhj20' /></c:if>
	</h1>
	<div id="close">
        <ul>
            <li><span name="btn_CancelAprLineTempletName" id="btn_CancelAprLineTempletName" onclick="return btn_CancelAprDeptTempletName_onclick()"></span></li>
        </ul>
    </div>
	<h2><spring:message code='ezApprovalG.t350'/></h2>
	<div ID="Table2" class="nobox">
	<input class="text" type="text" id="Text1" name="TxtAprDeptTempletName" style="width:100%">
	</div>
	<div class="btnposition btnpositionNew" >
		<a class="imgbtn" name="btn_SaveAprLineTempletName" id="btn_SaveAprLineTempletName" onClick="return btn_SaveAprDeptTempletName_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
	</div>	
</body>
</html>






