#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if(head==NULL){
        return 1;
    }
    node* tortoise;
    node* hare;
    tortoise=hare=head;
    while(1){
      if(tortoise->next!=NULL){
          tortoise = tortoise->next;
          if(tortoise->next!=NULL){
              tortoise = tortoise->next;
          }else{
              return 0;
          }
      }else{
          return 0;
      }
      hare = hare->next;
      if(hare==tortoise){
          break;
      }
    }
    /* your code here */
    return 1;
}
