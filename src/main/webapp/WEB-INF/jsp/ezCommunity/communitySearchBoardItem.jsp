<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>SearchBoardItem</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/community.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<!-- 		data picker -->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
        <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
        <!-- time picker-->
        <script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
        <link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}"/>       
        <style>
			#rowdata td, #rowdata td div {
        		white-space: nowrap;
        		text-overflow: ellipsis;
        		overflow:hidden;
        	}
        </style>
        
		<script type="text/javascript">
	        var pOrgBoardParameters = "<c:out value='${orgBoardParameters}' />";
	        pOrgBoardParameters = pOrgBoardParameters.replace(/&amp;/g, '&');
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
		    var ListInfo = "";
		    var inviteFlag = "<c:out value='${inviteFlag}' />";

		    if ("${userInfo.lang}" == '1') {
		    	pBoardName = "<c:out value='${boardInfo.boardName}' />";
		    } else {
		    	pBoardName = "<c:out value='${boardInfo.boardName2}' />";
		    }
		    
		    $(function () {
		    	var xmldoc = loadXMLString('${strXML}');
    			var listXML = '';
    			
    			for (var i = 0; i < SelectNodes(xmldoc,"NODES/NODE").length; i++) {
					var strSpace = '';
					var strEmergent = '';
					var bTag = '';
					var urgency = "";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Importance") == "1") {
						/* strEmergent = "<img src='/images/i_urgency.gif'>&nbsp;"; */
						urgency = "urgency";
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
					listXML += "<td width=20 align=center valign=middle style='padding:0'><div class='custom_checkbox'><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", event)'></div></td>";
					listXML += "<td class='"+ urgency +"' title='" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`")) + "' style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "\", \"" + bTag + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", event)'><nobr>"
						+ bTag + strEmergent + strSpace + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title").trim()) + "</nobr></td>";

					if (gubun == "1") {
						listXML += "<td class='"+ urgency +"'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterCompanyName").trim() + "</td>";
					}
					
					if (gubun != "2") {
						listXML += "<td class='"+ urgency +"'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptname").trim() + "</td>";
					}
					
					if (gubun == "2") {
						listXML += "<td class='"+ urgency +"'><div style='cursor:pointer'>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim()) + "</div></td>";
					} else {
						listXML += "<td class='"+ urgency +"'><div style='cursor:pointer' onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptID").trim() + "\")'>" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim()) + "</div></td>";
					}

					listXML += "<td class='"+ urgency +"'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</td>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						listXML += "<td><img src='/images/i_save01.gif'></td>";
					} else {
						listXML += "<td></td>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") == ""){
						listXML += "<td class='"+ urgency +"' align=center>0</td>";
					} else {
						listXML += "<td class='"+ urgency +"' align=center>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") + "</td>";
					}
					
					listXML += "</tr>";
					
					ListInfo += SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + ";";
    			}
    			
    			$('.cmhomelist').html($('.cmhomelist tbody').html() + listXML);
    			
    			makePageSelPage();
    			
			    $("#Sdatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
			    });
			    
			    $("#Edatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
			    });
			    var settime;
			    var NowDate;
			    
			    if (searchStart != "") {
			    	NowDate = new Date(searchStart.substring(0, 4), searchStart.substring(5, 7), searchStart.substring(8, 10), searchStart.substring(11, 13), searchStart.substring(14, 16));
			    } else {
			    	NowDate = new Date();
			    }
			    
			    NowDate.setMonth(NowDate.getMonth() - 1);
	
			    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Sdatepicker").datepicker('setDate', NowDate);
	
			    var NowDate2;
			    
			    if (searchEnd != "") {
			    	NowDate2 = new Date(searchEnd.substring(0, 4), searchEnd.substring(5, 7), searchEnd.substring(8, 10), searchEnd.substring(11, 13), searchEnd.substring(14, 16));
			    } else {
			    	NowDate2 = new Date();
			    }
			    
			    NowDate2.setMonth(NowDate2.getMonth() - 1);
			    
			    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Edatepicker").datepicker('setDate', NowDate2);
			    
			    var monthMsg = "<spring:message code='ezSchedule.t110' />";
			    var monthStr = monthMsg.split(";");		    
			    var dayMsg = "<spring:message code='ezSchedule.t108' />";
			    var dayStr = dayMsg.split(";");
			    
			    $(function () {
			        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
			        	closeText: "<spring:message code='main.t3' />",
			            prevText: "<spring:message code='main.t0604' />",
			            nextText: "<spring:message code='main.t0605' />",
						currentText: "<spring:message code='main.t0606' />",
			            monthNames: monthStr,
			            monthNamesShort: monthStr,
			            dayNames: dayStr,
			            dayNamesShort: dayStr,
			            dayNamesMin: dayStr,
			            weekHeader: 'Wk',
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			    });
			    
			    if (searchStart == "") {
			        btn_PostDate_Clear();
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
			        alert("<spring:message code='ezSystem.x0035' />");
			        return;
			    }
			    
			    if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
			    	alert("<spring:message code='ezSystem.x0036' />");
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
			    
			    if(title == "" && writerName == "" && strAbstract == "" && searchStart == "" && searchEnd == ""){
			    	alert("<spring:message code='ezBoard.t192' />");
	                return;
			    }

			    var url = "/ezCommunity/searchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
			    url += "&boardID=" + encodeURIComponent(pBoardID);
			    url += "&title=" + encodeURIComponent(title);
			    url += "&writerName=" + encodeURIComponent(writerName);
			    url += "&abstract=" + encodeURIComponent(strAbstract);
			    url += "&searchStart=" + searchStart;
			    url += "&searchEnd=" + searchEnd;
			    url += "&code=" + code;
			    url += "&inviteFlag=" + inviteFlag;

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
		        	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + code, "", 750, 721);
		        }
		        else {
	                window.open("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=721,width=750,top=" + pTop + ",left=" + pLeft, "");
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
    			for(i=0; i<$("input[name='chk']").length; i++) {
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
    			
    			//보드아이디가 안나옴
			    /* for (var i = 1; i < document.frmOutbox.length; i++) {
			        if (document.frmOutbox[i].type == 'checkbox') {
			            if (document.frmOutbox.checkbox.checked) {
			                document.frmOutbox[i].checked = true;
			                strListInfo = ListInfo.innerText;
			            } else {
			                document.frmOutbox[i].checked = false;
			                strListInfo = "";
			            }
			        }
			    } */
			}
			
			var checkpassword_dialogArguments = new Array();   		
    		function DeleteItem_onclick() {	
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

    			if (Delete_FG != "true") {
    				alert("<spring:message code='ezCommunity.t901' />");
    				return;
    			}
    			
    			if (CheckIfHasReplies()) {
    		        alert("<spring:message code='ezCommunity.t425' />");
                    return;
                }
    			
    		    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
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
		            alert("<spring:message code='ezCommunity.t901' />");
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
				
				if (xmlhttp.responseText == "TRUE") {
		            xmlhttp = null;
		            return true;
		        } else {
			        xmlhttp = null;
			        return false;
		        }
			}

			function DeleteItem() {
				$.ajax({
					type : 'POST',
					url : '/ezCommunity/deleteItem.do',
					async : false,
					data : {itemList : strListInfo},
					success : function() {
						if (document.getElementById("rowdata") != null && typeof (document.getElementById("rowdata").length) == "undefined" && CurPage != 1) {
							movePage(CurPage);
						} else if (document.getElementById("rowdata") != null && document.getElementById("rowdata").length == strListInfo.split(";").length - 1 && CurPage != 1) {
						    movePage(CurPage);
						} else {
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
						    window.location.reload();
						}
					}
				});
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
			        if (arrList[i].split(",")[1] != SSUserID) {
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
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&page=" + newPage.toString();
				url += "&code=" + code;
				url += "&inviteFlag=" + inviteFlag;

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
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&page=" + newPage.toString();
				url += "&code=" + code;
				url += "&inviteFlag=" + inviteFlag;

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
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&page=" + newPage.toString();
				url += "&code=" + code;
				url += "&inviteFlag=" + inviteFlag;

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
					url += "&boardID=" + encodeURIComponent(pBoardID);
					url += "&title=" + encodeURIComponent(title);
					url += "&writerName=" + encodeURIComponent(writerName);
					url += "&abstract=" + encodeURIComponent(strAbstract);
					url += "&searchStart=" + searchStart;
					url += "&searchEnd=" + searchEnd;
					url += "&page=" + newPage.toString();
					url += "&code=" + code;
					url += "&inviteFlag=" + inviteFlag;

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
					xmlhttp.open("POST", "/ezCommunity/setRead.do?boardID=" + encodeURIComponent(pBoardID) + "&itemIDList=" + encodeURIComponent(strItemList), false);
					xmlhttp.send();
					xmlhttp = null;
					refresh_onclick();
				}
			}
			
			/* 2018-10-02 홍승비 - 커뮤니티 게시물 리스트 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
			function MemberInfo_onclick(pUserID, pDeptID) {
			    var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 450);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
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

				window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardID=" + encodeURIComponent(pBoardID) +"&code=" + code, "", "height=600px,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth,"");		
			}

			function BoardItemList() {
				/* $(location).attr('href', '/ezCommunity/boardItemList.do?' + encodeURIComponent(pOrgBoardParameters)); */
				$(location).attr('href', '/ezCommunity/boardItemList.do?' + pOrgBoardParameters); 
// 				window.location.href = "/ezCommunity/boardItemList.do?" + pOrgBoardParameters;
			}
			
			function Print_onclick() {
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
			
				var url = "/ezCommunity/searchBoardItemPrint.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&strAbstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + encodeURIComponent(searchStart);
				url += "&searchEnd=" + encodeURIComponent(searchEnd);
				
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
			    idDatepicker.isoDateUTF = '<c:out value="${startDateTime}"/>';
			    idDatepicker.isoEndDateUTF = '<c:out value="${endDateTime}"/>';
			    idDatepicker.ready();
			}
		</script>
	</head>
	
	<body class = "cmhome_body">
		<h1 class = "type1_h1"><spring:message code='ezCommunity.t415'/><span id = "mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
				<li><span onClick="BoardItemList()"><spring:message code='ezCommunity.t987'/></span></li>
				<li><span onClick="SetRead_onclick()"><spring:message code='ezCommunity.t915'/></span></li>
				<li><span class="icon16 icon16_delete" onClick="DeleteItem_onclick()"></span></li>
<%-- 				<li><span onClick="CopyItem_onclick()"><spring:message code='ezCommunity.t911'/></span></li> --%>
<%-- 				<li><span onClick="Print_onclick()"><spring:message code='ezCommunity.t951'/></span></li> --%>
				<li><span class="icon16 icon16_refresh" onClick="refresh_onclick()"></span></li>				
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content" style="margin-top:10px">
			<tr>
				<th><spring:message code='ezCommunity.t418'/></th>
				<td>${boardName}</td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t138'/></th>
				<td><input class="inputText" type="text" id="txtWriterName" style="width:100%" value="<c:out value='${writerName}'/>"></td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t124'/></th>
				<td><input class="inputText" type="text" id="txtTitle" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="<c:out value='${title}'/>"></td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t433'/></th>
				<td><input class="inputText" type="text" id="txtAbstract" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" value="<c:out value='${abstracts}'/>"></td>
			</tr>
			<tr>
				<th><spring:message code='ezCommunity.t434'/></th>
				<td>
					<input class="inputText" type="text" id="Sdatepicker" readonly  style="width:80px;text-align:center"> ~ <input class="inputText" type="text" id="Edatepicker" readonly style="width:80px;text-align:center">&nbsp;
					<a class="imgbtn imgbck"><span onClick= "btn_PostDate_Clear()" popupLocation='bottomright'><spring:message code='ezCommunity.t444'/></span></a>&nbsp;<a class="imgbtn imgbck"><span onClick="search()"><spring:message code='ezCommunity.t31'/></span></a>
				</td>
			</tr>
			<table class="cmhomelist" style="margin-top:10px;width:100%">				
				<tr>
					<th style="padding:0" align="center" width="20"><div class='custom_checkbox'><input type='checkbox' name="checkbox" onclick='checkBox_checkAll()'></div></th>
				    <c:choose>
						<c:when test="${pSortBy == 'A.Title'}">
				    		<th style="cursor:pointer; width: 200px;" onClick="SortPage('A.Title desc')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:when test="${pSortBy == 'A.Title desc'}">
				    		<th style="cursor:pointer; width: 200px;" onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:otherwise>
				    		<th style="cursor:pointer; width: 200px;" onClick="SortPage('A.Title')"><spring:message code='ezCommunity.t124'/></th>
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
				    		<th style="cursor:pointer" width="23px" onClick="SortPage('A.Attachments')"><img src="/images/file.gif"><img src="/images/view-sortdown.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:otherwise>
				    		<th style="cursor:pointer" width="23px" onClick="SortPage('A.Attachments')"><img src="/images/file.gif"></th>
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
				
				<c:set var="count" value="${totalCount}" />
				    <c:if test="${count eq 0 }" >
					    <tr>
					    <c:choose>
						<c:when test="${boardInfo.gubun == '1'}">
					    	<td align="center" colspan="8"><spring:message code='ezBoard.t281'/></td>
					    </c:when>
					    <c:when test="${boardInfo.gubun == '2'}">
					    	<td align="center" colspan="6"><spring:message code='ezBoard.t281'/></td>
					    </c:when>
					    <c:otherwise>
					    	<td align="center" colspan="7"><spring:message code='ezBoard.t281'/></td>
					    </c:otherwise>
					    </c:choose>
					    </tr>
				    </c:if>
			</table>
		</table>
		<div id="tblPageRayer" style="margin-top:10px"></div>
		<div id="ListInfo" style="display:none">${ListInfo}</div>
	</body>
</html>
