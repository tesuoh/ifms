package ifms.core.i18n.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;
import ifms.core.i18n.mapper.i18nMapper;
import ifms.core.i18n.service.MessageRepository;

import java.util.Optional;

@Repository
public class MessageRepositoryImpl implements MessageRepository {

    @Autowired
    private i18nMapper i18nMapper;

    @Override
    @Cacheable(value = "i18nMessages", key = "#code + '_' + #locale", unless = "#result == null")
    public Optional<String> findMessage(String code, String locale) {
        String msg = i18nMapper.getMessage(code, locale);
        return Optional.ofNullable(msg == null || msg.isEmpty() ? null : msg);
    }
    
    @Override
    @Cacheable(value = "i18nTooltips", key = "#code + '_' + #locale", unless = "#result == null")
    public Optional<String> findTooltip(String code, String locale) {
    	String msg = i18nMapper.getTooltip(code, locale);
    	return Optional.ofNullable(msg == null || msg.isEmpty() ? null : msg);
    }
}
