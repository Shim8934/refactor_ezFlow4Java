<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mailDefaultQuota</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript">
			var userCompany = "${userCompany}";
			var companyId;

			window.onload = function() {
				companyId = userCompany;
				getCompanyQuota();
			}

			// 회사 선택
			function companyChange() { 
				companyId = document.getElementById("companyList").value;
				getCompanyQuota();
			}
			
			// 회사별 메일박스정책 가져오기
			function getCompanyQuota() {
				$.ajax({
					type : "POST",
					url : "/admin/ezEmail/getDefaultQuota.do",
					dataType : "json",
					data : {"companyId" : companyId},
					success : function(data) {
						var companyWarn = data.companyWarn;
						var companyMax = data.companyMax;
						document.getElementById("defaultWarn").value = companyWarn;
						document.getElementById("defaultMax").value = companyMax;
					},
					error : function () {
						alert("error");
					}
				});
			}

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
                
                // 2018.05.09 재은 수정 (경고알림이 총용량보다 더 크거나 같을경우)
                if (Number(defaultWarnInput.value) >= Number(defaultMaxInput.value)) {
                	alert("<spring:message code='ezEmail.jje01' />");
                	return;
                }
                
                var strXML = "<DATA>";
				strXML += "<COMPANYID>" + companyId + "</COMPANYID>";
                strXML += "<WARNSTORAGE>" + parseFloat(Remove1000Sep(defaultWarnInput.value, ",", "") * 1024) + "</WARNSTORAGE>";
                strXML += "<MAXSTORAGE>" + parseFloat(Remove1000Sep(defaultMaxInput.value, ",", "") * 1024) + "</MAXSTORAGE>";
                strXML += "</DATA>";

                var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezEmail/mailSaveDefaultQuota.do", false);
				xmlhttp.send(strXML);
                
				if (xmlhttp.responseText == "True") {
                    alert("<spring:message code='ezEmail.t42' />");
					getCompanyQuota();
                }
                else {
                    alert("<spring:message code='ezEmail.t228' />");
					getCompanyQuota();
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
            function valuePlus(target){
            	if (target.value == "") {
            		target.value = 0.0;
            	}
            	var num = parseFloat(target.value) + parseFloat('1');
            	target.value = num.toFixed(1);
            }
			function valueMinuse(target){
            	if (target.value == "") {
            		target.value = 0.0;
            	}
				var num = parseFloat(target.value) - parseFloat('1');
				if (num >= 0) {
	            	target.value = num.toFixed(1);
				}
            }
		</script>
	</head>
  <body class="mainbody">  
    <h1>
		<spring:message code='ezEmail.t73' />
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select id="companyList" class="companySelect" onchange="companyChange(this);">
			<option value="*"><spring:message code='ezEmail.t588' /></option>
			<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>   
    <span class="txt" style="margin-top:30px;display: block">* <spring:message code='ezEmail.t74' /></span><p>
    <div style="width:310px;">
	    <div style="border: 1px solid #dbdbda;">
		    <table class="mainlist" id="SaveTBL" style="width:100%">
		        <tr>
		            <th style="width:100px; text-align:center; border-top:0px; border-right:1px solid #dbdbda;"><spring:message code='ezEmail.t78' /></th>
		            <td style="width:125px; border-right:1px solid #dbdbda;">
		                <input id="defaultWarn" type="text" onkeyup="return Mark1000Sep(this)" value="${defaultWarn}" style="width:80%; text-align:right"> GB
		            </td>
		        	<td style="width:40px;text-align: center">
		        		<img src="/images/plusicon.png" style="cursor:pointer" onClick="valuePlus(defaultWarn);">
		        		<img src="/images/minusicon.png" style="cursor:pointer" onClick="valueMinuse(defaultWarn)">
		        	</td>
		        </tr>     
		        <tr>
		            <th style="width:100px; text-align:center; border-bottom:0px; border-right:1px solid #dbdbda;"><spring:message code='ezEmail.t80' /></th>
		            <td style="width:125px; border-bottom:0px; border-right:1px solid #dbdbda;">
		                <input id="defaultMax" type="text" onkeyup="return Mark1000Sep(this)" value="${defaultMax}" style="width:80%; text-align:right"> GB
		            </td>
		        	<td style="width:40px;text-align: center">
		        		<img src="/images/plusicon.png" style="cursor:pointer" onClick="valuePlus(defaultMax)">
		        		<img src="/images/minusicon.png" style="cursor:pointer" onClick="valueMinuse(defaultMax)">
		        	</td>
		        </tr>
		    </table>
	    </div>
	    <div class="btnpositionJsp">
		    <a class="imgbtn"><span onClick="Save('')"><spring:message code='main.sp09' /></span></a>
	    </div>
    </div>
  </body>
</html>



