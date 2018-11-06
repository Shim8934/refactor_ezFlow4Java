<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>approvalListPortlet</title>
	</head>
	<body>
		<div class="layDIV approval">
            <dl class="portlet_tab sortablePortlet">
                <dt id="doingTab" class="on" onclick="apprChangeTab(this)"><span><spring:message code='main.t00003' /></span></dt>
                <dt id="rejectTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00004' /></span></dt>
                <dt id="draftTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00005' /></span></dt>
                <dd class="portletPlus" onclick="Appmore_btnClick()"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
            </dl>
            <ul id ="ApprList" class="portlet_list"></ul>
        </div>
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
		<script type="text/javascript">
			var getApprovalList = function(type) {
				var request = new XMLHttpRequest();
				request.open('POST', '/ezNewPortal/getApprovalList.do', true);
				request.setRequestHeader('Content-Type', 'application/json');
	
				request.onload = function() {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						
						var docList = result.resultList;
						var imgPath = result.imgPath;
						var docsHTML = "";
						
						if (docList) {
							switch (type) {
							case "doing":
								docList.forEach(function(item, index) {
									if (index === 0) {
										docsHTML += dataAssemblerApprLine(item, result.aprLines, result.imgPath);
									} else {
										docsHTML += dataAssembler(item);
									}
								});
									
				                break;
	
				            case "reject":
								docList.forEach(function(item, index) {
									docsHTML += dataAssembler(item);
								});
								
				                break;
	
				            case "draft":
								docList.forEach(function(item, index) {
									docsHTML += dataAssembler(item);
								});
				            	
				                break;
							}
						} else {
							docsHTML += "<dl class='nodata'>";
							docsHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
							docsHTML += "<dd><spring:message code='main.t00026' /></dd>";
							docsHTML += "</dl>";
						}
						
						document.getElementById('ApprList').innerHTML = docsHTML;
					} else {
						// We reached our target server, but it returned an error
					}
				};
	
				request.onerror = function() {
				  // There was a connection error of some sort
				};
				
				var data = JSON.stringify({
					type : type
				});
				
				request.send(data);
			}
			
			var apprChangeTab = function(obj) {
				var type = "";
		        switch (obj.id) {
	            case "doingTab":
	            	//1
	            	type = "doing";
	                document.getElementById("doingTab").className = "on";
	                document.getElementById("rejectTab").className = "";
	                document.getElementById("draftTab").className = "";
	                break;

	            case "rejectTab":
	            	//4
	            	type = "reject";
	                document.getElementById("doingTab").className = "";
	                document.getElementById("rejectTab").className = "on";
	                document.getElementById("draftTab").className = "";
	                break;

	            case "draftTab":
	            	//2
	            	type = "draft";
	                document.getElementById("doingTab").className = "";
	                document.getElementById("rejectTab").className = "";
	                document.getElementById("draftTab").className = "on";
	                break;
		        }
		        
		        getApprovalList(type);
		    }
			
			var Appmore_btnClick = function() {
				if (document.querySelector("div.layDIV.approval dl.portlet_tab.sortablePortlet dt.on").id == "doingTab") {
					window.open("/ezApprovalG/apprGMain.do?listType=1", "main");
				} else {
					window.open("/ezApprovalG/apprGMain.do?listType=2", "main");
				}
		    }
			
			var dataAssembler = function(object) {
				var str = "";
				
				str += '<li onclick=\'opendocview("'+ object.docID +'", "'+ object.href +'", "'+ object.aprMemberID +'", "'+ object.aprMemberName +'", "'+ object.aprMemberDeptID +'", "'+ object.docState +'", "'+ object.functionType +'", "'+ object.companyID +'")\'>';
				str += '	<span class="txt">'+ object.docTitle +'</span>';
				str += '	<span class="date">'+ object.startDate.substr(5, 11).replace(/-/gi,'.')+'</span>';				
				str += '	<span class="name">'+ object.writerName +'</span>';
				str += '</li>';
				
				return str;
			}
			
			var dataAssemblerApprLine = function(object, lines, imgPath) {
				var listSize = lines.length > 3 ? 3 : lines.length;
			    var str = "";
			    
			    str += '<li class="first_approval" onclick=\'opendocview("'+ object.docID +'", "'+ object.href +'", "'+ object.aprMemberID +'", "'+ object.aprMemberName +'", "'+ object.aprMemberDeptID +'", "'+ object.docState +'", "'+ object.functionType +'", "'+ object.companyID +'")\'>';
			    str += '	<p class="approval_tit">'
			    str += '	<span class="txt">'+ object.docTitle +'</span><span class="date">'+ object.startDate.substr(5, 11).replace(/-/gi, ".") +'</span><span class="name">'+ object.writerName +'</span></p>';
			    str += '	<div class="approval_content">';
			    
			    for(var i=0; i<listSize; i++){
			        console.log("img", lines[i].ext2);
			        var imgsrc = lines[i].ext2 !== null && lines[i].ext2 !== '' ? "/ezCommon/downloadAttach.do?filePath=" + imgPath + "/" + lines[i].ext2 : "/images/kr/main/bestEmployee_pic_none.png";
			        var apprTextColor = "";
			        
			        // 승인 003, 진행 002, 대기, 001
			        if(lines[i].aprState === "003") {
			            apprTextColor = "apprText_blue";
			        } else if (lines[i].aprState === "002") {
			            apprTextColor = "apprText_green";
			        } else if (lines[i].aprState === "001") {
			            apprTextColor = "apprText_orange";
			        } else {
			            apprTextColor = "apprText_blue";
			        }
			        
			        str += '		<dl class="apprDL">';
			        str += '			<dt class="apprPic"><img src="'+ imgsrc +'"></dt>';
			        str += '			<dd class="apprName">'+ lines[i].aprMemberName +'</dd>';
			        
			        if(i==0) {
			            str += '			<dd class="'+ apprTextColor +'"><span><spring:message code="ezApprovalG.t30"/></span></dd>';
			        } else {
			            str += '			<dd class="'+ apprTextColor +'"><span>'+ lines[i].ext1 +'</span></dd>';
			        }
			        str += '		</dl>';			
			        
			        if(i !== listSize-1) {
			            str += '		<p class="appr_arrow"><img src="/images/kr/main/approval_arrow.png"></p>';	
			        }			    	
			        
			    }
			    
			    str += '	</div>';
			    str += '</li>';   	
			    
			    return str;
			}
			
			/** 결재 오픈 */
			function opendocview(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
		        var openLocation = "";
		        var selectedTapId = document.querySelector("div.layDIV.approval dl.portlet_tab.sortablePortlet dt.on").id;
	
	            if (selectedTapId != "draftTab") {
	                if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
	                    if (pDocState == "012" || pDocState == "014" || pDocState == "018") {
	                        OpenReceiveDraftUI(pDocID, pHref, "REDRAFT");
	                    } else if (pFunctionType == "004" && "${userInfo.companyID}" != orgCompanyID) {
                    		var pAlertContent = "<spring:message code='ezApprovalG.csj01' />";
	                        alert(pAlertContent);
	                        return;
	                    } else {
	                        openApprDraftUI("REDRAFT", pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
	                    }
	                } else {
	                    openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
	                }
	            } else {
	                openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID);
	            }
		    }
	
		    function openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
		        var pArgument = new Array();
		        var formURL = pHref;
		        var DocID = pDocID;
		        pArgument[0] = DocID;
		        pArgument[1] = formURL;
		        pArgument[2] = "";
		        pArgument[3] = pDocState;
		        pArgument[4] = "";
		        pArgument[5] = "";
		        pArgument[6] = "OPINION_SHOW";
		        pArgument[7] = "2";
		        pArgument[8] = orgCompanyID;
		        
		        var openLocation;
		        
                if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezViewApr_Word_Cross.aspx?DocID=" + escape(pArgument[0]) + "&DocHref=" + escape(pArgument[1]);
                    openLocation += "&OpinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
                    openLocation += "&isOpinion=" + escape(pArgument[6]);
                    openLocation += "&ListType=" + escape(pArgument[7]);
                }
                else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
                	if (isIE()) {
	                    openLocation = "/ezApprovalG/ezviewAprHWP.do?docID=" + escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
	                    openLocation += "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&listSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	                    openLocation += "&isOpinion=" + escape(pArgument[6]);
	                    openLocation += "&listType=" + escape(pArgument[7]);
                	} else {
                		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                        alert(pAlertContent);
                        
                        return;
                	}
                } else {
                	openLocation = "/ezApprovalG/aprDocView.do?docID=";
                	openLocation += escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
    	            openLocation += "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
    	            openLocation += "&isOpinion=" + escape(pArgument[6]);
    	            openLocation += "&listType=" + escape(pArgument[7]);
    	            openLocation += "&orgCompanyID=" + escape(pArgument[8]);
                }

                openwindow(openLocation, "", 880, 570);
		    }
	
		    function openApprDraftUI(pDraftFlag, pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
		        var pArgument = new Array();
		        var formURL = pHref;
		        
		        pArgument[0] = "${userInfo.id}";
		        pArgument[1] = pHref;
		        pArgument[2] = pDraftFlag;
		        pArgument[3] = "";
	
		        var openLocation = "";
		        var tempDocState = "001";
		        var SusinSn = "0";
		        
		        if (pDocState == "011") {
		            tempDocState = "011";
		            SusinSn = "1";
		        }
	
		        var AprState = "004";
		        
		        if (pFunctionType == "006")
		            AprState = "006";
		       
		        pArgument[4] = SusinSn;
		        pArgument[5] = tempDocState;
		        pArgument[6] = AprState;
		        pArgument[7] = "";
		        pArgument[8] = orgCompanyID;
	
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
		        	if (pDocState == "011" && pFunctionType == "004" && pDraftFlag == "REDRAFT") {
		            	openLocation = "/ezApprovalG/recevGSusin.do?docID=";
						openLocation = openLocation + pDocID + "&uOrgID=" + "&isReDraft=Y" + "&draftFlag=" + pDraftFlag;
		        	} else {
		            	openLocation = "/ezApprovalG/draftui.do?formURL=";
			            openLocation = openLocation + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
			            openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1&aprState=" + escape(pArgument[6]);
			            openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
			            openLocation += "&orgCompanyID=" + escape(pArgument[8]);
		        	}
		        } else {
	                openLocation = "/ezApprovalG/draftuiHWP.do?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
	                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1&aprState=" + escape(pArgument[6]);
	                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
		        }
	
		        openwindow(openLocation, "", 890, 560);
		    }
	
		    function OpenReceiveDraftUI(pDocID, pURL, pDraftFlag) {
		        var openLocation;
	
		        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
		            openLocation = "/ezApprovalG/recev.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		        }
		        else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		            openLocation = "/ezApprovalG/ezDeptRecevUI_HWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		        }
		        else {
		            if (CrossYN()) {
		                openLocation = "/ezApprovalG/recev.do?docID=";
		            } else {
		            	openLocation = "/ezApprovalG/recev.do?docID=";
		            }
	
		            openLocation = openLocation + escape(pDocID) + "&draftFlag=" + escape(pDraftFlag);
		        }
		        
		        openwindow(openLocation, "receive", 880, 550);
		    }
	
		    function openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType, orgCompanyID) {
	            var pArgument = new Array();
	            
	            pArgument[0] = pDocID;
	            pArgument[1] = pAprMemberID;
	            pArgument[2] = pAprMemberName;
	            pArgument[3] = pAprMemberDeptID;
	            pArgument[4] = orgCompanyID;

	            var formURL = pHref;
	            
	            if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	                openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID=" + escape(pArgument[0]);
	                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
	                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=0";
	            } else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	            	if (isIE()) {
		                openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		                openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]);
		                openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=0" + "&docState=" + escape(pDocState);
	            	} else {
	            		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                    alert(pAlertContent);
	                    
	                    return;
	            	}
	            } else {                
                    openLocation = "/ezApprovalG/approvui.do?docID=";
	                openLocation = openLocation + escape(pArgument[0]);
	                openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]);
	                openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=0" + "&docState=" + escape(pDocState);
	                openLocation += "&orgCompanyID=" + escape(orgCompanyID);
	            }
	            openwindow(openLocation, "", 880, 550);       
		    }
	
		    function openwindow(wfileLocation) {
		        var height = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = 0;
		        var top = 0;
	
		        if (window.screen.width > 800) {
		            var pleftpos;
		            pleftpos = parseInt(width) - 1150;
		            height = parseInt(height) - 30;
		            
		            if (CrossYN())
		            	height = parseInt(height) - 25;
	
		            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		            	height = parseInt(height) - 40;
	
		            width = parseInt(width) - pleftpos;
		            
		            left = pleftpos / 2;
		        } else {
		        	height = parseInt(height) - 30;
		            
		            if (CrossYN())
		            	height = parseInt(height) - 25;
	
		            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		            	height = parseInt(height) - 40;
	
		            
		            width = parseInt(width) - 10;
		        }
		        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + height + ",width=" + width + ",top=" + top + ",left = " + left);
		    }
			
			getApprovalList("doing");
		</script>
	</body>
</html>