#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <hidapi/hidapi.h>

/* ================= DEVICE INFO (VID/PID) ================= */
#define VENDOR_ID  0x5131  //Change this if VID is different
#define PRODUCT_ID 0x2007  //Change this if PID is different
#define REPORT_SIZE 65
/* =============================================== */

/* ---------------- CPU TEMP ---------------- */

static int get_cpu_temp(void)
{
    FILE *fp;
    char buf[64];

    fp = popen(
        "sensors | awk '/Package id 0:/ {gsub(/[+°C]/, \"\", $4); print $4; exit}'",
        "r"
    );

    if (!fp) return 30;

    if (!fgets(buf, sizeof(buf), fp)) {
        pclose(fp);
        return 30;
    }

    pclose(fp);
    return atoi(buf);
}

/* ---------------- MAIN ---------------- */

int main(void)
{
    hid_device *dev;
    uint8_t buf[REPORT_SIZE];

    if (hid_init()) {
        fprintf(stderr, "hid_init failed\n");
        return 1;
    }

    dev = hid_open(VENDOR_ID, PRODUCT_ID, NULL);
    if (!dev) {
        fprintf(stderr, "Failed to open device %04x:%04x (try sudo)\n",
                VENDOR_ID, PRODUCT_ID);
        return 1;
    }

    printf("Ant Esports C612 CPU Temp Utility running...\n");

    while (1) {
        int temp = get_cpu_temp();

        if (temp < 0)  temp = 0;
        if (temp > 99) temp = 99;

        memset(buf, 0, sizeof(buf));

        /* ---- CRITICAL FORMAT ---- */
        buf[0] = 0x00;        // Report ID (MANDATORY)
        buf[1] = 0x01;        // Command (constant)
        buf[2] = temp & 0xFF; // CPU temperature (°C)
        /* ------------------------- */

        hid_write(dev, buf, REPORT_SIZE);

        printf("\rCPU Temp: %d°C   ", temp);
        fflush(stdout);

        sleep(1);  // keep-alive interval
    }

    hid_close(dev);
    hid_exit();
    return 0;
}

