<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t380'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApproval.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/ezStatistics_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApproval/control_Cross/ListView_list.js" ></script>
	    <script type="text/javascript" src="/js/ezApproval/admin/Pagenation_Cross.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, DocList_Flag, DocTitle, pUserFlag, LISTTYPE;
	        var StatistList = createXmlDom();;
	        var docMode = "";
	        var companyID = "${userInfo.companyID}";
	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        window.onload = function () {
	            document.getElementById("SYear").value = "${year}";
	            document.getElementById("SMonth").value = "${month}";
	            document.getElementById("EYear").value = "${tempYear}";
	            document.getElementById("EMonth").value = "${tempMonth}";
	
	            document.getElementsByName("condition")[0].checked = false;
	            document.getElementsByName("condition")[1].checked = false;
	            document.getElementsByName("Dept")[0].checked = false;
	            document.getElementsByName("Dept")[1].checked = false;
	            document.getElementsByName("Dept")[2].checked = false;
	            document.getElementsByName("UserFlag")[0].checked = false;
	            document.getElementsByName("UserFlag")[1].checked = false;
	            document.getElementsByName("UserFlag")[2].checked = false;            
	        }
		    function btnOK_onclick() {
		        if (document.getElementById("SYear").value == "" || document.getElementById("SMonth").value == "" || document.getElementById("EYear").value == "" || document.getElementById("EMonth").value == "") {
		            alert("<spring:message code='ezApproval.t381'/>");
		            }
		            else {
		                var strMatch = document.getElementById("SYear").value.match(/^[0-9]+$/);
		                if (!strMatch) {
		                    alert("<spring:message code='ezApproval.t382'/>");
		                    return;
		                }
		
		                var strMatch = document.getElementById("SMonth").value.match(/^[0-9]+$/);
		                if (!strMatch) {
		                    alert("<spring:message code='ezApproval.t383'/>");
		                    return;
		                }
		
		                var strMatch = document.getElementById("EYear").value.match(/^[0-9]+$/);
		                if (!strMatch) {
		                    alert("<spring:message code='ezApproval.t384'/>");
		                    return;
		                }
		
		                var strMatch = document.getElementById("EMonth").value.match(/^[0-9]+$/);
		                if (!strMatch) {
		                    alert("<spring:message code='ezApproval.t385'/>");
		                    return;
		                }
		
		                if (document.getElementsByName("condition")[0].checked) {
		                    if (document.getElementsByName("UserFlag")[0].checked || document.getElementsByName("UserFlag")[1].checked || document.getElementsByName("UserFlag")[2].checked) {
		                        if (document.getElementsByName("UserFlag")[0].checked)
		                            pUserFlag = 0;
		                        else if (document.getElementsByName("UserFlag")[1].checked)
		                            pUserFlag = 1;
		                        else if (document.getElementsByName("UserFlag")[2].checked)
		                            pUserFlag = 2;
		
		                        UserDocCount();
		                    }
		                    else {
		                        alert("<spring:message code='ezApproval.t386'/>");
		                    }
		                }
		                else if (document.getElementsByName("condition")[1].checked) {
		                    if (document.getElementsByName("Dept")[0].checked)
		                        DeptDocCount("SEND");
		                    else if (document.getElementsByName("Dept")[1].checked)
		                        DeptDocCount("RECV");
		                    else if (document.getElementsByName("Dept")[2].checked)
		                        DeptDocCount("BOTH");
		                    else
		                        alert("<spring:message code='ezApproval.t387'/>");
		        }
		        else {
		            alert("<spring:message code='ezApproval.t388'/>");
		                }
		        }
		    }
		    function btnInit_onclick() {
		        document.getElementById("SYear").value = "";
		        document.getElementById("SMonth").value = "";
		        document.getElementById("EYear").value = "";
		        document.getElementById("EMonth").value = "";
		
		        document.getElementsByName("condition")[0].checked = false;
		        document.getElementsByName("condition")[1].checked = false;
		        document.getElementsByName("Dept")[0].checked = false;
		        document.getElementsByName("Dept")[1].checked = false;
		        document.getElementsByName("Dept")[2].checked = false;
		        document.getElementsByName("UserFlag")[0].checked = false;
		        document.getElementsByName("UserFlag")[1].checked = false;
		        document.getElementsByName("UserFlag")[2].checked = false;
		    }
		    function UserFlag_Init() {
		        document.getElementsByName("UserFlag")[0].checked = false;
		        document.getElementsByName("UserFlag")[1].checked = false;
		        document.getElementsByName("UserFlag")[2].checked = false;
		    }
		    function DeptRadio_Init() {
		        document.getElementsByName("Dept")[0].checked = false;
		        document.getElementsByName("Dept")[1].checked = false;
		        document.getElementsByName("Dept")[2].checked = false;
		    }
		    function lvtlist_onSel_Changed() {
		    }
		    function lvtlist_onSel_Click() {
		    }
		    function lvtlist_onSel_DBclick() {
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    function condition_Init(mode) {
		        if (mode == "1") {
		            document.getElementsByName("Dept")[0].disabled = true;
		            document.getElementsByName("Dept")[1].disabled = true;
		            document.getElementsByName("Dept")[2].disabled = true;
		            document.getElementsByName("Dept")[0].checked = false;
		            document.getElementsByName("Dept")[1].checked = false;
		            document.getElementsByName("Dept")[2].checked = false;
		            document.getElementsByName("UserFlag")[0].disabled = false;
		            document.getElementsByName("UserFlag")[1].disabled = false;
		            document.getElementsByName("UserFlag")[2].disabled = false;
		        }
		        else {
		            document.getElementsByName("Dept")[0].disabled = false;
		            document.getElementsByName("Dept")[1].disabled = false;
		            document.getElementsByName("Dept")[2].disabled = false;
		            document.getElementsByName("UserFlag")[0].checked = false;
		            document.getElementsByName("UserFlag")[1].checked = false;
		            document.getElementsByName("UserFlag")[2].checked = false;
		            document.getElementsByName("UserFlag")[0].disabled = true;
		            document.getElementsByName("UserFlag")[1].disabled = true;
		            document.getElementsByName("UserFlag")[2].disabled = true;
		        }
		    }
		    function btnSave_onclick() {
		    	if (document.getElementsByName("condition")[0].checked) {
                    if (!document.getElementsByName("UserFlag")[0].checked && !document.getElementsByName("UserFlag")[1].checked && !document.getElementsByName("UserFlag")[2].checked) {
                        alert("<spring:message code='ezApproval.t386'/>");
                        return ;
                    } 
                } else if (document.getElementsByName("condition")[1].checked) {
                    if (!document.getElementsByName("Dept")[0].checked && !document.getElementsByName("Dept")[1].checked && !document.getElementsByName("Dept")[2].checked) {
                        alert("<spring:message code='ezApproval.t387'/>");
                        return ;
                    }
      			} else {
      				alert("<spring:message code='ezApproval.t388'/>");
      				return ;
      			}
		    	
		    	var url = "/admin/ezApproval/excelExportOut.do?listType=" + LISTTYPE + "&startYear=" + document.getElementById("SYear").value + "&startMonth=" +
                document.getElementById("SMonth").value + "&endYear=" + document.getElementById("EYear").value + "&endMonth=" + document.getElementById("EMonth").value +
                "&userFlag=" + escape(pUserFlag) + "&mode=" + docMode + "&companyID=" + $("#ListCompany").val();
		    	
		    	saveExcel.location.href = url;
		    }
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezApproval.t392'/></h1>
	    <div style="margin-bottom: 5px">
	        <b><spring:message code='ezApproval.t378'/></b>
   			<select id="ListCompany" name="ListCompany" onchange="return changeCompID()">
    			${companySel}
			</select>
	    </div>
	    <br />
	
	    <table class="content" style="margin-bottom: 10px; width: 770px">
	        <tr>
	            <th><spring:message code='ezApproval.t393'/></th>
	            <td colspan="2">
	                <input type="text" style="WIDTH: 50px;" maxlength="4" id="SYear" name="SYear">
	                <spring:message code='ezApproval.t394'/>
	                <input type="text" style="WIDTH: 30px;" maxlength="2" id="SMonth" name="SMonth">
	                <spring:message code='ezApproval.t395'/>
	                <input type="text" style="WIDTH: 50px;" maxlength="4" id="EYear" name="EYear">
	                <spring:message code='ezApproval.t394'/>
	                <input type="text" style="WIDTH: 30px;" maxlength="2" id="EMonth" name="EMonth">
	                <spring:message code='ezApproval.t396'/>
	                <a class="imgbtn"><span onclick="return btnOK_onclick()"><spring:message code='ezApproval.t236'/></span></a>
	                <a class="imgbtn"><span onclick="return btnInit_onclick()"><spring:message code='ezApproval.t397'/></span></a>
	            </td>
	        </tr>
	        <tr>
	            <th rowspan="2"><spring:message code='ezApproval.t398'/></th>
	            <th>
	                <input type="radio" id="condition" name="condition" style="vertical-align: text-bottom" value="1" onclick="return condition_Init('1')">
	                <spring:message code='ezApproval.t399'/></th>
	            <td>
	                <input type="radio" id="UserFlag" name="UserFlag" style="vertical-align: text-bottom" value="0" onclick="return DeptRadio_Init()">
	                <spring:message code='ezApproval.t400'/>
	                <input type="radio" id="UserFlag" name="UserFlag" style="vertical-align: text-bottom" value="1" onclick="return DeptRadio_Init()">
	                <spring:message code='ezApproval.t401'/>
	                <input type="radio" id="UserFlag" name="UserFlag" style="vertical-align: text-bottom" value="2" onclick="return DeptRadio_Init()">
	                <spring:message code='ezApproval.t402'/></td>
	        </tr>
	        <tr>
	            <th>
	                <input type="radio" id="condition" name="condition" style="vertical-align: text-bottom" value="2" onclick="return condition_Init('2')">
	                <spring:message code='ezApproval.t403'/></th>
	            <td>
	                <input type="radio" id="Dept" name="Dept" value="1" style="vertical-align: text-bottom" onclick="return UserFlag_Init()">
	                <spring:message code='ezApproval.t155'/>
	                <input type="radio" id="Dept" name="Dept" value="2" style="vertical-align: text-bottom" onclick="return UserFlag_Init()">
	                <spring:message code='ezApproval.t404'/>
	                <input type="radio" id="Dept" name="Dept" value="3" style="vertical-align: text-bottom" onclick="return UserFlag_Init()">
	                <spring:message code='ezApproval.t405'/></td>
	        </tr>
	    </table>
	
	    <table>
	        <tr id="PageNum">
	        </tr>
	    </table>
	
	    <div class="listview" style="width: 780px">
	        <div id="lvtForm" style="border: 0; HEIGHT: 320px; WIDTH: 780px; overflow: auto"></div>
	    </div>
	    <div class="btnposition" style="width: 800px;">
	        <a class="imgbtn" onclick="btnSave_onclick()"><span>CSV <spring:message code='ezApproval.t66'/></span></a>
	    </div>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	    <iframe id="saveFile" name="saveFile" style="display: none"></iframe>
	</body>
</html>