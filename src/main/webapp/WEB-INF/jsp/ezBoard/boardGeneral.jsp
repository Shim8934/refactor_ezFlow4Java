<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
    <link rel="stylesheet" href="/css/tab.css" type="text/css" />
    <script type="text/javascript" src="/js/kaoni/XmlHttpRequest.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
	<title>Insert title here</title>
	<script type="text/javascript">
         document.onselectstart = function () { return false; };
        window.onload = function () {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
        }
        function PrevieOption(obj) {
            if (obj.value == "OFF") {
                document.getElementById("PreviewHSizeDiv").style.display = "none";
                document.getElementById("PreviewWSizeDiv").style.display = "none";
            }
            else if (obj.value == "H") {
                document.getElementById("PreviewHSizeDiv").style.display = "";
                document.getElementById("PreviewWSizeDiv").style.display = "none";
            }
            else {
                document.getElementById("PreviewHSizeDiv").style.display = "none";
                document.getElementById("PreviewWSizeDiv").style.display = "";
            }
        }
        function HChange(obj) {
            if (obj == document.getElementById("HListUser")) {
                document.getElementById("HPreUser").value = 100 - parseInt(obj.value);
            }
            else {
                document.getElementById("HListUser").value = 100 - parseInt(obj.value);
            }
        }
        function WChange(obj) {
            if (obj == document.getElementById("WListUser")) {
                document.getElementById("WPreUser").value = 100 - parseInt(obj.value);
            }
            else {
                document.getElementById("WListUser").value = 100 - parseInt(obj.value);
            }
        }
        function Cancel_Click() {
            window.location.reload(true);
        }
        function Change_Click() {
            var xmlHTTP = createXMLHttpRequest();
            var xmlpara = createXmlDom();
            var objNode;
            objNode = createNodeInsert(xmlpara, objNode, "DATA");
            createNodeAndInsertText(xmlpara, objNode, "LISTCOUNT", listcount.value);
            createNodeAndInsertText(xmlpara, objNode, "PREVIEWMODE", document.getElementById("PreviewMode").value);
            createNodeAndInsertText(xmlpara, objNode, "PREVIEWWLIST", document.getElementById("WListUser").value);
            createNodeAndInsertText(xmlpara, objNode, "PREVIEWWCONTENT", document.getElementById("WPreUser").value);
            createNodeAndInsertText(xmlpara, objNode, "PREVIEWHLIST", document.getElementById("HListUser").value);
            createNodeAndInsertText(xmlpara, objNode, "PREVIEWHCONTENT", document.getElementById("HPreUser").value);
            xmlHTTP.open("POST", "/myoffice/ezBoardSTD/aspx/board_generallist_save.aspx", false);
            xmlHTTP.send(xmlpara);

            if (xmlHTTP.status == 200 && xmlHTTP.responseText == "OK")
                alert(<spring:message code="ezBoard.t0013" />)
            else
                alert(<spring:message code="ezBoard.t0013" />);
        }
    </script>
</head>
<body style="margin-left: 10px; margin-right: 10px;">
    <h2 class="h2_dot"><spring:message code="ezBoard.t0006" /></h2>
    <span class="txt" style="margin-left: 13px;" >* <spring:message code="ezBoard.t0007" /></span>
        <br />
        <table class="content" style="width: 623px; margin-left: 13px;">
            <tr>
                <th><spring:message code="ezBoard.t10021" /></th>
                <td>
                    <select id="listcount" style="WIDTH: 100px">
                      <option value='10'  selected >10</option>
                        <option value='20' >20</option>
                        <option value='30' >30</option>
                        <option value='40' >40</option>
                        <option value='50' >50</option>
                    </select>
                    <spring:message code="ezBoard.t00019" /></td>
            </tr>
            <tr>
                <th><spring:message code="ezBoard.t431" /></th>
                <td>
                    <select id="PreviewMode" style="WIDTH: 100px" onchange="PrevieOption(this);">
                        <option value="OFF" ><spring:message code="ezBoard.t00011" /></option>
                        <option value="H" selected><spring:message code="ezBoard.t00012" /></option>
                        <option value="W" selected><spring:message code="ezBoard.t00013" /></option>
                    </select>
                    <span id="PreviewHSizeDiv" style="display:none;"
                        ><spring:message code="ezBoard.t0008" /> : 
              <select id="HListUser" style="width: 50px;" onchange="HChange(this);">
                  <%-- <% for (int i = 39; i <= 64; i++)
                     {
                         if (int.Parse(_PreviewHlistsize) == i)
                             Response.Write("<option value='" + i + "' selected>" + i + "</option>");
                         else
                             Response.Write("<option value='" + i + "'>" + i + "</option>");
                     } %> --%>
              </select>
                        <spring:message code="ezBoard.t0009" /> : 
              <select id="HPreUser" style="width: 50px;" onchange="HChange(this);">
                  <%-- <% for (int i = 36; i <= 61; i++)
                     {
                         if (int.Parse(_PreviewHContentsize) == i)
                             Response.Write("<option value='" + i + "' selected>" + i + "</option>");
                         else
                             Response.Write("<option value='" + i + "'>" + i + "</option>");
                     } %> --%>
              </select>
                    </span>
                    <span id="PreviewWSizeDiv" style="display:none;" ><spring:message code="ezBoard.t0008" /> : 
              <select id="WListUser" style="width: 50px;" onchange="WChange(this);">
                  <%-- <% for (int i = 24; i <= 65; i++)
                     {
                         if (int.Parse(_PreviewWlistsize) == i)
                             Response.Write("<option value='" + i + "' selected>" + i + "</option>");
                         else
                             Response.Write("<option value='" + i + "'>" + i + "</option>");
                     } %> --%>
              </select>
              			<spring:message code="ezBoard.t0009" />                    
              <select id="WPreUser" style="width: 50px;" onchange="WChange(this);">
                  <%-- <% for (int i = 35; i <= 76; i++)
                     {
                         if (int.Parse(_PreviewWContentsize) == i)
                             Response.Write("<option value='" + i + "' selected>" + i + "</option>");
                         else
                             Response.Write("<option value='" + i + "'>" + i + "</option>");
                     } %> --%>
              </select>
                    </span>
                </td>
            </tr>
        </table>
    <br />
    <div style="width:623px;text-align:center;">
        <a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezBoard.t98" /></span></a>
        <a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezBoard.t15" /></span></a>
    </div>
</body>
</html>