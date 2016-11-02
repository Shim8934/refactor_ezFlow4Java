<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<%
		String userLang = (String)request.getAttribute("userLang");
		%>
		<section  class="body_bg1">
      		<article class="portletbox boardbox ">
      		  <div id="BoardTab" class="title" runat="server"></div>
        		<div id="BoardList" class="boardcont" runat="server">
        		<%
		 			String pExist = (String)request.getAttribute("pExist");
		 		%>
            		 <%if (pExist == "true") { %>
            			<dl onclick="openDoc_section4_Type(''${pItemID}','${pBoardType}', '${pData1}')" class='listtype_photo' style='cursor: pointer'>
                			<dt class='tit'><strong><${pDocTitle}</strong></dt>
                			<dd class='photo'>
	                    		<img src='/images/kr/main/board_pic.gif' width='86' height='61' alt=''>
                    		</dd>
    			            <dd id='content' class='txt'>${pDocContent}></dd>
            			</dl>
            			<ul class="listtype_txt">
                			<asp:repeater id="BoardListRepeater_NewBoardSTD" runat="server">  
                				<ItemTemplate>
                    				<%-- <li onclick="openDoc_section4_Type('<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA10")[0].InnerText %>', 
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA1")[0].InnerText %>')" >
                        				<span class='txt'><%# pBoard_ID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}" ? 
                                          	((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[3].InnerText : 
                                          	((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[2].InnerText %></span> 
                        				<span class='date'><%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[6].InnerText %></span>
                        				<span class='name'><%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[5].InnerText %></span>
                    				</li> --%>
                				</ItemTemplate>
            				</asp:repeater>
            			</ul>
            		<%} else {%>
            			<div class='nodata_portlet '>
                			<p>
                    			<img src='/images/<spring:message code='main.t00025' />/main/nodata_gray.gif' width='107' height='70'>
                    		</p>
                			<p><spring:message code='main.t00026' /></p>
            			</div>
            		<%} %> 
        		</div>
        		<div class="guide"><span class="lb"></span><span class="rb"></span></div>
   		 	</article>
		</section>

		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
		 	var pBoardID_NewBoardSTD = "${pBoardID}";
		    var pBoardType_NewBoardSTD = "${pBoardGubun}";
		    var BoardCnt_NewBoardSTD = parseInt("${pHeaderCount}");
		    var strLang1_NewBoardSTD = "<spring:message code='main.t00026' />";
		    var pNoneActiveX = "${pNoneActiveX}";
		    document.onselectstart = function () { return false; };
		    function window_onload_NewBoardSTD() {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        GetMyBoardItem();
		        getTabList();
		        getBoardList_NewBoardSTD();
		    }

		    function getTabList() {
		        var xmldom = createXmlDom();
		        xmldom = GetMyBoardItem();

		        BoardCnt_NewBoardSTD = xmldom.getElementsByTagName("ROW").length;

		        var xmlnode = SelectNodes(xmldom, "ROOT/DATA/ROW");
		        if (BoardCnt_NewBoardSTD > 0) {
		            if (BoardCnt_NewBoardSTD > 3)
		                BoardCnt_NewBoardSTD = 3;

		            var listHTML = "<span class='tr'></span><dl class='portlet_tab'>";

		            var classon = "class='on'";

		            for (var i = 0; i < BoardCnt_NewBoardSTD; i++) {
		                var BoardName = "";
		                if ("<%=userLang%>" == "1")
		                        BoardName = getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME"));
		                    else
		                        BoardName = getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME2"));
		                    if (i == 0) {
		                        listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' DATA1='" + getNodeText(SelectSingleNode(xmlnode[i], "BOARDID")) + "' " + classon + " DATA5='" + getNodeText(SelectSingleNode(xmlnode[i], "GUBUN")) + "'" + "><span> " + BoardName + " </span></dt>";
		                        pBoardType_NewBoardSTD = getNodeText(SelectSingleNode(xmlnode[i], "GUBUN"));
		                    }
		                    else
		                        listHTML += "<dt id='Board" + i + "' onclick='boardChangeTab(this)' DATA1='" + getNodeText(SelectSingleNode(xmlnode[i], "BOARDID")) + "' DATA5='" + getNodeText(SelectSingleNode(xmlnode[i], "GUBUN")) + "'><span> " + BoardName + " </span></dt>";


		                }

		                listHTML += "</dl>";
		                listHTML += "<span class='btn_more' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/kr/main/btn_more02.gif' width='35' height='20' alt='more'></span>";

		                document.getElementById("BoardTab").innerHTML = listHTML;
		                pBoardID_NewBoardSTD = document.getElementById("Board0").getAttribute("DATA1");
		                getBoardList_NewBoardSTD();
		            }
		            else {
		                var nodata = "<div class='nodata_portlet '>";
		                nodata += "<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>";
		                nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";

		                document.getElementById("BoardList").innerHTML = nodata;
		            }

		        }


		        function GetMyBoardItem() {
		            var xmlhttp_GetMyBoardItem_NewBoardSTD = createXMLHttpRequest();
		            xmlhttp_GetMyBoardItem_NewBoardSTD.open("POST", "/ezBoard/get_favoriteList.do?mode=USE", false);
		            xmlhttp_GetMyBoardItem_NewBoardSTD.send();
		            var ret = xmlhttp_GetMyBoardItem_NewBoardSTD.responseXML;
		            xmlhttp_GetMyBoardItem_NewBoardSTD = null;
		            return ret;
		        }

		        var xmlhttp_getBoardList_NewBoardSTD = createXMLHttpRequest();
		        function getBoardList_NewBoardSTD() {
		           /*  var xmlpara = createXmlDom();
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "pBoardType", "1");
		            createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID_NewBoardSTD);
		            createNodeAndInsertText(xmlpara, objNode, "pPageNum", "1");
		            createNodeAndInsertText(xmlpara, objNode, "orderCell", "");
		            createNodeAndInsertText(xmlpara, objNode, "orderOption", "");

		            xmlhttp_getBoardList_NewBoardSTD = null;
		            xmlhttp_getBoardList_NewBoardSTD = createXMLHttpRequest();
		            xmlhttp_getBoardList_NewBoardSTD.open("POST", "/myoffice/ezBoardSTD/aspx/Get_BoardList.aspx", true);
		            xmlhttp_getBoardList_NewBoardSTD.onreadystatechange = getBoardList_after;
		            xmlhttp_getBoardList_NewBoardSTD.send(xmlpara); */
		            $.ajax({
	    	        	type : "POST",
	    	        	dataType : "text",
	    	        	url : "/ezBoard/getBoardList.do",
	    	        	data : {
	    	        		boardType   : "1", 
						 	boardId 	 : pBoardID_NewBoardSTD, 
						    pageNum 	 : "1", 
							orderCell 	 : "", 
							orderOption : ""
	    	        	},
	    	        	success : function(xml){
	    	        		getBoardList_after(loadXMLString(xml));
	    	        	},
	    	        	error : function(error){
	    	        		alert("<spring:message code='ezBoard.t22'/>" + error);	
	    	        	}
	    	        });
		        }

		        function getBoardList_after(xml) {
		            if (xml == null) return;
		            try {
		                if (xml == "") {
		                    var nodata = "<div class='nodata_portlet '>";
		                    nodata += "<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>";
		                    nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";
		                    document.getElementById("BoardList").innerHTML = nodata;
		                    return;
		                }

		                document.getElementById("BoardList").innerHTML = "";

		                var listHTML = "";
		                var xmldom = createXmlDom();
		                xmldom = xml;
		                var RowCnt = xmldom.getElementsByTagName("ROW").length;

		                if (RowCnt > 0) {
		                    if (RowCnt > 4)
		                        RowCnt = 4;


		                    var pfirstItemID = "";
		                    if (RowCnt > 0) {
		                        pfirstItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(0));
		                        var FboardType = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA10").item(0));
		                        var FboardMainContent = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA12").item(0));
		                        if (FboardType == "" && FboardMainContent != "") {
		                            FboardType = "3";
		                        }
		                        listHTML = "<dl onclick=\"openDoc_section4_Type('" + pfirstItemID + "','" + FboardType + "', '" + getNodeText(xmldom.getElementsByTagName("DATA1").item(i)) + "')\" class='listtype_photo' style='cursor:pointer'>";
		                        if (pBoardID_NewBoardSTD == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")
		                            var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(3));
		                        else
		                            var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(2));
		                        listHTML += "<dt class='tit'><strong>" + DOCTITLE + "</strong></dt>";
		                        listHTML += "<dd class='photo'><img src='/images/kr/main/board_pic.gif' width='86' height='61' alt=''></dd>";
		                        listHTML += "<dd id='content' class='txt'></dd>";
		                        listHTML += "</dl>";

		                        listHTML += "<ul class=\"listtype_txt \">";
		                        for (var i = 1; i < RowCnt; i++) {
		                            if (pBoardID_NewBoardSTD == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")
		                                var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(3));
		                            else
		                                var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(2));

		                            var WRITERNAME = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(5));
		                            var STARTDATE = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(6));
		                            var pItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(0));

		                            var boardType = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("DATA10").item(0));
		                          //2016-10-31
		                          //boardType이 아무 값도 들어가지 않아서, 보드타입이0일때, 메인컨텐츠에 내용이 있을때 보트타입3을넣어줌.
		                            var boardMainContent = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA12").item(0));
			                        if (boardType == "" && boardMainContent != "") {
			                            boardType = "3";
			                        }
		                            listHTML += "<li onclick=\"openDoc_section4_Type('" + pItemID + "','" + boardType + "', '" + getNodeText(xmldom.getElementsByTagName("DATA1").item(i)) + "')\" ><span class='txt'>" + DOCTITLE + "</span> <span class='date'>" + STARTDATE + "</span> <span class='name'>" + WRITERNAME + "</span></li>";
		                        }
		                        listHTML += "</ul>";
		                        document.getElementById("BoardList").innerHTML = listHTML;
		                        if (FboardType != "4" && FboardType != "3") {
		                            if (FboardMainContent != "") {
		                                document.getElementById("content").innerHTML = FboardMainContent;
		                            } else {
		                                getContent(pfirstItemID);
		                            }
		                        } else {
		                            document.getElementById("content").innerHTML = FboardMainContent;
		                        }
		                    } else {

		                        var nodata = "<div class='nodata_portlet '>";
		                        nodata += "<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>";
		                        nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";
		                        document.getElementById("BoardList").innerHTML = nodata;
		                    }
		                } else {

		                    var nodata = "<div class='nodata_portlet '>";
		                    nodata += "<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>";
		                    nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";
		                    document.getElementById("BoardList").innerHTML = nodata;
		                }
		            }
		            catch (e) {
		            	alert(e);
		            }
		        }

		        function openDoc_section4_Type(pItemID, pType, oBoardID) {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;

		            if (pType == "3" || pType == "4") {
		                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                if (CrossYN() || pNoneActiveX == "YES") {
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                } else {
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                }
		            }
		        }

		        function openDoc(pItemID) {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;

		            if (pBoardType_NewBoardSTD == "3" || pBoardType_NewBoardSTD == "4")
		                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoardSTD, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
		            else {
		                if (CrossYN())
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoardSTD, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                else
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoardSTD, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		            }
		        }

		        var xmlhttp_getContent_NewBoardSTD = createXMLHttpRequest();
		        function getContent(pItemID) {
		            xmlhttp_getContent_NewBoardSTD = createXMLHttpRequest();
		            var xmlpara = createXmlDom();
		            var objNode;

		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID_NewBoardSTD);
		            createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
		            xmlhttp_getContent_NewBoardSTD.open("POST", "/ezBoard/getItemInfo.do", true);
		            xmlhttp_getContent_NewBoardSTD.onreadystatechange = getContent_after;
		            xmlhttp_getContent_NewBoardSTD.send(xmlpara);
		        }

		        function getContent_after() {
		            if (xmlhttp_getContent_NewBoardSTD == null || xmlhttp_getContent_NewBoardSTD.readyState != 4) return;
		            try {
		                var xmldom = createXmlDom();
		                xmldom = xmlhttp_getContent_NewBoardSTD.responseXML;
		                xmlhttp_getContent_NewBoardSTD = null;
		                var strContentHref = getNodeText(xmldom.getElementsByTagName("ContentLocation").item(0));
		                var ConverContentUrl = location.protocol + "//" + location.host + "/ezCommon/downloadAttach.do?filePath=" + strContentHref;
		                var tempStr = ConvertMHTtoHTML(ConverContentUrl);
		                var DocContentObject = document.createElement("DIV");
		                DocContentObject.innerHTML = tempStr;
		                var DocContentObject_Div = document.createElement("DIV");
		                DocContentObject_Div.innerHTML = CrossYN() ? DocContentObject.textContent.replace(/<P>/gi, "").replace(/<\/P>/gi, "") : DocContentObject.innerText.replace(/<P>/gi, "").replace(/<\/P>/gi, "");

		                if (DocContentObject_Div.getElementsByTagName("style").length > 0)
		                    DocContentObject_Div.removeChild(DocContentObject_Div.getElementsByTagName("style")[0]);

		                if (CrossYN())
		                    DocContentObject.innerHTML = DocContentObject_Div.textContent.replace(/(\r\n)/g, "");
		                else
		                    DocContentObject.innerHTML = DocContentObject_Div.innerText.replace(/(\r\n)/g, "");

		                document.getElementById("content").appendChild(DocContentObject);
		            }
		            catch (e) {
		            }
		        }

		        function boardChangeTab(obj) {
		            switch (obj.id) {
		                case "Board0":
		                    document.getElementById("Board0").className = "on";
		                    for (var i = 1; i < BoardCnt_NewBoardSTD; i++) {
		                        document.getElementById("Board" + i).className = "";
		                    }
		                    break;

		                case "Board1":

		                    document.getElementById("Board0").className = "";
		                    document.getElementById("Board1").className = "on";
		                    if (BoardCnt_NewBoardSTD == 3)
		                        document.getElementById("Board2").className = "";
		                    break;

		                case "Board2":

		                    document.getElementById("Board0").className = "";
		                    document.getElementById("Board1").className = "";
		                    document.getElementById("Board2").className = "on";
		                    break;
		            }
		            pBoardID_NewBoardSTD = document.getElementById(obj.id).getAttribute("DATA1");
		            pBoardType_NewBoardSTD = document.getElementById(obj.id).getAttribute("DATA5");
		            getBoardList_NewBoardSTD();
		        }

		        function Boardmore_NewBoardSTD_btnClick() {
		            window.open("/ezBoard/boardMainRedirect.do?boardID=" + pBoardID_NewBoardSTD, "main", "");
		        }
		        function refresh_onclick() {
		            if (document.getElementById("Board0").className == "on") {
		                pBoardID_NewBoardSTD = document.getElementById("Board0").getAttribute("DATA1");
		                getBoardList_NewBoardSTD();
		            }
		            else if (document.getElementById("Board1").className == "on") {
		                pBoardID_NewBoardSTD = document.getElementById("Board1").getAttribute("DATA1");
		                getBoardList_NewBoardSTD();
		            }
		            else {
		                pBoardID_NewBoardSTD = document.getElementById("Board2").getAttribute("DATA1");
		                getBoardList_NewBoardSTD();
		            }
		        }

		        window_onload_NewBoardSTD();	
		</script>
	</head>	
</html>