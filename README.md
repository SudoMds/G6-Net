# 6to4 Manger / SocatTCP-UDP-Forwader
- create 6to4 tunnel between ubuntu servers
- create socat TCP/UDP forwarder through 6to4 with minimum cpu usage
- you can manage 6to4 interfaces and socat services by menu
# How to use
1.Transfer the g6.sh in your server
2.bash g6.sh
3.in menu press 4
4.enter your service name ,server public ipv4 ,remote server public ipv4 , a local ipv6 address example (1001:db8:101::1/64)
# note : for example we configuring ServerA(iran) and ServerB(kharej) Server A local ipv6 must be 1001:db8:101::1/64 and ServerB must be 1001:db8:101::2/64 and if you have multiplie tunnels dont use same ip change it like this for second tunnel (2001:db8:101::1/64 & 2001:db8:101::2/64)
5.after you enter the needed inputs tunnel will be established you should do it on the remote server too.
# now we want to route incoming trrafic for example from port localserver(iran):2210 to remoteserver(v2ray):2210
6.in script menu push select option 1.Create a new socat service and enter service name,local server port(2210),local ipv6 of remote server(1001:db8:101::2/64 ) in our example,port of v2ray service
done tunnel established and routing works like BENZ :)

# Persian
# 6to4 Manger / SocatTCP-UDP-Forwarder
- ایجاد تونل 6to4 بین سرورهای اوبونتو
- ایجاد Socat TCP/UDP Forwarder از طریق 6to4 با حداقل استفاده از cpu
- می توانید رابط های 6to4 و خدمات socat را با منو مدیریت کنید
# نحوه استفاده
1. g6.sh را در سرور خود انتقال دهید
2.bash g6.sh
3. در منو 4 را فشار دهید
4. نام سرویس خود، سرور ipv4 عمومی، سرور راه دور ipv4 عمومی، نمونه آدرس ipv6 محلی (1001:db8:101::1/64) را وارد کنید.
# نکته : برای مثال ما ServerA(iran) و ServerB(kharej) را پیکربندی می کنیم یک ipv6 محلی باید 1001:db8:101::1/64 و ServerB باید 1001:db8:101::2/64 باشد و اگر دارید تونل های ضربی از همان ip استفاده نمی کنند آن را برای تونل دوم به این شکل تغییر دهید (2001:db8:101::1/64 و 2001:db8:101::2/64)
5. پس از وارد کردن ورودی های مورد نیاز، تونل ایجاد می شود، باید این کار را روی سرور راه دور نیز انجام دهید.
# اکنون می خواهیم ترافیک ورودی را برای مثال از port localserver(iran):2210 به remoteserver(v2ray):2210 هدایت کنیم.
6. در منوی اسکریپت، گزینه 1 را انتخاب کنید. یک سرویس سوکت جدید ایجاد کنید و نام سرویس، پورت سرور محلی (2210)، ipv6 محلی سرور راه دور (1001:db8:101::2/64) را در مثال ما وارد کنید، پورت سرویس v2ray
ایجاد تونل انجام شده و مسیریابی مانند BENZ کار می کند :)
