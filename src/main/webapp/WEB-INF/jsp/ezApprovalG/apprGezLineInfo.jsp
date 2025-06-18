<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<c:choose>
				<c:when test="${docState == '015'}">
			        <c:if test="${approvalFlag == 'G'}">
					    <spring:message code='ezApprovalG.t1214'/>
			        </c:if>
			        <c:if test="${approvalFlag == 'S'}">
					    <spring:message code='ezApprovalG.sendGongram03'/>
			        </c:if>
				</c:when>
				<c:otherwise>
					<spring:message code='ezApprovalG.t1215'/>
				</c:otherwise>
			</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<style>
			.mainlist tr th {
				border-top:0px;
			}
		</style>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript">
		    var pDocID = "<c:out value ='${docID}'/>";
		    var pDeptID = "<c:out value ='${deptID}'/>";
		    var pDocState = "<c:out value ='${docState}'/>";
		    var pAprState = "<c:out value ='${aprState}'/>";
		    var ChildDocInfo = "${childDocInfo}";
		    var xmlhttp = createXMLHttpRequest();	
		    var FLAG;
		    var pDocInfoValue = "1";
		    var tempDocID;
		    var tempGDocID;
		    var OrderCell = "";
		    var ezapralert_cross_dialogArguments = new Array();
		    var ezapropinion_cross_dialogArguments = new Array();
		    
		    //2023-05-16 임정은 - 공람 회수
		    var count;
		    var aprMemberSN;

			// 의견 모달창을 띄우기 위한 companyID
			var orgCompanyID = "<c:out value ='${companyID}'/>";
			
			var ReturnFunction;

		    window.onload = function () {
				if (isParentCommonArgsUsed()) {
					ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
				}
				
		        try {
		            var xmlpara = createXmlDom();
		            xmlpara = loadXMLString(ChildDocInfo);
		
		            tempDocID = getNodeText(SelectSingleNode(xmlpara.documentElement, "DOCID"));
		            FLAG = getNodeText(SelectSingleNode(xmlpara.documentElement, "FLAG"));
		            tempGDocID = getNodeText(SelectSingleNode(xmlpara.documentElement, "GDOCID"));
		
		            if (FLAG == "END") {
		                getEndLine(tempDocID);
		            }
		            else if (FLAG == "APR") {
		            	if (pAprState == "N") {
		            		getAprLine("");
			                return;
		            	} else {
			                getAprLine(tempDocID);
		            	}
		            }
		            else {
		                getAprLine("");
		                return;
		            }
		            if ("<c:out value ='${approvalFlag}'/>" == 'G') {
		            	if (pDocState == "011") {
		                	document.getElementById("tdGongRam").style.display = "";
		            	}
		            }
		        }
		        catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    };
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";

		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            ezapralert_cross_dialogArguments[2] = true;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            ezapropinion_cross_dialogArguments[2] = true;
		            if (CompleteFunction != undefined) {
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            } else {
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            }
		            DivPopUpShow(330, 205, url);
		        } else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		            if (RtnVal)
		                CompleteFunction(RtnVal);
		        }
		        return RtnVal;
		    }
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		    function getAprLine(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/getLineList.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "APR"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getEndLine(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/getLineList.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "END"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getAprOpinion(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/getOpinionInfo.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "APR"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getEndOpinion(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/getOpinionInfo.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "END"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getAprovSub_after(xml) {
		        try {
		            if (xml == "") return;
		
		            document.getElementById("lvAprLine").innerHTML = "";
		            
		            if (xml == "NOTPERMISSION") {
		            	document.getElementById("lvAprLine").innerHTML = "<div style='height:170px;text-align:center;padding-top:150px;font-size:12px'><spring:message code='main.t00001'/></div>";
		            	return;
		            }		            
		
		            var listview = new ListView();                          
		            listview.SetID("AprLine");                              
		            listview.SetMulSelectable(false);                       
		            listview.SetRowOnDblClick("lvAprLine_DBSelChange");
		            listview.DataSource(loadXMLString(xml));                            
		            listview.DataBind("lvAprLine");                        
		
		            var tr = listview.GetDataRows();
					
		            var cnt = tr.length;
		            var i, j;
		            var chkVal;
		            /* if (cnt > 0 && tr[0].id != "AprLine_TR_noItems") {
		                for (i = 0; i < cnt; i++) {
		                    tr[i].cells[2].setAttribute("title", tr[i].cells[2].innerText);
		                }
		            } */
		            
		            var content = document.getElementById("AprLine_TH_2");
		            
		            if (content.innerText == strLang30) {
		            	content.setAttribute("width" , "356px");
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    function lvAprLine_DBSelChange() {
		        if (pDocInfoValue == "1" || pDocInfoValue == "5") {
		            openUserInfo();
				} else if (pDocInfoValue == "4") { // 의견 탭
					btnOpinion_onclick();
				}
		    }
			var aprendopinion_dialogArgument = new Array();
			function btnOpinion_onclick() {
				var parameter = new Array();
				parameter[0] = tempDocID;
				parameter[1] = "Show";
				parameter[2] = orgCompanyID;

				aprendopinion_dialogArgument[0] = parameter;
				aprendopinion_dialogArgument[1] = openOpinionUI_Complete;
				DivPopUpShow(430, 420, "/ezApprovalG/aprEndOpinion.do?resize=true");
			}
			function openOpinionUI_Complete() {
				DivPopUpHidden();
			}
		    function openUserInfo() {
		        var listview = new ListView();
		        listview.LoadFromID("AprLine");
		
		        var tr = listview.GetSelectedRows();
		        if (tr.length != 0) {
		            var pCheckval = tr[0].getAttribute("DATA5");
		            if (pCheckval == "Y") {
// 		                window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr[0].getAttribute("DATA3") + "&deptID=" + tr[0].getAttribute("DATA4") + "&docState=012", "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1155, 460));
		                showPopup("/ezApprovalG/ezLineInfo.do?docID=" + tr[0].getAttribute("DATA3") + "&deptID=" + tr[0].getAttribute("DATA4") + "&docState=012", 1155, 460, "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1155, 460), hidePopup);
		            }
		            else {
// 		                window.open("/ezCommon/showPersonInfo.do?id=" + tr[0].getAttribute("DATA4"), "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450));
		                showPopup("/ezCommon/showPersonInfo.do?id=" + tr[0].getAttribute("DATA4"), 420, 450, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450), hidePopup);
		            }
		        }
		    }
		    var g_tagSelectsub = "1";
		    function MM_swapImagesub(nSel) {
		    	methodForTabAction(nSel);
		        if (nSel != g_tagSelectsub) {
		            g_tagSelectsub = nSel;
		            if (g_tagSelectsub == "1") {
		                if (pDocState == "015") {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub5.gif\"";
		                    eval(str);
		                }
		                else {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub1.gif\"";
		                    eval(str);
		                }
		
		                var str2 = "tagsub4.src" + "=" + "\"/images/tab_appsub4a.gif\"";
		                eval(str2);
		                if ("<c:out value ='${approvalFlag}'/>" == 'G') {
			                var str3 = "tagsub5.src" + "=" + "\"/images/tab_appsub5a.gif\"";
			                eval(str3);
		                }
		            }
		            else if (g_tagSelectsub == "4") {
		                if (pDocState == "015") {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub5a.gif\"";
		                    eval(str);
		                }
		                else {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub1a.gif\"";
		                    eval(str);
		                }
		
		                var str2 = "tagsub4.src" + "=" + "\"/images/tab_appsub4.gif\"";
		                eval(str2);
		                if ("<c:out value ='${approvalFlag}'/>" == 'G') {
			                var str3 = "tagsub5.src" + "=" + "\"/images/tab_appsub5a.gif\"";
			                eval(str3);
		                }
		            }
		            else {
		                if (pDocState == "015") {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub5a.gif\"";
		                    eval(str);
		                }
		                else {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub1a.gif\"";
		                    eval(str);
		                }
		
		                var str2 = "tagsub4.src" + "=" + "\"/images/tab_appsub4a.gif\"";
		                eval(str2);
		                var str3 = "tagsub5.src" + "=" + "\"/images/tab_appsub5.gif\"";
		                eval(str3);
		            }
		        }
		    }
		    function Approval_onclick() {
		        if (FLAG == "END") {
		            getEndLine(tempDocID);
		        }
		        else if (FLAG == "APR") {
		        	if (pAprState == "N") {
	            		getAprLine("");
		                return;
	            	} else {
		                getAprLine(tempDocID);
	            	}
		        }
		        else
		            getAprLine("");
		    }
		    function Opinion_onclick() {
		        if (FLAG == "END") {
		            getEndOpinion(tempDocID);
		        }
		        else if (FLAG == "APR") {
		            getAprOpinion(tempDocID);
		        }
		        else
		            getAprOpinion("");
		    }
		    function GongRamInfo_onClick() {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/getLineList.do",
		    		data : {
		    				docID : tempGDocID,
		    				mode  : "APR"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function methodForTabAction(target) {
            	var tab1 = document.getElementById("tagsub1").children[0];
            	var tab2 = document.getElementById("tagsub4").children[0];
            	var tab3 = "";
            	if (document.getElementById("tdGongRam") != null) {
            		tab3 = document.getElementById("tdGongRam").children[0];
            	}
            	if (target == "1") {
            		tab1.className = "tabon";
            		tab2.className = "";
            		if (tab3 != "")
            		tab3.className = "";
            	} else if (target == "4") {
            		tab1.className = "";
            		tab2.className = "tabon";
            		if (tab3 != "")
            		tab3.className = "";
            	} else if (target == "5") {
            		tab1.className = "";
            		tab2.className = "";
            		tab3.className = "tabon";
            	}
            }
		    
			// 2023-05-16 임정은 - 공람 회수 버튼 온클릭 이벤트
		    function btnWithdraw_onclick() {
		        // 의견탭에서 공람회수 기능 제외처리
		        if ($('.tabon')[0].parentElement.id != "tagsub1") return;
		        
		 		var pAlertContent = "";
		    	var listview = new ListView();
		        listview.LoadFromID("AprLine");
		        var tr = listview.GetSelectedRows();
		        
		        if (tr.length == 0) return;
		        
	        	if (tr[0].getAttribute("data12") != "002") {
	        	    if ("<c:out value ='${approvalFlag}'/>" == 'G') {
	        		    pAlertContent = "<spring:message code='ezApprovalG.LJEAppr04'/>";
	        	    } else {
	        		    pAlertContent = "<spring:message code='ezApprovalG.sendGongram05'/>";
	        	    }
	        		OpenAlertUI(pAlertContent);
	        	} else {
			        count = listview.GetDataRows().length;
			        aprMemberSN = tr[0].firstChild.innerText;
	        	    if ("<c:out value ='${approvalFlag}'/>" == 'G') {
	        		    pAlertContent = "<spring:message code='ezApprovalG.LJEAppr05'/>";
	        	    } else {
	        		    pAlertContent = "<spring:message code='ezApprovalG.sendGongram06'/>";
	        	    }
	        		OpenInformationUI(pAlertContent, btnWithdraw_onclick_Complete);
	        	}
		    }
		 	function btnWithdraw_onclick_Complete(ret) {
		 		DivPopUpHidden();
		 		if (ret) {
		 			$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/gongRamCancel.do",
			    		data : {
			    				docID : tempDocID,
			    				count : count,
			    				aprMemberSN : aprMemberSN
			    				},
			    		success: function(xml){
			    			window.location.reload();
			    		}
			    	});
		 		}
		 	}
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1>
			<c:choose>
				<c:when test="${docState == '015'}">
				    <c:if test="${approvalFlag == 'G'}">
					    <spring:message code='ezApprovalG.t1214'/>
				    </c:if>
				    <c:if test="${approvalFlag == 'S'}">
					    <spring:message code='ezApprovalG.sendGongram03'/>
				    </c:if>
				</c:when>
				<c:otherwise>
					<spring:message code='ezApprovalG.t1215'/>
				</c:otherwise>
			</c:choose>
		</h1>
		<div id="close">
		  <ul>
		    <li><span onclick="btnClose_onclick()"></span></li>
		  </ul>
		</div>
		
		<%-- <div id="tabnav">
		  <ul>
		  	<c:choose>
				<c:when test="${docState == '015'}">
				    <li id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()" ><spring:message code='ezApprovalG.t946'/></span></li>
				</c:when>
				<c:otherwise>
				    <li id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()" ><spring:message code='ezApprovalG.t1769'/></span></li>
				</c:otherwise>
			</c:choose>
		    <li id="tagsub4"><span onclick="pDocInfoValue='4';MM_swapImagesub('4');Opinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		    <c:if test="${approvalFlag == 'G'}">
		    	<li id="tdGongRam" style="display:none"><span id="tagsub5" onclick="pDocInfoValue='5';MM_swapImagesub('5');GongRamInfo_onClick()" ><spring:message code='ezApprovalG.t946'/></span></li>
		    </c:if>
		  </ul>
		</div> --%>
		
		<div class="portlet_tabpart01" style="margin:0px;">
       		<div class="portlet_tabpart01_top" style="border-bottom:0px;">
	       		<c:choose>
					<c:when test="${docState == '015'}">
					    <c:if test="${approvalFlag == 'G'}">
		       			    <p id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()"class="tabon"><spring:message code='ezApprovalG.t946'/></span></p>
                        </c:if>
					    <c:if test="${approvalFlag == 'S'}">
		       			    <p id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()"class="tabon"><spring:message code='ezApprovalG.sendGongram03'/></span></p>
                        </c:if>
					</c:when>
					<c:otherwise>
		       			<p id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()"class="tabon"><spring:message code='ezApprovalG.t1769'/></span></p>
					</c:otherwise>
				</c:choose>
       			<p id="tagsub4"><span onclick="pDocInfoValue='4';MM_swapImagesub('4');Opinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></p>
       			<c:if test="${approvalFlag == 'G'}">
	       			<p id="tdGongRam" style="display:none"><span id="tagsub5" onclick="pDocInfoValue='5';MM_swapImagesub('5');GongRamInfo_onClick()"><spring:message code='ezApprovalG.t946'/></span></p>
       			</c:if>
				<c:if test="${docState == '015'}">
       			    <c:if test="${approvalFlag == 'G'}">
       			        <input type="button" id="btnWithdraw" name="btnWithdraw" value="<spring:message code='ezApprovalG.LJEAppr03'/>" style="float:right; width:80px; padding:2px; cursor:pointer;" onclick="btnWithdraw_onclick()">
       		        </c:if>
       			    <c:if test="${approvalFlag == 'S'}">
       			        <input type="button" id="btnWithdraw" name="btnWithdraw" value="<spring:message code='ezApprovalG.sendGongram04'/>" style="float:right; <c:if test="${lang == '2'}">width:150px;</c:if> <c:if test="${lang != '2'}">width:80px;</c:if> padding:2px; cursor:pointer;" onclick="btnWithdraw_onclick()">
       		        </c:if>
				</c:if>
       		</div>
       	</div>
       	
		<div class="listview" style="overflow-x:auto;width:100%;"><div id="lvAprLine" style="HEIGHT:360px;WIDTH:100%;"></div></div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>