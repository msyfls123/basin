const { Defer } = require('./build/Debug/defer.node')
const p = new Defer('子曾经曰过');
p.run(2000);

setTimeout(process.exit, 2000);
