



String nameCapitalization(String name){
  if(name=='') {
    return '';
  }else {
    name = name.replaceRange(0, 1, name[0].toUpperCase());
  return name;
}
}