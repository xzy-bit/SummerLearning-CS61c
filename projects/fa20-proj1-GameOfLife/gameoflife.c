/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
// Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
// and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	int rows = image->rows;
	int cols = image->cols;
	int flag = 0;
	int count = 0;
	for (size_t i = row - 1; i <= row + 1; i++)
	{
		for (size_t j = col - 1; j <= col + 1; j++)
		{
			if (i == row && j == col)
				continue;
			int x, y;
			if (i == 0)
			{
				x = rows;
			}
			else if (i == rows + 1)
			{
				x = 1;
			}
			else
			{
				x = i;
			}
			if (j == 0)
			{
				y = cols;
			}
			else if (j == cols + 1)
			{
				y = 1;
			}
			else
			{
				y = j;
			}
			int index = (x - 1) * image->cols + y - 1;
			Color *color = *(image->image + index);
			int B = color->B;
			if ((B & 1) == 1)
			{
				count++;
			}
		}
	}
	int index = (row - 1) * image->cols + col - 1;
	Color *color = *(image->image + index);
	int B = color->B;
	Color *ret = (Color *)malloc(sizeof(Color));
	if (B & 1)
	{
		flag = (rule >> (count + 9)) & 1;
	}
	else
	{
		flag = (rule >> (count)) & 1;
	}
	if (flag == 0)
	{
		ret->R = 0;
		ret->G = 0;
		ret->B = 0;
	}
	else
	{
		ret->R = 255;
		ret->G = 255;
		ret->B = 255;
	}
	return ret;
	// YOUR CODE HERE
}

// The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	int row = image->rows;
	int col = image->cols;
	Image *IMAGE = (Image *)malloc(sizeof(Image));
	IMAGE->image = (Color **)malloc(row * col * sizeof(Color *));
	IMAGE->rows = row;
	IMAGE->cols = col;
	int num = 0;
	for (size_t i = 1; i <= row; i++)
	{
		for (size_t j = 1; j <= col; j++)
		{
			Color *color = evaluateOneCell(image, i, j, rule);
			int index = (i - 1) * col + j - 1;
			*(IMAGE->image + index) = color;
		}
	}
	return IMAGE;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if (argc != 3)
	{
		printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.\n");
		return -1;
	}
	Image *image = readData(argv[1]);
	if (image == NULL)
	{
		return -1;
	}
	uint32_t rule = strtol(argv[2], NULL, 16);
	if (rule > 0x3ffff)
	{
		return -1;
	}
	Image *game = life(image, rule);
	int num = 0;
	int cols = game->cols;
	int rows = game->rows;
	printf("%s", "P3\n");
	printf("%d %d\n", cols, rows);
	printf("%d\n", 255);
	for (num = 0; num < cols * rows; num++)
	{
		Color *color = *(game->image + num);
		int r = color->R;
		int g = color->G;
		int b = color->B;
		if ((num + 1) % cols == 0)
		{
			printf("%3d %3d %3d\n", r, g, b);
		}
		else
		{
			printf("%3d %3d %3d   ", r, g, b);
		}
	}
	freeImage(image);
	freeImage(game);
}
