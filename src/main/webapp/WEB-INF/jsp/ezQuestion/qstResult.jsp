<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezQuestion.t378' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>

		<script type="text/javascript">
			document.onselectstart = function (){ return false; };
	    	window.onload = function (){
	        	if(navigator.userAgent.indexOf('Firefox') != -1){
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
	    	
		    function MM_reloadPage(init){
		        if(init == true) with (navigator){
		            if((appName == "Netscape") && (parseInt(appVersion) == 4)){
		                document.MM_pgW = innerWidth; document.MM_pgH = innerHeight; onresize = MM_reloadPage;
		            }
		        }else if(innerWidth != document.MM_pgW || innerHeight != document.MM_pgH)
		        	location.reload();
		    }
		    
			MM_reloadPage(true);
		</script>
		<script type="text/javascript">
			var brdId="${qstUserPermissionVO.userId}";
			var tempReceve= "${receve}";
			var receve = tempReceve.replace(/amp;/g,'');
			
			<%-- function Setting_Change(vdata){
		        var feature = GetOpenPosition(380, 340);
		        window.open("change_setting.aspx?brd_id=" + '<%=v_brd_id%>' + "&item_no=" + '<%=v_item_no%>', "setting", "width=380px,height=340px,toolbar=no,location=no,help=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no" + feature);
			} --%>
			
			/* function funResponseView(questionNo){
			    var szUrl = "/ezQuestion/qstResultSubjective.do?brdId=" + "${v_brdId}" + "&itemNo=" + "${v_itemNo}" + "&questionNo=" + questionNo;
			    window.location.href = szUrl;
			} */
			
			function UserInfo(questionNo, answerNo, type){
			}
			
			function printOnClick(){
			    window.print();
			}
			
			/* function funDelete(){
			    var result;
			    result = confirm("<spring:message code='ezQuestion.t321' />");
				if result){
				    document.location.href = "/ezQuestion/pollDeleteOk.do?brdId=" + "${v_brd_id}" + "&itemNo=" + "${v_item_no}";
				}
	
		    } */

		    var pUserID = "${userId}";
		    
		    function openUserInfo(strEmail){
		        var compemail = strEmail;
		        compemail = compemail.toUpperCase();
		        var sDomain =  request.getServerName();
		        sDomain = sDomain.toUpperCase();
		        var s_pos = compemail.indexOf("@");
		        var parameter = compemail.slice(0, s_pos);
		        var feature = GetOpenPosition(420, 460);
				
		        window.open("/myoffice/common/ShowPersonInfo_cross.aspx?id=" + parameter, "", "height=460px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
					
		        } 

		    function menuQstList(){
	            var szUrl = "/ezQuestion/qstList.do?" + receve + "&brdNm=" + "<spring:message code='ezQuestion.t206' />" ;
			    window.location.href = szUrl;
			}

			/* function menuQst_ResponseList(pflag){
			    var szUrl = "/ezQuestion/qstResponseList.do?" + "${receve}" + "&responseYN=" + pflag;
			    window.location.href = szUrl;
			} */

			/* function file_open(pType, pBrdID, pItemID, pQstNo, pAnsNo, pAttID){
				var pUrl = "Qst_Attach_View.aspx?href=" + pHref + "&type=" + pType + "&filename=" + escape(pFileName);	
			    if(pType == "1")
			        openwindow(pUrl, "", "800px", "600px", "1", "1", "800");
			    else if(pType == "3")
			        openwindow(pUrl, "", "420px", "410px", "0", "0", "500");
			    else
			        openwindow(pUrl, "", "415px", "120px", "0", "0", "500");
			} */

			function openwindow(wfileLocation, wName, wWeigth, wHeigth, wScrollbars, wResizable, wVal) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			        var top = (heigth - parseInt(wVal)) / 2;
			        var left = (width - parseInt(wVal)) / 2;

			        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=" + wScrollbars + ",resizable=" + wResizable + ",height=" + wHeigth + ",width=" + wWeigth + ",top=" + top + ",left = " + left);
			    }
			    catch (e) {
			    }
			}
		</script>
	</head>
	<body class="mainbody">
		<form method="post">
			<h1><spring:message code='ezQuestion.t303' /></h1>
			<div id="mainmenu">
				<ul>
					<li><span onClick="menuQstList()"><spring:message code='ezQuestion.t130' /></span></li>
					<c:if test="${resCnt > '0' && publicFlg == '0'}">
						<li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" align="absmiddle"></li>
						<li><span  onClick="menuQst_ResponseList('Y')"><spring:message code='ezQuestion.t350' /></span></li>
					</c:if>
					<c:if test="${responseRange == '1' && publicFlg == '0'}">
						<li><span onClick="menuQstResponseList('N')"><spring:message code='ezQuestion.t390' /></span></li>
					</c:if>
				</ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<table class="content">
				<tr>
					<th><spring:message code='ezQuestion.t255' /></th>
					<td>${qstUserPollItemVO.title}</td>
				</tr>
				<tr>
					<th><spring:message code='ezQuestion.t265' /></th>
					<td><a style="cursor:pointer" onclick='openUserInfo("${qstUserPollItemVO.userEmail}")' >${qstUserPollItemVO.userNm} (${qstUserPollItemVO.userEmail}) </a> </td>
				</tr>
				<tr>
					<th><spring:message code='ezQuestion.t216' /></th>
					<td>${qstUserPollItemVO.pollStartDate}  ~  ${qstUserPollItemVO.pollEndDate}</td>
				</tr>
				<tr>
					<th><spring:message code='ezQuestion.t231' /></th>
					
					<td>
						<c:choose>
							<c:when test="${qstUserPollItemVO.postTerm == '0'}">
								<spring:message code='ezQuestion.t322' />
							</c:when>
							<c:otherwise>
								${qstUserPollItemVO.pollEndDate} <spring:message code='ezQuestion.t323' /> ${qstUserPollItemVO.postTerm} <spring:message code='ezQuestion.t233' />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezQuestion.t325' /></th>
					<td>${qstUserPollItemVO.resCnt} <spring:message code='ezQuestion.t391' />${qstUserPollItemVO.readCnt} ] </td>
				</tr>
				<tr>
					<th><spring:message code='ezQuestion.t327' /></th>
					<td>${qstUserPollItemVO.content}</td>
				</tr>
			</table>
			<br>
			<%-- <div><%=strData%></div> --%>
		</form>
	</body>
</html>