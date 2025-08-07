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
                            doLogin(context.user.userPrincipalName);                 
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
            })();		
            microsoftTeams.appInitialization.notifySuccess();
    	</script>
	</head>		
</html>
