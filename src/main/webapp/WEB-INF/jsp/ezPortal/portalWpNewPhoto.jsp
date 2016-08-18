<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<section  class="body_bg1">
			 <article class="portletbox photobox ">
        		<div class="title_nb">
            		<span class="tl_nb"></span><span class="tr_nb"></span><span class="title_txt"><spring:message code='ezHome.t1007' /></span>
            		<span class="btn_more" onclick="Boardmore_btnClick()">
                		<img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='ezHome.t1008' />">
            		</span>
        		</div>
        		<div class="photocont">
        		<%
		 			String pExist = (String)request.getAttribute("pExist");
		 		%>
            		<%if(pExist == "true"){ %>
            			<ul id="photoul">
                			<li class="btn_area">
                    			<img src="/images/kr/main/btn_prev2.gif" width="10" height="17" onclick="Pagenationimage('PREV')">
                			</li>
            				<asp:Repeater ID="PhotoListRepeater" runat="server">  
                				<ItemTemplate>
                					<%-- <li>
                    					<span class="photo">
                        					<img src="<%# Request.Url.Scheme + "://" + GetSystemConfigValue("PORTAL_REMOTEURL") + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDTHUM&BOARDID=" + ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA1")[0].InnerText + "&FILENAME=" +  ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA5")[0].InnerText.Split('/')[((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA5")[0].InnerText.Split('/').Length -1] %>" 
                            					width="80" height="80" onclick="ItemRead_onclick(this)" 
                            					DATA1="<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA1")[0].InnerText %>" 
                            					DATA2="<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA2")[0].InnerText %>">
                    					</span>
                    					<span class="ptxt" DATA1="<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA1")[0].InnerText %>" 
                        					DATA2="<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DATA2")[0].InnerText %>" onclick="ItemRead_onclick(this)">
                        					<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("VALUE")[2].InnerText %>
                    					</span>
                					</li> --%>
                				</ItemTemplate>
            				</asp:Repeater>
                			<li class="btn_next">
                    			<img src="/images/kr/main/btn_next2.gif" width="10" height="17" onclick="Pagenationimage('NEXT')">
                			</li>
            			</ul>
            		<%}else{ %>
            			<div class='nodata_portlet '>
            				<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>
            				<p><spring:message code='ezHome.t00026' /></p>
            			</div>
            		<%} %>
        		</div>
        		<div class="guide"><span class="lb"></span><span class="rb"></span></div>
    		</article>
		</section>
		
		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
			var pBoardType_NewPhoto = "4";
	    	var pBoardID_NewPhoto = "${pPhotoGalleryID}";
	    	var strLang1_NewPhoto = "<spring:message code='ezHome.t00026' />";
	        
	    	var OrderCell_NewPhoto = "";
	    	var OrderOption_NewPhoto = "";
	    	var totalPage_NewPhoto = "";
	    	var CurPage_NewPhoto = 1;
	    	document.onselectstart = function () { return false; };
	    	function window_onload_NewPhoto() {
	        	if (navigator.userAgent.indexOf('Firefox') != -1) {
	            	document.body.style.MozUserSelect = 'none';
	            	document.body.style.WebkitUserSelect = 'none';
	            	document.body.style.khtmlUserSelect = 'none';
	            	document.body.style.oUserSelect = 'none';
	            	document.body.style.UserSelect = 'none';
	        	}
	        	getBoardList_NewPhoto();

	        	try { top.onresize() } catch (e) { }
	    	}
	    	function getBoardList_NewPhoto() {
		        var xmlpara = createXmlDom();
		        var objNode;
	    	    createNodeInsert(xmlpara, objNode, "PARAMETER");
	        	createNodeAndInsertText(xmlpara, objNode, "pBoardType", pBoardType_NewPhoto);
	        	createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID_NewPhoto);
	        	createNodeAndInsertText(xmlpara, objNode, "pPageNum", CurPage_NewPhoto);
	        	createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell_NewPhoto);
	        	createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption_NewPhoto);

		        xmlhttp_getBoardList_NewPhoto = null;
		        xmlhttp_getBoardList_NewPhoto = createXMLHttpRequest();
	    	    xmlhttp_getBoardList_NewPhoto.open("POST", "/ezBoard/getImagePortletList.do", true);
	        	xmlhttp_getBoardList_NewPhoto.onreadystatechange = getBoardList_NewPhoto_after;
	        	xmlhttp_getBoardList_NewPhoto.send(xmlpara);
	    	}

	    	var perCnt = "";
	    	function getBoardList_NewPhoto_after() {
		        if (xmlhttp_getBoardList_NewPhoto == null || xmlhttp_getBoardList_NewPhoto.readyState != 4) return;
		        var cntNode = SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/TOTALCNT");
	    	    var perNode = SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/PERSONALCNT");
	        	var pagenode = SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/PAGECNT");
	        	var lstCnt = getNodeText(cntNode);
	        	var pageCnt = getNodeText(pagenode);
	        	perCnt = getNodeText(perNode);
	        	totalPage_NewPhoto = Math.ceil(new Number(pageCnt / perCnt));

	        	document.getElementById("photoul").innerHTML = "";
	        	var start_li = document.createElement("li");
	        	start_li.className = "btn_area";
	        	start_li.innerHTML = "<img src=\"/images/kr/main/btn_prev2.gif\" width=\"10\" height=\"17\" onclick=\"Pagenationimage('PREV')\">";
	        	document.getElementById("photoul").appendChild(start_li);

		        var cnt = GetChildNodes(SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/LISTVIEWDATA/ROWS")).length;
		        if (cnt > 0) {
	    	        for (var i = 1; i < cnt + 1; i++) {
	        	        var Imgsrc = getNodeText(GetChildNodes(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[0])[5]);
	            	    var ItemID = getNodeText(GetChildNodes(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[0])[2]);
		                var BoardID = getNodeText(GetChildNodes(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[0])[1]);
		                var ImgTitle = getNodeText(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp_getBoardList_NewPhoto.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[2]);

	    	            var _li = document.createElement("li");
	        	        var _span1 = document.createElement("span");
	            	    _span1.className = "photo";
						
	            	    //2016-08-18 urc 수정
	                	//var imgSrc = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDTHUM&BOARDID=" + escape(BoardID) + "&FILENAME=" + Imgsrc.substring(Imgsrc.lastIndexOf("/") + 1, Imgsrc.length);
						var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + encodeURI(BoardID) + "&fileName=" + Imgsrc.substring(Imgsrc.lastIndexOf("/") + 1, Imgsrc.length);

	                	_span1.innerHTML = "<img src=\"" + imgSrc + "\" width=\"80\" height=\"80\" onclick=\"ItemRead_onclick(this)\" DATA1=\"" + BoardID + "\" DATA2=\"" + ItemID + "\">";

		                var _span2 = document.createElement("span");
		                _span2.className = "ptxt";
	    	            if (CrossYN()) {
	        	            _span2.textContent = ImgTitle;
	    	            } else {
	                	    _span2.innerText = ImgTitle;
	            	    }
	                	_span2.setAttribute("DATA1", BoardID);
	                	_span2.setAttribute("DATA2", ItemID);
	                	_span2.onclick = new Function("ItemRead_onclick(this);");

	                	_li.appendChild(_span1);
	                	_li.appendChild(_span2);

	                	document.getElementById("photoul").appendChild(_li);
	            	}
	            	var end_li = document.createElement("li");
	            	end_li.className = "btn_next";
	            	end_li.innerHTML = "<img src=\"/images/kr/main/btn_next2.gif\" width=\"10\" height=\"17\" onclick=\"Pagenationimage('NEXT')\">";
	            	document.getElementById("photoul").appendChild(end_li);
	        	} else {
	            	var nodata = "<div class='nodata_portlet '>";
	            	nodata += "<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>";
	            	nodata += "<p>" + strLang1_NewPhoto + "</p></div>";

	            	document.getElementById("photoul").innerHTML = nodata;
	        	}
		    }
	        
		    function Pagenationimage(page) {
	    	    switch (page) {
	        	    case "PREV":
	                	if (CurPage_NewPhoto != 1)
	                    	CurPage_NewPhoto--;
	                	break;
	            	case "NEXT":
		                if (CurPage_NewPhoto < totalPage_NewPhoto)
		                    CurPage_NewPhoto++;
	    	            break;
	        	}
	        	getBoardList_NewPhoto();
	    	}
	    	function ItemRead_onclick(obj) {
		        var ShowAdjacent = "";
		        var pheight = window.screen.availHeight;
	    	    var pwidth = window.screen.availWidth;
	        	var pTop = (pheight - 780) / 3;
	        	var pLeft = (pwidth - 765) / 2;

		        window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + obj.getAttribute("DATA2") + "&boardID=" + obj.getAttribute("DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
		    }
	    	function Boardmore_btnClick() {
		        window.open("/ezBoard/boardMainRedirect.do?boardID=" + pBoardID_NewPhoto, "main", "");
		    }
	    	function refresh_onclick() {
		        getBoardList_NewPhoto();
		    }

	    	window_onload_NewPhoto();
		</script>
	</head>
</html>