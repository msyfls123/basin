const { Defer } = require('./build/Debug/defer.node')
const p = new Defer('子曾经曰过');

p.run(2000).then((data) => console.log('from native', data));

setTimeout(process.exit, 2050);
