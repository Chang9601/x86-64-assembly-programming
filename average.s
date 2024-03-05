        .data
        .comm n,8

        .text
input_str:
        .string "n?"

format_specifier:
        .string "%ld"

sum_str:
        .string "총합=%ld\n"

avg_str:
        .string "평균=%ld\n"

.globl main
main:
        pushq %rbp
        movq %rsp, %rbp

        pushq %r12                      # 호출자 저장(caller-save) 레지스터(%rax, %rcx, %rdx, %rdi, %rsi, %rsp, %r8-%r11)는 함수 호출 간에 저장되지 않을 수 있다.
        pushq %r13                      # 피호출자 저장(callee-save) 레지스터( %rbx, %rbp, %r12-%r15)는 함수 호출 간에 저장된다.
                                        # 함수가 피호출자 저장 레지스터 중 어떤 것이라도 사용한다면 해당 값은 함수가 반환될 때 보존된다. 
                                        # 함수는 함수의 시작 부분에서 피호출자 저장 레지스터 값을 스택에 저장하고 반환 전에 복원해야 한다.
                                        # for 문의 scanf() 함수 호출로 인해 피호출자 저장 레지스터인 %r12 레지스터와 %r13 레지스터를 사용한다.
                                        #     
        subq $32, %rsp                  # 지역 변수를 위한 공간이 스택 영역 메모리에 할당될 수 있다.
                                        # n을 저장하는 지역 변수를 위한 공간을 스택 영역 메모리에 생성한다.
                                        # %rbp 레지스터, %r12 레지스터, %r13 레지스터와 지역 변수의 합은 32바이트.
                                        # 스택 사용 경우
                                        # 1. 반환 주소를 저장한다.
                                        # 2. 지역 변수를 저장한다.
                                        # 3. 레지스터가 부족할 때 레지스터를 저장한다(레지스터 스필.).
                                        # 4. 레지스터에 맞지 않는 경우 인수를 전달한다.
        movq $0, %r12                   # %r12 레지스터는 for 문의 첨자(i)를 저장한다.
        movq $0, %r13                   # %r13 레지스터는 합(sum)을 저장한다.
                                        #
                                        # 함수 종료 전에 이 명령어가 위치해야 하는데 그럴 경우 세그먼테이션 오류 발생. 왜?
                                        #
        movq $input_str, %rdi           # printf("n?");
        movq $0, %rax                   #
        call printf                     #
                                        #
        movq $format_specifier, %rdi    # scanf("%ld", &n);
        movq $n, %rsi                   #
        movq $0, %rax                   #
        call scanf                      #
                                        #
        movq $n, %rdi                   # &n에 저장된 값을 가져온다.
        movq (%rdi), %rdi               #
        movq %rdi, -32(%rbp)            # 스택의 저장 순서에 따라 가장 위에 지역 변수가 위치한다.
                                        #
for:                                    # for (i = 0; i < n; i++)
                                        # {
        cmpq %r12, -32(%rbp)            # 
        jle afterfor                    #
                                        #
        movq $format_specifier, %rdi    # scanf("%ld", &n)
        movq $n, %rsi                   #
        movq $0, %rax                   #
        call scanf                      #
                                        #
        movq $n, %rdi                   #
        movq (%rdi), %rdi               #
        addq %rdi, %r13                 # sum += n
                                        #
        addq $1, %r12                   # i++;
        jmp for                         # for 문의 시작으로 돌아간다.
                                        # }
afterfor:                               #
                                        #
        movq $sum_str, %rdi             # printf("SUM=%ld\n", sum);
        movq %r13, %rsi                 #
        movq $0, %rax                   #
        call printf                     #
                                        #
        movq $avg_str, %rdi             # printf("AVG=%ld\n", sum / n);
        movq %r13, %rax                 #
        idivq -32(%rbp)                 # idiviq S는 부호 있는 나누기로 %rdx:%rax, S로 나눈다. 몫은 %rax 레지스터, 나머지는 %rdx 레지스터에 저장된다.
        movq %rax, %rsi                 # TO-DO: 음수(floating point exception).
        movq $0, %rax                   #
        call printf                     #
                                        #
        addq $32, %rsp                  # 스택 영역 메모리에 할당된 공간을 해제한다.
        popq %r13                       # 스택은 후입선출 자료구조!
        popq %r12                       # 레지스터를 복원한다.
                                        #
        leave                           #
        ret                             # 반환 주소를 팝하고 호출자에게 제어를 반환한다.