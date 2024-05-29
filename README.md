Hi there 👋

I decided to write  script which will allow you to use self-signed certificates without HTTPS errors in browser.

### How to use it?
Run this commands on your host machine (NOT router):
```
nano script.sh
```
Paste code from script.sh file and save it.

```
scp -O -r script.sh root@192.168.8.1:/tmp
```
Enter password

```
ssh root@192.168.8.1
```

Enter password again

```
cd /tmp
```
```
./script.sh
```

### Important information:
- You must execute this script on client device, **not** directly on router
- You should **not** use windows for this script as in my testing it failed
- It can be run on Termux, but it is strongly recommended to use it in native Linux
- If you don’t know what to do with generated files, answer “y” to additional information prompt

> **Copyright**
> I allow copying/modifying of this script. I also allow to include it to any guides/manuals/tutorials. But please, don’t forget to post link to this thread.

### 🇺🇦 Author stands with Ukraine 🇺🇦
If you want to thank me, please [donate to Ukrainian army](https://war.ukraine.ua)
