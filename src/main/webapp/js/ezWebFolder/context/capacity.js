var capacity = (function() {
	var folderIdProvider = null;
	var loadEventListener = null;
	
	function getUsageSuffix(capacity) {
		var max = capacity.totalCapacity * 1024 * 1024;
		var usage = capacity.totalUsed / 1024;
		
		return " (" + kilobyteCalculation(usage) + " / " + kilobyteCalculation(max) + ")";
	}
	
	function kilobyteCalculation(kilobyte) {
		if (kilobyte >= 1024 * 1024) {
			return trimDecimal(kilobyte / (1024 * 1024)) + "GB";
		} else if (kilobyte >= 1024) {
			return trimDecimal(kilobyte / 1024) + "MB";
		} else {
			return trimDecimal(kilobyte) + "KB";
		}
	}
	
	function trimDecimal(number) {
		var str = number.toFixed(1);
		var decimalIndex = str.indexOf(".0");
	
		if (decimalIndex > -1) {
			return str.substr(0, decimalIndex);
		}
		
		return str;
	}
	
	return {
		setFolderIdProvider: function(provider) {
			folderIdProvider = provider;
		},
		setOnLoadEventListener: function(listener) {
			loadEventListener = listener;
		},
		load: function() {
			$.ajax({
				type: "POST",
				async: true,
				url: "/ezWebFolder/getCapacity.do",
				data: {
					folderId: folderIdProvider()
				},
				success: function(data) {
					var capacity = data.capacity;
					var usedRate = Math.min(capacity.usedRate, 100);
					var usageSuffix = getUsageSuffix(capacity);
					var progressColor = null;
					var progressElement = document.getElementById("capacity-bar");
					
					if (loadEventListener) {
						loadEventListener(capacity);
					}
					
					if (progressElement.style.width === usedRate + "%") {
						$("#capacity-percent").text(usedRate + "%" + usageSuffix);
						return;
					}
					
					switch (true) {
					case usedRate >= 80:
						progressColor = "#ff4040";
						break;
					case usedRate >= 70:
						progressColor = "#ffb600";
						break;
					default:
						progressColor = "#82b9f6";
					}
					
					$("#capacity-wrapper").css("display", "inline");
					$("#capacity-bar").css("backgroundColor", progressColor);
					$("#capacity-bar").stop().animate({
						width: usedRate + "%"
					}, {
						step: function(x) {
							$("#capacity-percent").text(Math.round(x) + "%" + usageSuffix);
						},
						duration: 500
					});
				}
			});
		}
	}
})();