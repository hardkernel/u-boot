/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#include "ini_log.h"

#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_UBOOT)
static int gLogLevel = INI_LOG_DEFAULT;

int ini_set_log_level(int log_level) {
    int tmp_level = gLogLevel;
    gLogLevel = log_level;
    return tmp_level;
}

int ini_get_log_level(void) {
    return gLogLevel;
}
#endif
