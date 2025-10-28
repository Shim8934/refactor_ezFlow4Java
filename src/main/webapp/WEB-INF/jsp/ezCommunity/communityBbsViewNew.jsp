<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t202' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<style>
			P{
				margin-top: 0mm;
				margin-bottom: 0mm;
			}
			/* 첨부파일 아이콘 변경 */
			#lstAttachLink img{width: 18px;height: 18px;vertical-align: middle;margin: 0 2px 4px 0;}
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
			var defaultFont  = "${defaultFont}";
			var defaultSize  = "${defaultSize}";
			var useEditor  = "<c:out value='${useEditor}'/>";
			var contentLocation = "<c:out value='${strContentLocation}'/>";
			var realPath = "<c:out value='${realPath}'/>";
			var pathMiddle = "";
			
			window.onload = function () {
		        GetFileURL();
		      	
		        if (useEditor != "HWP") {
		        	var html = "";
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : { type	:	"COMMUNITYNOTI", 
								 href	:	contentLocation,
								 itemID	:	encodeURIComponent(no)
							   },
						success: function(result){
							html = result;
						}        			
					});
					
					/* 2019-10-28 홍승비 - 커뮤니티 공지사항에 기본 폰트와 사이즈 적용 */
					var defaultStyleTag = "<HTML><META content='text/html; charset=utf-8' http-equiv='Content-Type'><STYLE>";
					defaultStyleTag += "P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px; font-family:" + defaultFont + "; font-size:" + defaultSize + "}";
					defaultStyleTag += "DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;}</STYLE>";
					
					html = (defaultStyleTag + html.replace("<HTML>", ""));
					
					var doc = document.getElementById('message').contentWindow.document;
					doc.open();
					doc.write(html);
					doc.close();
					
					$("#message").contents().find("body").css("word-wrap", "break-word");
		        }
		        
		        SetAttachmentInfo();
				window.onresize();
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
							if (result == "REPLYCNT") {
								alert("<spring:message code='ezCommunity.t425' />");
							} else if (result == "OK") {
								 alert("<spring:message code='ezCommunity.t204' />");
			 		                //window.opener.parent.left.getBoardList();
			 		                window.opener.location.reload(false);
			 		                window.close();
							} else {
								alert("<spring:message code='ezCommunity.t203' />");
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
		    
		    function unEscapeHtml(text) {
		        var map = {
		            '&amp;' : '&',
		            '&lt;' : '<',
		            '&gt;' : '>',
		            '&#034;' : '"',
		            '&#039;' : "'"
		        };

		        return text.replace(/&amp;|&lt;|&gt;|&#034;|&#039;/g, function(m) { return map[m]; });
		    }
		    
		    /* 2019-02-20 홍승비 - 커뮤니티 CSRF 수정 (단순 호출 작동 시 get방식 사용 )*/
		    function btn_Reply_Onclick() {
		    	var strTitle = "<c:out value='${strTitle}' />";
		    	window.location.href 
		    		= "/ezCommunity/board/bbsEditNew.do?mode=write&bName=" + encodeURIComponent("${bName}") + "&no=" + encodeURIComponent("${grsNo}") +
		    				"&head=" + encodeURIComponent(unEscapeHtml(strTitle)) + "&step=" + encodeURIComponent("${myStep}") + "&level=" + encodeURIComponent("${myLevel}") + 
		    				"&ref=" + encodeURIComponent("${grsRef}") + "&pagec=" + encodeURIComponent("${pagec}");
		    }
				
		    function btn_Modify_Onclick() {
		        window.location.href = "/ezCommunity/board/bbsEditNew.do?mode=edit&bName=" + encodeURIComponent(bName) + "&no=" + encodeURIComponent(grsNo) + 
		        		"&pagec=" + encodeURIComponent(goToPage) + "&block=" + encodeURIComponent(nowBlock) + "&sRadio= " + encodeURIComponent(sRadio) + 
		        		"&keyword= " + encodeURIComponent(keyword);
		    }

		    function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
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
		        pathMiddle = strReturn;
		        strContentLocation = "/upload_community/filedata/" + strReturn + "/" + fileName;
		    }
		    
		    function Editor_Complete() {
		    	var URL;
		    	var completePath = realPath + "/" + pathMiddle + "/" + contentLocation;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(completePath);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
		    }
		    
		    function FieldsAvailable(isTrue) {
		    	if (isTrue) {
		    		message.EditMode(0);
	        		message.ShowToolBar(false);
	        		message.ShowRibbon(false);
					message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            window.onresize();
		    	}
		    }
		    
		    window.onresize = function () {
		    	if (useEditor == "HWP") {
	            	var contentHeight = document.documentElement.clientHeight - 220;
	            	document.getElementById("ItemOverflow").style.height = contentHeight + "PX";
	            	message.Resize(contentHeight + "PX");
	            } else {
	            	var contentHeight = document.documentElement.clientHeight - 220;
		            document.getElementById("ItemOverflow").style.height = contentHeight + "PX";
		            document.getElementById("message").style.height = contentHeight + "PX";
	            }
		    };
		    
		    function SetAttachmentInfo() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();

	            xmlhttp.open("GET", "/ezCommunity/getItemAttachments.do?itemID=" + encodeURIComponent(no), false);
	            xmlhttp.send();

	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;

	            var i = 0;
	            var pos = 0;
	            var filepath = "";
	            var filenameOrg = "";
		        var filenameView = "";
	            var strAttach = "";
	            var fileImage = "";

	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	            var regData = GetbrowserLanguage();

	            for (i = 0; i < xmldomNodes.length; i++) {
	                filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	                /* 2018-04-30 홍승비 - 커뮤니티 게시판 첨부파일명 특문처리 수정 */
	                filenameOrg = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filenameView = ReplaceText(ReplaceText(ReplaceText(filenameOrg, ">", "&gt;"), "<", "&lt;"), "&", "&amp;");		           
	                filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
	                var strTarget = "target='_blank'";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();

	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                    strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                    strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                    strFileExt == ".xlsx" || strFileExt == ".rtf" || strFileExt == ".mht") {
	                    strTarget = "target=''";
	                }

	                if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
	                    fileImage = "/images/image.svg";
	                else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
	                    fileImage = "/images/doc.svg";
	                else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
	                    fileImage = "/images/xls.svg";
	                else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
	                    fileImage = "/images/ppt.svg";
	                else if (strFileExt.indexOf(".txt") != -1)
	                    fileImage = "/images/txt.svg";
	                else if (strFileExt.indexOf(".zip") != -1)
	                    fileImage = "/images/zip.svg";
	                else if (strFileExt.indexOf(".pdf") != -1)
	                    fileImage = "/images/pdf.svg";
					else if (strFileExt.indexOf(".hwp") != -1 || strFileExt.indexOf(".hwpx") != -1)
						fileImage = "/images/hwp.svg";
	                else if (strFileExt.indexOf(".ecm") != -1)
	                    fileImage = "/images/ecm.svg";
	                else if (strFileExt.indexOf(".mht") != -1)
	                    fileImage = "/images/mht.png";
	                else
	                    fileImage = "/images/etc.svg";

	                var protocol = window.location.protocol;
	                var serverName = window.location.hostname;

	                strAttach = strAttach + "<div class='custom_checkbox'><input type='checkbox' name='fileSelect' value='" + filenameView + "' filepath='"+ filepath +"' filehref=\"/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filenameOrg) + "&filePath=" + encodeURIComponent(filepath)  + "\"></div>";
	                strAttach = strAttach + "<img src='" + fileImage + "'> <a href=/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filenameOrg) + "&filePath=" + encodeURIComponent(filepath) + ">";
	                strAttach = strAttach + filenameView + "&nbsp;(" + filesize + ")</a><br>";
	            }
	            document.getElementById('lstAttachLink').innerHTML = strAttach;
	        }
		    
		    function attach_Download_Cross() {
	            var checks = document.getElementById('lstAttachLink');
	            AttachAllDownload(checks);
	        }

	        var suffix = 0;
	        function downloadAll(checks) {
	        	checks = checks.getElementsByTagName("input");
	            if (checks.item(suffix)) {
	                if (checks.item(suffix).checked) {
	                    location.href = checks.item(suffix++).getAttribute("filehref");
	                    setTimeout(function () { downloadAll(checks) }, 1000);
	                }
	                else {
	                    suffix++;
	                    downloadAll(checks);
	                }
	            }
	            else
	                suffix = 0;
	        }
	        
	        function attach_SelectAll() {
	            var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");
	            for (var i = 0; i < checks.length; i++)
	                checks.item(i).checked = true;
	        }
	        
	        function AttachAllDownload(checks) {
	            var checkedFiles = $("#lstAttachLink").find("input:checkbox[name='fileSelect']:checked");
	            var checkedFilesLength = checkedFiles.length;
	            var filePath = ""; // 전체파일경로
	            var filePathTemp = "";
				var fileNames = ""; // 파일이름
				var fileNamesUID = ""; // 파일이름(UID 포함)
				
				if (checkedFilesLength == 1) { // 하나만 저장
					downloadAll(checks);
				}
				else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
					filePath = GetAttribute(checkedFiles.get(0), "filepath");
					filePath = filePath.substr(0, filePath.lastIndexOf("/") + 1);
					
					for (var i = 0; i < checkedFilesLength; i++) {
						filePathTemp = GetAttribute(checkedFiles.get(i), "filepath"); // 각 파일의 풀경로
						fileNames += MakeXMLString(checkedFiles.get(i).value) + ":"; // 각 파일의 이름을 :로 이어붙인 것
						fileNamesUID += MakeXMLString(filePathTemp.substr(filePathTemp.lastIndexOf("/"), filePathTemp.length)) + ":"; // 각 파일의 이름+UID를 :로 이어붙인 것
					}
					
					var $frm = $("<form></form>");
			    	$frm.attr('action', "/ezCommunity/downloadAttachAll.do");
			    	$frm.attr('method', 'post');
			    	$frm.appendTo('body');
			
			    	param1 = $('<input type="hidden" value="' + filePath + '" name="filePath" />');
			    	param2 = $("<input type='hidden' value='" + fileNames + "' name='fileNames' />");
			    	param3 = $("<input type='hidden' value='" + fileNamesUID + "' name='fileNamesUID' />");
			    	
			    	$frm.append(param1).append(param2).append(param3);
			    	$frm.submit();
				}
				else { // 체크된 파일 없음
					return;
				}
	        }
	        
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<form name="frmWrite" Method="POST">
			<input type="hidden" name="content" value="">
		</form>
		
		<table class="layout">
			<tr>
				<td style="height: 10px; vertical-align: top;">
					<div id="menu">
						<ul>
							<%--<c:if test="${bName == 'tbl_c_board'}">
							</c:if>--%>
							<c:if test="${strWriterID == userInfo.id ||fn:indexOf(userInfo.rollInfo, 'c=1') > -1 || fn:indexOf(userInfo.rollInfo, 'k=1') > -1}">
								<li id="btn_Reply"><span onclick="btn_Reply_Onclick()" ><spring:message code='ezCommunity.t207' /></span></li>
								<li id="btn_Modify"><span  onclick="btn_Modify_Onclick()" ><spring:message code='ezCommunity.t6' /></span></li>
								<li id="btn_Delete"><span class="icon16 popup_icon16_delete" onclick="btn_Delete_Onclick()"></span></li>
		          			</c:if>
						</ul>
					</div>
					<div id="close">
						<ul>
					    	<li><span onclick="btnClose_onclick()" ></span></li>
						</ul>
					</div>
					
					<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
				</td>
			</tr>
			<tr>
				<td style="height:20px">
					<table class="content">
						<tr>
							<th><spring:message code='ezCommunity.t138' /></th>
							<td id="WriteUserNM" ><div id=title style="OVERFLOW-Y: auto; WIDTH: 100%; CURSOR: pointer; HEIGHT: 20px; vertical-align: middle; line-height: 20px;" onclick='OpenUserInfo("<c:out value='${strWriterID}'/>")'> <c:out value='${strWriteName}'/></div></td>
							<th><spring:message code='ezCommunity.t209' /></th>
							<td id="PostDate" style="padding-right:15px;white-space:nowrap;" ><c:out value='${strWriteDate}'/></td>
			        	</tr>
			        	<tr>
			          		<th><spring:message code='ezCommunity.t210' /></th>
			          		<td id="cTitle" colspan="3"><div id="title" style="WORD-WRAP: break-word;word-break:break-all;OVERFLOW-Y: auto; WIDTH: 100%; HEIGHT: 20px; line-height: 20px;"><c:out value='${strTitle}'/></div></td>
			        	</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
				<td style="padding-top:10px;height:580px" id="ItemOverflow">
					<c:if test="${useEditor ne 'HWP'}">
						<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:100%; overflow:auto; border:1px solid #ddd;"></iframe>
					</c:if>
					<c:if test="${useEditor eq 'HWP'}">
						<iframe id="message" class="viewbox" src="/ezCommunity/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto; border:1px solid #ddd;"></iframe>
					</c:if>
					
    			</td>
  			</tr>
  			<!-- 2018-05-04 홍승비 - 그룹게시판 다음글, 이전글 테이블 삭제 -->	
  			
  			<tr>
				<td class="pad1" style="height:20px; vertical-align:top">
			   		<table class="file">
			   			<tr>
			        		<th><spring:message code='ezCommunity.t141'/></th>
			               	<td class="pos1">
			               		<div align="left" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white" id="lstAttachLink"></div>
			              	</td>
		                  	<td class="pos2" style ="white-space:normal;">
		                   		<a class="imgbtn imgbck" style="margin-bottom: 3px !important;"><span onclick="attach_SelectAll()" style="width:70px;"><spring:message code='ezCommunity.t962'/></span></a>
		                        <br>
		                        <a class="imgbtn imgbck"><span onclick="attach_Download_Cross()" style="width:70px;"><spring:message code='ezCommunity.t20'/></span></a>
		               		</td>
			           	</tr>
			       	</table>
			    </td>
			</tr>		
		</table>
				
		<form style="display:none" method="post" name="del" action="/ezCommunity/board/bbsDelOk.do">
			<input type=hidden name=grsNo value="<c:out value='${grsNo}'/>">
			<input type=hidden name=goToPage value="<c:out value='${pagec}'/>">
			<input type="hidden" name="bName" value="<c:out value='${bName}'/>">
		</form>
	</body>
</html>