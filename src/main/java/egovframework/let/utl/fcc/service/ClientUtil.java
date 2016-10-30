/**
 * @Class Name  : EgovStringUtil.java
 * @Description : 문자열 데이터 처리 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.01.13     박정규          최초 생성
 *   2009.02.13     이삼섭          내용 추가
 *
 * @author 공통 서비스 개발팀 박정규
 * @since 2009. 01. 13
 * @version 1.0
 * @see
 *
 */

package egovframework.let.utl.fcc.service;

/*
 * Copyright 2001-2006 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the ";License&quot;);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS"; BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import javax.servlet.http.HttpServletRequest;

public class ClientUtil {
	
	public static String getClientIP(HttpServletRequest request) {
	     String ip = request.getHeader("X-FORWARDED-FOR");      

	     if(ip == null || ip.length() == 0) {
	         ip = request.getHeader("Proxy-Client-IP");
	     }
	     if(ip == null || ip.length() == 0) {
	         ip = request.getHeader("WL-Proxy-Client-IP");  // 웹로직
	     }
	     if(ip == null || ip.length() == 0) {
	         ip = request.getRemoteAddr();
	     }

	     return ip;
	}
	
	public static String getClientInfo(HttpServletRequest request, String type) {
	     String agent = request.getHeader("User-Agent");
	     String result = "";
	     
	     if(type.equals("agent")){
	    	 result = agent;
	     }else if(type.equals("os")){
	    	 if (agent.indexOf("Windows NT 10.0") > 0)
	    		 result = "Windows 10";	    	 
	    	 else if (agent.indexOf("Windows NT 6.3") > 0)
	    		 result = "Windows 8.1";
             else if (agent.indexOf("Windows NT 6.2") > 0)
            	 result = "Windows 8";
             else if (agent.indexOf("Windows NT 6.1") > 0)
            	 result = "Windows 7";
             else if (agent.indexOf("Windows NT 6.0") > 0)
            	 result = "Windows Vista";
             else if (agent.indexOf("Windows NT 5.2") > 0 || agent.indexOf("Windows NT 5.1") > 0)
            	 result = "Windows XP";
             else if (agent.indexOf("Mac OS") > 0)
            	 result = "Mac OS";
             else
            	 result = "Etc";
	     }else{
		     if (agent.indexOf("Trident") > 0){
	             if (agent.indexOf("Trident/4.0") > 0)
	            	 result = "IE8";
	             else if (agent.indexOf("Trident/5.0") > 0)
	            	 result = "IE9";
	             else if (agent.indexOf("Trident/6.0") > 0)
	            	 result = "IE10";
	             // Windows 10에서 Trident/8.0으로 전송되는 경우가 발생하여 추가함.  
	             else if (agent.indexOf("Trident/7.0") > 0 || agent.indexOf("Trident/8.0") > 0)
	            	 result = "IE11";
	         }else{
	             if (agent.indexOf("Edge") > 0)
	            	 result = "Edge";	        	 
	             else if (agent.indexOf("Chrome") > 0)
	            	 result = "Chrome";
	             else if (agent.indexOf("Safari") > 0)
	            	 result = "Safari";
	             else if (agent.indexOf("Firefox") > 0)
	            	 result = "Firefox";
	             else
	            	 result = "Etc";
	         }
	     }

	     return result;
	}	
}
