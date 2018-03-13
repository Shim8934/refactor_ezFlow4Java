<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code='ezBoard.t293' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/common.js"></script>
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/Common.js" ></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script  type="text/javascript">
		</script>
	</head>
	<body class="popup" style="overflow:hidden; height:100%;">
		<table class="layout" style="height:100%">
		  <tr>
		    <td style="vertical-align: top; height: 10px;">
		      <div id="menu">
		        <ul>
	        		<li><span onclick=''> <spring:message code='ezJournal.t102' /></span></li>
		        	<c:if test="${journal.mine eq 'yes' }">
	        		<li><span onclick=''> <spring:message code='ezJournal.t107' /></span></li>
	        		<li><span onclick=''> <spring:message code='ezJournal.t108' /></span></li>
		        	</c:if>
	        		<li><span onclick=''> <spring:message code='ezJournal.t103' /></span></li>
		        	<c:if test="${journal.mine eq 'yes' }">
	        		<li><span onclick=''> <spring:message code='ezQuestion.t700' /></span></li>
	        		<li><span onclick=''> <spring:message code='ezJournal.t113' /></span></li>
		        	</c:if>
	        		<li><span onclick=''> <spring:message code='main.t73' /></span></li>
	        		<li><span onclick=''> <spring:message code='ezJournal.t104' /></span></li>
		        </ul>
		      </div>    
		      <div id="close">
		        <ul>
		          <li><span onClick="window.close()"> <spring:message code='ezBoard.t12' /></span></li>
		        </ul>
		      </div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			</script>
		    </td>
		    </tr>
		    <tr>
					<td style="vertical-align: top; height: 10px;">
					<table class="content2" style="width:100%;">
						<!-- 작성일  -->
						<tr>
							<th style="width:10%;"><spring:message code='ezJournal.t25' /></th>
							<td style="width:40%; white-space:nowrap">
				             	<div style="overflow-y:auto;WIDTH: 100%; vertical-align: middle"> <c:out value="${journal.journalDate}"/></div>
							</td>
						<!-- 작성자 -->
							<th style="width:10%;"><spring:message code='ezJournal.t34' /></th>
							<td style="width:40%; white-space:nowrap">
								<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer" onclick='OpenUserInfo("${journal.writerId}")'>
				             	 <c:out value="${journal.writerName}"/></div>
							</td>
						</tr>
						<!-- 일지함명  -->
						<tr>
							<th style="width:10%;"><spring:message code='ezJournal.t12' /></th>
							<td style="width:40%; white-space:nowrap">
				             	<div style="overflow-y:auto;WIDTH: 100%; vertical-align: middle"> <spring:message code='${journal.typeId}' /></div>
							</td>
						<!-- 양식명 -->
							<th style="width:10%;"><spring:message code='ezJournal.t22' /></th>
							<td style="width:40%; white-space:nowrap">
				             	<div style="overflow-y:auto;WIDTH: 100%; vertical-align: middle"> <c:out value="${journal.formName}"/></div>
							</td>
						</tr>
						<!-- 제목 -->	
				        <tr>
				          <th><spring:message code='ezBoard.t323' /></th>
				             <td width="100%" id="cTitle" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
				             	<div style="overflow-y:auto;WIDTH: 100%; vertical-align: middle"><c:out value=" ${journal.journalTitle}"/></div>
				             </td>
				        </tr>
			      </table>
			    </td>
		  </tr>
		  <tr>
		    <td class="pad1" id="pad1" style="vertical-align: top; height:100%;">
	        <div class="viewbox" style="text-align:center; padding:0; width:100%; height:100%; overflow:auto; border:1px solid #b6b6b6">
			    <div style="text-align: left;">
					<img onclick="Smaller();" style="cursor:pointer; margin:5px;" src="/images/minus.png">
			        <img onclick="Bigger();" style="cursor:pointer; margin:5px; margin-left:-10px;" src="/images/plus.png">
				</div>
				<div id="journalContent" >
		        	${journal.journalContent }
				</div>
	        </div>
		    </td>
		  </tr>
		 	<tr>
			    <td class="pad1" style="vertical-align: top; ">
			        <table class="file">
			        <tr>
			          <th><spring:message code='ezBoard.t292' /></th>
                      <td>
		            	<div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;background-color:white; text-align:left"></div>
			          </td>
			          <td class="pos2">
			             <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
			             <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
			          </td>
			          <td id="Td2" style="display:none"></td>
			        </tr>
			      </table>
			    </td>
			</tr>
		</table>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    
	    
	    <script  type="text/javascript">
		    window.offscreenBuffering = true;
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        
	        function Bigger(doc) {     
                if (nowZoom < maxZoom) {
                    nowZoom += 10;
                } else {
                    return;
                }
                
                $("#journalContent").css("zoom",nowZoom + "%");
	        }
	        
	        function Smaller(doc) {
                if (nowZoom > minZoom) {
                    nowZoom -= 10;
                } else {
                    return;
                }

                $("#journalContent").css("zoom",nowZoom + "%");
	        }
		
		    
		    //프린터
		    var boarditemview_cross_print_option_dialogArguments = new Array();
		    var url = window.location.href;
		    function btn_Print_Onclick() {
		        if (CrossYN()) {
		            url = window.location.href;
		            url = url.replace(".do", "PrintOption.do");
		            boarditemview_cross_print_option_dialogArguments[1] = btn_Print_Onclick_Complete;
		            var OpenWin = window.open(url, "boarditemview_print_option", GetOpenWindowfeature(380, 200));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var parameter = "";
		            url = window.location.href;
		            url = url.replace(".do", "PrintOption.do");
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
		            url = url.replace("PrintOption.do", "Print.do");
		            url = url + "&oneLine=" + RtnVal[0] + "&attach=" + RtnVal[1];
		            window.open(url, "", "top=0, left=0, height=700px, width=840px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1");
		        }
		    }
		    
		    //작성자 정보창
		    function OpenUserInfo(pUserID) {
		        var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID, "UserInfo", 420, 450, "NO");
		    }
			
		    //메일로?
		    function Retrans_mailContent() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/ezEmail/mailWrite.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&cmd=board";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }
		</script>
	    
	    
	</body>
</html>