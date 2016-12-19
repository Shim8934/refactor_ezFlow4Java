<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>boardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<link rel="stylesheet" href="/css/community.css" type="text/css">		
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<style type="text/css">
	        <!--
	        .photo_tit {
	            font-size: 9pt;
	            font-weight: bold;
	            color: #333333;
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
	        -->
	    </style>
    	<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
    	<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
    	<style>
	        .pagetd {
	            padding-top: 6px;
	        }
	
	        .pcol {
	            padding-top: 6px;
	        }
	
	        .Right_Point01 {
	            font: bold;
	            color: #017bec;
	        }
	    </style>
    	
    	<script type="text/javascript">
	    	var pBoardID = "<c:out value = '${boardInfo.boardID}' />";
	        var pBoardName = "<c:out value = '${boardInfo.boardName}' />";
	        var SSUserID = "<c:out value = '${userInfo.id}' />";
	        var SSUserName = "<c:out value = '${userInfo.displayName1}' />";
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
	        var PageHref = "boardItemList_Photo.aspx?BoardID=<c:out value = '${pBoardID}' />&Page=<c:out value = '${pPage}' />&SortBy=<c:out value = '${pSortBy}' />";
	        var ch_CommunityAdmin = "<c:out value = '${chCommunityAdmin}' />";
	        var UserLevel = "<c:out value = '${userLevel}' />";
	        var pUse_Editor = "<c:out value = '${useEditor}' />";
	        var pUse_IE11Browser = "<c:out value = '${useIE11Browser}' />";
	        
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
    						listXML += "<table width='146' border='0' cellspacing='0' cellpadding='0' style='margin-right:10px'>";
    						listXML += "<tr>";
    						var imgUrl = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "EXTENSIONATTRIBUTE5").trim();
                            listXML += "<td width='146' height='116' align='center' background='/images/photo_bg.gif'><img style='cursor:pointer;width:100px;height:100px;' src='/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&boardID=" + pBoardID + "&fileName=" + imgUrl + "' onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriterID").trim() + "\", event)'></td>";
                            
                            listXML += "</tr></table>";
                            listXML += "<table width='146' border='0' cellpadding='1' cellspacing='1' style='margin-top:5px'>";
                            listXML += "<tr><td class='photo_tit' style='cursor:pointer;'  onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriterID").trim() + "\", event)'>";
                            listXML += "<img src='/images/photo_tit.gif' width='17' height='16' align='absbottom'>";
                            
                            var title = SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "Title").trim();
                            
                            if (title.Length > 8) {
                                title = title.Substring(0, 8) + "...";
                            }
                            
                            listXML += title;
                            listXML += "</td>";
                            listXML += "<tr><td style='padding-left:5px'><span class='photo_name'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriterName").trim() + "</span> / " + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[idx], "WriteDate").split(' ')[0];
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
	        
	        if (url != "") window.location.href = url;
	        
	    	function NewItem_onclick() {
	            if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
					alert("<spring:message code = 'ezCommunity.t896' />");
	               	return;
	           	}
	            
	           	if (ch_CommunityAdmin < 0 && Write_FG != "true") {
					alert("<spring:message code = 'ezCommunity.t897' />");
			        return;
			    }
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;
	
	            if (CrossYN()) {
	                window.open("/ezCommunity/newBoardItemPhoto.do?boardID=" + pBoardID + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	            } else {
	                if (pUse_Editor == "" || pUse_Editor == "CK") {
	                    window.open("/ezCommunity/newBoardItemPhoto.do?boardID=" + pBoardID + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	                } else {
	                    window.open("/ezCommunity/newBoardItemPhoto.do?boardID=" + pBoardID + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	                }
	            }
	        }
	
			function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
	            if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
	            	alert("<spring:message code = 'ezCommunity.t899' />");
	                return;
	           	}
	
	           	if (ch_CommunityAdmin < 0 && Read_FG != "true") {
	            	alert("<spring:message code = 'ezCommunity.t423' />");
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
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;
	            if (CrossYN()) {
	                window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	            } else {
	                window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	            }
	        }
	
// 	        function checkBox_checked(pItemID, pUserID) {
// 	            if (window.event.srcElement.checked) {
// 	                strListInfo += pItemID + "," + pUserID + ";";
// 	            } else {
// 	                strListInfo = ReplaceText(strListInfo, pItemID + "," + pUserID + ";", "");
// 	            }
// 	        }
	
// 	        function checkBox_checkAll() {
// 	            var i = 0;
	            
// 	            for (i = 1; i < document.frmOutbox.length; i++) {
// 	                if (document.frmOutbox[i].type == 'checkbox') {
// 	                    if (document.frmOutbox.checkbox.checked) {
// 	                        document.frmOutbox[i].checked = true;
// 	                        strListInfo = ListInfo.innerText;
// 	                    } else {
// 	                        document.frmOutbox[i].checked = false;
// 	                        strListInfo = "";
// 	                    }
// 	                }
// 	            }
// 	        }
	        
	        var checkpassword_dialogArguments = new Array();
	        
	        function DeleteItem_onclick() {
	            if (gubun == "2") {
	                if (strListInfo == "") {
	                    alert("<spring:message code = 'ezCommunity.t424' />");
					    return;
					}
	
	                arrList = strListInfo.split(",;");
	
	                if (arrList.length > 2) {
	                    alert("<spring:message code = 'ezCommunity.t919' />");
					    return;
					}
	            } else {
	                if (strListInfo == "") {
	                    alert("<spring:message code = 'ezCommunity.t424' />");
					    return;
					}
	            }
	
	            if (Delete_FG != "true") {
	                alert("<spring:message code = 'ezCommunity.t901' />");
				    return;
				}
	
	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false && gubun != "2") {
	                alert("<spring:message code = 'ezCommunity.t431' />");
				    return;
				}
	
	            if (CheckIfHasReplies()) {
	                alert("<spring:message code = 'ezCommunity.t425' />");
				    return;
				}
	
	            if (gubun == "2" && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
	                if (CrossYN()) {
	                    checkpassword_dialogArguments[1] = DeleteItem_onclick_Complete;
	                    var OpenWin = window.open("aspx/CheckPassWord.aspx?ItemID=" + arrList[0], "CheckPassWord", GetOpenWindowfeature(340, 200));
	                    
	                    try { OpenWin.focus(); } catch (e) { }
	                } else {
	                    var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
	                    feature = feature + GetShowModalPosition(330, 200);
	                    var ret = window.showModalDialog("aspx/CheckPassWord.aspx?ItemID=" + arrList[0], "", feature);
	
	                    if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") {
	                    	return;
	                    }
	                    
	                    if (ret == "NO") {
	                        alert("<spring:message code = 'ezCommunity.t921' />");
	                        return;
	                    } else {
	                        var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	                        xmlhttp.open("POST", "aspx/DeleteItem.aspx?ItemList=" + arrList[0] + ";", false);
	                        xmlhttp.send();
	                        xmlhttp = null;
	                        alert('<spring:message code = 'ezCommunity.t204' />');
	                        window.location.reload();
	                    }
	                }
	            } else {
	                var ret = confirm("<spring:message code = 'ezCommunity.t426' />");
	                
				    if (ret) {
				        DeleteItem();
				    }
				}
	        }
	
	        function DeleteItem_onclick_Complete(ret) {
	            if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") {
	            	return;
	            }
	
	            if (ret == "NO") {
	                alert("<spring:message code = 'ezCommunity.t921' />");
	                return;
	            } else {
	                var xmlhttp = createXMLHttpRequest();
	                xmlhttp.open("POST", "interASP/DeleteItem.aspx?ItemList=" + arrList[0] + ";", false);
	                xmlhttp.send();
	                xmlhttp = null;
	                alert('<spring:message code = 'ezCommunity.t204' />');
	                window.location.reload();
	            }
	
	            var ret = confirm("<spring:message code = 'ezCommunity.t426' />");
	            
	            if (ret) {
	                DeleteItem();
	            }
	        }
	
	        function CheckIfHasReplies() {
	            var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	            xmlhttp.open("POST", "interASP/CheckIfHasReply.aspx?ItemList=" + strListInfo, false);
	            xmlhttp.send();
	            
	            if (xmlhttp.responseText == "FALSE") {
	                xmlhttp = null;
	                return false;
	            }
	            
	            xmlhttp = null;
	            
	            return true;
	        }
	
	        function DeleteItem() {
	            var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	            xmlhttp.open("POST", "interASP/DeleteItem.aspx?ItemList=" + strListInfo, false);
	            xmlhttp.send();
	            xmlhttp = null;
	            window.location.reload();
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function CheckOwnerShip() {
	            var arrList = new Array();
	            var i = 0;
	
	            arrList = strListInfo.split(";");
	            
	            for (i = 0; i < arrList.length - 1; i++) {
	                if (arrList[i].split(",")[1].indexOf(SSUserID) == -1) {
	                    arrList = null;
	                    
	                    return false;
	                }
	            }
	            
	            arrList = null;
	            
	            return true;
	        }
	
	        function refresh_onclick() {
	            window.location.reload(false);
	        }
	
	        function AddToMyBoards() {
	            var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	            xmlhttp.open("POST", "interASP/AddToMyBoards.aspx?BoardID=" + pBoardID + "&BoardName=" + escape(pBoardName), false);
	            xmlhttp.send();
	
	            if (xmlhttp.responseXML.text == "OK") {
	                alert("<spring:message code = 'ezCommunity.t902' />");
				} else {
				    alert("<spring:message code = 'ezCommunity.t903' />");
				}
	            
	            xmlhttp = null;
	        }
	
	        var BlockSize = 10;
	        
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext;
	        }
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang82 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang83 + "]";
	            strtext = "<div class='pagenavi'>";
	            PagingHTML += strtext;
	            var pageNum = CurPage;
	            
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
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
	                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + parseInt(newPage) + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
				}
	        }
	
	        function prevPage_onclick() {
	            newPage = parseInt(CurPage) - 1;
	            
	            if (newPage > 0) {
	                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + newPage.toString() + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
				}
	        }
	
	        function nextPage_onclick() {
	            newPage = parseInt(CurPage) + 1;
	            
	            if (newPage <= parseInt(totalPage)) {
	                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + newPage.toString() + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
				}
	        }
	
	
	        function goPrevPage_onclick(objPage) {
	            newPage = (parseInt(objPage) - 1) * 10 + 1;
	
	            if (newPage < 0) {
	            	newPage = 1;
	            }
	            
	            if (newPage > 0) {
	                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + newPage.toString() + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
				}
	
	        }
	
	        function goNextPage_onclick(objPage) {
	            newPage = (parseInt(objPage) - 1) * 10 + 1;
	            
	            if (newPage <= parseInt(totalPage)) {
	                window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + newPage.toString() + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
				}
	        }
	
	        function moveToPage() {
	            if (window.event.keyCode == 13) {
	                var newPage = txt_PageInputNum.value;
	                
	                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	                    window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + parseInt(newPage) + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + "<c:out value = '${code}' />";
					}
	            }
	        }
	
	        function SortPage(SortBy) {
	            window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + CurPage + "&bBoardID=" + pBoardID + "&pBoardName=" + pBoardName + "&sortBy=" + SortBy + "&code=" + "<c:out value = '${code}' />";
			}
	
			function SelCateList_onChange() {
			    window.location.href = "/ezCommunity/boardItemListPhoto.do?page=" + CurPage + "&boardID=" + pBoardID + "&pBoardName=" + pBoardName + "&sortBy=" + pSortBy + "&cateID=" + SelCateList.value + "&code=" + "<c:out value = '${code}' />";
			}
	
			function CopyItem_onclick() {
			    if (Read_FG != "true") {
			        alert("<spring:message code = 'ezCommunity.t431' />");
			        
				    return;
				}
	
	            if (strListInfo == "") {
	                alert("<spring:message code = 'ezCommunity.t430' />");
				    return;
				}
	
	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
	                alert("<spring:message code = 'ezCommunity.t431' />");
	                
				    return;
				}
	            
	            var arrList = new Array();
	            var strItemList = "";
	            var i = 0;
	
	            arrList = strListInfo.split(";");
	            
	            for (i = 0; i < arrList.length - 1; i++) {
	                strItemList += arrList[i].split(",")[0] + ";";
	            }
	            
	            arrList = null;
	
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 200;
	            pwidth = pwidth - 127;
	
	            window.open("CopyBoardItem.aspx?ItemIDList=" + strItemList + "&BoardID=" + pBoardID, "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth, "");
	        }
	
	        function SetRead_onclick() {
	            if (Read_FG != "true") {
	                alert("<spring:message code = 'ezCommunity.t423' />");
	                
				    return;
				}
	
	            if (strListInfo == "") {
	                alert("<spring:message code = 'ezCommunity.t427' />");
	                
				    return;
				}
	
	            var ret = confirm("<spring:message code = 'ezCommunity.t428' />");
	            
			    if (ret) {
			        var arrList = new Array();
			        var strItemList = "";
			        var i = 0;
	
			        arrList = strListInfo.split(";");
			        
			        for (i = 0; i < arrList.length - 1; i++) {
			            strItemList += arrList[i].split(",")[0] + ";";
			        }
			        
			        arrList = null;
	
			        var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			        xmlhttp.open("POST", "interASP/SetRead.aspx?BoardID=" + pBoardID + "&ItemIDList=" + strItemList, false);
			        xmlhttp.send();
	
			        xmlhttp = null;
			        
			        refresh_onclick();
			    }
			}
	
			function MemberInfo_onclick(pUserID) {
			    if (gubun == "2") {
			    	return;
			    }
			    
			    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 450);
			    window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + pUserID, "", feature);
			}
	
			function ReservationItem_onclick() {
			    var OrgBoardParameters = "Page=" + CurPage + "&BoardID=" + pBoardID + "&SortBy=" + pSortBy;
			    window.location.href = "BoardReservedItemList.aspx?OrgBoardParameters=" + escape(OrgBoardParameters);
			}
	
			document.onselectstart = function () {
			    window.event.cancelBubble = true;
			    window.event.returnValue = false;
			}
	
			function search_onclick() {
			    var OrgBoardParameters = "Page=" + CurPage + "&BoardID=" + pBoardID + "&SortBy=" + pSortBy;
			    window.location.href = "SearchBoardItem.aspx?BoardID=" + pBoardID + "&OrgBoardParameters=" + escape(OrgBoardParameters);
			}
	
			function NewPhotoItem_onclick() {
			    if (Write_FG != "true") {
			        alert("<spring:message code = 'ezCommunity.t897' />");
			        
				    return;
				}
	
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 720) / 2;
	            var pLeft = (pwidth - 765) / 2;
	
	            window.open("NewBoardItem_Photo.aspx?BoardID=" + pBoardID + "&Mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
	        }
    	</script>
	</head>
	<body class="cmhome_body" style="overflow-x:hidden">
	
		<c:if test="${boardInfo.listView_FG != 'true' }">
			<div style="margin-top: 100px; text-align: center"><spring:message code = 'ezCommunity.t909' /></div>
			<%
				if (true) {
					return;
				}
			%>
		</c:if>
	    
	    <h1 class="type1_h1">${boardInfo.boardName }<span id="mailBoxInfo"></span></h1>
	    
	    <div id = "mainmenu">
	    	<c:if test="${boardInfo.boardID !=  '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
	    		<ul>
	        		<li><span onclick="NewItem_onclick()"><spring:message code = 'ezCommunity.t923' /></span></li>
		            <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
		            <li style="display: none"><span onclick="DeleteItem_onclick()"><spring:message code = 'ezCommunity.t208' /></span></li>
	        </c:if>
	        
	        <c:if test="${boardInfo.gubun != '2' && boardInfo.boardID !=  '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
	        		<li style="display: none"><span onclick="CopyItem_onclick()"><spring:message code = 'ezCommunity.t911' /></span></li>
	        </c:if>
	        
	        <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
            <li><span onclick="refresh_onclick()"><spring:message code = 'ezCommunity.t912' /></span></li>
            
            <c:if test="${boardInfo.read_FG == 'true' && boardInfo.boardID !=  '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
            		<li style="display: none"><span onclick="search_onclick()"><spring:message code = 'ezCommunity.t31' /></span></li>
            		<li style="display: none"><span onclick="AddToMyBoards()"><spring:message code = 'ezCommunity.t916' /></span></li>
            </c:if>
            
            		<li style="display: none"><span onclick="ReservationItem_onclick()"><spring:message code = 'ezCommunity.t913' /></span></li>
            	</ul>
	    </div>

	    <table id="tblList">
<!-- 	        <form name="frmOutbox" action="/ezCommunity/boardItemListPhoto.do" method="post"> -->
<!-- 	        </form> -->
	    </table>
	    <div style="width: 615px; padding-top: 10px" id="tblPageRayer"></div>
	    <div id="ListInfo" style="DISPLAY: none">${listInfo}</div>
	</body>
</html>