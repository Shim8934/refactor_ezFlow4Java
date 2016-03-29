<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezQuestion.t561' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezQuestion.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<STYLE> 
			.pagetd{padding-top:6px; }
			.pcol{padding-top:6px; }
			.Right_Point01 {
				font:bold;
				color:#017bec;
			}
		</STYLE>
		<script type="text/javascript">
			<%-- var szBrdID = "<%=brd_id%>";
			var szItemNo = "<%=item_no%>";
			var szQuestionNo = "<%=question_no%>";
			var pTotalPage = "<%=pTotalPage%>";
			var pCurrPage = "<%=pCurrPage%>";
			var totalCount = "<%=pTotalCnt%>";
			var xmlHTTP = createXMLHttpRequest();
			var xmlRtn = createXmlDom(); --%>
			document.onselectstart = function () { return false; };
			window.onload = function () {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
					document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
			    makePageSelPage()
			}
			<%-- function fun_UserView(responseno) {
			    var Para = window.showModalDialog("/ezQuestion/infoUser.aspx?brd_id=" + '<%=brd_id%>' + "&item_no=" + '<%=item_no%>' + "&question_no=" + '<%=question_no%>' + "&responseno=" + responseno, "", "dialogwidth:467px;dialogheight:396px;toolbar:no;location:no;help:no;directories:no;status:no;menubar:no;scrollbars=no;resizable:no");
			}
			
			function Detail_UserInfo(pUserID) {
			    var feature = GetOpenPosition(420, 450);
			    window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			} --%>
			
			function menuQst_ResultView() {
			    history.go("${page_count}");
			}
			
			function search_Set(pPage) {
				if (parseInt(pPage) > 0 && parseInt(pPage) != "" && parseInt(pPage) <= parseInt(pTotalPage)) {
			    	var szUrl = "/ezQuestion/qstResultSubjective.do?brd_id=" + szBrdID + "&item_no=" + szItemNo + "&page=" + pPage + "&page_count=" + "${page_count}" + "&question_no=" + szQuestionNo;
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
				<%-- var open_Url = "/ezQuestion/qstResultSave.do?brd_id=<%=brd_id%>&item_no=<%=item_no%>&question_no=<%=question_no%>" --%>
			
				xmlHTTP.open("POST", open_Url, false);
				xmlHTTP.send();
				var xmldom = loadXMLString(xmlHTTP.responseText);
				rows = xmldom.getElementsByTagName("ROW");
				//rows = xmlHTTP.responseXML.getElementsByTagName("ROW");
			
				var Clength = rows.length;
			
			
				if (Clength != 0) {
				    SaveCSV(Clength)
				}else{
				    alert("<spring:message code='ezQuestion.t121' />");
				}
			}
			
			function SaveCSV(Clength) {
			    var Rlength = Clength;
			
			    var col = new Array(4);
			    var row = new Array(Rlength);
			    var fPath;
			    var bResult
			    if (CrossYN()) {
			        for (var i = 0; i < Rlength; i++) {
			            var cells = rows[i].getElementsByTagName("CELL");
			            var Clength = cells.length;
			            var txt = cells[0].getElementsByTagName("VALUE")[0].textContent;
			            var cnt = cells[1].getElementsByTagName("VALUE")[0].textContent;
			            if (i != 0) {
			                var dept = cells[2].getElementsByTagName("VALUE")[0].textContent;
			                var jikgub = cells[3].getElementsByTagName("VALUE")[0].textContent;
			            }
			            col[0] = repComMa(txt);
			            col[1] = repComMa(cnt);
			            if (i != 0) {
			                col[2] = repComMa(dept);
			                col[3] = repComMa(jikgub);
			            }
			            else {
			                col[3] = "\n";
			            }
			            document.getElementById("AnalysisData").value += col;
			        }
			        form_analysissave.submit();
			    }else {
			    	var objSave = new ActiveXObject("EzUtil.MiscFunc");
			        var strFilter = objSave.OpenSaveDlg("CSV files (*.csv)\0*.csv\0All Files (*.*)\0*.*\0\0", "text");
			
			        for (var i = 0; i < Rlength; i++) {
			            var cells = rows[i].getElementsByTagName("CELL");
			            var Clength = cells.length;
			            var txt = cells[0].getElementsByTagName("VALUE")[0].text;
			            var cnt = cells[1].getElementsByTagName("VALUE")[0].text;
			            if (i != 0) {
			                var dept = cells[2].getElementsByTagName("VALUE")[0].text;
			                var jikgub = cells[3].getElementsByTagName("VALUE")[0].text;
			            }
			            col[0] = repComMa(txt);
			            col[1] = repComMa(cnt);
			            if (i != 0) {
			                col[2] = repComMa(dept);
			                col[3] = repComMa(jikgub);
			            }
			            row[i] = col.join();
			        }
			        var strCSV = row.join("\r\n");
			        bResult = objSave.SaveTextToFile(strFilter, strCSV);
			    }
			    if (bResult) {
			        alert("<spring:message code='ezQuestion.t344' />");
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
			    document.getElementById("tblPageRayer").innerHTML = strtext;
			}
			
			function makePageSelPage() {
			    var strtext;
			    var PagingHTML = "";
			    document.getElementById("tblPageRayer").innerHTML = "";
			    document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang42 + "]";
			    strtext = "<div class='pagenavi'>";
			    PagingHTML += strtext;
			    var pageNum = pCurrPage;
			    if (pTotalPage > 1 && pageNum != 1) {
			        strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/Sub/btn_p_prev.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/Sub/btn_p_prev01.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    if (pTotalPage > BlockSize) {
			        if (pageNum > BlockSize) {
			            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/Sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
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
			            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/Sub/btn_next.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
			            strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
			        strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    if (pTotalPage > 1 && pTotalPage != 1 && (pTotalPage != pageNum)) {
			        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + pTotalPage + ")'><img src='/images/Sub/btn_n_next.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/Sub/btn_n_next01.gif' width='16' height='16'></span>";
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
			
			function changePage() {
			    if (event.keyCode == 13) {
			        var inputNum = txt_PageInputNum.value;
			
			        search_Set(inputNum);
			
			        return false;
			    }
			
			    return true;
			}
			
			function title_Onclick(pReceve) {
			    document.location.href = "/ezQuestion/qstPollOpen.do?" + pReceve;
			}
		</script>
	</head>
	<body>
		<c:if test="${pAnsType == 4}">
			alert("1111");
		</c:if>
		<%-- <% if (pAnsType == "4")
		{ %>
		    <h1><spring:message code='ezQuestion.t561' /><span id="mailBoxInfo"></span></h1>
		    
		    <% }
		   else
		{%>
		    <h1><spring:message code='ezQuestion.t402' /><span id="mailBoxInfo"></span></h1>
		    
		    <% }%>
		    <div id="mainmenu">
		        <ul>
		            <li><span onclick="menuQst_ResultView()"><spring:message code='ezQuestion.t303' /></span></li>
		            <li><span onclick="menuQst_Total_view()"><spring:message code='ezQuestion.t405' /></span></li>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		    </script>
		    <table class="mainlist" style="width: 100%">
		        <tr>
		            <!--- 번호 ----->
		            <th style="width:40px"><spring:message code='ezQuestion.t344' /></th>
		            <!--- 응답자 명 ----->
		            <% //# 기명으로 설문조사를 실시한 경우 %>
		            <% if (public_flg == "0") { %>
		            <th style="width:140px"><spring:message code='ezQuestion.t408' /></th>
		            <th style="width:80px"><spring:message code='ezQuestion.t4' /></th>
		            <th style="width:130px"><spring:message code='ezQuestion.t8' /></th>
		            <% } %>
		            <!--- 응답 내용 ----->
		            <th style="text-align:center"><spring:message code='ezQuestion.t410' /></th>
		        </tr>
		        <asp:Repeater ID="reList" runat="server">
		            <ItemTemplate>
		                <tr>
		                    <td style="width:40px;text-align:center"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("NO").InnerText %> </td>
		                    <% //# 기명으로 설문조사를 실시한 경우 %>
		                    <% if (public_flg == "0")
		                       { %>
		                    <td style="width:140px"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("RESPONSEUSER_DEPT_NAME").InnerText %></td>
		                    <td style="width:80px"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("RESPONSEUSER_POSITION").InnerText %></td>
		                    <td style="width:130px"><a style="cursor: pointer" onclick="Detail_UserInfo('<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("RESPONSEUSER_ID").InnerText %>')"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("RESPONSEUSER_NAME").InnerText %> </a></td>
		                    <% } %>
		                    <%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("OPTION").InnerText.Replace("\r\n", "<br>") %>
		                </tr>
		                <% if (pTotalCnt == 0)
		                   { %>
		                <tr>
		                    <td style="height:30px;text-align:center" colspan="5"><spring:message code='ezQuestion.t413' /></td>
		                </tr>
		                <% } %>
		            </ItemTemplate>
		        </asp:Repeater> --%>
		    </table>
		    <div id="tblPageRayer"></div>
		<form method="post" id="form_analysissave" name="form_analysissave" enctype="multipart/form-data" action="Result_AnalysisSave.aspx" target="_self">
		    <input type="hidden" name="AnalysisData" id="AnalysisData" />
		    <input type="hidden" name="hidQst2" id="hidQst2" value="ALL" /><!-- 전체/문항 구분 -->
		    <input type="hidden" name="hidCatalog2" id="hidCatalog2" value="0" /><!-- Catalog 구분 -->
		    <input type="hidden" name="hidRType2" id="hidRType2" value="A" /><!-- 표/그래프 구분 --->
		</form>
	</body>
</html>