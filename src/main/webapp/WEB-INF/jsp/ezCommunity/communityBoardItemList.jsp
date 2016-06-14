<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>BoardItemList</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" type="text/css" href="/css/community.css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
        
        <style type="text/css"> 
	        .pagetd{padding-top:6px; }
	        .pcol{padding-top:6px; }
	        .Right_Point01 {
		        font:bold;
		        color:#017bec;
        	}
        </style>
    	
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
    		var ch_CommunityAdmin = "<c:out value='${fn:indexOf(userInfo.rollInfo, \'t=1\') }'/>";
    		var ListInfo = "";
    		
    		$(function () {
    			var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			
    			for (i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
					var strSpace = '';
					var strEmergent = '';
					var bTag = '';
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Importance") == "1") {
						strEmergent = "<img src='/images/i_urgency.gif'>&nbsp;";
					}
					
					for (var j = 1; j < SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel"); j++) {
						strSpace += "&nbsp&nbsp;";
						if (j == SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemLevel") - 1) {
							strSpace += "<img src='/images/i_rep.gif' align='absmiddle'>&nbsp;";
						}
					}
					
					if (pBoardID != "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
						if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadFlag") != "0") {
							bTag = "";
						} else {
							bTag = "<B>";
						}
					} else {
						bTag = "<B>";
					}
					
					listXML += "<TR>";
					listXML += "<TD align=center><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID") + "\" , event)'></td>";
					
					if (pBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
                        listXMl += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName"+"${lang}") + "</TD>";
                        listXML += "<TD title='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`") + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "boardName"+"${lang}") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID") + "\", event)'><nobr>" + bTag + strEmergent + strSpace + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title") + "</nobr></TD>";						
					} else {
						listXML += "<TD title='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`") + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID") + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Writer") + "\", event)'><nobr>" + bTag + strEmergent + strSpace + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title") + "</nobr></TD>";
					}
					
					if (gubun == '1') {
						listXML += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterCompanyName").trim() + "</TD>";
					}
					
					if (gubun != '2') {
						listXML += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() + "</TD>";
                        listXML += "<TD><div style='cursor:pointer' onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\")'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim() + "</div></TD>";
					} else {
                        listXML += "<TD><div onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\")'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim() + "</div></TD>";
					}
					
					listXML += "<TD>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</TD>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						listXML += "<TD align=center><img src='/images/i_save01.gif'></TD>";
					} else {
						listXML += "<TD></TD>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") == ""){
						listXML += "<TD align=center>0</TD>";
					} else {
						listXML += "<TD align=center>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") + "</TD>";
					}
					
					listXML += "</TR>";
					
					ListInfo += SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + ";";
    			}
    			
    			$('#tblList').html($('#tblList').html()+listXML);
    			makePageSelPage();
    		});
    		
    		
    		if (url != "") { 
				window.location.href = url;
    		}
    		
    		function NewItem_onclick() {
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
				    alert("<spring:message code='ezCommunity.t896' />");
				    return;
				}
    			    
				if (ch_CommunityAdmin < 0 && Write_FG != "true") {
				    alert("<spring:message code='ezCommunity.t897' />");
				    return;
				}
				
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 765) / 2;
			    window.open("/ezCommunity/newBoardItem.do?boardID=" + pBoardID + "&mode=new", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
			}
    		 
    		function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
   				if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t899' />");
    				return;
    			}
    				
    			if(ch_CommunityAdmin < 0 && Read_FG != "true") {
    				alert("<spring:message code='ezCommunity.t423' />");
    				return;
    			}

		       	var e = evt.currentTarget.innerHTML;
  		        	
   		        if (evt.currentTarget.getElementsByTagName("B").length == 1) {
   		            evt.currentTarget.getElementsByTagName("nobr")[0].innerHTML = evt.currentTarget.getElementsByTagName("B")[0].innerHTML;
   		        }

    		    var pheight = window.screen.availHeight;
    		    var pwidth = window.screen.availWidth;
    		    var pTop = (pheight - 720) / 2;
    		    var pLeft = (pwidth - 765) / 2;
    		    
   		    	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pItemBoardID + "&code=" + code + "&showAdjacent=" + ShowAdjacent, "", 750, 800);
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
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t900' />");
    				return;
    			}
    					
    			if(strListInfo == "") {
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

    			if(ch_CommunityAdmin < 0 && Delete_FG != "true") {
    				alert("<spring:message code='ezCommunity.t901' />");
    				return;
    			}
    			
    		    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false && ch_CommunityAdmin < 0) {
    		        if (gubun == "2") {
    		            var pItemInfo = strListInfo.split(";")[0];
    		            var pItemID = pItemInfo.split(",")[0];

    		            if (pItemID != "") {
   		                    checkpassword_dialogArguments[1] = DeleteItem_onclick_Complete;
   		                    var OpenWin = window.open("/ezCommunity/checkPassWord.do?itemID=" + pItemID, "checkPassWord", GetOpenWindowfeature(340, 200));
   		                    
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
    		    	if (gubun == "2") {
    		    		var pItemInfo = strListInfo.split(";")[0];
     		            var pItemID = pItemInfo.split(",")[0];
     		            
    		    		if (!confirm("<spring:message code='ezCommunity.t426'/>")) {
    	            		return;
    	            	}
    	            	
                        var ret = window.showModalDialog("/ezCommunity/checkPassword.do?itemID=" + pItemID, "CheckPassWord", GetOpenWindowfeature(340, 200));
    					
    					if (ret != "OK") {
    					    alert("<spring:message code = 'ezCommunity.t901' />");
    					    return;
    					}
    					
    	 			    var xmlhttp = createXMLHttpRequest();
    	 			    xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + pItemID + ";", false);
    	 			    xmlhttp.send();
    	 			    xmlhttp = null;
    	 			    
    	 			    try {
    	 			        window.refresh_onclick();
    	 			    } catch (e) {
    	 			    }
    		    	}
    		    	
    		    }
    		    
    		    if (CheckIfHasReplies()) {
    		        alert("<spring:message code='ezCommunity.t425' />");
                    return;
                }
    		    
    		    if(gubun != "2"){
    		        var ret = confirm("<spring:message code='ezCommunity.t426' />");
    		        if (ret) {
    		        	DeleteItem();
    		        }
    		    }
    		}
    		
    		function DeleteItem_onclick_Complete(ret) {
		        if (typeof (ret) == "undefined") {
		            alert("<spring:message code='ezCommunity.t901' />");
		            return;
		        }

		        if (ret != "OK") {
		            alert("<spring:message code='ezCommunity.t901' />");
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
    			xmlhttp.open("POST", "/ezCommunity/checkIfHasReply.do?itemList=" + strListInfo, false);
    			xmlhttp.send();	

    			if(xmlhttp.responseText == "FALSE") {
    				xmlhttp = null;	
    				return true;
    			}
    			
    			xmlhttp = null;
    			return false;
    		}

    		function DeleteItem() {
    		    var xmlhttp = createXMLHttpRequest();
    		    
    			xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + strListInfo, false);
    			xmlhttp.send();
    			xmlhttp = null;
    			window.location.href = "/ezCommunity/boardItemList.do?boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
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
    				if(arrList[i].split(",")[1].indexOf(SSUserID) == -1) {
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
    			xmlhttp.open("POST", "/ezCommunity/addToMyBoards.do?boardID=" + pBoardID + "&boardName=" + encodeURIComponent(pBoardName), false);
    			xmlhttp.send();
    			
    			if(xmlhttp.responseXML.text == "OK") {
    				alert("<spring:message code='ezCommunity.t902' />");
    			} else {
    				alert("<spring:message code='ezCommunity.t903' />");
    			}
    			xmlhttp = null;		
    		}
    		
            var BlockSize = 10;
            
            function td_Create1(strtext) {
                $("#tblPageRayer").html(strtext);
            }
            
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                $("#tblPageRayer").html("");
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
    			    window.location.href = "/ezCommunity/boardItemList.do?page=" + parseInt(newPage) + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
    		    }
    		}
            
            function prevPage_onclick() {
    			newPage = parseInt(CurPage) - 1;
    			
    			if(newPage > 0) {
    				window.location.href = "/ezCommunity/boardItemList.do?page=" + newPage.toString() + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
    			}
    		}

    		function nextPage_onclick() {
    			newPage = parseInt(CurPage) + 1;
    			
    			if(newPage <= parseInt(totalPage)) {
    				window.location.href = "/ezCommunity/BoardItemList.do?page=" + newPage.toString() + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
    			}
    		}

    		function moveToPage() {
    			if(window.event.keyCode == 13) {
    				var newPage = txt_PageInputNum.value;
    				
    				if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage))  {
    					window.location.href = "/ezCommunity/boardItemList.do?page=" + parseInt(newPage) + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
    				}
    			}
    		}

    		function SortPage(SortBy) {
    			window.location.href = "/ezCommunity/boardItemList.do?page=" + CurPage + "&boardID=" + pBoardID + "&pBoardName=" + pBoardName + "&sortBy=" + SortBy + "&code=" + code;
    		}

    		function CopyItem_onclick() {
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t905' />");
    				return;
    			}
    					
    			if(strListInfo == "") {
    				alert("<spring:message code='ezCommunity.t430' />");
    				return;
    			}

    			if(ch_CommunityAdmin < 0 && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
    				alert("<spring:message code='ezCommunity.t431' />");
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
    			
    			var wWeight = "340";
    			var wHeight = "656";

    			var heigth = window.screen.availHeight;
    			var width = window.screen.availWidth;

    			var left = (width - wWeight) / 2;
    			var top = (heigth - wHeight) / 2;
    			
    			window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID + "&code=" + code, "", "height=656,width=340, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + top + ",left = " + left, "");
    		}
    		
    		function SetRead_onclick() {
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t899' />");
    				return;
    			}
    					
    			if(ch_CommunityAdmin < 0 && Read_FG != "true") {
    				alert("<spring:message code='ezCommunity.t423' />");
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
    			
    				var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    				xmlhttp.open("POST", "/ezCommunity/setRead.do?boardID=" + pBoardID + "&itemIDList=" + strItemList, false);
    				xmlhttp.send();
    				
    				xmlhttp = null;

    				refresh_onclick();
    			}
    		}

    		function MemberInfo_onclick(pUserID) {
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t906' />");
    				return;
    			}
    					
    		    if (gubun == "2") return;
    		    var heigth = window.screen.availHeight;
    		    var width = window.screen.availWidth;
    		    var left = (width - 500) / 2;
    		    var top = (heigth - 400) / 2;
    		    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
    		}

    		function ReservationItem_onclick() {
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t907' />");
    				return;
    			}
    				
    			var OrgBoardParameters = "page=" + CurPage + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
    			window.location.href = "/ezCommunity/boardReservedItemList.do?orgBoardParameters=" + encodeURIComponent(OrgBoardParameters);
    		}

    		document.onselectstart = function () {
    		    window.event.cancelBubble = true;
    		    window.event.returnValue = false;
    		}

    		function search_onclick() {
    			if (ch_CommunityAdmin < 0 && (UserLevel == "0" || UserLevel == "9")) {
    				alert("<spring:message code='ezCommunity.t908' />");
    				return;
    			}
    					
    			var OrgBoardParameters = "page=" + CurPage + "&boardID=" + pBoardID + "&sortBy=" + pSortBy + "&code=" + code;
    			window.location.href = "/ezCommunity/searchBoardItem.do?boardID=" + pBoardID + "&orgBoardParameters=" + encodeURIComponent(OrgBoardParameters) + "&code=" + code;
    		}

    		function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
   		        try {
   		            var heigth = window.screen.availHeight;
   		            var width = window.screen.availWidth;

   		            var left = 0;
   		            var top = 0;

   		            if (window.screen.width > 800) {
   		                var pleftpos;

   		                pleftpos = parseInt(width) - 770;
   		                heigth = parseInt(heigth) - 30;
   		                width = parseInt(width) - pleftpos;

   		                left = pleftpos / 2;
   		            } else {
   		                heigth = parseInt(heigth) - 30;
   		                width = parseInt(width) - 10;
   		            }
   		            
   		            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
   		        } catch (e) {
   		            alert("openwindow :: " + e.description);
   		        }
   		    }
    	</script>    
        
	</head>
	<body class = "cmhome_body">
		<c:if test="${boardInfo.listView_FG != 'true' }">
			<div style="margin-top:100px;text-align:center"><spring:message code='ezCommunity.t909' /></div>
			
		</c:if>
		
		<h1 class="type1_h1">${boardInfo.boardName}<span id="mailBoxInfo"></span></h1>
		
		<div id="mainmenu">
			<ul>
				<li><span onClick="SetRead_onclick()"><spring:message code='ezCommunity.t915'/></span></li>
				
				<c:if test="${pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					<li><span onClick="NewItem_onclick()"><spring:message code='ezCommunity.t910' /></span></li>
					<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
					<li><span onClick="DeleteItem_onclick()"><spring:message code='ezCommunity.t208' /></span></li>
				</c:if>
				
				<c:if test="${boardInfo.gubun != '2' && pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
					<li><span onClick="CopyItem_onclick()"><spring:message code='ezCommunity.t911' /></span></li>
				</c:if>
				
				<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
				<li><span onClick="refresh_onclick()"><spring:message code='ezCommunity.t912' /></span></li>
				
				<c:if test="${boardInfo.read_FG == 'true' && pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					<li><span onClick="search_onclick()"><spring:message code='ezCommunity.t31' /></span></li>
				</c:if>
				
				<li><span onClick="ReservationItem_onclick()"><spring:message code='ezCommunity.t913' /></span></li>
     		</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>

		<%-- <table border="0" cellspacing="0" cellpadding="0" class="micon">
			<tr>
				<td><span onClick="SetRead_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezCommunity.t915' /></span></td>

				<c:if test="${pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					<td><span onClick="NewItem_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezCommunity.t910' /></span></td>
					<td style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></td>
					<td><span onClick="DeleteItem_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezCommunity.t208' /></span></td>
				</c:if>
				
				<c:if test="${pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' && gubun != '2' }">
					<td><span onClick="CopyItem_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezCommunity.t911' /></span></td>
				</c:if>
				
				<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
				<td><span onClick="refresh_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezCommunity.t912' /></span></td>
				
				
				<c:if test="${pBoardID != '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' && boardInfo.read_FG == 'true'}">
					<td><span onClick="search_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezCommunity.t31' /></span></td>
					<td><span style="cursor:pointer;display:none" onClick="AddToMyBoards()" class="ic"><spring:message code='ezCommunity.t916' /></span></td>
				</c:if>
				
				<td><span style="cursor:pointer" onClick="ReservationItem_onclick()" class="ic"><spring:message code='ezCommunity.t913' /></span></td>
			</tr>
		</table> --%>
		
		<table  id="tblList" class="cmhomelist" style="width:100%">
			<form name="frmOutbox" action="/ezCommunity/boardItemList.do" method="post">
				<tr>
					<th style="width:20px;padding-top:2px;"><input type='checkbox' name="checkbox" onclick='checkBox_checkAll()'></th>
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
					
					<c:choose>
						<c:when test="${lang=='' || lang==null}">
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
										<th style="cursor:pointer"  width="150" onClick="SortPage('A.WriterDeptName desc')"><spring:message code='ezCommunity.t241' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
									</c:when>
									<c:when test="${pSortBy == 'A.WriterDeptName desc'}">
										<th style="cursor:pointer"  width="150" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
									</c:when>
									<c:otherwise>
										<th style="cursor:pointer"  width="150" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241' /></th>
									</c:otherwise>
								</c:choose>
							</c:if>
							
							<c:choose>
								<c:when test="${pSortBy == 'A.WriterName'}">
									<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriterName desc')"><spring:message code='ezCommunity.t445' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
								</c:when>
								<c:when test="${pSortBy == 'A.WriterName desc'}">
									<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
								</c:when>
								<c:otherwise>
									<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445' /></th>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:if test="${boardInfo.gubun == '1'}">
								<c:choose>
									<c:when test="${pSortBy == 'A.WriterCompanyName2'}">
										<th style="cursor:pointer"  width="130" onClick="SortPage('A.WriterCompanyName desc')"><spring:message code='ezCommunity.t270' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
									</c:when>
									<c:when test="${pSortBy == 'A.WriterCompanyName2 desc'}">
										<th style="cursor:pointer"  width="130" onClick="SortPage('A.WriterCompanyName')"><spring:message code='ezCommunity.t270' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
									</c:when>
									<c:otherwise>
										<th style="cursor:pointer"  width="130" onClick="SortPage('A.WriterCompanyName')"><spring:message code='ezCommunity.t270' /></th>
									</c:otherwise>
								</c:choose>
							</c:if>
							
							<c:if test="${boardInfo.gubun != '2'}">
								<c:choose>
									<c:when test="${pSortBy == 'A.WriterDeptName2'}">
										<th style="cursor:pointer"  width="150" onClick="SortPage('A.WriterDeptName desc')"><spring:message code='ezCommunity.t241' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
									</c:when>
									<c:when test="${pSortBy == 'A.WriterDeptName2 desc'}">
										<th style="cursor:pointer"  width="150" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
									</c:when>
									<c:otherwise>
										<th style="cursor:pointer"  width="150" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241' /></th>
									</c:otherwise>
								</c:choose>
							</c:if>
							
							<c:choose>
								<c:when test="${pSortBy == 'A.WriterName2'}">
									<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriterName desc')"><spring:message code='ezCommunity.t445' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
								</c:when>
								<c:when test="${pSortBy == 'A.WriterName2 desc'}">
									<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
								</c:when>
								<c:otherwise>
									<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445' /></th>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
						
					
					<c:choose>
						<c:when test="${pSortBy == 'A.WriteDate'}">
							<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriteDate desc')"><spring:message code='ezCommunity.t209' /><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.WriteDate desc'}">
							<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriteDate')"><spring:message code='ezCommunity.t209' /><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="80" onClick="SortPage('A.WriteDate')"><spring:message code='ezCommunity.t209' /></th>
						</c:otherwise>
					</c:choose>
					
					<c:choose>
						<c:when test="${pSortBy == 'A.Attachments'}">
							<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments desc')"><img src="/images/file.gif" width="13" height="12"><img src="/images/view-sortup.gif" width="9" height="9"></th>
						</c:when>
						<c:when test="${pSortBy == 'A.Attachments desc'}">
							<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments')"><img src="/images/file.gif" width="13" height="12"><img src="/images/view-sortdown.gif" width="9" height="9"></th>
						</c:when>
						<c:otherwise>
							<th style="cursor:pointer"  width="20" onClick="SortPage('A.Attachments')"><img src="/images/file.gif" width="13" height="12"></th>
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
			</form>
		</table>
		<div id="tblPageRayer"></div>
		<div id="ListInfo" style="DISPLAY:none">${ListInfo }</div>
		<FONT face="<spring:message code='ezCommunity.t154' />"></FONT>	
	</body>
</html>