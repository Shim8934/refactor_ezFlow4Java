<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:97%">
	<head>
	    <title><spring:message code='ezApprovalG.t1308'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Recvdocnumber_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDeptRecev_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
	        var pDocID = "<c:out value ='${docID}'/>";
	        var DraftFlag = "<c:out value ='${draftFlag}'/>";
	        var pFormHref = new String("");
	        var pFormID = new String();
	        var pUserID = "<c:out value ='${userInfo.id}'/>";
			var pHasAttachYN = new String("N");
			var pHasOpinionYN = new String("N");
			var CurrentDate
			var flag = false;
			var fieldflag = false;
			var xmlhttp = createXMLHttpRequest();
			var xmldoc = createXmlDom();
			var xmluserInfo = createXmlDom();
			var SignCount = 0;
			var hapyuiCount = 0;
			var gongramCount = 0;
			var SignInfo = "";
			var SignInfoFlag = true;
			var pDraftFlag;
			var pSuSinFlag;
			var pChamJoFlag;
			var pSusinSN;
			var pDocType;
			var pDocState;
			var pOrgDocID;
			var pOrgHtml;
			var IsSkipDrafter;
			var badForm = false;
			var g_docnumber = "";
			var docAccess = false;
			var pCurSelRow;
			var pSusinDocURL = "";
			var DeptSymbol;
			var pPublic = "P";
			var drafterDeptid
			var gPublic = "";
			var AppendFileAttach = "";
			var AppenAprDocAttachList = "";
			var RootURL = document.location.protocol + "//" + document.location.hostname;
			var arr_userinfo = new Array();
			arr_userinfo[0] = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
	
	        var SignType = new Array();
	        var SignName = new Array();
	        var SignContent = new Array();
	        var KuyjeType = "002";
	        var signDateFormat = "<c:out value ='${optSignDateFormat}'/>";
			var isSplit = "<c:out value ='${optIsSplit}'/>";
	        var SplitKind = "<c:out value ='${optSplitKind}'/>";
	        var _opinionYN = "<c:out value ='${opinionYN}'/>";
	        var _opinionGamsaYN = "<c:out value ='${opinionGamsaYN}'/>";
	        var _usepassword = "<c:out value ='${usePassword}'/>";
	        var pDocSN = "1"; // 2023-05-22 기준 웹한글 합의문에서 전혀 사용하지 않는 변수로 확인 (상단에서 import한 .js파일에서도 미사용)
	        var pUse_Editor = "<c:out value ='${useEditor}'/>";
			var DocNumCode = "";
			var ext = "hwp";
			var isHWP = "<c:out value ='${isHWP}'/>";
			var dirPath = "<c:out value ='${dirPath}'/>";
			
			var orgCompanyID = "${userInfo.companyID}";
			var _USE_DirectSign = "<c:out value='${useDirectSign}'/>";
			var approvalFlag = "${approvalFlag}";
			var junGyulFlag = "${junGyulFlag}";
			var pSignImage_Size = "${signImageSize}";
			var docNumZeroCnt = "${docNumZeroCnt}";
			var curDocNum = "";
			var draftDeptID = "${draftDeptID}";
			var useReceiveDocNo = "${useReceiveDocNo}";
			var nonElecRec = "${nonElecRec}";
			var SummaryFlag = true;
			var pDocNumCode = "";
			var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pLimitRange = "", pPageNum = "1";
	        var cabinetID = "";
	        var tempSecurityDate = "";
	        var TaskCode = "";       
			
			var strLang12 = "";
			
			var gpGubun = "";
			
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			
			/* 2023-11-03 홍승비 - G버전에서는 부서합의문서 접수 시에도 기안자의 대결/전결이 가능하므로, 기안자의 결재유형 체크 변수 추가 */
			var CurAprType = "";
			
			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";

			// 창마다 고유한 id 지정용
			var windowUuid = getRandomId();
			var ReturnFunction;
			
			window.onresize = function () {
				document.getElementById("messageWHWPEditor").style.height = document.documentElement.clientHeight - 170 + "px";
				var mHeight = document.documentElement.clientHeight - 180 - document.getElementById("messageWHWPEditor").offsetTop + "px";
	       		message.Resize(mHeight);
	        }
			
			function process_AfterOpen() {
			    try {
			        if (pFormHref == "")
			            SetBtnStateFalse();
			        else {
			
			            if (pDraftFlag == "REDRAFT") {
			                var len;
			                var pInformationContent;
			                var Ans;
			
			                SetBtnStateTrue();
			                len = pFormHref.lastIndexOf("/");
			                pDocID = pFormHref.substr(len + 1, 20);
			                GetAprDocFormID();
			                setAttachInfo(pDocID, "APR", lstAttachLink);
			                getDocInfo();
			
			                /* 2023-05-19 홍승비 - 부서순차(병렬)합의문 초기 로딩 시 의견 표출여부 로직 수정 */
			                // 기존 사용하던 "_opinionYN" 변수는 서버단에서 항상 "N"값으로 전달되므로 로직에서 제거
			                if (pHasOpinionYN == "Y") {
								pInformationContent = "<spring:message code='ezApprovalG.t1374'/><br> <spring:message code='ezApprovalG.t10'/>";
			                    Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
			                }
			            }
			            else if (pDraftFlag == "SUSIN" || pDraftFlag == "GONGRAM") {
			                var len;
			
			                len = pFormHref.lastIndexOf("/");
			                pOrgDocID = pFormHref.substr(len + 1, 20);
			                pDocID = pOrgDocID;
			                GetAprDocFormID();
			                setAttachInfo(pDocID, "APR", lstAttachLink);
			                getDocInfo();
			                
			                if (pHasOpinionYN == "Y") {
								var pInformationContent = "<spring:message code='ezApprovalG.t1374'/><br> <spring:message code='ezApprovalG.t10'/>";
			                    var Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
			                }
			            }
			            else if (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
			                var len;
			
			                len = pFormHref.lastIndexOf("/");
			                ClearDocCellInfo();
			                setClearSusinCellInfo();
			                pOrgDocID = pFormHref.substr(len + 1, 20);
			                pDocID = pOrgDocID;
			                GetAprDocFormID();
			                setAttachInfo(pDocID, "APR", lstAttachLink);
			                getDocInfo();
			                
			                if (pHasOpinionYN == "Y") {
								var pInformationContent = "<spring:message code='ezApprovalG.t1374'/><br> <spring:message code='ezApprovalG.t10'/>";
			                    var Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
			                }
			            }
			            else {
			                SetBtnStateTrue();
			                pDraftFlag = "DRAFT";
			
			                if (pFormHref != "PC") {
			                    var len;
			                    len = pFormHref.lastIndexOf("/");
			                    pFormID = pFormHref.substr(len + 1, 10);
			                }
			
			                if (pDocID == "") {
			                    if (pReadPC) {
			                        ClearDocCellInfo();
			                        setClearSusinCellInfo();
			                    }
			                    pDocID = createNewDoc();
			                }
			            }
			        }
			    } catch (e) {
			        alert(e.description);
			    }
			}
	
			function setAutoProperty() {
			    try {
			        getDraftUserInfo();
			
			        SetAutoPropertyValue();
			
			        var rtnVal = ExcuteInfo("INIT", "")
			        if (!rtnVal) {
			            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
					    OpenAlertUI(pAlertContent);
					    return;
					}
			  } catch (e) {
			      alert(e.description);
			  }
			}
	
			function window_onload() {
				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
				
			    IsSkipDrafter = "TRUE";
				DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
			    SetBtnStateTrue();
			    getReceiveDocInfo();
			    
			    window.onresize();
			
			    /* if (pSusinDocURL != "") {
			        if (pSusinDocURL == "PC") {
			        	message.Open("", "", "", function (res) { FieldsAvailable(res.result) }, null);
			        } else {
			            showProgress("<spring:message code='ezApprovalG.t1475'/>");
			
					    var URL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + dirPath + escape(pSusinDocURL.substr(pSusinDocURL.lastIndexOf("/") + 1, pSusinDocURL.length));
					    var isTrue = HwpCtrl.LoadFile(URL, false);
			
					    if (isTrue) {
			
					        URL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pFormHref);
			
					        isTrue = HwpCtrl2.LoadFile(URL, false);
					        FieldsAvailable(isTrue);
					    } else {
					        hideProgress();
					        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			
							HwpCtrl.ClearDocument();
			            }
			        }
			    }
			
			    HwpCtrl.SetFieldFocus("doctitle");
			    HwpCtrl.ezSetScrollPosInfo(0); */
			    
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
			}
	
	
			var MoveValue = new Array("body", "doctitle", "publication", "department", "position", "telephone", "draftername", "keepperiod", "lastKyulName");
			function FieldsAvailable(isTrue) {
			    if (isTrue) {
			        setAutoProperty();
			        for (var i = 0; i < MoveValue.length; i++) {
			            if (message.FieldExist(MoveValue[i]) && message2.FieldExist(MoveValue[i])) {
			            	var doctitletemp = message2.GetFieldText(MoveValue[i]);
                            message.PutFieldText(MoveValue[i], doctitletemp);
			            }
			        }
			        form2.style.display = "none";
			        message.EditMode(0);
					message.SetViewProperties(2, 100);
			        
			        message.ScrollPosInfo(0, 0);
                    SetBody();
                    hideLoadingProgress();
                    
			        /* hideProgress();
			        process_AfterOpen();
			        HwpCtrl.SetImgReg(); */
			    }
			    else {
			    	hideLoadingProgress();
			        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			        OpenAlertUI(pAlertContent);
			        message.Clear();
			    }
			}
			
			function SetBody() {
	            if (message.FieldExist("body") && message2.FieldExist("body")) {
	                message2.GetCloneData("body", "HWP", function (data) {
	                    var text = data;
	                    message.SetCloneDataCallback(text, "body", "HWP", process_AfterOpen);
	                });
	            }
	        }
	
			function btnSetAprLine_onclick() {
			    var ret;
			    ret = openAprLineUI();
			    if (ret[3] != "" && ret[3] != "cancel") pPublic = ret[3];
			
			    if (ret[0] != "cancel" && ret[3] != "cancel") {
			        IsSkipDrafter = "FALSE";
			        btnSendDraft.Enable = "true";
			        if (approvalFlag == "S") {
                        SGetDraftAprLineInfo(ret);
                    } else {
                        GetDraftAprLineInfo(ret);
                    }
			    }
			    else {
			        if (ret[2] == "cancel") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t127'/>.";
				       OpenAlertUI(pAlertContent);
				       return;
				   }
			   }
			}
	
			var ingFlag = false;
			function btnSendDraft_onclick() {
				if (ingFlag) {
                    return;
                }
				
			    try {
			        var rtnSignInfo;
			        var pDocTitle;
			        if (message.FieldExist("doctitle")) {
			            pDocTitle = trim(message.GetFieldText("doctitle"));
			        } else {
			            pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
			        }
			        
				    if ((LastSignSN == 1 || typeof (LastSignSN) == "undefined") && IsSkipDrafter == "TRUE") {
				    	var pAlertContent = "<spring:message code='ezApprovalG.t1489'/><BR> <spring:message code='ezApprovalG.t1490'/>";
		                var Ans = OpenInformationUI(pAlertContent, CheckAprLine);
					} else {
					    if (!checkLines())
					        return;
					
					    if (message.FieldExist("docnumber")) {
					        var tempValue = message.GetFieldText("docnumber");
					        if (tempValue != tempValue.replace("분류", "")) {
					            var pAlertContent = "<spring:message code='ezApprovalG.t1691'/>";
							    OpenAlertUI(pAlertContent);
							    return;
							}
					    }
					
					    if (pDocTitle == "") {
					        var pAlertContent = "<spring:message code='ezApprovalG.t1695'/>";
						    OpenAlertUI(pAlertContent);
						    return;
						}
						else {
						 	if (CheckUsePassword()) {
		                        chk_Passwd();
		                    }
		                    else {
		                        check_skipdraft();
		                    }
					    }
					}
				  } catch (e) {
				      alert("btnSendDraft_onclick : " + e);
				  }
			}
			
		    function CheckAprLine(Ans) {
		        DivPopUpHidden();
		        if (Ans) {
		            if(approvalFlag == "G")
		        	    btnApprovalInfo("15");
                    else
		        	    btnApprovalInfo("9");
		            return;
		        }
		        else {
		            return;
		        }
		    }
			
			function CheckUsePassword() {
				var result = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/getApprovalPWD.do",
					success: function(text) {
						result = text;
					}        			
				});
				
				if (result != "N") {
					return true;
				} else {
					return false;
				}
			}
			
			function chk_Passwd_Complete(chkpass) {
				DivPopUpHidden();
		        if (chkpass == "FALSE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        check_skipdraft();
			}
			
			function check_skipdraft() {
		        if (LastSignSN == 1 || DraftLastFlag) {
		            getLastOpinon();
		        }
		
		        if (IsSkipDrafter == "FALSE") {
		            var ret;
		            var parameter = new Array();
		
		            parameter[0] = pDocID;
		            parameter[1] = _USE_DirectSign;
		            openSignUI(parameter);
		        }
		        else {
		            SaveRecevInfo();
		        }
		    }
			
			function saveRecevInfo() {
		          if ((pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") && pSusinSN != "0") {
		              var RtnVal;
		              var pAlertContent;
		              RtnVal = "true";
		              if (RtnVal == "true") {
		                  RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "")
		                  if (!RtnVal) {
		                      pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  			      OpenAlertUI(pAlertContent);
			  			      return;
			  			  }
		                  
		                  if (RtnVal) RtnVal = SaveDraftDocInfo();
		
		                  if (RtnVal == "TRUE") {
		                      RtnVal = setSusinUpdataDocID();
		                      RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "")
		                      if (!RtnVal) {
		                          pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  				      OpenAlertUI(pAlertContent);
			  				      return;
			  				  }
		
		                      if (LastSignSN == 1 || DraftLastFlag) {
		                          RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "")
		                          if (!RtnVal) {
		                              pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  					      OpenAlertUI(pAlertContent);
			  					      return;
			  					  }
		                      }
		                      UpdateLineHistory(pDocID, "MUST");
		                      pAlertContent = "<spring:message code='ezApprovalG.t1496'/>";
			  				  OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		                  } else {
		                      UndoSignInfo(rtnSignInfo);
		
		                      if (LastSignSN == 1 || DraftLastFlag) {
		                          RtnVal = ExcuteInfo("END_FAIL", "")
		                          if (!RtnVal) {
		                              pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  					      OpenAlertUI(pAlertContent);
			  					      return;
			  					  }
		                      }
		                      pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  			      OpenAlertUI(pAlertContent);
			  			      return;
			  			  }
		              } else {
		                  UndoSignInfo(rtnSignInfo);
		
		                  if (LastSignSN == 1 || DraftLastFlag) {
		                      RtnVal = ExcuteInfo("END_FAIL", "")
		                      if (!RtnVal) {
		                          pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  				      OpenAlertUI(pAlertContent);
			  				      return;
			  				  }
		                  }
		                  SetBtnStateTrue();
		                  btnSendDraft.Enable = "true";
		
		                  pAlertContent = "[" + "<spring:message code='ezApprovalG.t1495'/>";
			  			  OpenAlertUI(pAlertContent);
			  			  return;
		              }
		          } else {
		              var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "")
		              var pAlertContent;
		              if (!RtnVal) {
		                  pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  		      OpenAlertUI(pAlertContent);
			  		      return;
			  		  }
		              RtnVal = SaveDraftDocInfo();
		              if (RtnVal == "TRUE") {
		                  RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "")
		                  if (!RtnVal) {
		                      pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  			      OpenAlertUI(pAlertContent);
			  			      return;
			  			  }
		
		                  if (LastSignSN == 1 || DraftLastFlag) {
		                      RtnVal = ExcuteInfo("DOCNUM_END", "")
		                      if (!RtnVal) {
		                          pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  				      OpenAlertUI(pAlertContent);
			  				      return;
			  				  }
		                      sendAlertMail("END", "1", "RECEV");
		                  } else {
		                	  sendAlertMail("APR", "1", "RECEV");
		                  }
		                  UpdateLineHistory(pDocID, "MUST");
		                  pAlertContent = "<spring:message code='ezApprovalG.t1496'/>";
			  			  OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		              } else {
		                  UndoSignInfo(rtnSignInfo);
		
		                  if (LastSignSN == 1 || DraftLastFlag) {
		                      RtnVal = ExcuteInfo("END_FAIL", "")
		                      if (!RtnVal) {
		                          pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
			  				      OpenAlertUI(pAlertContent);
			  				      return;
			  				  }
		                  }
		                  SetBtnStateTrue();
		                  pAlertContent = "[" + "<spring:message code='ezApprovalG.t1400'/>";
			  			  OpenAlertUI(pAlertContent);
			  			  return;
		              }
		          }
			}
			
			function openSignUI_Complete(ret) {
	            if (ret == "cancel") {
	                var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
		  		    OpenAlertUI(pAlertContent);
		  		    return;
		  		}
	            
	            if (LastSignSN == 1 || DraftLastFlag) {
	                var rtnVal;
	                rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")
	                if (!rtnVal) {
	                  var pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
		  			  OpenAlertUI(pAlertContent);
		  			  return;
		  			}
	            }
				
	            if (LastSignSN == 1 || DraftLastFlag) {
					rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
	            } else {
					rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
	            }
	            
	            if (!rtnval) {
	                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t1384'/>";
				    OpenAlertUI(pAlertContent);
				    return;
				}
				
	            if (LastSignSN == 1 || DraftLastFlag) {
	                var rtnVal;
	                rtnVal = ExcuteInfo("DOCNUM_AFTER", "")
	                if (!rtnVal) {
	                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
		  			    OpenAlertUI(pAlertContent);
		  			    return;
		  			}
	            }
	            
	            SendDraftMappingSign(ret);
			}
			
			function before_saveRecevInfo(html) {
				pOrgHtml = html;
				
				saveRecevInfo();
			}
	
			function btnOpinion_onclick() {
			    //var ret = openOpinionUI_New("");
				openOpinionUI_New("");
			}
			
			function btnPrint_onclick() {
				message.PrintDocument();
			}
			
			// function btnClose_onclick() {
			//     window.close();
			// }
	
			function window_onbeforeunload() {
			    try {
			        window.opener.openergetDocInfo();
			    } catch (e) {
					window.parent.openergetDocInfo();
				}
			    // try {
			    //     window.opener.Refresh_Window();
			    // } catch (e) { }
			}
	
		    function btnReturn_onclick() {
		        var RecevState = getDocRecevState();
		        if (RecevState != "011" && RecevState != "012" && RecevState != "014" && RecevState != "013") {
		            if (RecevState == "015") {
		                var pAlertContent = strLang912;
		                OpenAlertUI(pAlertContent);
		            }
		            return false;
		        }
		        
		        /* 2023-05-19 홍승비 - 개선된 의견 작성창을 사용하도록 회송 코드 수정, 합의문에서는 의미가 없는 pDocSN 체크 제외 */
		        /*
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "HeSong";
		        parameter[2] = KuyjeType;
		        parameter[3] = "";
		
		        if (pDocSN != "")
		            parameter[4] = "Y";
		        else
		            parameter[4] = "N";
		        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
		        parameter[99] = ext;
		        
		        temppDocSN = pDocSN;
		        apropinion_cross_dialogArguments[0] = parameter;
		        apropinion_cross_dialogArguments[1] = btnReturn_onclick_Complete;
		
		        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
		        */
		        openOpinionUI_New("HeSong", btnReturn_onclick_Complete);
		    }
		    
		    function btnReturn_onclick_Complete(ret) {
		    	DivPopUpHidden();
		    	
		    	var hesongok = true;
		        if (ret != "cancel") {
		        	setButtonReceiveTrue();
					var RtnVal = ExcuteInfo("HESONG_BEFORE", "");
		        	
		        	if (!RtnVal) {
		                OpenAlertUI("연동처리]를 실패하였습니다.");
		                return;
		            }
		        	
		        	if (hesongok) {
		        		var writerID = GetDocInfoData("APR", "writerid");
						var writerName = GetDocInfoData("APR", "writername");
						var docTitle = GetDocInfoData("APR", "doctitle");
		            	SendMailToDrafter_Hesong(writerID, writerName, docTitle);
		            	hesongok = setHeSongDocInfo();
		            	
		            	if (hesongok) {
							ExcuteInfo("HESONG_AFTER", "");
						} else {
							ExcuteInfo("HESONG_FAIL", "");
						}
		        	}
		        } else {
		            var pAlertContent = "<spring:message code='ezApprovalG.cancelHesong.JIH01'/>";
                    OpenAlertUI(pAlertContent);
		        }
		    }
		    
