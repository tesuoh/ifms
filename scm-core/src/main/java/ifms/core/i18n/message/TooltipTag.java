package ifms.core.i18n.message;

import java.text.MessageFormat;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DelegatingMessageSource;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.support.RequestContext;

public class TooltipTag extends TagSupport {

    private static final long serialVersionUID = 1L;

    private String code;

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public int doStartTag() throws JspException {
        try {
            WebApplicationContext ctx =
                WebApplicationContextUtils.getWebApplicationContext(
                    pageContext.getServletContext());

            if (ctx == null) {
                pageContext.getOut().print("ApplicationContext not found");
                return SKIP_BODY;
            }

            MessageSource messageSource = ctx.getBean("messageSource", MessageSource.class);

            if (messageSource instanceof DelegatingMessageSource) {
                MessageSource parentSource =
                    ((DelegatingMessageSource) messageSource).getParentMessageSource();
                if (parentSource != null) {
                    messageSource = parentSource;
                }
            }

            if (messageSource instanceof CombinedMessageSource) {
                CombinedMessageSource cms = (CombinedMessageSource) messageSource;

                RequestContext rc = new RequestContext((HttpServletRequest) pageContext.getRequest());
                Locale locale = rc.getLocale();

                // MessageFormat → String 변환
                MessageFormat tooltipFormat = cms.getTooltip(code, locale);
                String tooltipMessage = tooltipFormat != null
                        ? tooltipFormat.format(null)
                        : code;

                // JSP 출력
                pageContext.getOut().print(tooltipMessage);
            } else {
                pageContext.getOut().print("Tooltip message not available");
            }

        } catch (Exception e) {
            throw new JspException("Error in TooltipTag", e);
        }
        return SKIP_BODY;
    }
}