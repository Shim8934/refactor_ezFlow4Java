<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezQuestion.t115" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script src="https://code.jquery.com/jquery-1.12.0.min.js"></script>
		<script type="text/javascript" src="/js/ezQuestion/jquery.battatech.excelexport.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezQuestion/ListView_list.js"></script>
		
	
		<script type="text/javascript" >
			var SelectedQuesNo = "";
			var returnXML = "";
	        var xmlHttp = createXMLHttpRequest();
	        var xmlRtn = createXmlDom();
			var szRType = "";
			var savemsg;
			var buttonFlag = "";
			var pBrdID = "${pBrdID}";
			var pItemNo = "${pItemNo}";

			document.onselectstart = function () { return false; };
			window.onload = function () {
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
			    var listview = new ListView();
			    listview.SetID("AnalysisList");
			    listview.SetSelectFlag(false);
			    listview.SetMulSelectable(true);
			    listview.SetRowOnDblClick("ListViewNodeDblClick");
			    listview.DataSource(listviewheader);
			    listview.DataBind("AnalysisListView");
			    tableXML();
			    
			    $("#saveExcel").click(function () {
			    	if (!StateChangeClickFlag) {
		                return;
		            }
			    	
			    	if(document.getElementById("hidRType2").value=="T"){
			    		var tr = AnalysisListView.getElementsByTagName("tr");
		                for (var i = 0; i < tr.length; i++) {
		                    if (tr[i].getAttribute("selected") == "true") {
		                        tr[i].style.backgroundColor = "white";
		                    }
		                }
		                document.getElementById("AnalysisData").value = AnalysisListView.innerHTML;
		                
			            $("#AnalysisList").battatech_excelexport({
			                containerid: "AnalysisList"
			               , datatype: 'table'
			            });
			    	}else{
			    		 if (Graph.innerHTML != "") {
			    		 	document.getElementById("AnalysisData").value = Graph.innerHTML;
			    		 
							$("#Graph").battatech_excelexport({
			                containerid: "Graph"
			               	, datatype: 'table'
			            	});
			    		 }else{
			    			 alert("분석결과가 없습니다.");
			    		 }
			    	}
		        });
			    
			}
			
			function tableXML(){
				var xmlDoc = loadXMLString('${xmlMainDom}');
				var DataNode = SelectSingleNode(xmlDoc, "DATA");
				var RowNode = SelectSingleNode(DataNode,"ROW");
				var nodes = GetChildNodes(DataNode);
				var tableXml=document.getElementsByName("listQst")[0].innerHTML;
				for(i=0; i<nodes.length ;i++){
					tableXml += "<option value='" + SelectSingleNodeValue(nodes[i], "QUESTION_NO") +"' anstype='"+SelectSingleNodeValue(nodes[i], "ANSWERTYPE")+"'>"+SelectSingleNodeValue(nodes[i], "QUESCONTENT")+"</option>"
				}
				document.getElementsByName("listQst")[0].innerHTML = tableXml;
			}
			
			function menuQst_List() {
	            var szUrl = "/ezQuestion/qstList.do?brd_id="+pBrdID+"";
			    window.location.href = szUrl;
			}
		    function menu_AnalyStart() {
				if (buttonFlag != "") {
		            return;
		        }
				
		        var szQst = hidQst.value;
		        var szCatalog = hidCatalog.value;
		        szRType = hidRType.value;
		        var szUrl;
		        switch (szCatalog) {
		            case "0":
		                szUrl = "/ezQuestion/qstCallAnalysisAll.do";
		                break;
		            case "1":
		                szUrl = "/ezQuestion/qstCallAnalysisDept4.do";
		                break;
		            case "2":
		                szUrl = "/ezQuestion/qstCallAnalysisPos2.do";
		                break;
		            case "3":
		                szUrl = "/ezQuestion/qstCallAnalysisJikgub2.do";
		                break;
		            case "4":
		                szUrl = "/ezQuestion/qstCallAnalysisAge2.do";
		                break;
		            case "5":
		                szUrl = "/ezQuestion/qstCallAnalysisGender2.do";
		                break;
		        }
	        	var szParam = "?brd_id="+pBrdID+"&item_no="+pItemNo;
		        if (szQst == "ALL") {
		            szParam += "&ques_no=0";
		        }else {
		            if (SelectedQuesNo == "") {
		                alert("<spring:message code='ezQuestion.t119' />");
		                return;
		            }
	           		szParam += "&ques_no=" + SelectedQuesNo;
				}
	        	szUrl += szParam;
				try {
					document.getElementById("message").innerHTML = "<font  color=bule>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code='ezQuestion.t120' /></font>"
					buttonFlag = "enableFalse";
					xmlHttp = null;
					xmlHttp = createXMLHttpRequest();
					xmlHttp.open("POST", szUrl, true);
					xmlHttp.onreadystatechange = HandleStateChange;
					xmlHttp.send();
				}catch (e) {
					alert(e.description);
				}
			}
	    	var StateChangeClickFlag = false;
	    	function HandleStateChange() {
	        	if (xmlHttp.readyState != 4) {
	            	return;
	        	}
		        StateChangeClickFlag = true;
		        document.getElementById("message").innerHTML = "";
		        if (xmlHttp.responseText != "") {
		            xmlTemp = loadXMLString(xmlHttp.responseText);
		            xmlRtn = SelectSingleNode(xmlTemp, "LISTVIEWDATA");
		            var rows = SelectNodes(xmlRtn, "ROW");
		            var Rlength = rows.length;
		            if (Rlength != 0) {
		                document.getElementById("hidRType2").value = szRType;
		                document.getElementById("AnalysisData").value = "";
		                if (szRType == "T") {
		                    document.getElementById("AnalysisData").value = getXmlString(xmlRtn);
		                    document.getElementById("AnalysisListView").innerHTML = "";
		                    var listview = new ListView();
		                    listview.SetID("AnalysisList");
		                    listview.SetSelectFlag(false);
		                    listview.SetMulSelectable(true);
		                    listview.SetRowOnDblClick("ListViewNodeDblClick");
		                    listview.DataSource(xmlRtn);
		                    listview.DataBind("AnalysisListView");
		                } else {
		                    var strHTML = "<table width=100% border=0 cellspacing=0 cellpadding=1 border=0>";
		                    for (var i = 0; i < Rlength; i++) {
								var SelNode = rows.item(i);
								var cells = null;
								cells = SelectNodes(SelNode, "CELL");
		                        var Clength = cells.length;
		                        var gubun = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[0], "DATA1");
		                        if (gubun == "TOT") {
		                            var txt = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[0], "VALUE");
		                            var cnt = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[1], "VALUE");
		                            strHTML += "<tr>";
		                            strHTML += "<td colspan=5>" + txt + " " + cnt;
		                            strHTML += "</td></tr>";
		                        }
		                        else if (gubun == "Q") {
		                            var txt = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[0], "VALUE");
		                            strHTML += "<tr>";
		                            strHTML += "<td colspan=5>" + txt;
		                            strHTML += "</td></tr>"
		                        }
		                        else if (gubun == "A") {
		                            var txt = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[0], "VALUE");
		                            var cnt = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[1], "VALUE");
		                            var percent = SelectSingleNodeValue(rows.item(i).getElementsByTagName("CELL")[2], "VALUE");
		                            strHTML += "<tr>";
		                            strHTML += "<td>&nbsp;</td>";
		                            strHTML += "<td>" + txt + "</td>";
		                            strHTML += "<td>" + cnt + "</td>";
		                            strHTML += "<td width='50' align='right'>[" + percent + "]</td>";
		                            percent = percent.replace("%", "");
		                            strHTML += "<td width=150 valign=middle>";
		                            if (percent != 0) {
		                                strHTML += "<img src='http://" + document.location.host + "/images/img_graph.gif' width='" + percent + "' height='16'  align='absmiddle'>";
		                            }
		                            strHTML += "</td></tr>";
		                        }
		                    }
		                    strHTML += "</table>";
		                    document.getElementById("Graph").innerHTML = strHTML;
		                    document.getElementById("AnalysisData").innerHTML = strHTML;
		                }
		            } else {
		                document.getElementById("AnalysisData").value = "";
		                document.getElementById("hidRType2").value = "";
		                alert("<spring:message code='ezQuestion.t121' />");
		            }
		            buttonFlag = "";
		        }else {
		            buttonFlag = "";
		            return false;
		        }
		    }
		    function AnalysisGResult(strXML) {
		        var xmlRtn = createXmlDom();
		        xmlRtn.loadXML(strXML);
		        var rows = xmlRtn.getElementsByTagName("ROW");
		        var Rlength = rows.length;
		        var strHTML = "<table width=100% border=0 cellspacing=0 cellpadding=1 border=0>";
		        for (var i = 0; i < Rlength; i++) {
		            var cells = rows[i].getElementsByTagName("CELL");
		            var Clength = cells.length;
		            var gubun = cells[0].getElementsByTagName("DATA1")[0].text;

		            if (gubun == "TOT") {
		                var txt = cells[0].getElementsByTagName("VALUE")[0].text;
		                var cnt = cells[1].getElementsByTagName("VALUE")[0].text;
		                strHTML += "<tr>"
		                strHTML += "<td colspan=5>" + txt + " " + cnt;
		                strHTML += "</td></tr>"
		            }else if (gubun == "Q") {
		                var txt = cells[0].getElementsByTagName("VALUE")[0].text;
		                strHTML += "<tr>";
		                strHTML += "<td colspan=5>" + txt;
		                strHTML += "</td></tr>"
		            }else if (gubun == "A") {
		                var txt = cells[0].getElementsByTagName("VALUE")[0].text;
		                var cnt = cells[1].getElementsByTagName("VALUE")[0].text;
		                var percent = cells[2].getElementsByTagName("VALUE")[0].text;
		                
		                strHTML += "<tr>";
		                strHTML += "<td>&nbsp;</td>";
		                strHTML += "<td>" + txt + "</td>";
		                strHTML += "<td>" + cnt + "</td>";
		                strHTML += "<td width='50' align='right'>[" + percent + "]</td>";
		                percent = percent.replace("%", "");
		                strHTML += "<td width=150 valign=middle>";
		                if (percent != "0") {
		                    //strHTML += "<img src='http://" + document.location.host + "/images/img_graph.gif' width='" + percent + "' height='16'  align='absmiddle'>";
		                    strHTML = strHTML + percent + "%";
		                }
		                strHTML += "</td></tr>";
		            }
		
		        }
		        strHTML += "</table>"
		        Graph.innerHTML = strHTML;
		    }
		    
		    function repComMa(param) {
		        while (param.indexOf(",") != -1) {
		            param = param.replace(",", "<spring:message code='ezQuestion.t126' />");
		            if (param.indexOf(",") == -1) {
		                break;
		            }
		        }
		        return (param);
		    }
		    function listQst_onchange() {
		        var idx = document.getElementsByName("listQst")[0].selectedIndex;
		        SelectedQuesNo = document.getElementsByName("listQst")[0][idx].value;
		    }
		    function rdoQst_onclick(idx) {
		        hidQst.value = document.getElementsByName("rdoQst")[idx].value;
		        if (idx == 1) {
		            document.getElementsByName("listQst")[0].disabled = "";
		        }else {
		            document.getElementsByName("listQst")[0].disabled = "disabled";
		        }
		    }
		    function Catalog_onclick(idx) {
		        hidCatalog.value = document.getElementsByName("Catalog")[idx].value;
		    }
		    function Result_onclick(idx) {
		        hidRType.value = document.getElementsByName("Result")[idx].value;
		        if (hidRType.value == "T") {
		            AnalysisListView.style.display = "";
		            Graph.style.display = "none";
		        }else {
		            AnalysisListView.style.display = "none";
		            Graph.style.display = "";
		        }
		    }
		    function TotalSaveCSV() {
		        if (buttonFlag != "") {
		            alert("<spring:message code='ezQuestion.t128' />")
		            return
		        }
		        document.getElementById("message").innerHTML = "<font  color=bule>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<spring:message code='ezQuestion.t120' /></font>"
		        var _MSIE = 'MSIE';
		        var useragentstr = navigator.userAgent;
		        
		        document.getElementById("iframe").src = "resultTotalSave.do?item_no=" + pItemNo;
		        document.getElementById("message").innerHTML = "";
		    }
		</script>
	</head>
	
	<body class="mainbody">
		<xml id="listviewheader" style="display:none">
		    <LISTVIEWDATA>
		        <HEADERS>
				    <HEADER>
					    <STYLE>background-color:#C4D4EB;</STYLE>
					    <NAME><spring:message code='ezQuestion.t46' /></NAME>
					    <WIDTH>60</WIDTH>
				    </HEADER>
				    <HEADER>
					    <STYLE>background-color:#C4D4EB;</STYLE>
					    <NAME><spring:message code='ezQuestion.t47' /></NAME>
					    <WIDTH>20</WIDTH>
				    </HEADER>
				    <HEADER>
					    <STYLE>background-color:#C4D4EB;</STYLE>
					    <NAME><spring:message code='ezQuestion.t48' />.Replace(" ", "")%></NAME>
					    <WIDTH>20</WIDTH>
				    </HEADER>
			    </HEADERS>
		    </LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezQuestion.t129' /></h1>
		<div id="mainmenu">
			<ul>
			    <li><span onclick="menuQst_List()"><spring:message code='ezQuestion.t130' /></span></li>
			    <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" align="absmiddle"></li>
			    <li><span id="saveExcel"><spring:message code='ezQuestion.t131' /></span></li>
			    <li><span id="saveTotalExcel"><spring:message code='ezQuestion.t132' /></span></li>
			</ul>
		</div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content">
			<tr>
				<th><spring:message code='ezQuestion.t133' /></th>
		    	<td>
		    		<input type="radio" name="rdoQst" value="ALL" onclick="javascript:return rdoQst_onclick(0)" checked="checked" style="vertical-align:-2px;" /><spring:message code='ezQuestion.t138' />
			      	<input type="radio" name="rdoQst" value="PART" onclick="javascript:return rdoQst_onclick(1)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t135' />
					<select name="listQst" style=" WIDTH:300px;" onChange="return listQst_onchange()">
						<option value="" selected><spring:message code='ezQuestion.t136' /></option>
					</select>
		      	</td>
		 	</tr>
		  	<tr>
				<th><spring:message code='ezQuestion.t137' /></th>
		    	<td>
		    		<input type="radio" name="Catalog" value="0" onclick="javascript:return Catalog_onclick(0)" checked="checked"style="vertical-align:-2px;"/><spring:message code='ezQuestion.t138' />
			    	<c:choose>
			    		<c:when test="${pPubFlag == 1 }">
			    			<input type="radio" name="Catalog" value="1" disabled onclick="javascript:return Catalog_onclick(1)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t139' />
					        <input type="radio" name="Catalog" value="2" disabled onclick="javascript:return Catalog_onclick(2)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t140' />
					        <input type="radio" name="Catalog" value="3" disabled onclick="javascript:return Catalog_onclick(3)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t141' />
			    		</c:when>
			    		<c:otherwise>
							<input type="radio" name="Catalog" value="1" onclick="javascript:return Catalog_onclick(1)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t139' />
					        <input type="radio" name="Catalog" value="2" onclick="javascript:return Catalog_onclick(2)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t140' />
					        <input type="radio" name="Catalog" value="3" onclick="javascript:return Catalog_onclick(3)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t141' />
			    		</c:otherwise>
			    	</c:choose>
		    	</td>
		  	</tr>
		  	<tr>
				<th><spring:message code='ezQuestion.t144' /></th>
		    	<td>
			        <input type="radio"  name="Result" value="T" onclick="javascript:return Result_onclick(0)" checked=checked style="vertical-align:-2px;"/>
			        <spring:message code='ezQuestion.t145' />
			        <input type="radio" name="Result" value="G" onclick="javascript:return Result_onclick(1)" style="vertical-align:-2px;"/><spring:message code='ezQuestion.t146' />
			        <a class="imgbtn"><span onclick="menu_AnalyStart()"><spring:message code='ezQuestion.t147' /></span></a><span id="message"></span>
			    </td>
			</tr>
		</table>
		
		<div id="AnalysisListView" class="listview" style="padding:0;margin-top:10px;OVERFLOW:auto;HEIGHT:300px;"></div>
		<div id="Graph" class="box" style="padding:0;margin-top:10px;DISPLAY:none; OVERFLOW:auto; WIDTH:100%; HEIGHT:70%; BACKGROUND-COLOR:#ffffff"></DIV>

		<input type="hidden" name="hidQst" id="hidQst" value="ALL" /><!-- 전체/문항 구분 -->
		<input type="hidden" name="hidCatalog" id="hidCatalog" value="0" /><!-- Catalog 구분 -->
		<input type="hidden" name="hidRType" id="hidRType" value="T" /><!-- 표/그래프 구분 --->
		<iframe id="iframe" src="" style="DISPLAY:none"> </iframe>

		<form method="post" id="form_analysissave" name="form_analysissave" enctype="multipart/form-data" action="/ezQuestion/qstResultAnalysisSave.do" target="_self">
		    <input type="hidden" name="AnalysisData" id="AnalysisData" />
		    <input type="hidden" name="hidQst2" id="hidQst2" value="ALL" /><!-- 전체/문항 구분 -->
		    <input type="hidden" name="hidCatalog2" id="hidCatalog2" value="0" /><!-- Catalog 구분 -->
		    <input type="hidden" name="hidRType2" id="hidRType2" value="T" /><!-- 표/그래프 구분 --->
		</form>
	</body>
</html>