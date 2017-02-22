<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezOrgan.t168' /></title>
	<link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript">
    function window_onload() {
        main_change();

        /*
        check_change(document.getElementById("CheckQuota1"), document.getElementById("TextQuota1"));
        check_change(document.getElementById("CheckQuota2"), document.getElementById("TextQuota2"));
        */
        check_change(document.getElementById("CheckQuota3"), document.getElementById("TextQuota3"));
    }

    function check_change(checkbox, inputbox) {
        if (checkbox.checked == true) {
            document.getElementById("CheckUseDefault").checked = false;
            inputbox.readOnly = false;
        }
        else {
            inputbox.value = "";
            inputbox.readOnly = true;
        }
    }

    function main_change() {
        if (document.getElementById("CheckUseDefault").checked == true) {
            /*
            document.getElementById("CheckQuota1").checked = false;
            document.getElementById("CheckQuota2").checked = false;
            */
            document.getElementById("CheckQuota3").checked = false;

            /*
            check_change(document.getElementById("CheckQuota1"), document.getElementById("TextQuota1"));
            check_change(document.getElementById("CheckQuota2"), document.getElementById("TextQuota2"));
            */
            check_change(document.getElementById("CheckQuota3"), document.getElementById("TextQuota3"));
        }
    }

    function OK_Click() {
        for (i = 3; i < 4; i++) {
            if (document.getElementById("TextQuota" + i).value != "" && parseFloat(document.getElementById("TextQuota" + i).value) != document.getElementById("TextQuota" + i).value) {
                alert("<spring:message code='ezOrgan.t169' />");
                return;
            }

            if (parseInt(document.getElementById("TextQuota" + i).value) < 0 || parseInt(document.getElementById("TextQuota" + i).value) > 2047) {
                alert("<spring:message code='ezOrgan.t171' />");
                return;
            }
        }

        if (document.getElementById("CheckUseDefault").checked == false) {
            if (/*document.getElementById("TextQuota1").value == "" || document.getElementById("TextQuota2").value == "" || */document.getElementById("TextQuota3").value == "") {
                alert("<spring:message code='ezOrgan.t172' />");
                return;
            }
        }

        var xmlHTTP = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var xmlPara = createXmlDom();
        var objRoot, objNode, subNode;

        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "PARENTCN", "");
        createNodeAndInsertText(xmlpara, objNode, "CN", "${userId}");
        objRoot = createNodeAndInsertText(xmlpara, objNode, "PROP", "");
        if (document.getElementById("CheckUseDefault").checked == true) {
            createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "useDefault", "1");
        } else {
            createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "useDefault", "0");
        }

        /*
        createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "mDBStorageQuota", parseInt(document.getElementById("TextQuota1").value * 1024));
        createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "mDBOverQuotaLimit", parseInt(document.getElementById("TextQuota2").value * 1024));
        */
        createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "hardQuotaLimit", parseInt(document.getElementById("TextQuota3").value * 1024));

        xmlHTTP.open("POST", "/admin/ezOrgan/saveUserQuota.do", false);
        xmlHTTP.send(xmlpara);

        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
            alert("<spring:message code='ezOrgan.t173' />");
        } else {
            alert("<spring:message code='ezOrgan.t174' />");
            window.close();
        }
    }	
	</script>
</head>
<body class="popup" onload="javascript:window_onload()">
<form name="Form1" method="post" action="ConfigQuota.aspx?id=dev01" id="Form1">
  <h1 style="height:30px;"><spring:message code='ezOrgan.t168' /></h1>
    <br />
  <table  class="content">
    <tr>
      <th><spring:message code='ezOrgan.t175' /></th>
      <td><input id="CheckUseDefault" type="checkbox" name="CheckUseDefault" <c:if test="${userQuota == null}">checked="checked"</c:if> onclick="main_change();" /><spring:message code='ezOrgan.t176' /></td>
    </tr>
    <!--
    <tr>
      <th ><spring:message code='ezOrgan.t177' /></th>
      <td><input id="CheckQuota1" type="checkbox" name="CheckQuota1" onclick="check_change(document.getElementById('CheckQuota1'), document.getElementById('TextQuota1'));" />
        <input name="TextQuota1" type="text" value="" id="TextQuota1" />GB </td>
    </tr>
    <tr>
      <th ><spring:message code='ezOrgan.t178' /></th>
      <td><input id="CheckQuota2" type="checkbox" name="CheckQuota2" onclick="check_change(document.getElementById('CheckQuota2'), document.getElementById('TextQuota2'));" />
        <input name="TextQuota2" type="text" value="" id="TextQuota2" />GB </td>
    </tr>
    -->
    <tr>
      <th ><spring:message code='ezStatistics.t1024' /></th>
      <td><input id="CheckQuota3" type="checkbox" name="CheckQuota3" <c:if test="${userQuota != null}">checked="checked"</c:if> onclick="check_change(document.getElementById('CheckQuota3'), document.getElementById('TextQuota3'));" />
        <input name="TextQuota3" type="text" value="<c:if test="${userQuota != null}">${userQuota}</c:if>" id="TextQuota3" />GB </td>
    </tr>
  </table>
  <div class="btnposition">
       <a class="imgbtn"><span onClick="return OK_Click()"><spring:message code='ezOrgan.t124' /></span></a>
      <a class="imgbtn"><span onClick="window.close()"><spring:message code='ezOrgan.t125' /></span></a>
  </div>
</form>
</body>
</html>
