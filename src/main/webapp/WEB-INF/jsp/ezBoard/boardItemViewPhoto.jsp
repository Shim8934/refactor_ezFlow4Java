<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t293'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<style title="ezform_style_1">
			P {
					MARGIN-TOP: 0mm;
					MARGIN-BOTTOM: 0mm;
				}
			<%-- 2018-07-24 홍승비 - 썸네일/포토게시물 이미지 클릭 시 레이어팝업 추가 --%>
			.imgPopup{position: relative; float: left; max-width: 400px; max-height: 400px; cursor:pointer;}
			.imgPopupMagnify{position: relative; float: left; cursor: pointer;}
			.imgPopupBox{width: 500px;height: 500px; position: absolute; background: rgba(0,0,0,0.4); border-radius: 30px;}
			.imgPopupBoxMagnify{width: 700px;height: 760px; position: absolute; background: rgba(0,0,0,0.4); border-radius: 30px; z-index: 5;}
			.imgPopupDivMagnify{width: 670px; max-width:670px; height:680px; overflow:auto; margin:0px auto;}
			.imgPopupDiv{width:400px; height:400px; margin:0px auto;}
			.imgPopupBoxOff, .imgPopupOff{display: none;}
			.imgNotAttached{vertical-align: middle; margin: 0px auto; display: block; border: 1px dotted #cfcfcf; width: 33px; padding: 5px 2px 2px 5px;}
			.iPBInnerDiv_Top{display:inline-block; float:right; width:40px; margin-top: 15px;}
			.iPBInnerDiv_Top i{font-size:25px; color:black; cursor:pointer;}
			.iPBInnerDiv_TopOff{display:none; float:right; width:40px;}
			.iPBInnerDiv{height:50px; padding-right: 15px}	
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
		<script type="text/javascript">
				window.offscreenBuffering = true;
				var xmlhttp = createXMLHttpRequest();
				var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
				var curFontSize = 1;
				var pItemID = "${itemID}";
				var pBoardID = "${boardID}";
				var pBoardName = "${boardInfo.boardName}";
		        var pTitle = "${title}";
				var strWriterID = "${boardItem.writerID}";
				var strWriterName = "${boardItem.writerName}";
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
				var g_progresswin;
				var OneLineReplyFlag = "${oneLineReplyFlag}";
				var gubun = "${boardInfo.guBun}";
				var isLikeChecked = "<c:out value='${isLikeChecked}'/>";
				var likeFlag = "<c:out value='${boardInfo.likeFlag}'/>";
				var likeCount = "${boardItem.likeCount}";
				var likeCountAfter = 0;
				var commentCount = "${commentCount}";
			    var nowCommentCount = ""; // 댓글 옵션처리를 위해 전역변수로 변경
			    var userInfoID = "${userInfo.id}"; // 댓글 삭제가능여부 판단을 위해 자신의 userID 사용
				var refreshFlag = "N";
		        var ImageCount = "";
		        var viewimage = "";
		        var pListImage = "";
		        var pImageID= "";
		        var pListImageContent = "";
		        var resultimage = "";
		        var pPage = 1;
		        var imagepage = "0";
		        var imagetotalcount = "";
		        var imgWidth = "57px";
		        var imgHeight = "37px";
		        var rsa = new RSAKey();
		        var imageContentArray = new Array();
		        var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
		        var agent = navigator.userAgent.toLowerCase();
				var reactFlag = "<c:out value='${boardInfo.reactFlag}'/>"; // 2023-07-28 임정은 - 게시판 댓글 좋아요 기능 사용여부
				/* 2023-04-12 이가은 - 답글 기능을 위한 변수 추가 */
		        var userInfoName = "${userInfo.displayName1}";
				var replyOpenFlag = 0;
				var replyModifyFlag = 0;
				var replyModifyId = "";
				var replyTextarea = "";
				var delParentReply = 0;
				var delChildReply = 0;
				var delReplyLevel = "";
				var parentReplyID = "";
				var replyModifyArray = new Array(); // 2023-08-09 임정은 - 답글 수정 기능을 위한 배열 추가
				
				var useKeyword = "<c:out value='${boardInfo.useKeyword}'/>"; // 키워드 기능 사용 여부 (Y/N)
				var keywordArr = []; // 키워드 배열
				var starRatingFlag = "<c:out value='${boardInfo.starRatingFlag}'/>";
				var rating = "${itemStarRating.rating}";

				/* 2023-11-17 홍승비 - 게시물 승인 시 게시알림메일 발송을 위한 그룹사게시판 여부 파라미터 추가 */
				var isAllGroupBoard = "<c:out value='${boardInfo.isAllGroupBoard}'/>";
				
		        var isDisLikeChecked = "<c:out value='${isDisLikeChecked}'/>";
				var disLikeFlag = "<c:out value='${boardInfo.disLikeFlag}'/>";
				var disLikeCount = "${boardItem.disLikeCount}";
				var disLikeCountAfter = 0;
				var commentSort = "earliest"; // 댓글 정렬 기준 : earliest(등록순) / latest(최신순)
				
                var myBoardScrapFlag = "<c:out value='${MyBoardScrapFlag}'/>" // myBoardScrapFlag 테넌트컨피그값 (NONE, TYPE1_(마이게시판하위), TYPE2(스크랩함))
		        var isScrap = "<c:out value='${isScrap}'/>"; // 이미 스크랩되었는지의 여부 (type1일때)
			    var scrapContID = "<c:out value='${scrapContID}'/>"; // 개인스크랩함 ID (TYPE2, 스크랩함에서 게시물 조회했을 때 값이 들어옴)
			 	 
			    var attachmentFlag = "${boardInfo.attachmentFlag}"; // 게시판 첨부파일 사용여부
                var attachLimit = "${boardInfo.attachSizeLimit}"; // 개별 첨부파일 limit
                var attachFileNameMaxLength = Number("${attachFileNameMaxLength}"); // 첨부파일명 글자수 제한 limit
                var totalFileSize = 0; // 현재 총 첨부파일 사이즈

				var writerNameType = "<c:out value='${boardItem.writerNameType}'/>"; // 2025-01-21 임정은 - 게시자명선택 타입 (0 : 이름, 1 : 부서명)
				var strWriterDeptID = "${boardItem.writerDeptID}";
				var SSDeptID = "<c:out value='${userInfo.deptID}'/>";
				
		        window.onload = function () {
		            imageViewInit();
		            pageimageout();
		            rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		            makeEmoticonPanel();
		
		            // GS 수정(2006.02.10) : 게시알림메일을 다시 게시하는 경우 url link와 게시물 link 기능이 겹치는 문제 수정
		            AddLinkTarget();
		
		            if (g_progresswin) {
		            	g_progresswin.close();
		            }

		            if ("${useOCS}" == "YES") {
		                var pSIPUriList = getSIPUri(strWriterID + ";", "").split(';');
		                document.getElementById("WriteUserNM").innerHTML = "<div><img style ='vertical-align:middle' src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[0] + "\",this);'/>" + "<span style ='vertical-align:middle'>" + "${boardItem.writerName}" + "</span></div>";
		                pSIPUriList = null;
		            }
		            else {
		               // document.getElementById("WriteUserNM").innerHTML = "${boardItem.writerName}";
		            }
		            
		            /* 2018-07-24 홍승비 - 투표 모듈의 이미지 레이어팝업 포토+썸넬게시물에도 적용 */
		            addThumbnailEvent();
		            
		            /* 2019-11-05 홍승비 - 본문 하단에 댓글영역 표출 */
 		            if (OneLineReplyFlag == "2") {
 		            	document.getElementById("bodyPopup").style.overflowX = "hidden";
 		            	document.getElementById("bodyPopup").style.overflowY = "auto";
 		            	self.resizeTo(794, 914);
 		            	getBoardComment();
 		            }
		        };
		        
		        window.onresize = function () {
		            /* 2022-08-18 홍승비 - 화면 리사이즈 시, 화면 높이만큼 레이어 팝업의 배경 회색 영역을 확장 */
		            if (document.body.scrollHeight > window.innerHeight) {
		            	document.getElementById("mailPanel").style.height = (document.body.scrollHeight + 17) + "px";
		            } else {
		            	document.getElementById("mailPanel").style.height = (window.innerHeight) + "px";
		            }
		        };
		        
		        $(document).ready(function() {
					/* 2019-04-05 홍승비 - 좋아요 버튼이 존재한다면 본문 패딩과 height 조절 */
		            if ((likeFlag != null && likeFlag == "Y")||(disLikeFlag != null && disLikeFlag == "Y")) {
						$(".MainContentTD").css({"padding" : "15px 0px 4px 0px", "height" : "47px"});
						$("#MainContent").css("height", "35px");
		            }
		        });
		        
		        //강민수92 댓글 클릭 이벤트
			    function btn_One_Line_Reply_Onclick() {
			    	if (OneLineReplyFlag == "1") {
			    		openBoardComment();
			    		return;
			    	} 
			    }
		        
				//GUID 채번
				function generateGuid() {
				    var result = "";
				    for (var i = 0, j = 0; j < 32; j++) {
				        if (j == 8 || j == 12 || j == 16 || j == 20) {
				            result = result + "-";
				        }
				        i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
				        result = result + i;
				    }
				    return "{"+ result + "}";
				}
				////
		
				// 20090408 : 게시물 위로가기 기능 추가
				function GoTopNDownView()
				{
				    AGoTop.style.display = "";
				    AGoDown.style.display = "";
				}
				
				// 20090408 : 게시물 위로가기 기능 추가
				function GoTopNDownHidden()
				{
				    AGoTop.style.display = "none";
				    AGoDown.style.display = "none";
				}
				
				
				// GS 수정(2006.02.10)  : 게시알림메일을 다시 게시하는 경우 url link와 게시물 link 기능이 겹치는 문제 수정
				// 함수 호출이 아닌 경우에만 target을 추가하도록 함
				function AddLinkTarget()
				{
					try
					{
					    // 20091030 : 게시판 읽기창 본문 IFRAME으로 변경
					    var objTags = message.txtContent.all.tags("a");
		    			
					    for( var i = 0 ; i < objTags.length ; i++ )
					    {
						    if( objTags.item(i).href.indexOf("javascript:") == -1 )
							    objTags.item(i).target = "_blink";
					    }
					}
					catch(e) {}
				}
				
		
				function ExtractBetweenPattern( orgStr, firstPattern, lastPattern )
				{
					var sIndex, eIndex;
					var copyStr = new String( orgStr );
					var retStr = "", subStr;
					
					var regFExp = new RegExp( firstPattern, "i" );
					var regEExp = new RegExp( lastPattern, "i" );
					
					var loop = 0;
		
					sIndex = copyStr.search( regFExp );
					if ( sIndex == -1 ) {
						return orgStr;
					}
					
					copyStr = copyStr.substr( sIndex + firstPattern.length );
		
					eIndex = copyStr.search( regEExp );
					if ( eIndex == -1 ) {
						return copyStr;
					}
					
					retStr = copyStr.substr( 0, eIndex );
					
					return retStr;
				}		
				
				//2007.06.21 SSL 적용후 본문에 이미지가 들어간 mht로드시 보안 경고창 뜨는 오류 수정함.
				function ImageUrl(pUrl, cnt)
				{
				    var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl+"&Cnt="+cnt;
					
					return link;
				}
		
				function CheckIfHasReplies()
				{
				    var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + encodeURIComponent(pItemID) + ",;", false);
					xmlhttp.send();	
					if(xmlhttp.responseText == "FALSE") {
						xmlhttp = null;	
						return false;
					}
					xmlhttp = null;
					return true;
				}
				
				/* 2020-02-14 홍승비 - 불필요한 구분값 체크 코드 정리 (포토게시판의 구분값은 "3") */
				var checkpassword_dialogArguments = new Array();
				function btn_Delete_Onclick()
				{
					if (CheckIfHasReplies())
					{
						alert("<spring:message code='ezBoard.t196'/>");
						return;
					}
		
					if(Delete_FG != "true") {
						alert("<spring:message code='ezBoard.t265'/>");
						return;
					}
		
					//게시판관리자 또는 게시판그룹관리자 또는 게시물작성자가 아니면 지울 수 없다
				    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID && !(writerNameType == '1' && strWriterDeptID == SSDeptID)) {
			            alert("<spring:message code='ezBoard.t265'/>");
			            // GS 수정(2006.02.10) : 익명게시판인 경우 게시물 삭제 시 암호가 맞아도 삭제가 안되는 문제 수정 (return의 위치가 잘못되었음)
			            return;
				    } else {
			            if (!confirm(strLang48)) {
			            	return;
			            }
	
			            var xmlhttp = createXMLHttpRequest();
			            xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + ";", false);
			            xmlhttp.send();
	
			            if (xmlhttp.responseText == "NO") {
			                alert("<spring:message code='ezBoard.t265'/>");
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
			            
			            //2019.03.04 유은정 - 포토갤러리 포틀릿에도 리스트 업데이트 되도록 수정
			            try { 
							if (parent.opener != null && parent.opener.reloadPhotoPage != undefined) {
								parent.opener.reloadPhotoPage();
							}
			            } catch (e) {console.log(e);}
						
			            try {
							if (window.opener != null && window.opener.getBoardList != undefined) {
								window.opener.getBoardList();
							}
			            } catch (e) {console.log(e);}
			            
			            try {// 카드 A형, 카드 B형, 리스트형 포틀릿 새로고침
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
			            
			            try { // 탭게시판  포틀릿 새로고침
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
							if(parent.opener.search != undefined){
								parent.opener.search('skip');
							}
	                 	} catch (e) {console.log(e);}
						
			            window.close();
				    }
				}
		
		    function btn_Delete_Onclick_Complete(ret) {
		        if (ret != "OK") {
		            alert("<spring:message code='ezBoard.t265'/>");
		            return;
		        }
		
		        if (!confirm(strLang48)) return;
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + ";", false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265'/>");
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
		    }
		
				function btn_Reply_Onclick()
				{
					if(Reply_FG != "true") {
						alert("<spring:message code='ezBoard.t303'/>");
						return;
					}
		
					window.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=reply";
				}
