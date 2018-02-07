	var g_windowReference = null;

	function menu_SelectRange() {
         if (CrossYN()) {
            var szUrl = "/admin/ezWebFolder/targetSelect.do";        		  
            var _MSIE = 'MSIE';
            var useragentstr = navigator.userAgent;
            
            if (useragentstr.indexOf(_MSIE) != -1) {	            	
                var szParam = "dialogHeight:705px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 705);
                var rv = window.showModalDialog(szUrl, document.getElementById("RangeXMLStr").value, szParam);
                
                if (rv[0] == "OK") {
                    document.getElementById("RangeXMLStr").value = rv[1];
                } 
                else if (rv[0] == "NO") {
                    document.getElementById("RangeXMLStr").value = "";
                }
            } 
            else {	            	
                if ((g_windowReference == null) || (g_windowReference.closed == true)) {
                    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
                        var feature = GetOpenPosition(560, 730);
                        g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
                    } 
                    else {
                        var feature = GetOpenPosition(730, 700);
                        g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
                    }
                }
                
                g_windowReference.focus();
            }
        } 
        else {
            menu_SelectRange_IE();
        } 
    }
	
	function menu_SelectRange_IE() {		 
        var szUrl = "/admin/ezWebFolder/targetSelect.do"; 
        
        if ((g_windowReference == null) || (g_windowReference.closed == true)) {
            if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
                var feature = GetOpenPosition(560, 630);
                g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
            } 
            else {
                var feature = GetOpenPosition(560, 700);
                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
            }
        }
        
        g_windowReference.focus();
    }
	
	function GetRangeValue() {
        return document.getElementById("RangeXMLStr").value;
    }
	
    function updateParent(_element, _value, _Type) {
        var elementRef = document.getElementsByName(_element);

        if (elementRef.length > 0) {
            switch (_Type) {
                case "selectedIndex":
                    elementRef[0].selectedIndex = _value;
                    break;
                case "value":
                    elementRef[0].value = _value;
                    break;
            }
        }
    }
    
    function updateTarget(listOfTarget) {	    	    	
    	var newTargetDiv = document.getElementById("newTargetDiv");
    	newTargetDiv.innerHTML = listOfTarget;
    	newTargetDiv.setAttribute("title", listOfTarget);
    	newTargetDiv.style.display = "";	    	
    }
    
    function closeWindow() {
        if ((g_windowReference != null) && (g_windowReference.closed == false)) {
            g_windowReference.close();
            g_windowReference = null;
        }
    }