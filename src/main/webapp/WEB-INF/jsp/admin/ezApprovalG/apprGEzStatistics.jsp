<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1285' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Pagenation_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezStatistics_Cross.js"></script>
		
		<script type="text/javascript">
			var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, DocList_Flag, DocTitle, pUserFlag;
	        var StatistList = createXmlDom();
	        var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
	        var OrderCell = "";
	        var listview = new ListView();
	        var pMode = "";
	        
	        $(document).ready(function(){
	            document.getElementById("SCompID").value = pCompanyID;
	            document.getElementById("SYear").value = "<c:out value = '${tempPYear}' />";
	            document.getElementById("SMonth").value = "<c:out value = '${tempPMonth}' />";
	            document.getElementById("EYear").value = "<c:out value = '${tempYear}' />";
	            document.getElementById("EMonth").value = "<c:out value = '${tempMonth}' />";
	            document.all("condition")[0].checked = false;
	            document.all("condition")[1].checked = false;
	            document.all("Dept")[0].checked = false;
	            document.all("Dept")[1].checked = false;
	            document.all("UserFlag")[0].checked = false;
	            document.all("UserFlag")[1].checked = false;
	            document.all("UserFlag")[2].checked = false;
	            document.all("UserFlag")[3].checked = false;

	            Initlvtlist();
	        });
	        
	        function Initlvtlist() {

	            listview.SetID("lvSDocForm");
	            listview.SetMulSelectable(false);

	            listview.DataBind("lvSDoc");
	        }

	        function btnOK_onclick() {
	            if (document.getElementById("SYear").value == "" || document.getElementById("SMonth").value == "" || document.getElementById("EYear").value == "" || document.getElementById("EMonth").value == "") {
	                alert("<spring:message code = 'ezApprovalG.t1286' />");
	            } else {
	                var strMatch = document.getElementById("SYear").value.match(/^[0-9]+$/);
	                if (!strMatch) {
	                    alert("<spring:message code = 'ezApprovalG.t1287' />");
	                    return;
	                }

	                var strMatch = document.getElementById("SMonth").value.match(/^[0-9]+$/);
	                if (!strMatch) {
	                    alert("<spring:message code = 'ezApprovalG.t1288' />");
	                    return;
	                }

	                var strMatch = document.getElementById("EYear").value.match(/^[0-9]+$/);
	                if (!strMatch) {
	                    alert("<spring:message code = 'ezApprovalG.t1289' />");
	                    return;
	                }

	                var strMatch = document.getElementById("EMonth").value.match(/^[0-9]+$/);
	                if (!strMatch) {
	                    alert("<spring:message code = 'ezApprovalG.t1290' />");
	                    return;
	                }

	                if (document.all("condition")[0].checked) {
	                    if (document.all("UserFlag")[0].checked || document.all("UserFlag")[1].checked || document.all("UserFlag")[2].checked || document.all("UserFlag")[3].checked) {
	                        if (document.all("UserFlag")[0].checked) {
	                            pUserFlag = 1;
	                        } else if (document.all("UserFlag")[1].checked) {
	                            pUserFlag = 2;
	                        } else if (document.all("UserFlag")[2].checked) {
	                            pUserFlag = 3;
	                        } else if (document.all("UserFlag")[3].checked) {
	                            pUserFlag = 4;
	                        }
	                        
	                        UserDocCount();
	                    } else {
	                        alert(" <spring:message code = 'ezApprovalG.t1291' />");
	                    }
	                } else if (document.all("condition")[1].checked) {
	                    if (document.all("Dept")[0].checked) {
	                        DeptDocCount("SEND");
	                    } else if (document.all("Dept")[1].checked) {
	                        DeptDocCount("RECV");
	                    } else if (document.all("Dept")[2].checked) {
	                        DeptDocCount("BOTH");
	                    } else {
	                        alert("<spring:message code = 'ezApprovalG.t1292' />");
	                    }
			        } else {
			            alert("<spring:message code = 'ezApprovalG.t1293' />");
	                }
		        }
		    }
	        
	        function btnInit_onclick() {
	            document.getElementById("SYear").value = "";
	            document.getElementById("SMonth").value = "";
	            document.getElementById("EYear").value = "";
	            document.getElementById("EMonth").value = "";
	            document.all("condition")[0].checked = false;
	            document.all("condition")[1].checked = false;
	            document.all("Dept")[0].checked = false;
	            document.all("Dept")[1].checked = false;
	            document.all("UserFlag")[0].checked = false;
	            document.all("UserFlag")[1].checked = false;
	            document.all("UserFlag")[2].checked = false;
	            document.all("UserFlag")[3].checked = false;
	        }
	        
	        function UserFlag_Init() {
	            document.all("UserFlag")[0].checked = false;
	            document.all("UserFlag")[1].checked = false;
	            document.all("UserFlag")[2].checked = false;
	            document.all("UserFlag")[3].checked = false;
	        }
	        
	        function DeptRadio_Init() {
	            document.all("Dept")[0].checked = false;
	            document.all("Dept")[1].checked = false;
	            document.all("Dept")[2].checked = false;
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
	                document.all("Dept")[0].disabled = false;
	                document.all("Dept")[1].disabled = false;
	                document.all("Dept")[2].disabled = false;
	                document.all("Dept")[0].checked = false;
	                document.all("Dept")[1].checked = false;
	                document.all("Dept")[2].checked = false;
	                document.all("UserFlag")[0].disabled = false;
	                document.all("UserFlag")[1].disabled = false;
	                document.all("UserFlag")[2].disabled = false;
	                document.all("UserFlag")[3].disabled = false;
	            } else {
	                document.all("Dept")[0].disabled = false;
	                document.all("Dept")[1].disabled = false;
	                document.all("Dept")[2].disabled = false;
	                document.all("Dept")[0].checked = false;
	                document.all("Dept")[1].checked = false;
	                document.all("Dept")[2].checked = false;
	                document.all("UserFlag")[0].disabled = true;
	                document.all("UserFlag")[1].disabled = true;
	                document.all("UserFlag")[2].disabled = true;
	                document.all("UserFlag")[3].disabled = true;
	            }
	        }
	        
	        function btnSave_onclick() {
	            var url = "/ezApprovalG/excelExportOut.do";

	            if (document.all("condition")[0].checked) {
	                url += "?FLAG=USER";
	            } else {
	                url += "?FLAG=DEPT";
	            }
	            
	            url += "&P0=" + document.getElementById("SYear").value;
	            url += "&P1=" + document.getElementById("SMonth").value;
	            url += "&P2=" + document.getElementById("EYear").value;
	            url += "&P3=" + document.getElementById("EMonth").value;

	            if (document.all("condition")[0].checked) {
	                url += "&P4=" + pUserFlag;
	            } else {
	                if (document.all("Dept")[0].checked) {
	                    pMode = "SEND";
	                } else if (document.all("Dept")[1].checked) {
	                    pMode = "RECV";
	                } else if (document.all("Dept")[2].checked) {
	                    pMode = "BOTH";
	                }
	                
	                url += "&P4=" + pMode;
	            }
	            
	            url += "&P5=" + pCompanyID;

	            window.frames["saveExcel"].location.href = url;
	        }
	        
	        function selectCompanyID() {
	            if (pCompanyID != document.getElementById("SCompID").value) {
	                pCompanyID = document.getElementById("SCompID").value;
	            }
	        }
		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code = 'ezApprovalG.t1297' /></h1>
	    <div id="mainmenu">
	        <ul>
	        	<b><spring:message code = 'ezApprovalG.t1276' /></b>
	            <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </SELECT><br /><br />
	            <li><span onclick="return btnSave_onclick()"><spring:message code = 'ezApprovalG.t59' /></span></li>
	        </ul>
	    </div>
	    <table class="content" style="margin-bottom: 10px; width: 770px;">
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1298' /></th>
	            <td colspan="2">
	                <input type="text" class="text" style="Width: 50px;" maxlength="4" id="SYear" name="SYear">
	                <spring:message code = 'ezApprovalG.t456' />
	                <input type="text" class="text" style="Width: 30px;" maxlength="2" id="SMonth" name="SMonth">
	                <spring:message code = 'ezApprovalG.t1299' />
	                <input type="text" class="text" style="Width: 50px;" maxlength="4" id="EYear" name="EYear">
	                <spring:message code = 'ezApprovalG.t456' />
	                <input type="text" class="text" style="Width: 30px;" maxlength="2" id="EMonth" name="EMonth">
	                <spring:message code = 'ezApprovalG.t1300' />
	                    <a class="imgbtn"><span onclick="return btnOK_onclick()"><spring:message code = 'ezApprovalG.t111' /></span></a>
	                    <a class="imgbtn"><span onclick="return btnInit_onclick()"><spring:message code = 'ezApprovalG.t1301' /></span></a>
	            </td>
	        </tr>
	        <tr>
	            <th rowspan="2"><spring:message code = 'ezApprovalG.t1302' /></th>
	            <th><input type="radio" id="condition" name="condition" value="1" onclick="return condition_Init('1')"><spring:message code = 'ezApprovalG.t1303' /></th>
	            <td>
	                <input type="radio" id="UserFlag" name="UserFlag" value="1" onclick="return DeptRadio_Init()">
	                <spring:message code = 'ezApprovalG.t445' />
	                <input type="radio" id="UserFlag" name="UserFlag" value="2" onclick="return DeptRadio_Init()">
	                <spring:message code = 'ezApprovalG.t1304' />
	                <input type="radio" id="UserFlag" name="UserFlag" value="3" onclick="return DeptRadio_Init()">
	                <spring:message code = 'ezApprovalG.t1305' />
	                <input type="radio" id="UserFlag" name="UserFlag" value="4" onclick="return DeptRadio_Init()">
	                <spring:message code = 'ezApprovalG.t1306' />
	            </td>
	        </tr>
	        <tr>
	            <th><input type="radio" id="condition" name="condition" value="2" onclick="return condition_Init('2')"><spring:message code = 'ezApprovalG.t1307' /></th>
	            <td>
	                <input type="radio" id="Dept" name="Dept" value="1" onclick="return UserFlag_Init()">
	                <spring:message code = 'ezApprovalG.t214' />
	                <input type="radio" id="Dept" name="Dept" value="2" onclick="return UserFlag_Init()">
	                <spring:message code = 'ezApprovalG.t1308' />
	                <input type="radio" id="Dept" name="Dept" value="3" onclick="return UserFlag_Init()">
	                <spring:message code = 'ezApprovalG.t1309' />
	            </td>
	        </tr>
	    </table>
	
	    <table>
	        <tr id="PageNum"></tr>
	    </table>
	
	    <div class="listview" style="width: 770px; overflow-y: auto; overflow-x: hidden">
	        <div id="lvSDoc" style="border: 0; width: 770px; height: 320px;"></div>
	    </div>
	
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>