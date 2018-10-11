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
		<script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
	</head>
	<body>
		<div class="layDIV">
			<dl class="portlet_title">
				<!-- portalMain에서 타이틀 넣어주는게 나을꺼같은데 -->
				<dt class="portletText"></dt>
				<dd class="portletPlus" id="fraviteFormsPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
			</dl>
			
			<ul class="bookmark">
				<li class='bookmarkLi_none'></li>
				<li class='bookmarkLi_none'></li>
				<li class='bookmarkLi_none'></li>
				<li class='bookmarkLi_none'></li>
				<li class='bookmarkLi_none'></li>
			</ul>
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
		
		<script type="text/javascript">
		//개똥이라 수정해야함 긁고 붙이고해서 돌아가게만 해놓음
			var getFavoriteForms = function() {
				var request = new XMLHttpRequest();
				request.open('POST', '/ezNewPortal/getFavoriteForms.do', true);

				request.onload = function() {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						
						var forms = result.resultList;
						var formsHTML = "";
						
						for (var i = 0; i < 5; i++) {
							if (forms[i]) {
								formsHTML += "<li class='bookmarkLi' data-location='" + forms[i].formFileLocation + "' data-type='" + forms[i].formDocType + "'><span>" + forms[i].formName + "</span></li>";
							} else {
								formsHTML += "<li class='bookmarkLi_none'></li>";
							}
						}
						
						document.getElementsByClassName('bookmark')[0].innerHTML = formsHTML
						
						Array.from(document.getElementsByClassName('bookmarkLi')).forEach(function(element) {
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

				var data = JSON.stringify({
					"userId" : "${userInfo.id}"
				});
				
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
		    
		    function openDraftUI(formURL, formDocType) {
		        var openLocation = "";
		      
		        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht") {
		        	openLocation += "/ezApprovalG/draftui.do?formURL=";
		            openLocation += encodeURIComponent(formURL) + "&draftFlag=" + encodeURIComponent('DRAFT') + "&formDocType=" + encodeURIComponent(formDocType);
		            openLocation += "&susinSN=0&docState=&listType=1&aprState=";
		            openLocation += "&isTmpDoc=";
		        } else {
		        	if (!isIE()) {
		                alert(strLang1103);
		                return;
		            } else {
		            	openLocation += "/ezApprovalG/draftuiHWP.do";
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
			
		    //이거 뭔가 되게 이상한거같은데
			var checkBujaeInfo = function (type, formURL, formDocType) {
				var BString = "${buJaeInfo}";
				
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            if (tmpEndDate < "${now}") {
		                setBujaeOff();
		                checkBujaeInfo_Complete(true, type, formURL, formDocType);
		                return true;

		            } else if (tmpStartDate > "${now}") {
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
		    		}
		    	});
		    }
		    
		    //로드되고나서
		    document.getElementById('fraviteFormsPlus').addEventListener('click', fraviteFormsPlus);
			getFavoriteForms();
		</script>
	</body>
</html>