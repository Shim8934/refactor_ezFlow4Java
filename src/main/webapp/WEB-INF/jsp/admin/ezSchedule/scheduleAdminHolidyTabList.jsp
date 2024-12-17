<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<!-- <html style="height: 99%;"> -->
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <!-- <link rel="stylesheet" href="${util.addVer('/css/tab_over.css')}" type="text/css"> -->
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <style type="text/css">
	    .tabpart01UL{
	    	position:absolute;
	    	top:35px;
	    	right:0px;
	    	background:white;
	    	padding:25px;
	    	border:1px solid #999;
	    	width:120px;
	    	list-style-image:url("/images/kr/cm/dot_blue.gif");
	    }
	    .tabpart01UL li {
	    	height:20px;
	    	color:#777;
			white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
	    }
	    </style>
	    <script type="text/javascript">
	        var userLang = "${userLang}";
	        var xmlhttp = createXMLHttpRequest();
	        var timer = null;
	        var companylist = "<c:out value='${companyList}'/>"; //(ex. S907001,가온아이A;S907000,가온아이B;)
	        
			window.onresize = function () {
				var delay = 100;
				/**
					onresize의 경우 완료되는 경우 한 번에 실행되는 것이 아니라. 유저가 화면을 만질때마다 계속 발생.
					setTimeout을 이용해서 resize 작업이 끝날 경우에만 동작하도록 처리.
				*/
				clearTimeout(timer);
				timer = setTimeout(resizeMenuTab, delay);
			}
			
	        window.onload = function () {
	        	GetMyBoardItem_evnet();
	        };
	        
	        /**
	        	브라우저 리사이즈 대비 tab 동적 변경
	        */
	        function resizeMenuTab() {
				var doNotRefresh = true;      // 화면을 리프레시 하는지 여부.
				var isOpenUL;                 // '...' 탭이 열리있는지 확인
				//var isResize = true;          // 리사이즈 중인지 확인.
				
				// '...'탭이 열려있는 경우를 판단
				if(document.getElementById("tabpart01UL") === null || document.getElementById("tabpart01UL").style.display == "none") {
					isOpenUL = false;
				} else {
					isOpenUL = true;	
				}
				
				var selectedNode = document.getElementById("curTabID").value;
				
				document.getElementById("tab1").innerHTML = "";
				widthCheck = false;
				
				GetMyBoardItem_evnet(doNotRefresh);

				if(document.querySelectorAll('[data1="'+selectedNode+'"]')[0].tagName === "LI"){
					selectedNode = "overSpan";
				}				
				
				// GetMyBoardItem_event를 끝내고 '...'탭의 display상태를 유지
				if(isOpenUL && document.getElementById("tabpart01UL") !== null ) {
					document.getElementById("tabpart01UL").style.display = "";	
				}
				
				// 기존에 선택되는 0번탭 해제 후 재설정.
				document.getElementById("1tab0").className = "";
				
				// 선택된 탭이 리사이징으로 인해 '...' 탭으로 가게되는 경우
				if (document.getElementById(selectedNode) !== null) {
					document.getElementById(selectedNode).className = "tabon";
					Tab1_SelectID = selectedNode;
				} else {
					// '...' 탭에서 보통 탭으로 나올 경우
					selectedNode = document.querySelectorAll('[data1="'+selectedNode+'"]')[0].id;	
					if (selectedNode != "") {
						document.getElementById(selectedNode).className = "tabon";
						Tab1_SelectID = selectedNode;
						
						if (document.getElementById("overSpan")) {
							document.getElementById("overSpan").className = "";
						}
					} else {
						if (document.getElementById("overSpan")) {
							document.getElementById("overSpan").className = "tabon";
						}
						Tab1_SelectID = "overSpan";
					}
					/* 2018-12-04 홍승비- '...'탭이 없는 경우 접근 시 스크립트 에러 수정 */
					if (document.getElementById("tabpart01UL") !== null) {
						document.getElementById("tabpart01UL").style.display = "none";
					}	
				}
	        }
	        
	        var overCnt = 0;
	        var widthCheck = false;
	        var overCntText = '...';
	        
	        function GetMyBoardItem_evnet(doNotRefresh) {
	        	
		        var tabText = "";
	        	var tabId = "a"; // anniversary
	        	var tabId2 = "s"; // statutory holiday 
	        	//탭이름 message 처리
	        	var tabName = strLangKHA1;
	        	var tabName2 = strLangKHA2;
	        	
	        	tabText += "<p id='FBoard_sub0'>";
	        	tabText += "<span id='1tab0' divname='FBoard_div0' name='FBoard_div' data1=\'"+tabId+"\' data2=\'"+tabName+"\' data5='0' class='tabover'>"+tabName+"</span>";
	        	tabText += "</p>";
	        	tabText += "<p id='FBoard_sub1'>";
	        	tabText += "<span id='1tab1' divname='FBoard_div1' name='FBoard_div' data1=\'"+tabId2+"\' data2=\'"+tabName2+"\' data5='0'>"+tabName2+"</span>";
	        	tabText += "</p>";
				
	        	document.getElementById("tab1").innerHTML = tabText;
				
                Tab1_NewTabIni("tab1");

               // 화면을 리사이징 할때는 현재 리스트는 그대로 유지
               if(doNotRefresh !== true) {
              		document.getElementById("1tab0").setAttribute("class", "tabon");
              		Tab1_SelectID = "1tab0";	                    	
              		ChangeTab(document.getElementById("1tab0"));	
               }
	        }
	
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                        document.getElementById(Tab1_SelectID).className = "";
	
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                if (!displayFlag)
	                    document.getElementById("tabpart01UL").style.display = "";
	                else {
	                    if (document.getElementById("tabpart01UL").style.display == "")
	                        document.getElementById("tabpart01UL").style.display = "none";
	                    else
	                        document.getElementById("tabpart01UL").style.display = "";
	                }
	            }
	            else {
	                if (document.getElementById("tabpart01UL").style.display == "")
	                    document.getElementById("tabpart01UL").style.display = "none";
	                else
	                    document.getElementById("tabpart01UL").style.display = "";
	            }
	        }
	        function tabAllWidth() {
	            var allWidth = 0;
	            for (var i = 0; i < document.getElementById("tab1").getElementsByTagName("P").length; i++) {
	                allWidth += document.getElementById("tab1").getElementsByTagName("P")[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	        	if(obj.id == '1tab1'){
		            document.getElementById("ListCompany").style.display = "none";
	        	} else {
		            document.getElementById("ListCompany").style.display = "";
	        	}
	        	
	        	var SelectedTabID = obj.getAttribute("DATA1");
	        	//TO-DO get방식에 companyList 가 너무 길어서 추후 터질 우려가 있음. 줄여야한다
                document.getElementById("FBoard_ifrm").src = "/admin/ezSchedule/scheduleAdminHolidayManage.do?holidayType=" + SelectedTabID + "&companylist=" + encodeURIComponent(companylist);
	            document.getElementById("curTabID").value = SelectedTabID;
	        }
	
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id)
	                obj.className = "";
	        }
	        function Tab1_MouseClick(obj) {
	            if(document.getElementById("tabpart01UL") != null)
	                document.getElementById("tabpart01UL").style.display = "none";
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	            /* overSpan의 게시판을 선택하면 overSpan display:none처리*/
	            document.getElementById("tabpart01UL").style.display = "none";	            
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id != "overSpan")
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };
	                        else
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick_more(this, true); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	        
	        function changeCompany() {
	        	$('#FBoard_ifrm').get(0).contentWindow.schedule_get_holiday();
	        }
	    </script>
	</head>
	<!-- <body class="mainbody" style="height: 89%;"> -->
	<body class="mainbody" style="height: 95%; overflow:hidden;margin-left:0px;margin-right:0px">
	 <h1 style="margin-left:10px;margin-right:10px;"><spring:message code='ezSchedule.t4003' />
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
	    <select class="companySelect" id="ListCompany" onchange="changeCompany()">
	    	<c:forEach var="item" items="${list}">
  				<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
			</c:forEach>
	    </select>
	 </h1>
		<div style="padding-left:10px;padding-right:10px">
		    <!-- <h1><span id='mailBoxInfo'></span></h1> -->
		    <div class="portlet_tabnew01">
		        <div class="portlet_tabnew01_top" id="tab1"></div>
		    </div>
		    <%-- <c:if test="${holidayType eq 'a'}">
			</c:if> --%>
		</div>    
	    <iframe id="FBoard_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	</body>
	<input type="hidden" id="curTabID" namd="curTabID" value=""/>
</html>