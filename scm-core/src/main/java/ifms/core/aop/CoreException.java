package ifms.core.aop;

public class CoreException extends RuntimeException  {

    private static final long serialVersionUID = 1L;

    // 기본 생성자
    public CoreException() {
        super();
    }

    // 메시지를 받을 수 있는 생성자
    public CoreException(String message) {
        super(message);
    }

}
