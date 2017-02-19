<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<link href="/css/jquery.theme01scrollbar.css" rel="stylesheet" type="text/css">
		
		<!-- custom scrollbars plugin -->
		<script src="/js/jquery/jquery.theme01Scrollbar.concat.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			window.onload = function () {
	            try { top.onresize() } catch (e) { }
	            
	            $("#content_1").mCustomScrollbar({
 	                scrollInertia: 550,
 	                horizontalScroll: true,
 	                mouseWheelPixels: 116,
 	                scrollButtons: {
 	                    enable: true,
 	                    scrollType: "pixels",
 	                    scrollAmount: 116
 	                },
 	                callbacks: {
 	                    onScroll: function () { snapScrollbar(); }
 	                }
 	            });
 	            /* toggle buttons scroll type */
 	            var content = $("#content_1");
 	            $("a[rel='toggle-buttons-scroll-type']").html("<code>scrollType: \"" + content.data("scrollButtons_scrollType") + "\"</code>");
 	            $("a[rel='toggle-buttons-scroll-type']").click(function (e) {
 	                e.preventDefault();
 	                var scrollType;
 	                if (content.data("scrollButtons_scrollType") === "pixels") {
 	                    scrollType = "continuous";
 	                } else {
 	                    scrollType = "pixels";
 	                }
 	                content.data({ "scrollButtons_scrollType": scrollType }).mCustomScrollbar("update");
 	                $(this).html("<code>scrollType: \"" + content.data("scrollButtons_scrollType") + "\"</code>");
 	            });
 	            /* snap scrollbar fn */
 	            var snapTo = [];
 	            $("#content_1 .images_container img").each(function () {
 	                var $this = $(this), thisX = $this.position().left;
 	                snapTo.push(thisX);
 	            });
 	            function snapScrollbar() {
 	                var posX = $("#content_1 .mCSB_container").position().left, closestX = findClosest(Math.abs(posX), snapTo);
 	                $("#content_1").mCustomScrollbar("scrollTo", closestX, { scrollInertia: 350, callbacks: false });
 	            }
 	            function findClosest(num, arr) {
 	                var curr = arr[0];
 	                var diff = Math.abs(num - curr);
 	                for (var val = 0; val < arr.length; val++) {
 	                    var newdiff = Math.abs(num - arr[val]);
 	                    if (newdiff < diff) {
 	                        diff = newdiff;
 	                        curr = arr[val];
 	                    }
 	                }
 	                return curr;
 	            }
	            
	        }
		</script>
	</head>
	<body>
		${strHTML}
	</body>
</html>