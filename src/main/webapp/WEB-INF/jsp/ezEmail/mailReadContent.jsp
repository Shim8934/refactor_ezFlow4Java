<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	        <link href="<%=CommonUtil.addVer(application, "/css/previewmail.css")%>" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="<spring:message code='ezEmail.e1' />"></script>
	        <script language="JavaScript" src="<%=CommonUtil.addVer(application, "/js/ezEmail/js_cross/reademail.js")%>"></script>
	        <script src="<%=CommonUtil.addVer(application, "/js/jquery/jquery-1.11.3.min.js")%>"></script>
	    	<script language="javascript" type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
	    	<script language="javascript" type="text/javascript">
			    var g_rejectWord = "${rejectKeyWord}";
			    var g_paramURL = "${url}";
			    var objLink = document.all("BigSizeFileLink");
				
			    if (objLink != null) {
					
			    	if (typeof(objLink.length) == "undefined") {
						objLink.target = "";
					} else {
						
						for ( var n = 0 ; n < objLink.length ; n++ )	{
							objLink(n).target = "";
						}
					}
				}
				
				function window_onload() {
				    if (window.parent.pContentClass == "IPM.Schedule.Meeting.Request") {
				        ContentClassbtn.style.display = "";
				    }
				    
				    if (typeof(window.parent.g_rejectWord) == "string") {
				        window.parent.g_rejectWord = g_rejectWord;
				    }

					sizeBtnAppend();
					sentDateView();
				}
				
				function sizeBtnAppend() {
					var minusBtn = "<img src='/images/minus.png' title='<spring:message code='ezEmail.t99000065' />' onclick='Smaller()' style='cursor: pointer; display:inline;'/>";
					var plusBtn = "<img src='/images/plus.png' title='<spring:message code='ezEmail.t99000064' />' onclick='Bigger()' style='cursor: pointer; display:inline;'/>";
					
					$("body").prepend(plusBtn);
					$("body").prepend(minusBtn);
				}
				
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
			
			        var xmlHTTP = new XMLHttpRequest();
			        xmlHTTP.open("POST", "/ezEmail/mailDelReadInterAttach.do", false);
			        xmlHTTP.send(xml);
			
			        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
			            var oRoot = xmlHTTP.responseXML.documentElement;
			            var ret = oRoot.childNodes[0].nodeValue;
			           
			            if (ret != "FAIL" && ret != "") {
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
		                document.getElementById("ifrmPreViewRayer").style.MozTransform = "scale(" + MozNowZoom + ")";
		                document.getElementById("ifrmPreViewRayer").style.MozTransformOrigin = "0 0";
		            } else {
		                
		            	if (nowZoom < maxZoom) {
		                    nowZoom += 10;
		                } else {
		                    return;
		                }
		            	
		                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
		                document.getElementById("ifrmPreViewRayer").style.zoom = nowZoom + "%";
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
		                document.getElementById("ifrmPreViewRayer").style.MozTransform = "scale(" + MozNowZoom + ")";
		                document.getElementById("ifrmPreViewRayer").style.MozTransformOrigin = "0 0";
		
		            } else {
		                
		            	if (nowZoom > minZoom) {
		                    nowZoom -= 10;
		                } else {
		                    return;
		                }
		            	
		                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
		                document.getElementById("ifrmPreViewRayer").style.zoom = nowZoom + "%";
		            }
		        }
		        
		        function Schedule_btn(pGubun) {
		            parent.mtg_onClick(pGubun);
		        }
		        
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
		        

		        function goProjectDetails(projectId) {
		        	parent.window.open("/ezPMS/getProjectDetails.do?projectId=" + projectId, "right");
		        	parent.window.open("/ezPMS/pmsLeft.do?mode=mail", "left");
		        }

		     	// 전달, 회신 시 보낸 시간
		        function sentDateView(msg) {
					var sendDateStrApp = $(".content", parent.document).parent();
					
					sendDateStrApp.find(".sentDateStr").remove();

		     		if (parent.sentDateMsg != "") {
		     			sendDateStrApp.prepend("<div class='sentDateStr'>" + parent.sentDateMsg + "</div>");
		     			sendDateStrApp.find(".sentDateStr").css({
		     				"height" : "27px",
			     		    "box-sizing" : "border-box",
			     		    "background" : "#fdfec1",
			     		    "border-top" : "1px solid #e9ea94",
			     			"border-left" : "1px solid #e9ea94",
			     			"border-right" : "1px solid #e9ea94",
			     		    "line-height" : "27px",
			     			"width" : "100%",
			     		    "padding" : "0px 0px 0px 10px",
			     			"margin" : "0px",
			     			"font-family" : "Gulim",
			     			"font-size" : "12px",
			     			"color" : "#333"
				    	});

				    }
		     		
			    	parent.mailPrevSentDateChk();
		        }
			</script> 
	</head>
	<body style="margin-left:10px;margin-top:10px" onload="javascript:window_onload()">
		<span id="ContentClassbtn" style="float:right;display:none;" >
			<img src='/images/mtgrsp-accept.gif' width="20" height="20" title="<spring:message code='ezEmail.t901' />" onclick="Schedule_btn('ACCEPT');" style='cursor:pointer;' />
			<img src='/images/mtgrsp-tent.gif' width="20" height="20" title="<spring:message code='ezEmail.t903' />" onclick="Schedule_btn('TENT');" style='cursor:pointer;' />
			<img src='/images/mtgrsp-decline.gif' width="20" height="20" title="<spring:message code='ezEmail.t902' />" onclick="Schedule_btn('DECLINE');" style='cursor:pointer;' />
		</span>
		<div class="previewmail_addfile" id="ifrmPreViewRayer" style="<c:if test="${isAttach != 'OK'}">display:none;</c:if>margin-bottom:10px;font-family:<spring:message code='main.t246' />">
			<p class="title"><spring:message code='ezEmail.t99000003' />
				<span>${pAttachListHtmlSub}</span>
				<span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);"></span>
				<span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload(this);"><spring:message code='ezEmail.t99000004' /></span>
			</p>
			<ul class="list" id="PreviewAttachList">${pAttachListHtml}</ul>
		</div>
		<div id="MailBigAttachRayer" class="previewmail_addfile">
		</div>
		<div class='margin' id="normalScreen" style="margin-top:5px; word-wrap:break-word;">${htmlBody}<!--  --></div>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>  
	</body>
</html>