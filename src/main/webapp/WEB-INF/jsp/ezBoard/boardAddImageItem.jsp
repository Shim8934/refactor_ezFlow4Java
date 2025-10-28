<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t1001' /></title>
	    <style type="text/css">
	         .preView {
	         	width: 70px;
	         	height: 70px;
	         	text-align: center;
	         	border:1px solid silver;
	         }
	          textarea {
	         	resize:none;
	         }
	    </style>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	    </c:if>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript">
	        var pMode = "new";
	        var bodycount = "0";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pItemID = "<c:out value='${itemID}'/>";
	        var pBoardID = "<c:out value='${boardID}'/>";
	        var PhotoBoard = "N";
	        var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName1}";
		    var SSUserName2 = "${userInfo.displayName2}";
		    var SSDeptID = "${userInfo.deptID}";
		    var SSDeptName = "${userInfo.deptName1}";
		    var SSDeptName2 = "${userInfo.deptName2}";
		    var SSCompanyID = "${userInfo.companyID}";
		    var SSCompanyName = "${userInfo.companyName1}";
		    var SSCompanyName2 = "${userInfo.companyName2}";
	        var g_fileList;
	        var pNoneActiveX = "YES";
	        var pUrl = "";
	        var lastItemID = "000";
	        var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
	        
	        window.onload = function () {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                document.getElementById("file1").multiple = false;
	            }
	            
	            // imageID 앞쪽에 순서 숫자 붙은 경우에만 substring하여 마지막 imageID 사용
	            if ("${lastItemID}" != "") {
	            	lastItemID = "${lastItemID}".substring(0,3);
	            }
	        };
	
	        function btn_PhotoAttachAdd() {
	            if (CrossYN()) {
	                document.getElementById('mode').value = "PHOTO";
	                document.form.file1.click();
	            } else {
	                var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	                ezUtil.UseUTF8 = true;
	                var file = "";
	                if (pMode == "modify")	
	                {
	                    file = ezUtil.OpenLoadDlg("" + strLang22 + "", "");
	                    if (file != "") {
	                        file = file + "|";
	                    }
	                }
	                else {
	                    file = ezUtil.OpenLoadDlgMultiNew("" + strLang22 + "", "");
	                }

	                if (!file)
	                    return;

	                pAttachListXml = "";
	                g_fileList = file.split("|");
	                var fileSize = 0;
	                if (pMode != "modify") {
	                    if (g_fileList.length > 20) {
	                        alert("" + strLang23 + "")
	                        return;
	                    }
	                }

	                for (var i = 0; i < g_fileList.length - 1; i++) {
	                    if (ezUtil.GetFileSize(g_fileList[i]) == 0) {
	                        alert("" + strLang6 + "");
	                        return;
	                    }
	                    //[2006.06.20] 파일명의 길이가 111byte를 초과할 경우 오류메시지 처리.
	                    var temp = ezUtil.ExtractFileName(g_fileList[i]);

	                    if (temp.length > 111) {
	                        alert("" + strLang7 + "");
	                        return;
	                    }
	                    //2006.11.28 포토게시판은 게시물 건당 첨부파일 용량을 체크한다.
	                    fileSize = ezUtil.GetFileSize(g_fileList[i]);

	                    //게시판별로 설정되어 있는 첨부용량 제한
	                    if (fileSize > parseInt(AttachLimit) * 1024 * 1024) {
	                        alert("" + strLang8 + "" + AttachLimit + "MB" + strLang9 + "");
	                        return;
	                    }
	                    //var result = addimageline(g_fileList[i]);
	                }

	                ezUtil = null;
	                txtPhotoFile.value = file;
	                var fileNamelist = "";
	                var fileName = "";
	                show_progress_photo(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\") + 1) + "" + strLang10 + "" + 1 + "/" + (g_fileList.length - 1));
	            }
	        }
	        
	        function uploadComplete() {
		        document.getElementById("file1").value = "";
		        returnvalue(xhr.responseText);
		    }
	
	        //사진 이미지 추가
	        function returnvalue(strXML) {
				/* 2021-12-08 홍승비 - 포토, 썸네일 게시물 이미지 추가 시 서버단에서도 이미지 확장자 체크 진행 */
				if (strXML.split(";")[0] == "UPLOAD_EXT_ERROR") {
					if (parseInt(strXML.split(";")[1]) > 1) { // 업로드 파일이 2개 이상인 경우
			        	alert("<spring:message code ='ezJournal.kms01' />"); // 업로드 제한 확장자 파일이 있습니다.
			        } else {
			        	alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
			        }
					return;
				}
	        	 
	            ImgaeReturnXml = loadXMLString(strXML);
	            var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
	
	            for (var i = 0; i < nodes.length ; i++) {
	                var rtnMode = getNodeText(GetChildNodes(nodes[i])[5]);
	                var imgFileName = getNodeText(GetChildNodes(nodes[i])[0]);
	                var localFileName = getNodeText(GetChildNodes(nodes[i])[2]);
	                var imgFileSize = getNodeText(GetChildNodes(nodes[i])[3]);
	                var imgUniqueID = getNodeText(GetChildNodes(nodes[i])[6]);
	
	                addimageline(imgFileName, localFileName, imgUniqueID, imgFileSize);
	            }
	
	            var attachXml = "<LISTVIEWDATA><ROWS>";
	            for (var i = 0 ; i < document.getElementById("addimagecontent").childNodes.length ; i++) {
	                attachXml += "<ROW><CELL>";
	                attachXml += "<DATA1>" + "/upload_board/" + pBoardID + "/uploadFile/" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA1>";
	                attachXml += "<DATA2>" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA2>";
	                attachXml += "<DATA3></DATA3>";
	                attachXml += "<DATA4></DATA4>";
	                attachXml += "<DATA5>Y</DATA5>";
	                attachXml += "<DATA6>" + GetAttribute(document.getElementsByName('imgView')[i], 'size') + "</DATA6>";
	                attachXml += "</CELL></ROW>";
	            }
	            attachXml += "</ROWS></LISTVIEWDATA>";  //pAttachListXml
	
	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLString(attachXml);
	            pAttachListXml = xmlDom;
	        }
	        
	        /* 2018-10-11 홍승비 - 이미지파일 확장자체크 추가 */
	        function imgtemp_onclick() {
	            if (document.form.file1.value != "") {
		            var fd = new FormData();
		            
		            for (var i = 0; i < document.getElementById("form").file1.files.length; i++) {
		            	var file1val = document.getElementById("file1").files[i].name;
				        var exIndex = file1val.lastIndexOf('.');
						var extension = file1val.substring(exIndex+1, file1val.length);
				        var check = false;
				        check = compareExtension(check, extension);
				        
				        if (!check) {
				        	document.getElementById("file1").files[i] = "";
				        	alert("<spring:message code ='ezBoard.hsbImg01' />");
				        	return;
				        }
				        else {
		                	fd.append("file1", document.getElementById("form").file1.files[i]);
				        }
		            }
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=PICTURE&boardID=" + encodeURIComponent(pBoardID) + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		        }
	        }
	
	        function addimageline(imgpath, localFileName, imgUniqueID, imgSize) {
	            var imagecount = "";
	            var imageid = "";
	
	            if (CrossYN()) {
	                imagecount = imgpath.split("/").length - 1;
	                imageid = imgpath.split("/")[imagecount];
	
	                if (document.getElementById(imageid) != "" && document.getElementById(imageid) != null)
	                    return "false";
	
	                var resultHTML = "<table style='margin-top:5px' width='100%' class='content' id='" + "M_" + imageid + "' name='" + imgpath + "'  uniqueId='" + imgUniqueID + "' ><tr>" +
	                                 "<td style='width:25px;padding:6px; margin:0px;'><div class='custom_checkbox'><input type='checkbox' value='" + "M_" + imageid + "' id='imagecheck" + bodycount + "'  name='checkmenuSub' /></div></td>" +
	                                 "<td style='width:100px; height: 100px;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 100px; height: 100px;' name='imgView'></img></td>" +
	                                 "<td><textarea id='getcontent' style='width:94%; height:80px; margin:5px' maxlength='50' name='imgContent' ></textarea></input></td></tr></table>";
	
	                var imagecontent = document.getElementById("addimagecontent");
	
	                imagecontent.innerHTML += resultHTML;
	
	                if (imagecontent != null && imagecontent != "") {
	                    var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(imgpath);
	                    document.getElementById(imageid).src = imgSrc;
	                    bodycount = parseInt(bodycount) + 1;
	                }
	            } else {
	                imagecount = imgpath.split("\\").length - 1;
	                imageid = imgpath.split("\\")[imagecount];

	                if (document.getElementById(imageid) != "" && document.getElementById(imageid) != null)
	                    return "false";

	                var resultHTML = "<table width='100%' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + imageid + "' name='" + imgpath + "' uniqueId='" + imgUniqueID + "' ><tr>" +
	                                     "<td style='width:25px;background:rgb(245, 245, 245);border-top:0 none; padding:6px;'><div class='custom_checkbox'><input type='checkbox' value='" + "M_" + imageid + "' id='imagecheck" + bodycount + "'  name='checkmenuSub' /></div></td>" +
	                                     "<td style='width:113px; height: 100px;border-top:0 none; padding:6px;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 100px; height: 100px;' name='imgView'></img></td>" +
	                                     "<td style='border-top:0 none; padding:6px 8px 6px 6px;'><textarea type=/text' style='width:100%; height:100px; border:1px solid #ddd; margin:0; padding:0;' maxlength='50' name='imgContent'></textarea></td>" +
	                                     "</tr></table>";

	                var imagecontent = document.getElementById("addimagecontent");
	                imagecontent.innerHTML += resultHTML;

	                if (imagecontent != null && imagecontent != "") {
	                    document.getElementById(imageid).src = localFileName;
	                    bodycount = parseInt(bodycount) + 1;
	                }
	            }
	        }
	
	        function btn_ImgAddOnclick() {
	            var bodycount = document.getElementById("addimagecontent").childNodes.length;
	            var file = "";
	            var content = "";
	            var filename = "";
	
	            if(bodycount == 0)
	            {
	                alert(strLang44);
	                return;
	            }
	            if (CrossYN()) {
	                for (var i = 0; i < bodycount; i++) {
	                    content += document.getElementsByName('imgContent')[i].value + ";:;";
	                    filename += document.getElementsByName('imgView')[i].title + "|";
	                }
	            } else {
	                for (var i = 0; i < bodycount; i++) {
	                    var checkreuslt = document.getElementById("addimagecontent").childNodes[i].childNodes[0].childNodes[0].childNodes[0].childNodes[0];
	                    var checkreuslts = document.getElementById("addimagecontent").childNodes[i].childNodes[0].childNodes[0].childNodes[2].childNodes[0];
	                    //경로
	                    file += document.getElementById(checkreuslt.value).getAttribute("name") + "|";
	                    //내용
	                    content += MakeXMLString(checkreuslts.value + ";:;");

	                    var imagenamelength = document.getElementById(checkreuslt.value).getAttribute("name").lastIndexOf("\\");
	                    //사진실제이름
	                    filename += document.getElementById(checkreuslt.value).getAttribute("name").substring(imagenamelength + 1, imagenamelength.length) + "|";
	                }
	            }
	            
	            var strXML = "";
	            var pStartDate = "";
	
	            var xmldom = createXmlDom();
	            var filecount = document.getElementsByName('checkmenuSub').length;
	            var imageid = "";
	            
			    strXML += "<NODES>";
			    strXML += "<NODE>";
	            strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	            
	           	/* 2018-06-08 홍승비 - 사진 추가 시 imageID 순서 유지하며 추가 */
	            if(filecount > 0)
	            {
	                for (var i = 0; i < filecount ; i++) {
	                    imageid += getZeroNum(i) + "{" + GetGUID() + "}" + ";";
	                }
	            }
	            else{
	                alert(strLang174);
	                return;
	            }
	            
	            strXML += "<IMAGE_ID>" + imageid + "</IMAGE_ID>";
	
	            var filepath = MakeXMLString(GetSmallUrl());
	
				strXML += "<WRITERID>" + SSUserID + "</WRITERID>";
				strXML += "<WRITERNAME>" + MakeXMLString(SSUserName) + "</WRITERNAME>";
				strXML += "<DEPTID>" + SSDeptID + "</DEPTID>";
	            strXML += "<STARTDATE>" + pStartDate + "</STARTDATE>";
	            strXML += "<CONTENT2>" + MakeXMLString(content) + "</CONTENT2>";
	            strXML += "<FILEPATH>" + filepath + "</FILEPATH>";
	            strXML += "<IMAGE_FILENAME>" + MakeXMLString(filename) + "</IMAGE_FILENAME>";
			    strXML += "</NODE>";
			    strXML += "</NODES>";
   
	            xmldom.async = false;
			    xmldom.preserveWhiteSpace = true;
			    xmldom = loadXMLString(strXML);
	            //20121018_[을지]_포토앨범 : 업로드 실행 FileData에 저장
	            
			    var xmlhttp = createXMLHttpRequest();
			    xmlhttp.open("POST", "/ezBoard/saveImageItem.do", false);
	            xmlhttp.send(xmldom);
	
			    if(xmlhttp.responseText == "OK") 
	            {
				    xmlhttp = null;
				    xmldom = null;
				    alert(strLang46);
				    
				    sendBoardAlert("modify", pBoardID, pItemID, isAllGroupBoard);
				    
				    /* 2019-01-15 홍승비 - 사진추가 후 DB에 게시물 수정일자 업데이트 */
                    $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/modUpdateDate.do",
						data : {
							itemID  : pItemID
						},
						success : function(result) {
							window.opener.page_reload();
							window.close();
						}
					});
				}
	            else 
	            {
			        alert(strLang47);
				}
			
			    xmlhttp = null;
			    xmldom = null;
	        }
	        function MakeXMLString(str)
		    {
			    str = ReplaceText(str, "&", "&amp;");
			    str = ReplaceText(str, "<", "&lt;");
			    str = ReplaceText(str, ">", "&gt;");
			    return str;
		    }
		    
	        function ReplaceText( orgStr, findStr, replaceStr )
		    {
			    var re = new RegExp( findStr, "gi" );
			    return ( orgStr.replace( re, replaceStr ) );
		    }
	
	        function GetSmallUrl() {
	            var xmldom_attachlist = createXmlDom();
	            var strRet = "";
	            var filepath = "";
	
	            if (typeof (pAttachListXml) == "string")
	                xmldom_attachlist = loadXMLString(pAttachListXml);
	            else
	                xmldom_attachlist = pAttachListXml;
	
	            if (CrossYN()) {
	                if (xmldom_attachlist == false) {
	                    xmldom_attachlist = null;
	                    return "";
	                }
	            }
	
	            //var xmldomNodes = xmldom_attachlist.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
	            var xmldomNodes = xmldom_attachlist.getElementsByTagName('DATA2');
	
	            for (var i = 0; i < xmldomNodes.length; i++) {
	                filepath = getNodeText(xmldomNodes.item(i));
	                if (filepath.indexOf(pBoardID) != -1) {
	                    var idx = filepath.lastIndexOf("/");
	                    if (idx != -1) {
	                        strRet += filepath.substr(0, idx + 1) + "s_" + filepath.substr(idx + 1) + "|";                        
	                    }
	
	                } else {
	                    //strRet += pBoardID + "/UploadFile/s_" + getNodeText(xmldomNodes.item(i)) + "|";
	                    strRet += "tempUploadFile/s_" + getNodeText(xmldomNodes.item(i)) + "|";
	                }
	            }
	            xmldom_attachlist = null;
	            return strRet;
	        }
	
	        function imagecheckAll(checkeds)
	        {
	            if (document.getElementsByName('checkmenu')[0].checked) {
	                for (var i = 0 ; i < document.getElementsByName('checkmenuSub').length ; i++)
	                    document.getElementsByName('checkmenuSub')[i].checked = true;
	            } else {
	                for (var i = 0 ; i < document.getElementsByName('checkmenuSub').length ; i++)
	                    document.getElementsByName('checkmenuSub')[i].checked = false;
	            }
	        }
	
	        function btn_PhotoAttachDel()
	        {
	            if (CrossYN()) {
	                var xmlhttp = createXMLHttpRequest();
	                var uniqueIDs = "";
		            var fd = new FormData();
		            for (var i = document.getElementsByName('checkmenuSub').length - 1 ; i >= 0 ; i--) {
		                if (document.getElementsByName('checkmenuSub')[i].checked) {
		                    var obj = document.getElementById(document.getElementsByName('checkmenuSub')[i].value);
		                    uniqueIDs += obj.getAttribute('uniqueID') + ";";
		                    obj.parentNode.removeChild(obj);
		                }
		            }
		            
		            if (uniqueIDs == null || uniqueIDs == "") {
		            	alert("<spring:message code='ezBoard.t601'/>");
			    		return;	
		            }
		            
	                xmlhttp.open("POST", "/ezBoard/boardImageUpload.do?mode=DEL&boardID=" + encodeURIComponent(pBoardID) +"&uniqueIDs=" + uniqueIDs, false);
	                xmlhttp.send(xmldom);
	
	                document.getElementById("checkmenu").checked = false;
	
	                if (document.getElementsByName('checkmenuSub').length == 0)
	                    txtPhotoFile.value = "";
	
	                xmlhttp = null;
	
	            } else {
	                for (var i = document.getElementsByName('checkmenuSub').length - 1 ; i >= 0 ; i--) {
	                    if (document.getElementsByName('checkmenuSub')[i].checked) {
	                        var obj = document.getElementById(document.getElementsByName('checkmenuSub')[i].value);
	                        obj.parentNode.removeChild(obj);
	                    }
	                }
	                document.getElementById("checkmenu").checked = false;
	
	                if (document.getElementsByName('checkmenuSub').length == 0)
	                    txtPhotoFile.value = "";
	            }
	            
	            var attachXml = "<LISTVIEWDATA><ROWS>";
	            for (var i = 0 ; i < document.getElementById("addimagecontent").childNodes.length ; i++) {
	                attachXml += "<ROW><CELL>";
	                attachXml += "<DATA1>" + "/upload_board/" + pBoardID + "/uploadFile/" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA1>";
	                attachXml += "<DATA2>" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA2>";
	                attachXml += "<DATA3></DATA3>";
	                attachXml += "<DATA4></DATA4>";
	                attachXml += "<DATA5>Y</DATA5>";
	                attachXml += "<DATA6>" + GetAttribute(document.getElementsByName('imgView')[i], 'size') + "</DATA6>";
	                attachXml += "</CELL></ROW>";
	            }
	            attachXml += "</ROWS></LISTVIEWDATA>";

	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLString(attachXml);
	            pAttachListXml = xmlDom;
	        }
	
	        //create guid
	        function S4() {
	            return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
	        }
	
	        function GetGUID() {
	            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
	        }
	        
	        /* 2018-06-08 홍승비 - 사진 추가 시 imageID 순서 유지하며 추가 */
		    function getZeroNum(count){
	        	var addCnt =  parseInt(count) + parseInt(lastItemID) + 1;
		    	var zeroNum = "000" + addCnt;
		    	zeroNum = zeroNum.substring(zeroNum.length - 3);
		    	return zeroNum;
		    }
	        
	        function CustomRandom() {
	            var now = new Date();
	            var seed = now.getMilliseconds();
	            return Math.random(seed) + 1;
	        }
	        //
	        
		    /* 2018-10-11 홍승비 - 이미지파일 확장자체크 추가 */
		    function compareExtension(check, extension) {
	    		var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
	    		for (var i = 0; i < filterExtension.length; i++) {
	        		if (extension.toLowerCase() == filterExtension[i]) {
	            		check = true;
	            		break;
	        		}
	    		}
	    		return check;
			}
	        
	        /* 2021-06-22 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendBoardAlert.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID,
						isAllGroupBoard : pIsAllGroupBoard
					}
				});
	        }
	    
	    </script>
	    <c:if test="${!isCrossBrowser}">
		    <script  FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
			        Append_AttachAdd(filename);
			</script>
	    </c:if>
	</head>
	<body class="popup">
	    <table class="layout" >
	        <tr>
	            <td style="vertical-align:top" colspan="4">
	                <div id="menu">
	                <ul>
	                    <li ID='btn_Modify' ><span  onclick="btn_ImgAddOnclick()" ><spring:message code='ezBoard.t98'/></span></li>
	                    <li ID='Li1' ><span  onclick="btn_PhotoAttachAdd()" ><spring:message code='ezBoard.t1001'/></span></li>
	                    <li ID='Li2' ><span  onclick="btn_PhotoAttachDel()" ><spring:message code='ezBoard.t1003'/></span></li>
	                </ul>
	                </div>
	                <div id="close">
	                <ul>
	                    <li ><span  onClick="window.close();"></span></li>
	                </ul>
	              </div>
	            </td>
	        </tr>
	    </table>
	    <table>
	        <tr style="display:none">
	          <th><spring:message code='ezBoard.t1009'/></th>
	          <td style="vertical-align:top; width:100%; padding-left:2px">
	              <INPUT type="text" id="txtPhotoFile" style="WIDTH:70%;" readonly="true" >
	              <%--<a class="imgbtn"><span id="Span1" onClick="return btn_PhotoAttachAdd()"><%=RM.GetString("t1001")%></span></a>--%>
	          </td>
	        </tr>
	        <tr>
	            <th style="text-align:left; margin: 0px; padding-left:6px; width:25px; border-right: 0px">
	            	<div class="custom_checkbox">
		                <input id="checkmenu" type="checkbox" onClick="imagecheckAll(this)"  name="checkmenu"/>
	            	</div>
	            </th>  
	            <th style="text-align:center; height:25px; width:100%; border-left:0px;font-weight: normal;color:#333"><spring:message code='ezBoard.t1010'/></th>
	        </tr>       
	        <tr style="vertical-align:top">
	            <td style="vertical-align:top; padding:0px; margin:0px" colspan="2">
	                <div id="addimagecontent" style="overflow:auto;width:100%;height:415px; vertical-align:top; text-align:left; border:0px; margin:0px; padding:0px"></div>
	            </td>
	        </tr>
	    </table>
	    <table>
	        <tr style="display:none;">
	            <td>
	            	<c:if test="${!isCrossBrowser}">
		            	<SCRIPT>  EzHTTPTrans_ActiveX("EzHTTPTrans");</SCRIPT>
	            	</c:if>
	                <div id="lstAttachLink">&nbsp;</div>
	            </td>
	        </tr>
	        <tr style="display:none;">
	            <td>
	                <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	                <form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
	                <input type="file" name="file1" id="file1"  style="width: 1px; height: 1px;" onchange="imgtemp_onclick()" accept="image/*" multiple />
	                <input type="hidden" name="mode" id="mode" />
	                </form>
	            </td>
	        </tr>
	    </table>
	</body>
</html>