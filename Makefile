all: buildroot

.PHONY: bootstrap buildroot run_x86-64

EXTERNALS="../br2qemu ../br2directfb2 ../br2games"
DEFCONFIG=../buildroot_defconfig

BR2OPTS=BR2_EXTERNAL=$(EXTERNALS) BR2_DEFCONFIG=$(DEFCONFIG)

bootstrap:
	cp buildroot_defconfig buildroot/.config
	$(MAKE) -C buildroot $(BR2OPTS) olddefconfig

buildroot:
	$(MAKE) -C buildroot $(BR2OPTS)

buildroot-download:
	$(MAKE) -C buildroot $(BR2OPTS) source

buildroot-menuconfig:
	$(MAKE) -C buildroot $(BR2OPTS) menuconfig

buildroot-savedefconfig:
	$(MAKE) -C buildroot $(BR2OPTS) savedefconfig

QEMU_BIN=-./buildroot/output/host/bin/qemu-system-x86_64
run_x86-64:
	$(QEMU_BIN) \
		-machine q35 \
		-m 1G \
		-vga virtio \
		-kernel ./buildroot/output/images/bzImage
