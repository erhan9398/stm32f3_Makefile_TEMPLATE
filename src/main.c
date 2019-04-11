#include "stm32f30x.h"
#include "stm32f30x_rcc.h"
#include "stm32f30x_gpio.h"

void Delay_us(uint32_t us);

int main(void)
{
  
  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOA, ENABLE);
  
  GPIO_InitTypeDef GPIO_InitStructure;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);


  while (1)
  {
    GPIO_SetBits(GPIOA, GPIO_Pin_7);
    Delay_ms(50);

    GPIO_ResetBits(GPIOA, GPIO_Pin_7);
    Delay_ms(50);
    

  }


}


void Delay_us(uint32_t us)
{
    us *= 12;

    /* fudge for function call overhead  */
    //us--;
    asm volatile("   mov r0, %[us]          \n\t"
                 "1: subs r0, #1            \n\t"
                 "   bhi 1b                 \n\t"
                 :
                 : [us] "r"(us)
                 : "r0");
}

void Delay_ms(uint32_t ms)
{
  Delay_us(1000 * ms);
}