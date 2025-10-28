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
        </style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    	<script type="text/javascript">
    		var pBoardID = '<c:out value="${boardInfo.boardID}" />';
    		var pBoardName = "<c:out value='${pBoardName}' />";
    		var SSUserID = "<c:out value='${userInfo.id}' />";
    		var SSUserName = "<c:out value='${userInfo.displayName1}' />";
    		var CurPage = "<c:out value='${pPage}' />";
    		var totalPage = "<c:out value='${totalPage}' />";
    		var totalCount = "<c:out value='${totalCount}' />";
    		var strListInfo = "";
    		var	Access_FG = "<c:out value='${boardInfo.access_FG}' />";
    		var	BoardAdmin_FG = "<c:out value='${boardInfo.boardAdmin_FG}' />";
    		var	ListView_FG = "<c:out value='${boardInfo.listView_FG}' />";
    		var	Read_FG = "<c:out value='${boardInfo.read_FG}' />";
    		var	Write_FG = "<c:out value='${boardInfo.write_FG}' />";
    		var	Reply_FG = "<c:out value='${boardInfo.reply_FG}' />";
    		var	Delete_FG = "<c:out value='${boardInfo.delete_FG}' />";
    		var BoardGroupAdmin_FG = "<c:out value='${boardInfo.boardGroupAdmin_FG}' />";
    		var pSortBy = "<c:out value='${pSortBy}' />";
    		var url = "<c:out value='${url}' />";
    		var ShowAdjacent = "<c:out value='${showAdjacent}' />";
    		var gubun = "<c:out value='${boardInfo.gubun}' />";
    		var UserLevel = "<c:out value='${userLevel}' />";
    		var code = "<c:out value='${code}' />";
    		var ListInfo = "";
    		var pastDate = "<c:out value='${pastDate}' />";
    		//2018-07-13 김보미
    		var treeCtrl = "<c:out value='${treeCtrl}' />";
    		var inviteFlag = "<c:out value='${inviteFlag}' />";

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
				//2018-07-03 김보미 - 제목 특수문자처리 버그 수정 
     		    //return strValue.replace(/&/g,"&amp;");
    		    return strValue;
    		}
    		
    		$(function () {
    			var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			var strSpace = '';
				var strEmergent = '';
				var bClass = '';
				var urgency = "";
				var writeDate = "";
				
    			for (var i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
					strSpace = '';
					strEmergent = '';
					bClass = '';
					urgency = "";
					writeDate = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate");
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Importance") == "1") {
						//strEmergent = "<img src='/images/i_urgency.gif'>&nbsp;";
						urgency = "urgency";
					}
					
					for (var j = 1; j < SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel"); j++) {
						strSpace += "&nbsp;&nbsp;";
						if (j == SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel") - 1) {
							strSpace += "<img src='/images/i_rep.gif' align='absmiddle'>&nbsp;";
						}
					}
					
					/* 2018-07-10 홍승비 - bTag를 font-weight:bold 스타일이 포함된 클래스로 수정 */
					if (pBoardID != "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
						if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadFlag") != "0") {
							bClass = "";
						} else {
							bClass = "boldClass";
						}
					} else {
						bClass = "boldClass";
					}
					
					listXML += "<TR>";
					listXML += "<TD align=center><div class='custom_checkbox'><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID") + "\" , event)'></div></td>";
					
					if (pBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
                        listXML += "<TD class='"+ urgency + " " + bClass + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName") + "</TD>";
                        listXML += "<TD class='"+ urgency + " " + bClass + "' title='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`") + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\""
                        	+ SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "boardName") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\", \""
                        	+ SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID") + "\", event)'>";
						listXML += "<div style='display:flex;align-items:center;'>";
						listXML += "<div style='float: left; overflow: hidden; text-overflow: ellipsis; display: block; max-width: 100%;'>";
                       	listXML += strEmergent + strSpace + SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "Title");
                       	listXML += "</div>";
                       	
                       	/* 2018-05-04 홍승비 - 댓글 표시하기, 2020-03-16 홍승비 - 댓글 영역 표출 스타일 수정 */
                       	if(SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "OneLineCnt") > 0) {
                       		listXML += "<SPAN class= '" + bClass + "' style='color:#c64200;padding-left:1px;'>[" + SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "OneLineCnt") + "]<SPAN>";
                       	}
						/*  2018-05-18 홍승비 - 커뮤니티 일반/그룹/익명게시판 리스트에서 new 표시하기 */
						if (pastDate <= writeDate) {
							listXML += "<span class='board_new'></span>";
						}
                        listXML += "</div></TD><TD></TD>";
					}
					else {
						listXML += "<TD class='"+ urgency + " " + bClass + "' title='" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`")) + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\""
							+ pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Writer") + "\", event)'>";
						listXML += "<div style='display:flex;align-items:center;'>";
						listXML += "<div style='float: left; overflow: hidden; text-overflow: ellipsis; display: block; max-width: 100%;'>";
	                    listXML += strEmergent + strSpace + Replace2HTML(SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "Title"));
                       	listXML += "</div>";
	                    
						if(SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "OneLineCnt") > 0) {
                       		listXML += "<SPAN class ='" + bClass + "' style='color:#c64200;padding-left:1px;'>[" + SelectSingleOnlyTitle(SelectNodes(xmldoc,"NODES/NODE")[i], "OneLineCnt") + "]</SPAN>";
                       	}
						if (pastDate <= writeDate) {
							listXML += "<span class='board_new'></span>";
						}
                    	listXML += "</div></TD><TD></TD>";
					}				
					
					if (gubun == '1') {
						listXML += "<TD class='"+ urgency + " " + bClass + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterCompanyName").trim() + "</TD>";
					}
					
					if (gubun != '2') {
						listXML += "<TD class='"+ urgency + " " + bClass + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() + "</TD>";
                        listXML += "<TD class='"+ urgency + " " + bClass + "'><div style='cursor:pointer' onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptID").trim() + "\")'>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim()) + "</div></TD>";
					} else {
                        listXML += "<TD class='"+ urgency + " " + bClass + "'><div onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptID").trim() + "\")'>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim()) + "</div></TD>";
					}
					
					listXML += "<TD class='"+ urgency + " " + bClass + "'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</TD>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						var fileExt = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "EXT").trim();
						var filePath = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "FILEPATH").trim();
						var itemID = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim();
						var downURL = "/ezCommunity/getCommunityAttachInfo.do?fileName=" + javaURLEncode(fileExt) + "&filePath=" + javaURLEncode(filePath);
						var imgTag = "";
			           	if (fileExt.indexOf("MANY") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/disk.svg' onclick='selectToDownloadFiles(\""+ itemID +"\")'>";
                    	} else if (fileExt.indexOf(".jpg") != -1 || fileExt.indexOf(".jpeg") != -1 || fileExt.indexOf(".bmp") != -1 || fileExt.indexOf(".gif") != -1 || fileExt.indexOf(".png") != -1 || fileExt.indexOf(".tif") != -1 || fileExt.indexOf(".tiff") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/image.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
                    	} else if (fileExt.indexOf(".doc") != -1 || fileExt.indexOf(".docx") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/doc.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
                    	} else if (fileExt.indexOf(".xls") != -1 || fileExt.indexOf(".xlsx") != -1) {
                    		imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/xls.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
                		} else if (fileExt.indexOf(".ppt") != -1 || fileExt.indexOf(".pptx") != -1 || fileExt.indexOf(".pps") != -1 || fileExt.indexOf(".ppsx") != -1) {
                			imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/ppt.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
            			} else if (fileExt.indexOf(".txt") != -1) {
            				imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/txt.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
        				} else if (fileExt.indexOf(".zip") != -1) {
        					imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/zip.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
    					}else if (fileExt.indexOf(".pdf") != -1) {
    						imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/pdf.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
						} else if (fileExt.indexOf(".hwp") != -1 || fileExt.indexOf(".hwpx") != -1) {
							imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/hwp.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
						} else if (fileExt.indexOf(".ecm") != -1) {
							imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/ecm.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
						} else {
							imgTag = "<img style='cursor: pointer;width:20px; height:20px; vertical-align:middle;' src='/images/etc.svg' onclick='downloadBoardFile(\"" + downURL + "\")'>";
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
					
					ListInfo += SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + ";";
    			}
    			
    			$('#tblList tbody:first').append(listXML);
    			makePageSelPage();
    		});
    		
    		document.onselectstart = function () {
    		    window.event.cancelBubble = true;
    		    window.event.returnValue = false;
    		};
    		
    		if (url != "") { 
				window.location.href = url;
    		}
    		
    		function NewItem_onclick() {
    			if (Write_FG != "true") {
				    alert("<spring:message code='ezCommunity.t431' />");
				    return;
				}
				
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 765) / 2;
				
				window.open("/ezCommunity/newBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new", "", GetOpenWindowfeature(720, 765));
			    
			}
    		 
    		function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
   				if (Read_FG != "true") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
   				
   				var bTarget = evt.currentTarget.parentNode;
   		         if (bTarget.childNodes[1].classList.contains("boldClass")) {
   		            for (var i = 0; i < bTarget.childNodes.length; i++) {
   		            	bTarget.childNodes[i].classList.remove("boldClass");
   		            }
   		        }

    		    /* var pheight = window.screen.availHeight;
    		    var pwidth = window.screen.availWidth;
    		    var pTop = (pheight - 720) / 2;
    		    var pLeft = (pwidth - 765) / 2; */
    		    //2018-07-13 김보미 - 파라메터 추가
//     		    GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(code) + "&showAdjacent=" + ShowAdjacent, "", 750, 721);
    		    GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(code) + "&showAdjacent=" + ShowAdjacent + "&treeCtrl=" + treeCtrl + "&inviteFlag=" + inviteFlag, "", 750, 721);
    		}
    		
    		function checkBox_checked(pItemID, pUserID, evt) {
	            if (evt.currentTarget.checked) {
	                strListInfo += pItemID + "," + pUserID + ";";
	            } else {
	                strListInfo = ReplaceText(strListInfo, pItemID + "," + pUserID + ";", "");
	            }
		    }
    		
    		function checkBox_checkAll() {
    			var i=0;
    			
    			for(i=0;i<$("input[name='chk']").length;i++) {
    				if($("input[name='chk']")[i].type == 'checkbox') {
    					if($("input[name='checkbox']")[0].checked) {
    					$("input[name='chk']")[i].checked = true;
                            strListInfo = ListInfo;
                        } else {
                        	$("input[name='chk']")[i].checked = false;
    						strListInfo = "";
    					}				
    				}
    			}
    		}
    		
    		var checkpassword_dialogArguments = new Array();
    		
    		function DeleteItem_onclick() {
    			if (Delete_FG != "true" && CheckOwnerShip() == false && gubun != "2") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
    					
    			if (strListInfo == "") {
    				alert("<spring:message code='ezCommunity.t424' />");
    				return;
    			}
    			
    			if (gubun == "2") {
    				arrList = strListInfo.split(";");
    				
    				if (arrList.length > 2)  {
    					alert("<spring:message code='ezCommunity.lhj01' />");
    					return;
    				}
    			}
    			
    			if (CheckIfHasReplies()) {
    		        alert("<spring:message code='ezCommunity.t425' />");
                    return;
                }
    			
    		    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false && Delete_FG != "true") {
    		        if (gubun == "2") {
    		            var pItemInfo = strListInfo.split(";")[0];
    		            var pItemID = pItemInfo.split(",")[0];

    		            if (pItemID != "") {
   		                    checkpassword_dialogArguments[1] = DeleteItem_onclick_Complete;
   		                    var OpenWin = window.open("/ezCommunity/checkPassword.do?itemID=" + encodeURIComponent(pItemID), "checkPassword", GetOpenWindowfeature(470, 200));
   		                    
   		                    try {
   		                    	OpenWin.focus();
   		                    	
   		                    } catch (e) {
   		                    	
   		                    }
    		            }
    		        } else {
    		            alert("<spring:message code='ezCommunity.t431' />");
    		            return;
    		        }
    		    } else {
					var ret = confirm("<spring:message code='ezCommunity.t426' />");
					if (ret) {
						DeleteItem();
					}
    		    }
    		}
    		
    		function DeleteItem_onclick_Complete(ret) {
		        if (typeof (ret) == "undefined") {
		            alert("<spring:message code='ezCommunity.t431' />");
		            return;
		        }

		        if (ret != "OK" && ret == "FALSE") {
                    alert("<spring:message code = 'ezCommunity.t921' />");
                    return;
                } else if (ret == "cancel") {
	            	alert("<spring:message code='ezCommunity.t60'/>");
	                return;
	            }

		        if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezCommunity.t425' />");
		            return;
		        }

		        var ret = confirm("<spring:message code='ezCommunity.t426' />");
		        
		        if (ret) {
		        	DeleteItem();
		        }
		    }
    		
    		function CheckIfHasReplies() {
    		    var xmlhttp = createXMLHttpRequest();
    			xmlhttp.open("GET", "/ezCommunity/checkIfHasReply.do?itemList=" + encodeURIComponent(strListInfo), false);
    			xmlhttp.send();
    			
    			if(xmlhttp.responseText == "TRUE") {
    				xmlhttp = null;	
    				return true;
    			} else {
    				xmlhttp = null;
        			return false;
    			}
    		}

    		function DeleteItem() {
    			$.ajax({
    				type : "POST",
    				async : false,
    				url : "/ezCommunity/deleteItem.do",
    				data : {itemList : strListInfo}
    			});

				// 게시물 리스트에서 게시물 삭제 시 팝업홈 좌측 전체 카운트 새로고침 추가
				if (window.location.href.indexOf("ezCommunity/boardItemList.do") > -1  || window.location.href.indexOf("ezCommunity/searchBoardItem.do") > -1) {
					try {
						var cntDom = window.parent.document.getElementById("itemcnt");
						var code = window.parent.code;
						if (typeof(cntDom) != "undefined" && cntDom != null && typeof(code) != "undefined" && code != null) {
							reloadLeftCount(code, cntDom);
						}
					} catch(e) {}
				}
    			refresh_onclick();
    			
    			/* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
				if (window.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.parent.applyIsNewIconAll) == "function") {
					window.parent.applyIsNewIconAll();
				}
    		}

    		function ReplaceText( orgStr, findStr, replaceStr ) {
    			var re = new RegExp( findStr, "gi" );
    			return ( orgStr.replace( re, replaceStr ) );
    		}

    		function CheckOwnerShip() {
    			var arrList = new Array();
    			var i=0;
    			arrList = strListInfo.split(";");
    			
    			for(i=0;i<arrList.length-1;i++)  {
    				if(arrList[i].split(",")[1] != SSUserID) {
    					arrList = null;	
    					return false;
    				}		
    			}
    			
    			arrList = null;	
    			return true;
    		}

    		function refresh_onclick() {
				if ($('#tblList tbody').children().length == '2') {
					newPage = CurPage - 1;
					
					if (newPage == 0) newPage = 1;
					
					if (newPage > 0) {
		    			window.location.href = "/ezCommunity/boardItemList.do?page=" + newPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + pSortBy + "&code=" + code + "&inviteFlag=" + inviteFlag;
					}
				} else if ($('#tblList tbody').children().length == strListInfo.split(";").length) {
	    			newPage = CurPage - 1;    			
	    			
	    			if (newPage == 0) newPage = 1;
					
	    			if (newPage > 0) {
		    			window.location.href = "/ezCommunity/boardItemList.do?page=" + newPage + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + pSortBy + "&code=" + code + "&inviteFlag=" + inviteFlag;
					}
    			} else {
    				window.location.reload(false);
    			}
    		}

            function td_Create1(strtext) {
                $("#tblPageRayer").html(strtext);
            }
            
            var BlockSize = 10;
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                $("#tblPageRayer").html("");
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
            
            function goToPageByNum(Value){
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
                
                if( parseInt(pageNum + 1) <= totalPage) {
                    goToPageByNum(parseInt(pageNum + 1));
                } else {
                    return;
                }
            }
            
            function movePage(newPage) {	
    		    if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage))  {
    			    window.location.href = "/ezCommunity/boardItemList.do?page=" + parseInt(newPage) + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + pSortBy + "&code=" + code;
    		    }
    		}

    		function moveToPage() {
    			if(window.event.keyCode == 13) {
    				var newPage = txt_PageInputNum.value;
    				
    				if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage))  {
    					window.location.href = "/ezCommunity/boardItemList.do?page=" + parseInt(newPage) + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + pSortBy + "&code=" + code;
    				}
    			}
    		}

    		function SortPage(SortBy) {
    			window.location.href = "/ezCommunity/boardItemList.do?page=" + CurPage + "&boardID=" + encodeURIComponent(pBoardID) + "&pBoardName=" + pBoardName + "&sortBy=" + SortBy + "&code=" + code;
    		}

    		function CopyItem_onclick() {
    			if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
    					
    			if(strListInfo == "") {
    				alert("<spring:message code='ezCommunity.t430' />");
    				return;
    			}

    			var arrList = new Array();
    			var strItemList = "";
    			var i=0;

    			arrList = strListInfo.split(";");
    			
    			for(i=0;i<arrList.length-1;i++) {
    				strItemList += arrList[i].split(",")[0] + ";";
    			}
    			
    			arrList = null;		
    			
    			var wWeight = "355";
    			var wHeight = "600";

    			var heigth = window.screen.availHeight;
    			var width = window.screen.availWidth;

    			var left = (width - wWeight) / 2;
    			var top = (heigth - wHeight) / 2;
    			//2018-07-13 김보미 - 파라메터 추가    			
//     			window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + encodeURIComponent(code), "", "height=600,width=355, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + top + ",left = " + left, "");
    			window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + encodeURIComponent(code) + "&treeCtrl=" + treeCtrl, "", "height=600,width=355, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + top + ",left = " + left, "");
    		}
    		
    		function SetRead_onclick() {
    			if (Read_FG != "true") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}

    			if(strListInfo == "") {
    				alert("<spring:message code='ezCommunity.t427' />");
    				return;
    			}
    			
    			var ret = confirm("<spring:message code='ezCommunity.t428' />");
    			
    			if(ret)	{
    				var arrList = new Array();
    				var strItemList = "";
    				var i=0;

    				arrList = strListInfo.split(";");
    				
    				for(i=0;i<arrList.length-1;i++) {
    					strItemList += arrList[i].split(",")[0] + ";";
    				}
    				
    				arrList = null;
    				
    				$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommunity/setRead.do",
						data : { boardID	:	pBoardID, 
								 itemIDList	:	strItemList
						}
					});
    				
    				refresh_onclick();
    				
        			/* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
    				if (window.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.parent.applyIsNewIconAll) == "function") {
    					window.parent.applyIsNewIconAll();
    				}
    			}
    		}

    		/* 2018-10-02 홍승비 - 커뮤니티 게시물 리스트 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
			function MemberInfo_onclick(pUserID, pDeptID) {
    			if (UserLevel == "0" || UserLevel == "9") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
    					
    		    if (gubun == "2") {
    		    	return;
    		    }
    		    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 450);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
			}

    		function ReservationItem_onclick() {
    			if (Read_FG != "true") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
    			
    			window.location.href = "/ezCommunity/boardReservedItemList.do?page=" + encodeURIComponent(CurPage) + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + encodeURIComponent(pSortBy) + "&code=" + encodeURIComponent(code);
    		}

    		function search_onclick() {
    			if (Read_FG != "true") {
    				alert("<spring:message code='ezCommunity.t431' />");
    				return;
    			}
    					
    			var OrgBoardParameters = "page=" + encodeURIComponent(CurPage) + "&boardID=" + encodeURIComponent(pBoardID) + "&sortBy=" + encodeURIComponent(pSortBy) + "&code=" + encodeURIComponent(code);
    			window.location.href = "/ezCommunity/searchBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&orgBoardParameters=" + encodeURIComponent(OrgBoardParameters) + "&code=" + encodeURIComponent(code) + "&inviteFlag=" + inviteFlag;
    		}

	        /* 2021-05-03 홍승비 - 게시물 리스트에서 게시물을 삭제한 경우, 커뮤니티 팝업홈 좌측 전체 게시물 개수 갱신 */
	        function reloadLeftCount(pCode, pCntDom) {
            	$.ajax({
			    	type : "GET",
			    	url : "/ezCommunity/getCommunityBoardItemCnt.do",
			    	async : false,
			    	data : {
			    		code : pCode
			    	},
			    	success : function (result) {
			    		pCntDom.innerText = result;
			    	}
			    });
	        }
            
            function downloadBoardFile(downURL) {
            	
                if (Read_FG != "true") {
                	alert("<spring:message code='ezCommunity.t431' />");
                    return;
                }
                
            	window.location = downURL;
            }
            
            function selectToDownloadFiles(itemID) {
            	
            	if (Read_FG != "true") {
            		alert("<spring:message code='ezCommunity.t431' />");
            		return;
            	}
                
            	var url = "/ezCommunity/selectToDownloadFiles.do?itemID=" + javaURLEncode(itemID) + "&boardID=" + javaURLEncode(pBoardID) + "&code=" + encodeURIComponent(code);
                window.open(url, "", "status=no,help=no,width=580px,height=480px" + GetOpenPosition(580, 480));
            }
    	</script>    
        
	</head>
	<body class = "cmhome_body">
		<h1 class="type1_h1"><c:out value='${multiBoardName}'/><span id="mailBoxInfo"></span></h1>
		
		<div id="mainmenu">
			<ul>
				<c:if test="${pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					<li class="important"><span onClick="NewItem_onclick()"><spring:message code='ezCommunity.t958' /></span></li>
				</c:if>
				<li><span onClick="SetRead_onclick()"><spring:message code='ezCommunity.t915'/></span></li>
				<c:if test="${boardInfo.gubun != '2' && pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
					<li><span onClick="CopyItem_onclick()"><spring:message code='ezCommunity.t911' /></span></li>
				</c:if>
				<%-- 2021-10-12 홍승비 - 예약게시 버튼은 익명게시판에서 표출하지 않도록 수정 (포토게시판처럼 예약게시 기능이 없는 게시판이라면 버튼도 표출하지 않도록 스펙 통일) --%>
				<c:if test="${boardInfo.gubun != '2'}">
					<li><span onClick="ReservationItem_onclick()"><spring:message code='ezCommunity.t913' /></span></li>
				</c:if>
				<c:if test="${boardInfo.read_FG == 'true' && pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					<li onClick="search_onclick()"><span class="icon16 icon16_search"></span></li>
				</c:if>
				<c:if test="${pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					<li onClick="DeleteItem_onclick()"><span class="icon16 icon16_delete"></span></li>
				</c:if>
				<li onClick="refresh_onclick()"><span class="icon16 icon16_refresh"></span></li>
     		</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<div style = "height:370px;">
			<table  id="tblList" class="cmhomelist" style="width:100%">
				<tr>
					<th style="width:20px;padding-top:2px; text-align: center;"><div class="custom_checkbox"><input type='checkbox' name="checkbox" onclick='checkBox_checkAll()'></div></th>
					<c:if test="${pBoardID == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
						<c:choose>
							<c:when test="${pSortBy == 'BoardName'}">
								<th style="cursor:pointer"  onClick="SortPage('BoardName desc')" ><spring:message code='ezCommunity.t418' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
							</c:when>
							<c:when test="${pSortBy == 'BoardName desc'}">
								<th style="cursor:pointer"  onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
							</c:when>
							<c:otherwise>
								<th style="cursor:pointer"  width="80" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418' /></th>
							</c:otherwise>
						</c:choose>
					</c:if>
					
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
					<th style="width:20px; "></th>
					<c:if test="${boardInfo.gubun == '1'}">
						<c:choose>
							<c:when test="${pSortBy == 'A.WriterCompanyName'}">
								<th style="cursor:pointer"  width="130" onClick="SortPage('A.WriterCompanyName desc')"><spring:message code='ezCommunity.t270' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
							</c:when>
							<c:when test="${pSortBy == 'A.WriterCompanyName desc'}">
								<th style="cursor:pointer"  width="130" onClick="SortPage('A.WriterCompanyName')"><spring:message code='ezCommunity.t270' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
							</c:when>
							<c:otherwise>
								<th style="cursor:pointer"  width="130" onClick="SortPage('A.WriterCompanyName')"><spring:message code='ezCommunity.t270' /></th>
							</c:otherwise>
						</c:choose>
					</c:if>
					
					<c:if test="${boardInfo.gubun != '2'}">
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
					</c:if>

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
						    <td align="center" colspan="8"><spring:message code='ezBoard.t281'/></td>
					    </tr>
				    </c:if>
			</table>
		</div>	
		<div id="tblPageRayer" style="margin-top:10px"></div>
		<div id="ListInfo" style="DISPLAY:none">${ListInfo }</div>
		<FONT face="<spring:message code='ezCommunity.t154' />"></FONT>	
	</body>
</html>