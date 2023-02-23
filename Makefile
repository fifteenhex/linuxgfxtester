all: buildroot

.PHONY: buildroot run_x86-64

EXTERNALS="../br2directfb2 ../br2qemu"

buildroot:
	$(MAKE) -C buildroot BR2_EXTERNAL=$(EXTERNALS)

buildroot-menuconfig:
	$(MAKE) -C buildroot BR2_EXTERNAL=$(EXTERNALS) menuconfig

#QEMU_BIN=-./buildroot/output/host/bin/qemu-system-x86_64
QEMU_BIN=-qemu-system-x86_64
run_x86-64:
	$(QEMU_BIN) \
		-machine q35 \
		-m 1G \
		-vga virtio \
		-kernel ./buildroot/output/images/bzImage
