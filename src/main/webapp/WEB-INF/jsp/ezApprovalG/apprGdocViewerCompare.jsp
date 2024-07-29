<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
	    <script type="text/javascript">
	        var pDocHrefBefore = "${docHrefBefore}"; // 편집 전 문서
	        var pDocHrefAfter = "${docHrefAfter}"; // 편집 후 문서
	        var PrtBodyContent = ""; // 인쇄용 변수
	        var isBeforeDocLoaded = false;
	        var isAfterDocLoaded = false;
	        var isPrintDocLoaded = false;
	        
	        /* 2020-03-03 홍승비 - 결재문서이력의 중복 로드 방지 플래그 추가 */
	        function DocumentComplete() {
				if (pDocHrefBefore != "" && pDocHrefAfter != "") {
					if (isBeforeDocLoaded == false) {
	             		message.Set_EditorContentURL(pDocHrefBefore);
	             		isBeforeDocLoaded = true;
					}
					if (isAfterDocLoaded == false) {
	             		message2.Set_EditorContentURL_Compare(pDocHrefAfter, pDocHrefBefore);
	             		isAfterDocLoaded = true;
					}
					if (isPrintDocLoaded == false) { // 인쇄용 편집 후 문서 (취소선, 하이라이트 없음)
	             		message3.Set_EditorContentURL(pDocHrefAfter);
	             		isPrintDocLoaded = true;
					}
            	}
	        }
	        
	        // 문서비교 화면 상에서 사용하지 않는 undefined 함수 호출 제거
	        function FieldsAvailable() {}
	        
	        function btnPrint_onclick() {
	            var pDocHref = "";
	            var printMode = "";
	            
	            if (document.getElementById("messageTD").style.display == "" && document.getElementById("message2TD").style.display == "none") {
	            	pDocHref = pDocHrefBefore; // 편집 전 문서
	            	printMode = "BEFORE";
	            } else if (document.getElementById("messageTD").style.display == "none" && document.getElementById("message2TD").style.display == "") {
	            	pDocHref = pDocHrefAfter; // 편집 후 문서
	            	printMode = "AFTER";
	            }
	            
	            PrintClick(pDocHref, printMode);
	        }
	        
	        /* 2020-02-26 홍승비 - 원본/현재보기 시에 맞게 인쇄되도록 함수 추가 */
	        function PrintClick(pDocHref, mode) {
	        	
	            if (mode == "BEFORE") {
	            	PrtBodyContent = message.Get_EditorBodyHTML();
	            } else if (mode == "AFTER") {
	            	PrtBodyContent = message3.Get_EditorBodyHTML(); // 인쇄용 편집 후 문서 (취소선, 하이라이트 없음)
	            }
	            
	            var feature = "width=800, height=500, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
	            feature = feature + GetOpenPosition(800, 500);
	            window.open("/ezApprovalG/ezApprovalPrint.do", "", feature);
	        }
	        
	        function btnClose_onclick() {
	            window.close();
	        }
	        
	        function btnSave_onclick() {
	            var pDocID = "", pDocTitle = "";
	            var pDocHref = "";
	            
	            if (document.getElementById("messageTD").style.display == "" && document.getElementById("message2TD").style.display == "none") {
	            	pDocHref = pDocHrefBefore;
	            } else if (document.getElementById("messageTD").style.display == "none" && document.getElementById("message2TD").style.display == "") {
	            	pDocHref = pDocHrefAfter;
	            }
	            
	            try {
	                var pPos1 = pDocHref.lastIndexOf("/");
	                pDocID = pDocHref.substring(pPos1 + 1).split("-")[0];
	                
	                /* 2021-10-21 홍승비 - 문서 저장 시 원본문서, 현재문서 제목 구분하도록 수정 */
	                if (pDocHref == pDocHrefBefore) {
	                	pDocTitle = getNodeText(message.document.getElementById("doctitle")).trim();
	                } else {
	                	pDocTitle = getNodeText(message2.document.getElementById("doctitle")).trim();
	                }

					<%-- 2025-05-28 양지혜 - 게시판 > 버전관리 > 문서비교 시 본문에 제목없어 발생하는 오류 수정 --%>
					if (pDocTitle == "" && -1 != pDocHref.lastIndexOf("upload_board")) {
						pDocTitle = getBoardTitle(pDocHref);
					}
	            } catch (e) {
	                pDocTitle = "No Title";
	                pDocID = "No DocID";
	            }
	            var rtnVal = SavePCFile(pDocID, pDocTitle, pDocHref);

	            //activeX 일단 제외
	            if (window.ActiveXObject) {
	                rtnVal = rtnVal.replace("/Upload_Common/", "/myoffice/common/downloadattach.aspx?filepath=/Upload_Common/");
	                var filename = rtnVal.split("/")[rtnVal.split("/").length - 1];
	                rtnVal = rtnVal + "&filename=" + filename;
	                rtnVal = ReplaceText(rtnVal, filename, encodeURIComponent(filename));
	                AttachDownFrame.location.href = rtnVal;
	            } else {
	            	/*  2018-09-19 홍승비 - 기존  ezCommon/downloadAttach.do 사용하던 부분 수정 */
	                AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(rtnVal);
	            }
	        }
	
	        function SavePCFile(pDocID, pDocTitle, pDocHref) {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/savePCTmpFile.do",
		    		data : {
		    			docID     : pDocID,
		    			docTitle  : pDocTitle,
		    			docHref   : pDocHref
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
	
	            return result;
	        }
	        
	        function btnCompare_onclick() { // 문서비교
	        	document.getElementById("saveLI").style.display = "none";
	        	document.getElementById("printLI").style.display = "none";
	        	document.getElementById("messageTD").style.display = "";
	        	document.getElementById("message2TD").style.display = "";
	        }
	        
	        function btnShowBefore_onclick() { // 원문보기
	        	document.getElementById("saveLI").style.display = "";
	        	document.getElementById("printLI").style.display = "";
	        	document.getElementById("messageTD").style.display = "";
	        	document.getElementById("message2TD").style.display = "none";
	        }
	        
	        function btnShowAfter_onclick() { // 현재보기
	        	document.getElementById("saveLI").style.display = "";
	        	document.getElementById("printLI").style.display = "";
	        	document.getElementById("messageTD").style.display = "none";
	        	document.getElementById("message2TD").style.display = "";
	        }
			
			function getBoardTitle(itemHref) {
				var title = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getBoardTitle.do",
					data : {
						href : itemHref
					},
					success: function(text){
						title = text;
					}
				});
				
				return title;
			}
	        
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
							<li id="showCompareLI"><span onclick="btnCompare_onclick()"><spring:message code='ezApprovalG.hsbCo01'/></span></li>
							<li id="showBeforeLI"><span onclick="btnShowBefore_onclick()"><spring:message code='ezApprovalG.hsbCo02'/></span></li>
	                        <li id="showAfterLI"><span onclick="btnShowAfter_onclick()"><spring:message code='ezApprovalG.hsbCo03'/></span></li>
	                        <li id="saveLI" style="display:none;"><span onclick="btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="printLI" style="display:none;"><span class="icon16 popup_icon16_print" onclick="btnPrint_onclick()"></span> </li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td id="messageTD" style="padding-bottom: 10px;">
	                <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/aprDocViewContent.do" name="message" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            </td>
				 <td id="message2TD" style="padding-bottom: 10px;">
	                <iframe id="message2" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/aprDocViewContent.do" name="message2" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            </td>
				<td id="message3TD" style="padding-bottom: 10px; display:none;">
	                <iframe id="message3" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/aprDocViewContent.do" name="message3" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    </script>
	    <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	</body>
</html>