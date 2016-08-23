<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO"%>
<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<link rel="stylesheet" href="/css/main.css" type="text/css" />
		<link rel="stylesheet" href="/css/orbit-1.2.3.css" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.orbit-1.2.3.min.js""></script>	
	    <style type="text/css">
        	div {
            	margin: auto;
        	}
        	.orbit-wrapper  {
            	margin-left: 27px;
            	float : left;
        	}
    	</style>
    	<script type="text/javascript">
	        $(document).ready(function(){
	        	$('#featured').orbit();
	        	getBoardList();
	        });
	        
        	var pBoardID = "${pCompanyBoard}";
        	var pBoardType = "";
        	var BoardCnt = 0;
        	var strLang1 = "<spring:message code='ezHome.t00025'/>";
        	var strLang2 = "<spring:message code='ezHome.t00026'/>";
        	var pNoneActiveX = "${noneActiveX}";

        	document.onselectstart = function () { return false; };
        	window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
    	            document.body.style.MozUserSelect = 'none';
                	document.body.style.WebkitUserSelect = 'none';
                	document.body.style.khtmlUserSelect = 'none';
                	document.body.style.oUserSelect = 'none';
                	document.body.style.UserSelect = 'none';
            	}
            	getBoardList();

            	try { top.onresize() } catch (e) { }
                        
        	}
        	var xmlhttp = createXMLHttpRequest();
        	
        	function getBoardList() {
           	  $.ajax({
      	       	type : "POST",
      	       	dataType : "xml",
      	       	url : "/ezBoard/getBoardList.do",
      	       	data : {
      	       		boardType   : "1", 
  				 	boardId 	 : pBoardID, 
  				    pageNum 	 : "1", 
  					orderCell 	 : "", 
  					orderOption : ""
      	       	},
      	       	success : function(xml){		        		
      	       		getBoardList_after(xml);
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
        	            nodata += "<p><img src='/images/" + strLang1 + "/main/nodata_gray.gif' width='107' height='70'></p>";
                    	nodata += "<p>" + strLang2 + "</p></div>";

	                    document.getElementById("BoardList").innerHTML = nodata;
    	                return;
        	        }
            	    document.getElementById("BoardList").innerHTML = "";
                	var listHTML = "";
                	var xmldom = xml;

	                var RowCnt = xmldom.getElementsByTagName("ROW").length;

                	if (RowCnt > 0) {
	                    if (RowCnt > 4)
    	                    RowCnt = 4;

                    	var pfirstItemID = "";

	                    pfirstItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(0));
                    	listHTML = "<dl onclick=\"openDoc('" + pfirstItemID + "')\" class='nt_pic' style='cursor:pointer'>";

	                    var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(2));

	                    listHTML += "<dt class='tit'><strong>" + DOCTITLE + "</strong></dt>";
                    	listHTML += "<dd class='photo'><img src='/images/" + strLang1 + "/main/notice_pic.gif' width='83' height='54' alt=''></dd>";
                    	listHTML += "<dd id='content' class='txt'></dd>";
                    	listHTML += "</dl>";
	                    listHTML += "<ul class=\"mainlist \">";
	                    
                    	for (var i = 1; i < RowCnt; i++) {
	                        var DOCTITLE = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(2));
	                        var pItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(0));

    	                    listHTML += "<li  style='cursor:pointer' onclick=\"openDoc('" + pItemID + "')\" >" + DOCTITLE + "</li>";
                    	}
                    	listHTML += "</ul>";
                    	document.getElementById("BoardList").innerHTML = listHTML;
                    	getContent(pfirstItemID);
                	} else {
                    	var nodata = "<div class='nodata_portlet '>";
                    	nodata += "<p><img src='/images/" + strLang1 + "/main/nodata_gray.gif' width='107' height='70'></p>";
                    	nodata += "<p>" + strLang2 + "</p></div>";

                    	document.getElementById("BoardList").innerHTML = nodata;
                	}
            	} catch (e) {
            	}
        	}
        	
        	function openDoc(pItemID) {
            	var pheight = window.screen.availHeight;
            	var pwidth = window.screen.availWidth;
            	var pTop = (pheight - 720) / 2;
            	var pLeft = (pwidth - 765) / 2;

            	if (pBoardType == "3" || pBoardType == "4")
                	window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
            	else {
                	if (CrossYN() || pNoneActiveX == "YES")
	                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
                	else
	                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&BoardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
            	}
	        }

    	    var xmlhttp5 = createXMLHttpRequest();
    	    
        	function getContent(pItemID) {
            	xmlhttp5 = createXMLHttpRequest();
            	var xmlpara = createXmlDom();
            	var objNode;
            	createNodeInsert(xmlpara, objNode, "PARAMETER");
            	createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
            	createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemID);
            	xmlhttp5.open("POST", "/myoffice/ezBoardSTD/aspx/Get_ItemInfo.aspx", true);
            	xmlhttp5.onreadystatechange = getContent_after;
            	xmlhttp5.send(xmlpara);
        	}
        	
        	function getContent_after() {
            	if (xmlhttp5 == null || xmlhttp5.readyState != 4) return;
            	try {
                	var xmldom = xmlhttp5.responseXML;
                	xmlhttp5 = null;
                	var tempStr;
                	if (getNodeText(xmldom.getElementsByTagName("MainContent").item(0)) == "") {
                    	var strContentHref = getNodeText(xmldom.getElementsByTagName("ContentLocation").item(0));
                    	var ConverContentUrl = location.protocol + "//" + location.host + "/myoffice/Common/DownloadAttach.aspx?filepath=" + strContentHref;
                    	tempStr = ConvertMHTtoHTML(ConverContentUrl);
                	} else {
                    	tempStr = getNodeText(xmldom.getElementsByTagName("MainContent").item(0));
                	}
                	
                	var DocContentObject = document.createElement("DIV");
                	DocContentObject.innerHTML = tempStr;
                	var DocContentObject_Div = document.createElement("DIV");
                	DocContentObject_Div.innerHTML = CrossYN() ? DocContentObject.textContent.replace(/<P>/gi, "").replace(/<\/P>/gi, "") : DocContentObject.innerText.replace(/<P>/gi, "").replace(/<\/P>/gi, "");
                	if (CrossYN())
                    	DocContentObject.innerHTML = DocContentObject_Div.textContent.replace(/(\r\n)/g, "");
                	else
	                    DocContentObject.innerHTML = DocContentObject_Div.innerText.replace(/(\r\n)/g, "");

    	            document.getElementById("content").appendChild(DocContentObject);
	            } catch (e) {
            	}
        	}
        	
        	function boardChangeTab(obj) {
	            switch (obj.id) {
                	case "Board0":
                    	document.getElementById("Board0").className = "on";
                    	document.getElementById("Board1").className = "";
                    	document.getElementById("Board2").className = "";
                    	break;

                	case "Board1":
                    	document.getElementById("Board0").className = "";
                    	document.getElementById("Board1").className = "on";
                    	document.getElementById("Board2").className = "";
                    	break;

                	case "Board2":
	                    document.getElementById("Board0").className = "";
                    	document.getElementById("Board1").className = "";
                    	document.getElementById("Board2").className = "on";
                    	break;
            	}	
            	pBoardID = document.getElementById(obj.id).getAttribute("DATA1");
            	pBoardType = document.getElementById(obj.id).getAttribute("TYPE");
            	getBoardList();
        	}

        	function Boardmore_btnClick() {
	            location.href = "/ezBoard/boardMainRedirect.do?boardID=" + pBoardID;
        	}

        	function refresh_onclick() {
            	if (document.getElementById("Board0").className == "on") {
	                pBoardID = document.getElementById("Board0").getAttribute("DATA1");
                	getBoardList();
            	} else if (document.getElementById("Board1").className == "on") {
                	pBoardID = document.getElementById("Board1").getAttribute("DATA1");
                	getBoardList();
            	} else {
                	pBoardID = document.getElementById("Board2").getAttribute("DATA1");
                	getBoardList();
            	}
        	}
        	
        	function OpenUserInfo(pUserID) {
            	var heigth = window.screen.availHeight;
            	var width = window.screen.availWidth;
            	var left = (width - 500) / 2;
            	var top = (heigth - 400) / 2;
            	window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
        	}
		</script>
	</head>
	<body  class="body_bg1">
    	<article class="portlet_notice">
        	<p class="title"><img src="/images/<spring:message code='ezHome.t00025'/>/main/notice_title.gif" alt=""> <span onclick='Boardmore_btnClick()' class="btn_more"><img src="/images/<spring:message code='ezHome.t00025'/>/main/btn_more01.gif" alt="more"></span></p>
        	<dl class="notice_tab">
          		<dt id="Board0" DATA1="${pCompanyBoard}" TYPE="${pCompanyType}" onclick="boardChangeTab(this)" class="on"><span>${pCompanyBDNM}</span></dt>
          		<dt id="Board1" DATA1="${pDeptBoardID}" TYPE="${pDeptType}" onclick="boardChangeTab(this)"><span>${pDeptBDNM}</span></dt>
          		<dt id="Board2" DATA1="${pNewsBoardID}" TYPE="${pNewsType}" onclick="boardChangeTab(this)"><span>${pNewsBDNM}</span></dt>
        	</dl>
          <div id="BoardList" ></div>
      	</article>

    	<div id="featured" style="float:left;"> 
        	<c:choose>
	            	<c:when test="${not empty sliderList}">
	            		<c:forEach items="${sliderList}" varStatus="slider">
							<img src="${sliderList.imagePath}" style="width:467px;height:200px"/>
						</c:forEach>
	            	</c:when>
	            	<c:otherwise>
		            	<img src="/images/WebPartSliderCI/img0.png" />
			    		<img src="/images/WebPartSliderCI/img1.png" />
			    		<img src="/images/WebPartSliderCI/img2.png" />
			    		<img src="/images/WebPartSliderCI/img3.png" />
	            	</c:otherwise>
	            </c:choose>
		</div>

	    <article class="portlet_side" style="float:left;margin-left:27px;">
    	    <p class="title"><img src="/images/<spring:message code='ezHome.t00025'/>/main/side_title.gif" alt=""></p>
	        <div class="event" style="padding-top:0px;"><img src="/images/<spring:message code='ezHome.t00025'/>/main/event.gif" width="155" height="179"></div>
        	<%
        	PersonalGetEmpOfMonthVO result = (PersonalGetEmpOfMonthVO)request.getAttribute("result");
        	%>
        	<% if (result != null) { %>
        		<div class="best">
        			<dl>
        				<dt><span class="icon"><img src="/images/<spring:message code='ezHome.t00025' />/main/icon_best1.gif" width="26" height="28"></span><spring:message code='ezHome.t68' /></dt>
        				<dd class="photo"><img src="${filePath}" width="75" height="77"></dd>
        				<dd class="txt_name">
            				<span style="cursor:pointer" onclick="OpenUserInfo('${result.cn}')">
                				${displayName}
            				</span>
        				</dd>
        				<dd class="txt_part">${description}</dd>
        			</dl>
        		</div>
        		<% } else{ %>
        			<div class="best">
        				<dl>
        					<dt><span class="icon"><img src="/images/<spring:message code='ezHome.t00025' />/main/icon_best1.gif" width="26" height="28"></span><spring:message code='ezHome.t68' /></dt>
        					<dd class="nodata_portlet"><img src="/images/kr/main/nodata_white.gif" width="107" height="70"><br /> <span><spring:message code='ezHome.t00026' /></span></dd>
        				</dl>
        			</div>
        		<%} %>
    	</article>
	</body>
</html>