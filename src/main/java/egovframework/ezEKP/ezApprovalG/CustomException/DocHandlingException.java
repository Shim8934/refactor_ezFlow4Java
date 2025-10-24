package egovframework.ezEKP.ezApprovalG.CustomException;

public class DocHandlingException extends Exception{
     public DocHandlingException() {
       //basic 생성자 
    }

    public DocHandlingException(String msg) {
        // 예외 메시지 전달하기 위한 생성자
        
        super(msg); // Exception 클래스 생성자 호출
    }
}
