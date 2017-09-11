package egovframework.ezEKP.ezSystem.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.antlr.grammar.v3.ANTLRParser.exceptionGroup_return;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;

public interface EzSystemAdminService {
	public List<SysParamVO> getSysParam(int tenantID) throws Exception;
	public void updateSysParam(int tenantId, List<Map<String, String>> list, Locale locale) throws Exception;
	public List<ConnectionInfoVO> getLoginHist(int tenantID, String offset, int startPage, int maxItemPerPage, 
			String keyword, String keycode, String lang, String startDate, String endDate) throws Exception;
	public int getLoginHistCount(int tenantID, String offset, String keyword, String keycode, 
			String lang, String startDate, String endDate) throws Exception;
	public ArrayList<String> getServerInfo(int tenantID, String ip, String serverName, ArrayList<String> getServerList) throws Exception;
	public String getSysMonitorInfo(int tenantID, String ip, String serverName, String serverSN, String address) throws Exception;
}
