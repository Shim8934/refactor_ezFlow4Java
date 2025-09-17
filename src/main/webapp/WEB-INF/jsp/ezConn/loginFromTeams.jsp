<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="${util.addVer('/js/ezConn/MicrosoftTeams.min.js')}"></script>
		<script type="text/javascript">
            (function () {
                "use strict";
            
                microsoftTeams.app.initialize().then(function () {
                    microsoftTeams.app.getContext().then(function (context) {
                        if (context?.user?.userPrincipalName) {
                            var upn = context.user.userPrincipalName;
                            var tab = '<c:out value="${type}"/>' || 'orgChart';
                            var hostClientType = (context.app?.host?.clientType || "").toLowerCase();
                            var device = "web";
                            if (hostClientType === "android" || hostClientType === "ios" || hostClientType === "ipados") {
                                device = isTabletDevice() ? "tablet" : "mobile";
                            }
                            var lang = context.app?.locale || "";
                            var subIndex = context.subEntityId || "";

                            location.href = "/ezConn/loginForTeams.do?encacc=" + encodeURIComponent(upn) + "&tabmenu=" + encodeURIComponent(tab) + "&device=" + encodeURIComponent(device) + "&lang=" + encodeURIComponent(lang) + "&index=" + encodeURIComponent(subIndex);
                        }
                    });
                });
            
                function doLogin(id) {
                    location.href = "/ezConn/loginForTeams.do?id=" + encodeURIComponent(id) + "&cmd=<c:out value='${type}' />";
                }
                
                function updateHubState(hubName) {
                    if (hubName) {
                        document.getElementById("hubState").innerHTML = "in " + hubName;
                    }
                }

                function isTabletDevice() {
                    var isTablet = false;
                    var userAgent = navigator.userAgent.toLowerCase();

                    if (userAgent.indexOf('ipad') > -1
                        || (userAgent.indexOf('android') > -1 && userAgent.indexOf('mobile') == -1)
                        || userAgent.indexOf('sm-x') > -1) { // 일부 갤럭시 탭 모델 식별
                        isTablet = true;
                    }

                    if (isTabletDevice_Sub()) {
                        isTablet = true;
                    }

                    // 갤럭시 탭 전용 보정 (필요 없으면 제거 가능)
                    var galaxyTabModel = ['shw-'];
                    for (var i = 0; i < galaxyTabModel.length; i++) {
                        if (userAgent.indexOf(galaxyTabModel[i]) > -1) {
                            isTablet = true;
                            break;
                        }
                    }
                    return isTablet;
                }

                function isTabletDevice_Sub() {
                    var isTablet = false;
                    const userAgent = navigator.userAgent;

                    if (
                        userAgent.match(/Tablet/i) ||
                        userAgent.match(/iPad/i) ||
                        userAgent.match(/Kindle/i) ||
                        userAgent.match(/Playbook/i) ||
                        userAgent.match(/Nexus/i) ||
                        userAgent.match(/Xoom/i) ||
                        userAgent.match(/silk/i) ||
                        userAgent.match(/SM-N900T/i) || // Samsung Note 3
                        userAgent.match(/GT-N7100/i) || // Samsung Note 2
                        userAgent.match(/SAMSUNG-717/i) || // Samsung Note
                        userAgent.match(/SM-T/i) ||       // Samsung Tab 4
                        userAgent.match(/SM-X/i)          // Samsung Tab
                    ) {
                        isTablet = true;
                    }

                    return isTablet;
                }

            })();		
            microsoftTeams.appInitialization.notifySuccess();
    	</script>
	</head>		
</html>
