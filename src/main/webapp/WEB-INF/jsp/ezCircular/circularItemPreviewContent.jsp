<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <link href="/css/previewmail.css" rel="stylesheet" type="text/css">
	    <style type="text/css">
	    	.list {
	    		font-size:12px;
				font-family: 'Gulim', 'arial', 'verdana';
				text-decoration: none;
	    	}
	    	
	    	table th, td {
	    		font-size:12px;
				font-family: 'Gulim', 'arial', 'verdana';
				text-decoration: none;
	    	}
	    </style>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    
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
	        	$("#circularUserList").attr("tabindex", -1).focus();
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
	                var _img3;
	
	                _img1 = document.createElement("IMG");
	                _img1.id = "smallImg";
	                _img1.onclick = function () { Smaller(); };
	
	                _img1.style.cursor = "pointer";
	                _img1.style.margin = "5px";
	                _img1.src = "/images/minus.png";
	
	                _img2 = document.createElement("IMG");
	                _img2.id = "biglImg";
	                _img2.setAttribute("onclick", "Bigger()");
	                _img2.onclick = function () { Bigger(); };
	                
	                _img2.style.cursor = "pointer";
	                _img2.style.margin = "5px";
	                _img2.style.marginLeft = "-4px";
	                _img2.src = "/images/plus.png";
	                
	                _img3 = document.createElement("IMG");
	                _img3.id = "goComment";
	                _img3.onclick = function () { goComment(); };
	
	                _img3.style.cursor = "pointer";
	                _img3.style.margin = "7px";
	                _img3.src = "/images/ImgIcon/circular_opinion.gif";
	                
	                document.getElementById("txtContent").appendChild(_img1);
	                document.getElementById("txtContent").appendChild(_img2);
	                
	                if (option == "1" || option == "3") {
	                	document.getElementById("txtContent").appendChild(_img3);
	                }
	
	                var xmldom = loadXMLString(AttachText);
	                var _attchDIV;
	                
	                if (SelectNodes(xmldom, "NODES/NODE").length > 0) {
	                    var AttchHTML = SetAttachmentInfo(xmldom);
	                    _attchDIV = document.createElement("DIV");
	                    _attchDIV.id = "attchdivContent";
	                    _attchDIV.innerHTML = AttchHTML;
	                    document.getElementById("txtContent").appendChild(_attchDIV);
	                }
	
	                var _div = document.createElement("DIV");
	                _div.id = "divContent";
	                _div.innerHTML = responseText;
	                document.getElementById("txtContent").appendChild(_div);
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
	
	            strAttach += "<div class='previewmail_addfile' id='ifrmPreViewRayer' style='margin-bottom:10px;'>";
	
	            var totalSize = 0;
	            for (var j = 0; j < xmldomNodes.length; j++) {
	                totalSize += parseInt(getNodeText(SelectSingleNode(xmldomNodes[j], "FileSize")));
	            }
	
	            var strSize = "";
	            strAttach += "<p class='title'>" + strLang1+" - " + "<span><b>" + xmldomNodes.length + strLang2 + "(" + File_Size(totalSize) + ")</b></span><span class='icon_grayup' id='BtnAttachDetail' onclick='AttachDetail_view(this);'></span>";
	            strAttach += "<span class='title_btn' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' onclick='AttachAllDownload();'>" + strLang3 + "</span></p>";
	            strAttach += "<ul class='list' id='PreviewAttachList'>";
	
	
	            for (i = 0; i < xmldomNodes.length; i++) {
	            	filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	            	filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
// 	                filename = filepath.substr(filepath.indexOf("}_") + 2);
// 	                filename = ReplaceText(filename, "%2b", "+");
// 	                filename = ReplaceText(filename, "%3b", ";");
// 	                filename = ReplaceText(filename, "%7e", "~");
// 	                filename = ReplaceText(filename, "%3d", "=");
	                filepath = "/upload_board/" + filepath;
	                filesize = parseInt(getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize")));
	
	                var strTarget = "target=''";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
	                    strTarget = "target=''";
	                }
	                
	                strAttach += "<li>";
	                strAttach += "<span id='MailAttachDownloadItems' name='MailAttachDownloadItems' onclick=\"DownloadFile('/ezCircular/getCircularAttachInfo.do?CircularFileID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "CircularFileId")) + "')\"><img style='cursor:pointer' src='/images/icon_adddownload.gif' width='16' height='16' /></span>";
	                strAttach += "&nbsp;";
	                strAttach += "<span onmouseover=\"this.style.color='#164aad'\" onmouseout=\"this.style.color='#666'\" style='cursor: pointer; color: rgb(102, 102, 102);'>";
	                strAttach += "<a name='filename' href='/ezCircular/getCircularAttachInfo.do?CircularFileID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "CircularFileId")) + "'>" + filename + " (" + File_Size(filesize) + ")</a>";
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
	            if (obj.className == "icon_graydown") {
	                obj.className = "icon_grayup";
	                document.getElementById("PreviewAttachList").style.display = "";
	            }
	            else {
	                obj.className = "icon_graydown";
	                document.getElementById("PreviewAttachList").style.display = "none";
	            }
	        }
	
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
	        
	        function getCircularComment(circularID, userInfoID, status) {
				var divComment = document.createElement("DIV");
                divComment.id = 'divComment';
                divComment.innerHTML = '<table id="circularUserList" style="width:100%;margin-top:15px;table-layout: fixed;border:1px solid #e2e2e2"></table>';
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
	        }
	    </script>
	</head>
	<body>
		<div id="txtContent" name="txtContent" style="position:absolute;margin-left:5px;margin-right:5px;word-wrap:break-word;">
			<span style="margin-top:50px;height:10px;display:inline-block;"></span>    
		</div>
	</body>
</html>