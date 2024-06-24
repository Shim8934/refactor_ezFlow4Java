package egovframework.ezEKP.ezPortal.service.impl;


import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPortalService")
public class EzPortalServiceImpl extends EgovAbstractServiceImpl implements EzPortalService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPortalServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	/**
	 *  통합검색 - 검색엔진 URL 만들기
	 *  w : 검색영역
	 *	q : 검색어
	 *	csq : 제목, 내용, 첨부에서 찾을 내용
	 *	outmax : 출력 갯수
	 *	pg : page 번호
	 *	view : 권한 aa|bb|cc 의 형태 생성
	 *	d1 : 검색범위(날짜)
	 *	dsort : 정렬
	 * */
	public String getTotalSearchURL(LoginVO userInfo, Map<String, Object> param) throws Exception {
		
		StringBuffer queryStr = new StringBuffer();
		String type = (String) param.get("type") != null ? (String) param.get("type") : "";
		String keyword = (String) param.get("keyword") != null ? (String) param.get("keyword") : "";
		String searchRange = (String) param.get("searchRange") != null ? (String) param.get("searchRange") : "";
		String startDate = (String) param.get("startDate") != null ? (String) param.get("startDate") : "";
		String endDate = (String) param.get("endDate") != null ? (String) param.get("endDate") : "";
		String automax = (String) param.get("automax") != null ? (String) param.get("automax") : "";
		String userID = userInfo.getId();
		String page = (String) param.get("page") != null ? (String) param.get("page") : "";
		int tenantID = (int) userInfo.getTenantId() ;
		String companyID = (String) userInfo.getCompanyID();

		logger.debug("companyID : " + companyID);
		
		// 검색 위치 필수값.
		if(type.equalsIgnoreCase("approval")) {
			queryStr.append("?w=approval");
		} else if (type.equalsIgnoreCase("board")) {
			queryStr.append("?w=board");
		}
		
		// base64 디코더를 사용하지 않으면 필수로 넣어야함.
		queryStr.append("&base64=n");
		
		// section test
		//queryStr.append("&section=title");
		
		// 한 페이지에 출력되는 리스트 갯수
		// default : 10
		if(StringUtils.isNotEmpty(automax)){
			queryStr.append("&outmax=").append(automax);
		}
		
		// 원하는 페이지 번호
		queryStr.append("&pg=").append(page);		
		
		// 날짜 정렬 11 내림차순, 10 오름차순
		queryStr.append("&dsort=11");		
		
		// 키워드는 필수값.
		queryStr.append("&q=");
		
		/**
		 * UTF-8 인코딩을 해서 넘겨줘야함.
		 * 1. title:제목, 2.content:내용, 3.attach:첨부, 4.name:작성자, 5.dept:부서
		 * */ 		
		keyword = URLEncoder.encode(keyword, "UTF-8");
		
		queryStr.append(keyword);
		logger.debug("searchRange : " + searchRange);
		// 범위 '전체'는 포함되지 않음.
		
		if(!searchRange.equalsIgnoreCase("ALL")) {
			StringBuffer csq = new StringBuffer();
			String range[] = searchRange.split("\\|");
			List<String> rangeList = new ArrayList<String>();

			for(int i=0; i<range.length; i++) {
				if(range[i].equalsIgnoreCase("TITLE")) {
					rangeList.add("{title:" + keyword + "}");
				} else if(range[i].equalsIgnoreCase("CONTENTS")) {
					rangeList.add("{contents:" + keyword + "}");
				} else if(range[i].equalsIgnoreCase("ATTACH")) {
					rangeList.add("{attach:" + keyword + "}");
				} else if(range[i].equalsIgnoreCase("WRITER")) {
					rangeList.add("{name:" + keyword + "}");
				}
			}
			
			csq.append("&csq=");
			csq.append("(");
			for(int i=0; i<rangeList.size(); i++) {
				if(i==0) {
					csq.append(rangeList.get(i));
				} else {
					csq.append(" ^[OR ");
					csq.append(rangeList.get(i));
				}
			}
			csq.append(")");
			//TENANT_ID, COMPANYID 설정
			csq.append(" ^[AND {tenant:").append(tenantID+"").append("}");
			
			if(type.equalsIgnoreCase("approval")) {
				csq.append(" ^[AND {company:").append(companyID).append("}");
			}
			
			queryStr.append(csq);
		} else {
			//TENANT_ID, COMPANYID 설정
			queryStr.append("&csq={tenant:").append(tenantID+"").append("}");
			
			if(type.equalsIgnoreCase("approval")) {
				queryStr.append(" ^[AND {company:").append(companyID).append("}");
			}
		}
		

		// 권한 체크
		if(queryStr.toString().contains("&csq=")) {
			queryStr.append(" ^[AND {view:"+userID+"}");
		} else {
			queryStr.append("&csq={view:"+userID+"}");
		}
		
		if(StringUtils.isNotEmpty(startDate) && StringUtils.isNotEmpty(endDate)) {
			
			String dateRange = "";
			
			startDate = startDate.replaceAll("-", "");
			endDate = endDate.replaceAll("-", "");
			
			dateRange = startDate + "~" + endDate;
			queryStr.append("&d1=");
			queryStr.append(dateRange);
		}
		
		logger.debug("queryStr : " + queryStr.toString());
		
		return queryStr.toString();
	}
	
	
	/**
	 * 통합검색 - 검색엔진 서버에 검색 결과 호출하기.
	 * */
	public Map<String, Object> callSearchServerForResult(String searchURL, String offset) throws Exception {
		
		Map<String, Object> ret = new HashMap<String, Object>();
		
		//접속하고자 하는 url.
		String totalSearchURL = config.getProperty("config.totalSearchURL");
		// 중간에 인코딩되지 않은 공백이 있기 때문에 강제 변환.
		String urlStr = totalSearchURL + searchURL.replaceAll(" ", "%20");
		logger.debug("urlStr : " + urlStr);
		URL url = new URL(urlStr);
		URLConnection conn = url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestProperty("content-type", "text/xml");
		
		StringBuffer sb = new StringBuffer();
		
		try (BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"))) {
	
			String inputLine;
			//StringBuffer sb = new StringBuffer();
			
			// 내용을 저장한다.
			while((inputLine = in.readLine()) != null) {
				sb.append(inputLine.trim());
			}
		}
		
		// List 데이터 변환
		int totcnt = getCntTotalSearchResult(sb.toString());
		List<Map<String, Object>> retList = converTotalSearchResult(sb.toString(), offset);
		
		ret.put("totcnt", totcnt);
		ret.put("list", retList);
		
		return ret;
	}
	
	/**
	 * 통합검색 - 리스트 총 갯수 확인
	 * */
	public int getCntTotalSearchResult(String searchResult) throws Exception {
	
		Document xmlDom = commonUtil.convertStringToDocument(searchResult);
		
		int cnt = Integer.parseInt(xmlDom.getElementsByTagName("totcnt").item(0).getTextContent());
		
		return cnt;
	}
	
	/**
	 * 통합검색 - xml 데이터 파싱
	 * */
	public List<Map<String, Object>> converTotalSearchResult(String searchResult, String offset) throws Exception {

		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		
		Document xmlDom = commonUtil.convertStringToDocument(searchResult);
		NodeList docList = xmlDom.getElementsByTagName("doc");
		//String totalCnt = xmlDom.getElementsByTagName("totcnt").item(0).getTextContent();
		
		//logger.debug("totalCnt : " + totalCnt);
		
		int dListLen = docList.getLength();
		
		for(int i=0; i<dListLen; i++){
			int childLen = docList.item(i).getChildNodes().getLength();
			NodeList childNodeList = docList.item(i).getChildNodes();
			Map<String, Object> map = new HashMap<String, Object>();
			
			for(int j=0; j<childLen; j++) {
				String key = childNodeList.item(j).getAttributes().getNamedItem("name").getTextContent().replaceAll("\\^", "").replaceAll(":","");
				String value = childNodeList.item(j).getFirstChild() != null ? childNodeList.item(j).getFirstChild().getNodeValue() : "";
				
				// WriteDate, StartDate, EndDate
				if (key.equalsIgnoreCase("WriteDate") || key.equalsIgnoreCase("StartDate") || key.equalsIgnoreCase("EndDate")) {
					if(value != null && !value.equalsIgnoreCase("")) {
						value = commonUtil.getDateStringInUTC(value.substring(0,16), offset, false);
						logger.debug("return value: " + value);
					}
				}
				// trim()으로 제거되지 않는 앞뒤 공백제거.
				// 2023-05-17 이사라 : NullPointerException 시큐어코딩
				value = StringUtils.isBlank(value) ? "" : value.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");
				map.put(key, value);
			}
			list.add(map);
		}
		
		//logger.debug("arrayList : " + list.toString());
		
		return list;
	}
	
	/**
	 *  통합검색 - 검색엔진 URL 만들기
	 *  w : 검색영역
	 *	q : 검색어
	 *	csq : 제목, 내용, 첨부에서 찾을 내용
	 *	outmax : 출력 갯수
	 *	pg : page 번호
	 *	view : 권한 aa|bb|cc 의 형태 생성
	 *	d1 : 검색범위(날짜)
	 *	dsort : 정렬
	 * */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject callSearchServerForResult2(LoginVO userInfo, Map<String, Object> param) throws Exception {
		String type = Optional.ofNullable(param.get("type")).map(Object::toString).orElse("");
		type = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(type));
		String keyword = Optional.ofNullable(param.get("keyword")).map(Object::toString).orElse("");
		keyword = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(keyword));
		String searchRange = Optional.ofNullable(param.get("searchRange")).map(Object::toString).orElse("");
		String startDate = Optional.ofNullable(param.get("startDate")).map(Object::toString).orElse("");
		String endDate = Optional.ofNullable(param.get("endDate")).map(Object::toString).orElse("");
		String automax = Optional.ofNullable(param.get("automax")).map(Object::toString).orElse("");
		String userID = userInfo.getId();
		String page = Optional.ofNullable(param.get("page")).map(Object::toString).orElse("");
		int tenantID = userInfo.getTenantId() ;
		String companyID = userInfo.getCompanyID();

		logger.debug("[callSearchServerForResult2 Params] type : " + type + ", keyword : " + keyword + 
				", searchRange : " + searchRange + ", startDate : " + startDate + ", endDate : " + endDate +
				", automax : " + automax + ", userID : " + userID + ", page : " + page + ", companyID : " + companyID);
		
		JSONObject json = new JSONObject();
		json.put("w", type);
		json.put("outmax", automax);
		json.put("page", page);
		json.put("dsort", "11");
		json.put("q", keyword);
		json.put("searchRange", !searchRange.equalsIgnoreCase("all") ? searchRange.toLowerCase() : "title|contents|attach|writer");
		json.put("view", userID);
		json.put("tenant", tenantID);
		json.put("company", companyID);
		
		if(StringUtils.isNotEmpty(startDate) && StringUtils.isNotEmpty(endDate)) {
			String dateRange = (startDate + "~" + endDate).replaceAll("-", "");
			json.put("d1", dateRange);
		}
		
		logger.debug("[JSON result] json = " + json.toJSONString());

		return json;
	}
	
	/** 2023-02-14 홍승비 - 통합검색엔진 XTEN 전용 검색어 생성 메서드 분리
	 *  통합검색 - 검색엔진 URL 만들기 (XTEN)
	 *  w : 검색영역 (TOTAL로 고정)
	 *	q : 검색어 (색인별 검색 사용하므로 *로 고정)
	 * 	section : 검색결과로 출력할 게시판 / 전자결재 컬렉션 (APPROVAL / BOARD / 미입력시 전체출력)
	 *	csq : 제목, 내용, 첨부에서 찾을 내용 (색인별 검색, 다중검색 가능)
	 *	outmax : 출력 갯수 (반환될 검색결과 수)
	 *	pg : page 번호
	 *	d1 : 기간검색범위 (YYYYMMDDHHmmss~YYYYMMDDHHmmss 형태)
	 *	dsort : 날짜 기준 정렬 (오름차순 정렬 : 10 / 내림차순 정렬 : 11)
	 * */
	public String getTotalSearchURL_XTEN(LoginVO userInfo, Map<String, Object> param) throws Exception {
		
		// logger.debug("param in getTotalSearchURL_XTEN  ::  " + param.toString());
		
		StringBuffer queryStr = new StringBuffer();
		String section = (String) param.get("type") != null ? (String) param.get("type") : "";
		String keyword = (String) param.get("keyword") != null ? (String) param.get("keyword") : "";
		String searchRange = (String) param.get("searchRange") != null ? (String) param.get("searchRange") : "";
		String startDate = (String) param.get("startDate") != null ? (String) param.get("startDate") : "";
		String endDate = (String) param.get("endDate") != null ? (String) param.get("endDate") : "";
		String automax = (String) param.get("automax") != null ? (String) param.get("automax") : "";
		String userID = userInfo.getId();
		String page = (String) param.get("page") != null ? (String) param.get("page") : "";
		int tenantID = (int) userInfo.getTenantId() ;
		String companyID = (String) userInfo.getCompanyID();
		
		// w : 검색영역 (TOTAL로 고정)
		queryStr.append("?w=TOTAL");
		
		// section : 검색 결과 컬렉션 (APPROVAL / BOARD / 미입력시 전체출력) 
		if (section.equalsIgnoreCase("approval")) {
			queryStr.append("&section=APPROVAL");
		} else if (section.equalsIgnoreCase("board")) {
			queryStr.append("&section=BOARD");
		}
		
		// base64 : base64 디코더를 사용하지 않는 경우 "n"값 필수
		queryStr.append("&base64=n");
		
		// outmax : 한 페이지에 출력되는 리스트 갯수 (반환될 검색결과 수) / default : 10
		if (StringUtils.isNotEmpty(automax)){
			queryStr.append("&outmax=").append(automax);
		}
		
		// pg : 페이지 번호
		queryStr.append("&pg=").append(page);		
		
		// dsort : 날짜 정렬 (10 : 오름차순 / 11 : 내림차순)
		queryStr.append("&dsort=11");		
		
		// q : 검색어(키워드)는 필수값
		queryStr.append("&q=*");
		
		// 단일 또는 다중 검색조건 (제목, 내용, 작성자, 첨부)
		// 검색범위가 ALL(모두)인 경우, 각 검색범위를 "|"로 이어서 전부 사용
		if (searchRange.equalsIgnoreCase("ALL")) {
			searchRange = "TITLE|CONTENTS|WRITER|ATTACH";
		}
		
		StringBuffer csq = new StringBuffer();
		String range[] = searchRange.split("\\|");
		List<String> rangeList = new ArrayList<String>();

		// 게시판, 전자결재 별로 일부 색인칼럼명이 다르기 때문에 전부 기재
		for (int i = 0; i < range.length; i++) {
			// 제목
			if (range[i].equalsIgnoreCase("TITLE")) {
					rangeList.add("{DOCTITLE:" + keyword + "}"); // APPROVAL
					rangeList.add("{TITLE:" + keyword + "}"); // BOARD
			}
			// 내용 (직접 파일 내부에 접근 -> 본문 내용을 인식하여 검색함)
			else if (range[i].equalsIgnoreCase("CONTENTS")) {
					rangeList.add("{CONTENTSPATH:" + keyword + "}"); // APPROVAL
					rangeList.add("{CONTENTLOCATION:" + keyword + "}"); // BOARD
			}
			// 작성자
			else if (range[i].equalsIgnoreCase("WRITER")) {
				rangeList.add("{WRITERNAME:" + keyword + "}");
			}
			// 첨부
			else if (range[i].equalsIgnoreCase("ATTACH")) {
				rangeList.add("{FILENAME:" + keyword + "}");
			}
		}
		
		csq.append("&csq=");
		
		// 검색어 조건을 각각 OR로 묶기 위해 괄호처리
		csq.append("(");
		
		for (int i = 0; i < rangeList.size(); i++) {
			if (i == 0) {
				csq.append(rangeList.get(i));
			} else {
				csq.append(" ^[OR ");
				csq.append(rangeList.get(i));
			}
		}
			
		csq.append(")");
		
		// TENANT_ID, COMPANYID 조건은 AND로 묶음
		csq.append(" ^[AND {TENANT_ID:").append(String.valueOf(tenantID)).append("}");
		csq.append(" ^[AND {COMPANY_ID:").append(companyID).append("}");
		
		queryStr.append(csq);
		
		// 통합검색 내부 쿼리로 접근가능한 사용자ID 권한을 체크 (게시판, 전자결재문서 접근 권한자 쿼리는 검색엔진측에 제공함)
		queryStr.append(" ^[AND {MEMBERID:" + userID + "}");
		
		// 검색기간 (작성일, 완료일) > DB 테이블과 동일하게 UTC 시간으로 검색
		if (StringUtils.isNotEmpty(startDate) && StringUtils.isNotEmpty(endDate)) {
			String dateRange = "";
			
			startDate = commonUtil.getDateStringInUTC(startDate + " 00:00:00", userInfo.getOffset(), true);
			endDate = commonUtil.getDateStringInUTC(endDate + " 23:59:59", userInfo.getOffset(), true);
			
			startDate = startDate.replaceAll("-", "").replaceAll(" ", "").replaceAll(":", "");
			endDate = endDate.replaceAll("-", "").replaceAll(" ", "").replaceAll(":", "");
			
			dateRange = startDate + "~" + endDate;
			queryStr.append("&d1=");
			queryStr.append(dateRange);
		}
		
		logger.debug("getTotalSearchURL_XTEN queryStr :: " + queryStr.toString());
		
		return queryStr.toString();
	}
	
}
