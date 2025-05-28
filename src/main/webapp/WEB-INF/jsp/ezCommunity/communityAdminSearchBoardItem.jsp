<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
        
        <script type="text/javascript">
	        var pOrgBoardParameters = "${orgBoardParameters}";
	        var searchStart = "${searchStart}";
	        var searchEnd = "${searchEnd}";
			var pBoardID = "${boardID}";
			var pBoardName = "${boardName}";
			var ParentBoardID = "${parentBoardID}";
			var BoardGroupID = "${boardGroupID}";
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName1}";
			var CurPage = "${pPage}";
			var totalPage = "${totalPage}";
			var strListInfo = "";
			var	Access_FG = "${boardInfo.access_FG}";
			var	BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
			var	ListView_FG = "${boardInfo.listView_FG}";
			var	Read_FG = "${boardInfo.read_FG}";
			var	Write_FG = "${boardInfo.write_FG}";
			var	Reply_FG = "${boardInfo.reply_FG}";
			var	Delete_FG = "${boardInfo.delete_FG}";
			var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
	        var xmlhttp = createXMLHttpRequest();
			var code = "${code}";
	        var iMenuNum = 7;
	        var gubun = "${boardInfo.gubun}";
	        //2018-07-09 김보미
	        var ListInfo = "";
	        
			window.onload = function() {
			    var boardname = "${boardName}";
			    
			    if (boardname != "") {
			        document.getElementById("txtBoardName").value = boardname;
			    }
			    
				if(searchStart == "") {
					btn_PostDate_Clear();
				}
	
				makePageSelPage();
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
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadFlag") != "0") {
						bTag = "";
					} else {
						bTag = "<B>";
					}
					
					
					listXML += "<tr id='rowdata'>";
					listXML += "<td style='padding:0'><input type='checkbox' name='chk' id='chk"+i+"' onclick='checkBox_checked(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID").trim() + "\", event)'></td>";
					listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardName").trim() + "</td>";
					listXML += "<td title='" + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Abstract").trim().replace("'", "`")) + "' style='cursor:pointer;text-overflow:ellipsis; overflow:hidden; word-break:break-all' onclick='ItemRead_onclick(\"" + pBoardID + "\", \"" + pBoardName + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "\", \"" + bTag + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", event)'><nobr>"
						+ bTag + strEmergent + strSpace + MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Title").trim()) + "</nobr></td>";
					listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptName").trim() + "</td>";
					listXML += "<td><div style='cursor:pointer' onclick='MemberInfo_onclick(\"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "\", \"" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterDeptID").trim() + "\")'>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterName").trim() + "</div></td>";
		    		listXML += "<td>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriteDate").split(' ')[0] + "</td>";
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "Attachments").trim() != "0") {
						listXML += "<td><img src='/images/i_save01.gif'></td>";
					} else {
						listXML += "<td></td>";
					}
					
					if (SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") == ""){
						listXML += "<td align=center>0</td>";
					} else {
						listXML += "<td align=center>" + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ReadCount") + "</td>";
					}
					
					listXML += "</tr>";
					
					ListInfo += SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "ItemID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "WriterID").trim() + "," + SelectSingleNodeValue(SelectNodes(xmldoc,"NODES/NODE")[i], "BoardID").trim() + ";";
    			}
    			
				$('.mainlist tbody').html();
    			$('.mainlist tbody').append(listXML);
    			
    			
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

			    NowDate = new Date(searchStart.substring(0, 4), searchStart.substring(5, 7), searchStart.substring(8, 10), searchStart.substring(11, 13), searchStart.substring(14, 16));
			    NowDate.setMonth(NowDate.getMonth() - 1);
	
			    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Sdatepicker").datepicker('setDate', NowDate);
	
			    var NowDate2 = new Date(searchEnd.substring(0, 4), searchEnd.substring(5, 7), searchEnd.substring(8, 10), searchEnd.substring(11, 13), searchEnd.substring(14, 16));
			    NowDate2.setMonth(NowDate2.getMonth() - 1);
			    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Edatepicker").datepicker('setDate', NowDate2);
			});
		    
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
	
			function btn_PostDate_Clear() {
			    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Sdatepicker").datepicker('setDate', "");
			    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Edatepicker").datepicker('setDate', "");
			}
	
			function search() {
			    if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
			        alert("<spring:message code = 'ezSystem.x0035' />");
					return;
			    }
			    
	            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
					alert("<spring:message code = 'ezSystem.x0036' />");
			        return;
			    }
	            
	            if (new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
	                alert("<spring:message code = 'ezCommunity.t1459' />");
			        return;
			    }
				
				var title = document.getElementById("txtTitle").value;
				var writerName = document.getElementById("txtWriterName").value;
				var strAbstract = document.getElementById("txtAbstract").value;
				var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var boardname = document.getElementById("txtBoardName").value;
	
				if (boardname == "") {
				    alert("<spring:message code = 'ezCommunity.t289' />");
				    return;
				}
				
				if (title == "" && writerName == "" && strAbstract == "" && searchStart == "" && searchEnd == "") {
					alert("<spring:message code = 'ezCommunity.t422' />");
					return;
				}
				
				/* 2019-01-10 홍승비 - 커뮤니티 게시판그룹 대상으로 검색 시 경고문구 발생하도록 수정 */
				if (getParentBoardID(pBoardID) == "top") {
					alert("<spring:message code = 'ezCommunity.t356' />");
					return;
				}
				
				var url = "/ezCommunity/adminSearchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(strAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&code=" + code;
				url += "&boardname=" + encodeURIComponent(boardname);
				url += "&gubun=" + gubun;
				
				window.location.href = url;
			}
	
			function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID, pUserID, ee) {
				if(Read_FG != "true") {
					alert("<spring:message code = 'ezCommunity.t423' />");
					return;
				}
				
			    if (CrossYN()) {
			        var e = ee.target;
			        var eText = e.outerHTML;
	            } else {
			        var e = event.srcElement;
			        var eText = e.outerHTML;
			    }
			    
				if (eText.substring(0, 3) == "<B>") {
					e.outerHTML = eText.substring(3, eText.length);
				}
	
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 765) / 2;
				
				if (CrossYN()) {
				    if (gubun == "3") {
				        window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=1&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
				    } else {
				    	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(code), "", 750, 721);
				    }
				} else {
			        if (gubun == "3") {
			            window.open("/ezCommunity/boardItemViewPhoto.do?showAdjacent=1&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
			        } else {
			        	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(code), "", 750, 721);
			        }
				}
			}
	
			function checkBox_checked(pItemID, pUserID, pBoardID, e) {
			    if (CrossYN()) {
			        if (e.target.checked) {
			            strListInfo += pItemID + "," + pUserID + "," + pBoardID + ";";
			        } else {
			            strListInfo = ReplaceText(strListInfo, pItemID + "," + pUserID + "," + pBoardID + ";", "");
			        }
			    } else {
			        if (window.event.srcElement.checked) {
			            strListInfo += pItemID + "," + pUserID + "," + pBoardID + ";";
			        } else {
			            strListInfo = ReplaceText(strListInfo, pItemID + "," + pUserID + "," + pBoardID + ";", "");
			        }
			    }
			}
	
			function checkBox_checkAll() {
			    var i = 0;
			    
			    for (; i < document.getElementsByName("chk").length; i++) {
			        if (document.getElementById("checkbox").checked) {
			            document.getElementById("chk" + i).checked = true;
			            
			            if (CrossYN()) {
			            	//2018-07-09 김보미
 			                //strListInfo = ListInfo.textContent;
							strListInfo = ListInfo;
			            } else {
			                strListInfo = ListInfo.innerText;
			            }
			        } else {
			            document.getElementById("chk" + i).checked = false;
			            strListInfo = "";
			        }
			    }
			}
	
			function DeleteItem_onclick() {	
				if(strListInfo == "") {
					alert("<spring:message code = 'ezCommunity.t424' />");
					return;
				}
	
				if(CheckIfHasReplies()) {
					alert("<spring:message code = 'ezCommunity.t425' />");
					return;
				}
				
				var ret = confirm("<spring:message code = 'ezCommunity.t426' />");
				
				if(ret)	{
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
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + encodeURIComponent(strListInfo), false);
				xmlhttp.send();
				xmlhttp = null;
				window.location.reload();
			}
	
			function ReplaceText( orgStr, findStr, replaceStr ) {
				var re = new RegExp( findStr, "gi" );
				return ( orgStr.replace( re, replaceStr ) );
			}
	
			function CheckOwnerShip() {
				var arrList = new Array();
				var i=0;
	
				arrList = strListInfo.split(";");
				
				for(i=0;i<arrList.length-1;i++) {
					if(arrList[i].split(",")[1] != SSUserID) {
						arrList = null;	
						return false;
					}		
				}
				
				arrList = null;
				return true;
			}
	
			function prevPage_onclick() {
				newPage = parseInt(CurPage) - 1;
				
				var title = document.getElementById("txtTitle").value;
				var writerName = document.getElementById("txtWriterName").value;
				var txtAbstract = document.getElementById("txtAbstract").value;
				var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var boardname = document.getElementById("txtBoardName").value;
	
				var url = "/ezCommunity/adminSearchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(txtAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&code=" + code;
				url += "&boardname=" + encodeURIComponent(boardname);
				url += "&page=" + newPage.toString();
				url += "&gubun=" + gubun;
	
				if (boardname == "") {
				    alert("<spring:message code = 'ezCommunity.t289' />");
	                return;
				}
	
				if(newPage > 0) {
					window.location.href = url;
				}
			}
	
			function nextPage_onclick() {
				newPage = parseInt(CurPage) + 1;
				
				var title = document.getElementById("txtTitle").value;
				var writerName = document.getElementById("txtWriterName").value;
				var txtAbstract = document.getElementById("txtAbstract").value;
				var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var boardname = document.getElementById("txtBoardName").value;
	
				var url = "/ezCommunity/adminSearchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(txtAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&code=" + code;
				url += "&boardname=" + encodeURIComponent(boardname);
				url += "&page=" + newPage.toString();
				url += "&gubun=" + gubun;
	
				if (boardname == "") {
				    alert("<spring:message code = 'ezCommunity.t289' />");
	                return;
				}
	
				if(newPage <= parseInt(totalPage)) {
					window.location.href = url;
				}
			}
	
			/* 2019-02-19 홍승비 - 페이징 변수명 수정 */
	        function moveToPage(CurPage) {
				//if(window.event.keyCode == 13)
				//{
				//	var newPage = txt_PageInputNum.value;	
	            //}
				var title = document.getElementById("txtTitle").value;
				var writerName = document.getElementById("txtWriterName").value;
				var txtAbstract = document.getElementById("txtAbstract").value;
				var searchStart = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var searchEnd = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var boardname = document.getElementById("txtBoardName").value;
				
				var url = "/ezCommunity/adminSearchBoardItem.do?orgBoardParameters=" + encodeURIComponent(pOrgBoardParameters);
				url += "&boardID=" + encodeURIComponent(pBoardID);
				url += "&title=" + encodeURIComponent(title);
				url += "&writerName=" + encodeURIComponent(writerName);
				url += "&abstract=" + encodeURIComponent(txtAbstract);
				url += "&searchStart=" + searchStart;
				url += "&searchEnd=" + searchEnd;
				url += "&code=" + code;
				url += "&boardname=" + encodeURIComponent(boardname);
				url += "&page=" + CurPage.toString();
				url += "&gubun=" + gubun;
				
				if (boardname == "") {
				    alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}
				
	            if (parseInt(CurPage) > 0 && parseInt(CurPage) <= parseInt(totalPage)) {
	                window.location.href = url;
	            }
			}
	        
    		/* 2018-10-02 홍승비 - 커뮤니티 게시물 리스트 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
			function MemberInfo_onclick(pUserID, pDeptID) {
				var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
			    feature = feature + GetOpenPosition(420, 450);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
			}
	
			document.onselectstart = function () {
				window.event.cancelBubble = true;
			    window.event.returnValue = false;
			}
	
			function refresh_onclick() {
				window.location.reload(false);
			}
	
	
			function MoveItem_onclick() {
				if(strListInfo == "") {
					alert("<spring:message code = 'ezCommunity.t430' />");
					return;
				}
	
				if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && CheckOwnerShip() == false) {
					alert("<spring:message code = 'ezCommunity.t431' />");
					return;
				}
	
				var arrList = new Array();
				var strItemList = "";
				var strBoardList = "";
				var i=0;
	
				arrList = strListInfo.split(";");
				
				for(i=0;i<arrList.length-1;i++) {
					strItemList += arrList[i].split(",")[0] + ";";
				}
				
				arrList = null;
				arrList = strListInfo.split(";");
				
				for(i=0;i<arrList.length-1;i++) {
					strBoardList += arrList[i].split(",")[2] + ";";
				}
				
				arrList = null;		
				
				var pheigth = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				pheigth = parseInt(pheigth) / 2;
				pwidth = parseInt(pwidth) / 2;
				pheigth = pheigth - 200;
				pwidth = pwidth - 127;
				
				window.open("/ezCommunity/moveBoardItem.do?itemIDList=" + encodeURIComponent(strItemList) + "&boardIDList=" + encodeURIComponent(strBoardList), "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth,"");		
			}
	
			var boardselect_dialogArguments = new Array();
			
			function SelectBoard() {
			    if (CrossYN()) {
			        boardselect_dialogArguments[1] = SelectBoard_Complete;
			        var OpenWin = GetOpenWindow("/ezCommunity/boardSelect.do?code=" + code, "BoardSelect", 355, 600);
			        try { OpenWin.focus(); } catch (e) { }
			    } else {
			        var feature = "DialogHeight:600px;DialogWidth:355px;scroll:no;status:no;help:no;edge:sunken";
			        feature = feature + GetShowModalPosition(355, 600);
			        var ret = window.showModalDialog("/ezCommunity/boardSelect.do?code=" + code, "", feature);
			        
			        if (typeof (ret) != "undefined") {
			            pBoardID = ret[0];
			            txtBoardName.value = ret[2];
			            getParentBoardID(pBoardID);
			        }
			    }
			}
	
			function SelectBoard_Complete(ret) {
			    pBoardID = ret[0];
			    txtBoardName.value = ret[2];
			    getParentBoardID(pBoardID);
			}
			
			/* 2019-01-10 홍승비 - 커뮤니티 게시판정보 가져오는 함수 제거(컨트롤러에 구현 안됨), 게시판그룹여부 체크하는 함수 추가 */
		    function getParentBoardID(pBoardID) {
				var result = "";
				
		    	  $.ajax({
						type : "GET",
						dataType : "text",
						async : false,
						url : "/ezCommunity/getParentBoardID.do",
						data : {
							boardID : pBoardID
						},
						success: function(text){
							result = text;
						}
					});
		    	  return result;
		    }
			
			function OpenRightMenu(pIndex) {
				if (pBoardID == "" && pIndex == 6) {
					alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}
	
				curMenuIndex = pIndex;
	
				if (pBoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code = 'ezCommunity.t289' />");
					return;
				}
				
				if (pBoardID == ParentBoardID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code = 'ezCommunity.t290' />");
					return;
				}
	
				switch(pIndex) {
					case 1:		
						window.location.href = "/ezCommunity/boardProperty.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 2:		
					    window.location.href = "/ezCommunity/boardCreate.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 3:		
						window.location.href = "/ezCommunity/boardACL.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
				    case 4:
				        window.location.href = "/ezCommunity/boardOrder.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
				        break;
				    case 5:		
				        if (pBoardID == BoardGroupID) {
				            alert("<spring:message code = 'ezCommunity.t377' />");
				        } else {
				            window.location.href = "/ezCommunity/boardMove.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
				        }
				        
				        break;
					case 6:		
						window.location.href = "/ezCommunity/boardDelete.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 7:		
						window.location.href = "/ezCommunity/adminSearchBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
					case 9:		
						window.location.href = "/ezCommunity/boardGroupCreate.do?boardID=" + encodeURIComponent(pBoardID) + "&parentBoardID=" + encodeURIComponent(ParentBoardID) + "&boardGroupID=" + encodeURIComponent(BoardGroupID) + "&code=" + code;
						break;
						
					default:
						break;		
				}
			}
			
			function searchBoard_onclick() {
			    var feature = "DialogHeight:470px;DialogWidth:340px;status:no;help:no;edge:sunken";
			    feature = feature + GetShowModalPosition(340, 470);
			    var ret = window.showModalDialog("/ezCommunity/searchBoard.do", "", feature);
			    
				if(typeof(ret) == "undefined") {
				} else {
					var spans = TopBoardsList.all.tags("span");
					
					for (var i=0; i<spans.length; i++) {
						if(spans.item(i).id == ret[1]) {
							loadTreeViewByPath(spans.item(i), ret[0], ret[1], ret[2], ret[3]);
						}
					}
				}
			}
	
			function loadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID, pBoardName, pParentBoardID) {
				var divs = TopBoardsList.all.tags("DIV");
				
				for (var i=0; i<divs.length; i++) {
					if(divs.item(i).parentElement.parentElement.id == "TreeArea") {
						divs.item(i).parentElement.parentElement.style.display = "none";
					}
				}
	
				pObjSpan.parentElement.parentElement.nextSibling.style.display = "";
				var TreeCtrl = pObjSpan.parentElement.parentElement.nextSibling.firstChild.firstChild;
				
				TreeCtrl.server = SS_ServerName;
				TreeCtrl.config = xmlDom_treeview;
				TreeCtrl.source = GetBoardTreeByPath(pBoardID, pBoardGroupID);
				TreeCtrl.update();
	
				SelectedBoardID = pBoardID;
				SelectedBoardName = pBoardName;
				SelectedBoardParentBoardID = pParentBoardID;
				SelectedBoardGroupID = pBoardGroupID;
	
				window.location.href = "/ezCommunity/boardProperty.do?boardID=" + encodeURIComponent(SelectedBoardID);
			}
		
	        function onkey_down() {
	            if(window.event.keyCode == 13) {
	                search();
	            }
	        }
	
	    	var BlockSize = 10;
	    	
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + "${totalCount}" + "</span>";
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
		        moveToPage(CurPage);
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
		</script>
	</head>
	<body class="mainbody" style="min-width:1040px; margin:0; padding:0 10px 10px;">
		<h1><spring:message code = 'ezCommunity.t432' /> <span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
			    <li><span onClick="OpenRightMenu(1)"><spring:message code = 'ezCommunity.t291' /></span></li>
			    <li><span onClick="OpenRightMenu(9)"><spring:message code = 'ezCommunity.t297' /></span></li>
			    <li><span onClick="OpenRightMenu(2)"><spring:message code = 'ezCommunity.t324' /></span></li>
			    <li><span onClick="OpenRightMenu(4)"><spring:message code = 'ezCommunity.t294' /></span></li>
			    <li><span onClick="OpenRightMenu(5)"><spring:message code = 'ezCommunity.t295' /></span></li>
			    <li><span onClick="OpenRightMenu(6)"><spring:message code = 'ezCommunity.t208' /></span></li>
			    <li><span onClick="OpenRightMenu(7)"><spring:message code = 'ezCommunity.t296' /></span></li>
			    <li style="display:none"><span onClick="OpenRightMenu(3)"><spring:message code = 'ezCommunity.t293' /></span></li>
		  	</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content" style="margin-top:10px">
			<tr>
			    <th><spring:message code = 'ezCommunity.t418' /></th>
			    <td><input type="text" id="txtBoardName" readonly ="readonly" style="width:200px">
			      <a class="imgbtn"><span onClick="SelectBoard()"><spring:message code = 'ezCommunity.t352' /></span></a></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezCommunity.t138' /></th>
			    <td><input type="text" id="txtWriterName" style="width:100px" onkeydown="return onkey_down()" value="<c:out value='${writerName}'/>"></td>
		  	</tr>
		 	<tr>
			    <th  ><spring:message code = 'ezCommunity.t124' /></th>
			    <td><input type="text" id="txtTitle" style="width:400px" onkeydown="return onkey_down()"  value="<c:out value='${title}'/>"></td>
		 	</tr>
		  	<tr>
			    <th  ><spring:message code = 'ezCommunity.t433' /></th>
			    <td><input type="text" id="txtAbstract" style="width:400px" onkeydown="return onkey_down()" value="<c:out value='${abstracts}'/>"></td>
		  	</tr>
		  	<tr>
			    <th  ><spring:message code = 'ezCommunity.t434' /></th>
			    <td>
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly></span> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly></span> &nbsp;&nbsp; <a class="imgbtn"><span onClick= "btn_PostDate_Clear()"><spring:message code = 'ezCommunity.t444' /></span></a>&nbsp;<a class="imgbtn"><span onClick="search()"><spring:message code = 'ezCommunity.t31' /></span></a>&nbsp;<a class="imgbtn" name="Submit2" onClick="javascript:DeleteItem_onclick()"><span><spring:message code = 'ezCommunity.t208' /></span></a>
				</td>
		  	</tr>
		</table>
		
		<form name="frmOutbox" method="post">
			<table class="mainlist" style="width:100%;margin-top:10px">
				<tr>
				    <th style="width:20px;padding:0px" align="center"><input type='checkbox' id ="checkbox" name="checkbox" onclick='checkBox_checkAll()'></th>
				     <c:choose>
						<c:when test="${pSortBy == 'BoardName'}">
				    		<th style="cursor:pointer;width:80px;" onClick="SortPage('BoardName desc')"><spring:message code='ezCommunity.t418'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:when test="${pSortBy == 'BoardName desc'}">
				    		<th style="cursor:pointer;width:80px;" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:otherwise>
				    		<th style="cursor:pointer;width:80px;" onClick="SortPage('BoardName')"><spring:message code='ezCommunity.t418'/></th>
				    	</c:otherwise>
				    </c:choose>
				    
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
				    		<th style="cursor:pointer;width:80px;" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:otherwise>
				    		<th  style="cursor:pointer;width:80px;" onClick="SortPage('A.ParentWriteDate')"><spring:message code='ezCommunity.t209'/></th>
				    	</c:otherwise>
				    </c:choose>
				    
				    <c:choose>
				    	<c:when test="${pSortBy == 'A.Attachments' }">
				    		<th style="cursor:pointer;width:20px;" onClick="SortPage('A.Attachments desc')"><img src="/images/file.gif"><img src="/images/view-sortup.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:when test="${pSortBy == 'A.Attachments desc' }">
				    		<th style="cursor:pointer;width:20px;" onClick="SortPage('A.Attachments')"><img src="/images/file.gif"><img src="/images/view-sortdown.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:otherwise>
				    		<th style="cursor:pointer;width:20px;" onClick="SortPage('A.Attachments')"><img src="/images/file.gif"></th>
				    	</c:otherwise>
				    </c:choose>
				    
				    <c:choose>
				    	<c:when test="${pSortBy == 'A.ReadCount' }">
				    		<th style="cursor:pointer;width:45px;" onClick="SortPage('A.ReadCount desc')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortup.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:when test="${pSortBy == 'A.ReadCount desc' }">
				    		<th style="cursor:pointer;width:45px;" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/><img src="/images/view-sortdown.gif" width="9" height="9"></th>
				    	</c:when>
				    	<c:otherwise>
				    		<th style="cursor:pointer;width:45px;" onClick="SortPage('A.ReadCount')"><spring:message code='ezCommunity.t173'/></th>
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
		</form>
	    <br/>
	    <div id="tblPageRayer"></div>
		<div id="ListInfo" style="DISPLAY:none">${listInfo }</div>
	</body>
</html>