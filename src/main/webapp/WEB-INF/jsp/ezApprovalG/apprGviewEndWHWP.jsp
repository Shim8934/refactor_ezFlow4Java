<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
		<script type="text/javascript" src="http://10.0.100.175:8080/webhwpctrl/js/hwpctrlapp/utils/util.js"></script>
    	<script type="text/javascript" src="http://10.0.100.175:8080/webhwpctrl/js/webhwpctrl.js"></script>
	    <script type="text/javascript">
	        var pDocID = "<c:out value='${docID}'/>";
	        var docHref = "<c:out value='${docHref}'/>";
	        var pListSusin = "<c:out value='${listSusin}'/>";
	        var porgDocID = "<c:out value='${orgDocID}'/>";
	        var pFormID = "<c:out value='${formID}'/>";
	        var pTitle = "<c:out value='${docTitle}'/>";
	        var pOpinionFlag;
	        var pListTypeValue = 4;
	        var flag = false;
	        var PrevOpinionFlag = false;
	        var NextOpinionFlag = true;
	        var doctitle = "";
	        var pOrgAttach = "";
	        var pendDir = "<c:out value='${endDir}'/>";
			var xmlhttp = createXMLHttpRequest();
			var arr_userinfo = new Array();
			arr_userinfo[0] = "user";
		    arr_userinfo[1]  = "<c:out value='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value='${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value='${susinAdmin}'/>";
	        arr_userinfo[11]  = "<c:out value='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value='${userInfo.deptName2}'/>";
	        var companyID = "<c:out value='${userInfo.companyID}'/>";
	        var pUserID = arr_userinfo[1];
	        var pUse_Editor = "<c:out value='${useEditor}'/>";
			var ext = "hwp";
			var orgCompanyID = "<c:out value='${orgCompanyID}' />";
			var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			
			window.onresize = function () {
	        	var mHeight = document.documentElement.clientHeight - 152 - document.getElementById("message").offsetTop + "px";
	       		message.Resize(mHeight);
	        }
	
			var apropinion_dialogArguments = new Array();
	        function btnOpinion_onclick() {
	            var parameter = new Array();
	            parameter[0] = pDocID;
	            parameter[1] = "Show";
	            parameter[2] = orgCompanyID;
	
	            var url = "/ezApprovalG/aprEndOpinion.do";
	            //var feature = "status:no;dialogWidth:530px;dialogHeight:520px;scroll:no;edge:sunken"
	            //var ret = window.showModalDialog(url, parameter, feature);
	            
	            apropinion_dialogArguments[0] = parameter;
	            apropinion_dialogArguments[1] = openOpinionUI_Complete;
	            DivPopUpShow(530, 520, "/ezApprovalG/aprEndOpinion.do");
	        }
	        
	        function openOpinionUI_Complete() {
		        DivPopUpHidden();
		    }
	
	        function CheckOpinionInfo() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getEndOpinionInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
		
		        Resultxml = result;
		
		        var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
		
		        if (NodeList.length != "0") {
		            return true;
		        } else {
		            return false;
		        }
	        }
	
	        function window_onload() {
	            window.onresize();
	
	            /* HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
	            HwpCtrl.SetSaveMode(1); */
				
	            if ("${pass}" != "<RESULT>TRUE</RESULT>") {
	                QuitWindow();
	            }
	        }
	
			function QuitWindow() {
			    menu.style.display = "none";
			    OpenAlertUI("<spring:message code='ezApprovalG.t1443'/><br><spring:message code='ezApprovalG.t1444'/>");
			    btnClose_onclick();
			    window.close();
			}
	
			/* function OpenAlertUI(pAlertContent, CompleteFunction) {
			    var parameter = pAlertContent;
			    var url = "/ezApprovalG/ezAprAlert.do";

		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(330, 205);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
			} */
			
			
			function btnPrint_onclick() {
				message.PrintDocument();
			}
			
			function btnClose_onclick() {
			    window.close();
			}
	
			/* function OpenInformationUI(pInformationContent) {
				var parameter = pInformationContent;
				var url = "/ezApprovalG/ezAprOpinion.do";
				var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
				
				var RtnVal = window.showModalDialog(url,parameter,feature);	
				return RtnVal;
			} */
			
			//한글 pc저장이 안돼서 저장방식 변경
			 function FileDown(docTitle) {
	            var pDocID_mht = pDocID;
	            AttachDownFrame.location.href = "/ezApprovalG/downloadAttachDbClick.do?type=APPROVALGMHT&fileName=" + encodeURIComponent(docTitle + ".hwp") + "&docID=" + pDocID_mht + "&docStatus=" + "END";
	        }
	
			function btnSave_onclick() {
			    var hwpDoctitle = message.GetFieldText("doctitle").replace("\r\n", "");
			    hwpDoctitle = hwpDoctitle.replace(/\\/ig, '').replace(/\//ig, '').replace(/:/ig, '').replace(/\*/ig, '').replace(/\?/ig, '').replace(/“/ig, '').replace(/</ig, '').replace(/>/ig, '').replace(/|/ig, '').replace("“", "").replace("|", "");
				FileDown(hwpDoctitle);
			}
	
			function btnMail_onclick() {
// 			    window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=" + docHref +"&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
		        window.open("/ezEmail/mailWrite.do?docHref=" + docHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));

			}
	
			function btnBoard_onclick() {
			    var wWeight = "345";
			    var wHeight = "660";
			
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			
			    var left = (width - wWeight) / 2;
			    var top = (heigth - wHeight) / 2;
			    var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
			        "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
			
			    if (typeof (ret) != "undefined") {
			        pBoardID = ret[0];
			
			        if (pBoardID == "" || typeof (pBoardID) == "undefined") {
			            return;
			        }
			
			        var pheight = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        var pTop = (pheight - 720) / 2;
			        var pLeft = (pwidth - 765) / 2;
			
			        if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
			            alert(strLang1031);
			        }
			        else {
			            if (pUse_Editor == "" || pUse_Editor == "CK") {
			                window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			            }
			            else {
			                window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			                //window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + docHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			            }
			        }
			    }
			}
	
			function btnhistory_onclick() {
			    getHistory();
			}
	
			function getHistory() {
				var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + ext;
				centerOpenWindow(URL, 730, 430);
			}
	
			function centerOpenWindow(wfileLocation, wWeight, wHeight) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			
			        var left = (width - wWeight) / 2;
			        var top = (heigth - wHeight) / 2;
			
			        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			
			    } catch (e) {
			        alert("centerOpenWindow :: " + e.description);
			    }
			}
	
			var ezdocinfog_view_cross_dialogArguments = new Array();
			function btnDocInfo_onclick() {
				ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
		        
				var url = "/ezApprovalG/ezDocInfoView.do?docID=" + pDocID + "&ingFlag=END";
			    //var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
			    //var RtnVal = window.showModalDialog(url, "", feature);
				DivPopUpShow(420, 500, url);
			}
			
			function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
	
			function SignCheck() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getSignInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		        var SignXML = createXmlDom();
		        
		        if (result == "") {
		            SaveSignCheck();
		            return;
		        }
		        result = loadXMLString(result);
		        var NodeList;
		        NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");

		        if (NodeList.length <= 0) {
		            SaveSignCheck();
		            return;
		        }
		        return;
		    }
			
			function btnReqOpinion_onclick() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/getRelayReqOpinion.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(text){
		    			result = text.opinion;
		    		}
		    	});
		    	
				var url = "/ezApprovalG/ezAprAlertLong.do";
				var feature = "status:no;dialogWidth:330px;dialogHeight:305px;help:no;scroll:no;edge:sunken";
				
				window.showModalDialog(url, result, feature);
			}
	
			function SaveSignCheck() {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/updateSignCheck.do",
		    		data : {
		    			docID : pDocID,
		    			signCheck : "Y"
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		    	
		        return result;
			}
			
	    	function Editor_Complete() {
	        	if (pDocHref != "") {
                    var URL;
                  //URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
                    URL = document.location.protocol + "//" + "10.0.100.108" + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
                    message.Open(URL, "", "", function (res) { 
                    	if (res.result) {
    	                    if (pFormID == "") {
    	                        btnSave.style.display = "none";
    	                    }
    	
    	                    setAttachInfo(pDocID, "END", lstAttachLink);
    	
    	                    var Rtnval = CheckOpinionInfo();
    	                    if (Rtnval) {
    	                        var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
    	                        var Ans = OpenInformationUI(pInformationContent);
    	
    	                        if (Ans) {
    	                            btnOpinion_onclick();
    	                        }
    	                    }
    	
    	                    //HwpCtrl.SetImgReg();
    	                } else {
    	                    //hideProgress();
    	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
    	                    OpenAlertUI(pAlertContent);
    	                    message.Clear();
    	                }
                    	message.EditMode(0);
    	                
    	                if(useExternalMailServer == "NO") {
    				    	$("#btnMail").css("display","");
    				    }
                    }, null);
	        	}
	    	}
	    </script>
	</head>
	<body class="popup" style="overflow: hidden" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btnMail" style="display:none"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t62'/></span></li>
	                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnSave"><span onclick="return btnSave_onclick()">PC<spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnOpinion"><span onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <c:if test="${sendType eq 'T'}">
		                        <li id="btnReqOpinion"><span onclick="btnReqOpinion_onclick()">재발송의견</span></li>
	                        </c:if>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom:10px;height:820px;" >
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height: 70px;">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t65'/></th>
	                        <td>
	                            <div id="lstAttachLink" style="height: 65px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                            <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>