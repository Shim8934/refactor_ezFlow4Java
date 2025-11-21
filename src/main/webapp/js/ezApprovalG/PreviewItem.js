// 2023-06-20 전인하 - 전자결재G > 기록물대장 미리보기 -  필요한 변수 추가. 미리보기 열람불가문서를 미리보기레이어로 열람 시도하는 경우의 분기처리.
// 미리보기가 삽입되는 페이지 구분값(g_sFlag) 변수배열 추가
var cabinetPreviewItemFlagArr = ['m01', 'm03', 'm05', 'm06', 'm12', 'm13', 'm14', 'UNTREATED', 'docShare'];
var isPreviewChange = false;
function PreviewRayerChange(pGubun, pPage) {
	if (pGubun == "NONE") {
		pGubun = "OFF";
	}
    pGubun = pGubun.trim();
    selobj = null;
    document.getElementById("ifrmPreViewH").src = "";
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    selobj = DocList.GetSelectedRows()[0];
    
    // 문서 리스트에서 선택된 컬럼이 있을 때의 분기
    if (typeof selobj != "undefined" && selobj != null && pGubun != "OFF" && selobj.childNodes.length != 0) {
    	ItemPreviewRead(selobj, pPage);
    	// 2023-09-08 전인하 - 비공개문서 미리보기 동작 이상 수정 - 문서 로딩 과정을 기존과 동일히 하되, 프레임에 load시 동작 삽입한 것을 다 사용하면 off시켜 메소드가 중첩 생성되지 않도록 함
    	$(document).ready(function() {
          $("#ifrmPreViewH").on("load", function () { // 로딩 시 해당 jQuery 로드 함수가 중첩 실행되는 것을 제거
   			// 상단 버튼 표출제어 부분 각 결재문서 보기 팝업창 내부로 이동 (화면에 잠시 나타났다가 사라지는 현상 방지)
/*    			$("#ifrmPreViewH").contents().find("tr:eq(0) #close").css("display", "none");
    			$("#ifrmPreViewH").contents().find("tr:eq(0) #menu li").css("display", "none");*/
    			$("#ifrmPreViewH").css("height", "738px"); // 미리보기 영역 높이 고정 (화면 전체 스크롤을 위해)
    		/*	var btn_popup = "<ul><li><img src='/images/kr/cm/btn_newpopup.gif' title='새창으로열기' alt='새창으로열기' onclick='return parent.btn_newpopup()'></li></ul>";
    			$("#ifrmPreViewH").contents().find("tr:eq(0) #menu").append(btn_popup);*/
            // 2023-09-05 기록물 등록대장 미리보기 - 배부대장에서 정상적으로 미리보기 할 수 있도록 분기처리, 전체관리자일 경우 미리보기 또한 가능케 하도록 분기처리, 로직개선 및 코드정리
            if ($("#ifrmPreViewH").attr("src") == strLangJIH02) { // 권한이 없어서 선택한 문서 row가 있음에도 빈문서가 로드되었을 때의 분기
                var secureApprovalDate = "";
                var checkAprLineFlag = "";
                var ifrmviewEmptyTextValue = "";
                
                if (pPage == "Cabinet") {
                    secureApprovalDate = (g_sFlag == "m03" || g_sFlag == "m14") ? trim_Cross(selobj.getAttribute("DATA8")) : trim_Cross(selobj.getAttribute("DATA14"));
                    checkAprLineFlag = CheckAprLine(selobj.getAttribute("DATA1"));
                } else if ( pPage == "Container") {
                    secureApprovalDate = trim_Cross(selobj.getAttribute("DATA10"));
                    checkAprLineFlag = CheckAprLine(selobj.getAttribute("DATA1"));
                }
                
                // 2023-09-08 전인하 - 프레임 생성 시에만 텍스트 삽입함으로서 에러 방지, 불필요한 조건분기 제거
                // 문서 비공개 사유 문자열 생성
                if (pPage == "Manage" && pListTypeValue == '5' && selobj.getAttribute("DATA3") == '') { // 대외수신함에서, 문서 최초열람 하지 않아 문서 저장경로가 없을 경우
                   ifrmviewEmptyTextValue = strLangJIH03;
                } else if (checkAprLineFlag != "TRUE" && GetUserRole() == "User") { // 열람권한이 없을 경우
                    ifrmviewEmptyTextValue = strLang929;
                } else if (typeof secureApprovalDate != "undefined" && secureApprovalDate != "" && secureApprovalDate >= GetTodayDate()) {  // 보안결재 문서일 경우
                    ifrmviewEmptyTextValue = strLangJIH01;
                } 
                if ($("#ifrmviewEmptyText") != null) {
                    ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerHTML = ifrmviewEmptyTextValue;   
                }
            }
            $("#ifrmPreViewH").off();
          });
        });
    // 문서 리스트에서 선택된 컬럼이 없거나, 리스트에 문서가 없을때의 분기
    } else {
    	document.getElementById("ifrmPreViewH").src = strLangJIH02;
    	document.getElementById("ifrmPreViewH").onload = function() {
    	// 공백페이지 문구 영역 존재여부에 더해, 이미 존재하는 문구가 있는지 여부를 체크 (미리보기 영역에 이미 존재하는 메세지가 있으면 기존 메세지 유지)
    		if (CrossYN()) {
    			if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null && ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText == "") {
    				ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;	        			
    			}
    		} else {
    			if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null && ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText == "") {
    				ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;		            		
    			}
    		}    
    	}
    }
    
    try {
        if (document.getElementById("previewmail_bar_h") != null) {
            document.getElementById("previewmail_bar_h").style.cursor = "w-resize";
        }
        
        if (pGubun == "H" && selobj != null) {
            if (selobj.childNodes.length != 0) {
                selobj.childNodes[2].style.fontWeight = "normal";
            }
        }

        isPreviewChange = true;
        if (pGubun == "OFF") {
            pPreviewShow_HOW = "OFF";
            document.getElementById("PreviewRayerH").style.display = "none";
            CurrentHeight = document.documentElement.clientHeight - 133;
           // document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            document.getElementById("MailListRayer").style.width = "100%";
            g_bPrevShow = false;
        }
        else if (pGubun == "H") {
            if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                pMailListDiv_H = 50; pMailPreVDiv_H = 50;
            }

			if (parent.document.getElementById("tab1")) {
				CurrentWidth = document.documentElement.clientWidth + 7;
			} else {
				CurrentWidth = document.documentElement.clientWidth - 20;
			}
            CurrentHeight = document.documentElement.clientHeight - 133;
            pMailListWidthH = parseInt(CurrentWidth * (pMailListDiv_H / 100));
            pMailPreWidthH = parseInt(CurrentWidth * (pMailPreVDiv_H / 100)) - 3;

            document.getElementById("MailListRayer").style.display = "inline-block";
            document.getElementById("PreviewRayerH").style.display = "inline-block";

            if (CurrentWidth < (pMailListWidthH + pMailPreWidthH)) {
                if (pMailListWidthH > parseInt(CurrentWidth * 0.40)) {
                    pMailListWidthH = pMailListWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrentWidth);
                }
                else {
                    pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrentWidth);
                }
            }

            //document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
            //document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
            //document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
            
            if ($("body").attr("class") == "tabbody") {            
            	document.getElementById("MailListRayer").style.width = pMailListWidthH-20 + "px";
            } else {
            	document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
            }            
            
            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
            //document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68) + "px";
            
            pPreviewShow_HOW = "H";
            pMailListDiv_H = Math.round((pMailListWidthH / CurrentWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrentWidth) * 100);

            g_bPrevShow = true;
        }
        
        PreviewMode_ChangeBtn();
        Set_ApprovConfig(); 
        isPreviewChange = false;
       // scroll();
    } catch (e) {
        console.log(e);
     }
}

