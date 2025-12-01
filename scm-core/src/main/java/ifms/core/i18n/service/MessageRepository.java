package ifms.core.i18n.service;

import java.util.Optional;

public interface MessageRepository {
	Optional<String> findMessage(String code, String locale);
	
	Optional<String> findTooltip(String code, String locale);
}
