/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	int index = (row - 1) * image->cols + col - 1;
	Color *color = *(image->image + index);
	int B = color->B;
	Color *ret = (Color *)malloc(sizeof(Color));
	if ((B & 1) == 0)
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

// Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
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
			Color *color = evaluateOnePixel(image, i, j);
			int index = (i - 1) * col + j - 1;
			*(IMAGE->image + index) = color;
		}
	}
	return IMAGE;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	Image *image = readData(argv[1]);
	if (image == NULL)
	{
		return -1;
	}
	Image *hide = steganography(image);
	int num = 0;
	int cols = hide->cols;
	int rows = hide->rows;
	printf("%s", "P3\n");
	printf("%d %d\n", cols, rows);
	printf("%d\n", 255);
	for (num = 0; num < cols * rows; num++)
	{
		Color *color = *(hide->image + num);
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
	freeImage(hide);
	return 0;
}
