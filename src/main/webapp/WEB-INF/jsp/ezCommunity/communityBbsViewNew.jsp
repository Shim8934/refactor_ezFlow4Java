<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t202' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<style>
			P{
				margin-top: 0mm;
				margin-bottom: 0mm;
			}
		</style>
		
		<script type="text/javascript">
			var no = "<c:out value='${no}'/>";
			var grsNo = "<c:out value='${grsNo}'/>";
			var goToPage = "<c:out value='${pagec}'/>";
			var bName = "<c:out value='${bName}'/>";
			var nowBlock = "<c:out value='${nowBlock}'/>";
			var sRadio = "<c:out value='${sRadio}'/>";
			var keyword = "<c:out value='${keyword}'/>";
			var fileName = "<c:out value='${fileName}'/>";
			
			window.onload = function () {
		        GetFileURL();
		      
				var html = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type	:	"COMMUNITYNOTI", 
							 href	:	"<c:out value='${strContentLocation}'/>",
							 itemID	:	encodeURIComponent(no)
						   },
					success: function(result){
						html = result;
					}        			
				});
				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
		        
				$("#message").contents().find("body").css("word-wrap", "break-word");
		    }
			
			function btn_Delete_Onclick() {
		        var result;

		        result = confirm("<spring:message code='ezCommunity.t136' />");

		        if (result) {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommunity/bbsDelOk.do",
						data : {itemNo : grsNo,
								goToPage : goToPage,
								bName : bName,
						},
						success : function(result) {
							if (result != "OK") {
								alert("<spring:message code='ezCommunity.t203' />");
							} else {
								 alert("<spring:message code='ezCommunity.t204' />");
			 		                //window.opener.parent.left.getBoardList();
			 		                window.opener.location.reload(false);
			 		                window.close();
							}
						},
						error : function(xhr, status, error) {
							if (status != 200) {
								alert("<spring:message code='ezCommunity.t203' />");
							}
						}
					});
		        }
		    }

		    function OpenItem(idx) {
		        if (idx != "") {
		        	window.location.href = window.location.href.replace("no=" + no, "no=" + idx);
		        }
		    }
				
		    function btnClose_onclick() {
		        window.close();
		    }
				
		    function btn_Reply_Onclick() {
		        document.re.submit();
		    }
				
		    function btn_Modify_Onclick() {
		        window.location.href = "/ezCommunity/board/bbsEditNew.do?mode=edit&bName=" + bName + "&no=" + grsNo + "&pagec=" + goToPage + "&block=" + nowBlock + "&sRadio= " + sRadio + "&keyword= " + keyword;
		    }

		    function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
			
		    function ImageUrl(pUrl, cnt) {
		        var link = "/ezCommon/imgFileRead.do?pUrl=" + pUrl + "&cnt=" + cnt;

		        return link;
		    }
				
		    function trim(val) {
		        s = val.split(" ", val.length);
		        return s.join("");
		    }
				
		    function ExtractBetweenPattern(orgStr, firstPattern, lastPattern) {
		        var sIndex, eIndex;
		        var copyStr = new String(orgStr);

		        var retStr = "", subStr;

		        var regFExp = new RegExp(firstPattern, "i");
		        var regEExp = new RegExp(lastPattern, "i");

		        var loop = 0;

		        sIndex = copyStr.search(regFExp);
		        if (sIndex == -1) {
		            return orgStr;
		        }

		        copyStr = copyStr.substr(sIndex + firstPattern.length);

		        eIndex = copyStr.search(regEExp);
		        if (eIndex == -1) {
		            return copyStr;
		        }

		        retStr = copyStr.substr(0, eIndex);
		        return retStr;
		    }
				
		    function GetFileURL() {
		        var strReturn = "";

		        switch (bName) {
		            case "tbl_c_clubnotice":
		                strReturn = "notice";
		                break;
		            case "tbl_c_clubboard":
		                strReturn = "board";
		                break;
		            case "tbl_c_clubboard1":
		                strReturn = "board1";
		                break;
		            case "tbl_c_clubboard2":
		                strReturn = "board";
		                break;
		            case "tbl_c_clubpds":
		                strReturn = "pds";
		                break;
		            case "tbl_c_clubpds1":
		                strReturn = "pds1";
		                break;
		            case "tbl_c_notice":
		                strReturn = "mainnotice";
		                break;
		            case "tbl_c_board":
		            default:
		                strReturn = "mainboard";
		                break;
		        }
		        strContentLocation = "/upload_community/filedata/" + strReturn + "/" + fileName;
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<form name="frmWrite" Method="POST">
			<input type="hidden" name="content" value="">
		</form>
		
		<table class="layout" style="height:707px">
			<tr>
				<td style="height:20px;">
					<div id="menu">
						<ul>
							<c:if test="${bName == 'tbl_c_board'}">
								<li id="btn_Reply"><span onclick="btn_Reply_Onclick()" ><spring:message code='ezCommunity.t207' /></span></li>
							</c:if>
							<c:if test="${strWriterID == userInfo.id ||fn:indexOf(userInfo.rollInfo, 'c=1') > -1 || fn:indexOf(userInfo.rollInfo, 'k=1') > -1}">
								<li id="btn_Modify"><span  onclick="btn_Modify_Onclick()" ><spring:message code='ezCommunity.t6' /></span></li>
								<li id="btn_Delete"><span  onclick="btn_Delete_Onclick()" ><spring:message code='ezCommunity.t208' /></span></li>
		          			</c:if>
						</ul>
					</div>
					
					<div id="close">
						<ul>
					    	<li><span onclick="btnClose_onclick()" ><spring:message code='ezCommunity.t21' /></span></li>
						</ul>
					</div>
					
					<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
						selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
				</td>
			</tr>
			<tr>
				<td style="height:20px">
					<table class="content">
						<tr>
							<th><spring:message code='ezCommunity.t138' /></th>
							<td id="WriteUserNM" ><div id=title style="OVERFLOW-Y: auto; WIDTH: 100%; CURSOR: pointer; HEIGHT: 16px; vertical-align: middle" onclick='OpenUserInfo("<c:out value='${strWriterID}'/>")'> <c:out value='${strWriteName}'/></div></td>
							<th><spring:message code='ezCommunity.t209' /></th>
							<td id="PostDate" style="padding-right:15px;white-space:nowrap;" ><c:out value='${strWriteDate}'/></td>
			        	</tr>
			        	<tr>
			          		<th><spring:message code='ezCommunity.t210' /></th>
			          		<td id="cTitle" colspan="3"><div id="title" style="WORD-WRAP: break-word;word-break:break-all;OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 16px"><c:out value='${strTitle}'/></div></td>
			        	</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
				<td style="padding-top:10px;height:70%" id="ItemOverflow">
					<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
    			</td>
  			</tr>
  			<tr>
				<td style="height:20px;vertical-align:top;" class="pad1">
    				<table class="content">
						<tr>
							<th><spring:message code='ezCommunity.t190' /></th>
							<c:choose>
								<c:when test="${previousItemID == '' }">
									<td>
								</c:when>
								<c:otherwise>
									<td style="cursor:pointer" >
								</c:otherwise>
							</c:choose>
								<div style="word-break:break-all;margin-top:0px;padding-top:0px;OVERFLOW: auto; HEIGHT: 16px; background-color:white" onclick="OpenItem('<c:out value="${previousItemID}"/>')"><c:out value='${previousTitle}'/></div>
						 	</td>
						</tr>
						<tr>
							<th><spring:message code='ezCommunity.t192' /></th>
							<c:choose>
								<c:when test="${nextItemID == '' }">
									<td>
								</c:when>
								<c:otherwise>
									<td style="cursor:pointer">
								</c:otherwise>
							</c:choose>
								<div style="word-break:break-all;margin-top:0px;padding-top:0px;OVERFLOW: auto; HEIGHT: 16px; background-color:white" onclick="OpenItem('<c:out value='${nextItemID}'/>')"><c:out value='${nextTitle}'/></div>
				 			</td>
						</tr>
     				</table>
     			</td>
  			</tr>
		</table>
                
		<form style="display:none" name="re" method="post" action="/ezCommunity/board/bbsEditNew.do?mode=write&bName=<c:out value='${bName}'/>">
			<input type="hidden" name="no" value="<c:out value='${grsNo}'/>">
			<input type="hidden" name="head" value="<c:out value='${strTitle}'/>">
			<input type="hidden" name="step" value="<c:out value='${myStep}'/>">
			<input type="hidden" name="level" value="<c:out value='${myLevel}'/>">
			<input type="hidden" name="ref" value="<c:out value='${grsRef}'/>">
			<input type="hidden" name="pagec" value="<c:out value='${pagec}'/>">
		</form>
		
		<form style="display:none" method="post" name="del" action="/ezCommunity/board/bbsDelOk.do">
			<input type=hidden name=grsNo value="<c:out value='${grsNo}'/>">
			<input type=hidden name=goToPage value="<c:out value='${pagec}'/>">
			<input type="hidden" name="bName" value="<c:out value='${bName}'/>">
		</form>
	</body>
</html>