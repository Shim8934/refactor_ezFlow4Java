<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t570' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<style>
			.pagetd{padding-top:6px; }
	        .pcol{padding-top:6px; }
	        .Right_Point01 {
		        font:bold;
		        color:#017bec;
	        }
			.witterReply td {
				padding-top: 10px;
				height: 24px;
			}
			.editReply {
				border: 1px solid rgb(221, 221, 221);
				width: 97%;
				background: #fff;
			}
			.editSubmit {
				text-align: right;
				padding: 0 20px 10px 0;
			}
			
			.blankSpan{
				margin : 0 10px;
				color:gray;
			}
			
			.contText {
				word-wrap: break-word;
				white-space: pre-wrap;
			} 
		</style>

		<script type="text/javascript">
			var CurPage = '<c:out value="${curPage}" />';
			var totalPage = '<c:out value="${totalPage}" />';
		    var totalCount = '<c:out value="${keywordCount}" />';
		    var code = '<c:out value="${code}" />';
		    var multiData = '<c:out value="${multiData}" />';
			
		    var xmlDoc = loadXMLString('${strXML}');
			var chkId = '<c:out value="${chkId}" />';

		    window.onload = function () {
		        makePageSelPage();
		        
		        var html = "";

		        for(var i = 0; i < SelectNodes(xmlDoc, "DATA/ROW").length; i++) {
		        	html += "<table id='guestRp_" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + "' class=\"content\" style=\"margin-top:10px;margin-bottom:12px;border-left:1px solid #dfdfdf;border-right:1px solid #dfdfdf;\">";
		        	html += "<tr style='border:1px solid #dfdfdf;' >";
		        	html += "<th style='height:25px; border:1px solid #dfdfdf; width:20px;' nowrap><div class='custom_checkbox'><input type='checkbox' name='c_no' value='" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_NO") + "'></div></th>";
		        	/* html += "<th style=\"border-left:1px solid none;border-right:1px solid none;width:50px;\" nowrap>" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_NO") + "</th>"; */
		        	html += "<th style=\"width:90%; text-align:left;border:1px solid #dfdfdf; border-right: 1px solid transparent; font-weight:normal\" >";
		        	
		        	if(SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NEW") == 'NEW') {
		        		html += "<img src=\"/images/i_new.gif\" border=\"0\" hspace=\"5\" align=\"absmiddle\">";
		        	}
		        		
					html += SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "USERNAME"+multiData);
					html += "<spring:message code='ezCommunity.t587' />";
					/* 2019-10-25 홍승비 - 커뮤니티 방명록에서 초단위 삭제 (타 모듈과 통일) */
					var writeDate = SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "WRITEDAY");
					html += writeDate.substring(0, writeDate.length - 3);
					html += " <spring:message code='ezCommunity.t588' /></th>";
					html += "<th style='width:20%;'><a id='replyDisplay" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + "' class='imgbtn replyDisplay' style='vertical-align: middle;'><span onclick='replyLayerDisplay(" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + ")'><spring:message code="ezCommunity.reply.hik01" /></span></a></th>";
					html += "</tr>";
					html += "<tr style=\"border-left:1px solid #dfdfdf;border-right:1px solid #dfdfdf;\">";
					html += "<td  colspan=\"3\" style=\"word-break:break-all; height:100px; border:1px solid #dfdfdf;\">";
					/* 2020-01-16 홍승비 - textarea의 ID 중복 문제 수정 */
					//2018-07-02 김보미 - textarea에 resize:none;추가 / 특수문자 처리 위해 값 비움
 					html += "<textarea style=\"padding:7px;height:100px;width:98%; border:0; overflow-y:auto; resize:none;\" readonly=\"readonly\" id=textarea" + (i + 1) + " name=textarea" + (i + 1) + ">" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "CONTENT").replace(/<br>/gi, "\n").replace(/&dquot;/gi, "\"").replace(/&quot;/gi, "\'") + "</textarea></td>";
