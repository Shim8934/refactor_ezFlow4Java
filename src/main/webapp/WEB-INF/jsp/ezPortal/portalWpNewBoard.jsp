<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<section  class="body_bg1">
      		<article class="portlet_notice">
        		<p class="title"><img src="/images/<spring:message code='main.t00025' />/main/notice_title.gif" alt=""> <span onclick='Boardmore_NewBoard_btnClick()' class="btn_more"><img src="/images/<spring:message code='main.t00025' />/main/btn_more01.gif" alt="more"></span></p>
        		<dl class="notice_tab">
          			<dt id="Board0_Newboard" DATA1="${pCompanyBoard}" TYPE="${pCompanyType}" onclick="boardChangeTab_Newboard(this)" class="on"><span>${pCompanyBDNM}</span></dt>
          			<dt id="Board1_Newboard" DATA1="${pDeptBoardID}" TYPE="${pDeptType}" onclick="boardChangeTab_Newboard(this)"><span>${pDeptBDNM}</span></dt>
          			<dt id="Board2_Newboard" DATA1="${pNewsBoardID}" TYPE="${pNewsType}" onclick="boardChangeTab_Newboard(this)"><span>${pNewsBDNM}</span></dt>
        		</dl>
          		<div id="BoardList_NewBoard" >
          		<%
		 			String pExist = (String)request.getAttribute("pExist");
		 		%>
        			<%if(pExist == "true") { %>
            			<dl onclick="openDoc('${pItemID}')" class='nt_pic' style='cursor:pointer'>
            				<dt class='tit'><strong>${pDocTitle}</strong></dt>
            				<dd class='photo'><img src='/images/<spring:message code='main.t00025' />/main/notice_pic.gif' width='83' height='54' alt=''></dd>
            				<dd id='content_NewBoard' class='txt'>${pDocContent}</dd>
            			</dl>
			            <ul class="mainlist">
			    	        <asp:Repeater ID="BoardListRepeater" runat="server">  
                				<ItemTemplate>
                    				<%-- <li  style='cursor:pointer' onclick="openDoc('<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[0].InnerText %>')" >
                        				<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[2].InnerText %>
                    				</li> --%>
                				</ItemTemplate>
        	    			</asp:Repeater>
    	        		</ul>
	        	    <%} else {%>
               			<div class='nodata_portlet '>
                			<p><img src='/images/<spring:message code='main.t00025' />/main/nodata_gray.gif' width='107' height='70'></p>
                			<p><spring:message code='main.t00026' /></p>
                		</div>
            		<%} %>
        		</div>
      		</article>
		</section>

		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
    		var pBoardID_NewBoard = "${pCompanyBoard}";
    		var pBoardType_NewBoard = "";
    		var BoardCnt_NewBoard = 0;
    		var strLang1_NewBoard = "<spring:message code='main.t00025'/>";
    		var strLang2_NewBoard = "<spring:message code='main.t00026'/>";

        	document.onselectstart = function () { return false; };
        
	        function window_onload_Newboard(){
    	        if (navigator.userAgent.indexOf('Firefox') != -1) {
        	        document.body.style.MozUserSelect = 'none';
            	    document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
                	document.body.style.oUserSelect = 'none';
                	document.body.style.UserSelect = 'none';
            	}
    	        // 2016-08-03 첫화면에 공지게시판 불러오기
				getBoardList_NewBoard();
            	try { top.onresize() } catch (e) { }
        	}
        	var xmlhttp_getBoardList_NewBoard = createXMLHttpRequest();
        	
        	function getBoardList_NewBoard() {
                $.ajax({
    	        	type : "POST",
    	        	dataType : "text",
    	        	url : "/ezBoard/getBoardList.do",
    	        	data : {
    	        		boardType   : "1", 
					 	boardId 	 : pBoardID_NewBoard, 
					    pageNum 	 : "1", 
						orderCell 	 : "", 
						orderOption : ""
    	        	},
    	        	success : function(xml){
    	        		getBoardList_NewBoard_after(loadXMLString(xml));
    	        	},
    	        	error : function(error){
    	        		console.log("<spring:message code='ezBoard.t22'/>portalWpNewBoard" + error);	
    	        	}
    	        	});
            	
        	}
			function getBoardList_NewBoard_after(xml) {
            	if (xml == null) return;
            	try {
                	if (xml == "") {
	                    var nodata = "<div class='nodata_portlet '>";
    	                nodata += "<p><img src='/images/" + strLang1_NewBoard + "/main/nodata_gray.gif' width='107' height='70'></p>";
        	            nodata += "<p>" + strLang2_NewBoard + "</p></div>";

            	        document.getElementById("BoardList_NewBoard").innerHTML = nodata;
                	    return;
                	}
                	document.getElementById("BoardList_NewBoard").innerHTML = "";
                	var listHTML = "";
                	var xmldom = xml;

	                var RowCnt = xmldom.getElementsByTagName("ROW").length;
                
    	            if (RowCnt > 0) {
        	            if (RowCnt > 4) {
            	            RowCnt = 4;
        	            }

                	    var pfirstItemID = "";
                    
                        pfirstItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(0));
                        listHTML = "<dl onclick=\"openDoc('" + pfirstItemID + "')\" class='nt_pic' style='cursor:pointer'>";

                        var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(2));
                        listHTML += "<dt class='tit'><strong>" + DOCTITLE + "</strong></dt>";
                        listHTML += "<dd class='photo'><img src='/images/" + strLang1_NewBoard + "/main/notice_pic.gif' width='83' height='54' alt=''></dd>";
                        listHTML += "<dd id='content' class='txt'></dd>";
                        listHTML += "</dl>";

                        listHTML += "<ul class=\"mainlist \">";
                        for (var i = 1; i < RowCnt; i++) {
                            var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(2));
                            var pItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(0));
                            listHTML += "<li  style='cursor:pointer' onclick=\"openDoc('" + pItemID + "')\" >" + DOCTITLE + "</li>";
                        }
                        listHTML += "</ul>";
                        document.getElementById("BoardList_NewBoard").innerHTML = listHTML;

                        getContent(pfirstItemID);                  
	                } else {
                    	var nodata = "<div class='nodata_portlet '>";
                    	nodata += "<p><img src='/images/" + strLang1_NewBoard + "/main/nodata_gray.gif' width='107' height='70'></p>";
                    	nodata += "<p>" + strLang2_NewBoard + "</p></div>";

                    	document.getElementById("BoardList_NewBoard").innerHTML = nodata;
                	}
            	} catch (e) {
            		
            	}
        	}
			function openDoc(pItemID) {
	            var pheight = window.screen.availHeight;
            	var pwidth = window.screen.availWidth;
            	var pTop = (pheight - 720) / 2;
            	var pLeft = (pwidth - 765) / 2;

            	if (pBoardType_NewBoard == "3" || pBoardType_NewBoard == "4")
	                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoard, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
            	else {
	                if (CrossYN())
    	                window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoard, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
        	        else
            	        window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoard, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
            	}
	        }

    	    var xmlhttp_getContent_Newboard = createXMLHttpRequest();
    	    
        	function getContent(pItemID) {
	            xmlhttp_getContent_Newboard = createXMLHttpRequest();
            	var xmlpara = createXmlDom();
            	var objNode;
            	createNodeInsert(xmlpara, objNode, "PARAMETER");
            	createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID_NewBoard);
            	createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
            	xmlhttp_getContent_Newboard.open("POST", "/myoffice/ezBoardSTD/aspx/Get_ItemInfo.aspx", true);
            	xmlhttp_getContent_Newboard.onreadystatechange = getContent_NewBoard_after;
            	xmlhttp_getContent_Newboard.send(xmlpara);
        	}
        	
        	function getContent_NewBoard_after() {
	            if (xmlhttp_getContent_Newboard == null || xmlhttp_getContent_Newboard.readyState != 4) return;
    	        try {
        	        var xmldom = xmlhttp_getContent_Newboard.responseXML;
            	    xmlhttp_getContent_Newboard = null;
	                var tempStr;
                	if (getNodeText(xmldom.getElementsByTagName("MainContent").item(0)) == "") {
	                    var strContentHref = getNodeText(xmldom.getElementsByTagName("ContentLocation").item(0));
    	                var ConverContentUrl = location.protocol + "//" + location.host + "/ezCommon/downloadAttach.do?filePath=" + strContentHref;
        	            tempStr = ConvertMHTtoHTML(ConverContentUrl);
            	    } else {
                    	tempStr = getNodeText(xmldom.getElementsByTagName("MainContent").item(0));
                	}
                	var DocContentObject = document.createElement("DIV");
                	DocContentObject.innerHTML = tempStr;
                	var DocContentObject_Div = document.createElement("DIV");
                	DocContentObject_Div.innerHTML = CrossYN() ? DocContentObject.textContent.replace(/<P>/gi, "").replace(/<\/P>/gi, "") : DocContentObject.innerText.replace(/<P>/gi, "").replace(/<\/P>/gi, "");

	                if (DocContentObject_Div.getElementsByTagName("style").length > 0) {
    	                DocContentObject_Div.removeChild(DocContentObject_Div.getElementsByTagName("style")[0]);
        	        }

            	    if (CrossYN())
                	    DocContentObject.innerHTML = DocContentObject_Div.textContent.replace(/(\r\n)/g, "");
                	else
                    	DocContentObject.innerHTML = DocContentObject_Div.innerText.replace(/(\r\n)/g, "");
                
                	document.getElementById("content_NewBoard").appendChild(DocContentObject);
	            }
    	        catch (e) {
        	    }
	        }	
    	    function boardChangeTab_Newboard(obj) {
        	    switch (obj.id) {
            	    case "Board0_Newboard":
                	    document.getElementById("Board0_Newboard").className = "on";
                    	document.getElementById("Board1_Newboard").className = "";
                    	document.getElementById("Board2_Newboard").className = "";
                    	break;

	                case "Board1_Newboard":
    	                document.getElementById("Board0_Newboard").className = "";
        	            document.getElementById("Board1_Newboard").className = "on";
            	        document.getElementById("Board2_Newboard").className = "";
                	    break;

                	case "Board2_Newboard":
	                    document.getElementById("Board0_Newboard").className = "";
    	                document.getElementById("Board1_Newboard").className = "";
        	            document.getElementById("Board2_Newboard").className = "on";
            	        break;
            	}
            	pBoardID_NewBoard = document.getElementById(obj.id).getAttribute("DATA1");
            	pBoardType_NewBoard = document.getElementById(obj.id).getAttribute("TYPE");
            	getBoardList_NewBoard();
        	}

        	function Boardmore_NewBoard_btnClick() {
	            window.open("/ezBoard/boardMainRedirect.do?boardID=" + pBoardID_NewBoard, "main", "");
    	    }

        	function refresh_onclick() {
            	if (document.getElementById("Board0_Newboard").className == "on") {
                	pBoardID_NewBoard = document.getElementById("Board0_Newboard").getAttribute("DATA1");
                	getBoardList_NewBoard();
            	} else if (document.getElementById("Board1_Newboard").className == "on") {
                	pBoardID_NewBoard = document.getElementById("Board1_Newboard").getAttribute("DATA1");
                	getBoardList_NewBoard();
            	} else {
                	pBoardID_NewBoard = document.getElementById("Board2_Newboard").getAttribute("DATA1");
                	getBoardList_NewBoard();
            	}
        	}

        	window_onload_Newboard();
	</script>
</html>