package egovframework.ezEKP.ezSystem.service;

import java.util.List;

import egovframework.ezEKP.ezSystem.vo.SysParamVO;

public interface EzSystemAdminService {
	public List<SysParamVO> getSysParam(int tenantID);
	public int updateSysParam(List<SysParamVO> sysParamVO);
}
