#include <amlogic/aml_led.h>

#define LED_DEFAULT_PWM_FREQ 100000
#define FIN_FREQ (24 * 1000)
#define DUTY_MAX 1024

static struct aml_led pwm_led;
static unsigned int ledmode = -1;

static int pwm_calc(int duty, unsigned int pwm_freq, unsigned int *setting)
{
	unsigned int div;
	unsigned int pwm_cnt;
	unsigned int pwm_lo, pwm_hi;

	if (duty < 0)
		duty = 0;
	else if (duty > DUTY_MAX)
		duty = DUTY_MAX;

	for (div = 0; div < 0x7f; div++) {
		pwm_cnt = FIN_FREQ * 1000 / (pwm_freq * (div + 1)) - 2;
		if (pwm_cnt <= 0xffff)
			break;
	}

	if (duty == 0) {
		pwm_hi = 0;
		pwm_lo = pwm_cnt;
	}
	else if (duty == DUTY_MAX) {
		pwm_hi = pwm_cnt;
		pwm_lo = 0;
	}
	else {
		pwm_hi = pwm_cnt * duty;
		pwm_hi /= DUTY_MAX;
		pwm_lo = pwm_cnt - pwm_hi;
	}

	setting[0] = div;
	setting[1] = pwm_lo;
	setting[2] = pwm_hi;
	return 0;
}

/*
static void pled_gpio_ctrl(int on)
{
	unsigned int value;

	value = readl(AO_RTI_PIN_MUX_REG);
	value &= ~(3<<19);
	writel(value, AO_RTI_PIN_MUX_REG);
	value = readl(AO_GPIO_O_EN_N);
	value &= ~((1<<11)|(1<<27));
#ifdef CONFIG_LED_PWM_INVERT
	on = !on;
#endif
	value |= (on<<27);
	//printf("on=%d, value=0x%x\n", on, value);
	writel(value, AO_GPIO_O_EN_N);
}
*/

static void pled_mux_to_pwm(void)
{
	unsigned int value;
	// GPIOAO_11 mux as PWM_AO_A
	value = readl(AO_RTI_PIN_MUX_REG);
	value |= (1<<19);
	value &= ~(1<<20);
	writel(value, AO_RTI_PIN_MUX_REG);
}

static void pled_set_brightness(int brightness)
{
	unsigned int value;
	unsigned int setting[3] = {0};

#ifdef CONFIG_LED_PWM_INVERT
	brightness = DUTY_MAX - brightness;
#endif
	pwm_calc(brightness, LED_DEFAULT_PWM_FREQ, &setting[0]);

	value = readl(AO_PWM_MISC_REG_AB);
	// clk div
	value &= ~(0x7f<<8);
	value |= (setting[0]<<8);
	//clk enable
	value |= 1<<15;
	writel(value, AO_PWM_MISC_REG_AB);
	// duty cycle
	writel((setting[2] << 16) | setting[1], AO_PWM_PWM_A);

	// enable PWM_AO_A
	value = readl(AO_PWM_MISC_REG_AB);
	value |= 0x3;
	writel(value, AO_PWM_MISC_REG_AB);
}

static struct coord breath_inflections[]= {
	{0, 0},
	{1000, 80},
	{2000, 256},
	{2500, 512},
	{3000, 1024},
	{3200, 1024},
	{4200, 512},
	{5200, 256},
	{7200, 80},
	{9200, 0},
	{9400, 0},
};

struct aml_led_config pled_config = {
	.off_brightness = 0,
	.on_brightness = DUTY_MAX,
	.flash_off_brightness = 0,
	.flash_off_time = 350,
	.flash_on_brightness = DUTY_MAX,
	.flash_on_time = 400,
	.breath_inflections = breath_inflections,
	.breath_inflections_num = 11,
	.set_brightness = pled_set_brightness,
};

/*
 * for suspend
 */
void pled_suspend_init(void)
{
	if (ledmode == -1)
		return;
	pled_mux_to_pwm();
	aml_led_init(&pwm_led, &pled_config);
	//if (lwm_get_suspend(ledmode) == SHUTDOWN_MODE)
		aml_led_event(&pwm_led, LED_EVENT_FLASH, 3);
	if (lwm_get_standby(ledmode) == LWM_ON)
		aml_led_event(&pwm_led, LED_EVENT_ON, 0);
	else if(lwm_get_standby(ledmode) == LWM_FLASH)
		aml_led_event(&pwm_led, LED_EVENT_FLASH, 0);
	else if(lwm_get_standby(ledmode) == LWM_BREATH)
		aml_led_event(&pwm_led, LED_EVENT_BREATH, 0);
	else
		aml_led_event(&pwm_led, LED_EVENT_OFF, 0);
}

void pled_suspend_timer_proc(void)
{
	if (ledmode == -1)
		return;
	aml_led_timer_proc(&pwm_led);
}

/*
 * for scp
 */
static void pled_scp_init(int mode)
{
	ledmode = mode;
	pled_mux_to_pwm();
}

static void pled_scp_timer_proc(int count)
{
	int mod = 2;

	if (lwm_get_suspend(ledmode) == RECOVERY_MODE)
		mod = 3;
	if (count%mod)
		pled_set_brightness(pled_config.flash_on_brightness);
	else
		pled_set_brightness(pled_config.flash_off_brightness);
}

struct scp_led pwm_scp_led = {
	.count = 0,
	.init = pled_scp_init,
	.timer_proc = pled_scp_timer_proc,
};