// 			function btnMail_onclick() {
// 			    var pheight = window.screen.availHeight;
// 			    var pwidth = window.screen.availWidth;
// 			    var pTop = (pheight - 656) / 2;
// 			    var pLeft = (pwidth - 760) / 2;
//			
// 			    if (useWebMail == "YES") {
// // 			        window.open("/myoffice/ezWmail/mail_write.aspx?DocHref=" + pFormHref + "&cmd=docsend&DocID=" + pDocID + "&TARGET=APPROVALG", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
// 			        window.open("/ezEmail/mailWrite.do?docHref=" + pFormHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
//
// 				}
// 				else {
// 			        window.open("/ezEmail/mailWrite.do?docHref=" + pFormHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
// 				}
// 			}
	
			var tempSecurity = "";
			var tempKeep = "";
			var tempUrgent = "N";
			var tempPublic = "Y";
			var tempKeyword = "";
			var tempItemCode = "";
			var tempItemName = "";
			var tempItemName2 = "";
			var tempdocnumcode = "분류";
	
			function btnDocInfo_onclick() {
			    var parameter = new Array();
			    parameter[0] = pDocID;
			    parameter[1] = "ING";
			    parameter[2] = tempKeep;
			    parameter[3] = tempSecurity;
			    parameter[4] = tempUrgent;
			    parameter[5] = tempPublic;
			    parameter[6] = tempKeyword;
			    parameter[7] = tempItemCode;
			    parameter[8] = tempItemName;
			
			    if (tempItemCode != "")
			        tempdocnumcode = tempItemCode;
			
			    var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfo.aspx?arr1=" + escape(tempKeep) + "&arr2=" + escape(tempSecurity);
			    var feature = "status:no;dialogWidth:370px;dialogHeight:555px;help:no;scroll:no;edge:sunken";
			    var ret = window.showModalDialog(url, parameter, feature);
			
			    if (ret[0] == "OK") {
			        tempKeep = ret[1];
			        tempSecurity = ret[2];
			        tempUrgent = ret[3];
			        tempPublic = ret[4];
			        tempKeyword = ret[6];
			        tempItemCode = ret[7];
			        tempItemName = ret[8];
			        tempItemName2 = ret[9];
			        SetDocOption(ret[5]);
			    }
			}
	
			function SetDocOption(tempSecurityValue) {
			    if (message.FieldExist("keepperiod"))
			        message.PutFieldText("keepperiod", tempKeep);
			
			    if (message.FieldExist("securitylevel"))
			        message.PutFieldText("securitylevel", tempSecurityValue);
			
			    if (message.FieldExist("publication")) {
			        if (tempPublic == "N")
			            message.PutFieldText("publication", "<spring:message code='ezApprovalG.t46'/>");
					else
					    message.PutFieldText("publication", "<spring:message code='ezApprovalG.t47'/>");
			    }
			    if (message.FieldExist("docnumber") && tempItemCode != "") {
			        var tempdocnumber = message.GetFieldText("docnumber");
			        tempdocnumber = tempdocnumber.replace(tempdocnumcode, tempItemCode);
			        message.PutFieldText("docnumber", tempdocnumber);
			    }
			}
	
			function btnOrgDocInfo_onclick() {
			    var openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + escape(pDocID) + "&mode=APR&docHref=" + pFormHref;
			    openwindow(openLocation, "", 880, 570);
			}
	
			function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			
			        var left = 0;
			        var top = 0;
			
			        if (window.screen.width > 800) {
			            var pleftpos;
			
			            pleftpos = parseInt(width) - 1224;
			            heigth = parseInt(heigth) - 30;
			            width = parseInt(width) - pleftpos;
			            left = pleftpos / 2;
			        }
			        else {
			            heigth = parseInt(heigth) - 30;
			            width = parseInt(width) - 10;
			        }
			
			        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			    }
			    catch (e) {
			        alert("openwindow :: " + e.description);
			    }
			}
	
			// var ezapprovalinfo_dialogArguments = new Array();
			function btnApprovalInfo(pGubun) {
                gpGubun = pGubun; 
                var onlydocinfiview = false;
			    var parameter = new Array();
			    parameter[0] = pDocID;
			    parameter[1] = "9999999999";;
			    parameter[2] = SignCount;
			    parameter[3] = SignInfo;
			    parameter[4] = hapyuiCount;
			    parameter[5] = DraftFlag;
			    parameter[6] = pSuSinFlag;
			    parameter[7] = pChamJoFlag;
			    parameter[8] = gongramCount;
			    parameter[9] = false;
			    parameter[10] = pDocType;
			    parameter[11] = "";
			    parameter[12] = "";
			    parameter[13] = DraftFlag;
			    parameter[28] = onlydocinfiview
			    parameter[30] = cabinetID;
			    parameter[31] = tempSecurity;
			    parameter[32] = tempUrgent;
			    parameter[33] = pSummery;
			    parameter[34] = pSpecialRecordCode;
			    parameter[35] = pPublicityCode;
			    parameter[36] = pLimitRange;
			    parameter[37] = pPageNum;
			    parameter[38] = tempSecurityDate;
		        parameter[39] = SummaryFlag;
		        parameter[41] = tempItemName;
		        parameter[42] = tempItemName2;
		        
		        if(pDocState == "012") {
		        	parameter[45] = "";
		        	parameter[46] = "";
		        }

                if (approvalFlag == "G") {
                    parameter[52] = basis;
                    parameter[53] = reason;
                    parameter[54] = listOpenFlag;
                    parameter[55] = fileOpenFlagList;
                    parameter[56] = limitDate;
                }

                parameter[61] = tempKeyword;
			
			    if (tempItemCode != "")
			        tempdocnumcode = tempItemCode;
			    
		        // ezapprovalinfo_dialogArguments[0] = parameter;
		        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
			    //
		       	// var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + gpGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp", 
				// 		"ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750));
		       	// try { OpenWin.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = parameter;
				showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + gpGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp", 1210, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
            }

		    function btnApprovalInfo_Complete(ret) {
				hidePopup();
 			    if (ret != undefined && ret[0] == "OK") {
			        try {
			            var savexmlhttp = createXMLHttpRequest();
			
			            if (ret[1] != false) {
			            	$.ajax({
	                    		type : "POST",
	                    		dataType : "text",
	                    		async : false,
	                    		url : "/ezApprovalG/aprLineSave.do",
	                    		data : {
	                    				ret    : ret[1]
	                    				},
	                    		success : function(result){
	                    		}
	                    	});
			
			                IsSkipDrafter = "FALSE";
			                btnSendDraftEnable = "true";
			                if (approvalFlag == "S") {
                                SGetDraftAprLineInfo(ret);
                            } else {
                                GetDraftAprLineInfo(ret);
                            }

			                if (approvalFlag == "S") {
                                if (ret[4] != undefined) {
                                    var g_SelCabXml = ret[4];
                                    var xmlCab = createXmlDom();
                                    xmlCab = loadXMLString(g_SelCabXml);
                                    cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
                                    TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
                                }

                                tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
                                tempSecurity = ret[7];
                                tempUrgent = ret[8];
                                pSummery = ret[9];
                                tempSecurityDate = ret[14];
                                pPublicityCode = ret[11];

                                tempKeep = ret[16];
                                tempItemName = ret[17];
                                tempItemName2 = ret[18];
                                pPageNum = "1";
                                pLimitRange = "1";
                                pSpecialRecordCode = "1";
                                tempPublic = ret[11];
                                SetDocOption(ret[20]);
                            }else{
                                if (ret[4] != undefined) {
                                    var g_SelCabXml = ret[4];
                                    var xmlCab = createXmlDom();
                                    xmlCab = loadXMLString(g_SelCabXml);
                                    cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
                                    TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
                                }

                                tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
                                tempSecurity = ret[7];
                                tempUrgent = ret[8];
                                pSummery = ret[9];
                                tempSecurityDate = ret[14];
                                pPublicityCode = ret[11];
                                pPublicityYN = ret[21];
                                pPageNum = ret[13];
                                pLimitRange = ret[12];
                                pSpecialRecordCode = ret[10];
                            }
			            }
			        } catch (e) {
			            alert("저장시 오류 발생");
			        }
			    }           
            }


			
		    function getDocRecevState() {
		        try {
					var result = "FALSE";
		        	
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/getDocState.do",
		        		data : {
		        			docID : pDocID,
		        			deptID: arr_userinfo[4]
		        		},
		        		success: function(text){
		        			result = text;
		        		}
		        	});
		        	
		            return result;
		        } 
		        catch (e) {
		            alert("getDocRecevState :: " + e.description);
		        }
		    }
		    
		    var messageload = false;
	        var messageload2 = false;
		    function Editor_Complete() {
		    	showLoadingProgress();
		    	if (pSusinDocURL != "") {
	                var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pSusinDocURL);
	                message.Open(URL, "", "", function (res) { messageload = res.result; }, null);
	            }
		    }
		    
		    function Editor_Complete2() {
	            setTimeout("Editor_Complete2Load();", 1000);
	        }
		    
		    function Editor_Complete2Load() {
	            if (pSusinDocURL != "") {
	                var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pFormHref);
	                message2.Open(URL, "", "", function (res) {
	                    messageload2 = true;
	                    FieldsAvailable(res.result);
	                }, null);
	            }
	        }
		    
		    // 통합 PC 저장 시작
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=APR");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    // 통합 PC 저장 끝
		    
		    function GetHTML(callback) {
		    	ingFlag = true;
	            message.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data) });
	        }
		    
	        function OpenAlertUI_Close() {
	            DivPopUpHidden();
	            btnClose_onclick();
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
	    	
	    	/* 2023-05-19 홍승비 - 최초 로딩 시 의견 존재여부 체크 후 의견 레이어 팝업 표출을 위한 함수 추가 */
			function CheckOpinionYN_complete(Ans) {
				DivPopUpHidden();
		    	if (Ans) {
					openOpinionUI_New("");
		        }
			}
	    </script>
	</head>
	<body class="popup" style="height:100%" onload="window_onload()" onbeforeunload="return window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
						<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
				        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                        <li id="btntotaldocinfo"><span onclick=<c:if test="${approvalFlag == 'G'}">"return btnApprovalInfo('15')"</c:if><c:if test="${approvalFlag != 'G'}">"return btnApprovalInfo('9')"</c:if>><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnSetAprLine" style="display: none"><span onclick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li>
	                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
	                        <li id="btnReturn"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
	                        <li id="btnDocInfo" style="display: none;"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <%-- <li id="btnOrgDocInfo"><span onclick="return btnOrgDocInfo_onclick()"><spring:message code='ezApprovalG.t367'/></span></li> --%>
	                        <li id="btnServerSave" style="display: none;"><span style="display: none; cursor: hand" onclick="return btnServerSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                   		<li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                    </ul>
						<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
				        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
				        </ul>
	                </div>
	                <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
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
	            <td>
	                <table width="100%" height="100%">
	                    <tr>
	                        <td style="padding-bottom:10px;height:800px;" id="messageWHWPEditor">
					    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
				            </td>
	                    </tr>
	                    <tr>
	                        <td style="vertical-align: top; height: 0%" id="form2">
					            <iframe id="message2" name="message2" src="/ezApprovalG/WHWPEditor.do?type=deptrecev"  style="background-color: White; height: 0px; width: 0px; border:0px;"></iframe>
					        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                        </td>
	                        <td style=" width:30%;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
							</td>
							<td class="pos2" style="width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
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
	    <xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	    <xml id="PREVNEXTDOCINFO"></xml>
	    <div id="AprMemberSN" style="display: none"></div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
		<div id="RECEIPTDEPTID" style="display: none"></div>
	</body>
</html>
