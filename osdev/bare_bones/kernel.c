#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// #if defined (__linux__)
// #error "You are not using a cross-compiler"
// #endif

// #if defined (__i386__)
// #error "It is not compile with i386 platform"
// #endif


enum vga_color
{
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GRAY = 7,
    VGA_COLOR_DARK_GRAY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15
};


static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg)
{
    return fg | bg << 4;
}


static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
    return (uint16_t) uc | (uint16_t) color << 8;
}


size_t strlen(const char *str)
{
    size_t size = 0;
    while (*str != '\0')
    {
        ++size;
        ++str;
    }
    return size;
}


static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;


size_t terminal_row;
size_t terminal_col;
uint8_t terminal_color;
uint16_t *terminal_buffer;


void terminal_initilize()
{
    terminal_row = 0;
    terminal_col = 0;
    terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GRAY, VGA_COLOR_BLACK);
    terminal_buffer = (uint16_t*)0xb8000;
    size_t index;

    for (size_t y = 0; y < VGA_HEIGHT; ++y)
    {
        for (size_t x = 0; x < VGA_WIDTH; ++x)
        {
            index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}


void terminal_set_color(uint8_t color)
{
    terminal_color = color;
}


void terminal_put_at(char c, uint8_t color, size_t x, size_t y)
{
    const size_t index = y * VGA_WIDTH + x;
    terminal_buffer[index] = vga_entry(c, color);
}


void terminal_put_char(char c)
{
    terminal_put_at(c, terminal_color, terminal_col, terminal_row);
    if (++terminal_col == VGA_WIDTH)
    {
        terminal_col = 0;
        if (++terminal_row == VGA_HEIGHT)
            terminal_row = 0;
    }
}


void terminal_write(const char *data, size_t size)
{
    for (size_t i = 0; i < size; ++i)
        terminal_put_char(data[i]);
}


void terminal_write_str(const char *data)
{
    terminal_write(data, strlen(data));
}


void kernel_main()
{
    terminal_initilize();
    terminal_write_str("Hello world\n");
}
