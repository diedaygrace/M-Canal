#include<Trade\Trade.mqh>
CTrade trade;



//--------------------------FUN CANAL-------------------------------------------------
int canaisGuardados = 0, canal = 0;
double bufferCanal1 = 0, bufferCanal2 = 0,  razao = 0;
datetime tempoGuardado = 0;
//----------------------------------------------------------------------------------------------
int zigzag1=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",8,5,3);
int zigzag2=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",19,5,3);
int zigzag3=iCustom(NULL, PERIOD_CURRENT, "Examples\\ZigZag",36,6,12);
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
      long simbolo = StringToInteger(_Symbol);
      
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
      double buffez1[];
      ArraySetAsSeries(buffez1,true);
      CopyBuffer(zigzag1,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez1);
      double buffez2[];
      ArraySetAsSeries(buffez2,true);
      CopyBuffer(zigzag2,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez2);
      double buffez3[];
      ArraySetAsSeries(buffez3,true);
      CopyBuffer(zigzag3,0,0,Bars(Symbol(),PERIOD_CURRENT),buffez3);
      
      FunCanal(simbolo, lows, highs, closes, opens, datas, buffez1);
      FunCanal(simbolo, lows, highs, closes, opens, datas, buffez2);
      FunCanal(simbolo, lows, highs, closes, opens, datas, buffez3);
      
   }
   
