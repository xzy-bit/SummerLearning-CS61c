/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image *readData(char *filename)
{
	FILE *fp = fopen(filename, "rb");
	if (!fp)
	{
		printf("unable to open the file");
		return NULL;
	}

	/* read header */
	char P;
	int C;
	fscanf(fp, "%c%d", &P, &C);
	int row, col;
	fscanf(fp, "%d%d", &col, &row);
	int value;
	fscanf(fp, "%d", &value);

	Image *IMAGE = (Image *)malloc(sizeof(Image));
	IMAGE->image = (Color **)malloc(row * col * sizeof(Color *));
	IMAGE->rows = row;
	IMAGE->cols = col;
	int r, g, b;
	int num = 0;
	while (fscanf(fp, "%d%d%d", &r, &g, &b) != 0)
	{
		Color *color = (Color *)malloc(sizeof(Color));
		color->R = r;
		color->G = g;
		color->B = b;
		// printf("%d %d %d\n",r,g,b);
		*(IMAGE->image + num) = color;
		num++;
		if (num == row * col)
		{
			break;
		}
	}
	fclose(fp);
	return IMAGE;
	// YOUR CODE HERE
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	int num = 0;
	int cols = image->cols;
	int rows = image->rows;
	printf("%s", "P3\n");
	printf("%d %d\n", cols, rows);
	printf("%d\n", 255);
	for (num = 0; num < cols * rows; num++)
	{
		Color *color = *(image->image + num);
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
	// YOUR CODE HERE
}

// Frees an image
void freeImage(Image *image)
{
	// YOUR CODE HERE
	int num = 0;
	int cols = image->cols;
	int rows = image->rows;
	for (num = 0; num < cols * rows; num++)
	{
		free(*(image->image + num));
	}
	free(image->image);
	free(image);
}
