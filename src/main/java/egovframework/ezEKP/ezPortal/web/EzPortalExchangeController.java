package egovframework.ezEKP.ezPortal.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPoll.service.EzPollService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezQuestion.service.EzQuestionService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPortalExchangeController extends EgovFileMngUtil {
private static final Logger logger = LoggerFactory.getLogger(EzPortalController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzPortalService")
	private EzPortalService ezPortalService;
	
	@Resource(name="EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@RequestMapping(value = "/ezExchange/exchangeRate.do")
	public String exchangeRateSection(Model model,@CookieValue("loginCookie") String loginCookie, HttpServletRequest req) throws Exception{
		logger.debug("exchangeRateSection started");
		
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		BufferedReader br = null;
		
		try{
		String authkey = "bEpJzTo23DwqD1TOODGOlf3QuXhDrsxe";
    	String searchdate = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
    	String data = "AP01";
    	String urlLink = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=";
    	String add = "";
    	
		add = add + "&searchdate=" + searchdate;
		add = add + "&data=" + data;
		add = urlLink + authkey + add;
		URL url = new URL(add);
		HttpURLConnection urlconnection = (HttpURLConnection) url.openConnection();
		urlconnection.setRequestMethod("GET");
		br = new BufferedReader(new InputStreamReader(urlconnection.getInputStream(), "UTF-8"));
		
		String result = "";
		String line;
		
		while((line = br.readLine())!=null){
			result = result+line+"\n";
		}
		
		logger.debug(result);
		JSONParser parser = new JSONParser();
		JSONArray json = (JSONArray) parser.parse(result);
		
		String status = "ok";
		
		if(status.equals("ok")){
			model.addAttribute(json);
		}else{
			return "error";
		}
		
		}catch(Exception e){
			e.printStackTrace();
		}
		logger.debug("exchangeRateSection end");
		
		return "json";
	}
}
