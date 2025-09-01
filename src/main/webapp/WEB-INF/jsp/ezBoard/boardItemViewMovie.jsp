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
				var isDisLikeChecked = "<c:out value='${isDisLikeChecked}'/>";
				var disLikeFlag = "<c:out value='${boardInfo.disLikeFlag}'/>";
				var disLikeCount = "${boardItem.disLikeCount}";
				var disLikeCountAfter = 0;
				var refreshFlag = "N";
				var commentCount = "${commentCount}";
			    var nowCommentCount = ""; // 댓글 옵션처리를 위해 전역변수로 변경
			    var userInfoID = "${userInfo.id}"; // 댓글 삭제가능여부 판단을 위해 자신의 userID 사용
		        var ImageCount = "";
		        var moviePath = "";
		        var movieID= "";
		        var movieContent = "";
		        var pPage = 1;
		        var imagepage = "0";
		        var imagetotalcount = "";
		        var imgWidth = "57px";
		        var imgHeight = "37px";
		        var rsa = new RSAKey();
		        var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
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
                
                var myBoardScrapFlag = "<c:out value='${MyBoardScrapFlag}'/>" // myBoardScrapFlag 테넌트컨피그값 (NONE, TYPE1_(마이게시판하위), TYPE2(스크랩함))
		        var isScrap = "<c:out value='${isScrap}'/>"; // 이미 스크랩되었는지의 여부 (type1일때)
                var scrapContID = "<c:out value='${scrapContID}'/>"; // 개인스크랩함 ID (TYPE2, 스크랩함에서 게시물 조회했을 때 값이 들어옴)
				var starRatingFlag = "<c:out value='${boardInfo.starRatingFlag}'/>";
                var rating = "${itemStarRating.rating}";

				/* 2023-11-17 홍승비 - 게시물 승인 시 게시알림메일 발송을 위한 그룹사게시판 여부 파라미터 추가 */
				var isAllGroupBoard = "<c:out value='${boardInfo.isAllGroupBoard}'/>";
				var commentSort = "earliest"; // 댓글 정렬 기준 : earliest(등록순) / latest(최신순)
				
			    var attachmentFlag = "${boardInfo.attachmentFlag}"; // 게시판 첨부파일 사용여부
                var attachLimit = "${boardInfo.attachSizeLimit}"; // 개별 첨부파일 limit
                var attachFileNameMaxLength = Number("${attachFileNameMaxLength}"); // 첨부파일명 글자수 제한 limit
                var totalFileSize = 0; // 현재 총 첨부파일 사이즈
				var addThumbnail = "<c:out value='${addThumbnail}'/>";
				var thumbnailExt = "<c:out value='${thumbnailExt}'/>";
				var AttachLimit = "${boardInfo.attachSizeLimit}";

				var writerNameType = "<c:out value='${boardItem.writerNameType}'/>"; // 2025-01-21 임정은 - 게시자명선택 타입 (0 : 이름, 1 : 부서명)
				var strWriterDeptID = "${boardItem.writerDeptID}";
				var SSDeptID = "<c:out value='${userInfo.deptID}'/>";
				var guestReadFG = "${guestReadFG}";
				
		        window.onload = function () {
		        	imageViewInit();
		            rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		            makeEmoticonPanel();
		            
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
		            
		            /* 2019-11-05 홍승비 - 본문 하단에 댓글영역 표출 */
					if (OneLineReplyFlag == "2" && guestReadFG !== "Y") {
 		            	document.getElementById("bodyPopup").style.overflowX = "hidden";
 		            	document.getElementById("bodyPopup").style.overflowY = "auto";
 		            	self.resizeTo(794, 815);
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
					/* 2019-04-05 홍승비 - 좋아요 버튼이 존재한다면 본문 패딩 조절 */
		            if ((likeFlag != null && likeFlag == "Y") || (disLikeFlag != null && disLikeFlag == "Y")) {
						$(".movieTR").css("padding" , "20px 0px 0px 0px");
		            }
		        });
		        
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
		            var xmldom = createXmlDom();
		
		            xmldom = loadXMLString(result);
		            
	            //    movieContent = getNodeText(xmldom.getElementsByTagName("FILECONTENT")[0]);
	                moviePath = getNodeText(xmldom.getElementsByTagName("FILEPATH")[0]);
	                movieID = getNodeText(xmldom.getElementsByTagName("IMAGEID")[0]);
	                movieName = getNodeText(xmldom.getElementsByTagName("IMAGENAME")[0]);
	                
					movieMain(movieID, moviePath, movieName);
		        }
		        
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
		
				var checkpassword_dialogArguments = new Array();
				function btn_Delete_Onclick()
				{
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
			            xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemList=" + encodeURIComponent(pItemID) + "&mode=MOVIE", false);
			            xmlhttp.send();
	
			            if (xmlhttp.responseText == "NO") {
			                alert("<spring:message code='ezBoard.t265'/>");
	                        return;
	                    }
	
			            xmlhttp = null;
			            try {
		                	window.opener.leftCountRf();
						} catch (e) {
						}
			            try {
			                window.opener.refresh_onclick();
			            } catch (e) {
			            }
			            
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

						if (window.opener) {
							window.close();
						} else {
							window.location.reload();
						}
				    }
				}
				
		        window.onunload = function () {
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
				}
		
				function attach_SelectAll()
				{
					var checks = lstAttachLink.all.tags("input");
					for (var i=0; i<checks.length; i++)
						checks.item(i).checked = true;
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
		
					var szHref = "/ezBoard/itemReadList.do?boardID=" + encodeURI(pBoardID) + "&itemID=" + encodeURI(pItemID);			
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
		
// 				function OneLineReply_onkeydown(e)
// 				{
// 				    if (e.keyCode == 13) {
// 				        e.returnValue = false;
// 				        e.cancelBubble = true;
// 				        Save_OneLineReply(e);
// 				    }
// 				}
		
// 				function Save_OneLineReply(e)
// 				{
// 					if (Reply_FG != "true") 
// 					{
// 						alert("<spring:message code='ezBoard.t303'/>");
// 						return;
// 					}
					
// 				    e.returnValue = false;
// 				    e.cancelBubble = true;
		
// 					//event.returnValue = false;
// 					//event.cancelBubble = true;
					
// 					//2011-04 : 한줄 답변 옵션 처리
// 					if(OneLineReplyFlag == "1")
// 					{
// 					    if (document.getElementById("onelinereply").value == "") 
// 					    {
// 						    alert("<spring:message code='ezBoard.t307'/>");
// 						    return;
// 					    }
// 					}
					
// 					//2011.04.13 익명게시판의 경우 한줄답변 등록시 password 추가
// 					if (gubun == "2" && trim(document.getElementById("txtPassWord").value) == "" )
// 					{
// 					    alert("<spring:message code='ezBoard.t391'/>");
// 					    txtPassWord.focus();
// 						return;
// 					}
					
// 					var pReplyID = "";
// 					pReplyID = generateGuid();
					
// 					var content,password;
// 					if (OneLineReplyFlag == "1"){
// 						content = MakeXMLString(document.getElementById('onelinereply').value);
// 					}else{
// 						content = "";
// 					}
// 					if (gubun != "2") {
// 					    password = "";
// 					}
// 					else {
// 					    password = rsa.encrypt(document.getElementById("txtPassWord").value);
// 					}
					
// 					$.ajax({
// 						type : "POST",
// 						dataType : "text",
// 						async : false,
// 						url : "/ezBoard/saveOneLineReply.do",
// 						data : { boardID    : pBoardID, 
// 								 itemID 	: pItemID,
// 								 replyID	: pReplyID,
// 								 content	: content,
// 								 password	: password
									 
// 							   },
// 						success: function(){
// 							reloadOneline();
// 						}
// 					});
// 				}
		
// 				function reloadOneline(){
// 				    if (OneLineReplyFlag == "1")
// 				        document.getElementById('onelinereply').value = "";
// 				    if (gubun == "2")
// 				        document.getElementById('txtPassWord').value = "";
// 				    getOneLineReply();
// 				}
				
// 				function delete_onelinereply(pReplyID)
// 				{
// 				     var xmlhttp = createXMLHttpRequest();
				    
// 				    //게시판관리자 또는 게시판그룹관리자 또는 게시물작성자가 아니면 지울 수 없다
// 					if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") 
// 					{
// 					    xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + pReplyID, false);
// 					    xmlhttp.send();
		        			
// 					    if (xmlhttp.responseText.substr(0,2) != "OK")
// 					    {
// 						    alert("<spring:message code='ezBoard.t310'/>");
// 						    return;
// 					    }
		        			
// 					    if (!confirm("<spring:message code='ezBoard.t311'/>")) 
// 					    	return;
		
// 					} else {
// 						    if(!confirm("<spring:message code='ezBoard.t311'/>")) 
// 						    	return;
// 						}
					
// 					xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + pReplyID+"&guBun="+gubun, false);
// 					xmlhttp.send();
// 					getOneLineReply();			
// 					xmlhttp = null;
// 				}
				
// 			    function getOneLineReply()
// 			    {
// 			        var xmlhttp = createXMLHttpRequest();
// 			        xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
// 			        xmlhttp.send();
// 			        var xmldom = createXmlDom();
// 			        //xmldom.loadXML(xmlhttp.responseText);
// 			        xmldom = loadXMLString(xmlhttp.responseText);
// 			        xmlhttp = null;
// 			        strHTML = "";
// 			        var temp;
// 			        for (var i=0; i<xmldom.getElementsByTagName("REPLYID").length; i++)
// 			        {
// 			            temp = i+1;
// 			            strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i))+ "\")'><p>";
// 			        }
// 			        if (i==0)
// 			            strHTML = "<spring:message code='ezBoard.t312'/>";
		            
// 		            try
// 		            {
// 		                document.getElementById("onelinereplylist").innerHTML = strHTML;
// 		            }
// 		            catch(e)
// 		            {
// 		            }
// 			    }
				
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
					if (strItemID != "") {
						window.location.href = window.location.href.replace(pItemID, strItemID);
					}
				}
				
				function GoTop()
				{
				    message.AGoTop.click();
				}
				
				function GoDown()
				{
				    message.AGoDown.click();
				}
		
		        function movieMain(movieID, moviePath, movieName)
		        {
		            document.getElementById("mainVideo").src = moviePath;
		            document.getElementById("mainVideo").setAttribute("movieid", movieID);
		            document.getElementById("mainVideo").title = movieName;
					if (guestReadFG !== "Y") {
						document.getElementById("movieDownload").href = "/ezBoard/boardAttachDown.do?filePath=" + javaURLEncode(moviePath) + "&fileName=" + javaURLEncode(movieName);
					}
		        }
		        
		        function showHideLayers()
		        {
		            showDiv.style.display = "block";
		        }
		
		        function btn_movieMod() {
		            var swidth;
		            var sheight;
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		 	
               		swidth = 460;
               		
		            if (navigator.userAgent.toLowerCase().indexOf("edg") > 0) {
		            	swidth = 550;
		            }
		            
                	sheight = 380;
		            pleft = (pwidth - swidth) / 2;
		            ptop = (pheight - sheight) / 2;
		            
	                window.open("/ezBoard/modifyMovieItem.do?movieID=" + encodeURI(document.getElementById("mainVideo").getAttribute("movieid")) + "&boardID=" + encodeURI(pBoardID) + "&itemID=" + encodeURI(pItemID) + "&page=" + pPage + "&guBun=" + gubun + "&addThumbnail=" + addThumbnail + "&thumbnailExt=" + thumbnailExt, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft, "");
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
	                photoalbumedit_dialogArguments[0] = params;
	                photoalbumedit_dialogArguments[1] = btn_albumEdit_Complete;
	                DivPopUpShow(400, 200, "/ezBoard/movieAlbumEdit.do");          
		        }
		        
		        function btn_albumEdit_Complete(ret) {
		            DivPopUpHidden();
		            if (ret == "OK") {
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
		            	
		            	window.opener.location.reload();
						window.location.reload();
		        	}
		        }
		        
		        function Appr_onclick(pFlag) {
		            if (pFlag == "C") {
		                var OpenWin = window.open("/ezBoard/boardApprOpinion.do?itemList=" + encodeURI(pItemID) + ";&mode=" + pFlag, "BoardApprOpinion", GetOpenWindowfeature(540, 300));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                var xmlhttp = createXMLHttpRequest();
		                xmlhttp.open("POST", "/ezBoard/apprBoardItem.do?itemList=" + encodeURIComponent(pItemID) + ";&mode=" + pFlag, false);
		                xmlhttp.send();
		
		                if (xmlhttp.responseText == "OK") {
		                	/* 2023-11-17 홍승비 - 승인게시판의 게시물 승인 시 게시알림메일 발송 기능 추가 (동영상 게시판은 답변게시물 사용 불가) */
		                	if (pFlag == "Y") { // 승인
		                		// 해당 게시판의 관리자에게 게시알림 발송 (게시판 권한설정 > 관리자 권한자인 경우 '게시 알림' 옵션)
		                		sendPostNotiForAdmin(pBoardID, pItemID);
		                		
	                			// 해당 게시판의 일반 사용자(접근 권한자)에게 게시알림메일 발송 (게시판 일반설정 > 메일알림 > '게시알림' 옵션)
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
		        function window_reload() {
			        window.location.href = window.location.href;
			    }
		        
		        function btn_ReWrite() {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		            window.close();
		            
		            window.open("/ezBoard/boardNewItemTempMovie.do?boardID=" + encodeURI(pBoardID) + "&itemID=" + encodeURI(pItemID) + "&mode=modify" + "&location=", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=679,width=765,top=" + pTop + ",left=" + pLeft, "");
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
			    
				/* 2023-11-17 홍승비 - 관리자 권한자의 '게시 알림' 옵션에 대한 게시 알림 함수 추가, 비동기로 백그라운드 동작 */
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
                        alert("<spring:message code='ezBoard.kmh46'/>");
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

            function btn_ThumbnailModify() {
            	var swidth;
	            var sheight;
	            var pwidth = window.screen.availWidth;
	            var pheight = window.screen.availHeight;
	            var pleft = (pwidth - swidth) / 2;
	            var ptop = (pheight - sheight) / 2;
	 	
           		swidth = 460;
           		
	            if (navigator.userAgent.toLowerCase().indexOf("edg") > 0) {
	            	swidth = 550;
	            }
	            
            	sheight = 380;
	            pleft = (pwidth - swidth) / 2;
	            ptop = (pheight - sheight) / 2;
	            
                window.open("/ezBoard/modifyThumbnailItem.do?movieID=" + encodeURI(document.getElementById("mainVideo").getAttribute("movieid")) + "&boardID=" + encodeURI(pBoardID) + "&itemID=" + encodeURI(pItemID) + "&page=" + pPage + "&guBun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft, "");
			}
            
            function btn_ThumbnailDelete() {
            	
            	if (addThumbnail == "Y") {
            		if (confirm("<spring:message code='ezBoard.thumbnail.kwc009'/>")) {
            			var thumbnail = makeThumbnail("mainVideo");
            			var fd2 = new FormData();
            			var xhr2 = new XMLHttpRequest();
            			addThumbnail = "N";
            			fd2.append("thumbnail", thumbnail);
            			var thumbnailID = moviePath.split("/")[7];

        	            xhr2.open("POST", "/ezBoard/boardMovieThumb.do?thumbnailID=" + encodeURIComponent(thumbnailID) + "&fileLimit=" + AttachLimit + "&addThumbnail=" + addThumbnail, false);
        	            xhr2.send(fd2);
        	            
        	            var thumbnailResult = getNodeText(SelectNodes(loadXMLString(xhr2.responseText), "ROOT/NODES/NODE/THUMBNAILNAME")[0]);
        	            var thumbnailExt = thumbnailResult.substring(thumbnailResult.lastIndexOf(".") + 1);
        	            thumbnailPath = "tempUploadFile/" + thumbnailResult;
        	            var imageName = document.getElementById("mainVideo").title;
        	            
        	            var strXML = "";
                        strXML = "<DATA>";
                        strXML += "<NODE>";
                        strXML += "<IMAGEID>" + movieID + "</IMAGEID>"; // 기존 IMAGEID(movieID)를 조건으로 걸어 PHOTO테이블 업데이트
                        strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
                        if (thumbnailPath == undefined) {
                            strXML += "<FILEPATH></FILEPATH>";
                        }
                        else {
        					strXML += "<FILEPATH><![CDATA[" + thumbnailPath + "]]></FILEPATH>";
                        }
                        strXML += "<CONTENT></CONTENT>";
                        strXML += "<MAINFG>Y</MAINFG>";
                        strXML += "<ITEMID>" + pItemID + "</ITEMID>";
                        strXML += "<OFILENAME>" + imageName + "</OFILENAME>";
                        strXML += "<EXT>" + thumbnailExt + "</EXT>";
                        strXML += "<ADDTHUMBNAIL>" + addThumbnail + "</ADDTHUMBNAIL>";
                        strXML += "</NODE>";
                        strXML += "</DATA>";
                        
                        var xmlhttp = createXMLHttpRequest();
                        var xmldom = createXmlDom();

                        xmldom.async = false;
                        xmldom.preserveWhiteSpace = true;
                        xmldom = loadXMLString(strXML);
                        
                        xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=Mod&gubun=" + gubun + "&modifyThumb=Y", false);
                        xmlhttp.send(xmldom);

                        if (xmlhttp.responseText == "OK") {
                            alert("<spring:message code='ezBoard.thumbnail.kwc006'/>" + "\n" + "<spring:message code='ezBoard.thumbnail.kwc007'/>");
                            
                            window.opener.getBoardList();
                        }
                        else {
                            alert("<spring:message code='ezBoard.thumbnail.kwc005'/>");
                        }
            		}
            	} else {
            		alert("<spring:message code='ezBoard.thumbnail.kwc010'/>");
            	}
            }
            
            function makeThumbnail(videoID) {
			    var canvas = document.createElement("CANVAS");
			    var video = document.getElementById(videoID);
			 	// 썸네일 이미지의 크기는 200px * 160px
			 	canvas.width = 200;
			 	canvas.height = 160;
			    canvas.getContext("2d").drawImage(video, 0, 0, 200, 160);
			    
			 	return canvas.toDataURL();
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

			function copyURL() {
				var url = window.frames.location.href;

				var urlArea = document.createElement("textarea");
				urlArea.value = url;
				document.body.appendChild(urlArea);
				urlArea.select();

				try {
					var success = document.execCommand("copy");
					if (success) {
						alert("<spring:message code='ezBoard.t355' />");
					} else {
						console.log("copyURL error : " + e);
					}
				} catch (e) {
					console.log("copyURL error : " + e);
				}

				document.body.removeChild(urlArea);
			}

			// 주소복사 후 복사된 URL로 주소창에 붙여넣기하여 게시글을 조회할 경우 버튼 정상동작하지 않아 숨김처리
			document.addEventListener("DOMContentLoaded", function () {
				if (!window.opener) {
					var closeBtn = document.getElementById("close");
					if (closeBtn) {
						closeBtn.style.display = "none";
					}
				}
			});
		</script>
	</head>
	<body id="bodyPopup" class="popup">
		<table class="layout" style="border-spacing:0; border-bottom:1px solid #ddd; border:0px; width:100%; min-width:745px;">
		  <tr>
		    <td style="height:20px; vertical-align:top">
		      <div id="menu">
		        <ul>
					<c:if test="${guestReadFG ne 'Y'}">
		        	<c:choose>
		        		<%-- 2018-06-20 홍승비 - 승인/반려 버튼만 활성화, 작성자는 수정/삭제 가능 --%>
		        		<c:when test="${apprFlag == 'N'}">
			                <li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005'/></span></li>
			                <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014'/></span></li>
			                	<c:if test="${boardItem.writerID == userInfo.id}">
				                	<li ID='btn_Modify' ><span  onclick="btn_movieMod()"><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t316'/></span></li>
				                	<li ID='btn_Thumbnaildelete' ><span  onclick="btn_ThumbnailDelete()"><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t113'/></span></li>
				               		<li ID='btn_ThumbnailModify' ><span  onclick="btn_ThumbnailModify()"><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t316'/></span></li>
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
			                    <li ID='btn_Modify' ><span  onclick="btn_movieMod()"><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t316'/></span></li>
			                    <li ID='btn_Thumbnaildelete' ><span  onclick="btn_ThumbnailDelete()"><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t113'/></span></li>
				                <li ID='btn_ThumbnailModify' ><span  onclick="btn_ThumbnailModify()"><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t316'/></span></li>
			                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t1004'/></span></li>
			                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t1005'/></span></li>
			                    <c:if test="${boardItem.itemLevel == 1 && (boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK')}"><%-- 답변글은 재게시 버튼 안뜨도록 함 --%>
                                    <li ID='btn_Repost'><span onclick='btn_Repost_Onclick()'><spring:message code='ezBoard.lhr04'/></span></li>
                                </c:if>
		        			</c:if>
		                    <li ID='btn_Read' ><span  onclick="ReaderList()"><spring:message code='ezBoard.t1006'/></span></li>
		                    <li ID='btn_down' ><a id="movieDownload"><span><spring:message code='ezQuestion.t180'/><spring:message code='ezQuestion.t567'/></span></a></li>
		        		</c:otherwise>
		        	</c:choose>
					<c:if test="${boardInfo.urlCopyFlag != 'N'}">
						<li id ="urlCopyBtn"><span onclick="copyURL()"><spring:message code = "ezBoard.lyj02" /></span></li>
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
							<c:when test="${MyBoardScrapFlag eq 'TYPE2' && not empty scrapContID}">
							</c:when>
							<c:otherwise>
                                <li id ="addScrapBtn"><span onclick="addScrap()"><spring:message code='ezBoard.kmh13'/></span></li>	
							</c:otherwise>
						</c:choose>
					</c:if>
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
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="User_WriteDate">${boardItem.writeDate} </td>
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
		                <th><spring:message code='ezQuestion.t180'/><spring:message code='ezCommunity.t18'/></th>
		                <td id="cimagecontent" colspan="3" style="padding-right:0px">
		                    <div id="Div2" style="OVERFLOW-Y: auto; overflow-x:hidden; height:55px;WIDTH: 100%; padding-top:5px;padding-bottom:5px; vertical-align:middle; white-space:pre-wrap; word-break:break-word;"><c:out value="${boardItem.mainContent}"/></div>
		                </td>
		            </tr>
		          </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="width:100%;  text-align:center; padding-top:10px;" >
		        <table style="width:100%; border:1px solid #ddd; min-height:450px;">
		        <tr class="movieTR" style="display:table-cell;">
		            <td style="display:inline-block;">
		                <table id="movieTable">
		                    <tr>  
		                        <td>
		                            <video id="mainVideo" style="width: 640px; height: 360px;" src="" controls />            
		                        </td>
		                    </tr>
		           	    </table>
		            </td>
		        </tr>
				<%-- 2019-04-05 홍승비 - 본문 하단에 좋아요 버튼 추가 --%>
				<%-- 2023-04-06 기민혁 - 싫어요 버튼 추가 --%>
				<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y' || boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
					<tr>
						<td style="text-align:center; padding-bottom:8px;" colspan="3">
					  		<div style="display: flex; justify-content: center;">
								<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y'}">
									<div id="likeDiv" style="text-align:center; padding:5px 0px 7px 0px; margin-right: 5px">	
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
        <c:if test="${oneLineReplyFlag == '2' && guestReadFG ne 'Y'}">
        	<div style='height:auto;'>
				<table class="mainlist emoticonLayerStaticPosition" style="width:100%; min-width:745px; margin-top:8px;" >
					<tr>
						<th style="text-align:center; width: 10%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
                            <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                            <div class="emoticonRelative">								    
                                <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                            </div>
						</th>
						<th style="text-align:center; width: 88%; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
						    <textarea id="onelinereply" rows="3" style = "resize:none; width:90%;" maxlength="500"></textarea>
						</th>
						<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;width:15%;">
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