int FunCanal(long simbolo, double &lows[], double &highs[], double &closes[], double &opens[], datetime &datas[], double &buffez[])
   {
      int candles1a3 = 2, candles2a4 = 2, candles3a5 = 2, candles4a6 = 2, posPonto1 = 0, posPonto2 = 0, posPonto3 = 0, posPonto4 = 0, posPonto5 = 0, posPonto6 = 0, ponto = 0;
      double valPonto1=0, valPonto2=0, valPonto3=0, valPonto4=0, valPonto5=0, valPonto6=0;
      
      int posTop1 = 0, posTop3 = 0, posTop5 = 0, posFun2 = 0, posFun4 = 0, posFun6 = 0, candlesAux;
      double mediaTop1 = 0, mediaTop3 = 0, mediaTop5 = 0, base1 = 0, base2 = 0, base3 = 0, base4 = 0, base5 = 0, base6 = 0, top1[3], top3[3], top5[3], veriMenu, veriBase, veriExtre, valAux;
      
      double precoAncoraTop1 = 0, precoAncoraTop3 = 0, precoAncoraFun2 = 0, precoAncoraFun4 = 0;
      datetime  tempoAncoraFun2 = 0, tempoAncoraFun4, tempoAncoraTop1, tempoAncoraTop3;
      
      int i=0, j=0;
      for(i=0; i<ArraySize(buffez); i++){
         if(buffez[i]!= 0 && i>3){
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
               //Print("Ponto: ", ponto,": ", candles1a3);
            }
            if(ponto == 2 || ponto == 3){
               //Print("Ponto: ", ponto,": ", candles2a4);
               candles2a4++;
            }
            if(ponto == 3 || ponto == 4){
               candles3a5++;
            }
            if(ponto == 4 || ponto == 5){
                  candles4a6++;
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
         
         if(closes[posPonto2] < opens[posPonto2]){
            base2 = closes[posPonto2];
            //mediaFun2 = ((closes[posPonto2]-lows[posPonto2])/2)+lows[posPonto2];
         }else{
            base2 = opens[posPonto2];
            //mediaFun2 = ((opens[posPonto2]-lows[posPonto2])/2)+lows[posPonto2];
         }
         if(closes[posPonto4] < opens[posPonto4]){
            base4 = closes[posPonto4];
            //mediaFun4 = ((closes[posPonto4]-lows[posPonto4])/2)+lows[posPonto4];
         }else{
            base4 = opens[posPonto4];
            //mediaFun4 = ((opens[posPonto4]-lows[posPonto4])/2)+lows[posPonto4];
         }
         if(closes[posPonto6] < opens[posPonto6]){
            base6 = closes[posPonto6];
            //mediaFun6 = ((closes[posPonto6]-lows[posPonto6])/2)+lows[posPonto6];
         }else{
            base6 = opens[posPonto6];
            //mediaFun6 = ((opens[posPonto6]-lows[posPonto6])/2)+lows[posPonto6];
         }
         posTop1 = posPonto1;
         posTop3 = posPonto3;
         posTop5 = posPonto5;
         posFun2 = posPonto2;
         posFun4 = posPonto4;
         posFun6 = posPonto6;
      }else{
         if(closes[posPonto2] > opens[posPonto2]){
            base1 = closes[posPonto2];
            mediaTop1 = ((highs[posPonto2]-closes[posPonto2])/2)+closes[posPonto2];
         }else{
            base1 = opens[posPonto2];
            mediaTop1 = ((highs[posPonto2]-opens[posPonto2])/2)+opens[posPonto2];
         }
         if(closes[posPonto4] > opens[posPonto4]){
            base3 = closes[posPonto4];
            mediaTop3 = ((highs[posPonto4]-closes[posPonto4])/2)+closes[posPonto4];
         }else{
            base3 = opens[posPonto4];
            mediaTop3 = ((highs[posPonto4]-opens[posPonto4])/2)+opens[posPonto4];
         }
         if(closes[posPonto6] > opens[posPonto6]){
            base5 = closes[posPonto6];
            mediaTop5 = ((highs[posPonto6]-closes[posPonto6])/2)+closes[posPonto6];
         }else{
            base5 = opens[posPonto6];
            mediaTop5 = ((highs[posPonto6]-opens[posPonto6])/2)+opens[posPonto6];
         }
         
          if(closes[posPonto1] < opens[posPonto1]){
            base2 = closes[posPonto1];
            //mediaFun2 = ((closes[posPonto1]-lows[posPonto1])/2)+lows[posPonto1];
         }else{
            base2 = opens[posPonto1];
            //mediaFun2 = ((opens[posPonto1]-lows[posPonto1])/2)+lows[posPonto1];
         }
         if(closes[posPonto3] < opens[posPonto3]){
            base4 = closes[posPonto3];
            //mediaFun4 = ((closes[posPonto3]-lows[posPonto3])/2)+lows[posPonto3];
         }else{
            base4 = opens[posPonto3];
            //mediaFun4 = ((opens[posPonto3]-lows[posPonto3])/2)+lows[posPonto3];
         }
         if(closes[posPonto5] < opens[posPonto5]){
            base6 = closes[posPonto5];
            //mediaFun6 = ((closes[posPonto5]-lows[posPonto5])/2)+lows[posPonto5];
         }else{
            base6 = opens[posPonto5];
            //mediaFun6 = ((opens[posPonto5]-lows[posPonto5])/2)+lows[posPonto5];
         }
         posTop1 = posPonto2;
         posTop3 = posPonto4;
         posTop5 = posPonto6;
         posFun2 = posPonto1;
         posFun4 = posPonto3;
         posFun6 = posPonto5;
         candlesAux = candles1a3;
         candles1a3 = candles2a4;
         candles2a4 = candlesAux;
         candlesAux = candles3a5;
         candles3a5 = candles4a6;
         candles4a6 = candlesAux;
         valAux = valPonto1;
         valPonto1 = valPonto2;
         valPonto2 = valAux;
         valAux = valPonto3;
         valPonto3 = valPonto4;
         valPonto4 = valAux;
      }
      top1[0] = mediaTop1;
      top1[1] = base1;
      top1[2] = highs[posTop1];
      top3[0] = mediaTop3;
      top3[1] = base3;
      top3[2] = highs[posTop3];
      top5[0] = mediaTop5;
      top5[1] = base5;
      top5[2] = highs[posTop5];
      tempoAncoraFun2 = datas[posFun2];
      tempoAncoraFun4 = datas[posFun4];
      tempoAncoraTop1 = datas[posTop1];
      tempoAncoraTop3 = datas[posTop3];
      
      
      for(i=0; i<3; i++){
         if(canal > canaisGuardados){
               break;
            }
         for(j=0; j<3; j++){
            razao = (top1[i]-top3[j])/(candles1a3-1);
            if(razao<0){
               veriMenu = razao * -candles2a4;
            }else{
               veriMenu = razao * candles2a4;
            }
            if(base2>base4){
               veriBase = base2 - base4;
            }else{
               veriBase = base4 - base2;
            }
            if(lows[posFun2] > lows[posFun4]){
               veriExtre = lows[posFun2] - lows[posFun4];
            }else{
               veriExtre = lows[posFun4] - lows[posFun2];
            }
            
            if((veriBase>=veriMenu && veriMenu>= veriExtre) &&  tempoAncoraFun2 != tempoGuardado && ((razao>=0 && base2>=base4) || (razao<0 && base2<base4))){
               Print("(candles1a3-1) = ", (candles1a3-1));
               Print("candles2a4 = ", candles2a4);
               //Print("(top1[i]-top3[j]) = ", (top3[j]-top1[i]));
               Print("top3[j] = ", top3[j]);
               Print("top1[i] = ", top1[i]);
               Print("razao: ", razao);
               //Print("\n");
               //Print("veriMenu = razao * -+candles2a4:  ", veriMenu);
               //Print("veriBase = base2 -+ base4:  ", veriBase);
               //Print("veriExtre = lows[posFun2] -+ lows[posFun4]: ", veriExtre);
               canal++;
               precoAncoraTop1 = top1[i];
               precoAncoraTop3 = top3[j];
               break;
            }
         }
      }
      Print("razao fora do loop:  ", razao);
      if(canal > canaisGuardados){
         Print("razao no primeiro if:  ", razao);
         if((base2-lows[posFun2]) < (base4-lows[posFun4])){
            //pontoInicioFunRazao = base2;
            Print("razao no segundo if:  ", razao);
            precoAncoraFun2 = base2;
            precoAncoraFun4 = (candles2a4 * (razao - (2 * razao))+base2);
            bufferCanal2 = (posFun2 * razao) + base2;
            Print("depois das contas:  ", razao);
            Print("precoAncoraFun2 = base2;:  ", base2);
            
            Print("(candles2a4 * -razao):  ", (candles2a4 * -razao));
            Print("precoAncoraFun4 = (candles2a4 * -razao)+base2:  ", (candles2a4 * -razao)+base2);
         }else{
            //pontoInicioFunRazao = base4;
            bufferCanal2 = (posFun4 * razao) + base4;
            precoAncoraFun4 = base4;
            precoAncoraFun2 = (candles2a4 * razao) + base4;
            Print("precoAncoraFun4 = base4:  ", base4);
            Print("razao dentro do else:  ", razao);
            Print("candles2a4 * razao:  ", (candles2a4 * razao));
            Print("precoAncoraFun2 = candles2a4 * razao) + base4:  ", (candles2a4 * razao) + base4);
         }
         
         bufferCanal1 = (posTop1*razao)+precoAncoraTop1;
         canaisGuardados = canal;
         tempoGuardado = tempoAncoraFun2;
         FunMostrarCanal(simbolo, canal, tempoAncoraFun2, precoAncoraFun2, tempoAncoraFun4, precoAncoraFun4, tempoAncoraTop1, precoAncoraTop1, tempoAncoraTop3, precoAncoraTop3);
         return 1;
      }
      
      
      //[...]
      //[...]
      return 0;
   }
   int FunMostrarCanal(long simbolo, int canais, datetime tempo2, double preco2, datetime tempo4, double preco4, datetime tempo1, double preco1, datetime tempo3, double preco3){
      datetime extra = 5250;
      
      if(!ObjectCreate(simbolo, IntegerToString(canais)+" Parte Inferior "+TimeToString(tempo2,TIME_DATE), OBJ_TREND, 0, tempo2, preco2, tempo4, preco4)){
         return 0;
      }
      if(!ObjectCreate(simbolo, IntegerToString(canais)+" Parte Superior "+TimeToString(tempo2,TIME_DATE), OBJ_TREND, 0, tempo1, preco1, tempo3, preco3)){
         return 0;
      }
      ObjectSetInteger(simbolo, IntegerToString(canais)+" Parte Inferior "+TimeToString(tempo2,TIME_DATE),OBJPROP_COLOR,clrBlue);
      ObjectSetInteger(simbolo, IntegerToString(canais)+" Parte Inferior "+TimeToString(tempo2,TIME_DATE),OBJPROP_WIDTH,2);
      
      ObjectSetInteger(simbolo, IntegerToString(canais)+" Parte Superior "+TimeToString(tempo2,TIME_DATE),OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(simbolo, IntegerToString(canais)+" Parte Superior "+TimeToString(tempo2,TIME_DATE),OBJPROP_WIDTH,2);
      
      //Print("tempo: ", tempo2);
      
      //Print("tempods: ", tempo2+tempods);
      return 1;
   }