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
	     
	     /** 2019.04.29 유은정 - 로그인시 WAF에서 ip를 ip주소:포트번호 형식으로 보내왔을때
	      * :포트번호 부분을 지우도록 추가
	      */
	     if (ip != null && ip.length() != 0) {
	    	 String[] ipColonSplit = ip.split(":");
	    	 int splitLength = ipColonSplit.length - 1; //콜론의 개수
	    	 
	    	 if (splitLength == 1) {
	    		 ip = ip.substring(0, ip.lastIndexOf(":"));
	    	 }
	     }
	     
	     return ip;
	}
	
	public static String getClientInfo(HttpServletRequest request, String type) {
	     String agent = request.getHeader("User-Agent");
	     agent = agent != null ? agent : "";
	    
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
             /* 모바일 (수정된 부분)  2018.04.26 문성업 로그인 기록 수정 - 리눅스 접속 추가  */
             else if (agent.indexOf("iPhone") > 0) 
            	 result = "iPhone";
             else if (agent.indexOf("iPod") > 0)
            	 result = "iPod";
             else if (agent.indexOf("iPad") > 0)
            	 result = "iPad";
             else if (agent.indexOf("Android") > 0)
            	 result = "Android";
             else if (agent.indexOf("BlackBerry") > 0)
            	 result = "BlackBerry";
             else if (agent.indexOf("Windows CE") > 0)
            	 result = "Windows CE";
             else if (agent.indexOf("IEMobile") > 0)
            	 result = "NOKIA";
             else if (agent.indexOf("Webos") > 0)
            	 result = "Webos";
             else if (agent.indexOf("Linux x86") > 0) //수정
            	 result = "Linux";
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
	             else
	            	 result = "Etc";
		     }else{
	             if (agent.indexOf("Edge") > 0)
	            	 result = "Edge";	        	 
	             else if (agent.indexOf("Chrome") > 0)
	            	 result = "Chrome";
	             else if (agent.indexOf("Safari") > 0)
	            	 result = "Safari";
	             else if (agent.indexOf("Firefox") > 0)
	            	 result = "Firefox";
	            /* (수정된 부분) 2018.04.16 문성업 로그인 기록 수정  */
	             else if (agent.indexOf("Presto") > 0)
	            	 result = "Opera";
	             else
	            	 result = "Etc";
	         }
	     }

	     return result;
	}	
}
