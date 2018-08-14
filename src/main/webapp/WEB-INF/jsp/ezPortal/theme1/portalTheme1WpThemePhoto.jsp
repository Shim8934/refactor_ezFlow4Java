<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link href="/css/jquery.theme01scrollbar.css" rel="stylesheet" type="text/css">
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		
		<!-- custom scrollbars plugin -->
		<script type="text/javascript">
			window.onload = function () {
		    	try { top.onresize() } catch (e) { }
			}
			
			function ItemRead_onclick(obj) {
				var ShowAdjacent = "";
			    var pheight = window.screen.availHeight;
			    var pwidth = window.screen.availWidth;
			    var pTop = (pheight - 780) / 3;
			    var pLeft = (pwidth - 765) / 2;

			    window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + GetAttribute(obj,"DATA2") + "&boardID=" + GetAttribute(obj,"DATA1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
			}
		</script>
	</head>	
	<body>
		<div class="photobox" style="height:226px;">
     		<p class="title"><spring:message code='main.t00030' /></p>
			${strHTML}	
		</div>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.theme01Scrollbar.concat.min.js')}"></script>
		<script type="text/javascript">
			(function ($) {
	        	$(window).load(function () {
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
    			});
			})(jQuery); 
		</script>
	</body>	
</html>