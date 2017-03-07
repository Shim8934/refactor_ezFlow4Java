<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>main_page</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
	        var xmlhttp3 = null;
	        var xmlhttp4 = null;
	        var xmlhttp5 = null;
	        var str = "<c:out value = '${strXML}' />";
	        var strlang = "<c:out value = '${strLang}' />";
	        var totalPage = "<c:out value = '${totalPage}' />";
	        var temptotalPage = totalPage;
	        var CurPage = "1";

	        var bestclick = false;
	        var strLang1 = "<spring:message code = 'ezCommunity.t1379' />";
	        var strLang2 = "<spring:message code = 'ezCommunity.t9' />";
	        var strLang3 = "<spring:message code = 'ezCommunity.t11' />";
	        var strLang4 = "<spring:message code = 'ezCommunity.t504' />";
	        var strLang5 = "<spring:message code = 'ezCommunity.t1474' />";
	        var strLang6 = "<spring:message code = 'ezCommunity.t1079' />";
	        var strLang7 = "<spring:message code = 'ezCommunity.t1102' />";
	        var strLang8 = "<spring:message code = 'ezCommunity.t2002' />";
	        var pUse_IE11Browser = "<c:out value = '${useIE11Browser}' />";
	        
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
				};
			window.onload = function () {
		            get_todaycop();
		            get_bestCommunity();
		            get_myCommunity();
		            makePageSelPage();
		    }
	        function change_tab(val) {
	            if (val == "best") {
	                document.getElementById("best").className = "on";
	                document.getElementById("new").className = "";
	                document.getElementById("bestcomm").style.display = "";
	                document.getElementById("newcomm").style.display = "none";
	            } else if (val == "new") {
	                if (!bestclick) {
	                    get_newCommunity();
	                    bestclick = true;
	                }
	                
	                document.getElementById("best").className = "";
	                document.getElementById("new").className = "on";
	                document.getElementById("bestcomm").style.display = "none";
	                document.getElementById("newcomm").style.display = "";
	            } else if (val == "mycop") {
	                search = false;
	                document.getElementById("mycop").className = "on";
	                document.getElementById("categorycop").className = "icon_tabpartBorder";
	                document.getElementById("mycommunity").style.display = "";
	                document.getElementById("categorycommunity").style.display = "none";
	                totalPage = temptotalPage;
	                CurPage = "1";
	                get_myCommunity();
	                makePageSelPage();
	            } else if(val == "categorycop") {
	                search = false;
	                document.getElementById("mycop").className = "";
	                document.getElementById("categorycop").className = "icon_tabpartBorder on";
	                document.getElementById("mycommunity").style.display = "none";
	                document.getElementById("categorycommunity").style.display = "";
	                document.getElementById("work").className = "on";
	                document.getElementById("type").className = "line";
	                CurPage = "1";
	                get_categoryCommunity("A");
	            } else if (val == "WORK") {
	                search = false;
	                document.getElementById("work").className = "on";
	                document.getElementById("type").className = "line";
	                CurPage = "1";
	                get_categoryCommunity("A");
	            } else {
	                search = false;
	                document.getElementById("work").className = "line";
	                document.getElementById("type").className = "on";
	                CurPage = "1";
	                get_categoryCommunity("B");
	            }
	        }

	        function get_newCommunity() {
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezCommunity/getBestNewCommunity.do",
					data : { mode   : "NEW"
					},
					success: function(result){
						event_get_newCommunity(result);
					}
				});
	        }

	        function get_bestCommunity() {
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezCommunity/getBestNewCommunity.do",
					data : { mode   : "BEST"
					},
					success: function(result){
						event_get_bestCommunity(result);
					}
				});
	        }

	        function event_get_newCommunity(result) {
                var xmldom = loadXMLString(result);
                var bestcoummunity = SelectNodes(xmldom, "DATA/ROW");
                
                for (var i = 0; i < bestcoummunity.length; i++) {
                    var dl = document.createElement("DL");
                    dl.className = "newCommunity_list";

                    var dt = document.createElement("DT");

                    var img = document.createElement("IMG");
                    
                    if (SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL").indexOf("default_logo_type") > -1) {
                        img.src = "/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    }
                    
                    img.style.width = "56px";
                    img.style.height = "40px";

                    var span = document.createElement("SPAN");
                    span.className = "icon_newcommunity01";

                    var img2 = document.createElement("IMG");

                    img2.src = "/images/kr/community/icon_newCommunity04.png";

                    var dd = document.createElement("DD");

                    var span2 = document.createElement("SPAN");
                    
                    var copName = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNAME");

                    span2.innerHTML = copName + " (" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_MEMBERCNT") + "<spring:message code = 'ezCommunity.t478' />"+")";
                    span2.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNO").trim());
                    span2.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBCONFIRMTYPE"));
                    span2.style.cursor = "pointer";
                    span2.onclick = function () { move_cop(this); };

                    var dd2 = document.createElement("DD");
                    dd2.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBDESC");

                    span.appendChild(img2);
                    dt.appendChild(img);
                    dt.appendChild(span);

                    dd.appendChild(span2);

                    dl.appendChild(dt);
                    dl.appendChild(dd);
                    dl.appendChild(dd2);

                    document.getElementById("newcomm").appendChild(dl);
                }
	        }

	        function event_get_bestCommunity(result) {
                var xmldom = loadXMLString(result);

                var bestcoummunity = SelectNodes(xmldom, "DATA/ROW");
                
                for (var i = 0; i < bestcoummunity.length; i++) {
                    var dl = document.createElement("DL");
                    dl.className = "newCommunity_list";

                    var dt = document.createElement("DT");

                    var img = document.createElement("IMG");
                    
                    if (SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL").indexOf("default_logo_type") > -1) {
                        img.src = "/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    }
                    
                    img.style.width = "56px";
                    img.style.height = "40px";

                    var span = document.createElement("SPAN");
                    span.className = "icon_newcommunity01";

                    var img2 = document.createElement("IMG");

                    var order = i + 1;
                    img2.src = "/images/kr/community/icon_newCommunity0" + order + ".png";

                    var dd = document.createElement("DD");

                    var span2 = document.createElement("SPAN");
                    
                    var copName = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNAME");
                    
                    span2.innerHTML = copName + " (" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_MEMBERCNT") + "<spring:message code = 'ezCommunity.t478' />" + ")";
                    span2.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNO").trim());
                    span2.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBCONFIRMTYPE"));
                    span2.style.cursor = "pointer";
                    span2.onclick = function () { move_cop(this); };

                    var dd2 = document.createElement("DD");
                    dd2.innerHTML = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBDESC");

                    span.appendChild(img2);
                    dt.appendChild(img);
                    dt.appendChild(span);

                    dd.appendChild(span2);

                    dl.appendChild(dt);
                    dl.appendChild(dd);
                    dl.appendChild(dd2);

                    document.getElementById("bestcomm").appendChild(dl);
                }

	        }

	        function get_myCommunity() {
	        	$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommunity/myCopNewBoardItem.do",
						data : { page   : CurPage
						},
						success: function(result){
							event_get_myCommunity(result);
						}
				});
	        }

	        function event_get_myCommunity(result) {
                document.getElementById("mycommunity").innerHTML = "";
                var xmldom = loadXMLString(result);
                var table;
                
                if (SelectNodes(xmldom, "ITEM/DATA").length <= 0) {
                	return;
                }
                
                for (var i = 0; i < SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW").length; i++) {
                    var copno;

                    if (i == 0 || SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim() != copno) {
                        copno = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim();
                        table = null;
                        var div = document.createElement("DIV");
                        div.className = "tabpartMycommunity";

                        var dl = document.createElement("DL");
                        dl.className = "tabpartMycommunityTitle";
                        var dt = document.createElement("DT");

                        if (strlang == "" || strlang == "1") {
                            dt.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNAME");
                        } else {
                            dt.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNAME2");
                        }
                        
                        var dd = document.createElement("DD");
                        var span = document.createElement("SPAN");
                        span.className = "icon_community01";
                        span.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_MEMBERCNT");

                        var span2 = document.createElement("SPAN");
                        span2.className = "line";
                        
                        var span3 = document.createElement("SPAN");
                        span3.className = "icon_community02";
                        span3.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ITEMCNT");

                        var span4 = document.createElement("SPAN");
                        span4.className = "line";
                        
                        var span5 = document.createElement("SPAN");
                        span5.className = "btn_community01";
                        span5.setAttribute("code", copno);
                        span5.setAttribute("type", SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBCONFIRMTYPE"));
                        span5.onclick = function () { move_cop(this); };

                        var span6 = document.createElement("SPAN");
                        span6.innerHTML = strLang8;

                        span5.appendChild(span6);

                        dd.appendChild(span);
                        dd.appendChild(span2);
                        dd.appendChild(span3);
                        dd.appendChild(span4);
                        dd.appendChild(span5);

                        dl.appendChild(dt);
                        dl.appendChild(dd);

                        div.appendChild(dl);

                        document.getElementById("mycommunity").appendChild(div);

                        div = null;

                        div = document.createElement("DIV");
                        div.className = "tabpartMycommunityList";
                        table = document.createElement("TABLE");
                        table.style.width = "100%";
                        table.style.border = "0";
                        div.appendChild(table);
                        document.getElementById("mycommunity").appendChild(div);
                    }

                    var tr = document.createElement("TR");

                    var td = document.createElement("TD");
                    var td2 = document.createElement("TD");
                    var td3 = document.createElement("TD");
                    var td4 = document.createElement("TD");
                    
                    td.className = "text";
                    var boardid = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDID");
                    var itemid = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ITEMID");
                    var copno = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim();
                    var gubun = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "GUBUN");
                    td.style.cursor = "pointer";
                    td.setAttribute("boardid", boardid);
                    td.setAttribute("itemid", itemid);
                    td.setAttribute("gubun", gubun);
                    td.setAttribute("code", copno);
                    td.onclick = function () { ItemRead_onclick(this); };
                    
                    if (strlang == "" || strlang == "1") {
                        td.innerHTML = "[" + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDNAME") + "] " + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "TITLE");
                        td2.className = "team";
                        td2.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERDEPTNAME");
                        td3.className = "name";
                        td3.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERNAME");
                    } else {
                        td.innerHTML = "[" + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDNAME") + "] " + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "TITLE");
                        td2.className = "team";
                        td2.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERDEPTNAME2");
                        td3.className = "name";
                        td3.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERNAME2");
                    }
                    
                    td4.className = "day";
                    td4.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITEDATE").substring(0, 10);

                    tr.appendChild(td);
                    tr.appendChild(td2);
                    tr.appendChild(td3);
                    tr.appendChild(td4);
                    table.appendChild(tr);
                }
	        }

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
	            var pageNum = CurPage;
	            
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                PagingHTML += strtext;
	            }
	            
	            var MaxNum;
	            var i;
	            var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	            
	            if (totalPage >= (startNum + parseInt(BlockSize))) {
	                MaxNum = (startNum + parseInt(BlockSize)) - 1;
	            } else {
	                MaxNum = totalPage;
	            }
	            
	            for (i = startNum; i <= MaxNum; i++) {
	                if (i == pageNum) {
	                    strtext = "<span class='on'>" + i + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                    PagingHTML += strtext;
	                }
	            }
	            
	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                    strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                    strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            }
	            
	            PagingHTML += "</div>";
	            td_Create1(PagingHTML);
	        }

	        function goToPageByNum(Value) {
	            CurPage = Value;
	            makePageSelPage();
	            movePage(CurPage);
	        }
	        
	        function selbeforeBlock() {
	            var pageNum = parseInt(CurPage);
	            pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	        
	        function selbeforeBlock_one() {
	            var pageNum = parseInt(CurPage);
	            
	            if (parseInt(pageNum - 1) > 0) {
	                goToPageByNum(parseInt(pageNum - 1));
	            } else {
	                return;
	            }
	        }
	        
	        function selafterBlock() {
	            var pageNum = parseInt(CurPage);
	            pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	        
	        function selafterBlock_one() {
	            var pageNum = parseInt(CurPage);
	            
	            if (parseInt(pageNum + 1) <= totalPage) {
	                goToPageByNum(parseInt(pageNum + 1));
	            } else {
	                return;
	            }
	        }

	        function movePage(newPage) {
	            if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	                CurPage = newPage;
	                
	                if (document.getElementById("mycop").className == "on") {
	                    get_myCommunity();
	                } else if (search) {
	                    copsearchpage();
	                } else {
	                    select_category();
	                }
	            }
	        }

	        function prevPage_onclick() {
	            newPage = parseInt(CurPage) - 1;
	            
	            if (newPage > 0) {
	                CurPage = newPage;
	                
	                if (document.getElementById("mycop").className == "on") {
	                    get_myCommunity();
	                } else if (search) {
	                    copsearchpage();
	                } else {
	                    select_category();
	                }
	            }
	        }

	        function nextPage_onclick() {
	            newPage = parseInt(CurPage) + 1;
	            
	            if (newPage <= parseInt(totalPage)) {
	                CurPage = newPage;
	                
	                if (document.getElementById("mycop").className == "on") {
	                    get_myCommunity();
	                } else if (search) {
	                    copsearchpage();
	                } else {
	                    select_category();
	                }
	            }
	        }
	        
	        function get_categoryCommunity(type) {
	            $.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezCommunity/myCategoryCop.do",
					data	:	{
						mode : type
					},
					success: function(result){
						event_get_categoryCommunity(result["list"]);
					}
				});
	        }
	        
	        function event_get_categoryCommunity(list) {
                document.getElementById("categorytab").innerHTML = "";

                var ul = document.createElement("UL");
                ul.className = "left_tabpartLis";
                
                list.forEach(function(categoryVO, index) {
                	var li = document.createElement("LI");
                	
                    var a = document.createElement("A");
                    a.style.cursor = "pointer";
                    a.setAttribute("type", categoryVO.cate);
                    a.setAttribute("cnt", categoryVO.cnt);
                    a.onclick = function () { select_category(this); };
                    
                    if (index == 0) {
                        a.onclick();
                    }
                    
                    a.innerHTML = getcategoryname(categoryVO.c_Name);
                    
                    var span = document.createElement("SPAN");
                    span.innerHTML = "(" + categoryVO.cnt + ")";

                    a.appendChild(span);
                    li.appendChild(a);
                    ul.appendChild(li);
                });
                
                document.getElementById("categorytab").appendChild(ul);
	        }
	        
	        function getcategoryname(val) {
	            var retval = "";
	            
	            switch(val){
	                case "t1496":
	                    retval = "<spring:message code = 'ezCommunity.t1496' />";
	                    break;
	                case "t1497":
	                    retval = "<spring:message code = 'ezCommunity.t1497' />";
	                    break;
	                case "t1498":
	                    retval = "<spring:message code = 'ezCommunity.t1498' />";
	                    break;
	                case "t1499":
	                    retval = "<spring:message code = 'ezCommunity.t1499' />";
	                    break;
	                case "t1500":
	                    retval = "<spring:message code = 'ezCommunity.t1500' />";
	                    break;
	                case "t1501":
	                    retval = "<spring:message code = 'ezCommunity.t1501' />";
	                    break;
	                case "t1502":
	                    retval = "<spring:message code = 'ezCommunity.t1502' />";
	                    break;
	                case "t1503":
	                    retval = "<spring:message code = 'ezCommunity.t1503' />";
	                    break;
	                case "t1504":
	                    retval = "<spring:message code = 'ezCommunity.t1504' />";
	                    break;
	                case "t1505":
	                    retval = "<spring:message code = 'ezCommunity.t1505' />";
	                    break;
	                case "t1506":
	                    retval = "<spring:message code = 'ezCommunity.t1506' />";
	                    break;
	                case "t1507":
	                    retval = "<spring:message code = 'ezCommunity.t1507' />";
	                    break;
	                case "t1508":
	                    retval = "<spring:message code = 'ezCommunity.t1508' />";
	                    break;
	                case "t1509":
	                    retval = "<spring:message code = 'ezCommunity.t1499' />";
	                    break;
	                case "t1510":
	                    retval = "<spring:message code = 'ezCommunity.t1510' />";
	                    break;
	                case "t1511":
	                    retval = "<spring:message code = 'ezCommunity.t1511' />";
	                    break;
	                case "t1512":
	                    retval = "<spring:message code = 'ezCommunity.t1512' />";
	                    break;
	                case "t1513":
	                    retval = "<spring:message code = 'ezCommunity.t1513' />";
	                    break;
	                case "t1514":
	                    retval = "<spring:message code = 'ezCommunity.t1514' />";
	                    break;
	                case "t1515":
	                    retval = "<spring:message code = 'ezCommunity.t1515' />";
	                    break;
	                case "t1516":
	                    retval = "<spring:message code = 'ezCommunity.t1516' />";
	                    break;
	                case "t1517":
	                    retval = "<spring:message code = 'ezCommunity.t1517' />";
	                    break;
	                case "t1518":
	                    retval = "<spring:message code = 'ezCommunity.t1518' />";
	                    break;
	                case "t1519":
	                    retval = "<spring:message code = 'ezCommunity.t1519' />";
	                    break;
	            }
	            return retval;
	        }
	        
	        var type = "";
	        
	        function select_category(val) {
	            if (val != undefined) {
	                type = val.getAttribute("type");
	                
	                if (val.getAttribute("cnt") % 5 == 0) {
	                    totalPage = val.getAttribute("cnt") / 5;
	                } else {
	                    totalPage = parseInt(val.getAttribute("cnt") / 5) + 1;
	                }
	                
	                CurPage = "1";
	            }
	            
	            search = false;
	            var mode = "";
     
	            if(document.getElementById("work").className == "on") {
					mode = "A";
	            } else {
	                mode = "B";
	            }
	            
	            $.ajax({
					type : "POST",
					dataType : "json",
					url : "/ezCommunity/categoryCopList.do",
					data	: {	mode	:	mode,
								page	:	CurPage,
								type 	:	type
					},
					success: function(result){
						event_select_category(result["list"]);
					}
				});
				
	        }
	        
	        function event_select_category(list) {
	        	if (list.length == 0) {
                    alert(strLang1);
                    return;
                }
                
                document.getElementById("categorylist").innerHTML = "";
                var table = document.createElement("TABLE");
                table.className = "right_tabpartListLayout";
                table.style.width = "100%";
                table.style.border = "0";

                list.forEach(function(clubVO, index) {
                	if (index == 0 && clubVO.copCnt != 0) {
                        var total = clubVO.copCnt;
                        
                        if (total % 5 == 0) {
                            totalPage = total / 5;
                        } else {
                            totalPage = parseInt(total / 5) + 1;
                        }
                    }
                	
                	var tr = document.createElement("TR");
                    var td = document.createElement("TD");
                    var dl = document.createElement("DL");
                    dl.className = "right_tabpartList";
                    var dt = document.createElement("DT");
                    var img = document.createElement("IMG");
                    
                	if (clubVO.c_Logo_Thumbnail.indexOf("default_logo_type") > -1) {
                        img.src = "/images/ezCommunity/logo/" + clubVO.c_Logo_Thumbnail;
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" + clubVO.c_Logo_Thumbnail;
                    }
                    
                    img.style.width = "84px";
                    img.style.height = "60px";
                    var dd = document.createElement("DD");
                    var strong = document.createElement("STRONG");
                    
                    if (strlang == "" || strlang == "1") {
                        strong.innerHTML = clubVO.c_ClubName;
                    } else {
                        strong.innerHTML = clubVO.c_ClubName2;
                    }
                    
                    dd.appendChild(strong);
                    var dd2 = document.createElement("DD");
                    dd2.innerHTML = clubVO.c_ClubDesc;

                    var dd3 = document.createElement("DD");
                    
                    if (strlang == "" || strlang == "1") {
                        dd3.innerHTML = strLang2 + " : " + clubVO.displayName + "(" + clubVO.description + ")";
                    } else {
                        dd3.innerHTML = strLang2 + " : " + clubVO.displayName2 + "(" + clubVO.description2 + ")";
                    }

                    dt.appendChild(img);
                    dl.appendChild(dt);
                    dl.appendChild(dd);
                    dl.appendChild(dd2);
                    dl.appendChild(dd3);
                    td.appendChild(dl);

                    tr.appendChild(td);

                    td = null;
                    dl = null;
                    dt = null;
                    dd = null;

                    td = document.createElement("TD");
                    td.style.width = "250px";
                    dl = document.createElement("DL");
                    dl.className = "right_tabpartList01";
                    dt = document.createElement("DT");

                    var span = document.createElement("SPAN");
                    var span2 = document.createElement("SPAN");
                    var span3 = document.createElement("SPAN");
                    var span4 = document.createElement("SPAN");

                    span.className = "icon_community01";
                    span.innerHTML = clubVO.c_MemberCnt;
                    span2.className = "line";
                    span3.className = "icon_community02";
                    span3.innerHTML = clubVO.itemCnt;
                    span4.className = "line";

                    var br = document.createElement("BR");
                    var br2 = document.createElement("BR");

                    dd = document.createElement("DD");
                    var span5 = document.createElement("SPAN");
                    span5.className = "btn_community01";

                    span5.setAttribute("code", clubVO.c_ClubNo.trim());
                    span5.setAttribute("type", clubVO.c_ClubConfirmType);
                    span5.onclick = function () { move_cop(this); };

                    var span6 = document.createElement("SPAN");
                    span6.innerHTML = strLang8;

                    span5.appendChild(span6);
                    dd.appendChild(span5);

                    dt.appendChild(span);
                    dt.appendChild(span2);
                    dt.appendChild(span3);
                    dt.appendChild(span4);

                    dl.appendChild(dt);
                    dl.appendChild(br);
                    dl.appendChild(br2);
                    dl.appendChild(dd);
                    td.appendChild(dl);

                    tr.appendChild(td);

                    table.appendChild(tr);
                });
                
                document.getElementById("categorylist").appendChild(table);
                makePageSelPage();
	        }

	        function get_todaycop() {
	            $.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezCommunity/todayCop.do",
					success: function(result){
						if (result["clubVO"] != null) {
							event_get_todaycop(result);
						}
					}
				});
	        }
	        
	        function event_get_todaycop(result) {
                var h1 = document.createElement("H1");
                var img = document.createElement("IMG");
                img.style.width = "156px";
                img.style.height = "28px";
                //이효진 2017-03-06 분기타서 언어별 이미지따와야함
                
                if ('${userInfo.lang}' == '3') {
                	img.src = "/images/jp/community/title_todayCommunity_jp.png";
                } else {
                	img.src = "/images/kr/community/title_todayCommunity.png";
                }
                img.alt = "today Community";

                h1.appendChild(img);

                var div = document.createElement("DIV");
                div.className = "todayCommunity";

                var div2 = document.createElement("DIV");
                div2.className = "todayCommunityLayout";

                var p = document.createElement("P");
                p.className = "btn_CommunityMore";

                p.setAttribute("code", result["clubVO"]["c_ClubNo"]);
                p.setAttribute("type", result["clubVO"]["c_ClubConfirmType"]);
                p.style.cursor = "pointer";
                p.onclick = function () { move_cop(this); };

                var img2 = document.createElement("IMG");
                img2.src = "/images/kr/community/btn_todayCommunity.png";

                p.appendChild(img2);

                var ui = document.createElement("UI");
                ui.className = "bg_todayCommunity";

                var li = document.createElement("LI");
                li.className = "bg_todayCommunityTL";

                var li2 = document.createElement("LI");
                li2.className = "bg_todayCommunityTR";

                var li3 = document.createElement("LI");
                li3.className = "bg_todayCommunityBL";

                var li4 = document.createElement("LI");
                li4.className = "bg_todayCommunityBR";

                ui.appendChild(li);
                ui.appendChild(li2);
                ui.appendChild(li3);
                ui.appendChild(li4);

                var p2 = document.createElement("P");
                p2.className = "todayCommunity_img";

                var img3 = document.createElement("IMG");
                img3.style.width = "198px";
                img3.style.height = "140px";
                
                if (result["clubVO"]["c_Logo_Thumbnail"].indexOf("default_logo_type") > -1) {
                    img3.src = "/images/ezCommunity/logo/" + result["clubVO"]["c_Logo_Thumbnail"];
                } else {
                    img3.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" + result["clubVO"]["c_Logo_Thumbnail"];
                }

                p2.appendChild(img3);

                var dl = document.createElement("DL");
                dl.className = "todayCommunity_list";

                var dt = document.createElement("DT");
                
                if(strlang == "" || strlang == "1") {
                    dt.innerHTML = result["clubVO"]["c_ClubName"];
                } else {
                    dt.innerHTML = result["clubVO"]["c_ClubName2"];
                }

                var dd = document.createElement("DD");

                var span = document.createElement("SPAN");
                span.className = "icon_community01";
                span.innerHTML = result["clubVO"]["c_MemberCnt"];
                var span2 = document.createElement("SPAN");
                span2.className = "line";
                var span3 = document.createElement("SPAN");
                span3.className = "icon_community02";
                span3.innerHTML = result["itemCnt"];
                var span4 = document.createElement("SPAN");
                span4.className = "line";
                var span5 = document.createElement("SPAN");
                
                if (strlang == "" || strlang == "1") {
                    span5.innerHTML = strLang2 + " : " + result["clubVO"]["displayName"];
                } else {
                    span5.innerHTML = strLang2 + " : " + result["clubVO"]["displayName2"];
                }
                
                dd.appendChild(span);
                dd.appendChild(span2);
                dd.appendChild(span3);
                dd.appendChild(span4);
                dd.appendChild(span5);

                var dd2 = document.createElement("DD");
                dd2.innerHTML = strLang3 + " : ";
                
                if (result["clubVO"]["c_Cate_A"].trim() != "0") {
                    dd2.innerHTML += getcategoryname(result["cCateAName"]);
                }

                if (result["clubVO"]["c_Cate_A"].trim() != "0" && result["clubVO"]["c_Cate_B"].trim() != "0") {
                    dd2.innerHTML += ", " + getcategoryname(result["cCateBName"]);
                } else {
                    dd2.innerHTML += getcategoryname(result["cCateBName"]);
                }

                dl.appendChild(dt);
                dl.appendChild(dd);
                dl.appendChild(dd2);

                var p3 = document.createElement("P");
                p3.className = "todayCommunity_text";

                var span6 = document.createElement("SPAN");
                span6.innerHTML = result["clubVO"]["c_ClubDesc"];

                p3.appendChild(span6);

                div2.appendChild(p);
                div2.appendChild(ui);
                div2.appendChild(p2);
                div2.appendChild(dl);
                div2.appendChild(p3);
                div.appendChild(div2);

                document.getElementById("todaycop").appendChild(h1);
                document.getElementById("todaycop").appendChild(div);
	        }

	        function key_down(e) {
	            if (e.keyCode == "13") {
	                copsearch();
	            }
	        }
	        
	        var search = false;
	        var searchoption;
	        var searchvalue;
	        
	        function copsearch() {
	            var sel = document.getElementById("search").selectedIndex;
	            searchoption = document.getElementById("search")[sel].value;
	            searchvalue = document.getElementById("keyword").value;

	            if (searchvalue == "") {
	                alert(strLang4);
	                return;
	            }
	            search = true;

	            CurPage = "1";
	            
	            $.ajax({
					type : "POST",
					dataType : "json",
					url : "/ezCommunity/searchCop.do",
					data	: {	option	:	searchoption,
								keyword	:	searchvalue,
								page 	:	CurPage
					},
					success: function(result){
						event_select_category(result["list"]);
					}
				});
	        }

	        function copsearchpage() {
	            search = true;

	            $.ajax({
					type : "POST",
					dataType : "json",
					url : "/ezCommunity/searchCop.do",
					data	: {	option	:	searchoption,
								keyword	:	searchvalue,
								page 	:	CurPage
					},
					success: function(result){
						event_select_category(result["list"]);
					}
				});
	        }

	        function ItemRead_onclick(val) {
	            var pItemID = val.getAttribute("itemid");
	            var pItemBoardID = val.getAttribute("boardid");
	            var gubun = val.getAttribute("gubun");
	            var copno = val.getAttribute("code");

	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;

	            if (gubun == "3") {
	                if (CrossYN()) {
	                    window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	                } else {
	                    window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	                }
	            } else {
	                if (CrossYN() || pUse_IE11Browser == "CK") {
	                	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1, "", 750, 800);
	                } else {
	                	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1, "", 750, 800);
	                }
	            }
	        }

	        var idx = "";
	        var mainVal = "";
	        function move_cop(val) {
	        	var clubgubun = 0;
	            idx = val.getAttribute("code");
	            mainVal = val;
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommunity/remote/getACL.do",
					data : { cID	:	idx,
							 uID	:	"${userInfo.id}"
					},
					success: function(result){
						if (result == "ERR" || clubgubun == "1") {
							if (CrossYN()) {
								var rtn = OpenInformationUI(strLang5 + "<BR>" + strLang6, move_cop_Complete);
								
								if (rtn) {
									$.ajax({
										type : "POST",
										dataType : "text",
										async : false,
										url : "/ezCommunity/getIsJoin.do",
										data : { code	:	idx
										},
										success: function(result){
											if (result == "FALSE") {
												var wWidth = "330";
								                var wHeight = "220";
								                var heigth = window.screen.availHeight;
								                var width = window.screen.availWidth;
						                        var left = (width - wWidth) / 2;
						                        var top = (heigth - wHeight) / 2;
						                        var type = val.getAttribute("type");
						                        
						                        if (type == "2") {
						                            window.open("/ezCommunity/join1.do?no=" + idx, "", "location=1,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
						                        } else if (type == "3") {
						                            window.open("/ezCommunity/join2.do?no=" + idx, "", "location=1,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
						                        }
						                	} else {
						                    	alert(strLang7);
						                	}
										}
									});
				                }
							} else {
								var rtn = OpenInformationUI(strLang5 + "<BR>" + strLang6);
								
								if (rtn) {
									getIsJoin(idx, val);
								} 
							}
						} else {
							//window.open("/ezCommunity/main.do?communityCD=" + idx + "&userLevel=1", "main");
							GoFunc(val);
						}
					}
				});
	        }
	        
	        function move_cop_Complete(rtn) {
	        	if (rtn) {
	        		$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommunity/getIsJoin.do",
						data : { code	:	idx
						},
						success: function(result){
							if (result == "FALSE") {
								var wWidth = "330";
				                var wHeight = "220";
				                var heigth = window.screen.availHeight;
				                var width = window.screen.availWidth;
		                        var left = (width - wWidth) / 2;
		                        var top = (heigth - wHeight) / 2;
		                        var type = mainVal.getAttribute("type");
		                        
		                        if (type == "2") {
		                            window.open("/ezCommunity/join1.do?no=" + idx, "", "location=1,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
		                        } else if (type == "3") {
		                            window.open("/ezCommunity/join2.do?no=" + idx, "", "location=1,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
		                        }
		                	} else {
		                    	alert(strLang7);
		                	}
						}
					});
	        	}
	        }

	        function GoFunc(obj) {
	            code = obj.getAttribute("code").trim();
	            codeName = obj.innerText;
	            
	            if (code == "0") {
	                window.frames.location.href = window.frames.location.href;
	            } else {
	                var url = "/ezCommunity/checkCommHome.do?communityCD=" + code;
	                var wWeight = "1300";
	                var wHeight = "900";

	                var heigth = window.screen.availHeight;
	                var width = window.screen.availWidth;

	                var left = (width - wWeight) / 2;
	                var top = (heigth - wHeight) / 2 - 30;

	                var ret = window.open(url, code, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	                
	                try { ret.focus() } catch (e) { }
	            }
	        }
		</script>
	</head>
	<body>
		<div class="main_community">
			<table style="width:100%" border="0" class="main_communityTop">
				<tr>
		    		<td>
			            <div class="contents_todayCommunity" id="todaycop"></div>
			        </td>
			        <td style="width:30px"><p style="width:30px;"></p></td>
			        <td style="width:331px">
			            <div class="contents_newCommunity">
			              	<ul class="newCommunity_title">
			                    <li id="best" class="on"><span onclick="change_tab('best')"><spring:message code = 'ezCommunity.t2003' /></span></li>
			                    <li id="new"><span class="newCommunity_titleMg" onclick="change_tab('new')" ><spring:message code = 'ezCommunity.t2004' /></span></li>
			                </ul>
			                
			                <div class="newCommunity_listLayout" id ="bestcomm" style="width:331px;height:172px"></div>
			                <div class="newCommunity_listLayout" id ="newcomm" style="width:331px;height:172px;display:none"></div>
			            </div>
			        </td>
			    </tr>
			</table>
			
			<table style="width:100%" border="0" class="main_communityContent">
				<tr>
			    	<td>
			            <div class="contents_tabpartTitle">
			                <ul class="tabpartTitle">
			                    <li id="mycop" class="on" onclick ="change_tab('mycop')"><span><span class="icon_tabpart"></span><spring:message code = 'ezCommunity.t2005' /></span></li>
			                    <li id="categorycop" class="icon_tabpartBorder" onclick ="change_tab('categorycop')"><span><span class="icon_tabpart"></span><spring:message code = 'ezCommunity.t2006' /></span></li>
			                </ul>
			            </div>
			            <div id ="mycommunity"></div>
			            <div id ="categorycommunity" style="display:none">
			                <div class="tabpartMycommunity02">
			                    <div class="left_tabpart">
			                        <ul class="left_tabpartTitle">
			                            <li id="work" class="on" onclick ="change_tab('WORK')" style="cursor:pointer"><span><spring:message code = 'ezCommunity.t81' /></span></li>
			                            <li id="type" class="line" onclick ="change_tab('TYPE')" style="cursor:pointer"><span><spring:message code = 'ezCommunity.t80' /></span></li>
			                        </ul>
			                        
			                        <div class="left_tabpartList_layout" id ="categorytab"></div>
			                    </div>
			                    
			                    <div class="right_content">
			                        <div class="right_tabpartContent">
			                            <div class="right_CopSearchLayout">
			                                <p class="right_CopSearch">
			                                    <select id="search" name="select">
			                                        <option value ="NAME"><spring:message code = 'ezCommunity.t2007' /></option>
			                                        <option value ="DESC"><spring:message code = 'ezCommunity.t2008' /></option>
			                                    </select>
			                                    
			                                    <input id="keyword" name="keyword" onkeydown ="key_down(event)" />
			                                    <a class="imgbtn"><span onclick ="copsearch()"><spring:message code = 'ezCommunity.t31' /></span></a>
			                                </p>
			                            </div>
			                            
			                            <div id ="categorylist"></div>
			                        </div>
			                    </div>
			                </div>
			            </div>
			            
			            <div id="tblPageRayer" style="text-align:center"></div>
			        </td>
			    </tr>
			</table>
		</div>
	</body>
</html>