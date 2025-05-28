<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>favoriteFormsPortlet</title>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	</head>
	<body>
	<article class="box_shadow favorite">
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet" style="border-bottom:0px;">
				<%-- portalMain에서 타이틀을 넣어주는 것이 더 나을 수 있음 --%>
				<dt class="portletText"><c:out value = "${portletName}" /></dt>
				<dd class="portletPlus setting" id="fraviteFormsPlus"></dd>
			</dl>
			<div class = "bookmark_content">
				<ul class="bookmark">
					<li class='bookmarkLi_none'></li>
					<li class='bookmarkLi_none'></li>
					<li class='bookmarkLi_none'></li>
					<li class='bookmarkLi_none'></li>
					<li class='bookmarkLi_none'></li>
					<li class='bookmarkLi_none'></li>
				</ul>
			</div>
			
			<%-- 2023-05-31 홍승비 - 테마에 따라 즐겨찾기 양식 포틀릿 하단의 미결재문서 스타일 분기처리 --%>
			<c:choose>
				<c:when test="${usedTheme == 1 || usedTheme == 2 || usedTheme == 3}">
					<div class="apprgraph_div">
		                <div class="apprgraph_text"><spring:message code='ezNewPortal.HSBPT02'/></div>
		                <div class="apprgraph">
		                    <div class="apprgraph_area">
		                        <dl class="bookmarkG01">
		                            <dt><spring:message code='main.t00006'/></dt>
		                            <dd><span id="SIXHGAP">0</span></dd>
		                            <dd class="dot"></dd>
		                        </dl>
		                        <dl class="bookmarkG02">
		                            <dt><spring:message code='main.t00007'/></dt>
		                            <dd><span id="ONEDGAP">0</span></dd>
		                            <dd class="dot"></dd>
		                        </dl>
		                        <dl class="bookmarkG03">
		                            <dt><spring:message code='main.t00008'/></dt>
		                            <dd><span id="SEVENDGAP">0</span></dd>
		                            <dd class="dot"></dd>
		                        </dl>
		                        <dl class="bookmarkG04">
		                            <dt><spring:message code='main.t00009'/></dt>
		                            <dd><span id="ONEMGAP">0</span></dd>
		                            <dd class="dot"></dd>
		                        </dl>
		                        <dl class="bookmarkG05">
		                            <dt><spring:message code='main.t00010'/></dt>
		                            <dd><span id="OTHER">0</span></dd>
		                            <dd class="dot"></dd>
		                        </dl>
		                        <div class="graph_bar"></div>
		                    </div>
		                </div>
		            </div>
				</c:when>
				<c:otherwise>
					<div class ="apprgraph_div">
						<div class="apprgraph">
							<div class="apprgraph_area">
								<dl class="bookmarkG01">
									<dt><spring:message code='main.t00006' /></dt>
									<dd>(<span id="SIXHGAP">0</span>)</dd>
								</dl>
								<dl class="bookmarkG02">
									<dt><spring:message code='main.t00007' /></dt>
									<dd>(<span id="ONEDGAP">0</span>)</dd>
								</dl>
								<dl class="bookmarkG03">
									<dt><spring:message code='main.t00008' /></dt>
									<dd>(<span id="SEVENDGAP">0</span>)</dd>
								</dl>
								<dl class="bookmarkG04">
									<dt><spring:message code='main.t00009' /></dt>
									<dd>(<span id="ONEMGAP">0</span>)</dd>
								</dl>
								<dl class="bookmarkG05">
									<dt><spring:message code='main.t00010' /></dt>
									<dd>(<span id="OTHER">0</span>)</dd>
								</dl>
							</div>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</article>
		<script type="text/javascript">
			// 즐겨찾기 양식목록 조회
			var BString = "${buJaeInfo}";
			
			var getFavoriteForms = function() {
				var request = new XMLHttpRequest();
				request.open('GET', '/ezNewPortal/getFavoriteForms.do', true);

				request.onload = function() {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						
						var forms = result.resultList;
						var formsHTML = "";
						
						for (var i = 0; i < 6; i++) {
							if (forms[i]) {
								// 텍스트 한줄 ... 처리로 수정(기존 3줄 ... 처리는 주석 처리(uiux 조기완)
								// formsHTML += "<li class='bookmarkLi' data-location='" + forms[i].formFileLocation + "' data-type='" + forms[i].formDocType + "'><span style='overflow:hidden; text-overflow:ellipsis; -webkit-line-clamp:3; -webkit-box-orient:vertical; height: 39px;";
								formsHTML += "<li class='bookmarkLi' data-location='" + forms[i].formFileLocation + "' data-type='" + forms[i].formDocType + "'><span";
								if (navigator.userAgent.indexOf("Trident") > -1) {
									// formsHTML += " display:-ms-flexbox; -ms-flex-pack:center; "
								} else {
									// formsHTML += " display:-webkit-box; "
								}
								// formsHTML += "'>" + forms[i].formName + "</span></li>";
								formsHTML += ">" + forms[i].formName + "</span></li>";
							} else {
								formsHTML += "<li class='bookmarkLi_none'></li>";
							}
						}
						
						document.getElementsByClassName('bookmark')[0].innerHTML = formsHTML
						
						var elementList = document.querySelectorAll('.bookmarkLi');
							
						[].forEach.call(elementList, function(element) {
							element.addEventListener('click', function() {
								checkBujaeOpenDraftUI(this.getAttribute("data-location"), this.getAttribute("data-type"));
							});
						});
					} else {
						// We reached our target server, but it returned an error
					}
				};

				request.onerror = function() {
				  // There was a connection error of some sort
				};
				
				request.send();
			}
			
			// 결재통계 조회
			var getApprovalStatistics = function() {
				var request = new XMLHttpRequest();
				request.open('GET', '/ezNewPortal/getApprovalStatistics.do', true);

				request.onload = function() {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						
						document.getElementById("SIXHGAP").innerHTML = result.hour;
						document.getElementById("ONEDGAP").innerHTML = result.day;
						document.getElementById("SEVENDGAP").innerHTML = result.week;
						document.getElementById("ONEMGAP").innerHTML = result.month;
						document.getElementById("OTHER").innerHTML = result.other;
					} else {
						// We reached our target server, but it returned an error
					}
				};

				request.onerror = function() {
				  // There was a connection error of some sort
				};
				
				request.send();
			}
		
		
			var fraviteFormsPlus = function () {
		    	if (!checkBujaeInfo('form')) {
		    		return;
		    	}
			}
			
			var checkBujaeOpenDraftUI = function (formURL, formDocType) {
		    	if (!checkBujaeInfo('draft', formURL, formDocType)) {
		    		return;
		    	}
		    }
			
			var getformcont_cross_dialogArguments = new Array();
			var openForm = function() {
		        var parameter = new Array();
		        parameter[0] = "${userInfo.deptID}";
		        parameter[1] = "A01000";
	            url = "/ezApprovalG/getFormCont.do";
		        
		        if (CrossYN()) {
		            getformcont_cross_dialogArguments[0] = parameter;
		            getformcont_cross_dialogArguments[1] = openForm_Complete;
		            getformcont_Cross_OpenWin = window.open(url, "/ezApprovalG/getFormCont.do", GetOpenWindowfeature(713, 570));
		            
		            try { getformcont_Cross_OpenWin.focus(); } catch (e) {}
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		            var ret = window.showModalDialog(url, parameter, feature);
		            formURL = ret[0];
		            formDocType = ret[1];
		            
		            if (formURL != "cancel") {
		                openDraftUI(formURL, formDocType);
		            }
		        }
		    }
		    
		    function openForm_Complete(ret) {
		        getformcont_Cross_OpenWin.close();
		        formURL = ret[0];
		        formDocType = ret[1];
		        if (formURL != "cancel") {
		            openDraftUI(formURL, formDocType);
		        }
		    }
		    
		    // 2018-09-18 구해안 - 팝업창 가져오기 위해 OpenInformationUI 함수 복붙
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction, type, type2, formURL, formDocType) {
			var parameter = pInformationContent;
		    var url = "/ezApprovalG/ezAprOpinion.do";
		    
			// 2018-08-07 강민수92 - 크롬에서 반송문서 대장등록 할수있게 하기위해  CompleteFunction != "" 추가
		    if (CrossYN() && (CompleteFunction != "")) {
		        ezapropinion_cross_dialogArguments[0] = parameter;
		        if (type == undefined && CompleteFunction != undefined) {
		            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            DivPopUpShow(330, 205, url);
		        }
		        else if (type == undefined && CompleteFunction == undefined) {
		            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else if (type != undefined && CompleteFunction != "") {
		            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            ezapropinion_cross_dialogArguments[2] = true;
		            var OpenWin = window.open(url + "?type="+type2+"&formURL="+formURL+"&formDocType="+formDocType, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else if (type != undefined && CompleteFunction == "") {
		        	ezapropinion_cross_dialogArguments[2] = true;
		            var OpenWin = window.open(url + "?type="+type2+"&formURL="+formURL+"&formDocType="+formDocType, "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		            try { OpenWin.focus(); } catch (e) { }
		        }
			    } else {
			        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			        feature = feature + GetShowModalPosition(330, 205);
			        var RtnVal = window.showModalDialog(url, parameter, feature);
			    }
			    return RtnVal;
			}
			
			function OpenInformationUI_Complete() {
			    DivPopUpHidden();
			}
		    
		    function openDraftUI(formURL, formDocType) {
		        var openLocation = "";
		      
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
		        	openLocation += "/ezApprovalG/draftui.do?formURL=";
		            openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
		            openLocation += "&susinSN=0&docState=&listType=1&aprState=";
		            openLocation += "&isTmpDoc=";
		        } else {
		        	if("${useWebHWP}" == "NO") {
			        	if (!isIE()) {
			                alert(strLang1103);
			                return;
			            } else {
			            	openLocation += "/ezApprovalG/draftuiHWP.do?formURL=";
			            	openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
			                openLocation += "&susinSN=0&docState=&listType=1&aprState=";
			                openLocation += "&isTmpDoc=";
			            }
		        	} else {
		        		openLocation += "/ezApprovalG/draftuiWHWP.do?formURL=";
		            	openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
		                openLocation += "&susinSN=0&docState=&listType=1&aprState=";
		                openLocation += "&isTmpDoc=";
		        	}
		        }

		        openwindow(openLocation, "", 890, 560);
		    }
		    
		    var openwindow = function openwindow(wfileLocation) {
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
			
		    // 부재자 설정 체크 로직
			var checkBujaeInfo = function (type, formURL, formDocType) {
				
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		            var now = "${now}";
		            now = now.substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            if (tmpEndDate < now) {
		                setBujaeOff();
		                checkBujaeInfo_Complete(true, type, formURL, formDocType);
		                return true;

		            } else if (tmpStartDate > now) {
		            	checkBujaeInfo_Complete(true);
		                return true;
		            }
		            var pAlertContent = "${userInfo.displayName1}" + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";

		            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN", type, formURL, formDocType);
		            return;
		            if (Rtnval) {
		                checkBujaeInfo_Complete(true, type, formURL, formDocType);
		                return;
		            }
		            else {
		                checkBujaeInfo_Complete(false, type, formURL, formDocType);
		                return;
		            }
		        } else {
		            checkBujaeInfo_Complete(true, type, formURL, formDocType);
		            return true;
		        }
		    }
		
		    var checkBujaeInfo_Complete = function (Rtnval, type, formURL, formDocType) {
	            if (Rtnval == true) {
	                setBujaeOff();
	                clearAbsence(true);
	                
		            if (type == "form") {
		            	openForm();
		            } else {
		            	openDraftUI(formURL, formDocType);
		            }
	            } else {
	                return;
	            }
	        }
		    
		    var setBujaeOff = function() {
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : "",
		    				proxy  : ""
		    				},
		    		success: function(xml) {
// 		    			arr_userinfo[7] = "";
		    			BString = "";
		    		}
		    	});
		    }
		    
		    // 로드 이후 동작
		    document.getElementById('fraviteFormsPlus').addEventListener('click', fraviteFormsPlus);
			getFavoriteForms();
			getApprovalStatistics();
		</script>
	</body>
</html>