function PreviewRayerChange(pGubun, pPage) {
    pGubun = pGubun.trim();
    selobj = null;
    document.getElementById("ifrmPreViewH").src = "";
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    selobj = DocList.GetSelectedRows()[0];
    if (selobj != null && pGubun != "NONE" && selobj.childNodes.length != 0) {
    	ItemPreviewRead(selobj, pPage);   
    	$(document).ready(function () {
    		$("#ifrmPreViewH").load(function(){
    			$("#ifrmPreViewH").contents().find("tr:eq(0) #close").css("display", "none");
    			$("#ifrmPreViewH").css("height", $("#PreviewRayerH").css("height"));
    			var btn_popup = "<ul><li><img src='/images/kr/cm/btn_newpopup.gif' title='새창으로열기' alt='새창으로열기' onclick='return parent.btn_newpopup()'></li></ul>";
    			$("#ifrmPreViewH").contents().find("tr:eq(0) #menu li").css("display", "none");
    			$("#ifrmPreViewH").contents().find("tr:eq(0) #menu").append(btn_popup);
    		});
    	});
    } else {
    	document.getElementById("ifrmPreViewH").src = "/blank_kr.htm";  
    	document.getElementById("ifrmPreViewH").onload = function(){
    		if (CrossYN()) {
    			if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
    				ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = "선택된 문서가 없습니다.";	        			
    			}
    		} else {
    			if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
    				ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "선택된 문서가 없습니다.";		            		
    			}
    		}    		
    	}
    }

    if (pGubun == "OFF") {
    	pGubun = "NONE";
    }
    
    try {
        if (document.getElementById("previewmail_bar_h") != null)
            document.getElementById("previewmail_bar_h").style.cursor = "w-resize";

        if (pGubun == "H" && selobj != null) {
            if (selobj.childNodes.length != 0)
                selobj.childNodes[2].style.fontWeight = "normal";
        }

        isPreviewChange = true;
        if (pGubun == "NONE") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 133;
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            g_bPrevShow = false;
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }

			if (parent.document.getElementById("tab1")) {
				CurrenWidth = document.documentElement.clientWidth + 7;
			} else {
				CurrenWidth = document.documentElement.clientWidth - 20;
			}
            CurrentHeight = document.documentElement.clientHeight - 133;
            pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            if (CurrenWidth < (pMailListWidthH + pMailPreWidthH)) {
                if (pMailListWidthH > parseInt(CurrenWidth * 0.40)) {
                    pMailListWidthH = pMailListWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
                else {
                    pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
                }
            }

            document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            
            if ($("body").attr("class") == "tabbody") {            
            	document.getElementById("MailListRayer").style.width = pMailListWidthH-20 + "px";
            } else {
            	document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            }            
            
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68) + "px";
            
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);

            g_bPrevShow = true;
        }
        
        PreviewMode_ChangeBtn();
        Set_ApprovConfig();
        isPreviewChange = false;
        scroll();
    } catch (e) { }
}

function PreviewMode_ChangeBtn() {
    try {
    	document.getElementById("PreViewNone").className = "icon16 btn_noframe";
    	
    	if (document.getElementById("PreViewBottom")) {
    		document.getElementById("PreViewBottom").className = "icon16 btn_bottomframe";
    	}
    	
    	if (document.getElementById("PreViewleft")) {
    		document.getElementById("PreViewleft").className = "icon16 btn_leftframe";
    	}
    	
    	if (pPreviewShow_HOW == "H") {
    		if (document.getElementById("PreViewleft")) {
    			document.getElementById("PreViewleft").className = "icon16 btn_onleftframe";
    		}
    	} else {
            document.getElementById("PreViewNone").className = "icon16 btn_onnoframe";
    	}
    } catch (e) { }
}