/* 		
				function btn_Copy_Onclick()
				{
					if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
						alert("<spring:message code='ezBoard.t202'/>");
						return;
					}
		
					var pheigth = window.screen.availHeight;
					var pwidth = window.screen.availWidth;
					pheigth = parseInt(pheigth) / 2;
					pwidth = parseInt(pwidth) / 2;
					pheigth = pheigth - 200;
					pwidth = pwidth - 127;
					
					window.open("/ezBoard/copyBoardItem.do?itemIDList=" + encodeURIComponent(pItemID) + ";" + "&boardID=" + encodeURIComponent(pBoardID), "", "height=600px,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth,"");		
				} */
				
		        window.onunload = function () {
		        	//리프레쉬 할 이유가 없는거 같음
// 		            refresh_onclick();
		        };
		        
		        /* 2019-04-12 홍승비 - 댓글 갯수 갱신 시 게시물리스트 갱신 */
				window.onbeforeunload = function () {
					checkRefreshFlag();
					if (refreshFlag == "Y") {
						window.opener.getBoardList();
					}
					opener.isOpenWindow = undefined;
			    };
			    
				function btnClose_onclick()
				{
					window.close();
					//리프레쉬 할 이유가 없는거 같음
// 				    refresh_onclick();
				}
		
				function attach_SelectAll()
				{
					var checks = lstAttachLink.all.tags("input");
					for (var i=0; i<checks.length; i++)
						checks.item(i).checked = true;
				}
		
				/* 2018-06-29 홍승비 - 게시물 미리보기 > 게시자 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
				// 이 기능 사용하지 않음(닷넷 당시의 기능)
				function MemberInfo_onclick(pUserID, pDeptID)
				{
		            var swidth = 420;
		            var sheight = 490;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		            
					window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID + "&dept=" + pDeptID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
				}
		
				function Bigger()
				{
					if(curFontSize < 4) {
						curFontSize += 1;
					}
					// 20091030 : 게시판 읽기창 본문 IFRAME으로 변경
					message.txtContent.style.fontSize = fontSize[curFontSize];
				}
		
				function Smaller()
				{
					if(curFontSize > 0) {
						curFontSize -= 1;
					}
					// 20091030 : 게시판 읽기창 본문 IFRAME으로 변경
					message.txtContent.style.fontSize = fontSize[curFontSize];
				}
				
				var item_readlist_cross_dialogArguments = new Array();
				function ReaderList()
				{
		            var swidth = 620;
		            var sheight = 425;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
					var szHref = "/ezBoard/itemReadList.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID);			
					var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";
					
					if (CrossYN()) {
					    item_readlist_cross_dialogArguments[0] = "";
					    item_readlist_cross_dialogArguments[1] = ReaderList_Complete;
					    DivPopUpShow(620, 425, szHref);
					}
					else
					    window.open(szHref,"", "width=" + swidth + ",height=" + sheight + ",top=" + ptop + ",left=" + pleft + ", resizable=yes, scrollbars=yes");
				}
				function ReaderList_Complete() {
				    DivPopUpHidden();
				}
		
				/* 2018-06-29 홍승비 - 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
				function OpenUserInfo(pUserID, pDeptID)
				{
		            var swidth = 420;
		            var sheight = 450;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
					window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");			
				}
				
				/* 2020-02-14 홍승비 - 하단댓글 기능 적용으로 기존 한줄댓글 코드 제거 */
				function ReplaceText( orgStr, findStr, replaceStr )
				{
					var re = new RegExp( findStr, "gi" );
					return ( orgStr.replace( re, replaceStr ) );
				}
		
				function MakeXMLString(p_str)
				{
					p_str = ReplaceText(p_str, "&", "&amp;");
					p_str = ReplaceText(p_str, "<", "&lt;");
					p_str = ReplaceText(p_str, ">", "&gt;");
					
					return p_str;
				}
		
				function OpenItem(strItemID)
				{
					if (strItemID != "") window.location.href = window.location.href.replace(pItemID, strItemID);
				}
				
				/* 2019-11-28 홍승비 - 사용하지 않는 함수 주석처리 */
				// 게시 보기(새거)
