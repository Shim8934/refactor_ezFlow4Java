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
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Recvdocnumber_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDeptRecev_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
	        var pDocID = "<c:out value ='${docID}'/>";
	        var DraftFlag = "<c:out value ='${draftFlag}'/>";
	        var pFormHref = new String("");
	        var pFormID = new String();
	        var pUserID = "<c:out value ='${userInfo.id}'/>";
			var pCompanyID = "<c:out value = '${userInfo.companyID}' />";
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
	        var pDocSN = "1";
	        var pUse_Editor = "<c:out value ='${useEditor}'/>";
			var DocNumCode = "";
			var ext = "hwp";
			var isHWP = "<c:out value ='${isHWP}'/>";
			var dirPath = "<c:out value ='${dirPath}'/>";
			
			var orgCompanyID = "${userInfo.companyID}";
			var _USE_DirectSign = "<c:out value='${useDirectSign}' />"
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
			
			//부서감사 관련 2020-01-14 홍대표
			var deptgamsaCount = 0;
			
			var strLang12 = "";
			
			var gpGubun = "";
			
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
			
			                if (pHasOpinionYN == "Y") {
			                    if (_opinionYN == "Y")
			                        openOpinionUI("Display");
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
			                    if (_opinionYN == "Y")
			                        openOpinionUI("Display");
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
			                    if (_opinionYN == "Y")
			                        openOpinionUI("Display");
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
				HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
				
			    try {
			        var ezUtil = new ActiveXObject("ezUtil.MiscFunc.1");
			        ezUtil.ChangeIME(1);
			        ezUtil = null;
			    } catch (e) {
			        alert(e.description + ": window_onload");
			    }
			
			    IsSkipDrafter = "TRUE";
			    DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
			    SetBtnStateTrue();
			    getReceiveDocInfo();
			
			    if (pSusinDocURL != "") {
			        if (pSusinDocURL == "PC") {
			            HwpCtrl.LoadFile("", true);
			        } else {
			            showProgress("<spring:message code='ezApprovalG.t1475'/>");
			
					    var URL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pSusinDocURL);
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
			    HwpCtrl.ezSetScrollPosInfo(0);
			}
	
	
			var MoveValue = new Array("body", "doctitle", "publication", "department", "position", "telephone", "draftername", "keepperiod", "lastKyulName");
			function FieldsAvailable(isTrue) {
			    if (isTrue) {
			        setAutoProperty();
			        for (var i = 0; i < MoveValue.length; i++) {
			            if (HwpCtrl.CheckFieldExist(MoveValue[i]) && HwpCtrl2.CheckFieldExist(MoveValue[i])) {
			                HwpCtrl.SetCloneData(HwpCtrl2.GetCloneData(MoveValue[i], "HWP"), MoveValue[i], "HWP");
			            }
			        }
			        form2.style.display = "none";
			        hideProgress();
			        process_AfterOpen();
			        HwpCtrl.SetImgReg();
			    }
			    else {
			        hideProgress();
			        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			
				    HwpCtrl.ClearDocument();
			    }
			}
	
			function btnSetAprLine_onclick() {
			    var ret;
			    ret = openAprLineUI();
			    if (ret[3] != "" && ret[3] != "cancel") pPublic = ret[3];
			
			    if (ret[0] != "cancel" && ret[3] != "cancel") {
			        IsSkipDrafter = "FALSE";
			        btnSendDraft.Enable = "true";
			        GetDraftAprLineInfo(ret);
			    }
			    else {
			        if (ret[2] == "cancel") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t127'/>.";
				       OpenAlertUI(pAlertContent);
				       return;
				   }
			   }
			}
	
			function btnSendDraft_onclick() {
			    try {
			        var rtnSignInfo;
			        var pDocTitle;
			        if (HwpCtrl.CheckFieldExist("doctitle"))
			            pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
			        else
			            pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
			
			    if ((LastSignSN == 1 || typeof (LastSignSN) == "undefined") && IsSkipDrafter == "TRUE") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1489'/>";
				    OpenAlertUI(pAlertContent);
				    return;
				}
			
			    if (!checkLines())
			        return;
			
			    if (HwpCtrl.CheckFieldExist("docnumber")) {
			        var tempValue = HwpCtrl.GetFieldText("docnumber");
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
	                    var chkpass = chk_Passwd();
	                    if (chkpass == "False") {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    } else if (chkpass == "cancel" || chkpass == undefined) {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    }
                    
                    check_skipdraft();
			      }
			  } catch (e) {
			      alert(e.description);
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
			
			function check_skipdraft() {
		        if (LastSignSN == 1 || DraftLastFlag) {
		            getLastOpinon();
		        }
		
		        if (IsSkipDrafter == "FALSE") {
		            var ret;
		            var parameter = new Array();
		
		            parameter[0] = pDocID;
		            parameter[1] = _USE_DirectSign;
		            ret = openSignUI(parameter);
		            openSignUI_Complete(ret);
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
		                      pAlertContent = "<spring:message code='ezApprovalG.t1499'/>";
			  				OpenAlertUI(pAlertContent);
			  				window.close();
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
			  			OpenAlertUI(pAlertContent);
			  			window.close();
		
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
	
	            pOrgHtml = HwpCtrl.GetCloneData("", "HWP");
	
	            if (LastSignSN == 1 || DraftLastFlag) {
	                var rtnVal;
	                rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")
	                if (!rtnVal) {
	                  var pAlertContent = "[" + "<spring:message code='ezApprovalG.t69'/>";
		  			  OpenAlertUI(pAlertContent);
		  			  return;
		  			}
	            }
	
	            if (LastSignSN == 1 || DraftLastFlag)
	                rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
	            else
	                rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
	
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
	            rtnSignInfo = SendDraftMappingSign(ret);
	            
	            saveRecevInfo();
			}
	
			function btnOpinion_onclick() {
			    var ret = openOpinionUI_New("");
			}
			
			function btnPrint_onclick() {
			    HwpCtrl.PrintDocument("", true);
			}
			
			function btnClose_onclick() {
			    window.close();
			}
	
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
		        
		        openOpinionUI_New("HESONG", btnReturn_onclick_Complete);
		    }
		    
		    function openOpinionUI_New_Complete(ret) {
		    	try {
		    		if (ret == "Clear") {
		    			pHasOpinionYN = "N";
		    		} else if (ret == "cancel") {
		    			//do_nothing
		    		} else {
		    	        var objXML = createXmlDom();
		    	        objXML = loadXMLString(ret);
		    	        
		    	        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
		    	        if (NodeList.length != 0) {
		    	            pHasOpinionYN = "Y";
		    	        } else {
		    	            pHasOpinionYN = "N";
		    	            ret = "cancel";
		    	        }
		    		}
		    	} catch (e) {
		    		alert("openOpinionUI_New_Complete ::: " + e.description);
		    	}
		    }
		    
		    function btnReturn_onclick_Complete(ret) {
		        if (ret != "cancel") {
		            
					var RtnVal = ExcuteInfo("HESONG_BEFORE", "");
		        	
		        	if (!RtnVal) {
		                OpenAlertUI("연동처리]를 실패하였습니다.");
		                return;
		            }
		        	
	            	SendMailToDrafter_Hesong();
	                setHeSongDocInfo();
		        }
                window.close();
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
			    var feature = "status:no;dialogWidth:370px;dialogHeight:535px;help:no;scroll:no;edge:sunken";
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
			    if (HwpCtrl.CheckFieldExist("keepperiod"))
			        HwpCtrl.SetFieldText("keepperiod", tempKeep);
			
			    if (HwpCtrl.CheckFieldExist("securitylevel"))
			        HwpCtrl.SetFieldText("securitylevel", tempSecurityValue);
			
			    if (HwpCtrl.CheckFieldExist("publication")) {
			        if (tempPublic == "N")
			            HwpCtrl.SetFieldText("publication", "<spring:message code='ezApprovalG.t46'/>");
					else
					    HwpCtrl.SetFieldText("publication", "<spring:message code='ezApprovalG.t47'/>");
			    }
			    if (HwpCtrl.CheckFieldExist("docnumber") && tempItemCode != "") {
			        var tempdocnumber = HwpCtrl.GetFieldText("docnumber");
			        tempdocnumber = tempdocnumber.replace(tempdocnumcode, tempItemCode);
			        HwpCtrl.SetFieldText("docnumber", tempdocnumber);
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
					        parameter[43] = deptgamsaCount;
					        
					        if(pDocState == "012" || pDocState == "014") {
					        	parameter[45] = "";
					        	parameter[46] = "";
					        }
						
						    if (tempItemCode != "")
						        tempdocnumcode = tempItemCode;
						    
					        // ezapprovalinfo_dialogArguments[0] = parameter;
					        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
						    //
					       	// var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + gpGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp", 
							// 		"ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1144, 750));
					       	// try { OpenWin.focus(); } catch (e) { }
							ezCommon_cross_dialogArguments[0] = parameter;
							showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + gpGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp", 1144, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1144, 750), btnApprovalInfo_Complete);
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
						                GetDraftAprLineInfo(ret);
						
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
	    </script>
	</head>
	<body class="popup" style="height:100%" onload="window_onload()" onbeforeunload="return window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo('15')"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnSetAprLine" style="display: none"><span onclick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li>
	                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
	                        <li id="btnReturn"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
	                        <li id="btnDocInfo" style="display: none;"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnOrgDocInfo"><span onclick="return btnOrgDocInfo_onclick()"><spring:message code='ezApprovalG.t367'/></span></li>
	                        <li id="btnServerSave" style="display: none;"><span style="display: none; cursor: hand" onclick="return btnServerSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
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
	            <td style="padding-bottom: 10px">
	                <table width="100%" height="100%">
	                    <tr>
	                        <td valign="center" id="form1">
	                            <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<c:out value ='${hwpToolbar}'/>", "1");</script>
	                            <img src="../img/bbs_hr01.gif" width="1" height="10">
	                        </td>
	                    </tr>
	                    <tr id="form2">
	                        <td valign="center" height="1">
	                            <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl2", "3", "0", "<c:out value ='${hwpToolbar}'/>", "1");</script>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px; solid #d5d5d5; overflow: auto;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style="width:30%; overflow: auto;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
	                        </td>
							<td class="pos2" style="display:none;width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
							</td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	    <xml id="PREVNEXTDOCINFO"></xml>
	    <div id="AprMemberSN" style="display: none"></div>
	</body>
</html>