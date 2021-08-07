use CPtr;

proc syncRWTCallback(arg: c_void_ptr) {
  var syncVariablePtr = arg: c_ptr(sync int);
  syncVariablePtr.deref().writeEF(5);
  writeln("i did my job");
}

proc main() {
  var mutex$: sync int = 0;
  mutex$.readFE();
  begin syncRWTCallback(c_ptrTo(mutex$):c_void_ptr);
  writeln("ready");
  writeln(mutex$.readFE());
}
