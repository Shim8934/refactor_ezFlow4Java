package egovframework.ezEKP.ezSystem.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.ezEKP.ezSystem.vo.SysParamVO;

public interface EzSystemAdminService {
	public List<SysParamVO> getSysParam(int tenantID) throws Exception;
	public void updateSysParam(int tenantId, List<Map<String, String>> list, Locale locale) throws Exception;
}
