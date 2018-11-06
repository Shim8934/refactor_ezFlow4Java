<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t293'/></title>
		<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<style title="ezform_style_1">
			P {
					MARGIN-TOP: 0mm;
					MARGIN-BOTTOM: 0mm;
				}
		</style>
		<script type="text/javascript">
				window.offscreenBuffering = true;
				var xmlhttp = createXMLHttpRequest();
				var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
				var curFontSize = 1;
				var pItemID = "${itemID}";
				var pBoardID = "${boardID}";
				var pBoardName = "${boardInfo.boardName}";
		        var pTitle = "${title}";
				var strWriterID = "${boardItem.writerID}";
				var strWriterName = "${boardItem.writerName}";
				var strWriterDeptName = "${boardItem.writerDeptName}";
				var strWriterCompanyName = "${boardItem.writerCompanyName}";
				var strWriteDate = "${boardItem.writeDate}";
				var strImportance = "${boardItem.importance}";
				var strEndDate = "${boardItem.endDate}";
				var strContentLocation = "${boardItem.contentLocation}";
				var strAttachList = "${boardItem.attachments}";
				var SSUserID = "${userInfo.id}";
				var SSUserName = "${userInfo.displayName}";
				var Access_FG = "${boardInfo.access_FG}";
				var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
				var ListView_FG = "${boardInfo.listView_FG}";
				var Read_FG = "${boardInfo.read_FG}";
				var Write_FG = "${boardInfo.write_FG}";
				var Reply_FG = "${boardInfo.reply_FG}";
				var Delete_FG = "${boardInfo.delete_FG}";
				var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
				var g_progresswin;
				var OneLineReplyFlag = "${oneLineReplyFlag}";
				var gubun = "${boardInfo.guBun}";
				var commentCount = "${commentCount}";
		        var ImageCount = "";
		        var viewimage = "";
		        var moviePath = "";
		        var movieID= "";
		        var movieContent = "";
		        var pPage = 1;
		        var imagepage = "0";
		        var imagetotalcount = "";
		        var imgWidth = "57px";
		        var imgHeight = "37px";
		        var rsa = new RSAKey();

		        window.onload = function () {
		        	imageViewInit();
		            rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		            
		            if (g_progresswin) {
		            	g_progresswin.close();
		            }

		            if ("${useOCS}" == "YES") {
		                var pSIPUriList = getSIPUri(strWriterID + ";", "").split(';');
		                document.getElementById("WriteUserNM").innerHTML = "<div><img style ='vertical-align:middle' src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[0] + "\",this);'/>" + "<span style ='vertical-align:middle'>" + "${boardItem.writerName}" + "</span></div>";
		                pSIPUriList = null;
		            }
		            else {
		               // document.getElementById("WriteUserNM").innerHTML = "${boardItem.writerName}";
		            }       
		        };
		        
		        function imageViewInit()
		        {
		            $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/imageViewList.do",
						data : { boardID   : pBoardID, 
								 itemID    : pItemID,
								 page      : "1"
							   },
						success: function(result){
							ImageViewTable(result);
						}        			
					});
		        }
		
		        function ImageViewTable(result)
		        {
		            var xmldom = createXmlDom();
		
		            xmldom = loadXMLString(result);
		            
	            //    movieContent = getNodeText(xmldom.getElementsByTagName("FILECONTENT")[0]);
	                moviePath = getNodeText(xmldom.getElementsByTagName("FILEPATH")[0]);
	          //      movieID = getNodeText(xmldom.getElementsByTagName("IMAGEID")[0]);
	                
	                console.log("moviePath      ::     " + moviePath);
	            //    console.log("movieID      ::     " + movieID);
	          //      console.log("resultimage      ::     " + resultimage);
	                
					movieMain(moviePath);
		        }
		        
		        //강민수92 댓글 클릭 이벤트
			    function btn_One_Line_Reply_Onclick() {
			    	if (OneLineReplyFlag == "1") {
			    		openBoardComment();
			    		return;
			    	} 
			    }
		        
				//GUID 채번
				function generateGuid() {
				    var result = "";
				    for (var i = 0, j = 0; j < 32; j++) {
				        if (j == 8 || j == 12 || j == 16 || j == 20) {
				            result = result + "-";
				        }
				        i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
				        result = result + i;
				    }
				    return "{"+ result + "}";
				}
				////
		
				// 20090408 : 게시물 위로가기 기능 추가
				function GoTopNDownView()
				{
				    AGoTop.style.display = "";
				    AGoDown.style.display = "";
				}
				
				// 20090408 : 게시물 위로가기 기능 추가
				function GoTopNDownHidden()
				{
				    AGoTop.style.display = "none";
				    AGoDown.style.display = "none";
				}
		
				var checkpassword_dialogArguments = new Array();
				function btn_Delete_Onclick()
				{
					if (CheckIfHasReplies())
					{
						alert("<spring:message code='ezBoard.t196'/>");
						return;
					}
		
					if(Delete_FG != "true") {
						alert("<spring:message code='ezBoard.t265'/>");
						return;
					}
		
					//게시판관리자 또는 게시판그룹관리자 또는 게시물작성자가 아니면 지울 수 없다
				    if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
			            alert("<spring:message code='ezBoard.t265'/>");
			            // GS 수정(2006.02.10) : 익명게시판인 경우 게시물 삭제 시 암호가 맞아도 삭제가 안되는 문제 수정 (return의 위치가 잘못되었음)
			            return;
				    } else {
			            if (!confirm(strLang48)) {
			            	return;
			            }
	
			            var xmlhttp = createXMLHttpRequest();
			            xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + pItemID + ";", false);
			            xmlhttp.send();
	
			            if (xmlhttp.responseText == "NO") {
			                alert("<spring:message code='ezBoard.t265'/>");
	                        return;
	                    }
	
			            xmlhttp = null;
			            try {
		                	window.opener.leftCountRf();
						} catch (e) {
						}
			            try {
			                window.opener.refresh_onclick();
			            } catch (e) {
			            }
			            window.close();
				    }
				}
		
		    function btn_Delete_Onclick_Complete(ret) {
		        if (ret != "OK") {
		            alert("<spring:message code='ezBoard.t265'/>");
		            return;
		        }
		
		        if (!confirm(strLang48)) return;
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + pItemID + ";", false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265'/>");
		            return;
		        }
		
		        xmlhttp = null;
		        try {
                	window.opener.leftCountRf();
				} catch (e) {
				}
		        try {
		            window.opener.refresh_onclick();
		        } catch (e) {
		        }
		    }
		    
		        window.onunload = function () {
		        };
				function btnClose_onclick()
				{
					window.close();
				}
		
				function attach_SelectAll()
				{
					var checks = lstAttachLink.all.tags("input");
					for (var i=0; i<checks.length; i++)
						checks.item(i).checked = true;
				}
				
				var item_readlist_cross_dialogArguments = new Array();
				function ReaderList()
				{
		            var swidth = 620;
		            var sheight = 425;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
					var szHref = "/ezBoard/itemReadList.do?boardID=" + pBoardID + "&itemID=" + pItemID;			
					var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";
		
					if (CrossYN()) {
					    item_readlist_cross_dialogArguments[0] = "";
					    item_readlist_cross_dialogArguments[1] = ReaderList_Complete;
					    DivPopUpShow(620, 425, szHref);
					}
					else
					    window.open(szHref,"", "width=" + swidth + ",height=" + sheight + ",top=" + ptop + ",left=" + pleft + ", resizable=yes, scrollbars=yes");
				}
				function ReaderList_Complete() {
				    DivPopUpHidden();
				}
		
				/* 2018-06-29 홍승비 - 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
				function OpenUserInfo(pUserID, pDeptID)
				{
		            var swidth = 420;
		            var sheight = 450;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
					window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");			
				}
		
// 				function OneLineReply_onkeydown(e)
// 				{
// 				    if (e.keyCode == 13) {
// 				        e.returnValue = false;
// 				        e.cancelBubble = true;
// 				        Save_OneLineReply(e);
// 				    }
// 				}
		
// 				function Save_OneLineReply(e)
// 				{
// 					if (Reply_FG != "true") 
// 					{
// 						alert("<spring:message code='ezBoard.t303'/>");
// 						return;
// 					}
					
// 				    e.returnValue = false;
// 				    e.cancelBubble = true;
		
// 					//event.returnValue = false;
// 					//event.cancelBubble = true;
					
// 					//2011-04 : 한줄 답변 옵션 처리
// 					if(OneLineReplyFlag == "1")
// 					{
// 					    if (document.getElementById("onelinereply").value == "") 
// 					    {
// 						    alert("<spring:message code='ezBoard.t307'/>");
// 						    return;
// 					    }
// 					}
					
// 					//2011.04.13 익명게시판의 경우 한줄답변 등록시 password 추가
// 					if (gubun == "2" && trim(document.getElementById("txtPassWord").value) == "" )
// 					{
// 					    alert("<spring:message code='ezBoard.t391'/>");
// 					    txtPassWord.focus();
// 						return;
// 					}
					
// 					var pReplyID = "";
// 					pReplyID = generateGuid();
					
// 					var content,password;
// 					if (OneLineReplyFlag == "1"){
// 						content = MakeXMLString(document.getElementById('onelinereply').value);
// 					}else{
// 						content = "";
// 					}
// 					if (gubun != "2") {
// 					    password = "";
// 					}
// 					else {
// 					    password = rsa.encrypt(document.getElementById("txtPassWord").value);
// 					}
					
// 					$.ajax({
// 						type : "POST",
// 						dataType : "text",
// 						async : false,
// 						url : "/ezBoard/saveOneLineReply.do",
// 						data : { boardID    : pBoardID, 
// 								 itemID 	: pItemID,
// 								 replyID	: pReplyID,
// 								 content	: content,
// 								 password	: password
									 
// 							   },
// 						success: function(){
// 							reloadOneline();
// 						}
// 					});
// 				}
		
// 				function reloadOneline(){
// 				    if (OneLineReplyFlag == "1")
// 				        document.getElementById('onelinereply').value = "";
// 				    if (gubun == "2")
// 				        document.getElementById('txtPassWord').value = "";
// 				    getOneLineReply();
// 				}
				
// 				function delete_onelinereply(pReplyID)
// 				{
// 				     var xmlhttp = createXMLHttpRequest();
				    
// 				    //게시판관리자 또는 게시판그룹관리자 또는 게시물작성자가 아니면 지울 수 없다
// 					if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") 
// 					{
// 					    xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + pReplyID, false);
// 					    xmlhttp.send();
		        			
// 					    if (xmlhttp.responseText.substr(0,2) != "OK")
// 					    {
// 						    alert("<spring:message code='ezBoard.t310'/>");
// 						    return;
// 					    }
		        			
// 					    if (!confirm("<spring:message code='ezBoard.t311'/>")) 
// 					    	return;
		
// 					} else {
// 						    if(!confirm("<spring:message code='ezBoard.t311'/>")) 
// 						    	return;
// 						}
					
// 					xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + pReplyID+"&guBun="+gubun, false);
// 					xmlhttp.send();
// 					getOneLineReply();			
// 					xmlhttp = null;
// 				}
				
// 			    function getOneLineReply()
// 			    {
// 			        var xmlhttp = createXMLHttpRequest();
// 			        xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
// 			        xmlhttp.send();
// 			        var xmldom = createXmlDom();
// 			        //xmldom.loadXML(xmlhttp.responseText);
// 			        xmldom = loadXMLString(xmlhttp.responseText);
// 			        xmlhttp = null;
// 			        strHTML = "";
// 			        var temp;
// 			        for (var i=0; i<xmldom.getElementsByTagName("REPLYID").length; i++)
// 			        {
// 			            temp = i+1;
// 			            strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i))+ "\")'><p>";
// 			        }
// 			        if (i==0)
// 			            strHTML = "<spring:message code='ezBoard.t312'/>";
		            
// 		            try
// 		            {
// 		                document.getElementById("onelinereplylist").innerHTML = strHTML;
// 		            }
// 		            catch(e)
// 		            {
// 		            }
// 			    }
				
				function ReplaceText( orgStr, findStr, replaceStr )
				{
					var re = new RegExp( findStr, "gi" );
					return ( orgStr.replace( re, replaceStr ) );
				}
		
				function MakeXMLString(p_str)
				{
					p_str = ReplaceText(p_str, "&", "&amp;");
					p_str = ReplaceText(p_str, "<", "&lt;");
					p_str = ReplaceText(p_str, ">", "&gt;");
					
					return p_str;
				}
		
				function OpenItem(strItemID)
				{
					if (strItemID != "") {
						window.location.href = window.location.href.replace(pItemID, strItemID);
					}
				}
				
				function GoTop()
				{
				    message.AGoTop.click();
				}
				
				function GoDown()
				{
				    message.AGoDown.click();
				}
		
		        function movieMain(imagefilename)
		        {
		            var mainfilename = imagefilename;
		            if (imagefilename.indexOf("s_") > -1) {
		                mainfilename = imagefilename.split("s_")[0] + imagefilename.split("s_")[1];
		            }
		    
		            viewimage = imagefilename.id;	
		            document.getElementById("mainVideo").src = mainfilename;
		            document.getElementById("mainVideo").name = imagefilename.name;
		        }
		        
		        function showHideLayers()
		        {
		            showDiv.style.display = "block";
		        }
		
		        function btn_movieMod(pMod) {
		            var swidth;
		            var sheight;
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
	            	var agent = navigator.userAgent.toLowerCase();
	            	
	            	if ((navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || agent.indexOf("msie") != -1) {
	            		if (gubun != 4) {
	            			swidth = 440;
		               		sheight = 460;
	            		} else {
		            		swidth = 460;
			                sheight = 380;
	            		}
	            	} else {
	               		swidth = 460;
	                	sheight = 380;
	            	}
	                
		            pleft = (pwidth - swidth) / 2;
		            ptop = (pheight - sheight) / 2;
		            
	                window.open("/ezBoard/modifyImageItem.do?imageID=" + document.getElementById("mainVideo").name + "&boardID=" + pBoardID + "&itemID=" + pItemID + "&page=" + pPage + "&mod=image&guBun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft, "");
				}
		
		        function page_reload()
		        {
		            window.location.reload();
		        }
		
		        function btn_Add_Onclick()
		        {
		            var swidth = 500;
		            var sheight = 525;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
		            window.open("/ezBoard/addImageItem.do?&boardID=" + pBoardID + "&itemID=" + pItemID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft , "");
		        }
		
		        function btn_SmallIamge(Page)
		        {
		            var NewPage = "";
		
		            if (Page == "Next") {
		                var endpage = pPage * 10;
		                if (imagetotalcount <= endpage) {
		                    return;
		                }
		                else {
		                    imagepage = 0;
		                    NewPage = parseInt(pPage) + 1;
		                }
		            }
		            else if (Page == "Nextimage") {
		                var endpage = pPage * 10;
		
		                if (imagetotalcount <= endpage) {
		                    imagepage = 0;
		                    NewPage = 1;
		                }
		                else {
		                    imagepage = 0;
		                    NewPage = parseInt(pPage) + 1;
		                }
		            }
		            else if (Page == "Prev") {
		                imagepage = 9;
		                if (pPage == 1) {
		                    if (imagetotalcount % 10 > 0) {
		                        pPage = Number(imagetotalcount / 10) + 2;
		                    } else {
		                        pPage = Number(imagetotalcount / 10) + 1;
		                    }
		                    imagepage = imagetotalcount % 10 - 1;
		                }
		                NewPage = parseInt(pPage) - 1;
		            }
		            
		            pPage = NewPage;
		    
		            $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/imageViewList.do",
						data : { boardID   : pBoardID, 
								 itemID    : pItemID,
								 page      : NewPage
							   },
						success: function(result){
							ImageViewTable(result);
						}        			
					});
		        }
		
		        var photoalbumedit_dialogArguments = new Array();
		        function btn_albumEdit()
		        {
		            var params = new Array();
		            params[0] = pBoardID;
		            params[1] = pItemID;
		            params[2] = document.getElementById("title").textContent;
		            params[3] = document.getElementById("Div2").textContent;
		            if (CrossYN()) {
		                photoalbumedit_dialogArguments[0] = params;
		                photoalbumedit_dialogArguments[1] = btn_albumEdit_Complete;
		                DivPopUpShow(400, 200, "/ezBoard/photoAlbumEdit.do");
		            }
		            else {
		                var swidth = 400;
		                var sheight = 200;
		                var feature = "status:no;dialogWidth:" + swidth + "px;dialogHeight:" + sheight + "px;help:no;scroll:no;edge:sunken";
		
		                var ret = window.showModalDialog("/ezBoard/photoAlbumEdit.do", params, feature);
		                if (ret == "OK")
		                    page_reload();	
		            }		           
		        }
		        
		        function btn_albumEdit_Complete(ret) {
		            DivPopUpHidden();
		            if (ret == "OK")
		                page_reload();
		        }
		        
		        /* 2018-06-01 홍승비 - 페이징 코드 수정, 도달 불가능 코드 삭제 */
		        function pageimageover()
		        {
		            var endpage = pPage * 10;
		            if(imagetotalcount > endpage && pPage == 1)
		            {
		                document.getElementById("SmallImageNext").style.display = "";		                
		            }
		            else if(pPage == 1 && imagetotalcount <= 10)
		            {
		                document.getElementById("SmallImagePrev").style.display = "none";
		                document.getElementById("SmallImageNext").style.display = "none";
		            }
		            else if(pPage != 1 && imagetotalcount <= endpage)
		            {
		                document.getElementById("SmallImagePrev").style.display = "";
		                document.getElementById("SmallImageNext").style.display = "none";
		            }
		            else
		            {
		                document.getElementById("SmallImagePrev").style.display = "";
		                document.getElementById("SmallImageNext").style.display = "";
		            }
		        }
		
		        function btn_ImgDownload()
		        {
		            var swidth;
		            var sheight;
		
		            swidth = 420;
		            sheight = 500;
		            
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		            
		            window.open("/ezBoard/imageDownload.do?itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ",status = no, toolbar=no, menubar=no,location=no, resizable=1");			
		        }
		
		    	//mouseWheel Event 
// 		        document.onmousewheel = ScrollControl;
		
		        function ScrollControl()
		        {
		            for(var i = 0  ; i < document.getElementById("viewboxlist").getElementsByTagName("IMG").length ; i++)
		            {
		                if(event.wheelDelta == "120")
		                {
		                    if (CrossYN()) {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.opacity == "1") {
		                            if (i == document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1)
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[0]);
		                            else
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i + 1]);
		
		                            break;
		                        }
		                    } else {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.filter == "Alpha(Opacity=100)") {
		                            if (i == document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1)
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[0]);
		                            else
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i + 1]);
		
		                            break;
		                        }
		                    }
		
		                } else {
		                    if (CrossYN()) {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.opacity == "1") {
		                            if (i == 0)
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1]);
		                            else
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i - 1]);
		
		                            break;
		                        }
		                    } else {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.filter == "Alpha(Opacity=100)") {
		                            if (i == 0)
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1]);
		                            else
		                                movieMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i - 1]);
		
		                            break;
		                        }
		                    }
		                }
		            }
		        }
		        function Appr_onclick(pFlag) {
		            if (pFlag == "C") {
		                var OpenWin = window.open("/ezBoard/boardApprOpinion.do?itemList=" + pItemID + ";&mode=" + pFlag, "BoardApprOpinion", GetOpenWindowfeature(540, 300));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                var xmlhttp = createXMLHttpRequest();
		                xmlhttp.open("POST", "/ezBoard/apprBoardItem.do?itemList=" + pItemID + ";&mode=" + pFlag, false);
		                xmlhttp.send();
		
		                if (xmlhttp.responseText == "OK") {
		                    if (pFlag == "Y")
		                        alert("<spring:message code='ezBoard.t999002'/>");
		                    else
		                        alert("<spring:message code='ezBoard.t999009'/>");
		                }
		
		                try {
		                    window.opener.refresh_onclick();
		                } catch (e) {
		                }
		                
			            window.close();
		            }
		        }
		        function refresh_onclick() {
		            try {
		                window.opener.refresh_onclick();
		            } catch (e) {
		            }
		            window.close();
		        }
		    	//mouseWheel Event  END
		        function btn_ReWrite() {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		            window.close();
		
		            /* 2018-06-20 홍승비 - 승인게시물 반려 후 제작성 .do 경로 수정 */
		            window.open("/ezBoard/boardNewItemTempPhoto.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&location=", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        }
		    	
		</script>
	</head>
	<body class="popup">
		<table class="layout" style="border-spacing:0; border-bottom:1px solid #ddd; border:0px; width:100%; min-width:745px;">
		  <tr>
		    <td style="height:20px; vertical-align:top">
		      <div id="menu">
		        <ul>
		        	<c:choose>
		        		<%-- 2018-06-20 홍승비 - 승인/반려 버튼만 활성화, 작성자는 수정/삭제 가능 --%>
		        		<c:when test="${apprFlag == 'N'}">
			                <li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005'/></span></li>
			                <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014'/></span></li>
			                	<c:if test="${boardItem.writerID == userInfo.id}">
				                	<li ID='btn_Modify' ><span  onclick="btn_movieMod('Mod')"><spring:message code='ezBoard.t1002'/></span></li>
				                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t1004'/></span></li>
				                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t1005'/></span></li>
		                    	</c:if>
						</c:when>
		        		<c:when test="${apprFlag == 'C'}">
			                <li><span onClick="btn_ReWrite()"><spring:message code='ezBoard.t999021'/></span></li>
		        		</c:when>
		        		<c:otherwise>
		        			<!--		강민수92	   -->
	        				<c:if test = "${oneLineReplyFlag == '1'}">
	        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81'/>[${commentCount}]</span></li>
	        				</c:if>
							<!--		강민수92 end -->
		        			<c:if test="${boardInfo.boardAdmin_FG =='true' || boardInfo.boardGroupAdmin_FG == 'OK' || boardItem.writerID == userInfo.id}">
			                    <li ID='btn_Modify' ><span  onclick="btn_movieMod('Mod')"><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t316'/></span></li>
			                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t89'/></span></li>
			                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t316'/></span></li>
		        			</c:if>
		                    <li ID='btn_Read' ><span  onclick="ReaderList()"><spring:message code='ezBoard.t1006'/></span></li>
		                    <li ID='btn_down' ><span  onclick="btn_ImgDownload()"><spring:message code='ezQuestion.t180'/><spring:message code='ezQuestion.t567'/></span></li>
		        		</c:otherwise>
		        	</c:choose>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		            <li ><span  onclick="btnClose_onclick()"></span></li>
		        </ul>
		      </div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
			</script>
		    </td>
		  </tr>
		  <tr>
		     <td>
		         <table class="content" style="border:0px; width:100%">
		            <tr>
		              <th style="width:10%"><spring:message code='ezBoard.t223'/></th>
			              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="WriteUserNM">
			              	  <div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto">
								 <span onclick='OpenUserInfo("${boardItem.writerID}", "${boardItem.writerDeptID} ")' style="cursor:pointer;"><c:out value="${boardItem.writerName}"/></span>
							  </div>
			              </td> 
		              <th style="width:10%"><spring:message code='ezBoard.t289'/></th>
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;"id="User_DeptNM"><c:out value="${boardItem.writerDeptName}"/></td>
		            </tr>
		            <tr>
		              <th style="width:10%"><spring:message code='ezBoard.t290'/></th>
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="User_JobTitle">${boardItem.extensionAttribute3}</td>
		              <th style="width:10%"><spring:message code='ezBoard.t224'/></th>
		              <td style="width:40%; text-overflow:ellipsis; white-space:nowrap;" id="User_WriteDate">${boardItem.writeDate} </td>
		            </tr>
		            <tr>
		              <th><spring:message code='ezBoard.t291'/></th>
		              <td id="cTitle" colspan="3">
			              <div id="title" style="OVERFLOW-Y:auto; WIDTH:100%; vertical-align:middle;"><c:out value="${boardItem.title}"/></div>
		              </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezQuestion.t180'/><spring:message code='ezCommunity.t18'/></th>
		                <td id="cimagecontent" colspan="3" style="padding-right:0px">
		                    <div id="Div2" style="OVERFLOW-Y: auto; height:55px;WIDTH: 100%; padding-top:5px;padding-bottom:5px; vertical-align:middle;"><c:out value="${boardItem.mainContent}"/></div>
		                </td>
		            </tr>
		          </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="width:100%;  text-align:center; padding-top:10px;" >
		        <table style="width:100%; border:1px solid #ddd; min-height:450px;">
		        <tr style="display:table-cell;">
		            <td style="display:inline-block;">
		                <table id="movieTable">
		                    <tr>  
		                        <td>
		                            <video id="mainVideo" style="width: 640px; height: 360px;" src="" controls />            
		                        </td>
		                    </tr>
		           	    </table>
		            </td>
		        </tr>
		        </table>
		    </td>
		  </tr>
		  <%--2011-04 : 한줄 답변 옵션 처리--%>
<%-- 		  <c:choose> --%>
<%-- 		  	<c:when test="${oneLineReplyFlag == '1'}"> --%>
<!-- 			  <tr> -->
<!-- 			    <td style="height:50px"> -->
<!-- 			        <table> -->
<!-- 			            <tr> -->
<!-- 			                <td style="height:20px;"></td> -->
<!-- 			            </tr> -->
<!-- 			        </table> -->
<!-- 			        <table class="content">    -->
<!-- 			        <tr> -->
<%-- 			            <th><spring:message code='ezBoard.t486'/></th> --%>
<!-- 			            <td class="pos1"><input id="onelinereply" style="WIDTH: 100%" type="text" maxLength="100" onKeyDown="OneLineReply_onkeydown(event)"></td> -->
<%-- 			            <td class="pos2"><a class="imgbtn"><span onClick="Save_OneLineReply(event)"><spring:message code='ezBoard.t321'/></span></a></td> --%>
<!-- 			        </tr> -->
<!-- 			        <tr> -->
<!-- 			            <td style="height:100px" colspan="4"> -->
<!-- 			                <div id="onelinereplylist" style="OVERFLOW:auto; HEIGHT: 90px; background-color:white; padding:10px; text-align:left"></div> -->
<!-- 			            </td> -->
<!-- 			        </tr> -->
<!-- 			        </table> -->
<!-- 			      </td> -->
<!-- 			  </tr> -->
<!-- 			  <tr> -->
<!-- 			    <td style="DISPLAY:none; height:50px" class="pad1"> -->
<!-- 			        <table class="file"> -->
<!-- 			            <tr> -->
<%-- 			              <th><spring:message code='ezBoard.t292'/></th> --%>
			
<!-- 			              <td class="pos1"> -->
<!-- 			                  <div style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left" id="lstAttachLink"></div> -->
<!-- 			              </td> -->
<%-- 			              <td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325'/></span></a><a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98'/></span></a> </td> --%>
<!-- 			              <td id="ItemLevel"></td> -->
<!-- 			            </tr> -->
<!-- 			      </table> -->
<!-- 			    </td> -->
<!-- 			  </tr> -->
<%-- 		  	</c:when> --%>
<%-- 		  	<c:otherwise> --%>
<!-- 		        <tr style="DISPLAY:none"> -->
<!-- 				    <td class="pad1" style="height:20px"> -->
<!-- 					    <table class="file"> -->
<!-- 				     	   <tr> -->
<%-- 			        		<th><spring:message code='ezBoard.t292'/></th> --%>
<!-- 				          	<td class="pos1"><div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left"></div></td> -->
<%-- 				          	<td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325'/></span></a><a class="imgbtn"><span onClick="attach_Download()"> <spring:message code='ezBoard.t98'/></span></a></td> --%>
<!-- 				          	<td id="ItemLevel"></td> -->
<!-- 				        	</tr> -->
<!-- 				        </table> -->
<!-- 				    </td> -->
<!-- 		 	 	</tr> -->
<%-- 		  	</c:otherwise> --%>
<%-- 		  </c:choose> --%>
		  <c:if test="${adjacentItemsEnableFlag == '1' && showAdjacent == '1'}">
			  <tr>
			    <td style="height:20px">
			    <table>
			        <tr>
			            <td style="height:20px"></td>
			        </tr>
			    </table>
			    <table class="content">
			        <!-- 표준모듈 (2007.02.22) 수정 : 다음/이전글 위치변경-->
			        <tr>
			          <th><spring:message code='ezBoard.t327'/></th>
			          <c:choose>
				          <c:when test="${boardAdjacent.previousItemID == ''}">
				          	<td style="width:100%">
				          </c:when>
				          <c:otherwise>
				          	<td style="cursor:pointer; width:100%">
				          </c:otherwise>
			          </c:choose>
			          <div style="word-break:break-all;HEIGHT: 18px; padding-top:2px; background-color:white; text-align:left" onClick="OpenItem('${boardAdjacent.previousItemID}')">${boardAdjacent.previousTitle}</div></td>
			        </tr>
			        <tr>
			          <th><spring:message code='ezBoard.t328'/></th>
			          <c:choose>
			          	<c:when test="${boardAdjacent.nextItemID == ''}">
			          		<td>
			          	</c:when>
			          	<c:otherwise>
			          		<td style="cursor:pointer">
			          	</c:otherwise>
			          </c:choose>
			          <div style="word-break:break-all;HEIGHT: 18px; padding-top:2px; background-color:white; text-align:left" onClick="OpenItem('${boardAdjacent.nextItemID}')">${boardAdjacent.nextTitle}</div></td>
			        </tr>
			      </table>
			    </td>
			  </tr>
		  </c:if>
		</table>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>