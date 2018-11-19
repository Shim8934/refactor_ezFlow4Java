<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var Strmessage = "<spring:message code = 'ezPersonal.t1022' />";
	        var xmlhttp = null;
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
	        $(document).ready(function() {
	        	$(".hidden").hide().removeClass("hidden");
	        	
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezPersonal/getQuickLinkList.do",
	        		dataType : "JSON",
            		contentType: "application/json",
	        		success : function(result) {
	        			event_QuickList2(result);
	        			//event_QuickList(loadXMLString(result));
	        		}
	        	});
	        });
	        
	        function event_QuickList(result) {
	            try {
	                document.getElementById("AccessList").innerHTML = "";
	                var xmldom = result;
	                var headerData = createXmlDom();
	                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
					
	                if (CrossYN()) {
	                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
	                    var Node = headerData.importNode(xmlRtn, true);
	                    headerData.documentElement.appendChild(Node);
	                } else {
	                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
	                    headerData.documentElement.appendChild(xmlRtn);
	                }
	
	                var listview = new ListView();
	                listview.SetID("AccessListView");
	                listview.SetSelectFlag(false);
	                listview.SetMulSelectable(true);
	                listview.SetRowOnDblClick("QuickList_onDblclick");
	                listview.DataSource(headerData);
	                listview.DataBind("AccessList");
	                //listview.DataSource(xmldom);
	                listview.RowDataBind();
	                xmldomNode = null;
	                xmldom = null;
	                
	                //2018-08-09 김보미 - 데이터가 없을 경우 출력
	                if (headerData.getElementsByTagName("ROW").length == 0) {
	                	var TR_noItems = "<tr id='Link_TR_noItems'><td style='text-align: center;' colspan='8'>" + "<spring:message code = 'ezPersonal.t20005' />" + "</td></tr>";
		            	$("#AccessListView tbody").eq(0).html(TR_noItems);
	                }
	            } catch (e) {
	
	            }
	        }
			function event_QuickList2(result) {
				var mainList = document.getElementById("mainlist");
				
				result.forEach(function(item, index) {
					var liElmt  = document.createElement("li");
					var divElmt = document.createElement("div");
					var titElmt = document.createElement("p");
					var urlElmt = document.createElement("p");
					var updElmt = document.createElement("img");
					var delElmt = document.createElement("img");
					var dlElmt  = document.createElement("dl");
					
					liElmt.className = "link";
					liElmt.setAttribute("id", item.quickLinkID);
					
					divElmt.className = "linkBttn";
					updElmt.setAttribute("src", "/images/email/popup_icon.gif");
					delElmt.setAttribute("src", "/images/close_xBtn.png");
					
					divElmt.appendChild(updElmt);
					divElmt.appendChild(delElmt);
					
					titElmt.innerHTML = setQuickImg(item.linkType, item.linkTypeUrl) + item.quickLinkName;
					urlElmt.textContent = item.url;
					
					var dtElmt1 = document.createElement("dt");
					var dtElmt2 = document.createElement("dt");
					var dtElmt3 = document.createElement("dt");
					
					var ddElmt1 = document.createElement("dd");
					var ddElmt2 = document.createElement("dd");
					var ddElmt3 = document.createElement("dd");
					
					dtElmt1.textContent = "등록자 : ";
					dtElmt2.textContent = "등록일: ";
					dtElmt3.textContent = "수정일: ";
					
					ddElmt1.textContent = item.displayName;
					ddElmt2.textContent = item.regDate.substring(0, 10);
					ddElmt3.textContent = item.modiDate == null? item.modiDate : item.modiDate.substring(0, 10);
					
					dlElmt.appendChild(dtElmt1);
					dlElmt.appendChild(ddElmt1);
					dlElmt.appendChild(dtElmt2);
					dlElmt.appendChild(ddElmt2);
					dlElmt.appendChild(dtElmt3);
					dlElmt.appendChild(ddElmt3);
					
					liElmt.appendChild(divElmt);
					liElmt.appendChild(titElmt);
					liElmt.appendChild(urlElmt);
					liElmt.appendChild(dlElmt);
					
					mainList.appendChild(liElmt);
				});
				
				var addElmt = document.createElement("li");
				var dlElmt  = document.createElement("dl");
				var dtElmt  = document.createElement("dt");
				var imgElmt = document.createElement("img");
				var ddElmt1 = document.createElement("dd");
				var ddElmt2 = document.createElement("dd");
				
				addElmt.addEventListener("click", function(event) { openLinkAdd(); });
				addElmt.className = "linkAdd";
				addElmt.setAttribute("id", "linkAdd");
				imgElmt.setAttribute("src", "/images/admin/menuAdd.png");
				
				ddElmt1.textContent = "빠른 링크를";
				ddElmt2.textContent = "추가하세요.";
				
				dtElmt.appendChild(imgElmt);
				dlElmt.appendChild(dtElmt);
				dlElmt.appendChild(ddElmt1);
				dlElmt.appendChild(ddElmt2);
				
				addElmt.appendChild(dlElmt);
				mainList.appendChild(addElmt);
			}
			function setQuickImg(linkType, linkTypeUrl) {
				var result;
				
				switch(linkType) {
					case "A" : result = "<img src='/images/kr/main/quickmenu_icon01.gif'>"; break;
					case "B" : result = "<img src='/images/kr/main/quickmenu_icon02.gif'>"; break;
					case "C" : result = "<img src='/images/kr/main/quickmenu_icon03.gif'>"; break;
					case "D" : result = "<img src='/images/kr/main/quickmenu_icon04.gif'>"; break;
					case "E" : result = "<img src='/images/kr/main/quickmenu_icon05.gif'>"; break;
					case "F" : result = "<img src='/images/kr/main/quickmenu_icon06.gif'>"; break;
					case "G" : result = "<img src='/images/kr/main/quickmenu_icon07.gif'>"; break;
					case "H" : result = "<img src='/images/kr/main/quickmenu_icon08.gif'>"; break;
					default : result = "<img src='" + linkTypeUrl + "'>"; break;
						break;
				}
				return result;
			}
			function openLinkAdd()  {
				var linksHTML = "<li class='linkDetails' style='display:none'>";
				linksHTML += "<div id='showNewLink'>";
				linksHTML += "<div class='linkTitle'>";
				linksHTML += "<span>빠른 링크 등록/수정</span>";
				linksHTML += "<div id='close' class='close'><ul><li><span></span></li></ul></div>"
				linksHTML += "</div><hr>";
				linksHTML += "<div class='linkContent'>";
				linksHTML += "<table class='content def'>";
				linksHTML += "<tr class='primary'>";
				linksHTML += "<th>이름 (한국어) <span style='color:red'>*</span></th>";
				linksHTML += "<td style='border-bottom: 0px;'><input name='Input' id='Title1' class='contInput' maxlength='50'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr class='primary'>";
				linksHTML += "<th>이름 (영어) <span style='color:red'>*</span></th>";
				linksHTML += "<td style='border-bottom: 0px;'><input type='text' id='Title2' class='contInput' maxlength='50'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr class='secondary'>";
				linksHTML += "<th>이름 (일본어) <span style='color:red'>*</span></th>";
				linksHTML += "<td><input type='text' id='Title3' class='contInput' maxlength='50'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<th>URL <span style='color:red'>*</span></th>";
				linksHTML += "<td><input type='text' id='txtURL' class='contInput' maxlength='512'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<th>열림 종류 </th>";
				linksHTML += "<td><select style='height: 24px; padding-left: 5px;'><option>FULL</option><option>SIZE</option></select></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<th rowspan='2' style='text-align: bottom; vertical-align: top;'>팝업 크기</th>";
				linksHTML += "<td><span id='div_Size'>Width <input type='text' id='txt_Width' class='popInput'></span></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td><span id='div_Size'>Height <input type='text' id='txt_Height' class='popInput'></span></td>";
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</div>";
				linksHTML += "<div class='linkContent'>";
				linksHTML += "<table class='content type'>";
				linksHTML += "<tr>";
				linksHTML += "<th>링크 Type <span style='color:red'>*</span></th>";
				linksHTML += "<td style='border-left: 1px solid #d2d2d2;'>";
				linksHTML += "<table class='linkType'>"	
				linksHTML += "<tr>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon01.gif' id='A' onclick='radioClick(this,'img')'></td>"
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon02.gif' id='B' onclick='radioClick(this,'img')'></td>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon03.gif' id='C' onclick='radioClick(this,'img')'></td>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon04.gif' id='D' onclick='radioClick(this,'img')'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>"
				linksHTML += "<td><input name='linktypeOption' type='radio' value='A' onclick='radioClick(this,'rad')' checked=''></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='B' onclick='radioClick(this,'rad')'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='C' onclick='radioClick(this,'rad')'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='D' onclick='radioClick(this,'rad')'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon05.gif' id='E' onclick='radioClick(this,'img')'></td>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon06.gif' id='F' onclick='radioClick(this,'img')'></td>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon07.gif' id='G' onclick='radioClick(this,'img')'></td>";
				linksHTML += "<td><img src='/images/kr/main/quickmenu_icon08.gif' id='H' onclick='radioClick(this,'img')'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='E' onclick='radioClick(this, 'rad')'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='F' onclick='radioClick(this, 'rad')'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='G' onclick='radioClick(this, 'rad')'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='H' onclick='radioClick(this, 'rad')'></td>";
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td colspan='2'><div class='btnpositionJsp iconBtn' style='text-align: right;'><a class='imgbtn'><span>type 등록</span></a></div></td>";
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</div>";
				linksHTML += "<div class='linkContent'>";
				linksHTML += "<table class='content perm'>";
				linksHTML += "<tr>";
				linksHTML += "<th>권한</th>";
				linksHTML += "<td style='border-left: 1px solid #d2d2d2;'><div class='listview' id='AccessList'></div></td>";	
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td colspan='2'>"
				linksHTML += "<div class='btnpositionJsp iconBtn' style='text-align: right;'><a class='imgbtn'><span>저장</span></a></div>";
				linksHTML += "</td>"
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</div>";
				linksHTML += "</div>";
				linksHTML += "</li>"; 
				
				$("#linkAdd").after(linksHTML);
				$(".linkDetails").slideDown();
			}
	        var addquicklink_dialogArguments = new Array();
	        function btn_Select() {
	            if (CrossYN()) {
	                addquicklink_dialogArguments[0] = "";
	                addquicklink_dialogArguments[1] = btn_Select_Complete;
	                
	                //크롬일때 alert창 크기때문에 크롬일때 구별
		            var agent = navigator.userAgent.toLowerCase();
		            if (agent.indexOf("chrome") != -1) {
		            	//2018-08-03 김보미 - alert창 크기때문에 팝업 사이즈 조정
		            	//var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=new", "AddQuickLink", GetOpenWindowfeature(450, 682));	
		            	var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=new", "AddQuickLink", GetOpenWindowfeature(460, 682));	
		            } else {
		            	var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=new", "AddQuickLink", GetOpenWindowfeature(415, 670));
		            }
	                
	                try { AddQuickLink.focus(); } catch (e) {
	                }
	            } else {
	                var rtnValue = window.showModalDialog("/admin/ezPersonal/addQuickLink.do?mode=new", "", "dialogHeight:620px;dialogwidth:400px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(415, 670));
	                window.location.reload();
	            }
	        }
	
	        function btn_Select_Complete() {
	            window.location.reload();
	        }
	
	        function QuickList_onDblclick() {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var listviewSelected = listview.GetSelectedRows();
	            if (listviewSelected == "") {
	                alert(Strmessage);
	                return;
	            }
	
	            if (CrossYN()) {
	                addquicklink_dialogArguments[0] = listviewSelected[0].getAttribute("data1");
	                addquicklink_dialogArguments[1] = btn_Select_Complete;
	                
		            //2018-08-03 김보미 - alert창 크기때문에 팝업 사이즈 조정
 	                //var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=modify", "AddQuickLink", GetOpenWindowfeature(415, 680));
		            var agent = navigator.userAgent.toLowerCase();
		            if (agent.indexOf("chrome") != -1) {
		            	var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=modify", "AddQuickLink", GetOpenWindowfeature(460, 682));	
		            } else {
		            	var AddQuickLink = window.open("/admin/ezPersonal/addQuickLink.do?mode=modify", "AddQuickLink", GetOpenWindowfeature(415, 670));
		            }
	                try { AddQuickLink.focus(); } catch (e) {
	                }
	                
	            } else {
	                var rtnValue = window.showModalDialog("/admin/ezPersonal/addQuickLink.do?mode=modify", listviewSelected[0].getAttribute("data1"), "dialogHeight:620px;dialogwidth:400px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(415, 625));
	                window.location.reload();
	            }
	        }
	
	        function btn_Del() {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var listviewSelected = listview.GetSelectedRows();
	            if (listviewSelected == "") {
	                alert(Strmessage);
	                return;
	            }
	
	            if (!confirm("<spring:message code = 'ezPersonal.t00003' />")) {
	            	return;
	            }
	
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", listviewSelected[0].getAttribute("data1"));
	
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/admin/ezPersonal/delQuickLink.do", false);
	            xmlhttp.send(xmlpara);
	
	            if (xmlhttp != null && xmlhttp.readyState == 4) {
	                if (xmlhttp.statusText == "OK") {
	                    alert("<spring:message code = 'ezPersonal.t00004' />");
	                    window.location.reload();
	                }
	            }
	        }
		</script>
		<style type="text/css">
			.link, .linkAdd {cursor: pointer; vertical-align: top; display: inline-block; width: 310px; border: 1px solid #d9d9d9; margin: 20px 30px 0px 0px; height: 200px;}
			.linkAdd {border: 1px dashed #aaaaaa;}
			.linkAdd dl dt {text-align: center; margin-top: 50px;}
			.linkAdd dl dt img {height: 60px; width: 60px;}
			.linkAdd dl dd {margin-left: 120px; color: #999; font-size: 15px; line-height: 19px;}
			.link dl {margin: 10px;}
			.link dl dt, .link dl dd {font-size: 13px; line-height: 25px;} 
			.link dl dt {float: left; width: 50px;}
			.link p {margin: 0px 10px 0px 10px; font-size: 18px; font-weight: bold; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
			.link p img {vertical-align: bottom; width: 30px; height: 30px;}
			.linkBttn {text-align: right; padding: 10px 10px 0px 0px;}
			.linkBttn > img {height: 14px; width: 14px;}
			.linkBttn > img:first-child {margin-right: 5px;}
			.linkDetails {list-style: none; float: left; width: 90%; border: 1px solid black; position: relative; display: list-item; margin: 20px 0px 20px 0px;}
			.linkTitle {margin: 10px;}
			.linkTitle span {font-size: 18px; font-weight: bold;}
			.linkContent {float: left; width: 375px; min-width: 375px; display: inline-block; margin: 3px 10px 10px 10px;}
			.content, .content th, .content td {border: 0px;}
			.content th {background-color: transparent;}
			.contInput {width: 100%; -moz-box-sizing: border-box; box-sizing: border-box;}
			.primary > td {border: 0px;}
			.popInput {width:30px;}
			.type tr th, .perm tr th {vertical-align: top;}
			.listview {height: 142px; overflow-y: auto; overflow-x: hidden; border-bottom: 0px; border-width: 0px; border: 1px solid #ddd; margin-left: 7px;}
			.perm tr:ntn-child(2) > td {padding:0px; border-left: 1px solid #ddd;}
			.perm tr:ntn-child(2) > td > div {text-align: right;}
			.linkType {width:280px; margin-left:5px; border: 1px solid #d2d2d2;}
			.linkType tr {text-align:center;} 
			.linkType tr td {width:25%;}
			.linkType tr:nth-child(odd) > td {cursor:pointer;}
			.linkType tr:nth-child(even) > td {text-align:center; margin-top:-5px;}
			.hidden {display: none;}
		</style>
	</head>
	<body class="mainbody">
		<c:choose>
			<c:when test="${lang == '1'}">
				<xml id="listviewheader" style ="display:none">
					<LISTVIEWDATA>
						<HEADERS>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' /></NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					      	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s82' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
							<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s84' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					     	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1023' />Type</NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME>URL</NAME>
					        	<WIDTH>70</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1024' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1025' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1026' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					    </HEADERS>
					</LISTVIEWDATA>
				</xml>
			</c:when>
			<c:when test="${lang == '2'}">
				<xml id="listviewheader" style ="display:none">
					<LISTVIEWDATA>
						<HEADERS>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s82' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s81' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
							<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s84' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					     	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1023' />Type</NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME>URL</NAME>
					        	<WIDTH>70</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1024' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1025' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1026' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					    </HEADERS>
					</LISTVIEWDATA>
				</xml>
			</c:when>
			<c:otherwise>
				<xml id="listviewheader" style ="display:none">
					<LISTVIEWDATA>
						<HEADERS>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s84' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					    	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s81' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
							<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.jjs03' />(<spring:message code = 'ezPersonal.s82' />)</NAME>
					        	<WIDTH>40</WIDTH>
					      	</HEADER>
					     	<HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1023' />Type</NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME>URL</NAME>
					        	<WIDTH>70</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1024' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1025' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					        <HEADER>
					        	<NAME><spring:message code = 'ezPersonal.t1026' /></NAME>
					        	<WIDTH>50</WIDTH>
					      	</HEADER>
					    </HEADERS>
					</LISTVIEWDATA>
				</xml>
			</c:otherwise>
		</c:choose>

		
		<h1>Quick Link</h1>
		<div id="mainmenu">
			<ul>
		    	<li class="important"><span onclick="btn_Select()"><spring:message code = 'ezPersonal.t105' /></span></li>
		    	<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		        <li><span onclick="QuickList_onDblclick()"><spring:message code = 'ezPersonal.t169' /></span></li>
		        <li><span class="icon16 icon16_delete" onclick="btn_Del()"></span></li>
			</ul>
		</div>
		<script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	    <table class="mainlist" style="width:100%;">
	        <div id=AccessList style ="WIDTH:100%; border-right:1px solid #e8e8e8; border-left:1px solid #e8e8e8;"></div>
	    </table>
		<ul id="mainlist"></ul>
	</body>
</html>