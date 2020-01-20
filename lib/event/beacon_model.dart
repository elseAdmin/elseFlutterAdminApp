class BeaconData {
  int major;
  int minor;
  BeaconData(int major,int minor){
    this.major=major;
    this.minor=minor;
  }

  toJson(){
    return{
      'major':this.major,
      'minor':this.minor
    };
  }
}