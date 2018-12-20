<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezTalkGate.ldh001" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/ezTalkGate/ktb2b.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezTalkGate/main.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezTalkGate.e1', 'msg')}"></script>
		<script>
		
		window.onload = function() {
			document.getElementById('noticeMoreBtn').addEventListener("click", moreView);	
		}
		
		var Count = 5; //공지사항 게시게수 
		var SelectBoardID = "${noticeBoardID}";
		var gubun = "0";
		var ezTalkId = "${ezTalkId}";
		var ezTalkPw = "${ezTalkPw}";
		
		function ItemRead_onclick(itemseq) {  
		    
			if (itemseq == "0") {
		      return;     
		    }
		     
		    var pheigth = window.screen.availHeight;
		    var pwidth = window.screen.availWidth;
		    pheigth = parseInt(pheigth) / 2;
		    pwidth = parseInt(pwidth) / 2;
		    pheigth = pheigth - 300;
		    pwidth = pwidth - 330;
		    
		    // TODO : 톡게이트에 하나 추가 하여서 처리할 예정 (redirect할때 id넘겨서 인증스트링 으로 로그인 처리한 다음에 처리!!!!!!!ㅎ) 
		    // window.open("/myoffice/ezMsn/shownotice.aspx?itemid=" + itemseq, "", "height=657,width=720px, status=no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth,""); 
		    var pURL = "/ezTalkGate/showNoticeBoardItem.do?itemId=" + itemseq;
		    window.showModalDialog(pURL, null, "dialogHeight:604px; dialogWidth:773px; status:no; scroll:no; help:no; edge:sunken; resizable=yes; center:yes"); 
		}
			
		/**
		 * 공지사항 더보기
		 */
		function moreView() {
			console.log("boardId=" + SelectBoardID);
			var openUrl = "/ezTalkGate/noticeBoardDetailList.do?boardType=" + gubun 
						+ "&ezTalkId=" + encodeURIComponent(ezTalkId) + "&ezTalkPw=" + encodeURIComponent(ezTalkPw); 
			console.log("openUrl=" + openUrl);
			window.open(openUrl, "_blank", "width=1152, height=790, resizable=yes, toolbar=yes");
		}
			
		</script>
	</head>
	<body scroll="no" width="365" height="165">
		<table width="100%" height="165" border="0" cellspacing="0" cellpadding="0" style="background:#f7f7f7;">
		  <tr> 
		    <td height="10">
		      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr>
		          <td style="text-align: right; padding-right: 10px;">
		          	<img src="/images/kr/main/btn_more02.gif" style="cursor: pointer;vertical-align:text-bottom;" alt='<spring:message code="main.t1008"/>' id="noticeMoreBtn"/>
		          </td>
		        </tr>
		      </table>
		    </td>
		  </tr>
		  <tr>
		    <td>
		      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="" >
		        <tr>
		          <td width="7"></td>
		          <td style="border:1px solid #e1e1e1; padding:15px; background:#fff;">
		            <table width="290" border="0" cellspacing="0" cellpadding="0">	
		            <c:if test="${empty boardItemList}">
		              <tr>
		                <td width="20" height="22" align="center"><img src="images/ico_arrow02.gif" width="4" height="5"></td>
		                <td><spring:message code="ezTalkGate.ldh003" /></td>
		              </tr>
		              <tr>
		                <td colspan="2" height="1" style="background-image:url(images/dot_line01.gif)"></td>
		              </tr>
		              <tr colspan="2" height="93"><td>&nbsp;</td></tr>            
		            </c:if>
		            <c:if test="${!empty boardItemList}">
		              <tr>
		                <td>	    
		                  <c:forEach var="item" items="${boardItemList}">
		                  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="9" > 
		                    <tr style="cursor:pointer" onClick="ItemRead_onclick('${item.ITEMID}')"> 
		                      <td width="20" height="22" align="center"></td>
		                      <td>
		                        <c:if test="${item.ISNEW == 'YES'}"><img src='/images/ezTalkGate/new_s.gif' style="width:27px;height:17px;vertical-align:bottom;"></c:if>
		                        <div style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;width:190px;display:inline-block;vertical-align:bottom;"><font color="#000000">[${fn:substring(item.WRITEDATE, 5, 7)}/${fn:substring(item.WRITEDATE, 8, 10)}] <c:out value='${item.TITLE}' /></font></div> &nbsp;
		                      </td>
		                    </tr>
		                    <tr>
		                      <td colspan="2" height="1"></td>
		                    </tr> 					       
		                  </table>		                      
		                  </c:forEach>
		                </td>
		              </tr>
		            </c:if>
		            </table>
		          </td>
		          <td width="7"></td>
		        </tr>
		      </table>
		    </td>
		  </tr>
		  <tr> 
		    <td height="7"> 
		      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr>
		          <td style="width:27px;height:7px"></td>
		          <td align="right" valign="bottom"></td>
		          <td style="width:27px"></td>
		        </tr>
		      </table>
		    </td>
		  </tr>
		</table> 
	</body>
</html>