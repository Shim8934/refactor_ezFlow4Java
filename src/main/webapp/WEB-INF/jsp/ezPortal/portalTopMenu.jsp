<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>TopMenu</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:choose>
			<c:when test="${mode != 'view'}">
				<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
			</c:when>
			<c:otherwise>
				<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
			</c:otherwise>
		</c:choose>
	</head>
		<c:choose>
			<c:when test="${mode != 'view'}">
				<body class="mainbody">
			</c:when>
			<c:otherwise>
				<body>
			</c:otherwise>
		</c:choose>
		<c:if test="${approvalFlag == 'G' && useHWP == 'YES'}">
			<script type="text/javascript">
				ezIcd_ActiveX("i_icd2");
			</script>
		</c:if>  
		<div id="objectDiv"></div>
		<c:choose>
			<c:when test="${mode != 'view'}">
				<!-- 메뉴 -->
				<h1><spring:message code='ezPortal.t363' /></h1>
					<div id="mainmenu">
						<ul>
							<li><span onClick="save()"><spring:message code='ezPortal.t62' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="layoutmode()"><spring:message code='ezPortal.t322' /></span></li>
							<li><span onClick="editingmode()"><spring:message code='ezPortal.t323' /></span></li>					
							<li><span onClick="preview()"><spring:message code='ezPortal.t63' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="insertpage()"><spring:message code='ezPortal.t325' /></span></li>
							<li><span onClick="removecell('field')"><spring:message code='ezPortal.t326' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="insertcell()"><spring:message code='ezPortal.t327' /></span></li>
							<li><span onClick="removecell()"><spring:message code='ezPortal.t328' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="insertrow()"><spring:message code='ezPortal.t280' /></span></li>
							<li><span onClick="removerow()"><spring:message code='ezPortal.kbm02' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="swaprow('up')"><spring:message code='ezPortal.t331' /></span></li>
							<li><span onClick="swaprow('down')"><spring:message code='ezPortal.t332' /></span></li>
							<li><span onClick="swaprow('left')"><spring:message code='ezPortal.t72' /></span></li>
							<li><span onClick="swaprow('right')"><spring:message code='ezPortal.t74' /></span></li>					
						</ul>
					</div>
					<script type="text/javascript">
						selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
					</script>
					<table width="1020" class="popuplist" >
						<tr>
							<th height="30" style="width:100px"><spring:message code='ezPortal.t359' /></th>
							<td>
				    			<table style="width:100%;">
			            			<tr class="primary">
				            			<th style="width:80px;">${langPrimary}</th>
				            			<td><input type="text" id="txtDisplayName" value="${displayName}" style="width:100%;" maxLength="255"></td>	
			            			</tr>
			            			<tr class="secondary">
				            			<th style="width:80px;">${langSecondary}</th>
				            			<td><input type="text" id="txtDisplayName2" value="${displayName2}" style="width:100%;" maxLength="255"></td>	
			            			</tr>
		            			</table>
							</td>
						</tr>
					</table>
					<br>
					<table style="width:1020px; background-color:#F5f5f5;"class="box">
						<tr>
			  				<td style="padding-left:10px; height:30px;">
			  					<spring:message code='ezPortal.t334' />
			  					<input type="text" id="txtWidth" name="txtWidth" style="WIDTH:50px" maxLength="10">
								px * 
								<spring:message code='ezPortal.t335' />
								<input type="text" id="txtHeight" name="txtHeight" style="WIDTH:50px" maxLength="10">
								 px 
								<a class="imgbtn">
									<span onClick="resizeTable()">
										<spring:message code='ezPortal.t336' />
									</span>
								</a>
			  				</td>
                			<td style="width:60px;"><spring:message code='ezPortal.t990022' />:</td>
                			<td style="width:135px;">
                    			<select id="Themeinfo" style="width:130px; height: 23px;">
			                        ${pThemeSelectObject}
                    			</select>
                			</td>
						</tr>
					</table>
				<div style="WIDTH:1020px">
					${strHTML}
				</div>
			</c:when>
			<c:otherwise>
				${strHTML}
			</c:otherwise>
		</c:choose>
		<!-- 표준모듈 (2007.03.15) 수정: .NET Framework 2.0에서는 RegisterStartupScript 메서드 지원하지 않음. -->
		<div id="objectProgressDiv"></div>
		<c:if test="${approvalFlag == 'G' && useHWP == 'YES'}">
			<iframe id=if_Progress style="display:none" src="/ezPortal/progress.do"></iframe>
		</c:if>
		<iframe id=ifmpopup style="display:none" src=""></iframe>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>
		
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>			
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>

		<script type="text/javascript">
			var skinnum = "${skinNum}";
			var selectedCell = "";
			var selectedSubCell = "";
			var previousSubCell = null;
			var previousCell = null;
			var count = 1000;
			var pageid = '<c:out value="${pageID}"/>';
			var parentpageid = "<c:out value='${parentPageID}'/>";
			var mode = '<c:out value="${mode}"/>';
			var editmode = "${editMode}";
			var viewmode = "<c:out value='${viewMode}'/>";
			var bInherit = false;
			var pressCount = 0;
			var selObjClass = "";
			var SkinExist = "${skinExist}";
			var pNoneActiveX = "${noneActiveX}";
			var useHWP = "${useHWP}";
			var lastLoginYN = "${lastLoginYN}";
			
			document.onselectstart = function () { return false; };
			
			var windowOnloadFunc = function() {
				
				/* 2018-12-27 홍승비 - 공지사항 팝업 동작 위치 수정 */
				${script1}
				
			    if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
			    
				if (editmode == "new_inherit") bInherit = true;
				
				if (mode == "edit") AttachEvents(main_table);
				
				// 검색UI 설정
				try {
					if (typeof(searchTD) == "object") {
						searchTD.parentNode.parentNode.parentNode.style.width = "100%";
						searchTD.innerHTML = "<table border=\"0\" height=\"41\" cellspacing=\"0\" cellpadding=\"0\"><tr>" +
											"<td width=\"44\"   height=\"40\" valign=\"middle\"><img src=\"/images/main/totalsearch.gif\" align=\"absmiddle\"></td>" +
											"<td width=\"140\"   height=\"40\" valign=\"middle\">   <input name=\"txtSearch\" type=\"text\"  class=\"search\" onkeydown=entercheck()></td>" +									
											"<td width=\"31\"  height=\"40\" valign=\"middle\"><img src=\"/images/top/bt_search.gif\" width=\"31\" height=\"21\" style='cursor:pointer' onclick=Search()></td>" +
									     	"</tr></table>";
					}
				}
				catch (e) {}
				
				// 수정(2007.03.14) : 사용자 정보 영역 UI 설정
				try {
					if (typeof(userInfoTD) == "object") {
						userInfoTD.parentNode.parentNode.parentNode.style.marginTop = "10px";
						userInfoTD.innerHTML = "<iframe width=300 height=31 border=0 src='/myoffice/ezPortal/filter/UserInfoPortlet.aspx' frameborder=0 scrolling=no></iframe>";
			        }
				}
				catch (e) {}
		
				// 보기모드에서 미리보기가 아닌 경우 실행
				if (mode == "view" && viewmode != "preview") {
					//브라우저 정보 가져오기
					var userAgent = window.navigator.userAgent;
					
				    if ((/msie/i.test(userAgent)) || (/rv:11.0/i.test(userAgent))) {
				    	if (useHWP == "YES") {
				    		//한글기안기 사용일때는 ie9,10,11 전부 activeX 설치
							if (userAgent.indexOf("Trident/5.0") > 0 || userAgent.indexOf("Trident/6.0") > 0 || userAgent.indexOf("Trident/7.0") > 0) {
						    	 GetObject();
							}
				    	}
				    } 
				}
			
				if(lastLoginYN == "YES"){
					$('.utmenu ul li:first-child').css('padding', '5px 15px');
					$('.utmenu ul li:first-child').css('font-size', '12px');
					$('.utmenu ul li:first-child').css('font-weight', 'bold');
					$('.utmenu ul li:first-child').css('cursor:default', 'cursor:default');
					$('.utmenu ul li:first-child').css('color', '#000');
				}
				
				//2019.02.28 유틸메뉴 이미지 마우스 오버시, 이미지 변경되도록 이벤트 세틍
				utilMenuImageSetting();
			}
			
			
			function utilMenuImageSetting() {
				var utilMenu = document.getElementsByClassName("utmenu")[0].querySelectorAll("img");
				var utilMenuCount = utilMenu.length;

				for (var i = 0; i < utilMenuCount; i++) {
					var item = utilMenu[i];
					
					if (item.id != null && item.id != "") {
						
						document.getElementById(item.id).addEventListener("mouseover", function() {
							var originalImg = this.getAttribute("data1");
							var overImg = this.getAttribute("data2");
							this.src = overImg;
						});
						
						document.getElementById(item.id).addEventListener("mouseout", function() {
							var originalImg = this.getAttribute("data1");
							var overImg = this.getAttribute("data2");
							this.src = originalImg;
						});
					}
				}
			}
			
			function ezNotieSetting() {
	        }
			
			function GetObject() {
				i_icd2.SetDocumentDisp(window.document);
                i_icd2.xmlURL = "http://" + document.location.hostname + ":" + location.port + "/ezPortal/componentListTransfer.do";
                i_icd2.CheckVersion();
                var nCount = i_icd2.nNeedDownload;

                if (nCount) {
                    if_Progress.StartOn();
                } else {
                    finish_download();
                }
			}
	
			function finish_download() {
				OfficeBugPatch();	
			}
	
			function OfficeBugPatch() {
			}
			
			var bLogOutNOTICE = false;
			
			function event_update_connectinfo() {
				if (xmlHTTP.readyState != 4)
					return;
				
				if (xmlHTTP.status == 200 && xmlHTTP.responseText == "LOGOUT") {
					blogout = true;
					alert("<spring:message code='ezPortal.t346' />");
					window.top.location.href = "/user/login/actionLogout.do";
				}
			}
			
			function OpenInformationUI(pInformationContent) {
				var parameter = pInformationContent;
				var url = "/myoffice/ezApproval/ezAPROPINION.htm";
				var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
				var RtnVal = window.showModalDialog(url,parameter,feature);
				return RtnVal;
			}
	
			function load() {
				var ret = window.showModalDialog("TopMenu_search.aspx?mode=load");
				
				if (typeof(ret) == "undefined") return;
				
				document.location.href = "/ezPortal/topMenu.do?pageID=" + ret[0];
			}
	
			function inherit() {
				var ret = window.showModalDialog("TopMenu_search.aspx?mode=inherit");
				
				if (typeof(ret) == "undefined") return;
				
				document.location.href = "/ezPortal/topMenu.do?parentPageID=" + ret[0];
			}
	
			function savesub(pObject, pPageID, pParentPageID, pDisplayName, pDisplayName2) {
				var strXML = "<DATA>";
				strXML += "<DISPLAYNAME>" + pDisplayName + "</DISPLAYNAME>";
				strXML += "<DISPLAYNAME2>" + pDisplayName2 + "</DISPLAYNAME2>";
				strXML += "<THEMEINFO>" + ReplaceValidString(document.getElementById("Themeinfo").value) + "</THEMEINFO>";
				strXML += "<WIDTH>" + pObject.getAttribute("width").toString().replace("px", "").replace("100%", "-1") + "</WIDTH>";
				strXML += "<HEIGHT>" + pObject.getAttribute("height").toString().replace("px", "").replace("100%", "-1") + "</HEIGHT>";
				strXML += "<PARENTPAGEID>" + pParentPageID + "</PARENTPAGEID>";
				
				// 대상테이블의 최상위td count
				for (var i=0; i<pObject.children.item(0).children.item(0).children.length; i++) {
					// 최상위td
					if (pObject.children.item(0).children.item(0).children.item(i).id == "") continue;
					if (pObject.children.item(0).children.item(0).children.item(i).id.substr(0, 2) == "td") {
						strXML += "<CELL>";
						var td_item = pObject.children.item(0).children.item(0).children.item(i);
						strXML += "<WIDTH>" + td_item.style.width.toString().replace("px", "") + "</WIDTH>";
						
						// 해당td내의 tr의 카운트 (TABLE/TBODY/TR)
						for (var j=0; j<td_item.children.item(0).children.item(0).children.length; j++) {
							// 해당 tr내의 td
							var tdsub_item = td_item.children.item(0).children.item(0).children.item(j).children.item(0);
				
							if (tdsub_item.id == "") continue;
							
							// td안에 컨텐츠가 존재하는 경우
							if (tdsub_item.children.length > 0 && tdsub_item.children.item(0).id.toLowerCase().substr(0, 4) != "main") {
								strXML += "<ROW>";
								strXML += "<TYPE>0</TYPE>";
								strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
								strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
								strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
								strXML += "<DISPLAYNAME>" + ReplaceValidString(tdsub_item.firstChild.innerHTML) + "</DISPLAYNAME>";
								strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
								strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
								strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
								strXML += "<ROOTPAGEID>" + pageid + "</ROOTPAGEID>";
								strXML += "</ROW>";
							}
							// td안에 테이블이 존재하는 경우
							else {
								strXML += "<ROW>";
								strXML += "<TYPE>1</TYPE>";
								strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
								strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
								strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
								strXML += "<DISPLAYNAME>" + tdsub_item.getAttribute("pageuid") + "</DISPLAYNAME>";
								strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
								strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
								strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
								strXML += "<ROOTPAGEID>" + pageid + "</ROOTPAGEID>";
								strXML += "</ROW>";
								
								// 하위테이블의 정보를 저장
								savesub(tdsub_item.children.item(0), tdsub_item.getAttribute("uid"), "top", tdsub_item.getAttribute("uid"), tdsub_item.getAttribute("uid"));
							}
						}
						strXML += "</CELL>";
					}
				}
				strXML += "</DATA>";
	
				var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/portalSaveTopMenu.do?pageID=" + pPageID + "&parentPageID=" + pParentPageID, false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send(strXML);
				xmlhttp = null;
			}
	
			function save() {
				if (txtDisplayName.value == "") {				
					alert("<spring:message code='ezPortal.t361' />");
					txtDisplayName.focus();
					return;		
				}
				
				if (txtDisplayName2.value == "") {				
					txtDisplayName2.value = txtDisplayName.value;
				}
				
				if (specialChk(document.getElementById("txtDisplayName").value) || specialChk(document.getElementById("txtDisplayName2").value)) {
			    	alert("<spring:message code='ezResource.special' />");
			    	return;
			    }
				
				savesub(main_table, pageid, parentpageid, txtDisplayName.value, txtDisplayName2.value);
				
				// 스킨정보 생성
				if (SkinExist == "NO")
					SaveSkin(pageid);
				
				alert("<spring:message code='ezPortal.t84' />");
				document.location.href = "/ezPortal/topMenu.do?pageID=" + pageid;
			}
			
			function SaveSkin(pPageID) {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/portalSaveSkin.do?pageID=" + pPageID, false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send();
				xmlhttp = null;
			}
			
			function CheckDuplicate(pUID) {
				for (var i=0; i<main_table.getElementsByTagName("td").length; i++) {
				    if (main_table.getElementsByTagName("td").item(i).getAttribute("uid") == pUID) return true;
				}
				return false;
			}
			
			function OpenEditWindow(pUID) {
			    if (pUID == "201") window.open("/admin/ezPortal/logoEdit.do?pageID=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
			    if (pUID == "202") window.open("/admin/ezPortal/utilMenuAreaEdit.do?pageID=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
			    if (pUID == "203") window.open("/admin/ezPortal/mainMenuAreaEdit.do?pageID=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
			    if (pUID == "205") window.open("admin/edit/SearchArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
			}
			
			function dblclicksubcell() {
				var obj = null;
				if (event.srcElement.id == "") obj = event.srcElement.parentElement;
				else obj = event.srcElement;
				
				if (typeof(obj.uid) != "undefined" && obj.uid != "") {
					event.cancelBubble = true;	
					OpenEditWindow(obj.uid);
				}
			}
	
			function AttachEvents(pObject, pPageID) {
				var prevpageid = "";
				var count = 0;
				
				for (var i = 0; i < pObject.getElementsByTagName("td").length; i++) {
	
				    if (pObject.getElementsByTagName("td").item(i).id == "") continue;
	
				    if (pObject.getElementsByTagName("td").item(i).id.indexOf("sub") > -1) {
				        if (prevpageid != pObject.getElementsByTagName("td").item(i).getAttribute("pageuid")) count++;
				        prevpageid = pObject.getElementsByTagName("td").item(i).getAttribute("pageuid");
	
				        pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectsubcell(event)");
				        pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
				        pObject.getElementsByTagName("td").item(i).setAttribute("onkeyup", "cellkeyup()");
						//pObject.getElementsByTagName("td").item(i).onclick = selectsubcell;
						//pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
						//pObject.getElementsByTagName("td").item(i).onkeyup = cellkeyup;
						pObject.getElementsByTagName("td").item(i).style.cursor = "pointer";
						
					} else {
				        pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectcell(event)");
				        pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
				        pObject.getElementsByTagName("td").item(i).setAttribute("onkeyup", "cellkeyup()");
				        //pObject.getElementsByTagName("td").item(i).onclick = selectcell;
				        //pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
				        //pObject.getElementsByTagName("td").item(i).onkeyup = cellkeyup;
					}
				}
				
				if (count > 1) bInherit = false;
			}
	
			// 영역 선택시 처리
			function selectcell(e) {
			    var Event = e ? e : window.event;
			    var Element = Event.target ? Event.target : Event.srcElement;
			    
			    if (Element.id == "") return;
			    
			    if (Element.id.indexOf("sub") > -1) return;
			    
			    selectedCell = Element.id;
			    
			    if (previousCell != null) previousCell.style.backgroundColor = "white";
			    
			    previousCell = Element.children.item(0).children.item(0).children.item(0).children.item(0);
			    previousCell.style.backgroundColor = "lightblue";
				
				// 현재 선택된 cell
				var cell = eval(selectedCell);
				
				// 선택된 cell의 table
				var tblObject = eval(GetMainTable(eval(selectedCell)));
				
				if (typeof(tblObject) == "undefined")
					return;
				
				var maxHeight = 0;
				var compareHeight = 0;
				
				if (tblObject.getAttribute("height") != "")
				    maxHeight = parseInt(tblObject.getAttribute("height").replace("px", ""), 10);
				
				// 해당 table의 height를 구한다.
				for (var i = 0; i < tblObject.getElementsByTagName("tr").length; i++) {
					try {
					    compareHeight = tblObject.getElementsByTagName("tr").item(i).style.height.replace("px", "");
						
						if (compareHeight != "") {
							if (parseInt(compareHeight, 10) > maxHeight)
								maxHeight = parseInt(compareHeight, 10);
						}
					
					} catch (e) {}
				}
				
				document.getElementById("txtWidth").value = cell.style.width.replace("px", "");
				document.getElementById("txtHeight").value = maxHeight;
	
				
				document.getElementById("txtWidth").disabled = false;
				
				if (document.getElementById("txtWidth").value == "") {
				    document.getElementById("txtWidth").value = "*";
				    document.getElementById("txtWidth").disabled = true;
				}
				
				// 선택한 개체의 종류
				selObjClass = "TABLE";
			}
	
			function selectcellTitle(e) {
			    var Event = e ? e : window.event;
			    var Element = Event.target ? Event.target : Event.srcElement;
			    selectcell2(Element.parentElement.parentElement.parentElement.parentElement);
				//event.srcElement.parentElement.parentElement.parentElement.parentElement.click();
				//event.cancalBubble = true;
				//event.returnValue = false;
			}
			
			function selectcell2(obj) {
			    if (obj.getAttribute("id") == "") return;
			    
			    if (obj.getAttribute("id").indexOf("sub") > -1) return;
			    
			    selectedCell = obj.getAttribute("id");
			    
			    if (previousCell != null) previousCell.style.backgroundColor = "white";
			    
			    previousCell = obj.children.item(0).children.item(0).children.item(0).children.item(0);
			    previousCell.style.backgroundColor = "lightblue";
	
			    // 현재 선택된 cell
			    var cell = eval(selectedCell);
	
			    // 선택된 cell의 table
			    var tblObject = eval(GetMainTable(eval(selectedCell)));
	
			    if (typeof (tblObject) == "undefined")
			        return;
	
			    var maxHeight = 0;
			    var compareHeight = 0;
	
			    if (tblObject.getAttribute("height") != "")
			        maxHeight = parseInt(tblObject.getAttribute("height").replace("px", ""), 10);
	
			    // 해당 table의 height를 구한다.
			    for (var i = 0; i < tblObject.getElementsByTagName("tr").length; i++) {
			        try {
			            compareHeight = tblObject.getElementsByTagName("tr").item(i).style.height.replace("px", "");
	
			            if (compareHeight != "") {
			                if (parseInt(compareHeight, 10) > maxHeight)
			                    maxHeight = parseInt(compareHeight, 10);
			            }
	
			        } catch (e) { }
			    }
	
			    document.getElementById("txtWidth").value = cell.style.width.replace("px", "");
			    document.getElementById("txtHeight").value = maxHeight;
	
			    document.getElementById("txtWidth").disabled = false;
			    
			    if (document.getElementById("txtWidth").value == "") {
			        document.getElementById("txtWidth").value = "*";
			        document.getElementById("txtWidth").disabled = true;
			    }
	
			    // 선택한 개체의 종류
			    selObjClass = "TABLE";
			}
	
			// 컨텐츠 선택시 처리
			function selectsubcell(e) {
			    var Event = e ? e : window.event;
			    var eventItem = Event.target ? Event.target : Event.srcElement;
			    
			    if (eventItem.getAttribute("id") == null) {
					eventItem = eventItem.parentElement;
				}
			    
			    selectedSubCell = eventItem.getAttribute("id");
				
				try {
					if (previousSubCell != null) previousSubCell.parentElement.style.backgroundColor = "white";
				} catch(e) {}
				
				eventItem.parentElement.style.backgroundColor = "#FFDEB5";
				previousSubCell = eventItem;
				
				var cell;
				var curHeight = 0;
				
				if (selectedSubCell != null) {
				    cell = eval(selectedSubCell);
				    curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));
				} else {
				    cell = eval(previousSubCell);
				    curHeight = parseInt(cell.parentElement.children[1].style.height.replace("px", ""));
				}
				
				document.getElementById("txtHeight").value = curHeight;
				// 컨텐츠 선택시는 너비 입력필드를 disabled
				document.getElementById("txtWidth").value = "*";
				document.getElementById("txtWidth").disabled = true;
				// 선택한 개체의 종류
				selObjClass = "CONTENTS";
			}
	
			function cellkeyup() {
				pressCount = 0;
			}
	
			function cellkeydown(e) {
				if (!e.ctrlKey) {
					switch(e.keyCode) {
						case 37:
							swaprow("left");
							break;
						case 38:
							swaprow("up");
							break;
						case 39:
							swaprow("right");
							break;
						case 40:
							swaprow("down");
							break;
						default:
							break;
					}
				} else {
					switch(e.keyCode) {
						case 37:
							resizecell("left");
							break;
						case 38:
							resizerow("up");
							break;
						case 39:
							resizecell("right");
							break;
						case 40:
							resizerow("down");
							break;
						default:
							break;
					}
				}
			}
	
			function GetPageID(pCell) {
			    if (typeof (pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid")) != "undefined") return pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid");
			    else return pageid;
			}
			
			var menuitem_search_dialogArguments = new Array();
			
			function insertrow() {
				if (selectedCell == "") {
					alert("<spring:message code='ezPortal.kbm01' />");
					return;
				}
				
				if (eval(selectedCell).children.item(0).children.item(0).children.length > 9) {
					alert("<spring:message code='ezPortal.t348' />");
					return;
				}
				
			    if (CrossYN()) {
			        menuitem_search_dialogArguments[1] = insertrow_Complete;
			        var OpenWin = window.open("/ezPortal/menuItemSearch.do", "MenuItem_search", GetOpenWindowfeature(290, 355));
			        try { OpenWin.focus(); } catch (e) { }
			    } else {
			        var ret = window.showModalDialog("/ezPortal/menuItemSearch.do", "", "dialogHeight:355px; dialogWidth:290px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(290, 355));
	
			        if (typeof (ret) == "undefined") return;
	
			        if (CheckDuplicate(ret[0]) && ret[0] != "206") {
			            alert("<spring:message code='ezPortal.t349' />");
			            return;
			        }
	
			        if (ret[0] == "206") {
			            ret[0] = GetGUID();
			            ret[1] = "";
			        }
	
			        /*var newrow = eval(selectedCell).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
			        newrow.style.width = "100%";
			        newrow.style.height = "100px";
	
			        var subtdGetid = "subtd" + GetGUID().substr(0, 4);
			        var strInnerHTML = "<td id=\"" + subtdGetid + "\"uid=\"" + ret[0] + "\" style=\"width:100%\"  ownerpageuid='" + pageid + "' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\"><b> " + ret[1] + "</b></td>";		        
	                newrow.innerHTML = strInnerHTML;
			        var pageuid = "";
			        if (GetPageID(document.getElementById(subtdGetid)) == null)
			            pageuid = pageid;
			        else
			            pageuid = GetPageID(document.getElementById(subtdGetid));
	
			        document.getElementById(subtdGetid).setAttribute("pageuid", pageuid);
			        document.getElementById(subtdGetid).focus(); */
	
			        var newrow = eval(selectedCell).children.item(0).insertRow();
			        var subtdGetid = "subtd" + GetGUID().substr(0, 4);
			        newrow.style.width = "100%";
			        newrow.style.height = "100px";
			        var newcell = newrow.insertCell();
			        newcell.id = subtdGetid;
			        newcell.uid = ret[0];
	
			        if (GetPageID(document.getElementById(subtdGetid)) == null) {
			            pageuid = pageid;
			        } else
			            pageuid = GetPageID(document.getElementById(subtdGetid));
	
			        newcell.pageuid = pageuid;
			        newcell.ownerpageuid = pageid;
			        newcell.canremove = 1;
			        newcell.canresize = 1;
			        newcell.canreplace = 1;
	
			        newcell.setAttribute("id", subtdGetid);
			        newcell.setAttribute("uid", ret[0]);
			        newcell.setAttribute("pageuid", pageuid);
			        newcell.setAttribute("ownerpageuid", pageid);
			        newcell.setAttribute("canremove", 1);
			        newcell.setAttribute("canresize", 1);
			        newcell.setAttribute("canreplace", 1);
	
			        newcell.style.width = "100%";
			        newcell.align = "center";
			        newcell.innerHTML = "<b>" + ret[1] + "</b>";
			        newcell.onclick = selectsubcell;
			        //newcell.ondblclick = dblclicknotice;
			        //newcell.onkeydown = cellkeydown;
			        selectedSubCell = "";
			        newcell.focus();
			    }
			}
			
		    function insertrow_Complete(ret) {
		        if (typeof (ret) == "undefined") return;

		        if (CheckDuplicate(ret[0]) && ret[0] != "206") {
		            alert("<spring:message code='ezPortal.t349' />");
		            return;
		        }

                if (ret[0] == "206") {
                    ret[0] = GetGUID();
                    ret[1] = "";
                }

                var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
                newrow.style.width = "100%";
                newrow.style.height = "100px";

                var subtdGetid = "subtd" + GetGUID().substr(0, 4);
                var strInnerHTML = "<td id=\"" + subtdGetid + "\"uid=\"" + ret[0] + "\" style=\"width:100%\"  ownerpageuid='" + pageid + "' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\"><b> " + ret[1] + "</b></td>";
                newrow.innerHTML = strInnerHTML;

                var pageuid = "";
                if (GetPageID(document.getElementById(subtdGetid)) == null)
                    pageuid = pageid;
                else
                    pageuid = GetPageID(document.getElementById(subtdGetid));

                document.getElementById(subtdGetid).setAttribute("pageuid", pageuid);
                document.getElementById(subtdGetid).focus();

		    }
	
			function insertcell() {
				if (bInherit) {
					alert("<spring:message code='ezPortal.t294' />");
					return;
				}
				
				if (selectedCell == "") {
					alert("<spring:message code='ezPortal.t295' />");
					return;
				}
				
				var newcell = document.createElement("td");
				var row = eval(selectedCell).parentElement;
				row.insertBefore(newcell, eval(selectedCell));
				
				newcell.style.width = "100px";
				newcell.vAlign = "top";
				newcell.innerHTML = "<table border=1 cellpadding=0 cellspacing=0 width=100% valign=top><tbody><TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>100px</td></TR></tbody></table>";
				newcell.id = "td" + GetID();
				newcell.setAttribute("onclick", "selectcell(event)");
				newcell.setAttribute("onkeydown", "cellkeydown(event)");
				//newcell.onclick = selectcell;
				//newcell.onkeydown = cellkeydown;
				selectedSubCell = "";
			}
	
			function removecell(type) {
				if (bInherit) {
					alert("<spring:message code='ezPortal.t350' />");
					return;
				}
	
				if (selectedCell == "") {
					if (type == 'field') {
						alert("<spring:message code='ezPortal.jjs12' />");	
					} else {
						alert("<spring:message code='ezPortal.t297' />");	
					}
					return;
				}
				
				if (selectedCell == "td0") return;
				
				if (selectedCell.substr(0,3) == "td0") {
					if (confirm("<spring:message code='ezPortal.t298' />")) {
						eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.removeChild(eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement);
						selectedCell = "";
						selectedSubCell = "";
					}
					return;
				}
				
				var row = eval(selectedCell).parentElement;
				
				for (var i=0; i<row.children.length; i++) {
					if (row.children.item(i).id == selectedCell) {
						row.removeChild(row.children.item(i));
						break;
					}
				}
				selectedCell = "";
				selectedSubCell = "";
			}
	
			function removerow() {
				if (selectedSubCell == "") {	
					alert("<spring:message code='ezPortal.jjs12' />");
					return;
				}
				
				var cell = eval(selectedSubCell);
				
				if (cell.getAttribute("canremove") != 1) {
					alert("<spring:message code='ezPortal.t352' />");
					return;
				}
				
			    var parentPageid = GetPageID(cell);
			    
			    if (parentPageid == null)
			        parentPageid = pageid;
			    
			    if (cell.getAttribute("pageuid") != parentPageid) {
					alert("<spring:message code='ezPortal.t353' />");
					return;
				}
				
				cell.parentElement.parentElement.removeChild(cell.parentElement);
				selectedSubCell = "";
				selectedCell = "";
			}
			
			//크로스용 함수 추가
			function swapNodes(item1, item2) {
			    var itemtmp = item1.cloneNode(1);
			    var parent = item1.parentNode;
			    
			    item2 = parent.replaceChild(itemtmp, item2);
			    parent.replaceChild(item2, item1);
			    parent.replaceChild(item1, itemtmp);
			    itemtmp = null;
			}
			
			function getNextSibling(node) {
	
			    while (node.nodeType != 1) {
			        node = node.nextSibling;
			    }
	
			    return node;
			}
			
			function getPreviousSibling(node) {
	
			    while (node.nodeType != 1) {
			        node = node.previousSibling;
			    }
	
			    return node;
			}
			
			//크로스용 함수 추가
			function swaprow(pDirection) {
				if (selectedSubCell == "") {	
					alert("<spring:message code='ezPortal.t354' />");
					return;
				}
	
				var cell = eval(selectedSubCell);
	
				if (cell.getAttribute("canreplace") != 1) {
					alert("<spring:message code='ezPortal.t355' />");
					return;
				}
				
			    var parentPageid = GetPageID(cell);
			    
			    if (parentPageid == null)
			        parentPageid = pageid;
			    
			    if (cell.getAttribute("pageuid") != parentPageid) {
					alert("<spring:message code='ezPortal.t356' />");
					return;
				}
	
				var obj = null;
				
				if (pDirection == "up") {
				    if (getPreviousSibling(cell.parentElement.previousSibling) == null || getPreviousSibling(cell.parentElement.previousSibling).children.item(0).id == "") {
						if (cell.pageuid == pageid) return;
						try {
							obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("beforeBegin", cell.parentElement);
	//						obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
						} catch(e) { return; }
					} else {
				        if (getPreviousSibling(cell.parentElement.previousSibling).outerHTML.toLowerCase().indexOf("table") > -1) {
							try {
							    obj = getPreviousSibling(cell.parentElement.previousSibling).children.item(0).children.item(0).children.item(0).children.item(0).lastChild.children.item(0).children.item(0).insertAdjacentElement("beforeEnd", cell.parentElement);
	//						    obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
							} catch(e) { return; }
						} else {
				            //cell.parentElement.swapNode(cell.parentElement.previousSibling);
				            swapNodes(cell.parentElement, getPreviousSibling(cell.parentElement.previousSibling));
						}
					}
				} else if (pDirection == "down") {
				    if (getNextSibling(cell.parentElement.nextSibling) == null || getNextSibling(cell.parentElement.nextSibling).children.item(0).id == "") {
						if (cell.pageuid == pageid) return;
						try {
							obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("afterEnd", cell.parentElement);
							obj.children.item(0).pageuid = GetPageID(obj.children.item(0));
						} catch(e) { return; }
					} else {
				        if (getNextSibling(cell.parentElement.nextSibling).outerHTML.toLowerCase().indexOf("table") > -1) {
							try {
							    obj = getNextSibling(cell.parentElement.nextSibling).children.item(0).children.item(0).children.item(0).children.item(0).firstChild.children.item(0).children.item(0).firstChild.insertAdjacentElement("afterEnd", cell.parentElement);
	//						    obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
							} catch(e) { return; }
						} else {
				            //cell.parentElement.swapNode(cell.parentElement.nextSibling);
				            //cell.parentElement.swapNode(cell.parentElement.nextSibling);
				            swapNodes(cell.parentElement, getNextSibling(cell.parentElement.nextSibling));
						}
					}
				} else if (pDirection == "left") {
				    if (getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling) == null) return;
					
				    if (getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling).children.item(0).children.item(0).children.length > 9) {
						alert("<spring:message code='ezPortal.t348' />");
						return;
					}
				    
				    getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling).children.item(0).children.item(0).appendChild(cell.parentElement);
				} else if (pDirection == "right") {
				    if (getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling) == null) return;
				
				    if (getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling).children.item(0).children.item(0).children.length > 9) {
						alert("<spring:message code='ezPortal.t348' />");
						return;
					}
				    
				    getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling).children.item(0).children.item(0).appendChild(cell.parentElement);
				}
				cell.focus();
			}
	
			function resizecell(pDirection) {
				if (selectedCell == "") {	
					alert("<spring:message code='ezPortal.t354' />");
					return;
				}
				
				if (bInherit) {
					alert("<spring:message code='ezPortal.t305' />");
					return;
				}
	
				var cell = eval(selectedCell);
				
				var curWidth = parseInt(cell.style.width.replace("px", ""));
	
				var increase = 1;
	
				if (pDirection == "right") {
					curWidth += increase;
					try {
						cell.style.width = curWidth.toString();
						cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
					} catch(e) {}
				}  else if (pDirection == "left") {
					curWidth -= increase;
					try {
						cell.style.width = curWidth.toString();
						cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
					} catch(e) {}
				}
	
				event.cancelBubble = true;
			}
	
			function resizerow(pDirection) {
				if (selectedSubCell == "") {	
					alert("<spring:message code='ezPortal.t306' />");
					return;
				}
	
				var cell = eval(selectedSubCell);
				
				if (cell.getAttribute("canresize") != 1) {
					alert("<spring:message code='ezPortal.t357' />");
					return;
				}
				
			    if (cell.getAttribute("pageuid") != GetPageID(cell)) {
					alert("<spring:message code='ezPortal.t358' />");
					return;
				}
				
				var curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));
	
				var increase = 1;
	
				if (pDirection == "up") {
					curHeight += increase;
					try {
						cell.parentElement.style.height = curHeight.toString();
					} catch(e) {}
				} else if (pDirection == "down") {
					curHeight -= increase;
					try {
						cell.parentElement.style.height = curHeight.toString();
					} catch(e) {}
				}
				//event.cancelBubble = true;
			}
	
			function GetMainTable(pCell) {
				try {
					return pCell.parentElement.parentElement.parentElement.id;
				} catch (e) {}
			}
			
			function resizepage(pDirection) {
				if (selectedCell == "") {
					alert("<spring:message code='ezPortal.t311' />");
					return;
				}
				
				var tblObject = eval(GetMainTable(eval(selectedCell)));
				
				if (bInherit) {
					alert("<spring:message code='ezPortal.t305' />");
					return;
				}
	
				if (tblObject.width == "100%" && (pDirection == "left" || pDirection == "right")) {
					alert("<spring:message code='ezPortal.t309' />");
					return;
				}
				
				if (tblObject.height == "100%" && (pDirection == "up" || pDirection == "down")) {
					alert("<spring:message code='ezPortal.t310' />");
					return;
				}
	
				try {
					if (pDirection == "left") {
						tblObject.width = parseInt(tblObject.width.toString().replace("px", "")) - 10;
					}
					if (pDirection == "right") {
						tblObject.width = parseInt(tblObject.width.toString().replace("px", "")) + 10;
					}
					if (pDirection == "down") {
						tblObject.height = parseInt(tblObject.height.toString().replace("px", "")) + 10;
						tblObject.parentElement.parentElement.style.height = tblObject.height;
					}
					if (pDirection == "up") {
						tblObject.height = parseInt(tblObject.height.toString().replace("px", "")) - 10;
						tblObject.parentElement.parentElement.style.height = tblObject.height;
					}
				} catch(e) {}
			}
			
			function S4() {
			    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
			}
			
			function GetGUID() {
			    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
			}
	
			function GetID() {
				return count++;
			}
	
			function preview() {
				window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + pageid);
			}
	
			function OpenMaxURL(pURL) {
				if (pURL == "") return;	
				location.href = pURL;
			}
	
			function insertpage() {
				if (selectedCell == "") {
					alert("<spring:message code='ezPortal.t312' />");
					return;
				}
				
				if (eval(selectedCell).children.item(0).children.item(0).children.length > 9) {
					alert("<spring:message code='ezPortal.t348' />");
					return;
				}
				
				var strHTML = "<table id='main_table_" + GetGUID().substr(0,4) + "' border=1 cellpadding=0 cellspacing=0 width=100% height=110px style='table-layout:fixed;'>";
				strHTML += "<tr id='main_row'>";
				strHTML += "<TD id='td0" + GetGUID().substr(0,3) + "' vAlign=top><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>";
				strHTML += "<TBODY><TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR></tbody>";
				strHTML += "</table></td></tr></table>";
	
				var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
				//var newrow = eval(selectedCell).children.item(0).insertRow();
				newrow.style.width = "100%";
				newrow.style.height = "100px";
	
				var subGetId = "subtd" + GetID();
				//var strInnerHTML = "<td id=\"" + subGetId + "\"uid=\"" + GetGUID() + "\" style=\"width:100%\" pageuid='" + GetGUID() + "' ownerpageuid='" + pageid + "' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\">" + strHTML + "</td>";
				var TD = document.createElement("TD");
				TD.setAttribute("id", subGetId);
				TD.setAttribute("uid", GetGUID());
				TD.setAttribute("style", "width:100%");
				TD.setAttribute("pageuid", GetGUID());
				TD.setAttribute("ownerpageuid", pageid);
				TD.setAttribute("align", "center");
				TD.setAttribute("canremove", "1");
				TD.setAttribute("canresize", "1");
				TD.setAttribute("canreplace", "1");
				TD.setAttribute("onclick", "selectsubcell(event)");
				TD.setAttribute("ondblclick", "dblclicknotice()");
				TD.setAttribute("onkeydown", "cellkeydown(event)");			
				TD.innerHTML = strHTML;
	
				newrow.appendChild(TD);
				//newrow.innerHTML = strInnerHTML;
	
				//var newcell = newrow.insertCell();
				//newcell.id = "subtd" + GetID();
				//newcell.uid = GetGUID();
				//newcell.pageuid = GetGUID();
				//newcell.canremove = 1;
				//newcell.canresize = 1;
				//newcell.canreplace = 1;
				//newcell.style.width = "100%";
				//newcell.align = "center";	
				//newcell.innerHTML = strHTML;
				//selectedSubCell = "";
				//newcell.focus();
			    //AttachEvents(newcell);
				document.getElementById(subGetId).focus();
				AttachEvents(document.getElementById(subGetId))
			}
	
			function newpage() {
				location.href = "/ezPortal/topMenu.do?mode=new";
			}
	
			function subMenuClick() {
				var sh = screen.height;
				
				if (parent.document.getElementById("topFrame").style.position == "") {
					$("#topMenuFull").fadeOut(0, function(){
						$("#topMenuFull").attr("class", "full_nav on");
						$("#topMenuFull").fadeIn(100);
					});					
					
					parent.document.getElementById("topFrame").style.position = "relative";
					parent.document.getElementById("topFrame").style.minHeight = sh+"px";
					parent.document.getElementById("topFrame").style.backgroundColor = "rgba(0,0,0,0.3)";
					//$(".full_menu_toggle").css("display", "");
					$(".full_menu_toggle").slideDown(200);
				} else {
					$("#topMenuFull").fadeOut(100, function(){
						$("#topMenuFull").attr("class", "full_nav off");
						$("#topMenuFull").fadeIn(100);
					});
					
					parent.document.getElementById("topFrame").style.minHeight = "260px";
					parent.document.getElementById("topFrame").style.backgroundColor = "rgba(0,0,0,0)";
					$(".full_menu_toggle").slideUp(200, function(){
						parent.document.getElementById("topFrame").style.position = "";
					});
				}
			}
			
			/* 2018-03-07 장진혁 서브메뉴 수정 현재 이미지 관리 및 롤오버시 이미지 변환 함수 */			
			var subPath = "";
			var menuName = "";
			var tempobj;			
			
			function img_onMouseOver(obj) {			    
			    if (document.getElementById("menu_" + obj.id) != null) {
			        subPath = "menu_" + obj.id;
			        menuName = obj.id;
			        document.getElementById("menu_" + obj.id).style.left = 0;			        
			        document.getElementById("menu_" + obj.id).style.display = "";
			        var LeftMargin = parseInt(document.getElementById(menuName).offsetLeft) - 60;
			        
			        if (window.document.documentElement.clientWidth < document.getElementById(menuName).offsetLeft + document.getElementById("menu_" + obj.id).clientWidth) {
			            LeftMargin = LeftMargin - (document.getElementById(menuName).offsetLeft + document.getElementById("menu_" + obj.id).clientWidth - window.document.documentElement.clientWidth);
			            LeftMargin = LeftMargin - 20;
			        }
					var cw = document.getElementById(obj.id).clientWidth;
					
			        document.getElementById("menu_" + obj.id).style.left = LeftMargin + "px";
			        document.getElementById("menu_" + obj.id).style.width = cw + "px";
			    } else {
			        menuName = obj.id;
			        subPath = "";
			    }
			    
			    parent.document.getElementById("topFrame").style.position = "relative";
			}
	
			function img_onMouseOut(obj){
				tempobj = obj;
				
				if (document.getElementById("menu_"+obj.id)) {
					document.getElementById("menu_"+obj.id).style.display = "none";
				}
			    
			    parent.document.getElementById("topFrame").style.position = "";			    
			}
	
			function submenuover(subObj) {				
			    if (tempobj.id == subObj.id.replace("menu_", "")) {
					img_onMouseOver(tempobj);
			    }
			}
	
			function submenuout(subObj) {
			    img_onMouseOut(tempobj);
			}
			
			function cntCalculaor() {
				var cnt = 0;
				
				$(".navUL > li").each(function(index) {
					if ($(this).offset().top > 10) {
						cnt++;
					}
				});
				
				if (cnt > 0) {
					$("nav > .countBox").css("display", "block");
					$("#topNav").css("max-width", "1102px");
					/* $("#topNav").css("max-width", "902px"); */
					$(".hidden_nav_count").html("+" + cnt);
				} else {
					$("#topNav").css("max-width", "1102px");
					/* $("#topNav").css("max-width", "902px"); */
					$("nav > .countBox").css("display", "none");
				}
			}
			
			window.onresize = function () {
			    if (clickmenusub != "") {
			        document.getElementById(clickmenusub).style.left = 0;
			        var LeftMargin = parseInt(document.getElementsByName(clickmenuName)[0].offsetLeft);
			        
			        if (window.document.documentElement.clientWidth <= document.getElementsByName(clickmenuName)[0].offsetLeft + document.getElementById(clickmenusub).clientWidth) {
			            LeftMargin = LeftMargin - (document.getElementsByName(clickmenuName)[0].offsetLeft + document.getElementById(clickmenusub).clientWidth - window.document.documentElement.clientWidth);
			            LeftMargin = LeftMargin - 30;
			        }
			        
			        document.getElementById(clickmenusub).style.left = LeftMargin + "px";
			    }
			    cntCalculaor();
			}
	
			function sub_toggle(subfolder) {
				try {
					for (var i=0; i<subfolder.parentElement.children.length; i++) {
						subfolder.parentElement.children.item(i).style.display = "none";
					}
				
					subfolder.style.display = "block";		
					//subfolder.firstChild.firstChild.firstChild.click();
				} catch(e) {}
			}
			
			function submenuclick(pSubMenuID) {
				
			}
			
			function layoutmode() {
				for (var i=0; i<document.getElementsByTagName("tr").length; i++) {
				    var evtHandler = document.getElementsByTagName("tr").item(i).onclick;
				    
					if (evtHandler != null && evtHandler.toString().indexOf("selectcellTitle") > -1) {
					    document.getElementsByTagName("tr").item(i).style.display = "none";
					}
				}
			}
	
			function editingmode() {
			    for (var i = 0; i < document.getElementsByTagName("tr").length; i++) {
			        var evtHandler = document.getElementsByTagName("tr").item(i).onclick;
			        
					if (evtHandler != null && evtHandler.toString().indexOf("selectcellTitle") > -1) {
					    document.getElementsByTagName("tr").item(i).style.display = "";
					}
				}
			}
			
			function resizeTable() {
				if (selObjClass == "TABLE") {
					if (selectedCell == "") {
						alert("<spring:message code='ezPortal.t314' />");
						return;
					}
					
					// 현재 선택된 cell
					var cell = eval(selectedCell);
					
					if (txtWidth.value != "*" && txtWidth.value != "") {
						if (!is_num(txtWidth.value)) {
							alert("<spring:message code='ezPortal.t315' />");
							return;
						}
					    cell.style.width = document.getElementById("txtWidth").value + "px";
					    cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = document.getElementById("txtWidth").value + "px";
					}
					
					var tblObject = eval(GetMainTable(eval(selectedCell)));
					
					if (typeof(tblObject) == "undefined")
						return;
					
					if (!is_num(txtHeight.value)) {
						alert("<spring:message code='ezPortal.t316' />");
						return;
					}
					
				    tblObject.height = document.getElementById("txtHeight").value;
				    tblObject.parentElement.parentElement.style.height = document.getElementById("txtHeight").value + "px";
				} else if (selObjClass == "CONTENTS") {
					if (selectedSubCell == "") {	
						alert("<spring:message code='ezPortal.t306' />");
						return;
					}
	
					var cell = eval(selectedSubCell);
					
					if (cell.getAttribute("canresize") != 1) {
						alert("<spring:message code='ezPortal.t317' />");
						return;
					}
					
					try {
					    cell.parentElement.style.height = document.getElementById("txtHeight").value + "px";
					} catch(e) { alert }
				} else {
					alert("<spring:message code='ezPortal.t318' />");
				}
				
				//event.cancelBubble = true;
			}
			
			// 통합검색
			function Search() {
				txtSearch.value = TrimText(ReplaceText(txtSearch.value, "'", ""));
				var pSearchString = txtSearch.value;
				
				parent.document.querySelector("iframe[name=main]").src = "/myoffice/ezsearch/index_search.aspx?Keyword=" + escape(pSearchString);
			}
			
			function keyword_Clear(obj) {
			    obj.value = "";
			}
			
			function Key_event(e,obj) {
			    var curevent = (typeof event == 'undefined' ? e : event)
			        if (curevent.keyCode == "13") {
			            Emp_Search();
			        }
			}
	
			function input_Onblur(obj) {
			    if (obj.value.length == 0) { obj.className = 'input_text' } else { obj.className = 'input_text focusnot' }
			}
			
			// 직원조회
			function Emp_Search() {
			    if (document.getElementById('input_search').value != "") {
			        var wHeight = 670;
			        var wWidth = 750;
			        var wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
			        var wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	
			        window.open("/ezPersonal/personSearch.do?searchString=" + encodeURI(document.getElementById('input_search').value), "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status=no, toolbar=no, menubar=no,location=no, resizable=0");
			        document.getElementById('input_search').value = '';
			    }
			}
			
			// 2009.11.27 - 팝업창의 위치를 선택할 수 있는 기능 추가
			function openPopup(popup_number, wWidth, wHeight, wPosition) {
			    var wVertical, wHorizontal;
			    
				if(wPosition == 0) {
			        wVertical = Math.floor(screen.height/2) - (wHeight/2); 
			        wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
			    } else if(wPosition == 1) {
			        wVertical = 100; 
			        wHorizontal = 100;
			    } else if(wPosition == 2) {
			        wVertical = screen.height - wHeight - 100; 
			        wHorizontal = 100;
			    } else if(wPosition == 3) {
			        wVertical = 100; 
			        wHorizontal = screen.width - wWidth - 100;
			    } else if(wPosition == 4) {
			        wVertical = screen.height - wHeight - 100; 
			        wHorizontal = screen.width - wWidth - 100;
			    } else if(wPosition == 5) {
			        wVertical = 100; 
			        wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
			    } else if(wPosition == 6) {
			        wVertical = screen.height - wHeight - 100; 
			        wHorizontal = Math.floor(screen.width/2) - (wWidth/2);
			    } else {
			        wVertical = 0; 
			        wHorizontal = 0;
			    }
	
			    if(wVertical < 0)
			        wVertical = 0;
	
			    if(wHorizontal < 0)
			        wHorizontal = 0;
	
			    if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
			        wHeight = eval(wHeight) - 60;
	
			    window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + popup_number + 
						"&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
			}
		
			var clickmenusub = "";
			var clickmenuPath = "";
			var clickmenuName = "";
			
			function OpenWindow(evt, url, location, option) {
				if ($(".full_menu_toggle").css("display") != "none") {
					$(".full_menu_toggle").slideUp(200, function(){
						parent.document.getElementById("topFrame").style.backgroundColor = "rgba(0,0,0,0)";
						parent.document.getElementById("topFrame").style.position = "";
						$(".full_menu_toggle").css("display", "none");
						
						if ($("#topMenuFull").attr("class") == "full_nav on") {
							$("#topMenuFull").attr("class", "full_nav off");
						}
						
						if (url == "/ezPersonal/personSearch.do") {
							option = GetOpenWindowfeature(750, 670);
						}
						
						window.open(url, location, option);
					});
				} else {
					if (url == "/ezPersonal/personSearch.do") {
						option = GetOpenWindowfeature(750, 670);
					}
					
					window.open(url, location, option);
				}
				
				/* if (option != "") {
	    			var width = 0, height = 0;
	    			var leftPosition = "", topPosition = "";
	    			var opt = option.split(',');
	    			
	    			for (var i = 0 ; i < opt.length ; i++) {
	        			if (opt[i].indexOf('height') > -1) {
	            			height = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
	            			var top = (window.screen.height / 2) - ((height / 2) + 50);
	            			topPosition = ", top=" + top + ", screenY=" + top;
	        			}
	        			
	        			if (opt[i].indexOf('width') > -1) {
	            			width = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
	            			left = (window.screen.width / 2) - ((width / 2) + 10);
	            			leftPosition = ", left=" + left + ", screenX=" + left;
	        			}
	    			}
	    			option = option + topPosition + leftPosition;
				}
				
				if (evt != undefined) {
	    			var targetid = evt.target ? evt.target.id : event.srcElement.id;

	    			if (targetid != "") {
	        			clickmenusub = subPath;
	        			if (menuName != clickmenuName) {
	            			clickmenuPath = oldPath;
	            			clickmenuName = menuName;
	        			}
	    			}
	    			
	    			var targetName = evt.target ? evt.target.parentElement.id : event.srcElement.parentElement.id;

	    			if (targetName.indexOf("menu_") > -1) {
	 		        	clickmenusub = targetName;
	 		        	var tName = targetName.replace("menu_", "");
	 		        	
	 		            if (menuName != clickmenuName) {	 		                
	 		                if (clickmenuPath != "") {
	 		                	if (tName == clickmenuName) {
									clickmenuPath = clickmenuPath;
	 		                	} else {
	 		                		clickmenuPath = oldPath;	
	 		                	}
							} else {
	 		                	clickmenuPath = oldPath;
							}
	 		                clickmenuName = targetName.split("menu_")[1];
	 		            }
	 		        }
				} */
			}
			
			function OpenWindow2(targetid, url, location, option) {
				window.open(url, location, option);
			}
		    
		    function showProgress() {
			    document.getElementById("progressPanel").style.display = "block";
			    document.getElementById("progressPanel").style.opacity = 0.5;
			    document.getElementById("progressPanel").style.background = "rgba(0,0,0,0.7)";
			}
	        
	        function hideProgress() {
	        	document.getElementById("progressPanel").style.display = "none";
	        }
	        
	        function topMenuToggle(menu) {
	        	switch (menu) {
		        	case "NewMail" : 
		        		//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
						break;						
					case "ApprG" : 	
						// 문서Type 선택 1=결재할문서 2=기안할문서  3=결재진행문서  4=수신문서처리(접수기)
						var listType;
						listType = 1;
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu04o(1).gif', document.getElementById("top_menu04(1)"));
						OpenWindow2('top_menu04(1)', "/ezApprovalG/apprGMain.do?listType=" + listType, "main", " ");
						break;
					case "Appr" : 		
						var listType;
						listType = 1;
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu04o(1).gif', document.getElementById("top_menu04(1)"));
		        		OpenWindow2('top_menu04(1)', "/ezApprovalG/apprMain.do?listType=" + listType, "main", " ");	
						break;
					// 표준모듈 (2007.03.23) 수정 : 메모보고 
					case "Memo" : 					
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
						break;
						
					case "Schedule" :
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu03o(8).gif', document.getElementById("top_menu03(4)"));
		        		OpenWindow2('top_menu03(4)', "/ezSchedule/scheduleIndex.do?funCode=2", "main", " ");
						break;
						
					case "Poll" :
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu05o.gif', document.getElementById("top_menu05"));
		        		OpenWindow2('top_menu05', "/ezBoard/boardMain.do?func=1", "main", " ");
						break;
						
					case "pollnum" : 
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu05o.gif', document.getElementById("top_menu05"));
						OpenWindow2('top_menu05', "/ezBoard/boardMain.do?func=1", "main", " ");
						break;
					
					case "Env" :
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
						break;
					case "My_Board" :
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
						break;
					case "Address" : 
						//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
						break;
				    case "ModInfo":
				    	//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
				        break; 
				    case "Circular":
				    	//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
		        		OpenWindow2('top_menu02', "/ezCircular/circularIndex.do", "main", " ");
				        break; 
	        	}
	        }
	        
	        windowOnloadFunc();
		</script>
	</head>
		<c:choose>
			<c:when test="${mode != 'view'}">
				<body class="mainbody" style="background-color: transparent;overflow:hidden;min-width:1280px">
			</c:when>
			<c:otherwise>
				<body style="background-color: transparent;overflow:hidden;min-width:1280px">
			</c:otherwise>
		</c:choose>
		<c:if test="${approvalFlag == 'G' && useHWP == 'YES'}">
			<script type="text/javascript">
				ezIcd_ActiveX("i_icd2");
			</script>
		</c:if>  
		<div id="objectDiv"></div>
		<c:choose>
			<c:when test="${mode != 'view'}">
				<!-- 메뉴 -->
				<h1><spring:message code='ezPortal.t363' /></h1>
					<div id="mainmenu">
						<ul>
							<li><span onClick="save()"><spring:message code='ezPortal.t62' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="layoutmode()"><spring:message code='ezPortal.t322' /></span></li>
							<li><span onClick="editingmode()"><spring:message code='ezPortal.t323' /></span></li>					
							<li><span onClick="preview()"><spring:message code='ezPortal.t63' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="insertpage()"><spring:message code='ezPortal.t325' /></span></li>
							<li><span onClick="removecell('field')"><spring:message code='ezPortal.t326' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="insertcell()"><spring:message code='ezPortal.t327' /></span></li>
							<li><span onClick="removecell()"><spring:message code='ezPortal.t328' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="insertrow()"><spring:message code='ezPortal.t329' /></span></li>
							<li><span onClick="removerow()"><spring:message code='ezPortal.t330' /></span></li>
							<!-- <li style="background:none; padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
							<li><span onClick="swaprow('up')"><spring:message code='ezPortal.t331' /></span></li>
							<li><span onClick="swaprow('down')"><spring:message code='ezPortal.t332' /></span></li>
							<li><span onClick="swaprow('left')"><spring:message code='ezPortal.t72' /></span></li>
							<li><span onClick="swaprow('right')"><spring:message code='ezPortal.t74' /></span></li>					
						</ul>
					</div>
					<script type="text/javascript">
						selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
					</script>
					<table width="1020" class="popuplist" >
						<tr>
							<th height="30" style="width:100px"><spring:message code='ezPortal.t359' /></th>
							<td>
				    			<table style="width:100%;">
			            			<tr class="primary">
				            			<th style="width:80px;">${langPrimary}</th>
				            			<td><input type="text" id="txtDisplayName" value="${displayName}" style="width:100%;" maxLength="255"></td>	
			            			</tr>
			            			<tr class="secondary">
				            			<th style="width:80px;">${langSecondary}</th>
				            			<td><input type="text" id="txtDisplayName2" value="${displayName2}" style="width:100%;" maxLength="255"></td>	
			            			</tr>
		            			</table>
							</td>
						</tr>
					</table>
					<br>
					<table style="width:1020px; background-color:#F5f5f5;"class="box">
						<tr>
			  				<td style="padding-left:10px; height:30px;">
			  					<spring:message code='ezPortal.t334' />
			  					<input type="text" id="txtWidth" name="txtWidth" style="WIDTH:50px" maxLength="10">
								px * 
								<spring:message code='ezPortal.t335' />
								<input type="text" id="txtHeight" name="txtHeight" style="WIDTH:50px" maxLength="10">
								 px 
								<a class="imgbtn">
									<span onClick="resizeTable()">
										<spring:message code='ezPortal.t336' />
									</span>
								</a>
			  				</td>
                			<td style="width:60px;"><spring:message code='ezPortal.t990022' />:</td>
                			<td style="width:135px;">
                    			<select id="Themeinfo" style="width:130px; height: 23px;">
			                        ${pThemeSelectObject}
                    			</select>
                			</td>
						</tr>
					</table>
				<div style="WIDTH:1020px">
					${strHTML}
				</div>
			</c:when>
			<c:otherwise>
				${strHTML}
			</c:otherwise>
		</c:choose>
		<!-- 표준모듈 (2007.03.15) 수정: .NET Framework 2.0에서는 RegisterStartupScript 메서드 지원하지 않음. -->
		${script1}
		<div id="objectProgressDiv"></div>
		<c:if test="${approvalFlag == 'G' && useHWP == 'YES'}">
			<iframe id=if_Progress style="display:none" src="/ezPortal/progress.do"></iframe>
		</c:if>
		<iframe id=ifmpopup style="display:none" src=""></iframe>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>
	</body>
</html>
