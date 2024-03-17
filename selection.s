        .text
        .globl selection

selection:                          # long selection(long order, long n, long *arr)
                                    # %rdi = order, %rsi = n, %rdx = arr
        pushq %rbp                  # %rcx = index, %r8 = i, %r9 = j
        movq %rsp, %rbp             #
                                    #
        movq $0, %r8                # i = 0;
                                    #
outer_for:                          # for (i = 0; i < n - 1; i++)
                                    # {
        cmpq %r8, %rsi              # TODO: n - 1
        jle end_outer_for           #
                                    #
        movq %r8, %rcx              #   index = i;
        movq %r8, %r9               #   j = i + 1
        addq $1, %r9                #
                                    #
inner_for:                          #
                                    #
        cmpq %r9, %rsi              #   for (j = i + 1; j < n; j++)
        jle end_inner_for           #   {
                                    #
        movq %r9, %r10              # &arr[j] // *(long *)((8 * j + (char *)arr))
        imulq $8, %r10              #
        addq %rdx, %r10             #
        movq (%r10), %r10           # arr[j]
                                    #
        movq %rcx, %r11             # &arr[index]
        imulq $8, %r11              #
        addq %rdx, %r11             #
        movq (%r11), %r11           # arr[index]
                                    #
        cmpq $1, %rdi               #      if (order == 1)
        jne end_if                  #      {
                                    #        
        cmpq %r10, %r11             #        if (arr[j] < arr[index])
        jle end_if_else             #        {
                                    #
        movq %r9, %rcx              #           index = j;
        jmp end_if_else             #        }
                                    #      }
end_if:                             #      else
                                    #      {   
        cmpq %r10, %r11             #        if (arr[j] > arr[index])
        jge end_if_else             #        {
                                    #
        movq %r9, %rcx              #           index = j;
        jmp end_if_else             #        }
                                    #      }
end_if_else:                        #
                                    #
        addq $1, %r9                #     j++;
        jmp inner_for               #
                                    #
end_inner_for:                      #
                                    #
        movq %rcx, %r10             # &arr[index]
        imulq $8, %r10              # 해당 메모리 주소에 값을 대입하기 때문에 포인터로 설정한다.
        addq %rdx, %r10             # 
                                    # 
        movq %r8, %r11              # &arr[i]
        imulq $8, %r11              # 해당 메모리 주소에 값을 대입하기 때문에 포인터로 설정한다.
        addq %rdx, %r11             #
                                    #
        movq (%r10), %r12           # arr[index]
        movq (%r11), %r13           # arr[i]
                                    #
        movq %r13, %r14             #      long temp = arr[i];
        movq %r12, (%r11)           #      arr[i] = arr[index];
        movq %r14, (%r10)           #      arr[index] = temp;
                                    #
        addq $1, %r8                #   }
        jmp outer_for               #  i++;
                                    # 
end_outer_for:                      # }
                                    #
        leave                       #
        ret                         #