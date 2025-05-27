<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>main_page</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<!-- 18-04-27 김민성 - 카테고리별 커뮤니티 클릭시 bold 지정 -->
		<style>
			/*  .category_select span {newCommunity_list
				color : rgb(4, 112, 228);
			}
			.category_select {
				font-Weight : bold;
			}
			.tabpartMycommunityList table td.read {
				text-align: center;
				white-space: nowrap;
    			text-overflow: ellipsis;
    			overflow: hidden;
   				width: 60px;
   				padding-right:5px;
			}  */
			.txt {
				clear : none;
			}
			.contents_listCommunity li span.icon_reply {
				float : left;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript">
	        var xmlhttp3 = null;
	        var xmlhttp4 = null;
	        var xmlhttp5 = null;
	        var str = "<c:out value = '${strXML}' />";
	        var primary = "<c:out value = '${primary}' />";
	        var pastDate = "<c:out value = '${pastDate}' />";
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
//	        var strLang7 = "<spring:message code = 'ezCommunity.t1102' />";
	        var strLang7 = "<spring:message code = 'ezCommunity.t1083' />";
	        var strLang8 = "<spring:message code = 'ezCommunity.t2002' />";
	        var strLang9 = "<spring:message code = 'ezSchedule.t267' />";
	        
	        var categoryColors = ["#ff6868", "#ff68c4", "#d668ff", "#a868ff", "#6f68ff", "#3d78ff", 
				                              "#4d8fcc", "#0dbeff", "#6dabad", "#4dc689", 
				                              "#81bc3d", "#ffc71e", "#ff8f1e", "#bd6438"];
	        var categoryColor = "";
	        
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
			};
			window.onload = function () {
		    	//get_todaycop();
		        get_bestCommunity();
		        get_newCommunity();
		       // makePageSelPage();   
		        get_categoryCommunity("A");
		        get_myCommunity();
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
	                //document.getElementById("mycop").className = "on";
	                //document.getElementById("categorycop").className = "icon_tabpartBorder";
	                document.getElementById("mycommunity").style.display = "";
	                document.getElementById("categorycommunity").style.display = "none";
	                totalPage = temptotalPage;
	                CurPage = "1";
	                get_myCommunity();
	                makePageSelPage();
	            } else if(val == "categorycop") {
	                search = false;
	                //document.getElementById("mycop").className = "";
	                //document.getElementById("categorycop").className = "icon_tabpartBorder on";
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
					type : "GET",
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
					type : "GET",
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

	        /* 신규 커뮤니티 표출 */
	        function event_get_newCommunity(result) {
                var xmldom = loadXMLString(result);
                var bestcoummunity = SelectNodes(xmldom, "DATA/ROW");
                
                document.getElementById("newcomm").innerHTML = "";
                if (bestcoummunity.length > 0) {
                	document.getElementById("newcomm").innerHTML = "";
                	var best = document.getElementById("newcomm");
	                best.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBNO").trim());
                    best.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE"));
                    best.style.cursor = "pointer";
	                best.onclick = function () { move_cop(this); };
	                
	                var btn = document.getElementById("newcommBtn");
	                btn.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBNO").trim());
                    btn.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE"));
                    btn.style.cursor = "pointer";
	                btn.onclick = function () { move_cop(this); };
	                
	                var dt = document.createElement("DT");
	                
	                var img = "";
	                
	                if (SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL").indexOf("default_logo_") <= -1) {
	                	img = document.createElement("IMG")
	                	img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL");
	                }
	                
	                var dd = document.createElement("DD");
	                
	                var span = document.createElement("SPAN");
	                span.className = "title";
	                span.innerHTML = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBNAME"));
	                
	                var span2 = document.createElement("SPAN");
	                span2.className = "text";
	                span2.innerHTML = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBDESC"));
	                
	                dd.appendChild(span);
	                dd.appendChild(span2);
	                
	                if (img != "") {
		                dt.appendChild(img);
	                }
	                document.getElementById("newcomm").appendChild(dt);
	                document.getElementById("newcomm").appendChild(dd);
                }
                else {
                	 var dl = document.getElementById("newcomm");
					 dl.className = "nodata_sIcon";
					 dl.style.paddingTop = "35px";
					 
					 var dt = document.createElement("DT");
					 
		             var img = document.createElement("IMG");
		             img.src = "/images/kr/main/noData_sIcon.png";
		             
		             var dd = document.createElement("DD");
		             dd.innerHTML = strLang535;
		             
		             dt.appendChild(img);
		             dl.appendChild(dt);
		             dl.appendChild(dd);
		             
		            /* 2019-10-24 홍승비 - 신규 커뮤니티 미존재 시 '+' 버튼 클릭하면 메인페이지 갱신 */
					var btn = document.getElementById("newcommBtn");
					btn.onclick = function () {
						refresh_onclick();
					};
                }
                
               /*  for (var i = 0; i < bestcoummunity.length; i++) {
                    var dl = document.createElement("DL");
                    dl.className = "newCommunity_list";

                    var dt = document.createElement("DT");

                    var img = document.createElement("IMG");
                    
                    if (SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL").indexOf("default_logo_") > -1) {
                        img.src = "/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    }
                    
                    img.style.width = "56px";
                    img.style.height = "40px";

                    var span = document.createElement("SPAN");
                    span.className = "icon_newcommunity01";

                    var img2 = document.createElement("IMG");

                    img2.src = "/../images/kr/community/icon_newCommunity04.png";

                    var dd = document.createElement("DD");

                    var span2 = document.createElement("SPAN");
                    
                    var copName = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNAME");

                    span2.innerHTML = MakeXMLString(copName) + " (" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_MEMBERCNT") + "<spring:message code = 'ezCommunity.t478' />"+")";
                    span2.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNO").trim());
                    span2.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBCONFIRMTYPE"));
                    span2.style.cursor = "pointer";
                    span2.onclick = function () { move_cop(this); };

                    var dd2 = document.createElement("DD");
                    dd2.innerHTML = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBDESC"));

                    span.appendChild(img2);
                    dt.appendChild(img);
                    dt.appendChild(span);

                    dd.appendChild(span2);

                    dl.appendChild(dt);
                    dl.appendChild(dd);
                    dl.appendChild(dd2);

                    document.getElementById("newcomm").appendChild(dl);
                } */
                
                /* if( bestcoummunity.length <= 0 ){
	                conts = "<div style='height:170px; text-align:center;margin-top:5px;'><div><img style='margin-top:28px;' src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px;color:#d0d0d0;font-weight:bold'>"+strLang88+"</div></div></div>";							
					$("#newcomm").html(conts);
                } */
	        }

	        /* 인기 커뮤니티 표출 */
	        function event_get_bestCommunity(result) {
                var xmldom = loadXMLString(result);

                var bestcoummunity = SelectNodes(xmldom, "DATA/ROW");
                
                if (bestcoummunity.length > 0) {
                	document.getElementById("bestcomm").innerHTML = "";
                	var best = document.getElementById("bestcomm");
	                best.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBNO").trim());
                    best.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE"));
                    best.style.cursor = "pointer";
	                best.onclick = function () { move_cop(this); };
	                
	                var btn = document.getElementById("bestcommBtn");
	                btn.setAttribute("code", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBNO").trim());
                    btn.setAttribute("type", SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBCONFIRMTYPE"));
                    btn.style.cursor = "pointer";
	                btn.onclick = function () { move_cop(this); };
                	
	                var dt = document.createElement("DT");
	                
	                var img = "";
	                
	                if (SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL").indexOf("default_logo_") <= -1) {
	                	img = document.createElement("IMG");
	                	img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_LOGO_THUMBNAIL");
	                }
	                
	                var dd = document.createElement("DD");
	                
	                var span = document.createElement("SPAN");
	                span.className = "title";
	                span.innerHTML = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBNAME"));
	                
	                var span2 = document.createElement("SPAN");
	                span2.className = "text";
	                span2.innerHTML = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[0], "C_CLUBDESC"));
	                
	                dd.appendChild(span);
	                dd.appendChild(span2);
	                
	                if (img != "") {
		                dt.appendChild(img);
	                }
	                
	                document.getElementById("bestcomm").appendChild(dt);
	                document.getElementById("bestcomm").appendChild(dd);
                }
                else {
               	     var dl = document.getElementById("bestcomm");
					 dl.className = "nodata_sIcon";
					 dl.style.paddingTop = "35px";
					 
					 var dt = document.createElement("DT");
					 
		             var img = document.createElement("IMG");
		             img.src = "/images/kr/main/noData_sIcon.png";
		             
		             var dd = document.createElement("DD");
		             dd.innerHTML = strLang535;
		             
		             dt.appendChild(img);
		             dl.appendChild(dt);
		             dl.appendChild(dd);
		             
		            /* 2019-10-24 홍승비 - 인기 커뮤니티 미존재 시 '+' 버튼 클릭하면 메인페이지 갱신 */
					var btn = document.getElementById("bestcommBtn");
					btn.onclick = function () {
						refresh_onclick();
					};
               }
                /* for (var i = 0; i < bestcoummunity.length; i++) {
                    var dl = document.createElement("DL");
                    dl.className = "newCommunity_list";

                    var dt = document.createElement("DT");

                    var img = document.createElement("IMG");
                    
                    if (SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL").indexOf("default_logo_") > -1) {
                        img.src = "/images/ezCommunity/logo/" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_LOGO_THUMBNAIL");
                    }
                    
                    img.style.width = "56px";
                    img.style.height = "40px";

                    var span = document.createElement("SPAN");
                    span.className = "icon_newcommunity01";

                    var img2 = document.createElement("IMG");

                    var order = i + 1;
                    img2.src = "/../images/kr/community/icon_newCommunity0" + order + ".png";

                    var dd = document.createElement("DD");

                    var span2 = document.createElement("SPAN");
                    
                    var copName = SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_CLUBNAME");
                    
                    span2.innerHTML = MakeXMLString(copName) + " (" + SelectSingleNodeValue(SelectNodes(xmldom, "DATA/ROW")[i], "C_MEMBERCNT") + "<spring:message code = 'ezCommunity.t478' />" + ")";
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
                } */
                
                /* if( bestcoummunity.length <= 0 ){
	                conts = "<div style='height:170px; text-align:center;margin-top:5px;'><div><img style='margin-top:28px;' src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px;color:#d0d0d0;font-weight:bold'>"+strLang88+"</div></div></div>";							
					$("#bestcomm").html(conts);
                } */
	        }

	        function get_myCommunity() {
	        	$.ajax({
						type : "GET",
						dataType : "text",
						async : false,
						url : "/ezCommunity/myCopNewBoardItem.do",
						data : { page   : CurPage
						},
						success: function(result){
							event_get_myCommunity(result, 'new');
							//commuTitleWidth(); //타이틀 너비 조정
						}
				});
	        }
	        
	        // 커뮤니티 새글
	        function event_get_myCommunity(result, type) {
                var xmldom = loadXMLString(result);
                var table;
                
				if (type == 'new') {
					document.getElementById("listCommunity2").style.display = "";
					document.getElementById("listCommunityPop").style.display = "none";
				} else {
					document.getElementById("listCommunityPop").style.display = "";
					document.getElementById("listCommunity2").style.display = "none";
				}
				
                if (SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW").length == 0) {
					if (type == 'new') {
						var ul = document.getElementById("listCommunity2");
					} else {
						var ul = document.getElementById("listCommunityPop");
					}

					if (ul.querySelector('.nodata_sIcon') == null) {
						var dl = document.createElement("DL");
						dl.className = "nodata_sIcon";
						
						var dt = document.createElement("DT");
						 
						var img = document.createElement("IMG");
						img.src = "/images/kr/main/noData_sIcon.png";
						 
						var dd = document.createElement("DD");
						dd.innerHTML = strLang535;
						 
						 dt.appendChild(img);
						 dl.appendChild(dt);
						 dl.appendChild(dd);

						 ul.appendChild(dl);
					}
                	return;
                }
                
                var j = 0;

				if (type == 'new') {
					document.getElementById("listCommunity2").innerHTML = "";
				} else {
					document.getElementById("listCommunityPop").innerHTML = "";
				}
               
                
                for(var i = 0; i < SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW").length; i++) {
	                var li = document.createElement("LI");
	                
                    var boardid = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDID");
                    var itemid = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ITEMID");
                    var copno = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim();
                    var gubun = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "GUBUN");
                    var writeDate = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITEDATE");
                    li.style.cursor = "pointer";
                    li.setAttribute("boardid", boardid);
                    li.setAttribute("itemid", itemid);
                    li.setAttribute("gubun", gubun);
                    li.setAttribute("code", copno);
                    li.onclick = function () { ItemRead_onclick(this); }; 
	                
	                var span = document.createElement("SPAN");
	                span.className = "icon_new";
	                
	                var img = document.createElement("IMG");
	                img.src = "/images/kr/community/communityPortlet_iconnew.gif" 
	                
	                span.appendChild(img);
	                
	                var span2 = document.createElement("SPAN");
	                span2.className = "kind";
	                var clubname = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], primary == "1" ? "C_CLUBNAME" : "C_CLUBNAME2");
	                if(clubname.length > 9) {
	                	clubname = clubname.substring(0,8) + "...";
	                }
	                span2.innerHTML = MakeXMLString("[" + clubname + "]");
	                
	                var span3 = document.createElement("SPAN");
	                span3.className = "txt";
	                span3.innerHTML = MakeXMLString(SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "TITLE"));
	                
	                var span4 = document.createElement("SPAN");
	                span4.className = "date";
	                var writeDate = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITEDATE");
					span4.innerHTML = writeDate.substring(0, 10);
					
	                if (pastDate <= writeDate ) {
	                	li.appendChild(span);
	                } 
	                li.appendChild(span2);
	                li.appendChild(span3);
	                li.appendChild(span4);

					if (type == 'new') {
						document.getElementById("listCommunity2").appendChild(li);
					} else {
						document.getElementById("listCommunityPop").appendChild(li);
					}
					
                }
	        }
                
                // 사용 안함
                function event_get_myCommunity2(result) {
              
                for (var i = 0; i < SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW").length; i++) {
                    var copno;
                    var clubname;

                    if (i == 0 || SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim() != copno) {
                        copno = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim();
                        table = null;
                        var div = document.createElement("DIV");
                        div.className = "tabpartMycommunity";

                        var dl = document.createElement("DL");
                        dl.className = "tabpartMycommunityTitle";
                        var dt = document.createElement("DT");

                        if (primary == "1") {
                        	clubname = MakeXMLString(SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNAME"));
                            dt.innerHTML = clubname;
                        } else {
                        	clubname = MakeXMLString(SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNAME2"));
                            dt.innerHTML = clubname;
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

                        document.getElementById("listCommunity2").appendChild(div);

                        div = null;

                        div = document.createElement("DIV");
                        div.className = "tabpartMycommunityList";
                        table = document.createElement("TABLE");
                        table.style.width = "100%";
                        table.style.border = "0";
                        div.appendChild(table);
                        document.getElementById("mycommunity").appendChild(div);
                        j = 0;
                    }

                    var tr = document.createElement("TR");
                    
                    if (j != 4) {
                    	tr.style.borderBottom = "1px solid #f2f2f2";
                    }
                    
                    if (j % 2 == 0) {
                    	//tr.style.backgroundColor = "rgb(250, 250, 250)"; 
                    }
                    var td = document.createElement("TD");
                    var td2 = document.createElement("TD");
                    var td3 = document.createElement("TD");
                    var td4 = document.createElement("TD");
                    var td5 = document.createElement("TD");
                    
                    td.className = "text";
                    var boardid = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDID");
                    var itemid = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ITEMID");
                    var copno = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "C_CLUBNO").trim();
                    var gubun = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "GUBUN");
                    var writeDate = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITEDATE");
                    var title = MakeXMLString(SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "TITLE"));
                    td.style.cursor = "pointer";
                    td.setAttribute("boardid", boardid);
                    td.setAttribute("itemid", itemid);
                    td.setAttribute("gubun", gubun);
                    td.setAttribute("code", copno);
                    td.onclick = function () { ItemRead_onclick(this); }; 
                     
                    /* 2018-05-17 홍승비 - 새 게시물의 제목 앞에 new 표시 추가 */
                     if (pastDate <= writeDate ) {
                    	td.innerHTML = "<img src='/images/i_new.gif'>&nbsp;";
                    }
                    
                    if (primary == "1") {
                        td.innerHTML += "<div style='overflow: hidden; text-overflow: ellipsis; display: inline-block; max-width: 90%;'>[" + MakeXMLString(SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDNAME")) + "] " + title + "</div>";
                         /* 2018-05-07 홍승비 - 커뮤니티 메인 MY커뮤니티 새글에서 댓글 표시하기 */
                         if (SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ONELINECNT") > 0) {
                        	td.innerHTML += " <SPAN style='color:#c64200'; position: absolute;> [" + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ONELINECNT") + "]</SPAN><td style='width:20px;'></td>";
                        }
                        td2.className = "team";
                        td2.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERDEPTNAME");
                        td3.className = "name";
                        td3.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERNAME");
                    } else {
                        td.innerHTML += "<div style='overflow: hidden; text-overflow: ellipsis; display: inline-block; max-width: 90%;'>[" + MakeXMLString(SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "BOARDNAME2")) + "] " + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "TITLE") + "</div>";
                         /* 2018-05-07 홍승비 - 커뮤니티 메인 MY커뮤니티 새글에서 댓글 표시하기 */
                         if (SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ONELINECNT") > 0) {
							td.innerHTML += " <SPAN style='color:#c64200'; position: absolute;> [" + SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "ONELINECNT") + "]</SPAN><td style='width:20px;'></td>";
			          	}                   
                        td2.className = "team";
                        td2.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERDEPTNAME2");
                        td3.className = "name";
                        td3.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "WRITERNAME2");
                    }
                    
                    td4.className = "day";
                    td4.innerHTML = writeDate.substring(0, 10);
                     
                    /* 2018-05-18 홍승비 - 커뮤니티 메인 페이지에서 게시물 조회수 표시 */
                    td5.className = "read";
                    td5.innerHTML = SelectSingleNodeValue(SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW")[i], "READCOUNT");

                    tr.appendChild(td);
                    tr.appendChild(td2);
                    tr.appendChild(td3);
                    tr.appendChild(td4);
                    tr.appendChild(td5);
                    table.appendChild(tr);
                    
                    j++;
                }  
                
                /* 
                if (SelectNodes(SelectNodes(xmldom, "ITEM/DATA")[0], "ROW").length == 0) {
                	var str = "<spring:message code = 'main.t00026' />";
                	document.getElementById("mycommunity").innerHTML = "<div style='height:20px'>&nbsp;</div><div style='height:430px;text-align:center;'><img style='margin-top:160px' src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px;color:#d0d0d0;font-weight:bold'>" + str + "</div></div>";
                } */
                //document.getElementById("tblPageRayer").style.display = "none";
                
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
	                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg first disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg prev disabled'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg prev disabled'></span>";
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
	            
	            if (MaxNum == 0) {
	            	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
	            }
	            
	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next disabled'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg last disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            PagingHTML += "</div>";
	            td_Create1(PagingHTML);
	        }

	        function goToPageByNum(Value) {
	            CurPage = Value;
	            makePageSelPage();
	            movePage(CurPage);
	            commuTitleWidth();//타이틀 너비 조정
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
	                
	                if (document.getElementById("tagsub1").className != "") {
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
	                
	                if (document.getElementById("tagsub1").className != "") {
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
	                
	                if (document.getElementById("tagsub1").className != "") {
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
					type : "GET",
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

            /* 18-04-27 김민성 - 카테고리별 커뮤니티 클릭시 bold 지정 */
	        function event_get_categoryCommunity(list) {
	        	document.getElementById("listCategory").innerHTML = "";
	        	
	        	var totalCnt = 0;
	        	
	        	var li = document.createElement("LI");
	        	 	
        	 	var span = document.createElement("SPAN");
        	 	span.className = "icon";
        	 	
        	 	var img = document.createElement("IMG");
        	 	img.src = "../images/kr/community/categoryList_icon.gif";
        	 	
        	 	var span2 = document.createElement("SPAN");
        	 	span2.className = "txt";
        	 	span2.innerHTML = strLang9;	
        	 	span2.setAttribute("type", "ALL");							
        	 	span2.onclick = function () { 
        	 		$("#listCategory .txt").removeClass("bold");
                	$("#keyword").val('');
                	copsearch();
                	$(this).addClass("bold"); 
                };
                span2.onclick();					
        	 	
        	 	var span3 = document.createElement("SPAN");
                span3.id = "totalCnt";
        	 	span3.className = "count";
        	 	
        	 	span.appendChild(img);
        	 	
        	 	li.appendChild(span);
                li.appendChild(span2);
                li.appendChild(span3);
	        	 
	        	document.getElementById("listCategory").appendChild(li);
	        	 
	        	 list.forEach(function(categoryVO, index) {
	        	 	var li = document.createElement("LI");
	        	 	
	        	 	var span = document.createElement("SPAN");
	        	 	span.className = "icon";
	        	 	
	        	 	var img = document.createElement("IMG");
	        	 	img.src = "../images/kr/community/categoryList_icon.gif";
	        	 	
	        	 	var span2 = document.createElement("SPAN");
	        	 	span2.className = "txt";
	        	 	span2.innerHTML = getcategoryname(categoryVO.c_Name);
	        	 	span2.setAttribute("type", categoryVO.cate);
	        	 	span2.onclick = function () { 
	        	 		$("#listCategory .txt").removeClass("bold");
                    	$(this).addClass("bold"); 
                    	$("#keyword").val('');
                    	select_category(this); 
                    };
	        	 	
	        	 	var span3 = document.createElement("SPAN");
	        	 	span3.className = "count";
	        	 	span3.innerHTML = "(" + categoryVO.cnt + ")";
	        	 	totalCnt +=  categoryVO.cnt;
	        	 	
	        	 	span.appendChild(img);
	        	 	
	        	 	li.appendChild(span);
                    li.appendChild(span2);
                    li.appendChild(span3);
                    
                    document.getElementById("listCategory").appendChild(li);
	        	 });
	        	 
	        	 document.getElementById("totalCnt").innerHTML = "(" + totalCnt + ")";
	        	 
                /* document.getElementById("categorytab").innerHTML = "";

                var ul = document.createElement("UL");
                ul.className = "left_tabpartLis";
                
                list.forEach(function(categoryVO, index) {
                	var li = document.createElement("LI");
                	
                    var a = document.createElement("A");
                    a.style.cursor = "pointer";
                    a.setAttribute("type", categoryVO.cate);
                    a.setAttribute("cnt", categoryVO.cnt);
                    a.onclick = function () { 
                    	$(".category_select").removeClass("category_select");
                    	$(this).addClass("category_select"); 
                    	select_category(this); 
                    };
                    
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
                
                if (list.length == 0) {
                	var str = strLang88;
                	document.getElementById("categorytab").innerHTML = "<div style='height:20px'>&nbsp;</div><div style='text-align:center;'><img style='margin-top:160px' src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px;color:#d0d0d0;font-weight:bold'>" + str + "</div></div>";
                	document.getElementById("categorylist").innerHTML = "<div style='height:20px'>&nbsp;</div><div style='text-align:center;'><img style='margin-top:160px' src='/images/kr/main/nodata_plan.png' /><div style='margin-top:10px;color:#d0d0d0;font-weight:bold'>" + str + "</div></div>";
                }
                
                document.getElementById("categorytab").appendChild(ul);
                
                //document.getElementById("tblPageRayer").style.display = ""; */
	        }
            
	        function getcategoryname(val) {
	            var retval = "";
	            
	            switch(val){
	                case "t1496":
	                    retval = "<spring:message code = 'ezCommunity.t1496' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1497":
	                    retval = "<spring:message code = 'ezCommunity.t1497' />";
	                    categoryColor = categoryColors[1];
	                    break;
	                case "t1498":
	                    retval = "<spring:message code = 'ezCommunity.t1498' />";
	                    categoryColor = categoryColors[2];
	                    break;
	                case "t1499":
	                    retval = "<spring:message code = 'ezCommunity.t1499' />";
	                    categoryColor = categoryColors[3];
	                    break;
	                case "t1500":
	                    retval = "<spring:message code = 'ezCommunity.t1500' />";
	                    categoryColor = categoryColors[4];
	                    break;
	                case "t1501":
	                    retval = "<spring:message code = 'ezCommunity.t1501' />";
	                    categoryColor = categoryColors[5];
	                    break;
	                case "t1502":
	                    retval = "<spring:message code = 'ezCommunity.t1502' />";
	                    categoryColor = categoryColors[6];
	                    break;
	                case "t1503":
	                    retval = "<spring:message code = 'ezCommunity.t1503' />";
	                    categoryColor = categoryColors[7];
	                    break;
	                case "t1504":
	                    retval = "<spring:message code = 'ezCommunity.t1504' />";
	                    categoryColor = categoryColors[8];
	                    break;
	                case "t1505":
	                    retval = "<spring:message code = 'ezCommunity.t1505' />";
	                    categoryColor = categoryColors[9];
	                    break;
	                case "t1506":
	                    retval = "<spring:message code = 'ezCommunity.t1506' />";
	                    categoryColor = categoryColors[10];
	                    break;
	                case "t1507":
	                    retval = "<spring:message code = 'ezCommunity.t1507' />";
	                    categoryColor = categoryColors[11];
	                    break;
	                case "t1508":
	                    retval = "<spring:message code = 'ezCommunity.t1508' />";
	                    categoryColor = categoryColors[12];
	                    break;
	                case "t1509":
	                    retval = "<spring:message code = 'ezCommunity.t1509' />";
	                    categoryColor = categoryColors[0];				// 추후 수정
	                    break;
	                case "t1510":
	                    retval = "<spring:message code = 'ezCommunity.t1510' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1511":
	                    retval = "<spring:message code = 'ezCommunity.t1511' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1512":
	                    retval = "<spring:message code = 'ezCommunity.t1512' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1513":
	                    retval = "<spring:message code = 'ezCommunity.t1513' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1514":
	                    retval = "<spring:message code = 'ezCommunity.t1514' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1515":
	                    retval = "<spring:message code = 'ezCommunity.t1515' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1516":
	                    retval = "<spring:message code = 'ezCommunity.t1516' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1517":
	                    retval = "<spring:message code = 'ezCommunity.t1517' />";
	                    categoryColor = categoryColors[0];
	                    break;
	                case "t1518":
	                    retval = "<spring:message code = 'ezCommunity.t1518' />";
	                    categoryColor = categoryColors[13];
	                    break;
	                case "t1519":
	                    retval = "<spring:message code = 'ezCommunity.t1519' />";
	                    categoryColor = categoryColors[0];
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
	            var mode = "A";
     			
	            // 2018-11-13 김민성 - 종류별 / 업무별 -> 종류별 
	            /* if(document.getElementById("work").className == "on") {
					mode = "A";
	            } else {
	                mode = "B";
	            } */
	            
	            $.ajax({
					type : "GET",
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
	        	
	        	document.getElementById("categoryViewList").innerHTML = "";
	        	
	        	// 2018-11-14 김민성 - 데이터 없을 때 alert -> 이미지로 변경
	        	if (list.length == 0) {
                    //alert(strLang1);
                    var div = document.getElementById("categoryViewList");
                	
                	var dl = document.createElement("DL");
                	dl.className = "nodata_sIcon";
                	dl.style.paddingTop = "70px";
                	
					var dt = document.createElement("DT");
					 
		            var img = document.createElement("IMG");
		            img.src = "/images/kr/main/noData_sIcon.png";
		             
		            var dd = document.createElement("DD");
		            dd.innerHTML = strLang535;
		             
		             dt.appendChild(img);
		             dl.appendChild(dt);
		             dl.appendChild(dd);

		             div.appendChild(dl);
		             
		             
                    return;
                }
                
                list.forEach(function(clubVO, index) {
                	/* if (index == 0 && clubVO.copCnt != 0) {
                        var total = clubVO.copCnt;
                        
                        if (total % 5 == 0) {
                            totalPage = total / 5;
                        } else {
                            totalPage = parseInt(total / 5) + 1;
                        }
                    } */
                	
                	var div = document.createElement("DIV");
                	div.className = "categoryBox";
                	div.setAttribute("code", clubVO.c_ClubNo.trim());
                	div.setAttribute("type", clubVO.c_ClubConfirmType);
                	div.onclick = function () { move_cop(this); };
                	
                	var p = document.createElement("P");
                	p.className = "categoryPic";
                	
                	var img = document.createElement("IMG");
                	if (clubVO.c_Logo_Thumbnail.indexOf("default_logo_") > -1) {
                        img.src = "/images/ezCommunity/logo/default_logo_empty.png";
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + clubVO.c_Logo_Thumbnail;
                    }
                	img.style.width = "91px";
                	img.style.height = "64px";
                	
                	var dl = document.createElement("DL");
                	dl.className = "categoryInfo";
                	
                	var dt = document.createElement("DT");
                	dt.className = "sort";
                	dt.innerHTML = getcategoryname(clubVO.c_name);
                	dt.style.backgroundColor =  categoryColor;
                	
                	var dd = document.createElement("DD");
                	dd.className = "title";
                	dd.innerHTML = MakeXMLString(primary == "1" ? clubVO.c_ClubName : clubVO.c_ClubName2);
                	
                	var dd2 = document.createElement("DD");
                	dd2.className = "categoryInfo_count";
                	
                	var span = document.createElement("SPAN");
                	span.className = "icon";
                	
                	var img2 = document.createElement("IMG");
                	img2.src = "../images/kr/community/categoryBox_iconLineup.gif";
                	
                	var span2 = document.createElement("SPAN");
                	span2.className = "count";
                	span2.innerHTML = clubVO.c_MemberCnt;
                	
                	var span3 = document.createElement("SPAN");
                	span3.className = "icon";
                	
                	var img3 = document.createElement("IMG");
                	img3.src = "../images/kr/community/categoryBox_iconPost.gif";
                	
                	var span4 = document.createElement("SPAN");
                	span4.className = "count";
                	span4.innerHTML = clubVO.itemCnt;
                	
                	
                    p.appendChild(img);
                    dl.appendChild(dt);
                    
                    dl.appendChild(dd);
                    
                    span.appendChild(img2);
                    dd2.appendChild(span);
                    dd2.appendChild(span2);
                    span3.appendChild(img3);
                    dd2.appendChild(span3);
                    dd2.appendChild(span4);
                    
                    dl.appendChild(dd2);
                    
                    div.appendChild(p);
                    div.appendChild(dl);
                    
                    document.getElementById("categoryViewList").appendChild(div);
                   
                });
                
               /*  list.forEach(function(clubVO, index) {
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
                    
                	if (clubVO.c_Logo_Thumbnail.indexOf("default_logo_") > -1) {
                        img.src = "/images/ezCommunity/logo/" + clubVO.c_Logo_Thumbnail;
                    } else {
                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + clubVO.c_Logo_Thumbnail;
                    }
                    
                    img.style.width = "84px";
                    img.style.height = "60px";
                    var dd = document.createElement("DD");
                    var strong = document.createElement("STRONG");
                    strong.setAttribute("code", clubVO.c_ClubNo.trim());
                    strong.setAttribute("type", clubVO.c_ClubConfirmType);
                    strong.style.cursor = "pointer";
                    strong.onclick = function () { move_cop(this); };
                    
                    if (primary == "1") {
                        strong.innerHTML = MakeXMLString(clubVO.c_ClubName);
                    } else {
                        strong.innerHTML = MakeXMLString(clubVO.c_ClubName2);
                    }
                    
                    dd.appendChild(strong);
                    var dd2 = document.createElement("DD");
                    dd2.innerHTML = MakeXMLString(clubVO.c_ClubDesc);

                    var dd3 = document.createElement("DD");
                    
                    if (primary == "1") {
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
					span5.style.background = "#e8e8e8"
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
                }); */
                
                //document.getElementById("categoryViewList").appendChild(table);
                //makePageSelPage();
	        }

	        function get_todaycop() {
	            $.ajax({
					type : "GET",
					dataType : "json",
					async : true,
					url : "/ezCommunity/todayCop.do",
					success: function(result){
						if (result["clubVO"] != null) {
							event_get_todaycop(result);
						} else {
							/* var h1 = document.createElement("H1");
			                var img = document.createElement("IMG");
			                img.style.width = "156px";
			                img.style.height = "28px";
			                
			                if ('${userInfo.lang}' == '3') {
			                	img.src = "/images/jp/community/title_todayCommunity_jp.png";
			                } else {
			                	img.src = "/../images/kr/community/title_todayCommunity.png";
			                }
			                img.alt = "today Community";

			                h1.appendChild(img); */

			                var div = document.createElement("DIV");
			                div.className = "todayCommunity";			                

			                var div2 = document.createElement("DIV");
			                div2.className = "todayCommunityLayout";
			                
			                var strHtml = "<p class='btn_CommunityMore' type='2' code='C_48'><img src='/../images/kr/community/btn_todayCommunity.png' /></p>";
			                strHtml += "<p class='todayCommunity_img'><img src='/images/ezCommunity/logo/default_logo_empty.png' /></p>";
			                strHtml += "<dl class='todayCommunity_list'><div style='text-align:center'><img style='margin-top:13px;' src='/images/kr/main/nodata_plan.png' />&nbsp;<div style='margin-top:10px;color:#d0d0d0;font-weight:bold'>"+strLang88+"</div></div></dl>";
			                
			                div2.innerHTML = strHtml;
			                div.appendChild(div2);
			                
			                document.getElementById("todaycop").appendChild(div);
							
						}
					}
				});
	        }
	        
	        function event_get_todaycop(result) {
                /* var h1 = document.createElement("H1");
                var img = document.createElement("IMG");
                img.style.width = "156px";
                img.style.height = "28px";
                
                if ('${userInfo.lang}' == '3') {
                	img.src = "/images/jp/community/title_todayCommunity_jp.png";
                } else {
                	img.src = "/../images/kr/community/title_todayCommunity.png";
                }
                img.alt = "today Community";

                h1.appendChild(img); */

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
                img2.src = "/../images/kr/community/btn_todayCommunity.png";

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
                
                if (result["clubVO"]["c_Logo_Thumbnail"].indexOf("default_logo_") > -1) {
                    img3.src = "/images/ezCommunity/logo/" + result["clubVO"]["c_Logo_Thumbnail"];
                } else {
                    img3.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + result["clubVO"]["c_Logo_Thumbnail"];
                }

                p2.appendChild(img3);

                var dl = document.createElement("DL");
                dl.className = "todayCommunity_list";

                var dt = document.createElement("DT");
                
                if(primary == "1") {
                    dt.innerHTML = MakeXMLString(result["clubVO"]["c_ClubName"]);
                } else {
                    dt.innerHTML = MakeXMLString(result["clubVO"]["c_ClubName2"]);
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
                
                if (primary == "1") {
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

                /* document.getElementById("todaycop").appendChild(h1); */
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

	            /* if (searchvalue == "") {
	                alert(strLang4);
	                return;
	            } */
	        	$("#listCategory .txt").removeClass("bold");
	            search = true;

	            CurPage = "1";
	            
	            $.ajax({
					type : "GET",
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
					type : "GET",
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
				var type = val.parentNode.id;

				if (gubun == "3") {
					if (type == 'listCommunityPop') {
						$.ajax({
							type : "GET",
							dataType : "text",
							url : "/ezCommunity/boardItemViewPhoto.do",
							data : {	
								showAdjacent : 1,
								itemID : pItemID,
								boardID : pItemBoardID,
								type : "pop"
							},
							success: function(result){
								try {
									var resultObj = JSON.parse(result);
									if (resultObj.result == false) {
										GetOpenWindow("/ezCommunity/communityMainPopBoardAlert.do","", 370, 190);
									}
								} catch (e) {
									GetOpenWindow("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
								}
							}
						});
					} else {
						if (CrossYN()) {
							window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
						} else {
							window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + 1 + "&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
						}
					}
	            } else {
					if (type == 'listCommunityPop') {
						$.ajax({
							type : "GET",
							dataType : "text",
							url : "/ezCommunity/boardItemView.do",
							data : {
								showAdjacent : 1,
								itemID : pItemID,
								boardID : pItemBoardID,
								type : "pop"
							},
							success: function(result){
								try {
									var resultObj = JSON.parse(result);
									if (resultObj.result == false) {
										GetOpenWindow("/ezCommunity/communityMainPopBoardAlert.do","", 370, 190);
									} 
								} catch (e) {
									GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1 + "&type=pop", "", 750, 721);
								}
							}
						});
					} else {
						if (CrossYN()) {
							GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1, "", 750, 721);
						} else {
							GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1, "", 750, 721);
						}
					}
	            }
	        }

	        var idx = "";
	        var mainVal = "";
	        function move_cop(val) {
		        idx = val.getAttribute("code");
	        	if(idx != undefined || idx != null) {
		        	var clubgubun = 0;
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
											type : "GET",
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
							                            window.open("/ezCommunity/join1.do?no=" + idx, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
							                        } else if (type == "3") {
							                            window.open("/ezCommunity/join2.do?no=" + idx, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
							                        }
							                	} else {
							                    	alert("<c:out value = '${userName}' />" + strLang7);
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
	        }
	        
	        function move_cop_Complete(rtn) {
	        	if (rtn) {
	        		$.ajax({
						type : "GET",
						dataType : "text",
						async : false,
						url : "/ezCommunity/getIsJoin.do",
						data : { code	:	idx
						},
						success: function(result){
							if (result == "FALSE") {
								var wWidth = "330";
				                var wHeight = "197";
				                var heigth = window.screen.availHeight;
				                var width = window.screen.availWidth;
		                        var left = (width - wWidth) / 2;
		                        var top = (heigth - wHeight) / 2;
		                        var type = mainVal.getAttribute("type");

		                        if (type == "2") {
		                            window.open("/ezCommunity/join1.do?no=" + idx, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
		                        } else if (type == "3") {
		                            window.open("/ezCommunity/join2.do?no=" + idx, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWidth + ",top=" + top + ",left = " + left);
		                        }
		                	} else {
		                    	alert("<c:out value = '${userName}' />" + strLang7);
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
	                
	                /* 2018-12-24 김민성 - 커뮤니티 팝업 해상도 1600*900 이하 height 조절 */
	                if(wHeight > heigth) {
                    	wHeight = heigth-100;
                    }

	                var ret = window.open(url, code, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	                
	                try { ret.focus() } catch (e) { }
	            }
	        }
	        
	        var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
	
		    function Tab1_MouserOut(obj) {
		        if(Tab1_SelectID != obj.id) 
		            obj.className = "";
		    }
	
		    function Tab1_MouseClick(obj) {		
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
	
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    
		    function ChangeTab(obj) {
		        var pSelectTab = obj.id;

		        switch (pSelectTab) {
		            case "tagsub1": change_tab('mycop'); break;
		            case "tagsub2": change_tab('categorycop'); break;
		        }
		    }
	        
	        function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };

		                    if (i == 1) {
		                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
		                    }	
		                }
		            }
		        }
		    }
	        
	        //2018-08-27 김보미 - 커뮤니티 타이틀 너비 조정
	        window.onresize = function () {   	
	        	//commuTitleWidth();
		    }
	        
	        /* 2019-02-24 홍승비 - 커뮤니티 멤버, 게시물 수에 따라 커뮤니티명 길이 조절 수정 */
			function commuTitleWidth() {
				var titleWidth0 = "";
				var titleWidth1 = "";
				
				// 첫번째 커뮤니티, 두번째 커뮤니티의 이름 길이를 각각 계산하도록 수정, 화면 사이즈 축소 시 두 탭이 찌그러지지 않도록 body에 min-width 부여
				if (document.getElementById("tagsub1").className != "") {
					if ($(".tabpartMycommunityTitle").eq(0).width() != null) {
						titleWidth0 = $(".tabpartMycommunityTitle").eq(0).width() - $(".tabpartMycommunityTitle dd").eq(0).width() - 40; // 40은 커뮤니티명 앞에 이미지 너비때문에 빼는것.
						$(".tabpartMycommunityTitle dt").eq(0).css("width", titleWidth0 + "px");
					}
					
					if ($(".tabpartMycommunityTitle").eq(1).width() != null) {
						titleWidth1 = $(".tabpartMycommunityTitle").eq(1).width() - $(".tabpartMycommunityTitle dd").eq(1).width() - 40;
						$(".tabpartMycommunityTitle dt").eq(1).css("width", titleWidth1 + "px");
					} 
				}
			}
			
			/* 2018-09-13 홍승비 - 커뮤니티 메인홈의 새로고침 함수 추가 */
			function refresh_onclick() {
				window.location.reload(false);	
			}
			
			/* 2018-11-12 김민성 - 커뮤니티 공지사항 조회 */
			function btn_bbsView(sURL, ttt) {
			    var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 200;
	            pwidth = pwidth - 127;
	
	            var feature = "width=760,height=720";
	            feature = feature + GetOpenPosition(760, 720);
	            window.open("/ezCommunity/board/bbsViewNew.do?mode=content&no=" + sURL + "&bName=" + ttt, "", feature);
			}
			
			/* 2024-10-08 황인경 - 커뮤니티 > 인기글 조회 */
			function getPopBoard() {
				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezCommunity/popularBoardItem.do",
					success: function(result){
						event_get_myCommunity(result, 'pop');
					}
				});
			}
			
		</script>
	</head>
	<body class="mainbody" style="margin:20px 0 0; min-width:1040px; padding:0 30px 10px;">
		<div class="main_community_center">
			<!-- communitySection01 : banner -->
		    <div class="community_section01">
		    	<div class="contents_bannerCommunity">
		        	<p>
		        		<c:choose>
			        		<c:when test ="${userInfo.lang == 1}"> 
				                	<img src="../images/kr/community/bannertxt.png">
				            </c:when>
				            <c:when test ="${userInfo.lang == 3}"> 
				                	<img src="../images/jp/community/bannertxt.png">
				            </c:when>
				            <c:otherwise>
				            		<img src="../images/us/community/bannertxt.png">
				            </c:otherwise>
				         </c:choose>
		        	</p>
		        </div>
		    </div>
		    <!-- //communitySection01 : banner -->
		    <!-- communitySection02 : notice + board -->
		    <div class="community_section02">
		    	<div class="contents_noticeCommunity">
		        	<dl class="contents_tabCommunity">
		                <dt><spring:message code='ezCommunity.khj07'/></dt>
		            </dl>
		            <ul id="listCommunity" class="contents_listCommunity">
		            	<c:choose>
		            		<c:when test="${fn:length(cNoticeList) eq 0 }"> 
		            			<dl class="nodata_sIcon">
									<dt><img src="/images/kr/main/noData_sIcon.png"></dt>
								    <dd><spring:message code='ezCommunity.kmsc01'/></dd>
								</dl>
		            		</c:when>
		            		<c:when test="${fn:length(cNoticeList) ne 0 }">
		            			<c:forEach items="${cNoticeList }" var="list" begin="0" end="4" >
		            				<li>
		            					<c:if test="${list.re_Level > 0}">
		            						<span class="icon_reply">
		            							<img src="/images/dum.gif" width="${list.re_Level * 10 }" height="1" border="0">
		            							<img src="/images/i_rep.gif" alt border="0">
		            						</span>
		            					</c:if>
		            					<c:if test="${list.writeDay >= pastDate}">
		            						<span class="icon_new"><img src="../images/kr/community/communityPortlet_iconnew.gif"></span>
		            					</c:if>
		            					<span class="txt" onclick="btn_bbsView('${list.no}','tbl_c_board')">${list.title }</span><span class="date">${fn:substring(list.writeDay, 0, 10) }</span>
					               </li>
					            </c:forEach>
					        </c:when>
		            	</c:choose>
		            </ul>
		        </div>
		        <div class="contents_boardCommunity">
		        	<dl class="contents_tabCommunity">
		                <dt class="boardNewPop" id="newPost" onclick="get_myCommunity()"><spring:message code='ezCommunity.kmsc02'/></dt>
		                <dt class="boardNewPop" id="popularPost" onclick="getPopBoard()"><spring:message code='ezCommunity.popularPosts01'/></dt>
		            </dl>
		            <ul id="listCommunity2" class="contents_listCommunity">
		            </ul>
		            <ul id="listCommunityPop" style="display: none" class="contents_listCommunity">
		            </ul>
		        </div>
		    </div>
		    <!-- //communitySection02 : notice + board -->
		    <!-- communitySection02 : category -->
		    <div class="community_section03">
		    	<div class="contents_category">
		            <div class="contents_categoryTab">
		                <dl class="contents_tabCategory">
		                    <dt><spring:message code='ezCommunity.t2006'/></dt>
		                </dl>
		                <ul id="listCategory" class="contents_listCategory"></ul>
		            </div>
		            <div class="contents_categoryView">
		                <div class="contents_searchCategory">
		                    <dl>
		                        <dt class="selectbox">
		                            <select id="search" name="select" style="padding-left: 3px;">
			                                <option value ="NAME"><spring:message code = 'ezCommunity.t2007' /></option>
			                                <option value ="DESC"><spring:message code = 'ezCommunity.t2008' /></option>
			                         </select>
		                        </dt>
		                        <dt class="searchinput"><input id="keyword" name="keyword" onkeydown="key_down(event)" type="text"></dt>
		                        <dd onclick="copsearch()" class="btn_searh"><spring:message code='ezCommunity.t31'/></dd>
		                    </dl>
		                </div>
		                <div id="categoryViewList" class="contents_categoryViewList"></div>
		            </div>
		        </div>
		    </div>
		    <!-- //communitySection02 : category -->
		</div>
		<!-- main_community_right -->
		<div class="main_community_right">
			<!-- contents_newCommunity -->
		    <div class="contents_newCommunity">
		        <dl class="contents_tabCommunity">
		            <dt><spring:message code='ezCommunity.kmsc04'/></dt>
		            <dd id="newcommBtn"  class="btn_more"></dd>
		        </dl>
		        <dl id="newcomm" class="contents_rightCommunity">
		        </dl>
		    </div>
		    <!-- //contents_newCommunity -->
		    <!-- contents_popularCommunity -->
		    <div class="contents_popularCommunity">
		        <dl class="contents_tabCommunity">
		            <dt><spring:message code='ezCommunity.kmsc03'/></dt>
		            <dd id="bestcommBtn" class="btn_more"></dd>
		        </dl>
		        <dl id="bestcomm" class="contents_rightCommunity">
		        </dl>
		    </div>
		    <!-- //contents_popularCommunity -->
		</div>
		<!-- //main_community_right -->
		</body> 
	<%-- 
	<body style="min-width:500px;">
		<div class="main_community">
			<table style="width:100%" border="0" class="main_communityTop">
				<tr>
		    		<td>
			            <div class="contents_todayCommunity" id="todaycop"><span class="todayComm"><spring:message code = "ezCommunity.jjh01" /></span></div>
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
			            <div id="tabnav" class="portlet_tabpart01" style="width:100%;margin-top:5px">
							<div class="portlet_tabpart01_top" id="tab1">
							    <p><span id="tagsub1"><spring:message code = 'ezCommunity.t2005' /></span></p>
							    <p><span id="tagsub2"><spring:message code = 'ezCommunity.t2006' /></span></p>
						  	</div>	
						</div>
				   		<script type="text/javascript">
				   			Tab1_NewTabIni("tab1");
						</script>
			            <div id ="mycommunity" style="height:477px"></div>
			            <div id ="categorycommunity" style="display:none;">
			                <div class="tabpartMycommunity02" style="margin-top:18px">
			                    <div class="left_tabpart">
			                        <ul class="left_tabpartTitle">
			                            <li id="work" class="on" onclick ="change_tab('WORK')" style="cursor:pointer"><span style="text-align: center"><spring:message code = 'ezCommunity.t80' /></span></li>
			                            <li id="type" class="line" onclick ="change_tab('TYPE')" style="cursor:pointer"><span style="text-align: center"><spring:message code = 'ezCommunity.t81' /></span></li>
			                        </ul>			                        
			                        <div class="left_tabpartList_layout" id ="categorytab"></div>
			                    </div>
			                    
			                    <div class="right_content">
			                        <div class="right_tabpartContent">
			                            <div class="right_CopSearchLayout">
			                                <p class="right_CopSearch">
			                                    <select id="search" name="select" style="height:22px">
			                                        <option value ="NAME"><spring:message code = 'ezCommunity.t2007' /></option>
			                                        <option value ="DESC"><spring:message code = 'ezCommunity.t2008' /></option>
			                                    </select>
			                                    
			                                    <input id="keyword" name="keyword" onkeydown ="key_down(event)" style="height:22px"/>
			                                    <a class="imgbtn imgbck"><span onclick ="copsearch()"><spring:message code = 'ezCommunity.t31' /></span></a>
			                                </p>
			                            </div>			                            
			                            <div id ="categorylist"></div>
			                        </div>
			                    </div>
			                </div>
			            </div>
			        </td>
			    </tr>
			</table>
			<div id="tblPageRayer" style="text-align:center;margin-top:3px;"></div>
		</div>
	</body> --%>
</html>
