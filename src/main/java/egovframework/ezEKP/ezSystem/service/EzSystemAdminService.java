package egovframework.ezEKP.ezSystem.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.antlr.grammar.v3.ANTLRParser.exceptionGroup_return;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;

public interface EzSystemAdminService {
	public List<SysParamVO> getSysParam(int tenantID) throws Exception;
	public void updateSysParam(int tenantId, List<Map<String, String>> list, Locale locale) throws Exception;
	public List<ConnectionInfoVO> getLoginHist(int tenantID, String offset, int startPage, int maxItemPerPage, 
			String keyword, String keycode, String lang, String startDate, String endDate) throws Exception;
	public int getLoginHistCount(int tenantID, String offset, String keyword, String keycode, 
			String lang, String startDate, String endDate) throws Exception;
	public ArrayList<String> getServerInfo(String ip, String curServer, String serverName, ArrayList<String> getServerList) throws Exception;
	public String getSysMonitorInfo(String ip, String serverName, String address, boolean chkServer) throws Exception;
	public void deleteLoginHist(int keepLogPeriod, int tenantID) throws Exception;
	public void updateSystemIPAllow(String allowResult, int tenantID) throws Exception;
	public List<IPBandVO> getAllIPBand(int tenantID) throws Exception;
	public void insertIPBand(int tenantID, String ipAddress, String access, String explanation) throws Exception;
	public IPBandVO getSystemIPBand(String ipNo) throws Exception;
	public void updateIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception;
	public void deleteIPBand(String ipNo) throws Exception;
	public List<AccessIdVO> getAllAccessList(String primaryLang, int tenantID, String companyID) throws Exception;
	public List<AccessIdVO> getAllAccessListDept(String primaryLang, int tenantID, String companyID) throws Exception;
	public void deleteAccessId(String accessNo) throws Exception;
	public void insertAccessId(int tenantID, String cn) throws Exception;
}
