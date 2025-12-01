package ifms.core.i18n.message;

import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;

import ifms.core.i18n.service.MessageRepository;

import java.text.MessageFormat;
import java.util.Locale;

public class CombinedMessageSource extends AbstractMessageSource {

    private final MessageRepository messageRepository;
    private final MessageSource fallbackMessageSource; // EgovMessageSource

    public CombinedMessageSource(MessageRepository messageRepository, MessageSource fallbackMessageSource) {
        this.messageRepository = messageRepository;
        this.fallbackMessageSource = fallbackMessageSource;
    }

    @Override
    protected MessageFormat resolveCode(String code, Locale locale) {
        String lang = locale.getLanguage();
        return messageRepository.findMessage(code, lang)
                .map(MessageFormat::new)
                .orElseGet(() -> {
                    try {
                        String fallback = fallbackMessageSource.getMessage(code, null, locale);
                        return new MessageFormat(fallback, locale);
                    } catch (NoSuchMessageException e) {
                        return null;
                    }
                });
    }
    
    public MessageFormat getTooltip(String code, Locale locale) {
    	
    	String lang = locale.getLanguage();
    	return messageRepository.findTooltip(code, lang)
                .map(msg -> new MessageFormat(msg, locale))
                .orElseGet(() -> {
                    try {
                        String fallback = fallbackMessageSource.getMessage(code, null, locale);
                        return new MessageFormat(fallback, locale);
                    } catch (NoSuchMessageException e) {
                        return null;
                    }
                });
    }
}
