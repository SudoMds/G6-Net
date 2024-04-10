# How to Use
## 6to4 Manager / Socat TCP-UDP Forwarder

- Establish a 6to4 tunnel between Ubuntu servers.
- Create a Socat TCP/UDP forwarder through 6to4 with minimal CPU usage.
- Manage 6to4 interfaces and Socat services using the menu.

### Usage Instructions:

1. Transfer the `g6.sh` script to your server.
2. Run `bash g6.sh`.
3. Press `4` in the menu.
4. Enter your service name, server public IPv4, remote server public IPv4, and a local IPv6 address. For example:
   - ServerA (Iran) should have a local IPv6 of `1001:db8:101::1/64`.
   - ServerB (Kharej) should have a local IPv6 of `1001:db8:101::2/64`. 
     - If you have multiple tunnels, avoid using the same IP. For the second tunnel, use different IPs like `2001:db8:101::1/64` and `2001:db8:101::2/64`.

5. After entering the required inputs, the tunnel will be established. Repeat this step on the remote server.
6. Now, if you want to route incoming traffic, for example, from `localserver (Iran):2210` to `remoteserver (v2ray):2210`, follow these steps:
   - In the script menu, select option `1` to create a new Socat service.
   - Enter the service name, local server port (`2210`), local IPv6 of the remote server (`1001:db8:101::2/64` in our example), and the port of the v2ray service.
   - Once done, the tunnel will be established, and routing will work accordingly.

### Persian (فارسی)

- ایجاد تونل 6to4 بین سرورهای اوبونتو.
- ایجاد Socat TCP/UDP Forwarder از طریق 6to4 با حداقل استفاده از CPU.
- می‌توانید رابط‌های 6to4 و خدمات Socat را با استفاده از منو مدیریت کنید.

### نحوه استفاده:

1. اسکریپت `g6.sh` را به سرور خود منتقل کنید.
2. `bash g6.sh` را اجرا کنید.
3. در منو عدد `4` را فشار دهید.
4. نام سرویس خود، آدرس آی‌پی عمومی سرور، آدرس آی‌پی عمومی سرور راه دور و یک آدرس IPv6 محلی وارد کنید. به عنوان مثال:
   - برای ServerA (ایران) باید یک IPv6 محلی به شکل `1001:db8:101::1/64` داشته باشد.
   - برای ServerB (خارج) باید یک IPv6 محلی به شکل `1001:db8:101::2/64` داشته باشد.
     - در صورت داشتن تونل‌های چندگانه، از استفاده از همان آی‌پی‌ها پرهیز کنید. برای تونل دوم، آی‌پی‌های متفاوتی مانند `2001:db8:101::1/64` و `2001:db8:101::2/64` استفاده کنید.

5. پس از وارد کردن ورودی‌های مورد نیاز، تونل ایجاد خواهد شد. این مرحله را روی سرور راه دور نیز تکرار کنید.
6. حالا، اگر می‌خواهید ترافیک ورودی را هدایت کنید، به عنوان مثال از `localserver (ایران):2210` به `remoteserver (v2ray):2210`، مراحل زیر را دنبال کنید:
   - در منوی اسکریپت، گزینه `1` را انتخاب کنید تا یک سرویس جدید Socat ایجاد کنید.
   - نام سرویس، پورت سرور محلی (`2210`)، IPv6 محلی سرور راه دور (`1001:db8:101::2/64` در مثال ما) و پورت سرویس v2ray را وارد کنید.
   - پس از انجام این مراحل، تونل ایجاد خواهد شد و مسیریابی به درستی کار خواهد کرد.