// 2023-06-08 전인하 -  전자결재G > 기록물대장 미리보기 > 배부대장의 우측 상단 미리보기 버튼 id가 중복되지 않도록 분리
function PreviewMode_ChangeBtn() {
    try {
    	document.getElementById("PreViewNone").className = "icon16 btn_noframe";
    	if (document.getElementById("PreViewNoneDelivery")) {
    	    document.getElementById("PreViewNoneDelivery").className = "icon16 btn_noframe";
    	}
    	
    	if (document.getElementById("PreViewBottom")) {
    		document.getElementById("PreViewBottom").className = "icon16 btn_bottomframe";
    	}
    	
    	if (document.getElementById("PreViewBottomDelivery")) {
    	    document.getElementById("PreViewBottomDelivery").className = "icon16 btn_bottomframe";
    	}

    	if (document.getElementById("PreViewleft")) {
    		document.getElementById("PreViewleft").className = "icon16 btn_leftframe";
    	}
    	
    	if (document.getElementById("PreViewleftDelivery")) {
    	    document.getElementById("PreViewleftDelivery").className = "icon16 btn_leftframe";
    	}

    	if (pPreviewShow_HOW == "H") {
    		if (document.getElementById("PreViewleft")) {
    			document.getElementById("PreViewleft").className = "icon16 btn_onleftframe";
    		}
    		if (document.getElementById("PreViewleftDelivery")) {
    		    document.getElementById("PreViewleftDelivery").className = "icon16 btn_onleftframe";
    		}
    	} else {
            document.getElementById("PreViewNone").className = "icon16 btn_onnoframe";
            if (document.getElementById("PreViewNoneDelivery")) {
                document.getElementById("PreViewNoneDelivery").className = "icon16 btn_onnoframe";
            }
    	}
    } catch (e) {
        console.log(e);
    }
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
        	var pAlertContent = strLang870; // 문서를 선택해주십시오.
        	alert(pAlertContent);
            return;
        }
        
        var tr = selRow[0];
        pURL = tr.getAttribute("DATA2");

        var para = new Array();
        para[0] = DocID;
        para[1] = pURL;
        
        // 2023-09-08 전인하 - 불필요하게 삽입된 조건분기 제거함
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
    }
    // 2023-06-20 전인하 - 전자결재G > 기록물대장 미리보기 - "Cabinet"플래그를 추가하여, 기록물 등록대장에서 미리보기하는 경우의 분기를 생성, 처리
    else if (page == "Cabinet") {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");

        var selRow = DocList.GetSelectedRows();

        if (selRow.length <= 0) {
            var pAlertContent = strLang870;
            alert(pAlertContent);
            return;
        }

        var tr = selRow[0];
        pURL = tr.getAttribute("DATA2");

        var para = new Array();
        para[0] = DocID;
        para[1] = pURL;

        if (cabinetPreviewItemFlagArr.includes(g_sFlag)) {
            var securityApproval = "";
            $.ajax({
                type : "GET",
                dataType : "text",
                async : false,
                url : "/ezApprovalG/getSecurityApprovalDate.do",
                data : {
                        docID: DocID
                        },
                success: function(result) {
                    securityApproval = result;
                },
                error: function(err) {
                    console.log(err);
                }
            });

            if (securityApproval != "" && securityApproval >= GetTodayDate()) {  // 미리보기로 열람하려는 문서가 보안문서일 때.
                document.getElementById("ifrmPreViewH").src = strLangJIH02;
            } else { // 미리보기로 열람하려는 문서가 보안문서가 아닐 때.
                pre_chk_Passwd_Complete("TRUE");
            }
        }
	} else {
		if (pListTypeValue == "1" || pListTypeValue == "11") { //listTypeValue = 11(공유결재문서)
			if (checkAprState(selobj.getAttribute("DATA1"), selobj.getAttribute("DATA12"), selobj.getAttribute("DATA4"), selobj.getAttribute("APRMEMBERSN"), selobj.getAttribute("ORGCOMPANYID"))){
				alert(strLangHSBAP01); // 해당 문서는 다른 공유결재자에 의해 이미 결재되었습니다.
				getDocList(setting);
				return;
			}
			if (selobj.getAttribute("DATA12") == "015")
				pre_openViewDocInfo();
			else if (document.getElementById("tbtnRedraft").style.display == "none" && document.getElementById("tbtnApprove").style.display == "")
				pre_openApprovUI();
			else
				pre_btnRedraft_onclick();
		} else if (pListTypeValue == "4" || pListTypeValue == "97") {
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
			var pDocID = selobj.getAttribute("DATA1");
			var pURL = selobj.getAttribute("DATA3");
			
			para[0] = pDocID;
			para[1] = pURL;
			
			// 대외수신함에서, 문서 최초열람 하지 않아 문서 저장경로가 없을 경우 - 유통문서의 docHref는 문서 최초열람 시 작성됨
			// url이 없어 문서를 열 수 없으므로 빈 페이지를 삽입함
			if (para[0] != '' && para[1] == '') {
			    document.getElementById("ifrmPreViewH").src = strLangJIH02;
			    return;
			}

			if (pURL.substr(pURL.length - 4, pURL.length).toLowerCase() == ".ezd") {
				pURL = pURL.substr(0, pURL.length - 4);
			}
			
			if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
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
			openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL) + "&listSusin=" +"&orgCompanyID=" + orgCompanyID;
			/* 2022-06-23 홍승비 - 전자결재 문서보기 페이지가 미리보기로 열린 경우, 기존 버튼 영역을 로딩 시점부터 표출하지 않도록 하기 위한 플래그 추가 */
			openLocation +=  "&isPreview=Y";
			if (typeof g_sFlag != 'undefined' && g_sFlag != null) {
			    openLocation +=  "&sFlag=" + g_sFlag;
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
	    } else {

            var isGroupDoc = checkIsGroupDoc(encodeURI(pArgument[0]), orgCompanyID);
            var openLocation = "";

            if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 일괄기안 문서를 여는 경우
                openLocation = "/ezApprovalG/approvuiAll_WHWP.do?docID=" + encodeURI(pArgument[0]);
                openLocation += "&id=" + encodeURI(pArgument[1]) + "&name=" + encodeURI(pArgument[2]);
                openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2"));
            } else {
                if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
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
                        openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + encodeURI(pArgument[0]);
                        openLocation += "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2"));
                    }
                    
                } else {
                    openLocation = "/ezApprovalG/approvui.do?docID=" + encodeURI(pArgument[0]);
                    openLocation = openLocation + "&name=" + encodeURI(pArgument[2]);
                    openLocation = openLocation + "&deptID=" + encodeURI(pArgument[3]) + "&allFlag=" + encodeURI(allFlag) + "&docState=" + encodeURI(GetAttribute(tr[0], "DATA12")) + "&mode=" + encodeURI(mode) + "&orgCompanyID=" + orgCompanyID + "&orgDocID=" + encodeURI(GetAttribute(tr[0], "DATA2")) + "&aprMemberSN=" + pArgument[4];
                }
            }
	    }
	    
	    openLocation +=  "&isPreview=Y";
	    
	    document.getElementById("ifrmPreViewH").src = openLocation;
	}
	else {
	    var pAlertContent = strLang870; // 문서를 선택해주십시오.
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

    if (pListTypeValue == "4" || pListTypeValue == "97") {
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
    
    /* 2022-08-02 홍승비 - 미리보기 시 완료문서보기로 접근해야 하는 페이지를 추가로 확인 (getContainerInfo) */
    var locationHref = window.location.href;
    
    if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9" || locationHref.indexOf("ezApprovalG/getContainerInfo.do") > -1) {
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
        openLocation = openLocation + "?docID=" + encodeURI(DocID) + "&docHref=" + encodeURI(formURL);
        if (approvalFlag == "G") {
            openLocation = openLocation + "&formID=&orgDocID=&sendType=" + GetAttribute(tr, "DATA5");
        } else {
            openLocation = openLocation + "&formID=" + GetAttribute(tr, "DATA6") + "&orgDocID=&sendType=" + GetAttribute(tr, "DATA5");    
            openLocation = openLocation + "&orgCompanyID=" + orgCompanyID;    
        }
        
    }
    else {

        var isGroupDoc = checkIsGroupDoc(encodeURI(DocID), orgCompanyID);
        if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) {
		    openLocation = "/ezApprovalG/ezviewAprAll_WHWP.do";
        } else {
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
            } else {
                openLocation = "/ezApprovalG/aprDocView.do";
            }
        }
        openLocation = openLocation + "?docID=" + encodeURI(pArgument[0]) + "&docHref=" + encodeURI(pArgument[1]);
        openLocation = openLocation + "&opinionFlag=" + encodeURI(pArgument[2]) + "&docState=" + encodeURI(pArgument[3]) + "&listSusin=" + encodeURI(pArgument[4]) + "&oDoc=" + encodeURI(pArgument[5]);
        openLocation = openLocation + "&isOpinion=" + encodeURI(pArgument[6]);
        openLocation = openLocation + "&listType=" + encodeURI(pArgument[7]);
        openLocation = openLocation + "&CallBackType=" + escape(trim_Cross(type));
        openLocation = openLocation + "&ext=" + escape(trim_Cross(ext));
        openLocation = openLocation + "&orgCompanyID=" + orgCompanyID;
        if (shareUser = "shareUser") {
            openLocation += "&pageType=admin";
        }
    }
    
    openLocation +=  "&isPreview=Y";
    
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
                
                if (GetAttribute(selobj, "DATA15") == "001") {
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
            
            openLocation +=  "&isPreview=Y";
            
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
            openLocation +=  "&isPreview=Y";
            
            document.getElementById("ifrmPreViewH").src = openLocation;
        }
    } else {
        var pAlertContent = strLang870;
        OpenAlertUI(pAlertContent);
        return;
    }
}

