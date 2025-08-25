package egovframework.ezEKP.ezPortal.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzPortalExchangeController extends EgovFileMngUtil {
	private static final Logger logger = LoggerFactory.getLogger(EzPortalController.class);

	@Resource(name = "EzPortalService")
	private EzPortalService ezPortalService;

	@Resource(name = "EzPortalAdminService")
	private EzPortalAdminService ezPortalAdminService;

	@Resource(name = "loginService")
	private LoginService loginService;

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@RequestMapping(value = "/ezExchange/exchangeRate.do")
	public String exchangeRateSection(Model model, @CookieValue("loginCookie") String loginCookie, HttpServletRequest req) throws Exception {
		logger.debug("exchangeRateSection started");

		BufferedReader br = null;

		try {
			String authkey = "bEpJzTo23DwqD1TOODGOlf3QuXhDrsxe";
			String searchdate = new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime());
			//String searchdate = "20181024";
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

			while ((line = br.readLine()) != null) {
				result = result + line + "\n";
			}

			logger.debug(result);
			JSONParser parser = new JSONParser();
			JSONArray json = (JSONArray) parser.parse(result);

			String status = "ok";

			if (status.equals("ok")) {
				model.addAttribute("json", json);
			} else {
				return "error";
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		logger.debug("exchangeRateSection end");

		return "/ezExchange/exchangeRate";
	}
}
