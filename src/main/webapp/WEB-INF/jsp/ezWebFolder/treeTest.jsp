<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%-- <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css"> --%>
<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css"
	type="text/css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<!-- date Picker -->

<script type="text/javascript">
	// 	$(function() {
	// 		$('#tree-container').jstree();
	// 		$('#jstree_demo_div').on("changed.jstree", function (e, data) {
	// 			  console.log(data.selected);
	// 			});
	// 	})
	$(function() {
		//$('#jstree_demo_div').jstree();
// 		$('#html1').jstree();

		$('#jstree_demo_div').on("changed.jstree", function(e, data) {
			console.log(data.selected);
		});

		$('button').on('click', function() {
			$('#jstree').jstree(true).select_node('child_node_1');
			$('#jstree').jstree('select_node', 'child_node_1');
			$.jstree.reference('#jstree').select_node('child_node_1');
		});
		$('#jstree').jstree({
			"plugins" : [ "wholerow", "checkbox" ]
		});
// 		$('#html1').jstree({
// 			"themes" : {
// 				"dots" : false
// 			},
// 			"core" : {
// 				"themes" : {
// 					"dots" : false
// 					'responsive' : false,
// 					'variant' : 'small',
// 					'stripes' : true
// 				}
// 			}
// 			"checkbox" : {
// 				"keep_selected_style" : false
// 			}
// 			"plugins" : [ "wholerow", "checkbox" ]
// 			 "plugins" : [ "themes", "html_data" ],
//                 "themes" : {
//                     "theme" : "default",
//                     "dots" : false,
//                     "icons" : false
//                 }
			$('#html1').jstree({
				  "core" : { // core options go here
				    "multiple" : false, // no multiselection
				    "themes" : {
				      "dots" : false // no connecting dots between dots
				    }
				  },
				  "plugins" : ["state"] // activate the state plugin on this instance
				});
                
			
// 		})
// 		 .bind("__ready.jstree", function (event, data) {
// 	            $("#html1").jstree("hide_dots");
// 	            $("#html1").jstree("hide_icons");
// 	        });
	});
</script>
</head>
<body>

	<div id="html1">
		<ul>
			<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Electronics
				<ul>
					<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Mobile
						<ul>
							<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Samsung</li>
							<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Apple</li>
						</ul>
					</li>
					<li>
						<ul>
							<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Dell</li>
							<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Computer Peripherals
								<ul>
									<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Printers</li>
									<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Monitor</li>
								</ul>
							</li>
							<li data-jstree='{"icon":"/images/OrganTree_cross/fldr.gif"}'>Keyboard</li>
						</ul>
					</li>
				</ul>
			</li>
		</ul>
	</div>
</body>
</html>