/* 2022-08-10 홍승비 - 미리보기 영역에서는 기안 및 결재정보 접근 동작이 불가능하므로, 재기안 시의 알러트를 일부 사용하지 않도록 주석처리함 */
function pre_btnRedraft_onclick() {
    var DocList = new ListView();
    DocList.LoadFromID("DocList");
    
    var oArrRows = DocList.GetSelectedRows();
    
    if (oArrRows.length <= 0) {
    	var pAlertContent = strLang870; // 문서를 선택해주십시오.
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
    
    // 문서보기에 영향을 미치지 않는 알러트 메세지 주석처리 (해당 알러트는 미리보기 영역 및 팝업창 내부에서 표출됨)
    /*
    if (pCurSelRow.getAttribute("orgcompanyid") != "" && pCurSelRow.getAttribute("orgcompanyid") != companyID) {
    	var pAlertContent = strLangHSBAP02; // 다른 회사에서 기안한 문서는 재기안 할 수 없습니다.
    	alert(pAlertContent);
        return;
    }
    if (CheckFormConnFlag(pCurSelRow.getAttribute("DATA1"))) {
        var pAlertContent = strLangHSBAP03; // 연동 양식은 재기안하실 수 없습니다.
        alert(pAlertContent);
        return;
    }
    if (pCurSelRow) {
        var ret = CheckAprLineInfo(pCurSelRow);
        if (ret != "OK") {
            var pAlertContent = strLang863 + "\n" + strLang864 + ret + strLang865; // 기안 당시 부서정보와 현재의 부서정보가 일치하지 않습니다.
            alert(pAlertContent);
            return;
        }
    }
    */
    if ((pListTypeValue == "1" || pListTypeValue == "11") && checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
    	alert(strLangHSBAP01); // 해당 문서는 다른 공유결재자에 의해 이미 결재되었습니다.
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
        
        openLocation +=  "&isPreview=Y";

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
    var isGroupDoc = checkIsGroupDoc(pDocSN, "");

    if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) { // 일괄기안 문서를 여는 경우
        openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    } else {
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
            openLocation = "/ezApprovalG/draftui.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);

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
                }
            } else {
                openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
                
            }
        }
    }
    openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]) + "&docSN=" + encodeURI(pDocSN);
    openLocation +=  "&isPreview=Y";
    
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

    var isGroupDoc = checkIsGroupDoc(pArgument[7], ""); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)

    if (isGroupDoc == "Y" && (typeof draftAllTypeB == "undefined" || draftAllTypeB != "Y")) {
        openLocation = "/ezApprovalG/draftuiAll_WHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
    } else {
        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
            openLocation = "/ezApprovalG/draftui.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
        } else {
            if(useWebHWP == "NO") {
                if (!isIE()) {
                    alert("한글양식은 IE에서만 기안 할 수 있습니다.");
                    return;
                } else {
                    openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
                }
            } else {
                openLocation = "/ezApprovalG/draftuiWHWP.do?formURL=" + encodeURI(pArgument[1]) + "&draftFlag=" + encodeURI(pArgument[2]) + "&formDocType=" + encodeURI(pArgument[3]);
            }
        }
    }
  
    openLocation = openLocation + "&susinSN=" + encodeURI(pArgument[4]) + "&docState=" + encodeURI(pArgument[5]) + "&listType=" + encodeURI(pListTypeValue) + "&aprState=" + encodeURI(pArgument[6]);
    openLocation = openLocation + "&isTmpDoc=" + encodeURI(pArgument[7]);
    openLocation +=  "&isPreview=Y";
    
    document.getElementById("ifrmPreViewH").src = openLocation;
}