/* 				function Item_View_New(pBoardID, pItemID)
				{
					var pheigth = window.screen.availHeight;
					var pwidth = window.screen.availWidth;
					pheigth = parseInt(pheigth) / 2;
					pwidth = parseInt(pwidth) / 2;
					pheigth = pheigth - 284;
					pwidth = pwidth - 359;
							
					window.open("/ezBoard/boardItemViewPhoto.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), "", "height=700,width=1000, status = no, toolbar=no, menubar=no, location=no,scrollbars=1, resizable=1, top=0, left=0", "");	
				} */
				function GoTop()
				{
				    message.AGoTop.click();
				}
				
				function GoDown()
				{
				    message.AGoDown.click();
				}
		
		        function ImageMain(imagefilename)
		        {
		            imageonmouse(imagefilename.id);
		            var index = Number(imagefilename.id.substring(imagefilename.id.length-1));
		
		            var mainfilename = imagefilename.src;
		            if (imagefilename.src.indexOf("s_") > -1) {
		                mainfilename = imagefilename.src.split("s_")[0] + imagefilename.src.split("s_")[1];
		            }
		    
		            viewimage = imagefilename.id;
		
		            document.getElementById("mainimages").style.display = "none";
		            document.getElementById("mainimages").src = mainfilename;
		            document.getElementById("mainimages").name = imagefilename.name;
		            document.getElementById("MainContent").innerHTML = MakeXMLString(imagefilename.title.replaceAll("&apos;", "'"));
		            //document.getElementById("MainContent").innerHTML = MakeXMLString(imageContentArray[index].title);
		
		            imageloding();
		        }
		
		        function imageloding()
		        {
					var newimage = new Image();
			        newimage.src = document.getElementById("mainimages").src;

			        /* 2018-04-25 홍승비 - 기존 setTimeout을 이미지.onload로 수정 */
			        newimage.onload = function() {
					    var we = newimage.width;
						var he = newimage.height;
	
						if (we > 400) {
							document.getElementById("mainimages").width = 400;
					  	} else {
					  		document.getElementById("mainimages").width = we;
					  	}
						if (he > 300) {
							document.getElementById("mainimages").height = 280;
						} else {
							document.getElementById("mainimages").height = he;
						}
	
						document.getElementById("mainimages").style.display = "";
			
			            var maxWidth = 400;
			            var maxHeight = 280;
			            var ratio = 0;
		
			            if (we > maxWidth) {
			                ratio = maxWidth / we;
			                document.getElementById("mainimages").width = maxWidth;
			                document.getElementById("mainimages").height = he * ratio;
			
			                if (document.getElementById("mainimages").height > maxHeight) {
			                    ratio = maxHeight / document.getElementById("mainimages").height;
			                    document.getElementById("mainimages").height = maxHeight;
			                    document.getElementById("mainimages").width = document.getElementById("mainimages").width * ratio;
			                }
			            }
			            else {
			                if (he > maxHeight) {
			                    ratio = maxHeight / he;
			                    document.getElementById("mainimages").height = maxHeight;
			                    document.getElementById("mainimages").width = we * ratio;
			                }
			            }
			        }
		        }
		
		        function Pagenationimage(page)
		        {
		            var pageimage = "";
		
		            for(var i = 0; i < ImageCount; i++)
		            {
		                if(viewimage == "image" + i)
		                {
		                    if(page == "prevPage")
		                    {
		                        if(i == 0)
		                        {
		                        	btn_SmallIamge("Prev");
		                            return;
		                        }
		                
		                        pageimage = "image" + (i - 1);
		                    }
		                    else if(page == "nextPage")
		                    {
		                        if(i == (ImageCount - 1))
		                        {
		                            btn_SmallIamge('Nextimage');
		                            return;
		                        }
		                        else
		                            pageimage = "image" + (i + 1);
		                    }
		                }
		            }
		            viewimage = pageimage;
		            imageonmouse(pageimage);
		
		            var mainfilename = document.getElementById(pageimage).src.split("s_")[0] + document.getElementById(pageimage).src.split("s_")[1];
		            ImageMain(document.getElementById(pageimage));
		        }
		        function showHideLayers()
		        {
		            showDiv.style.display = "block";
		        }
		 
		        function bt(id, after){ document.getElementById(id).src=after; }
		
		        function btn_ImgOnclick(pMod) {
		            var swidth;
		            var sheight;
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
		
		            if (pMod == "Del") {
		                if ((pListImage.split(";").length - 1) == 1) {
		                    if (!confirm(strLang48)) return;
		                    var xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + ";", false);
		                    xmlhttp.send();
		
		                    if (xmlhttp.responseText == "NO") {
		                        alert("<spring:message code='ezBoard.t265'/>");
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
		                    
		                  	//2019.03.04 유은정 - 포토갤러리 포틀릿에도 리스트 업데이트 되도록 수정
		                  	try{
								if (parent.opener != null && parent.opener.reloadPhotoPage != undefined) {
									parent.opener.reloadPhotoPage();
								}
		                  	} catch (e) {console.log(e)}
			                
							// 게시판 포틀릿 리스트 업데이트 되도록 수정
							try{
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
							} catch(e) {console.log(e);}
							
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
							
		                    window.close();
		                }
		                else {
		                    swidth = 550;
		                    sheight = 520;
		                    
		                    pleft = (pwidth - swidth) / 2;
				            ptop = (pheight - sheight) / 2;
				          
		                    window.open("/ezBoard/boardItemDelete.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID) + "&mod=" + pMod + "&isAllGroupBoard=" + isAllGroupBoard, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ",status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                }
		            }
		            else {
		            	/* 2019-07-03 홍승비 - 포토/썸네일게시물 사진수정 시 팝업창 크기 조정 */
						swidth = 460;
		            	
			            if (agent.indexOf("edg") > 0) {
			            	swidth = 550;
			            }
		            	
						if (gubun == 3) { // 포토게시판 (메인이미지 사용 안함)
							sheight = 475;
						} else { // 썸네일게시판 (메인이미지 사용함)
							sheight = 475;
						}
						
			            pleft = (pwidth - swidth) / 2;
			            ptop = (pheight - sheight) / 2;
			            //2019.03.04 유은정 - 게시판 포틀릿 리스트 업데이트 되도록 수정
		                window.open("/ezBoard/modifyImageItem.do?imageID=" + encodeURIComponent(document.getElementById("mainimages").name) + "&boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&page=" + pPage + "&mod=image&guBun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft, "");
		            }
		        }
		
		        function page_reload()
		        {
		            window.location.reload();
		        }
		
		        function btn_Add_Onclick()
		        {
		            var swidth = 500;
		            var sheight = 525;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
		            window.open("/ezBoard/addImageItem.do?&boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft , "");
		        }
		
		        function btn_SmallIamge(Page)
		        {
		            var NewPage = "";
		
		            if (Page == "Next") {
		                var endpage = pPage * 10;
		                if (imagetotalcount <= endpage) {
		                    return;
		                }
		                else {
		                    imagepage = 0;
		                    NewPage = parseInt(pPage) + 1;
		                }
		            }
		            else if (Page == "Nextimage") {
		                var endpage = pPage * 10;
		
		                if (imagetotalcount <= endpage) {
		                    imagepage = 0;
		                    NewPage = 1;
		                }
		                else {
		                    imagepage = 0;
		                    NewPage = parseInt(pPage) + 1;
		                }
		            }
		            else if (Page == "Prev") {
		                imagepage = 9;
		                if (pPage == 1) {
		                    if (imagetotalcount % 10 > 0) {
		                        pPage = Number(imagetotalcount / 10) + 2;
		                    } else {
		                        pPage = Number(imagetotalcount / 10) + 1;
		                    }
							if (imagetotalcount != 10) {
		                    	imagepage = imagetotalcount % 10 - 1;
							}
		                }
		                NewPage = parseInt(pPage) - 1;
		            }
		            
		            pPage = NewPage;
		    
		            $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/imageViewList.do",
						data : { boardID   : pBoardID, 
								 itemID    : pItemID,
								 page      : NewPage
							   },
						success: function(result){
							ImageViewTable(result);
						}        			
					});
		            
		            pageimageout();
		        }
		
		        function imageViewInit()
		        {
		            $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/imageViewList.do",
						data : { boardID   : pBoardID, 
								 itemID    : pItemID,
								 page      : "1"
							   },
						success: function(result){
							ImageViewTable(result);
						}        			
					});
		        }
		
		        function ImageViewTable(result)
		        {
		            pListImageContent= ""; 
		            pListImage = "";
		            pImageID = "";
		            resultimage = "";
		    
		            var obj = document.getElementById("viewBox");
		            var obj2 = document.getElementById("viewboxlist");
		            if(obj.childNodes.length > 0)
		            {
		                obj2.parentNode.removeChild(obj2);
		            }
		
		            var xmldom = createXmlDom();
		
		            xmldom = loadXMLString(result);
		    
		            imagetotalcount = getNodeText(xmldom.getElementsByTagName("IMAGECOUNT")[0]);
		    
		            for(var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++)
		            {
		                pListImageContent += getNodeText(xmldom.getElementsByTagName("FILECONTENT")[i])+ ";:;";
		                pListImage += getNodeText(xmldom.getElementsByTagName("FILEPATH")[i]) + ";";
		                pImageID += getNodeText(xmldom.getElementsByTagName("IMAGEID")[i]) + ";";
		                resultimage += getNodeText(xmldom.getElementsByTagName("IMAGEPATH")[i]);
		                
		                imageContentArray.push({title:getNodeText(xmldom.getElementsByTagName("FILECONTENT")[i])});
		            }
		
		            ImageCount = xmldom.getElementsByTagName("ROW").length;
		            var result = pListImage.split(";");
		            var resultcount = result.length - 1;
		            var imagecontet = pListImageContent.split(";:;");
		            var imageid = pImageID.split(";");
		            document.getElementById("viewBox").innerHTML += "<span id='viewboxlist'>";            
		            for(var i = 0; i < ImageCount; i++)
		            {
		                var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(result[i].split('/')[7]);
		                document.getElementById("viewboxlist").innerHTML += "<img src='" + imgSrc + "' style='border:0' title='" + MakeXMLString(imagecontet[i].replaceAll("'" , "&apos;")) + "' id='image" + i + "' name='" + imageid[i] + "' style='cursor:pointer;' onclick='ImageMain(this)' onmouseover='imagemouseover(this)' onmouseout='imagemouseout(this)'/>";
		                if (CrossYN())
		                    document.getElementById("image" + i).style.opacity = "0.35";
		                else
		                    document.getElementById("image" + i).style.filter = 'Alpha(Opacity=35)';
		
		                document.getElementById("image" + i).style.width = imgWidth;
		                document.getElementById("image" + i).style.height = imgHeight;
		
		            }
		            document.getElementById("viewBox").innerHTML += "<span>";
		
		            if(ImageCount != 0 )
		            {
		                ImageMain(document.getElementById("image" + imagepage));
		            }
		        }
		
		        function imageonmouse(result)
		        {
		            for(var i = 0; i < ImageCount; i++)
		            {
		                document.getElementById("image" + i).style.border = "";
		                document.getElementById("image" + i).style.margin = "0px 4px";
		                document.getElementById("image" + i).style.width = imgWidth;
		                document.getElementById("image" + i).style.height = imgHeight;
		                if (CrossYN())
		                    document.getElementById("image" + i).style.opacity = "0.35";
		                else
		                    document.getElementById("image" + i).style.filter = "Alpha(Opacity=35)";
		            }
		
		            document.getElementById(result).style.border = "#888 1px solid";
					document.getElementById(result).style.margin = "0px 4px";
		            document.getElementById(result).style.width = imgWidth;
		            document.getElementById(result).style.height = imgHeight;
		            if (CrossYN())
		                document.getElementById(result).style.opacity = "1";
		            else
		                document.getElementById(result).style.filter = "Alpha(Opacity=100)";
		        }
		
		        /* 2018-06-01 홍승비 - 포토/썸네일게시물 하단 UI 수정 */
		        function imagemouseover(image)
		        {
		            if(document.getElementById("mainimages").name == image.name) {
		                return;
		            }
		            if(CrossYN()) {
		                image.style.opacity = "1";
		            } else {
		                image.style.filter = "Alpha(Opacity=100)";
		            }
		            
		            image.style.border = "#888 0.015px solid";
					image.style.margin = "0px 4px";
		        }
		        function imagemouseout(image)
		        {
		            if(document.getElementById("mainimages").name == image.name) {
		                return;
		            }
		            if (CrossYN()) {
		                image.style.opacity = "0.35";
		            } else {
		                image.style.filter = "Alpha(Opacity=35)";
		            }
		            
		            image.style.border = "none";
					image.style.margin = "0px 4px";
		        }
		
		        var photoalbumedit_dialogArguments = new Array();
		        function btn_albumEdit()
		        {
		            var params = new Array();
		            params[0] = pBoardID;
		            params[1] = pItemID;
		            params[2] = document.getElementById("title").textContent;
		            params[3] = document.getElementById("Div2").textContent;
		            params[5] = isAllGroupBoard;
                    params[6] = useKeyword;
                    params[7] = getKeywordListByView();
		            if (CrossYN()) {
		                photoalbumedit_dialogArguments[0] = params;
		                photoalbumedit_dialogArguments[1] = btn_albumEdit_Complete;
		                DivPopUpShow(400, 200, "/ezBoard/photoAlbumEdit.do");
		            }
		            else {
		                var swidth = 400;
		                var sheight = 200;
		                var feature = "status:no;dialogWidth:" + swidth + "px;dialogHeight:" + sheight + "px;help:no;scroll:no;edge:sunken";
		                
		                var ret = window.showModalDialog("/ezBoard/photoAlbumEdit.do", params, feature);
		                if (ret == "OK") {
		                	//2019.03.04 유은정 - 포토갤러리 포틀릿에도 리스트 업데이트 되도록 수정
		                	try {
								if (parent.opener != null && parent.opener.reloadPhotoPage != undefined) {
									parent.opener.reloadPhotoPage();
								}
		                	} catch(e) {console.log(e); }
			                
							// 게시판 포틀릿 리스트 업데이트 되도록 수정
							try{
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
							} catch(e) {console.log(e); }
							
							try { // 탭게시판 포틀릿 새로고침
								if (parent.opener.refreshTab != undefined) {
		                 			parent.opener.refreshTab();
		                 		}
		                 	} catch (e) {console.log(e);}
							
		                 	try{
					            if (parent.opener.getBoardList_NewBoardSTD != undefined) {
									parent.opener.getBoardList_NewBoardSTD();
								}
		                 	} catch(e) {console.log(e);}
				            
		                	page_reload();
		                }
		
		            }
		           
		        }
		        function btn_albumEdit_Complete(ret) {
		            DivPopUpHidden();
		            
		            if (ret == "OK") {
	                	//2019.03.04 유은정 - 포토갤러리 포틀릿에도 리스트 업데이트 되도록 수정
	                	try{
							if (parent.opener != null && parent.opener.reloadPhotoPage != undefined) {
								parent.opener.reloadPhotoPage();
							}
	                	} catch(e) {console.log(e);}
		                
						// 게시판 포틀릿 리스트 업데이트 되도록 수정
						try{
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
						
	                 	try {
				            if (parent.opener.getBoardList_NewBoardSTD != undefined) {
								parent.opener.getBoardList_NewBoardSTD();
							}
	                 	} catch (e) {console.log(e);}
			            
			            page_reload();
		            }
		                
		        }
		        
		        /* 2018-06-01 홍승비 - 페이징 코드 수정, 도달 불가능 코드 삭제 */
		        function pageimageover()
		        {
		            var endpage = pPage * 10;
		            if(imagetotalcount > endpage && pPage == 1)
		            {
		                document.getElementById("SmallImageNext").style.display = "";		                
		            }
		            else if(pPage == 1 && imagetotalcount <= 10)
		            {
		                document.getElementById("SmallImagePrev").style.display = "none";
		                document.getElementById("SmallImageNext").style.display = "none";
		            }
		            else if(pPage != 1 && imagetotalcount <= endpage)
		            {
		                document.getElementById("SmallImagePrev").style.display = "";
		                document.getElementById("SmallImageNext").style.display = "none";
		            }
		            else
		            {
		                document.getElementById("SmallImagePrev").style.display = "";
		                document.getElementById("SmallImageNext").style.display = "";
		            }
		        }
		
		        function pageimageout()
		        {
		            document.getElementById("SmallImagePrev").style.display = "none";
		            document.getElementById("SmallImageNext").style.display = "none";
		        }
		
		        function btn_ImgDownload()
		        {
		            var swidth;
		            var sheight;
		
		            swidth = 460;
		            if(agent.indexOf("edg") > 0){
		            	swidth = 550;
		            }
		            
		            sheight = 500;
		            
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		            
		            window.open("/ezBoard/imageDownload.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ",status = no, toolbar=no, menubar=no,location=no, resizable=1");			
		        }
		
		    	//mouseWheel Event 
// 		        document.onmousewheel = ScrollControl;
		
		        function ScrollControl()
		        {
		            for(var i = 0  ; i < document.getElementById("viewboxlist").getElementsByTagName("IMG").length ; i++)
		            {
		                if(event.wheelDelta == "120")
		                {
		                    if (CrossYN()) {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.opacity == "1") {
		                            if (i == document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[0]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i + 1]);
		
		                            break;
		                        }
		                    } else {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.filter == "Alpha(Opacity=100)") {
		                            if (i == document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[0]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i + 1]);
		
		                            break;
		                        }
		                    }
		
		                } else {
		                    if (CrossYN()) {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.opacity == "1") {
		                            if (i == 0)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i - 1]);
		
		                            break;
		                        }
		                    } else {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.filter == "Alpha(Opacity=100)") {
		                            if (i == 0)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i - 1]);
		
		                            break;
		                        }
		                    }
		                }
		            }
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
		                	/* 2023-11-17 홍승비 - 승인게시판의 게시물 승인 시 게시알림메일 발송 기능 추가 (포토/썸네일 게시판은 답변게시물 사용 불가) */
		                	if (pFlag == "Y") { // 승인
		                		// 해당 게시판의 관리자에게 게시알림 발송 (게시판 권한설정 > 관리자 권한자인 경우 '게시 알림' 옵션)
		                		sendPostNotiForAdmin(pBoardID, pItemID);
		                		
	                			// 해당 게시판의 일반 사용자(접근 권한자)에게 게시알림 발송 (게시판 일반설정 > 메일알림 > '게시알림' 옵션)
	                			sendBoardAlert("new", pBoardID, pItemID, isAllGroupBoard);
		                		
		                		alert("<spring:message code='ezBoard.t999002' />");
		                	}
		                	else { // 반려
		                        alert("<spring:message code='ezBoard.t999009'/>");
		                    }
		                }
		
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
		    	//mouseWheel Event  END
		        function btn_ReWrite() {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		            window.close();
		
		            /* 2018-06-20 홍승비 - 승인게시물 반려 후 제작성 .do 경로 수정 */
		            window.open("/ezBoard/boardNewItemTempPhoto.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&location=", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        }
		    	
		        /* 2018-07-24 홍승비 - 이미지 클릭 시 투표 모듈에서 가져온 레이어팝업 동작 */
			    var tempTimer;
			    function addThumbnailEvent(){
			  		$(document)
			    	.on("click", ".thumbCloseBtn", function(e){
						toggleImgPopupBox(e);
					}).on("click", ".thumbnail", function(e){
						toggleImgPopupBox(e);
					}).on("click", "#thumbMagnifyBtn", function(e){
						magnifyThumbnailSize();
					}).on("click", "#thumbZoomInBtn", function(e){
						zoomInImgPopup();
					}).on("mousedown", "#thumbZoomInBtn", function(e){
						e.target.style.color = "#0470e4";
						tempTimer = setInterval(zoomInImgPopup, 150);
					}).on("mouseup mouseleave", "#thumbZoomInBtn", function(e){
						e.target.style.color = "";
						if(tempTimer){
							clearInterval(tempTimer);
						}
					}).on("click", "#thumbZoomOutBtn", function(e){
						zoomOutImgPopup();
					}).on("mousedown", "#thumbZoomOutBtn", function(e){
						e.target.style.color = "#0470e4";
						tempTimer = setInterval(zoomOutImgPopup, 150);
					}).on("mouseup mouseleave", "#thumbZoomOutBtn", function(e){
						e.target.style.color = "";
						if(tempTimer){
							clearInterval(tempTimer);
						}
					}).on("click", "#imgPopup", function(e){
						var pwidth = window.screen.availWidth;
						var pheight = window.screen.availHeight;
			            var htmlString = "";
			            var imgPopupWindow = window.open("" , "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height="+ pheight + ",width="+ pwidth + ",top=0,left=0", "");
			            
						htmlString = "<html><head><title><spring:message code='ezPortal.t49'/></title></head>";
						htmlString += "<body style='margin:0px;text-align:center;' onClick='window.close()'>";
						htmlString += "<div style='height:" + pheight + "px;width:" + pwidth + "px;vertical-align:middle;display:table-cell;'><img style='cursor:pointer;' src=" + e.target.src + "/></div>";
						htmlString += "</body></html>";
						
						imgPopupWindow.document.write(htmlString);
						imgPopupWindow.document.close();
					});
			    }
			    
			  //썸네일에 마우스 오버할 때 처리.(thumbnail클래스 클릭하여 확대 레이어팝업 띄우는 함수)
			  	function thumbnailImgMouseOver(e){
		    		$("#imgPopupDiv, #imgPopupBox, #imgPopup").attr("style","");
		    		$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","none");
			  		var iPBInnerDivH = $(".iPBInnerDiv").height();
			  		var imgPopupBox = $("#imgPopupBox");
			  		var imgPopupDiv = $("#imgPopupDiv");
			  		var imgPopup = $("#imgPopup");
			  		
			  		imgPopupBox.removeClass("imgPopupBoxOff imgPopupBoxMagnify").addClass("imgPopupBox");
		    		imgPopupDiv.removeClass("imgPopupDivMagnify").addClass("imgPopupDiv");
		    		imgPopup.removeClass("imgPopupOff imgPopupMagnify").addClass("imgPopup");
		    		imgPopup.attr("src", e.target.src);
		    		
		    		// src에 부여된 height값 읽어오지 못한 경우(창 두개에서 동시에 레이어팝업 조작할 경우)
		    		if (imgPopup.height() == 0){
			    		imgPopup.load (function() {
			    			$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","");
			    			
		    				var imgPB_LeftOffset = (window.innerWidth-imgPopupBox.width()) / 2;
				    		var imgPB_TopOffset = (window.innerHeight-imgPopupBox.height()) / 2 + window.pageYOffset;
				    		var imgP_LeftOffset = (imgPopup.parent().width()-imgPopup.width()) / 2;
				    		
				    		imgPopupBox.css({"left": imgPB_LeftOffset, "top": imgPB_TopOffset});
				    		imgPopupDiv.css({"width": imgPopup.prop("offsetWidth")});
				    		imgPopup.css({"left": "", "top": ((imgPopupBox.height() - imgPopup.height()) / 2) - iPBInnerDivH});
				    		imgPopup.attr("zoom","1");
			    		});
		    		} else {
		    			$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","");
		    			
		    			var imgPB_LeftOffset = (window.innerWidth-imgPopupBox.width()) / 2;
			    		var imgPB_TopOffset = (window.innerHeight-imgPopupBox.height()) / 2 + window.pageYOffset;
			    		var imgP_LeftOffset = (imgPopup.parent().width()-imgPopup.width()) / 2;
			    		
			    		imgPopupBox.css({"left": imgPB_LeftOffset, "top": imgPB_TopOffset});
			    		imgPopupDiv.css({"width": imgPopup.prop("offsetWidth")});
			    		imgPopup.css({"left": "", "top": ((imgPopupBox.height() - imgPopup.height()) / 2) - iPBInnerDivH});
			    		imgPopup.attr("zoom","1");
		    		}
		    		
		    		$("#thumbMagnifyBtn").removeClass("fa fa-minus-square").addClass("fa fa-plus-square");
		    		$("#thumbZoomInBtn, #thumbZoomOutBtn").parent().removeClass("iPBInnerDiv_Top").addClass("iPBInnerDiv_TopOff");
			  	}
			  
			  //썸네일 원본 크기로 보기 기능.
			  	function magnifyThumbnailSize(){
			  		var iPBInnerDivH = $(".iPBInnerDiv").height();
			  		var imgPopupDiv = document.getElementById("imgPopupDiv");
		    		var imgPopup = document.getElementById("imgPopup");
		    		var $imgPopupBox = $("#imgPopupBox");
			  		var $imgPopupDiv = $("#imgPopupDiv");
			  		var $imgPopup = $("#imgPopup");
			  		
			  		if($("#thumbMagnifyBtn").attr("class").indexOf("plus") != -1){
			  			$("#thumbMagnifyBtn").attr("class","fa fa-minus-square");
			  			$imgPopupDiv.css("overflow", "auto");
			  		}
			  		else{
			  			$("#thumbMagnifyBtn").attr("class","fa fa-plus-square");
			  			$imgPopup.css("width", "");
			  			$imgPopupDiv.css("overflow", "");
			  		}
		  			$imgPopup.attr("zoom","1");
		    		
		    		$("#thumbZoomInBtn, #thumbZoomOutBtn").parent().toggleClass("iPBInnerDiv_TopOff iPBInnerDiv_Top");
					$imgPopupBox.toggleClass("imgPopupBox imgPopupBoxMagnify");
		    		$imgPopupDiv.toggleClass("imgPopupDiv imgPopupDivMagnify");
		    		$imgPopup.toggleClass("imgPopup imgPopupMagnify");
		    		
		    		//imgPopupBox frame 가운데로 위치 조정.
		    		$imgPopupBox.css("left",(window.innerWidth-$imgPopupBox.width()) / 2);
		    		var iPBTopOffset = (window.innerHeight-$imgPopupBox.height()) / 2 + window.pageYOffset;
		    		
		    		if(iPBTopOffset < 0){
		    			$imgPopupBox.css("top", 0);
		    		}
		    		else{
			    		$imgPopupBox.css("top", iPBTopOffset);
		    		}
		    		$imgPopupDiv.width(imgPopup.offsetWidth);
		    		
		    		var imgPopupDivSH = imgPopupDiv.scrollHeight;
		    		var imgPopupDivCH = imgPopupDiv.clientHeight;
		    		var imgPopupCH = imgPopup.clientHeight;
		    		
		    		//imgPopup 세로 위치 조정.
		    		if( imgPopupCH > imgPopupDivCH && imgPopup.naturalHeight > 700 ){
		    			$imgPopup.css("top", 0);
		    		}else{
		    			$imgPopup.css("top",(($imgPopupBox.height() - $imgPopup.height()) / 2) - iPBInnerDivH);
		    		}
			  	}
			  	
			  //썸네일 이미지 팝업박스를 토글해준다.
			  	function toggleImgPopupBox(e){
			  		var imgPopupBox = $("#imgPopupBox");
			  		var imgPopupDiv = $("#imgPopupDiv");
			  		var imgPopup = $("#imgPopup");
			  		
			  		$("#imgPopupDiv, #imgPopupBox, #imgPopup").attr("style","");
			  		
			  		//마우스 오버 이벤트 없애는 작업과 함께 이미지 뷰어가 보이는 상태에서 다른 그림 선택했을 때 처리하기 위해 수정. 2018-06-19 홍대표
			  		if(e.target.id != "thumbCloseBtn"){
			  			thumbnailImgMouseOver(e);
			  			return;
			  		}
			  		
			  		if(imgPopup.attr("src")){
				  		imgPopupBox.removeClass("imgPopupBox").addClass("imgPopupBoxOff");
				  		imgPopupDiv.removeClass("imgPopupDivMagnify").addClass("imgPopupDiv");
				  		imgPopup.removeClass("imgPopup").addClass("imgPopupOff");
				  		imgPopup.removeAttr("src");
			  		}
			  		else if(e.target.getAttribute("class") === "thumbnail"){
			  			thumbnailImgMouseOver(e);
			  		}
			  	}
			  	
			  	//줌인버튼 기능.
			  	function zoomInImgPopup(){
			  		var zoom = 1;
			  		var zoomOffset = 0.1;
			  		var $imgPopupBox = $("#imgPopupBox");
			  		var $imgPopupDiv = $("#imgPopupDiv");
			  		var $imgPopup = $("#imgPopup");
			  		var imgPopupOrignW =  $imgPopup.prop("naturalWidth");
			  		
			  		//zoom이 숫자가 아닌 다른 형태로 넘어올 때 처리.
			  		if($imgPopup.attr("zoom").indexOf("%") != -1){
			  			zoom = parseFloat($imgPopup.attr("zoom").replace("%", "") / 100) + zoomOffset;
			  		}
			  		else if($imgPopup.attr("zoom").indexOf("normal") != -1){
			  			zoom = 1 + zoomOffset;
			  		}
			  		else{
				  		zoom = parseFloat($imgPopup.attr("zoom")) + zoomOffset;
			  		}
			  		zoom = zoom.toFixed(1);
			  		$imgPopup.attr("zoom", zoom);
			  		
			  		var iPBInnerDivH = $(".iPBInnerDiv").height();
			  		var thumbImgH = $imgPopup.prop("naturalHeight") * zoom;
			  		var imgPopupDiv = document.getElementById("imgPopupDiv");
		    		var imgPopup = document.getElementById("imgPopup");
			  		var imgPopupDivCH = imgPopupDiv.clientHeight;
			  		$imgPopup.width(imgPopupOrignW * zoom);
			  		$imgPopupDiv.width(imgPopupOrignW * zoom);
			  		
			  		//imgPopup 세로 위치 조정.
			  		if(thumbImgH < (imgPopupDivCH - 100)){
			  			var topOffset = "";
				  		topOffset = ((($imgPopupBox.height() - thumbImgH) / 2) - iPBInnerDivH);

			  			$imgPopup.css("top", topOffset);
			  		}
			  		else if(thumbImgH > (imgPopupDivCH - 100)){
			  			$imgPopup.css("top", 0);
			  			$imgPopupDiv.css("overflow", "auto");
			  		}
			  	}
			  	
			  	//줌아웃 버튼 기능.
			  	function zoomOutImgPopup(){
			  		var zoom = 1;
			  		var zoomOffset = 0.1;
			  		var $imgPopupBox = $("#imgPopupBox");
			  		var $imgPopupDiv = $("#imgPopupDiv");
			  		var $imgPopup = $("#imgPopup");
			  		var imgPopupOrignW =  $imgPopup.prop("naturalWidth");
			  		
			  		//zoom이 숫자가 아닌 다른 형태로 넘어올 때 처리.
			  		if($imgPopup.attr("zoom").indexOf("%") != -1){
			  			zoom = parseFloat($imgPopup.attr("zoom").replace("%", "") / 100) - zoomOffset;
			  		}
			  		else if($imgPopup.attr("zoom").indexOf("normal") != -1){
			  			zoom = 1 - zoomOffset;
			  		}
			  		else{
				  		zoom = parseFloat($imgPopup.attr("zoom")) - zoomOffset;
			  		}
			  		zoom = zoom.toFixed(1);
			  		
			  		// 0.1보다 작은 비율로는 축소 불가능
			  		if ( zoom >= 0.1 ) {
				  		$imgPopup.attr("zoom", zoom);
			  		} else {
			  			return;
			  		}
			  		
			  		var thumbImgW = imgPopupOrignW * zoom;
			  		var thumbImgH = $imgPopup.prop("naturalHeight") * zoom;
			  		var iPBInnerDivH = $(".iPBInnerDiv").height();
			  		var imgPopupDiv = document.getElementById("imgPopupDiv");
		    		var imgPopup = document.getElementById("imgPopup");
			  		var imgPopupDivCW = imgPopupDiv.clientWidth;
		    		var imgPopupDivCH = imgPopupDiv.clientHeight;
		    		$imgPopup.width(thumbImgW);
		    		$imgPopupDiv.width(thumbImgW);
		    		
			  		if(thumbImgW > (imgPopupDivCW - 100)){
			  			$imgPopup.css("left","");
			  		}
			  		
			  		//imgPopup 세로 위치 조정
			  		if(thumbImgH < (imgPopupDivCH - 100)){
			  			var topOffset = "";
				  		topOffset = ((($imgPopupBox.height() - thumbImgH) / 2) - iPBInnerDivH);

			  			$imgPopup.css("top", topOffset);
			  		}
			  		else if(thumbImgH > (imgPopupDivCH - 100)){
			  			$imgPopup.css("top", 0);
			  			$imgPopupDiv.css("overflow", "auto");
			  		}
				}
				
				function addRelatedCabinet() {
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
					var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
					return feature;
				}
			  	
			  	 /* 2019-04-05 홍승비 - 좋아요 버튼 클릭 동작 */
			  	 /* 2023-04-06 기민혁 - 좋아요 버튼 클릭 동작 (수정) */
			   function clickLikeButton() {
			    	var mod = "";

			    	if(isDisLikeChecked == "Y"){
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
			    function checkRefreshFlag () {
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
			    
				/* 2023-11-17 홍승비 - 관리자 권한자의 '게시 알림' 옵션에 대한 게시알림 함수 추가, 비동기로 백그라운드 동작 */
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
			    
			    /* 2023-04-06 기민혁 - 싫어요 버튼 이미지 및 좋아요 갯수 업데이트 */
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
			    };

			    /* 2023-05-03 기민혁 -  스크랩 추가 클릭시 data insert */
			    function addScrapType1(){
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
							} else if(result == "false"){
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
                        if(result == "true") {	
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
                    alert("예약게시물은 재게시가 불가능합니다.");
                    return;
                }

                if (newEndDate < currentDate) {
                    alert("게시기간이 만료된 게시물은 재게시가 불가능합니다.");
                    return;
                }

                if(confirm("재게시를 하시면 최근 게시물로 등록됩니다.\n재게시 하시겠습니까?")) {
                    var xmlhttp = createXMLHttpRequest();
                    xmlhttp.open("POST", "/ezBoard/repostItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&userID=" + userInfoID, false);
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
		</script>
	</head>
	<body  id="bodyPopup" class="popup" style="overflow:hidden; height:100%;">
		<table class="layout" style="border-spacing:0; border-bottom:1px solid #ddd; border:0px; width:100%; min-width:745px;">
		  <tr>
		    <td style="height:20px; vertical-align:top">
		      <div id="menu">
		        <ul>
		        	<c:choose>
		        		<%-- 2018-06-20 홍승비 - 승인/반려 버튼만 활성화, 작성자는 수정/삭제 가능 --%>
		        		<c:when test="${apprFlag == 'N'}">
			                <li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005'/></span></li>
			                <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014'/></span></li>
			                	<c:if test="${boardItem.writerID == userInfo.id}">
				                	<li ID='btn_Reply' ><span onclick='btn_Add_Onclick()'><spring:message code='ezBoard.t1001'/></span></li>
				                	<li ID='btn_Modify' ><span  onclick="btn_ImgOnclick('Mod')"><spring:message code='ezBoard.t1002'/></span></li>
				                    <li ID='btn_Delete' ><span  onclick="btn_ImgOnclick('Del')"><spring:message code='ezBoard.t1003'/></span></li>
				                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t1004'/></span></li>
				                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t1005'/></span></li>
		                    	</c:if>
						</c:when>
		        		<c:when test="${apprFlag == 'C'}">
			                <li><span onClick="btn_ReWrite()"><spring:message code='ezBoard.t999021'/></span></li>
		        		</c:when>
		        		<c:otherwise>
		        			<!--		강민수92	   -->
	        				<c:if test = "${oneLineReplyFlag == '1'}">
	        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81'/>[${commentCount}]</span></li>
	        				</c:if>
							<!--		강민수92 end -->
		        			<c:if test="${boardInfo.boardAdmin_FG =='true' || boardInfo.boardGroupAdmin_FG == 'OK' || (boardItem.writerID == userInfo.id && boardInfo.edit_FG == 'true') || (boardItem.writerNameType == '1' && boardItem.writerDeptID == userInfo.deptID)}">
			                    <li ID='btn_Reply' ><span onclick='btn_Add_Onclick()'><spring:message code='ezBoard.t1001'/></span></li>
			                    <li ID='btn_Modify' ><span  onclick="btn_ImgOnclick('Mod')"><spring:message code='ezBoard.t1002'/></span></li>
			                    <li ID='btn_Delete' ><span  onclick="btn_ImgOnclick('Del')"><spring:message code='ezBoard.t1003'/></span></li>
			                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t1004'/></span></li>
			                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t1005'/></span></li>
			                    <c:if test="${boardItem.itemLevel == 1 && (boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK')}"><%-- 답변글은 재게시 버튼 안뜨도록 함 --%>
                                    <li ID='btn_Repost'><span onclick='btn_Repost_Onclick()'>재게시</span></li>
                                </c:if>
		        			</c:if>
		                    <li ID='btn_Read' ><span  onclick="ReaderList()"><spring:message code='ezBoard.t1006'/></span></li>
		                    <li ID='btn_down' ><span  onclick="btn_ImgDownload()"><spring:message code='ezBoard.t1007'/></span></li>
		        		</c:otherwise>
		        	</c:choose>
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
		      </div>
		      <div id="close">
		        <ul>
		            <li ><span  onclick="btnClose_onclick()"></span></li>
		        </ul>
		      </div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
			</script>
		    </td>
		  </tr>
		  <tr>
		     <td>
		         <table class="content" style="border:0px; width:100%">
		            <tr>
		              <th style="width:10%"><spring:message code='ezBoard.t223'/></th>
			              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="WriteUserNM">
			              	  <div style="vertical-align:middle;width:100%;height:16px;">
								 <span onclick='OpenUserInfo("${boardItem.writerID}", "${boardItem.writerDeptID} ")' style="cursor:pointer;"><c:out value="${boardItem.writerName}"/></span>
							  </div>
			              </td> 
		              <th style="width:10%"><spring:message code='ezBoard.t289'/></th>
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;"id="User_DeptNM"><c:out value="${boardItem.writerDeptName}"/></td>
		            </tr>
		            <tr>
		              <th style="width:10%"><spring:message code='ezBoard.t290'/></th>
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="User_JobTitle">${boardItem.extensionAttribute3}</td>
		              <th style="width:10%"><spring:message code='ezBoard.t224'/></th>
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="User_WriteDate">${boardItem.writeDate.substring(0, 16)} </td>
		            </tr>
		            <%-- 키워드 --%>
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
                    <c:if test="${(boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && not empty boardItem.updateDate}">
                    <!-- 수정자, 수정일 -->
                        <tr>
                            <th style="width:10%;"><spring:message code='ezBoard.updateJIH01' /></th>
                            <td id="updaterName" style = "white-space:nowrap; padding-right:5px; width: 40%;">
                                <div style="vertical-align:middle;width:100%;height:16px;">${boardItem.updaterName}</div>
                            </td>
                            <th style="width:10%;"><spring:message code='ezBoard.updateJIH02' /></th>
                            <td id="updateDate" style = "white-space:nowrap; padding-right:5px; width: 40%;">
                                <div style="vertical-align:middle;width:100%;height:16px;">${boardItem.updateDate.substring(0, 16)}</div>
                            </td>
                        </tr>
                    <!-- 수정자, 수정일 end -->
                    </c:if>	
		            <tr>
		              <th><spring:message code='ezBoard.t291'/></th>
		              <td id="cTitle" colspan="3">
			              <div id="title" style="OVERFLOW-Y:auto; WIDTH:100%; vertical-align:middle;"><c:out value="${boardItem.title}"/></div>
		              </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezBoard.t1008'/></th>
		                <td id="cimagecontent" colspan="3" style="padding-right:0px">
		                    <div id="Div2" style="OVERFLOW-Y: auto; overflow-x:hidden; height:55px;WIDTH: 100%; padding-top:5px;padding-bottom:5px; vertical-align:middle; white-space:pre-wrap; word-break:break-word;"><c:out value="${boardItem.mainContent}"/></div>
		                </td>
		            </tr>
		          </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="width:100%;  text-align:center; vertical-align:top;padding-top:10px;" >
		        <table style="width:100%; border:1px solid #ddd;  ">
				  <tr>
		        	<td style="height:55px;" colspan="3">
		            </td>
		        </tr>
		        <tr>
		            <td style="width:100px; padding-left:50px; text-align:center">
		                <img src="/images/previous.png" style="width:70px;height:70px;border:0;cursor:pointer;" onclick="Pagenationimage('prevPage');" />
		            </td>
		            <td style="display:inline-block;">
		                <table id="imagetable" style="text-align:center; border:0px;">
		                    <tr>  
		                        <td style="width:400px;height:300px; min-height:300px; border:1px solid #e3e1e2; text-align:center;">
		                            <img id="mainimages" class="thumbnail" style="background-color:#ffffff;cursor:pointer;" src=""/>            
		                        </td>
		                    </tr>
		           	    </table>
		            </td>
		            <td style="width:100px; padding-right:50px; text-align:center">
		                <img src="/images/next.png" style="width:70px;height:70px;border:0;cursor:pointer;" onclick="Pagenationimage('nextPage');" />
		            </td>
		        </tr>
		        <tr>
		        	<td class="MainContentTD" style="padding:10px 0px; height:83px; text-align:center" colspan="3">
		            	<div id="MainContent" style="height:60px; padding-left:23%; padding-right:24%;white-space: pre-wrap; overflow: auto;"></div>
		            </td>
		        </tr>
			<%-- 2019-04-05 홍승비 - 본문, 사진소개 하단에 좋아요 버튼 추가 --%>
			<%-- 2023-04-06 기민혁 - 싫어요 버튼 추가 --%>
			<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y' || boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
				<tr>
					<td style="text-align:center; padding-bottom:8px;" colspan="3">
						<div style="display: flex; justify-content: center; ">
							<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y'}">
								<div id="likeDiv" style="text-align:center; padding:5px 0px 7px 0px; margin-right: 5px;">	
						  			<span class="likeButton" onclick="clickLikeButton()" title="<spring:message code='ezBoard.hsb10'/>" style="height:20px;">
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
			
							<c:if test="${boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
								<div id="disLikeDiv" style="text-align:center; padding:5px 0px 7px 0px;">	
						  			<span class="disLikeButton" onclick="clickDisLikeButton()" title="<spring:message code='ezBoard.kmh07'/>" style="height:20px;">
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
					</td>
				</tr>
			</c:if>
                <%-- 2024-09-24 이혜림 - 본문 하단, 첨부파일/한줄댓글 상단에 별점 평가하기 추가 --%>
                <c:if test="${not empty boardInfo.starRatingFlag && boardInfo.starRatingFlag == 'Y'}">
                    <tr>
                        <td style="text-align:center; padding-bottom:8px;" colspan="3">
                       <div id="ratingContainer" class="rating_div" onclick="clickRatingButton()">
                                <div>
                                <span id="avgScore"><b>${itemStarRating.averageScore}</b><spring:message code='ezBoard.lhr004'/></span>
                                    <span>(<span id="totalRaters">${itemStarRating.totalRaters}</span><spring:message code='ezBoard.lhr003'/>)</span>
                                </div>
                                <span class="ratingButton" title="<spring:message code='ezBoard.lhr001'/>">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:set var="srcIconFlag" value="${itemStarRating.rating >= i}" />
                                <label for="rate${i}">
                                    <input type="radio" name="reviewStar" value="${i}" id="rate${i}" <c:if test="${itemStarRating.rating == i}"> checked </c:if> />
                                    <img draggable="false" src="/images/ImgIcon/${srcIconFlag ? 'icon-flag.gif' : 'view-flag.gif'}"/>
                                </label>
                                </c:forEach>
                                </span>
                                <a class="imgbtn"><span onclick="clickSaveRatingButton()"><spring:message code='ezBoard.lhr001'/></span></a>
                            </div>
                        </td>
                    </tr>
                </c:if>
		        </table>
		    </td>
		  </tr>
		    <%--<tr style="display:none;">
		        <td style="text-align:center">
		            <span id="MainContent" ></span>
		        </td>
		    </tr>--%>
		    <tr>
		        <td  >
					<div style="background:#f8f8fa; border:1px solid #ddd; border-top:0 none; height:70px; text-align:center; padding-top:25px;">
		            <table border="0">
		                <tr>
		                    <td style="width:30px; padding-left:15px;padding-right:1px;padding-bottom:5px; vertical-align:bottom; text-align:left" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/previous.png" id="SmallImagePrev" style="width:30px;height:30px;border:0;cursor:pointer;" onclick="btn_SmallIamge('Prev')" />
		                    </td>
		                    <td onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <div class="content" id="viewBox" style="width:100%; border:0;" ></div>
		                    </td>
		                    <td style="width:30px; padding-bottom:5px; vertical-align:bottom; text-align:right" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/next.png" id="SmallImageNext" style="width:30px;height:30px;border:0;cursor:pointer;" onclick="btn_SmallIamge('Next')" />
		                    </td>
		                </tr>
		            </table>
				</div>
		        </td>
		    </tr>
		  <%--2011-04 : 한줄 답변 옵션 처리--%>
<%-- 		  <c:choose> --%>
<%-- 		  	<c:when test="${oneLineReplyFlag == '1'}"> --%>
<!-- 			  <tr> -->
<!-- 			    <td style="height:50px"> -->
<!-- 			        <table> -->
<!-- 			            <tr> -->
<!-- 			                <td style="height:20px;"></td> -->
<!-- 			            </tr> -->
<!-- 			        </table> -->
<!-- 			        <table class="content">    -->
<!-- 			        <tr> -->
<%-- 			            <th><spring:message code='ezBoard.t486'/></th> --%>
<!-- 			            <td class="pos1"><input id="onelinereply" style="WIDTH: 100%" type="text" maxLength="100" onKeyDown="OneLineReply_onkeydown(event)"></td> -->
<%-- 			            <td class="pos2"><a class="imgbtn"><span onClick="Save_OneLineReply(event)"><spring:message code='ezBoard.t98'/></span></a></td> --%>
<!-- 			        </tr> -->
<!-- 			        <tr> -->
<!-- 			            <td style="height:100px" colspan="4"> -->
<!-- 			                <div id="onelinereplylist" style="OVERFLOW:auto; HEIGHT: 90px; background-color:white; padding:10px; text-align:left"></div> -->
<!-- 			            </td> -->
<!-- 			        </tr> -->
<!-- 			        </table> -->
<!-- 			      </td> -->
<!-- 			  </tr> -->
<!-- 			  <tr> -->
<!-- 			    <td style="DISPLAY:none; height:50px" class="pad1"> -->
<!-- 			        <table class="file"> -->
<!-- 			            <tr> -->
<%-- 			              <th><spring:message code='ezBoard.t292'/></th> --%>
			
<!-- 			              <td class="pos1"> -->
<!-- 			                  <div style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left" id="lstAttachLink"></div> -->
<!-- 			              </td> -->
<%-- 			              <td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325'/></span></a><a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98'/></span></a> </td> --%>
<!-- 			              <td id="ItemLevel"></td> -->
<!-- 			            </tr> -->
<!-- 			      </table> -->
<!-- 			    </td> -->
<!-- 			  </tr> -->
<%-- 		  	</c:when> --%>
<%-- 		  	<c:otherwise> --%>
<!-- 		        <tr style="DISPLAY:none"> -->
<!-- 				    <td class="pad1" style="height:20px"> -->
<!-- 					    <table class="file"> -->
<!-- 				     	   <tr> -->
<%-- 			        		<th><spring:message code='ezBoard.t292'/></th> --%>
<!-- 				          	<td class="pos1"><div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left"></div></td> -->
<%-- 				          	<td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325'/></span></a><a class="imgbtn"><span onClick="attach_Download()"> <spring:message code='ezBoard.t98'/></span></a></td> --%>
<!-- 				          	<td id="ItemLevel"></td> -->
<!-- 				        	</tr> -->
<!-- 				        </table> -->
<!-- 				    </td> -->
<!-- 		 	 	</tr> -->
<%-- 		  	</c:otherwise> --%>
<%-- 		  </c:choose> --%>
			<%-- 2019-11-05 홍승비 - 하단댓글 영역 추가 --%>
	        <c:if test="${oneLineReplyFlag == '2'}">
	        	<div style='height:auto;'>
					<table class="mainlist emoticonLayerStaticPosition" style="width:100%; min-width:745px; margin-top:8px;" >
						<tr>
							<th style="text-align:center; width: 85%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
                                <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                                <div class="emoticonRelative">								    
                                    <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                    <textarea id="onelinereply" rows="3" style = "resize:none; width:90%;" maxlength="500"></textarea>
                                </div>
							</th>
							<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2; width:15%">
								<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
								    <a class='imgbtn' style="vertical-align: middle"><span onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span></a><br/>
								</c:if>
								<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></span></a>
							</th>
						</tr>
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
					<table id="commentList" style="width:100%; min-width:745px; margin-top:2px; overflow:auto;border:1px solid rgb(225,225,225)"></table>
				</div>
	        </c:if>
	        <%-- 본문하단 댓글영역 끝 --%>
		  <c:if test="${adjacentItemsEnableFlag == '1' && showAdjacent == '1'}">
			  <tr>
			    <td style="height:20px">
			    <table>
			        <tr>
			            <td style="height:20px"></td>
			        </tr>
			    </table>
			    <table class="content">
			        <!-- 표준모듈 (2007.02.22) 수정 : 다음/이전글 위치변경-->
			        <tr>
			          <th><spring:message code='ezBoard.t327'/></th>
			          <c:choose>
				          <c:when test="${boardAdjacent.previousItemID == ''}">
				          	<td style="width:100%">
				          </c:when>
				          <c:otherwise>
				          	<td style="cursor:pointer; width:100%">
				          </c:otherwise>
			          </c:choose>
			          <div style="word-break:break-all;HEIGHT: 18px; padding-top:2px; background-color:white; text-align:left" onClick="OpenItem('${boardAdjacent.previousItemID}')">${boardAdjacent.previousTitle}</div></td>
			        </tr>
			        <tr>
			          <th><spring:message code='ezBoard.t328'/></th>
			          <c:choose>
			          	<c:when test="${boardAdjacent.nextItemID == ''}">
			          		<td>
			          	</c:when>
			          	<c:otherwise>
			          		<td style="cursor:pointer">
			          	</c:otherwise>
			          </c:choose>
			          <div style="word-break:break-all;HEIGHT: 18px; padding-top:2px; background-color:white; text-align:left" onClick="OpenItem('${boardAdjacent.nextItemID}')">${boardAdjacent.nextTitle}</div></td>
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
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    
	    <%-- 2018-07-20 홍승비 - 이미지 클릭 시 레이어팝업 표출 --%>
	    <div id="imgPopupBox" class="imgPopupBoxOff">
			<div style="height:50px;" class="iPBInnerDiv">
    			<div class="iPBInnerDiv_Top">
    				<i id="thumbCloseBtn" class="fa fa-times-circle thumbCloseBtn"></i>
    			</div>
    			<div class="iPBInnerDiv_Top">
    				<i id="thumbMagnifyBtn" class="fa fa-plus-square thumbMagnifyBtn"></i>
    			</div>
    			<div class="iPBInnerDiv_TopOff">
    				<i id="thumbZoomInBtn" class="fa fa-search-plus"></i>
   				</div>
   				<div class="iPBInnerDiv_TopOff">
    				<i id="thumbZoomOutBtn" class="fa fa-search-minus"></i>
   				</div>
   			</div>
   			<div id="imgPopupDiv" class="imgPopupDiv">
				<img id="imgPopup" class="imgPopup">
   			</div>
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
	</body>
</html>
