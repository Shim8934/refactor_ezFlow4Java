<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
	    <style type="text/css">
	    	.list {
	    		font-size:12px;
				text-decoration: none;
	    	}
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
	        var gubun = "${gubun}";
	        var pItemID = "${itemID}";
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
	        
	        window.onload = function () {
	            document.getElementById("txtContent").style.textAlign = "center";
	            window.parent.previewItemSet();
	            
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
	            strAttach += "<div class='attachedfile' id='ifrmPreViewRayer' style='margin:-13px; margin-bottom:10px; margin-top:-8px;'>";
	
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
	            	filename = MakeXMLString(filepath.substr(120, filepath.length - 119));
	            	filenameAttr = MakeXMLString(filepath.substr(filepath.lastIndexOf("/"), filepath.length));
// 	                filename = filepath.substr(filepath.indexOf("}_") + 2);
// 	                filename = ReplaceText(filename, "%2b", "+");
// 	                filename = ReplaceText(filename, "%3b", ";");
// 	                filename = ReplaceText(filename, "%7e", "~");
// 	                filename = ReplaceText(filename, "%3d", "=");
	               // filepath = "/upload_board/" + filepath;
	                filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
	
	                var strTarget = "target=''";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
	                    strTarget = "target=''";
	                }
	                
	                strAttach += "<li>";
	                strAttach += "<span id='MailAttachDownloadItems' name='MailAttachDownloadItems' onclick=\"DownloadFile('/ezBoard/getBoardAttachInfo.do?type=BOARD&itemID=" + encodeURIComponent(getNodeText(SelectSingleNode(xmldomNodes[i], "ItemID"))) + "&attID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "GUID")) + "')\"><img style='cursor:pointer;vertical-align:middle' src='/images/icon_adddownload.gif' width='16' height='16' /></span>";
	                strAttach += "&nbsp;";
	                strAttach += "<span onmouseover=\"this.style.color='#164aad'\" onmouseout=\"this.style.color='#666'\" style='cursor: pointer; color: rgb(102, 102, 102);'>";
         
	                /* 2018-10-11 홍승비 - 모두저장용 filePath 속성 추가 */
	                strAttach += "<a name='filename' href='/ezBoard/getBoardAttachInfo.do?type=BOARD&itemID=" + encodeURIComponent(getNodeText(SelectSingleNode(xmldomNodes[i], "ItemID"))) + "&attID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "GUID")) + "' filePath='" + filepathHTMLEscape + "' fileNameAttr='" + filenameAttr + "'>" + filename + " (" + filesize + ")</a>";	                
	              	strAttach += "</span>";
	                strAttach += "</li>";
	            }
	            strAttach += "</ul></div>";
	            return strAttach;
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
					fileNames += MakeXMLString(filePathTemp.substr(120, filePathTemp.length - 119)) + ":";
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
	    </script>
	</head>
	<body>
		<div id="txtContent" name="txtContent" style="height:100%;margin-left:5px;margin-right:5px;">
			<span style="margin-top:50px;height:10px;display:inline-block;"></span>    
		</div>
		<%-- 2019-11-06 홍승비 - 하단댓글 영역 추가 --%>
        <c:if test="${OneLineReplyFlag == '2'}">
        	<div style='height:auto; padding-bottom: 15px;'>
				<table class="mainlist" style="width:100%" >
					<c:choose>
						<c:when test="${gubun == 2}">
							<tr>
								<th colspan="2" style="text-align:center; width: 90%; border-left:1px solid #e2e2e2; border-right:1px solid #e2e2e2;
										 border-top:1px solid #e2e2e2; border-bottom:1px solid #f8f8fa; padding-bottom:3px">
									<textarea id="onelinereply" rows="3" style = "resize:none; width:98%" maxlength="600"></textarea>
								</th>
						</c:when>
						<c:otherwise>
							<tr>
								<th style="text-align:center; width: 90%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
									<textarea id="onelinereply" rows="3" style = "resize:none; width:98%" maxlength="600"></textarea>
								</th>
						</c:otherwise>	
					</c:choose>
					<c:choose>
						<c:when test="${gubun == 2}">
							</tr>
						</c:when>
						<c:otherwise>
								<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
									<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply()"><spring:message code='ezBoard.t321' /></span></a>
								</th>
							</tr>
						</c:otherwise>
					</c:choose>
					</tr>
					<c:if test="${gubun == 2}">
						<tr>
							<th colspan="2" style="width: 90%; border-left:1px solid #e2e2e2; border-top:1px solid #f8f8fa; border-right:1px solid #e2e2e2; text-align:right;
									border-bottom:1px solid #e2e2e2; padding-top:0px; padding-bottom:4px; vertical-align: middle">
								<span style = "font-weight:normal; display:inline-block; margin-top:2px"><spring:message code='ezBoard.t438' />&nbsp;</span>
								<span><input type="password" id="txtPassWord" maxlength="20" size="20" />&nbsp;</span>
								<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply()"><spring:message code='ezBoard.t321' /></span></a>
							</th>
						</tr>
					</c:if>
				</table>
				<table id="commentList" style="width:100%;margin-top:10px;table-layout: fixed; overflow:auto;border:1px solid rgb(225,225,225)"></table>
			</div>
        </c:if>
        <%-- 본문하단 댓글영역 끝 --%>
		<%-- 2018-10-11 - 홍승비 - 모두저장 기능 추가 --%>
		<iframe name="AttachDownFrame" id="AttachDownFrame" style="display:none"></iframe>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    
		<%-- 2019-11-07 홍승비 - 익명게시물 댓글삭제 시 비밀번호 확인을 위한 레이어팝업 추가 --%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel2">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer2"></iframe>
	    </div>
	</body>
</html>