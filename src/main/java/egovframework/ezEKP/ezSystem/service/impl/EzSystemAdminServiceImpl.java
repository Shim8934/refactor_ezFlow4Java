package egovframework.ezEKP.ezSystem.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;

@Service("EzSystemAdminService")
public class EzSystemAdminServiceImpl implements EzSystemAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	
	@Resource(name="EzSystemAdminDAO")
	EzSystemAdminDAO ezSystemAdminDAO;
	
	
	@Override
	public List<SysParamVO> getSysParam(int tenantID) {
		return ezSystemAdminDAO.getSysParam(tenantID);
	}

	@Override
	public int updateSysParam(List<SysParamVO> sysParamVO) {
		ezSystemAdminDAO.updateSysParam(sysParamVO);
		return 0;
	}

}