function ItemPreviewRead(obj, page) {
	for (var i = 0; i < obj.childNodes.length; i++) {
		if (obj.childNodes[i].style.fontWeight == "bold") {
			obj.childNodes[i].style.fontWeight = "normal";
		} else {
			obj.childNodes[i].style.fontWeight = "normal";
		}
	}
	
	if (page == "Container") {
		var DocList = new ListView();
        DocList.LoadFromID("DocList");
        
        var selRow = DocList.GetSelectedRows();

        if (selRow.length <= 0) {
        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
        	alert(pAlertContent);
            return;
        }
        
        var tr = selRow[0];
        pURL = tr.getAttribute("DATA2");

        var para = new Array();
        para[0] = DocID;
        para[1] = pURL;

        if (tr.getAttribute("DATA10") != "" && tr.getAttribute("DATA10") >= GetTodayDate()) {
            if (CheckAprLine(tr.getAttribute("DATA1")) == "TRUE") {
                    chk_Passwd(UserID);
            } else {
                OpenAlertUI(strLang580,"OPEN","");
                return;
            }
        }
        else {
            pre_chk_Passwd_Complete("TRUE");
        }
	} else {
		if (pListTypeValue == "1" || pListTypeValue == "11") { //listTypeValue = 11(공유결재문서)
			if (checkAprState(selobj.getAttribute("DATA1"), selobj.getAttribute("DATA12"), selobj.getAttribute("DATA4"), selobj.getAttribute("APRMEMBERSN"), selobj.getAttribute("ORGCOMPANYID"))){
				alert("<spring:message code='ezApprovalG.bhs23'/>");
				getDocList(setting);
				return;
			}
			if (selobj.getAttribute("DATA12") == "015")
				pre_openViewDocInfo();
			else if (document.getElementById("tbtnRedraft").style.display == "none" && document.getElementById("tbtnApprove").style.display == "")
				pre_openApprovUI();
			else
				pre_btnRedraft_onclick();
		} else if (pListTypeValue == "4") {
			if (pSusinManagerFlag == "admin" || selobj.getAttribute("DATA8") == pUserID) {
				var pDraftFlag;
				var tmpDocState = selobj.getAttribute("DATA9");
				if (tmpDocState == strDocState11 || tmpDocState == strDocState16)
					pDraftFlag = "SUSIN";
				else if (tmpDocState == strDocState12 || tmpDocState == strDocState2)
					pDraftFlag = "HAPYUI";
				if (selobj.getAttribute("DATA10") == strAprState15) {
					pre_openViewDocInfo();
				}
				else {
					pre_OpenReceiveDraftUI(selobj, pDraftFlag);
				}
			} else {
				pre_openViewDocInfo();
			}
		} else if (pListTypeValue == "21") { //한양대 임시저장 
			pDocID = selobj.getAttribute("DATA1");
			pURL = selobj.getAttribute("DATA3");
			pre_btnRedraft_onclick();
		} else if (pListTypeValue != "5") {
			pre_openViewDocInfo();
		} else {
			var para = new Array();
			var tempURL = pURL;
			
			para[0] = pDocID;
			para[1] = pURL;
			
			if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
				tempURL = tempURL.substr(0, tempURL.length - 4);
			}
			
			if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp") {
				if(useWebHWP == "NO") {
					if (isIE()) {
						openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
					} else {
						var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
						alert(pAlertContent);
						
						return;
					}
				} else {
					openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
				}
			} else {
				openLocation = "/ezApprovalG/contDocView.do";
				openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL) + "&listSusin=" +"&orgCompanyID=" + orgCompanyID;
			}
			
			document.getElementById("ifrmPreViewH").src = openLocation;
		}	
	}
}

function pre_openApprovUI(allFlag) {
	var DocList = new ListView();
	DocList.LoadFromID("DocList");
	var tr = DocList.GetSelectedRows();
	var mode = "APR";
	var openLocation;
	if (tr.length > 0) {
	    var pArgument = new Array();
	    pArgument[0] = GetAttribute(tr[0], "DATA1");      
	    pArgument[1] = GetAttribute(tr[0], "DATA4");		
	    pArgument[2] = GetAttribute(tr[0], "DATA5");		
	    pArgument[3] = GetAttribute(tr[0], "DATA7");
	    pArgument[4] = GetAttribute(tr[0], "APRMEMBERSN")
	    var orgCompanyID = GetAttribute(tr[0], "ORGCOMPANYID");
	
	    if (GetAttribute(tr[0], "DATA12") == "017") {
	    	   $.ajax({
	    			type : "POST",
	    			dataType : "text",
	    			async : false,
	    			url : "/ezApprovalG/getLineMode.do",
	    			data : {
	    					docID : pArgument[0]
	    					},
	    			success: function(xml){
	    				mode = xml;
	    			}        			
	    	  });
	    }
	    
	    var formURL = GetAttribute(tr[0], "DATA3");
	    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	        openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?docID=" + encodeURI(pArgument[0]);
	        openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
	        openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag);
	    } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	        if(useWebHWP == "NO") {
	    		if (isIE()) {
	        		var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + encodeURI(pArgument[0]);
	        		openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
	        		openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2"));
	        	} else {
	        		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	        		alert(pAlertContent);
	                
	                return;
	        	}
	    	} else {
	    		var openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + encodeURI(pArgument[0]);
	    		openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
	    		openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2"));
	    	}
	    } else {
	        openLocation = "/ezApprovalG/approvui.do?docID=";
	        openLocation = openLocation + encodeURI(pArgument[0]);
	        openLocation = openLocation + "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
	        openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2")) + "&aprMemberSN=" + pArgument[4];
	    }
	    
	    document.getElementById("ifrmPreViewH").src = openLocation;
	}
	else {
	    var pAlertContent = strLang870;
	    alert(pAlertContent);
	}
}

