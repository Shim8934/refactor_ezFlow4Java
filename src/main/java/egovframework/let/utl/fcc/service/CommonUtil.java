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

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.sim.service.EgovFileScrty;

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
@Component
public class CommonUtil {
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	public LoginVO userInfo(String loginCookie) throws Exception {	
		String decData = egovFileScrty.decryptAES(loginCookie);
		String userID = decData.split("///")[1];
		
		LoginVO login = new LoginVO();
		login.setId(userID);
		login.setDn("NOPASSWORD");

		LoginVO user = loginService.selectUser(login);

		user.setDeptPathCode(userID+ "," + ezOrganService.getDeptFullPath(user.getDeptID()));
		user.setLang(config.getProperty("config.primary"));
		
		return user;
	}
	
	public List<String> getUserIdAndPassword(String loginCookie) throws Exception {	
		String decData = egovFileScrty.decryptAES(loginCookie);
		List<String> returnObject = new ArrayList<String>();
		
		String userId = decData.split("///")[1];
		String pass = decData.split("///")[4];
		returnObject.add(userId);
		returnObject.add(pass);

		return returnObject;
	}
	
	public String getMultiData(String lang) throws Exception{
		if(!lang.equals(config.getProperty("config.primary"))){
			return "2";
		}else{
			return "";
		}
	}
		
	public Document convertStringToDocument(String xmlStr) {		
		String replaceData = xmlStr.trim().replaceFirst("^([\\W]+)<","<");
		
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();  
        DocumentBuilder builder;
        Document doc = null;
        
        try {  
            builder = factory.newDocumentBuilder();  
            doc = builder.parse(new InputSource(new StringReader(replaceData)));            
        } catch (Exception e) {}
        
        return doc;        
	}
	
	public Document convertRequestToDocument(HttpServletRequest request) {
		StringBuilder sb = new StringBuilder();		
        String readData = "";
        BufferedReader br;
        Document doc = null;
        
		try {
			br = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"));
			
			while ((readData = br.readLine()) != null ) {
	            sb.append(readData);
	        }
			doc = convertStringToDocument(sb.toString());
			
		} catch(Exception e){}
		
		return doc;		
	}
}


