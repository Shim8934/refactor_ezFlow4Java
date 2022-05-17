package egovframework.ezMobile.ezTalk.service;

import java.util.List;

import egovframework.ezMobile.ezTalk.vo.MTalkNotification;

public interface MTalkService {

	List<MTalkNotification> getNotificationsAndDelete(Integer limit);

}
