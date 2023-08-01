#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

#define MAX_SIZE 512
Image *readData(char *filename)
{
    FILE *fp = fopen(filename, "rb");
    if (!fp)
    {
        printf("unable to open the file");
        return NULL;
    }

    /**
     * read header
     */
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

void writeData(Image *image)
{
    int num = 0;
    FILE *fp = fopen("./studentOutputs/output.ppm", "w");
    int cols = image->cols;
    int rows = image->rows;
    fprintf(fp, "%s", "P3\n");
    fprintf(fp, "%d %d\n", cols, rows);
    fprintf(fp, "%d\n", 255);
    for (num = 0; num < cols * rows; num++)
    {
        Color *color = *(image->image + num);
        int r = color->R;
        int g = color->G;
        int b = color->B;
        if ((num + 1) % cols == 0)
        {
            fprintf(fp, "%3d %3d %3d\n", r, g, b);
        }
        else
        {
            fprintf(fp, "%3d %3d %3d   ", r, g, b);
        }
    }
    // YOUR CODE HERE
}

int main(int argc, char *args[])
{
    // char filename[35];
    // scanf("%s",filename);
    Image *IMAGE = readData("./testInputs/blinkerH.ppm");
    int num = 0;
    writeData(IMAGE);
    return 0;
}