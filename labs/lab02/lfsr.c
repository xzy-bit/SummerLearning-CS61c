#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

uint16_t get_bit(uint16_t x, int n)
{
    return (x >> n) & 1;
}
void lfsr_calculate(uint16_t *reg)
{
    uint16_t zero = get_bit(*reg, 0);
    uint16_t sec = get_bit(*reg, 2);
    uint16_t trd = get_bit(*reg, 3);
    uint16_t fif = get_bit(*reg, 5);
    *reg = (*reg >> 1) | ((((zero ^ sec) ^ trd) ^ fif) << 15);
}
