package egovframework.ezEKP.ezApprovalG.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGConnService;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzApprovalGConnController {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGConnController.class);
    
    @Autowired
    private CommonUtil commonUtil;
    
    @Autowired
    private EzApprovalGConnService ezApprovalGConnService;

}