function MailPreviewEnd(e) {
    if (PreviewH_Move) {
        document.getElementById("ResizeBarH").style.display = "none";
        document.getElementById("ResizeBarPanel").style.display = "none";
        if (PreviewH_Move) {
        	 var newPos_H = parseInt(document.getElementById("ResizeBarH").style.left) - 10;
             if (pMailListWidthH >= newPos_H) {
                 pMailPreWidthH = pMailPreWidthH + (pMailListWidthH - newPos_H); // 미리보기 영역
                 pMailListWidthH = newPos_H; // 결재문서 영역
             } else {
                 pMailPreWidthH = CurrentWidth - newPos_H; // 미리보기 영역
                 pMailListWidthH = newPos_H; // 결재문서 영역
             }
             
            pMailListDiv_H = Math.round((pMailListWidthH / CurrentWidth) * 100);
            pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrentWidth) * 100);
            
            // 두 비율의 합이 100%가 초과하거나, 미만인 경우가 발생하기도 한다. 이 경우, 임의로 퍼센티지를 조정해준다.
            var pDivSum = parseInt(pMailListDiv_H) + parseInt(pMailPreVDiv_H);
            // 100% 미만인 경우, 더하기 보정
            if (pDivSum < 100) {
            	var leftPer = 100 - pDivSum;
            	
            	pMailListDiv_H = pMailListDiv_H + (leftPer * pMailListDiv_H / 100);
            	pMailPreVDiv_H = pMailPreVDiv_H + (leftPer * pMailPreVDiv_H / 100);
            }
            // 100% 초과인 경우, 감소 보정
            else if (pDivSum > 100) {
            	var leftPer = pDivSum - 100;
            	
            	pMailListDiv_H = pMailListDiv_H - (leftPer * pMailListDiv_H / 100);
            	pMailPreVDiv_H = pMailPreVDiv_H - (leftPer * pMailPreVDiv_H / 100);
            }
            
            // 강제적으로 결재문서 리스트와 미리보기 영역의 비율을 고정 (6.5:3.5 또는 3.5:6.5으로 제한)
            // 결재문서 리스트의 비율이 65% 이상이거나, 미리보기 영역의 비율이 35% 이하인 경우, 6.5:3.5로 고정
            if (parseInt(pMailListDiv_H) >= parseInt(65) || parseInt(pMailPreVDiv_H) <= parseInt(35)) {
            	pMailListDiv_H = 65;
            	pMailPreVDiv_H = 35;
            }
            // 결재문서 리스트의 비율이 35% 이하이거나, 미리보기 영역의 비율이 65% 이상인 경우, 3.5:6.5로 고정
            else if (parseInt(pMailListDiv_H) <= parseInt(35) || parseInt(pMailPreVDiv_H) >= parseInt(65)) {
            	pMailListDiv_H = 35;
            	pMailPreVDiv_H = 65;
            }

        }
        PreviewH_Move = false;
    }
    
    Window_resize();
    
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

            if (newPos_H <= parseInt(CurrentWidth * 0.40)) {
                newPos_H = parseInt(CurrentWidth * 0.40);
            }
            else if (newPos_H > parseInt(CurrentWidth * 0.65)) {
                newPos_H = parseInt(CurrentWidth * 0.65);
            }
            
            document.getElementById("ResizeBarH").style.left = newPos_H + "px";
        }
    }
    
}
function PreviewH_onMouserDown(e) {
    curevent = (typeof event == 'undefined' ? e : event);
    
    var newPos_H = curevent.clientX;

    if (newPos_H < parseInt(CurrentWidth * 0.40)) {
        newPos_H = parseInt(CurrentWidth * 0.40);
    }
    else if (newPos_H > parseInt(CurrentWidth * 0.65)) {
        newPos_H = parseInt(CurrentWidth * 0.65);
    }

    document.getElementById("ResizeBarH").style.left = newPos_H + "px";
    document.getElementById("ResizeBarH").style.display = "";
    document.getElementById("ResizeBarPanel").style.display = "";
    PreviewH_Move = true;
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}
function Window_resize() {
    try {
        if (!isPreviewChange) {
        	// 브라우저 넓이 1000px 이하는 미리보기 해제
            if (parseInt(document.documentElement.clientWidth) < 1000) {
                document.getElementById("right").style.display = "none"; // 우측 상단 미리보기 아이콘 숨김처리
                document.getElementById("PreviewRayerH").style.display = "none"; // 우측 미리보기 영역 숨김처리
                
                if (pPreviewShow_HOW.trim() == "H") {
                    pPreviewShow_HOW = "OFF";
                }
                PreviewMode_ChangeBtn();
            }
            else {
            	if (useAprPreview == "YES") {
            		document.getElementById("right").style.display = "";
            		// 2023-07-11 전인하 - useAprPreview가 Yes이나 미리보기 미사용인 일부 메뉴(기록물철 조회 화면 > 기록물보기 버튼 클릭)에서 미리보기 버튼 나타나지 않게 분기처리
            		if (typeof g_sFlag != 'undefined') {
            		    if (!cabinetPreviewItemFlagArr.includes(g_sFlag)) {
            		        document.getElementById("right").style.display = "none";
            		    } 
            		}
            	}
                document.getElementById("MailListRayer").style.width = "100%";
            }
            if (pPreviewShow_HOW.trim() == "H") {
                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
                	pMailListDiv_H = 50;
                    pMailPreVDiv_H = 50;
                }
                
                document.getElementById("MailListRayer").style.display = "inline-block";
                document.getElementById("PreviewRayerH").style.display = "inline-block";
                
    			CurrentWidth = document.documentElement.clientWidth - 20;
                CurrentHeight = document.documentElement.clientHeight - 133;
                pMailListWidthH = parseInt(CurrentWidth * (pMailListDiv_H / 100)); // 미리보기 영역과 리스트와의 표출 비율을 계산 (미리보기 중간 바에 의한 분리 비율)
                pMailPreWidthH = parseInt(CurrentWidth * (pMailPreVDiv_H / 100)) - 3;

                if (pMailListWidthH <= parseInt(CurrentWidth * 0.40)) {
                    var ChangeListWidthDiv = parseInt(CurrentWidth * 0.40) - pMailListWidthH;
                    pMailListWidthH = parseInt(CurrentWidth * 0.40); // 기존 전자결재 리스트 영역 (좌측)
                    pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv; // 미리보기 영역 (우측)
                }
                
                // 중간의 미리보기 바 클릭 시 회색 오버 영역
                //document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
                
                // 기존 전자결재문서 리스트 영역
                //document.getElementById("MailListRayer").style.height = CurrentHeight + "px"; // 전체적인 스크롤 발생을 위해, 높이 조정은 하지 않음
                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
                
                // 우측 미리보기 영역
                //document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px"; // 전체적인 스크롤 발생을 위해, 높이 조정은 하지 않음
                document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 10) + "px";
                //document.getElementById("PreContent_RayerH").style.height = CurrentHeight + "px";
                document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
               // document.getElementById("ifrmPreViewH").style.height = CurrentHeight + "px";
                
                pPreviewShow_HOW = "H";
                
                pMailListDiv_H = Math.round((pMailListWidthH / CurrentWidth) * 100);
                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrentWidth) * 100);
            }
            // 미리보기 영역이 열려있지 않은 경우, 좌측 전자결재 리스트 가로 리사이즈 및 우측 미리보기 display 관련 스타일 변경
            else if (pPreviewShow_HOW.trim() == "OFF") {
        		//document.getElementById("PreViewleft").style.display = "none";
                document.getElementById("PreviewRayerH").style.display = "none";
               // CurrentHeight = document.documentElement.clientHeight - 133 - (document.getElementById("mainmenu").clientHeight - 28);
               // document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
                document.getElementById("MailListRayer").style.width = "100%";
            }
        }
        //scroll();
    } catch (e) {
    	console.log(e);
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
    {
		if (bAttachProcess == false)
			window.parent.openergetDocInfo();
	}
    // try {
    //     if (bAttachProcess == false)
    //         window.opener.Refresh_Window();
    // }
    // catch (e)
    // { }
    try {
    	if (bAttachProcess == false)
    		window.opener.parent.frames["right"].openergetDocInfo();
    } catch (e) 
    {
		if (bAttachProcess == false)
			window.parent.parent.frames["right"].openergetDocInfo();
	}
    try {
        bAttachProcess = true;
    }
    catch (e) { }
    // try {
    //     window.opener.getApprGraph("appr");
    // } catch (e) { }
}

