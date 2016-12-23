<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
		 var RetValue;
		    window.onload = function () {
		        
		            try {
		                RetValue = opener.personsearch_print_dialogArguments[0];
		            } catch (e) {
		                RetValue = dialogArguments
		            }
		        

		            var xmlRtn = RetValue["TreeXml"];
		            var pListType = RetValue["ListType"];
		            var pSeach = RetValue["Search"];

		            document.getElementById("SelectDeptNM").innerHTML = RetValue["Dept"];

		        document.getElementById("Print_DeptUserImgList").innerHTML = "";
		        document.getElementById("Print_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes
		        while (document.getElementById("Print_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Print_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Print_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        while (document.getElementById("Print_Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Print_Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Print_Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        if (pListType == "IMG") {
		            document.getElementById("Print_DeptUserImgList").style.display = "";
		            document.getElementById("Print_txtlist_table").style.display = "none";
		            document.getElementById("Print_Search_txtlist_table").style.display = "none";
		        }
		        else {
		            document.getElementById("Print_DeptUserImgList").style.display = "none";
		            if (!pSeach) {
		                document.getElementById("Print_txtlist_table").style.display = "";
		                document.getElementById("Print_Search_txtlist_table").style.display = "none";
		            }
		            else {
		                document.getElementById("Print_Search_txtlist_table").style.display = "";
		                document.getElementById("Print_txtlist_table").style.display = "none";
		            }
		        }
		        for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
		            if (pListType == "IMG") {

		                var MainTable = document.createElement("TABLE");
		                MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
		                MainTable.setAttribute("cellspacing", "0");
		                MainTable.setAttribute("cellpadding", "0");
		                if (pListType == "IMG")
		                    MainTable.style.marginTop = "5px";

		                MainTable.style.marginLeft = "auto";
		                MainTable.style.marginRight = "auto";
		                var M_TR = document.createElement("TR");
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
		                        if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
		                        }
		                    }
		                }
		                else {
		                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                          SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
		                    }
		                }

		                var M_TR_TD = document.createElement("TD");
		                M_TR_TD.setAttribute("class", "pictd");
		                var M_TR_DIV = document.createElement("DIV");
		                M_TR_DIV.setAttribute("class", "pic");
		                if (M_TR.getAttribute("_DATA9") != "") {
		                    var M_TR_IMG = document.createElement("IMG");
		                    M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
		                    M_TR_IMG.setAttribute("width", "90px");
		                    M_TR_IMG.setAttribute("height", "90px");
		                    M_TR_DIV.appendChild(M_TR_IMG);
		                }
		                M_TR_TD.appendChild(M_TR_DIV);
		                M_TR.appendChild(M_TR_TD);

		                var M_TR_TD2 = document.createElement("TD");
		                M_TR_TD2.style.width = "300px";

		                var M_TR_TDS_Table = document.createElement("TABLE");
		                M_TR_TDS_Table.setAttribute("class", "organinfo");
		                M_TR_TD2.appendChild(M_TR_TDS_Table);

		                var Sub_TR1 = document.createElement("TR");
		                var Sub_TD1 = document.createElement("TD");
		                Sub_TD1.style.textAlign = "left";
		                Sub_TD1.setAttribute("class", "name");
		                var pDisplayName = "";
		                pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
		                pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
		                Sub_TD1.innerHTML = pDisplayName;
		                Sub_TR1.appendChild(Sub_TD1);

		                var Sub_TR2 = document.createElement("TR");
		                var Sub_TD2 = document.createElement("TD");
		                Sub_TD2.style.textAlign = "left";
		                Sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
		                Sub_TR2.appendChild(Sub_TD2);

		                var Sub_TR3 = document.createElement("TR");
		                var Sub_TD3 = document.createElement("TD");
		                Sub_TD3.style.textAlign = "left";
		                var Sub_TD3_Img = document.createElement("IMG");
		                Sub_TD3_Img.setAttribute("class", "icon");
		                Sub_TD3_Img.setAttribute("src", "/images/OrganTree_cross/icon_hp.gif");
		                Sub_TD3.appendChild(Sub_TD3_Img);
		                Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
		                Sub_TR3.appendChild(Sub_TD3);

		                var Sub_TR4 = document.createElement("TR");
		                var Sub_TD4 = document.createElement("TD");
		                Sub_TD4.style.textAlign = "left";
		                var Sub_TD4_Img = document.createElement("IMG");
		                Sub_TD4_Img.setAttribute("class", "icon");
		                Sub_TD4_Img.setAttribute("src", "/images/OrganTree_cross/icon_mail.gif");
		                Sub_TD4.appendChild(Sub_TD4_Img);
		                Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
		                Sub_TR4.appendChild(Sub_TD4);

		                M_TR_TDS_Table.appendChild(Sub_TR1);
		                M_TR_TDS_Table.appendChild(Sub_TR2);
		                M_TR_TDS_Table.appendChild(Sub_TR3);
		                M_TR_TDS_Table.appendChild(Sub_TR4);

		                M_TR.appendChild(M_TR_TD2);
		                MainTable.appendChild(M_TR);
		                document.getElementById("Print_DeptUserImgList").appendChild(MainTable);
		            }
		            else {
		                var M_TR = document.createElement("TR");
		                if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.length; NodeCount++) {
		                        if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName != "#text") {
		                            M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).nodeName,
		                                              trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(1).childNodes.item(NodeCount).textContent));
		                        }
		                    }
		                }
		                else {
		                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
		                                          SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
		                    }
		                }

		                if (pSeach) {
		                    var M_TR_TD1 = document.createElement("TD");
		                    M_TR_TD1.style.overflow = "hidden";
		                    M_TR_TD1.style.textOverflow = "ellipsis";
		                    M_TR_TD1.style.whiteSpace = "nowrap";
		                    M_TR_TD1.style.width = "110px";
		                    M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");

		                    var M_TR_TD2 = document.createElement("TD");
		                    M_TR_TD2.style.overflow = "hidden";
		                    M_TR_TD2.style.textOverflow = "ellipsis";
		                    M_TR_TD2.style.whiteSpace = "nowrap";
		                    M_TR_TD2.style.width = "90px";
		                    M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");

		                    var M_TR_TD3 = document.createElement("TD");
		                    M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
		                    M_TR_TD3.style.width = "80px";

		                    var M_TR_TD4 = document.createElement("TD");
		                    M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

		                    M_TR.appendChild(M_TR_TD1);
		                    M_TR.appendChild(M_TR_TD2);
		                    M_TR.appendChild(M_TR_TD3);
		                    M_TR.appendChild(M_TR_TD4);
		                    document.getElementById("Print_Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
		                }
		                else {
		                    var M_TR_TD1 = document.createElement("TD");
		                    M_TR_TD1.style.overflow = "hidden";
		                    M_TR_TD1.style.textOverflow = "ellipsis";
		                    M_TR_TD1.style.whiteSpace = "nowrap";
		                    M_TR_TD1.style.width = "150px";
		                    M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");

		                    var M_TR_TD2 = document.createElement("TD");
		                    M_TR_TD2.style.width = "80px";
		                    M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");

		                    var M_TR_TD3 = document.createElement("TD");
		                    M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

		                    M_TR.appendChild(M_TR_TD1);
		                    M_TR.appendChild(M_TR_TD2);
		                    M_TR.appendChild(M_TR_TD3);
		                    document.getElementById("Print_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
		                }
		            }

		        }

		        window.print();
		    }
		</script>
	</head>
	<body class="popup">
    <div id="menu">
        <ul>
        <li><span onClick="window.print()"><spring:message code='ezPersonal.t1005'/></span></li>
        </ul>
    </div>
    <div id="close">
        <ul>
        <li><span onClick="window.close()"><spring:message code='ezPersonal.t10'/></span></li>
        </ul>
    </div>

    <span id="SelectDeptNM" style="font-weight:bold;width:300px;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;display:inline-block;vertical-align:bottom;"></span>    
    <table style="width:100%;height:auto;border:1px solid #B6B6B6;display:none;" id="Print_txtlist_table" class="mainlist" > 
              <tr>
                  <td style="width:150px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t304'/></td>
                  <td style="width:80px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t69'/></td>
                  <td class="td_gray" style="font-weight:bold;"><spring:message code='ezPersonal.t177'/></td>
              </tr>
          </table>
          <table style="width:100%;height:100%; border:1px solid #B6B6B6;display:none;" id="Print_Search_txtlist_table" class="mainlist" > 
              <tr>
                  <td style="width:110px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t305'/></td>
                  <td style="width:90px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t304'/></td>
                  <td style="width:80px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t69'/></td>
                  <td class="td_gray" style="font-weight:bold;"><spring:message code='ezPersonal.t177'/></td>
              </tr>
          </table>
		  <div style="vertical-align:top;text-align:center;height:auto;display:none;width:425px;" id="Print_DeptUserImgList">    
          </div>    
</body>
</html>