function pre_openViewDocInfo(type) {
	if (type == undefined)
	        type = "";
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    var tr = oArrRows[0];

    var pArgument = new Array();
    var formURL = GetAttribute(tr, "DATA3");
    var DocID = GetAttribute(tr, "DATA1");
    var orgCompanyID = GetAttribute(tr, "orgCompanyID");

    pArgument[0] = DocID;
    pArgument[1] = formURL;

    if (pListTypeValue == "4") {
        pArgument[2] = GetAttribute(tr, "DATA5");
        pArgument[3] = "VIEW";
        pArgument[4] = pSusinManagerFlag;
        pArgument[5] = GetAttribute(tr, "DATA7");
        pArgument[6] = "OPINION_SHOW";
        pArgument[7] = pListTypeValue;
    } else if (pListTypeValue != "7" && pListTypeValue != "8" && pListTypeValue != "9") {
        pArgument[2] = GetAttribute(tr, "DATA11").trim();
        pArgument[3] = GetAttribute(tr, "DATA12").trim();
        pArgument[4] = GetAttribute(tr, "DATA4").trim();
        pArgument[5] = GetAttribute(tr, "DATA2").trim();
       
        if (pListTypeValue != "5") {
            pArgument[6] = "OPINION_SHOW";
        } else {
            pArgument[6] = "OPINION_HIDE";
        }
       
        pArgument[7] = pListTypeValue;
    }

    var openLocation;
    // 20191210 ezd 확장자 빼기
    var formUrlExt = getOriginalFileExtension(formURL);

    if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9") {
        if (formUrlExt === "hwp") {
        	if(useWebHWP == "NO") {
	             if (CrossYN() && isIE()) {
	             	 openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
	             } else {
	            	 var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	            	 alert(pAlertContent);
	                
	                 return;
	             }
        	} else {
       		 	openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
        	}
        }
        else {
        	openLocation = "/ezApprovalG/contDocView.do";
        }
        openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(formURL) + "&formID=&orgDocID=&sendType=" + GetAttribute(tr, "DATA5");
    }
    else {
    	// 2018.07.06 (KLIB) - ezd 확장자 처리
    	if (formUrlExt === "hwp") {
    		if(useWebHWP == "NO") {
	            	if (CrossYN() && isIE()) {
	            		openLocation = "/ezApprovalG/ezviewAprHWP.do";
	            	} else {
	            		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	            		alert(pAlertContent);
	                
	            		return;
	            	}
    		} else {
    			openLocation = "/ezApprovalG/ezviewAprWHWP.do";
    		}
    	}
    	else {
    		openLocation = "/ezApprovalG/aprDocView.do";
    	}
    	openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&docHref=" + encodeURI(pArgument[1]);
    	openLocation = openLocation + "&opinionFlag=" + encodeURI(pArgument[2]) + "&docState=" + encodeURI(pArgument[3]) + "&listSusin=" + encodeURI(pArgument[4]) + "&oDoc=" + encodeURI(pArgument[5]);
       	openLocation = openLocation + "&isOpinion=" + encodeURI(pArgument[6]);
       	openLocation = openLocation + "&listType=" + encodeURI(pArgument[7]);
       	openLocation = openLocation + "&CallBackType=" + escape(trim_Cross(type));
       	openLocation = openLocation + "&ext=" + escape(trim_Cross(ext));
       	openLocation = openLocation + "&orgCompanyID=" + orgCompanyID;
       	if(shareUser = "shareUser"){
       		openLocation += "&pageType=admin";
       	}
    }
    document.getElementById("ifrmPreViewH").src = openLocation;
}

