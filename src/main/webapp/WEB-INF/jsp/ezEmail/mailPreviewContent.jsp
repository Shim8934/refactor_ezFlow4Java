<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/ezMemo/memoContext.css')}">
	    <script language="javascript" src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script language="javascript" type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/relay/webfolderFileUploadOpener.js')}"></script>
	    <style> 
			p { margin-bottom: 0; margin-top: 0; } 
		</style>
	    <script language="javascript" type="text/javascript">
	        var g_paramURL = "${url}";
	        var editor = "${Use_Editor}";
	        var pNoneActiveX = "${NoneActiveX}";
		    var sentDateMsg = "${sentDateMsg}"; // 전달, 회신 시 보낸 시간
		    var memoFlag = "<c:out value='${memoFlag}' />";
		    var shareId = "${shareId}";
		    var deletePermission = "${deletePermission}";
		    var sendPermission = "${sendPermission}";
		    var mouseTop;
		    
	        function window_onload() {
	        	if (shareId != "" && deletePermission != "Y") {
					var divsToHide = document.getElementsByClassName("icon_rbtn");
					
				    for(var i = 0; i < divsToHide.length; i++){
				        divsToHide[i].style.display = "none";
				    }
				}

				document.addEventListener('click', function (e) {
					if (window.parent.hiddenMoreMenu) {
						parent.hiddenMoreMenu(e);
					}
				})
				
		    }
		    
	        $(document).ready(function() {
	        	//보기설정 레이어팝업 바깥 클릭시 close되게 하기위한 코드 2018.03.05 강민수92
	        	var maillistoption = parent.document.getElementById('maillistoptiondiv');
	        	
	        	$(document).mouseup(function(e) {
	        		var container = $('#layer_popup');
	        		var maillistoptionmode = $(maillistoption).attr('mode');
	        		
	        		if (maillistoptionmode == "on") {
	        			if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
	        			    parent.document.getElementById("layer_popup").style.display = "none";
	        			    parent.document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
	        			    parent.document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif"); 
	        			}
	        		}
	        	})
	        	
			    sentDateView();
	        	
	        	// 메일 본문에 absolute이거나 fixed인 position 스타일을 찾아서 지운다.
				setTimeout(function() {
	        		$("#normalScreen").find('*').each(function() {
						var position = $(this).css('position');
						
						if (position == 'fixed') {
							$(this).css('position', '');
						}
					});
	        	}, 10);
	        	
				<c:if test="${unread == 1}">
		        try {
		            parent.parent.frames["left"].get_unreadcount();
		        } catch(e) {		            
		        }
		        </c:if>
	        });
	        
	        function btnPrint_onClick() {
		        window.self.focus();	
		        window.self.print();
			}
			
			window.onbeforeprint = function() {
			    printScreen.style.display = "";
			    normalScreen.style.display = "none";
			    
			    if (window.parent.tb_PrevShow) {
			        printMsgFrom.innerHTML = window.parent.div_SndName.innerHTML;
			        printMsgTo.innerHTML = window.parent.div_RcvName.innerHTML;
			        printMsgCC.innerHTML = window.parent.div_Ref.innerHTML;
			        printSubject.innerHTML = window.parent.div_Subject.innerHTML;
			        printInsertFile.innerHTML = window.parent.div_Attachment.innerHTML;
				
			    } else {
			        printMsgFrom.innerHTML = window.parent.MsgToPut.innerHTML;
			        printMsgTo.innerHTML = window.parent.MsgToGot.innerHTML;
			        
			        if (window.parent.MsgCCGot != null) {
			            printMsgCC.innerHTML = window.parent.MsgCCGot.innerHTML;
			        } else {
			            document.getElementById('printMsgCC').parentNode.parentNode.style.display = "none"
			        }
			        
			        printSubject.innerHTML = window.parent.mailSubject.innerHTML;
			        printDate.innerHTML = window.parent.g_date;
			        
			        if (window.parent.attachedfileDIV != null) {
			            printInsertFile.innerHTML = window.parent.attachedfileDIV.innerHTML;
			        } else {
			            document.getElementById('printInsertFile').parentNode.parentNode.style.display = "none"
			        }
			    }
			    
			    printDocument.innerHTML = normalScreen.innerHTML;
		
			    var checks = printInsertFile.all.tags("input");
			    
			    for (var i=0; i<checks.length; i++) {
			        checks.item(i).style.display = "none";
			    }
			    
			    var tableColl = printDocument.all.tags("TABLE");
			    
			    for (var i=0; i<tableColl.length; i++) {
			        
			    	if (String(tableColl.item(i).borderColorDark).toLowerCase() == "#ffffff") {
			        	tableColl.item(i).style.borderCollapse = "collapse";
			            tableColl.item(i).borderColorDark = "black";
			        }
			    }
			}
			
			window.onafterprint = function() {
			    printScreen.style.display = "none";
			    normalScreen.style.display = "";
			}
	        
	        function frameClick(){
	        	parent.event_secondRightClick();
	        }
		    
		    function AttachDetail_view(obj) {
		       
		    	if (obj.className == "attach_btn_down") {
		            obj.className = "attach_btn_up"
		            document.getElementById("PreviewAttachList").style.display = "";
		        } else {
		            obj.className = "attach_btn_down"
		            document.getElementById("PreviewAttachList").style.display = "none";
		        }
		    }
		    
		    function DownloadAttach(DownloadUrl) {
		        AttachDownFrame.location.href = DownloadUrl;
		    }
		    
		 	// 메일읽기창에서 "모두저장" 클릭시 압축파일로 내보내는 메서드
		    var suffix = 0;
		    function AttachAllDownload() {
		    	
		    	var url = "/ezEmail/downloadAttachAll.do";
		    	
		    	if (typeof(shareId) != "undefined" && shareId != "") {
		    		url += "?shareId=" + encodeURIComponent(shareId);
		    	}
		    	
		    	var fileLen = document.getElementsByName("MailAttachDownloadItems").length;
		    	var params = "";
		    	var folderPath = "";
		    	var uid = "";
		    	
		    	if (suffix < fileLen) {
		    		
		    		for (var i = 0; i < fileLen; i++) {
			    		var fileHref = document.getElementsByName("MailAttachDownloadItems").item(suffix++).getAttribute("_filehref");
			    		var strArr = fileHref.split('?');
			    		strArr = strArr[1].split('&'); 

			    		if (i < 1) {
				    		var tmpStr = strArr[1].split('=');
				    		folderPath = tmpStr[1];
				    		
				    		tmpStr = strArr[2].split('=');
				    		uid = tmpStr[1];
				    		
				    		params = strArr[3] + "&" + strArr[4] + "&" + strArr[5] + "&" + strArr[6]; 
						} else {
				    		params += "&" + strArr[3] + "&" + strArr[4] + "&" + strArr[5] + "&" + strArr[6]; 
						}
			    		
		    		}
		    		
		    	}
		    	
	    		suffix = 0;

	    		var $frm = $("<form></form>");
		    	$frm.attr('action', url);
		    	$frm.attr('method', 'post');
		    	$frm.appendTo('body');

		    	params = $('<input type="hidden" value="' + params + '" name="params" />');
		    	folderPath = $('<input type="hidden" value="' + decodeURIComponent(folderPath) + '" name="folderPath" />');
		    	uid = $('<input type="hidden" value="' + uid + '" name="uid" />');
		    	
		    	$frm.append(params).append(folderPath).append(uid);
		    	$frm.submit();
		    }
		    
		    function FileDownload(pFileUrl) {

		    	if (pFileUrl != null) {
		            location.href = pFileUrl;
		        } else {
		            suffix = 0;
		            return;
		        }
		
		    }
		    
		    function DownloadPC(obj) {
		        var param = { "href": new Array(), "filesize": new Array(), "name": new Array(), "folderpath": new String() };
		        var count = 0;
		        param["href"][count] = "/"+obj.getAttribute("_filehref");
		        param["filesize"][count] = obj.getAttribute("_filesize");
		        param["name"][count] = obj.getAttribute("_filename");
	
		        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		        ezUtil.UseUTF8 = true;
		        var folderpath = ezUtil.BrowseFolder();
		        
		        if (folderpath != "") {
		            param["folderpath"] = folderpath;
		            var feature = "dialogWidth:430px; dialogHeight:150px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
		            feature = feature + GetShowModalPosition(430, 150);
		            window.showModalDialog("htm/attachdownload.aspx", param, feature);
		        }
		    }
		    
		    function AttachFile_Delete(obj) {
	
		        if (!confirm("<spring:message code='ezEmail.t99000005' />")) {
		            return;
		        }
		        
		        var count = 0;
		        var param = new Array();
		        var ArrayDel = new Array();
	
		        var xml = "<FILE>";
		        xml += "<ROW>";
		        xml += "<NAME><![CDATA[" + obj.getAttribute("fileid") + "]]></NAME>";
		        xml += "</ROW>";
		        xml += "<ITEMID><![CDATA[" + g_paramURL + "]]></ITEMID></FILE>";
				
				var requestUrl = "/ezEmail/mailDelReadInterAttach.do";
		        
				if (typeof(shareId) != "undefined" && shareId != "") {
					requestUrl += "?shareId=" + encodeURIComponent(shareId);
				}
		        
		        var xmlHTTP = new XMLHttpRequest();
		        xmlHTTP.open("POST", requestUrl, false);
		        xmlHTTP.send(xml);
	
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var oRoot = xmlHTTP.responseXML.documentElement;
		            var ret = oRoot.childNodes[0].nodeValue;
	
		            if (ret != "FAIL") {
		            	window.parent.reloadReadContent(ret);
		            } else {
		                alert(strLang183);
		            }
		        }
		    }
		    
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        var MozNowZoom = 1;
	        var MozMaxZoom = 2;
	        var MozMinZoom = 0.8;
	        
	        function Bigger() {
	           
	        	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                
	        		if (MozNowZoom < MozMaxZoom) {
	                    MozNowZoom += 0.1;
	                } else {
	                    return;
	                }
	        		
	                document.getElementById("normalScreen").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("normalScreen").style.MozTransformOrigin = "0 0";
	            } else {
	                
	            	if (nowZoom < maxZoom) {
	                    nowZoom += 10;
	                } else {
	                    return;
	                }
	            	
	                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
	            }
	        }
	        
	        function Smaller() {
	           
	        	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                
	            	if (MozNowZoom > MozMinZoom) {
	                    MozNowZoom -= 0.1;
	                } else {
	                    return;
	                }
	                
	                document.getElementById("normalScreen").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("normalScreen").style.MozTransformOrigin = "0 0";
	
	            } else {
	                
	            	if (nowZoom > minZoom) {
	                    nowZoom -= 10;
	                } else {
	                    return;
	                }
	            	
	                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
	            }
	        }
	        
	        function Mail_Acton(Division) {
	            
	        	var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            
	            if (conWidth > 890) {
	                conWidth = 890;
	            }
	            
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;
	            var oForm = document.createElement("FORM");
	            oForm.name = "fomAction";
	            oForm.method = "POST";
	
	            var oInputHidden = document.createElement("INPUT");
	            oInputHidden.type = "hidden";
	            oInputHidden.name = "iptURL";
	            oInputHidden.value = g_paramURL;
	            oForm.appendChild(oInputHidden);
	            window.document.body.appendChild(oForm);
	            
	            var pURI = "";
	            
	            if (Division == "ALLRE") {
	                pURI = "/ezEmail/mailWrite.do?cmd=REPLYALL&URL=" + encodeURIComponent(g_paramURL);
	            } else if (Division == "RE") {
	                pURI = "/ezEmail/mailWrite.do?cmd=REPLY&URL=" + encodeURIComponent(g_paramURL);
	            } else if (Division = "FW") {
	            	pURI = "/ezEmail/mailWrite.do?cmd=FORWARD&URL=" + encodeURIComponent(g_paramURL);
	            }
	            
	            if (typeof(shareId) != "undefined" && shareId != "") {
	            	pURI += "&shareId=" + encodeURIComponent(shareId);
	        	}
	            
	            var newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() 
                		+ ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
                newwin.focus();
	        }
	        
	        //업무일지 상세보기
	        function journalMailLink(journalId,mine){
	        	$.ajax({
	        		type : "post",
	        		data : {
	        			"journalId" : journalId
	        		},
	        		url : "/ezJournal/checkToMailJournal.do",
	        		success: function(result){
	        			if (result.isLive!="N" ) {
	        				if (result.checkSusin != "N" || mine==1) {
	        					var feature = GetOpenPosition(820, 850);
	        					window.open("/ezJournal/journalDetail.do?journalId=" + journalId, "journalDetail",
	        							"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1"
	        							+ feature);
	        				} else {
	        					alert("<spring:message code='ezJournal.t172'/>");
	        				}
	        			} else {
	        				alert("<spring:message code='ezJournal.t171'/>");
	        			}
	        		}
	        	});
	        }
	        
	        //프로젝트 관리 이동
	        function goProjectDetails(projectId) {
	        	window.open("/ezPMS/getProjectDetails.do?projectId=" + projectId, "right");
	        	window.open("/ezPMS/pmsLeft.do?mode=mail", "left");
	        }
	        
	     	// 전달, 회신 시 보낸 시간
	        function sentDateView(msg) {
	     		var preViewInfoParent = $(".previewmail_info", parent.document).parent();
	     		preViewInfoParent.find(".sentDateStr").remove();
				
	     		if (sentDateMsg != "") {
	     			preViewInfoParent.prepend("<div class='sentDateStr' id='sentDateStr'>" + sentDateMsg + "</div>");
	     			preViewInfoParent.find(".sentDateStr").css({
			    		"height" : "27px",
			        	"box-sizing" : "border-box",
			        	"background" : "#fdfec1",
		        		"border-top" : "1px solid #e9ea94",
			        	"line-height" : "27px",
			    		"width" : "100%",
			        	"padding" : "0px 0px 0px 10px",
			    		"margin" : "0px",
			    		"font-size" : "12px",
			    		"color" : "#333"
			    	});
			    }
	     		
		    	parent.mailPrevIframeSize();
	     	}
	     	
	        function AttachFile_Preview(mailPath, mailUid, fileIndex, fileName) {
				
	     		//window.open('http://jmocha.kaoni.com:8080/uFOCS3.0/viewer/document/docviewer.do?filepath=http://10.0.120.213:8080' + encodeURIComponent(downloadURL) + '&filename=' + fileName + '&fileext=txt&viewerselect=image');
	    		  $.ajax({
	    			  type : 'get',
	    			  url : '/ezEmail/attachFilePreview.do',
	    			  data : {
	    				  "fileName" : fileName,
	    				  "folderId" : decodeURIComponent(mailPath),
	    				  "mailId" : mailUid,
	    				  "fileIndex" : fileIndex
	    			  },
	    			  error: function(xhr, status, error){
	    			  },
	    			  success : function(result){ // sat , kukudocs

	    					  /* var link = document.createElement("a");

	    					  link.setAttribute("href",result);
	    					  link.setAttribute("target","_blink");
	    					  link.click(); */
						window.open(result, '_blank', getOpenWindowfeature(1100, 950));

	    			  }
	    		  });
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
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
	    </script> 
	</head>

	<body onload="javascript:window_onload()" onclick="frameClick();">
		<div class="attachedfile" id="ifrmPreViewRayer" style="<c:if test="${isAttach != 'OK'}">display:none;</c:if>margin-bottom:10px;font-family:<spring:message code='main.t246' />">
			<ul class="attachedfile_title">
				<li class="titleText"><span class="titleT"><spring:message code='ezEmail.t99000003' /><span>${pAttachListHtmlSub}</span></span><span class="attach_btn_up" id="BtnAttachDetail" onclick="AttachDetail_view(this);"></span></li>
	    		<li class="titleSave"><span onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload();"><spring:message code='ezEmail.t99000004' /></span></li>
	    	</ul>
			<ul class="attachedfile_list" id="PreviewAttachList">
	            ${pAttachListHtml}
			</ul>
		</div>
		
		<!-- ical -->
		<c:if test="${isIcalMail == 'Y'}">
			<div style="margin-bottom: 10px; margin: -8px; padding: 0px; clear: both; overflow: hidden;">
				<ul style="padding: 10px; margin: 0px; list-style: none; border-bottom: 1px solid #e5e5e5;">
					<li>
						<span title="<spring:message code='ezEmail.ical01' />" onClick="addIcalSchedule(g_paramURL, shareId)" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='rgb(102, 102, 102)'" 
						style="display: inline-block; cursor: pointer; color: rgb(102, 102, 102);font-size: 12px;background: rgb(255, 255, 255);border-width: 1px;border-style: solid;border-color: rgb(199, 199, 199) rgb(199, 199, 199) rgb(144, 145, 147);padding: 3px;letter-spacing: -0.5px;">
							<span style="cursor:pointer; width: 19px;height: 19px;background-image: url(/images/kr/left/sub_iconLNB.png);float: left;background-position: 0px -50px;" class="imgSpan"></span>
							<span style="height: 19px;display: inline;line-height: 19px;"><spring:message code='ezEmail.ical01' /></span>
						</span>  
					</li>
				</ul>
			</div>
		</c:if>
		
		<div id="MailBigAttachRayer" class="previewmail_addfile">
		</div>
		<div style="display:inline-block; font-size: 12px; font-family: 'malgun gothic', 'arial', 'verdana';">
		<img src='/images/minus.png' title='<spring:message code='ezEmail.t99000065' />' onclick='Smaller()' style='cursor:pointer; width:29px; height:29px;' />
		<img src='/images/plus.png' title='<spring:message code='ezEmail.t99000064' />' onclick='Bigger()' style='cursor: pointer; margin-left: -4px; width:28px; height:29px;' />
		</div>
		<c:if test="${shareId == null or (shareId != '' and sendPermission == 'Y')}">
			<span style="float:right;">
				<img src="/images/ImgIcon/PrereplyAll.gif" title="<spring:message code='ezEmail.t512' />" style='cursor:pointer; width:28px; height:29px;' onclick="Mail_Acton('ALLRE');" /><img src="/images/ImgIcon/Prereply.gif" title="<spring:message code='ezEmail.t511' />"  style='cursor:pointer; width:28px; height:29px;' onclick="Mail_Acton('RE');"/><img src="/images/ImgIcon/Preforward.gif" title="<spring:message code='ezEmail.t513' />"  style='cursor:pointer; width:29px; height:29px;' onclick="Mail_Acton('FW');"/>
			</span>
		</c:if>
		<div id="normalScreen" style="margin-top:5px; word-wrap:break-word;">
		${htmlBody}
		<!---->
		</div>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	  	<c:if test="${previewMailImage == 'Y' && previewImageListHtml != ''}">
		  	<div class="previewmail_addImage" style="margin-bottom:10px;">
				<p class="title"><spring:message code='ezEmail.0hun05' /></p>
				<div class="previewIamgelist" id="PreviewAttachList">${previewImageListHtml}</p>
			</div>  
		</c:if>
	</body>
</html>