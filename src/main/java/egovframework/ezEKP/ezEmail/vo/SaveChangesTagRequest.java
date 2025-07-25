package egovframework.ezEKP.ezEmail.vo;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class SaveChangesTagRequest {
    @JsonProperty
    private String shareId;
    private List<String> mailPathList;
    private List<String> enableTagList;
    private List<String> disableTagList;

    public String getShareId() {
        return shareId;
    }

    public void setShareId(String shareId) {
        this.shareId = shareId;
    }

    public List<String> getMailPathList() {
        return mailPathList;
    }

    public void setMailPathList(List<String> mailPathList) {
        this.mailPathList = mailPathList;
    }

    public List<String> getEnableTagList() {
        return enableTagList;
    }

    public void setEnableTagList(List<String> enableTagList) {
        this.enableTagList = enableTagList;
    }

    public List<String> getDisableTagList() {
        return disableTagList;
    }

    public void setDisableTagList(List<String> disableTagList) {
        this.disableTagList = disableTagList;
    }

    @Override
    public String toString() {
        return "SaveChangesTagRequest{" +
                "shareId='" + shareId + '\'' +
                ", mailPathList=" + mailPathList +
                ", enableTagList=" + enableTagList +
                ", disableTagList=" + disableTagList +
                '}';
    }
}
