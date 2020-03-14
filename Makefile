CROSS_COMPILE ?= riscv64-unknown-elf

# If users don't specify RISCV_PATH then assume that the tools will just be in
# their path.
RISCV_GCC     := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-gcc)
RISCV_GXX     := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-g++)
RISCV_OBJDUMP := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-objdump)
RISCV_OBJCOPY := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-objcopy)
RISCV_GDB     := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-gdb)
RISCV_AR      := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-ar)
RISCV_SIZE    := $(abspath $(RISCV_PATH)/bin/$(CROSS_COMPILE)-size)

SRCS := \
tensorflow/lite/experimental/micro/micro_error_reporter.cc tensorflow/lite/experimental/micro/micro_mutable_op_resolver.cc tensorflow/lite/experimental/micro/simple_tensor_allocator.cc tensorflow/lite/experimental/micro/debug_log.cc tensorflow/lite/experimental/micro/debug_log_numbers.cc tensorflow/lite/experimental/micro/micro_interpreter.cc tensorflow/lite/experimental/micro/kernels/depthwise_conv.cc tensorflow/lite/experimental/micro/kernels/softmax.cc tensorflow/lite/experimental/micro/kernels/all_ops_resolver.cc tensorflow/lite/experimental/micro/kernels/fully_connected.cc tensorflow/lite/c/c_api_internal.c tensorflow/lite/core/api/error_reporter.cc tensorflow/lite/core/api/flatbuffer_conversions.cc tensorflow/lite/core/api/op_resolver.cc tensorflow/lite/kernels/kernel_util.cc tensorflow/lite/kernels/internal/quantization_util.cc  tensorflow/lite/experimental/micro/kernels/fully_connected_test_wrapper.cc

OBJS := \
$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(SRCS)))

INCLUDES := \
-I. \
-I./third_party/gemmlowp \
-I./third_party/flatbuffers/include

CXXFLAGS += -O3 -DNDEBUG --std=c++11 -g -DTF_LITE_STATIC_MEMORY -march=rv32imac -mabi=ilp32 -mcmodel=medlow 
CCFLAGS += -march=rv32imac -mabi=ilp32 -mcmodel=medlow  

LDFLAGS += -lm

%.o: %.cc
	$(RISCV_GXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

%.o: %.c
	$(RISCV_GCC) $(CCFLAGS) $(INCLUDES) -c $< -o $@

fully_connected_test : $(OBJS)
	$(RISCV_AR) crs $@ $(OBJS) 

all: fully_connected_test

.PHONY : clean
clean :
	-rm $(OBJS)
	rm fully_connected_test
