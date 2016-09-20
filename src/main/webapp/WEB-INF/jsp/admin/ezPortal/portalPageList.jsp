<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>portalpage_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript">
		var g_SelectedObj = null;
		var g_UID = "";
		var g_GubunFlag = "";
		var g_UseFlag = "";
		var g_SearchString = "${pSearchString}";
		var g_PortalGubun = "${portalGubun}";
		var g_intPage  = "${intPage}";
		var g_totalPage= "${totalPage}";
		var pDefaultPageUID = "${defaultPageUID}";
		<%
			int intPage = (request.getParameter("intPage") != null && !request.getParameter("intPage").equals(""))?Integer.parseInt(request.getParameter("intPage")) : 0;
			int totalPage = (request.getParameter("totalPage") != null && !request.getParameter("totalPage").equals(""))?Integer.parseInt(request.getParameter("totalPage")) : 0;
		%>	
		
		document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
		};
		
		function window_onload() {
		}
		
		function setValue(pUID, pGubunFG, pUseFG, pObj)
		{
			g_UID = pUID;
			g_GubunFlag = pGubunFG;
			g_UseFlag = pUseFG;
			
			// 선택된 개체가 없는 경우
			if( g_SelectedObj == null )
			{
			    pObj.style.backgroundColor = "#DBE1E7";
				g_SelectedObj = pObj;
			}
			else
			{
			    pObj.style.backgroundColor = "#DBE1E7";
				
				if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
				g_SelectedObj = pObj;
			}
		}
		function selectItem(pUID, pObj)
		{
		    if(navigator.userAgent.indexOf("MSIE") != -1)
		        location.href = "/ezPortal/portalPage.do?mode=edit&pageID=" + pUID;
		    else
		        location.href = "/ezPortal/portalPage.do?mode=edit&pageID=" + pUID;
		}
		// 새로만들기
		function newpage()
		{
		    if(navigator.userAgent.indexOf("MSIE") != -1)
		        location.href = "/ezPortal/portalPage.do?mode=new";
		    else
		        location.href = "/ezPortal/portalPage.do?mode=new";
		}
		
		// 미리보기
		function preview()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t60'/>");
				return;
			}
			
			window.open("/ezPortal/portalPage.do?mode=view&viewMode=preview&pageID=" + g_UID);
		}
		
		// 검색
		function btnSearch_onClick()
		{
			var pSearchString = TrimText(ReplaceText(SearchString.value, "'", ""));
			
			/*
			if (pSearchString.length < 2)
			{
				alert ("<spring:message code='ezPortal.t233'/>");
				SearchString.focus();
				return false;
			}
			*/
			
			var pSearchGubun = "";
			
			// 전체
			if (PortalGubun.value == "")
			{
				for (var i=0; i<PortalGubun.length; i++)
				{
					if (PortalGubun[i].value != "")
					{
						if (pSearchGubun == "")
							pSearchGubun += "'" + PortalGubun[i].value + "'";
						else
							pSearchGubun += ",'" + PortalGubun[i].value + "'";
					}
				}
			}
			else
			{
				pSearchGubun = "'" + PortalGubun.value + "'";
			}
			
			window.location.href = "/admin/ezPortal/portalpageList.do?pSearchString=" + escape(pSearchString) + "&portalGubun=" + escape(pSearchGubun);
		}
		
		function entercheck()
		{
			if (window.event.keyCode == 13)
				btnSearch_onClick();
		}
		
		// 페이지 이동
		function goToPage( r_value )
		{
			if (r_value == "page")
			{
				var movenum = txt_PageInputNum.value;
				
				if (movenum == "")
				{
					alert("<spring:message code='ezPortal.t234'/>");
					return;
				}
				else if ( !is_num(movenum) )
				{
					alert("0 ~ 9 <spring:message code='ezPortal.t235'/>");
					return;
				}
				else if (parseInt(movenum, 10) > parseInt(g_totalPage, 10))
				{
					alert("<spring:message code='ezPortal.t236'/>" + g_totalPage + ") <spring:message code='ezPortal.t237'/>");
					return;
				}
				
				pageChange(movenum);
			}
			else if (r_value == "front")
			{
				if (g_intPage != "1")
				{
					var prevnum = parseInt(g_intPage) - 1
					pageChange(prevnum);
				}
			}
			else if (r_value == "next")
			{
				if (g_intPage != g_totalPage)
				{
					var nextnum = parseInt(g_intPage) + 1
					pageChange(nextnum);
				}
			}
		}
		
		// 페이지 이동
		function pageChange(p_intPage)
		{
			window.location.href = "/admin/ezPortal/portalpageList.do?pSearchString=" + escape(g_SearchString) + "&portalGubun=" + escape(g_PortalGubun) + "&intPage=" + p_intPage;
		}
		
		// 삭제
		function DeletePortalPage()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t238'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t54'/>"))
			{
			    var xmlhttp = createXMLHttpRequest();
			    xmlhttp.open("POST", "/admin/ezPortal/deletePortalPage.do", false);
				xmlhttp.send("<DATA><UID>" + g_UID + "</UID></DATA>");
				
				if (xmlhttp.responseText == "OK")
					document.location.reload();
				else
					alert("<spring:message code='ezPortal.t239'/>" + xmlhttp.responseText);
				
				xmlhttp = null;
			}
		}
		
		// 해당 페이지를 사용중으로 설정
		// 같은 GubunFlag를 가진 다른 페이지는 사용안함으로 설정(기존스팩) but 2007-08-28 스팩변경
		// 같은 GubunFlag에서도 다중으로 사용 가능 함 대신 사용취소버튼 추가 함 Outofusepage()
		function usepage()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t240'/>");
				return;
			}
			
			if (g_UseFlag == "Y")
			{
				alert("<spring:message code='ezPortal.t241'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t242'/>")) {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/usePortalPage.do?uID=" + g_UID + "&gubunFlag=" + g_GubunFlag, false);
				xmlhttp.send();
				
				if (xmlhttp.responseText == "OK") {
					alert("<spring:message code='ezPortal.t412'/>");
					document.location.reload();
				} else {
					alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
				}
				xmlhttp = null;
			}
		}
		
		
	     function Outofusepage() {
	           if (g_UID == "") { 
	            alert("<spring:message code='ezPortal.t244'/>");
	            return;
	           }
        	   
	           if (g_UseFlag == "") {
	            alert("<spring:message code='ezPortal.t245'/>");
	            return;
	           }
        	   
	           if (confirm("<spring:message code='ezPortal.t246'/>")) {
	               var xmlhttp = createXMLHttpRequest();
	                  xmlhttp.open("POST", "/admin/ezPortal/outOfUsePortalPage.do?uID=" + g_UID + "&gubunFlag=" + g_GubunFlag, false);
	                  xmlhttp.send();
            	      
	                  if (xmlhttp.responseText =="OK")
	                  {
						alert("<spring:message code='ezPortal.t413'/>");
	                     document.location.reload();
	                     
	                    }
	                  else
	                  {
	                    alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
	                    }
            	        
	                    xmlhttp = null;
	           }
	     }
		    function DefaultPageSet()
		    {
		        if (g_UID == "")
		        {
		            alert("<spring:message code='ezPortal.t240'/>");
		            return;
		        }
			
		        if (g_UseFlag == "Y")
		        {
		            alert("<spring:message code='ezPortal.t241'/>");
		            return;
		        }
			
		        if (confirm("<spring:message code='ezPortal.t242'/>"))
		        {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/admin/ezPortal/usePortalPage.do?uID=" + g_UID + "&gubunFlag=" + g_GubunFlag, false);
		            xmlhttp.send();
				
		            if (xmlhttp.responseText == "OK")
		            {
		                alert("<spring:message code='ezPortal.t412'/>");
		                document.location.reload();
		            }
		            else
		            {
		                alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
		            }
				
		            xmlhttp = null;
		        }
		    }
		    function DefaultPageSet(pGubun)
		    {
		        if (g_UID == "")
		        {
		            alert("<spring:message code='ezPortal.t240'/>");
		            return;
		        }

		        if(g_UID != pDefaultPageUID && pDefaultPageUID !="")
		        {
		            alert("<spring:message code='ezPortal.t990031'/>");
		            return;
		        }
		        if (confirm(pGubun=="Y"?"<spring:message code='ezPortal.t990020'/>":"<spring:message code='ezPortal.t990021'/>"))
		        {
                    var xmlhttp = createXMLHttpRequest();
                    var xmlpara = createXmlDom();
                    var objNode;
                    objNode = createNodeInsert(xmlpara, objNode, "DATA");
                    createNodeAndInsertText(xmlpara, objNode, "PAGEUID", g_UID);
                    createNodeAndInsertText(xmlpara, objNode, "GUBUNFLAG", g_GubunFlag);
                    createNodeAndInsertText(xmlpara, objNode, "FLAG", pGubun);
                    xmlhttp.open("POST", "/admin/ezPortal/setDefaultPortalPage.do", false);
                    xmlhttp.send(xmlpara);
				
		            if (xmlhttp.responseText == "OK")
		            {
		                alert("<spring:message code='ezPortal.t412'/>");
		                document.location.reload();
		            }
		            else
		            {
		                alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
		            }
				
                    xmlhttp = null;
                }
		    }

		    function ACLEdit()
		    {
		        if(g_UID == "")
		            alert("<spring:message code='ezPortal.t240'/>");
		        else
		            window.open("/ezPortal/portalPageACL.do?uID=" + g_UID, "", "height = 500px, width = 535px, status = no, toolbar=no, menubar=no,location=no, resizable=yes"+GetOpenPosition(535, 500));
		    }
		</script>
	</head>
	<body class="mainbody" onload="javascript:window_onload()">
		<h1><spring:message code='ezPortal.t229'/></h1>
		<div id="mainmenu">
    		<ul>
        		<li><span onclick="newpage()"><spring:message code='ezPortal.t247'/></span></li>
        		<li><span onclick="DeletePortalPage()"><spring:message code='ezPortal.t67'/></span></li>
        		<li><span onclick="preview()"><spring:message code='ezPortal.t63'/></span></li>
        		<li><span onclick="ACLEdit()"><spring:message code='ezPortal.t87'/></span></li>
        		<li><span onclick="usepage()"><spring:message code='ezPortal.t248'/></span></li>
        		<li><span onclick="Outofusepage()"><spring:message code='ezPortal.t249'/></span></li>
        		<li><span onclick="DefaultPageSet('Y')"><spring:message code='ezPortal.t990017'/></span></li>
        		<li><span onclick="DefaultPageSet('N')"><spring:message code='ezPortal.t990018'/></span></li>
    		</ul>
		</div>

		<div class="page"><img src="/images/page_previous.gif" width="15" height="15" align="absmiddle" hspace="2" onClick="goToPage('front')" <% if (intPage != 1) { %>style="cursor:pointer"<% } %>> <spring:message code='ezPortal.t253'/>${totalPage}<spring:message code='ezPortal.t254'/>
  			<input type="text"name="txt_PageInputNum" style="width:30px" value='${intPage}' onKeyPress="if ( window.event.keyCode == 13 ) { goToPage('page'); }">
  			<img src="/images/page_next.gif" width="15" height="15" align="absmiddle" hspace="2" <% if (intPage != totalPage) { %>style="cursor:pointer" onClick="goToPage('next')"<% } %>></div>

			<table class="mainlist" style="width:100%"> 
				<tr>
					<th width="120" style="display:none"><spring:message code='ezPortal.t255'/></th>
					<th><spring:message code='ezPortal.t256'/></th>
            		<th width="100"><spring:message code='ezPortal.t990016'/></th>
            		<th width="150"><spring:message code='ezPortal.t990011'/></th>
					<th width="150"><spring:message code='ezPortal.t257'/></th>
					<th width="150"><spring:message code='ezPortal.t990028'/></th>
				</tr>
			</table>		
			<table class="mainlist" style="width:100%">
