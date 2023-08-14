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
		-device virtio-serial,max_ports=1 \
		-chardev socket,id=testqemu_console,path=./testqemu_console,server=yes,wait=no \
		-device virtconsole,chardev=testqemu_console,name=test_console \
		-kernel ./buildroot/output/images/bzImage \
		-append "console=hvc0 quiet"

vnc2mpg.c:
	wget "https://raw.githubusercontent.com/LibVNC/libvncserver/master/examples/client/vnc2mpg.c"

vnc2mpg: vnc2mpg.c
	gcc -o $@ $< `PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig/ pkg-config --cflags --libs libavcodec libavutil libavformat libswscale libvncclient`

recordvnc: vnc2mpg
	./vnc2mpg -o vncrecording.mp4

test-chocolatedoom:
	$(MAKE) run_x86-64 &
