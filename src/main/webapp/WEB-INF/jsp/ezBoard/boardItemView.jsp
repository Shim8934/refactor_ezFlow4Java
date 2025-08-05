<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t293' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<style>
			.likeButton {
				padding:5px;
				cursor:pointer;
				display:inline-block;
				border:1px solid #c7c7c7;
			    border-radius:2px;
			}
			.likeButton:hover {
				background-color:#f1f8ff;
				border:1px solid #6793d8;
			}
			.disLikeButton {
				padding:5px;
				cursor:pointer;
				display:inline-block;
				border:1px solid #c7c7c7;
			    border-radius:2px;
			}
			.disLikeButton:hover {
				background-color:#ffd9ec;
				border:1px solid #f44336;
			}
		</style>
		<script  type="text/javascript">
		    window.offscreenBuffering = true;
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var pItemID = "${itemID}";
			var pBoardID = "${boardID}";
		    var pBoardName = "${boardInfo.boardName}";
		    var strWriterID = "${boardItem.writerID}";
		    var strWriterDeptID = "${boardItem.writerDeptID}";
		    var strWriterName = ConvMakeXMLString("<c:out value='${boardItem.writerName}'/>"); // 익명게시판의 게시자명 특문처리 대응
		    var strWriterDeptName = "${boardItem.writerDeptName}";
		    var strWriterCompanyName = "${boardItem.writerCompanyName}";
		    var strWriteDate = "${boardItem.writeDate}";
		    var strImportance = "${boardItem.importance}";
		    var strEndDate = "${boardItem.endDate}";
		    var strStartDate = "${boardItem.startDate}";
		    var strContentLocation = "${boardItem.contentLocation}";
		    var strAttachList = "${boardItem.attachments}";
		    var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName}";
		    var Access_FG = "${boardInfo.access_FG}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var ListView_FG = "${boardInfo.listView_FG}";
		    var Read_FG = "${boardInfo.read_FG}";
		    var Write_FG = "${boardInfo.write_FG}";
		    var Reply_FG = "${boardInfo.reply_FG}";
		    var Delete_FG = "${boardInfo.delete_FG}";
		    var Edit_FG = "${boardInfo.edit_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var pReservedItem = "${pReservedItem}";
		    var g_progresswin;
		    var OneLineReplyFlag = "${boardPropertyVO.oneLineReply}";
		    var commentCount = "${commentCount}";
		    var nowCommentCount = ""; // 댓글 옵션처리를 위해 전역변수로 변경
		    var userInfoID = "${userInfo.id}"; // 댓글 삭제가능여부 판단을 위해 자신의 userID 사용
			var gubun = "${guBun}";
			var isLikeChecked = "<c:out value='${isLikeChecked}'/>";
			var likeFlag = "<c:out value='${boardInfo.likeFlag}'/>";
			var likeCount = "${boardItem.likeCount}";
			var likeCountAfter = 0;
			var refreshFlag = "N";
		    var pUse_Editor = "${useEditor}";
			var pNoneActiveX = "YES";
			var reactFlag = "<c:out value='${boardInfo.reactFlag}'/>"; // 2023-07-28 임정은 - 게시판 댓글 좋아요 기능 사용여부
		    //추가항목 유무
		    var pAttributeYN = "${boardInfo.attributeYN}";
		    var AtttributeCount = "${boardAttrCount}"; 
		    var rsa = new RSAKey();
		    var addheight = 0;
		    var scrollValue = 0;
		 	// 2023-05-25 조수빈 - 게시판 첨부파일 미리보기 사용 여부
		    var useBoardFilePrvw = "<c:out value='${useBoardFilePrvw}'/>";
		    
		    /* 2023-11-17 홍승비 - 게시물 승인 시 게시알림메일 발송을 위한 그룹사게시판 여부 파라미터 추가 */
			var isAllGroupBoard = "<c:out value='${boardInfo.isAllGroupBoard}'/>";
			var strUpperItemIDTree = "<c:out value='${boardItem.upperItemIDTree}'/>";
			var strParentWriteDate = "<c:out value='${boardItem.parentWriteDate}'/>"; // 답변게시물 판별용 부모게시물 NO(PARENTWRITEDATE)
			var strDocNo = "<c:out value='${boardItem.docNo}'/>"; // 답변게시물 판별용 현재게시물 NO(DOCNO)
			var useKeyword = "<c:out value='${boardInfo.useKeyword}'/>"; // 키워드 기능 사용 여부 (Y/N)
		    
			var isDisLikeChecked = "<c:out value='${isDisLikeChecked}'/>";
			var disLikeFlag = "<c:out value='${boardInfo.disLikeFlag}'/>";
			var disLikeCount = "${boardItem.disLikeCount}";
			var disLikeCountAfter = 0;

            var myBoardScrapFlag = "<c:out value='${MyBoardScrapFlag}'/>" // myBoardScrapFlag 테넌트컨피그값 (NONE, TYPE1_(마이게시판하위), TYPE2(스크랩함))
			var isScrap = "<c:out value='${isScrap}'/>"; // 이미 스크랩되었는지의 여부 (type1일때)
			var scrapContID = "<c:out value='${scrapContID}'/>"; // 개인스크랩함 ID (TYPE2, 스크랩함에서 게시물 조회했을 때만 값이 삽입되는 변수)
			var writerNameType = "<c:out value='${boardItem.writerNameType}'/>"; // 2025-01-21 임정은 - 게시자명선택 타입 (0 : 이름, 1 : 부서명)
			var SSDeptID = "<c:out value='${userInfo.deptID}'/>";
			var starRatingFlag = "<c:out value='${boardInfo.starRatingFlag}'/>";
			var rating = "${itemStarRating.rating}";
			var updateDate = "<c:out value= '${boardItem.updateDate}'/>";

		    <%--본문 확대/축소 관련--%>
            var nowZoom = parseInt("<c:out value='${contentSize}'/>"); // 사용자 설정 본문크기값
            var maxZoom = 200;
            var minZoom = 100;
    
            var MozNowZoom = parseInt("<c:out value='${mozContentSize}'/>"); // 사용자 설정 본문크기값
            var MozMaxZoom = 2;
            var MozMinZoom = 1;
	        
			/* 2023-04-12 이가은 - 답글 기능을 위한 변수 추가 */
	        var userInfoName = "${userInfo.displayName}"; 
			var replyOpenFlag = 0;
			var replyModifyFlag = 0;
			var replyModifyId = "";
			var replyTextarea = "";
			var delParentReply = 0;
			var delChildReply = 0;
			var delReplyLevel = "";
			var parentReplyID = "";
			var replyModifyArray = new Array(); // 2023-08-09 임정은 - 답글 수정 기능을 위한 배열 추가
			var commentSort = "earliest"; // 댓글 정렬 기준 : earliest(등록순) / latest(최신순)
			var attachmentFlag = "${boardInfo.attachmentFlag}"; // 게시판 첨부파일 사용여부(Y/N)
			var attachLimit = "${boardInfo.attachSizeLimit}"; // 첨부파일 크기 limit
			var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");// 첨부파일명 글자수 제한 limit
			var totalFileSize = 0; // 현재 총 첨부파일 사이즈
			
            var userLang = "${extenLang}"
            var boardAttrListTemp = '<c:out value="${boardAttrJson}"/>';
            var boardAttrListJson = JSON.parse(replaceEntityCodeToStr(boardAttrListTemp));
            var boardItemTemp = '<c:out value="${boardItemJson}"/>';
            var boardItemJson = JSON.parse(replaceEntityCodeToStr(boardItemTemp));
	        
			var version = "${ version }";
			var useVersion = "${ useVersion }";
			var leftAddr = "${ leftAddr }";
			var rightAddr = "${ rightAddr }";
			var selectedAddr = "${ selectedAddr }"
			var addrInfo = [];
			var selectedViewFlag = "${ selectedViewFlag }";
			var historyModify = "${ historyModify }";
			var newestVersionFlag = "${ newestVersionFlag }";

	        function Bigger() {
                var doc = document.getElementById("message").contentWindow.document;
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom < MozMaxZoom) {
	                    MozNowZoom += 0.1;
	                } else {
	                    return;
	                }
	                
	                $(doc).find('.contentDiv').css("MozTransform","scale(" + MozNowZoom + ")");
	                $(doc).find('.contentDiv').css("MozTransformOrigin","0 0");
	            } else {
	                if (nowZoom < maxZoom) {
	                    nowZoom += 10;
	                } else {
	                    return;
	                }
	                
	                $(doc).find(".contentDiv").css("zoom",nowZoom + "%");
	                $(doc).find("#curZoomSize").text(nowZoom + "%");
	                $(doc).find("#curZoomSize").show();
	                setTimeout(function(){$(doc).find("#curZoomSize").css("display","none")}, 1000);
	            }
	            fontSync("B");
	        }
	        
	        function Smaller() {
	            var doc = document.getElementById("message").contentWindow.document;
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom > MozMinZoom) {
	                    MozNowZoom -= 0.1;
	                } else {
	                    return;
	                }

	                $(doc).find('.contentDiv').css("MozTransform","scale(" + MozNowZoom + ")");
	                $(doc).find('.contentDiv').css("MozTransformOrigin","0 0");
	            } else {
	                if (nowZoom > minZoom) {
	                    nowZoom -= 10;
	                } else {
	                    return;
	                }

	                $(doc).find(".contentDiv").css("zoom",nowZoom + "%");
	                $(doc).find("#curZoomSize").text(nowZoom + "%");
	                $(doc).find("#curZoomSize").show();
	                setTimeout(function(){$(doc).find("#curZoomSize").css("display","none")}, 1000);
	            }
	            fontSync("S");
	        }
	        
	        function fontSync(type) {
                for (let i=0; i<5; i++) {
                    let elementId = "message" + i;
                    let element = document.getElementById(elementId);

                    if (element) {
                        if (type == "S") {
                            Smaller2(element.contentWindow.document, i);
                        } else {
                            Bigger2(element.contentWindow.document, i)
                        }
                    } else {
                        break;
                    }
                }
            }
	        
		    window.onload = function () {
		    	makeEmoticonPanel();
		        try {
		        	if (pUse_Editor != "HWP") {
		        		// 수정 수아 재은
			        	var html = "<div><img src='/images/minus.png' title='<spring:message code='ezEmail.t99000065' />' id='smaller' style='cursor:pointer; margin-bottom: 5px;' />"
							html += "<img src='/images/plus.png' title='<spring:message code='ezEmail.t99000064' />' id='bigger' style='cursor: pointer; margin-bottom: 5px;' />";
							html += "<span id='curZoomSize'  style='position: absolute; top: 2px; right: 0px; background: white; font-size: 12px; padding: 2px; border: 1px solid rgb(204, 204, 204); border-radius: 4px; display: none;'></span></div>";
							
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezCommon/mhtToHTMLContent.do",
							data : { type   : "BOARDCONTENT", 
									 itemID : pItemID,
									 href   : strContentLocation 
								   },
							success: function(result){
								html += "<div class='contentDiv' id='txtContent'>" + result + "<div>";
							}        			
						});
						
						var doc = document.getElementById('message').contentWindow.document;
						doc.open();
						doc.write('<!doctype html>');
						doc.write(html);
						doc.close();
						
						// 수정 수아 재은
						<%-- doc.getElementById('smaller').onclick = function () {
							Smaller(doc);
						}
						doc.getElementById('bigger').onclick = function () {
							Bigger(doc);
						}--%>
						
						/* 2024-12-17 김은실 - default.css 추가 */
						var cssLink0 = document.createElement("link");
						cssLink0.href = "${util.addVer('/css/default.css')}";
						cssLink0.rel = "stylesheet";
						cssLink0.type = "text/css";

						/* 2020-07-10 홍승비 - 게시물 본문 내부에도 기본적인 css가 적용되도록 수정 */
						var cssLink1 = document.createElement("link");
						cssLink1.href = "${util.addVer('main.default.css', 'msg')}";
						cssLink1.rel = "stylesheet";
						cssLink1.type = "text/css";
						
						/* 2021-09-02 홍승비 - 게시물 본문 내부의 헤딩 태그(h1, h2...)의 스타일은 default.css가 아닌 기본적인 브라우저의 user-agent 속성을 사용하도록 수정 (글자 자체의 인라인 속성이 있다면 해당 속성이 우선 적용됨) */
						// chrome의 경우 각 속성 revert로 간단히 처리가 가능하나, IE에서 해당 속성을 지원하지 않아 각 폰트 사이즈와 마진을 명시함
						var cssHeading = "<style type='text/css'>.contentDiv h1, .contentDiv h2, .contentDiv h3, .contentDiv h4, .contentDiv h5, .contentDiv h6 {margin-left:0px; margin-right:0px; color:#000000;}";
						cssHeading += " .contentDiv h1 {font-size:2em; margin-top:0.67em; margin-bottom:0.67em;}";
						cssHeading += " .contentDiv h2 {font-size:1.5em; margin-top:0.83em; margin-bottom:0.83em;}";
						cssHeading += " .contentDiv h3 {font-size:1.17em; margin-top:1em; margin-bottom:1em;}";
						cssHeading += " .contentDiv h4 {font-size:1em; margin-top:1.33em; margin-bottom:1.33em;}";
						cssHeading += " .contentDiv h5 {font-size:0.83em; margin-top:1.67em; margin-bottom:1.67em;}";
						cssHeading += " .contentDiv h6 {font-size:0.67em; margin-top:2.33em; margin-bottom:2.33em;}";
						cssHeading += "</style>";
						
						$("#message").contents().find("head").append(cssLink0).append(cssLink1).append(cssHeading);
						$("#message").contents().find("body").css("word-wrap", "break-word");
						
						rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
						
			            AddLinkTarget();
			            
			            // 사용자가 설정한 본문크기값으로 세팅 (원글)
                        if (navigator.userAgent.indexOf('Firefox') != -1) {
                            $(doc).find('.contentDiv').css("MozTransform","scale(" + MozNowZoom + ")");
                        } else {
                            $(doc).find(".contentDiv").css("zoom",nowZoom + "%");
                        }
		        	}
		        	
		            SetAttachmentInfo();
			        
		            //추가항목 창 사이즈 조절
		            addheight = 0;
		            if("${boardAttrCount}" > 0){
						addheight = AtttributeCount * 30;
						document.getElementById("bodyPopup").style.marginRight = "1px";
		            }
		            
		            // 2024-07-31 전인하 - 게시판 > 확장컬럼 > peoplePicker 타입, textArea 타입 출력값 가공
		            for (let i = 0 ; i < boardAttrListJson.length ; i++ ) {
		                var boardAttr = boardAttrListJson[i];
		                if (boardAttr.colType == 'people') {
		                    var peoplePickerString = peoplePickerDisplay(boardItemJson[boardAttr.tableCol], userLang);
		                    document.getElementById(boardAttr.tableCol).innerText = peoplePickerString;
		                } else if (boardAttr.colType == 'textArea') {
		                    var peoplePickerString = boardItemJson[boardAttr.tableCol];
		                    peoplePickerString = peoplePickerString.replace(/<script.*?>(.*?)<\/script>/gs, '$1');
		                    document.getElementById(boardAttr.tableCol).innerHTML = unescapeForJson(peoplePickerString);
		                }
		            }
		            
		            /* 2019-11-05 홍승비 - 본문 하단에 댓글영역 표출 */
 		            if (OneLineReplyFlag == "2") {
 		            	document.getElementById("bodyPopup").style.overflowX = "hidden";
 		            	document.getElementById("bodyPopup").style.overflowY = "auto";
 		            	document.getElementById("bodyPopup").style.marginRight = "1px";
 		            	getBoardComment();
 		            }
		            
		            /* 2020-04-09 홍승비 - 좋아요 버튼 사용+하단댓글 미사용 시, 좋아요+첨부파일 영역 패딩 상하 조절 */
		            if (likeFlag != null && likeFlag == "Y") {
						if (OneLineReplyFlag != "2") {
							document.getElementById("likeDiv").style.padding = "5px 0px 0px 0px";
							document.getElementById("attachTD").style.padding = "0px";
						}
		            }
		            
		            /* 2023-03-20 기민혁 - 싫어요 버튼 사용+하단댓글 미사용 시, 싫어요+첨부파일 영역 패딩 상하 조절 */
		            if (disLikeFlag != null && disLikeFlag == "Y") {
						if (OneLineReplyFlag != "2") {
							document.getElementById("disLikeDiv").style.padding = "5px 0px 0px 0px";
							document.getElementById("attachTD").style.padding = "0px";
						}
		            }
		            
					if (gubun != "2") {
		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
		                    self.resizeTo(760, (800 + addheight));
		                } else {
		                    self.resizeTo(785, (830 + addheight));
		                }
					} else {
						if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
		                    self.resizeTo(760, (775 + addheight));
						} else  {
		                    self.resizeTo(785, (805 + addheight));
		                }
					}
