<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
		<title><spring:message code='ezBoard.t293'/></title>
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/Common.js" ></script>
		<script type="text/javascript" src="/js/NameControl.js"></script>
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<style title="ezform_style_1">
		P {
				MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm
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
				var SSUserName = "${userInfo.displayName1}";
				var Access_FG = "${boardInfo.access_FG}";
				var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
				var ListView_FG = "${boardInfo.listView_FG}";
				var Read_FG = "${boardInfo.read_FG}";
				var Write_FG = "${boardInfo.write_FG}";
				var Reply_FG = "${boardInfo.reply_FG}";
				var Delete_FG = "${boardInfo.delete_FG}";
				var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
				var pReservedItem = "${reservedItem}";
				var g_progresswin;
				var OneLineReplyFlag = "${oneLineReplyFlag}";
				var gubun = "${boardInfo.guBun}";
		        var ImageCount = "";
		        var viewimage = "";
		        var pListImage = "";
		        var pImageID= "";
		        var pListImageContent = "";
		        var resultimage = "";
		        var pPage = 1;
		        var imagepage = "0";
		        var imagetotalcount = "";
		        var imgWidth = "55px";
		        var imgHeight = "37px";
		
		        window.onload = function () {
		            imageViewInit();
		            pageimageout();
		
		            if (OneLineReplyFlag == "1") {
		                getOneLineReply();
		                if(CrossYN())
		                    self.resizeTo(770, 1000);
		                else
		                    self.resizeTo(770, 1010);
		            }
		
		            // GS 수정(2006.02.10) : 게시알림메일을 다시 게시하는 경우 url link와 게시물 link 기능이 겹치는 문제 수정
		            AddLinkTarget();
		
		            if (g_progresswin) g_progresswin.close();
		
		            if ("${useOCS}" == "YES") {
		                var pSIPUriList = getSIPUri(strWriterID + ";", "").split(';');
		                document.getElementById("WriteUserNM").innerHTML = "<div><img style ='vertical-align:middle' src='/images/Presence/unknown.gif' id ='" + GetGUID() + ",type=smtp' onload='PresenceControl(\"" + pSIPUriList[0] + "\",this);'/>" + "<span style ='vertical-align:middle'>" + "${boardItem.writerName}" + "</span></div>";
		                pSIPUriList = null;
		            }
		            else {
		                document.getElementById("WriteUserNM").innerHTML = "${boardItem.writerName}";
		            }
		        };
		
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
				
				
				// GS 수정(2006.02.10)  : 게시알림메일을 다시 게시하는 경우 url link와 게시물 link 기능이 겹치는 문제 수정
				// 함수 호출이 아닌 경우에만 target을 추가하도록 함
				function AddLinkTarget()
				{
					try
					{
					    // 20091030 : 게시판 읽기창 본문 IFRAME으로 변경
					    var objTags = message.txtContent.all.tags("a");
		    			
					    for( var i = 0 ; i < objTags.length ; i++ )
					    {
						    if( objTags.item(i).href.indexOf("javascript:") == -1 )
							    objTags.item(i).target = "_blink";
					    }
					}
					catch(e) {}
				}
				
		
				function ExtractBetweenPattern( orgStr, firstPattern, lastPattern )
				{
					var sIndex, eIndex;
					var copyStr = new String( orgStr );
					var retStr = "", subStr;
					
					var regFExp = new RegExp( firstPattern, "i" );
					var regEExp = new RegExp( lastPattern, "i" );
					
					var loop = 0;
		
					sIndex = copyStr.search( regFExp );
					if ( sIndex == -1 ) {
						return orgStr;
					}
					
					copyStr = copyStr.substr( sIndex + firstPattern.length );
		
					eIndex = copyStr.search( regEExp );
					if ( eIndex == -1 ) {
						return copyStr;
					}
					
					retStr = copyStr.substr( 0, eIndex );
					
					return retStr;
				}		
				
				//2007.06.21 SSL 적용후 본문에 이미지가 들어간 mht로드시 보안 경고창 뜨는 오류 수정함.
				function ImageUrl(pUrl, cnt)
				{
				    var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl+"&Cnt="+cnt;
					
					return link;
				}
		
				function CheckIfHasReplies()
				{
				    var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + pItemID + ",;", false);
					xmlhttp.send();	
					if(xmlhttp.responseText == "FALSE") {
						xmlhttp = null;	
						return false;
					}
					xmlhttp = null;
					return true;
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
				        if (gubun == "2") {
				            if (CrossYN()) {
				                checkpassword_dialogArguments[1] = btn_Delete_Onclick_Complete;
				                var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + pItemID, "CheckPassWord", GetOpenWindowfeature(340, 200));
				                try { OpenWin.focus(); } catch (e) { }
				            } else {
				                var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + pItemID, "", "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no");
				                if (typeof (ret) == "undefined") {
				                    alert("<spring:message code='ezBoard.t265'/>");
				                    return;
				                }
		
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
				                    window.opener.refresh_onclick();
				                } catch (e) {
				                }
				                window.close();
				            }
				        }
				        else {
				            alert("<spring:message code='ezBoard.t265'/>");
				            // GS 수정(2006.02.10) : 익명게시판인 경우 게시물 삭제 시 암호가 맞아도 삭제가 안되는 문제 수정 (return의 위치가 잘못되었음)
				            return;
				        }
		
				    } else {
				        if (gubun != "2") {
		
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
				                window.opener.refresh_onclick();
				            } catch (e) {
				            }
				            window.close();
				        }
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
		            window.opener.refresh_onclick();
		        } catch (e) {
		        }
		        window.close();
		    }
		
				function btn_Reply_Onclick()
				{
					if(Reply_FG != "true") {
						alert("<spring:message code='ezBoard.t303'/>");
						return;
					}
		
					window.location.href = "/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply";
				}
		
				function btn_Copy_Onclick()
				{
					if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
						alert("<spring:message code='ezBoard.t202'/>");
						return;
					}
		
					var pheigth = window.screen.availHeight;
					var pwidth = window.screen.availWidth;
					pheigth = parseInt(pheigth) / 2;
					pwidth = parseInt(pwidth) / 2;
					pheigth = pheigth - 200;
					pwidth = pwidth - 127;
					
					window.open("/ezBoard/copyBoardItem.do?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID, "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth,"");		
				}
		        window.onunload = function () {
		            refresh_onclick();
		        };
				function btnClose_onclick()
				{
				    refresh_onclick();
				}
		
				function attach_SelectAll()
				{
					var checks = lstAttachLink.all.tags("input");
					for (var i=0; i<checks.length; i++)
						checks.item(i).checked = true;
				}
		
		        //사진다운로드
				function attach_Download()
				{
					var param = {"href":new Array(), "name":new Array(), "folderpath":new String()};
					var count = 0;
		
					var checks = lstAttachLink.all.tags("input");
		
					for (var i=0; i<checks.length; i++)
					{
						if (checks.item(i).checked == true)
						{
							param["href"][count] = checks.item(i).filehref;
							param["name"][count] = checks.item(i).value;
							count++;
						}
					}
					if (count == 0)
					{
						alert("<spring:message code='ezBoard.t306'/>");
						return;
					}
		
					var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		            ezUtil.UseUTF8 = true;
					var folderpath = ezUtil.BrowseFolder();
					if (folderpath != "")
					{
						param["folderpath"] = folderpath;
						window.showModalDialog("/ezBoard/boardAttachDown.do", param, "dialogWidth:430px; dialogHeight:170px; scroll:no; status:no; help:no; scroll:no; edge:sunken");
					}
				}
		
				function MemberInfo_onclick(pUserID)
				{
		            var swidth = 420;
		            var sheight = 490;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		            
					window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
				}
		
				function Bigger()
				{
					if(curFontSize < 4) {
						curFontSize += 1;
					}
					// 20091030 : 게시판 읽기창 본문 IFRAME으로 변경
					message.txtContent.style.fontSize = fontSize[curFontSize];
				}
		
				function Smaller()
				{
					if(curFontSize > 0) {
						curFontSize -= 1;
					}
					// 20091030 : 게시판 읽기창 본문 IFRAME으로 변경
					message.txtContent.style.fontSize = fontSize[curFontSize];
				}
				
				var item_readlist_cross_dialogArguments = new Array();
				function ReaderList()
				{
		            var swidth = 520;
		            var sheight = 400;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
					var szHref = "/ezBoard/itemReadList.do?boardID=" + pBoardID + "&itemID=" + pItemID;			
					var strFeature = "status:no;dialogHeight: 400px;dialogWidth: 520px;help: no;resizable:yes";
		
					if (CrossYN()) {
					    item_readlist_cross_dialogArguments[0] = "";
					    item_readlist_cross_dialogArguments[1] = ReaderList_Complete;
					    DivPopUpShow(520, 400, szHref);
					}
					else
					    window.open(szHref,"", "width=" + swidth + ",height=" + sheight + ",top=" + ptop + ",left=" + pleft + ", resizable=yes, scrollbars=yes");
				}
				function ReaderList_Complete() {
				    DivPopUpHidden();
				}
		
				function OpenUserInfo(pUserID)
				{
		            var swidth = 420;
		            var sheight = 450;
		
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
					window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + pUserID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");			
				}
		
				function OneLineReply_onkeydown(e)
				{
				    if (e.keyCode == 13) {
				        e.returnValue = false;
				        e.cancelBubble = true;
				        Save_OneLineReply(e);
				    }
				}
		
				function Save_OneLineReply(e)
				{
					if (Reply_FG != "true") 
					{
						alert("<spring:message code='ezBoard.t303'/>");
						return;
					}
					
				    e.returnValue = false;
				    e.cancelBubble = true;
		
					//event.returnValue = false;
					//event.cancelBubble = true;
					
					//2011-04 : 한줄 답변 옵션 처리
					if(OneLineReplyFlag == "1")
					{
					    if (document.getElementById("onelinereply").value == "") 
					    {
						    alert("<spring:message code='ezBoard.t307'/>");
						    return;
					    }
					}
					
					//2011.04.13 익명게시판의 경우 한줄답변 등록시 password 추가
					if (gubun == "2" && trim(document.getElementById("txtPassWord").value) == "" )
					{
					    alert("<spring:message code='ezBoard.t391'/>");
					    txtPassWord.focus();
						return;
					}
					
					var pReplyID = "";
					//var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
					//pReplyID = ezUtil.GetGUID();
				    //ezUtil = null;
					pReplyID = generateGuid();
					
					var strXML = "";
					
					strXML += "<DATA>";
					strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
					strXML += "<ITEMID>" + pItemID + "</ITEMID>";
					strXML += "<REPLYID>" + pReplyID + "</REPLYID>";
					
					//2011-04 : 한줄 답변 옵션 처리
					if(OneLineReplyFlag == "1")
		            {
					    strXML += "<CONTENT>" + MakeXMLString(document.getElementById("onelinereply").value) + "</CONTENT>";
		                //strXML += "<IMGEMOTI>" + setEmoti + "</IMGEMOTI>";  //이모티콘 제외
		            }
					else
		            {
					    strXML += "<CONTENT></CONTENT>";
					}
		
					//2011.04.13 익명게시판의 경우 한줄답변 등록시 password 추가
					strXML += "<PASSWORD></PASSWORD>";
					strXML += "</DATA>";
					var xmlhttp = createXMLHttpRequest();
					
					xmlhttp.open("POST", "interASP/SaveOneLineReply.aspx", false);
					xmlhttp.send(strXML);
					
					if (xmlhttp.status == 200) 
					{
						xmlhttp = null;
						// 표준모듈 (2007.02.23) 수정: 불필요한 메세지 삭제
						//alert("<spring:message code='ezBoard.t309'/>");
						
						//2011-04 : 한줄 답변 옵션 처리
						if(OneLineReplyFlag == "1")
						    document.getElementById("onelinereply").value = "";
						    
						getOneLineReply();
					}
					
					xmlhttp = null;
				}
		
				function delete_onelinereply(pReplyID)
				{
				     var xmlhttp = createXMLHttpRequest();
				    
				    //게시판관리자 또는 게시판그룹관리자 또는 게시물작성자가 아니면 지울 수 없다
					if(BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") 
					{
					
					    xmlhttp.open("POST", "interASP/CheckOneLineOwner.aspx?ReplyID=" + pReplyID, false);
					    xmlhttp.send();
		        			
					    if (xmlhttp.responseText.substr(0,2) != "OK")
					    {
						    alert("<spring:message code='ezBoard.t310'/>");
						    return;
					    }
		        			
					    if (!confirm("<spring:message code='ezBoard.t311'/>")) return;
		
					}else{
					
						    if(!confirm("<spring:message code='ezBoard.t311'/>")) return;
						}
					
					xmlhttp.open("POST", "interASP/DeleteOneLineReply.aspx?ReplyID=" + pReplyID+"&gubun="+gubun, false);
					xmlhttp.send();
					getOneLineReply();			
					xmlhttp = null;
				}
				
			    function getOneLineReply()
			    {
			        var xmlhttp = createXMLHttpRequest();
			        xmlhttp.open("POST", "interASP/ReadOneLineReply.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
			        xmlhttp.send();
			        var xmldom = createXmlDom();
			        //xmldom.loadXML(xmlhttp.responseText);
			        xmldom = loadXMLString(xmlhttp.responseText);
			        xmlhttp = null;
			        strHTML = "";
			        var temp;
			        for (var i=0; i<xmldom.getElementsByTagName("REPLYID").length; i++)
			        {
			            temp = i+1;
			            strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i))+ "\")'><p>";
			        }
			        if (i==0)
			            strHTML = "<spring:message code='ezBoard.t312'/>";
		            
		            try
		            {
		                document.getElementById("onelinereplylist").innerHTML = strHTML;
		            }
		            catch(e)
		            {
		            }
			    }
				
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
					if (strItemID != "") window.location.href = window.location.href.replace(pItemID, strItemID);
				}
				
				// 게시 보기(새거)
				function Item_View_New(pBoardID, pItemID)
				{
					var pheigth = window.screen.availHeight;
					var pwidth = window.screen.availWidth;
					pheigth = parseInt(pheigth) / 2;
					pwidth = parseInt(pwidth) / 2;
					pheigth = pheigth - 284;
					pwidth = pwidth - 359;
							
					window.open("/ezBoard/boardItemViewPhoto.do?itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=700,width=1000, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");	
				}
				function GoTop()
				{
				    message.AGoTop.click();
				}
				
				function GoDown()
				{
				    message.AGoDown.click();
				}
		
		        function ImageMain(imagefilename)
		        {
		            imageonmouse(imagefilename.id);
		
		            var mainfilename = imagefilename.src;
		            if (imagefilename.src.indexOf("s_") > -1)
		                mainfilename = imagefilename.src.split("s_")[0] + imagefilename.src.split("s_")[1];
		    
		            viewimage = imagefilename.id;
		
		            document.getElementById("mainimages").src = mainfilename;
		            document.getElementById("mainimages").name = imagefilename.name;
		            document.getElementById("MainContent").innerHTML = imagefilename.title;
		
		            imageloding();
		        }
		
		        function imageloding()
		        {
		            var loading = 1000;
		
		            var newiamge = new Image();
		            newiamge.src = document.getElementById("mainimages").src;
		            var we = newiamge.width;
		            var he = newiamge.height;
		            
		            if(we == 0 && he == 0)
		            {
		                var endloading = loading + loading;
		                setTimeout("imageloding()", endloading);
		            }
		           
		            if(we > 400)
		                document.getElementById("mainimages").width = 400;
		            else
		                document.getElementById("mainimages").width = we;
		                
		            if(he > 300)
		                document.getElementById("mainimages").height = 280;
		            else
		                document.getElementById("mainimages").height = he;
		
		            var maxWidth = 400;
		            var maxHeight = 280;
		            var ratio = 0;
		
		
		            if (we > maxWidth) {
		                ratio = maxWidth / we;
		                document.getElementById("mainimages").width = maxWidth;
		                document.getElementById("mainimages").height = he * ratio;
		
		                if (document.getElementById("mainimages").height > maxHeight) {
		                    ratio = maxHeight / document.getElementById("mainimages").height;
		                    document.getElementById("mainimages").height = maxHeight;
		                    document.getElementById("mainimages").width = document.getElementById("mainimages").width * ratio;
		                }
		            }
		            else {
		                if (he > maxHeight) {
		                    ratio = maxHeight / he;
		                    document.getElementById("mainimages").height = maxHeight;
		                    document.getElementById("mainimages").width = we * ratio;
		                }
		            }
		
		
		            
		        }
		
		        function Pagenationimage(page)
		        {
		            var pageimage = "";
		
		            for(var i = 0; i < ImageCount; i++)
		            {
		                if(viewimage == "image" + i)
		                {
		                    if(page == "prevPage")
		                    {
		                        if(i == 0)
		                        {
		                            //if(pPage > 1)
		                                btn_SmallIamge("Prev");
		                            //else
		                                //alert("맨처음 이미지 입니다");
		                    
		                            return;
		                        }
		                
		                        pageimage = "image" + (i - 1);
		                    }
		                    else if(page == "nextPage")
		                    {
		                        if(i == (ImageCount - 1))
		                        {
		                            btn_SmallIamge('Nextimage');
		                            return;
		                        }
		                        else
		                            pageimage = "image" + (i + 1);
		                    }
		                }
		            }
		            viewimage = pageimage;
		            imageonmouse(pageimage);
		
		            var mainfilename = document.getElementById(pageimage).src.split("s_")[0] + document.getElementById(pageimage).src.split("s_")[1];
		            ImageMain(document.getElementById(pageimage));
		        }
		        function showHideLayers()
		        {
		            showDiv.style.display = "block";
		        }
		 
		        function bt(id, after){ document.getElementById(id).src=after; }
		
		        function btn_ImgOnclick(pMod) {
		            var swidth;
		            var sheight;
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		
		
		            if (pMod == "Del") {
		                if ((pListImage.split(";").length - 1) == 1) {
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
		                        window.opener.refresh_onclick();
		                    } catch (e) {
		                    }
		                    window.close();
		                }
		                else {
		                    swidth = 510;
		                    sheight = 500;
		                    window.open("/ezBoard/boardItemDelete.do?itemID=" + pItemID + "&boardID=" + pBoardID + "&mod=" + pMod, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ",status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                }
		            }
		            else {
		                swidth = 380;
		                sheight = 380;
		                window.open("/ezBoard/modifyImageItem.do?imageID=" + document.getElementById("mainimages").name + "&boardID=" + pBoardID + "&itemID=" + pItemID + "&page=" + pPage + "&mod=image&guBun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=yes,resizable=1,height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft, "");
		            }
		        }
		
		        function page_reload()
		        {
		            window.location.reload();
		        }
		
		        function btn_Add_Onclick()
		        {
		            var swidth = 500;
		            var sheight = 580;
		
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
		                    //alert("마지막 이미지입니다.");
		                    //return;
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
		                    //alert("처음 페이지입니다.");
		                    //return;
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
		            pListImageContent= ""; 
		            pListImage = "";
		            pImageID = "";
		            resultimage = "";
		    
		            var obj = document.getElementById("viewBox");
		            var obj2 = document.getElementById("viewboxlist");
		            if(obj.childNodes.length > 0)
		            {
		                obj2.parentNode.removeChild(obj2);
		            }
		
		            var xmldom = createXmlDom();
		
		            xmldom = loadXMLString(result);
		    
		            imagetotalcount = getNodeText(xmldom.getElementsByTagName("IMAGECOUNT")[0]);
		    
		            for(var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++)
		            {
		                pListImageContent += getNodeText(xmldom.getElementsByTagName("FILECONTENT")[i])+ "\\";
		                pListImage += getNodeText(xmldom.getElementsByTagName("FILEPATH")[i]) + ";";
		                pImageID += getNodeText(xmldom.getElementsByTagName("IMAGEID")[i]) + ";";
		                resultimage += getNodeText(xmldom.getElementsByTagName("IMAGEPATH")[i]);
		            }
		
		            ImageCount = xmldom.getElementsByTagName("ROW").length;
		            var result = resultimage.split(";");
		            var resultcount = result.length - 1;
		            var imagecontet = pListImageContent.split("\\");
		            var imageid = pImageID.split(";");
		            document.getElementById("viewBox").innerHTML += "<span id='viewboxlist'>";            
		            for(var i = 0; i < ImageCount; i++)
		            {
		                var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + escape(pBoardID) + "&fileName=" + escape(result[i].split('/')[4]);
		                document.getElementById("viewboxlist").innerHTML += "<img src='" + imgSrc + "' style='border:0' title='" + imagecontet[i] + "' id='image" + i + "' name='" + imageid[i] + "' style='cursor:pointer;' onclick='ImageMain(this)' onmouseover='imagemouseover(this)' onmouseout='imagemouseout(this)'/>";
		                if (CrossYN())
		                    document.getElementById("image" + i).style.opacity = "0.35";
		                else
		                    document.getElementById("image" + i).style.filter = 'Alpha(Opacity=35)';
		
		                document.getElementById("image" + i).style.width = imgWidth;
		                document.getElementById("image" + i).style.height = imgHeight;
		
		            }
		            document.getElementById("viewBox").innerHTML += "<span>";
		
		            if(ImageCount != 0 )
		            {
		                ImageMain(document.getElementById("image" + imagepage));
		            }
		        }
		
		        function imageonmouse(reslut)
		        {
		            for(var i = 0; i < ImageCount; i++)
		            {
		                document.getElementById("image" + i).style.border = "";
		                document.getElementById("image" + i).style.margin = "0px 4px";
		                document.getElementById("image" + i).style.width = imgWidth;
		                document.getElementById("image" + i).style.height = imgHeight;
		                if (CrossYN())
		                    document.getElementById("image" + i).style.opacity = "0.35";
		                else
		                    document.getElementById("image" + i).style.filter = "Alpha(Opacity=35)";
		            }
		
		            document.getElementById(reslut).style.border = "#2e71ff 3px solid";
					document.getElementById(reslut).style.margin = "0px 4px";
		            document.getElementById(reslut).style.width = imgWidth;
		            document.getElementById(reslut).style.height = imgHeight;
		            if (CrossYN())
		                document.getElementById(reslut).style.opacity = "1";
		            else
		                document.getElementById(reslut).style.filter = "Alpha(Opacity=100)";
		        }
		
		        function imagemouseover(image)
		        {
		            if(document.getElementById("mainimages").name == image.name)
		                return;
		            if(CrossYN())
		                image.style.opacity = "1";
		            else
		                image.style.filter = "Alpha(Opacity=100)";
		            image.style.border = "#2e71ff 3px solid";
					image.style.margin = "0px 4px";
		        }
		        function imagemouseout(image)
		        {
		            if(document.getElementById("mainimages").name == image.name)
		                return;
		            
		            if (CrossYN())
		                image.style.opacity = "0.35";
		            else
		                image.style.filter = "Alpha(Opacity=35)";
		            image.style.border = "1px solid #ffffff";
					image.style.margin = "0px 4px";
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
		        
		        function pageimageover()
		        {
		            var endpage = pPage * 10;
		            if(imagetotalcount >= endpage && pPage == 1)
		            {
		                document.getElementById("SmallImageNext").style.display = "";
		                
		            }
		            else if(pPage == 1 && imagetotalcount < 10)
		            {
		                document.getElementById("SmallImagePrev").style.display = "none";
		                document.getElementById("SmallImageNext").style.display = "none";
		            }
		            else if(pPage == 1 && endpage > 10)
		            {
		                document.getElementById("SmallImagePrev").style.display = "none";
		                document.getElementById("SmallImageNext").style.display = "";
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
		
		        function pageimageout()
		        {
		            document.getElementById("SmallImagePrev").style.display = "none";
		            document.getElementById("SmallImageNext").style.display = "none";
		        }
		
		        function btn_ImgDownload()
		        {
		            var swidth;
		            var sheight;
		
		            swidth = 440;
		            sheight = 500;
		            
		            var pwidth = window.screen.availWidth;
		            var pheight = window.screen.availHeight;
		            
		            var pleft = (pwidth - swidth) / 2;
		            var ptop = (pheight - sheight) / 2;
		            
		            window.open("/ezBoard/imagedownload.do?itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=" + sheight + ",width=" + swidth + ",top=" + ptop + ",left=" + pleft + ",status = no, toolbar=no, menubar=no,location=no, resizable=1");			
		        }
		
		    //mouseWheel Event 
		        document.onmousewheel = ScrollControl;
		
		        function ScrollControl()
		        {
		            for(var i = 0  ; i < document.getElementById("viewboxlist").getElementsByTagName("IMG").length ; i++)
		            {
		                if(event.wheelDelta == "120")
		                {
		                    if (CrossYN()) {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.opacity == "1") {
		                            if (i == document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[0]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i + 1]);
		
		                            break;
		                        }
		                    } else {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.filter == "Alpha(Opacity=100)") {
		                            if (i == document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[0]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i + 1]);
		
		                            break;
		                        }
		                    }
		
		                } else {
		                    if (CrossYN()) {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.opacity == "1") {
		                            if (i == 0)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i - 1]);
		
		                            break;
		                        }
		                    } else {
		                        if (document.getElementById("viewboxlist").getElementsByTagName("IMG")[i].style.filter == "Alpha(Opacity=100)") {
		                            if (i == 0)
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[document.getElementById("viewboxlist").getElementsByTagName("IMG").length - 1]);
		                            else
		                                ImageMain(document.getElementById("viewboxlist").getElementsByTagName("IMG")[i - 1]);
		
		                            break;
		                        }
		                    }
		                }
		            }
		        }
		        function Appr_onclick(pFlag) {
		            if (pFlag == "C") {
		                var OpenWin = window.open("/myoffice/ezBoardSTD/admin/BoardApprOpinion.aspx?ItemList=" + pItemID + ";&Mode=" + pFlag, "BoardApprOpinion", GetOpenWindowfeature(540, 300));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                var xmlhttp = createXMLHttpRequest();
		                xmlhttp.open("POST", "interASP/ApprBoardItem.aspx?ItemList=" + pItemID + ";&Mode=" + pFlag, false);
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
		
		            window.open("/ezBoard/newBoardItemTempPhoto.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&location=", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		        }
		        
		</script>
	</head>
	<body class="popup">
		<table class="layout" style="border-spacing:0; border-bottom:1px solid #b6b6b6; border:0px; width:100%">
		  <tr>
		    <td style="height:20px; vertical-align:top">
		      <div id="menu">
		        <ul>
		        	<c:choose>
		        		<c:when test="${apprFlag == 'N'}">
			                <li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005'/></span></li>
			                <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014'/></span></li>
			                <c:if test="${boardInfo.boardAdmin_FG =='true' || boardInfo.boardGroupAdmin_FG == 'OK' || boardItem.writerID == userInfo.id}">
			                    <li ID='btn_Reply' ><span onclick='btn_Add_Onclick()'><spring:message code='ezBoard.t1001'/></span></li>
			                    <li ID='btn_Modify' ><span  onclick="btn_ImgOnclick('Mod')"><spring:message code='ezBoard.t1002'/></span></li>
			                    <li ID='btn_Delete' ><span  onclick="btn_ImgOnclick('Del')"><spring:message code='ezBoard.t1003'/></span></li>
			                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t1004'/></span></li>
			                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t1004'/></span></li>
			                </c:if>
		        		</c:when>
		        		<c:when test="${apprFlag == 'C'}">
			                <li><span onClick="btn_ReWrite()"><spring:message code='ezBoard.t999021'/></span></li>
		        		</c:when>
		        		<c:otherwise>
		        			<c:if test="${boardInfo.boardAdmin_FG =='true' || boardInfo.boardGroupAdmin_FG == 'OK' || boardItem.writerID == userInfo.id}">
			                    <li ID='btn_Reply' ><span onclick='btn_Add_Onclick()'><spring:message code='ezBoard.t1001'/></span></li>
			                    <li ID='btn_Modify' ><span  onclick="btn_ImgOnclick('Mod')"><spring:message code='ezBoard.t1002'/></span></li>
			                    <li ID='btn_Delete' ><span  onclick="btn_ImgOnclick('Del')"><spring:message code='ezBoard.t1003'/></span></li>
			                    <li ID='btn_AllDelete' ><span  onclick="btn_Delete_Onclick()"><spring:message code='ezBoard.t1004'/></span></li>
			                    <li ID='btn_AlbumModify' ><span  onclick="btn_albumEdit()"><spring:message code='ezBoard.t1005'/></span></li>
		        			</c:if>
		                    <li ID='btn_Read' ><span  onclick="ReaderList()"><spring:message code='ezBoard.t1006'/></span></li>
		                    <li ID='btn_down' ><span  onclick="btn_ImgDownload()"><spring:message code='ezBoard.t1007'/></span></li>
		        		</c:otherwise>
		        	</c:choose>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		            <li ><span  onclick="btnClose_onclick()"><spring:message code='ezBoard.t12'/></span></li>
		        </ul>
		      </div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		    </td>
		  </tr>
		  <tr>
		     <td>
		         <table class="content" style="border:0px">
		            <tr>
		              <th style="width:100px; text-align:center"><spring:message code='ezBoard.t223'/></th>
		              <td style="width:100px; text-overflow:ellipsis; white-space:nowrap" id="WriteUserNM">${boardItem.writerName}</td>
		              <th style="width:60px; text-align:center"><spring:message code='ezBoard.t289'/></th>
		              <td style="width:120px; text-overflow:ellipsis; white-space:nowrap;"id="User_DeptNM">${boardItem.writerDeptName}</td>
		              <th style="width:60px; text-align:center"><spring:message code='ezBoard.t290'/></th>
		              <td style="width:120px; text-overflow:ellipsis; white-space:nowrap;" id="User_JobTitle">${boardItem.extensionAttribute3}</td>
		              <th style="width:60px; text-align:center"><spring:message code='ezBoard.t224'/></th>
		              <td style="width:125px; text-overflow:ellipsis; white-space:nowrap;" id="User_WriteDate">${boardItem.writeDate} </td>
		            </tr>
		            <tr>
		              <th style="width:100px; text-align:center"><spring:message code='ezBoard.t291'/></th>
		              <td id="cTitle" colspan="7"><div id="title" style="OVERFLOW-Y:auto; WIDTH:100%; vertical-align:middle; color:#666">${boardItem.title}</div></td>
		            </tr>
		            <tr>
		                <th ><spring:message code='ezBoard.t1008'/></th>
		                <td id="cimagecontent" colspan="7">
		                    <div id="Div2" style="OVERFLOW-Y: auto; WIDTH: 100%; height:30px;" >${boardItem.mainContent}</div>
		                </td>
		            </tr>
		          </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="width:100%;  text-align:center; vertical-align:top;padding-top:10px;" >
		        <table style="width:100%; border:1px solid #b6b6b6;  ">
				  <tr>
		        	<td style="height:68px;" colspan="3">
		            </td>
		        </tr>
		        <tr>
		            <td style="width:100px; padding-left:50px; text-align:center">
		                <img src="/images/etc/btn_005.gif" style="border:0;cursor:pointer;" onclick="Pagenationimage('prevPage');" />
		            </td>
		            <td style="padding-left:15px">
		                <table id="imagetable" style="text-align:center; border:0px;">
		                    <tr>  
		                        <td style="width:400px;height:300px; min-height:300px; border:8px solid #e3e1e2; text-align:center">
		                            <img id="mainimages" style="background-color:#ffffff;cursor:pointer;" src=""/>            
		                        </td>
		                    </tr>
		           	    </table>
		            </td>
		            <td style="width:100px; padding-right:50px; text-align:center">
		                <img src="/images/etc/btn_006.gif" style="border:0;cursor:pointer;" onclick="Pagenationimage('nextPage');" />
		            </td>
		        </tr>
		        <tr>
		        	<td style="padding:10px 0px; height:88px; text-align:center" colspan="3">
		            	<div id="MainContent" style="height:88px;overflow:auto;"></div>
		            </td>
		        </tr>
		        </table>
		    </td>
		  </tr>
		    <tr style="display:none;">
		        <td style="text-align:center">
		            <span id="MainContent" ></span>
		        </td>
		    </tr>
		    <tr>
		        <td  >
					<div style="background:#e5e5e5; border:1px solid #b6b6b6; border-top:0 none; height:70px; text-align:center; padding-top:30px;">
		            <table border="0">
		                <tr>
		                    <td style="width:30px; padding-bottom:5px; vertical-align:bottom; text-align:left" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/etc/btn_001.gif" id="SmallImagePrev" style="border:0;cursor:pointer;" onclick="btn_SmallIamge('Prev')" />
		                    </td>
		                    <td onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <div class="content" id="viewBox" style="width:100%; border:0;" ></div>
		                    </td>
		                    <td style="width:30px; padding-bottom:5px; vertical-align:bottom; text-align:right" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/etc/btn_002.gif" id="SmallImageNext" style="border:0;cursor:pointer;" onclick="btn_SmallIamge('Next')" />
		                    </td>
		                </tr>
		            </table>
				</div>
		        </td>
		    </tr>
		  <%--2011-04 : 한줄 답변 옵션 처리--%>
		  <c:choose>
		  	<c:when test="${oneLineReplyFlag == '1'}">
			  <tr>
			    <td style="height:50px">
			        <table>
			            <tr>
			                <td style="height:20px;"></td>
			            </tr>
			        </table>
			        <table class="content">   
			        <tr>
			            <th><spring:message code='ezBoard.t486'/></th>
			            <td class="pos1"><input id="onelinereply" style="WIDTH: 100%" type="text" maxLength="100" onKeyDown="OneLineReply_onkeydown(event)"></td>
			            <td class="pos2"><a class="imgbtn"><span onClick="Save_OneLineReply(event)"><spring:message code='ezBoard.t321'/></span></a></td>
			        </tr>
			        <tr>
			            <td style="height:100px" colspan="4">
			                <div id="onelinereplylist" style="OVERFLOW:auto; HEIGHT: 90px; background-color:white; padding:10px; text-align:left"></div>
			            </td>
			        </tr>
			        </table>
			      </td>
			  </tr>
			  <tr>
			    <td style="DISPLAY:none; height:50px" class="pad1">
			        <table class="file">
			            <tr>
			              <th><spring:message code='ezBoard.t292'/></th>
			
			              <td class="pos1">
			                  <div style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left" id="lstAttachLink"></div>
			              </td>
			              <td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325'/></span></a><a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98'/></span></a> </td>
			              <td id="ItemLevel"></td>
			            </tr>
			      </table>
			    </td>
			  </tr>
		  	</c:when>
		  	<c:otherwise>
		        <tr style="DISPLAY:none">
				    <td class="pad1" style="height:20px">
					    <table class="file">
				     	   <tr>
			        		<th><spring:message code='ezBoard.t292'/></th>
				          	<td class="pos1"><div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left"></div></td>
				          	<td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325'/></span></a><a class="imgbtn"><span onClick="attach_Download()"> <spring:message code='ezBoard.t98'/></span></a></td>
				          	<td id="ItemLevel"></td>
				        	</tr>
				        </table>
				    </td>
		 	 	</tr>
		  	</c:otherwise>
		  </c:choose>
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
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>