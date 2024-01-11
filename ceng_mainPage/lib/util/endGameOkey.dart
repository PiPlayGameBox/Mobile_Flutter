
class Tile{
  Tile(String tile){
    color=tile[0];
    number=int.parse(tile.split("_")[0].substring(1));
  }

  @override
  bool operator == (Object other){
    if(other is Tile){
      return color==other.color && number==other.number;
    }
    return false;
  }

  @override
  toString(){
    return "$color$number";
  }

  late String color;
  late int number;
}

bool checkConsecutive(List<Tile> token, Tile okey){
  int firstNonOkey=-1, pivotNum=-1, i;
  String pivotCol="";
  bool retVal;

  for(i=0; i<token.length; ++i){
    if(token[i]!=okey){
      firstNonOkey=i;
      pivotNum=token[i].number;
      pivotCol=token[i].color;
      break;
    }
  }

  retVal=true;
  for(i=0; i<token.length; ++i){
    if(token[i]!=okey){
      if(token[i].number!=pivotNum+(i-firstNonOkey) || token[i].color!=pivotCol){
        retVal=false;
        break;
      }
    }
  }
  if(retVal){
    return true;
  }

  retVal=true;
  for(i=0; i<token.length; ++i){
    if(token[i]!=okey){
      if(token[i].number!=pivotNum-(i-firstNonOkey) || token[i].color!=pivotCol){
        retVal=false;
        break;
      }
    }
  }
  if(retVal){
    return true;
  }

  return false;
}

bool checkColor(List<Tile> token, Tile okey){
  Set<String> distClr={};
  int firstNonOkey=-1;

  for(int i=0; i<token.length; ++i){
    if(token[i]!=okey){
      firstNonOkey=i;
      break;
    }
  }

  for(Tile tile in token){
    if(tile!=okey){
      if(distClr.contains(tile.color)){
        return false;
      }
      else{
        distClr.add(tile.color);
      }

      if(tile.number!=token[firstNonOkey].number){
        return false;
      }
    }
  }

  return true;
}

bool checkToken(List<Tile> token, Tile okey){

  Set<String> distClr= {};
  int okeyCnt=0;

  for(Tile tile in token){
    if(tile==okey){
      okeyCnt++;
    }else{
      distClr.add(tile.color);
    }
  }

  if(token.length>=3 && distClr.length==1 && checkConsecutive(token, okey)){
    return true;
  }

  if(((token.length==3 && distClr.length+okeyCnt==3) || (token.length==4 && distClr.length+okeyCnt==4)) && checkColor(token, okey)){
    return true;
  }

  return false;
}

int checkRow(List<String> row, String okey){
  List<Tile> token=[];
  int tilesInAllPers=0;

  for(String elm in row){
    if(elm!="E"){
      token.add(Tile(elm));
    }
    else{
      if(token.isNotEmpty && checkToken(token, Tile(okey))){
        tilesInAllPers+=token.length;
      }
      token.clear();
    }
  }

  if(token.isNotEmpty && checkToken(token, Tile(okey))){
    tilesInAllPers+=token.length;
  }

  return tilesInAllPers;
}

// Returns the total number of tiles in all valid pers in the given board.
int numTilesInAllPers(List<String> row1, List<String> row2, String okey){
  return checkRow(row1, okey)+checkRow(row2, okey);
}
