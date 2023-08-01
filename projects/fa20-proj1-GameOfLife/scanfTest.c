#include <stdio.h>

int main(){
    char *str;
    int c1,c2,c3;
    int num1;
    FILE *fp = fopen("./testInputs/blinkerH.ppm","r");
    int num=0;
    
    /**
     * read header
    */
    char P;
    int C;
    fscanf(fp,"%c%d",&P,&C);
    printf("%c%d",P,C);
    int row,col;
    fscanf(fp,"%d%d",&row,&col);
    printf("%d%d",row,col);
    int value;
    fscanf(fp,"%d",&value);
    printf("%d",value);
    while (num1 = fscanf(fp,"%d%d%d",&c1,&c2,&c3)!=0)
    {
        printf("%d %d %d %d",num1,c1,c2,c3);
        if (num==row*col)
        {
            break;
        }
        num++;
    }
    return 0;
}