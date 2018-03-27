<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<div class="blackBox" >
<div class="startButton">
 	<c:choose>
		<c:when test="${id eq vo.writerId }">
			<a href="#" onclick="start(${vo.ladderId})"><img src ='/images/ezLadder/start.png' width='50' height ='50'/></a><br>
		</c:when>
		<c:otherwise>
			<img src ='/images/ezLadder/start.png' width='50' height ='50'/><br>
		</c:otherwise>
	</c:choose>
 </div>
</div>

