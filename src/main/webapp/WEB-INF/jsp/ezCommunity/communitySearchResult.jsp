<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>BoardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/community.css')}" />
		<style type="text/css">
        	#tblList td, #tblList td div {
        		white-space: nowrap;
        		text-overflow: ellipsis;
        		overflow: hidden;
        	}
        	 .cmhomelist tr td.boldClass  {
        		font-weight: bold;
        	}
	    	#totalSearch {
	    		 color: white;
	    		 background: black;
	    		 width: 40px;
	    		 height: 25px;
	    		 display: flex;
	    		 justify-content: center;
	    		 align-items: center;
	    	}
	    	#searchElem * {
	    		 margin: 0px 5px;
	    		 display: flex;
	    	}
        </style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    	<script type="text/javascript">
    		var CurPage = "<c:out value='${pageNum}' />";
    		var totalPage = "<c:out value='${totalPage}' />";
    		var totalCount = "<c:out value='${totalCount}' />";
    		var sortType = "";
    		var resList = "<c:out value='${resList}'/>";
    		var pastDate = "<c:out value='${pastDate}'/>";
    		var UserLevel = window.parent.userLevel;
    		var code = window.parent.code;

    		function SelectSingleOnlyTitle(node, tagName) {
    		    var strValue = "";
    		    if (CrossYN()) {
    		        var objNode = node.firstChild;

    		        while (objNode) {
    		            if (objNode.nodeType == 1 && objNode.tagName.toUpperCase() == tagName.toUpperCase()) {
    		                if (objNode.firstChild != null && objNode.firstChild.nodeValue != null) {
    		                    strValue = objNode.firstChild.nodeValue;
    		                }
    		                break;
    		            }
    		            else {
    		                objNode = objNode.nextSibling;
    		            }
    		        }
    		    }
    		    else {
    		        if (node != null)
    		            if (node.selectSingleNode(tagName))
    		                return node.selectSingleNode(tagName).text;
    		    }
    		    return strValue;
    		}
    		
	        function commuTotalSearch() {
	        	var searchWord = document.getElementById("searchWord").value;
	        	
	        	if (searchWord.trim().length < 1) {
	        		alert("<spring:message code='ezCommunity.t504'/>");
	        		return;
	        	}
	        	
	        	document.getElementById("totalSearchForm").submit();
	        }
	        
	        $(function () {

	        	document.getElementById("code").value = code;
    			var xmldoc = loadXMLString('${resList}');
    			var listXML = '';
    			var strSpace = '';
				var strEmergent = '';
				var bClass = '';
				var urgency = "";
				var writeDate = "";
				
				document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;" + "<c:out value='${totalCount}' />";
				document.getElementById("mailBoxInfo").style.color = "#017BEC";
				
    			for (var i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
					strSpace = '';
					strEmergent = '';
					bClass = '';
					urgency = "";
					writeDate = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate");
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Importance") == "1") {
						urgency = "urgency";
					}
					
					for (var j = 1; j < SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel"); j++) {
						strSpace += "&nbsp;&nbsp;";
						
						if (j == SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel") - 1) {
							strSpace += "<img src='/images/i_rep.gif' align='absmiddle'>&nbsp;";
						}
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadFlag") != "0") {
						bClass = "";
					} else {
						bClass = "boldClass";
					}
					
					listXML += "<TR>";
					listXML += "<TD class='"+ urgency + " " + bClass + "' title ='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName") + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName") + "</td>";
					listXML += "<TD title =\"" + Replace2HTML(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title")) + "\" class='"+ urgency + " " + bClass + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\""
						+ SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID").trim()
						+ "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName").trim()
						+ "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim()
						+ "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "READ_FG").trim()
						+"\", event)'>";
					listXML += "<div style='display:flex;align-items:center;'>";
					listXML += "<div style='float: left; overflow: hidden; text-overflow: ellipsis; display: block; max-width: 100%;'>";
                    listXML += strEmergent + strSpace + Replace2HTML(SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "Title"));
                    listXML += "</div>";
                    
					if (SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "OneLineCnt") > 0) {
                    	listXML += "<SPAN class ='" + bClass + "' style='color:#c64200;padding-left:1px;'>[" + SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "OneLineCnt") + "]<SPAN>";
                    }
					if (pastDate <= writeDate) {
						listXML += "<span class='board_new' style='vertical-align:middle'></span>";
					}
                   	listXML += "</div></TD>";
					listXML += "<TD class='"+ urgency + " " + bClass + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() + "</TD>";
                    listXML += "<TD class='"+ urgency + " " + bClass + "'><div style='cursor:pointer' onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptID").trim() + "\")'>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim()) + "</div></TD>";
					listXML += "<TD class='"+ urgency + " " + bClass + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</TD>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						var fileExt = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "EXT").trim();
						var filePath = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "FILEPATH").trim();
						var readFg = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "READ_FG").trim();
						var itemID = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim();
						var downURL = "/ezCommunity/getCommunityAttachInfo.do?fileName=" + javaURLEncode(fileExt) + "&filePath=" + javaURLEncode(filePath);
						var BoardID = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID").trim();
						var imgTag = "";
			           	if (fileExt.indexOf("MANY") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/disk.svg' onclick='selectToDownloadFiles(\""+ readFg + "\", \"" + BoardID + "\", \"" + itemID +"\")'>";
                    	} else if (fileExt.indexOf(".jpg") != -1 || fileExt.indexOf(".jpeg") != -1 || fileExt.indexOf(".bmp") != -1 || fileExt.indexOf(".gif") != -1 || fileExt.indexOf(".png") != -1 || fileExt.indexOf(".tif") != -1 || fileExt.indexOf(".tiff") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/image.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
                    	} else if (fileExt.indexOf(".doc") != -1 || fileExt.indexOf(".docx") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/doc.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
                    	} else if (fileExt.indexOf(".xls") != -1 || fileExt.indexOf(".xlsx") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/xls.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
                		} else if (fileExt.indexOf(".ppt") != -1 || fileExt.indexOf(".pptx") != -1 || fileExt.indexOf(".pps") != -1 || fileExt.indexOf(".ppsx") != -1) {
                			imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/ppt.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
            			} else if (fileExt.indexOf(".txt") != -1) {
            				imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/txt.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
        				} else if (fileExt.indexOf(".zip") != -1) {
        					imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/zip.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
    					}else if (fileExt.indexOf(".pdf") != -1) {
    						imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/pdf.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
						} else if (fileExt.indexOf(".hwp") != -1 || fileExt.indexOf(".hwpx") != -1) {
							imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/hwp.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
						} else if (fileExt.indexOf(".ecm") != -1) {
							imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/ecm.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
						} else {
							imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/etc.svg' onclick='downloadBoardFile(\""+ readFg + "\", \"" + downURL + "\")'>";
						}

						listXML += "<TD class='"+ urgency + "'>" + imgTag +"</TD>";
					} else {
						listXML += "<TD class='"+ urgency + "'></TD>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") == ""){
						listXML += "<TD class='"+ urgency + " " + bClass + "' align=center>0</TD>";
					} else {
						listXML += "<TD class='"+ urgency + " " + bClass + "' align=center>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") + "</TD>";
					}
					
					listXML += "</TR>";
					
    			}
    			
    			$('#tblList tbody:first').append(listXML);
    			makePageSelPage();
    		});
	        
            var BlockSize = 10;
            
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                $("#tblPageRayer").html("");
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
            
            function td_Create1(strtext) {
                $("#tblPageRayer").html(strtext);
            }
            
    		function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, Read_FG, evt) {
   				<%--if (Read_FG != "true") {--%>
    			<%--	alert("<spring:message code='ezCommunity.t431' />");--%>
    			<%--	return;--%>
    			<%--}--%>
   				
   				var bTarget = evt.currentTarget.parentNode;
   		         if (bTarget.childNodes[1].classList.contains("boldClass")) {
   		            for (var i = 0; i < bTarget.childNodes.length; i++) {
   		            	bTarget.childNodes[i].classList.remove("boldClass");
   		            }
   		        }

    		    var TreeCtrl0obj = window.parent.document.getElementById("TreeCtrl0obj").querySelectorAll('div[data1]');
    		    var treeCtrl = "";
    		    
    		    TreeCtrl0obj.forEach(function(node) {
    		        if (node.getAttribute('data1') == pItemBoardID) {
    		        	treeCtrl = node.id;
    		        }
    		    });
    		    
    		    GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(code) + "&showAdjacent=&treeCtrl=" + treeCtrl, "", 750, 721);
    		}
			
    		function MemberInfo_onclick(pUserID, pDeptID) {
    			if (UserLevel == "0" || UserLevel == "9") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
    					
    		    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 450);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
			}
    		
    		function SortPage(SortBy) {
    			document.getElementById("sortBy").value = SortBy;
				commuTotalSearch();
    		}
    		
            function goToPageByNum(Value){
                CurPage = Value;
                makePageSelPage();
    			movePage(CurPage);
            }
            
            function movePage(newPage) {	
    		    if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage))  {
        			document.getElementById("pageNum").value = newPage;
    				commuTotalSearch();
    		    }
    		}
            
            function downloadBoardFile(Read_FG, downURL) {
            	
                <%--if (Read_FG != "true") {--%>
                <%--	alert("<spring:message code='ezCommunity.t431' />");--%>
                <%--    return;--%>
                <%--}--%>
                
            	window.location = downURL;
            }
            
            function selectToDownloadFiles(Read_FG, boardID, itemID) {
            	
            	<%--if (Read_FG != "true") {--%>
            	<%--	alert("<spring:message code='ezCommunity.t431' />");--%>
            	<%--	return;--%>
            	<%--}--%>
                
            	var url = "/ezCommunity/selectToDownloadFiles.do?itemID=" + javaURLEncode(itemID) + "&boardID=" + javaURLEncode(boardID) + "&code=" + encodeURIComponent(code);
                window.open(url, "", "status=no,help=no,width=580px,height=480px" + GetOpenPosition(580, 480));
            }
    	</script>    
        
	</head>
	<body class = "cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezTotalSearch.t0028' /></h1>
		<hr/>
		
		<div style = "height:30px;">
			'<strong><c:out value='${searchWord}'/></strong>'<spring:message code='ezTotalSearch.t0020' /> <strong id="mailBoxInfo"></strong> <spring:message code='ezTotalSearch.t0021' />
		</div>
		<div id="searchElem" style="height:40px; background-color: #f8f8fa; margin-bottom: 10px; display: flex; align-items: center;">
			<form id="totalSearchForm" method="post" target="rightfrm" action="/ezCommunity/communitySearchResult.do">
				<c:forEach var="type" items="${beforeSearchType}">
					<input type="hidden" name="beforeSearchType" value="<c:out value='${type }'/>">
				</c:forEach>
				<c:forEach var="keyword" items="${beforeKeyword}">
					<input type="hidden" name="beforeKeyword" value="<c:out value='${keyword }'/>">
				</c:forEach>
				<label for="refineInResult"><input type="checkbox" <c:out value='${refineInResult}'/> name="refineInResult" id="refineInResult"><spring:message code='ezCommunity.searchInResult' /></label>
				<select name="searchType">
					<option value="title"<c:if test="${searchType eq 'title'}">selected</c:if>><spring:message code='ezCommunity.t124' /></option>
					<option value="writer"<c:if test="${searchType eq 'writer'}">selected</c:if>><spring:message code='ezCommunity.t445' /></option>
				</select>
				<input type="text" id="searchWord" name="searchWord" value="<c:out value='${searchWord}'/>">
			    <span id="totalSearch" onclick="commuTotalSearch()">
			    	<spring:message code='ezCommunity.t31'/>
			    </span>
				<input type="hidden" id="sortBy" name="sortBy" value="<c:out value='${pSortBy }'/>">
				<input type="hidden" id="code" name="code">
				<input type="hidden" id="pageNum" name="pageNum" value="<c:out value='${pageNum}' />">
			</form>
		</div>
		
		<div style = "height:370px;">
			<table  id="tblList" class="cmhomelist" style="width:100%">
				<tr>
					<c:choose>
						<c:when test="${pSortBy == 'BoardName'}">
							<th style="cursor:pointer" width="150" onClick="SortPage('BoardName desc')" ><spring:message code='ezCommunity.t418' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'BoardName desc'}">
							<th style="cursor:pointer" width="150" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer" width="150" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418' /></th>
						</c:otherwise>
					</c:choose>
					
					<c:choose>
						<c:when test="${pSortBy == 'A.Title'}">
							<th style="cursor:pointer"  onClick="SortPage('A.Title desc')" width="60%"><spring:message code='ezCommunity.t124' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.Title desc'}">
							<th style="cursor:pointer"  onClick="SortPage('A.Title')" width="60%"><spring:message code='ezCommunity.t124' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  onClick="SortPage('A.Title')" width="60%"><spring:message code='ezCommunity.t124' /></th>
						</c:otherwise>
					</c:choose>
					
					<c:choose>
						<c:when test="${pSortBy == 'A.WriterDeptName'}">
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriterDeptName desc')"><spring:message code='ezCommunity.t241' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.WriterDeptName desc'}">
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241' /></th>
						</c:otherwise>
					</c:choose>

					<c:choose>
						<c:when test="${pSortBy == 'A.WriterName'}">
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriterName desc')"><spring:message code='ezCommunity.t445' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.WriterName desc'}">
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445' /></th>
						</c:otherwise>
					</c:choose>
					
					<c:choose>
						<c:when test="${pSortBy == 'A.WriteDate'}">
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriteDate desc')"><spring:message code='ezCommunity.t209' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.WriteDate desc'}">
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriteDate')"><spring:message code='ezCommunity.t209' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="120" onClick="SortPage('A.WriteDate')"><spring:message code='ezCommunity.t209' /></th>
						</c:otherwise>
					</c:choose>
					
					<c:choose>
						<c:when test="${pSortBy == 'A.Attachments'}">
							<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments desc')"><img src="/images/file.gif"><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.Attachments desc'}">
							<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments')"><img src="/images/file.gif"><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments')"><img src="/images/file.gif"></th>
						</c:otherwise>
					</c:choose>
					
					<c:choose>
						<c:when test="${pSortBy == 'A.ReadCount'}">
							<th style="cursor:pointer"  width="50" onClick="SortPage('A.ReadCount desc')"><spring:message code='ezCommunity.t173' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.ReadCount desc'}">
							<th style="cursor:pointer"  width="50" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="50" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173' /></th>
						</c:otherwise>
					</c:choose>
				</tr>
				<c:set var="count" value="${totalCount}" />
				    <c:if test="${count eq 0 }" >
					    <tr>
						    <td align="center" colspan="7"><spring:message code='ezBoard.t281'/></td>
					    </tr>
				    </c:if>
			</table>
		</div>	
		<div id="tblPageRayer" style="margin-top:10px"></div>
		<FONT face="<spring:message code='ezCommunity.t154' />"></FONT>	
	</body>
</html>