<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	 	<c:if test ="${mode =='write'}">
			<title><spring:message code = 'ezCommunity.t146'/></title> <!-- 게시물 등록 -->
		</c:if>
		<c:if test = "${mode == 'edit'}" >
			<title><spring:message code = 'ezBoard.t370'/></title> <!-- 게시물 수정 -->
		</c:if> 
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			#lstAttachLink {
				height: 115px;
				border: 1px solid #d2d2d2;
			}

			.attachInnerNotice_p_on {
				text-align: center;
				margin: 10px 0 0 0;
			}

			.attachInnerNotice_p_off {
				display: none;
			}

			.attachInnerNotice_span {
				line-height: 55px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ConvertSaveImage.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
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
			var pID = "<c:out value='${cBoardVO.id}'/>";
			var pGoToPage = "<c:out value='${pagec}'/>";
			var pNowBlock = "<c:out value='${block}'/>";
			var pRef = "<c:out value='${gref}'/>";
			var pStep  = "<c:out value='${step}'/>";
			var pLevel = "<c:out value='${level}'/>";
			var pCode  = "<c:out value='${code}'/>";	
			var pBname  = "<c:out value='${bName}'/>";	
			var pUserNM = "<c:out value='${userInfo.displayName1}'/>";
			var pUserNM2 = "<c:out value='${userInfo.displayName2}'/>"; 
			var strContentLocation ="";
			var g_progresswin;
			var pTitle = "<c:out value='${cBoard.title}'/>";
			var wDate = "<c:out value='${cBoard.writeDay}'/>";
			var fileName = "<c:out value='${fileName}'/>";
			var writerFakeName = "<c:out value='${writerFakeName}'/>";
			var dirPath = "<c:out value='${dirPath}'/>";
			var defaultFontAndSize  = "${defaultFontAndSize}";
			var useEditor = "<c:out value='${useEditor}'/>";
			var pAttachFileList ="";
			
			var pBoardID = "mainboard";
			
			var pAttachListXml = "";
			var AttachLimit = "10";
			var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
			var PhotoBoard = "N";
			var isfileup = false;
			var xhr = new XMLHttpRequest();
			
			window.onresize = function () {
				if (useEditor != "HWP") {
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 220 + "PX";
				} else {
				    var mHeight = document.getElementById("EdtorSize").clientHeight - 5 + "PX";
				    message.Resize(mHeight);
				}
			}
			
			window.onload = function() {
				document.getElementById("title").focus();

                if (pMode == "write" && pNo != "" && (pBname == "tbl_c_clubpds" || pBname == "tbl_c_clubpds1")) {
//첨부파일 부분을 아예 사용안함
// 				    document.getElementById("divBody").innerHTML = makeAttachDIV(document.getElementById("preAttachList").innerText);	
// 				    document.getElementById("attachedFile").innerHTML = makeAttachDIV2(document.getElementById("preAttachList").innerText);
				}
                
/* 				if (pMode == "edit" || pNo != "") {
					document.getElementById("title").value = ConvMakeXMLString(pTitle);
				} */
				if (pMode == "edit") {
		            pAttachListXml = MakeAttachList();
		            AppendFileAttachInfo(pAttachListXml);
		        }
				
				setAttachSortable();
				
                window.onresize();
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

				if (ntype == 0) {
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
					if (pBname == "tbl_c_clubpds" || pBname == "tbl_c_clubpds1" || pBname == "tbl_c_board") {
						pAttachFileList = AttachFileList();
					}
					if (useEditor != "HWP") {
						 /* 2019-04-02 홍승비 - MHT파일 변환 및 저장 시 예외처리 추가 */
						 var messageMHT = "";
				        try {
							messageMHT =  message.ConvertHTMLtoMHT("<HTML>" + "<BODY>" + EmbedContentIntoXML(message.GetEditorContent()) + "</BODY>" + "</HTML>");
				        } catch (e) {
				        	alert("<spring:message code='ezCommunity.lhj04'/>");
		      				return;
				        }
				        
				        saveFile(messageMHT);
					} else {
						GetHTML(saveFile);
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
				
				strContentLocation = dirPath + "/" + strReturn + "/" + fileName;
			}
			
			var isComplete = false;
			function Editor_Complete() {
				if (useEditor != "HWP") {
					if (pNo != "") {
						GetFileURL();
				        
				        var fullPath = strContentLocation;
				        var htmlData = message.GetEditorContentURL(fullPath);
				        
				        /* 2019-10-28 홍승비 - 커뮤니티 공지사항 답변 작성 시 p 태그와 기본 폰트 스타일 추가 */
				        if(pMode == "write" && pNo != "") {
				            //htmlData = "<br><br>-----<B>[&nbsp;" + "<spring:message code = "ezCommunity.t1161"/>" + "</B>-----<br><B> " + "<spring:message code = "ezCommunity.t1162"/>" + "</B>" + wDate + "<br><B> " + "<spring:message code = 'ezCommunity.t218'/>" + "</B>" + writerFakeName + "<br><B> " + "<spring:message code = "ezCommunity.t885"/>" + "</B>" + ConvMakeXMLString(pTitle) + "<br><br>" + htmlData;
				            var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
				            replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code = 'ezCommunity.t1161'/></B>-----</p>";
							replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code = 'ezCommunity.t1162'/></B>" + wDate + "</p> ";
							replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code = 'ezCommunity.t885'/></B><c:out value='${cBoard.title}'/></p>";
							replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
							htmlData = (replyHeader + htmlData);
				            message.SetEditorContent(htmlData);
				        } else {
				            message.SetEditorContentURL(fullPath);
				        }
					}
		        } else {
		        	var URL;
		        	if(pNo != "") {
						GetFileURL();
				        var fullPath = strContentLocation;
		        		URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(fullPath);
		        	} else {
		        		URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
		        	}
		        	message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	                
		        }
			}
			
			function ConvMakeXMLString(str) {
                str = ReplaceText(str, "&amp;", "&");
                str = ReplaceText(str, "&lt;", "<");
                str = ReplaceText(str, "&gt;", ">");
                str = ReplaceText(str, "&quot;", "\"");
                str = ReplaceText(str, "&#034;", "\"");
                str = ReplaceText(str, "&#039;", "\'");
                return str;
            }
			
			function FieldsAvailable(isTrue) {
				if (isTrue) {
					if (pMode == "write" && pNo == "") {
            			message.SetMargin(3000);
            		} else if (pMode != "edit" && pNo != "") {
            			var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
            			replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code = 'ezCommunity.t1161'/></B>-----</p>";
            			replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code = 'ezCommunity.t1162'/></B>" + wDate + "</p> ";
            			replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code = 'ezCommunity.t885'/></B><c:out value='${cBoard.title}'/></p>";
            			replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
            			
            			message.moveTopOfFile();
            			message.createField("reply");
            			message.AppendFieldText("reply", replyHeader, "", "HTML", "", function() {
	            			message.moveEndOfFile();
            			});
            			
            		}
            		message.EditMode(1);
            		message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            message.ShowToolBar(true);
		            message.ShowRibbon(true);
		            message.FoldRibbon(true);
		            window.onresize();
				}
			}
			
			function saveFile(content) {
				var textContent = "";
				if (useEditor != "HWP") {
					textContent = message.GetEditorContent();
				} else {
					textContent = content;
				}
				
				$.ajax({
 					type : "POST",
 					dataType : "text",
 					async : false,
 					url : "/ezCommunity/bbsEditOk.do",
 					data : {attachList	:	pAttachFileList,
 							content	:	content,
 							title	:	title.value,
 							textContent	:	textContent,
 							mode	:	pMode,
 							no	:	pNo,
 							sRadio	:	pSradio,
 							keyword	:	pKeyword,
 							id	:	pID,
 							goToPage	:	pGoToPage,
 							nowBlock	: pNowBlock,
 							ref	:	pRef,
 							step	:	pStep,
 							level	:	pLevel,
 							code	:	pCode,
 							bName	:	pBname,
 							userNM	:	pUserNM,
 							userNM2	:	pUserNM2,
							companyID : "<c:out value='${companyID}'/>",
							boardID : pBoardID
 						   },
 					success : function(result){
 						if (result != "OK") {
 	 						alert("<spring:message code = 'ezCommunity.t152'/>");
 	 					} else {
 	 						alert("<spring:message code = 'ezCommunity.t153'/>");
 						    
 	 					    if (window.opener.parent.left != undefined) {
 	 					        window.opener.parent.left.getBoardList();
 	 					    }
 						    
 	 					  window.opener.location.reload(false);
 	 					  window.close();
 	 					}
 					},
 					error : function(xhr, status, error) {
						if (status != 200) {
							alert("<spring:message code = 'ezCommunity.t152'/>");
						}
 					}
 				});
			}
			
			function GetHTML(callback) {
                ingFlag = true;
			    message.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data); });
			}
			
			function btn_AttachSelect_onclick() {
                document.getElementById('mode').value = "ATT";
                document.form.file1.click();
            }
            
            function returnvalue(strXML) {
                var xml = loadXMLString(strXML);
                var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
                var extFlag = false;
                
                for (var i = 0; i < nodes.length; i++) {
                    if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "true") {
                        if (SelectSingleNodeValue(nodes[i], "FILESIZE") == 0) {
                            alert(strLang1);
                            return;
                        }
                    } else if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "overflow") {
                        alert(strLang27 + AttachLimit + strLang28);
                        return;
                    } else if(SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "denied") {
                        extFlag = true;                            
                    } else {
//                         alert(getNodeText(GetChildNodes(nodes[i])[2]) + strLang6 + "\n\n" + result);
                        alert(SelectSingleNodeValue(nodes[i], "PFILENAME") + strLang6 + "\n\n");
                        return;
                    }
                }
                
                if(extFlag) {
                	alert(strLang75);
                }
                
                AttachFileInfo(strXML);
            }
            
            /* 2023-08-16 홍승비 - 현재 게시물의 첨부파일 사이즈 총합을 계산하여 uploadedFileSize 변수에 설정하는 함수 */
		    function initAttachFileSize() {
		    	uploadedFileSize = 0; // 첨부파일 사이즈 전역변수 초기화
		    	var attachListInput = $("#lstAttachLink input");
		    	
		    	$.each(attachListInput, function(index, item) {
		    		var pRealFileSize = item.getAttribute("realfilesize");
		    		
		    		if (typeof(pRealFileSize) != "undefined" && pRealFileSize != null) {
		    			uploadedFileSize += parseInt(item.getAttribute("realfilesize"));
		    		}
		    	});
		    }
            
		    function MakeAttachList() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();
	            var str = "";
	            var i=0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";

	            xmlhttp.open("GET", "/ezCommunity/getItemAttachments.do?itemID=" + encodeURIComponent(pNo), false);
	            xmlhttp.send();

	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;
	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;
				
	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");

	            str += "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezCommunity.t1135' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezCommunity.t1136'/></NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
			
	            for(i=0;i<xmldomNodes.length;i++) {
		            filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
		            filename = MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileName"));
		            
	                str += "<ROW><CELL>";	
	                /* 2018-04-30 홍승비 - 커뮤니티 게시판 첨부파일명 특문처리 수정 */
	                str += "<VALUE><![CDATA[" + filename + "]]></VALUE>";
	                str += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
	                str += "<DATA2>" + MakeXMLString(filepath) + "</DATA2>";
	                str += "<DATA3></DATA3>";
	                str += "<DATA4></DATA4>";
	                str += "<DATA5>Y</DATA5>";
	                str += "<DATA6>" + SelectSingleNodeValue(xmldomNodes[i], "FileSize2") + "</DATA6>";
	                str += "</CELL>";
	                str += "<CELL><VALUE></VALUE>";
	                str += "</CELL></ROW>";
	            }
	            
	            str += "</ROWS></LISTVIEWDATA>";
	            
	            return str;
	        }
		    
		</script>
		
