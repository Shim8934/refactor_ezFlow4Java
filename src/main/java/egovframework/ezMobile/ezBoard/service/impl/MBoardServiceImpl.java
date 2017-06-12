package egovframework.ezMobile.ezBoard.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezMobile.ezBoard.service.MBoardService;

@Service("MBoardService")
public class MBoardServiceImpl implements MBoardService {

	@Resource(name = "MBoardDAO")
	private MBoardDAO mBoardDAO;
}
