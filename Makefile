CC=gcc
CFLAGS=-static
DEBUG=gdb
SRC_S=average.s
EXECUTABLE=average.exe

# -static 플래그는 .text 섹션이 무작위 텍스트 주소에 로드될 수 있는 대신 미리 정의된 로딩 주소를 가지도록 한다.
# 또한, 컴파일러에게 위치 독립적 코드 또는 PIC를 생성하지 말라고 지시한다.
# Linux의 새로운 보안 기능 중 하나는 프로그램을 실행할 때마다 무작위 메모리 주소에 프로그램을 로드하여 프로그램 해킹을 어렵게 만든다. 
# -static 플래그는 어셈블리 프로그래밍을 더 쉽게 만들기 위해 어셈블리 프로그램에서 이 기능을 비활성화한다.
all: square average max selection

square: square.s
	$(CC) $(CFLAGS) -o square.exe square.s

average: average.s
	$(CC) $(CFLAGS) -o average.exe average.s

max: max.s max.c
	$(CC) $(CFLAGS) -o max.exe max.c max.s

selection: selection.s selection.c
	$(CC) $(CFLAGS) -o selection.exe selection.c selection.s

clean:
	rm -f *.exe