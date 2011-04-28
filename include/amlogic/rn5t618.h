
#ifndef __RN5T618_H__
#define __RN5T618_H__

int rn5t618_write   (int add, uint8_t val);
int rn5t618_writes  (int add, uint8_t *buff, int len);
int rn5t618_read    (int add, uint8_t *val);
int rn5t618_reads   (int add, uint8_t *buff, int len);
int rn5t618_set_bits(int add, uint8_t bits, uint8_t mask);

int rn5t618_set_gpio(int gpio, int output);
int rn5t618_get_gpio(int gpio, int *val);
int rn5t618_set_usb_current_limit(int limit);

int rn5t618_init(void);
int rn5t618_set_charging_current(int current);
int rn5t618_get_charging_percent();
int rn5t618_charger_online(void);
void rn5t618_power_off();
#endif      /* __RN5T618_H__ */
