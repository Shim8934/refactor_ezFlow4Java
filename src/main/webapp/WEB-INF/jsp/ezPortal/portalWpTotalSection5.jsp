<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<link rel="stylesheet" href="/css/main.css" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    	<script type="text/javascript">
	        //생일
        	var month = "${curMon}";
        	var totalCnt = 0;
        	var totalPage = 0;
        	var curPage = 0;
        	var EndCnt = 10;
        	var timer;
        	var xmlhttp = createXMLHttpRequest();
        	var strLang1 = "<spring:message code='main.t00026'/>";
        	document.onselectstart = function () { return false; };
        	//생일

        	//포토
        	var pBoardType = "4";
        	var pBoardID = "${pPhotoGalleryID}";
        	var strLang1 = "<spring:message code='main.t00026'/>";
	        var OrderCell = "";
        	var OrderOption = "";
        	var totalPage = "";
        	var CurPage = 1;
        	//포토

        	window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
    	            document.body.style.MozUserSelect = 'none';
                	document.body.style.WebkitUserSelect = 'none';
                	document.body.style.khtmlUserSelect = 'none';
                	document.body.style.oUserSelect = 'none';
                	document.body.style.UserSelect = 'none';
            	}

	            if ("${userInfo.lang}" != "1") {
    	            document.getElementById("kordisplay").style.display = "none";
	                var txtmonth;
    	            switch (month.toString()) {
        	            case "01": txtmonth = "January birthdays";
            	            break;
                	    case "02": txtmonth = "February birthdays";
                        	break;
                    	case "03": txtmonth = "March birthdays";
	                        break;
                    	case "04": txtmonth = "April birthdays";
	                        break;
                    	case "05": txtmonth = "May birthdays";
	                        break;
                    	case "06": txtmonth = "June birthdays";
	                        break;
                    	case "07": txtmonth = "July birthdays";
	                        break;
                    	case "08": txtmonth = "August birthdays";
	                        break;
                    	case "09": txtmonth = "September birthdays";
	                        break;
                    	case "10": txtmonth = "October birthdays";
	                        break;
                    	case "11": txtmonth = "November birthdays";
	                        break;
                    	case "12": txtmonth = "December birthdays";
	                        break;
                    	default: txtmonth = "birthdays";
	                        break;
	                }

    	            if (CrossYN())
                    	document.getElementById("curMontxt").textContent = txtmonth;
                	else
	                    document.getElementById("curMontxt").innerText = txtmonth;
            	}

            	if (CrossYN())
	                document.getElementById("curMon").textContent = month;
            	else
	                document.getElementById("curMon").innerText = month;

            	getbirthUserList();
            	getBoardList();

            	try { top.onresize() } catch (e) { }
        	}

        	//포토
        	function getBoardList() {
	            var xmlpara = createXmlDom();
    	        var objNode;
            	createNodeInsert(xmlpara, objNode, "PARAMETER");
            	createNodeAndInsertText(xmlpara, objNode, "pBoardType", pBoardType);
            	createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
            	createNodeAndInsertText(xmlpara, objNode, "pPageNum", CurPage);
            	createNodeAndInsertText(xmlpara, objNode, "orderCell", OrderCell);
            	createNodeAndInsertText(xmlpara, objNode, "orderOption", OrderOption);
	
    	        xmlhttp = null;
        	    xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezBoard/getImagePortletList.do", true);
            	xmlhttp.onreadystatechange = getBoardList_after;
            	xmlhttp.send(xmlpara);
        	}
        	var perCnt = "";
        	
        	function getBoardList_after() {
            	if (xmlhttp == null || xmlhttp.readyState != 4) return;
            	var cntNode = SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/TOTALCNT");
            	var perNode = SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/PERSONALCNT");
            	var pagenode = SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/PAGECNT");
            	var lstCnt = getNodeText(cntNode);
            	var pageCnt = getNodeText(pagenode);
            	perCnt = getNodeText(perNode);
            	totalPage = Math.ceil(new Number(pageCnt / perCnt));

	            document.getElementById("photoul").innerHTML = "";
            	var start_li = document.createElement("li");
            	start_li.className = "btn_area";
            	start_li.innerHTML = "<img src=\"/images/kr/main/btn_prev2.gif\" width=\"10\" height=\"17\" onclick=\"Pagenationimage('PREV')\">";
            	document.getElementById("photoul").appendChild(start_li);
	
	            var cnt = GetChildNodes(SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/LISTVIEWDATA/ROWS")).length;
	            
            	if (cnt > 0) {
                	for (var i = 1; i < cnt + 1; i++) {
	                    var Imgsrc = getNodeText(GetChildNodes(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[0])[5]);
    	                var ItemID = getNodeText(GetChildNodes(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[0])[2]);
        	            var BoardID = getNodeText(GetChildNodes(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[0])[1]);
            	        var ImgTitle = getNodeText(GetChildNodes(GetChildNodes(SelectSingleNodeNew(xmlhttp.responseXML, "DOCLIST/LISTVIEWDATA/ROWS"))[i - 1])[2]);

                	    var _li = document.createElement("li");
	                    var _span1 = document.createElement("span");
                    	_span1.className = "photo";
                    	
                    	//2016-08-23
                    	//var imgSrc = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDTHUM&BOARDID=" + escape(BoardID) + "&FILENAME=" + Imgsrc.substring(Imgsrc.lastIndexOf("/") + 1, Imgsrc.length);
                    	var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + encodeURI(BoardID) + "&fileName=" + Imgsrc.substring(Imgsrc.lastIndexOf("/") + 1, Imgsrc.length);
                    	_span1.innerHTML = "<img src=\"" + imgSrc + "\" width=\"80\" height=\"80\" onclick=\"ItemRead_onclick(this)\" DATA1=\"" + BoardID + "\" DATA2=\"" + ItemID + "\">";
	
                    	var _span2 = document.createElement("span");
                    	_span2.className = "ptxt";
                    	
                    	if (CrossYN())
                        	_span2.textContent = ImgTitle;
                    	else
	                        _span2.innerText = ImgTitle;
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
                	nodata += "<p>" + strLang1 + "</p></div>";

	                document.getElementById("photoul").innerHTML = nodata;
            	}
	        }
        	
        	function Pagenationimage(page) {
	            switch (page) {
                	case "PREV":
	                    if (CurPage != 1)
    	                    CurPage--;
        	            break;
            	    case "NEXT":
                	    if (CurPage < totalPage)
                    	    CurPage++;
                    	break;
            	}
            	getBoardList();
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
	            parent.location.href = "/ezBoard/mainRedirect.do?boardID=" + pBoardID;
    	    }
        	
        	function refresh_onclick() {
	            getBoardList();
    	    }
        	//포토

	        //배너
    	    function Img_OnClick() {
        	    var pheight = window.screen.availHeight;
            	var pwidth = window.screen.availWidth;
            	var pTop = (pheight - 750) / 2;
            	var pLeft = (pwidth - 1000) / 2;

            	window.open("/help/help.aspx", "", "height=700px,width=1000px,top=" + pTop + ",left = " + pLeft + "status = no, toolbar=no, menubar=no, location=no, resizable=0");
        	}
        	//배너

	        //생일
        	function getbirthUserList() {
	            window.clearTimeout(timer);
            	xmlhttp = createXMLHttpRequest();
            	xmlhttp.open("POST", "/ezPersonal/mainBirthUserList.do?mon=" + month, false);
            	//xmlhttp.onreadystatechange = getbirthUserList_after;
            	xmlhttp.send();

            	if (xmlhttp == null || xmlhttp.readyState != 4) return;
            	if (document.getElementById("userlist").innerHTML != "") document.getElementById("userlist").innerHTML = "";
            	if (SelectSingleNodeNew(xmlhttp.responseXML, "DATA/ROW") != null) getbirthUserList_after(xmlhttp.responseXML);
            	else {
	                document.getElementById("birthcont").style.display = "none";
    	            document.getElementById("nodata").style.display = "";
        	    }
        	}
        	var userLang = "${userInfo.lang}";
        	function getbirthUserList_after(xmldom) {
	            //if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            //if (document.getElementById("userlist").innerHTML != "") document.getElementById("userlist").innerHTML = "";
	            //if (SelectSingleNodeNew(xmldom, "DATA/ROW") != null) {
    	       totalCnt = GetChildNodes(SelectSingleNodeNew(xmldom, "DATA")).length;
        	   totalPage = Math.ceil(totalCnt / EndCnt);
               document.getElementById("birthcont").style.display = "";
               document.getElementById("nodata").style.display = "none";
               for (var i = 0; i < totalCnt; i++) {
               	var cn = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "CN");
				var birthType = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "BIRTHTYPE");
				var birthDate = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "BIRTH");
				var userName = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "DISPLAYNAME");
				if(userLang != "1") {
                	userName = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "DISPLAYNAME2");
				}
				var userTitle = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "TITLE");
                if (userLang != "1") {
					userTitle = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "TITLE2");
                }
				var _li = document.createElement("li");
                _li.style.display = "none";
                _li.style.cursor = "pointer";
                _li.onclick = new Function("OpenUserInfo('" + cn + "');");
                
                if (CrossYN()) {
					_li.textContent = "[" + birthDate + "]" + userName + " " + userTitle;
                } else {
					_li.innerText = "[" + birthDate + "]" + userName + " " + userTitle;
				}
                document.getElementById("userlist").appendChild(_li);

                if (i >= (curPage * 10) && i < (curPage + 1) * 10) {
                	document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'block';
				} else {
                  	document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'none';
				}
			}
     		curPage++;
            if (curPage >= totalPage) {
            	curPage = 0;
			}
			if (totalCnt > EndCnt) {
            	timer = window.setInterval("intervalList()", 5000);
			}
            //}
            //else {
            //    document.getElementById("birthcont").style.display = "none";
            //    document.getElementById("nodata").style.display = "";
            //}
        }
        	
        function intervalList() {
            for (var i = 0; i < totalCnt; i++) {
                if (i >= (curPage * 10) && i < (curPage + 1) * 10) {
                    document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'block';
                } else {
                    document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'none';
                }
            }
            curPage++;
            if (curPage >= totalPage) {
                curPage = 0;
            }
        }
        function moveBirth(page) {
            switch (page) {
                case "PREV":
                    if (month != 1)
                        month = month - 1;
                    else
                        month = 12;
                    break;
                case "NEXT":
                    if (month != 12)
                        month = Number(month) + 1;
                    else
                        month = 1;
                    break;
            }
            if (month < 10 && String(month).length == 1)
                month = "0" + month;

            if ("${userInfo.lang}" != "1") {
                document.getElementById("kordisplay").style.display = "none";

                var txtmonth;
                switch (month.toString()) {
                    case "01": txtmonth = "January birthdays";
                        break;
                    case "02": txtmonth = "February birthdays";
                        break;
                    case "03": txtmonth = "March birthdays";
                        break;
                    case "04": txtmonth = "April birthdays";
                        break;
                    case "05": txtmonth = "May birthdays";
                        break;
                    case "06": txtmonth = "June birthdays";
                        break;
                    case "07": txtmonth = "July birthdays";
                        break;
                    case "08": txtmonth = "August birthdays";
                        break;
                    case "09": txtmonth = "September birthdays";
                        break;
                    case "10": txtmonth = "October birthdays";
                        break;
                    case "11": txtmonth = "November birthdays";
                        break;
                    case "12": txtmonth = "December birthdays";
                        break;
                    default: txtmonth = "birthdays";
                        break;

                }

                if (CrossYN())
                    document.getElementById("curMontxt").textContent = txtmonth;
                else
                    document.getElementById("curMontxt").innerText = txtmonth;
            }


            if (CrossYN())
                document.getElementById("curMon").textContent = month;
            else
                document.getElementById("curMon").innerText = month;
            curPage = 0;
            getbirthUserList();
        }
        
        function OpenUserInfo(pUserID) {
            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;
            var left = (width - 500) / 2;
            var top = (heigth - 400) / 2;
            window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
        }
        //생일
    	</script>
	</head>
	<body class="body_bg1">
    	<%--  배너 --%>
    	<article class="gw_banner">
    		<img src="/images/<spring:message code='main.t00025'/>/main/manual.gif" width="208" height="168" usemap="#Map_gwb" style="cursor:pointer" onclick="Img_OnClick()">
    			<map name="Map_gwb">
      				<area alt="" shape="rect" coords="252,8,344,47" href="#">
    			</map>
    	</article>
    	<%--  배너 --%>

    	<%--포토--%>
    	<article class="portletbox photobox ">
	        <div class="title_nb">
    	        <span class="tl_nb"></span><span class="tr_nb"></span><span class="title_txt"><spring:message code='main.t1007'/></span>
        	    <span class="btn_more" onclick="Boardmore_btnClick()">
            	    <img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008'/>">
            	</span>
        	</div>
        	<div class="photocont">
	            <ul id="photoul"></ul>
        	</div>
        	<div class="guide"><span class="lb"></span><span class="rb"></span></div>
    	</article>
    	
    	<%--포토--%>

    	<%-- 생일 --%>
    	<article class="portletbox birthbox " style="float:left; margin-left:27px;">
	        <div class="title">
    	        <span class="tl"></span>
        	    <span class="tr"></span>
	            <span class="title_txt">
    	            <img src="/images/kr/main/btn_prev1.gif" width="21" height="17" class="btn_img" onclick="moveBirth('PREV')">
        		        <span id="kordisplay">
                    		<span id="curMon"></span><spring:message code='main.t1002'/>
                		</span>
                		<span id="curMontxt"></span>
                		<img src="/images/kr/main/btn_next1.gif" width="21" height="17" class="btn_img" onclick="moveBirth('NEXT')">
                			<span class="t11"><spring:message code='main.t1003'/></span>
            	</span>
        	</div>
        	<div class="birthcont" id="birthcont">
				<ul class="fl" id="userlist"></ul>
        	</div>
        	<div class="birthcont" id="nodata" style="display: none;">
            	<div class="nodata_portlet">
	                <p>
    	                <img src="/images/kr/main/nodata_white.gif" width="107" height="70" />
        	        </p>
            	    <p>
                	   <spring:message code='main.t00026'/>
                	</p>
            	</div>
        	</div>
        	<div class="guide"></div>
    	</article>
    	<%-- 생일 --%>
	</body>
</html>