function pre_chk_Passwd_Complete(Rtn)
{
    if (Rtn == "FALSE") {
        var pAlertContent = strLang581; // 암호가 맞지 않습니다.
        OpenAlertUI(pAlertContent);
        return "";
    }
    else if (Rtn == "cancel") {
        var pAlertContent = strLang582; // 취소하셨습니다.
        OpenAlertUI(pAlertContent);
        return "";
    }
    else {
        var DocList = new ListView();
        DocList.LoadFromID("DocList");
        var selRow = DocList.GetSelectedRows();
        var tr = selRow[0];

        // 2023-05-23 이혜림 -  전자결재G > 기록물대장 미리보기 - 기록물 등록대장의 미리보기 문서 url 생성 분기처리
        // 결재완료문서, 기록물등록대장 등 각 메뉴의 문서 리스트 tr에 맞춰서 데이터를 설정
        pURL = tr.getAttribute("DATA2");
        var openLocation;
        var tempURL = pURL;
        
        if (typeof g_sFlag != 'undefined' && cabinetPreviewItemFlagArr.includes(g_sFlag)) {
            orgCompanyID = CompanyID;
            var formid = tr.getAttribute("DATA5");
            var docState =  tr.getAttribute("DATA15");
            var orgdocid = trim_Cross(tr.getAttribute("DATA1")); // 결재완료문서에서 ""
        } else {
            orgCompanyID = tr.getAttribute("ORGCOMPANYID");
            var formid = tr.getAttribute("DATA6");

            if (approvalFlag == 'S' ) {
                var docState =  tr.getAttribute("DATA12");
            } else {
                var docState =  tr.getAttribute("DATA7");
            }

            var orgdocid = trim_Cross(tr.getAttribute("DATA5"));
        }
        
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
        if (typeof g_sFlag != 'undefined' && ["m03", "m14"].includes(g_sFlag)) { // 2023-09-25 전인하 - 미리보기에서 문서 열람 시 메뉴 플래그 전달
            openLocation += "&uFlag=" + g_sFlag;
        }
        if (share && share == 'share') {
        	openLocation += "&share=Y";
        }
        
        openLocation +=  "&isPreview=Y";
        
        document.getElementById("ifrmPreViewH").src = openLocation;
    }
}

