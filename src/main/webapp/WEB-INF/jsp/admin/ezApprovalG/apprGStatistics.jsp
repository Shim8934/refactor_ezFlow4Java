<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1285' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist tr th {
	    		border-top:0px;
	    	}
	    </style>	
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_listForAdminNumberOfApproval.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Pagenation_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezStatistics_Cross.js')}"></script>		
		<script type="text/javascript">
			var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, DocList_Flag, DocTitle, pUserFlag;
	        var StatistList = createXmlDom();
	        var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
	        var approvalFlag = "<c:out value = '${approvalFlag}' />";
	        var OrderCell = "";
	        var listview = new ListView();
	        var pMode = "";
			var searchInfo = null;

			function staticsInit() {
				$('#lvSDoc').empty();
				pCompanyID = document.getElementById("ListCompany").value;
				document.getElementById("SYear").value = "<c:out value = '${tempPYear}' />";
				document.getElementById("SMonth").value = "<c:out value = '${tempPMonth}' />";
				document.getElementById("EYear").value = "<c:out value = '${tempYear}' />";
				document.getElementById("EMonth").value = "<c:out value = '${tempMonth}' />";
				document.getElementsByName("condition")[0].checked = false;
				document.getElementsByName("condition")[1].checked = false;
				document.getElementsByName("Dept")[0].checked = false;
				document.getElementsByName("Dept")[1].checked = false;
				document.getElementsByName("Dept")[2].checked = false;
				document.getElementsByName("UserFlag")[0].checked = false;
				document.getElementsByName("UserFlag")[1].checked = false;
				document.getElementsByName("UserFlag")[2].checked = false;
				document.getElementsByName("UserFlag")[3].checked = false;

				if (approvalFlag == 'S') {
					$(".approvalG").hide();
// 	            	$(".approvalS").show();
				} else {
					$(".approvalS").hide();
// 	            	$(".approvalG").show();
				}
				Initlvtlist();
			}

			$(document).ready(function(){
//	            document.getElementById("SCompID").value = pCompanyID;
				staticsInit();
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
	                
	                /* 2018-10-15 김민성 - 기간검색 시 날짜 조건 추가 */
	                var startYear = parseInt(document.getElementById("SYear").value);
	                var endYear = parseInt(document.getElementById("EYear").value);
	                var startMonth = parseInt(document.getElementById("SMonth").value);
	                var endMonth = parseInt(document.getElementById("EMonth").value);
	                
	                if(startMonth < 1 || startMonth > 12 || endMonth < 1 || endMonth > 12) {
	                	alert("<spring:message code='ezApprovalG.t10030'/>");
	                	return;
	                }
	                if(startYear > endYear || ( startYear == endYear && startMonth > endMonth )) {
	                	alert("<spring:message code='ezApprovalG.t1327'/>");
	                	return;
	                }

	                if (document.getElementsByName("condition")[0].checked) {
	                    if (document.getElementsByName("UserFlag")[0].checked || document.getElementsByName("UserFlag")[1].checked || document.getElementsByName("UserFlag")[2].checked || document.getElementsByName("UserFlag")[3].checked) {
	                        if (document.getElementsByName("UserFlag")[0].checked) {
	                            pUserFlag = 1;
	                        } else if (document.getElementsByName("UserFlag")[1].checked) {
	                            pUserFlag = 2;
	                        } else if (document.getElementsByName("UserFlag")[2].checked) {
	                            pUserFlag = 3;
	                        } else if (document.getElementsByName("UserFlag")[3].checked) {
	                            pUserFlag = 4;
	                        }
	                        
							UserDocCount();
							
							searchInfo = {};
							searchInfo.startYear = startYear;
							searchInfo.endYear = endYear;
							searchInfo.startMonth = startMonth;
							searchInfo.endMonth = endMonth;
							searchInfo.flag = "USER";
							searchInfo.mode = pUserFlag;
	                    } else {
	                        alert(" <spring:message code = 'ezApprovalG.t1291' />");
	                    }
	                } else if (document.getElementsByName("condition")[1].checked) {
						var deptCheckNodes = Array.prototype.concat.apply([], document.getElementsByName("Dept"));
						if (deptCheckNodes.some(function(inputDept) { return inputDept.checked; })) {
							if (document.getElementsByName("Dept")[0].checked) {
								pUserFlag = "SEND";
							} else if (document.getElementsByName("Dept")[1].checked) {
								pUserFlag = "RECV";
							} else if (document.getElementsByName("Dept")[2].checked) {
								pUserFlag = "BOTH";
							}
							DeptDocCount(pUserFlag);

							searchInfo = {};
							searchInfo.startYear = startYear;
							searchInfo.endYear = endYear;
							searchInfo.startMonth = startMonth;
							searchInfo.endMonth = endMonth;
							searchInfo.flag = "DEPT";
							searchInfo.mode = pUserFlag;
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
	            document.getElementsByName("condition")[0].checked = false;
	            document.getElementsByName("condition")[1].checked = false;
	            document.getElementsByName("Dept")[0].checked = false;
	            document.getElementsByName("Dept")[1].checked = false;
	            document.getElementsByName("Dept")[2].checked = false;
	            document.getElementsByName("Dept")[0].disabled = false;
	            document.getElementsByName("Dept")[1].disabled = false;
	            document.getElementsByName("Dept")[2].disabled = false;
	            document.getElementsByName("UserFlag")[0].checked = false;
	            document.getElementsByName("UserFlag")[1].checked = false;
	            document.getElementsByName("UserFlag")[2].checked = false;
	            document.getElementsByName("UserFlag")[3].checked = false;
	            document.getElementsByName("UserFlag")[0].disabled = false;
	            document.getElementsByName("UserFlag")[1].disabled = false;
	            document.getElementsByName("UserFlag")[2].disabled = false;
				document.getElementsByName("UserFlag")[3].disabled = false;
				searchInfo = null;
	        }
	        
	        function UserFlag_Init() {
	        	condition_Init("2");
	            document.getElementsByName("condition")[1].checked = true;
	        }
	        
	        function DeptRadio_Init() {
	        	condition_Init("1");
	            document.getElementsByName("condition")[0].checked = true;
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
	                document.getElementsByName("UserFlag")[3].disabled = false;
	            } else if (mode == "2") {
	                document.getElementsByName("Dept")[0].disabled = false;
	                document.getElementsByName("Dept")[1].disabled = false;
	                document.getElementsByName("Dept")[2].disabled = false;
	                document.getElementsByName("UserFlag")[0].disabled = true;
	                document.getElementsByName("UserFlag")[1].disabled = true;
	                document.getElementsByName("UserFlag")[2].disabled = true;
	                document.getElementsByName("UserFlag")[3].disabled = true;
	                document.getElementsByName("UserFlag")[0].checked = false;
		            document.getElementsByName("UserFlag")[1].checked = false;
		            document.getElementsByName("UserFlag")[2].checked = false;
		            document.getElementsByName("UserFlag")[3].checked = false;
	            }
	        }
	        
	        function btnSave_onclick() {
				if (!searchInfo) {
					alert("<spring:message code = 'ezApprovalG.t1294' />");
		            return;
				}

				var url = "/admin/ezApprovalG/ezStatistics/excelExportOut.do";
				url += "?flag=" + searchInfo.flag;
				url += "&p0=" + encodeURIComponent(searchInfo.startYear);
				url += "&p1=" + encodeURIComponent(searchInfo.startMonth);
				url += "&p2=" + encodeURIComponent(searchInfo.endYear);
				url += "&p3=" + encodeURIComponent(searchInfo.endMonth);
				url += "&p4=" + encodeURIComponent(searchInfo.mode);
				url += "&p5=" + encodeURIComponent(pCompanyID);

	            window.frames["saveExcel"].location.href = url;
	        }
	        
	        function selectCompanyID() {
	            if (pCompanyID != document.getElementById("ListCompany").value) {
	                pCompanyID = document.getElementById("ListCompany").value;
	            }
				staticsInit();
	        }
	        
		    /* 2020-07-15 홍승비 - 숫자 이외의 값 입력 방지 함수 */
		    function KeEventControl(obj) {
	            if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
	                return true;
	            }
	            else {
	            	obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	            }
	        }
		    
		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code = 'main.t42' />
			<%-- 2020-10-22 홍승비 - 회사선택 셀렉트박스 추가 --%>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany" onChange="selectCompanyID()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
	    </h1>
	    <%--<input type="hidden" id="SCompID" value="${userInfo.companyID }" >--%>
	    <table class="content" style="margin-bottom: 10px; width: 770px;">
	        <tr>
	            <th><spring:message code = 'ezApprovalG.t1298' /></th>
	            <td colspan="2">
	                <input type="text" class="text" style="Width: 50px;" maxlength="4" id="SYear" name="SYear" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);">
	                <spring:message code = 'ezApprovalG.t456' />
	                <input type="text" class="text" style="Width: 30px;" maxlength="2" id="SMonth" name="SMonth" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);">
	                <spring:message code = 'ezApprovalG.t1299' />
	                <input type="text" class="text" style="Width: 50px;" maxlength="4" id="EYear" name="EYear" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);">
	                <spring:message code = 'ezApprovalG.t456' />
	                <input type="text" class="text" style="Width: 30px;" maxlength="2" id="EMonth" name="EMonth" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);">
	                <spring:message code = 'ezApprovalG.t1300' />
	                    <a class="imgbtn imgbck"><span onclick="return btnOK_onclick()"><spring:message code = 'ezApprovalG.t111' /></span></a>
	                    <a class="imgbtn imgbck"><span onclick="return btnInit_onclick()"><spring:message code = 'ezApprovalG.t1301' /></span></a>
	            </td>
	        </tr>
	        <tr>
	            <th rowspan="2"><spring:message code = 'ezApprovalG.t1302' /></th>
	            <th><input type="radio" id="condition" name="condition" value="1" onclick="return condition_Init('1')"><spring:message code = 'ezApprovalG.t1303' /></th>
	            <td>
	                <input type="radio" id="UserFlag" name="UserFlag" value="1" onclick="return DeptRadio_Init()">
		                <c:choose>
		                	<c:when test="${approvalFlag == 'S' }">
		                		<spring:message code = 'ezApproval.t400' />
		                	</c:when>
		                	<c:otherwise>
		                		<spring:message code = 'ezApprovalG.t445' />
		                	</c:otherwise>
		                </c:choose>
	                
	                <input type="radio" id="UserFlag" name="UserFlag" value="2" onclick="return DeptRadio_Init()">
	                	<c:choose>
		                	<c:when test="${approvalFlag == 'S' }">
		                		<spring:message code = 'ezApproval.t401' />
		                	</c:when>
		                	<c:otherwise>
		                		<spring:message code = 'ezApprovalG.t1304' />
		                	</c:otherwise>
		                </c:choose>
	                
	                <input type="radio" id="UserFlag" name="UserFlag" value="3" onclick="return DeptRadio_Init()">
	                	<c:choose>
		                	<c:when test="${approvalFlag == 'S' }">
		                		<spring:message code = 'ezApproval.t402' />
		                	</c:when>
		                	<c:otherwise>
		                		<spring:message code = 'ezApprovalG.t1305' />
		                	</c:otherwise>
		                </c:choose>
	                <input type="radio" id="UserFlag" name="UserFlag" class = "approvalG" value="4" onclick="return DeptRadio_Init()">
	                <c:if test="${approvalFlag == 'G' }">
		                <spring:message code = 'ezApprovalG.t1306' />
	                </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th><input type="radio" id="condition" name="condition" value="2" onclick="return condition_Init('2')"><spring:message code = 'ezApprovalG.t1307' /></th>
	            <td>
	                <input type="radio" id="Dept" name="Dept" value="1" onclick="return UserFlag_Init()">&nbsp;<spring:message code = 'ezApprovalG.t214' />
	                <input type="radio" id="Dept" name="Dept" value="2" onclick="return UserFlag_Init()">&nbsp;<spring:message code = 'ezApprovalG.t1308' />
	                <input type="radio" id="Dept" name="Dept" value="3" onclick="return UserFlag_Init()">&nbsp;<spring:message code = 'ezApprovalG.t1309' />
	            </td>
	        </tr>
	    </table>
	
	    <table>
	        <tr id="PageNum"></tr>
	    </table>
	
		<div class="listview" style="width: 770px; overflow-y: hidden; overflow-x: hidden">
			<div id="lvSDoc" style="border: 0; width: 770px; height: 320px;"></div>
		</div>
	    
	    <div class="btnpositionJsp" style="width: 765px;">
	        <a class="imgbtn" onclick="btnSave_onclick()"><span>EXCEL <spring:message code='ezApprovalG.t59'/></span></a>
	    </div>
	
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>