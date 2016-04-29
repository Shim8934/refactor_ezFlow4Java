<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t146'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ConvertSaveImage.js"></script>
<!-- 		<script type="text/javascript" src="/ezcommunity/editor/js/dhtmled.js"></script> -->

		<script type="text/javascript">
			var iMhtml = null;
			var objxmlhttp = null;
			var iMhtmlSave = null;
			var DHTMLEditCtrlLoadFlag = false;
			var pMode = "<c:out value='${mode}'/>";
			var pNo = "<c:out value='${no}'/>";
			var pGant = "<c:out value='${cBoard.no}'/>";
			var pSradio = "<c:out value='${sRadio}'/>";
			var pKeyword = "<c:out value='${keyword}'/>";
			var pID = "<c:out value='${grsID}'/>";
			var pGoTopage = "<c:out value='${pagec}'/>";
			var pNowblock = "<c:out value='${block}'/>";
			var pRef = "<c:out value='${gref}'/>";
			var pStep  = "<c:out value='${step}'/>";
			var pLevel = "<c:out value='${level}'/>";
			var pName  = "<c:out value='${userInfoUserID}'/>";
			var pCode  = "<c:out value='${code}'/>";	
			var pBname  = "<c:out value='${bName}'/>";	
			var pUserNM = "<c:out value='${userInfoUserNM1}'/>";
			var pUserNM2 = "<c:out value='${userInfoUserNM2}'/>"; 
			var strContentLocation ="";
			var g_progresswin;
			var pTitle = "<c:out value='${cBoard.title}'/>";
			var wDate = "<c:out value='${cBoard.writeDay}'/>";
			var fileName = "<c:out value='${fileName}'/>";
			var writerFakeName = "<c:out value='${writerFakeName}'/>";
			
			window.onresize = function () {
			    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 140 + "PX";
			}
			
			window.onload = function() {
				alert(pCode, pGant);
				document.getElementById("title").focus();

                if (pMode == "write" && pNo != "" && (pBname == "c_clubpds" || pBname == "c_clubpds1")) {
				    document.getElementById("divBody").innerHTML = makeAttachDIV(document.getElementById("preAttachList").innerText);	
				    document.getElementById("attachedFile").innerHTML = makeAttachDIV2(document.getElementById("preAttachList").innerText);
				}
                
				if (pMode == "edit" || pNo != "") {
					document.getElementById("title").value = pTitle;
				}
			}
			
			function trim(val) {
				s=val.split(" ",val.length);
				return s.join("");
			}
			
			document.onclick = function () {
			    try {
			        document.getElementById("baseColor").style.display = "none";
			    } catch (e) {
			    }
			}
			
			function SaveMHT_onclick() {
				if (trim(document.getElementById("title").value) == "") {
						alert("<spring:message code = 'ezCommunity.t128'/>");
						document.getElementById("title").value = "";
						document.getElementById("title").focus();
						return;
				}
				
                mhtml_encodecomplete(1);
                return false;
			}
			
			function mhtml_encodecomplete( ntype ) {
				var pAttachFileList ="";

				if ( ntype == 0 ) {
					idstate.style.display = "none";
					
                    if (pMode == "write" && pNo != "") {
                    	var html = '<div style=\"font-family: <spring:message code = "ezCommunity.t150"/>">&nbsp;<div><BLOCKQUOTE style="MARGIN-RIGHT: 0px; MARGIN-TOP: 0px"><DIV>-------------------------[ <spring:message code = "ezCommunity.t131"/> ] -------------------------</DIV>' + i_mhtml.htmlData + '</BLOCKQUOTE></div></div>';
					    tbContentElement.editor.DOM.body.innerHTML = html;
                    } else {
// 					    tbContentElement.editor.DOM.body.innerHTML = '<div style=\"font-family: <spring:message code = "ezCommunity.t150"/> \">' + i_mhtml.htmlData + '</div>';
                    }
                    
					var retVal = tbContentElement.editor.DOM.body.createTextRange();
					retVal.collapse(true);
					retVal.select();
				} else {
					if (pBname == "c_clubpds" || pBname == "c_clubpds1") {
						pAttachFileList = AttachFileList();
					}

					var xmlDom = createXmlDom();
					var xmlHTTP = createXMLHttpRequest();
					
				    var objNode;
					createNodeInsert(xmlDom, objNode, "DATA"); 
                    createNodeAndInsertText(xmlDom, objNode, "Attachlist", pAttachFileList);					
                    createNodeAndInsertText(xmlDom, objNode, "Content", message.ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(message.GetEditorContent()) + "</BODY>" + "</HTML>"));
					createNodeAndInsertText(xmlDom, objNode, "Title", title.value);
					createNodeAndInsertText(xmlDom, objNode, "Textcontent", message.GetEditorContent());
					createNodeAndInsertText(xmlDom, objNode, "Mode", pMode);
					createNodeAndInsertText(xmlDom, objNode, "NO", pNo);
					createNodeAndInsertText(xmlDom, objNode, "Gant", pGant);
					createNodeAndInsertText(xmlDom, objNode, "Sradio", pSradio);
					createNodeAndInsertText(xmlDom, objNode, "Keyword", pKeyword);
					createNodeAndInsertText(xmlDom, objNode, "ID", pID);
					createNodeAndInsertText(xmlDom, objNode, "GoTopage", pGoTopage);
					createNodeAndInsertText(xmlDom, objNode, "Nowblock", pNowblock);
					createNodeAndInsertText(xmlDom, objNode, "Ref", pRef);
					createNodeAndInsertText(xmlDom, objNode, "Step", pStep);
					createNodeAndInsertText(xmlDom, objNode, "Level", pLevel);
					createNodeAndInsertText(xmlDom, objNode, "Code", pCode);
					createNodeAndInsertText(xmlDom, objNode, "Bname", pBname);
					createNodeAndInsertText(xmlDom, objNode, "UserNM", pUserNM);
					createNodeAndInsertText(xmlDom, objNode, "UserNM2", pUserNM2);
				
					xmlHTTP.open("POST", "/ezCommunity/bbsEditOk.do", false);
					xmlHTTP.send(xmlDom);
					
					if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
						alert("<spring:message code = 'ezCommunity.t152'/>");
					} else {
						alert("<spring:message code = 'ezCommunity.t153'/>");
					    
					    if (window.opener.parent.left != undefined) {
					        window.opener.parent.left.getBoardList();
					    }
					    
					    window.opener.location.reload(false);
					    window.close();
					}
				}
			}
			
			function exit_onclick(){
				history.go(-1);
			}
			
			function btnClose_onclick(){
				window.close();
			}
			
			function ReplaceText( orgStr, findStr, replaceStr ){
				var re = new RegExp( findStr, "gi" );
				return ( orgStr.replace( re, replaceStr ) );
			}
			
			function GetFileURL(){
				var strReturn = "";
			
				switch(pBname){
					case "c_clubnotice":
						strReturn = "notice";
						break;
					case "c_clubboard":
						strReturn = "board";
						break;
					case "c_clubboard1":
						strReturn = "board1";
						break;
					case "c_clubboard2":
						strReturn = "board";
						break;
					case "c_clubpds":
						strReturn = "pds";
						break;
					case "c_clubpds1":
						strReturn = "pds1";
						break;
					case "c_notice":
						strReturn = "mainnotice";
						break;
					case "c_board":
					default:
						strReturn = "mainboard";
						break;
				}
				
				strContentLocation = "/files/upload_community/filedata/" + strReturn + "/" + fileName;
			}
			
			var isComplete = false;
			function DocumentComplete() {
			    if(pNo != "") {
			        GetFileURL();
			        var fullPath = strContentLocation;
			        var htmlData = message.SetEditorContentURL2(fullPath);
			        
			        if(pMode == "write" && pNo != "") {
			            htmlData = "<br><br>-----<B>[&nbsp;" + "<spring:message code = "ezCommunity.t1161"/>" + "</B>-----<br><B> " + "<spring:message code = "ezCommunity.t1162"/>" + "</B>" + wDate + "<br><B> " + "<spring:message code = 'ezCommunity.t218'/>" + "</B>" + writerFakeName + "<br><B> " + "<spring:message code = "ezCommunity.t885"/>" + "</B>" + pTitle + "<br><br>" + htmlData;
			            message.SetEditorContent(htmlData);
			        } else {
			            message.SetEditorContentURL(fullPath);
			        }
			    } 
			}
		</script>
		
		<c:if test="${mode == 'edit' && no != '' && (bName == 'c_clubpds' || bName == 'c_clubpds1')}">
			<script type="text/javascript">
				function makeAttachDIV(attachStr){
				
					if(attachStr = "") {
						return;
					}
					
					DIVHTML = "<TABLE><TBODY>";
					attachArray = Split(attachStr, ";");
					attachLength = UBound(attachArray);
					
					for (i=0; i>=attachLength-1; i++){
						orgFileName = attachArray(i);
						pos = instr(1, orgFileName, "_");
						FileName = right(orgFileName, len(orgFileName) - pos);
						DIVHTML = DIVHTML & "<TR style='height:12px;' org_filename=""" & orgFileName & """ filename=""" & FileName & """>";
						DIVHTML = DIVHTML & "<TD><INPUT type=checkbox id=checkbox1 name=checkbox1><img src='/images/email/mail_006.gif'>&nbsp;<a target='_blank' style=\"cursor:pointer\" href='/ezCommon/downloadattach.do?filename=" & FileName & "&filepath=/upload_community/filedata/pds/" & orgFileName & "'>" & FileName & "</a></TD></TR>";
					}
					
					DIVHTML = DIVHTML & "</TBODY></TABLE>";
					makeAttachDIV = DIVHTML
				}
				
	
			function makeAttachDIV2(attachStr){
				if(attachStr = "") {
					return;
				}
				
				DIVHTML = "";
				attachArray = Split(attachStr, ";");
				attachLength = UBound(attachArray);
				
				for (i=0 ; i>=attachLength-1; i++){
					orgFileName = attachArray(i);
					pos = instr(1, orgFileName, "_");
					FileName = right(orgFileName, len(orgFileName) - pos);
					DIVHTML = DIVHTML & "<DIV org_filename=""" & orgFileName & """ id=orgfile" & i & ">";	
					DIVHTML = DIVHTML & "<INPUT type=checkbox id=checkbox1><IMG src=""/images/email/mail_006.gif"">&nbsp;<A href='/ezCommon/downloadattach.do?filename=" & FileName & "&filepath=/upload_community/filedata/pds/" & orgFileName & "' target='_blank'>" & FileName & "</A></DIV>";
				}
				
				makeAttachDIV2 = DIVHTML;
			}
			
			window.onload = function() {
				divBody.innerHTML = makeAttachDIV(preAttachList.innerText);			
				attachedFile.innerHTML = makeAttachDIV2(preAttachList.innerText);		
			}
			</script>
		</c:if>
	</head>
	<body class = "popup" style = "height:97%">
		<table class="layout">
			<tr>
				<td style="height:20px;">
					<div id="menu">
						<ul>
							<li><span onClick="SaveMHT_onclick();" ><spring:message code = "ezCommunity.t155"/></span></li>
						</ul>
					</div>
					<div id="close">
						<ul>
			     			<li><span onClick="btnClose_onclick();"><spring:message code = "ezCommunity.t21"/></span></li>
				 		</ul>
					</div>
					
					<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
						selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
					
				</td>
			</tr>
			<tr>
				<td style = "height:20px;">
					<table class = "content">
						<tr>
							<th><spring:message code = "ezCommunity.t138"/></th>
							<td><c:out value="${grsUserName }"/></td>
						</tr>
						<tr>
							<th><spring:message code = "ezCommunity.t156"/></th>
							<td><INPUT id=title style="WIDTH: 100%;box-sizing:border-box;-moz-box-sizing:border-box;" type=text maxLength=99 value=""></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table style="width:100%;height:100%;">
		                <tr> 
							<td style="vertical-align:top;height:100%" id="EdtorSize">
					        	<iframe id="message" class="viewbox"  name="message" src="/ezCommunity/ckEditor.do" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
							</td>
		                </tr> 
		            </table>
				</td>
			</tr>
		</table>
		
		<div id="idstate"  class="box" style="width:300px;height:50px;display:none;POSITION:absolute;LEFT:200px;TOP:60px;z-index:1">
			<table style="width:100%;height:100%;background-color:gainsboro">
				<tr>
					<td align="center"><spring:message code = "ezCommunity.t142"/></td>
				</tr>
			</table>
		</div>
		
		<span id="tmpbody" style="display:none"></span><span id="preAttachList" style="display:none"> <c:out value="${cBoard.charFileName }"/> </span>
		
	    <script type="text/javascript">
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 140 + "PX";
		</script>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/myoffice/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>   
	</body>
</html>