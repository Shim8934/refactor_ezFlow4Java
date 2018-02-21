<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/js/jsTree/src/themes/default/style.css" />
<title>Insert title here</title>
<%-- <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css"> --%>
<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
<!-- <link rel="stylesheet" href="/jstree/themes/proton/style.min.css"> -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>

<script type="text/javascript">
	window.onload = function () {
		folderList();
		
	};
	function folderList () {
		$.ajax ({
			type:"POST",
			url : "/ezWebFolder/folderList.do",
			data : { 
				"folderType" : 'C'
				},
			dataType: "JSON",
			success : function (data) {
				$('#html1').jstree({
					'core' : {
						'data' : data.folderList.folderList
					},
					'themes' : {
						'responsive' : true
					},
					"types" : {
						"default": {
							"icon" :"/images/OrganTree_cross/fldr.gif" 
						}
					},
					'plugins': ["wholerow","types","json_data","core","conditionalselect"]
				})
				
			},
			error : function(error) {
				alert("<spring:message code='ezWebFolder.t134' />" + error);
			}
		});
		$('#html1').on("changed.jstree", function (e, data) {
		   console.log("The selected nodes are:");
		   alert(data.selected);
		});
	}
	
	
	
// 	$(function() {
// // 		$.ajax({
// // 			"url" : 
			
			
			
// 			$('#html1').jstree({
	
// 				'plugins': ["wholerow","types","json_data"],
				 
	
// 				'themes' : {
				
// 					'responsive' : true
// 				},
// 				"types" : {
// 					"default": {
// 						"icon" :"/images/OrganTree_cross/fldr.gif" 
// 					}
// 				}
// 			}).bind("select_node.jstree", function (e, data) { alert(data.rslt.obj.data("id")); });
			
// 		})
		
// // 		$('#html1 li').addClass('class',);
	
// 	});




			
// 		})
// 		 .bind("__ready.jstree", function (event, data) {
// 	            $("#html1").jstree("hide_dots");
// 	            $("#html1").jstree("hide_icons");
// 	        });
	
	
	
	
</script>
</head>
<body>

	<div id="html1">
		<ul>
<!-- 			<li >Electronics -->
<!-- 				<ul> -->
<!-- 					<li>Mobile -->
<!-- 						<ul> -->
<!-- 							<li>Samsung</li> -->
<!-- 							<li >Apple</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 					<li> -->
<!-- 						<ul> -->
<!-- 							<li >Dell</li> -->
<!-- 							<li >Computer Peripherals -->
<!-- 								<ul> -->
<!-- 									<li >Printers</li> -->
<!-- 									<li >Monitor</li> -->
<!-- 								</ul> -->
<!-- 							</li> -->
<!-- 							<li >Keyboard</li> -->
<!-- 						</ul> -->
<!-- 					</li> -->
<!-- 				</ul> -->
<!-- 			</li> -->
		</ul>
	</div>
</body>
</html>