function pre_OpenReceiveDraftUI(selobj, pDraftFlag) {
    var openLocation;
    if (selobj != null) {
        if (pDraftFlag == "SUSIN") {
        	var pURL = GetAttribute(selobj, "DATA3");
            var pDocID = GetAttribute(selobj, "DATA1").trim();
            var docHref = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
            var isMht = docHref == "mht" || (docHref != "hwp" && g_RelayG_Type.toUpperCase() == "MHT");
            if (isMht) {
                openLocation = "";
                
                if (GetAttribute(selobj,"DATA15") == "001") {
                	//언제타는지 궁금하구나
                	openLocation = "/ezApprovalG/recevG.do";
                } else {
                	openLocation = "/ezApprovalG/recevGSusin.do";
                }
                
                openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag);
                openLocation = openLocation + "&uOrgID=" + encodeURI(GetAttribute(selobj, "DATA7"));
            } else {
            	if(useWebHWP == "NO") {
	                if (/chrome/i.test(navigator.userAgent)) {
	                     alert(strLang1103);
	                     return;
	            	 } else {
	            		if (docHref == "hwp" || g_RelayG_Type.toUpperCase() == "HWP") {
	            			openLocation = "/ezApprovalG/ezRecevGSusinHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(GetAttribute(selobj, "DATA7"));
	                    }
	            	 }
            	} else {
            		openLocation = "/ezApprovalG/ezRecevGSusinWHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag) + "&uOrgID=" + encodeURI(GetAttribute(selobj, "DATA7"));
            	}
            }
            document.getElementById("ifrmPreViewH").src = openLocation;
        } else {
            var pURL = GetAttribute(selobj, "DATA3");
            var pDocID = GetAttribute(selobj, "DATA1");
            var orgCompanyID = GetAttribute(selobj, "orgCompanyID");
            
            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
            	if(useWebHWP == "NO") {
	            	if (/chrome/i.test(navigator.userAgent)) {
	            		alert(strLang1103);
	            		return;
	            	} else {
	            		openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do";
	            	}
            	} else {
            		openLocation = "/ezApprovalG/ezDeptRecevUI_WHWP.do";
            	}
            } else if (pDraftFlag == "HAPYUI" && approvalFlag == "G") {
            	openLocation = "/ezApprovalG/recevGDeptHapyui.do";
            } else {
            	openLocation = "/ezApprovalG/recev.do";
            }
            openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI(pDraftFlag) + "&orgCompanyID=" + encodeURI(orgCompanyID);
            document.getElementById("ifrmPreViewH").src = openLocation;
        }
    } else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
        return;
    }
}

function pre_btnRedraft_onclick() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    
    var oArrRows = DocList.GetSelectedRows();
    
    if (oArrRows.length <= 0) {
    	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
    	alert(pAlertContent);
        return;
    }
    
    /* 2020-08-27 홍승비 -  체크박스로 다중선택된 문서 재기안 시, 가장 상단에 존재하는 반송(004), 회송(015), 회수(006)문서를 선택하도록 수정 */
    var pFunctionType = "";
    var pCurSelRow = oArrRows[0];
    for (var i = 0; i < oArrRows.length; i++) {
    	pFunctionType = GetAttribute(oArrRows[i], "DATA10");
    	if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
    		pCurSelRow = oArrRows[i];
    		break;
    	}
    }
    
    if (pCurSelRow.getAttribute("orgcompanyid") != "" && pCurSelRow.getAttribute("orgcompanyid") != companyID) {
    	var pAlertContent = "<spring:message code='ezApprovalG.csj01'/>";
    	alert(pAlertContent);
        return;
    }
    
    if (CheckFormConnFlag(pCurSelRow.getAttribute("DATA1"))) {
        var pAlertContent = "<spring:message code='ezApprovalG.t1726'/>";
        alert(pAlertContent);
        return;
    }
    if (pCurSelRow) {
        var ret = CheckAprLineInfo(pCurSelRow);
        if (ret != "OK") {
            var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
                        "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
            alert(pAlertContent);
            return;
        }
    }
    
    if ((pListTypeValue == "1" || pListTypeValue == "11") && checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
    	alert("<spring:message code='ezApprovalG.bhs23'/>");
		getDocList(setting);
		return;
	}
    
    formURL = pCurSelRow.getAttribute("DATA3");
    var docState = pCurSelRow.getAttribute("DATA12");
    if (docState == "012" || docState == "014" || docState == "018") {
        pre_OpenReceiveDraftUI(pCurSelRow, "REDRAFT");
    }
    else if (docState == "011") {
        pre_OpenReceiveENDDraftUI(pCurSelRow, "REDRAFT");
    }
    else {
        var FunctionType = pCurSelRow.getAttribute("DATA10");
        var Html = pCurSelRow.getAttribute("DATA3");

        var Html1 = getOriginalFileExtension(Html);

        if (Html1 == "hwp") {
            if (FunctionType == "000")                   //한글양식 미결 문서
                pre_openServerDraftUI("REDRAFT", pCurSelRow);
            else
                pre_openDraftUI("REDRAFT", pCurSelRow);
        }

            //[한양대]2011.11.17 임시저장
            //서버 저장문서 open하기.
        else {
            if (FunctionType == "000")                   //미결 문서
            	pre_openServerDraftUI("REDRAFT", pCurSelRow);
            else
            	pre_openDraftUI("REDRAFT", pCurSelRow);
        }
    }
}

