const gui = require('../build/Debug/gui');

const { app, BrowserWindow } = require('electron');

app.whenReady().then(() => {
  const win = new BrowserWindow({
    width: 500,
    height: 500,
    show: false
  });

  win.loadURL(`file://${__dirname}/index.html`);
  win.webContents.openDevTools({ mode: 'detach' });

  const nativeHandle = win.getNativeWindowHandle();

  console.log(gui.createNative(nativeHandle));
  console.log(gui.getSize(nativeHandle));
});