/* 2022-06-30 홍승비 - 일괄기안된 문서인지 판별하는 ajax 함수 (Y/N) */
function checkIsGroupDoc(pDocID, pOrgCompanyID) {
    var res = "";
    
    $.ajax({
        type : "GET",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/checkIsGroupDoc.do",
        data : {
            docID : pDocID,
            orgCompanyID : pOrgCompanyID
        },
        success: function(result) {
            res = result;
        }        			
    });
    
    return res;
}

/* 2023-06-26 한태훈 - 관리자 전제문서조회(완료문서) 리스트 개수 설정 기능 추가 */
function MailOptionView(obj,flag) {
    if (obj.getAttribute("mode") == "off") {
        if (flag == 'N') {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 160 + "px";
        } else {
        	document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
        }
       
        document.getElementById("layer_Viewpopup").style.display = "";
        obj.setAttribute("class", "icon16 btn_onarrow_down");
        obj.setAttribute("mode", "on");
    }
    else {
        MailOptionHidden();
    }
}

function MailOptionHidden() {
    document.getElementById("layer_Viewpopup").style.display = "none";
    document.getElementById("maillistoptiondiv").setAttribute("mode", "off");
    document.getElementById("maillistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
}

function MailOptionHiddenOutside(e) {
	var container = $('#layer_Viewpopup');
	var maillistoptionmode = $('#maillistoptiondiv').attr('mode');
	if (maillistoptionmode == "on") {
		if (container.has(e.target).length === 0 && $(e.target).attr('id') != 'maillistoptiondiv') {
			MailOptionHidden();
		}
	}
}
