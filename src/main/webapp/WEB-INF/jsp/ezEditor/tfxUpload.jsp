<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>XFE UPLOAD</title>
		<script type="text/javascript">
			window.onload = function() {
				
				var strContentType = document.getElementById("divContentType").innerHTML;
				var strImagePath = document.getElementById("divImagePath").innerHTML;
				
				if (strImagePath != undefined && strImagePath != "") {
					
					var strLocation = "<c:out value='${sUploadedPath}'/>";
					
					if(strLocation) {						
						
						/**
						 * http://, https:// 프로토콜 체크 후 없을 경우 절대 경로.
						 * 절대 경로 일 경우 앞에 / 가 여러개 들어 갈 경우 처리.  
						 */
						if(strLocation.indexOf('http://') < 0 && strLocation.indexOf('https://') < 0) {
							
							if(/^[\/]{2,}/img.test(strLocation)) {
								strLocation = strLocation.replace(/^[\/]{2,}/img, function() {
									return '/';
								});
							}								
						}
	
						if (strContentType == "flash") {						
                            //parent.insertFlash.setFlash(strLocation);

                            if(parent.insertFlash) {
                                parent.insertFlash.setFlash(strLocation);
                            } else {
                                parent.parent.insertFlash.setFlash(strLocation);
                            }

                        } else if (strContentType == "image") {
                            //parent.insertImage.setImage(strLocation);

                            if(parent.insertImage) {
                                parent.insertImage.setImage(strLocation);
                            } else {
                                parent.parent.insertImage.setImage(strLocation);
                            }

                        }
						
					} else {
						
					}
					
				} else {
					alert("ERROR");
				}
		
			};
		</script>
	</head>
	<body>
		<div id="divContentType"><c:out value="${sContentType}"/></div>
		<div id="divImagePath"><c:out value="${sUploadedPath}"/></div>
	</body>
</html>
