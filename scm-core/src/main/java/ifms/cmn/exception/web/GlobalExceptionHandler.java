package ifms.cmn.exception.web;                                  

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;

//@Controller
//@ControllerAdvice               
public class GlobalExceptionHandler {                                                                                                             
                                                                                                                                                 
    private Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
        
    //@ExceptionHandler( Exception.class )
    public ModelAndView handleException(final Exception e) throws Exception {
    	logger.error("GlobalExceptionHandler => handleException error " + e.getMessage());
		if (e instanceof MaxUploadSizeExceededException) {
			logger.error("MaxUploadSizeExceededException 확인");
			logger.error(e.getClass().getName());
			logger.error(e.getMessage());
		}
    	
		//TODO : [hsh] 유형별 에러페이지 제작	
    	ModelAndView modelAndView = new ModelAndView("/cmn/error/errorPage");
		modelAndView.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);		
    	return modelAndView;
    }    
}     



