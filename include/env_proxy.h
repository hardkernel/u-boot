#ifndef __ENV_PROXY_H
#define __ENV_PROXY_H

struct env_proxy {
	char **env_name_spec_cb;
	int (*env_init_cb)(void);
	int (*saveenv_cb)(void);
	void (*env_relocate_spec_cb)(void);
};

#endif
