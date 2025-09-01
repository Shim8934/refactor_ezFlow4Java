<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t175' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
 		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<script type="text/javascript">
			window.offscreenBuffering = true;
		    var pItemID = "<c:out value = '${item.itemID}' />";
		    var pBoardID = "<c:out value = '${boardInfo.boardID}' />";
		    var strWriterID = "<c:out value = '${item.writerID}' />";
		    var strContentLocation = "<c:out value = '${item.contentLocation}' />";
		    var SSUserID = "<c:out value = '${userInfo.id}' />";
		    var BoardAdmin_FG = "<c:out value = '${boardInfo.boardAdmin_FG}' />";
		    var Write_FG = "<c:out value = '${boardInfo.write_FG}' />";
		    var Reply_FG = "<c:out value = '${boardInfo.reply_FG}' />";
		    var Delete_FG = "<c:out value = '${boardInfo.delete_FG}' />";
		    var BoardGroupAdmin_FG = "<c:out value = '${boardInfo.boardGroupAdmin_FG}' />";
		    var OneLineReplyFlag = "<c:out value = '${ oneLineReplyFlag }' />";
		    var gubun = "<c:out value = '${boardInfo.gubun }' />";
            var code = "<c:out value = '${code}' />";

		    window.onload = function () {
		    	var html = "";
		    	
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type	:	"COMMUNITYCONTENT",
							 href	:	strContentLocation,
							 itemID	:	pItemID
						   },
					success: function(result){
						var gImageUrlEncode = "${gImageUrl}";
						gImageUrlEncode = gImageUrlEncode.replace(/{/gi, "%7B").replace(/}/gi, "%7D");
						//2018-07-05 김보미 - 팝업창에 생기던 스크롤바 내용부분으로 스크롤바 생기게 변경
// 						html = result;
						html += "<div class='viewbox'><img src='" + gImageUrlEncode + "' border=0 width='${gWidth }' height ='${gHeight}' name=zb_target_resize>";
						html += result;
						html += "<div>";
					}        			
				});
				
				var doc = document.getElementById("message").contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
		        
				$("#message").contents().find("body").css("word-wrap", "break-word");
				
				//2018-07-05 김보미 - 창사이즈 조절(새로고침시에도 원래 사이즈로 돌아오게끔)
				if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
                    self.resizeTo(721, 750);
				} else  {
                    self.resizeTo(746, 780);
             	}
				
				/* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
				if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
					window.opener.parent.applyIsNewIconAll(); // 리스트, 팝업홈 메인에서 읽기창 접근
				}
		    }

		    function btn_Delete_Onclick() {
	            if ((Delete_FG != "true") || (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID)) {
	           		alert("<spring:message code = 'ezCommunity.t431' />");
	          		return;
	            }

	            if (!confirm("<spring:message code = 'ezCommunity.t426' />")) {
	            	return;
	            }

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + encodeURIComponent(pItemID) + ";", false);
	            xmlhttp.send();
	            xmlhttp = null;
	            
				// 게시물 보기창에서 삭제한 경우, 부모창의 카운트 새로고침 추가
				if (window.opener.location.href.indexOf("ezCommunity/boardItemListPhoto.do") > -1) {
					try {
						var cntDom = window.opener.parent.document.getElementById("itemcnt");
						var code = window.opener.parent.code;
						if (typeof(cntDom) != "undefined" && cntDom != null && typeof(code) != "undefined" && code != null) {
							reloadLeftCount(code, cntDom);
						}
					} catch(e) {}
				}
	            window.opener.refresh_onclick();
	            
	            /* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
				if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
					window.opener.parent.applyIsNewIconAll();
				}
	            
	            window.close();
	        }

	        function btn_Modify_Onclick() {
	            if ((Write_FG != "true") || (strWriterID != SSUserID && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK")) {
	                alert("<spring:message code = 'ezCommunity.t431' />");
	                return;
	            }

				window.location.href = "/ezCommunity/newBoardItemPhoto.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify";
	        }

	        function btnClose_onclick() {
	            window.close();
	        }

	        /* function ReaderList() {
	            var szHref = "/ezCommunity/itemReadList.do?boardID=" + pBoardID + "&itemID=" + pItemID;
	            var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";
	            var feature = "width=620, height=425, resizable=yes, scrollbars=0";
	            feature = feature + GetOpenPosition(620, 425);
	            window.open(szHref, "", feature);
	        } */
	        
	        var item_readlist_cross_dialogArguments = new Array();
	        
	        function ReaderList() {
	        	var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 620) / 2;
		        var top = (heigth - 425) / 2;		        
		        var szHref = "/ezCommunity/itemReadList.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID);
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

	        function OpenUserInfo(pUserID) {
	            var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
	        }
	        
		 	 // 강민수92
		    function btn_One_Line_Reply_Onclick() {
		    	openCommunityBoardComment();
	    		return;
		    }
		 	 
		    //2018-07-05 김보미 - 팝업창에 생기던 스크롤바 내용부분으로 스크롤바 생기게 변경(팝업창 사이즈 변경시에도)
		    window.onresize = function () {
	            var contentHeight = document.documentElement.clientHeight - 180;
	            document.getElementById("message").style.height = contentHeight + "PX";
	            document.getElementById("messagePad").style.height = contentHeight + "PX";
		    };
		    
			function addRelatedCabinet() {
				window.open("/ezCabinet/cabinetAddRelated.do?module=commu", "addRelated", getOpenWindowfeature(480, 505));
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
			
	        /* 2021-05-03 홍승비 - 게시물 리스트에서 게시물을 등록한 경우, 커뮤니티 팝업홈 좌측 전체 게시물 개수 갱신 */
	        function reloadLeftCount(pCode, pCntDom) {
            	$.ajax({
			    	type : "GET",
			    	url : "/ezCommunity/getCommunityBoardItemCnt.do",
			    	async : false,
			    	data : {
			    		code : pCode
			    	},
			    	success : function (result) {
			    		pCntDom.innerText = result;
			    	}
			    });
	        }
	        
		</script>	
	</head>
	<body class="popup" style ="overflow:hidden; height:100%">
		<table class="layout">
			<tr>		
		    	<td style="height:20px">
		    		<div id="menu">
			        	<ul>
			        		<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81'/>[${commentCount}]</span></li>
                            <c:if test="${item.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK' }">
                                <li><span onclick='btn_Modify_Onclick()'><spring:message code = 'ezCommunity.t6' /></span></li>
                            </c:if>
                            <c:if test="${item.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK' || boardInfo.delete_FG == 'true'}">
                                <li><span onclick='btn_Delete_Onclick()'><spring:message code = 'ezCommunity.t208' /></span></li>
                            </c:if>
                            <li><span onclick='ReaderList()'><spring:message code = 'ezCommunity.t952' /></span></li>
                            <c:if test="${useCabinet == 'YES'}">
                                <li><span onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
                            </c:if>
				 	   	</ul>
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
		    	<td style="height:20px">
		    		<table class="content" style="width:100%">
			        	<tr>
				        	<th style="width:10%"><spring:message code = 'ezCommunity.t138' /></th>
				          	<td id="WriteUserNM" style="white-space:nowrap; width:40%"><div id = title style="OVERFLOW-Y:auto;cursor:pointer;HEIGHT:16px;vertical-align:middle;" onclick='OpenUserInfo("${item.writerID}")'><c:out value = '${item.writerName}' /></div></td>
				          	<th style="width:10%"><spring:message code = 'ezCommunity.t932' /></th>
				          	<td id="User_DeptNM" style="padding-right:10px;white-space:nowrap"><span><c:out value = '${item.writerDeptName }' /></span></td>
				        </tr>
				        <tr>  	
				          	<th style="width:10%"><spring:message code = 'ezCommunity.t960' /></th>
				          	<td id="User_JobTitle" colspan="3" style="padding-right:10px;white-space:nowrap;"><span><c:out value = '${item.extensionAttribute3}' /></span></td>
				        </tr>
				        <tr> 
				        	<th style="width:10%"><spring:message code = 'ezCommunity.t210' /></th>
				          	<td width="100%" id="cTitle" colSpan="5"><div id="Div1" style="WIDTH: 100%; overflow-y:auto; word-wrap: break-word;"><c:out value = '${item.title}' /></div></td>
				        </tr>
			    	</table>
			   	</td>
			</tr>
			<tr>
				<td class="pad1" id="messagePad" style="height:450px;">
					<!-- 2018-07-05 김보미 - 팝업창에 생기던 스크롤바 내용부분으로 스크롤바 생기게 변경 -->
					<iframe id="message" class="viewbox" name="message" style="padding:0; width:100%; height:542px; overflow:auto; border:1px solid #ddd"></iframe>
<%-- 					<div class="viewbox" style="border:1px solid #ddd;"><img src='${gImageUrl}' border=0 width='${gWidth }' height ='${gHeight}' name=zb_target_resize style='cursor:pointer' > --%>
<!-- 				      	<iframe id="message" class='margin' name="message" style="padding: 0;width:100%;border:0px"></iframe>       -->
<!-- 				    </div> -->
				</td>
			</tr>
			<%-- 2018-05-11 홍승비 - 포토게시판 미사용 첨부파일 테이블, 인쇄, 메일, PC저장, 답변 코드 삭제--%>
			<%-- 2018-05-04 홍승비 - 포토게시판 다음글, 이전글 테이블 삭제 --%>			
		</table>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div> 
	</body>
</html>