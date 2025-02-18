<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezCircular.t19'/></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezCircular/PreviewItem.js')}"></script>
	    <style>
			#divContent p a {
				color: blue;
				text-decoration: underline;
				cursor: pointer;
			}
		</style>
	    <script type="text/javascript">
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        var MozNowZoom = 1;
	        var MozMaxZoom = 2;
	        var MozMinZoom = 0.8;
	
	        var strLang1 = "<spring:message code='ezCircular.t108'/>";
	        var strLang2 = "<spring:message code='ezCircular.t104'/>";
	        var strLang3 = "<spring:message code='ezCircular.t107'/>";
	        window.onload = function () {
	            document.getElementById("txtContent").style.textAlign = "center";
	            window.parent.previewItemSet();
	        };
	        
	        //보기설정 레이어팝업 바깥 클릭시 close되게 하기위한 코드 2018.03.05 강민수92
	        $(document).ready(function() {
	        	var maillistoption = parent.document.getElementById('maillistoptiondiv');
	        	
	        	$(document).mouseup(function(e) {
	        		var container = $('#layer_Viewpopup');
	        		var maillistoptionmode = $(maillistoption).attr('mode');
	        		if (maillistoptionmode == "on") {
	        			if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
	        			    parent.document.getElementById("layer_Viewpopup").style.display = "none";
	        			    parent.document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
	        			    parent.document.getElementById("maillistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif"); 
	        			}
	        		}
	        	})
	        });
	
	        function Bigger() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom < MozMaxZoom) {
	                    MozNowZoom += 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("divContent").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom < maxZoom) {
	                    nowZoom += 10;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.zoom = nowZoom + "%";
	            }
	        }
	
	        function Smaller() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom > MozMinZoom) {
	                    MozNowZoom -= 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("divContent").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom > minZoom) {
	                    nowZoom -= 10;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.zoom = nowZoom + "%";
	            }
	        }
	        
	        function goComment() {
	        	$("#commentLists").attr("tabindex", -1).focus();
	        }
	        
	        function makeWriteContent(responseText, AttachText, option) {
	        	try {
	                nowZoom = 100;
	                maxZoom = 200;
	                minZoom = 80;
	                MozNowZoom = 1;
	                MozMaxZoom = 2;
	                MozMinZoom = 0.8;
	
	                document.getElementById("txtContent").style.textAlign = "";
	                document.getElementById("txtContent").innerHTML = "";
	                var _img1;
	                var _img2;
// 	                var _img3;

					var xmldom = loadXMLString(AttachText);
	                var _attchDIV;
	                
	                if (SelectNodes(xmldom, "NODES/NODE").length > 0) {
	                    var AttchHTML = SetAttachmentInfo(xmldom);
	                    _attchDIV = document.createElement("DIV");
	                    _attchDIV.id = "attchdivContent";
	                    _attchDIV.innerHTML = AttchHTML;
	                    document.getElementById("txtContent").appendChild(_attchDIV);
	                }
	
	                _img1 = document.createElement("IMG");
	                _img1.id = "smallImg";
	                _img1.onclick = function () { Smaller(); };
	
	                _img1.style.cursor = "pointer";
	                _img1.style.margin = "5px 4px 5px 0px";
	                _img1.src = "/images/minus.png";
	
	                _img2 = document.createElement("IMG");
	                _img2.id = "biglImg";
	                _img2.setAttribute("onclick", "Bigger()");
	                _img2.onclick = function () { Bigger(); };
	                
	                _img2.style.cursor = "pointer";
	                _img2.style.margin = "5px";
	                _img2.style.marginLeft = "-4px";
	                _img2.src = "/images/plus.png";
	                
	                /* _img3 = document.createElement("IMG");
	                _img3.id = "goComment";
	                _img3.onclick = function () { goComment(); };
	
	                _img3.style.cursor = "pointer";
	                _img3.style.margin = "7px";
	                _img3.src = "/images/ImgIcon/circular_opinion.gif"; */
	                
	                document.getElementById("txtContent").appendChild(_img1);
	                document.getElementById("txtContent").appendChild(_img2);
	                
	                /* if (option == "1" || option == "3") {
	                	document.getElementById("txtContent").appendChild(_img3);
	                	
	                	var span1 = document.createElement("SPAN");
	                	span1.style.marginTop("10px");
	                	span1.style.position("absolute");
	                	
	                    var count = document.createTextNode("[1]");
	                    span1.appendChild(count);
	                    document.getElementById("txtContent").appendChild(span1);
	                } */
	
	                var _div = document.createElement("DIV");
	                _div.id = "divContent";
	                _div.innerHTML = responseText;
	                document.getElementById("txtContent").appendChild(_div);

		         	// 미리보기 창에서 링크 새창으로 띄우기 위해 추가
					if ($("#divContent p a").length > 0) {
						$("#divContent p a").attr("target", "_blank")
					}
	            } catch (e) {}
	        }
	
	        function SetAttachmentInfo(responseText) {
	            var xmldom = responseText;
	            var i = 0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";
	            var strAttach = "";
	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	            var regData = GetbrowserLanguage();
	
	            strAttach += "<div class='attachedfile' id='ifrmPreViewRayer' style='margin:-14px; margin-bottom:10px; margin-top:-10px;'>";
	
	            var totalSize = 0;
	            for (var j = 0; j < xmldomNodes.length; j++) {
	                totalSize += parseInt(getNodeText(SelectSingleNode(xmldomNodes[j], "FileSize")));
	            }
	
	            var strSize = "";
	            strAttach += "<ul class='attachedfile_title'><li class='titleText'><span class='titleT'>" + strLang1 + "<span class='cblue'> " + xmldomNodes.length + "</span> (" + File_Size(totalSize) + ")</span><span class='attach_btn_up' id='BtnAttachDetail' onclick='AttachDetail_view(this);'></span>";
	            strAttach += "<li class='titleSave' onclick='AttachAllDownload();'><span>" + strLang3 + "</span></li></ul>";
	            strAttach += "<ul class='attachedfile_list' id='PreviewAttachList'>";
	
	
	            for (i = 0; i < xmldomNodes.length; i++) {
	            	filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	            	filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
// 	                filename = filepath.substr(filepath.indexOf("}_") + 2);
// 	                filename = ReplaceText(filename, "%2b", "+");
// 	                filename = ReplaceText(filename, "%3b", ";");
// 	                filename = ReplaceText(filename, "%7e", "~");
// 	                filename = ReplaceText(filename, "%3d", "=");
	                filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
	
	                var strTarget = "target=''";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
	                    strTarget = "target=''";
	                }
	                
	                strAttach += "<li>";
	                strAttach += "<span id='MailAttachDownloadItems' name='MailAttachDownloadItems' onclick=\"DownloadFile('/ezCircular/downloadAttach.do?circularFileID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "CircularFileId")) + "')\"><img style='cursor:pointer;vertical-align:middle' src='/images/icon_adddownload.gif' width='16' height='16' /></span>";
	                strAttach += "&nbsp;";
	                strAttach += "<span onmouseover=\"this.style.color='#164aad'\" onmouseout=\"this.style.color='#666'\" style='cursor: pointer; color: rgb(102, 102, 102);'>";
	                //2018-07-12 김보미 - a태그 속성값 추가(파일 모두저장)
// 	                strAttach += "<a name='filename' href='/ezCircular/downloadAttach.do?circularFileID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "CircularFileId")) + "'>" + filename + " (" + File_Size(filesize) + ")</a>";
	                strAttach += '<a name="filename" href="/ezCircular/downloadAttach.do?circularFileID=' + getNodeText(SelectSingleNode(xmldomNodes[i], "CircularFileId")) + '" filePath="' + filepath + '" fileName="' + filename + '">' + filename + ' (' + filesize + ')</a>';
	                strAttach += "</span>";
	                strAttach += "</li>";
	            }
	            strAttach += "</ul></div>";
	            return strAttach;
	        }
	
	        function File_Size(totalSize) {
	            var strSize = "";
	            if (totalSize > 1024 * 1024) {
	                totalSize = parseInt(totalSize / 1024 / 1024);
	                strSize = totalSize + "MB";
	            }
	            else if (totalSize > 1024) {
	                totalSize = parseInt(totalSize / 1024);
	                strSize = totalSize + "KB";
	            }
	            else
	                strSize = parseInt(totalSize) + "B";
	
	            return strSize;
	        }
	
	        function DownloadFile(href)
	        {
	            location.href = href;
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function AttachDetail_view(obj) {
	            if (obj.className == "attach_btn_down") {
	                obj.className = "attach_btn_up";
	                document.getElementById("PreviewAttachList").style.display = "";
	            }
	            else {
	                obj.className = "attach_btn_down";
	                document.getElementById("PreviewAttachList").style.display = "none";
	            }
	        }
			//2018-07-12 김보미 - 모두저장시 zip파일로 다운
			function AttachAllDownload() {
				var allobj = document.getElementsByName("filename");
				
				var filePath = ""; // 파일경로
				var fileNames = []; // UUID + 파일이름
				var fileNames2 = []; //파일이름
				for (var i = 0; i < allobj.length; i++) {
					filePath = GetAttribute(allobj[i], "filepath");
					fileNames.push(filePath.split("/")[2]);
					filePath = "/" + filePath.split("/")[1] + "/";
					fileNames2.push(GetAttribute(allobj[i], "filename"));
				}
				
				var $frm = $("<form></form>");
		    	$frm.attr('action', "/ezCircular/downloadAttachAll.do");
		    	$frm.attr('method', 'post');
		    	$frm.appendTo('body');
		    	
		    	var param1 = $("<input type='hidden' />");
		    	$(param1).attr("name", "filePath");
		    	$(param1).val(filePath);
		    	var param2 = $("<input type='hidden' />");
		    	$(param2).attr("name", "fileNames");
		    	$(param2).val(JSON.stringify(fileNames));
		    	var param3 = $("<input type='hidden' />");
		    	$(param3).attr("name", "fileNames2");
		    	$(param3).val(JSON.stringify(fileNames2));
		    	
		    	$frm.append(param1).append(param2).append(param3);
		    	$frm.submit();
			}
			/*
	        function AttachAllDownload(attachObj) {
	            var allobj = document.getElementsByName("filename");
	            downloadAll(allobj);
	        }
	
	        var suffix = 0;
	        function downloadAll(allobj) {
	            if (allobj[suffix]) {
	                location.href = GetAttribute(allobj[suffix], "href");
	                suffix++;
	                setTimeout(function () { downloadAll(allobj) }, 1000);
	            }
	            else
	                suffix = 0;
	        }
	 		*/
	        
	        /* function getCircularComment(circularID, userInfoID, status) {
				var divComment = document.createElement("DIV");
                divComment.id = 'divComment';
                divComment.style.borderTop = "1px solid";
                divComment.innerHTML = '<p id = "commentLists"><spring:message code = "ezCircular.t180" /></p><table id="circularUserList" style="width:100%;margin-top:15px;table-layout: fixed;"></table>';
                document.getElementById("txtContent").appendChild(divComment);
	        	
	        	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularComment.do",
            		dataType : "json",
            		data : {
            			circularID : circularID,
            			searchValue : ""
            		},
            		success : function(result) {
            			circularUserList = "<colgroup><col width='20%' /><col width='60%' /><col width='20%' /></colgroup>";
            			
            			list = result.circularUserList;
            			list.forEach(function(vo, index) {
            				circularUserList += "<tr class='circularUser' circularUserID='" + vo.memberID + "' style='height:40px;text-align:left;vertical-align:middle;'>";
            				circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:left;background-color:white;'>";
            				
            				if (vo.status == 1) {
            					//확인 이미지
            					circularUserList += "<img src='/images/ImgIcon/circular_read.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				} else {
            					//미확인 이미지
            					circularUserList += "<img src='/images/ImgIcon/circular_unread.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "&nbsp;";
            				}
            				
            				circularUserList += "</th>";
            				circularUserList += "<th style='border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:right;background-color:white;' colspan='2'>";
            				//확인일
            				if (vo.status == 1) {
            					circularUserList += vo.confirmDate.substring(0, 16);
            				}
            				
            				circularUserList += "</th>";
            				circularUserList += "</tr>";
            			});
            			
            			$("#circularUserList").html("");
            			$("#circularUserList").append(circularUserList);
            			
            			var now = new Date();

            			circularCommentList = "";
            			list = result.circularCommentList ;
            			list.forEach(function(vo, index) {
            				circularCommentList  = "<tr class='circularComment' circularUserID='" + vo.circularUserID + "' memberID='" + vo.memberID + "' circularCommentID='" + vo.circularCommentID + "' circularCommentStatus='" + vo.status + "'>";
           					circularCommentList += "<td style='padding-left:3px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>&nbsp;&nbsp;<img src='/images/ImgIcon/commentRe.gif' style='vertical-align:middle;'/>&nbsp;" + vo.memberName + "</td>";
            				circularCommentList += "<td style='text-align:left;padding:8px; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.circularComment + "&nbsp;&nbsp;";
            				
            				var arry = vo.regDate.substring(0, 10).split('-');
            				var d = new Date(arry[0], arry[1]-1, arry[2]);
            				var getDiffTime = now.getTime() - d.getTime();
            				
            				if (getDiffTime / (1000 * 60 * 60 * 24) < 3) {
            					circularCommentList += "<img src='/images/ImgIcon/circular_newIcon1.gif' />&nbsp;";
            				}
            				
            				circularCommentList += "</td>";
            				circularCommentList += "<td style='text-align:right; border-bottom:1px solid #e2e2e2; background-color:#fafafa;'>" + vo.regDate.substring(0, 16) + "</td>";
            				circularCommentList += "</tr>";
            				
            				if (vo.status == 0) {
            					if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            						$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
            					} else {
            						$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
            					}
            				} else {//비공개
            					if (vo.memberID == userInfoID || vo.circularUserID == userInfoID) {
            						if ($(".circularComment[circularUserID='" + vo.circularUserID + "']").length == 0) {
            							$(".circularUser[circularUserID='" + vo.circularUserID + "']").after(circularCommentList);
            						} else {
            							$(".circularComment[circularUserID='" + vo.circularUserID + "']:last").after(circularCommentList);
            						}
            					}
            				}
            			});
            		},
            		error : function(jqXHR, textStatus, errorThrown) {
            			
            		}
            	});
	        } */
	    </script>
	</head>
	<body>
		<div id="txtContent" name="txtContent" style="margin:10px 14px;word-wrap:break-word;font-size:12px;">
			<span style="margin-top:50px;height:10px;display:inline-block;"></span>    
		</div>
		<!-- 2018-07-12 김보미 -->
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	</body>
</html>