function pre_OpenReceiveENDDraftUI(pCurSelRow, pDraftFlag) {

    if (pCurSelRow != null) {
        if (pDraftFlag.toUpperCase() == "REDRAFT") {
            var ret = CheckAprLineInfo(pCurSelRow);
            if (ret != "OK") {
                var pAlertContent = strLang863 + "<br>" +
								strLang864 + ret + strLang865;
                OpenAlertUI(pAlertContent);
                return;
            }
        }

        var pArgument = new Array();

        pArgument[0] = GetAttribute(pCurSelRow, "DATA1");        
        pArgument[1] = GetAttribute(pCurSelRow, "DATA2");

        var pURL = GetAttribute(pCurSelRow, "DATA3");
        var tmpDocState = GetAttribute(pCurSelRow, "DATA12");
        
        var openLocation = "";
        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
        	openLocation = "/ezApprovalG/ezRecevGSusinHWP.do";

            openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&uOrgID=" + encodeURI(pArgument[1]) + "&isReDraft=" + encodeURI("Y") + "&draftFlag=" + encodeURI(pDraftFlag);
        }
        else {
        	//docstate가 012(합의) 일 경우에 부서합의 페이지 띄우도록 수정 2019-02-27 홍대표
        	if (tmpDocState == strDocState12) {
        		openLocation = "/ezApprovalG/recevGDeptHapyui.do";
        	} else {
        		var docType = GetAttribute(pCurSelRow, "DATA15");
        		if (docType == "001") {
        			openLocation = "/ezApprovalG/recevG.do";
        		} else {
        			openLocation = "/ezApprovalG/recevGSusin.do";
        		}
        	}

            openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&uOrgID=" + encodeURI(pArgument[1]) + "&isReDraft=" + encodeURI("Y") + "&draftFlag=" + encodeURI(pDraftFlag);
        }

        if (g_selReturn == "Y" && (pListTypeValue == "1" || pListTypeValue == "11")) {
            openLocation = openLocation + "&RetFlag=" + g_selReturn;
            g_selReturn = "N";
        }

        document.getElementById("ifrmPreViewH").src = openLocation;
    }
    else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
        return;
    }
}

function pre_openServerDraftUI(pDraftFlag, pCurSelRow) {
    var pArgument = new Array();
    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    
    // 2018.08.27 재기안은 윈도우 하나면 열리게 수정
    var windowName =  "";
    
    if (pDraftFlag == "REDRAFT") {
    	pArgument[3] = pCurSelRow.getAttribute("DATA15");
    	windowName = "openServerDraftUI_REDRAFT";
    } else {
    	pArgument[3] = formDocType;
    }  

    var pDocSN = pCurSelRow.getAttribute("DATA1");

    var newDocID = MakeTmp2Ing(pDocSN);

    if (pCurSelRow) {
        pArgument[4] = "0";    //susinSN 
        pArgument[5] = "";     //DocState
        pArgument[6] = "";     // 결재처리 상태
        pArgument[7] = newDocID;
    }
    else {
        pArgument[4] = "0";
        pArgument[5] = "";
        pArgument[6] = "";
        pArgument[7] = "";
    }

    //우선 만들고 tmpDocID를 넘겨주어야 한다.	
    var openLocation = "";
    
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
    	openLocation = "/ezApprovalG/draftui.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    	openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
    	openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);
    	
        // FormBuilder
        if (window.reformflag == null) {
        	// reformflag null 값이라면
        	reformflag = GetAttribute(pCurSelRow, "REFORMFLAG");
        }
        
    	if (reformflag.length > 0) {
            openLocation += "&reformflag=" + encodeURI(reformflag);
    	}
    } else {
    	if(useWebHWP == "NO") {
	    	if (!isIE()) {
	    		//노티문구가 잘못되었음. 아무래도 한글양식은 IE에서만 지원가능합니다 라고 바꿔야할듯
	            alert(strLang1103);
	            return;
	        } else {
	        	openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);;
	        }
    	} else {
    		openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);
    	}
    }
    
    document.getElementById("ifrmPreViewH").src = openLocation;
}

