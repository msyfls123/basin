const gui = require('./build/Debug/gui');

const { app, BrowserWindow } = require('electron');

app.whenReady().then(() => {
  const win = new BrowserWindow({
    width: 233,
    show: false
  });

  win.loadURL(`file://${__dirname}/index.html`);

  const nativeHandle = win.getNativeWindowHandle();

  console.log(gui.createNative(nativeHandle));
  console.log(gui.getSize(nativeHandle));
});