//					html += "<textarea style=\"padding:7px;height:100px;width:98%; border:0; overflow-y:auto; resize:none;\" readonly=\"readonly\" id=textarea1 name=textarea1></textarea></td>";
					html += "</tr>";
					html += "</table>";

					// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 추가
					html += "<div style='height:auto;'>";
					html += "<table id='replyLayerTable_" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + "' class='mainlist emoticonLayerStaticPosition' style='width: 100%; display: none'>";
					html += "<tbody><tr>";
					html += "<th style='text-align:left; border: #fff; width: 85%;'>";
					html += "<textarea id='onelinereply"+ SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") +"' rows='2' style='resize:none; margin-left: 10px; margin-top: 4px; width: 95%;' maxLength='300'></textarea>";
					html += "<th style='text-align:center; border: #fff; width: 15%;'>";
					html += '<a class="imgbtn" style="vertical-align: middle"><span onclick="guestOneLineReply(\'new\' ,' + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + ')"><spring:message code="ezBoard.t321" /></span></a>';
					html += '<a class="imgbtn" style="vertical-align: middle; margin-left:5px;"><span onclick="guestOneLineReply(\'cancel\' ,' + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + ')"><spring:message code="ezCommunity.t109" /></span></a>';
					html += "</th>";
					html += "</th>";
					html += "</tr></tbody>";
					html += "</table>";

					if ((SelectNodes(xmlDoc, "DATA/ROW")[i]).getElementsByTagName("C_REPLY")[0]) {
						html += "<table class='witterReply' id='writtenReply_"+ SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") +"' style='margin-top: 10px; width: 100%; border: 1px solid rgb(225, 225, 225);'>";
						for(var j = 0; j < SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2").length; j++) {
							if (j%2 == 0) {
								html += "<tbody>";
							} else {
								html += "<tbody style='background-color: #fafafa'>";
							}

							html += "<tr style='border-top: 1px solid rgb(225, 225, 225);'>";
							html += "<td style='width: 15%; padding-left: 10px; font-weight: bold'>"+ SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "RUSERNAME" + multiData) + "</td>";
							html += "<td style='width: 15%;'>" + (SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "WRITEDATE")).slice(0, 16) + "</td>";
							html += "<td style='text-align: right; padding-right: 15px;'>";

							if (chkId == SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "RUSERID")) {
								html += "<div class='buttonChk' imgbtnid='"+ SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "REPLYID") +"'>";
								html += '<a class="imgbtn" style="vertical-align: middle"><span onclick="guestOneLineReply(\'edit\' ,' + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + ', \'' + SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "REPLYID") + '\')"><spring:message code='ezCommunity.t6' /></span></a>';
								html += '<a class="imgbtn" style="vertical-align: middle; margin-left: 5px;"><span onclick="guestOneLineReply(\'del\' ,' + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NO") + ', \'' + SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "REPLYID") + '\')"><spring:message code='ezCommunity.t208' /></span></a>';
								html += "<div>";
							}

							html += "</td>";
							html += "</tr>";
							html += "<tr>";
							html += "<td replyId="+ SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "REPLYID") + " colspan='3' style='padding: 10px 0 10px 10px;'><span class='contText'>" + SelectSingleNodeValue(SelectNodes(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_REPLY/ROW2")[j], "RCONTENT").replace(/<br>/gi, "\n").replace(/&dquot;/gi, "\"").replace(/&quot;/gi, "\'") + "</span></td>";
							html += "</tr>";
							html += "</tbody>";
						}

						html += "</table>";
					}
					html += "</div>";
		        }
		        
		        if (SelectNodes(xmlDoc, "DATA/ROW").length == 0) {
		        	var strstr = "<img src='/images/kr/main/noData_sIcon.png'><br/><span style='color:#d0d0d0;font-weight:bold'><spring:message code='ezCommunity.t926' /></span>";
		        	html += "<table class=\"content\" style=\"margin-top:10px;margin-bottom:10px;border-left:1px solid #eaeaea;border-right:1px solid #eaeaea;width:100%;height:180px;text-align:center\">";
		        	html += "<tr style=\"border-left:1px solid #eaeaea;border-right:1px solid #eaeaea;\" ><td style='color:#777;background-color:#fafafa;border:1px solid #dfdfdf !important'>" + strstr +"</td></tr></table>";
		        }
		        
		        document.getElementById("formDel").innerHTML = document.getElementById("formDel").innerHTML + html; 
		        
		        //2018-07-16 김보미 - 특수문자
		        /* for(var j = 0; j < SelectNodes(xmlDoc, "DATA/ROW").length; j++) {
			        if (SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[j], "CONTENT").length != 0) {
			        	var contentArr = JSON.parse(SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[j], "CONTENT"));
			        	var contentStr = "";
			        	
			        	for (var k = 0; k < contentArr.length; k++) {
			        		contentStr += ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(contentArr[k], "&lt;", "<"), "&gt;", ">"), "&quot;", "'"),"&dquot;", '"'), "&amp;", "&");
			        		if (k != contentArr.length - 1) { //마지막에는 개행을 붙이지 않는다
				        		contentStr += "\n";
			        		}
			        	}
			        	$("textarea[name=textarea1]").eq(j).val(contentStr);
			        }
		        } */
		        
		        // 2018-02-14 천성준
		        $(document).keydown(function(e) {
		        	// input 박스를 제외한 나머지에서 backspace 입력을 막는다.(IE뒤로가기 방지)
		            if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA") {
		                if(e.keyCode === 8) {return false;}
		            }
		        });
		    }
		    
		    function keyword_onkeydown(e) {
				var keycode;
		        if (!window.ActiveXObject)
		            keycode = e.keyCode;
		        else
		            keycode = event.keyCode;
		        if (keycode == 13) {
		            search();
		            return false;
		        }
		        return true;
		    }
		    
			function search() {
				if( !comm_searchCheck()) {
					return;
				}
					
				if (document.getElementById("s_radio").value == "title") {
					var strSearch = "sRadio=title&keyword=" + document.getElementById("keyword").value;
				} else if (document.getElementById("s_radio").value == "titleContent") {
					var strSearch = "sRadio=titleContent&keyword=" + document.getElementById("keyword").value;
				} else {
					var strSearch = "sRadio=writer&keyword=" + document.getElementById("keyword").value;
				}
				
				strSearch = strSearch + "&key=" + document.getElementById("keyword").value;
				window.location.href = "/ezCommunity/guestOne.do?code=" + code + "&" + encodeURI(strSearch);
			}

			function comm_searchCheck() {
				//[2006.06.21] 특수문자가 검색어에 들어올 경우 오류 메시지 처리
			    var pKeyword = document.getElementById("keyword").value;
				/*var pLen = pKeyword.length;				
				for( var i = 0; i < pLen ; i++) {
					if( pKeyword.charAt(i) == "\"" || pKeyword.charAt(i) == "+" ) {
						alert("<spring:message code='ezCommunity.t580' />(\\\"+)<spring:message code='ezCommunity.t581' />");
						return false;
					}
				}*/

				//2018-07-02 김보미 - 키워드 특수문자에 '%' 추가	
				if( pKeyword.indexOf("\"") != -1 || pKeyword.indexOf("+") != -1 || pKeyword.indexOf("%") != -1) {
					alert("<spring:message code='ezCommunity.t580' />(\\, \", +, %)<spring:message code='ezCommunity.t581' />");
					return false;
				}
				
			    if (pKeyword.length < 2) {
					alert("<spring:message code='ezCommunity.t164' />");
					return false;
				}
			    
				return true;
			}
			
			function Chk1() {
				if (document.FIND.Find.value=="") {
					alert("<spring:message code='ezCommunity.t582' />");
					document.FIND.Find.focus();
					return false;
				}
				
				document.FIND.submit();
				
				return
			}
			
			function mo_onclick() {
				var count = 0;
				var ingNo;

				for(var i = 0; i < del.elements.length; i++ ) {
					if ( del.elements[i].name == "c_no" && del.elements[i].checked == true) {
						ingNo = del.elements[i].value;
						count++;
					}
				}

				if (count == 0) {
					alert("<spring:message code='ezCommunity.t583' />");
				} else if( count >= 2 ) {
					alert("<spring:message code='ezCommunity.t584' />");
				} else {
					document.location.href = "/ezCommunity/guestEdit.do?code=" + code + "&mode=edit&no="+ingNo;
				}
			}
			
		    function delete1() {
		        var count = 0;
		        for (var i = 0; i < del.elements.length; i++) {
		            if (del.elements[i].name == "c_no" && del.elements[i].checked == true) {
		                ingNo = del.elements[i].value;
		                count++;
		            }
		        }

		        if (count == 0) {
		            alert("<spring:message code='ezCommunity.t583' />");
		            return;
		        }
		        
		        var result;
		        result = confirm("<spring:message code='ezCommunity.t136' />");
		        
		        if (result) {
		            document.del.submit();
		        }
		    }
			
			function alertMessage() {
				alert("<spring:message code='ezCommunity.t181' />");
			}
			
			var BlockSize = 10;
			
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
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
	            
	            if (MaxNum == 0) {
	            	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
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
	            
	            if( parseInt(pageNum + 1) <= totalPage) {
	                goToPageByNum(parseInt(pageNum + 1));
	            } else {
	                return;
	            }
	        }
	        
	        function movePage(newPage) {	
	            // 20060628 준호수정
	            // 숫자 아닌 문자 들어갔을 경우 에러 남.
	    		var href = "/ezCommunity/guestOne.do?bName=" + encodeURIComponent('<c:out value="${mode}"/>')
				            + "&sRadio=" + encodeURIComponent("${sRadio}")
				            + "&code=" + encodeURIComponent(code)
							+ "&keyword=" + encodeURIComponent("${fn:escapeXml(keyword)}");
				            + "&block=" + encodeURIComponent("${nowBlock}");
				            
	            if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	                document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(newPage));
	            }
			}
	        
	        //########################################페이지네이션 변경 ##############################################
		    function goToPage(page) {
		        var href = "/ezCommunity/guestOne.do?bName=" + encodeURIComponent("${mode}")
					+ "&sRadio=" + encodeURIComponent('<c:out value="${sRadio}"/>')
					+ "&code=" + encodeURIComponent('<c:out value="${code}"/>')
					+ "&keyword=" + encodeURIComponent("${fn:escapeXml(keyword)}");
					+ "&block=" + encodeURIComponent("${nowBlock}");

		        if (page == "front") {
		            if (parseInt(CurPage) - 1 < 1)
		                return;
		            document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(CurPage) - 1);
		        }
		        else if (page == "next") {
		            if (parseInt(CurPage) + 1 > parseInt(totalPage))
		                return;
		            document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(CurPage) + 1);
		        }
		        else if (page == "page") {
		            if (event.keyCode == 13) {
		                var goPage = document.all.txt_PageInputNum.value;

		                // 20060628 준호수정
		                // 숫자 아닌 문자 들어갔을 경우 에러 남.
		                if (parseInt(goPage) > 0 && parseInt(goPage) <= parseInt(totalPage)) {
		                    document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(goPage));
		                }
		            }
		        }
		    }

		    function goPage(idx) {
		        var url = "";
		        
		        switch (idx) {
		            case 1:
		                url = "/ezCommunity/guestEdit.do?mode=write&code=" + code;
		                break;
		            case 2:
		                url = "/ezCommunity/guestOne.do?mode=list&code=" + code;
		                break;
		        }
		        
		        window.location.href = url;
		    }

			// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글작성 버튼 이벤트
			function replyLayerDisplay(guestNo) {
				var replyDisplay = document.querySelectorAll(".imgbtn.replyDisplay");
				for (var i = 0; i < replyDisplay.length; i++) {
					replyDisplay[i].style.display = "";
				}

				var cont = document.querySelectorAll(".contText");
				for (var i = 0; i < cont.length; i++) {
					cont[i].style.display = "";
				}

				var aButton = document.getElementById('replyDisplay' + guestNo);
				aButton.style.display = "none";
				var writerArea = document.querySelectorAll(".mainlist.emoticonLayerStaticPosition");

				for (var i = 0; i < writerArea.length; i++) {
					writerArea[i].style.display = "none";
				}

				var relplyLayer = document.getElementById("replyLayerTable_" + guestNo);
				relplyLayer.style.display = "table";
				var span = document.querySelector("#writtenReply_" + guestNo +" .contText");
				var editAreaText = document.querySelectorAll(".editReply");
				var buttons = document.querySelectorAll(".buttonChk");

				for (var i = 0; i < buttons.length; i++) {
					buttons[i].style.display = "none";
				}

				for (var i = 0; i < editAreaText.length; i++) {
					editAreaText[i].parentNode.removeChild(editAreaText[i]);
				}

				if (span) {
					span.style.display = "";
				}
			}

			// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 등록
			function guestOneLineReply(mode, guestNo, replyNo) {
				if (mode == 'new') {
					var content = document.getElementById("onelinereply" + guestNo).value.trim();

					if (content) {
						$.ajax({
							type: "POST",
							url: "/ezCommunity/guestOneLineReply.do",
							data: {
								c_no: guestNo,
								code: code,
								memo: encodeURIComponent(content)
							},
							success: function (result) {
								goPage(2);
							}
						});
					} else {
						alert("<spring:message code='ezCommunity.t569' />");
						document.getElementById("onelinereply" + guestNo).focus();
					}
				} else if (mode == "cancel") { // 등록 취소
					var relplyLayer = document.getElementById("replyLayerTable_" + guestNo);
					relplyLayer.style.display = "none";
					var aButton = document.getElementById('replyDisplay' + guestNo);
					aButton.style.display = "";
					var replyArea = document.getElementById("onelinereply" + guestNo);
					replyArea.value = "";
					var buttons = document.querySelectorAll(".buttonChk");

					for (var i = 0; i < buttons.length; i++) {
						buttons[i].style.display = "";
					}
				} else if (mode == "edit") { // 수정 버튼
					var buttonChk = document.querySelectorAll(".buttonChk");

					for (var i = 0; i < buttonChk.length; i++) {
						buttonChk[i].style.display = "";
					}

					var beforeEditReplyDiv = document.querySelectorAll(".editReply");
					for (var i = 0; i < beforeEditReplyDiv.length; i++) {
						beforeEditReplyDiv[i].parentNode.removeChild(beforeEditReplyDiv[i]);
					}

					var beforeContText = document.querySelectorAll(".contText");
					for (var i = 0; i < beforeContText.length; i++) {
						beforeContText[i].style.display = "";
					}

					var editButtons = document.querySelector('[imgbtnid="' + replyNo + '"]');
					editButtons.style.display = "none";

					var editReply = document.createElement("textarea");
					var editReplyDiv = document.createElement("div");
					var editReplyTotalDiv = document.createElement("div");

					editReplyTotalDiv.className = "editReply";
					editReply.style.width = "97%";
					editReply.style.resize = "none";
					editReply.setAttribute("maxlength", "300");

					var replyTextArea = document.querySelector('[replyId="' + replyNo + '"]');
					var span = replyTextArea.querySelector("span");
					var replyContext = span.textContent;

					editReply.value = replyContext;
					editReply.id = "editReply" + guestNo;
					editReply.name = replyNo;
					editReply.style.border = "none";
					span.style.display = "none";
					editReplyDiv.appendChild(editReply);
					editReplyTotalDiv.appendChild(editReplyDiv);
					replyTextArea.appendChild(editReplyTotalDiv);

					var editReplyOkDiv = document.createElement("div");
					var editReplyOkA = document.createElement("a");
					var editReplyCancelA = document.createElement("a");
					var blankSpan = document.createElement("span");

					editReplyOkA.setAttribute("onclick", "editReplySave('" + replyNo + "', '" + guestNo + "')");
					editReplyCancelA.setAttribute("onclick", "editCancel('"+ replyNo +"')");
					editReplyOkA.textContent = "<spring:message code='ezCommunity.t958' />";
					editReplyCancelA.textContent = "<spring:message code='ezCommunity.t109' />";
					editReplyOkDiv.className = "editSubmit";
					blankSpan.textContent = "|";
					blankSpan.className = "blankSpan";

					editReplyOkDiv.appendChild(editReplyCancelA);
					editReplyOkDiv.appendChild(blankSpan);
					editReplyOkDiv.appendChild(editReplyOkA);
					editReplyTotalDiv.appendChild(editReplyOkDiv);
				} else if (mode == "del") { // 삭제
					if (confirm("<spring:message code='ezCommunity.t426' />")){
						$.ajax({
							type : "POST",
							url : "/ezCommunity/deleteGuestOneLineReply.do",
							data : {replyNo : replyNo},
							success : function(result) {
								goPage(2);
							}
						});
					}
				}
			}

			// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 수정 저장
			function editReplySave(replyNo, guestNo) {
				var editReplyContent = document.getElementById("editReply" + guestNo).value.trim();

				if (editReplyContent) {
					$.ajax({
						type: "POST",
						url: "/ezCommunity/modifyGuestOneLineReply.do",
						data: {
							replyNo: replyNo,
							content: encodeURIComponent(editReplyContent)
						},
						success: function (result) {
							var contentTd = document.querySelector('[replyid="' + replyNo + '"]');
							var editReply = contentTd.querySelector(".editReply");
							var content = contentTd.querySelector("span");
							content.textContent = editReplyContent;
							content.style.display = "";

							if (editReply && editReply.parentNode) {
								editReply.parentNode.removeChild(editReply);
							}

							var buttons = document.querySelectorAll(".buttonChk");
							for (var i = 0; i < buttons.length; i++) {
								buttons[i].style.display = "";
							}
						}
					});
				} else {
					alert("<spring:message code='ezCommunity.t569' />");
					document.getElementById("editReply" + guestNo).focus();
				}
			}

			// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 수정 취소
			function editCancel(replyNo) {
				var editButtons = document.querySelector('[imgbtnid="' + replyNo + '"]');
				editButtons.style.display = "";

				var contentTd = document.querySelector('[replyid="' + replyNo + '"]');
				var content = contentTd.querySelector("span");
				content.style.display = "";

				var editArea = contentTd.querySelector("div");
				if (editArea && editArea.parentNode) {
					editArea.parentNode.removeChild(editArea);
				}

				var editReply = document.querySelectorAll(".editReply");
				for (var i = 0; i < editReply.length; i++) {
					editReply[i].parentNode.removeChild(editReply[i]);
				}
			}
			
		</script>
	</head>
	<body class="cmhome_body" style = "margin-bottom:0px;">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t570' /><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu" >
			<ul>
				<c:if test="${guest != '1' }">
					<c:choose>
						<c:when test="${disable == false }">
							<li class="important"><span onClick="goPage(1)"><spring:message code='ezCommunity.t167' /></span></li>
						</c:when>
						
						<c:otherwise>
							<li><span onClick="alertMessage();"><spring:message code='ezCommunity.t167' /></span></li>
						</c:otherwise>
					</c:choose>

					<li><span onClick="javascript:mo_onclick()"><spring:message code='ezCommunity.t6' /></span></li>
					<li onClick="javascript:delete1()"><span class="icon16 icon16_delete"></span></li>
				</c:if>
				<c:if test="${keyword != '' }">
					<li><span onClick="goPage(2)" ><spring:message code='ezCommunity.t168' /></span></li>
				</c:if>
				<div style="float:right;margin-top:5px;">
					<select name="s_radio" id ="s_radio" style="vertical-align: middle; height: 24px !important; margin-top:1px; text-align-last: center; height: 24px !important; -webkit-appearance: auto; padding: 0px; ">
						<option selected value="titleContent" ><spring:message code='ezCommunity.t585' /></option>
						<option value="writer"><spring:message code='ezCommunity.t445' /></option>
					</select>
					<input class="inputText" type="text" name="keyword" id ="keyword" onKeyDown="return keyword_onkeydown(event)" style="vertical-align: middle; width:200px; border-color:#ddd">
					<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;margin:0px"><span onClick="search();" style="height:22px;line-height:22px"><spring:message code='ezCommunity.t31' /></span></a>
				</div>
   			</ul>
		</div>
		
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table class="content" style="width:100%;border:0px;border-top:1px solid #ddd">
			<tr>
	  			<td style="border:0px; height: 0px;">
	  				<%-- <div style="margin-top:8px;">
						<select name="s_radio" id ="s_radio" style="vertical-align: middle; height: 25px;margin-top:1px">
							<option selected value="titleContent" ><spring:message code='ezCommunity.t585' /></option>
							<option value="writer"><spring:message code='ezCommunity.t138' /></option>
						</select>
						<input class="inputText" type="text" name="keyword" id ="keyword" onKeyDown="return keyword_onkeydown(event)" style="vertical-align: middle; width:200px">
						<a class="imgbtn" style="vertical-align: middle;height:22px;margin:0px"><span onClick="search();" style="height:22px;line-height:22px"><spring:message code='ezCommunity.t31' /></span></a>
					</div>  --%>
	  			</td>
			</tr>
		</table>
		
		<form name="del" id= "formDel" action = "/ezCommunity/guestEditOk.do" method = "post">
			<input type=hidden name=code value="<c:out value='${code}' />">
			<input type=hidden name=memo value="<c:out value='${memo}' />">
			<input type=hidden name=mode value=delete>
		</form>
		<div id="tblPageRayer"></div>
	</body>
</html>