<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
	    <style type="text/css">
	    	.list {
	    		font-size:12px;
				text-decoration: none;
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
			#txtContent h1, #txtContent h2 , #txtContent h3 , #txtContent h4 , #txtContent h5 , #txtContent h6 {
				margin-left:0px;
				margin-right:0px;
				color:#000000;
			}
			#txtContent h1 {font-size:2em; margin-top:0.67em; margin-bottom:0.67em;}
			#txtContent h2  {font-size:1.5em; margin-top:0.83em; margin-bottom:0.83em;}
			#txtContent h3 {font-size:1.17em; margin-top:1em; margin-bottom:1em;}
			#txtContent h4 {font-size:1em; margin-top:1.33em; margin-bottom:1.33em;}
			#txtContent h5 {font-size:0.83em; margin-top:1.67em; margin-bottom:1.67em;}
			#txtContent h6 {font-size:0.67em; margin-top:2.33em; margin-bottom:2.33em;}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script  type="text/javascript">
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        var MozNowZoom = 1;
	        var MozMaxZoom = 2;
	        var MozMinZoom = 0.8;
	
	        var strLang1 = "<spring:message code='ezBoard.t10025'/>";
	        var strLang2 = "<spring:message code='ezBoard.t10023'/>";
	        var strLang3 = "<spring:message code='ezBoard.t10024'/>";
	        
	        var OneLineReplyFlag = "${OneLineReplyFlag}";
			var isLikeChecked = "<c:out value='${isLikeChecked}'/>";
			var likeFlag = "<c:out value='${boardInfo.likeFlag}'/>";
			var likeCount = "<c:out value='${likeCount}'/>";
			var isDisLikeChecked = "<c:out value='${isDisLikeChecked}'/>";
			var disLikeFlag = "<c:out value='${boardInfo.disLikeFlag}'/>";
			var disLikeCount = "<c:out value='${disLikeCount}'/>";
	        var gubun = "${gubun}";
			var pItemID = "<c:out value='${itemID}'/>";
	        var pBoardID = "${boardID}";
	        var userInfoID = "${userInfoID}";
		    var Access_FG = "${boardInfo.access_FG}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var ListView_FG = "${boardInfo.listView_FG}";
		    var Read_FG = "${boardInfo.read_FG}";
		    var Write_FG = "${boardInfo.write_FG}";
		    var Reply_FG = "${boardInfo.reply_FG}";
		    var Delete_FG = "${boardInfo.delete_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var rsa = new RSAKey(); // 댓글기능 비밀번호 관련
		    var checkpassword_dialogArguments = new Array(); // 익명게시물 댓글삭제 시 레이어팝업 관련
		    var scrollValue = 0;
		 	// 2023-05-25 조수빈 - 게시판 첨부파일 미리보기 사용 여부
	        var useBoardFilePrvw = "<c:out value='${useBoardFilePrvw}'/>";
			var reactFlag = "<c:out value='${boardInfo.reactFlag}'/>"; // 2023-07-28 임정은 - 게시판 댓글 좋아요 기능 사용여부
            var starRatingFlag = "<c:out value='${boardInfo.starRatingFlag}'/>"; // 별점 평가하기 기능 사용여부
			var rating = "${itemStarRating.rating}"; // 별점 평가하기 기능 > 별점
			
			/* 2023-04-12 이가은 - 답글 기능을 위한 변수 추가 */
	        var userInfoName = "${displayName}";
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
			
			var useEditor = "<c:out value='${useEditor}'/>";
			var strContentLocation = "<c:out value='${itemLocation}'/>";
						    
            var attachmentFlag = "${boardInfo.attachmentFlag}"; // 게시판 첨부파일 사용여부
            var attachLimit = "${boardInfo.attachSizeLimit}"; // 개별 첨부파일 limit
            var attachFileNameMaxLength = Number("${attachFileNameMaxLength}"); // 첨부파일명 글자수 제한 limit
            var totalFileSize = 0; // 현재 총 첨부파일 사이즈

	        window.onload = function () {
	            document.getElementById("txtContent").style.textAlign = "center";
	            
	            if (useEditor != "HWP") {
	            	window.parent.previewItemSet();
	            }
	            
	            makeEmoticonPanel();
	            
            	/* 2019-11-06 홍승비 - 본문 하단에 댓글영역 표출 */
	            if (OneLineReplyFlag == "2") {
	            	getBoardComment();
	            }
	        };
	        
	        /* 2019-11-07 홍승비 - 댓글삭제 레이어팝업 스크롤 위치 관련 */
	        $(window).scroll(function () {
				scrollValue = $(document).scrollTop();
	        });
			
	        //보기설정 레이어팝업 바깥 클릭시 close되게 하기위한 코드 2018.03.05 강민수92
	        $(document).ready(function() {
	        	var maillistoption = parent.document.getElementById('maillistoptiondiv');
	        	
	        	$(document).mouseup(function(e) {
	        		var container = $('#layer_Viewpopup');
	        		var maillistoptionmode = $(maillistoption).attr('mode');
	        		if (maillistoptionmode == "on") {
	        			if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
	        			    parent.document.getElementById("layer_Viewpopup").style.display = "none";
	        			    parent.document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
	        			    parent.document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif"); 
	        			}
	        		}
	        	})
	        	
	        	rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
	        });
	        
	        function Bigger() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom < MozMaxZoom) {
	                    MozNowZoom += 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("divContent").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom < maxZoom) {
	                    nowZoom += 10;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.zoom = nowZoom + "%";
	            }
	        }
	
	        function Smaller() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom > MozMinZoom) {
	                    MozNowZoom -= 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("divContent").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom > minZoom) {
	                    nowZoom -= 10;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.zoom = nowZoom + "%";
	            }
	        }
	
	        function makeWriteContent(responseText, AttachText) {
	            try {
	                nowZoom = 100;
	                maxZoom = 200;
	                minZoom = 80;
	                MozNowZoom = 1;
	                MozMaxZoom = 2;
	                MozMinZoom = 0.8;
	
	                document.getElementById("txtContent").style.textAlign = "";
	                document.getElementById("txtContent").innerHTML = "";
	                var _img1;
	                var _img2;
	                
	                var xmldom = loadXMLString(AttachText);
	                var _attchDIV;
	                if (SelectNodes(xmldom, "NODES/NODE").length > 0) {
	                    var AttchHTML = SetAttachmentInfo(xmldom);
	                    _attchDIV = document.createElement("DIV");
	                    _attchDIV.id = "attchdivContent";
	                    _attchDIV.innerHTML = AttchHTML;
	                    document.getElementById("txtContent").appendChild(_attchDIV);
	                }
	
	                _img1 = document.createElement("IMG");
	                _img1.id = "smallImg";
	                //_img1.setAttribute("onclick", "Smaller()");
	                _img1.onclick = function () { Smaller(); };
	
	                _img1.style.cursor = "pointer";
	                _img1.style.margin = "5px 4px 5px 0px";
	                _img1.src = "/images/minus.png";
	
	                _img2 = document.createElement("IMG");
	                _img2.id = "biglImg";
	                //_img2.setAttribute("onclick", "Bigger()");
	                _img2.onclick = function () { Bigger(); };
	                
	                
	                _img2.style.cursor = "pointer";
	                _img2.style.margin = "5px";
	                _img2.style.marginLeft = "-4px";
	                _img2.src = "/images/plus.png";
	
	                document.getElementById("txtContent").appendChild(_img1);
	                document.getElementById("txtContent").appendChild(_img2);
	
	                var _div = document.createElement("DIV");
	                _div.id = "divContent";
	                _div.innerHTML = responseText;
	                document.getElementById("txtContent").appendChild(_div);
	                
	            } catch (e) {}
	        }
	
	        function SetAttachmentInfo(responseText) {
	            var xmldom = responseText;
	            var i = 0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";
	            var filepathTemp = "";
	            var strAttach = "";
	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	            var regData = GetbrowserLanguage();
	            
	            /* 2019-05-02 홍승비 - 게시물 미리보기 첨부파일영역 폰트 수정 */
	            // strAttach += "<div class='attachedfile' id='ifrmPreViewRayer' style='margin:-13px; margin-bottom:10px; margin-top:-8px;'>";
	             /* 2019-11-07 게시물 미리보기단에 default_...css 적용 후 마진 수정 */
	            strAttach += "<div class='attachedfile' id='ifrmPreViewRayer' style='margin:-13px; margin-bottom:10px; margin-top:0px;'>";
	
	            var totalSize = 0;
	            for (var j = 0; j < xmldomNodes.length; j++) {
	                totalSize += parseInt(getNodeText(SelectSingleNode(xmldomNodes[j], "FileSize2")));
	            }
	
	            var strSize = "";
	            strAttach += "<ul class='attachedfile_title'><li class='titleText'><span class='titleT'>" + strLang1+ "<span class='cblue'> " + xmldomNodes.length + "</span> (" + File_Size(totalSize) + ")</span><span class='attach_btn_up' id='BtnAttachDetail' onclick='AttachDetail_view(this);'></span>";
	            strAttach += "<li class='titleSave' onclick='AttachAllDownload();'><span>" + strLang3 + "</span></li></ul>"; 
	            strAttach += "<ul class='attachedfile_list' id='PreviewAttachList'>";
	
				/* 2018-07-16 홍승비 - 게시물 미리보기 시 첨부파일 특수문자 처리 */
	            for (i = 0; i < xmldomNodes.length; i++) {
	            	filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	            	filepathHTMLEscape = MakeXMLString(getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath")));
	            	/* 2020-01-31 홍승비 - filePath가 아닌 fileName으로 파일명을 가져오도록 수정 */
	            	filename = MakeXMLString(getNodeText(SelectSingleNode(xmldomNodes[i], "FileName")));
	            	filenameAttr = MakeXMLString(filepath.substr(filepath.lastIndexOf("/"), filepath.length));
	                filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
	
	                var strTarget = "target=''";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
	                    strTarget = "target=''";
	                }
	                
	                strAttach += "<li style='display:inline-block;'>";
	                strAttach += "<span id='MailAttachDownloadItems' name='MailAttachDownloadItems' onclick=\"DownloadFile('/ezBoard/getBoardAttachInfo.do?type=BOARD&itemID=" + encodeURIComponent(getNodeText(SelectSingleNode(xmldomNodes[i], "ItemID"))) + "&attID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "GUID")) + "')\"><img style='cursor:pointer;vertical-align:middle' src='/images/icon_adddownload.gif' width='16' height='16' /></span>";
	                strAttach += "&nbsp;";
	                strAttach += "<span onmouseover=\"this.style.color='#164aad'\" onmouseout=\"this.style.color='#666'\" style='cursor: pointer; color: rgb(102, 102, 102);'>";
         
	                /* 2018-10-11 홍승비 - 모두저장용 filePath 속성 추가 */
	                strAttach += "<a name='filename' href='/ezBoard/getBoardAttachInfo.do?type=BOARD&itemID=" + encodeURIComponent(getNodeText(SelectSingleNode(xmldomNodes[i], "ItemID"))) + "&attID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "GUID"))
	                + "' filePath='" + filepathHTMLEscape + "' fileNameAttr='" + filenameAttr + "' realFileName='" + filename + "'>" + filename + " (" + filesize + ")</a>";	                
	              	strAttach += "</span>";
	             	// 2023-05-23 조수빈 - 게시판 첨부파일 미리보기 아이콘 추가
		            if (typeof useBoardFilePrvw !== 'undefined' && useBoardFilePrvw == "1") {
			        	strAttach += "<span class='icon_rbtn2' style='margin-left : 10px;' title='<spring:message code = 'ezEmail.t487'/>' onclick=\"attachFile_Preview('" + javaURLEncode(filepath) + "', '" + javaURLEncode(filename) + "');\"><img src='/images/icon_preview.png' width='16' height='16' style='vertical-align:middle; cursor:pointer;'></span>";
		            }
	                strAttach += "</li><br>";
	            }
	            strAttach += "</ul></div>";
	            return strAttach;
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

	        function File_Size(totalSize) {
	            var strSize = "";
	            if (totalSize > 1024 * 1024) {
	                totalSize = parseInt(totalSize / 1024 / 1024);
	                strSize = totalSize + "MB";
	            }
	            else if (totalSize > 1024) {
	                totalSize = parseInt(totalSize / 1024);
	                strSize = totalSize + "KB";
	            }
	            else
	                strSize = parseInt(totalSize) + "B";
	
	            return strSize;
	        }
	
	        function DownloadFile(href)
	        {
	            location.href = href;
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function AttachDetail_view(obj) {
	            if (obj.className == "attach_btn_down") {
	                obj.className = "attach_btn_up";
	                document.getElementById("PreviewAttachList").style.display = "";
	            }
	            else {
	                obj.className = "attach_btn_down";
	                document.getElementById("PreviewAttachList").style.display = "none";
	            }
	        }
	
	        /* 2018-10-11 홍승비 - 모두저장 시 zip 파일로 다운받도록 수정 */
	        function AttachAllDownload(attachObj) {
	            var allobj = document.getElementsByName("filename");
	            var filePath = ""; // 전체파일경로
	            var filePathTemp = "";
				var fileNames = ""; // 파일이름
				var fileNamesUID = ""; // 파일이름(UID 포함)
				
				filePath = GetAttribute(allobj[0], "filepath");
				filePath = filePath.substr(0, filePath.lastIndexOf("/") + 1);
				
				for (var i = 0; i < allobj.length; i++) {
					filePathTemp = GetAttribute(allobj[i], "filepath");
					fileNames += MakeXMLString(GetAttribute(allobj[i], "realFileName")) + ":";
					fileNamesUID += MakeXMLString(GetAttribute(allobj[i], "fileNameAttr")) + ":";
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
	            	            
	       //     downloadAll(allobj);
	        }
	
	        var suffix = 0;
	        function downloadAll(allobj) {
	            if (allobj[suffix]) {
	                location.href = GetAttribute(allobj[suffix], "href");
	                suffix++;
	                setTimeout(function () { downloadAll(allobj) }, 1000);
	            }
	            else
	                suffix = 0;
	        }
	        
	        /* 2019-04-08 홍승비 - 좋아요 버튼 클릭 동작 */
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
		  	 
		    /* 2019-04-08 홍승비 - 좋아요 버튼 이미지 및 좋아요 갯수 업데이트 */
		    function updateLikeCountImg(isLikeChecked) {
		    	if(parent.isOpenWindow == undefined){
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
					});	
		    	}else if(parent.isOpenWindow != undefined){
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
							try {parent.refreshLikeAndDisLikeOpen(result,isLikeChecked,"like");}catch (e) {}

						}
					});		    		
		    	}
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
						try {parent.refreshLikeAndDisLikeOpen(result,isDisLikeChecked,"disLike");}catch (e) {}

					}
				});
			}
		    
		    /* 2023-04-06 기민혁 - itemview 에서  좋아요/싫어요 버튼 클릭시  이미지 및  개수 업데이트 */
		    function refreshLikeAndDisLike(result,checked,gubun){
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
		    
		    function Editor_Preview_Complete() {
		    	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(strContentLocation);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
		    }
		    
		    function FieldsAvailable(isTrue) {
	        	if (isTrue) {
	        		message.GetTextFile("HTML", "", function(data) {
	        			parent.event_downContent(data, parent.xmlhttp2.responseText);
	        		});
	        	}
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
	    </script>
	</head>
	<body>
		<div id="txtContent" name="txtContent" style="height:100%;margin-left:5px;margin-right:5px;">
			<span style="margin-top:50px;height:10px;display:inline-block;"></span>
		</div>
		
		<%-- 2019-04-05 홍승비 - 본문 하단, 첨부파일/한줄댓글 상단에 좋아요 버튼 추가 --%>
		<%-- 2023-04-06 기민혁 - 싫어요 버튼 추가  --%>
		<div style="display: flex; justify-content: center;">
			<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y'}">
				<div id="likeDiv" style="text-align:center; padding:5px 0px 7px 0px; margin-right: 5px">
			  		<span class="likeButton" onclick="clickLikeButton()" title="<spring:message code='ezBoard.hsb10'/>" style="height:20px">
				  		<c:choose>
				  			<c:when test="${isLikeChecked == 'Y'}">
				  				<img id="likeButtonImg" src="/images/like_on.png" style="vertical-align:text-top;"/>
				  			</c:when>
				  			<c:otherwise>
				  				<img id="likeButtonImg" src="/images/like_off.png" style="vertical-align:text-top;"/>
				  			</c:otherwise>
				  		</c:choose>
				  	<span id="likeCountSpan" style="vertical-align:top;"><c:if test="${likeCount > 0}"> (<c:out value="${likeCount}"/>)</c:if></span>
			  		</span>
				</div>			
			</c:if>
		
		    <c:if test="${boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
				<div id="disLikeDiv" style="text-align:center; padding:5px 0px 7px 0px;">	
					<span class="disLikeButton" onclick="clickDisLikeButton()" title="<spring:message code='ezBoard.kmh07'/>" style="height:20px">
						<c:choose>
							<c:when test="${isDisLikeChecked == 'Y'}">
							  	<img id="disLikeButtonImg" src="/images/disLike_on.png" style="vertical-align:text-top;"/>
							</c:when>
							<c:otherwise>
							  	<img id="disLikeButtonImg" src="/images/disLike_off.png" style="vertical-align:text-top;"/>
							</c:otherwise>
						</c:choose>
					<span id="disLikeCountSpan" style="vertical-align:top;"><c:if test="${disLikeCount > 0}"> (<c:out value="${disLikeCount}"/>)</c:if></span>
					</span>
				</div>
            </div>
            </c:if>
            	
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
                        <input type="radio" name="reviewStar" value="${i}" id="rate${i}" <c:if test="${itemStarRating.rating == i}"> checked </c:if> />
                        <img draggable="false" src="/images/ImgIcon/${srcIconFlag ? 'icon-flag.gif' : 'view-flag.gif'}"/>
                    </label>
                    </c:forEach>
                    </span>
                    <a class="imgbtn"><span onclick="clickSaveRatingButton()"><spring:message code='ezBoard.lhr001'/></span></a>
                </div>
            </c:if>
			
		<%-- 2019-11-06 홍승비 - 하단댓글 영역 추가 --%>
        <c:if test="${OneLineReplyFlag == '2'}">
        	<div style='height:auto; padding-bottom: 15px;'>
				<table class="mainlist emoticonLayerStaticPosition" style="width:100%">
					<c:choose>
						<c:when test="${gubun == 2}">
								<th colspan="2" style="text-align:center; width: 100%; border-left:1px solid #e2e2e2; border-right:1px solid #e2e2e2;
										 border-top:1px solid #e2e2e2; border-bottom:1px solid #f8f8fa; padding-bottom:3px">
								    <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
								    <div class="emoticonRelative">                                       
                                        <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                        <textarea id="onelinereply" rows="3" style = "resize:none; width:calc(100% - 45px);" maxlength="500"></textarea>
									</div>
								</th>
						</c:when>
						<c:otherwise>
								<th style="text-align:center; width: 85%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
								    <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
								    <div class="emoticonRelative">								    
                                        <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                        <textarea id="onelinereply" rows="3" style = "resize:none; width: 90%" maxlength="500"></textarea>
								    </div>
								</th>
						</c:otherwise>	
					</c:choose>
					<c:choose>
						<c:when test="${gubun == 2}">
							</tr>
						</c:when>
						<c:otherwise>
								<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2; width:15%;">
									<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
									    <a class='imgbtn' style="vertical-align: middle"><span onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span></a><br/>
									</c:if>
									<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></span></a>
								</th>
							</tr>
						</c:otherwise>
					</c:choose>
					</tr>
					<c:if test="${gubun == 2}">
						<tr>
							<th colspan="2" style="width: 85%; border-left:1px solid #e2e2e2; border-top:1px solid #f8f8fa; border-right:1px solid #e2e2e2; text-align:right;
									border-bottom:1px solid #e2e2e2; padding-top:0px; padding-bottom:4px; vertical-align: middle">
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
		<%-- 2018-10-11 - 홍승비 - 모두저장 기능 추가 --%>
		<c:if test="${useEditor eq 'HWP'}">
			<iframe id="message" class="viewbox"  src="/ezBoard/WHWPEditor.do?type=preview" name="message" frameborder="0" style="padding:0; overflow:auto; display:none;"></iframe>
		</c:if>
		<iframe name="AttachDownFrame" id="AttachDownFrame" style="display:none"></iframe>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    
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
	</body>
</html>
