<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t00008'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <c:if test="${useHWP eq 'YES' and useHwpDownSecurity eq 'Y' and approvalFlag eq 'G' }">
	    	<script type="text/javascript" src="${webHWPUrl}js/hwpctrlapp/utils/util.js"></script>
			<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
    		<script type="text/javascript" src="${webHWPUrl}js/webhwpctrl.js"></script>
	    </c:if>
		
    	
	    <script type="text/javascript">	
	        var pDocID = "<c:out value='${docID}'/>";
	        var pType = "<c:out value='${type}'/>";
	        var orgCompanyID = "<c:out value='${orgCompanyID}'/>";
			var hasOpinion = "<c:out value='${hasOpinion}'/>";
	        var ReturnFunction;
	        
	        /* 2023-05-09 김우철 - hwp결재문서를 배포용 문서로 저장하기 위한 변수 */
			var HwpCtrl;
			var useHwpDownSecurity = "<c:out value='${useHwpDownSecurity}'/>";
			var length = 0;
			var num = 0;
			var docHwpPathArr;
			var downUrl = "";
			var docHwpPath = "";
			var isHwpCtrlOpen = false;
			
			/* 2023-07-04 김우철 - 전자결재 일반버전에서 테넌트 컨피그 useHwpDownSecurity값에 상관없이 대응하기 위한 변수 */
			var approvalFlag = "<c:out value='${approvalFlag}'/>";
			var useHWP = "<c:out value='${useHWP}'/>";
	        
	        window.onload = function ()
	        {
	        	// useHwpDownSecurity가 Y일 때만 Whwp api 호출. 전자결재 일반버전에서는 useHwpDownSecurity의 값에 상관없이 Whwp api 호출하지 않음.
	        	if (useHWP == "YES" && useHwpDownSecurity == "Y" && approvalFlag == "G") {
	        		HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${webHWPUrl}", function () {isHwpCtrlOpen = true;});
	        	}
	        	
	        	if ("${pass}" != "<RESULT>TRUE</RESULT>") {
		    		QuitWindow();
			    }
	        	
	            try {
	                if (isParentCommonArgsUsed()) {
						ReturnFunction = parent.ezCommon_cross_dialogArguments[1];
					} else {
						ReturnFunction = parent.totalsavefileinfo_dialogArguments[1];
					}
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.totalsavefileinfo_dialogArguments[1];
	                } catch (e) {
	                }
	            }
	
	        	var result = "";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/getTotalDoc.do",
	        		data : {
	        			docID : pDocID,
	        			mode : pType,
	        			orgCompanyID : orgCompanyID
	        		},
	        		success: function(text){
	        			result = text;
	        		}
	        	});
	        	
	            if (result != "") {
	                var attSN = 1;
	                var docAttach = loadXMLString(result);
	                for (var i = 0; i < SelectNodes(docAttach, "ROW").length; i++) {
	                    var TR = document.createElement("TR");
	                    var TD1 = document.createElement("TD");
	                    var TD2 = document.createElement("TD");
	                    var CHECK = document.createElement("INPUT");
	                    var IMG = document.createElement("IMG");
	                    var SPAN = document.createElement("SPAN");
	                    CHECK.id = "chk_" + i;
	                    CHECK.type = "checkbox";
	                    CHECK.value = getNodeText(SelectNodes(docAttach, "FILEPATH")[i]);
	                    CHECK.setAttribute("DATA1", getNodeText(SelectNodes(docAttach, "TYPE")[i]));
	                    CHECK.setAttribute("DATA2", getNodeText(SelectNodes(docAttach, "FILENAME")[i]));
	                    CHECK.onclick = function () { CheckBoxClick(this); };
	                    TR.ondblclick = function () { FileDown(this); };
	                    TR.style.cursor = "pointer";
	                    TR.setAttribute("FILEPATH", getNodeText(SelectNodes(docAttach, "FILEPATH")[i]));
	                    TR.setAttribute("DATA1", getNodeText(SelectNodes(docAttach, "TYPE")[i]));
	                    TR.setAttribute("DATA2", getNodeText(SelectNodes(docAttach, "FILENAME")[i]));
	                    if (getNodeText(SelectNodes(docAttach, "TYPE")[i]) == "ATT") {
	                        TR.setAttribute("DATA3", attSN);
	                        attSN++;
	                    }
	                    /* 2021-04-22 홍승비 - 통합PC저장 UI에서 더블클릭으로 첨부파일 다운로드 시, VIEWSN(표출순번)이 아닌 ATTACHFILESN(실제 PRI KEY 순번)을 사용하도록 수정 */
	                    if (getNodeText(SelectNodes(docAttach, "TYPE")[i]) == "ATT") {
	                        TR.setAttribute("DATA4", getNodeText(SelectNodes(docAttach, "ATTACHFILESN")[i]));
	                    }
	                    
	                    TD1.style.width = "30px";
	                    TD1.appendChild(CHECK);
	                    TD2.style.textAlign = "left";
	                    TD2.style.overflow = "hidden";
	                    TD2.style.textOverflow = "ellipsis";
	                    TD2.style.whiteSpace = "nowrap";
	                    switch (getNodeText(SelectNodes(docAttach, "TYPE")[i]))
	                    {
	                        case "DOC":
	                            IMG.src = "/images/appdoc.png";
	                            break;
	                        case "ATT":
	                            IMG.src = "/images/attach.png";
	                            break;
	                        case "ATTDOC":
	                            IMG.src = "/images/attdoc.png";
	                            break;
	                    }
	                    IMG.style.display = "inline-block";
	                    IMG.style.verticalAlign = "middle";
	                    SPAN.style.paddingLeft = "5px";
	                    SPAN.style.height = "16px";
	                    SPAN.style.verticalAlign = "middle";
	                    SPAN.style.paddingTop = "5px";
	                    SPAN.id = "spn_title";
	                    if (new RegExp(/Firefox/).test(navigator.userAgent))
	                        SPAN.innerHTML = getNodeText(SelectNodes(docAttach, "FILENAME")[i]).replace(/&amp;/gi, "&");
	                    else
	                        SPAN.innerText = getNodeText(SelectNodes(docAttach, "FILENAME")[i]).replace(/&amp;/gi, "&").replace("\r", "").replace("\n", "");
	
	                    TD2.appendChild(IMG);
	                    TD2.appendChild(SPAN);
	                    TD1.style.height = "20px";
	                    TD2.style.height = "20px";
	                    TR.appendChild(TD1);
	                    TR.appendChild(TD2);
	                    table_filelist.appendChild(TR);
	                }
					if(hasOpinion=="Y"){
		                var opiTR = document.createElement("TR");
	                    var opiTD1 = document.createElement("TD");
	                    var opiTD2 = document.createElement("TD");
	                    var opiIMG = document.createElement("IMG");
	                    var opiCHECK = document.createElement("INPUT");
	                    var opiSPAN = document.createElement("SPAN");
	                    opiCHECK.id = "chk_"+i++;
	                    opiCHECK.type = "checkbox";
	                    opiCHECK.value = "Y";
	                    opiCHECK.onclick = function () { CheckBoxClick(this); };
	                    opiTR.ondblclick = function () { opinionDown(); };
	                    opiTR.style.cursor = "pointer";
	                    opiCHECK.setAttribute("opinionchk","YES");
	                    opiTD1.style.width = "30px";
	                    opiTD1.appendChild(opiCHECK);
	                    opiTD2.style.textAlign = "left";
	                    opiTD2.style.overflow = "hidden";
	                    opiTD2.style.textOverflow = "ellipsis";
	                    opiTD2.style.whiteSpace = "nowrap";
	                    opiTD1.style.height = "20px";
	                    opiTD2.style.height = "20px";
	                    
	                    opiIMG.src = "/images/txt.png";
	                    opiIMG.style.display = "inline-block";
	                    opiIMG.style.verticalAlign = "middle";
	                    
	                    opiSPAN.style.paddingLeft = "5px";
	                    opiSPAN.style.height = "16px";
	                    opiSPAN.style.verticalAlign = "middle";
	                    opiSPAN.style.paddingTop = "5px";
	                    opiSPAN.innerText = "<spring:message code='ezApprovalG.t00012'/>";
	                    
	                    opiTD2.appendChild(opiIMG);
	                    opiTD2.appendChild(opiSPAN);
	                    opiTR.appendChild(opiTD1);
	                    opiTR.appendChild(opiTD2);
	                    table_filelist.appendChild(opiTR);
	                }
	            }            
	        };
	
	        function FileDown(obj) {
	            var pSourcePath = obj.getAttribute("FILEPATH").split('.')[1];
	            var pDocID_mht = obj.getAttribute("FILEPATH").substring(obj.getAttribute("FILEPATH").lastIndexOf("/") + 1, obj.getAttribute("FILEPATH").length).split('.')[0];
	            
	            if (pSourcePath.toUpperCase() == "MHT") {
	            	AttachDownFrame.location.href = "/ezApprovalG/downloadMhtDbClick.do?fileName=" + encodeURIComponent(obj.getAttribute("DATA2") + "." + pSourcePath) + "&fileName2=" + obj.getAttribute("DATA2") + "&docID=" + pDocID_mht + "&docStatus=END&filePath=" + obj.getAttribute("FILEPATH");
	            	return;
	            }
	            
	            if (obj.getAttribute("DATA1") == "ATT") {
	                AttachDownFrame.location.href = "/ezApprovalG/downloadAttachDbClick.do?type=APPROVALG&fileName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&docID=" + pDocID + "&docStatus=" + pType + "&docAttachSN=" + obj.getAttribute("DATA4") + "&orgCompanyID=" + orgCompanyID;
				} else if (obj.getAttribute("DATA1") == "ATTDOC") {
					if (pSourcePath.toUpperCase() == "HWP" && useHwpDownSecurity == "Y" && approvalFlag == "G") {
						dcHwpDown(obj, pSourcePath, pDocID_mht);
					} else {
						AttachDownFrame.location.href = "/ezApprovalG/downloadAttachDbClick.do?type=APPROVALGMHT&fileName=" + encodeURIComponent(obj.getAttribute("DATA2") + "." + pSourcePath) + "&docID=" + pDocID_mht + "&docStatus=END&orgCompanyID=" + orgCompanyID;
					}
	            } else {
	            	if (pType == "TMP") { //2019-02-08 천성준 - #14965 임시보관함문서 > 문서보기 > 통합PC저장 시, 첨부 및 문서파일을 내려받을수 없던 문제해결
	            		AttachDownFrame.location.href = "/ezApprovalG/downloadAttachDbClick.do?type=APPROVALGMHT&fileName=" + encodeURIComponent(obj.getAttribute("DATA2") + "." + pSourcePath) + "&docID=" + pDocID + "&docStatus=" + pType + "&orgCompanyID=" + orgCompanyID;
					} else {
						if (pSourcePath.toUpperCase() == "HWP" && useHwpDownSecurity == "Y" && approvalFlag == "G") {
							dcHwpDown(obj, pSourcePath, pDocID_mht);
						} else {
							AttachDownFrame.location.href = "/ezApprovalG/downloadAttachDbClick.do?type=APPROVALGMHT&fileName=" + encodeURIComponent(obj.getAttribute("DATA2") + "." + pSourcePath) + "&docID=" + pDocID_mht + "&docStatus=" + pType + "&orgCompanyID=" + orgCompanyID;
						}
					}
				}
			}
	
	        function btn_OK()
	        {
	            if (strTypeInfo == ""  && opinionChk == "") {
	                showAlert(strLang584);
	                return;
	            }
	            
				var strTypeInfoArr = strTypeInfo.split("|||");
				var strPathInfoArr = strPathInfo.replace("&amp;", "&").split("|||");
				length = (strTypeInfoArr.length - 1);
				docHwpPathArr = new Array(strTypeInfoArr.length - 1);
				docHwpPath = "";
				downUrl = "";
				num = 0;
	            
				for (var i = 0; i < strTypeInfoArr.length - 1; i++) {
					
					if ((strTypeInfoArr[i] == "DOC" || strTypeInfoArr[i] == "ATTDOC") && strPathInfoArr[i].substring(strPathInfoArr[i].lastIndexOf(".") + 1).toUpperCase() == "HWP") {
						docHwpPathArr[i] = strPathInfoArr[i];
					} else {
						docHwpPathArr[i] = "noPath"; // 2023-05-09 김우철 - 배포용 문서로 저장할 대상이 아닌 경우 docHwpPath를 "noPath"로 지정
					}
	           	 	
					docHwpPath += (docHwpPathArr[i] + "|||");
				}
	        	
				if (useHwpDownSecurity == "Y" && approvalFlag == "G") {
					hwp_url(num);
				} else {
					download(downUrl);
				}
			}
	
	        var strPathInfo = "";
	        var strTypeInfo = "";
	        var strFileName = "";
	        var opinionChk = "";
	        function CheckBoxClick(obj)
	        {
	        	/* 2023-05-23 김우철 - 파일명에 사용할 수 없는 특수문자를 "_" 문자로 치환 (타 모듈과 파일명 특수문자 처리 통일) */
	        	var filename = GetAttribute(obj, "data2").replace(/[*|\\\":\/?<>]/gi, "_");
	            document.getElementById('cbx_all').checked = false;
	            
	            // 2023-06-30 한태훈 - 통합 PC 저장시 의견 다운로드 기능 추가
	            if (hasOpinion == "Y" && obj.getAttribute("opinionchk") == "YES") {
	            	if (obj.checked) {
	            		opinionChk = obj.value;
	            		obj.parentElement.parentElement.style.backgroundColor = "#f1f8ff";
	            	} else {
	            		opinionChk = "";
	            		obj.parentElement.parentElement.style.backgroundColor = "#FFFFFF";
	            	}
	            	return;
	            }
	            
	            if (obj.checked) {
	                obj.parentElement.parentElement.style.backgroundColor = "#f1f8ff";
	                strPathInfo = strPathInfo + obj.value + "|||";
	                strTypeInfo = strTypeInfo + GetAttribute(obj, "data1") + "|||";
	                strFileName = strFileName + filename + "|||";
	            }
	            else {
	                obj.parentElement.parentElement.style.backgroundColor = "#FFFFFF";
	                strPathInfo = strPathInfo.replace(obj.value + "|||", '');
	                strTypeInfo = strTypeInfo.replace(GetAttribute(obj, "data1") + "|||", '');
	                strFileName = strFileName.replace(filename + "|||", '');
	            }
	        }
	        
	        function HeaderCheckBoxClick(obj) {
	            var count = GetChildNodes(document.getElementById('table_filelist')).length;
	            if (!CrossYN())
	                count = count - 1;
	            
	            strPathInfo = "";
                strTypeInfo = "";
                strFileName = "";
                opinionChk = "";
                
                if (hasOpinion == "Y") {
                	count = count - 1; // 의견 작성 리스트 있는 경우 count - 1 (의견 파일은 실제 첨부파일이 아니므로 count에서 제외);
                }
                
	            if (obj.checked) {
	                for (var i = 0; i < count ; i++) {
						var filename = GetAttribute(document.getElementById('chk_' + i), "data2").replace(/[*|\\\":\/?<>]/gi, "_");
	                    document.getElementById('chk_' + i).checked = true;
	                    
	                    if (CrossYN()) {
	                        GetChildNodes(document.getElementById('table_filelist'))[i].style.backgroundColor = "#f1f8ff";
	                    } else {
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[0].style.backgroundColor = "#f1f8ff";
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[1].style.backgroundColor = "#f1f8ff";
	                    }
	
	                    strPathInfo += document.getElementById('chk_' + i).value + "|||";
	                    strTypeInfo += GetAttribute(document.getElementById('chk_' + i), "data1") + "|||";
	                    strFileName += filename + "|||";
	                }
	                if (hasOpinion == "Y") {
		                var opinionChkbox = document.getElementById('chk_' + i++);
		                opinionChkbox.checked = true;
		                opinionChkbox.parentElement.parentElement.style.backgroundColor = "#f1f8ff";
		                opinionChk = "Y";
	                }
	            }
	            else {
	                for (var i = 0; i < count ; i++) {
	                    document.getElementById('chk_' + i).checked = false;
	
	                    if (CrossYN())
	                        GetChildNodes(document.getElementById('table_filelist'))[i].style.backgroundColor = "#FFFFFF";
	                    else {
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[0].style.backgroundColor = "#FFFFFF";
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[1].style.backgroundColor = "#FFFFFF";
	                    }
	                }
	                if (hasOpinion == "Y") {
	                	var opinionChkbox = document.getElementById('chk_' + i++);
		                opinionChkbox.checked = false;
		                opinionChkbox.parentElement.parentElement.style.backgroundColor = "#FFFFFF";
	                	opinionChk = "";
	                }
	            }
	        }
	        function window_close() {
	            if (ReturnFunction != null)
	                ReturnFunction();
	            window.close();
	        }
	        
	        function QuitWindow() {
// 		        OpenAlertUI(strLang929);
				showAlert(strLang1139);
				window_close();
		    }
	        
	        /* 2023-05-09 김우철 - 통합PC저장 시 다중 파일을 배포용 문서로 저장할 때, Whwp api가 비동기로 호출되는 것을 제어하기 위한 재귀함수 */
			function hwp_url(p_num) {
				// p_num은 각 첨부파일의 배열 인덱스이며, 파일 전체 개수보다 같거나 많아지는 경우 download 함수 호출
				if (p_num >= length) {
					return download(downUrl);
				} else {
					if (isHwpCtrlOpen != true) {
						showAlert(strLangKWCHd01);
						return;
					}
	        		
					if (docHwpPathArr[num] == "noPath") {
						downUrl += ("noURL|||");
						num++;
   						
						return hwp_url(num);
					} else {
						var doc = HwpCtrl.Open(window.location.origin + docHwpPathArr[num], "HWP", "", function(res) {
							// console.log("res" + num + " : " + JSON.stringify(res));
							if (res.result) {
                   				var dact = HwpCtrl.CreateAction("FileSetSecurity");
        						var dset = dact.CreateSet();
        						
        						dact.GetDefault(dset);
        						
        						// 패스워드 설정
        						dset.SetItem("Password", "${HwpSecurityNum}");
        						
        						// 프린트 사용여부
        						dset.SetItem("NoPrint", true);
        						
        						// 복사 방지
        						dset.SetItem("NoCopy", true);
        						
        						var rtn = dact.Execute(dset, function(action, param, result, userData) {
        							// 배포용 문서는 웹한글기안기 서버 상에 저장되며, downUrl에는 웹한글기안기 서버에서 해당 파일을 다운로드하기 위한 URL이 저장됨
        	   						downUrl += (result.downloadUrl + "|||");
        	   						num++;
        	   						
        	   						return hwp_url(num);
        						});
                   			} else {
                   				showAlert(strLangKWCHd01);
                   				return;
                   			}
        				});	
           			}
	        	}
			}
			
	        /* 2023-05-09 김우철 - 통합PC저장 시 단일 파일을 더블클릭으로 저장할 때 배포용 문서로 저장 */
			function dcHwpDown(obj, pSourcePath, pDocID_mht) {
				if (isHwpCtrlOpen != true) {
	        		showAlert(strLangKWCHd01);
	        		return;
	        	}
	        	
				var filename = GetAttribute(obj, "data2").replace(/[*|\\\":\/?<>]/gi, "_");
	        	var doc = HwpCtrl.Open(window.location.origin + obj.getAttribute("FILEPATH"), "HWP", "", function(res) {
           			// console.log("res : " + JSON.stringify(res));
           			if (res.result) {
	           			var dact = HwpCtrl.CreateAction("FileSetSecurity");
						var dset = dact.CreateSet();
						
						dact.GetDefault(dset);
						
						// 패스워드 설정
						dset.SetItem("Password", "${HwpSecurityNum}");
						
						// 프린트 사용여부
						dset.SetItem("NoPrint", true);
						
						// 복사 방지
						dset.SetItem("NoCopy", true);
						
						var rtn = dact.Execute(dset, function(action, param, result, userData) {
							// 배포용 문서는 웹한글기안기 서버 상에 저장되며, result.downloadUrl에는 웹한글기안기 서버에서 해당 파일을 다운로드하기 위한 URL이 리턴됨
		  					document.getElementById("AttachDownFrame").src = "/ezApprovalG/downloadHwpDbClick.do?fileName=" + encodeURIComponent(filename + "." + pSourcePath) + "&docID=" + pDocID_mht + "&downloadUrl=" + result.downloadUrl;
						});
					} else {
						showAlert(strLangKWCHd01);
						return;
					}
				});	
			}
	        
			/* 2023-05-09 김우철 - 통합PC저장 > 실제 첨부파일 다운로드를 위한 함수 분리 (다중 파일 저장) */
			function download(downloadUrl) {
				var p_downloadUrl = downloadUrl;
				var xmlhttp = createXMLHttpRequest();
				var xmlpara = createXmlDom();
	            
				var xmlstring = "<DATA>";
				xmlstring += "<PDOCID>" + pDocID + "</PDOCID>";
				xmlstring += "<PTITLE><![CDATA[" + ReplaceText(document.getElementById('spn_title').innerText, "\n", "").replace(/[*|\\\":\/?<>]/gi, "_") + "]]></PTITLE>";
				xmlstring += "<PTYPEINFO><![CDATA[" + strTypeInfo + "]]></PTYPEINFO>";
				xmlstring += "<PPATHINFO><![CDATA[" + strPathInfo.replace("&amp;", "&") + "]]></PPATHINFO>";
				xmlstring += "<PFILEINFO><![CDATA[" + ReplaceText(strFileName, "\n", "") + "]]></PFILEINFO>";
				xmlstring += "<PHWPINFO><![CDATA[" + docHwpPath.replace("&amp;", "&") + "]]></PHWPINFO>";
				xmlstring += "<POPINIONCHK><![CDATA[" + opinionChk + "]]></POPINIONCHK>";
				xmlstring += "<PORGCOMPANY><![CDATA[" + orgCompanyID + "]]></PORGCOMPANY>";
				 
				if (useHwpDownSecurity == "Y" && approvalFlag == "G") {
					xmlstring += "<PDOWNINFO><![CDATA[" + p_downloadUrl.replace("&amp;", "&") + "]]></PDOWNINFO>";
				}
				xmlstring += "</DATA>";
				xmlpara = loadXMLString(xmlstring);
				
				xmlhttp.open("Post", "/ezApprovalG/saveTotalDoc.do", false);
				xmlhttp.send(xmlpara);
				var URL = xmlhttp.responseText;
				
				/* 2023-03-08 홍승비 - 통합PC저장으로 결재문서와 첨부파일 다운로드 후, 임시 생성된 .zip파일 삭제 */
				document.getElementById("AttachDownFrame").src = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(URL) + "&isToDelFG=Y";
			}
			
			// 2023-06-30 한태훈 - 통합 PC 저장시 의견 다운로드 기능 추가 (더블클릭 시 단일 다운로드 기능)
			function opinionDown() {
				var URL = "";
				$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/opinionDown.do",
	        		data : {
	        			docID : pDocID,
	        			orgCompanyID : orgCompanyID
	        		},
	        		success: function(result) {
	        			URL = result;
	        		}
	        	});
				document.getElementById("AttachDownFrame").src = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(URL) + "&isToDelFG=Y";
			}
			
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t00008'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window_close()"></span></li>
            </ul>
        </div>
	    <span>&nbsp;▒ <spring:message code='ezApprovalG.t00009'/></span>
	    <table class="mainlist" style="width: 550px; margin-left: 5px;margin-top:7px">
	        <tr>
	            <th style="width:30px;"><input id="cbx_all" type="checkbox" onclick="return HeaderCheckBoxClick(this);" value="all" /></th>
	            <th><spring:message code='ezApprovalG.t00010'/></th>
	        </tr>                
	    </table>
	    <div style="overflow-y:auto; overflow-x:auto; height:250px; width: 555px;">
	        <table class="mainlist" id="table_filelist" style="width: 99%; margin-left: 5px;">
	        </table>
	    </div>
	    <br />
	     <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span style="text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>	        
	    </div>
	    <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	    <div id="hwpctrl"/>

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>