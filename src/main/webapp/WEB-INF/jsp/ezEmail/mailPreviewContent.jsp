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
	    <script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script>
	    <script language="javascript" src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script language="javascript" type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/contextmenu.js')}"></script>
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
	        	
	        	if(memoFlag === "YES") {
		        	/* 마우스 오른쪽 메뉴 변수 */
					var conObject = document.getElementById("context-menus");
					init();
					
					/* 마우스 클릭 리스너를 초기 실행시킨다. */
					function init() {
						rightMouseListener();
						leftMouseListener();
					}
	
					/* 마우스 왼클릭 감지 */
					function leftMouseListener() {
						document.addEventListener("click", function(e) {
							toggleOnOff(0);
						})
					}
	
					/* 마우스 우클릭 감지 */
					function rightMouseListener() {
						document.addEventListener("contextmenu", function(e) {
							event.preventDefault();
							toggleOnOff(1);
							copy();
							showMenu(event.pageX, event.pageY);
						});
					}
	
					/* 마우스 메뉴 on & off */
					function toggleOnOff(num) {
						num === 1 ? conObject.classList.add("active") : conObject.classList.remove("active");
					}
	
					/* 마우스 클릭한 지점에서 메뉴 보여줌 */
					function showMenu(contextLeft, contextTop) {
						var contextmenu = document.getElementById("context-menus");
						var frameX = document.body.scrollWidth > 800 ? document.body.scrollWidth : window.innerWidth;
						var frameY = document.body.scrollHeight > 610 ? document.body.scrollHeight : window.innerHeight;
						var conWidth = contextmenu.offsetWidth;
						var conHeight = contextmenu.offsetHeight;
				
						// 컨텍스트의 위치가 프레임의 범위를 벗어날 경우 위치 조정
						if(contextLeft + conWidth >= frameX) {
							contextLeft = frameX - conWidth + 9;
						}
						if(contextTop + conHeight >= frameY) {
							contextTop = frameY - conHeight;
						}
						conObject.style.left = contextLeft + "px";
						conObject.style.top = contextTop + "px";
						mouseTop = contextTop + "px";
					}
					
					$(".menus").click(function(){
						var rightId = $(this).attr('id');
						toggleOnOff(0);
				  		
				  		switch(rightId) {
							case "menu1":
								copyToClip();
								break;
							case "menu2":
								btnPrint();
								break;
							case "menu3":
								copyToMemo("preview");
								break;
						}
					});
	        	}
		    }
		    
	        //보기설정 레이어팝업 바깥 클릭시 close되게 하기위한 코드 2018.03.05 강민수92
	        $(document).ready(function() {
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
		       
		    	if (obj.className == "icon_graydown") {
		            obj.className = "icon_grayup"
		            document.getElementById("PreviewAttachList").style.display = "";
		        } else {
		            obj.className = "icon_graydown"
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
				    		
				    		params = strArr[3] + "&" + strArr[4]; 
						} else {
				    		params += "&" + strArr[3] + "&" + strArr[4]; 
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
	    </script> 
	</head>

	<body style="margin:10px 13px" onload="javascript:window_onload()" onclick="frameClick();">
		<img src='/images/minus.png' title='<spring:message code='ezEmail.t99000065' />' onclick='Smaller()' style='cursor:pointer;' />
		<img src='/images/plus.png' title='<spring:message code='ezEmail.t99000064' />' onclick='Bigger()' style='cursor: pointer; margin-left: -4px;' />
		<c:if test="${shareId == null or (shareId != '' and sendPermission == 'Y')}">
			<span style="float:right;">
				<img src="/images/ImgIcon/PrereplyAll.gif" title="<spring:message code='ezEmail.t512' />" style='cursor:pointer;' onclick="Mail_Acton('ALLRE');" /><img src="/images/ImgIcon/Prereply.gif" title="<spring:message code='ezEmail.t511' />"  style='cursor:pointer;' onclick="Mail_Acton('RE');"/><img src="/images/ImgIcon/Preforward.gif" title="<spring:message code='ezEmail.t513' />"  style='cursor:pointer;' onclick="Mail_Acton('FW');"/>
			</span>
		</c:if>
		
		<div class="previewmail_addfile" id="ifrmPreViewRayer" style="<c:if test="${isAttach != 'OK'}">display:none;</c:if>margin-bottom:10px;font-family:<spring:message code='main.t246' />">
			<p class="title"><spring:message code='ezEmail.t99000003' /><span>${pAttachListHtmlSub}</span><span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);"></span>
	    	<span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload();"><spring:message code='ezEmail.t99000004' /></span></p>
			<ul class="list" id="PreviewAttachList">
	            ${pAttachListHtml}
			</ul>
		</div>
		<div id="MailBigAttachRayer" class="previewmail_addfile">
		</div>
		<div id="normalScreen" style="margin-top:5px; word-wrap:break-word;">
		${htmlBody}
		<!---->
		</div>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
		<!-- 마우스 오른쪽 메뉴 -->
	  	<div id="context-menus" class="context-menus">
	   		<table cellpadding="2" cellspacing="1" border="0" style="width:150px;" class="popuplist">
	   			<tr>
	      			<td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'"><span class="menus" id="menu1"><img src="/images/ezMemo/contextCopy.png" align="absmiddle" hspace="5"><spring:message code='ezMemo.t0060' /></span></td>
	      		</tr>
	      		<tr>
	      			<td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'"><span class="menus" id="menu2"><img src="/images/ezMemo/contextPrint.png" align="absmiddle" hspace="5"><spring:message code='ezMemo.t0061' /></span></td>
	      		</tr>
	      		<tr>
	      			<td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'"><span class="menus" id="menu3"><img src="/images/ezMemo/contextMemoAdd.png" align="absmiddle" hspace="5"><spring:message code='ezMemo.t0062' /></span></td>
	      		</tr>
	    	</table>	
	  	</div>
	  	<div class="previewmail_addImage" style="<c:if test="${isAttach != 'OK'}">display:none;</c:if>margin-bottom:10px;font-family:<spring:message code='main.t246' />">
			<p class="title"><spring:message code='ezEmail.0hun05' /></p>
			<div class="previewIamgelist" id="PreviewAttachList">${previewImageListHtml}</p>
		</div>  
	</body>
</html>