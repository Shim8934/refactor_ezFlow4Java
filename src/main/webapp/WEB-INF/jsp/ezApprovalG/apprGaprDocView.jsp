<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t367'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprDocView_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var	DocID = "<c:out value ='${docID}'/>";
		    var	DocHref = "<c:out value ='${docHref}'/>";
		    var	OpinionFlag = "<c:out value ='${opinionFlag}'/>";
		    var	ListTypeValue = "<c:out value ='${listType}'/>";
		    var	ListSusin = "<c:out value ='${listSusin}'/>";
		    var pDocState =  "<c:out value ='${docState}'/>";
		    var pOrgDocID = "<c:out value ='${orgDocID}'/>";
		    var isOpinion = "<c:out value ='${isOpinion}'/>";
		    var pDocID;
		    var pDocHref;
		    var pOpinionFlag;
		    var pUserID;
		    var pListTypeValue;
		    var arrPrevDoc = new Array();
		    var arrNextDoc = new Array();
		    var flag = false;
		    var pOrgDocHref;
		    var pDocTitle;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
		    pUserID = arr_userinfo[1];
		    var approvalFlag = "<c:out value ='${approvalFlag}'/>";     //전자결재 일반/공공 여부 (G : 공공 , S : 일반)
	        var callBackType = "<c:out value ='${callBackType}'/>";
		    var pHasOpinion = "<c:out value ='${hasOpinionYN}'/>";
		    var pOpinionType = "Show";
		    var pMailEditor = "<c:out value ='${crossEditor}'/>";
		    var signImageType = "<c:out value ='${signImageType}'/>";
		    var pMode = "<c:out value ='${mode}'/>";
		    var forceCallBackYN = "<c:out value ='${forceCallBackYN}'/>";
		    var ext = "<c:out value ='${ext}'/>";
		    var orgCompanyID = "<c:out value ='${orgCompanyID}'/>";
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
			
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
	        
		    $(function () {
		      	if(approvalFlag == "G") {
	        		$(".approvalG").css("display","");
	        		$(".approval").css("display","none");
	        	} else{
	        		$(".approvalG").css("display","none");
	        		$(".approval").css("display","");
	        	}
		      	
		      	$("#message").load(function() {
					var selectOp = $("#selectImg option").length;
					if(selectOp == 1){
						$("#selectImg option").remove();
					}
					var val = parseInt($("#selectImg option:selected").val());
					var divImg = $("#message").contents().find(".divImg");
					$(divImg).children().css("zoom",100+"%");
					var pages = $(divImg).children().length;
					if(selectOp==1){
						for(var i=1; i<=pages; i++){
							if(i <= pages){
								$("#selectImg").append("<option value='" + i + "'>" + i +" / "+pages+ " Page</option>");
							}
						}
					}
					if(pages > 1){
						window.resizeTo(1920, 1200);
						var sw = screen.width;
			    		var sh = screen.height;
			    		var cw = document.body.clientWidth;
			    		var ch = document.body.clientHeight;
			    		var top  = sh / 2 - ch / 2 - 100;
			    		var left = sw / 2 - cw / 2;
						$("#officeBtn").css("display","");
						var selectNum = $("#message").contents().find(".divImg").find(".imgDiv").index();
						$("#selectImg option:eq("+ selectNum +")").prop('selected', true);
					}
					
					var imgMove = $("#message").contents().find(".divImg").find(".imgDiv");
					$(imgMove).find(".office-image").css("zoom", 100+"%");
					if(imgMove.length == 0){
						$("#zoomIn").css("display","none");
						$("#zoomOut").css("display","none");
						$("#zoomReset").css("display","none");
						$("#prev").css("display","none");
						$("#next").css("display","none");
						$("#prevAll").css("display","none");
						$("#nextAll").css("display","none");
						$("#selectImg").css("display","none");
						$("#all").attr("src", "/images/icviewer_downsize.png");
						
					}
				});
		      	
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
		    });
		    
		    function btnOpinion_onclick() {
		        //openOpinionViewUI();
		        if (ListTypeValue == "99") {
			        openOpinionUI_New("");
		        } else {
			        openOpinionUI_New("Show");
		        }
		    }
		    function DocumentComplete() {
		        if (flag == false) {
		            if (DocHref == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1439'/>" + "<br>" + "<spring:message code='ezApprovalG.t440'/>";
		                OpenAlertUI(pAlertContent);
		                btnClose_onclick();
		                return;
		            }
		            if (pDocState == "015" && pOrgDocID.length >= 20 && "<c:out value ='${listType}'/>" == "99") {
		                document.getElementById("btnGongRam").style.display = "";
		                pOpinionType = "";
		            }
		            LoadpzFormDocInfo(); // setAttachInfo(DocID, "APR", lstAttachLink);
		            //없이 테스트
// 		            SignCheck();
		            cancelYN();
					returnYN();			      	
		        }
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
		            return;
		        }
		        result = loadXMLString(result);
		        var NodeList;
		        NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
		        if (NodeList.length <= 0) {
		            return;
		        }
		        SignXML = result;
		        
		        var rtnVal = putSignXML(SignXML);
		        
		        if (rtnVal) {
		            SaveFile();
		        }
		    }
		    
		    function putSignXML(SignXML) {
		        var retVal = false;
		        /* 2017-03-18 장진혁 try 주석처리 : mht 파일은 save하는 이유를 알수없음, 스크립트오류만 안내게 수정함 */
		         try { 
		            var NodeList;
		            var fields = message.GetFieldsList();
		            NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
		            if (NodeList.length > 0) {
		            	//nodelist 잘못가져오는듯
		                for (i = 0; i < NodeList.length; i++) {
		                    var SignType = getNodeText(SelectSingleNode(NodeList[i], "SIGNTYPE"));
		                    var SignName = getNodeText(SelectSingleNode(NodeList[i], "SIGNNAME"));
		                    var SignCont = getNodeText(SelectSingleNode(NodeList[i], "CONTENT"));
		                    var aprMemberName = getNodeText(SelectSingleNode(NodeList[i], "APRMEMBERNAME"));
		                    
		                    var field = message.GetListItem(fields, SignName);

		                    if (field) {
		                        retVal = true;
		                        if (SignType == "TEXT" || SignType == "HTML") {
		                            field.innerHTML = SignCont;
		                        }
		                        else {
		                        	var seumyung = message.GetListItem(fields, "seumyungdate" + (SignName.slice(-1)));
		                        	var habyuiDate = message.GetListItem(fields, "habyuidate" + (SignName.slice(-1)));
		                            var img = SignCont.split("::");
		                            var signWidth = parseInt(field.offsetWidth) - 4 - 15;
		                            var signHeight = parseInt(field.offsetHeight) - 4;
		                            signWidth = 50;
		                            
		                            if (seumyung) {
		                            	if (img[1] != null) {
			                            	if (img[1].indexOf(strLang7) > -1) {
			                            		signHeight = 28;
			                            	} else {
			                            		signHeight = 50;
			                            		
			                            		if (SignName.indexOf("habyuisign") > -1) {
			                            			if (!habyuiDate) {
					                            		signHeight = 28;
				                            		}
			                            		}
			                            	}
		                            	} else {
		                            		signHeight = 50;
		                            		
		                            		if (SignName.indexOf("habyuisign") > -1) {
		                            			if (!habyuiDate) {
				                            		signHeight = 28;
			                            		}
		                            		}
		                            	}
		                            } else {
		                            	signHeight = 28;
		                            }
		
		                            var strimg;
		                            if (img.length >= 1) {
		                                strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' ";
		                                strimg = strimg + " width=" + signWidth;
		                                if (signImageType == "NAME") {
		                                	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>" + "<br>" + aprMemberName;
		                                } else {
		                                	strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
		                                }
		                            }
		                            
		                            if (seumyung) {
		                            	field.innerHTML = strimg;
		                            	
		                            	if (SignName.indexOf("habyuisign") > -1) {
	                            			if (!habyuiDate) {
	                            				if (img.length >= 2 && img[1] != "") {
	    		                            		field.innerHTML = img[1] + "<br>" + strimg;
	    		                            	}
	    		                            	else {
	    		                            		field.innerHTML = strimg;
	    		                            	}
		                            		}
	                            		}
		                            } else {
		                            	if (img.length >= 2 && img[1] != "") {
		                            		field.innerHTML = img[1] + "<br>" + strimg;
		                            	}
		                            	else {
		                            		field.innerHTML = strimg;
		                            	}
		                            }
		                        }
		                    }
		                }
		            }
		        } catch (e) {
		            alert("putSignXML : " + e.description);
		            return false;
		        }
		        
		        return retVal;
		    }
		    
		    var temppDocID;
		    function cancelYN() {
		        temppDocID = pDocID;
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/doCanCelYN.do",
		    		data : {
		    			docID : pDocID,
		    			userID : pUserID,
		    			orgCompanyID : orgCompanyID
		    		},
		    		success: function(xml){
		    			cancelYN_after(loadXMLString(xml));
		    		}
		    	});
		    }
		    function cancelYN_after(xml) {
		    	var RtnVal =  getNodeText(GetChildNodes(xml)[0]);
		    	
		    	if (RtnVal == "CANCEL" || RtnVal == "CALLBACK") {
		    		document.getElementById("tbtncallback").style.display = "";
		    		
			    	if (callBackType == "CALLBACK") {
			    		btncallback_onclick();
			    	}
		    	} else {
		        	if (forceCallBackYN == "YES") {
		        		//강제회수는 기안자만 가능하도록 수정
		        		if (!checkIsDrafter()) {
		        			return;
		        		}
		        		
						var result = "";

						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezApprovalG/doForceCancelYN.do",
							data : {
								docID : temppDocID,
								userID : pUserID
							},
							success : function(xml) {
								ForcecancelYN_after(loadXMLString(xml));
							}
						});
					}
		        }
		    }
		    
	      	function ForcecancelYN_after(xml) {
		        var RtnVal =  getNodeText(GetChildNodes(xml)[0]);
	            if (RtnVal == "TRUE") {
	                document.getElementById("tbtnforcecallback").style.display = "";

	                if (callBackType == "FORCECALLBACK") {
	                	btnforcecallback_onclick();
	                }
	            }
	        }
		    
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "ING");
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		
// 		    function btnMail_onclick() {
// 		    		  $.ajax({
// 	                        type:"POST",
// 	                        dataType:"text",
// 	                        async: false,
// 	                        data : {
// 	                        	imgUrl : DocHref,
// 	                        	docID: DocID
// 	                        },
// 	                        url: "/ezApprovalG/createMailImg.do",
// 	                        success: function (data) {
// 	                		    var pheight = window.screen.availHeight;
// 	                	        var conHeight = pheight * 0.8;
// 	                	        var pwidth = window.screen.availWidth;
// 	                	        var pTop = (pheight - conHeight) / 2;
// 	                	        var pLeft = (pwidth - 890) / 2;
// 	                		        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + DocID + "&docHref=" + encodeURIComponent(DocHref);
// //	                 	        var pURL = "/ezEmail/mailWrite.do?docHref=" +  encodeURIComponent(DocHref) + "&cmd=docsend&docID=" + DocID + "&imageCnt=&target=APPROVALG";
// 	                	        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
// 	                	        newwin.focus();
// 	                        }
// 	                    });
// 		    }

		    function btnMail_onclick() {
		    	var imgUrl="";
		    	html2canvas(document.getElementById("message").contentWindow.document.getElementById("div_Content"), {
		    	background:'#fff',onrendered: function(canvas) {
					$.ajax({
	                        type:"POST",
	                        dataType:"text",
	                        data : {
	                        	imgUrl : canvas.toDataURL("image/png"),
	                        	docID: DocID
	                        },
	                        url: "/ezApprovalG/createMailImg.do",
	                        success: function (data) {
	                        }
	                    });
					}
		    	});
			    var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
			    var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + DocID + "&docHref=" + encodeURIComponent(DocHref)+"&orgCompanyID="+orgCompanyID;
	 	        //var pURL = "/ezEmail/mailWrite.do?docHref=" +  encodeURIComponent(DocHref) + "&cmd=docsend&docID=" + DocID + "&imageCnt=&target=APPROVALG";
		        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        newwin.focus();
		    }
		    
		    function btnhistory_onclick() {
		        getHistory();
		    }
		    function btnGongRam_onclick() {
		        var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/gongRamUpdate.do",
		    		data : {
		    			docID : DocID,
		    			userID: ListSusin,
		    			orgCompanyID : orgCompanyID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		},error: function() {
		    			
		    		}	
		    	});
		        
		        var dataNodes = GetChildNodes(result);
		        var tempValue = getNodeText(dataNodes[0]);
		
		        if (tempValue == "TRUE") {
		        	var pAlertContent = "";
		        	
		        	if (approvalFlag == "G") {
			            pAlertContent = "<spring:message code='ezApprovalG.t1441'/>";
		        	} else {
		        		pAlertContent = "<spring:message code='ezApprovalG.hyj23'/>";
		        	}
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        }
		    }
		    function OpenAlertUI_Close() {
				//2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				  parent.opener.getApprovalList("draft");
				}
		    
		        window.close();
		    }
		    window.onbeforeunload = function () {
		        try {
		            window.opener.openergetDocInfo();
		        }
		        catch (e) { }
		        try {
		            window.opener.Refresh_Window();
		        } catch (e) { }
		    };
		    var ezdocinfog_view_cross_dialogArguments = new Array();
		    function btnDocInfo_onclick() {
		        ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
		        
				if (ListTypeValue == "21") {
			        DivPopUpShow(420, 500, "/ezApprovalG/ezDocInfoView.do?docID=" + DocID + "&ingFlag=TMP");
				} else {
			        var mode = getDocMode();
			        DivPopUpShow(420, 500, "/ezApprovalG/ezDocInfoView.do?docID=" + DocID + "&ingFlag=" + mode);
				}
		    }
		    function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    function FieldsAvailable() {
		        message.SetEditable(false);
		    }
		
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
				
		        if (ListTypeValue == "21") { //2019-02-08 천성준 - #14965 임시보관함문서 > 문서보기 > 통합PC저장 시, 첨부 및 문서파일을 내려받을수 없던 문제해결
			        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=TMP&orgCompanyID=" + orgCompanyID);
		        } else {
		        	var mode = getDocMode();
			        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=" + mode + "&orgCompanyID=" + orgCompanyID);
		        }
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    function getDocMode() {
		    	var rtnVal = "APR";
		    	
		    	try {
		    		$.ajax({
		     			type : "POST",
		     			dataType : "text",
		     			async : false,
		     			url : "/ezApprovalG/getLineMode.do",
		     			data : {
		     					docID : pDocID,
		     					orgCompanyID : orgCompanyID
		     					},
		     			success: function(result) {
		     				rtnVal = result;
		     			}        			
		            });
		    	} catch (e) {
		    		alert("getDocMode() :: " + e.description);
		    	}
		    	
		    	return rtnVal;
		    }
		    
		    function btncallback_onclick() {
	            var pMsg = "<spring:message code='ezApprovalG.t68'/>";
	            OpenInformationUI(pMsg, btncallback_onclick_Complete);
	        }
		    
	        function btncallback_onclick_Complete(ans) {
				DivPopUpHidden();

	            if (ans) {
					var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
					if (!retVal) {
						return;
					}

					doCancel();
	            }
	        }
	        
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=apprv", "addRelated", getOpenWindowfeature(480, 505));
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
	        
	        function doCancel() {
				var GetCurrentlinelist = getAprLinefor("APR", DocID);
				var result = "";
				
				//2018-07-10 배현상, 회수와 강제회수 분기(doCancelForce.do -> doCancel.do)
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/doCancel.do",
					data : {
						docID : pDocID,
						userID : pUserID,
						orgCompanyID : orgCompanyID
					},
					success: function(xml){
						result = xml;
					}, error: function () {
						doCancel_fail();
					}
				});
				
				var RtnVal = getNodeText(GetChildNodes(loadXMLString(result))[0]);
				if (RtnVal == "TRUE") {
					SendMailToCancel_Function(GetCurrentlinelist);
					var pAlertContent = strLang891 + "<br> " + strLang892;
					OpenAlertUI(pAlertContent, OpenAlertUI_Close);
					
					//2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 회수
					if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
						var code = document.getElementById('message').contentWindow.document.getElementById('annual-conn-del-script').getAttribute("code");
						var script = document.createElement("script");
						script.type = "text/javascript";
						script.innerHTML = code;
						document.querySelector("head").appendChild(script);
						
						attitude_annual_conn(pDocID);
					}

					ExcuteInfo("CALLBACK_AFTER", "DRAFT");
				} else {
					doCancel_fail(RtnVal);
				}
	        }

			function doCancel_fail(errMsg) {
				if (!errMsg) {
					errMsg = "";
				}

				var pAlertContent = "";

				switch (errMsg) {
					case "ERR01":
						pAlertContent = strLang895;
						break;
					case "ERR02":
						pAlertContent = strLang896;
						break;
					case "ERR03":
						pAlertContent = strLang897;
						break;
					default:
						pAlertContent = strLang898;
						break;
				}

				OpenAlertUI(pAlertContent);
				ExcuteInfo("CALLBACK_FAIL", "DRAFT");
			}
	        
	        function SendMailToCancel_Function(GetCurrentlinelist) {
	            var MemberList = loadXMLString(GetCurrentlinelist)
	            var pDocTitle = GetDocTitleInfoData("APR", "DOCTITLE");
	            var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
	            g_szUserID = pUserID;
	            g_senderinfo = "";
	            for (i = 0; i < objNodes.length; i++) {
	                var nowstate = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[12]);
	                var LineUserID = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[4]);
	                var LineSN = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[0]);
	                if (nowstate == "002" || nowstate == "003") {
	                    if (LineSN != "1") {
	                        sendmail(LineUserID, pDocTitle, arr_userinfo[2], js_yyyy_mm_dd_hh_mm_ss(), "callback", "")
	                    }
	                }

	            }
	        }
	        
	        function GetDocTitleInfoData(mode, filed) {
	            try {
	                var value = "";
	                var xmlpara = createXmlDom();
	                var objNode;
	                
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	                createNodeAndInsertText(xmlpara, objNode, "mode", mode);
	                createNodeAndInsertText(xmlpara, objNode, "fields", filed);

	                var xmlhttp = createXMLHttpRequest();
	                xmlhttp.open("Post", "/ezApprovalG/GetDocInfoMode.do", false);
	                xmlhttp.send(xmlpara);

	                var xmlDocument = createXmlDom();
	                xmlDocument = loadXMLString(xmlhttp.responseText);

	                var objNodes = GetChildNodes(xmlDocument.documentElement);

	                if (objNodes) {
	                    if (objNodes.length > 0) {
	                        value = getNodeText(objNodes[0]);
	                    }
	                }
	                return value;
	            }
	            catch (e) { }
	        }
	        
	        function js_yyyy_mm_dd_hh_mm_ss() {
	            now = new Date();
	            year = "" + now.getFullYear();
	            month = "" + (now.getMonth() + 1); if (month.length == 1) { month = "0" + month; }
	            day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
	            hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
	            minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
	            second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
	            return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
	        }
	        
	        function RemoveDoc_Complete() {
	            try { window.opener.getDocList(); } catch (e) { }
	            window.close();
	        }
	        
	        //2018-07-10 배현상, 강제회수 분기(btnforcecallback_onclick 생성)
	        function btnforcecallback_onclick() {
	        	var pMsg = "<spring:message code='ezApprovalG.t68'/>";
	        	OpenInformationUI(pMsg, btnforcecallback_onclick_complete);
	        }

	        function btnforcecallback_onclick_complete(ans) {
				DivPopUpHidden();

				if (ans) {
					var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
					if (!retVal) {
						return;
					}

					doForceCancel();
				}
	        }
	        
	        //2018-07-10 배현상, 강제회수 분기(doForceCancel 생성)
	        function doForceCancel() {
				var GetCurrentlinelist = getAprLinefor("APR", DocID);
				var result = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/doCancelForce.do",
					data : {
						docID : pDocID,
						userID : pUserID
					},
					success: function(xml){
						result = xml;
					}, error: function () {
						doCancel_fail();
					}
				});
				
				var RtnVal = getNodeText(GetChildNodes(loadXMLString(result))[0]);
				if (RtnVal == "TRUE") {
					SendMailToCancel_Function(GetCurrentlinelist);
					var pAlertContent = strLang891 + "<br> " + strLang892;
					OpenAlertUI(pAlertContent, OpenAlertUI_Close);
					
					//2020-04-03 김정언 : 근태관리 연동양식일 경우 추가 - 강제회수
					if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
						var code = document.getElementById('message').contentWindow.document.getElementById('annual-conn-del-script').getAttribute("code");
						var script = document.createElement("script");
						script.type = "text/javascript";
						script.innerHTML = code;
						document.querySelector("head").appendChild(script);
						
						attitude_annual_conn(pDocID);
					}

					ExcuteInfo("CALLBACK_AFTER", "DRAFT");
				} else {
					doCancel_fail(RtnVal);
				}
	        }
	        
	        function checkIsDrafter() {
	        	var rtnVal = false;
	        	
	        	try {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/getDocData.do",
						data : {
							docID : pDocID,
							mode : "APR",
							sel : "WRITERID"
						},
						success: function(xml) {
							var docXml = loadXMLString(xml);
							if (SelectSingleNodeValueNew(docXml, "DATA/WRITERID") == arr_userinfo[1]) {
								rtnVal = true;
							}
						}
	        		});
	        	} catch (e) {
	        		console.error(e);
	        	}
	        	
	        	return rtnVal;
	        }
	        
	    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
	    	function setAttachGuideText() {
	    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                
                if(bigSizeAttachDownloadLimitCount > 0) {
                	attachGuideText += strLangHSBAt06 + " <span style='color:#FF0000 ;'>" + bigSizeAttachDownloadLimitCount + strLangHSBAt09 + "</span> " + strLangHSBAt10;
                }
                
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += "</td>";
/*                 
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt05 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadPeriod + "</span></td>";
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt06 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadDay + strLangHSBAt07 + "</span>" + strLangHSBAt08;
                 */
                 
                 if (bigSizeAttachDownloadLimitCount > 0) {
                	 document.getElementById("apprAttachGuideTR").innerHTML = attachGuideText;
                 }
                 else {
                	 document.getElementById("apprAttachGuideTR").style.display = "none";
                 }
	    	}
	    	
		    var apropinion_cross_dialogArguments = new Array();
		    var temppDocSN = "";
		    function btnReturn_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
		    	if (deptCheckFlag == "3") {
		    		alert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		alert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	} else if (deptCheckFlag == "2") {
					alert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}	
		    	
		        var RecevState = getDocRecevState();
		        if (RecevState != "011" && RecevState != "012" && RecevState != "013" && RecevState != "014") {
		            if (RecevState == "015") {
		                var pAlertContent = strLang912;
		                OpenAlertUI(pAlertContent);
		            }
		            return false;
		        }
		        var pDocSN = "";
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "receiptnumber");
		        if (field) {
		            var fieldValue = trim(field.textContent);
		            if (fieldValue && fieldValue.replace("@", "") == fieldValue) {
		                var tmpDocSN = fieldValue.substr(fieldValue.lastIndexOf("-") + 1);
		                if (!isNaN(tmpDocSN))
		                    pDocSN = tmpDocSN;
		            }
		        }
		        temppDocSN = pDocSN;
		        
		        openOpinionUI_New("HeSong", btnReturn_onclick_Complete);
		    }
		    function btnReturn_onclick_Complete(ret) {
		        DivPopUpHidden();

		        if (checkAprState()) {
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
	    			window.close();
	    			return;
		    	}

		        var hesongok = true;
		        if (ret != "cancel") {
					var draftFlag = "SUSIN";
					if (pDocState === "012") {
						draftFlag = "HAPYUI";
					}
					
					var RtnVal = ExcuteInfo("HESONG_BEFORE", draftFlag);
		        	if (!RtnVal) {
		                return;
		            }

		        	var Rtnxml = loadXMLString(ret);
		            if (temppDocSN) {
		                hesongok = setCabinetHeSong(temppDocSN);
					}
		
		            if (hesongok) {
						var writerID = GetDocInfoData("APR", "writerid");
						var writerName = GetDocInfoData("APR", "writername");
						var docTitle = GetDocInfoData("APR", "doctitle");
		            	SendMailToDrafter_Hesong(writerID, writerName, docTitle);
		                hesongok = setHeSongDocInfo();

						if (hesongok) {
							ExcuteInfo("HESONG_AFTER", draftFlag);
						} else {
							ExcuteInfo("HESONG_FAIL", draftFlag);
						}
		            }
		        }
		    }
			function returnYN() {
				var req = new XMLHttpRequest();
				req.open("GET", "/ezApprovalG/returnYN.do?docID=" + pDocID + "&orgDocID=" + pOrgDocID + "&orgCompanyID=" + orgCompanyID);
				req.send();
				req.onload = function() {
					var res = req.responseText;
					switch (res) {
						case "Y":
							document.querySelector("#tbtnReturn").style.display = "";
							break;
						case "N":
							document.querySelector("#tbtnReturn").style.display = "none";
							break;
						case "E":
							console.log("fail returnYN");
							break;
					}
				}
			}
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
		  <tr>
		    <td style="height:20px" ><div id="menu">
		        <ul>
		          <c:if test="${approvalFlag == 'G'}">
			          <li id="btnGongRam" style="display:none"><span onclick ="return btnGongRam_onclick()" ><spring:message code='ezApprovalG.t1720'/></span></li>
				  </c:if>
				  <c:if test="${approvalFlag != 'G'}">
			          <li id="btnGongRam" style="display:none"><span onclick ="return btnGongRam_onclick()" ><spring:message code='ezApprovalG.hyj22'/></span></li>
				  </c:if>
				  <li id="tbtncallback" style="display: none;"><span id="btncallback" onclick="return btncallback_onclick()"><spring:message code='ezApprovalG.t66'/></span></li>
                  <li id="tbtnforcecallback" style="display: none;"><span id="btnforcecallback" onclick="return btnforcecallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
				  <li id="tbtnReturn" style="display: none;"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
		          <li id="btnOpinion"><span onClick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		          <li id="btnDocInfo" class="approvalG"><span onClick="return btnDocInfo_onclick()" ><spring:message code='ezApprovalG.t54'/></span></li>
		          <li id="btnhistory"><span onClick="btnhistory_onclick()" ><spring:message code='ezApprovalG.t61'/></span></li>
		          <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
				  <li id="btnPrint" ><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()" ></span></li>
				  <c:if test="${useExternalMailServer == 'NO'}">
                  <li id="btnMail"><span class="icon16 popup_icon16_mail_gray" onClick="return btnMail_onclick()" ></span></li>
                  </c:if>
				  <c:if test="${useCabinet == 'YES'}">
					<li><span onclick = "return addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
				  </c:if>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		          <li id="btnClose"><span onClick="return btnClose_onclick()"></span></li>
		        </ul>
		      </div></td>
		  </tr>
		  <tr>
		    <td style="vertical-align:top;height:90%;">
		            <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="aprDocViewContent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		    </td>
		  </tr>
		   <tr>
		  <td>
		  <div id="officeBtn" style="display:none;">
		  	<div style="text-align:center; background-color:rgba(0, 0, 0, 0.5); height: 50px;">
		  		<img id="zoomIn" onclick="zoomIn()" src="/images/icviewer_plus.png" width="25" height="25" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="zoomOut" onclick="zoomOut()" src="/images/icviewer_minus.png" width="25" height="25" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="zoomReset" src="/images/icviewer_reset.png" width="25" height="25" onclick="zoomReset()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="officeBar1" src="/images/icviewer_bar.png" style="position: relative; top: 13px;">
		  		<img id="prevAll" border="0" src="/images/icviewer_p_prev.png" width="25" height="25" onClick="prevClickAll()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="prev" border="0" src="/images/icviewer_prev.png" width="25" height="25" onClick="prevClick()" style="cursor:pointer; position: relative; top: 13px;">
		  			<select id="selectImg" class="imgSelect" onchange="selectImg()">
		  				<option value=""></option>
		  			</select>
		  		<img id="next" border="0" src="/images/icviewer_next.png" width="25" height="25" onClick="nextClick()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="nextAll" border="0" src="/images/icviewer_n_next.png" width="25" height="25" onClick="nextClickAll()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="officeBar2" src="/images/icviewer_bar.png" style="position: relative; top: 13px;">
		  		<img src="/images/icviewer_expend.png" class="allImg" id="all" onclick="allImg(this)" style="cursor:pointer; position: relative; top: 13px;" width="25" height="25">
			</div>
		</div>
		  </td>
		  </tr>
		  <tr>
			<td style="height:20px">
                <table class="file" style="height:80px;">
                    <tr>
                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
                            <div id="lstAttachLink" style="height:70px;"></div>
                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
                        </td>
                        <td style=" width:30%;">
							<div id="lstAttachLinkDoc" style="height:70px;"></div>
						</td>
						<td class="pos2" style="width:8%; background:#fffcfa;">
							<a class="imgbtn imgbck" style="width:60px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
							<a class="imgbtn imgbck" style="width:60px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
						</td>
                    </tr>
                </table>
                
                <%-- 대용량첨부 가이드 메세지 영역 --%>
                <table class="file" style="height: 20px;">
                    <tr id="apprAttachGuideTR"></tr>
                </table>
			</td>
		  </tr>
		</table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	</body>
</html>