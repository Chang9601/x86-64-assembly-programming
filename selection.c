#include <stdio.h>

long arr[] = {12, 2, 4, -3, -1, 53, 4, 7, 0, -37, 8};
long n = (sizeof(arr)/sizeof(long));

extern void selection(long order, long n, long * arr);

void 
printArr(long n, long * arr) 
{
  for (int i = 0; i < n; i++)
  {
    printf("%ld ", arr[i]);
  }

  printf("\n");
}

int 
main(int argc, char *argv[])
{
  printf("오름차순 정렬 전: ");
  printArr(n, arr);
  selection(1, n, arr);
  printf("오름차순 정렬 후: ");
  printArr(n, arr);
  
  printf("내림차순 정렬 전: ");
  printArr(n, arr);
  selection(0, n, arr);
  printf("내림차순 정렬 후: ");
  printArr(n, arr);

  return 0;
}