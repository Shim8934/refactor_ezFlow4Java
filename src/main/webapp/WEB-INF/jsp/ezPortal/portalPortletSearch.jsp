<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPortal.t147'/></title>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript">
		var selectedID = "";
	    var selectedDisplayName = "";
	    var selectedHeight = "";
	    var g_PortletCategoryXML = "${porteltCategoryXML}";
			var gubunFlag = "";   // 포탈페이지구분
			var ReturnFunction;
			var RetValue;
			function window_onload() {
			    try {
			        RetValue = parent.portlet_search_dialogArguments[0];
			        ReturnFunction = parent.portlet_search_dialogArguments[1];
			    } catch (e) {
			        try {
			            RetValue = opener.portlet_search_dialogArguments[0];
			            ReturnFunction = opener.portlet_search_dialogArguments[1];
			        } catch (e) {
			            RetValue = window.dialogArguments;
			        }
			    }
			    // 상속받은 포탈페이지에서 포틀릿 추가시 처리
			    gubunFlag = RetValue;
			    gubunFlag = ReplaceText(gubunFlag, "c", "");

			    var xmldom = createXmlDom();

			    if (g_PortletCategoryXML != "") {
			        xmldom = loadXMLString(g_PortletCategoryXML);

			        for (var i = 0; i < xmldom.getElementsByTagName("CATEGORY").length; i++) {
			            var lastindex = document.getElementById("PortalGubun").length;
			            var newoption = new Option(getNodeText(getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i))), getNodeText(xmldom.getElementsByTagName("CATEGORY").item(i)));
			            document.getElementById("PortalGubun").options[lastindex] = newoption;
			        }
			    }
			    xmldom = null;

			    SearchPortlet("");
			}

			// 포틀릿 정보를 가져온다. - 편집권한이 있는 정보만 가져온다.
			function SearchPortlet(pType) {
			    var xmldom = createXmlDom();
			    var xmlhttp = createXMLHttpRequest();
			    xmlhttp.open("POST", "/ezPortal/portletSearchList.do?pType=" + pType + "&mode=edit" + "&pPageType=" + gubunFlag, false);
			    xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			    xmlhttp.send();

			    if (xmlhttp.statusText == "OK") {
			        xmldom = loadXMLString(xmlhttp.responseText);
			        
					<%
						String userLang = (String)request.getParameter("userLang");
					%>
			        var portletHTML = "<table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"TABLE-LAYOUT:fixed\">";

			        for (var i = 0; i < xmldom.getElementsByTagName("UID_").length; i++) {
			            portletHTML += "<tr><td class=\"white\" style=\"padding-left:10px\">";
			            <%-- portletHTML += "<input type=radio name=uid onclick=\"RadioClick('" + getNodeText(GetElementsByTagName(xmldom, "UID_").item(i)).replace("'", "").replace("\"", "") + "', '" + getNodeText(GetElementsByTagName(xmldom, "DISPLAYNAME" + "<%=userLang%>").item(i)).replace("'", "").replace("\"", "") + "', '" + getNodeText(GetElementsByTagName(xmldom, "HEIGHT").item(i)).replace("'", "").replace("\"", "") + "')\"><span>" + getNodeText(GetElementsByTagName(xmldom, "DISPLAYNAME" + "<%=userLang%>").item(i)).replace("'", "").replace("\"", "") + "" + "</span>"; --%>
			            portletHTML += "<input type=radio name=uid onclick=\"RadioClick('" + getNodeText(xmldom.getElementsByTagName("UID_").item(i)) + "', '" + getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) + "', '" + getNodeText(xmldom.getElementsByTagName("HEIGHT").item(i)) + "')\"><span>" + getNodeText(xmldom.getElementsByTagName("DISPLAYNAME").item(i)) + "" + "</span>";
						portletHTML += "</td></tr>";
	                }
	                portletHTML += "</table>";

	                document.getElementById("div_PortletList").innerHTML = portletHTML;
	            }
	            xmlhttp = null;
	            xmldom = null;
	        }

	        function CheckBoxClick() {
	            if (!event.srcElement.checked) return;
	            for (var i = 0; i < document.all.tags("input").length; i++) {
	                if (document.all.tags("input").item(i).type == "checkbox") document.all.tags("input").item(i).checked = false;
	            }
	            event.srcElement.checked = true;
	            selectedID = event.srcElement.parentElement.nextSibling.uid;
	            selectedDisplayName = event.srcElement.parentElement.nextSibling.innerText;
	        }

	        function RadioClick(pContentsID, pContentsName, pHeight) {
	            selectedID = pContentsID;
	            selectedDisplayName = pContentsName;
	            selectedHeight = pHeight;
	        }

	        function Save() {
	            if (selectedID == "") {
	                alert("<spring:message code='ezPortal.t341'/>");
				    return;
				}
	            var ret = new Array();
	            ret[0] = selectedID;
	            ret[1] = selectedDisplayName;
	            ret[2] = selectedHeight;
	            if (ReturnFunction != null)
	                ReturnFunction(ret);
	            else
	                window.returnValue = ret;

	            window.close();
	        }

	        function ChangeType() {
	            SearchPortlet(document.getElementById("PortalGubun").value);
	        }
		</script>
	</head>
	<body class="popup" scroll="no" onload="javascript:window_onload()">
    	<h1><spring:message code='ezPortal.t147'/></h1>
		<table class="content" style="width:100%">
  			<tr>
    			<th>
    				<spring:message code='ezPortal.t342'/>
      				<select name="PortalGubun" id="PortalGubun" onChange="ChangeType()">
        				<option value=""><spring:message code='ezPortal.t251'/></option>
      				</select>
    			</th>
  			</tr>
  			<tr>
    			<td><div id="div_PortletList" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:280px;border:none"></div></td>
  			</tr>
		</table>
    	<table width="270" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px"> 
			<tr>
				<td align="right">
            		<a class="imgbtn" name="btnSave"><span onClick="Save()"><spring:message code='ezPortal.t282'/></span></a>
            		<a class="imgbtn" name="btnClose"><span onClick="window.close()"><spring:message code='ezPortal.t8'/></span></a>
				</td>
			</tr>
		</table>
	</body>
</html>