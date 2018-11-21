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
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		
		<script type="text/javascript">
			var Strmessage = "<spring:message code = 'ezPersonal.t1022' />";
	        var xmlhttp = null;
			var host;                         //host서버
			var userLang;                     //언어
			var mode;                         //new, modify
			var guid = "{" + GetGUID() + "}"; //랜덤Id
			var checkValue = "A";             //타입종류
			var LinkTypeURL;                  //타입src정보
			var mainTitleId;
			var subTitle1Id;
			var subTitle2Id;
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			$(document).ready(function() {
				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/getQuickLinkList.do",
					dataType : "JSON",
					contentType: "application/json",
					success : function(result) {
						host = result.host;
						event_QuickList(result.list);
					}
				});
			});
			function event_QuickList(result) {
				var mainList = document.getElementById("mainlist");
				
				result.forEach(function(item, index) {
					var itemId  = item.quickLinkID;
					var liElmt  = document.createElement("li");
					var divElmt = document.createElement("div");
					var titElmt = document.createElement("p");
					var urlElmt = document.createElement("p");
					var updElmt = document.createElement("img");
					var delElmt = document.createElement("img");
					var dlElmt  = document.createElement("dl");
					
					liElmt.className = "link";
					liElmt.setAttribute("id", itemId);
					
					divElmt.className = "linkBttn";
					updElmt.setAttribute("src", "/images/email/popup_icon.gif");
					updElmt.addEventListener("click", function(event) {btn_modify(itemId);});
					
					delElmt.setAttribute("src", "/images/close_xBtn.png");
					delElmt.addEventListener("click", function(event) {btn_delete(itemId);});
					
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
				
				addElmt.addEventListener("click", function(event) {btn_add();});
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
				
				//링크삭제후순서업데이트
				updateLinkOrder();
				
				//링크드래그앤드롭
				$("#mainlist").sortable({
					items: "li.link",
					start: function(event, ui) {
						$(".linkDetails").remove();
					},
					update: function(event, ui) {
						updateLinkOrder();
					}
				});
				
				$("#mainlist").disableSelection();
			}
			function setQuickImg(linkType, linkTypeUrl) {
				var result;
				
				if (host == "gw.freet.co.kr") {
					switch(linkType) {
						case "A" : result = "<img src='/images/kr/main/quickmenu_icon01.png' id='A'>"; break;
						case "B" : result = "<img src='/images/kr/main/quickmenu_icon02.gif' id='B'>"; break;
						case "C" : result = "<img src='/images/kr/main/quickmenu_icon03.png' id='C'>"; break;
						case "D" : result = "<img src='/images/kr/main/quickmenu_icon04.gif' id='D'>"; break;
						case "E" : result = "<img src='/images/kr/main/quickmenu_icon05.gif' id='E'>"; break;
						case "F" : result = "<img src='/images/kr/main/quickmenu_icon06.gif' id='F'>"; break;
						case "G" : result = "<img src='/images/kr/main/quickmenu_icon07.png' id='G'>"; break;
						case "H" : result = "<img src='/images/kr/main/quickmenu_icon08.gif' id='H'>"; break;
						default : result = "<img src='" + linkTypeUrl + "'>"; break;
						break;
					}	
				}
				else {
					switch(linkType) {
						case "A" : result = "<img src='/images/kr/main/quickmenu_icon01.gif' id='A'>"; break;
						case "B" : result = "<img src='/images/kr/main/quickmenu_icon02.gif' id='B'>"; break;
						case "C" : result = "<img src='/images/kr/main/quickmenu_icon03.gif' id='C'>"; break;
						case "D" : result = "<img src='/images/kr/main/quickmenu_icon04.gif' id='D'>"; break;
						case "E" : result = "<img src='/images/kr/main/quickmenu_icon05.gif' id='E'>"; break;
						case "F" : result = "<img src='/images/kr/main/quickmenu_icon06.gif' id='F'>"; break;
						case "G" : result = "<img src='/images/kr/main/quickmenu_icon07.gif' id='G'>"; break;
						case "H" : result = "<img src='/images/kr/main/quickmenu_icon08.gif' id='H'>"; break;
						default : result = "<img src='" + linkTypeUrl + "'>"; break;
						break;
					}	
				}
				return result;
			}
			function btn_add()  {
				var itemId = "";
				$.ajax({
					url : "/admin/ezPersonal/addQuickLink.do",
					data : {"mode": "new"},
					dataType : "JSON",
					contentType: "application/json",
					success : function(result) {
						openLinkDetail(result, itemId);
					}
				});
			}
			function btn_modify(itemId) {
				$.ajax({
					url : "/admin/ezPersonal/addQuickLink.do",
					data : {"mode": "modify"},
					dataType : "JSON",
					contentType: "application/json",
					success : function(result) {
						openLinkDetail(result, itemId);
					}
				});
			}
			function btn_delete(itemId) {
				if (!confirm("<spring:message code = 'ezPersonal.t00003' />")) {
					return;
				}
				
				$.ajax({
					url : "/admin/ezPersonal/delQuickLink.do",
					async : false,
					data : {pQuickLinkID : itemId},
					dataType : "JSON",
					contentType: "application/json",
					success : function(result) {
						if (result.result == "OK") {
							alert("<spring:message code = 'ezPersonal.t00004' />");
							window.location.reload();
						}
					}
				});
			}
			function openLinkDetail(item, itemId) {
				userLang = item.strUserLang;
				mode = item.mode;
				
				if (mode == "modify") {
					initQuickLink(itemId);
					initQuickLinkACL(itemId);
				}
				
				var mainTitle;
				var subTitle1;
				var subTitle2;
				
				if (item.primary == 1) {
					mainTitle = "<spring:message code = 'ezPersonal.s81' />";
					subTitle1 = "<spring:message code = 'ezPersonal.s82' />";
					subTitle2 = "<spring:message code = 'ezPersonal.s84' />";
					
					mainTitleId = "Title1";
					subTitle1Id = "Title2";
					subTitle2Id = "Title3";
				} else if (item.primary == 2) {
					mainTitle = "<spring:message code = 'ezPersonal.s82' />";
					subTitle1 = "<spring:message code = 'ezPersonal.s81' />";
					subTitle2 = "<spring:message code = 'ezPersonal.s84' />";
					
					mainTitleId = "Title2";
					subTitle1Id = "Title1";
					subTitle2Id = "Title3";
				} else {
					mainTitle = "<spring:message code = 'ezPersonal.s84' />";
					subTitle1 = "<spring:message code = 'ezPersonal.s81' />";
					subTitle2 = "<spring:message code = 'ezPersonal.s82' />";
					
					mainTitleId = "Title3";
					subTitle1Id = "Title1";
					subTitle2Id = "Title2";
				}
				
				var linksHTML = "<li class='linkDetails' id='linkLiNew' style='display:none'>";
				linksHTML += "<div id='linkDetailsNew'>";
				linksHTML += "<div class='linkTitle'>";
				linksHTML += "<span>빠른 링크 등록/수정</span>";
				linksHTML += "<div id='close' class='close'><ul><li><span></span></li></ul></div>"
				linksHTML += "</div><hr>";
				linksHTML += "<div class='linkContent'>";
				linksHTML += "<table class='content def'>";
				linksHTML += "<tr class='primary'>";
				linksHTML += "<th><spring:message code = 'ezPersonal.jjs03' /> (" + mainTitle + ") <span style='color:red'>*</span></th>";
				linksHTML += "<td style='border-bottom: 0px;'><input name='Input' id='"+ mainTitleId +"' class='contInput' maxlength='50'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr class='primary'>";
				linksHTML += "<th><spring:message code = 'ezPersonal.jjs03' /> (" + subTitle1 + ") <span style='color:red'>*</span></th>";
				linksHTML += "<td style='border-bottom: 0px;'><input type='text' id='"+ subTitle1Id +"' class='contInput' maxlength='50'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr class='secondary'>";
				linksHTML += "<th><spring:message code = 'ezPersonal.jjs03' /> (" + subTitle2 + ") <span style='color:red'>*</span></th>";
				linksHTML += "<td><input type='text' id='"+ subTitle2Id +"' class='contInput' maxlength='50'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<th>URL <span style='color:red'>*</span></th>";
				linksHTML += "<td><input type='text' id='txtURL' class='contInput' maxlength='512'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<th>열림 종류 </th>";
				linksHTML += "<td><select id='popSize' onchange='popChange();' style='height: 24px; padding-left: 5px;'><option value='chk_Full'>FULL</option><option value='chk_Size'>SIZE</option></select></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<th rowspan='2' style='text-align: bottom; vertical-align: top;'>팝업 크기</th>";
				linksHTML += "<td><span id='div_Size'>Width <input type='text' id='txt_Width' class='popInput' disabled></span></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td><span id='div_Size'>Height <input type='text' id='txt_Height' class='popInput'disabled></span></td>";
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
				linksHTML += "<td>" + setQuickImg("A", "") + "</td>";
				linksHTML += "<td>" + setQuickImg("B", "") + "</td>";
				linksHTML += "<td>" + setQuickImg("C", "") + "</td>";
				linksHTML += "<td>" + setQuickImg("D", "") + "</td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>"
				linksHTML += "<td><input name='linktypeOption' type='radio' value='A' checked=''></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='B'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='C'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='D'></td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td>" + setQuickImg("E", "") + "</td>";
				linksHTML += "<td>" + setQuickImg("F", "") + "</td>";
				linksHTML += "<td>" + setQuickImg("G", "") + "</td>";
				linksHTML += "<td>" + setQuickImg("H", "") + "</td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='E'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='F'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='G'></td>";
				linksHTML += "<td><input name='linktypeOption' type='radio' value='H'></td>";
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</td>";
				linksHTML += "</tr>";
				linksHTML += "<tr>";
				linksHTML += "<td colspan='2'>";
				linksHTML += "<div class='btnpositionJsp iconBtn' style='text-align: right;'><a class='imgbtn'><span onclick='CreateType()'>type 등록</span></a></div>";
				linksHTML += "<table style='margin-top: 10px; margin-left: 10px;display:none;' id='makeTypeTable'>";
				linksHTML += "<tr style='text-align: center;'><td id='makeTypeImgTD'></td></tr>";
				linksHTML += "<tr style='text-align: center;'>";
				linksHTML += "<td style='text-align: center;'><input name='linktypeOption' type='radio' value='Z' id='Z' onclick='radioClick(this, 'rad')' style='margin-top: -5px;' /></td>";
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</td>";
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
				linksHTML += "<div class='btnpositionJsp iconBtn' style='text-align: right;'>";
				linksHTML += "<a class='imgbtn' style='margin-right: 10px'><span onclick='regit()'>권한등록</span></a>";
				linksHTML += "<a class='imgbtn'><span id='btn_OK'>"; 
				
				if (itemId != "" && mode == "modify") {
					linksHTML += "<spring:message code = 'ezPersonal.t169' />";
				}
				else {
					linksHTML += "저장";
				}
				
				linksHTML += "</span></a>";
				linksHTML += "</div>";
				linksHTML += "</td>"
				linksHTML += "</tr>";
				linksHTML += "</table>";
				linksHTML += "</div>";
				linksHTML += "</div>";
				linksHTML += "</li>"; 
				
				var nowShowDetails = $(".linkDetails").children().attr("id");
				var detailId = $(".linkDetails").attr("id");
				
				if(itemId != "") {
					var itemId2 = itemId.substring(1, itemId.indexOf("}"));
				}
				
				if (mode == "new") {
					if (nowShowDetails == "linkDetailsNew") {
						if (detailId != "linkLiNew") {
							$(".linkDetails").slideUp(function(){
								$(".linkDetails").not("#linkLiNew").remove();
							});
							
							$("#linkAdd").after(linksHTML);
							$(".linkDetails").slideDown();
						}
						else {
							$(".linkDetails").slideUp(function(){
								$(".linkDetails").remove();
							});
						}
					}
					else {
						$("#linkAdd").after(linksHTML);
						$(".linkDetails").slideDown();
					}
				}
				else {
					if (detailId == itemId2) {
						$(".linkDetails").slideUp(function(){
							$(".linkDetails").remove();
						});
					}
					else {
						$(".linkDetails").slideUp(function(){
							$(".linkDetails").not("#" + itemId2).remove();
						});
						
						$("#linkAdd").after(linksHTML);
						$(".linkDetails").slideDown();
					}
					
				}
				
				//타입이미지버튼선택설정
				$("img").on("click", function() {
					radioClick(this, 'img');
				});
				
				
				//타입라디오버튼선택설정
				$("input[type=radio]").on("click", function() {
					radioClick(this, 'rad');
				});
				
				//저장버튼설정
				$("#btn_OK").on("click", function() {
					btn_ok(itemId);
				});
				
				//닫기버튼설정
				$(".close").on("click", function(){
					$(".linkDetails").slideUp();
					$(".linkDetails").attr("class", "linkDetails hideDetails");
				});
				
				LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
			}
			function popChange() {
				var popSize = document.getElementById("popSize").value;
				if (popSize == "chk_Full") {
					document.getElementById("txt_Width").disabled = true; 
					document.getElementById("txt_Height").disabled = true; 	
				}
				else{
					document.getElementById("txt_Width").disabled = false; 
					document.getElementById("txt_Height").disabled = false; 
				}
			}
			function S4() {
				return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
			}
			function GetGUID() {
				return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
			}
			var g_xmlhttp;
			function CreateType() {
				if (CrossYN() || (pNoneActiveX == "YES")) {
					document.getElementById('mode').value = "PHOTO";
					document.form.file1.click();
				}
				else {
					var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
					var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
					if (filepath == "") return;
					
					var strBase64 = ezUtil.DownloadToBase64(filepath);
					ezUtil = null;
					
					var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
					var temp = ezUtil.GetImageSize(filepath);
					ezUtil = null;
					
					imageWidth = temp.split("*")[0];
					imageHeight = temp.split("*")[1];
					var strXML = "<IMAGE><DATA>" + strBase64 + "</DATA></IMAGE>";
					
					g_xmlhttp = createXMLHttpRequest();
					g_xmlhttp.onreadystatechange = changeNormalImage_end;
					g_xmlhttp.send(strXML);
				}
			}
			function changeNormalImage_end() {
				if (g_xmlhttp.readyState != 4) return;
				document.getElementById("makeTypeTable").style.display = "";
				document.getElementById("makeTypeImgTD").innerHTML = "";
				
				var _img = document.createElement("IMG");
				_img.src = g_xmlhttp.responseText;
				_img.id = "ZmakeTypeImg";
				_img.onclick = function(){ radioClick(this,'img') };
				_img.style.cursor = "pointer";
				
				document.getElementById("makeTypeImgTD").appendChild(_img);
				document.getElementById("Z").checked = true;
				checkValue = "Z";
				LinkTypeURL = g_xmlhttp.responseText;
			}
			function btn_AttachAdd_onclick() {
				if (document.form.file1.value != "") {
					if (document.getElementById('mode').value == "PHOTO") {
						if (document.getElementById("form").file1.files.length < 2) { } else { alert(""); }
					}
				}
				document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
				var frm = document.getElementById('form');
				frm.action = "/admin/ezPersonal/typeImageUpload.do?QId=" + guid;
				frm.submit();
				document.form.file1.value = "";
			}
			function returnvalue(strXML) {
				var xml = loadXMLString(strXML);
				var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
				for (i = 0; i < nodes.length; i++) {
					if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
						document.getElementById("makeTypeTable").style.display = "";
						
						var path = getNodeText(GetChildNodes(nodes[i])[4]);
						document.getElementById("makeTypeTable").style.display = "";
						document.getElementById("makeTypeImgTD").innerHTML = "";
						
						var _img = document.createElement("IMG");
						_img.src = path;
						_img.id = "ZmakeTypeImg";
						_img.onclick = function () { radioClick(this, 'img') };
						_img.style.cursor = "pointer";
						document.getElementById("makeTypeImgTD").appendChild(_img);
						document.getElementById("Z").checked = true;
						checkValue = "Z";
						LinkTypeURL = path;
					}
				}
			}
			var g_attendant = "";
			var selecttarget_dialogArguments = new Array();
			function regit() {
				if (CrossYN()) {
					selecttarget_dialogArguments[0] = g_attendant;
					selecttarget_dialogArguments[1] = regit_Complete;
					
					var SelectTarget = window.open("/admin/ezPersonal/selectTarget.do", "SelectTarget", GetOpenWindowfeature(840, 480));
					try { SelectTarget.focus(); } catch (e) { }
				} 
				else {
					var config = "status:false;dialogWidth:840px;dialogHeight:480px;scroll:no;status:no;edge:sunken" + GetShowModalPosition(840, 480);
					var ret = window.showModalDialog("/admin/ezPersonal/selectTarget.do", g_attendant, config);
					
					if (ret == undefined)
						return;
					makePermissionsList(ret, false);
				}
			}
			function regit_Complete(rtv) {
				if (rtv == undefined) {
					return;
				}
				makePermissionsList(rtv, false);
			}
			function makePermissionsList(value, xmlFalg) {
				if (document.getElementById("AccessList").innerHTML != "") document.getElementById("AccessList").innerHTML = "";
				g_attendant = { "DATA1": new Array(), "DATA2": new Array(), "DATA3": new Array(), "DATA5": new Array() };
				
				if(xmlFalg) {
					var xmldom = value;
				} else {
					var xmldom = loadXMLString(value);
				}
				var listview = new ListView();
				listview.SetID("AccessListView");
				listview.SetSelectFlag(false);
				listview.SetMulSelectable(true);
				listview.DataSource(document.getElementById("listviewheader"));
				listview.SetHeightFree(true);
				listview.DataBind("AccessList");
				var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
				
				for (var i = 0; i < xmldomNode.length; i++) {
					g_attendant["DATA1"][i] = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME");
					g_attendant["DATA2"][i] = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2");
					g_attendant["DATA3"][i] = SelectSingleNodeValue(xmldomNode[i], "ACCESSID");
					g_attendant["DATA5"][i] = SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS");
					
					var listTR = listview.AddRow(listview.GetRowCount());
					var listTD = document.createElement("TD");
					listTD.style.paddingBottom = "0px";
					listTD.style.paddingTop = "0px";
					
					if (userLang == "2" && SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2") != "") {
						if (SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS") == "N") {
							var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
						} else {
							var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
						}
					} else {
						if (SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS") == "N") {
							var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
						} else {
							var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
						}
					}
					
					listTD.setAttribute("DATA", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
					listTD.setAttribute("DATA2", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
					listTD.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "ACCESSID"));
					listTD.setAttribute("DATA5", SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS"));
					listTD.appendChild(listTDText);
					listTR.appendChild(listTD);
				}
				
				xmldomNode = null;
				xmldom = null;
				
				var listview2 = new ListView();
				listview2.LoadFromID("AccessListView");
				var InitTr2 = listview2.GetDataRows();
				
				for (var i = 0; i < InitTr2.length; i++) {
					if (InitTr2[i].childNodes[0].getAttribute("data5") == "N") {
						InitTr2[i].childNodes[0].style.color = "red";
					}
				}
			}
			function radioClick(obj, type) {
				if (type == "img") {
					var imgCnt = document.getElementsByName("linktypeOption").length;
					
					for (var i = 0; i < imgCnt; i++) {
						if (document.getElementsByName("linktypeOption")[i].value == obj.id) {
							document.getElementsByName("linktypeOption")[i].checked = true;
							checkValue = document.getElementsByName("linktypeOption")[i].value;
							LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
						}
					}
				} else {
					checkValue = obj.value;
					LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
				}
			}
			function btn_ok(itemId) {
				if (specialChk(document.getElementById("Title1").value) || specialChk(document.getElementById("Title2").value) ||  specialChk(document.getElementById("Title3").value)) {
					alert("<spring:message code='ezResource.special' />");
					return;
				}
				
				if (document.getElementById(mainTitleId).value.trim() == "") {
					document.getElementById(mainTitleId).focus();
					alert("<spring:message code = 'ezPersonal.t1027' />");
					return;
				}
				
				if (document.getElementById("txtURL").value.trim() == "") {
					document.getElementById("txtURL").focus();
					alert("<spring:message code = 'ezPersonal.t87' />");
					return;
				}
				
				if (document.getElementById(subTitle1Id).value.trim() == "") {
					document.getElementById(subTitle1Id).value = document.getElementById(mainTitleId).value;
				}
				
				if (document.getElementById(subTitle2Id).value.trim() == "") {
					document.getElementById(subTitle2Id).value = document.getElementById(mainTitleId).value;
				}
				
				SaveQuickLink(itemId);
			}
			function SaveQuickLink(itemId) {
				var xmlpara = createXmlDom();
				var objNode;
				var objNode2;
				var objNode3;
				objNode = createNodeInsert(xmlpara, objNode, "parameter");
				
				if(mode == "new") {
					createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", guid);
				} else {
					createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", itemId);
				}
				
				createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName", document.getElementById(mainTitleId).value);
				createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName2", document.getElementById(subTitle1Id).value);
				createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName3", document.getElementById(subTitle2Id).value);
				createNodeAndInsertText(xmlpara, objNode, "pLinkType", checkValue);
				createNodeAndInsertText(xmlpara, objNode, "pLinkTypeURL", LinkTypeURL);
				createNodeAndInsertText(xmlpara, objNode, "pMode", mode);
				createNodeAndInsertText(xmlpara, objNode, "pURL", document.getElementById("txtURL").value);
				
				if (document.getElementById("popSize").value == "chk_Full") {
					createNodeAndInsertText(xmlpara, objNode, "pSize", "FULL");
				} else {
					createNodeAndInsertText(xmlpara, objNode, "pSize", document.getElementById("txt_Width").value + ":" + document.getElementById("txt_Height").value);
				}
				
				var listview = new ListView();
				listview.LoadFromID("AccessListView");
				var listviewSelected = listview.GetDataRows();
				
				if (listviewSelected != undefined) {
					for (var nCnt1 = 0; nCnt1 < listviewSelected.length; nCnt1++) {
						objNode2 = createNodeAndAppandNode(xmlpara, objNode, objNode2, "node");
						createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data", listviewSelected[nCnt1].childNodes[0].getAttribute("data"));
						createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data1", listviewSelected[nCnt1].childNodes[0].getAttribute("data1"));
						createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data2", listviewSelected[nCnt1].childNodes[0].getAttribute("data2"));
						createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data5", listviewSelected[nCnt1].childNodes[0].getAttribute("data5"));
						
						if (mode == "new") {
							createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data6", guid);
						} else {
							createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data6", itemId);
						}
						
						createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "value", getNodeText(listviewSelected[nCnt1].childNodes[0]));
						createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "mode", mode);
					}
				}
				
				xmlhttp = null;
				xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPersonal/saveQuickLink.do", false);
				xmlhttp.send(xmlpara);
				
				if (xmlhttp != null && xmlhttp.readyState == 4) {
					if (xmlhttp.statusText == "OK") {
						alert("<spring:message code = 'ezPersonal.s2' />");
						window.location.reload();
					} else {
						alert("<spring:message code = 'ezPersonal.t108' />");
					}
				}
			}
			//상세화면관련 기본정보뿌리기
			function initQuickLink(itemId) {
				$.ajax({
					type : "POST",
					dataType : "json",
					url : "/admin/ezPersonal/getQuickLink.do",
					async : true,
					data : {pQuickLinkID : itemId},
					success : function(result) {
						event_GetQuickLink(result.quickLinkVO);
					}
				});
			}
			function event_GetQuickLink(result) {
				var quickLinkId = result["quickLinkID"];
				
				document.getElementsByClassName("linkDetails")[0].setAttribute("id",
						quickLinkId.substring(1, quickLinkId.indexOf("}")));
				
				document.getElementById("Title1").value = result["quickLinkName"];
				document.getElementById("Title2").value = result["quickLinkName2"];
				document.getElementById("Title3").value = result["quickLinkName3"];
				document.getElementById("txtURL").value = result["url"];
				
				var size = result["size_"];
				if (size == "FULL") {
					document.getElementById("popSize").value = "chk_Full";
					document.getElementById("txt_Width").disabled = true;
					document.getElementById("txt_Height").disabled = true;
				}
				else{
					document.getElementById("popSize").value = "chk_Size";
					document.getElementById("txt_Width").disabled = false;
					document.getElementById("txt_Height").disabled = false;
					
					document.getElementById("txt_Width").value = size.split(':')[0];
					document.getElementById("txt_Height").value = size.split(':')[1];
				}
				
				var type = result["linkType"];
				checkValue = type;
				LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
				
				if (type == "Z") {
					var typeUrl = result["linkTypeUrl"];
					document.getElementById("makeTypeTable").style.display = "";
					document.getElementById("makeTypeImgTD").innerHTML = "";
					
					var _img = document.createElement("IMG");
					_img.src = typeUrl;
					
					_img.id = "ZmakeTypeImg";
					_img.onclick = function () { radioClick(this, 'img') };
					_img.style.cursor = "pointer";
					document.getElementById("makeTypeImgTD").appendChild(_img);
					document.getElementById("Z").checked = true;
					
					checkValue = "Z";
				}
				else {
					var cnt = document.getElementsByName("linktypeOption").length;
					for (var i = 0; i < cnt; i++) {
						if (document.getElementsByName("linktypeOption")[i].value.trim() == type.trim()) {
							document.getElementsByName("linktypeOption")[i].checked = true;
						}
					}
				}
			}
			//상세화면관련 권한정보뿌리기
			function initQuickLinkACL(itemId) {
				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/getQuickLinkACL.do",
					dataType : "text",
					data : {pQuickLinkID : itemId},
					success : function(result) {
						event_GetQuickLinkACL(loadXMLString(result));
					}
				});
			}
			function event_GetQuickLinkACL(result) {
				makePermissionsList(result, true);
			}
			function updateLinkOrder() {
				var linkList = $(".link");
				var linkListCount = linkList.length;
				var linkOrderList = [];
				
				for (var i = 0; i < linkListCount; i++) {
					var linkId = linkList[i].id;
					var order = i + 1;
					linkOrderList.push({"linkOrder": order, "linkId": linkId});
				}
				var data = {
					linkOrderList : linkOrderList
				};
				$.ajax({
					type: "POST",
					url: "/admin/ezPersonal/updateQuickLinkOrder.do",
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					data: JSON.stringify(data),
					success: function(result) {
						//성공
					}
				});
			}
		</script>
		<style type="text/css">
			.link, .linkAdd {cursor: pointer; vertical-align: top; display: inline-block; width: 310px; border: 1px solid #d9d9d9; margin: 20px 30px 0px 0px; height: 200px; background-color: rgb(255, 255, 255);}
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
			.hideDetails {display: none;}
		</style>
	</head>
	<body class="mainbody">
		<h1>Quick Link</h1>

		<!-- 빠른 링크 리스트 영역 -->
		<ul id="mainlist"></ul>
		
		<!-- 빠른 링크 추가 영역 -->
		<xml id="listviewheader" style="display: none;"></xml>
		<iframe name="ifrm" src="about:blank" style="display: none;"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPersonal/typeImageUpload.do?guid=" target="ifrm" style ="display:none">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="true" />
			<input type="hidden" name="boardid" id="boardid" />
			<input type="hidden" name="maxsize" id="maxsize" />
			<input type="hidden" name="mode" id="mode" value="PHOTO"/>
			<input type="hidden" name="cnt" id="cnt" />
			<input type="hidden" name="guid" id="guid"  />
			<input type="hidden" name="mailgubun" id="mailgubun" />
		</form>
	</body>
</html>