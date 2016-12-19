<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezAddress.t2" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <style type="text/css">
	        html { height:100%; }
	        body { height:100%; margin:0; }
	        input,button { margin:0; outline:none; color:#4f5964; font-size:1em; line-height:1em; }
	        textarea { margin:0; outline:none; color:#4f5964; font-size:1em; line-height:1.25em; }
	        img { border:0 none; vertical-align:top; }
	        hr,caption { display:none; }
	        strong { font-weight:bold; }
	        em { font-style:normal; }
	        a { text-decoration:none; color:#0066cc; }
	        a:hover { text-decoration:underline; }
	        cite { font-style:normal; }
	        address { font-style:normal; }
	        article {  }
	        article:after { clear:both; display:block; content:''; }
	        article,aside,canvas,details,figcaption,figure, footer,header,hgroup,menu,nav,section,summary { 
	            display:block;
	         }
	        .searchWrap{padding:15px;}
	        .searchWrap form{font-size:100%; margin:0px; padding:0px;}
	        .searchDesignBtn{float:right;}
	        .searchDesign{float:none; border:3px solid #414347; padding:7px; margin:0px 60px 0px 0px;} 
	        .searchWrap input[type="text"] {width: 100%; height: 20px; padding:0px; margin:0px; border:0 none; font-size: 15px; font-weight: bold; vertical-align:top;}
	    </style>
	    <link rel="stylesheet" type="text/css" href="/css/jquery.selectbox.ZipCode.css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.selectbox-0.2.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
		<script type="text/javascript" language="javascript">
			$(function () {
	            $("#Sido").selectbox();
	            $(".sbHolder").each(function (index) {
	                $(this).addClass('instance');
	            });
	        });
			
			var g_xmlHTTP = null;
	        var CurPage = 1;
	        var totalPage;
	        var pagesize = 20;
	        var ReturnFunction;
		    
		    window.onload = function () {
	            try {
	                ReturnFunction = opener.address_zip_select_dialogArguments[1];
	            } catch (e) {
	                try{
	                    ReturnFunction = parent.address_zip_select_dialogArguments[1];
	                }
	                catch (e) { }
	            }

	            _html = "<table class='mainlist' style='width:100%;'>";
	            _html += "<tr \>";
	            _html += "<td style='color:gray;border:0px'>" + "<spring:message code='ezPersonal.t20005' />" + "</td>";
	            _html += "</tr>";
	            _html += "</table>";

	            document.getElementById("AddressList").innerHTML = _html;
	        }
		    
		    function SearchAddress() {
	            if (document.getElementById("Sido").selectedIndex == 0 || document.getElementById('keyword').value == "") {
	                alert("<spring:message code='ezPersonal.t5000' />");
	                document.getElementById("Sido").focus();
	                return;
	            }
	            document.getElementById("ProgressBar").style.display = "";
	            document.getElementById("AddressListTr").style.display = "none";

	            var xmlpara = createXmlDom();
	            var objRoot, objNode;
	            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "SIDO", GetSelectVal("Sido"));
	            createNodeAndInsertText(xmlpara, objNode, "KEYWORD", document.getElementById('keyword').value);
	            createNodeAndInsertText(xmlpara, objNode, "PAGE", CurPage);
	            g_xmlHTTP = createXMLHttpRequest();
	            g_xmlHTTP.open("POST", "/ezAddress/addressZipCodeList.do", true);
	            g_xmlHTTP.onreadystatechange = event_AddressList;
	            g_xmlHTTP.send(xmlpara);
	        }
		    
		    function event_AddressList() {
	            if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	                if (g_xmlHTTP.statusText == "OK") {
	                    document.getElementById("ProgressBar").style.display = "none";
	                    document.getElementById("AddressListTr").style.display = "";

	                    XmlNode = loadXMLString(g_xmlHTTP.responseText);
	                    _html = "<table class='mainlist' style='width:100%;'>";
	                    if (SelectNodes(XmlNode, "DATA/ROW").length > 0) {
	                        for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                            var _Value;
	                            _html += "<tr onmouseover='event_Mover(this);' onmouseout='event_Mout(this);'>";
	                            _html += "<td style='width:15%;color:gray;'>" + getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ZIPCODE")[0]) + "</td>";
	                            _html += "<td style='width:75%;color:gray;text-align: left'>" + "<spring:message code='ezPersonal.t910' />" + " : <span>" + getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DORO")[0]) + "</span><br />";
	                            _html += "<span>" + "<spring:message code='ezPersonal.t5002' />" + " : " + getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "JIBUN")[0]) + "</span></td>";
	                            _html += "<td style='width:10%;color:gray;'><a class='imgbtn' onClick='choice_address(this)'><span>" + "<spring:message code='ezPersonal.t00006' />" + "</span></a></td>";
	                            _html += "</tr>";
	                        }
	                        _html += "</table>";
	                        document.getElementById("AddressList").style.border = "0px";
	                        document.getElementById("AddressList").innerHTML = _html;
	                        totalcount = parseInt(getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA")[0], "TOTALCOUNT")[0]));
	                        makePageSelPage();
	                    }
	                    else {
	                        document.getElementById("AddressList").style.border = "";
	                        document.getElementById("AddressList").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td style='color:gray;border:0px'> " + "<spring:message code='ezPersonal.t20005' />" + "</td></tr></table>";
	                    }

	                    g_xmlHTTP = null;                    
	                }
	                else {
	                    alert("<spring:message code='ezPersonal.t60' />" + g_xmlHTTP.statusText);
	                }

	            	g_xmlHTTP = null;
	        	}
	        }
		    
		    function event_Mover(obj) {
	            if (obj != _RowObject) {
	                obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
	                obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
	                obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
	            }
	        }
	        function event_Mout(obj) {
	            if (obj != _RowObject) {
	                obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
	                obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
	                obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
	            }
	        }
	        var _RowObject = null;
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
		    
		    function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            strtext = "<div class='pagenavi'>";
	            PagingHTML += strtext;
	            totalPage = Math.ceil(new Number(totalcount / pagesize));
	            var pageNum = CurPage;
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
	                PagingHTML += strtext;
	            }
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezPersonal.t10000' />" + "</span>";
	                    PagingHTML += strtext;
	                }
	                else {
	                    strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezPersonal.t10000' />" + "</span>";
	                    PagingHTML += strtext;
	                }
	            }
	            else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezPersonal.t10000' />" + "</span>";
	                PagingHTML += strtext;
	            }
	            var MaxNum;
	            var i;
	            var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	            if (totalPage >= (startNum + parseInt(BlockSize))) {
	                MaxNum = (startNum + parseInt(BlockSize)) - 1;
	            }
	            else {
	                MaxNum = totalPage;
	            }
	            for (i = startNum; i <= MaxNum; i++) {
	                if (i == pageNum) {
	                    strtext = "<span class='on'>" + i + "</span>";
	                    PagingHTML += strtext;
	                }
	                else {
	                    strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                    PagingHTML += strtext;
	                }
	            }
	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezPersonal.t10001' />" + "</span>";
	                    strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	                else {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezPersonal.t10001' />" + "</span>";
	                    strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	            }
	            else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezPersonal.t10001' />" + "</span>";
	                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            PagingHTML += "</div>";
	            td_Create1(PagingHTML);
	        }
		    
		    function goToPageByNum(Value) {
	            CurPage = Value;
	            makePageSelPage();
	            SearchAddress();
	        }
	        function selbeforeBlock() {
	            var pageNum = CurPage;
	            pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        } function selbeforeBlock_one() {
	            var pageNum = CurPage;
	            if (parseInt(pageNum - 1) > 0)
	                goToPageByNum(parseInt(pageNum - 1));
	            else
	                return;
	        }
	        function selafterBlock() {
	            var pageNum = CurPage;
	            pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	        function selafterBlock_one() {
	            var pageNum = CurPage;
	            if (parseInt(pageNum + 1) <= totalPage)
	                goToPageByNum(parseInt(pageNum + 1));
	            else
	                return;
	        }

	        function choice_address(obj) {
	            var SelectElement = obj.parentElement.parentElement;

	            var ReturnValue = new Array();

	            ReturnValue[0] = getNodeText(SelectElement.childNodes[0]);
	            ReturnValue[1] = getNodeText(SelectElement.childNodes[1].childNodes[1]);
	            if (ReturnFunction != undefined)
	                ReturnFunction(ReturnValue);
	            else
	                window.returnValue = ReturnValue;
	            window.close();
	        }

	        function window_close() {
	            if (ReturnFunction != undefined)
	                ReturnFunction("cancel");
	            window.close();
	        }

	        function SearchAddress_KeyPress(evt) {
	            if (window.event) {
	                if (window.event.keyCode == 13) {
	                	resetCurPageAndSearchAddress();
	                    event.returnValue = false;
	                }
	            }
	            else {
	                if (evt.keyCode == "13") {
	                	resetCurPageAndSearchAddress();
	                }
	            }
	        }

	        function ChangeSubtitle() {
	        }
	        
	        function resetCurPageAndSearchAddress() {
	        	CurPage = 1;
	        	SearchAddress();
	        }
	    </script>
	</head>
	<body class="popup" style="overflow:hidden">
	    <h1><spring:message code='ezPersonal.t5003' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="window_close()"><spring:message code='ezPersonal.t10' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>	    
	    <div id="main_body">   
	        <table class="content" style="border:0px">
	            <tr>
	                <td style="width:100px;border:0px">
	                    <select style="width:auto;" id="Sido" name="Sido">
	                    	<option value="<spring:message code='main.t242' />"><spring:message code='main.t242' /></option>
	                    	${sido}
	                    </select>
	                </td>
	                <td style="border:0px">
	                    <div class="searchWrap" style="padding-left:4px">
			            	<div class="searchDesignBtn" onclick="resetCurPageAndSearchAddress()">
			                	<input type="image" <spring:message code='ezPersonal.t5004' /> id="btnImgSrch" alt="<spring:message code='ezPersonal.t83' />"><img <spring:message code='ezPersonal.t5004' /> id="searchingBtnImg" style="display:none;" alt="<spring:message code='ezPersonal.t83' />">
			            	</div>
	                    	<div class="searchDesign">
			                	<input type="text" name="keyword" id="keyword" size="50" value="" onkeypress="SearchAddress_KeyPress(event)">
			            	</div>
		            	</div>
	                </td>
	            </tr>
	        </table>
	        <div style="height: 449px;">
	            <table class="mainlist" style="width: 100%;">
	                <tr>
	                    <th style="width: 15%;text-align:center"><span><spring:message code='ezPersonal.t181' /></span></th>
	                    <th style="width: 70%;text-align:center"><span><spring:message code='ezPersonal.t76' /></span></th>
	                    <th style="width: 15%;text-align:center"><span><spring:message code='ezPersonal.t00006' /></span></th>
	                </tr>
	            </table>
	            <div id="contentlist" style="height: 413px; overflow-y: auto;">
	                <table class="mainlist" style="width: 100%;">
	                    <tr id="ProgressBar" style="display:none">
	                        <td style="text-align: center;">
	                            <img src="/images/email/progress_img.gif" />
	                        </td>
	                    </tr>
	                    <tr id="AddressListTr">
	                        <td id="AddressList" style="text-align: center;padding-left:0px;padding-right:0px">
	                        </td>
	                    </tr>
	                </table>
	            </div>
	        </div>
	        <div id="tblPageRayer" style="margin-bottom: 10px;"></div>
	    </div>
	</body>
</html>