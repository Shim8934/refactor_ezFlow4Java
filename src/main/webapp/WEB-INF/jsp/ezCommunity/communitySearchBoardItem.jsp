<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>SearchBoardItem</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" type="text/css" href="/css/community.css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<!-- 		data picker -->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
        <!-- time picker-->
        <script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
        <link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css"/>
        
        <style type="text/css"> 
	        .pagetd{padding-top:6px; }
	        .pcol{padding-top:6px; }
	        .Right_Point01 {
		        font:bold;
		        color:#017bec;
	        }
        </style>
        
		<script type="text/javascript">
	        var pOrgBoardParameters = "<c:out value='${orgBoardParameters}' />'";
		    var searchStart = "<c:out value='${searchStart}' />";
		    var searchEnd = "<c:out value='${searchEnd}' />";
		    var pBoardID = "<c:out value='${boardInfo.boardID}' />";
		    var pBoardName = "";
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
		    var code = "<c:out value='${code}' />";
		    var pSortBy = "<c:out value='${pSortBy}' />";
		    var xmlhttp = createXMLHttpRequest();
		    var gubun = "<c:out value='${boardInfo.gubun}' />";
		    
		    if ("${userInfo.lang == '1'}") {
		    	pBoardName = "<c:out value='${boardInfo.boardName}' />";
		    } else {
		    	pBoardName = "<c:out value='${boardInfo.boardName2}' />";
		    }
		    
		    window.onload = function() {
			    if (searchStart == "") {
			        btn_PostDate_Clear();
			    }
			}
		    
		    $(function () {
		    	var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			
    			for (var i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
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
					
					listXML += "<tr id='rowdata'>";
					listXML += "<td width=20 align=center valign=middle style='padding:0'><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", event)'></td>";
					listXML += "<td title='" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`") + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "\", \"" + bTag + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", event)'><nobr>" + bTag + strEmergent + strSpace + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title").trim() + "</nobr></td>"

					if (gubun == "1") {
						listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterCompanyName").trim() + "</td>";
					}
					
					if (gubun != "2") {
						listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() + "</td>";
					}
					
					if (gubun == "2") {
						listXML += "<td><div style='cursor:pointer'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim() + "</div></td>";
					} else {
						listXML += "<td><div style='cursor:pointer' onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\")'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim() + "</div></td>";
					}

					listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</td>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						listXML += "<td align=center><img src='/images/i_save01.gif'></td>";
					} else {
						listXML += "<td></td>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") == ""){
						listXML += "<td align=center>0</td>";
					} else {
						listXML += "<td align=center>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") + "</td>";
					}
					
					listXML += "<tr>";
					
					ListInfo += SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + ";";
    			}
    			
    			$('.mainlist').html($('.mainlist').html() + listXML);
    			
    			makePageSelPage();
    			
			    $("#Sdatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.gif",
			        buttonImageOnly: true
			    });
			    
			    $("#Edatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.gif",
			        buttonImageOnly: true
			    });
			    var settime;
			    var NowDate;

			    NowDate = new Date(searchStart.substring(0, 4), searchStart.substring(5, 7), searchStart.substring(8, 10), searchStart.substring(11, 13), searchStart.substring(14, 16));
			    NowDate.setMonth(NowDate.getMonth() - 1);
	
			    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Sdatepicker").datepicker('setDate', NowDate);
	
			    var NowDate2 = new Date(searchEnd.substring(0, 4), searchEnd.substring(5, 7), searchEnd.substring(8, 10), searchEnd.substring(11, 13), searchEnd.substring(14, 16));
			    NowDate2.setMonth(NowDate2.getMonth() - 1);
			    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Edatepicker").datepicker('setDate', NowDate2);
			});
			
			$(function () {
				if("${userInfo.lang == '1'}"){
					$.datepicker.regional['ko'] = {
		            	closeText: '닫기',
		            	prevText: '이전달',
		            	nextText: '다음달',
		            	currentText: '오늘',
		            	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
		            	'7월', '8월', '9월', '10월', '11월', '12월'],
		            	monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
		            	'7월', '8월', '9월', '10월', '11월', '12월'],
		            	dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		            	dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		            	dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		            	weekHeader: 'Wk',
		            	dateFormat: 'yy-mm-dd',
		            	firstDay: 0,
		            	isRTL: false,
		            	duration: 200,
		            	showAnim: 'show',
		            	showMonthAfterYear: true
		        	};
		        	
		        	$.datepicker.setDefaults($.datepicker.regional['ko']);
				} else {
					$.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
		    	        firstDay: 0,
		        	    isRTL: false,
		            	duration: 200,
		            	showAnim: 'show',
		            	showMonthAfterYear: true
		        	};
		        	
		        	$.datepicker.setDefaults($.datepicker.regional['en']);
				}
	    	});
		    
			function btn_PostDate_Clear() {
			    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Sdatepicker").datepicker('setDate', "");
			    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Edatepicker").datepicker('setDate', "");
			}
			
			function search() {
			    if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
			        alert("<spring:message code='ezCommunity.t421' />");
			        return;
			    }
			    
			    if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
			    	alert("<spring:message code='ezCommunity.t421' />");
			        return;
			    }
			    
			    if (new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
			    	alert("<spring:message code='ezCommunity.t1459' />");
			        return;
			    }

			    var title = document.getElementById("txtTitle").value;
			    var writerName = document.getElementById("txtWriterName").value;
			    var strAbstract = document.getElementById("txtAbstract").value;
			    var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

			    var url = "/ezCommunity/searchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
			    url += "&boardID=" + pBoardID;
			    url += "&title=" + encodeURIComponent(title);
			    url += "&writerName=" + encodeURIComponent(writerName);
			    url += "&abstract=" + encodeURIComponent(strAbstract);
			    url += "&searchStart=" + searchStart;
			    url += "&searchEnd=" + searchEnd;
			    url += "&code=" + code;

			    window.location.href = url;
			}
			
			function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, evt) {
	            var e = evt.currentTarget.innerHTML;
		        var eText = e;
		        
		        if (eText.substring(0, 3) == "<B>") {
		            e.outerHTML = eText.substring(3, eText.length);
		        }
		        
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
		        
		        if (CrossYN()) {
		            GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pItemBoardID, "", 720, 765);
		        }
		        else {
	                window.open("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pItemBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        }
		    }
			
			function checkBox_checked(pItemID, pUserID, evt) {
		        if (CrossYN()) {
		            if (evt.currentTarget.checked) {
		                strListInfo += pItemID + "," + pUserID + ";";
		            } else {
		                strListInfo = ReplaceText(strListInfo, pItemID + "," + pUserID + ";", "");
		            }
		        } else {
		            if (window.event.srcElement.checked) {
		                strListInfo += pItemID + "," + pUserID + ";";
		            } else {
		                strListInfo = ReplaceText(strListInfo, pItemID + "," + pUserID + ";", "");
		            }
		        }
		    }
			
			function checkBox_checkAll() {
			    for (var i = 1; i < document.frmOutbox.length; i++) {
			        if (document.frmOutbox[i].type == 'checkbox') {
			            if (document.frmOutbox.checkbox.checked) {
			                document.frmOutbox[i].checked = true;
			                strListInfo = ListInfo.innerText;
			            } else {
			                document.frmOutbox[i].checked = false;
			                strListInfo = "";
			            }
			        }
			    }
			}
			
			function DeleteItem_onclick() {	
				if(strListInfo == "") {
					alert("<spring:message code='ezCommunity.t424' />");
					return;
				}

				if(Delete_FG != "true") {
					alert("<spring:message code='ezCommunity.t901' />");
					return;
				}

				if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
					alert("<spring:message code='ezCommunity.t431' />");
					return;
				}

				if(!CheckIfHasReplies()) {
					alert("<spring:message code='ezCommunity.t425' />");
					return;
				}
				
				var ret = confirm("<spring:message code='ezCommunity.t426' />");
				
				if (ret)	{
					DeleteItem();	
				}
			}
			
			function CheckIfHasReplies() {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/ezCommunity/checkIfHasReply.do?itemList=" + strListInfo, false);
				xmlhttp.send();
				
				if(xmlhttp.responseText == "FALSE") {
					xmlhttp = null;	
					return false;
				}
				
				xmlhttp = null;
				return true;
			}

			function DeleteItem() {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + strListInfo, false);
				xmlhttp.send();
				xmlhttp = null;

				if (document.getElementById("rowdata") != null && typeof (document.getElementById("rowdata").length) == "undefined" && CurPage != 1) {
					movePage(CurPage);
				} else if (document.getElementById("rowdata") != null && document.getElementById("rowdata").length == strListInfo.split(";").length - 1 && CurPage != 1) {
				    movePage(CurPage);
				} else {
				    window.location.reload();
				}
			}

			function ReplaceText(orgStr, findStr, replaceStr) {
				var re = new RegExp( findStr, "gi" );
				
				return (orgStr.replace( re, replaceStr ));
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
	            
	            if( parseInt(pageNum + 1) <= totalPage){
	                goToPageByNum(parseInt(pageNum + 1));
	            } else {
	                return;
	            }
	        }
	        
	        function movePage(newPage) {
	        	var title = txtTitle.value;
				var writerName = txtWriterName.value;
				var strAbstract = txtAbstract.value;
			    var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

				var url = "/ezCommunity/searchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + pBoardID;
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&page=" + newPage.toString();
				url += "&code=" + code;

				if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage))  {
					window.location.href = url;
				}
			}

			function prevPage_onclick() {
				var newPage = parseInt(CurPage) - 1;
				var title = txtTitle.value;
				var writerName = txtWriterName.value;
				var strAbstract = txtAbstract.value;
				var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

				var url = "/ezCommunity/searchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + pBoardID;
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&page=" + newPage.toString();
				url += "&code=" + code;

				if(newPage > 0) {
					window.location.href = url;
				}
			}
			
			function nextPage_onclick() {
				var newPage = parseInt(CurPage) + 1;
				var title = txtTitle.value;
				var writerName = txtWriterName.value;
				var strAbstract = txtAbstract.value;
				var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

				var url = "/ezCommunity/searchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + pBoardID;
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&page=" + newPage.toString();
				url += "&code=" + code;

				if(newPage <= parseInt(totalPage)) {
					window.location.href = url;
				}
			}

			function moveToPage() {
				if(window.event.keyCode == 13) {
					var newPage = txt_PageInputNum.value;	
					var title = txtTitle.value;
					var writerName = txtWriterName.value;
					var strAbstract = txtAbstract.value;
					var searchStart = idDatepicker.value;
					var searchEnd = _D2.value;

					var url = "/ezCommunity/searchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
					url += "&boardID=" + pBoardID;
					url += "&title=" + encodeURIComponent(title);
					url += "&writerName=" + encodeURIComponent(writerName);
					url += "&abstract=" + encodeURIComponent(strAbstract);
					url += "&searchStart=" + searchStart;
					url += "&searchEnd=" + searchEnd;
					url += "&page=" + newPage.toString();
					url += "&code=" + code;

					if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
						window.location.href = url;
					}
				}
			}
			
			function SetRead_onclick() {
				if(Read_FG != "true") {
					alert("<spring:message code='ezCommunity.t423'/>");
					return;
				}

				if(strListInfo == "") {
					alert("<spring:message code='ezCommunity.t427'/>");
					return;
				}
				
				var ret = confirm("<spring:message code='ezCommunity.t428'/>");
				
				if(ret)	{
					var arrList = new Array();
					var strItemList = "";
					var i=0;
					arrList = strListInfo.split(";");
					
					for(i=0;i<arrList.length-1;i++) {
						strItemList += arrList[i].split(",")[0] + ";";
					}
					
					arrList = null;		
				
					var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/ezCommunity/setRead.do?boardID=" + pBoardID + "&itemIDList=" + strItemList, false);
					xmlhttp.send();
					xmlhttp = null;
					refresh_onclick();
				}
			}

			function MemberInfo_onclick(pUserID) {
			    var feature = "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 438);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
			}

			document.onselectstart = function () {
			};

			function SortPage(pSortBy) {
// 				window.location.href = "/ezCommunity/searchBoardItem.do?page=" + CurPage + "&boardID=" + pBoardID + "&pBoardName=" + pBoardName + "&sortBy=" + SortBy + "&code=" + code;
			}

			function refresh_onclick() {
				window.location.reload(false);
			}


			function CopyItem_onclick() {
				if (Read_FG != "true") {
			        alert("<spring:message code='ezCommunity.t202'/>");
			        return;
			    }
			    
				if(strListInfo == "") {
					alert("<spring:message code='ezCommunity.t430'/>");
					return;
				}

				if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
					alert("<spring:message code='ezCommunity.t431'/>");
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
				
				var pheigth = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				pheigth = parseInt(pheigth) / 2;
				pwidth = parseInt(pwidth) / 2;
				pheigth = pheigth - 200;
				pwidth = pwidth - 127;

				window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + strItemList + "&boardID=" + pBoardID +"&code=" + code, "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth,"");		
			}

			function BoardItemList() {
				window.location.href = "/ezCommunity/boardItemList.do?" + pOrgBoardParameters;
			}
			
			function Print_onclick() {
				var title = document.getElementById("txtTitle").value;
				var writerName = document.getElementById("txtWriterName").value;
				var strAbstract = document.getElementById("txtAbstract").value;
				var searchStart = document.getElementById("idDatepicker").value;
				var searchEnd = document.getElementById("_D2").value;
			
				var url = "/ezCommunity/searchBoardItemPrint.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + pBoardID;
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				
				window.open(url, "", "top=0, left=0, height=760px, width=1000px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1");
			}
			
			function initdatepicker() {
			    var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
			    idDatepicker.elemDateButtons = "img_StartCalDisp;img_EndCalDisp";
			    idDatepicker.elemDateInputs = "idDatepicker;_D2";
			    idDatepicker.elemTimeButtons = "img_StartTime;img_EndTime";
			    idDatepicker.elemTimeInputs = "_T1;_T2";
			    idDatepicker.popupType = "both";
			    idDatepicker.pickerDateFormat = "[yyyy]<spring:message code = 'ezCommunity.t435'/>";
			    idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
			    idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
			    idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
			    idDatepicker.firstDayOfWeek = "0";
			    idDatepicker.textAM = "<spring:message code = 'ezCommunity.t436'/>";
			    idDatepicker.textPM = "<spring:message code = 'ezCommunity.t437'/>";
			    idDatepicker.textDecimal = ".";
			    idDatepicker.textHoursAbbrev = "<spring:message code = 'ezCommunity.t438'/>";
			    idDatepicker.textMustSpecifyValidTime = "<spring:message code = 'ezCommunity.t439'/>";
			    idDatepicker.daynameLetters = "<spring:message code = 'ezCommunity.t440'/>";
			    idDatepicker.daynamesShort = "<spring:message code = 'ezCommunity.t440'/>";
			    idDatepicker.daynamesLong = "<spring:message code = 'ezCommunity.t441'/>";
			    idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
			    idDatepicker.monthnamesLong = "1<spring:message code = 'ezCommunity.t442'/>";
			    idDatepicker.isoDateUTF = "${startDateTime}";
			    idDatepicker.isoEndDateUTF = "${endDateTime}";
			    idDatepicker.ready();
			}
		</script>
	</head>
	
	<body class = "cmhome_body">
		<h1 class = "type1_h1"><spring:message code='ezCommunity.t415'/><span id = "mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
				<li><span onClick="SetRead_onclick()"><spring:message code='ezCommunity.t915'/></span></li>
				<li><span onClick="DeleteItem_onclick()"><spring:message code='ezCommunity.t208'/></span></li>
				<li><span onClick="CopyItem_onclick()"><spring:message code='ezCommunity.t911'/></span></li>
				<li><span onClick="Print_onclick()"><spring:message code='ezCommunity.t951'/></span></li>
				<li><span onClick="refresh_onclick()"><spring:message code='ezCommunity.t912'/></span></li>
				<li><span onClick="BoardItemList()"><spring:message code='ezCommunity.t987'/></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content">
			<tr>
				<th><spring:message code='ezCommunity.t419'/></th>
				<td>${boardName}</td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t138'/></th>
				<td><input type="text" id="txtWriterName" style="width:100px" value="${writerName}"></td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t124'/></th>
				<td><input type="text" id="txtTitle" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="${title}"></td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t433'/></th>
				<td><input type="text" id="txtAbstract" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="${abstracts}"></td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t434'/></th>
				<td>
				<input type="text" id="Sdatepicker" style="width:80px;text-align:center"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center">
				<a class="imgbtn"><span onClick= "btn_PostDate_Clear()" popupLocation='bottomright'><spring:message code='ezCommunity.t444'/></span></a><a class="imgbtn"><span onClick="search()"><spring:message code='ezCommunity.t31'/></span></a></td>
			</tr>
			
			<table class="mainlist" style="margin-top:3px;width:100%">
				<form id = "listXML" name="frmOutbox" action="/ezCommunity/boardItemList.do" method="post">
					<tr>
					    <th style="padding:0" align="center" width="20"><input type='checkbox' name="checkbox" onclick='checkBox_checkAll()'></th>
					    <c:choose>
							<c:when test="${pSortBy == 'A.Title'}">
					    		<th style="cursor:pointer" onClick="SortPage('A.Title desc')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:when test="${pSortBy == 'A.Title desc'}">
					    		<th style="cursor:pointer" onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:otherwise>
					    		<th style="cursor:pointer" onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/></th>
					    	</c:otherwise>
					    </c:choose>
					    
					    <c:if test="${boardInfo.gubun == '1' }">
					    	<c:choose>
					    		<c:when test="${pSortBy == 'A.WriterCompanyName' }">
					    			<th style="cursor:pointer" width="100px" onClick="SortPage('A.WriterCompanyName desc')"><spring:message code='ezCommunity.t270'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    		</c:when>
					    		<c:when test="${pSortBy == 'A.WriterCompanyName desc' }">
					    			<th style="cursor:pointer" width="100px" onClick="SortPage('A.WriterCompanyName')"><spring:message code='ezCommunity.t270'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    		</c:when>
					    		<c:otherwise>
					    			<th style="cursor:pointer" width="100px" onClick="SortPage('A.WriterCompanyName')"><spring:message code='ezCommunity.t270'/></th>
					    		</c:otherwise>
					    	</c:choose>
					    </c:if>
					    
					    <c:if test="${boardInfo.gubun != '2' }">
					    	<c:choose>
					    		<c:when test="${pSortBy == 'A.WriterDeptName' }">
					    			<th style="cursor:pointer" width="80px" onClick="SortPage('A.WriterDeptName desc')"><spring:message code='ezCommunity.t241'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    		</c:when>
					    		<c:when test="${pSortBy == 'A.WriterDeptName desc' }">
					    			<th style="cursor:pointer" width="80px" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    		</c:when>
					    		<c:otherwise>
					    			<th style="cursor:pointer" width="80px" onClick="SortPage('A.WriterDeptName')"><spring:message code='ezCommunity.t241'/></th>
					    		</c:otherwise>
					    	</c:choose>
					    </c:if>
					    
					    <c:choose>
					    	<c:when test="${pSortBy == 'A.WriterName' }">
					    		<th style="cursor:pointer" width="80px" onClick="SortPage('A.WriterName desc')"><spring:message code='ezCommunity.t445'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:when test="${pSortBy == 'A.WriterName desc' }">
					    		<th style="cursor:pointer" width="80px" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:otherwise>
					    		<th style="cursor:pointer" width="80px" onClick="SortPage('A.WriterName')"><spring:message code='ezCommunity.t445'/></th>
					    	</c:otherwise>
					    </c:choose>
					    
					    <c:choose>
					    	<c:when test="${pSortBy == 'A.ParentWriteDate' }">
					    		<th style="cursor:pointer" width="80px" onClick="SortPage('A.ParentWriteDate desc')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:when test="${pSortBy == 'A.ParentWriteDate desc' }">
					    		<th style="cursor:pointer" width="80px" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:otherwise>
					    		<th style="cursor:pointer" width="80px" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/></th>
					    	</c:otherwise>
					    </c:choose>
					    
					    <c:choose>
					    	<c:when test="${pSortBy == 'A.Attachments' }">
					    		<th style="cursor:pointer" width="50px" onClick="SortPage('A.Attachments desc')"><spring:message code='ezCommunity.t172'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:when test="${pSortBy == 'A.Attachments desc' }">
					    		<th style="cursor:pointer" width="23px" onClick="SortPage('A.Attachments')"><img src="/images/file.gif" width="13" height="12"><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:otherwise>
					    		<th style="cursor:pointer" width="23px" onClick="SortPage('A.Attachments')"><img src="/images/file.gif" width="13" height="12"></th>
					    	</c:otherwise>
					    </c:choose>
					    
					    <c:choose>
					    	<c:when test="${pSortBy == 'A.ReadCount' }">
					    		<th style="cursor:pointer" width="50px" onClick="SortPage('A.ReadCount desc')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:when test="${pSortBy == 'A.ReadCount desc' }">
					    		<th style="cursor:pointer" width="50px" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
					    	</c:when>
					    	<c:otherwise>
					    		<th style="cursor:pointer" width="50px" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/></th>
					    	</c:otherwise>
					    </c:choose>
					    
					</tr>
					
				</form>
			</table>
		</table>
		<div id="tblPageRayer"></div>
		<div id="ListInfo" style="display:none">${ListInfo}</div>
	</body>
</html>