function pre_openDraftUI(pDraftFlag, pCurSelRow) {
	// 2018.08.27 재기안은 윈도우 하나만 열리도록 수정
	var windowName = "";
	
    if (pDraftFlag.toUpperCase() == "REDRAFT") {
        if (pCurSelRow) {
            var ret = CheckAprLineInfo(pCurSelRow);
            if (ret != "OK") {
                var pAlertContent = strLang863 + "<br>" +
							strLang864 + ret + strLang865;
                OpenAlertUI(pAlertContent);
                return;
            }
        }
        
        windowName = "openDraftUI_REDRAFT";
        
        //2020-01-16 홍대표. receptGubunYN이 Y인데 재기안 할 경우, 민원인 주소 입력 버튼이 사라지는 버그 수정. 닷넷 참고.
        if (formDocType == "") {
            formDocType = GetAttribute(pCurSelRow, "DATA15");
        }
    }

    var pArgument = new Array();
    pArgument[0] = pUserID;
    pArgument[1] = formURL;
    pArgument[2] = pDraftFlag;
    pArgument[3] = formDocType;
    
    var openLocation = "";
    if (pCurSelRow) {
        if (pListTypeValue != "5") {
            pArgument[4] = GetAttribute(pCurSelRow, "DATA9");
            pArgument[5] = GetAttribute(pCurSelRow, "DATA12");
            pArgument[6] = GetAttribute(pCurSelRow, "DATA10");
            pArgument[7] = GetAttribute(pCurSelRow, "DATA1");
        }
        else {
            pArgument[4] = "0"; 
            pArgument[5] = "";     
            pArgument[6] = "";    
            pArgument[7] = newDocID;
        }
    }
    else {
        pArgument[4] = "0";
        pArgument[5] = "";
        pArgument[6] = "";
        pArgument[7] = "";
    }
  
    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
    	openLocation = "/ezApprovalG/draftui.do?formURL=";
        openLocation = openLocation + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
        openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);

    } else {
    	if(useWebHWP == "NO") {
	    	if (!isIE()) {
	            alert("한글양식은 IE에서만 기안 할 수 있습니다.");
	            return;
	        } else {
	        	openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
	            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
	        }
    	} else {
    		openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
            openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
    	}
    }

    document.getElementById("ifrmPreViewH").src = openLocation;
}

function MailPreviewEnd(e) {
    if (PreviewH_Move) {
        document.getElementById("ResizeBarH").style.display = "none";
        document.getElementById("mailPanel").style.display = "none";
        if (PreviewH_Move) {
            var newPos_H = parseInt(document.getElementById("ResizeBarH").style.left) - 10;
            if (pMailListWidthH > newPos_H) {
                pMailPreWidthH = pMailPreWidthH + (pMailListWidthH - newPos_H);
                pMailListWidthH = newPos_H;
            } else {
                pMailPreWidthH = CurrenWidth - newPos_H;
                pMailListWidthH = newPos_H;
            }
            document.getElementById("ifrmPreViewH").style.display = "";
            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
            pMailListDiv_H = (pMailListWidthH / CurrenWidth) * 100;
            pMailPreVDiv_H = (pMailPreWidthH / CurrenWidth) * 100;

        }
        PreviewH_Move = false;
    }
}
function MailPreviewResize(e) {
    if (PreviewH_Move) {
        curevent = (typeof event == 'undefined' ? e : event);
        var minSize = parseInt(200);
        var maxSize = parseInt(document.documentElement.clientWidth - 200);
        if (curevent.clientX < minSize || curevent.clientX > maxSize) {
            MailPreviewEnd(e);
        }
        else {
            var newPos_H = curevent.clientX;

            if (newPos_H < parseInt(CurrenWidth * 0.40)) {
                newPos_H = parseInt(CurrenWidth * 0.40);
                SmallSizeList = true;
            }
            else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
                newPos_H = parseInt(CurrenWidth * 0.65);
            }

            if (newPos_H > parseInt(CurrenWidth * 0.40))
                SmallSizeList = false;

            document.getElementById("ResizeBarH").style.left = newPos_H + "px";
        }
    }
    
}
function PreviewH_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event);

    var newPos_H = curevent.clientX;

    if (newPos_H < parseInt(CurrenWidth * 0.40)) {
        newPos_H = parseInt(CurrenWidth * 0.40);
    }
    else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
        newPos_H = parseInt(CurrenWidth * 0.65);
    }

    document.getElementById("ResizeBarH").style.left = newPos_H + "px";
    document.getElementById("ResizeBarH").style.display = "";
    document.getElementById("mailPanel").style.display = "";
    PreviewH_Move = true;
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}
function Window_resize() {
    try {
        if (!isPreviewChange) {
            if (parseInt(document.documentElement.clientWidth) < 1000) {
                document.getElementById("PreViewleft").style.display = "none";
                if (pPreviewShow_HOW.trim() == "H")
                    pPreviewShow_HOW = "W";
                PreviewMode_ChangeBtn();
            }
            else {
                document.getElementById("PreViewleft").style.display = "";
            }
            if (pPreviewShow_HOW.trim() == "H") {
                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
                }
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerH").style.display = "inline-block";
                
                if (parent.document.getElementById("tab1")) {
    				CurrenWidth = document.documentElement.clientWidth + 7;
    			} else {
    				CurrenWidth = document.documentElement.clientWidth - 20;
    			}
                CurrentHeight = document.documentElement.clientHeight - 133;
                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

                if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
                    var ChangeListWidthDiv = parseInt(CurrenWidth * 0.40) - pMailListWidthH;
                    pMailListWidthH = parseInt(CurrenWidth * 0.40);
                    pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv;
                }
                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.height = CurrentHeight + 200 + "px";
                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
                document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
                document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
                pPreviewShow_HOW = "H";
                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
            }
            else if (pPreviewShow_HOW.trim() == "OFF") {
                document.getElementById("PreviewRayerH").style.display = "none";
                CurrentHeight = document.documentElement.clientHeight - 133 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = "100%";
            }
        }
        scroll();
    } catch (e) { }
}

