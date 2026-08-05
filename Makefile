PACKAGE_ID := com.github.runcatkde.runcat
PACKAGE_DIR := package
BUILD_DIR := build
QMLLINT := $(or $(shell command -v qmllint6 2>/dev/null),$(shell command -v qmllint 2>/dev/null),/usr/lib/qt6/bin/qmllint)
QMLTESTRUNNER := $(or $(shell command -v qmltestrunner6 2>/dev/null),$(shell command -v qmltestrunner 2>/dev/null),/usr/lib/qt6/bin/qmltestrunner)

.PHONY: check test install uninstall reload run package clean

check:
	jq empty $(PACKAGE_DIR)/metadata.json
	xmllint --noout $(PACKAGE_DIR)/contents/config/main.xml
	find $(PACKAGE_DIR)/contents/images -name '*.svg' -exec xmllint --noout {} +
	$(QMLLINT) -I /usr/lib/qt6/qml \
		$(PACKAGE_DIR)/contents/ui/main.qml \
		$(PACKAGE_DIR)/contents/ui/Dashboard.qml \
		$(PACKAGE_DIR)/contents/ui/MetricGauge.qml \
		$(PACKAGE_DIR)/contents/ui/UsagePie.qml \
		$(PACKAGE_DIR)/contents/ui/NetworkRate.qml \
		$(PACKAGE_DIR)/contents/ui/NetworkStats.qml \
		$(PACKAGE_DIR)/contents/ui/config/ConfigBehavior.qml \
		$(PACKAGE_DIR)/contents/config/config.qml \
		tests/tst_animation.qml \
		tests/tst_runners.qml \
		tests/tst_sensors.qml

test:
	QT_QPA_PLATFORM=offscreen $(QMLTESTRUNNER) \
		-input tests -import /usr/lib/qt6/qml

install:
	@if kpackagetool6 --type Plasma/Applet --list | grep -Fxq $(PACKAGE_ID); then \
		kpackagetool6 --type Plasma/Applet --upgrade $(PACKAGE_DIR); \
	else \
		kpackagetool6 --type Plasma/Applet --install $(PACKAGE_DIR); \
	fi

uninstall:
	kpackagetool6 --type Plasma/Applet --remove $(PACKAGE_ID)

reload: install
	-kquitapp6 plasmashell
	kstart plasmashell

run: install
	plasmawindowed $(PACKAGE_ID)

package: check test
	mkdir -p $(BUILD_DIR)
	cd $(PACKAGE_DIR) && zip -FSqr ../$(BUILD_DIR)/$(PACKAGE_ID).plasmoid .

clean:
	rm -f $(BUILD_DIR)/$(PACKAGE_ID).plasmoid
