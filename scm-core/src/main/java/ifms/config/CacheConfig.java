package ifms.config;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.jcache.JCacheCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.cache.Cache;
import javax.cache.Caching;
import javax.cache.configuration.MutableConfiguration;
import javax.cache.expiry.CreatedExpiryPolicy;
import javax.cache.expiry.Duration;
import javax.cache.spi.CachingProvider;
import java.util.concurrent.TimeUnit;

@Configuration
@EnableCaching
public class CacheConfig {

	private final CachingProvider provider = Caching.getCachingProvider();
	private final javax.cache.CacheManager cacheManager = provider.getCacheManager();

	@Bean
	public CacheManager cacheManager() {
		return new JCacheCacheManager(cacheManager);
	}
	
	@Bean
	public Cache<String, Object> authrtCache() {
		
		MutableConfiguration<String, Object> configuration =
				new MutableConfiguration<String, Object>()
					.setTypes(String.class, Object.class)
					.setStoreByValue(false)
					.setExpiryPolicyFactory(CreatedExpiryPolicy.factoryOf(new Duration(TimeUnit.MINUTES, 10)));
					
		if (cacheManager.getCache("authrtUrlCache") != null) {
			cacheManager.destroyCache("authrtUrlCache");
		}
		return cacheManager.createCache("authrtUrlCache", configuration);
	}
	
	@Bean
	public Cache<String, String> authrtMenuCache() {
		
		MutableConfiguration<String, String> configuration =
				new MutableConfiguration<String, String>()
					.setTypes(String.class, String.class)
					.setStoreByValue(false)
					.setExpiryPolicyFactory(CreatedExpiryPolicy.factoryOf(new Duration(TimeUnit.MINUTES, 10)));
					
		if (cacheManager.getCache("authrtMenuCache") != null) {
			cacheManager.destroyCache("authrtMenuCache");
		}
		return cacheManager.createCache("authrtMenuCache", configuration);
	}
	
	@Bean
	public Cache<String, String> i18nMessagesCache() {
	    MutableConfiguration<String, String> configuration =
	            new MutableConfiguration<String, String>()
	                .setTypes(String.class, String.class)
	                .setStoreByValue(false)
	                .setExpiryPolicyFactory(CreatedExpiryPolicy.factoryOf(new Duration(TimeUnit.MINUTES, 30)));
	    

	    if (cacheManager.getCache("i18nMessages") != null) {
	        cacheManager.destroyCache("i18nMessages");
	    }
	    return cacheManager.createCache("i18nMessages", configuration);
	}
	
	@Bean
	public Cache<String, String> i18nTooltipsCache() {
	    MutableConfiguration<String, String> configuration =
	            new MutableConfiguration<String, String>()
	                .setTypes(String.class, String.class)
	                .setStoreByValue(false)
	                .setExpiryPolicyFactory(CreatedExpiryPolicy.factoryOf(new Duration(TimeUnit.MINUTES, 30)));
	    

	    if (cacheManager.getCache("i18nTooltips") != null) {
	        cacheManager.destroyCache("i18nTooltips");
	    }
	    return cacheManager.createCache("i18nTooltips", configuration);
	}
}
