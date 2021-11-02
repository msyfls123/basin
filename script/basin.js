const addon = require('../build/Debug/basin');

const { func } = addon;
console.log(func());
console.log(func[0]);
console.log(func.test);
console.log((new func).hhh());
