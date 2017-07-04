package egovframework.ezEKP.ezSystem.service;

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
	public List<ConnectionInfoVO> getLoginHist(int tenantID) throws Exception;
}
