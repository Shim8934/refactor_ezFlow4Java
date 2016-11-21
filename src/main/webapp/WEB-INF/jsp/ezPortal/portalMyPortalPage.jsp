<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>PortalPage</title>
		<%
		String mode = (String)request.getAttribute("mode");
		String strHTML = (String)request.getAttribute("strHTML");
		String parentPageID = (String)request.getAttribute("parentPageID");
		String baseType = (String)request.getAttribute("baseType");
		%>
		<% if (!mode.equals("view")) { %>
			<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<% } else { %>
        	<link rel="stylesheet" href="/css/main.css" type="text/css" />
		<% } %>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript">
		var xmlhttp;
		var QuickcurNum = 0;
		var QuickBlockNum = 8;
		var selectedCell = "";
		var selectedSubCell = "";
		var previousSubCell = null;
		var previousCell = null;
		var count = 1000;
		var pageid = "${pageID}";
		var parentpageid = "${parentPageID}";
		var mode = "${mode}";
		var editmode = "${editMode}";
		var gubunFlag = "${gubunFlag}";
		var bInherit = false;
		var prevPageID = "";
		var selObjClass = "";
		var bCanModify = true;   // 영역삭제, 열추가, 열삭제 가능여부
		var g_XML = "";          // 삭제대상 포틀릿 정보 저장
		var g_ClassID = "${pClassID}";
		var g_ClassName = "${pClassName}";
		var g_UserID = "${userInfo.id}";
		var g_UserName = "${userInfo.displayName1}";				
		var MyPortalPageID = "${myPortalPageID}"; //
		var g_BaseType = "${baseType}"; // 초기화 버튼 활성화 유무
		var g_CompanyID = "${userInfo.companyID}";
		var TableViewOption = "${tableViewOption}";
		var lang = "${userInfo.lang}";

		document.onselectstart = function(){
		event.cancelBubble = true;
		event.returnValue = false;
		}
		
		window.onload = function() {
            <% if (mode.equals("view")) { %>
		    QuickLinkCheck();
            <%}%>
			if (editmode == "new_inherit") bInherit = true;
			if (mode == "edit") {
				AttachEvents(main_table);
				SetOptionPortlet(main_table);
			}
			
			if (mode != "view") {
			    document.getElementById("Optioninfo").value = TableViewOption;
				// 포탈페이지 카테고리 정보
				var PortalPageCategoryXML = "${portalPageCategoryXML}";
				if (PortalPageCategoryXML != "")
				{
				    var xmldom = createXmlDom();
				    xmldom = loadXMLString(PortalPageCategoryXML);
					
					// 최상위 페이지
					if (parentpageid.toLowerCase() == "top")
					{
						for (var i=0; i<xmldom.getElementsByTagName("CATEGORY").length; i++)
						{
						    var lastindex = document.getElementById("portal_gubun").length;
						    var newoption = new Option(getNodeText(GetElementsByTagName(xmldom, "DISPLAYNAME").item(i)) + "Root", getNodeText(GetElementsByTagName(xmldom, "CATEGORY").item(i)));
							document.getElementById("portal_gubun").options[lastindex] = newoption;
						}
						
						for (var i=0; i<document.getElementById("portal_gubun").length; i++)
						{
						    if (document.getElementById("portal_gubun").options[i].value == gubunFlag)
							{
						        document.getElementById("portal_gubun").options[i].selected = true;
								break;
							}
						}
						
						// 저장된 페이지는 카테고리정보 변경불가
						if (gubunFlag != "")
						    document.getElementById("portal_gubun").disabled = true;
					}
					// 상속페이지
					else
					{
						// 신규 상속페이지
						if (editmode == "new_inherit")
						{
							// 상속받은 페이지의 코드정보는 Root코드 + "c"로 설정 (ex. Root=2, Child=2c)
							for (var i=0; i<xmldom.getElementsByTagName("CATEGORY").length; i++)
							{
							    var lastindex = document.getElementById("portal_gubun").length;
							    var newoption = new Option(getNodeText(GetElementsByTagName(xmldom, "DISPLAYNAME").item(i)), getNodeText(GetElementsByTagName(xmldom, "CATEGORY").item(i)) + "c");
								document.getElementById("portal_gubun").options[lastindex] = newoption;
							}
							
							var checkFlag = gubunFlag + "c";
							for (var i=0; i<document.getElementById("portal_gubun").length; i++)
							{
							    if (document.getElementById("portal_gubun").options[i].value == checkFlag)
								{
							        document.getElementById("portal_gubun").options[i].selected = true;
									break;
								}
							}
						}
						else
						{
							// 상속받은 페이지의 코드정보는 Root코드 + "c"로 설정 (ex. Root=2, Child=2c)
							for (var i=0; i<xmldom.getElementsByTagName("CATEGORY").length; i++)
							{
							    var lastindex = document.getElementById("portal_gubun").length;
							    var newoption = new Option(getNodeText(GetElementsByTagName(xmldom, "DISPLAYNAME").item(i)), getNodeText(GetElementsByTagName(xmldom, "CATEGORY").item(i)) + "c");
								document.getElementById("portal_gubun").options[lastindex] = newoption;
							}
							
							for (var i=0; i<document.getElementById("portal_gubun").length; i++)
							{
							    if (document.getElementById("portal_gubun").options[i].value == gubunFlag)
								{
							        document.getElementById("portal_gubun").options[i].selected = true;
									break;
								}
							}
						}
						
						// 사용자 페이지에서는 카테고리정보 변경불가
						document.getElementById("portal_gubun").disabled = true;
					}
					xmldom = null;
				}
			}
			
			
			// 상속 페이지
			if (parentpageid.toLowerCase() != "top")
			{
				// 편집모드인 경우 사이즈 조정
				if (mode != "view" && typeof(td_mainframe) == "object")
				{
					if (typeof(document.getElementById("txtDisplayName")) == "object")
					{
						if (document.getElementById("txtDisplayName").value == "")
							document.getElementById("txtDisplayName").value = "<spring:message code='ezPortal.t288'/>";
						
						table_displayname.style.display = "none";
					}
					
					// 부문포탈
					if (g_ClassID != "")
					{
						td_mainframe.style.height = "470";
						main_div.style.height = "470";
					}
					// 마이포탈
					else
					{
						td_mainframe.style.height = "360";
						main_div.style.height = "360";
					}
				}
			}
		}
            

		    function QuickLinkCheck() {
		        var xmlpara = createXmlDom();
		        var objNode;

		        xmlhttp = null;
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezPortal/getQuickLink.do", true);
		        xmlhttp.onreadystatechange = event_GetQuickLink;
		        xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
		        xmlhttp.send(xmlpara);
                	        
		    }
		    function event_GetQuickLink() {
		        if (xmlhttp != null && xmlhttp.readyState == 4) {
		            if (xmlhttp.statusText == "OK") {
		                var xmldomNode = SelectNodes(xmlhttp.responseXML, "DATA/ROW");
		                for (i = 0; i < xmldomNode.length; i++) {

		                    var URL = SelectSingleNodeValue(xmldomNode[i], "URL");
		                    var SIZE = SelectSingleNodeValue(xmldomNode[i], "SIZE");


		                    var _li = document.createElement("li");
		                    _li.style.display = "none";
		                    if (trim_Cross(URL) != "") {
		                        _li.onclick = new Function("openURL('" + URL + "', '"+ SIZE +"');");
		                    }
		                    var _span1 = document.createElement("span");
		                    _span1.className = "icon";

		                    var linktype = SelectSingleNodeValue(xmldomNode[i], "LINKTYPE");
		                    _span1.innerHTML = "<img src=\"" + SelectSingleNodeValue(xmldomNode[i], "LINKTYPEURL") + "\" >";
		                                                

		                    var _span2 = document.createElement("span");
		                    _span2.className = "txt";
		                    var QuickLang = lang == "1" ? "" : lang;
                            if(CrossYN())
                                _span2.textContent = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKNAME" + QuickLang);
		                    else
                                _span2.innerText = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKNAME" + QuickLang);

		                    _li.appendChild(_span1);
		                    _li.appendChild(_span2);
		                    document.getElementById("QuickUl").appendChild(_li);


		                    if (i < QuickBlockNum) {
		                        document.getElementById('QuickUl').getElementsByTagName('li')[i].style.display = 'block';
		                    }
		                    else {
		                        document.getElementById('QuickUl').getElementsByTagName('li')[i].style.display = 'none';
		                    }
		                }

		                
		            }
		        }
		    }
		    
		    function QuickMove(value) {
		        var totalcnt = document.getElementById('QuickUl').getElementsByTagName('li').length;
		        if (value == "DOWN") {
		            if (totalcnt > QuickcurNum + QuickBlockNum) {
		                document.getElementById('QuickUl').getElementsByTagName('li')[QuickcurNum].style.display = "none";
		                document.getElementById('QuickUl').getElementsByTagName('li')[QuickcurNum + QuickBlockNum].style.display = "block";
		                QuickcurNum++;
		            }
		        }
		        else {
		            if (QuickcurNum > 0) {
		                QuickcurNum--;
		                document.getElementById('QuickUl').getElementsByTagName('li')[QuickcurNum].style.display = "block";
		                document.getElementById('QuickUl').getElementsByTagName('li')[QuickcurNum + QuickBlockNum].style.display = "none";
		            }
		        }
		    }
		    function openURL(Location, SIZE) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;

		            var left = 0;
		            var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;

		                pleftpos = parseInt(width) - 967;
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - pleftpos;

		                left = pleftpos / 2;
		            } else {

		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
		            }
		            if(SIZE == "FULL")
		                window.open(Location, "", "toolbar=1,location=1,directories=0,status=1,menubar=1,scrollbars=0,resizable=1,height=" + screen.height + ",width=" + screen.width + ",top=0,left=0");
		            else
		                window.open(Location, "", "toolbar=1,location=1,directories=0,status=1,menubar=1,scrollbars=0,resizable=1,height=" + SIZE.split(':')[1] + ",width=" + SIZE.split(':')[0] + ",top=" + top + ",left = " + left);

		        } catch (e) {
		            alert("openwindow :: " + e.description);
		        }
		    }
		    
		    function trim(parm_str) {
		        return rtrim(ltrim(parm_str));
		    }

		    function ltrim(parm_str) {
		        str_temp = parm_str;
		        while (str_temp.length != 0) {
		            if (str_temp.substring(0, 1) == " ") {
		                str_temp = str_temp.substring(1, str_temp.length);
		            } else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }

		    function rtrim(parm_str) {
		        str_temp = parm_str;
		        while (str_temp.length != 0) {
		            int_last_blnk_pos = str_temp.lastIndexOf(" ");
		            if ((str_temp.length - 1) == int_last_blnk_pos) {
		                str_temp = str_temp.substring(0, str_temp.length - 1);
		            } else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		function SetOptionPortlet(pObject)
		{
			if (parentpageid.toLowerCase() != "top")
			{
			    for (var i = 0; i < GetElementsByTagName(pObject, "td").length; i++)
				{
			        if (GetElementsByTagName(pObject, "td").item(i).id == "") continue;

			        if (GetElementsByTagName(pObject, "td").item(i).id.indexOf("sub") > -1)
					{			
						// 상속받은 포틀릿중 필수포틀릿은 링크표시가 나타나지 않도록 한다.
			            if (typeof( GetElementsByTagName(pObject, "td").item(i).ownerpageuid) != "undefined" && typeof (GetElementsByTagName(pObject, "td").item(i).mandatory) != "undefined")
						{
							// 옵션 포틀릿인 경우
						    if (GetElementsByTagName(pObject, "td").item(i).mandatory == "2")
							{
						        var cell = GetElementsByTagName(pObject, "td").item(i);

								// 상속페이지에서 Root페이지의 옵션 포틀릿인 경우 삭제대상 정보를 저장
								if (cell.cell.getAttribute('ownerpageuid') != pageid && cell.getAttribute('mandatory') == "2")
								{
								    g_XML += "<ROW>" + "<UID>" + cell.getAttribute('uid') + "</UID>" + "<PAGEUID>" + cell.getAttribute('pageuid') + "</PAGEUID>" +
										"<OWNERPAGEUID>" + cell.getAttribute('ownerpageuid') + "</OWNERPAGEUID>" +
										"<USERPAGEUID>" + pageid + "</USERPAGEUID>" +
										"<CHANGEFLAG>2</CHANGEFLAG>" + "</ROW>";

									cell.ownerpageuid = pageid;
								}
							}
						}
					}
				}
			}
		}

		function load() {
			var ret = window.showModalDialog("/ezPortal/portalPageSearch.do?mode=load");
			if (typeof(ret) == "undefined") return;
			
			document.location.href = "/ezPortal/portalPage.do?pageID=" + ret[0];
		}
		
		// 상속
		function inherit() {
			var ret = window.showModalDialog("/ezPortal/portalPageSearch.do?mode=inherit", "", "dialogHeight:300px; dialogWidth:290px; status:no;scroll:auto; help:no; edge:sunken");
			if (typeof(ret) == "undefined") return;
			
			document.location.href = "/ezPortal/portalPage.do?parentPageID=" + ret[0];
		}

		function CopyPortlet(pPortletID, pSourcePageID, pDestPageID)
		{
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "admin/remote/CopyPortlet.aspx?uid=" + pPortletID + "&sourcepageid=" + pSourcePageID + "&destpageid=" + pDestPageID, false);
			xmlhttp.send();
			xmlhttp = null;
		}
		
		function savesub(pObject, pPageID, pParentPageID, pDisplayName, pDisplayName2)
		{
			var pUserID = g_UserID;
			var pUserName = g_UserName;

			// 부문포탈인 경우 사용자 정보에 부문포탈 정보를 입력
			if (g_ClassID != "") pUserID = g_ClassID;
			if (g_ClassName != "") pUserName = g_ClassName;			
			
			var strXML = "<DATA>";
			strXML += "<DISPLAYNAME>" + ReplaceValidString(pDisplayName) + "</DISPLAYNAME>";
			strXML += "<DISPLAYNAME2>" + ReplaceValidString(pDisplayName2) + "</DISPLAYNAME2>";
			strXML += "<THEMEINFO>" + ReplaceValidString(document.getElementById("Themeinfo").value) + "</THEMEINFO>";
			strXML += "<TABLEVIEWOPTION>" + ReplaceValidString(document.getElementById("Optioninfo").value) + "</TABLEVIEWOPTION>";
			strXML += "<WIDTH>" + pObject.getAttribute("width").toString().replace("px", "").replace("100%", "-1") + "</WIDTH>";
			strXML += "<HEIGHT>" + pObject.getAttribute("height").toString().replace("px", "").replace("100%", "-1") + "</HEIGHT>";
			strXML += "<PARENTPAGEID>" + pParentPageID + "</PARENTPAGEID>";
			strXML += "<GUBUNFLAG>1c</GUBUNFLAG>";
			strXML += "<USERID>" + pUserID + "</USERID>";
			strXML += "<USERNAME>" + pUserName + "</USERNAME>";

			
			// 대상테이블의 최상위td count
			for (var i=0; i<pObject.children.item(0).children.item(0).children.length; i++)
			{
				if (pObject.children.item(0).children.item(0).children.item(i).id == "") continue;
				
				// 최상위td
				if (pObject.children.item(0).children.item(0).children.item(i).id.substr(0, 2) == "td")
				{
					strXML += "<CELL>";
					var td_item = pObject.children.item(0).children.item(0).children.item(i);			
					
					// 메인테이블이 수정되는 경우를 고려 - .replace("100%", "") 추가
					if (td_item.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML == "*") {
					    strXML += "<WIDTH>9999</WIDTH>";
					}
					else {
					    strXML += "<WIDTH>" + td_item.style.width.toString().replace("px", "").replace("100%", "") + "</WIDTH>";
					}

					
					// 해당td내의 tr의 카운트 (TABLE/TBODY/TR)
					for (var j=0; j<td_item.children.item(0).children.item(0).children.length; j++)
					{
						// 해당 tr내의 td
						var tdsub_item = td_item.children.item(0).children.item(0).children.item(j).children.item(0);
						try {
							if (tdsub_item.id == "") continue;
						} catch(e) { continue; }
						
						/*
						if (previousCell != null) previousCell.style.backgroundColor = "white";
						tdsub_item.style.backgroundColor = "red";
						previousCell = tdsub_item;
						*/
						
					    // td안에 컨텐츠가 존재하는 경우
						
						if (tdsub_item.children.length > 0 && tdsub_item.children.item(0).id.toLowerCase().substr(0, 4) != "main")
						{
							strXML += "<ROW>";
							strXML += "<TYPE>0</TYPE>";
							strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
							strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
							strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
							strXML += "<DISPLAYNAME>" + ReplaceValidString(tdsub_item.firstChild.innerHTML) + "</DISPLAYNAME>";
							strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
							strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
							//strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
							strXML += "<CANREPLACE>1</CANREPLACE>";
							strXML += "<OWNERPAGEUID>" + tdsub_item.getAttribute("ownerpageuid") + "</OWNERPAGEUID>";	
							strXML += "<PREVPAGEID>" + prevPageID + "</PREVPAGEID>";					
							strXML += "</ROW>";
							prevPageID = "";
						}
						// td안에 테이블이 존재하는 경우
						else
						{
							strXML += "<ROW>";
							strXML += "<TYPE>1</TYPE>";
							strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
							strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
							strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
							strXML += "<DISPLAYNAME>" + tdsub_item.getAttribute("pageuid") + "</DISPLAYNAME>";
							strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
							strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
						    //strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
							strXML += "<CANREPLACE>1</CANREPLACE>";
							strXML += "<OWNERPAGEUID>" + tdsub_item.getAttribute("ownerpageuid") + "</OWNERPAGEUID>";				
							strXML += "<PREVPAGEID>" + prevPageID + "</PREVPAGEID>";				
							strXML += "</ROW>";
							
							// 하위테이블의 정보를 저장
							savesub(tdsub_item.children.item(0), tdsub_item.getAttribute("uid"), "top", tdsub_item.getAttribute("uid"), "");
							prevPageID = tdsub_item.uid;
						}
					}
					prevPageID = "";
					strXML += "</CELL>";
				}
			}
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			
			xmlhttp.open("POST", "admin/remote/portal_SavePortalPage.aspx?callingpageid=" + pageid + "&pageid=" + pPageID + "&parentpageid=" + pParentPageID + "&type=MYPORTAL", false);
			xmlhttp.send(strXML);
			xmlhttp = null;
		}

		function save()
		{
			if (document.getElementById("txtDisplayName").value == "")
			{
				alert("<spring:message code='ezPortal.t289'/>");
				document.getElementById("txtDisplayName").focus();
				return;
			}
			if (document.getElementById("txtDisplayName2").value == "")
			{
			    document.getElementById("txtDisplayName2").value = document.getElementById("txtDisplayName").value;
			}
			
			// 상속페이지인 경우 자신의 캐쉬정보를 바로 삭제한다.
			if (parentpageid.toLowerCase() != "top")
			{
				DeleteCache();
			}
			
			var xmlhttp = null;
			
			if (g_XML != "")
			{
				var pUserID = g_UserID;
				var pUserName = g_UserName;
				
				// 부문포탈인 경우 사용자 정보에 부문포탈 정보를 입력
				if (g_ClassID != "") pUserID = g_ClassID;
				if (g_ClassName != "") pUserName = g_ClassName;
				
				// 삭제대상 포틀릿정보를 저장
				g_XML = "<DATA>" + g_XML + "</DATA>";
				xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "admin/remote/portal_SaveDelPortletInfo.aspx?userid=" + pUserID + "&username=" + pUserName, false);
				xmlhttp.send(g_XML);
				xmlhttp = null;
			}
			
			savesub(main_table, pageid, parentpageid, document.getElementById("txtDisplayName").value, document.getElementById("txtDisplayName2").value);	
            alert("<spring:message code='ezPortal.t59'/>");
		    document.location.href = "/ezPortal/myPortalPage.do?pageID=" + pageid + "&pClassID=" + g_ClassID + "&pClassName=" + g_ClassName + "&mode=edit";
		
		}

		function CheckDuplicate(pUID)
		{
		    for (var i=0; i<main_table.getElementsByTagName("td").length; i++)
			{
		        if (main_table.getElementsByTagName("td").item(i).getAttribute("uid") == pUID) return true;
			}
			return false;
		}

		function AttachEvents(pObject, pPageID)
		{
			var prevpageid = "";
			var count = 0;
			for (var i=0; i<pObject.getElementsByTagName("td").length; i++)
			{
			    if (pObject.getElementsByTagName("td").item(i).id == "") continue;

			    if (pObject.getElementsByTagName("td").item(i).id.indexOf("sub") > -1)
				{
			        if (prevpageid != pObject.getElementsByTagName("td").item(i).pageuid) count++;
			        prevpageid = pObject.getElementsByTagName("td").item(i).getAttribute("pageuid");	
					
					// 상속받은 포틀릿중 필수포틀릿은 링크표시가 나타나지 않도록 한다.
			        if (typeof(pObject.getElementsByTagName("td").item(i).getAttribute("ownerpageuid")) != "undefined" && typeof(pObject.getElementsByTagName("td").item(i).getAttribute("mandatory")) != "undefined")
					{
						// Root페이지 이거나 옵션 포틀릿인 경우
			            if (pObject.getElementsByTagName("td").item(i).getAttribute("ownerpageuid") == pageid || pObject.getElementsByTagName("td").item(i).getAttribute("mandatory") == "2")
						{
			                if (pObject.getElementsByTagName("td").item(i).children.item(0).tagName != "TABLE")
							{
								// Root페이지
			                    if (pObject.getElementsByTagName("td").item(i).getAttribute("ownerpageuid") == pageid)
								{
			                        pObject.getElementsByTagName("td").item(i).ondblclick = dblclicksubcell;
			                        pObject.getElementsByTagName("td").item(i).style.cursor = "pointer";
			                        pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectsubcell(event)");
			                        pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
			                        //pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
								}
								// 상속페이지 - 옵션포틀릿
								else
			                    {
			                        pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectsubcell(event)");
			                        pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
			                        //pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
								}
							}
						}
					}
				}
				else
			    {
			        pObject.getElementsByTagName("td").item(i).setAttribute("onclick", "selectcell(event)");
			        pObject.getElementsByTagName("td").item(i).setAttribute("onkeydown", "cellkeydown(event)");
			        //pObject.getElementsByTagName("td").item(i).onclick = function() {selectcell(evnet);};
			        //pObject.getElementsByTagName("td").item(i).onkeydown = cellkeydown;
				}
			}
			
			if (count > 1) bInherit = false;
		}

		function OpenEditWindow(pUID, pPageUID)
		{
			var pUserID = g_UserID;
			var pUserName = g_UserName;
			
			// 부문포탈인 경우 사용자 정보에 부문포탈 정보를 입력
			if (g_ClassID != "") pUserID = g_ClassID;
			if (g_ClassName != "") pUserName = g_ClassName;
			
			window.open("admin/edit/PortalPageItem_Edit.aspx?uid=" + pUID + "&pageid=" + pPageUID + "&ownerpageid=" + pageid + "&gubunFlag=" + gubunFlag + "&pUserID=" + pUserID + "&pUserName=" + escape(pUserName), "", "height = 320px, width = 530px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(530, 320));
		}

		function dblclicksubcell()
		{
			var obj = null;
			if (event.srcElement.id == "") obj = event.srcElement.parentElement;
			else obj = event.srcElement;
			
			// 영역 더블클릭시 처리, pageuid
			if (typeof(obj.ownerpageuid) == "undefined" || typeof(obj.pageuid) == "undefined" || typeof(obj.mandatory) == "undefined")
			{
				event.cancelBubble = true;
				return;
			}
			
			if (obj.ownerpageuid != pageid && obj.mandatory == "1")
			{
				alert("<spring:message code='ezPortal.t290'/>");
				event.cancelBubble = true;
				return;
			}
			
			if (typeof(obj.uid) != "undefined" && obj.uid != "") 
			{
				event.cancelBubble = true;	
				OpenEditWindow(obj.uid, obj.pageuid);					
			}
		}

		// 신규생성 포틀릿 알림메시지
		function dblclicknotice()
		{
			alert("<spring:message code='ezPortal.t291'/>");
		}

		    // 영역 선택시 처리selectcell

		function selectcell(e) {
			try {
				var Event = e ? e : window.event;
			    var Element = Event.target ? Event.target : Event.srcElement;
			    if (Element.getAttribute("id") == "") return;
			    if (Element.getAttribute("id").indexOf("sub") > -1) return;
			    selectedCell = Element.getAttribute("id");
				if (previousCell != null) previousCell.style.backgroundColor = "white";
				previousCell = Element.children.item(0).children.item(0).children.item(0).children.item(0);
				previousCell.style.backgroundColor = "lightblue";
				
				// 현재 선택된 cell (id='tdXXX')
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
				for (var i=0; i<tblObject.getElementsByTagName("tr").length; i++) {
					try{
					    compareHeight = tblObject.getElementsByTagName("tr").item(i).style.height.replace("px", "");
						
						if (compareHeight != "") {
							if (parseInt(compareHeight, 10) > maxHeight)
								maxHeight = parseInt(compareHeight, 10);
						}
					
					} catch (e) {}
				}
				

				if (cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML == "*")
				    document.getElementById("txtWidth").value = "*";
				else
				    document.getElementById("txtWidth").value = cell.style.width.replace("px", "");

				document.getElementById("txtHeight").value = maxHeight;
				
				bCanModify = true;
				document.getElementById("txtWidth").disabled = false;
				document.getElementById("txtHeight").disabled = false;
				
				// 메인테이블이 수정되는 경우를 고려
				if (document.getElementById("txtWidth").value == "" || document.getElementById("txtWidth").value == "100%") {
					document.getElementById("txtWidth").value = "*";
					
					// 메인테이블을 제외하고 테이블 너비 조정불가
					//if (tblObject.id != "main_table")
					//	document.getElementById("txtWidth").disabled = true;
				}
				
				// 상속받은 페이지인 경우 테이블 사이즈 조정 불가
				if (parentpageid.toLowerCase() != "top") {
					if (typeof(tblObject.parentElement.ownerpageuid) == "undefined" || tblObject.parentElement.ownerpageuid != pageid)
					{
						document.getElementById("txtWidth").disabled = true;
						document.getElementById("txtHeight").disabled = true;
						bCanModify = false;
					}
				}
				
				// 선택한 개체의 종류
				selObjClass = "TABLE";
			} catch (e) {}
		}

		function selectcellTitle(e) {
		    var Event = e ? e : window.event;
		    var Element = Event.target ? Event.target : Event.srcElement;
		    selectcell2(Element.parentElement.parentElement.parentElement.parentElement);
		    
		}
		function selectcell2(obj) {
		    try {
		        if (obj.getAttribute("id") == "") return;
		        if (obj.getAttribute("id").indexOf("sub") > -1) return;
		        selectedCell = obj.getAttribute("id");
		        if (previousCell != null) previousCell.style.backgroundColor = "white";
		        previousCell = obj.children.item(0).children.item(0).children.item(0).children.item(0);
		        previousCell.style.backgroundColor = "lightblue";
				
				
		        // 현재 선택된 cell (id='tdXXX')
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
		        for (var i=0; i<tblObject.getElementsByTagName("tr").length; i++)
		        {
		            try{
		                compareHeight = tblObject.getElementsByTagName("tr").item(i).style.height.replace("px", "");
						
		                if (compareHeight != "")
		                {
		                    if (parseInt(compareHeight, 10) > maxHeight)
		                        maxHeight = parseInt(compareHeight, 10);
		                }
					
		            } catch (e) {}
		        }
				

		        if (cell.children.item(0).children.item(0).children.item(0).children.item(0).textContent == "*")
		            document.getElementById("txtWidth").value = "*";
		        else
		            document.getElementById("txtWidth").value = cell.style.width.replace("px", "");

		        
		        document.getElementById("txtHeight").value = maxHeight;
				
		        bCanModify = true;
		        document.getElementById("txtWidth").disabled = false;
		        document.getElementById("txtHeight").disabled = false;
				
		        // 메인테이블이 수정되는 경우를 고려
		        if (document.getElementById("txtWidth").value == "" || document.getElementById("txtWidth").value == "100%")
		        {
		            document.getElementById("txtWidth").value = "*";
					
		            // 메인테이블을 제외하고 테이블 너비 조정불가
		            //if (tblObject.id != "main_table")
		            //    document.getElementById("txtWidth").disabled = true;
		        }
				
		        // 상속받은 페이지인 경우 테이블 사이즈 조정 불가
		        if (parentpageid.toLowerCase() != "top")
		        {
		            if (typeof(tblObject.parentElement.ownerpageuid) == "undefined" || tblObject.parentElement.ownerpageuid != pageid)
		            {
		                document.getElementById("txtWidth").disabled = true;
		                document.getElementById("txtHeight").disabled = true;
		                bCanModify = false;
		            }
		        }
				
		        // 선택한 개체의 종류
		        selObjClass = "TABLE";
		    } catch (e) {}

        }

		function selectsubcell(e) {
		    var Event = e ? e : window.event;
		    var eventItem = Event.target ? Event.target : Event.srcElement;

			//var eventItem = event.srcElement;

			if (eventItem.getAttribute("id") == "") 
			{
				eventItem = eventItem.parentElement;
			}
			
			selectedSubCell = eventItem.getAttribute("id");
			try
			{
				if (previousSubCell != null) previousSubCell.parentElement.style.backgroundColor = "white";
			} catch(e) {}

			if (selectedSubCell.substr(0,2).toLowerCase() != "su") 
			{
				selectedSubCell = "";
				return;
			}
			
			eventItem.parentElement.style.backgroundColor = "#FFDEB5";
			previousSubCell = eventItem;
			
			// 초기화
			bCanModify = true;
			document.getElementById("txtWidth").disabled = false;
			document.getElementById("txtHeight").disabled = false;
			
			var cell = eval(selectedSubCell);
			var curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));
			document.getElementById("txtHeight").value = curHeight;
			
			// 컨텐츠 선택시는 너비 입력필드를 disabled
			document.getElementById("txtWidth").value = "*";
			document.getElementById("txtWidth").disabled = true;
			
			// 상속받은 페이지인 경우 테이블 사이즈 조정 불가
			if (cell.getAttribute("ownerpageuid") != pageid)
			{
				document.getElementById("txtHeight").disabled = true;
				bCanModify = false;
			}
			
			// 선택한 개체의 종류
			selObjClass = "CONTENTS";
		}

		function cellkeydown(e)
		{
			// 최상위 페이지에서만 동작하도록 수정
			// 상속받은 페이지에서는 동작안함
			if (parentpageid.toLowerCase() == "top")
			{
				if (!e.ctrlKey)
				{
					switch(e.keyCode)
					{
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
				}
				else
				{
					switch(e.keyCode)
					{
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
		}

		function GetPageID(pCell)
		{
		    if (typeof(pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid")) != "undefined") return pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid");
			else return pageid;
		}

		    // 포틀릿 추가
		var portlet_search_dialogArguments = new Array();
		function insertrow()
		{
			var pGubunFlag = "";
			
			// 페이지가 저장되지 않은 경우 selectbox의 값을 할당한다.
			if (gubunFlag == "")
				pGubunFlag = portal_gubun.value;
			else
				pGubunFlag = gubunFlag;
			
			if (selectedCell == "")
			{
				alert("<spring:message code='ezPortal.t362'/>");
				return;
			}
			
			if (eval(selectedCell).children.item(0).children.item(0).children.length > 9)
			{
				alert("<spring:message code='ezPortal.t292'/>");
				return;
			}
		    if (CrossYN()) {
		        portlet_search_dialogArguments[0] = pGubunFlag;
		        portlet_search_dialogArguments[1] = insertrow_Complete;
		        var OpenWin = window.open("/ezPortal/portletSearch.do", "portlet_search", GetOpenWindowfeature(350, 410));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    else {
		        var ret = window.showModalDialog("/ezPortal/portletSearch.do", pGubunFlag, "dialogHeight:410px; dialogWidth:350px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(350, 410));
		        if (typeof (ret) == "undefined") return;

		        if (CheckDuplicate(ret[0])) {
		            alert("<spring:message code='ezPortal.t293'/>");
		            return;
		        }
		        var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
		        newrow.style.width = "100%";
		        newrow.style.height = ret[2];
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

			
		}
		    function insertrow_Complete(ret) {
		        if (typeof (ret) == "undefined") return;

		        if (CheckDuplicate(ret[0])) {
		            alert("<spring:message code='ezPortal.t293'/>");
		            return;
		        }
                var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
                newrow.style.width = "100%";
                newrow.style.height = ret[2];
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

		function insertcell()
		{
			if (!bCanModify)
			{
				alert("<spring:message code='ezPortal.t294'/>");
				return;
			}
			
			if (bInherit)
			{
				alert("<spring:message code='ezPortal.t294'/>");
				return;
			}
			
			if (selectedCell == "")
			{
				alert("<spring:message code='ezPortal.t295'/>");
				return;
			}
			
			// 선택된 cell의 table
			var tblObject = eval(GetMainTable(eval(selectedCell)));
			
			if (typeof(tblObject) == "undefined")
				return;
			
			// 상속받은 페이지인 경우 열을 추가할 수 없도록 체크
			if (parentpageid.toLowerCase() != "top")
			{
				if (typeof(tblObject.parentElement.ownerpageuid) == "undefined" || tblObject.parentElement.ownerpageuid != pageid)
				{
					alert("<spring:message code='ezPortal.t294'/>");
					return;
				}
			}
			
			var newcell = document.createElement("td");
			var row = eval(selectedCell).parentElement;
			row.insertBefore(newcell, eval(selectedCell));
			
			newcell.style.width = "100px";
			newcell.vAlign = "top";
			newcell.innerHTML = "<table border=1 cellpadding=0 cellspacing=0 width=100% valign=top><tbody><TR style='WIDTH: 100%; HEIGHT: 10px' onclick=\"selectcellTitle(event)\"><td align=center>100px</td></TR></tbody></table>";
			newcell.id = "td" + GetID();
			newcell.setAttribute("onclick", "selectcell(event)");
			newcell.setAttribute("onkeydown", "cellkeydown(event)");
			//newcell.onclick = function() { selectcell(event); }
			//newcell.onkeydown = cellkeydown;
			selectedSubCell = "";
		}

		function removecell()
		{
			if (!bCanModify)
			{
				alert("<spring:message code='ezPortal.t296'/>");
				return;
			}
			
			if (bInherit)
			{
				alert("<spring:message code='ezPortal.t296'/>");
				return;
			}

			if (selectedCell == "")
			{	
				alert("<spring:message code='ezPortal.t297'/>");
				return;
			}
			
			// 선택된 cell의 table
			var tblObject = eval(GetMainTable(eval(selectedCell)));
			
			if (typeof(tblObject) == "undefined")
				return;
			
			// 상속받은 페이지인 경우 열을 삭제할 수 없도록 체크
			if (parentpageid.toLowerCase() != "top")
			{
				if (typeof(tblObject.parentElement.ownerpageuid) == "undefined" || tblObject.parentElement.ownerpageuid != pageid)
				{
					alert("<spring:message code='ezPortal.t296'/>");
					return;
				}
			}
			
			if (selectedCell == "td0") return;
			
			if (selectedCell.substr(0,3) == "td0")
			{
				if (confirm("<spring:message code='ezPortal.t298'/>"))
				{
					eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.removeChild(eval(selectedCell).parentElement.parentElement.parentElement.parentElement.parentElement);
					selectedCell = "";
					selectedSubCell = "";
				}
				return;
			}
			
			var row = eval(selectedCell).parentElement;
			
			for (var i=0; i<row.children.length; i++)
			{
				if (row.children.item(i).id == selectedCell)
				{
					row.removeChild(row.children.item(i));
					break;
				}
			}
			selectedCell = "";
			selectedSubCell = "";
		}

		function removerow()
		{
			if (selectedSubCell == "")
			{	
				alert("<spring:message code='ezPortal.t299'/>");
				return;
			}

			var cell = eval(selectedSubCell);
			
			if (cell.getAttribute("canremove") != 1)
			{
				alert("<spring:message code='ezPortal.t300'/>");
				return;
			}
			
			// Root페이지가 아니고 필수 포틀릿인 경우
		    if (cell.getAttribute("ownerpageuid") != pageid && cell.getAttribute("mandatory") == "1")
			{
				alert("<spring:message code='ezPortal.t301'/>");
				//event.cancelBubble = true;
				return;
			}
			
			// 상속페이지에서 Root페이지의 옵션 포틀릿인 경우 삭제대상 정보를 저장
		    if (parentpageid.toLowerCase() != "top" && cell.getAttribute("ownerpageuid") != pageid && cell.getAttribute("mandatory") == "2")
			{
		        g_XML += "<ROW>" + "<UID>" + cell.getAttribute('uid') + "</UID>" + "<PAGEUID>" + cell.getAttribute('pageuid') + "</PAGEUID>" +
				         "<OWNERPAGEUID>" + cell.getAttribute('ownerpageuid') + "</OWNERPAGEUID>" +
				         "<USERPAGEUID>" + pageid + "</USERPAGEUID>" +
				         "<CHANGEFLAG>2</CHANGEFLAG>" + "</ROW>";
			}
			
			cell.parentElement.parentElement.removeChild(cell.parentElement);
			selectedSubCell = "";
			selectedCell = "";
		}

		function swaprow(pDirection)
		{
			if (selectedSubCell == "")
			{	
				alert("<spring:message code='ezPortal.t302'/>");
				event.cancelBubble = true;
				return;
			}

			var cell = eval(selectedSubCell);
			if (cell.getAttribute("canreplace") != 1)
			{
				alert("<spring:message code='ezPortal.t303'/>");
				return;
			}

			// 상속페이지는 위치변경 불가능
		    if (cell.getAttribute("ownerpageuid") != pageid)
			{
				
				// 상속페이지에서 Root페이지의 옵션 포틀릿인 경우 삭제대상 정보를 저장
		        if (parentpageid.toLowerCase() != "top" && cell.getAttribute("ownerpageuid") != pageid && cell.getAttribute("mandatory") == "2")
				{
		            g_XML += "<ROW>" + "<UID>" + cell.getAttribute("uid") + "</UID>" + "<PAGEUID>" + cell.getAttribute("pageuid") + "</PAGEUID>" +
							"<OWNERPAGEUID>" + cell.getAttribute("ownerpageuid") + "</OWNERPAGEUID>" +
							"<USERPAGEUID>" + pageid + "</USERPAGEUID>" +
							"<CHANGEFLAG>2</CHANGEFLAG>" + "</ROW>";
					
//		            cell.getAttribute("ownerpageuid") = pageid;
				}
			}
			
			var obj = null;
			
			if (pDirection == "up")
			{
			    if (getPreviousSibling(cell.parentElement.previousSibling) == null || getPreviousSibling(cell.parentElement.previousSibling).children.item(0).getAttribute("id") == "") 
				{
					if (cell.pageuid == pageid) return;
			        try {
			                //2013-01-21
							obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("beforeBegin", cell.parentElement);
//							obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
					} catch(e) { return; }
				}
				else 
				{
			        if (getPreviousSibling(cell.parentElement.previousSibling).outerHTML.toLowerCase().indexOf("table") > -1)
					{
						try {
						    obj = getPreviousSibling(cell.parentElement.previousSibling).children.item(0).children.item(0).children.item(0).children.item(0).lastChild.children.item(0).children.item(0).insertAdjacentElement("beforeEnd", cell.parentElement);
//						    obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
						} catch(e) { return; }
					}
					else
					{
						//cell.parentElement.swapNode(cell.parentElement.previousSibling);
			            swapNodes(cell.parentElement, getPreviousSibling(cell.parentElement.previousSibling));
					}
				}
			}	
			else if (pDirection == "down")
			{
			    if (getNextSibling(cell.parentElement.nextSibling) == null || getNextSibling(cell.parentElement.nextSibling).children.item(0).getAttribute("id") == "")
				{
					if (cell.pageuid == pageid) return;
			        try {
                            //2013-01-21
							obj = cell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.insertAdjacentElement("afterEnd", cell.parentElement);
//							obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
					} catch(e) { return; }
				}
				else
			    {
			        if (getNextSibling(cell.parentElement.nextSibling).outerHTML.toLowerCase().indexOf("table") > -1)
					{
						try {
						    obj = getNextSibling(cell.parentElement.nextSibling).children.item(0).children.item(0).children.item(0).children.item(0).firstChild.children.item(0).children.item(0).firstChild.insertAdjacentElement("afterEnd", cell.parentElement);
//							obj.children.item(0).getAttribute("pageuid") = GetPageID(obj.children.item(0));
						} catch(e) { return; }
					}
					else
					{
					    //cell.parentElement.swapNode(cell.parentElement.nextSibling);
			            swapNodes(cell.parentElement, getNextSibling(cell.parentElement.nextSibling));
					}

				}
			}
			else if (pDirection == "left")
			{
			    if (getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling) == null) return;
				
			    if (getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling).children.item(0).children.item(0).children.length > 9)
				{
					alert("<spring:message code='ezPortal.t292'/>");
					return;
				}
			    getPreviousSibling(cell.parentElement.parentElement.parentElement.parentElement.previousSibling).children.item(0).children.item(0).appendChild(cell.parentElement);
			}
			else if (pDirection == "right")
			{
			    if (getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling) == null) return;
			
			    if (getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling).children.item(0).children.item(0).children.length > 9)
				{
					alert("<spring:message code='ezPortal.t292'/>");
					return;
				}
			    getNextSibling(cell.parentElement.parentElement.parentElement.parentElement.nextSibling).children.item(0).children.item(0).appendChild(cell.parentElement);
			}
			cell.focus();
		}
            //크로스용 함수 추가
		function swapNodes(item1,item2){ 
		    var itemtmp = item1.cloneNode(1); 
		    var parent = item1.parentNode; 
		    item2 = parent.replaceChild(itemtmp,item2); 
		    parent.replaceChild(item2,item1); 
		    parent.replaceChild(item1,itemtmp); 
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
		function resizecell(pDirection)
		{
			if (selectedCell == "")
			{	
				alert("<spring:message code='ezPortal.t302'/>");
				return;
			}
			
			if (bInherit)
			{
				alert("<spring:message code='ezPortal.t305'/>");
				event.cancelBubble = true;
				return;
			}

			var cell = eval(selectedCell);
			
			var curWidth = parseInt(cell.style.width.replace("px", ""));
			
			if (pDirection == "right")
			{
				curWidth += 2;
				try {
					cell.style.width = curWidth.toString();
					cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
				} catch(e) {}
			}	
			else if (pDirection == "left")
			{
				curWidth -= 2;
				try {
					cell.style.width = curWidth.toString();
					cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = curWidth.toString() + "px"; 
				} catch(e) {}
			}
		}

		function resizerow(pDirection)
		{
			if (selectedSubCell == "")
			{	
				alert("<spring:message code='ezPortal.t306'/>");
				return;
			}

			var cell = eval(selectedSubCell);
			
			if (cell.getAttribute("canresize") != 1)
			{
				alert("<spring:message code='ezPortal.t307'/>");
				return;
			}
			
			if (cell.ownerpageuid != pageid)
			{
				alert("<spring:message code='ezPortal.t308'/>");
				event.cancelBubble = true;
				return;
			}
			
			var curHeight = parseInt(cell.parentElement.style.height.replace("px", ""));

			if (pDirection == "up")
			{
				curHeight += 1;
				try {
					cell.parentElement.style.height = curHeight.toString();
				} catch(e) {}
			}	
			else if (pDirection == "down")
			{
				curHeight -= 1;
				try {
					cell.parentElement.style.height = curHeight.toString();
				} catch(e) {}
			}
		}


		function GetMainTable(pCell)
		{
			try {
				return pCell.parentElement.parentElement.parentElement.id;
			} catch (e) {}
		}

		function resizepage(pDirection)
		{
			if (selectedCell == "")
			{
				alert("<spring:message code='ezPortal.t311'/>");
				return;
			}
			
			var tblObject = eval(GetMainTable(eval(selectedCell)));
			
			if (bInherit)
			{
				alert("<spring:message code='ezPortal.t305'/>");
				return;
			}

			if (tblObject.width == "100%" && (pDirection == "left" || pDirection == "right"))
			{
				alert("<spring:message code='ezPortal.t309'/>");
				return;
			}
			if (tblObject.height == "100%" && (pDirection == "up" || pDirection == "down"))
			{
				alert("<spring:message code='ezPortal.t310'/>");
				return;
			}

			try
			{
				if (pDirection == "left")
				{
					tblObject.width = parseInt(tblObject.width.toString().replace("px", "")) - 10;
					document.getElementById("txtWidth").value = tblObject.width.toString();
				}
				if (pDirection == "right")
				{
					tblObject.width = parseInt(tblObject.width.toString().replace("px", "")) + 10;
					document.getElementById("txtWidth").value = tblObject.width.toString();
				}
				if (pDirection == "down")
				{
					tblObject.height = parseInt(tblObject.height.toString().replace("px", "")) + 10;
					tblObject.parentElement.parentElement.style.height = tblObject.height;
					document.getElementById("txtHeight").value = tblObject.height.toString();
				}
				if (pDirection == "up")
				{
					tblObject.height = parseInt(tblObject.height.toString().replace("px", "")) - 10;
					tblObject.parentElement.parentElement.style.height = tblObject.height;
					document.getElementById("txtHeight").value = tblObject.height.toString();
				}
			} catch(e) {}
			
		}


		function S4() {
		    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		}
		function GetGUID() {
		    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		}
		function GetID()
		{
			return count++;
		}

		function preview()
		{
			window.open("/ezPortal/portalPage.do?mode=view&viewMode=preview&pageID=" + pageid + "&pClassID=" + g_ClassID + "&pClassName=" + g_ClassName);
		}

		function OpenMaxURL(pURL)
		{
			if (pURL == "") return;	
			location.href = pURL;
		}

		function insertpage()
		{
			if (selectedCell == "")
			{
				alert("<spring:message code='ezPortal.t312'/>");
				return;
			}
			
			if (eval(selectedCell).children.item(0).children.item(0).children.length > 9)
			{
				alert("<spring:message code='ezPortal.t292'/>");
				return;
			}
			
			var strHTML = "<table id='main_table_" + GetGUID().substr(0,4) + "' border=1 cellpadding=0 cellspacing=0 width=100% height=110px style='table-layout:fixed;'>";
			strHTML += "<tr id='main_row'>";
			strHTML += "<TD id='td0" + GetGUID().substr(0,3) + "' vAlign=top><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>";
			strHTML += "<TBODY><TR style='WIDTH: 100%; HEIGHT: 10px' onclick=\"selectcellTitle(event)\"><td align=center>*</td></TR></tbody>";
			strHTML += "</table></td></tr></table>";

			//alert(eval(selectedCell).children[0].children[0].children.length);
			var newrow = eval(selectedCell).children.item(0).children.item(0).insertRow(eval(selectedCell).children[0].children[0].children.length);
			newrow.style.width = "100%";
			newrow.style.height = "100";
			var subGetId = "subtd" + GetID();
			var strInnerHTML = "<td id=\"" + subGetId + "\"uid=\""+GetGUID()+"\" style=\"width:100%\" pageuid='"+GetGUID()+"' ownerpageuid='"+pageid+"' align=\"center\" onclick=\"selectsubcell(event)\" ondblclick=\"dblclicknotice()\" onkeydown=\"cellkeydown(event)\" canremove=\"1\"  canresize=\"1\"  canreplace=\"1\">"+strHTML+"</td>";
			newrow.innerHTML = strInnerHTML;

			//var newcell = newrow.insertCell();
			//newcell.id = "subtd" + GetID();
			//newcell.uid = GetGUID();
			//newcell.pageuid = GetGUID();
			//newcell.ownerpageuid = pageid;
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

		function newpage()
		{
			location.href = "PortalPage.aspx";
		}

		function layoutmode()
		{
		    for (var i=0; i<document.getElementsByTagName("tr").length; i++)
			{
		        var evtHandler = document.getElementsByTagName("tr").item(i).onclick;
				if (evtHandler != null && evtHandler.toString().indexOf("selectcellTitle") > -1)
				{
				    document.getElementsByTagName("tr").item(i).style.display = "none";
				}
		    }
		    document.getElementById("btn_mode").innerHTML = "<spring:message code='ezPortal.t323'/>";
		    document.getElementById("btn_mode").onclick = editingmode;
		}

		function editingmode()
		{
		    for (var i=0; i<document.getElementsByTagName("tr").length; i++)
			{
		        var evtHandler = document.getElementsByTagName("tr").item(i).onclick;
				if (evtHandler != null && evtHandler.toString().indexOf("selectcellTitle") > -1)
				{
				    document.getElementsByTagName("tr").item(i).style.display = "";
				}
		    }
		    document.getElementById("btn_mode").innerHTML = "<spring:message code='ezPortal.t322'/>";
		    document.getElementById("btn_mode").onclick = layoutmode;
		}
		
		function PageSizeChange()
		{
			main_table.width = document.getElementById("txtWidth").value + "px";
			main_table.height = document.getElementById("txtHeight").value + "px";
		}

		function ACLEdit()
		{
		    if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1)
		        window.open("/ezPortal/portalPageACL.do?uID=" + pageid, "", "height = 620px, width = 600px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(600, 620));
		    else
		        window.open("/ezPortal/portalPageACL.do?uID=" + pageid, "", "height = 620px, width = 600px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(600, 620));
		}
		
		// 테이블 크기 조정
		function resizeTable()
		{
			if (!bCanModify)
			{
				alert("<spring:message code='ezPortal.t313'/>");
				return;
			}
			
			if (selObjClass == "TABLE")
			{
				if (selectedCell == "")
				{
					alert("<spring:message code='ezPortal.t314'/>");
					return;
				}
				
				var tblObject = eval(GetMainTable(eval(selectedCell)));
				
				if (typeof(tblObject) == "undefined")
					return;
				
				// 현재 선택된 cell
				var cell = eval(selectedCell);
				
				// 메인테이블 - 너비에 *를 설정한 경우
				if (tblObject.id == "main_table" && document.getElementById("txtWidth").value == "*")
				{
					tblObject.width = "100%";
					
					cell.style.width = "100%";
					cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = "*";
				}
				
				if (document.getElementById("txtWidth").value != "*" && document.getElementById("txtWidth").value != "")
				{
					if (!is_num(document.getElementById("txtWidth").value))
					{
						alert("<spring:message code='ezPortal.t315'/>");
						return;
					}
					
					// 메인테이블이 수정되는 경우를 고려
					if (tblObject.id == "main_table")
						tblObject.width = document.getElementById("txtWidth").value;
					
					cell.style.width = document.getElementById("txtWidth").value + "px";
					cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = document.getElementById("txtWidth").value + "px";
					
				}
				else if (document.getElementById("txtWidth").value == "*") {
				    if (tblObject.id == "main_table")
				        tblObject.width = document.getElementById("txtWidth").value;

				    cell.style.width = "";
				    cell.children.item(0).children.item(0).children.item(0).children.item(0).innerHTML = "*";
				}
				
				if (!is_num(document.getElementById("txtHeight").value))
				{
					alert("<spring:message code='ezPortal.t316'/>");
					return;
				}
				tblObject.height = document.getElementById("txtHeight").value;
				tblObject.parentElement.parentElement.style.height = document.getElementById("txtHeight").value;
			}
			else if (selObjClass == "CONTENTS")
			{
				if (selectedSubCell == "")
				{	
					alert("<spring:message code='ezPortal.t306'/>");
					return;
				}

				var cell = eval(selectedSubCell);
				
				if (cell.getAttribute("canresize") != 1)
				{
					alert("<spring:message code='ezPortal.t317'/>");
					return;
				}
				
				try {
					cell.parentElement.style.height = document.getElementById("txtHeight").value;
				} catch(e) { alert }
			}
			else
			{
				alert("<spring:message code='ezPortal.t318'/>");
			}
			
			event.cancelBubble = true;
		}
		
		// 초기화_관리자edit 2007-09-12
		function ResetPortalPage()
		{
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "admin/edit/ResetPortalPage.aspx?Pageid=" + pageid + "&ComapnyID=" + g_CompanyID + "&BaseType=" +g_BaseType, false);
			xmlhttp.send();
		  if (xmlhttp.responseText == "OK")
		  {
		     //새로 고침 _ 현재의 PAGEID로 
		     alert("<spring:message code='ezPortal.t408'/>") ;
		     location.href = "/ezportal/portalPage.do?mode=edit&pageID="+pageid;
		  }
		  else
		  {
		      alert("<spring:message code='ezPortal.t319'/>" + + xmlhttp.responseText) ;
		  }
		  
		  xmlhttp = null;
		}
		
		
		// 초기화_Myportalpage 
		function DeletePortalPage()
		{
			if (parentpageid.toLowerCase() == "top")
				return;
			
			if (confirm("<spring:message code='ezPortal.t320'/>"))
			{
				// 상속페이지인 경우 자신의 캐쉬정보를 바로 삭제한다.
				if (parentpageid.toLowerCase() != "top")
				{
					DeleteCache();
				}
				
				var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "admin/edit/DeletePortalPage.aspx", false);
				xmlhttp.send("<DATA><UID>" + pageid + "</UID></DATA>");
				
				if (xmlhttp.responseText == "OK")
				{
					// 부문포탈, 마이포탈
					alert("<spring:message code='ezPortal.t408'/>") ;
					


				    document.location.href = "/ezPortal/myPortalPageList.do";
					//if (g_ClassID != "")
					//	location.href = "/myoffice/ezportal/myclassportal.aspx?mode=edit&pClassID=" + g_ClassID + "&pClassName=" + g_ClassName;
					//else
    				//	location.href = "/myoffice/ezportal/myportal.aspx?mode=edit&ResetMyParentpageid="+parentpageid;
					
				}
				else
					alert("<spring:message code='ezPortal.t239'/>" + xmlhttp.responseText);
				
				xmlhttp = null;
			}
		}
		
		// 캐쉬삭제
		function DeleteCache()
		{
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "admin/remote/portal_DeleteCache.aspx", "false");
			xmlhttp.send("<DATA><UID>" + pageid + "</UID></DATA>");
			xmlhttp = null;
		}
		var OpenFlag = false;
		function hiddenQuick() {
		    if (!OpenFlag) {
		        document.getElementById("btn_quick_Up").style.display = "none";
		        document.getElementById("QuickUl").style.display = "none";
		        document.getElementById("btn_quick_Down").style.display = "none";
		        document.getElementById("btn_hidden").src = "/images/kr/main/quickmenu_title_hidden.gif";
		        OpenFlag = true;
		    }
		    else {
		        document.getElementById("btn_quick_Up").style.display = "block";
		        document.getElementById("QuickUl").style.display = "block";
		        document.getElementById("btn_quick_Down").style.display = "block";
		        document.getElementById("btn_hidden").src = "/images/kr/main/quickmenu_title.gif";
		        OpenFlag = false;
		    }
		}
    	</script>
    </head>	
    <% if (!mode.equals("view")) { %>
	<body <%if (!mode.equals("view")){%>class="mainbody"<%}else{ %>  class="mainbg"  <%} %> style="OVERFLOW:hidden">		
		<h1><spring:message code='ezPortal.t321'/></h1>
		<div id="mainmenu">
			<ul>
  				<li><span onClick="layoutmode()" id="btn_mode"><spring:message code='ezPortal.t322'/></span></li>
  				<li><span onClick="preview()"><spring:message code='ezPortal.t63'/></span></li>
				<% if (parentPageID.equals("top")) { %>
  					<li><span onClick="ACLEdit()"><spring:message code='ezPortal.t87'/></span></li>
  					<li style="display:none"><span onClick="inherit()"><spring:message code='ezPortal.t324'/></span></li>
				<% } %>
				<li><span onClick="insertpage()"><spring:message code='ezPortal.t325'/></span></li>
				<li><span onClick="removecell()"><spring:message code='ezPortal.t326'/></span></li>
  				<li><span onClick="insertcell()"><spring:message code='ezPortal.t327'/></span></li>
  				<li><span onClick="removecell()"><spring:message code='ezPortal.t328'/></span></li>
  				<li><span onClick="insertrow()"><spring:message code='ezPortal.t329'/></span></li>
  				<li><span onClick="removerow()"><spring:message code='ezPortal.t330'/></span></li>
  				<li><span onClick="swaprow('up')"><spring:message code='ezPortal.t331'/></span></li>
  				<li><span onClick="swaprow('down')"><spring:message code='ezPortal.t332'/></span></li>
  				<li><span onClick="swaprow('left')"><spring:message code='ezPortal.t72'/></span></li>
  				<li><span onClick="swaprow('right')"><spring:message code='ezPortal.t74'/></span></li>
				
  				<% if ((baseType != null && baseType.trim().toString().equals("1")) || (baseType != null && baseType.trim().toString().equals("2"))) { %>
  					<!-- 상속페이지에서만 display -->
  					<li><span onClick="ResetPortalPage()"><spring:message code='ezPortal.t333'/></span></li>
  				<% } %>
  				<% if (!parentPageID.equals("top")) { %>
  					<!-- 상속페이지에서만 display -->
  					<li><span onClick="DeletePortalPage()"><spring:message code='ezPortal.t333'/></span></li>
  				<% } %>
			</ul>
		</div>			
		<table id="table_displayname" class="popuplist" width="820">
			<tr >
				<th width="80" style="display:none"><spring:message code='ezPortal.t255'/></th>
				<td style="display:none">									
					<select name="portal_gubun" id="portal_gubun">
					</select>
				</td>
				<th width="100"><spring:message code='ezPortal.t256'/></th>
				<td> 
					<table style="width:100%;">
                    	<tr class="primary">
                        	<th style="width:80px;">${langPrimary}</th>
                                            <td><input type="text" id="txtDisplayName" value="${displayName}" style="width:99%;"></td>	
                                        </tr>
                                        <tr class="secondary">
                                            <th style="width:80px;">${langSecondary}</th>
                                            <td><input type="text" id="txtDisplayName2" value="${displayName2}" style="width:99%;"></td>	
                                        </tr>
                                    </table>
								</td>
							</tr>
						</table>

						<table width="820" class="box">
							<tr>
							  <td height="30" bgcolor="#F5f5f5">&nbsp;<spring:message code='ezPortal.t334'/><input type="text" name="txtWidth" id="txtWidth" style="WIDTH:50px">
									px * <spring:message code='ezPortal.t335'/><input type="text" name="txtHeight" id="txtHeight" style="WIDTH:50px"> px <a class="imgbtn"><span onClick="resizeTable()"><spring:message code='ezPortal.t336'/></span></a></td>
                              <td bgcolor="#F5f5f5" ><spring:message code='ezPortal.t990022'/>:</td>
                              <td bgcolor="#F5f5f5">
                                  <select id="Themeinfo">
                                      ${pThemeSelectObject}
                                  </select>
                              </td>
                                <td bgcolor="#F5f5f5" >페이지 보기옵션</td>
                              <td bgcolor="#F5f5f5">
                                  <select id="Optioninfo">
                                      <option value="D" selected>
                                          div(가로)
                                      </option>
                                      <option value="T">
                                          Table(세로)
                                      </option>
                                  </select>
                              </td>
							</tr>
                            <tr height="20">
                                <td bgcolor="#F5f5f5" colspan="5">&nbsp;넓이를 * 입력 시 100%로 저장됩니다.</td>
                            </tr>
						</table>
        <table class="box" style="height:600px;">
            <tr>
                <td id="td_mainframe" style="width:820px;HEIGHT:600px" valign="top">			
                    <div id="main_div" style="OVERFLOW:auto;width:820px;HEIGHT:100%">
                    	${strHTML}
                    </div>			
                </td>
            </tr>
        </table>
	  <div class="btnposition" style="width:820px;">
          <a class="imgbtn"><span  onClick="save()"><spring:message code='ezPortal.t62'/></span></a>
      </div>
	<br><br>
	</body>
	
	<% } else { %>
	<body class="mainbg">        
		${strHTML}
	</body>
	<% } %>
     <% if (mode.equals("view")) { %>
    <aside style="position:fixed;">
    <p class="quickmenu_title"><img src="/images/kr/main/quickmenu_title.gif" width="70" height="31" onclick="hiddenQuick()" id="btn_hidden"></p>
    <p class="btn_quick" id="btn_quick_Up" onclick="QuickMove('UP')"><img src="/images/kr/main/quickmenu_btn_up.gif" ></p>
    <ul class="quickmenu" id="QuickUl">
     </ul>
	<p class="btn_quick" id="btn_quick_Down" onclick="QuickMove('DOWN')"><img src="/images/kr/main/quickmenu_btn_down.gif" ></p>
    </aside>
    <%} %>

</html>