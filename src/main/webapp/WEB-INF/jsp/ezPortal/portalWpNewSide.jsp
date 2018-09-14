<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
		 	var pBoardID_NewBoardSTD = "${pBoardID}";
		    var pBoardType_NewBoardSTD = "${pBoardGubun}";
		    var BoardCnt_NewBoardSTD = parseInt("${pHeaderCount}");
		    var strLang1_NewBoardSTD = "<spring:message code='main.t00026' />";
		    var pNoneActiveX = "${pNoneActiveX}";
		    
		    document.onselectstart = function () { return false; };
		    
		    window.onload = function() {
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

		            /* 2018-08-21 장진혁 포틀릿 변경으로 주석처리 */
		            /* var listHTML = "<span class='tr'></span><dl class='portlet_tab'>"; */
		            
		            var listHTML = "";
		            var classon = "class='on'";

		            for (var i = 0; i < BoardCnt_NewBoardSTD; i++) {
		                var BoardName = "";
		                
		                if ("${userInfo.primary}" == "1")
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

		            	/* 2018-08-21 장진혁 포틀릿 변경으로 주석처리 */
		                /* listHTML += "</dl>";
		                listHTML += "<span class='btn_more' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/kr/main/btn_more02.gif' width='35' height='20' alt='more'></span>"; */
		                listHTML += "<dd class='portletPlus' onclick='Boardmore_NewBoardSTD_btnClick()'><img src='/images/kr/main/portlet_Plus.png'></dd>";		                

		                document.getElementById("BoardTab").innerHTML = listHTML;
		                pBoardID_NewBoardSTD = document.getElementById("Board0").getAttribute("DATA1");
		                getBoardList_NewBoardSTD();
		            } else {
		                /* var nodata = "<div class='nodata_portlet '>";
		                nodata += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
		                nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";

		                document.getElementById("BoardList").innerHTML = nodata; */
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
	    	        		console.log("<spring:message code='ezBoard.t22'/>wpNewBoardSTD" + error);	
	    	        	}
	    	        });
		        }

		        function getBoardList_after(xml) {
		            if (xml == null) return;
		            
		            try {
		                if (xml == "") {
		                    /* var nodata = "<div class='nodata_portlet '>";
		                    nodata += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
		                    nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";
		                    document.getElementById("BoardList").innerHTML = nodata;
		                    return; */
		                }

		                document.getElementById("BoardList").innerHTML = "";

		                var listHTML = "";
		                var xmldom = createXmlDom();
		                xmldom = xml;
		                var RowCnt = xmldom.getElementsByTagName("ROW").length;

		                if (RowCnt > 0) {
		                    if (RowCnt > 6)
		                        RowCnt = 6;

		                    var pfirstItemID = "";
		                    if (RowCnt > 0) {
		                    	/* 2018-08-21 장진혁 포틀릿 변경으로 주석처리 */
		                        /* pfirstItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("VALUE").item(0));
		                        listHTML = "<dl onclick=\"openDoc_section4_Type('" + pfirstItemID + "','" + FboardType + "', '" + getNodeText(xmldom.getElementsByTagName("DATA1").item(i)) + "')\" class='listtype_photo' style='cursor:pointer;margin-top:-4px'>"; */
		                        
		                        /* 2018-08-21 장진혁 포틀릿 변경으로 주석처리  */
		                        /* 2018-07-16 홍승비 - 포틀릿 게시판 특수문자 처리 */
		                        /* if (pBoardID_NewBoardSTD == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		                            var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("TITLE").item(0)));
		                        } else {
		                            var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("TITLE").item(0)));
		                        }
		                        
		                        listHTML += "<dt class='tit'><strong>" + DOCTITLE + "</strong></dt>";
		                        listHTML += "<dd class='photo'><img src='/images/kr/main/board_pic.jpg' width='86' height='61' alt=''></dd>";
		                        listHTML += "<dd id='content' class='txt'></dd>";
		                        listHTML += "</dl>";
		                        listHTML += "<ul class=\"listtype_txt \">"; */
		                        
		                        var FboardMainContent = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA12").item(0));
		                        var FboardType = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("GUBUN").item(0));
		                        
		                        for (var i = 1; i < RowCnt; i++) {
		                            if (pBoardID_NewBoardSTD == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		                                var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("TITLE").item(0)));
		                            } else {
		                                var DOCTITLE = MakeXMLString(getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("TITLE").item(0)));
		                            }
		                            
		                            /* 2018-08-21 장진혁 포틀릿 변경으로 주석처리  */
		                            /* var STARTDATE = "";
                            		var WRITERNAME = "";

                            		for (var j = 0; j < xmldom.getElementsByTagName("HEADER").length; j++) {
                                		if (getNodeText(xmldom.getElementsByTagName("HEADER").item(j).getElementsByTagName("COLNAME").item(0)) == "WRITERNAME") {
                                    		WRITERNAME = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(j));
                                		}
                                		if (getNodeText(xmldom.getElementsByTagName("HEADER").item(j).getElementsByTagName("COLNAME").item(0)) == "WRITEDATE") {
                                    		STARTDATE = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(j));
                                		}
	
    		                            if (STARTDATE != "" && WRITERNAME != "")
                                    		break;
                            		} */
		                            
		                            var pItemID = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("VALUE").item(0));		                            
		                            var FboardType = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("GUBUN").item(0));
		                            var newItemFlag = getNodeText(xmldom.getElementsByTagName("ROW").item(i).getElementsByTagName("DATA7").item(0));
		                          	//2016-10-31
		                          	//boardType이 아무 값도 들어가지 않아서, 보드타입이0일때, 메인컨텐츠에 내용이 있을때 보트타입3을넣어줌.
		                             /* var FboardMainContent = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA12").item(0));
			                        if (FboardType == "" && FboardMainContent != "") {
			                            boardType = "3";
			                        } */ 
			                        
			                        var FboardMainContent = getNodeText(xmldom.getElementsByTagName("ROW").item(0).getElementsByTagName("DATA12").item(0));
			                        if (FboardType == "" && FboardMainContent != "") {
			                            FboardType = "3";
			                        }
			                        
			                        /* 2018-08-21 장진혁 포틀릿 변경으로 주석처리  */
		                            //listHTML += "<li onclick=\"openDoc_section4_Type('" + pItemID + "','" + FboardType + "', '" + getNodeText(xmldom.getElementsByTagName("DATA1").item(i)) + "')\" ><span class='txt'>" + DOCTITLE + "</span> <span class='date'>" + STARTDATE + "</span> <span class='name'>" + WRITERNAME + "</span></li>";
			                        listHTML += "<li onclick=\"openDoc_section4_Type('" + pItemID + "','" + FboardType + "', '" + getNodeText(xmldom.getElementsByTagName("DATA1").item(i)) + "')\" >";			                        
			                        /* 2018-09-14 홍승비 - 새게시물 표시 태그 추가 */
			                        if (newItemFlag == "Y") {
			                        	listHTML += "<span class='boardNew'>N</span>";
			                        }
			                        listHTML += DOCTITLE + "</li>";
		                        }
		                        
		                        listHTML += "</ul>";
		                        document.getElementById("BoardList").innerHTML = listHTML;
		                        
		                         if (FboardType != "4" && FboardType != "3") {
		                            if (FboardMainContent != "") {
		                                /* document.getElementById("content").innerHTML = FboardMainContent; */
		                            } else {
		                                /* getContent(pfirstItemID); */
		                            }
		                        } else {
		                            /* document.getElementById("content").innerHTML = FboardMainContent; */
		                        } 
		                    } else {
		                        /* var nodata = "<div class='nodata_portlet '>";
		                        nodata += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
		                        nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";
		                        document.getElementById("BoardList").innerHTML = nodata; */
		                    	var listHTML = "";
							    listHTML += "<dl class='nodata'>";
			                	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
			                	listHTML += '<dd>"' + strLang1_NewBoardSTD + '"</dd>';
			                	listHTML += "</dl>";
			                	
			                	document.getElementById("BoardList").innerHTML = listHTML;
		                    }
		                } else {
		                    /* var nodata = "<div class='nodata_portlet '>";
		                    nodata += "<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>";
		                    nodata += "<p>" + strLang1_NewBoardSTD + "</p></div>";
		                    document.getElementById("BoardList").innerHTML = nodata; */
		                    
		                	var listHTML = "";
						    listHTML += "<dl class='nodata'>";
		                	listHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
		                	listHTML += '<dd>"' + strLang1_NewBoardSTD + '"</dd>';
		                	listHTML += "</dl>";
		                	
		                	document.getElementById("BoardList").innerHTML = listHTML;
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
		                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                if (CrossYN()) {
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                } else {
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                }
		            }
		        }

		        function openDoc(pItemID) {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;

		            if (pBoardType_NewBoardSTD == "3" || pBoardType_NewBoardSTD == "4") {
		                window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoardSTD, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=770,width=765,top=" + pTop + ",left=" + pLeft, "");
		            } else {
		                if (CrossYN()) {
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoardSTD, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                } else {
		                    window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + pBoardID_NewBoardSTD, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                }
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
		           
		            xmlhttp_getContent_NewBoardSTD.open("GET", "/ezBoard/getItemInfo.do?boardID=" + pBoardID_NewBoardSTD + "&itemID=" + pItemID ,false);
		            xmlhttp_getContent_NewBoardSTD.onreadystatechange = getContent_after;
		            xmlhttp_getContent_NewBoardSTD.send(xmlpara);
		        }

		        function getContent_after() {
		            if (xmlhttp_getContent_NewBoardSTD == null || xmlhttp_getContent_NewBoardSTD.readyState != 4) return;
		          
	                var xmldom = createXmlDom();
	                xmldom = xmlhttp_getContent_NewBoardSTD.responseXML;
	                xmlhttp_getContent_NewBoardSTD = null;
	                var strContentHref = getNodeText(xmldom.getElementsByTagName("ContentLocation").item(0));
	                var tempStr = ConvertMHTtoHTML(strContentHref);
	                
	                var DocContentObject = document.createElement("DIV");
	                DocContentObject.innerHTML = tempStr;
	                var DocContentObject_Div = document.createElement("DIV");
	                DocContentObject_Div.innerHTML = CrossYN() ? DocContentObject.textContent.replace(/<P>/gi, "").replace(/<\/P>/gi, "") : DocContentObject.innerText.replace(/<P>/gi, "").replace(/<\/P>/gi, "");

	                if (DocContentObject_Div.getElementsByTagName("style").length > 0)
	                    DocContentObject_Div.removeChild(DocContentObject_Div.getElementsByTagName("style")[0]);

	                if (CrossYN()) {
	                    DocContentObject.innerHTML = DocContentObject_Div.textContent.replace(/(\r\n)/g, "");
	                } else {
	                    DocContentObject.innerHTML = DocContentObject_Div.innerText.replace(/(\r\n)/g, "");
	                }
	                
	                /* 2018-07-16 홍승비 - 포틀릿 게시판 특수문자 처리 */
	                //DocContentObject.innerHTML = MakeXMLString(DocContentObject.innerHTML);
	                document.getElementById("content").appendChild(DocContentObject);
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
		</script>
	</head>
	<body>
		<div class="layDIV">
            <dl class="portlet_tab" id="BoardTab"></dl>
            <ul class="portlet_list" id="BoardList"></ul>
        </div>
		<!-- 2018-08-21 장진혁 포틀릿 변경으로 주석처리 -->
		<!-- <section  class="body_bg1">
      		<article class="portletbox boardbox ">
      		  <div id="BoardTab" class="title"></div>
        		<div id="BoardList" class="boardcont">
        		</div>
        		<div class="guide"><span class="lb"></span><span class="rb"></span></div>
   		 	</article>
		</section> -->
	</body>
</html>