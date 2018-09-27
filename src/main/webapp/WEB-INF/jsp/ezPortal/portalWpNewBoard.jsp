<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">	
		<style>
			.portlet_list li {
				cursor:pointer;
				background:none;
				display:inline-block;
				width:118px;
				height:180px;
			}
			.noticeImg {
				cursor:pointer;
				width:118px;
				height:155px;
			}
			.noticeSpan {
				display:block;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<%-- <section  class="body_bg1">
      		<article class="portlet_notice">
        		<p class="title"><img src="/images/<spring:message code='main.t00025' />/main/notice_title.gif" alt=""> <span onclick='Boardmore_NewBoard_btnClick()' class="btn_more"><img src="/images/<spring:message code='main.t00025' />/main/btn_more01.gif" alt="more"></span></p>
        		<dl class="notice_tab">
          			<dt id="Board0_Newboard" DATA1="${pCompanyBoard}" TYPE="${pCompanyType}" onclick="boardChangeTab_Newboard(this)" class="on" onmouseover="tabover(this)" onmouseout="tabout(this)"><span>${pCompanyBDNM}</span></dt>
          			<dt id="Board1_Newboard" DATA1="${pDeptBoardID}" TYPE="${pDeptType}" onclick="boardChangeTab_Newboard(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><span>${pDeptBDNM}</span></dt>
          			<dt id="Board2_Newboard" DATA1="${pNewsBoardID}" TYPE="${pNewsType}" onclick="boardChangeTab_Newboard(this)" onmouseover="tabover(this)" onmouseout="tabout(this)"><span>${pNewsBDNM}</span></dt>
        		</dl>
          		<div id="BoardList_NewBoard" >
        		</div>
      		</article>
		</section>

		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css"> --%>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
    		var pBoardID_NewBoard = "${pCompanyBoard}";
    		var pBoardType_NewBoard = "";
    		var BoardCnt_NewBoard = 0;
    		var strLang1_NewBoard = "<spring:message code='main.t00025'/>";
    		var strLang2_NewBoard = "<spring:message code='main.t00026'/>";
			var selTab = "";
			
        	document.onselectstart = function () { return false; };
        
	        window.onload = function(){
    	        if (navigator.userAgent.indexOf('Firefox') != -1) {
        	        document.body.style.MozUserSelect = 'none';
            	    document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
                	document.body.style.oUserSelect = 'none';
                	document.body.style.UserSelect = 'none';
            	}
    	        // 2016-08-03 첫화면에 공지게시판 불러오기
				getBoardList_NewBoard();
				selTab = "Board0_Newboard";
				
				/* 2018-09-27 홍승비 - 포틀릿에 게시판이 등록되어있지 않다면 셀 나타내지 않도록 수정 */
				if ("${pCompanyBoard }" == "") {
					document.getElementById("Board0_Newboard").style.display = "none";
				}
				if ("${pDeptBoardID }" == "") {
					document.getElementById("Board1_Newboard").style.display = "none";
				}
				if ("${pNewsBoardID }" == "") {
					document.getElementById("Board2_Newboard").style.display = "none";
				}
				
            	try { top.onresize() } catch (e) { }
        	}
        	var xmlhttp_getBoardList_NewBoard = createXMLHttpRequest();
        	
        	/* 2018-09-14 홍승비 - 포틀릿에 표출되는 게시판에서 공지사항 리스트 제거 */
        	function getBoardList_NewBoard() {
                $.ajax({
    	        	type : "POST",
    	        	dataType : "text",
    	        	url : "/ezBoard/getBoardList.do",
    	        	data : {
    	        		type : "portletBoard",
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
	                    /* var nodata = "<div class='nodata_portlet '>";
    	                nodata += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
        	            nodata += "<p>" + strLang2_NewBoard + "</p></div>";

            	        document.getElementById("BoardList_NewBoard").innerHTML = nodata;
                	    return; */
                	}
                	document.getElementById("BoardList_NewBoard").innerHTML = "";
                	var listHTML = "";
                	var xmldom = xml;

	                var RowCnt = xmldom.getElementsByTagName("ROW").length;
                
    	            if (RowCnt > 0) {
    	            	/* 2018-09-11 홍승비 - 포틀릿에 표시되는 게시물의 수는 3개로 고정 */
        	            /* if (RowCnt > 6) {
            	            	RowCnt = 6;
            	            }*/
						if (RowCnt > 3) {
        	            	RowCnt = 3;
    	            	}
            	        
        	            /* 2018-08-21 장진혁 - 포틀릿 변경으로 주석처리 */
                	    /* var pfirstItemID = "";                    
                        pfirstItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(0));                       	
                        listHTML = "<dl onclick=\"openDoc('" + pfirstItemID + "')\" class='nt_pic' style='cursor:pointer'>"; */

                        /* 2018-07-12 홍승비 - 포탈 포틀릿 게시판 제목 특수문자 처리 */
                        /* 2018-08-21 장진혁 - 포틀릿 변경으로 주석처리 */
                        /* var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("TITLE").item(0)));
                        listHTML += "<dt class='tit'><strong>" + DOCTITLE + "</strong></dt>";
                        listHTML += "<dd class='photo'><img src='/images/" + strLang1_NewBoard + "/main/notice_pic.jpg' width='83' height='54' alt=''></dd>";
                        listHTML += "<dd id='content' class='txt'></dd>";
                        listHTML += "</dl>";
                        listHTML += "<ul class=\"mainlist \">";  */
                        
                        var FboardMainContent = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA12").item(0));
                        boardType = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("GUBUN").item(0));
                        
                        //for (var i = 1; i < RowCnt; i++) {
                        for (var i = 0; i < RowCnt; i++) {
                            var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("TITLE").item(0)));
                            var pItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(0));
                            var newItemFlag = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("DATA7").item(0));
                            var notiNewText = "";
                            var imgSrc = "";
                            
                            if (newItemFlag == "Y") {
                            	notiNewText = "N";
                            	newItemFlag = "noti_new";
                            }
                            
                          //  listHTML += "<li  style='cursor:pointer' onclick=\"openDoc('" + pItemID + "')\" >" + DOCTITLE + "</li>";
                          /* 2018-09-11 홍승비 - 게시물의 이미지와 제목을 화면에 뿌려주도록 수정 */
							$.ajax({
								type : "POST",
								dataType : "text",
								async : false,
								url : "/ezBoard/getContentInfo.do",
								data : { type   : "BOARDCONTENT",
										 docID   : pItemID 
									   },
								success: function(filePath){
									imgSrc = getMhtImg(pItemID, filePath);
									
									// mht 내부에 사진이 없는 경우, 디폴트 이미지 사용함
									if (imgSrc == "") {
										imgSrc = "/images/kr/main/notiImg0" + (i + 1) + ".png";
									}
									
									listHTML += "<li class='notiLI'><dl class='notiDL0" + (i + 1) + "' onclick=\"openDoc('" + pItemID + "')\">";
									listHTML += "<dt class='noti_num'>" + (i + 1) + "</dt><dt class='" + newItemFlag + "'>" + notiNewText + "</dt>";
									listHTML += "<dd class='noti_text'>" + DOCTITLE + "</dd></dl></li>";
								}
							});
                        }
                     //   listHTML += "</ul>";
                     
                     // 게시물이 3개 미만이라면, 디폴트 게시물 이미지를 대신 표출한다.
                     if (RowCnt < 3) {
						for (i = RowCnt; i < 3; i++) {
							listHTML += "<li class='notiLI'><p class='noti_nodata'></p></li>";
                    	 }
                     }
                        
					document.getElementById("BoardList_NewBoard").innerHTML = listHTML;
                        
                        /* 2018-09-11 홍승비 - 게시물의 내용(content)을 화면에 표출하는 부분 주석처리 */
						/* 
                        if (boardType == "3" || boardType == "4") {
                        	document.getElementById("content").innerHTML = FboardMainContent;	
                        } else {
                        	getContent(pfirstItemID);
                        }
                         */
	                } else {
                    	/* var nodata = "<div class='nodata_portlet '>";
                    	nodata += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
                    	nodata += "<p>" + strLang2_NewBoard + "</p></div>";

                    	document.getElementById("BoardList_NewBoard").innerHTML = nodata; */
                    	
	                	var listHTML = "";
					    listHTML += "<dl class='nodata'>";
	                	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
	                	listHTML += '<dd>"' + strLang2_NewBoard + '"</dd>';
	                	listHTML += "</dl>";
	                	
	                	document.getElementById("BoardList_NewBoard").innerHTML = listHTML;
                	}
            	} catch (e) {
            		
            	}
        	}
			
			/* 2018-09-11 홍승비 - mht파일 내부의 첫번째 이미지 경로를 리턴하는 함수 */
			function getMhtImg(pItemID, filePath) {
				var imgMht = "";
				var imgSrc = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type   : "BOARDCONTENT", 
							 itemID : pItemID,
							 href   : filePath 
						   },
					success: function(result){			
						imgMht = result.substr(result.indexOf('<img src="'));
						imgMht = imgMht.substring((imgMht.indexOf('"') + 1), imgMht.indexOf(">"));
						imgMht = imgMht.substring(0, imgMht.indexOf('"'));
						
						if(imgMht == "") {
							imgSrc = "";
						} else {
							imgSrc = imgMht;
						}
					}
				});
				
				return imgSrc;
			}
			
			function openDoc(pItemID) {
	            var pheight = window.screen.availHeight;
            	var pwidth = window.screen.availWidth;
            	var pTop = (pheight - 720) / 2;
            	var pLeft = (pwidth - 765) / 2;

            	/* 2018-09-19 홍승비 - 포탈 포틀릿에서 포토/썸네일게시물 보기 시 창 크기 수정 */
				if (boardType == "3" || boardType == "4") {
					if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
						var height = 789;
					} else {
						var height = 785;
					}
					pTop = (pheight - 789) / 2;
					pLeft = (pwidth - 764) / 2;
					
	                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoard, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height="+ height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
            	} else {
	                if (CrossYN())
    	                window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoard, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
        	        else
            	        window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoard, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
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
            	xmlhttp_getContent_Newboard.open("GET", "/ezBoard/getItemInfo.do?boardID=" + pBoardID_NewBoard + "&itemID=" + pItemID , false);
            	xmlhttp_getContent_Newboard.onreadystatechange = getContent_NewBoard_after;
            	xmlhttp_getContent_Newboard.send(xmlpara);
        	}
        	
        	function getContent_NewBoard_after() {
	            if (xmlhttp_getContent_Newboard == null || xmlhttp_getContent_Newboard.readyState != 4) return;
	            
    	        try {
        	        var xmldom = xmlhttp_getContent_Newboard.responseXML;
            	    xmlhttp_getContent_Newboard = null;
	                /* var tempStr;
                	if (getNodeText(xmldom.getElementsByTagName("MainContent").item(0)) == "") {
	                    var strContentHref = getNodeText(xmldom.getElementsByTagName("ContentLocation").item(0));
    	                var ConverContentUrl = location.protocol + "//" + location.host + "/ezCommon/downloadAttach.do?filePath=" + strContentHref;
        	            tempStr = ConvertMHTtoHTML(ConverContentUrl);
            	    } else {
                    	tempStr = getNodeText(xmldom.getElementsByTagName("MainContent").item(0));
                	} */
                	
                	var strContentHref = getNodeText(xmldom.getElementsByTagName("ContentLocation").item(0));
                	var tempStr = ConvertMHTtoHTML(strContentHref);
                	
                	var DocContentObject = document.createElement("DIV");
                	DocContentObject.innerHTML = tempStr;
                	var DocContentObject_Div = document.createElement("DIV");
                	DocContentObject_Div.innerHTML = CrossYN() ? DocContentObject.textContent.replace(/<P>/gi, "").replace(/<\/P>/gi, "") : DocContentObject.innerText.replace(/<P>/gi, "").replace(/<\/P>/gi, "");

	                if (DocContentObject_Div.getElementsByTagName("style").length > 0) {
    	                DocContentObject_Div.removeChild(DocContentObject_Div.getElementsByTagName("style")[0]);
        	        }
	                
            	    if (CrossYN()) {
                	    DocContentObject.innerHTML = DocContentObject_Div.textContent.replace(/(\r\n)/g, "");
            	    } else {
                    	DocContentObject.innerHTML = DocContentObject_Div.innerText.replace(/(\r\n)/g, "");
            	    }
            	    /* 2018-07-12 홍승비 - 포탈 포틀릿 게시판 제목+내용 특수문자 처리 */
            	    //DocContentObject.innerHTML = MakeXMLString(DocContentObject.innerHTML);
                	document.getElementById("content").appendChild(DocContentObject);
	            }
    	        catch (e) {
        	    }
	        }	
        	
    	    function boardChangeTab_Newboard(obj) {
        	    switch (obj.id) {
            	    case "Board0_Newboard":
						selTab = "Board0_Newboard";
                	    document.getElementById("Board0_Newboard").className = "on";
                    	document.getElementById("Board1_Newboard").className = "";
                    	document.getElementById("Board2_Newboard").className = "";
                    	break;

	                case "Board1_Newboard":
	                	selTab = "Board1_Newboard";
    	                document.getElementById("Board0_Newboard").className = "";
        	            document.getElementById("Board1_Newboard").className = "on";
            	        document.getElementById("Board2_Newboard").className = "";
                	    break;

                	case "Board2_Newboard":
                		selTab = "Board2_Newboard";
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
            	/* if (document.getElementById("Board0_Newboard").className == "on") {
                	pBoardID_NewBoard = document.getElementById("Board0_Newboard").getAttribute("DATA1");
                	getBoardList_NewBoard();
            	} else if (document.getElementById("Board1_Newboard").className == "on") {
                	pBoardID_NewBoard = document.getElementById("Board1_Newboard").getAttribute("DATA1");
                	getBoardList_NewBoard();
            	} else {
                	pBoardID_NewBoard = document.getElementById("Board2_Newboard").getAttribute("DATA1");
                	getBoardList_NewBoard();
            	} */
        		getBoardList_NewBoard();
        	}
        	
        	/* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "on");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != selTab) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
	        // window.onload로 해당 함수기능 이동하여 주석처리 
        	// window_onload_Newboard();
		</script>
	</head>
	<body>
		<div class="layDIV">
            <dl class="portlet_title">
                <dt class="portletText">${pCompanyBDNM}</dt>
                <dd class="portletPlus" onclick='Boardmore_NewBoard_btnClick()'><img src="/images/kr/main/portlet_Plus.png"></dd>
            </dl>
            <ul class="noti_portlet_list" id="BoardList_NewBoard">
                
            </ul>
        </div>
		<!-- 2018-08-21 장진혁 포틀릿 변경으로 주석처리 -->
		<%-- <section  class="body_bg1">
      		<article class="portlet_notice">
        		<p class="title"><img src="/images/<spring:message code='main.t00025' />/main/notice_title.gif" alt=""> <span onclick='Boardmore_NewBoard_btnClick()' class="btn_more"><img src="/images/<spring:message code='main.t00025' />/main/btn_more01.gif" alt="more"></span></p>
        		<dl class="notice_tab">
          			<dt id="Board0_Newboard" DATA1="${pCompanyBoard}" TYPE="${pCompanyType}" onclick="boardChangeTab_Newboard(this)" class="on"><span>${pCompanyBDNM}</span></dt>
          			<dt id="Board1_Newboard" DATA1="${pDeptBoardID}" TYPE="${pDeptType}" onclick="boardChangeTab_Newboard(this)"><span>${pDeptBDNM}</span></dt>
          			<dt id="Board2_Newboard" DATA1="${pNewsBoardID}" TYPE="${pNewsType}" onclick="boardChangeTab_Newboard(this)"><span>${pNewsBDNM}</span></dt>
        		</dl>
          		<div id="BoardList_NewBoard" >
        		</div>
      		</article>
		</section> --%>
	</body>
</html>