// 		            }
// 		            else {
// 		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
// 		                    self.resizeTo(760, (690 + addheight));
// 		                } else {
// 		                    self.resizeTo(785, (715 + addheight));
// 		                }
// 		            }
						// 에디터 테이블 사이즈 조절 (저해상도 IE 대응)
						resizeMessageFrame();
		
					/* 2018-11-15 홍승비 - 익명게시판 게시자 클릭 시 사원정보 표출되던 부분 수정 */
		            var Div = document.createElement("DIV");
		            var Span = document.createElement("SPAN");
		            if (gubun != 2) {
			            if ("${useOcs}" == "YES") {
			                var pSIPUriList = getSIPUri(strWriterID + ";", "").split(';');
			                var Img = document.createElement("IMG");
			                Img.style.verticalAlign = "middle";
			                Img.src = "/images/Presence/unknown.gif";
			                Img.type = "smtp";
			                Img.onload = "PresenceControl(\"" + pSIPUriList[0] + "\", this)";
			                Img.id = GetGUID();
			                Div.appendChild(Img);
			                var Span = document.createElement("SPAN");
			                Span.style.verticalAlign = "middle";
			                Span.style.cursor = "pointer";
			                Span.setAttribute("onclick", "OpenUserInfo('" + strWriterID + "', '" + strWriterDeptID + "')");
			                Span.innerText = strWriterName;
			                Div.appendChild(Span);
			                document.getElementById("WriteUserNM").innerHTML = Div.outerHTML;
			                pSIPUriList = null;
			            }
			            else {
			                Span = document.createElement("SPAN");
			                Span.style.verticalAlign = "middle";
			                Span.style.cursor = "pointer";
			                Span.setAttribute("onclick", "OpenUserInfo('" + strWriterID + "', '" + strWriterDeptID + "')");
			                Span.innerText = strWriterName;
			                Div.appendChild(Span);
			                document.getElementById("WriteUserNM").innerHTML = Div.outerHTML;
			            }
		            } else {
						Span = document.createElement("SPAN");
		                Span.style.verticalAlign = "middle";
		                Span.innerText = strWriterName;
		                Div.appendChild(Span);
		                document.getElementById("WriteUserNM").innerHTML = Div.outerHTML;
		            } 
		            
		            if (g_progresswin) g_progresswin.close();
		        }
		        catch (e) {
		            console.log(e);
		            alert(e.description);
		        }
		    };
		    
			    // 수정
			  /*   $(document).ready(function(){
			    	alert();
			    	var html2 = "<img src='/images/minus.png' title='<spring:message code='ezEmail.t99000065' />' id='smaller' style='cursor:pointer;' />";
					html2 += "<img src='/images/plus.png' title='<spring:message code='ezEmail.t99000064' />' id='bigger' style='cursor: pointer; margin-left: -4px;' />";
					html2 += "<p>";
					
					document.getElementById('message').prepend(html2);
					
			    }); */
			  /*   console.log($("#pad1 #smaller").attr);
			    $(document).on("click","#pad1 #smaller",function(){
			    	alert();
			    })
				//console.log(document.getElementById("pad1").children);
				//document.getElementById("smaller").onclick = smaller();
				 */
				 
		 /* 2019-11-07 홍승비 - 댓글삭제 레이어팝업 스크롤 위치 관련 */
	        $(window).scroll(function () {
				scrollValue = $(document).scrollTop();
	        });
		
		    window.onresize = function () {
				resizeMessageFrame();
				
	            /* 2022-08-18 홍승비 - 화면 리사이즈 시, 화면 높이만큼 레이어 팝업의 배경 회색 영역을 확장 */
				if (document.body.scrollHeight > window.innerHeight) {
	            	document.getElementById("mailPanel").style.height = (document.body.scrollHeight + 5) + "px";
	            } else {
	            	document.getElementById("mailPanel").style.height = (window.innerHeight) + "px";
	            }
	            
	            if (pUse_Editor == "HWP") {
	            	var mHeight = document.getElementById("pad1").clientHeight - 164 + "px";
	            	message.Resize(mHeight);
	            }
		    	
		    };
		    
		    /* 2019-04-12 홍승비 - 댓글 갯수 갱신 시 게시물리스트 갱신 */
			window.onbeforeunload = function () {
				checkRefreshFlag();
				if (refreshFlag == "Y") {
					window.opener.getBoardList();
				}
			    opener.isOpenWindow = undefined;
		    };
		    
		    /* 2018-12-26 홍승비 - 저해상도 대응을 위해 리사이즈 함수 분리 */
		    function resizeMessageFrame() {
		        // 댓글 높이 계산 시작
				/* 2019-11-05 홍승비 - 하단댓글 사용 시 메세지 프레임 높이 조정 추가 */
				/* 2019-05-08 홍승비 - 익명게시판에 확장컬럼 존재 시 세로 리사이즈 오류 수정 */
				var replyOffsetH = 0;
				if (OneLineReplyFlag == "2") {
					if (pAttributeYN == "Y") {
						if (gubun == "2") {
							replyOffsetH = -8; // 확장칼럼 존재 익명게시판
						} else {
							replyOffsetH = 16; // 확장칼럼 존재 일반, QNA게시판
						}
					} else {
						if (gubun == "2") {
							replyOffsetH = -14; // 확장칼럼 없는 익명게시판
						} else {
							replyOffsetH = 12; // 확장칼럼 없는 일반, QNA게시판
						}
					}
				} else { // 댓글을 사용하지 않거나 레이어 팝업인 경우
					replyOffsetH = -18;
				}
				// 댓글 높이 계산 끝
				
				var contentHeight;
				contentHeight = document.documentElement.clientHeight - 305 - addheight + replyOffsetH;
				
                if (gubun == "2") { // 익명게시판일 경우
				    contentHeight += 18;
				}
				
                if (useKeyword == "Y") { // 키워드 사용할 경우
				    contentHeight -= 28;
				}
				
				if ((BoardAdmin_FG == 'true' || BoardGroupAdmin_FG == 'OK') && updateDate && updateDate.length != 0) { // 수정일 컬럼 존재할 경우
				    contentHeight -= 28;
				}
				
                if ((likeFlag != null && likeFlag == "Y") || (disLikeFlag != null && disLikeFlag == "Y")) { // 좋아요/싫어요 버튼 존재할 경우
                    contentHeight -= 28;
                }
                
                if (starRatingFlag == "Y") { // 별점 평가하기 존재할 경우
                    contentHeight -= 38;
                }
                
                // 본문 영역에 최소 / 최대 크기 추가함, 없앨 수 없는 스크롤 생기는 것을 방지
                if (contentHeight < 300) {
                    contentHeight = 300;
                } else if (contentHeight > 600) {
                    contentHeight = 600;
                }
                
                document.getElementById("message").style.height = contentHeight + "PX";
                document.getElementById("pad1").style.height = (contentHeight + 20) + "PX";
		    }
		
		    function AddLinkTarget() {
		        try {
		            var objTags = document.getElementById('message').getElementsByTagName("a");
		            for (var i = 0 ; i < objTags.length ; i++) {
		                if (objTags.item(i).href.indexOf("javascript:") == -1)
		                    objTags.item(i).target = "_blink";
		            }
		        }
		        catch (e) { }
		    }
		    
		    function ImageUrl(pUrl, cnt) {
		        var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl + "&Cnt=" + cnt;
		        return link;
		    }
		    
		    function CheckIfHasReplies() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + encodeURIComponent(pItemID) + ",;", false);
		        xmlhttp.send();
		        if (xmlhttp.responseText == "FALSE") {
		            xmlhttp = null;
		            return false;
		        }
		        xmlhttp = null;
		        return true;
		    }
		    
		    var checkpassword_dialogArguments = new Array();
		    function btn_Delete_Onclick(param) {
		        if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezBoard.t196' />");
		            return;
		        }
		
		        if (Delete_FG != "true") {
		            alert("<spring:message code='ezBoard.t265' />");
		            return;
		        }
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID && !(writerNameType == '1' && strWriterDeptID == SSDeptID)) {
		            if (gubun == "2") {
		                if (CrossYN()) {
		                    checkpassword_dialogArguments[1] = btn_Delete_Onclick_Complete;
		                    var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID), "CheckPassWord", GetOpenWindowfeature(470, 200));
		                    try { OpenWin.focus(); } catch (e) { }
		                } else {
		                    var feature = "status:no;dialogWidth:470px;dialogHeight:200px;help:no;scroll:no";
		                    feature = feature + GetShowModalPosition(470, 200);
		                    var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID), "", "status:no;dialogWidth:470px;dialogHeight:200px;help:no;scroll:no");
		                    
			                if (ret == "NO") {
			                    alert("<spring:message code='ezBoard.t267' />");
			                    return;
			                }
			                
		                    if (typeof (ret) == "undefined") {
		                        alert("<spring:message code='ezBoard.t265' />");
		                        return;
		                    }
		                    
		                    if (!confirm("<spring:message code='ezBoard.t197' />")) {
		                    	return;
		                    }
		                    var xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + ";", false);
		                    xmlhttp.send();
		
		                    if (xmlhttp.responseText == "NO") {
		                        alert("<spring:message code='ezBoard.t265' />");
		                        return;
		                    } else if (xmlhttp.responseText == "ERROR") {
				                alert("<spring:message code='ezBoard.t1020'/>");
				                return;
				            }
		
		                    xmlhttp = null;
		                    try {
			                	window.opener.leftCountRf(pBoardID);
							} catch (e) {
							}
		                    try {
		                        window.opener.refresh_onclick();
		                    } catch (e) {
		                    }

							if(parent.opener.search != undefined){
								parent.opener.search('skip');
							}
		                    
		                    window.close();
		                }
		            }
		            else {
		                alert("<spring:message code='ezBoard.t265' />");
		                return;
		            }
		
		        }
		        else {
		            if (BoardAdmin_FG == "true" || gubun != "2") {
		                if (!confirm("<spring:message code='ezBoard.t197' />")) return;
		                var xmlhttp = createXMLHttpRequest();
		                xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + ";" + "&mode=" + param, false);
		                xmlhttp.send();
		
		                if (xmlhttp.responseText == "NO") {
		                    alert("<spring:message code='ezBoard.t265' />");
		                    return;
		                } else if (xmlhttp.responseText == "ERROR") {
			                alert("<spring:message code='ezBoard.t1020'/>");
			                return;
			            }
		
		                xmlhttp = null;
		                try {
		                	window.opener.leftCountRf(pBoardID);
						} catch (e) {console.log(e);}
						
		                try {
		                    window.opener.refresh_onclick();
		                } catch (e) {console.log(e);}

	                    // 게시판 포틀릿 리스트 업데이트 되도록 수정
	                    try { // 공지사항 포틀릿 새로고침
		                    if (parent.opener != null && parent.opener.getNoticePortletList != undefined) {
		                    	parent.opener.getNoticePortletList();
		                    }
	                    } catch (e) {console.log(e);}

	                    try {
		                    if (window.opener != null && window.opener.getBoardList != undefined) {
								window.opener.getBoardList();
		                    }
	                    } catch (e) {console.log(e);}

	                 	
						try { // 카드 A형, 카드 B형, 리스트형 포틀릿 새로고침
				            if (parent.opener.refreshBordPortletInfo != undefined) {
				            	var customBoardList = parent.opener.document.getElementsByClassName("customBoard");
				            	var customBoardCount = customBoardList.length;
				            	
				            	for (var i = 0; i < customBoardCount; i++) {
				            		var boardId = customBoardList[i].querySelector(".portletPlus").getAttribute("data1");
				            		
				            		if (boardId == pBoardID) {
				            			var portletId = customBoardList[i].parentElement.id;
				            			portletId = portletId.substring(0, portletId.indexOf("P"));
				            			parent.opener.refreshBordPortletInfo(portletId);
				            		}
				            	}
				            }
	                 	} catch (e) {console.log(e);}
	                 	
	                 	try { // 탭게시판 포틀릿 새로고침
	                 		if (parent.opener.refreshTab != undefined) {
	                 			parent.opener.refreshTab();
	                 		}
	                 	} catch (e) {console.log(e);}
	                 	
	                 	try { // 즐겨찾기 포틀릿 새로고침
				            if (parent.opener.getBoardList_NewBoardSTD != undefined) {
								parent.opener.getBoardList_NewBoardSTD();
							}
	                 	} catch (e) {console.log(e);}
	                 	
	                 	try {
							if (parent.opener.search != undefined){
								parent.opener.search('skip');
							}
	                 	} catch (e) {console.log(e);}
			            
		                window.close();
		            }
		        }
		    }
		    function btn_Delete_Onclick_Complete(ret) {
		        if (ret == "cancel") {
		            alert("<spring:message code='ezBoard.t999022' />");
		            return;
		        }
		
                if (ret == "NO") {
                    alert("<spring:message code='ezBoard.t267' />");
                    return;
                }
                
                /* 2018-11-28 홍승비 - 크롬에서 confirm() 실행 시 현재 창 활성화를 위해 함수 동작 추가함 */
				if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezBoard.t196' />");
		            return;
		        } 
		        
		        if (!confirm("<spring:message code='ezBoard.t197' />")) {
		        	return;
		        }
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + ";", false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265' />");
		            return;
		        } else if (xmlhttp.responseText == "ERROR") {
	                alert("<spring:message code='ezBoard.t1020'/>");
	                return;
	            }
		
		        xmlhttp = null;
		        try {
                	window.opener.leftCountRf(pBoardID);
				} catch (e) {
				}
		        try {
		            window.opener.refresh_onclick();
		        } catch (e) {
		        }
				if(parent.opener.search != undefined){
					parent.opener.search('skip');
				}
		        window.close();
		    }
		 	 //강민수92
		    function btn_One_Line_Reply_Onclick() {
		    	if (OneLineReplyFlag == "1") {
		    		openBoardComment();
		    		return;
		    	} 
		    }
		    function btn_Reply_Onclick() {
		        if (Reply_FG != "true") {
		            alert("<spring:message code='ezBoard.t303' />");
		            return;
		        }
		        
	            window.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=reply";
	            
	            /* 2019-11-22 홍승비 - 익명게시물에 답변 작성하는 경우, 게시암호만큼 높이 조정 */
	            if (gubun == 2) {
	            	window.resizeTo(785, 820);
	            } else {
		        	window.resizeTo(785, 780);
	            }
		    }
		    function btn_Modify_Onclick() {
		        if (Write_FG != "true" && gubun != "2") {
		            alert("<spring:message code='ezBoard.t304' />");
		            return;
		        }
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && Edit_FG != "true") {
		            alert("<spring:message code='ezBoard.t304' />");
		            return;
		        }
		        
		        var portletId = "";
		     	// 게시판 포틀릿 리스트 업데이트 되도록 수정
	            if (parent.opener != null && parent.opener.refreshBordPortletInfo != undefined) {
	            	portletId = "<c:out value='${portletId}'/>";
	            }
		     	
	            if (parent.opener != null && parent.opener.getBoardList_NewBoardSTD != undefined) {
					parent.opener.getBoardList_NewBoardSTD();
				}
	            
		        //익명게시판
		        if (gubun == "2") {
		            if (CrossYN()) {
		                checkpassword_dialogArguments = new Array();
		                checkpassword_dialogArguments[1] = btn_Modify_Onclick_Complete;
		                var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID), "CheckPassWord", GetOpenWindowfeature(470, 200));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + encodeURIComponent(pItemID), "", "status:no;dialogWidth:470px;dialogHeight:200px;help:no;scroll:no");
		                if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		                if (ret == "NO") {
		                    alert("<spring:message code='ezBoard.t267' />");
		                    return;
		                }
		            }
		        }
		        
		        if (gubun != "2") {
	                window.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=" + pReservedItem + "&portletId=" + portletId + "&historyModify=" + historyModify + "&version=" + version;
		            window.resizeTo(820, 780);
		        }
		    }
		    
		    function btn_Modify_Onclick_Complete(ret) {
		        if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		
		        if (ret == "NO") {
		            alert("<spring:message code='ezBoard.t267' />");
		            return;
		        }
		
	            window.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=" + pReservedItem;
		        window.resizeTo(785, 780);
		    }
		    
		    /* 2018-07-11 홍승비 - 게시물 복사 시 guBun 파라미터 추가 */
			var copyboarditem_cross_dialogArguments = new Array();
		    function btn_Copy_Onclick() {
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && Edit_FG != "true") {
		            alert("<spring:message code='ezBoard.t202' />");
				    return;
		        }
		
		        if (pAttributeYN == "Y") {
		            alert("<spring:message code='ezBoard.t999071' />");
		            return;
		        }
		
		        var pheigth = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheigth = parseInt(pheigth) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheigth = pheigth + 1000;
		        pwidth = pwidth - 127;
		        var feature = "height=600px,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth;
		        feature = feature + GetOpenPosition(pheigth,pwidth);
		        copyboarditem_cross_dialogArguments[1] = CopyItem_onclick_Complete
		        window.open("/ezBoard/copyBoardItem.do?itemIDList=" + encodeURIComponent(pItemID) + ";" + "&boardID=" + encodeURIComponent(pBoardID) + "&guBun=" + gubun, "", feature, "");
		    }
		    /* 2019-07-09 홍승비 - 게시물 읽기창에서 복사 후 좌측 게시물카운트 갱신 */
		    function CopyItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined" && ret != "") {
		            if (ret != "ERROR") {
			            try {
			            	window.opener.leftCountRf(ret);
						} catch (e) {}
		            }
		        }
		    }
		
		    /* 2018-07-11 홍승비 - 게시물 이동 시 guBun 파라미터 추가 */
		    var moveboarditem_cross_dialogArguments = new Array();
		    function btn_Move_Onclick() {
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && Edit_FG != "true") {
		            alert("<spring:message code='ezBoard.t202' />");
				    return;
		        }
		
		        if (pAttributeYN == "Y") {
		            alert("<spring:message code='ezBoard.t999072' />");
		            return;
		        }
		
		        if (CheckIfHasReplies()) {
		            alert(strLang26);
		            return;
		        }
		
		        if (CrossYN()) {
		            moveboarditem_cross_dialogArguments[1] = btn_Move_Onclick_Complete;
		            var OpenWin = window.open("/ezBoard/moveBoardItem.do?itemIDList=" + encodeURIComponent(pItemID) + ";" + "&boardID=" + encodeURIComponent(pBoardID) + "&guBun=" + gubun, "MoveBoardItem", GetOpenWindowfeature(355, 600));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var pheigth = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            pheigth = parseInt(pheigth) / 2;
		            pwidth = parseInt(pwidth) / 2;
		            pheigth = pheigth - 200;
		            pwidth = pwidth - 127;
		            
		            var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + encodeURIComponent(pItemID) + ";" + "&boardID=" + encodeURIComponent(pBoardID) + "&guBun=" + gubun, "", "DialogHeight:600px;DialogWidth:355px;status:no;help:no;edge:sunken;scroll:no");
		            
		            if (typeof (ret) != "undefined" && ret != "") {
		                if (ret != "ERROR") {
		                	window.opener.leftCountRf(pBoardID + ";" + ret); // 기존 게시판과 이동 목표 게시판의 카운트를 갱신
		                    window.opener.location.reload();
		                    window.close();
		                }
		            }
		        }
		    }
		    function btn_Move_Onclick_Complete(ret) {
		        if (typeof (ret) != "undefined" && ret != "") {
		            if (ret != "ERROR") {
		            	window.opener.leftCountRf(pBoardID + ";" + ret);
		                window.opener.location.reload();
		                window.close();
		            }
		        }
		    }
		    
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=board", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
		    
		    function btnClose_onclick() {
		        window.close();
		    }
		    function SetAttachmentInfo() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + encodeURIComponent(pItemID), false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);

		        var i = 0;
		        var pos = 0;
		        var filenameOrg = "";
		        var filenameView = "";
		        var filepath = "";
		        var strAttach = "";
		        var fileImage = "";
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        var regData = GetbrowserLanguage();
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
		            /* 2018-04-27 홍승비 - 화면에 표시되는 파일명 특문처리 수정 */
		            filenameOrg = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filenameView = MakeXMLString(filenameOrg);
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            
		            var strTarget = "target=''";
		            var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
		            if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
		               strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
		               strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
		               strFileExt == ".xlsx" || strFileExt == ".rtf") {
		                strTarget = "target=''";
		            }
		            
		            if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
		                fileImage = "/images/image.png";
		            else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
		                fileImage = "/images/doc.png";
		            else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
		                fileImage = "/images/xls.png";
		            else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
		                fileImage = "/images/ppt.png";
		            else if (strFileExt.indexOf(".txt") != -1)
		                fileImage = "/images/txt.png";
		            else if (strFileExt.indexOf(".zip") != -1)
		                fileImage = "/images/zip.png";
		            else if (strFileExt.indexOf(".pdf") != -1)
		                fileImage = "/images/pdf.png";
		            else if (strFileExt.indexOf(".ecm") != -1)
		                fileImage = "/images/ecm.png";
		            else
		                fileImage = "/images/email/mail_006.gif";
		
		            var protocol = window.location.protocol;
		            var serverName = window.location.hostname;
		            
		            /* 2020-01-30 홍승비 - 모두저장 기능을 위해 속성 추가 */
		            strAttach += "<div class='custom_checkbox'><input type='checkbox' name='fileSelect' value='" + filenameView + "' filePath='" + MakeXMLString(filepath) + "' id='fileSelect" + i + "'>";
		            strAttach += "<label for='fileSelect" + i + "'><img src='" + fileImage + "' style='vertical-align: middle;'> <a href='/ezBoard/boardAttachDown.do?filePath=" + javaURLEncode(filepath) + "&fileName=" + javaURLEncode(filenameOrg) + "'\">";
		            strAttach += filenameView + "&nbsp;(" + filesize + ")</a>";
		            // 2023-05-25 조수빈 - 게시판 첨부파일 미리보기 아이콘 추가
		            if (typeof useBoardFilePrvw !== 'undefined' && useBoardFilePrvw == "1") {
			            strAttach += "<span class='icon_rbtn2' style='margin-left : 10px;' title='<spring:message code = 'ezEmail.t487'/>' onclick=\"attachFile_Preview('" + javaURLEncode(filepath) + "', '" + javaURLEncode(filenameOrg) + "');\"><img src='/images/icon_preview.png' width='16' height='16' style='vertical-align:middle; cursor:pointer;'></span>";
		            }
		            strAttach += "</label></div><br>";
		        }
		        document.getElementById('lstAttachLink').innerHTML = strAttach;
		    }
		    
		 	// 2023-05-25 조수빈 - 게시판 첨부파일 미리보기
		    function attachFile_Preview(filePath, fileOrgName) {
		    	$.ajax({
		    		type : "GET",
		    		url : "/ezBoard/attachItemPreview.do",
		    		data : {
		    			pFilePath : filePath,
		    			fileName : fileOrgName
		    		},
		    		success : function(result) {
		    			if (result != "") {
		    				window.open(result, '_blank', getOpenWindowfeature(1100, 950));
		    			} else {
			    			alert("<spring:message code = 'ezBoard.t181'/>");
		    			}
		    		},
		    		error : function(e) {
		    			alert("<spring:message code = 'ezBoard.t181'/>");
		    			console.log(e);
		    		}
		    	});
		    }
		 	
		    function attach_SelectAll() {
		        var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");
		        for (var i = 0; i < checks.length; i++)
		            checks.item(i).checked = true;
		    }
		    
		    /* 2020-01-30 홍승비 - 체크한 파일이 1개 이상인 경우, zip 파일로 다운받도록 수정 */
		    function attach_Download() {
		        var checks = document.getElementById('lstAttachLink');
		        //downloadAll(checks);
		        AttachAllDownload(checks);
		    }
		    
		    var suffix = 0;
		    function downloadAll(checks) {
		        if (checks.getElementsByTagName("input").item(suffix)) {
		            if (checks.getElementsByTagName("input").item(suffix).checked) {
		                location.href = GetAttribute(checks.getElementsByTagName("a").item(suffix++), "href");
		                setTimeout(function () { downloadAll(checks) }, 1000);
		            }
		            else {
		                suffix++;
		                downloadAll(checks);
		            }
		        }
		        else
		            suffix = 0;
		    }
		    
		    /* 2020-01-30 홍승비 - 체크한 파일이 1개 이상인 경우, zip 파일로 다운받는 함수 */
	        function AttachAllDownload(checks) {
	            var checkedFiles = $("#lstAttachLink").find("input:checkbox[name='fileSelect']:checked");
	            var checkedFilesLength = checkedFiles.length;
	            var filePath = ""; // 전체파일경로
	            var filePathTemp = "";
				var fileNames = ""; // 파일이름
				var fileNamesUID = ""; // 파일이름(UID 포함)
				
				if (checkedFilesLength == 1) { // 하나만 저장
					downloadAll(checks);
				}
				else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
					filePath = GetAttribute(checkedFiles.get(0), "filepath");
					filePath = filePath.substr(0, filePath.lastIndexOf("/") + 1);
					
					for (var i = 0; i < checkedFilesLength; i++) {
						filePathTemp = GetAttribute(checkedFiles.get(i), "filepath"); // 각 파일의 풀경로
						fileNames += MakeXMLString(checkedFiles.get(i).value) + ":"; // 각 파일의 이름을 :로 이어붙인 것
						fileNamesUID += MakeXMLString(filePathTemp.substr(filePathTemp.lastIndexOf("/"), filePathTemp.length)) + ":"; // 각 파일의 이름+UID를 :로 이어붙인 것
					}
					
					var $frm = $("<form></form>");
			    	$frm.attr('action', "/ezBoard/downloadAttachAll.do");
			    	$frm.attr('method', 'post');
			    	$frm.appendTo('body');
			
			    	param1 = $('<input type="hidden" value="' + filePath + '" name="filePath" />');
			    	param2 = $("<input type='hidden' value='" + fileNames + "' name='fileNames' />");
			    	param3 = $("<input type='hidden' value='" + fileNamesUID + "' name='fileNamesUID' />");
			    	
			    	$frm.append(param1).append(param2).append(param3);
			    	$frm.submit();
				}
				else { // 체크된 파일 없음
					return;
				}
	        }
		    
		    /* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		    function MemberInfo_onclick(pUserID, pDeptID) {
		        var feature = "height=490px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 490);
		        window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID + "&dept=" + pDeptID, "", feature);
		    }
		    function mail_boarditem() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/ezEmail/mailWrite.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&cmd=board";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		        window.close();
		    }
		    var item_readlist_cross_dialogArguments = new Array();
		    function ReaderList() {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 620) / 2;
		        var top = (heigth - 425) / 2;
		        var szHref = "/ezBoard/itemReadList.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID);
		        var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";
		        if (CrossYN()) {
		            item_readlist_cross_dialogArguments[0] = "";
		            item_readlist_cross_dialogArguments[1] = ReaderList_Complete;
		            DivPopUpShow(620, 425, szHref);
		        }
		        else
		            window.open(szHref, "", "width=620, height=425, resizable=yes, scrollbars=yes, top="+top+", left=" + left);
		    }
		    function ReaderList_Complete() {
		        DivPopUpHidden();
		    }
		    
		    function printOption_close() {
		    	DivPopUpHidden();	
		    }
		    var boarditemview_cross_print_option_dialogArguments = new Array();
		    var url = window.location.href;
		    function btn_Print_Onclick() {
				var url = "/ezBoard/boardItemViewPrintOption.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID);
				if (CrossYN()) {
		            //url = window.location.href;
		            //url = url.replace(".do", "PrintOption.do");
		            boarditemview_cross_print_option_dialogArguments[1] = btn_Print_Onclick_Complete;
		            DivPopUpShow(380, 200, url);
		            //var OpenWin = window.open(url, "boarditemview_print_option", GetOpenWindowfeature(380, 200));
		            //try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var parameter = "";
		            //url = window.location.href;
		            //url = url.replace(".do", "PrintOption.do");
		            var feature = "status:no;dialogWidth:380px;dialogHeight:200px;help:no;";
		            feature = feature + GetShowModalPosition(380, 200);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		            if (RtnVal[0] != "0" && RtnVal[1] != "0") {
		                url = url.replace("PrintOption.do", "Print.do");
		                url = url + "&oneLine=" + RtnVal[0] + "&attach=" + RtnVal[1];
		                window.open(url, "", "top=0, left=0, height=700px, width=840px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1");
		            }
		        }
		    }
		    function btn_Print_Onclick_Complete(RtnVal) {
		        if (RtnVal[0] != "0" && RtnVal[1] != "0") {
					var url = "/ezBoard/boardItemViewPrint.do?boardID=" + pBoardID + "&itemID=" + pItemID;
					//url = url.replace("PrintOption.do", "Print.do");
		            url = url + "&oneLine=" + RtnVal[0] + "&attach=" + RtnVal[1];
		            window.open(url, "", getOpenWindowfeature(840, 700));
		        }
		    }
		    
		    /* 2018-06-29 홍승비 - 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		    function OpenUserInfo(pUserID, pDeptID) {
		        var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "UserInfo", 420, 450, "NO");
		    }
// 		    function OneLineReply_onkeydown() {
// 		        if (event.keyCode == 13) Save_OneLineReply();
// 		    }
// 		    function Save_OneLineReply() {
// 		        if (Reply_FG != "true") {
// 		            alert("<spring:message code='ezBoard.t303' />");
// 				    return;
// 				}
// 		        if (OneLineReplyFlag == "1") {
// 		            if (document.getElementById('onelinereply').value == "") {
// 		                alert("<spring:message code='ezBoard.t307' />");
// 				        return;
// 				    }
// 		        }

// 		        if (gubun == "2" && trim(document.getElementById('txtPassWord').value) == "") {
// 		            alert("<spring:message code='ezBoard.t391' />");
// 				    document.getElementById('txtPassWord').focus();
// 				    return;
// 				}
// 		        var pReplyID = "";
// 		        pReplyID = "{" + GetGUID().toUpperCase() + "}";
		
// 				var content,password;
// 				if (OneLineReplyFlag == "1"){
// 					content = MakeXMLString(document.getElementById('onelinereply').value);
// 				}else{
// 					content = "";
// 				}
// 				if (gubun != "2") {
// 				    password = "";
// 				}
// 				else {
// 				    password = rsa.encrypt(document.getElementById("txtPassWord").value);
// 				}
		
// 				$.ajax({
// 					type : "POST",
// 					dataType : "text",
// 					async : false,
// 					url : "/ezBoard/saveOneLineReply.do",
// 					data : { boardID    : pBoardID, 
// 							 itemID 	: pItemID,
// 							 replyID	: pReplyID,
// 							 content	: content,
// 							 password	: password
								 
// 						   },
// 					success: function(){
// 						reloadOneline();
// 					}
// 				});
// 		    }
		    
// 			function reloadOneline(){
// 			    if (OneLineReplyFlag == "1")
// 			        document.getElementById('onelinereply').value = "";
// 			    if (gubun == "2")
// 			        document.getElementById('txtPassWord').value = "";
// 			    getOneLineReply();
// 			}
			
		    var delpReplyID = "";
// 		    function delete_onelinereply(pReplyID) {
// 		        delpReplyID = pReplyID;
// 		        var xmlhttp = createXMLHttpRequest();
		        
// 		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
// 		            if (gubun == "2") {
// 		                if (CrossYN()) {
// 		                	var feature = "status:no;dialogWidth:470px;dialogHeight:200px;help:no;scroll:no";
// 		                    feature = feature + GetShowModalPosition(470, 200);
// 		                    var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + pItemID + "&replyID=" + pReplyID, "", feature);
		                    
// 		                    if (ret == "NO") {
// 		                        alert("<spring:message code='ezBoard.t267' />");
// 		                        return;
// 		                    } else if (ret == "cancel" || ret == undefined) {
// 		                        alert(strLang27);
// 		                        return;
// 		                    }
		                    
// 		                    xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + pReplyID + "&guBun=" + gubun, false);
// 		                    xmlhttp.send();
// 		                    if (xmlhttp.responseText == "FAIL") {
// 		                        alert("<spring:message code='ezBoard.t310' />");
// 		                    }
		
// 		                    getOneLineReply();
// 		                    xmlhttp = null;
// 		                } else {		                	
// 		                    checkpassword_dialogArguments = new Array();
// 		                    checkpassword_dialogArguments[1] = delete_onelinereply_Complete;
// 		                    var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + pItemID + "&replyID=" + pReplyID, "CheckPassWord", GetOpenWindowfeature(470, 200));
// 		                    try { OpenWin.focus(); } catch (e) { }
// 		                }
		                
// 		            } else {
// 		                xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + pReplyID, false);
// 		                xmlhttp.send();
// 		                if (xmlhttp.responseText.substr(0, 2) != "OK") {
// 		                    alert("<spring:message code='ezBoard.t310' />");
// 		                    return;
// 		                }
// 		                if (!confirm("<spring:message code='ezBoard.t311' />")) return;
// 		            }
// 		        } else {
// 		        	if (!confirm("<spring:message code='ezBoard.t311' />")) return;
// 		        }
// 		        xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + pReplyID + "&guBun=" + gubun, false);
// 		        xmlhttp.send();	        
		        
// 		        if (xmlhttp.responseText == "FAIL") {
// 		            alert("<spring:message code='ezBoard.t310' />");
// 		        }
// 		        getOneLineReply();
// 		        xmlhttp = null;
// 		    }
// 		    function delete_onelinereply_Complete(ret) {
// 		        var xmlhttp = createXMLHttpRequest();
// 		        if (ret == "NO") {
// 		            alert("<spring:message code='ezBoard.t267' />");
// 		            return;
// 		        }
// 		        else if (ret == "cancel" || ret == undefined) {
// 		            alert(strLang27);
// 		            return;
// 		        }
		
// 		        xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + delpReplyID + "&guBun=" + gubun, false);
// 		        xmlhttp.send();
// 		        getOneLineReply();
// 		        xmlhttp = null;
// 		    }
// 		    function getOneLineReply() {
// 		        var xmlhttp = createXMLHttpRequest();
// 		        xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
// 		        xmlhttp.send();
// 		        var xmldom = createXmlDom();
// 		        xmldom = loadXMLString(xmlhttp.responseText);
// 		        xmlhttp = null;
// 		        strHTML = "";
// 		        var temp;
// 		        for (var i = 0; i < xmldom.getElementsByTagName("REPLYID").length; i++) {
// 		            temp = i + 1;
// 		            if (gubun != "2")
// 		                strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
// 		            else
// 		                strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
// 		        }
// 		        if (i == 0)
// 		            strHTML = "<spring:message code='ezBoard.t312' />";
// 		        try {
// 		            document.getElementById('onelinereplylist').innerHTML = strHTML;
// 		        }
// 		        catch (e) {
// 		        }
// 		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    /* 2020-01-30 홍승비 - 특수문자 파싱 추가 */
		    function MakeXMLString(p_str) {
		        p_str = ReplaceText(p_str, "&", "&amp;");
		        p_str = ReplaceText(p_str, "<", "&lt;");
		        p_str = ReplaceText(p_str, ">", "&gt;");
		        p_str = ReplaceText(p_str, "'", "&apos;");
		        p_str = ReplaceText(p_str, "\"", "&quot;");
		        return p_str;
		    }
		    function OpenItem(strItemID) {
		        if (strItemID != "") window.location.href = window.location.href.replace(pItemID, strItemID);
		    }
		    function Item_View_New(pBoardID, pItemID) {
		        var pheigth = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheigth = parseInt(pheigth) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheigth = pheigth - 284;
		        pwidth = pwidth - 359;

		        window.open("/ezBoard/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), "", "height=720,width=1000, status = no, toolbar=no, menubar=no,scrollbars=1, location=no, resizable=1, top=0, left=0", "");
		    }
		    //kms 미구현
		    function ToKMS() {
		        var url = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezKMS/kasset/KAssetConvert.aspx?Mode=new&Flag=board&ItemID=" + encodeURIComponent(pItemID) + "&boardid=" + encodeURIComponent(pBoardID) + "&url=" + strContentLocation;
		        window.open(url, "KAssetConvert", GetOpenWindowfeature(780, 800));
		    }
		    function trim(parm_str) {
		        if (parm_str == "")
		            return "";
		        else
		            return rtrim(ltrim(parm_str));
		    }
		    function ltrim(parm_str) {
		        var str_temp = parm_str;
		        while (str_temp.length != 0) {
		            if (str_temp.substring(0, 1) == " ") {
		                str_temp = str_temp.substring(1, str_temp.length);
		            }
		            else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		    function rtrim(parm_str) {
		        var str_temp = parm_str;
		        while (str_temp.length != 0) {
		            int_last_blnk_pos = str_temp.lastIndexOf(" ");
		            if ((str_temp.length - 1) == int_last_blnk_pos) {
		                str_temp = str_temp.substring(0, str_temp.length - 1);
		            }
		            else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		
		    var board_retransoption_dialogArguments = new Array();
		    function btn_Retrans_Onclick() {
		        if (CrossYN()) {
		            board_retransoption_dialogArguments[0] = "";
		            board_retransoption_dialogArguments[1] = btn_Retrans_Onclick_Complete;
		            DivPopUpShow(310, 200, "/ezBoard/boardRetransOption.do");
		
		        }
		        else {
		            var parameter = "";
		            var url = "/ezBoard/boardRetransOption.do";
		            var feature = "status:no;dialogWidth:300px;dialogHeight:200px;help:no;";
		            feature = feature + GetShowModalPosition(300, 200);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		            if (RtnVal != undefined) {
		                switch (RtnVal) {
		                    case "boardContent":
		                        Retrans_boardContent();
		                        break;
		                    case "boardAttach":
		                        Retrans_boardAttach();
		                        break;
		                    case "mailContent":
		                        Retrans_mailContent();
		                        break;
		                    case "mailAttach":
		                        Retrans_mailAttach();
		                        break;
		                    default:
		                }
		            }
		        }
		    }
		    
		    function btn_Retrans_Onclick_Complete(RtnVal) {
		        DivPopUpHidden();
		
		        if (RtnVal != undefined) {
		            switch (RtnVal) {
		                case "boardContent":
		                    Retrans_boardContent();
		                    break;
		                case "boardAttach":
		                    Retrans_boardAttach();
		                    break;
		                case "mailContent":
		                    Retrans_mailContent();
		                    break;
		                case "mailAttach":
		                    Retrans_mailAttach();
		                    break;
		                default:
		            }
		        }
		    }
		    function Retrans_boardContent() {
		        var feature = GetOpenWindowfeature(790, 820);
	            window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=boardContent&itemID=" + encodeURIComponent(pItemID), "", feature, "");
		    }
		    function Retrans_boardAttach() {
		        var feature = GetOpenWindowfeature(790, 820);
	            window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=boardAttach&itemID=" + encodeURIComponent(pItemID), "", feature, "");
		    }
		    function Retrans_mailContent() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/ezEmail/mailWrite.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&cmd=board";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }
		    function Retrans_mailAttach() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/ezEmail/mailWrite.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&cmd=board&retransType=boardAttach";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }
		    function Appr_onclick(pFlag) {
		        if (pFlag == "C") { // 반려
		            var OpenWin = window.open("/ezBoard/boardApprOpinion.do?itemList=" + encodeURIComponent(pItemID) + ";&mode=" + pFlag, "BoardApprOpinion", GetOpenWindowfeature(540, 300));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "/ezBoard/apprBoardItem.do?itemList=" + encodeURIComponent(pItemID) + ";&mode=" + pFlag, false);
		            xmlhttp.send();
		
		            if (xmlhttp.responseText == "OK") {
		            	/* 2023-11-17 홍승비 - 승인게시판의 게시물 승인 시 게시알림 발송 기능 추가 */
		                if (pFlag == "Y") { // 승인
		                	// 해당 게시판의 관리자에게 게시알림 발송 (게시판 권한설정 > 관리자 권한자인 경우 '게시 알림' 옵션)
		                	sendPostNotiForAdmin(pBoardID, pItemID);
		                	
		                	// 답변게시물이 아닌 경우
			                if (strParentWriteDate == strDocNo) {
			                	// 해당 게시판의 일반 사용자(접근 권한자)에게 게시알림 발송 (게시판 일반설정 > 메일알림 > '게시알림' 옵션)
			                	sendBoardAlert("new", pBoardID, pItemID, isAllGroupBoard);
			                }
			                else { // 답변게시물인 경우
			                	// 해당 게시물의 부모게시물 작성자에게 답변알림 발송 (게시판 일반설정 > '답변알림' 옵션)
			                	sendReplyNotice(pBoardID, pItemID, strUpperItemIDTree);
			                }
		                	
		                    alert("<spring:message code='ezBoard.t999002' />");
		                }
		                else { // 반려
		                    alert("<spring:message code='ezBoard.t999009' />");
		                }
		            }
		            try {
						window.opener.leftCountRf(pBoardID);
					} catch (e) {}
		
		            try {
		                window.opener.refresh_onclick();
		            } catch (e) {
		            }
		            window.close();
		        }
		    }
		    function refresh_onclick() {
		        try {
		            window.opener.refresh_onclick();
		        } catch (e) {
		        }
		        window.close();
		    }
		    
		    /* 2019-04-05 홍승비 - 좋아요 버튼 클릭 동작 */
		    /* 2023-04-06 기민혁 - 좋아요 버튼 클릭 동작 (수정) */
		    function clickLikeButton() {
		    	var mod = "";
		    	
		    	if (isDisLikeChecked == "Y"){
		    		mod = "DELETE";
		    		$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/clickDisLikeMod.do",
						data : {
							mod: mod,
							itemID : pItemID
						},
						success: function(result){
							isDisLikeChecked = result;

							if($("#disLikeDiv").length > 0){
								updateDisLikeCountImg(isDisLikeChecked);
							}
						}
					});
		    	}
		    	
		    	if (isLikeChecked == "Y" && isDisLikeChecked != "Y") {
		    		mod = "DELETE";
		    	} else {
		    		mod = "INSERT";
		    	}
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/clickLikeMod.do",
					data : {
						mod: mod,
						itemID : pItemID
					},
					success: function(result){
						isLikeChecked = result;
						updateLikeCountImg(isLikeChecked);
					}
				});
		    }
		    
		    /* 2019-04-05 홍승비 - 좋아요 버튼 이미지 및 좋아요 갯수 업데이트 */
		    function updateLikeCountImg(isLikeChecked) {
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					cache : false,
					url : "/ezBoard/getLikeCount.do",
					data : {
						itemID : pItemID
					},
					success: function(result){
						likeCountAfter = result;
						if (parseInt(result) > 0) {
							document.getElementById("likeCountSpan").innerText = "(" + result + ")";
						} else {
							document.getElementById("likeCountSpan").innerText = "";
						}
						if (isLikeChecked == "Y") {
				    		document.getElementById("likeButtonImg").src = "/images/like_on.png";
				    	} else {
				    		document.getElementById("likeButtonImg").src = "/images/like_off.png";
				    	}
						try {opener.refreshLikeAndDisLike(result,isLikeChecked,"like");}catch (e) {}

					}
				});
			}
				
		    /* 2019-04-12 홍승비 - 게시물 갱신 조건 체크 */
		    function checkRefreshFlag() {
		    	if (OneLineReplyFlag == "1") { // 레이어팝업의 경우 텍스트로 표출된 현재 댓글갯수를 가져옴
		    		nowCommentCount = document.getElementById("commentCount").innerText;
		    		nowCommentCount = nowCommentCount.substring(nowCommentCount.indexOf("[") + 1, nowCommentCount.indexOf("]"));
		    	}
		    	var opnenerHref = window.opener.location.href;
		    	
		    	// 댓글의 수가 달라졌고, 부모창의 주소가 게시판인 경우(새게시물 제외)에만 플래그값 변경
		    	if (((likeCount != likeCountAfter) || (disLikeCount != disLikeCountAfter) || (commentCount != nowCommentCount)) && (window.opener.location.href.indexOf("/ezBoard/") > -1) && (window.opener.location.href.indexOf("boardItemList_new") == -1)) {
		    		refreshFlag = "Y";
		    	} else {
		    		refreshFlag = "N";
		    	}
		    }
		    
		    /* 2020-12-23 홍승비 - 익명게시물 게시자명 특문처리 추가 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		  		str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");
		        return str;
		    }
		    
	        /* 2023-11-17 홍승비 - 관리자 권한자의 '게시 알림' 옵션에 대한 게시판 알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendPostNotiForAdmin(pBoardID, pItemID) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendPostNotiForAdmin.do",
					data : {
						boardID : pBoardID,
						itemID : pItemID
					}
				});
	        }
		    
	        /* 2023-11-17 홍승비 - 일반 사용자(접근 권한자)의 '게시알림' 옵션에 대한 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendBoardAlert.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID,
						isAllGroupBoard : pIsAllGroupBoard
					}
				});
	        }
	        
	        /* 2023-11-17 홍승비 - 답변게시물의 부모게시물 작성자의 '답변알림' 옵션에 대한 게시판 알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendReplyNotice(pBoardID, pItemID, pStrUpperItemIDTree) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendReplyNotice.do",
					data : {
						boardID : pBoardID,
						itemID : pItemID,
						itemTreeID : pStrUpperItemIDTree
					}
				});
	        }
		    
		    /* 2023-04-06 기민혁 - 싫어요 버튼 클릭 동작 */
		    function clickDisLikeButton() {
		    	var mod = "";
		    	
		    	if(isLikeChecked == "Y"){
		    		mod = "delect";
		    		$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/clickLikeMod.do",
						data : {
							mod: mod,
							itemID : pItemID
						},
						success: function(result){
							isLikeChecked = result;

							if($("#likeDiv").length > 0){
								updateLikeCountImg(isLikeChecked);
							}
						}
					});
		    	}
		    		
		    	if (isDisLikeChecked == "Y" && isLikeChecked != "Y") {
		    		mod = "DELETE";
		    	} else {
		    		mod = "INSERT";
		    	}
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/clickDisLikeMod.do",
					data : {
						mod: mod,
						itemID : pItemID
					},
					success: function(result){
						isDisLikeChecked = result;
						updateDisLikeCountImg(isDisLikeChecked);
					}
				});
		    }
		    
		    /* 2023-04-06 기민혁 - 싫어요 버튼 이미지 및 싫어요 갯수 업데이트 */
		    function updateDisLikeCountImg(isDisLikeChecked) {
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					cache : false,
					url : "/ezBoard/getDisLikeCount.do",
					data : {
						itemID : pItemID
					},
					success: function(result){
						disLikeCountAfter = result;
						if (parseInt(result) > 0) {
							document.getElementById("disLikeCountSpan").innerText = "(" + result + ")";
						} else {
							document.getElementById("disLikeCountSpan").innerText = "";
						}
						if (isDisLikeChecked == "Y") {
				    		document.getElementById("disLikeButtonImg").src = "/images/disLike_on.png";
				    	} else {
				    		document.getElementById("disLikeButtonImg").src = "/images/disLike_off.png";
				    	}
						try {opener.refreshLikeAndDisLike(result,isDisLikeChecked,"disLike");}catch (e) {}

					}
				});
			}
		    
		    /* 2023-04-06 기민혁 - 미리보기 에서  좋아요/싫어요 버튼 클릭시  이미지 및  개수 업데이트 */
		    function refreshLikeAndDisLikeOpen(result,checked,gubun){
		    	if(gubun === "disLike"){
		    		isDisLikeChecked = checked ;
			    	if (parseInt(result) > 0) {
						document.getElementById("disLikeCountSpan").innerText = "(" + result + ")";
					} else {
						document.getElementById("disLikeCountSpan").innerText = "";
					}
					if (isDisLikeChecked == "Y") {
			    		document.getElementById("disLikeButtonImg").src = "/images/disLike_on.png";
			    	} else {
			    		document.getElementById("disLikeButtonImg").src = "/images/disLike_off.png";
			    	}
		    	}else if(gubun === "like"){
		    		isLikeChecked = checked;
		    		if (parseInt(result) > 0) {
						document.getElementById("likeCountSpan").innerText = "(" + result + ")";
					} else {
						document.getElementById("likeCountSpan").innerText = "";
					}
					if (isLikeChecked == "Y") {
			    		document.getElementById("likeButtonImg").src = "/images/like_on.png";
			    	} else {
			    		document.getElementById("likeButtonImg").src = "/images/like_off.png";
			    	}
		    	}
		    }
		    
	        function Editor_Complete() {
	        	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(strContentLocation);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	        }
	        
	        function FieldsAvailable(isTrue) {
	        	if (isTrue) {
	        		message.EditMode(0);
	        		message.ShowToolBar(false);
	        		message.ShowRibbon(false);
					message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            window.onresize();
	        	}
	        }
	        
		   
		    /* 2023-05-03 기민혁 -  스크랩 추가 클릭시 data insert */
		    function addScrapType1() {
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezBoard/setScrapItem.do",
					data : {
						itemID : pItemID,
						boardID : pBoardID
					},
					success: function(result){
						if(result == "true"){
							alert("<spring:message code='ezBoard.t269' />");
							var addScrapBtn = document.getElementById('addScrapBtn');
								addScrapBtn.id = 'delScrapBtn';
							var spanElement = addScrapBtn.querySelector('span');
								spanElement.onclick = delScrap
								spanElement.setAttribute("onclick", "delScrap();");
								spanElement.innerText = "<spring:message code='ezBoard.kmh14'/>";
							
							var layerSelect = document.getElementById('moreBoardIcon');
							if (layerSelect) {
								var addScrapBtn2 = layerSelect.querySelector('li#addScrapBtn');
								if (addScrapBtn2) {
									addScrapBtn2.id = 'delScrapBtn';
									var spanElement2 = addScrapBtn2.querySelector('span');
									spanElement2.onclick = delScrap
									spanElement2.setAttribute("onclick", "delScrap();");
									spanElement2.innerText = "<spring:message code='ezBoard.kmh14'/>";
								}
							}
						} else if (result == "false") {
							alert("<spring:message code='ezBoard.kmh001' />");
							document.getElementById("addScrapBtn").innerHTML = "<li id ='delScrapBtn'><span onclick='delScrap()''><spring:message code='ezBoard.kmh14'/></span></li>";
						} else if(result == "error"){
							alert("<spring:message code='ezBoard.kmh17' />");
						}
					}
				});
			}
			
			function addScrapType2() {
    	        var url = "/ezBoard/selUserScrapCont.do";
    	        ContOpen = GetOpenWindow(url + "?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), "selUserCont", 500, 460, "NO");
    	        try { ContOpen.focus() } catch (e) { }
			}
			
			function addScrap() {
			    if (myBoardScrapFlag == "TYPE1") {
			        addScrapType1();
			    } else if (myBoardScrapFlag == "TYPE2") {
			        addScrapType2();
			    } else {
			        alert("오류발생");
			    }
			}
		    
		    /* 2023-05-03 기민혁 -  스크랩 해제 클릭시 data delete */
		    function delScrap() {
		        var pUrl = "";
		        var pData = new FormData();
		        var pType;
		        if (myBoardScrapFlag == "TYPE1") {
		            pUrl = "/ezBoard/delScrapItem.do";
		            pData.append("itemID", pItemID);
		            pData.append("boardID", pBoardID);
		        } else if (myBoardScrapFlag == "TYPE2") {
		            pUrl = "/ezBoard/deleteScrapContItemList.do";
		            pData.append("itemList", pItemID + ";");
		            pData.append("scrapContID", scrapContID);
		        } else {
		            alert("<spring:message code='ezBoard.kmhScrap52' />");
		            return;
		        }
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : pUrl,
					data : pData,
					contentType: false,
					processData: false,
					success: function(result) {
						if (result == "true") {
							alert("<spring:message code='ezBoard.kmh18' />");
							
							if (myBoardScrapFlag == "TYPE1") {
								var delScrapBtn = document.getElementById('delScrapBtn');
									delScrapBtn.id = 'addScrapBtn';
								var spanElement = delScrapBtn.querySelector('span');
									spanElement.onclick = addScrap;
									spanElement.setAttribute("onclick", "addScrap();");
									spanElement.innerText = "<spring:message code='ezBoard.kmh13'/>";

								var layerSelect = document.getElementById('moreBoardIcon');
								if (layerSelect) {
									var delScrapBtn2 = layerSelect.querySelector('li#delScrapBtn');
									if (delScrapBtn2) {
										delScrapBtn2.id = 'addScrapBtn';
										var spanElement2 = delScrapBtn2.querySelector('span');
										spanElement2.onclick = addScrap
										spanElement2.setAttribute("onclick", "addScrap();");
										spanElement2.innerText = "<spring:message code='ezBoard.kmh13'/>";
									}
								}
							} else if (myBoardScrapFlag == "TYPE2") {
							    document.getElementById("delScrapBtn").replaceChildren();
							} else {
								alert("<spring:message code='ezBoard.kmhScrap52' />");
		                        return;
							}
							
							if (window.opener && !window.opener.closed && (window.opener.location.href.indexOf("boardMyScrapList") !== -1 || window.opener.location.href.indexOf("BoardScrapContItemListView") !== -1)) {
								window.close();
								window.opener.refresh_onclick();
							} 
						} else {
						     alert("<spring:message code='ezBoard.kmh17' />");
						}
					}
				});
			}

            <%-- 재게시 기능 --%>
            function btn_Repost_Onclick() {
                var newStartDate = new Date(strStartDate + " UTC");
                var newEndDate = new Date(strEndDate);
                var currentDate = new Date();

                if (newStartDate > currentDate) {
                    alert("예약게시물 및 공개시기가 지나지 않은 게시물은 재게시가 불가능합니다.");
                    return;
                }

                if (newEndDate < currentDate) {
                    alert("게시기간이 만료된 게시물은 재게시가 불가능합니다.");
                    return;
                }
                
                btn_Repost_Onclick_complete("OK");
               
            }
            
            function btn_Repost_Onclick_complete(ret) {
                if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;

                if (ret == "NO") {
                    alert("<spring:message code='ezBoard.t267' />");
                    return;
                }
                
                if(confirm("재게시를 하시면 최근 게시물로 등록됩니다.\n재게시 하시겠습니까?")) {
                    var xmlhttp = createXMLHttpRequest();
                    xmlhttp.open("POST", "/ezBoard/repostItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&userID=" + userInfoID +  "&hasReply=" + CheckIfHasReplies(), false);
                    xmlhttp.send();

                    if (xmlhttp.responseText == "SUCCESS") {
                        alert("재게시가 완료되었습니다.");
                        window.location.reload();

                        //if (boardItemView == "P") {
                            window.opener.location.reload();
                        //}
                    }
                }
            }
            
            var zoomSettings = {};
            var MozZoomSettings = {};

            function initializeZoom(num) {
                zoomSettings[num] = {
                    nowZoom: parseInt("<c:out value='${contentSize}'/>"),
                    maxZoom: 200,
                    minZoom: 100
                };

                MozZoomSettings[num] = {
                    MozNowZoom: parseInt("<c:out value='${mozContentSize}'/>"),
                    MozMaxZoom: 2,
                    MozMinZoom: 1
                };
            }

            function Bigger2(doc, num) {
                if (zoomSettings[num] === undefined) {
                    initializeZoom(num);
                }

                var settings = zoomSettings[num];
                var MozSettings = MozZoomSettings[num];

                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    if (MozSettings.MozNowZoom < MozSettings.MozMaxZoom) {
                        MozSettings.MozNowZoom += 0.1;
                    } else {
                        return;
                    }

                    $(doc).find('.contentDiv' + num).css("MozTransform", "scale(" + MozSettings.MozNowZoom + ")");
                    $(doc).find('.contentDiv' + num).css("MozTransformOrigin", "0 0");
                } else {
                    if (settings.nowZoom < settings.maxZoom) {
                        settings.nowZoom += 10;
                    } else {
                        return;
                    }

                    $(doc).find(".contentDiv" + num).css("zoom", settings.nowZoom + "%");
                    $(doc).find("#curZoomSize" + num).text(settings.nowZoom + "%");
                    $(doc).find("#curZoomSize" + num).show();
                    setTimeout(function () {
                        $(doc).find("#curZoomSize" + num).css("display", "none")
                    }, 1000);
                }
            }

            function Smaller2(doc, num) {
                if (zoomSettings[num] === undefined) {
                    initializeZoom(num);
                }

                var settings = zoomSettings[num];
                var MozSettings = MozZoomSettings[num];

                if (navigator.userAgent.indexOf('Firefox') != -1) {
                    if (MozSettings.MozNowZoom > MozSettings.MozMinZoom) {
                        MozSettings.MozNowZoom -= 0.1;
                    } else {
                        return;
                    }

                    $(doc).find('.contentDiv' + num).css("MozTransform", "scale(" + MozSettings.MozNowZoom + ")");
                    $(doc).find('.contentDiv' + num).css("MozTransformOrigin", "0 0");
                } else {
                    if (settings.nowZoom > settings.minZoom) {
                        settings.nowZoom -= 10;
                    } else {
                        return;
                    }

                    $(doc).find(".contentDiv" + num).css("zoom", settings.nowZoom + "%");
                    $(doc).find("#curZoomSize" + num).text(settings.nowZoom + "%");
                    $(doc).find("#curZoomSize" + num).show();
                    setTimeout(function () {
                        $(doc).find("#curZoomSize" + num).css("display", "none")
                    }, 1000);
                }
            }
	        
			function viewModifyHistory() {
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = (width - 620) / 2;
				var top = (heigth - 425) / 2;
				var href = "/ezBoard/modifyHistory?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID);
				var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";

				DivPopUpShow(620, 425, href);
			}

			function viewContent(loc) {
				selectedViewFlag = loc;

				getItemAddrInfo(loc);

				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 790) / 2;
				var url = "/ezBoard/boardItemView.do?showAdjacent=&location=GENERAL&historyCheck=true";

				url += "&itemID=" + encodeURIComponent(addrInfo[2]);
				url += "&boardID=" + encodeURIComponent(addrInfo[1]);
				url += "&version=" + addrInfo[3];
				url += "&leftAddr=" + encodeURI(leftAddr);
				url += "&rightAddr=" + encodeURI(rightAddr);
				url += "&selectedAddr=" + encodeURI(selectedAddr);
				url += "&selectedViewFlag=" + loc;
				url += "&historyModify=true";

				window.open(url, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=790,top=" + pTop + ",left=" + pLeft, "");
				window.close();
			}

			function getItemAddrInfo(loc) {
				switch (loc) {
					case "left" : {
						addrInfo = leftAddr.split(";");

						break;
					}

					case "right" : {
						addrInfo = rightAddr.split(";");

						break;
					}

					case "my" : {
						addrInfo = selectedAddr.split(";");

						break;
					}

					default : {}
				}
			}

			function showModifyHistory() {
				var compareTargetHref = getCompareTarget();

				if (leftAddr != null) {
					pUrl = "/ezApprovalG/docViewerCompare.do?docHrefAfter=" + encodeURI(compareTargetHref) + "&docHrefBefore=" + encodeURI(selectedAddr.split(";")[0]);

					openwindow2(pUrl);

					return;
				}
			}

			function getCompareTarget() {
				switch (selectedViewFlag) {
					case "left" : {
						return leftAddr.split(";")[0];
					}

					case "right" : {
						return rightAddr.split(";")[0];
					}

					default : {}
				}
			}

			function openwindow2(wfileLocation) {
				try {
					var heigth = window.screen.availHeight;
					var width = window.screen.availWidth;
					var left = 0;
					var top = 0;
					var pleftpos;

					heigth = parseInt(heigth) - 70;
					width = parseInt(width) - 20;

					window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
				} catch (e) {
					alert("openwindow :: " + e.description);
				}
			}
		</script>
	</head>
	<body id="bodyPopup" class="popup" style="overflow:auto; height:100%;">
		<table class="layout" style="height:100%">
		  <tr>
		    <td style="vertical-align: top; height: 10px;">
		      <div id="menu">
			  <c:if test = "${ historyCheck eq 'true' }">
				  <ul>
					  <c:if test = "${ selectedViewFlag ne 'right' && rightAddr ne '' }">
					  <li>
						  <span onclick = "viewContent('right')"><spring:message code='ezBoard.versionManage.msg8' /></span>
					  </li>
					  </c:if>

					  <c:if test = "${ selectedViewFlag ne 'my' }">
					  <li>
						  <span onclick = "viewContent('my')"><spring:message code='ezBoard.versionManage.msg10' /></span>
					  </li>
					  </c:if>

					  <c:if test = "${ selectedViewFlag ne 'left' && leftAddr ne '' }">
					  <li>
						  <span onclick = "viewContent('left')"><spring:message code='ezBoard.versionManage.msg9' /></span>
					  </li>
					  </c:if>

					  <%-- 수정 : 선택한 버전의 글만 수정 가능 --%>
					  <c:if test = "${ selectedViewFlag eq 'my' }">
					  	  <li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
					  </c:if>

					  <%-- 삭제 : 최종 수정본이 아닌 중간 버전의 글만 삭제 가능 --%>
					  <c:if test = "${ newestVersionFlag ne 'Y' }">
					  	  <li ID='btn_Delete'><span class="icon16 popup_icon16_delete" onclick='btn_Delete_Onclick(`only`)'></span></li>
					  </c:if>

					  <c:if test = "${ selectedViewFlag ne 'my' }">
					  <li>
						  <span onclick = "showModifyHistory()"><spring:message code='ezBoard.versionManage.msg11' /></span>
					  </li>
					  </c:if>
				  </ul>
			  </c:if>
			  <c:if test = "${ historyCheck ne 'true' }">
		        <ul>
		        	<c:choose>
		        		<c:when test="${pReservedItem == 'true'}">
		        			<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		        			<c:if test="${boardItem.itemLevel == 1 && (boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK')}"><%-- 답변글은 재게시 버튼 안뜨도록 함 --%>
                                <li ID='btn_Repost'><span onclick='btn_Repost_Onclick()'><spring:message code='ezBoard.lhr04'/></span></li>
                            </c:if>
		                    <li ID='btn_Delete' onclick='btn_Delete_Onclick()'><span class="icon16 popup_icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t113' /></span></li>
		        		</c:when>
		        		<c:when test="${apprFlag == 'N'}">
		        			<li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005' /></span></li>
		                    <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014' /></span></li>
		                    	<c:if test="${boardItem.writerID == userInfo.id || (boardItem.writerNameType == '1' && boardItem.writerDeptID == userInfo.deptID)}">
			                        <li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
			                        <li ID='btn_Delete' onclick='btn_Delete_Onclick()'><span class="icon16 popup_icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t113' /></span></li>
		                    	</c:if>
		        		</c:when>
		        		<c:when test="${apprFlag == 'C'}">
		        			<li><span onClick="btn_Modify_Onclick()"><spring:message code='ezBoard.t999021' /></span></li>
		        		</c:when>
		        		<c:when test="${apprFlag == 'W'}">
		        			<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		        			<c:if test="${boardItem.itemLevel == 1 && (boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK')}"><%-- 답변글은 재게시 버튼 안뜨도록 함 --%>
                                <li ID='btn_Repost'><span onclick='btn_Repost_Onclick()'><spring:message code='ezBoard.lhr04'/></span></li>
                            </c:if>
		                    <li ID='btn_Delete' onclick='btn_Delete_Onclick()'><span class="icon16 popup_icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t113' /></span></li>
		        		</c:when>
		        		<c:otherwise>
		        			<c:choose>
			        			<c:when test="${guBun == '2'}">
					        		<!--		강민수92	   -->
			        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
			        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81' />[${commentCount}]</span></li>
			        				</c:if>
									<!--		강민수92 end -->				        				
		        					<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
			        				<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
			        				<%-- 2020-02-11 홍승비 - 익명게시판 게시물도 관리자인 경우 이동, 복사 가능하도록 수정(boardGroupAdmin_FG이 OK라면 boardAdmin_FG값도 true) --%>
		                        	<c:if test="${boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK'}"> 
				                        <li ID='btn_Copy'><span onclick='btn_Copy_Onclick()' ><spring:message code='ezBoard.t274' /></span></li>
							            <li ID='btn_Move'><span onClick="btn_Move_Onclick()"><spring:message code='ezBoard.t134' /></span></li>
                        			</c:if>
			        				<li ID='btn_Delete' onclick='btn_Delete_Onclick()'><span class="icon16 popup_icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t113' /></span></li>
			                        <li ID='btn_Print' onclick='btn_Print_Onclick()'><span class="icon16 popup_icon16_print switchIcon"></span><span class="iconTexts"><spring:message code='main.t73'/></span></li>
			                        <c:if test="${useExternalMailServer eq 'NO' }">
			                        <li ID='btn_Mail' onclick='mail_boarditem()'><span class="icon16 popup_icon16_mail_gray switchIcon"></span><span class="iconTexts"><spring:message code='ezEmail.t177'/></span></li>
			                        </c:if>
			        			</c:when>
			        			<c:when test="${boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK' || (boardItem.writerNameType == '1' && boardItem.writerDeptID == userInfo.deptID)}">
		        					<!--		강민수92	   -->
			        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
			        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81' />[${commentCount}]</span></li>
			        				</c:if>
									<!--		강민수92 end -->			        				
		        					<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
			        				<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
			        				<c:if test="${boardItem.itemLevel == 1}">
                                        <li ID='btn_Repost'><span onclick='btn_Repost_Onclick()'><spring:message code='ezBoard.lhr04'/></span></li>
                                    </c:if>
			                        <c:if test="${guBun != '2'}">
										<li ID='btn_Copy'><span onclick='btn_Copy_Onclick()' ><spring:message code='ezBoard.t274' /></span></li>
										<%--게시물이동추가--%>
										<li ID='btn_Move'><span onClick="btn_Move_Onclick()"><spring:message code='ezBoard.t134' /></span></li>
			                        	<li ID='btn_Reader'><span onclick='ReaderList()' ><spring:message code='ezBoard.t320' /></span></li>
			                    	</c:if>
									<c:if test = "${ useVersion eq 'Y' }">
										<li id = "btn_modifyHistory">
											<span onclick = "viewModifyHistory()"><spring:message code = "ezBoard.versionManage.msg2" /></span>
										</li>
									</c:if>
			                    	<li ID='btn_Delete' onclick='btn_Delete_Onclick()'><span class="icon16 popup_icon16_delete switchIcon"></span><span class="iconTexts"><spring:message code='ezBoard.t113' /></span></li>
		                        	<li ID='btn_Print' onclick='btn_Print_Onclick()'><span class="icon16 popup_icon16_print switchIcon"></span><span class="iconTexts"><spring:message code='main.t73'/></span></li>
		                        	<c:if test="${useExternalMailServer eq 'NO' }">
		                        	<li ID='btn_Mail' onclick='mail_boarditem()' ><span class="icon16 popup_icon16_mail_gray switchIcon"></span><span class="iconTexts"><spring:message code='ezEmail.t177'/></span></li>
		                        	</c:if>
			        			</c:when>
			        			<c:otherwise>
				        			<!--		강민수92	   -->
			        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
			        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81' />[${commentCount}]</span></li>
			        				</c:if>
									<!--		강민수92 end -->			        				
			                        <li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
			                        <li ID='btn_Read' ><span onclick='ReaderList()' ><spring:message code='ezBoard.t320' /></span></li>
									<c:if test = "${ useVersion eq 'Y' }">
										<li id = "btn_modifyHistory">
											<span onclick = "viewModifyHistory()"><spring:message code = "ezBoard.versionManage.msg2" /></span>
										</li>
									</c:if>
			                        <li ID='btn_Print' onclick='btn_Print_Onclick()'><span class="icon16 popup_icon16_print switchIcon" ></span><span class="iconTexts"><spring:message code='main.t73'/></span></li>
			                        <li ID='btn_Mail' style="display:none;" onclick='mail_boarditem()' ><span class="icon16 popup_icon16_mail_gray switchIcon" ></span><span class="iconTexts"><spring:message code='ezEmail.t177'/></span></li>
			        			</c:otherwise>
		        			</c:choose>
		        		</c:otherwise>
		        	</c:choose>
		        	<c:if test="${useEzKMS == 'YES' && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
		        		<c:if test="${boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK'}">
		        			<li  ID='btn_KMS' style="display:none;"><span onclick='ToKMS()'>KMS <spring:message code='ezBoard.t98' /></span></li>
		        		</c:if>
		        	</c:if>
		        	<c:if test="${(boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
		        		<li ID='Retrans'><span onclick='btn_Retrans_Onclick()'><spring:message code='ezBoard.t10100' /></span></li>
		        	</c:if>
					<%-- 2024-02-02- 홍승비 - 게시물 승인 > 승인되지 않은 게시물 팝업창에서 캐비넷등록 버튼이 표출되는 오류 수정 (apprFlag값이 'W'인 경우는 승인게시판인데도 승인자가 없는 경우임) --%>
					<c:if test="${useCabinet == 'YES' && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
						<li><span onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
					</c:if>
					<c:if test="${MyBoardScrapFlag != 'NONE' && apprFlag != 'N'}">
						<c:choose>
							<c:when test="${MyBoardScrapFlag eq 'TYPE1' && isScrap ne 'true'}">
								<li id ="delScrapBtn"><span onclick="delScrap()"><spring:message code='ezBoard.kmh14'/></span></li>
							</c:when>
							<c:when test="${MyBoardScrapFlag eq 'TYPE2' && not empty scrapContID}">
								<li id ="addScrapBtn"><span onclick="addScrap()"><spring:message code='ezBoard.kmh13'/></span></li>
								<li id ="delScrapBtn"><span onclick="delScrap()"><spring:message code='ezBoard.kmh14'/></span></li>	
							</c:when>
							<c:when test="${empty MyBoardScrapFlag || MyBoardScrapFlag eq 'NONE'}">
							</c:when>
							<c:otherwise>
							    <li id ="addScrapBtn"><span onclick="addScrap()"><spring:message code='ezBoard.kmh13'/></span></li>	
							</c:otherwise>
						</c:choose>
					</c:if>
		        </ul>
			  </c:if>
		      </div>    
		      <div id="close">
		        <ul>
		          <li><span onClick="btnClose_onclick()"></span></li>
		        </ul>
		      </div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
			</script>
		    </td>
		    </tr>
		    <tr>
				<td style="vertical-align: top; height: 10px; padding-bottom:10px;">
				<table class="content2" style="width:100%;">
					<!-- 게시자  -->
					<tr>
						<th style="width:10%;"><spring:message code='ezBoard.t223' /></th>
						<c:choose>
							<c:when test="${guBun != '2'}">
								<td id="WriteUserNM" style="width:40%;">
									<div style="vertical-align:middle;width:100%;overflow-y:auto;cursor:pointer" onclick='OpenUserInfo("${boardItem.writerID}", "${boardItem.writerDeptID} ")'>
										<c:out value="${boardItem.writerName}"/>
									</div>
								</td>
							</c:when>
							<c:otherwise>
								<td id="WriteUserNM" style="width:40%; white-space:nowrap">
									<div style="vertical-align:middle;width:100%;overflow-y:auto;">
										<c:out value="${boardItem.writerName}"/>
									</div>
								</td>
							</c:otherwise>
						</c:choose>
					<!-- 게시자 end -->
					<c:choose>
						<c:when test="${guBun != '2'}">
							<!-- 부서 -->
								<th style="width:10%;"><spring:message code='ezBoard.t322' /></th>
								<c:choose>
									<c:when test="${guBun != '2'}">
										<td id="User_DeptNM" style="width:40%; white-space:nowrap"><span>${boardItem.writerDeptName}</span></td>
									</c:when>
									<c:otherwise>
										<td id="User_DeptNM" style="width:40%; white-space:nowrap"><span>&nbsp;</span> </td>
									</c:otherwise>
								</c:choose>
						</tr>
								<!-- 부서 end -->
								<!-- 직위 -->
								<tr>
									<th><spring:message code='ezBoard.t290' /></th>
									<c:choose>
										<c:when test="${guBun != '2'}">
											<td id="User_JobTitle"><span>${boardItem.extensionAttribute3}</span> </td>
										</c:when>
										<c:otherwise>
											<th id="User_JobTitle"><span>&nbsp; </span> </th>
										</c:otherwise>
									</c:choose>
								<!-- 직위 end -->
								<!-- 사내전화 -->
									<th><spring:message code='ezPersonal.t177' /></th>
									<c:choose>
										<c:when test="${guBun != '2'}">
											<td id="Telephone"><span>${boardItem.extensionAttribute4} </span> </td>
										</c:when>
										<c:otherwise>
											<td id="Telephone"><span>&nbsp; </span> </td>
										</c:otherwise>
									</c:choose>
								</tr>
								<!-- 전화번호 end -->
								<!-- 게시일 -->
								<tr>
									<th><spring:message code='ezBoard.t224' /></th>
									<td id="PostDate" style = "white-space:nowrap; padding-right:5px">
										<div style="vertical-align:middle;width:100%;height:16px;">${boardItem.writeDate.substring(0, 16)}</div>
									</td>
									<!-- 게시일 end -->
									<!-- 게시 종료일 -->
								<th><spring:message code='ezBoard.t288' /></th>
								<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
								<c:choose>
									<c:when test="${boardItem.endDate.substring(0,4) == '9999'}">
										<td id="EndDate" style="padding-right:5px;">
											<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;"><spring:message code='ezBoard.t287' /></div>
										</td>
									</c:when>
									<c:otherwise>
										<td id="EndDate" style="padding-right:15px;">
											<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;">${boardItem.endDate.split(' ')[0]}</div>
										</td>
									</c:otherwise>
								</c:choose>
							</tr>
							<!-- 게시 종료일 end -->
							</c:when>
							<c:otherwise>
								<th style="width:10%"><spring:message code='ezBoard.t224' /></th>
									<td id="PostDate" style="width:120px; white-space:nowrap; padding-right:5px">
										<div style="vertical-align:middle;width:100%;height:16px;">${boardItem.writeDate}</div>
									</td>
									<!-- 게시일 end -->
							</tr>
							<!-- 게시 종료일 -->
							<tr>
								<th><spring:message code='ezBoard.t288' /></th>
								<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
								<c:choose>
									<c:when test="${boardItem.endDate.substring(0,4) == '9999'}">
										<td colspan="3" id="EndDate" style="padding-right:5px;">
											<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;"><spring:message code='ezBoard.t287' /></div>
										</td>
									</c:when>
									<c:otherwise>
										<td colspan="3" id="EndDate" style="padding-right:15px;">
											<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;">${boardItem.endDate.split(' ')[0]}</div>
										</td>
									</c:otherwise>
								</c:choose>
							</tr>
							<!-- 게시 종료일 end -->
							</c:otherwise>
						</c:choose>
						<c:if test="${(boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && not empty boardItem.updateDate}">
						 <!-- 수정자, 수정일 -->
							<tr>
							    <c:if test="${guBun != '2'}">
                                    <th><spring:message code='ezBoard.updateJIH01' /></th>
                                    <td id="updaterName" style = "white-space:nowrap; padding-right:5px">
                                        <div style="vertical-align:middle;width:100%;height:16px;">${boardItem.updaterName}</div>
                                    </td>
                                    <th><spring:message code='ezBoard.updateJIH02' /></th>
                                    <td id="updateDate" style = "white-space:nowrap; padding-right:5px">
                                        <div style="vertical-align:middle;width:100%;height:16px;">${boardItem.updateDate.substring(0, 16)}</div>
                                    </td>
                                </c:if>
                                <c:if test="${guBun == '2'}">
                                    <th><spring:message code='ezBoard.updateJIH02' /></th>
                                    <td width="100%" id="updateDate" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
			             	            <div style="WIDTH: 100%; vertical-align: middle"><c:out value="${boardItem.updateDate.substring(0, 16)}"/></div>
			                        </td>
                                </c:if>
							</tr>
						<!-- 수정자, 수정일 end -->
						</c:if>	
						<c:if test="${boardAttrCount > 0}">
							<c:forEach var="boardAttr" items="${boardAttr}">
								<tr>
									<c:choose>
										<c:when test="${extenLang == '1'}">
							                <th>${boardAttr.colName1}</th>
										</c:when>
										<c:otherwise>
							                <th>${boardAttr.colName2}</th>
										</c:otherwise>
									</c:choose>
					                <td colspan="5">
					                	<c:choose>
                                            <c:when test="${boardAttr.colType == 'people' || boardAttr.colType == 'textArea'}">                                         
                                                <span id="${boardAttr.tableCol}"></span>
                                            </c:when>
                                            <c:when test="${boardAttr.colType == 'people'}">
                                                <span id="${boardAttr.tableCol}"></span>
                                            </c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute6'}">
					                			<c:out value="${boardItem.extensionAttribute6}"/>
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute7'}">
					                			<c:out value="${boardItem.extensionAttribute7}"/>
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute8'}">
					                			<c:out value="${boardItem.extensionAttribute8}"/>
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute9'}">
					                			<c:out value="${boardItem.extensionAttribute9}"/>
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute10'}">
					                			<c:out value="${boardItem.extensionAttribute10}"/>
					                		</c:when>
					                		<c:otherwise></c:otherwise>
					                	</c:choose>
					                </td>
					            </tr>
							</c:forEach>
						</c:if>
					<!-- 제목 -->	
			        <tr>
			          <th><spring:message code='ezBoard.t323' /></th>
			             <td width="100%" id="cTitle" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
			             	<div style="WIDTH: 100%; vertical-align: middle"><c:out value="${boardItem.title}"/></div>
			             </td>
			        </tr>
			        <!-- 제목 end -->
			        <c:if test='${boardInfo.useKeyword eq "Y"}'>
                         <tr>
                             <th><spring:message code="ezApprovalG.t1200" /></th>
                             <td width="100%" id="cKeyword" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
                                <div style="WIDTH: 100%; vertical-align: middle">
                                    <c:if test='${not empty keywordList}'>
                                        <c:forEach var="keyword" items="${keywordList}">
                                            <span class="keywordSpan" id="${keyword.keywordName}" onclick="onclickKeyword(event)">#${keyword.keywordName}</span>
                                        </c:forEach>
                                    </c:if>
                                </div>
                             </td>
                         </tr>
                     </c:if>
			      </table>
			    </td>
		  </tr>
		  <tr>
		    <td class="pad1" id="pad1" style="vertical-align: top; height:460px;">
		    <c:if test="${useEditor ne 'HWP'}">
		        <iframe id="message" class="viewbox" name="message" style="padding:0; width:calc(100% - 2px); height:495px; overflow:auto; border:1px solid #ddd"></iframe>
		    </c:if>
		    <c:if test="${useEditor eq 'HWP'}">
		    	<iframe id="message" class="viewbox"  src="/ezBoard/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:495px; width:calc(100% - 2px); overflow:auto; border:1px solid #ddd"></iframe>
		    </c:if>
				
				<%-- 2019-04-05 홍승비 - 본문 하단, 첨부파일/한줄댓글 상단에 좋아요 버튼 추가 --%>
				<div style="display: flex; justify-content: center;">
					<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y'}">
						<div id="likeDiv" style="text-align:center; padding:5px 0px 7px 0px; margin-right: 5px;">	
						  	<span class="likeButton" onclick="clickLikeButton()" title="<spring:message code='ezBoard.hsb10'/>" style="height:20px">
							  	<c:choose>
							  		<c:when test="${isLikeChecked == 'Y'}">
							  			<img id="likeButtonImg" src="/images/like_on.png"/>
							  		</c:when>
							  		<c:otherwise>
							  			<img id="likeButtonImg" src="/images/like_off.png"/>
							  		</c:otherwise>
							  	</c:choose>
							  	<span id="likeCountSpan" style="vertical-align:top;"><c:if test="${boardItem.likeCount > 0}"> (<c:out value="${boardItem.likeCount}"/>)</c:if></span>
						  	</span>
						</div>
					</c:if>
					
						
					<%-- 2023-04-06 기민혁 - 본문 하단, 첨부파일/한줄댓글 상단에 싫어요 버튼 추가 --%>
					<c:if test="${boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
						<div id="disLikeDiv" style="text-align:center; padding:5px 0px 7px 0px;">	
						  	<span class="disLikeButton" onclick="clickDisLikeButton()" title="<spring:message code='ezBoard.kmh07'/>" style="height:20px">
							  	<c:choose>
							  		<c:when test="${isDisLikeChecked == 'Y'}">
							  			<img id="disLikeButtonImg" src="/images/disLike_on.png"/>
							  		</c:when>
							  		<c:otherwise>
							  			<img id="disLikeButtonImg" src="/images/disLike_off.png"/>
							  		</c:otherwise>
							  	</c:choose>
							  	<span id="disLikeCountSpan" style="vertical-align:top;"><c:if test="${boardItem.disLikeCount > 0}"> (<c:out value="${boardItem.disLikeCount}"/>)</c:if></span>
						  	</span>
						</div>
					</c:if>
                </div>
                
				<%-- 2024-09-24 이혜림 - 본문 하단, 첨부파일/한줄댓글 상단에 별점 평가하기 추가 --%>
				<c:if test="${not empty boardInfo.starRatingFlag && boardInfo.starRatingFlag == 'Y'}">
                    <div id="ratingContainer" class="rating_div" onclick="clickRatingButton()">
                        <div>
                            <span id="avgScore"><b>${itemStarRating.averageScore}</b><spring:message code='ezBoard.lhr004'/></span>
                            <span>(<span id="totalRaters">${itemStarRating.totalRaters}</span><spring:message code='ezBoard.lhr003'/>)</span>
                        </div>
                        <span class="ratingButton" title="<spring:message code='ezBoard.lhr001'/>">
                        <c:forEach var="i" begin="1" end="5">
                            <c:set var="srcIconFlag" value="${itemStarRating.rating >= i}" />
                            <label for="rate${i}">
                            	<div class="custom_radio">
	                                <input type="radio" name="reviewStar" value="${i}" id="rate${i}" <c:if test="${itemStarRating.rating == i}"> checked </c:if> />
                            	</div>
                                <img draggable="false" src="/images/ImgIcon/${srcIconFlag ? 'icon-flag.gif' : 'view-flag.gif'}"/>
                            </label>
                        </c:forEach>
                        </span>
                        <a class="imgbtn"><span onclick="clickSaveRatingButton()"><spring:message code='ezBoard.lhr001'/></span></a>
                    </div>
                </c:if>
                				
				<%-- 2019-11-05 홍승비 - 하단댓글 영역 추가 --%>
		        <c:if test="${boardPropertyVO.oneLineReply == '2'}">
		        	<div style='height:auto;'>
						<table class="mainlist emoticonLayerStaticPosition" style="width:100%" >
							<c:choose>
								<c:when test="${guBun == 2}">
								    <tr>
										<th colspan="2" style="text-align:center; width: 100%; border-left:1px solid #e2e2e2; border-right:1px solid #e2e2e2;
												 border-top:1px solid #e2e2e2; border-bottom:1px solid #f8f8fa; padding-bottom:3px">
										    <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                                            <div class="emoticonRelative">								    
                                               <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                               <textarea id="onelinereply" rows="3" style = "resize:none; width: calc(100% - 45px);" maxlength="500"></textarea>
                                            </div>
										</th>
								</c:when>
								<c:otherwise>
								    <tr>
										<th style="text-align:center; width: 85%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
											<%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                                            <div class="emoticonRelative">								    
                                                <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                                <textarea id="onelinereply" rows="3" style = "resize:none; width:90%;" maxlength="500"></textarea>
                                            </div>
										</th>
								</c:otherwise>	
							</c:choose>
							<c:choose>
								<c:when test="${guBun == 2}">
									</tr>
								</c:when>
								<c:otherwise>
										<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;width:15%;">
										    <c:if test='${boardInfo.attachmentFlag eq "Y"}'>
											    <a class='imgbtn' style="vertical-align: middle"><span onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span></a><br/>
											</c:if>
											<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></span></a>
										</th>
									</tr>
								</c:otherwise>
							</c:choose>
							</tr>
							<c:if test="${guBun == 2}">
								<tr>
									<th colspan="2" style="width: 90%; border-left:1px solid #e2e2e2; border-top:1px solid #f8f8fa; border-right:1px solid #e2e2e2; text-align:right;
											border-bottom:1px solid #e2e2e2; padding-top:0px; padding-bottom:4px; vertical-align: middle ">
										<span style = "font-weight:normal; display:inline-block; margin-top:2px"><spring:message code='ezBoard.t438' />&nbsp;</span>
										<span><input type="password" id="txtPassWord" maxlength="20" size="20" />&nbsp;</span>
										<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
										    <a class='imgbtn' style="vertical-align: middle"><span onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span></a>
										</c:if>
										<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></span></a>
									</th>
								</tr>
							</c:if>
						</table>
						<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
                            <%-- 첨부파일 버튼 --%>
                            <input id="commentFile" type="file" multiple="multiple" onchange="filechange(event)" style="display:none"/>
                            <input id="commentListFile" type="file" multiple="multiple" onchange="filechange(event)" style="display:none"/>
                            <%-- 댓글 첨부 리스트 --%>
                            <div id="commentAttach"></div>
						</c:if>
						<div class="commentSort">
						    <span id="earliest" class="checked" onclick="boardCommentSort()"><spring:message code='ezBoard.commentSort.JIH001' /></span>
						    <span id="latest" onclick="boardCommentSort()"><spring:message code='ezBoard.commentSort.JIH002' /></span>
                        </div>
						<table id="commentList" style="width:100%;margin-top:2px; overflow:auto;border:1px solid rgb(225,225,225)"></table>
					</div>
		        </c:if>
		        <%-- 본문하단 댓글영역 끝 --%>
		    </td>
		  </tr>
			
		<%-- 2020-02-13 홍승비 - 사용하지 않는 한줄댓글 코드 제거(본문하단 댓글으로 대체), 첨부파일 영역 확장 --%>
		  <tr>
		    <td class="pad1" id="attachTD" style="vertical-align: top;">
		        <table class="file">
		        <tr>
		          <th><spring:message code='ezBoard.t10025' /></th>
		            <td>
		            	<div style="text-align:left; OVERFLOW: auto; HEIGHT: 76px; background-color:white" id="lstAttachLink" ></div>
		            </td>
		        <td class="pos2">
		        <a class="imgbtn imgbck" style="width:60px; margin-bottom: 3px !important;"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
		        <a class="imgbtn imgbck" style="width:60px"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a> 
		        </td>
		        <td id="ItemLevel" style="display:none"></td>
		        </tr>
		      </table>
		    </td>
		  </tr>
		  
		  <c:if test="${adjacentItemsEnableFlag == '1' && showAdjacent == '1'}">
			  <tr>
			    <td style="vertical-align: top;">
			        <table class="content">
			        <tr>
			          <th><spring:message code='ezBoard.t327' /></th>
			          <c:choose>
				          <c:when test="${adjacentItem.previousItemID == ''}">
					          <td width="100%">
				          </c:when>
				          <c:otherwise>
					          <td style="cursor:pointer" width="100%">
				          </c:otherwise>
			          </c:choose>
			          <div align="left" style="overflow-y:auto;width: 100%; height:18px" onClick="OpenItem('${adjacentItem.previousItemID}')">${adjacentItem.previousTitle}</div>
			        </tr>
			        <tr>
			          <th><spring:message code='ezBoard.t328' /></th>
			          <c:choose>
			          	<c:when test="${adjacentItem.nextItemID == ''}">
				          <td>
			          	</c:when>
			          	<c:otherwise>
				          <td style="cursor:pointer">
			          	</c:otherwise>
			          </c:choose>
			            <div align="left" style="overflow-y:auto;width: 100%; height:18px" onClick="OpenItem('${adjacentItem.nextItemID}')">${adjacentItem.nextTitle}</div>
			        </tr>
			      </table>
			    </td>
			  </tr>
		  </c:if>
		</table>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <%-- 2019-11-07 홍승비 - 익명게시물 댓글삭제 시 비밀번호 확인을 위한 레이어팝업 추가 --%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel2">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer2"></iframe>
	    </div>
	    
	    <div id = "basePanel">
            <%-- 2023-11-01 전인하 - 이모티콘 선택 팝업--%>
            <div id ="_stickerArea">					
                <div id="emoticonPanel" class="emoticonPanel">
                    <div id="emoticonGroup" style="display:block;width:100%; height: 45px;background-color: #fff; border-bottom:1px solid #ddd;">
                        <div style="float:left; display:block;">
                            <img id="previousEmoticon" src="/images/previous1.png" onclick="showNextGroupSticker(this);">
                        </div>
                        <div id="_ePresentors" style="float:left; display:block; ">
                        </div>
                        <div style="float: right; display:block;">
                            <img id="nextEmoticon" src="/images/next1.png" onclick="showNextGroupSticker(this);">
                        </div>
                    </div>						
                    <div id="emoticonList" style="display:inline-block;width:100%; background-color: #fff;">
                    </div>
                </div>					
            </div>
            
            <%-- 2023-11-01 전인하 - 선택된 이모티콘 조회 팝업 --%>
            <div id="uploadedFile" class="uploadedFile">
                <img id="cancelImg" class="cancelImg" src="/images/close.png" onclick="closeEmoticonPreview();">
                <img id="previewImage" class="previewImage">
            </div>            
        </div>
        <div class="zoom_btn">
            <span class="zoom_in" onclick="Bigger()">확대</span>
            <span class="zoom_out" onclick="Smaller()">축소</span>
        </div>
        <c:if test="${useAI}">
            <c:import url="/WEB-INF/jsp/ezAI/aiSlide.jsp" />
        </c:if>
	</body>
</html>
