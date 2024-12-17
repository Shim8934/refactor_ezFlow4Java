<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>boardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<style type="text/css">
	        .photo_tit {
	            font-size: 9pt;
	            color: #333333;
	            width:132px;
	            padding-left:4.5px;
	            padding-bottom:2px;
	            white-space: nowrap;
    			overflow: hidden;
    			text-overflow: ellipsis;
    			display:inline-block;            
	        }
	        .photo_name {
	            font-size: 9pt;
	            color: #00539b;
	        }
	        .photo_num {
	            font-size: 9pt;
	            font-weight: bold;
	            color: #639933;
	        }
	    </style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
    	<script type="text/javascript">
	    	var pBoardID = "<c:out value = '${boardInfo.boardID}' />";
	        var pBoardName = "<c:out value = '${multiBoardName}' />";
	        var SSUserID = "<c:out value = '${userInfo.id}' />";
	//        var SSUserName = "<c:out value = '${userInfo.displayName1}' />";
	        var CurPage = "<c:out value = '${page}' />";
	        var totalPage = "<c:out value = '${totalPage}' />";
	        var totalCount = "<c:out value = '${totalCount}' />";
	        var strListInfo = "";
	        var Access_FG = "<c:out value = '${boardInfo.access_FG}' />";
			var BoardAdmin_FG = "<c:out value = '${boardInfo.boardAdmin_FG}' />";
	        var ListView_FG = "<c:out value = '${boardInfo.listView_FG}' />";
	        var Read_FG = "<c:out value = '${boardInfo.read_FG}' />";
	        var Write_FG = "<c:out value = '${boardInfo.write_FG}' />";
	        var Reply_FG = "<c:out value = '${boardInfo.reply_FG}' />";
	        var Delete_FG = "<c:out value = '${boardInfo.delete_FG}' />";
	        var BoardGroupAdmin_FG = "<c:out value = '${boardInfo.boardGroupAdmin_FG}' />";
	        var pSortBy = "<c:out value = '${pSortBy}' />";
	        var url = "<c:out value = '${url}' />";
	        var ShowAdjacent = "<c:out value = '${showAdjacent}' />";
	        var gubun = "<c:out value = '${ boardInfo.gubun }' />";
	        var UserLevel = "<c:out value = '${userLevel}' />";
	        var pUse_Editor = "<c:out value = '${useEditor}' />";
	        var pastDate = "<c:out value = '${pastDate}' />";
	        
	        $(function () {
    			var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			var cnt = SelectNodes(xmldoc, "NODES/NODE").length;
    			var rows = cnt / 4;
    			
    			if (cnt % 4 > 0) {
    				rows = rows + 1;
    			}
    			
    			for (var i = 0; i < rows; i++) {
    				listXML += "<tr style='padding-bottom:10px'>";
    				for (var j = 0; j < 4; j++) {
    					idx = (i * 4) + j;

    					if (j ==3) {
    						listXML += "<td valign='top' nowrap align='left' width='100%'>";
    					} else {
    						listXML += "<td valign='top' nowrap align='left'>";
    					}
    					
    					if (idx < cnt) {
    						listXML += "<table width='146px' border='0' cellspacing='0' cellpadding='0' style='margin-right:10px'>";
    						listXML += "<tr>";
    						var fileName = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "EXTENSIONATTRIBUTE4").trim();
    						var imgUrl = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "EXTENSIONATTRIBUTE5").trim();
                            listXML += "<td width='146px' height='116px' align='center' background='/images/photo_bg.gif'><img style='cursor:pointer;width:100px;height:100px;' src='/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYBOARD&boardID=" + encodeURIComponent(pBoardID) + "&imgUrl=" + encodeURIComponent(imgUrl) + "&fileName=" + encodeURIComponent(fileName) + "' onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriterID").trim() + "\", event)'></td>";                       
                            listXML += "</tr></table>";
                            listXML += "<table width='146px' border='0' cellpadding='1' cellspacing='1' style='margin-top:5px'>";
                            listXML += "<tr><td class='photo_tit' style='cursor:pointer;'  onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriterID").trim() + "\", event)'>";
                            
                            var title = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "Title").trim());
                            var oneLineCnt = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "ONELINECNT");
                            var writeDate = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriteDate");
                            
                            /* 2018-05-18 홍승비 - 커뮤니티 포토게시판 리스트에서 new 표시 */
                            if (pastDate <= writeDate) {
                            	listXML += "<img src='/images/new_icon.gif'>&nbsp;";
		 					}
                            listXML += title;
                            
                            /* 2018-05-07 홍승비 - 댓글 표시하기 */ 
                            if (oneLineCnt > 0) {
                            	listXML+="<SPAN style='color:#c64200'> [" + oneLineCnt + "]</SPAN>";
                            }
                            
                            listXML += "</td>";
                            listXML += "<tr><td style='padding-left:5px'><span class='photo_name' style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; max-width:146px; display: inline-block;'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriterName").trim() + " / " + writeDate.split(' ')[0] + "</span>";
                            listXML += "</td></tr></table>";
    					}
    					listXML += "</td>";
    				}
    				listXML += "</tr>";
    			}
    			
    			if (cnt == 0) {
    				listXML += "<tr><td align='center'>";
    				listXML += "<spring:message code = 'ezCommunity.t926' />";
    				listXML += "</td></tr>";
    			}
    			
    			$('#tblList').append(listXML);
    			
    			makePageSelPage();
    		});
	        
	        document.onselectstart = function () {
			    window.event.cancelBubble = true;
			    window.event.returnValue = false;
			}
	        
	        if (url != "") {
	        	window.location.href = url;
	        }
	        
	    	function NewItem_onclick() {
	            if (UserLevel == "0" || UserLevel == "9" || Write_FG != "true") {
					alert("<spring:message code = 'ezCommunity.t431' />");
	               	return;
	           	}
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;
	
              	window.open("/ezCommunity/newBoardItemPhoto.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	        }
	
			function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
	            if (UserLevel == "0" || UserLevel == "9" || Read_FG != "true") {
	            	alert("<spring:message code = 'ezCommunity.t431' />");
	                return;
	           	}
	           	
	            if (CrossYN()) {
	                var e = evt.target;
	            } else {
	                var e = event.srcElement;
	            }
	            
	            var eText = e.outerHTML;
	            
	            if (eText.substring(0, 3) == "<B>") {
	                e.outerHTML = eText.substring(3, eText.length);
	            }
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 683) / 2;
	            var pLeft = (pwidth - 750) / 2;
	            
	          	window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=721,width=750,top=" + pTop + ",left=" + pLeft, "");
	        }

	        function refresh_onclick() {
	        	if ($('#tblList tbody tr').children().length == '11' && CurPage != '1') {
	        		newPage = parseInt(CurPage) - 1;
		            
	        		if (newPage == 0) {
	        			newPage = 1;
	        		} else if (newPage > 0) {
		                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + newPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
					}
	        	} else {
		            window.location.reload(false);        		
	        	}
	        }
	        
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	        
	        var BlockSize = 10;
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
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
	                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + parseInt(newPage) + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
				}
	        }
	        
	  		 /* 2018-05-11 홍승비 - 커뮤니티 포토게시판 사용하지 않는 코드 정리 */        
    	</script>
	</head>
	<body class="cmhome_body" style="overflow-x:hidden">
	    <h1 class="type1_h1"><c:out value='${multiBoardName}'/><span id="mailBoxInfo"></span></h1>
	    
	    <div id = "mainmenu">
	    	<c:if test="${boardInfo.boardID !=  '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
	    		<ul>
	        		<li><span onclick="NewItem_onclick()"><spring:message code = 'ezCommunity.t923' /></span></li>
		            <li style="display: none"><span onclick="DeleteItem_onclick()"><spring:message code = 'ezCommunity.t208' /></span></li>
	        </c:if>

            		<li><span onclick="refresh_onclick()"><spring:message code = 'ezCommunity.t912' /></span></li>  
            	</ul>
	    </div>

		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div style="height:465px;">
	    	<table id="tblList">
	    	</table>
	    </div>
	    <div style="width: 615px; padding-top: 10px" id="tblPageRayer"></div>
	    <div id="ListInfo" style="DISPLAY: none">${listInfo}</div>
	</body>
</html>