<%-- 		<% for (int i=0; i<xmldom.GetElementsByTagName("UID").Count; i++) { %>
		<tr style="cursor:pointer" onClick="setValue('<%= xmldom.GetElementsByTagName("UID").Item(i).InnerText %>', '<%= xmldom.GetElementsByTagName("GUBUNFLAG").Item(i).InnerText %>', '<%= xmldom.GetElementsByTagName("USEFLAG").Item(i).InnerText %>', this)" 
		                        ondblclick="selectItem('<%= xmldom.GetElementsByTagName("UID").Item(i).InnerText %>', this)">
			<td width="120" style="display:none">
			<%
				if (xmldom.GetElementsByTagName("GUBUNFLAG").Item(i).InnerText.IndexOf("c") < 0)
					Response.Write(xmldom.GetElementsByTagName("GUBUNNAME").Item(i).InnerText + "Root");
				else
					Response.Write(xmldom.GetElementsByTagName("GUBUNNAME").Item(i).InnerText);
			%>
			</td>
			<td><% Response.Write(xmldom.GetElementsByTagName("DISPLAYNAME" + GetLangData(userinfo.primary)).Item(i).InnerText); %></td>
            <td width="100">
                <%= xmldom.GetElementsByTagName("DEFAULTPAGE").Item(i).InnerText == null ? "":xmldom.GetElementsByTagName("DEFAULTPAGE").Item(i).InnerText.Trim().Equals("Y")? RM.GetString("t259"):"" %>
            </td>
            <td width="150"><%= xmldom.GetElementsByTagName("THEMENM" + GetLangData(userinfo.primary)).Item(i).InnerText%></td>
			<td width="130"> <% if (xmldom.GetElementsByTagName("USEFLAG").Item(i).InnerText == "Y") Response.Write(RM.GetString("t259")); %> </td>
			<td width="170"> <% Response.Write(xmldom.GetElementsByTagName("CREATEDATE").Item(i).InnerText); %> </td>
		</tr>
		<% } xmldom = null; %> --%>
			${mainHtml }
		</table>
		<br><br>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
	</body>
</html>