<!-- 		사용안함 -->
		<%-- <c:if test="${mode == 'edit' && no != '' && (bName == 'tbl_c_clubpds' || bName == 'tbl_c_clubpds1')}">
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
		</c:if> --%>
		
	</head>
	<body class = "popup" style = "height:97%">
		<table class="layout">
			<tr>
				<td style="height:20px;">
					<div id="menu">
						<ul>
							<li><span onClick="SaveMHT_onclick();" ><spring:message code = "ezCommunity.t20"/></span></li>
						</ul>
					</div>
					<div id="close">
						<ul>
			     			<li><span onClick="btnClose_onclick();"></span></li>
				 		</ul>
					</div>
					
					<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
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
							<td><INPUT id=title style="WIDTH: 100%;box-sizing:border-box;-moz-box-sizing:border-box;" type=text maxLength=99 value="<c:out value="${(pMode == 'edit' || pNo != '')? cBoard.title : ''}"/>"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table style="width:100%;height:100%;margin-top:-1px;">
		                <tr> 
							<td style="vertical-align:top;height:100%" id="EdtorSize">
								<c:if test="${useEditor ne 'HWP'}">
					        		<iframe id="message" class="viewbox"  name="message" src="/ezEditor/selectEditor.do" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;border-top:0px"></iframe>
								</c:if>
								<c:if test="${useEditor eq 'HWP'}">
									<iframe id="message" class="viewbox"  name="message" src="/ezCommunity/WHWPEditor.do" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;border-top:0px"></iframe>
								</c:if>
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
		<tr>
			<td style="height: 20px; vertical-align: top;">
				<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
				<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" style="visibility: hidden;">
					<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="multiple" />
					<input type="hidden" name="boardID" id="boardID" />
					<input type="hidden" name="maxSize" id="maxSize" />
					<input type="hidden" name="mode" id="mode" />
					<input type="hidden" name="cnt" id="cnt" />
					<input type="hidden" name="mailGubun" id="mailgubun" />
				</form>
				<div style="width:100%;white-space:nowrap;display:inline-block; height: 23px;">
					<div style="float:left">
						<a class="imgbtn imgbck" id="btn_AttachAdd" onclick="btn_AttachSelect_onclick()"><span><spring:message code='ezCommunity.t1177' /></span></a>
						<a class="imgbtn imgbck" id="btn_AttachDel" onclick="btn_AttachDel_onclick()"><span><spring:message code='ezCommunity.t1178' /></span></a>
					</div>
					<div id="progdiv" class="progarea" style="display:none">
						<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
					</div>
				</div>
				<div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
				<table id="filelist" class="sublist" style="width: 100%;"><tr><th style="width: 15px;"><div class="custom_checkbox"><input type="checkbox" id="checkboxall"></div></th><th style="width: 87%;"><spring:message code='ezCommunity.t1135' /></th><th style="width: 13%;"><spring:message code='ezCommunity.t1136' /></th></tr></table>
				<p id="attachInnerNotice" class="attachInnerNotice_p_on"><span class="attachInnerNotice_span"><spring:message code='ezJournal.AttachMJS01' /></span></p></div>
				<input id="file" type="file" onchange="filechange(event)" multiple="" style="display:none">
				<input type="hidden" value="upload" onclick="fileupload()">
				<div id="txtAttachList"></div>
			</td>
		</tr>
		</table>
		
	    <script type="text/javascript">
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 220 + "PX";
		</script>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>   
	</body>
</html>