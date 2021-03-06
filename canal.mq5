#include<Trade\Trade.mqh>
CTrade trade;


int zigzag=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",12,6,12);
void OnTick()
   {
      double highs[];            // DECLARAÇÃO DE VARIAVEIS E LISTAS DE INFORMAÇÃO DE PREÇOS \\       [C]
      double lows[];
      double closes[];
      double opens[];
      datetime datas[];
      double Ask;
      double Bid;
      double Balance;
      int Periodo = 12;     // PERIODO PARA DETERMINAR A ONDA\\
      
      ArraySetAsSeries(highs,true);                      // COPIANDO PREÇOS \\         [C]
      CopyHigh(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),highs);
      ArraySetAsSeries(lows,true);
      CopyLow(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),lows);
      ArraySetAsSeries(closes,true);
      CopyClose(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),closes);
      ArraySetAsSeries(opens,true);
      CopyOpen(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),opens);
      ArraySetAsSeries(datas,true);
      CopyTime(_Symbol,_Period,0,Bars(_Symbol,PERIOD_CURRENT),datas);      
      Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
      Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
      Balance = AccountInfoDouble(ACCOUNT_BALANCE);
     
      //indicador zigzag\\
      double buffez[];
      ArraySetAsSeries(buffez,true);
      CopyBuffer(zigzag,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez);
      
      
      
   }
   
int FunCanal(double &lows[], double &highs[], double &closes[], double &opens[], datetime &datas[], double &buffez[])
   {
      int candles1a3 = 2, candles2a4 = 2, candles3a5 = 2, candles4a6 = 2, posPonto1 = 0, posPonto2 = 0, posPonto3 = 0, posPonto4 = 0, posPonto5 = 0, posPonto6 = 0, ponto = 0;
      double valPonto1=0, valPonto2=0, valPonto3=0, valPonto4=0, valPonto5=0, valPonto6=0;
      
      int posTop1 = 0, posTop3 = 0, posTop5 = 0, posFun2 = 0, posFun4 = 0, posFun6 = 0, posAux;
      double mediaTop1 = 0, mediaTop3 = 0, mediaTop5 = 0, base1 = 0, base2 = 0, base3 = 0, base4 = 0, base5 = 0, base6 = 0;
      
      
      
      int i=0, j=0;
      for(i=0; i<ArraySize(buffez); i++){
         if(buffez[i]!= 0 && i!=0){
            ponto++;
            if(ponto==1){
               posPonto1 = i;
               valPonto1 = buffez[i];
            }else{
               if(ponto==2){
                  posPonto2 = i;
                  valPonto2 = buffez[i];
               }else{
                  if(ponto==3){
                     posPonto3 = i;
                     valPonto3 = buffez[i];
                  }else{
                     if(ponto==4){
                        posPonto4 = i;
                        valPonto4 = buffez[i];
                     }else{
                        if(ponto==5){
                           posPonto5 = i;
                        }else{
                           posPonto6 = i;
                           break;
                        }
                     }
                  }
               }
            }
         }else{
            if(ponto == 1 || ponto == 2){
               candles1a3++;
            }else{
               if(ponto == 2 || ponto == 3){
                  candles2a4++;
               }else{
                  if(ponto == 3 || ponto == 4){
                     candles3a5++;
                  }else{
                     if(ponto == 4 || ponto == 5){
                        candles4a6++;
                     }else{
                        continue;
                     }
                  }
               }
            }
         }
      }
      
      if(valPonto1>valPonto2 && valPonto3>valPonto4){
         if(closes[posPonto1] > opens[posPonto1]){
            base1 = closes[posPonto1];
            mediaTop1 = ((highs[posPonto1]-closes[posPonto1])/2)+closes[posPonto1];
         }else{
            base1 = opens[posPonto1];
            mediaTop1 = ((highs[posPonto1]-opens[posPonto1])/2)+opens[posPonto1];
         }
         if(closes[posPonto3] > opens[posPonto3]){
            base3 = closes[posPonto3];
            mediaTop3 = ((highs[posPonto3]-closes[posPonto3])/2)+closes[posPonto3];
         }else{
            base3 = opens[posPonto3];
            mediaTop3 = ((highs[posPonto3]-opens[posPonto3])/2)+opens[posPonto3];
         }
         if(closes[posPonto5] > opens[posPonto5]){
            base5 = closes[posPonto5];
            mediaTop5 = ((highs[posPonto5]-closes[posPonto5])/2)+closes[posPonto5];
         }else{
            base5 = opens[posPonto5];
            mediaTop5 = ((highs[posPonto5]-opens[posPonto5])/2)+opens[posPonto5];
         }
         
         if(closes[posPonto2] > opens[posPonto2]){
            base2 = closes[posPonto2];
            //mediaFun2 = ((closes[posPonto2]-lows[posPonto2])/2)+lows[posPonto2];
         }else{
            base2 = opens[posPonto2];
            //mediaFun2 = ((opens[posPonto2]-lows[posPonto2])/2)+lows[posPonto2];
         }
         // [...]
         
         
         posTop1 = posPonto1;
         posTop3 = posPonto3;
         posTop5 = posPonto5;
         posFun2 = posPonto2;
         posFun4 = posPonto4;
         posFun6 = posPonto6;
      }else{
         
      }
      
      return 0;
   }