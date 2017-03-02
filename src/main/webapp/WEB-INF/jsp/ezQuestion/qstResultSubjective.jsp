<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${pAnsType==4 }">
				<title><spring:message code='ezQuestion.t561' /></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code='ezQuestion.t402' /></title>
			</c:otherwise>
		</c:choose>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezQuestion.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
		<STYLE> 
			.pagetd{padding-top:6px; }
			.pcol{padding-top:6px; }
			.Right_Point01 {
				font:bold;
				color:#017bec;
			}
		</STYLE>
		<script type="text/javascript">
			var szBrdID = "<c:out value='${brdID}'/>";
			var szItemNo = "<c:out value='${itemNo}'/>";
			var szQuestionNo = "<c:out value='${questionNo}'/>";
			var pTotalPage = "<c:out value='${pTotalPage}'/>";
			var pCurrPage = "<c:out value='${pCurrPage}'/>";
			var totalCount = "<c:out value='${pTotalCnt}'/>";
			var xmlHTTP = createXMLHttpRequest();
			window.onload = function () {
			    makePageSelPage();
			    tableXML();
			}
			
			function tableXML(){
				var xmlDoc = loadXMLString('${xmlMainDom}');
				var DataNode = SelectSingleNode(xmlDoc, "DATA");
				var RowNode = SelectSingleNode(DataNode,"ROW");
				var nodes = GetChildNodes(DataNode);
				var tableXml="";
				
				for(i=0;nodes.length>i; i++){
					tableXml += "<tr>";
					tableXml += "<td style='width:40px;text-align:center'>";
					tableXml += SelectSingleNodeValue(nodes[i], 'NO');
					tableXml += "</td>";
					if("${publicFlg}"==0){
						tableXml += "<td style='width:140px'>";
						tableXml += SelectSingleNodeValue(nodes[i], 'RESPONSEUSERDEPTNAME');
						tableXml += "</td>";
						tableXml += "<td style='width:80px'>";
						tableXml += SelectSingleNodeValue(nodes[i], 'RESPONSEUSERPOSITION');
						tableXml += "</td>";
						tableXml += "<td style='width:90px'>";
						tableXml += "<a style='cursor: pointer' onclick='Detail_UserInfo(\"";
						tableXml += SelectSingleNodeValue(nodes[i], 'RESPONSEUSERID');
						tableXml += "\")'>";
						tableXml += SelectSingleNodeValue(nodes[i], 'RESPONSEUSERNAME');
						tableXml += "</td>";
						tableXml += "<td style='text-align:left'>";
						tableXml += SelectSingleNodeValue(nodes[i], 'ANSWERSUBJECTIVITY');
						tableXml += "</td>";
						
						
					}
					SelectSingleNodeValue(nodes[i], 'OPTION').replace("\r\n","<br>");
					tableXml += "</tr>";
					if("${pTotalCnt}" ==0){
						tableXml += "<tr>";
						tableXml += "<td style='height:30px;text-align:center' colspan='5'>";
						tableXml += "<spring:message code='ezQuestion.t413' />";
						tableXml += "</td>";
						tableXml += "</tr>";
					}
				}
				
				//document.getElementById("xmlTable").innerHTML = document.getElementById("xmlTable").innerHTML + tableXml;
				$('#xmlTable').html($('#xmlTable').html() + tableXml);
			}
			
			function fun_UserView(responseno) {
			    var Para = window.showModalDialog("/ezQuestion/infoUser.do?brdID=" + "<c:out value='${brdID}'/>" + "&itemNo=" + "<c:out value='${itemNo}'/>" + "&questionNo=" + "<c:out value='${questionNo}'/>" + "&responseno=" + responseno, "", "dialogwidth:467px;dialogheight:396px;toolbar:no;location:no;help:no;directories:no;status:no;menubar:no;scrollbars=no;resizable:no");
			}
			
			function Detail_UserInfo(pUserID) {
			    var feature = GetOpenPosition(420, 450);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			}
			
			function menuQst_ResultView() {
			    history.go("${pageCount}");
			}
			
			function search_Set(pPage) {
				if (parseInt(pPage) > 0 && parseInt(pPage) != "" && parseInt(pPage) <= parseInt(pTotalPage)) {
			    	var szUrl = "/ezQuestion/qstResultSubjective.do?brdID=" + szBrdID + "&itemNo=" + szItemNo + "&page=" + pPage + "&pageCount=" +  "<c:out value='${pageCount}'/>" + "&questionNo=" + szQuestionNo;
				window.location.href = szUrl;
				}
			}
			
			function changePage() {
			    if (event.keyCode == 13) {
			        var inputNum = txt_PageInputNum.value;
			        search_Set(inputNum);
			        return false;
			    }
			    return true;
			}
			
			function menuQst_Total_view() {
				if ("${pTotalCnt}" != 0) {
					SaveCSV();
				}else{
				    alert("<spring:message code='ezQuestion.t121' />");
				}
			}
	
			function ReplaceText(orgStr, findStr, replaceStr) {
			    var re = new RegExp(findStr, "gi");
			
			    return (orgStr.replace(re, replaceStr));
			}
	
			function repComMa(param) {
			    param = ReplaceText(param, "\"", "\"\"");
			    if (param.indexOf(",") != -1 || param.indexOf("\"") != -1 || param.indexOf("\n") != -1) {
			        param = "\"" + param + "\"";
			    }
			    return param;
			}
			
			var BlockSize = 10;
			function td_Create1(strtext) {
			    //document.getElementById("tblPageRayer").innerHTML = strtext;
			    $('#tblPageRayer').html(strtext);
			}
			
			function makePageSelPage() {
			    var strtext;
			    var PagingHTML = "";
			    //document.getElementById("tblPageRayer").innerHTML = "";
			    $('#tblPageRayer').html();
			    //document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang42 + "]";
			    $('#mailBoxInfo').html(" - [" + strLang41 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang42 + "]");
			    strtext = "<div class='pagenavi'>";
			    PagingHTML += strtext;
			    var pageNum = pCurrPage;
			    if (pTotalPage > 1 && pageNum != 1) {
			        strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    if (pTotalPage > BlockSize) {
			        if (pageNum > BlockSize) {
			            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
			        PagingHTML += strtext;
			    }
			    var MaxNum;
			    var i;
			    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
			    if (pTotalPage >= (startNum + parseInt(BlockSize))) {
			        MaxNum = (startNum + parseInt(BlockSize)) - 1;
			    }
			    else {
			        MaxNum = pTotalPage;
			    }
			    for (i = startNum; i <= MaxNum; i++) {
			        if (i == pageNum) {
			            strtext = "<span class='on'>" + i + "</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
			            PagingHTML += strtext;
			        }
			    }
			    if (pTotalPage > BlockSize) {
			        if (pTotalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
			            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
			            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
			        strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    if (pTotalPage > 1 && pTotalPage != 1 && (pTotalPage != pageNum)) {
			        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + pTotalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    PagingHTML += "</div>";
			    td_Create1(PagingHTML);
			}
			function goToPageByNum(Value) {
			    pCurrPage = Value;
			    makePageSelPage();
			    search_Set(pCurrPage);
			}
			function selbeforeBlock() {
			    var pageNum = parseInt(pCurrPage);
			    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
			function selbeforeBlock_one() {
			    var pageNum = parseInt(pCurrPage);
			    if (parseInt(pageNum - 1) > 0)
			        goToPageByNum(parseInt(pageNum - 1));
			    else
			        return;
			}
			function selafterBlock() {
			    var pageNum = parseInt(pCurrPage);
			    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
			function selafterBlock_one() {
			    var pageNum = parseInt(pCurrPage);
			    if (parseInt(pageNum + 1) <= pTotalPage)
			        goToPageByNum(parseInt(pageNum + 1));
			    else
			        return;
			}
			
// 			사용안함
			/* function title_Onclick(pReceve) {
			    document.location.href = "/ezQuestion/qstPollOpen.do?" + pReceve;
			} */
			
			function SaveCSV() {
				if ($('#AnaylsisTable').html()) {
					document.getElementById("AnalysisData").value = $('#AnaylsisTable').html();
					form_analysissave.submit();
				} else {
					alert("<spring:message code='ezQuestion.t124' />");
				}
				
		    }
		</script>
	</head>
	<body class="mainbody">
		<c:choose>
			<c:when test="${pAnsType == 4}">
				 <h1><spring:message code='ezQuestion.t561' /><span id="mailBoxInfo"></span></h1>
			</c:when>
			<c:otherwise>
				<h1><spring:message code='ezQuestion.t402' /><span id="mailBoxInfo"></span></h1>
			</c:otherwise>
		</c:choose>
	    <div id="mainmenu">
	        <ul>
	            <li><span onclick="menuQst_ResultView()"><spring:message code='ezQuestion.t303' /></span></li>
	            <li><span onclick="menuQst_Total_view()"><spring:message code='ezQuestion.t405' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    <div id="AnaylsisTable">
			<table id="xmlTable" class="mainlist" style="width: 100%">
				<tr>
					<th style="width:40px"><spring:message code='ezQuestion.t344' /></th>
					<c:if test="${publicFlg == 0 }">
						<th style="width:140px"><spring:message code='ezQuestion.t408' /></th>
						<th style="width:80px"><spring:message code='ezQuestion.t4' /></th>
						<th style="width:130px"><spring:message code='ezQuestion.t8' /></th>
					</c:if>
					<th style="text-align:center"><spring:message code='ezQuestion.t410' /></th>
				</tr>
			</table>
	    </div>
	    <div id="tblPageRayer"></div>
		<form method="post" id="form_analysissave" name="form_analysissave" enctype="multipart/form-data" action="/ezQuestion/qstResultAnalysisSave.do" target="_self">
		    <input type="hidden" name="AnalysisData" id="AnalysisData" />
		    <input type="hidden" name="hidQst2" id="hidQst2" value="ALL" /><!-- 전체/문항 구분 -->
		    <input type="hidden" name="hidCatalog2" id="hidCatalog2" value="0" /><!-- Catalog 구분 -->
		    <input type="hidden" name="hidRType2" id="hidRType2" value="A" /><!-- 표/그래프 구분 --->
		</form>
	</body>
</html>