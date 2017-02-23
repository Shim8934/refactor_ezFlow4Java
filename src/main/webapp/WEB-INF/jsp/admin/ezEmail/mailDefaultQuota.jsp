<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mailDefaultQuota</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript">            
            function Save(pPath)
            {
                var defaultWarnInput = document.getElementById("defaultWarn");
                var defaultMaxInput = document.getElementById("defaultMax");
                
                if (defaultWarnInput.value == '' || !CheckNumber(defaultWarnInput.value)
                        || defaultMaxInput.value == '' || !CheckNumber(defaultMaxInput.value)) {
                    alert("<spring:message code='ezEmail.t99000066' />");
                    return;
                }
                
                if (parseFloat(Remove1000Sep(defaultWarnInput.value, ",", "")) > 2047
                        || parseFloat(Remove1000Sep(defaultMaxInput.value, ",", "")) > 2047) {
                    alert("<spring:message code='ezEmail.t71' />");
                    return;
                }
                
                var strXML = "<DATA>";
                strXML += "<WARNSTORAGE>" + parseFloat(Remove1000Sep(defaultWarnInput.value, ",", "") * 1024) + "</WARNSTORAGE>";
                strXML += "<MAXSTORAGE>" + parseFloat(Remove1000Sep(defaultMaxInput.value, ",", "") * 1024) + "</MAXSTORAGE>";
                strXML += "</DATA>";

                var xmlhttp = createXMLHttpRequest();
                xmlhttp.open("POST", "/admin/ezEmail/mailSaveDefaultQuota.do", false);
                xmlhttp.send(strXML);
                
                if (xmlhttp.responseText == "True") {
                    alert("<spring:message code='ezEmail.t42' />");
                    document.location.href = document.location.href;
                }
                else {
                    alert("<spring:message code='ezEmail.t228' />");
                    document.location.href = document.location.href;
                }
                xmlhttp = null;
            }

            function Mark1000Sep(obj) {
                if (obj.value == '') {
                    return;
                }

                if (!CheckNumber(obj.value)) {
                    alert("<spring:message code='ezEmail.t99000066' />");
                    return;
                }

                var strReturn = "";
                var nHeadCnt;
                var strAll = new String(obj.value);
                var strRight = (strAll.indexOf(".") >= 0 ? strAll.substr(strAll.indexOf("."), strAll.length) : "");
                var strMoney = (strAll.indexOf(".") >= 0 ? strAll.substr(0, strAll.indexOf(".")) : strAll);
                strMoney = strMoney.replace(/,/g, "");
                var nCommaCnt = Math.floor((strMoney.length - 1) / 3);
                nHeadCnt = strMoney.length - nCommaCnt * 3
                for (i = nCommaCnt; i >= 0; i--) {
                    if (i == nCommaCnt) strReturn = strReturn + strMoney.substr(0, nHeadCnt);
                    else strReturn = strReturn + "," + strMoney.substr(nHeadCnt + (nCommaCnt - i - 1) * 3, 3);
                }
                strReturn = strReturn + (strRight != "" ? strRight : "");
                obj.value = strReturn;
            }

            function Remove1000Sep(size) {
                return size.replace(/,/g, "");
            }

            function CheckNull(toCheck) {
                var chkstr = toCheck + "";
                var is_Space = true;

                if ((chkstr == "") || (chkstr == null))
                    return (true);

                for (j = 0 ; is_Space && (j < chkstr.length) ; j++) {
                    if (chkstr.substring(j, j + 1) != " ") {
                        is_Space = false;
                    }
                }
                return (is_Space);
            }


            function CheckNumber(toCheck) {
                var chkstr = toCheck + "";
                toCheck = toCheck.replace(/,/g, "");
                var isNum = true;

                if (CheckNull(toCheck))
                    return false;

                for (j = 0 ; isNum && (j < toCheck.length) ; j++) {
                    if ((toCheck.substring(j, j + 1) < "0") || (toCheck.substring(j, j + 1) > "9")) {
                        if (toCheck.substring(j, j + 1) != ".") {
                            if (toCheck.substring(j, j + 1) == "-" || toCheck.substring(j, j + 1) == "+") {
                                if (j != 0) {
                                    isNum = false;
                                }
                            }
                            else
                                isNum = false;
                        }
                    }
                }

                if (chkstr == "+" || chkstr == "-") isNum = false;

                return isNum;
            }
		</script>
	</head>
  <body class="mainbody">  
    <h1><spring:message code='ezEmail.t73' /></h1>   
    <span class="txt">* <spring:message code='ezEmail.t74' /></span>
    <table class="mainlist" id="SaveTBL" style="width:100%">
        <tr>
            <th style="width:120px; text-align:center"><spring:message code='ezEmail.t78' /></th>
            <th style="width:120px; text-align:center"><spring:message code='ezEmail.t80' /></th>
            <th>&nbsp;</th>
        </tr>     
        <tr>
            <td style="width:120px;">
                <input id="defaultWarn" type="text" onkeyup="return Mark1000Sep(this)" value="${defaultWarn}" style="width:100%; text-align:right">
            </td>        
            <td style="width:120px;">
                <input id="defaultMax" type="text" onkeyup="return Mark1000Sep(this)" value="${defaultMax}" style="width:100%; text-align:right">
            </td>
            <td style="white-space:nowrap;"><a href="#" class="imgbtn"><span onClick="Save('')"><spring:message code='ezEmail.t48' /></span></a></td>
        </tr>
    </table>
  </body>
</html>



