const gui = require('./build/Debug/gui');

const { app, BrowserWindow } = require('electron');

app.whenReady().then(() => {
  const win = new BrowserWindow({
    width: 233,
  });

  const nativeHandle = win.getNativeWindowHandle();

  win.on('resize', () => {
    console.log(gui.getSize(nativeHandle));
  });
  console.log(gui.getSize(nativeHandle));
});
