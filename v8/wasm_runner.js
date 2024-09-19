const source= readbuffer(arguments[0]);
// If u want to print the source convert it to Uint8Array
//const source = new Uint8Array([0,97,115,109,1,0,0,0,1,5,1,96,0,1,126,3,2,1,0,7,5,1,1,102,0,0,10,9,1,7,0,66,0,66,1,125,11,0,11,4,110,97,109,101,1,4,1,0,1,102]);
const mod = new WebAssembly.Module(source);
const instance = new WebAssembly.Instance(mod, { /* imports */ });
//var x= instance.exports.f();
//console.log(x);
