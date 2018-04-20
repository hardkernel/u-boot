#ifndef ANDROID_LOG_H
#define ANDROID_LOG_H

#if (defined CC_COMPILE_IN_ANDROID)
    #include <utils/Log.h>
#elif (defined CC_COMPILE_IN_PC)
    #include <stdio.h>
    #include <stdarg.h>

    extern int ioctl(int handle, int cmd, void *data);
#elif (defined CC_COMPILE_IN_UBOOT)
#endif

#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_UBOOT)

    #define INI_LOG_UNKNOWN             (0)
    #define INI_LOG_DEFAULT             (1)
    #define INI_LOG_VERBOSE             (2)
    #define INI_LOG_DEBUG               (3)
    #define INI_LOG_INFO                (4)
    #define INI_LOG_WARN                (5)
    #define INI_LOG_ERROR               (6)
    #define INI_LOG_FATAL               (7)
    #define INI_LOG_SILENT              (8)

#ifdef __cplusplus
extern "C" {
#endif

    int ini_set_log_level(int log_level);
    int ini_get_log_level(void);

#ifdef __cplusplus
}
#endif

    #if LOG_NDEBUG == 1
        #define ALOGD(...)
        #define ALOGE(...)
        #define ALOGI(...)
        #define ALOGW(...)
    #else

        #define __ini_log_print(prio, tag, fmt, args...)   \
                if (prio >= ini_get_log_level()) {    \
                    if (prio == INI_LOG_DEBUG) {    \
                        printf("D/    %s:    ", tag);    \
                    } else if (prio == INI_LOG_ERROR) {    \
                        printf("E/    %s:    ", tag);    \
                    } else if (prio == INI_LOG_INFO) {    \
                        printf("I/    %s:    ", tag);    \
                    } else if (prio == INI_LOG_WARN) {    \
                        printf("W/    %s:    ", tag);    \
                    } else {    \
                        printf("V/    %s:    ", tag);    \
                    }    \
                    printf(fmt, ##args);    \
                    printf("\n");    \
                }

        #define ALOGD(...) __ini_log_print(INI_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
        #define ALOGE(...) __ini_log_print(INI_LOG_ERROR, LOG_TAG, __VA_ARGS__)
        #define ALOGI(...) __ini_log_print(INI_LOG_INFO, LOG_TAG, __VA_ARGS__)
        #define ALOGW(...) __ini_log_print(INI_LOG_WARN, LOG_TAG, __VA_ARGS__)
    #endif
#endif

#endif //ANDROID_LOG_H
