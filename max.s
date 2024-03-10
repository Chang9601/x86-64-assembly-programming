        .text                 #
        .globl max            # long max(long n, long *arr)
                              # 
                              # %rdi = n
                              # %rsi = arr
max:                          # %rdx = i
        pushq %rbp            # %rax = max
        movq %rsp, %rbp       #
                              #
        movq $0, %rdx         # i = 0;
        movq (%rsi), %rax     # max = arr[0];
                              #
while:                        #
        cmpq %rdx, %rdi       # while (i < n)
        jle afterwhile        # {
                              #  
        movq %rdx, %rcx       #   long *num = &arr[i]; // *(long *)((8*i + (char *)arr))
        imulq $8, %rcx        # imulq S는 %rax를 S로 부호 있는 전체(full) 곱셈을 수행하며 결과는 %rdx:%rax에 저장된다.   
        addq %rsi, %rcx       #
                              #
        cmpq (%rcx), %rax     #   if (max < *num)
        jge afterif           #   {
        movq (%rcx), %rax     #     max = *num;
                              #   }
                              # 
afterif:                      #
        addq $1, %rdx         #   i++;
        jmp while             # }
                              #
afterwhile:                   #
        leave                 #
        ret                   #