/* 2019-07-08 홍승비 - 게시물 등록, 삭제, 복사, 이동시 좌측메뉴의 선택된 하위게시판 확장 닫히지 않도록 수정 */
//레프트 메뉴카운트 업뎃용
function leftCountRf(pDestBoardIDs) {
	// 기존 코드 주석처리
/*	var pDiv, pId, pValue, pNodeID, pTreeID;

	if (window.parent.frames["left"] != undefined) {
	    var h2 = window.parent.frames["left"].document.getElementsByTagName("h2");
	    var span = window.parent.frames["left"].document.getElementsByTagName("span");
	    
	    
	    // 2018-02-23 천성준 
	     게시판  게시물 등록, 삭제, 복사, 이동시 왼쪽 게시판 폴더 볼드 해제되는 버그 수정 
	    for (var j = 0; j < span.length; j++) {
	    	if (span[j].className == "node_selected") {
	    		pNodeID = span[j].id.replace("spn_","");
	    		pTreeID = pNodeID.split("_")[0];
	    	}
	    }
	    
	    // 2018-12-31 홍승비 - 게시판명의 변경된 태그(div -> span)로 id 찾기 + 게시판 클릭 동작 변경
	    for (var i = 0; i < h2.length; i++) {
	        if (h2[i].className == "on") {
	            pId = h2[i].getElementsByClassName("h2Title")[0].id;
	            pId = pId.replace("TreeCtr", "TreeCtrl");
	            pValue = h2[i].getElementsByClassName("h2Title")[0].getAttribute("value");
	            window.parent.frames["left"].treeViewRefresh(pId, pValue);
	            window.parent.frames["left"].node_select(pNodeID, "", pTreeID, "");
	            break;
	        }
	    }
	}*/
	var pNodeID = "";
	var leftFrame;
	
	// 즐겨찾기탭, 관리자단탭에서 좌측메뉴 접근
	if (window.parent.location.href.indexOf("/ezBoard/boardItemList_favorite.do") > -1) {
		leftFrame = window.parent.parent.frames["left"];
    } else if (window.parent.location.href.indexOf("/admin/ezBoard") > -1) {
    	leftFrame = window.parent.parent.frames["board_menu"];
    } else {
    	leftFrame = window.parent.frames["left"];
    }
	
	if (leftFrame != undefined) {
	    var h2 = leftFrame.document.getElementsByTagName("h2");
	    var span = leftFrame.document.getElementsByTagName("span");
	    
	    // 현재 선택된 하위게시판명 div의 id 저장
	    for (var j = 0; j < span.length; j++) {
	    	if (span[j].className == "node_selected") {
	    		pNodeID = span[j].id.replace("spn_","");
	    	}
	    }
	    
	    if (pNodeID != "") {
	    	leftFrame.refreshItemCnt(pNodeID);
	    }
	    
	    // 게시판을 선택하여 등록, 복사, 이동 시의 목표게시판 게시물 카운트 갱신 (해당 게시판트리가 확장된 경우에만 게시물 개수 갱신 확인 가능)
	    if (pDestBoardIDs != null && pDestBoardIDs != "") {
	    	var destBoardIDs = pDestBoardIDs.split(";"); // 갱신 대상 게시판이 여러개인 경우 ';' 기호로 잘라서 루프
	    	var destBoardLength = destBoardIDs.length;
	    	var tempDestBoardDiv = leftFrame.document.getElementsByClassName("node_div");
	    	var tempLength = tempDestBoardDiv.length;
	    	
	    	for (var d = 0; d < destBoardLength; d++) {
	    		if (destBoardIDs[d] != null && destBoardIDs[d].trim() != "") {
			    	for (var i = 0; i < tempLength; i++) {
			    		if (tempDestBoardDiv[i].id.indexOf("FromTreeView") > -1) { // 마이게시판에 등록된 하위게시판 
			    		    if (tempDestBoardDiv[i].getAttribute("data3") == destBoardIDs[d]) { 
			    		    	leftFrame.refreshItemCnt(tempDestBoardDiv[i].id); 
			    		    	break; 
			    		    	} 
		    		    } else { // 일반 하위게시판 
		    		    	if (tempDestBoardDiv[i].getAttribute("data1") == destBoardIDs[d]) { 
		    		    		leftFrame.refreshItemCnt(tempDestBoardDiv[i].id); 
		    		    		break; 
		    		    	} 
		    		    } 
			    	}
	    		} else {
	    			break;
	    		}
	    	}
	    }
	}
}


