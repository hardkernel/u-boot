#include <common.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/io.h>
#include <asm/arch/mailbox.h>
#include <amlogic/aml_led.h>

#define LED_DEFAULT_PWM_FREQ 100000
#define FIN_FREQ (24 * 1000)
#define DUTY_MAX 1024


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


static void __led_blink (led_id_t mask, int count)
{
	struct led_timer_strc{
		unsigned int expires;
		unsigned int expires_count;
		unsigned int led_mode;
	} led_val;

	led_val.led_mode = 0;
	lwm_set_suspend(led_val.led_mode, RECOVERY_MODE);
	led_val.expires = 1000*1000; //1000ms
	led_val.expires_count = count;
	if (send_usr_data(SCPI_CL_LED_TIMER,(unsigned int *)&led_val,sizeof(led_val)))
		printf("send_led_timer_data send error!...\n");
}

void __led_toggle (led_id_t mask)
{
	__led_blink(mask, -1);
}

void __led_set (led_id_t mask, int state)
{
	__led_blink(mask, 0);
	if (state == STATUS_LED_ON)
		pled_set_brightness(DUTY_MAX);
	else
		pled_set_brightness(0);
}

void __led_init (led_id_t mask, int state)
{
	pled_mux_to_pwm();
	__led_set(mask, state);
}