//무적의 자바 인코더
function javaURLEncode(str) {
	  return encodeURIComponent(str)
	    .replace(/\+/g, "%2b")
	    .replace(/\;/g, "%3b")
	    .replace(/!/g, "%21")
	    .replace(/'/g, "%27")
	    .replace(/\(/g, "%28")
	    .replace(/\)/g, "%29")
	    .replace(/~/g, "%7E");
}

function Set_ApprovConfig() {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezApprovalG/setApprovConfig.do",
		data : { pUserID   : arr_userinfo[1], 
				 pPreView  : pPreviewShow_HOW 
				},
		success: function(result){
		}     			
	});
}

function window_onbeforeunload() {
    if (bAttachProcess == false) {
        if (!draftFlag) {
            UndoDoc();
        }
    }
    try {
        if (bAttachProcess == false)
            window.opener.openergetDocInfo();
    }
    catch (e)
    { }
    try {
        if (bAttachProcess == false)
            window.opener.Refresh_Window();
    }
    catch (e)
    { }
    try {
    	if (bAttachProcess == false)
    		window.opener.parent.frames["right"].openergetDocInfo();
    } catch (e) 
    { }
    try {
        bAttachProcess = true;
    }
    catch (e) { }
    try {
        window.opener.getApprGraph("appr");
    } catch (e) { }
}

function pre_chk_Passwd_Complete(Rtn)
{
    if (Rtn == "FALSE") {
        var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
        OpenAlertUI(pAlertContent);
        return "";
    }
    else if (Rtn == "cancel") {
        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
        OpenAlertUI(pAlertContent);
        return "";
    }
    else {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        var tr = selRow[0];
        pURL = tr.getAttribute("DATA2");
		orgCompanyID = tr.getAttribute("ORGCOMPANYID");
        var formid = tr.getAttribute("DATA6");
        if (approvalFlag == 'S' ) {
            var docState =  tr.getAttribute("DATA12");
        } else {
            var docState =  tr.getAttribute("DATA7");
        }
        var orgdocid = trim_Cross(tr.getAttribute("DATA5"));
        var openLocation;
        var tempURL = pURL;
        
        if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
        	tempURL = tempURL.substr(0, tempURL.length - 4);
        }
        
        if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp") {
        	if(useWebHWP == "NO") {
            	if (isIE()) {
	                openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
                } else {
                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                	alert(pAlertContent);
                    
                    return;
                }
        	} else {
        		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
        	}
        } else {
            openLocation = "/ezApprovalG/contDocView.do";
        }
        openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(pURL) + "&formID=" + encodeURI(formid) + "&orgDocID=" + encodeURI(orgdocid) + "&docState=" + docState + "&orgCompanyID=" + encodeURI(orgCompanyID);
        if(share && share == 'share'){
        	openLocation += "&share=Y";
        }
        document.getElementById("ifrmPreViewH").src = openLocation;
    }
}

function scroll() {
	var BoardList_BODYHeight = document.getElementById("BoardList_BODY").clientHeight;
	var BoardListDivHeight = document.getElementById("BoardListDiv").clientHeight;
	
	 if (BoardList_BODYHeight > BoardListDivHeight) {
		if ($("#BoardList_THEAD tr th#forScroll").length > 0) {
			$("#BoardList_THEAD tr th#forScroll").remove();
		}
	} else {
		if ($("#BoardList_THEAD tr th#forScroll").length < 1) {
			
			$("#BoardList_THEAD tr").append("<th></th>");
			
				var lastTh = $("#BoardList_THEAD tr th").last();
				lastTh.attr("id", "forScroll");
				lastTh.css("width", "7px");
		}
	}
	 
	/*var lastTh = $("#BoardList_TH th").last();
	if (lastTh.attr("id") == null) {
		lastTh.css("display", "none");
	}*/
}

